-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                           GMastEditor                             --
--          Graphical Editor for Modelling and Analysis              --
--                    of Real-Time Applications                      --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors : Pilar del Rio                                           --
--           Michael Gonzalez                                        --
--           Felisa Hidalgo                                          --
--                                                                   --
-- Contact info: Michael Gonzalez       mgh@unican.es                --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------
with Ada.Tags;                use Ada.Tags;
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Characters.Handling;

with Callbacks_Mast_Editor; use Callbacks_Mast_Editor;
with Cairo;                   use Cairo;
with Gdk.RGBA;      use Gdk.RGBA;
with Pango.Font;     use Pango.Font;
with Pango.Layout;   use Pango.Layout;
with Pango.Cairo; use Pango.Cairo;
with Pango.Enums; use Pango.Enums;
with Cairo;          use Cairo;
with Cairo.Region; use Cairo.Region;
with Gdk.Cairo; use Gdk.Cairo;
with Utilities; use Utilities;
with Mast_Editor_Window_Pkg;   use Mast_Editor_Window_Pkg;

with Gtk.Combo_Box_Text;    use Gtk.Combo_Box_Text;
with Gtk.Enums;             use Gtk.Enums;
with Gtk.Handlers;          use Gtk.Handlers;
with Gtk.GEntry;            use Gtk.GEntry;
with Gtk.Label;             use Gtk.Label;
with Gtk.Table;             use Gtk.Table;
with Pango.Font;            use Pango.Font;
with Gtkada.Dialogs;        use Gtkada.Dialogs;

with List_Exceptions;                     use List_Exceptions;
with Mast;                                use Mast;
with Mast.IO;                             use Mast.IO;
with Mast.Processing_Resources;           use Mast.Processing_Resources;
with Mast.Processing_Resources.Network;
use Mast.Processing_Resources.Network;
with Mast.Processing_Resources.Processor;
use Mast.Processing_Resources.Processor;
with Mast.Schedulers;                     use Mast.Schedulers;
with Mast.Schedulers.Primary;             use Mast.Schedulers.Primary;
with Mast.Schedulers.Secondary;           use Mast.Schedulers.Secondary;
with Mast.Scheduling_Policies;            use Mast.Scheduling_Policies;
with Mast.Scheduling_Servers;             use Mast.Scheduling_Servers;
with Mast_Editor.Processing_Resources;    use Mast_Editor.Processing_Resources;
with Mast_Editor.Scheduling_Servers;      use Mast_Editor.Scheduling_Servers;
with Prime_Sched_Dialog_Pkg;              use Prime_Sched_Dialog_Pkg;
with Second_Sched_Dialog_Pkg;             use Second_Sched_Dialog_Pkg;
with Editor_Error_Window_Pkg;             use Editor_Error_Window_Pkg;
with Item_Menu_Pkg;                       use Item_Menu_Pkg;
with Editor_Actions;                      use Editor_Actions;
with Change_Control;
with Cut_Strings;                         use Cut_Strings;
with Ada.Characters.Latin_1;
with Ada.Strings.Unbounded;               use Ada.Strings.Unbounded;

