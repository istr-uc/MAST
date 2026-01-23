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

with Glib.Object; use Glib.Object;
with Glib.Values; use Glib.Values;
with Gtk.Arguments;
with Gtk.Widget; use Gtk.Widget;
with Aboutdialog1_Pkg; use Aboutdialog1_Pkg;

package Pt_Editor_Pkg.Callbacks is
   procedure On_New_Menuitem1_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Open_Menuitem2_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Save_Menuitem3_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Save_As_Menuitem4_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Quit_Menuitem5_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_About_Menuitem10_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Fixed_Prio_Radiobutton_Toggled
     (Object : access Gtk_Radio_Button_Record'Class);

   procedure On_Edf_Radiobutton_Toggled
     (Object : access Gtk_Radio_Button_Record'Class);

   procedure On_Cswitch_Spinbutton_Value_Changed
     (Object : access Gtk_Spin_Button_Record'Class);

   procedure On_Ticker_Spinbutton_Value_Changed
     (Object : access Gtk_Spin_Button_Record'Class);

   procedure On_Task_Treeview_Columns_Changed
     (Object : access Gtk_Tree_View_Record'Class);

   procedure On_Add_Task_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Delete_Task_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Assign_Prio_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Add_Mutex_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Delete_Mutex_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Assign_Ceilings_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Add_Usage_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Delete_Usage_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Assign_Params_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Do_Analysis_Button_Pressed
     (Object : access Gtk_Button_Record'Class);

   function On_Pt_Editor_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean;

   procedure Text_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Mutex_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Usage_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Text_Edited_Callback_C
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Usage_Edited_Callback_WCET
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Text_Edited_Callback_T
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Text_Edited_Callback_D
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Text_Edited_Callback_Prio
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);

   procedure Mutex_Edited_Callback_Prio
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues);


   Aboutdialog1 : Aboutdialog1_Access;


end Pt_Editor_Pkg.Callbacks;
