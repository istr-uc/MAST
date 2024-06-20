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
with Gtk.Arguments;
with Gtk.Widget; use Gtk.Widget;

package Mast_Analysis_Pkg.Callbacks is
   function On_Mast_Analysis_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean;

   procedure On_Output_File_Changed
     (Object : access Gtk_Entry_Record'Class);

   procedure On_Default_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Blank_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Input_File_Selection_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Tool_Entry_Changed
     (Object : access Gtk_Combo_Box_Text_Record'Class);

   procedure On_Ceilings_Toggled
     (Object : access Gtk_Check_Button_Record'Class);

   procedure On_Priorities_Toggled
     (Object : access Gtk_Check_Button_Record'Class);

   procedure On_Stop_Factor_Button_Toggled
     (Object : access Gtk_Check_Button_Record'Class);

   procedure On_Technique_Entry_Changed
     (Object : access Gtk_Combo_Box_Text_Record'Class);

   procedure On_Destination_File_Changed
     (Object : access Gtk_Entry_Record'Class);

   procedure On_Stop_Factor_Entry_Changed
     (Object : access Gtk_Entry_Record'Class);

   procedure On_Operation_Name_Changed
     (Object : access Gtk_Entry_Record'Class);

   procedure On_Go_Button_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Cancel_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Hopa_Params_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Annealing_Params_Clicked
     (Object : access Gtk_Button_Record'Class);

   procedure On_Help_Button_Clicked
     (Object : access Gtk_Button_Record'Class);

end Mast_Analysis_Pkg.Callbacks;
