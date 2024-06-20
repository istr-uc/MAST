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
with Gtk.Window; use Gtk.Window;
with Gtk.Box; use Gtk.Box;
with Gdk.Pixbuf; use Gdk.Pixbuf;
with Gtk.Label; use Gtk.Label;
with Gtk.Image; use Gtk.Image;
with Gtk.Table; use Gtk.Table;
with Gtk.GEntry; use Gtk.GEntry;
with Glib.Unicode; use Glib.Unicode;
with Gtk.Button; use Gtk.Button;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Check_Button; use Gtk.Check_Button;
with Gtk.Alignment; use Gtk.Alignment;
with Var_Strings; use Var_Strings;
package Mast_Analysis_Pkg is

   type Mast_Analysis_Record is new Gtk_Window_Record with record
      Vbox1 : Gtk_Vbox;
      Hbox1 : Gtk_Hbox;
      Pixbuf1 : Gdk_Pixbuf;
      Image1 : Gtk_Image;
      Vbox2 : Gtk_Vbox;
      Pixbuf2 : Gdk_Pixbuf;
      Image2 : Gtk_Image;
      Title_2 : Gtk_Label;
      Hbox3 : Gtk_Hbox;
      Table1 : Gtk_Table;
      Label6 : Gtk_Label;
      Label8 : Gtk_Label;
      Output_File : Gtk_Entry;
      Label7 : Gtk_Label;
      Hbox6 : Gtk_Hbox;
      Vbox5 : Gtk_Vbox;
      Input_File : Gtk_Entry;
      Label12 : Gtk_Label;
      Hbox8 : Gtk_Hbox;
      Default : Gtk_Button;
      Blank : Gtk_Button;
      Input_File_Selection : Gtk_Button;
      Directory_Entry : Gtk_Entry;
      Tool : Gtk_Combo_Box_Text;
      Frame1 : Gtk_Frame;
      Vbox3 : Gtk_Vbox;
      Label9 : Gtk_Label;
      Table2 : Gtk_Table;
      Verbose : Gtk_Check_Button;
      Local_EDF : Gtk_Check_Button;
      Stop_Factor_Button : Gtk_Check_Button;
      Ceilings : Gtk_Check_Button;
      Priorities : Gtk_Check_Button;
      Hbox5 : Gtk_Hbox;
      Label10 : Gtk_Label;
      Prio_Assign_Technique : Gtk_Combo_Box_Text;
      Destination_File : Gtk_Entry;
      Stop_Factor_Entry : Gtk_Entry;
      Operation_Name : Gtk_Entry;
      Destination : Gtk_Check_Button;
      Slacks : Gtk_Check_Button;
      Operation_Slack : Gtk_Check_Button;
      View_Results : Gtk_Check_Button;
      Alignment3 : Gtk_Alignment;
      Hbox2 : Gtk_Hbox;
      Alignment1 : Gtk_Alignment;
      Hbox12 : Gtk_Hbox;
      Go_Button : Gtk_Button;
      Alignment19 : Gtk_Alignment;
      Hbox19 : Gtk_Hbox;
      Image5 : Gtk_Image;
      Label35 : Gtk_Label;
      Cancel_Button : Gtk_Button;
      Alignment2 : Gtk_Alignment;
      Hbox11 : Gtk_Hbox;
      Hopa_Params : Gtk_Button;
      Alignment20 : Gtk_Alignment;
      Hbox20 : Gtk_Hbox;
      Image6 : Gtk_Image;
      Label36 : Gtk_Label;
      Annealing_Params : Gtk_Button;
      Alignment21 : Gtk_Alignment;
      Hbox21 : Gtk_Hbox;
      Image7 : Gtk_Image;
      Label37 : Gtk_Label;
      Help_Button : Gtk_Button;
   end record;
   type Mast_Analysis_Access is access all Mast_Analysis_Record'Class;

   procedure Gtk_New (Mast_Analysis : out Mast_Analysis_Access);
   procedure Initialize (Mast_Analysis : access Mast_Analysis_Record'Class);

   Mast_Analysis : Mast_Analysis_Access;
   
   MAST_Pro : Boolean:=False;
   -- if true, the MAST Pro name is shown in the gmast window
   
   Analysis_Tool_Name : array(1..12) of Var_String:=
     (To_Var_String("Default"),
      To_Var_String("Offset_Based"),
      To_Var_String("Offset_Based_Slanted"),
      To_Var_String("Offset_Based_Approx_W_Pr"),
      To_Var_String("Offset_Based_Approx"),
      To_Var_String("Offset_Based_Brute_Force"),
      To_Var_String("Holistic"),
      To_Var_String("EDF_Within_Priorities"),
      To_Var_String("EDF_Monoprocessor"),
      To_Var_String("Varying_Priorities"),
      To_Var_String("Classic_RM"),
      To_Var_String("Parse"));

    Technique_Name : array(1..6) of Var_String:=
      (To_Var_String("Default"), To_Var_String("Monoprocessor"),
       To_Var_String("HOSPA"), To_Var_String("PD"), To_Var_String("NPD"),
       To_Var_String("Annealing"));

end Mast_Analysis_Pkg;
