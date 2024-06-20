-----------------------------------------------------------------------
--                MAST Graphical Periodic Task Editor                --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 3 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, see                      --
-- <http://www.gnu.org/licenses/>.                                   --
--                                                                   --
-----------------------------------------------------------------------

with Glib; use Glib;
with Gtk.Tree_View;            use Gtk.Tree_View;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Label; use Gtk.Label;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Gentry; use Gtk.GEntry;
with Gtk.Widget; use Gtk.Widget;
with Gdk.RGBA; use Gdk.RGBA;
with Gtk.Enums; use Gtk.Enums;
with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with Pt_Editor_Intl; use Pt_Editor_Intl;
with Ada.Text_IO; use Ada.Text_IO;
with Dialog1_Pkg; use Dialog1_Pkg;
with Mast;
with Mast.IO;

package body Results_Table is

   use type Mast.Time;

   subtype Byte is Integer range 0..255;

   function Color_Of (OK : Boolean) return Gdk.RGBA.Gdk_RGBA is
   begin
      if OK then
   	 return (0.1,0.8,0.1,1.0);
      else
   	 return (1.0,0.2,0.2,1.0);
      end if;
   end Color_Of;

   ------------------
   -- Add_New_Result --
   ------------------

   procedure Add_New_Result (Name : String; B, D, R: Mast.Time; Slack : Float)
   is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Results_Treemodel);
   begin
      Append(Pt_Editor.Results_Treemodel, Iter, Parent);
      Set(Pt_Editor.Results_Treemodel, Iter, Name_Col, -(Name));
      Set(Pt_Editor.Results_Treemodel, Iter, B_Col, -(Mast.IO.Time_Image(B)));
      Set(Pt_Editor.Results_Treemodel, Iter, D_Col, -(Mast.IO.Time_Image(D)));
      Set(Pt_Editor.Results_Treemodel, Iter, R_Col, -(Mast.IO.Time_Image(R)));
      Set(Pt_Editor.Results_Treemodel, Iter, Slack_Col,
          -(Mast.IO.Slack_Image(Slack)));
      if R<=D then
         -- "Spring Green"
	 Set(Pt_Editor.Results_Treemodel, Iter, Background_Col, "#00FF7F");
      else
         Set(Pt_Editor.Results_Treemodel, Iter, Background_Col, "Tomato");
      end if;

   end Add_New_Result;


   --------------
   -- Get_Result --
   --------------

   procedure Get_Result
     (Row : Positive; Name, B, D, R, Slack : out Var_String)
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if Row>Num_Results then
         raise Incorrect_Row;
      end if;
      Iter:=Nth_Child(Pt_Editor.Results_Treemodel,Parent,Gint(Row-1));
      Name:=To_Var_String
        (Get_String(Pt_Editor.Results_Treemodel,Iter,Name_Col));
      B:=To_Var_String
        (Get_String(Pt_Editor.Results_Treemodel,Iter,B_Col));
      D:=To_Var_String
        (Get_String(Pt_Editor.Results_Treemodel,Iter,D_Col));
      R:=To_Var_String
        (Get_String(Pt_Editor.Results_Treemodel,Iter,R_Col));
      Slack:=To_Var_String
        (Get_String(Pt_Editor.Results_Treemodel,Iter,Slack_Col));
   end Get_Result;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Results_Treemodel);
   begin
      Clear(Pt_Editor.Results_Treemodel);
      Set_Text(Pt_Editor.Slack_Entry,"");
      Set_Text(Pt_Editor.Utilization_Entry,"");
   end Initialize;


   ---------------
   -- Num_Results --
   ---------------

   function Num_Results return Natural is
   begin
      return Natural(N_Children(Pt_Editor.Results_Treemodel));
   end Num_Results;

   ----------------------
   -- Set_System_Slack --
   ----------------------

   procedure Set_System_Slack(Slack : Float) is
   begin
      Set_Text(Pt_Editor.Slack_Entry,Mast.IO.Slack_Image(Slack));
      -- Pt_Editor.Slack_Entry.Override_Background_Color
	-- (Gtk.Enums.Gtk_State_Flag_Normal,Color_Of(Slack>=0.0));
      -- Background color is not working; switch to background when possible
      Pt_Editor.Slack_Entry.Override_Color
	(Gtk.Enums.Gtk_State_Flag_Normal,Color_Of(Slack>=0.0));
   end Set_System_Slack;

   ----------------------------
   -- Set_System_Utilization --
   ----------------------------

   procedure Set_System_Utilization(Utilization : Float) is
   begin
      Set_Text(Pt_Editor.Utilization_Entry,Mast.IO.Slack_Image(Utilization));
      --Pt_Editor.Utilization_Entry.Override_Background_Color
      --  (Gtk.Enums.Gtk_State_Flag_Normal,Color_Of(Utilization<=100.0));
      -- Background color is not working; switch to background when possible
      Pt_Editor.Utilization_Entry.Override_Color
	(Gtk.Enums.Gtk_State_Flag_Normal,Color_Of(Utilization<=100.0));
   end Set_System_Utilization;

end Results_Table;
