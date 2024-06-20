-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
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
with Glib; use Glib;
with Gtk; use Gtk;
with Gdk.Types;       use Gdk.Types;
with Gtk.Widget;      use Gtk.Widget;
with Gtk.Enums;       use Gtk.Enums;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_Gmast_Analysis; use Callbacks_Gmast_Analysis;
with Gmast_Analysis_Intl; use Gmast_Analysis_Intl;
with Mast_Analysis_Pkg.Callbacks; use Mast_Analysis_Pkg.Callbacks;
with Mast_Analysis_Pixmaps;

package body Mast_Analysis_Pkg is

procedure Gtk_New (Mast_Analysis : out Mast_Analysis_Access) is
begin
   Mast_Analysis := new Mast_Analysis_Record;
   Mast_Analysis_Pkg.Initialize (Mast_Analysis);
end Gtk_New;

procedure Initialize (Mast_Analysis : access Mast_Analysis_Record'Class) is
   pragma Suppress (All_Checks);
   
begin
   Gtk.Window.Initialize (Mast_Analysis, Window_Toplevel);
   Set_Title (Mast_Analysis, -"Mast_Analysis");
   Set_Position (Mast_Analysis, Win_Pos_None);
   Set_Modal (Mast_Analysis, False);
   Return_Callback.Connect
     (Mast_Analysis, "delete_event", On_Mast_Analysis_Delete_Event'Access);

   Gtk_New_Vbox (Mast_Analysis.Vbox1, False, 0);
   Add (Mast_Analysis, Mast_Analysis.Vbox1);

   Gtk_New_Hbox (Mast_Analysis.Hbox1, False, 0);
   Pack_Start (Mast_Analysis.Vbox1, Mast_Analysis.Hbox1, True, True, 0);

   Mast_Analysis.Pixbuf1 := Gdk.Pixbuf.Gdk_New_From_XPM_Data
     (Mast_Analysis_Pixmaps.Mast_Logo_Xpm);
   Mast_Analysis.Image1:=Gtk_Image_New_From_Pixbuf(Mast_Analysis.Pixbuf1);
   
   Set_Alignment (Mast_Analysis.Image1, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Image1, 7, 0);
   Pack_Start (Mast_Analysis.Hbox1, Mast_Analysis.Image1, False, False, 0);
   
   
   Gtk_New_Vbox (Mast_Analysis.Vbox2, False, 0);
   Pack_Start (Mast_Analysis.Hbox1, Mast_Analysis.Vbox2, True, True, 0);
   
   -- show either the MAST or MAST Pro name on the gmast window
   if MAST_Pro then
      Mast_Analysis.Pixbuf2 := Gdk.Pixbuf.Gdk_New_From_XPM_Data
	(Mast_Analysis_Pixmaps.Mast_Pro_Name_Xpm);
   else
      Mast_Analysis.Pixbuf2 := Gdk.Pixbuf.Gdk_New_From_XPM_Data
	(Mast_Analysis_Pixmaps.Mast_Name_Xpm);
   end if;
   Mast_Analysis.Image2:=Gtk_Image_New_From_Pixbuf(Mast_Analysis.Pixbuf2);

   Set_Alignment (Mast_Analysis.Image2, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Image2, 0, 0);
   Pack_Start (Mast_Analysis.Vbox2, Mast_Analysis.Image2, True, False, 0);

   Gtk_New (Mast_Analysis.Title_2,
            -("Modelling and Analysis Suite for Real-Time Applications"));
   Set_Alignment (Mast_Analysis.Title_2, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Title_2, 0, 0);
   Set_Justify (Mast_Analysis.Title_2, Justify_Center);
   Set_Line_Wrap (Mast_Analysis.Title_2, False);
   Pack_Start (Mast_Analysis.Vbox2, Mast_Analysis.Title_2, True, True, 0);

   Gtk_New_Hbox (Mast_Analysis.Hbox3, False, 0);
   Pack_Start (Mast_Analysis.Vbox1, Mast_Analysis.Hbox3, True, True, 0);

   Gtk_New (Mast_Analysis.Table1, 4, 3, False);
   Set_Border_Width (Mast_Analysis.Table1, 15);
   Set_Row_Spacings (Mast_Analysis.Table1, 0);
   Set_Col_Spacings (Mast_Analysis.Table1, 0);
   Pack_Start (Mast_Analysis.Hbox3, Mast_Analysis.Table1, True, True, 0);

   Gtk_New (Mast_Analysis.Label6, -("Tool"));
   Set_Alignment (Mast_Analysis.Label6, 0.78, 0.5);
   Set_Padding (Mast_Analysis.Label6, 0, 0);
   Set_Justify (Mast_Analysis.Label6, Justify_Right);
   Set_Line_Wrap (Mast_Analysis.Label6, False);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Label6, 0, 1, 0, 1,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New (Mast_Analysis.Label8, -("Results File  "));
   Set_Alignment (Mast_Analysis.Label8, 0.8, 0.5);
   Set_Padding (Mast_Analysis.Label8, 0, 0);
   Set_Justify (Mast_Analysis.Label8, Justify_Right);
   Set_Line_Wrap (Mast_Analysis.Label8, False);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Label8, 0, 1, 3, 4,
     0, 0,
     0, 0);

   Gtk_New (Mast_Analysis.Output_File);
   Set_Editable (Mast_Analysis.Output_File, True);
   Set_Max_Length (Mast_Analysis.Output_File, 0);
   Set_Text (Mast_Analysis.Output_File, -"");
   Set_Visibility (Mast_Analysis.Output_File, True);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Output_File, 1, 2, 3, 4,
     Gtk.Enums.Expand or Gtk.Enums.Fill, 0,
     0, 0);
   Entry_Callback.Connect
     (Mast_Analysis.Output_File, "changed",
      Entry_Callback.To_Marshaller (On_Output_File_Changed'Access));

   Gtk_New (Mast_Analysis.Label7, -("Input File"));
   Set_Alignment (Mast_Analysis.Label7, 0.9, 0.5);
   Set_Padding (Mast_Analysis.Label7, 0, 0);
   Set_Justify (Mast_Analysis.Label7, Justify_Right);
   Set_Line_Wrap (Mast_Analysis.Label7, False);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Label7, 0, 1, 2, 3,
     0, 0,
     0, 0);

   Gtk_New_Hbox (Mast_Analysis.Hbox6, False, 0);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Hbox6, 1, 2, 2, 3,
     Gtk.Enums.Fill, Gtk.Enums.Fill,
     0, 0);

   Gtk_New_Vbox (Mast_Analysis.Vbox5, False, 0);
   Pack_Start (Mast_Analysis.Hbox6, Mast_Analysis.Vbox5, True, True, 0);

   Gtk_New (Mast_Analysis.Input_File);
   Set_Editable (Mast_Analysis.Input_File, True);
   Set_Max_Length (Mast_Analysis.Input_File, 0);
   Set_Text (Mast_Analysis.Input_File, -"");
   Set_Visibility (Mast_Analysis.Input_File, True);
   Pack_Start (Mast_Analysis.Vbox5, Mast_Analysis.Input_File, False, False, 0);

   Gtk_New (Mast_Analysis.Label12, -("Directory"));
   Set_Alignment (Mast_Analysis.Label12, 0.9, 0.5);
   Set_Padding (Mast_Analysis.Label12, 0, 0);
   Set_Justify (Mast_Analysis.Label12, Justify_Right);
   Set_Line_Wrap (Mast_Analysis.Label12, False);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Label12, 0, 1, 1, 2,
     0, 0,
     0, 0);

   Gtk_New_Hbox (Mast_Analysis.Hbox8, False, 0);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Hbox8, 2, 3, 3, 4,
     Gtk.Enums.Fill, Gtk.Enums.Fill,
     0, 0);

   Gtk_New (Mast_Analysis.Default, -"Default");
   Set_Relief (Mast_Analysis.Default, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox8, Mast_Analysis.Default, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Default, "clicked",
      Button_Callback.To_Marshaller (On_Default_Clicked'Access));

   Gtk_New (Mast_Analysis.Blank, -"Blank");
   Set_Relief (Mast_Analysis.Blank, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox8, Mast_Analysis.Blank, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Blank, "clicked",
      Button_Callback.To_Marshaller (On_Blank_Clicked'Access));

   Gtk_New (Mast_Analysis.Input_File_Selection, -"File...");
   Set_Relief (Mast_Analysis.Input_File_Selection, Relief_Normal);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Input_File_Selection, 2, 3, 2, 3,
     Gtk.Enums.Fill, 0,
     0, 0);
   Button_Callback.Connect
     (Mast_Analysis.Input_File_Selection, "clicked",
      Button_Callback.To_Marshaller (On_Input_File_Selection_Clicked'Access));

   Gtk_New (Mast_Analysis.Directory_Entry);
   Set_Editable (Mast_Analysis.Directory_Entry, True);
   Set_Max_Length (Mast_Analysis.Directory_Entry, 0);
   Set_Text (Mast_Analysis.Directory_Entry, -"");
   Set_Visibility (Mast_Analysis.Directory_Entry, True);
   Attach (Mast_Analysis.Table1, Mast_Analysis.Directory_Entry, 1, 3, 1, 2,
     Gtk.Enums.Expand or Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New_With_Entry (Mast_Analysis.Tool);
   Gtk_New_With_Entry (Mast_Analysis.Prio_Assign_Technique);
   for I in Analysis_Tool_Name'Range loop
      Append_Text (Mast_Analysis.Tool,
                   To_String(Analysis_Tool_Name(I)));
   end loop;
   Set_Active(Mast_Analysis.Tool,0);
   Combo_Box_Callback.Connect
     (Mast_Analysis.Tool, "changed",
      Combo_Box_Callback.To_Marshaller (On_Tool_Entry_Changed'Access));

   Attach
     (Mast_Analysis.Table1,
       Mast_Analysis.Tool,      Left_Attach  => 1,
      Right_Attach  => 3,
      Top_Attach  => 0,
      Bottom_Attach  => 1,
      Yoptions => 0,
      Xpadding  => 0,
      Ypadding  => 0);

   Gtk_New (Mast_Analysis.Frame1);
   Set_Border_Width (Mast_Analysis.Frame1, 3);
   Set_Shadow_Type (Mast_Analysis.Frame1, Shadow_Etched_In);
   Pack_Start (Mast_Analysis.Hbox3, Mast_Analysis.Frame1, True, True, 0);

   Gtk_New_Vbox (Mast_Analysis.Vbox3, False, 0);
   Add (Mast_Analysis.Frame1, Mast_Analysis.Vbox3);

   Gtk_New (Mast_Analysis.Label9, -("Options"));
   Set_Alignment (Mast_Analysis.Label9, 0.1, 0.5);
   Set_Padding (Mast_Analysis.Label9, 0, 0);
   Set_Justify (Mast_Analysis.Label9, Justify_Right);
   Set_Line_Wrap (Mast_Analysis.Label9, False);
   Pack_Start (Mast_Analysis.Vbox3, Mast_Analysis.Label9, False, False, 0);

   Gtk_New (Mast_Analysis.Table2, 9, 2, False);
   Set_Row_Spacings (Mast_Analysis.Table2, 0);
   Set_Col_Spacings (Mast_Analysis.Table2, 0);
   Pack_Start (Mast_Analysis.Vbox3, Mast_Analysis.Table2, True, True, 0);

   Gtk_New (Mast_Analysis.Verbose, -"Verbose");
   Set_Active (Mast_Analysis.Verbose, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Verbose, 0, 1, 0, 1,
     Gtk.Enums.Fill, 0,
     0, 0);

   -- Added local EDF option

   Gtk_New (Mast_Analysis.Local_EDF, -"Local EDF");
   Set_Active (Mast_Analysis.Local_EDF, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Local_EDF, 0, 1, 1, 2,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New (Mast_Analysis.Ceilings, -("Calc. Ceilings & Levels"));
   Set_Relief (Mast_Analysis.Ceilings, Relief_Normal);
   Set_Active (Mast_Analysis.Ceilings, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Ceilings, 0, 1, 2, 3,
     Gtk.Enums.Fill, 0,
     0, 0);
   Check_Button_Callback.Connect
     (Mast_Analysis.Ceilings, "toggled",
      Check_Button_Callback.To_Marshaller (On_Ceilings_Toggled'Access));

   Gtk_New (Mast_Analysis.Priorities, -("Assign Parameters"));
   Set_Relief (Mast_Analysis.Priorities, Relief_Normal);
   Set_Active (Mast_Analysis.Priorities, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Priorities, 0, 1, 3, 4,
     Gtk.Enums.Fill, 0,
     0, 0);
   Check_Button_Callback.Connect
     (Mast_Analysis.Priorities, "toggled",
      Check_Button_Callback.To_Marshaller (On_Priorities_Toggled'Access));

   Gtk_New_Hbox (Mast_Analysis.Hbox5, False, 0);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Hbox5, 1, 2, 3, 4,
     Gtk.Enums.Expand or Gtk.Enums.Fill, Gtk.Enums.Fill,
     0, 0);

   Gtk_New (Mast_Analysis.Label10, -("Technique"));
   Set_Alignment (Mast_Analysis.Label10, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Label10, 0, 0);
   Set_Justify (Mast_Analysis.Label10, Justify_Center);
   Set_Line_Wrap (Mast_Analysis.Label10, False);
   Pack_Start (Mast_Analysis.Hbox5, Mast_Analysis.Label10, False, False, 0);

   Gtk_New_With_Entry (Mast_Analysis.Prio_Assign_Technique);
   Append_Text (Mast_Analysis.Prio_Assign_Technique,"");
   for I in Technique_Name'Range loop
      Append_Text (Mast_Analysis.Prio_Assign_Technique,
                   To_String(Technique_Name(I)));
   end loop;
   Set_Active(Mast_Analysis.Prio_Assign_Technique,0);
   Combo_Box_Callback.Connect
     (Mast_Analysis.Prio_Assign_Technique, "changed",
      Combo_Box_Callback.To_Marshaller (On_Technique_Entry_Changed'Access));

   Pack_Start
     (Mast_Analysis.Hbox5,
      Mast_Analysis.Prio_Assign_Technique,
      Expand  => True,
      Fill    => True,
      Padding => 0);

   -- Added stop fator option, in 4,5

   Gtk_New (Mast_Analysis.Stop_Factor_Button, "Stop Factor");
   Set_Active (Mast_Analysis.Stop_Factor_Button, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Stop_Factor_Button, 0, 1, 4, 5,
     Gtk.Enums.Fill, 0,
     0, 0);
   Check_Button_Callback.Connect
     (Mast_Analysis.Stop_Factor_Button, "toggled",
      Check_Button_Callback.To_Marshaller
        (On_Stop_Factor_Button_Toggled'Access));

   Gtk_New (Mast_Analysis.Stop_Factor_Entry);
   Set_Editable (Mast_Analysis.Stop_Factor_Entry, True);
   Set_Max_Length (Mast_Analysis.Stop_Factor_Entry, 0);
   Set_Text (Mast_Analysis.Stop_Factor_Entry, -"");
   Set_Visibility (Mast_Analysis.Stop_Factor_Entry, True);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Stop_Factor_Entry, 1, 2, 4, 5,
     Gtk.Enums.Expand or Gtk.Enums.Fill, 0,
     0, 0);
   Entry_Callback.Connect
     (Mast_Analysis.Stop_Factor_Entry, "changed",
      Entry_Callback.To_Marshaller (On_Stop_Factor_Entry_Changed'Access));

   -- end stop factor

   Gtk_New (Mast_Analysis.Destination_File);
   Set_Editable (Mast_Analysis.Destination_File, True);
   Set_Max_Length (Mast_Analysis.Destination_File, 0);
   Set_Text (Mast_Analysis.Destination_File, -"");
   Set_Visibility (Mast_Analysis.Destination_File, True);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Destination_File, 1, 2, 5, 6,
     Gtk.Enums.Expand or Gtk.Enums.Fill, 0,
     0, 0);
   Entry_Callback.Connect
     (Mast_Analysis.Destination_File, "changed",
      Entry_Callback.To_Marshaller (On_Destination_File_Changed'Access));

   Gtk_New (Mast_Analysis.Operation_Name);
   Set_Editable (Mast_Analysis.Operation_Name, True);
   Set_Max_Length (Mast_Analysis.Operation_Name, 0);
   Set_Text (Mast_Analysis.Operation_Name, -"");
   Set_Visibility (Mast_Analysis.Operation_Name, True);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Operation_Name, 1, 2, 7, 8,
     Gtk.Enums.Expand or Gtk.Enums.Fill, 0,
     0, 0);
   Entry_Callback.Connect
     (Mast_Analysis.Operation_Name, "changed",
      Entry_Callback.To_Marshaller (On_Operation_Name_Changed'Access));

   Gtk_New (Mast_Analysis.Destination, -"Source Dest. File");
   Set_Active (Mast_Analysis.Destination, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Destination, 0, 1, 5, 6,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New (Mast_Analysis.Slacks, -"Calculate Slacks");
   Set_Active (Mast_Analysis.Slacks, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Slacks, 0, 1, 6, 7,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New (Mast_Analysis.Operation_Slack, -"Calc. Operation Slack");
   Set_Active (Mast_Analysis.Operation_Slack, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.Operation_Slack, 0, 1, 7, 8,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New (Mast_Analysis.View_Results, -"View Results");
   Set_Active (Mast_Analysis.View_Results, False);
   Attach (Mast_Analysis.Table2, Mast_Analysis.View_Results, 0, 1, 8, 9,
     Gtk.Enums.Fill, 0,
     0, 0);

   Gtk_New
     (Mast_Analysis.Alignment3, 0.5, 0.5, 1.0,
      1.0);
   Add (Mast_Analysis.Vbox1, Mast_Analysis.Alignment3);

   Gtk_New_Hbox (Mast_Analysis.Hbox2, False, 220);
   Set_Border_Width (Mast_Analysis.Hbox2, 10);
   Add (Mast_Analysis.Alignment3, Mast_Analysis.Hbox2);

   Gtk_New
     (Mast_Analysis.Alignment1, 0.0, 0.5, 1.0,
      1.0);
   Pack_Start (Mast_Analysis.Hbox2, Mast_Analysis.Alignment1, False, False, 0);

   Gtk_New_Hbox (Mast_Analysis.Hbox12, False, 0);
   Add (Mast_Analysis.Alignment1, Mast_Analysis.Hbox12);

   Gtk_New (Mast_Analysis.Go_Button);
   Set_Border_Width (Mast_Analysis.Go_Button, 4);
   Set_Relief (Mast_Analysis.Go_Button, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox12, Mast_Analysis.Go_Button, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Go_Button, "clicked",
      Button_Callback.To_Marshaller (On_Go_Button_Clicked'Access));

   Gtk_New
     (Mast_Analysis.Alignment19, 0.5, 0.5, 0.0,
      0.0);
   Add (Mast_Analysis.Go_Button, Mast_Analysis.Alignment19);

   Gtk_New_Hbox (Mast_Analysis.Hbox19, False, 2);
   Add (Mast_Analysis.Alignment19, Mast_Analysis.Hbox19);

   Gtk_New (Mast_Analysis.Image5 , "gtk-apply", Gtk_Icon_Size'Val (4));
   Set_Alignment (Mast_Analysis.Image5, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Image5, 0, 0);
   Pack_Start
     (Mast_Analysis.Hbox19,
      Mast_Analysis.Image5,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Mast_Analysis.Label35, -("GO"));
   Set_Alignment (Mast_Analysis.Label35, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Label35, 0, 0);
   Set_Justify (Mast_Analysis.Label35, Justify_Left);
   Set_Line_Wrap (Mast_Analysis.Label35, False);
   Set_Selectable (Mast_Analysis.Label35, False);
   Set_Use_Markup (Mast_Analysis.Label35, False);
   Set_Use_Underline (Mast_Analysis.Label35, True);
   Pack_Start
     (Mast_Analysis.Hbox19,
      Mast_Analysis.Label35,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New_From_Stock (Mast_Analysis.Cancel_Button, "gtk-cancel");
   Set_Border_Width (Mast_Analysis.Cancel_Button, 4);
   Set_Relief (Mast_Analysis.Cancel_Button, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox12,
               Mast_Analysis.Cancel_Button, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Cancel_Button, "clicked",
      Button_Callback.To_Marshaller (On_Cancel_Clicked'Access));

   Gtk_New
     (Mast_Analysis.Alignment2, 1.0, 0.5, 1.0,
      1.0);
   Add (Mast_Analysis.Hbox2, Mast_Analysis.Alignment2);

   Gtk_New_Hbox (Mast_Analysis.Hbox11, False, 0);
   Add (Mast_Analysis.Alignment2, Mast_Analysis.Hbox11);

   Gtk_New (Mast_Analysis.Hopa_Params);
   Set_Border_Width (Mast_Analysis.Hopa_Params, 4);
   Set_Relief (Mast_Analysis.Hopa_Params, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox11,
               Mast_Analysis.Hopa_Params, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Hopa_Params, "clicked",
      Button_Callback.To_Marshaller (On_Hopa_Params_Clicked'Access));

   Gtk_New
     (Mast_Analysis.Alignment20, 0.5, 0.5, 0.0,
      0.0);
   Add (Mast_Analysis.Hopa_Params, Mast_Analysis.Alignment20);

   Gtk_New_Hbox (Mast_Analysis.Hbox20, False, 2);
   Add (Mast_Analysis.Alignment20, Mast_Analysis.Hbox20);

   Gtk_New (Mast_Analysis.Image6 , "gtk-justify-fill", Gtk_Icon_Size'Val (4));
   Set_Alignment (Mast_Analysis.Image6, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Image6, 0, 0);
   Pack_Start
     (Mast_Analysis.Hbox20,
      Mast_Analysis.Image6,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Mast_Analysis.Label36, -("HOSPA Parameters"));
   Set_Alignment (Mast_Analysis.Label36, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Label36, 0, 0);
   Set_Justify (Mast_Analysis.Label36, Justify_Left);
   Set_Line_Wrap (Mast_Analysis.Label36, False);
   Set_Selectable (Mast_Analysis.Label36, False);
   Set_Use_Markup (Mast_Analysis.Label36, False);
   Set_Use_Underline (Mast_Analysis.Label36, True);
   Pack_Start
     (Mast_Analysis.Hbox20,
      Mast_Analysis.Label36,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Mast_Analysis.Annealing_Params);
   Set_Border_Width (Mast_Analysis.Annealing_Params, 4);
   Set_Relief (Mast_Analysis.Annealing_Params, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox11,
               Mast_Analysis.Annealing_Params, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Annealing_Params, "clicked",
      Button_Callback.To_Marshaller (On_Annealing_Params_Clicked'Access));

   Gtk_New
     (Mast_Analysis.Alignment21, 0.5, 0.5, 0.0,
      0.0);
   Add (Mast_Analysis.Annealing_Params, Mast_Analysis.Alignment21);

   Gtk_New_Hbox (Mast_Analysis.Hbox21, False, 2);
   Add (Mast_Analysis.Alignment21, Mast_Analysis.Hbox21);

   Gtk_New (Mast_Analysis.Image7 , "gtk-justify-fill", Gtk_Icon_Size'Val (4));
   Set_Alignment (Mast_Analysis.Image7, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Image7, 0, 0);
   Pack_Start
     (Mast_Analysis.Hbox21,
      Mast_Analysis.Image7,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Mast_Analysis.Label37, -("Annealing Parameters"));
   Set_Alignment (Mast_Analysis.Label37, 0.5, 0.5);
   Set_Padding (Mast_Analysis.Label37, 0, 0);
   Set_Justify (Mast_Analysis.Label37, Justify_Left);
   Set_Line_Wrap (Mast_Analysis.Label37, False);
   Set_Selectable (Mast_Analysis.Label37, False);
   Set_Use_Markup (Mast_Analysis.Label37, False);
   Set_Use_Underline (Mast_Analysis.Label37, True);
   Pack_Start
     (Mast_Analysis.Hbox21,
      Mast_Analysis.Label37,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New_From_Stock (Mast_Analysis.Help_Button, "gtk-help");
   Set_Border_Width (Mast_Analysis.Help_Button, 4);
   Set_Relief (Mast_Analysis.Help_Button, Relief_Normal);
   Pack_Start (Mast_Analysis.Hbox11,
               Mast_Analysis.Help_Button, False, False, 0);
   Button_Callback.Connect
     (Mast_Analysis.Help_Button, "clicked",
      Button_Callback.To_Marshaller (On_Help_Button_Clicked'Access));

end Initialize;

end Mast_Analysis_Pkg;