package body Mast_Editor.Schedulers is

   package Button_Cb is new Gtk.Handlers.User_Callback
     (Widget_Type => Gtk_Widget_Record,
      User_Type => ME_Scheduler_Ref);

   Zoom_Levels : constant array (Positive range <>) of Guint  :=
     (100,
      130,
      150);
   Font        : Pango_Font_Description;
   Font1       : Pango_Font_Description;
   Font_Size   : Gint;
   
   NL : String:=""&Ada.Characters.Latin_1.CR &
     Ada.Characters.Latin_1.LF;

   --------------
   -- Name     --
   --------------
   function Name (Item : in ME_Scheduler) return Var_String is
   begin
      return Name (Item.Sche);
   end Name;

   --------------
   -- Name     --
   --------------
   function Name (Item_Ref : in ME_Scheduler_Ref) return Var_String is
   begin
      return Name (Item_Ref.Sche);
   end Name;

   -----------------
   -- Print       --
   -----------------
   procedure Print
     (File        : Ada.Text_IO.File_Type;
      Item        : in out ME_Scheduler;
      Indentation : Positive;
      Finalize    : Boolean := False)
   is
   begin
      Ada.Text_IO.Set_Col (File, Ada.Text_IO.Count (Indentation));
      Ada.Text_IO.Put (File, "ME_Scheduler");
   end Print;

   -----------------
   -- Print       --
   -----------------
   procedure Print
     (File        : Ada.Text_IO.File_Type;
      The_List    : in out Lists.List;
      Indentation : Positive)
   is
      Item_Ref : ME_Scheduler_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind (The_List, Iterator);
      for I in 1 .. Lists.Size (The_List) loop
         Lists.Get_Next_Item (Item_Ref, The_List, Iterator);
         Print (File, Item_Ref.all, Indentation, True);
         Ada.Text_IO.New_Line (File);
      end loop;
   end Print;

   ----------------------
   -- Write Parameters --
   ----------------------
   procedure Write_Parameters
     (Item   : access ME_Primary_Scheduler;
      Dialog : access Gtk_Dialog_Record'Class)
   is
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access     :=
        Prime_Sched_Dialog_Access (Dialog);
      Sched_Ref          : Mast.Schedulers.Scheduler_Ref :=
        ME_Scheduler_Ref (Item).Sche;
      Host_Ref           : Mast.Processing_Resources.Processing_Resource_Ref;
      Host_Name          : Var_String;
      Host_Index         : Mast.Processing_Resources.Lists.Index;
      Policy_Ref         : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
   begin
      Change_Control.Changes_Made;
      Init
        (Sched_Ref.all,
         Var_Strings.To_Lower
           (To_Var_String
              (Get_Text (Prime_Sched_Dialog.Prime_Sched_Name_Entry))));
      if (Get_Active_Text (Prime_Sched_Dialog.Host_Combo) =
            "(NONE)")
      then
         Host_Ref := null;
         Mast.Schedulers.Primary.Set_Host
           (Primary_Scheduler (Sched_Ref.all),
            Host_Ref);
      else
         Host_Name  :=
           To_Var_String
           (Get_Active_Text (Prime_Sched_Dialog.Host_Combo));
         Host_Index :=
           Mast.Processing_Resources.Lists.Find
           (Host_Name,
            The_System.Processing_Resources);
         Host_Ref   :=
           Mast.Processing_Resources.Lists.Item
           (Host_Index,
            The_System.Processing_Resources);
         Mast.Schedulers.Primary.Set_Host
           (Primary_Scheduler (Sched_Ref.all),
            Host_Ref);
      end if;
      Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sched_Ref.all);
      if (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
            "(NONE)")
      then
         Policy_Ref := null;
      elsif (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
               "Fixed Priority")
      then
         Policy_Ref := new Fixed_Priority;
         Set_Max_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Prime_Sched_Dialog.Max_Prior_Entry)));
         Set_Min_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Prime_Sched_Dialog.Min_Prior_Entry)));
         Set_Worst_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Worst_Context_Entry)));
         Set_Best_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Best_Context_Entry)));
         Set_Avg_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Avg_Context_Entry)));
      elsif (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
               "Earliest Deadline First")
      then
         Policy_Ref := new EDF;
         Set_Worst_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Worst_Context_Entry)));
         Set_Best_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Best_Context_Entry)));
         Set_Avg_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Prime_Sched_Dialog.Avg_Context_Entry)));
      elsif (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
               "Fixed Priority Packet Based")
      then
         Policy_Ref := new FP_Packet_Based;
         Set_Max_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Prime_Sched_Dialog.Max_Prior_Entry)));
         Set_Min_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Prime_Sched_Dialog.Min_Prior_Entry)));
         Set_Packet_Overhead_Max_Size
           (FP_Packet_Based (Policy_Ref.all),
            Bit_Count'Value
              (Get_Text (Prime_Sched_Dialog.Packet_Over_Max_Entry)));
         Set_Packet_Overhead_Avg_Size
           (FP_Packet_Based (Policy_Ref.all),
            Bit_Count'Value
              (Get_Text (Prime_Sched_Dialog.Packet_Over_Avg_Entry)));
         Set_Packet_Overhead_Min_Size
           (FP_Packet_Based (Policy_Ref.all),
            Bit_Count'Value
              (Get_Text (Prime_Sched_Dialog.Packet_Over_Min_Entry)));
      end if;
      Mast.Schedulers.Set_Scheduling_Policy (Sched_Ref.all, Policy_Ref);
   exception
      when Invalid_Index =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "ERROR IN HOST ASSIGNMENT");
         Show_All (Editor_Error_Window);
         Destroy (Prime_Sched_Dialog);
   end Write_Parameters;

   ----------------------
   -- Write Parameters --
   ----------------------
   procedure Write_Parameters
     (Item   : access ME_Secondary_Scheduler;
      Dialog : access Gtk_Dialog_Record'Class)
   is
      Second_Sched_Dialog : Second_Sched_Dialog_Access    :=
        Second_Sched_Dialog_Access (Dialog);
      Sched_Ref           : Mast.Schedulers.Scheduler_Ref :=
        ME_Scheduler_Ref (Item).Sche;
      Serv_Ref            : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      Serv_Name           : Var_String;
      Serv_Index          : Mast.Scheduling_Servers.Lists.Index;
      Policy_Ref          : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
   begin
      Change_Control.Changes_Made;
      Init
        (Sched_Ref.all,
         Var_Strings.To_Lower
           (To_Var_String
              (Get_Text (Second_Sched_Dialog.Second_Sched_Name_Entry))));
      if (Get_Active_Text (Second_Sched_Dialog.Server_Combo) =
            "(NONE)")
      then
         Serv_Ref := null;
      else
         Serv_Name  :=
           To_Var_String
           (Get_Active_Text (Second_Sched_Dialog.Server_Combo));
         Serv_Index :=
           Mast.Scheduling_Servers.Lists.Find
           (Serv_Name,
            The_System.Scheduling_Servers);
         Serv_Ref   :=
           Mast.Scheduling_Servers.Lists.Item
           (Serv_Index,
            The_System.Scheduling_Servers);
         Mast.Schedulers.Secondary.Set_Server
           (Secondary_Scheduler (Sched_Ref.all),
            Serv_Ref);
      end if;
      Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sched_Ref.all);
      if (Get_Active_Text (Second_Sched_Dialog.Policy_Type_Combo) =
            "(NONE)")
      then
         Policy_Ref := null;
      elsif (Get_Active_Text (Second_Sched_Dialog.Policy_Type_Combo) =
               "Fixed Priority")
      then
         Policy_Ref := new Fixed_Priority;
         Set_Max_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Second_Sched_Dialog.Max_Prior_Entry)));
         Set_Min_Priority
           (Mast.Scheduling_Policies.Fixed_Priority_Policy (Policy_Ref.all),
            Priority'Value (Get_Text (Second_Sched_Dialog.Min_Prior_Entry)));
         Set_Worst_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Worst_Context_Entry)));
         Set_Best_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Best_Context_Entry)));
         Set_Avg_Context_Switch
           (Fixed_Priority (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Avg_Context_Entry)));
      elsif (Get_Active_Text (Second_Sched_Dialog.Policy_Type_Combo) =
               "Earliest Deadline First")
      then
         Policy_Ref := new EDF;
         Set_Worst_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Worst_Context_Entry)));
         Set_Best_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Best_Context_Entry)));
         Set_Avg_Context_Switch
           (EDF (Policy_Ref.all),
            Normalized_Execution_Time'Value
              (Get_Text (Second_Sched_Dialog.Avg_Context_Entry)));
      end if;
      Mast.Schedulers.Set_Scheduling_Policy (Sched_Ref.all, Policy_Ref);
   exception
      when Invalid_Index =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "ERROR IN HOST ASSIGNMENT");
         Show_All (Editor_Error_Window);
         Destroy (Second_Sched_Dialog);
   end Write_Parameters;

   ---------------------
   -- Read Parameters --
   ---------------------
   procedure Read_Parameters
     (Item   : access ME_Primary_Scheduler;
      Dialog : access Gtk_Dialog_Record'Class)
   is
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access     :=
        Prime_Sched_Dialog_Access (Dialog);
      Sched_Ref          : Mast.Schedulers.Scheduler_Ref :=
        ME_Scheduler_Ref (Item).Sche;
      Sched_Name         : String                        :=
        To_String (Name (Sched_Ref));
      Host_Ref           : Mast.Processing_Resources.Processing_Resource_Ref;
      Policy_Ref         : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
      Through            : Mast.Throughput_Value;
      Speed              : Mast.Processor_Speed;
   begin
      Set_Text (Prime_Sched_Dialog.Prime_Sched_Name_Entry, Sched_Name);
      Host_Ref :=
        Mast.Schedulers.Primary.Host (Primary_Scheduler (Sched_Ref.all));
      if Host_Ref = null then
         Set_Text_In_Combo_Box (Prime_Sched_Dialog.Host_Combo, "(NONE)");
         Through := 0.0;
         Speed   := 1.0;
      else
         Set_Text_In_Combo_Box
           (Prime_Sched_Dialog.Host_Combo,
            To_String (Name (Host_Ref.all)));
         Speed :=
           Speed_Factor
           (Mast.Processing_Resources.Processing_Resource (Host_Ref.all));
         if Host_Ref.all in Mast.Processing_Resources.Network.Network then
            Through :=
              Throughput
              (Mast.Processing_Resources.Network.Network (Host_Ref.all));
         else
            Through := 0.0;
         end if;
      end if;
      Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sched_Ref.all);
      if Policy_Ref = null then
         Set_Text_In_Combo_Box
           (Prime_Sched_Dialog.Policy_Type_Combo,
            "(NONE)");
         Show_All (Prime_Sched_Dialog);
         Hide (Prime_Sched_Dialog.Priority_Table);
         Hide (Prime_Sched_Dialog.Context_Table);
         Hide (Prime_Sched_Dialog.Overhead_Table);
      else
         if Policy_Ref.all in Fixed_Priority then
            Set_Text_In_Combo_Box
              (Prime_Sched_Dialog.Policy_Type_Combo,
               "Fixed Priority");
            Set_Text
              (Prime_Sched_Dialog.Max_Prior_Entry,
               Priority'Image
               (Max_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Min_Prior_Entry,
               Priority'Image
               (Min_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Worst_Context_Entry,
               Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Avg_Context_Entry,
               Execution_Time_Image
               (Avg_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Best_Context_Entry,
               Execution_Time_Image
               (Best_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Show_All (Prime_Sched_Dialog);
            Hide (Prime_Sched_Dialog.Overhead_Table);
         elsif Policy_Ref.all in EDF then
            Set_Text_In_Combo_Box
              (Prime_Sched_Dialog.Policy_Type_Combo,
               "Earliest Deadline First");
            Set_Text
              (Prime_Sched_Dialog.Worst_Context_Entry,
               Execution_Time_Image
                 (Worst_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Avg_Context_Entry,
               Execution_Time_Image
                 (Avg_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Best_Context_Entry,
               Execution_Time_Image
                 (Best_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Show_All (Prime_Sched_Dialog);
            Hide (Prime_Sched_Dialog.Priority_Table);
            Hide (Prime_Sched_Dialog.Overhead_Table);
         elsif Policy_Ref.all in FP_Packet_Based then
            Set_Text_In_Combo_Box
              (Prime_Sched_Dialog.Policy_Type_Combo,
               "Fixed Priority Packet Based");
            Set_Text
              (Prime_Sched_Dialog.Max_Prior_Entry,
               Priority'Image
               (Max_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Min_Prior_Entry,
               Priority'Image
               (Min_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
            Set_Text
              (Prime_Sched_Dialog.Packet_Over_Max_Entry,
               Bit_Count_Image
               (Packet_Overhead_Max_Size
                (Mast.Scheduling_Policies.FP_Packet_Based (Policy_Ref.all),
                 Through)));
            Set_Text
              (Prime_Sched_Dialog.Packet_Over_Avg_Entry,
               Bit_Count_Image
               (Packet_Overhead_Avg_Size
                (Mast.Scheduling_Policies.FP_Packet_Based (Policy_Ref.all),
                 Through)));

            Set_Text
              (Prime_Sched_Dialog.Packet_Over_Min_Entry,
               Bit_Count_Image
               (Packet_Overhead_Min_Size
                (Mast.Scheduling_Policies.FP_Packet_Based (Policy_Ref.all),
                 Through)));
            Show_All (Prime_Sched_Dialog);
            Hide (Prime_Sched_Dialog.Context_Table);
         end if;
      end if;
   end Read_Parameters;

   ---------------------
   -- Read Parameters --
   ---------------------
   procedure Read_Parameters
     (Item   : access ME_Secondary_Scheduler;
      Dialog : access Gtk_Dialog_Record'Class)
   is
      Second_Sched_Dialog : Second_Sched_Dialog_Access    :=
        Second_Sched_Dialog_Access (Dialog);
      Sched_Ref           : Mast.Schedulers.Scheduler_Ref :=
        ME_Scheduler_Ref (Item).Sche;
      Sched_Name          : String                        :=
        To_String (Name (Sched_Ref));
      Serv_Ref            : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      Policy_Ref          : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
   begin
      Set_Text (Second_Sched_Dialog.Second_Sched_Name_Entry, Sched_Name);
      Serv_Ref :=
        Mast.Schedulers.Secondary.Server
        (Secondary_Scheduler (Sched_Ref.all));
      if Serv_Ref = null then
         Set_Text_In_Combo_Box (Second_Sched_Dialog.Server_Combo, "(NONE)");
      else
         Set_Text_In_Combo_Box
           (Second_Sched_Dialog.Server_Combo,
            To_String (Name (Serv_Ref.all)));
      end if;

      Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sched_Ref.all);
      if Policy_Ref = null then
         Set_Text_In_Combo_Box
           (Second_Sched_Dialog.Policy_Type_Combo,
            "(NONE)");
         Show_All (Second_Sched_Dialog);
         Hide (Second_Sched_Dialog.Priority_Table);
         Hide (Second_Sched_Dialog.Context_Table);
      else
         if Policy_Ref.all in Fixed_Priority then
            Set_Text_In_Combo_Box
              (Second_Sched_Dialog.Policy_Type_Combo,
               "Fixed Priority");
            Set_Text
              (Second_Sched_Dialog.Max_Prior_Entry,
               Priority'Image
                 (Max_Priority
                    (Mast.Scheduling_Policies.Fixed_Priority_Policy
                       (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Min_Prior_Entry,
               Priority'Image
                 (Min_Priority
                    (Mast.Scheduling_Policies.Fixed_Priority_Policy
                       (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Worst_Context_Entry,
               Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Avg_Context_Entry,
               Execution_Time_Image
               (Avg_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Best_Context_Entry,
               Execution_Time_Image
               (Best_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority (Policy_Ref.all))));
            Show_All (Second_Sched_Dialog);
         elsif Policy_Ref.all in EDF then
            Set_Text_In_Combo_Box
              (Second_Sched_Dialog.Policy_Type_Combo,
               "Earliest Deadline First");
            Set_Text
              (Second_Sched_Dialog.Worst_Context_Entry,
               Execution_Time_Image
                 (Worst_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Avg_Context_Entry,
               Execution_Time_Image
                 (Avg_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Set_Text
              (Second_Sched_Dialog.Best_Context_Entry,
               Execution_Time_Image
                 (Best_Context_Switch
                    (Mast.Scheduling_Policies.EDF (Policy_Ref.all))));
            Show_All (Second_Sched_Dialog);
            Hide (Second_Sched_Dialog.Priority_Table);
         end if;
      end if;
   end Read_Parameters;

   ----------------------------
   -- Draw Primary Scheduler --
   ----------------------------
   procedure Draw
     (Item         : access ME_Primary_Scheduler;
      Cr   : Cairo_Context)
   is
      Rect      : constant Cairo.Region.Cairo_Rectangle_Int  := 
	Get_Coord (Item);
      W         : constant Gdouble        :=Gdouble(Rect.Width);
      H         : constant Gdouble        :=Gdouble(Rect.Height);
      Color,Black : Gdk_RGBA;
      Layout : Pango.Layout.Pango_Layout;
      Success : Boolean;
      Sche_Ref   : Scheduler_Ref          := Item.Sche;
      Sche_Name  : String                 := To_String (Name (Sche_Ref));

      Host_Ref   : Mast.Processing_Resources.Processing_Resource_Ref;

      Policy_Ref : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
      Line_Height : Gdouble;
      Text : Unbounded_String;

   begin
      Editor_Actions.Load_System_Font (Font, Font1);
      Layout := Mast_Editor_Window.Create_Pango_Layout;
      Set_Font_Description (Layout, Font);
      Font_Size:=Get_Size(Font);

      Parse (Color, To_String (Item.Color_Name),Success);
      Black := (0.0, 0.0, 0.0, 1.0);

      Item.X_Coord := Gint (Get_Coord (Item).X);
      Item.Y_Coord := Gint (Get_Coord (Item).Y);
      
      Gdk.Cairo.Set_Source_RGBA (Cr, Color);
      Cairo.Rectangle
        (Cr, 0.5, 0.5, Gdouble (W) - 1.0, Gdouble (H) - 1.0);
      Cairo.Fill (Cr);

      Gdk.Cairo.Set_Source_RGBA (Cr, Black);
      Rectangle
        (Cr, 0.5, 0.5, Gdouble (W) - 1.0, Gdouble (H) - 1.0);
      Cairo.Stroke(Cr);
      
      Line_Height:=Gdouble(Layout.Get_Baseline/Pango_Scale);
      Move_To(Cr,0.0,Line_Height+5.0);
      Line_To(Cr,W,Line_Height+6.0);
      Cairo.Stroke(Cr);
      
      if Guint(Get_Zoom (Item.Canvas)*100.0) = Zoom_Levels (1) then
	 Set_Size(Font,Font_Size*100/Gint(Zoom_Levels(1)));
	 Set_Size(Font1,Font_Size*100/Gint(Zoom_Levels(1)));
	 Pango.Layout.Set_Width(Layout,Gint(W)*Pango_Scale);
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Center);
	 Pango.Layout.Set_Ellipsize(Layout,Ellipsize_End);
	 
	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "PRIMARY SCHEDULER", "PRIMARY SCHED", 22));
	 Cairo.Move_To (Cr, 0.0, 2.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
	 Text:=To_Unbounded_String("");

         Host_Ref :=
           Mast.Schedulers.Primary.Host
           (Mast.Schedulers.Primary.Primary_Scheduler (Sche_Ref.all));
         if Host_Ref /= null then
	    Text:=Text&"Host: " & 
	      Cut (To_String (Name (Host_Ref.all)), 17)&NL;
         end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref /= null then
            if Policy_Ref.all in Fixed_Priority then
	       Text:=Text&"Policy: Fixed Priority"&NL&
		 "Worst Context: " & Execution_Time_Image
		 (Worst_Context_Switch
		    (Mast.Scheduling_Policies.Fixed_Priority(Policy_Ref.all)))
		 &NL;
	       
	    elsif Policy_Ref.all in EDF then
	       Text:=Text&"Policy: EDF"&NL&
		  "Worst Context: " & Execution_Time_Image
		    (Worst_Context_Switch
		       (Mast.Scheduling_Policies.EDF(Policy_Ref.all)));
	       
	    elsif Policy_Ref.all in FP_Packet_Based then
	       Text:=Text&"Policy: FP packet-based"&NL;
	    end if;
         end if;
	 
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Left);
	 Set_Font_Description (Layout, Font);
	 Set_Text (Layout,To_String(Text));
	 Cairo.Move_To (Cr, 4.0, Line_Height+8.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
	 
      elsif Guint(Get_Zoom (Item.Canvas)*100.0) = Zoom_Levels (2) then
	 Set_Size(Font,Font_Size*100/Gint(Zoom_Levels(2)));
	 Set_Size(Font1,Font_Size*100/Gint(Zoom_Levels(2)));
	 Pango.Layout.Set_Width(Layout,Gint(W)*Pango_Scale);
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Center);
	 Pango.Layout.Set_Ellipsize(Layout,Ellipsize_End);
	 
	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "PRIMARY SCHEDULER", "PRIMARY SCHED", 30));
	 Cairo.Move_To (Cr, 0.0, 2.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
	 Text:=To_Unbounded_String("");
	 
         Host_Ref :=
           Mast.Schedulers.Primary.Host
           (Mast.Schedulers.Primary.Primary_Scheduler (Sche_Ref.all));
         if Host_Ref /= null then
	    Text:=Text&
	       "Host: " & Cut (To_String (Name (Host_Ref.all)), 24)&NL;
	 end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref /= null then
	    if Policy_Ref.all in Fixed_Priority then
	       Text:=Text&"Policy: Fixed Priority"&NL&
		 "Worst Context: " & Execution_Time_Image
		 (Worst_Context_Switch
		    (Mast.Scheduling_Policies.Fixed_Priority(Policy_Ref.all)))
		 &NL;

         elsif Policy_Ref.all in EDF then
	    Text:=Text&
	       "Policy: Earliest Deadline First"&NL&
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.EDF(Policy_Ref.all)))&NL;

         elsif Policy_Ref.all in FP_Packet_Based then
	    Text:=Text&
	       "Policy: FP packet-based"&NL&
	       "Max Prio: " & Priority'Image
               (Max_Priority
                (Mast.Scheduling_Policies.FP_Packet_Based
                 (Policy_Ref.all)))&NL&
	       "Min Prio: " & Priority'Image
               (Min_Priority
                (Mast.Scheduling_Policies.FP_Packet_Based
                 (Policy_Ref.all)))&NL;
	    end if;
	 end if;
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Left);
	 Set_Font_Description (Layout, Font);
	 Set_Text (Layout,To_String(Text));
	 Cairo.Move_To (Cr, 4.0, Line_Height+8.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
      else
	 Set_Size(Font,Font_Size*100/Gint(Zoom_Levels(3)));
	 Set_Size(Font1,Font_Size*100/Gint(Zoom_Levels(3)));
	 Pango.Layout.Set_Width(Layout,Gint(W)*Pango_Scale);
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Center);
	 Pango.Layout.Set_Ellipsize(Layout,Ellipsize_End);
	 
	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "PRIMARY SCHEDULER", "PRIMARY SCHED", 35));
	 Cairo.Move_To (Cr, 0.0, 2.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
	 Text:=To_Unbounded_String("");
	 
         Host_Ref :=
           Mast.Schedulers.Primary.Host
           (Mast.Schedulers.Primary.Primary_Scheduler (Sche_Ref.all));
         if Host_Ref /= null then
	    Text:=Text&
	       "Host: " & Cut (To_String (Name (Host_Ref.all)), 29)&NL;
         end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref /= null then
	    if Policy_Ref.all in Fixed_Priority then
	       Text:=Text&
		  "Policy: Fixed Priority"&NL&
		  "Worst Context: " & Execution_Time_Image
		    (Worst_Context_Switch
		       (Mast.Scheduling_Policies.Fixed_Priority
			  (Policy_Ref.all)))&NL&
		  "Max Prio: " & Priority'Image
		    (Max_Priority
		       (Mast.Scheduling_Policies.Fixed_Priority_Policy
			  (Policy_Ref.all)))&NL&
		  "Min Prio: " & Priority'Image
		    (Min_Priority
		       (Mast.Scheduling_Policies.Fixed_Priority_Policy
			  (Policy_Ref.all)));
	       
	    elsif Policy_Ref.all in EDF then
	       Text:=Text&
	       "Policy: Earliest Deadline First"&NL&
		  "Worst Context: " & Execution_Time_Image
		    (Worst_Context_Switch
		       (Mast.Scheduling_Policies.EDF(Policy_Ref.all)))&NL;
	    elsif Policy_Ref.all in FP_Packet_Based then
	       Text:=Text&
		  "Policy: Fixed Priority Packet Based"&NL&
		  "Max Prio: " & Priority'Image
		    (Max_Priority
		       (Mast.Scheduling_Policies.FP_Packet_Based
			  (Policy_Ref.all)))&NL&
		  "Min Prio: " & Priority'Image
		    (Min_Priority
		       (Mast.Scheduling_Policies.FP_Packet_Based
			  (Policy_Ref.all)))&NL&
		  "Pkt Ovhd Max: " & Bit_Count_Image
		    (Packet_Overhead_Max_Size
		       (Mast.Scheduling_Policies.FP_Packet_Based 
			  (Policy_Ref.all),
			Throughput
			  (Mast.Processing_Resources.Network.Network 
			     (Host_Ref.all))));
	    end if;
	 end if;
	 Pango.Layout.Set_Alignment(Layout,Pango_Align_Left);
	 Set_Font_Description (Layout, Font);
	 Set_Text (Layout,To_String(Text));
	 Cairo.Move_To (Cr, 4.0, Line_Height+8.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	 
      end if;

   end Draw;

   ------------------------------
   -- Draw Secondary Scheduler --
   ------------------------------
   procedure Draw
     (Item         : access ME_Secondary_Scheduler;
      Cr   : Cairo_Context)
   is
      Rect      : constant Cairo.Region.Cairo_Rectangle_Int  := 
	Get_Coord (Item);
      W         : constant Gdouble        :=Gdouble(Rect.Width);
      H         : constant Gdouble        :=Gdouble(Rect.Height);
      Color,Black : Gdk_RGBA;
      Layout : Pango.Layout.Pango_Layout;
      Success : Boolean;
      Sche_Ref   : Scheduler_Ref          := Item.Sche;
      Sche_Name  : String                 := To_String (Name (Sche_Ref));
      Serv_Ref   : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      Policy_Ref : Mast.Scheduling_Policies.Scheduling_Policy_Ref;
   begin
      Editor_Actions.Load_System_Font (Font, Font1);
      Layout := Mast_Editor_Window.Create_Pango_Layout;
      Set_Font_Description (Layout, Font);

      Parse (Color, To_String (Item.Color_Name),Success);
      Black := (0.0, 0.0, 0.0, 1.0);

      Item.X_Coord := Gint (Get_Coord (Item).X);
      Item.Y_Coord := Gint (Get_Coord (Item).Y);
      
      Gdk.Cairo.Set_Source_RGBA (Cr, Color);
      Cairo.Rectangle
        (Cr, 0.5, 0.5, Gdouble (W) - 1.0, Gdouble (H) - 1.0);
      Cairo.Fill (Cr);

      Gdk.Cairo.Set_Source_RGBA (Cr, Black);
      Rectangle
        (Cr, 0.5, 0.5, Gdouble (W) - 1.0, Gdouble (H) - 1.0);
      Cairo.Stroke(Cr);
      
      Move_To(Cr,0.0,H/5.0);
      Line_To(Cr,W,H/5.0);
      Cairo.Stroke(Cr);
      
      if Guint(Get_Zoom (Item.Canvas)*100.0) = Zoom_Levels (1) then

	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "SECONDARY SCHEDULER", "SECONDARY SCHED", 22));
	 Cairo.Move_To (Cr, W / 20.0, H / 5.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	    
         Serv_Ref :=
           Mast.Schedulers.Secondary.Server
           (Mast.Schedulers.Secondary.Secondary_Scheduler (Sche_Ref.all));

         if Serv_Ref /= null then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Server: " & Cut (To_String (Name (Serv_Ref.all)), 15));
	    Cairo.Move_To (Cr, W / 20.0, 5.0*H / 10.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref = null then
            null;
         elsif Policy_Ref.all in Fixed_Priority then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: Fixed Priority");
	    Cairo.Move_To (Cr, W / 20.0, 7.0*H / 10.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 20.0, 9.0*H / 10.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         elsif Policy_Ref.all in EDF then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: EDF");
	    Cairo.Move_To (Cr, W / 20.0, 7.0*H / 10.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.EDF(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 20.0, 9.0*H / 10.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         end if;

      elsif Guint(Get_Zoom (Item.Canvas)*100.0) = Zoom_Levels (2) then

	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "SECONDARY SCHEDULER", "SECONDARY SCHED", 30));
	 Cairo.Move_To (Cr, W / 30.0, H / 6.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	    
         Serv_Ref :=
           Mast.Schedulers.Secondary.Server
           (Mast.Schedulers.Secondary.Secondary_Scheduler (Sche_Ref.all));
         if Serv_Ref /= null then
	    
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Server: " & Cut (To_String (Name (Serv_Ref.all)), 22));
	    Cairo.Move_To (Cr, W / 30.0, 5.0*H / 12.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);	    
         end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref = null then
            null;
         elsif Policy_Ref.all in Fixed_Priority then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: Fixed Priority");
	    Cairo.Move_To (Cr, W / 30.0, 7.0*H / 12.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 30.0, 9.0*H / 12.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         elsif Policy_Ref.all in EDF then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: : Earliest Deadline First");
	    Cairo.Move_To (Cr, W / 30.0, 7.0*H / 12.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.EDF(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 30.0, 9.0*H / 12.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         end if;

      else
	 Set_Font_Description (Layout, Font1);
	 Set_Text
	   (Layout,
	    Cut (Sche_Name, "SECONDARY SCHEDULER", "SECONDARY SCHED", 35));
	 Cairo.Move_To (Cr, W / 40.0, H / 7.0);
	 Pango.Cairo.Show_Layout (Cr, Layout);
	    
         Serv_Ref :=
           Mast.Schedulers.Secondary.Server
           (Mast.Schedulers.Secondary.Secondary_Scheduler (Sche_Ref.all));
         if Serv_Ref /= null then
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Server: " & Cut (To_String (Name (Serv_Ref.all)), 27));
	    Cairo.Move_To (Cr, W / 40.0, 5.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);	    

         end if;

         Policy_Ref := Mast.Schedulers.Scheduling_Policy (Sche_Ref.all);
         if Policy_Ref = null then
            null;
         elsif Policy_Ref.all in Fixed_Priority then
	    
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: Fixed Priority");
	    Cairo.Move_To (Cr, W / 40.0, 7.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.Fixed_Priority(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 40.0, 9.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);

	    Set_Text
	      (Layout,
	       "Max Prio: " & Priority'Image
               (Max_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 40.0, 11.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);

	    Set_Text
	      (Layout,
	       "Min Prio: " & Priority'Image
               (Min_Priority
                (Mast.Scheduling_Policies.Fixed_Priority_Policy
                 (Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 40.0, 13.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);

         elsif Policy_Ref.all in EDF then
	    
	    Set_Font_Description (Layout, Font);
	    Set_Text
	      (Layout,
	       "Policy: : Earliest Deadline First");
	    Cairo.Move_To (Cr, W / 40.0, 7.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
	    Set_Text
	      (Layout,
	       "Worst Context: " & Execution_Time_Image
               (Worst_Context_Switch
                (Mast.Scheduling_Policies.EDF(Policy_Ref.all))));
	    Cairo.Move_To (Cr, W / 40.0, 9.0*H / 14.0);
	    Pango.Cairo.Show_Layout (Cr, Layout);
	    
         end if;
      end if;

   end Draw;

   --------------------------
   -- Draw_Scheduler_Host  --
   --------------------------
   procedure Draw_Scheduler_Host (Item : ME_Scheduler_Ref) is

      Host_Ref         : Mast.Processing_Resources.Processing_Resource_Ref;
      Host_Name        : Var_String;
      Me_Host_Iterator :
        Mast_Editor.Processing_Resources.Lists.Iteration_Object;
      Me_Host_Ref      : ME_Processing_Resource_Ref;
      Sche_Ref         : Mast.Schedulers.Scheduler_Ref := Item.Sche;
      Sche_Name        : Var_String;
      Me_Sche_Iterator : Mast_Editor.Schedulers.Lists.Iteration_Object;
      Me_Sche_Ref      : ME_Scheduler_Ref;
   begin
      Host_Ref :=
        Mast.Schedulers.Primary.Host
        (Mast.Schedulers.Primary.Primary_Scheduler (Item.Sche.all));
      if Host_Ref /= null then
         Host_Name := Mast.Processing_Resources.Name (Host_Ref);
         -- we search the host in Me_Processing_Resources list
         Me_Host_Iterator :=
           Mast_Editor.Processing_Resources.Lists.Find
           (Host_Name,
            Editor_System.Me_Processing_Resources);
         Me_Host_Ref      :=
           Mast_Editor.Processing_Resources.Lists.Item
           (Me_Host_Iterator,
            Editor_System.Me_Processing_Resources);

         if Item.Canvas_Name = To_Var_String ("Proc_Res_Canvas") then
            Editor_Actions.Remove_Old_Links (Proc_Res_Canvas, Item);
            -- we remove the old link to former host

            Add_Canvas_Link (Proc_Res_Canvas, Item, Me_Host_Ref);
         else
            -- Item (Scheduler) drawn in sched_server_canvas
            begin
               if Sche_Ref /= null then
                  Sche_Name := Mast.Schedulers.Name (Sche_Ref);
                  -- we search the scheduler drawn in proc_res_canvas in
                  --Me_Schedulers list
                  Me_Sche_Iterator :=
                    Mast_Editor.Schedulers.Lists.Find
                    (Sche_Name,
                     Editor_System.Me_Schedulers);
                  Me_Sche_Ref      :=
                    Mast_Editor.Schedulers.Lists.Item
                    (Me_Sche_Iterator,
                     Editor_System.Me_Schedulers);

                  Editor_Actions.Remove_Old_Links
                    (Proc_Res_Canvas,
                     Me_Sche_Ref);  -- we remove the old link to former Host
                  Add_Canvas_Link (Proc_Res_Canvas, Me_Sche_Ref, Me_Host_Ref);
               end if;
            exception
               when Invalid_Index => -- Scheduler not found in proc_res_canvas
                  null;
            end;
         end if;
         Refresh_Canvas (Proc_Res_Canvas);
      end if;
   exception
      when Invalid_Index => -- host not found
         null;
   end Draw_Scheduler_Host;

   ---------------------------
   -- Draw_Scheduler_Server --
   ---------------------------
   procedure Draw_Scheduler_Server (Item : ME_Scheduler_Ref) is
      Ser_Ref         : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      Ser_Name        : Var_Strings.Var_String;
      Me_Ser_Iterator : Mast_Editor.Scheduling_Servers.Lists.Iteration_Object;
      ME_Ser_Ref      :
        Mast_Editor.Scheduling_Servers.ME_Scheduling_Server_Ref;
   begin
      if Item.Canvas_Name = To_Var_String ("Proc_Res_Canvas") then
         begin
            Editor_Actions.Remove_Old_Links (Proc_Res_Canvas, Item);
            -- we remove old link to former Server

            Ser_Ref :=
              Mast.Schedulers.Secondary.Server
              (Mast.Schedulers.Secondary.Secondary_Scheduler (Item.Sche.all));
            if Ser_Ref /= null then
               Ser_Name := Mast.Scheduling_Servers.Name (Ser_Ref);
               -- we search the server in Me_Servers_In_Proc_Canvas list
               Me_Ser_Iterator :=
                 Mast_Editor.Scheduling_Servers.Lists.Find
                 (Ser_Name,
                  Editor_System.Me_Servers_In_Proc_Canvas);
               ME_Ser_Ref      :=
                 Mast_Editor.Scheduling_Servers.Lists.Item
                 (Me_Ser_Iterator,
                  Editor_System.Me_Servers_In_Proc_Canvas);
               Add_Canvas_Link (Proc_Res_Canvas, Item, ME_Ser_Ref);
               Refresh_Canvas (Proc_Res_Canvas);
            end if;
         exception
            when Invalid_Index => -- server not drawn in proc_res_canvas
               ME_Ser_Ref             := new ME_Server;
               ME_Ser_Ref.Color_Name  := Ser_Color;
               ME_Ser_Ref.Name        := Ser_Name;
               ME_Ser_Ref.W           := Ser_Width;
               ME_Ser_Ref.H           := Ser_Height;
               ME_Ser_Ref.Canvas_Name := To_Var_String ("Proc_Res_Canvas");
               ME_Ser_Ref.Ser         := Ser_Ref;
               Mast_Editor.Scheduling_Servers.Lists.Add
                 (ME_Ser_Ref,
                  Editor_System.Me_Servers_In_Proc_Canvas);
               Set_Screen_Size (ME_Ser_Ref, ME_Ser_Ref.W, ME_Ser_Ref.H);
               Put (Proc_Res_Canvas, ME_Ser_Ref);
               Show_Item (Proc_Res_Canvas, ME_Ser_Ref);
               Add_Canvas_Link (Proc_Res_Canvas, Item, ME_Ser_Ref);
               Refresh_Canvas (Proc_Res_Canvas);
         end;
      end if;
   end Draw_Scheduler_Server;

   -------------------
   -- Write Primary -- (Write the params of an existing primary sched and
   --refreshes the canvas)
   -------------------
   procedure Write_Primary
     (Widget : access Gtk_Widget_Record'Class;
      Data   : ME_Scheduler_And_Dialog_Ref)
   is
      Item               : ME_Scheduler_Ref          := Data.It;
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access :=
        Prime_Sched_Dialog_Access (Data.Dia);
      Host_Name          : Var_String;
      Host_Ref           : Mast.Processing_Resources.Processing_Resource_Ref;
      Host_Index         : Mast.Processing_Resources.Lists.Index;
      Invalid_Host_Type : exception;
   begin
      if (Get_Active_Text (Prime_Sched_Dialog.Host_Combo) = "(NONE)") or
        (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
           "(NONE)")
      then
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "Host and Policy Type can't be set to (NONE)!");
         Show_All (Editor_Error_Window);
      else
         -- if "FP Packet Based" policy is selected, we have to check that
         --host belongs to Network'Class
         Host_Name  :=
           To_Var_String
           (Get_Active_Text (Prime_Sched_Dialog.Host_Combo));
         Host_Index :=
           Mast.Processing_Resources.Lists.Find
           (Host_Name,
            The_System.Processing_Resources);
         Host_Ref   :=
           Mast.Processing_Resources.Lists.Item
           (Host_Index,
            The_System.Processing_Resources);
         if Host_Ref /= null then
            if Host_Ref.all in
              Mast.Processing_Resources.Processor.Regular_Processor'Class
              and then (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
                          "Fixed Priority Packet Based")
            then
               raise Invalid_Host_Type;
            end if;
         end if;

         if Id_Name_Is_Valid
           (Ada.Characters.Handling.To_Lower
              (Get_Text (Prime_Sched_Dialog.Prime_Sched_Name_Entry)))
         then
            Write_Parameters (Item, Gtk_Dialog (Prime_Sched_Dialog));
            Draw_Scheduler_Host (Item);
            Refresh_Canvas (Proc_Res_Canvas);
            Destroy (Prime_Sched_Dialog);
         else
            Gtk_New (Editor_Error_Window);
            Set_Text (Editor_Error_Window.Label, "Identifier not Valid!!!");
            Show_All (Editor_Error_Window);
         end if;
      end if;
   exception
      when Constraint_Error =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "Invalid Value !!!");
         Show_All (Editor_Error_Window);
         Destroy (Prime_Sched_Dialog);
      when Invalid_Host_Type =>
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "FP Packet Based policy must be associated with a Network host!");
         Show_All (Editor_Error_Window);
      when Invalid_Index =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "ERROR IN HOST ASSIGNMENT");
         Show_All (Editor_Error_Window);
   end Write_Primary;

   ---------------------
   -- Write Secondary -- (Write the params of an existing secondary sched and
   --refreshes the canvas)
   ---------------------
   procedure Write_Secondary
     (Widget : access Gtk_Widget_Record'Class;
      Data   : ME_Scheduler_And_Dialog_Ref)
   is
      Item                : ME_Scheduler_Ref           := Data.It;
      Second_Sched_Dialog : Second_Sched_Dialog_Access :=
        Second_Sched_Dialog_Access (Data.Dia);
   begin
      if (Get_Active_Text (Second_Sched_Dialog.Server_Combo) =
            "(NONE)") or
        (Get_Active_Text (Second_Sched_Dialog.Policy_Type_Combo) =
           "(NONE)")
      then
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "Server and Policy Type can't be set to (NONE)!");
         Show_All (Editor_Error_Window);
      else
         if Id_Name_Is_Valid
           (Ada.Characters.Handling.To_Lower
              (Get_Text (Second_Sched_Dialog.Second_Sched_Name_Entry)))
         then
            Write_Parameters (Item, Gtk_Dialog (Second_Sched_Dialog));
            Draw_Scheduler_Server (Item);
            Refresh_Canvas (Proc_Res_Canvas);
            Destroy (Second_Sched_Dialog);
         else
            Gtk_New (Editor_Error_Window);
            Set_Text (Editor_Error_Window.Label, "Identifier not Valid!!!");
            Show_All (Editor_Error_Window);
         end if;
      end if;
   exception
      when Constraint_Error =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "Invalid Value !!!");
         Show_All (Editor_Error_Window);
         Destroy (Second_Sched_Dialog);
   end Write_Secondary;

   -----------------------
   -- New_Primary_Sched -- (Add new primary scheduler to the canvas and to the
   --lists of the systems)
   -----------------------
   procedure New_Primary_Sched
     (Widget : access Gtk_Widget_Record'Class;
      Data   : ME_Scheduler_And_Dialog_Ref)
   is
      Item               : ME_Scheduler_Ref          := Data.It;
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access :=
        Prime_Sched_Dialog_Access (Data.Dia);
      Host_Name          : Var_String;
      Host_Ref           : Mast.Processing_Resources.Processing_Resource_Ref;
      Host_Index         : Mast.Processing_Resources.Lists.Index;
      Invalid_Host_Type : exception;
   begin
      if (Get_Active_Text (Prime_Sched_Dialog.Host_Combo) = "(NONE)") or
        (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
           "(NONE)")
      then
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "Host and Policy Type can't be set to (NONE)!");
         Show_All (Editor_Error_Window);
      else
         -- if "FP Packet Based" policy is selected, we have to check that
         --host belongs to Network'Class
         Host_Name  :=
           To_Var_String
           (Get_Active_Text (Prime_Sched_Dialog.Host_Combo));
         Host_Index :=
           Mast.Processing_Resources.Lists.Find
           (Host_Name,
            The_System.Processing_Resources);
         Host_Ref   :=
           Mast.Processing_Resources.Lists.Item
           (Host_Index,
            The_System.Processing_Resources);
         if Host_Ref /= null then
            if Host_Ref.all in
              Mast.Processing_Resources.Processor.Regular_Processor'Class
              and then (Get_Active_Text (Prime_Sched_Dialog.Policy_Type_Combo) =
                          "Fixed Priority Packet Based")
            then
               raise Invalid_Host_Type;
            end if;
         end if;

         if Id_Name_Is_Valid
           (Ada.Characters.Handling.To_Lower
              (Get_Text (Prime_Sched_Dialog.Prime_Sched_Name_Entry)))
         then
            Write_Parameters (Item, Gtk_Dialog (Prime_Sched_Dialog));
            Mast.Schedulers.Lists.Add (Item.Sche, The_System.Schedulers);
            Mast_Editor.Schedulers.Lists.Add
              (Item,
               Editor_System.Me_Schedulers);
            Set_Screen_Size (Item, Item.W, Item.H);
            Put (Proc_Res_Canvas, Item);
            Refresh_Canvas (Proc_Res_Canvas);
            Show_Item (Proc_Res_Canvas, Item);
            Draw_Scheduler_Host (Item);
            Destroy (Prime_Sched_Dialog);
         else
            Gtk_New (Editor_Error_Window);
            Set_Text (Editor_Error_Window.Label, "Identifier not Valid!!!");
            Show_All (Editor_Error_Window);
         end if;
      end if;
   exception
      when Constraint_Error =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "Invalid Value !!!");
         Show_All (Editor_Error_Window);
         Destroy (Prime_Sched_Dialog);
      when Already_Exists =>
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "The Scheduler Already Exists !!!");
         Show_All (Editor_Error_Window);
         Destroy (Prime_Sched_Dialog);
      when Invalid_Host_Type =>
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "FP Packet Based policy must be associated with a Network host!");
         Show_All (Editor_Error_Window);
   end New_Primary_Sched;

   -------------------------
   -- New_Secondary_Sched -- (Add new secondary scheduler to canvas and to
   --lists of both systems)
   -------------------------
   procedure New_Secondary_Sched
     (Widget : access Gtk_Widget_Record'Class;
      Data   : ME_Scheduler_And_Dialog_Ref)
   is
      Item                : ME_Scheduler_Ref           := Data.It;
      Second_Sched_Dialog : Second_Sched_Dialog_Access :=
        Second_Sched_Dialog_Access (Data.Dia);
   begin
      if (Get_Active_Text (Second_Sched_Dialog.Server_Combo) =
            "(NONE)") or
        (Get_Active_Text (Second_Sched_Dialog.Policy_Type_Combo) =
           "(NONE)")
      then
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "Server and Policy Type can't be set to (NONE)!");
         Show_All (Editor_Error_Window);
      else
         if Id_Name_Is_Valid
           (Ada.Characters.Handling.To_Lower
              (Get_Text (Second_Sched_Dialog.Second_Sched_Name_Entry)))
         then
            Write_Parameters (Item, Gtk_Dialog (Second_Sched_Dialog));
            Mast.Schedulers.Lists.Add (Item.Sche, The_System.Schedulers);
            Mast_Editor.Schedulers.Lists.Add
              (Item,
               Editor_System.Me_Schedulers);
            Set_Screen_Size (Item, Item.W, Item.H);
            Put (Proc_Res_Canvas, Item);
            Refresh_Canvas (Proc_Res_Canvas);
            Show_Item (Proc_Res_Canvas, Item);
            Draw_Scheduler_Server (Item);
            Destroy (Second_Sched_Dialog);
         else
            Gtk_New (Editor_Error_Window);
            Set_Text (Editor_Error_Window.Label, "Identifier not Valid!!!");
            Show_All (Editor_Error_Window);
         end if;
      end if;
   exception
      when Constraint_Error =>
         Gtk_New (Editor_Error_Window);
         Set_Text (Editor_Error_Window.Label, "Invalid Value !!!");
         Show_All (Editor_Error_Window);
         Destroy (Second_Sched_Dialog);
      when Already_Exists =>
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "The Scheduler Already Exists !!!");
         Show_All (Editor_Error_Window);
         Destroy (Second_Sched_Dialog);
   end New_Secondary_Sched;

   ------------------------
   -- Show Primary Dialog -- (Show primary dialog with default params)
   ------------------------
   procedure Show_Primary_Dialog (Widget : access Gtk_Button_Record'Class) is
      Item               : ME_Scheduler_Ref            :=
        new ME_Primary_Scheduler;
      Sche_Ref           : Scheduler_Ref               :=
        new Primary_Scheduler;
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access;
      Me_Data            : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
      Item.W           := Sche_Width;
      Item.H           := Sche_Height;
      Item.Canvas_Name := To_Var_String ("Proc_Res_Canvas");
      Item.Color_Name  := Prime_Color;
      Item.Sche        := Sche_Ref;

      String_List.Append
        (Policy_Type_Combo_Items,
         "Fixed Priority Packet Based");
      Gtk_New (Prime_Sched_Dialog);
      Read_Parameters (Item, Gtk_Dialog (Prime_Sched_Dialog));
      Me_Data.It  := Item;
      Me_Data.Dia := Gtk_Dialog (Prime_Sched_Dialog);

      Me_Scheduler_And_Dialog_Cb.Connect
        (Prime_Sched_Dialog.Ok_Button,
         "clicked",
         Me_Scheduler_And_Dialog_Cb.To_Marshaller (New_Primary_Sched'Access),
         Me_Data);
   end Show_Primary_Dialog;

   ---------------------------
   -- Show Secondary Dialog -- (Show secondary dialog with default params)
   ---------------------------
   procedure Show_Secondary_Dialog
     (Widget : access Gtk_Button_Record'Class)
   is
      Item                : ME_Scheduler_Ref            :=
        new ME_Secondary_Scheduler;
      Sche_Ref            : Scheduler_Ref               :=
        new Secondary_Scheduler;
      Second_Sched_Dialog : Second_Sched_Dialog_Access;
      Me_Data             : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
      Item.W           := Sche_Width;
      Item.H           := Sche_Height;
      Item.Canvas_Name := To_Var_String ("Proc_Res_Canvas");
      Item.Color_Name  := Second_Color;
      Item.Sche        := Sche_Ref;

      Gtk_New (Second_Sched_Dialog);
      Read_Parameters (Item, Gtk_Dialog (Second_Sched_Dialog));
      Me_Data.It  := Item;
      Me_Data.Dia := Gtk_Dialog (Second_Sched_Dialog);

      Me_Scheduler_And_Dialog_Cb.Connect
        (Second_Sched_Dialog.Ok_Button,
         "clicked",
         Me_Scheduler_And_Dialog_Cb.To_Marshaller
           (New_Secondary_Sched'Access),
         Me_Data);
   end Show_Secondary_Dialog;

   -------------------
   -- Remove_Sched  --
   -------------------
   procedure Remove_Sched
     (Widget : access Gtk_Widget_Record'Class;
      Item   : ME_Scheduler_Ref)
   is
      Sche_Name       : Var_String;
      Sche_Index      : Mast.Schedulers.Lists.Index;
      Item_Deleted    : Scheduler_Ref;
      Me_Sche_Index   : Mast_Editor.Schedulers.Lists.Index;
      Me_Item_Deleted : ME_Scheduler_Ref;
   begin
      Sche_Name    := Name (Item);
      Sche_Index   :=
        Mast.Schedulers.Lists.Find (Sche_Name, The_System.Schedulers);
      Item_Deleted :=
        Mast.Schedulers.Lists.Item (Sche_Index, The_System.Schedulers);
      -- Check if the scheduler is referenced by a scheduling server
      if Mast.Scheduling_Servers.List_References_Scheduler
        (Item_Deleted,
         The_System.Scheduling_Servers)
      then
         -- Scheduler cannot be deleted
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "SCHEDULER IS REFERENCED BY A SCHEDULING_SERVER");
         Show_All (Editor_Error_Window);
         Destroy (Item_Menu);

      else
         if Message_Dialog
           (" Do you really want to remove this object? ",
            Confirmation,
            Button_Yes or Button_No,
            Button_Yes) =
           Button_Yes
         then
            Mast.Schedulers.Lists.Delete
              (Sche_Index,
               Item_Deleted,
               The_System.Schedulers);
            if Item.Sche.all'Tag =
              Mast.Schedulers.Primary.Primary_Scheduler'Tag
            then
               Mast.Processing_Resources.Set_Scheduler_State
                 (Host (Primary_Scheduler (Item.Sche.all)).all,
                  False);
            end if;
            Me_Sche_Index   :=
              Mast_Editor.Schedulers.Lists.Find
              (Sche_Name,
               Editor_System.Me_Schedulers);
            Me_Item_Deleted :=
              Mast_Editor.Schedulers.Lists.Item
              (Me_Sche_Index,
               Editor_System.Me_Schedulers);
            Mast_Editor.Schedulers.Lists.Delete
              (Me_Sche_Index,
               Me_Item_Deleted,
               Editor_System.Me_Schedulers);
            Remove (Proc_Res_Canvas, Me_Item_Deleted);
            Refresh_Canvas (Proc_Res_Canvas);
            begin
               Me_Sche_Index   :=
                 Mast_Editor.Schedulers.Lists.Find
                 (Sche_Name,
                  Editor_System.Me_Schedulers_In_Server_Canvas);
               Mast_Editor.Schedulers.Lists.Delete
                 (Me_Sche_Index,
                  Me_Item_Deleted,
                  Editor_System.Me_Schedulers_In_Server_Canvas);
               Remove (Sched_Server_Canvas, Me_Item_Deleted);
               Refresh_Canvas (Sched_Server_Canvas);
            exception
               -- we don't need to remove the scheduler when it isn't drawn
               -- in sched_server_canvas
               when Invalid_Index =>
                  null;
            end;
            Change_Control.Changes_Made;
            Destroy (Item_Menu);
         end if;
      end if;
   exception
      when Invalid_Index =>
         Gtk_New (Editor_Error_Window);
         Set_Text
           (Editor_Error_Window.Label,
            "ERROR IN SCHEDULER REMOVAL !!!");
         Show_All (Editor_Error_Window);
         Destroy (Item_Menu);
   end Remove_Sched;

   -------------------------
   -- Properties_Primary  --
   -------------------------
   procedure Properties_Primary
     (Widget : access Gtk_Widget_Record'Class;
      Item   : ME_Scheduler_Ref)
   is
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access;
      Me_Data            : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
      String_List.Append
        (Policy_Type_Combo_Items,
         "Fixed Priority Packet Based");

      Gtk_New (Prime_Sched_Dialog);
      Read_Parameters (Item, Gtk_Dialog (Prime_Sched_Dialog));
      Me_Data.It  := Item;
      Me_Data.Dia := Gtk_Dialog (Prime_Sched_Dialog);

      Me_Scheduler_And_Dialog_Cb.Connect
        (Prime_Sched_Dialog.Ok_Button,
         "clicked",
         Me_Scheduler_And_Dialog_Cb.To_Marshaller (Write_Primary'Access),
         Me_Data);

      Refresh_Canvas (Proc_Res_Canvas);
      Destroy (Item_Menu);
   end Properties_Primary;

   --------------------------
   -- Properties_Secondary --
   --------------------------
   procedure Properties_Secondary
     (Widget : access Gtk_Widget_Record'Class;
      Item   : ME_Scheduler_Ref)
   is
      Second_Sched_Dialog : Second_Sched_Dialog_Access;
      Me_Data             : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
      Gtk_New (Second_Sched_Dialog);
      Read_Parameters (Item, Gtk_Dialog (Second_Sched_Dialog));
      Me_Data.It  := Item;
      Me_Data.Dia := Gtk_Dialog (Second_Sched_Dialog);

      Me_Scheduler_And_Dialog_Cb.Connect
        (Second_Sched_Dialog.Ok_Button,
         "clicked",
         Me_Scheduler_And_Dialog_Cb.To_Marshaller (Write_Secondary'Access),
         Me_Data);

      Refresh_Canvas (Proc_Res_Canvas);
      Destroy (Item_Menu);
   end Properties_Secondary;

   ---------------------
   -- On Button Click --
   ---------------------
   function On_Button_Click
     (Item  : access ME_Primary_Scheduler;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean
   is
      Num_Button         : Guint;
      Event_Type         : Gdk_Event_Type;
      Prime_Sched_Dialog : Prime_Sched_Dialog_Access;
      Me_Data            : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
         Event_Type := Event.The_Type;
         if Event_Type = Gdk_2button_Press then
            Num_Button := Event.Button;
            if Num_Button = Guint (1) then

               String_List.Append
                 (Policy_Type_Combo_Items,
                  "Fixed Priority Packet Based");
               Gtk_New (Prime_Sched_Dialog);
               Read_Parameters (Item, Gtk_Dialog (Prime_Sched_Dialog));
               Me_Data.It  := ME_Scheduler_Ref (Item);
               Me_Data.Dia := Gtk_Dialog (Prime_Sched_Dialog);

               Me_Scheduler_And_Dialog_Cb.Connect
                 (Prime_Sched_Dialog.Ok_Button,
                  "clicked",
                  Me_Scheduler_And_Dialog_Cb.To_Marshaller
                    (Write_Primary'Access),
                  Me_Data);
	       return True;
            end if;
         elsif Event_Type = Button_Press then
            Num_Button := Event.Button;
            if Num_Button = Guint (3) then
               Gtk_New (Item_Menu);
               Button_Cb.Connect
                 (Item_Menu.Remove,
                  "activate",
                  Button_Cb.To_Marshaller (Remove_Sched'Access),
                  ME_Scheduler_Ref (Item));
               Button_Cb.Connect
                 (Item_Menu.Properties,
                  "activate",
                  Button_Cb.To_Marshaller (Properties_Primary'Access),
                  ME_Scheduler_Ref (Item));
	       return True;
            end if;
         end if;
      return False;
   end On_Button_Click;

   ---------------------
   -- On Button Click --
   ---------------------
   function On_Button_Click
     (Item  : access ME_Secondary_Scheduler;
      Event : Gdk.Event.Gdk_Event_Button) return Boolean
   is
      Num_Button          : Guint;
      Event_Type          : Gdk_Event_Type;
      Second_Sched_Dialog : Second_Sched_Dialog_Access;
      Me_Data             : ME_Scheduler_And_Dialog_Ref :=
        new ME_Scheduler_And_Dialog;
   begin
         Event_Type := Event.The_Type;
         if Event_Type = Gdk_2button_Press then
            Num_Button := Event.Button;
            if Num_Button = Guint (1) then

               Gtk_New (Second_Sched_Dialog);
               Read_Parameters (Item, Gtk_Dialog (Second_Sched_Dialog));
               Me_Data.It  := ME_Scheduler_Ref (Item);
               Me_Data.Dia := Gtk_Dialog (Second_Sched_Dialog);

               Me_Scheduler_And_Dialog_Cb.Connect
                 (Second_Sched_Dialog.Ok_Button,
                  "clicked",
                  Me_Scheduler_And_Dialog_Cb.To_Marshaller
                    (Write_Secondary'Access),
                  Me_Data);
	       return True;
            end if;
         elsif Event_Type = Button_Press then
            Num_Button := Event.Button;
            if Num_Button = Guint (3) then
               Gtk_New (Item_Menu);
               Button_Cb.Connect
                 (Item_Menu.Remove,
                  "activate",
                  Button_Cb.To_Marshaller (Remove_Sched'Access),
                  ME_Scheduler_Ref (Item));
               Button_Cb.Connect
                 (Item_Menu.Properties,
                  "activate",
                  Button_Cb.To_Marshaller (Properties_Secondary'Access),
                  ME_Scheduler_Ref (Item));
	       return True;
            end if;
         end if;
      return False;
   end On_Button_Click;

   -----------
   -- Print --
   -----------
   procedure Print
     (File        : Ada.Text_IO.File_Type;
      Item        : in out ME_Primary_Scheduler;
      Indentation : Positive;
      Finalize    : Boolean := False)
   is
   begin
      Mast_Editor.Schedulers.Print (File, ME_Scheduler (Item), Indentation);
      Put (File, " ");
      Put (File, "Me_Primary_Scheduler");
      Put (File, " ");
      Put (File, To_String (Name (Item)));
      Put (File, " ");
      Put (File, To_String (Item.Canvas_Name));
      if Item.X_Coord < 0 then
         Put (File, " ");
      end if;
      Put (File, Gint'Image (Item.X_Coord));
      if Item.Y_Coord < 0 then
         Put (File, " ");
      end if;
      Put (File, Gint'Image (Item.Y_Coord));
      Put (File, " ");
   end Print;

   -----------
   -- Print --
   -----------
   procedure Print
     (File        : Ada.Text_IO.File_Type;
      Item        : in out ME_Secondary_Scheduler;
      Indentation : Positive;
      Finalize    : Boolean := False)
   is
   begin
      Mast_Editor.Schedulers.Print (File, ME_Scheduler (Item), Indentation);
      Put (File, " ");
      Put (File, "Me_Secondary_Scheduler");

      Put (File, " ");
      Put (File, To_String (Name (Item)));
      Put (File, " ");
      Put (File, To_String (Item.Canvas_Name));
      if Item.X_Coord < 0 then
         Put (File, " ");
      end if;
      Put (File, Gint'Image (Item.X_Coord));
      if Item.Y_Coord < 0 then
         Put (File, " ");
      end if;
      Put (File, Gint'Image (Item.Y_Coord));
      Put (File, " ");
   end Print;

end Mast_Editor.Schedulers;
