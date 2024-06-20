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

with Gtk.Window; use Gtk.Window;
with Gtk.Box; use Gtk.Box;
with Gtk.Menu_Bar; use Gtk.Menu_Bar;
with Gtk.Menu_Item; use Gtk.Menu_Item;
with Gtk.Menu; use Gtk.Menu;
with Gtk.Image_Menu_Item; use Gtk.Image_Menu_Item;
with Gtk.Separator_Menu_Item; use Gtk.Separator_Menu_Item;
with Gtk.Notebook; use Gtk.Notebook;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Label; use Gtk.Label;
with Gtk.Radio_Button; use Gtk.Radio_Button;
with Gtk.Adjustment; use Gtk.Adjustment;
with Gtk.Spin_Button; use Gtk.Spin_Button;
with Glib.Unicode; use Glib.Unicode;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Button; use Gtk.Button;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Separator; use Gtk.Separator;
package Pt_Editor_Pkg is

   type Pt_Editor_Record is new Gtk_Window_Record with record
      Vbox1 : Gtk_Vbox;
      Menubar1 : Gtk_Menu_Bar;
      Menuitem1 : Gtk_Menu_Item;
      Menu1 : Gtk_Menu;
      New_Menuitem1 : Gtk_Image_Menu_Item;
      Open_Menuitem2 : Gtk_Image_Menu_Item;
      Save_Menuitem3 : Gtk_Image_Menu_Item;
      Save_As_Menuitem4 : Gtk_Image_Menu_Item;
      Separatormenuitem1 : Gtk_Separator_Menu_Item;
      Quit_Menuitem5 : Gtk_Image_Menu_Item;
      Menuitem3 : Gtk_Menu_Item;
      Menuitem4 : Gtk_Menu_Item;
      Menu3 : Gtk_Menu;
      About_Menuitem10 : Gtk_Image_Menu_Item;
      Notebook1 : Gtk_Notebook;
      Vbox2 : Gtk_Vbox;
      Hbox3 : Gtk_Hbox;
      Alignment1 : Gtk_Alignment;
      Vbox12 : Gtk_Vbox;
      Label8 : Gtk_Label;
      Fixed_Prio_Radiobutton : Gtk_Radio_Button;
      Edf_Radiobutton : Gtk_Radio_Button;
      Alignment2 : Gtk_Alignment;
      Vbox13 : Gtk_Vbox;
      Label10 : Gtk_Label;
      Cswitch_Spinbutton : Gtk_Spin_Button;
      Hbox4 : Gtk_Hbox;
      Alignment3 : Gtk_Alignment;
      Label9 : Gtk_Label;
      Alignment4 : Gtk_Alignment;
      Vbox14 : Gtk_Vbox;
      Label11 : Gtk_Label;
      Ticker_Spinbutton : Gtk_Spin_Button;
      Label1 : Gtk_Label;
      Vbox5 : Gtk_Vbox;
      Scrolledwindow1 : Gtk_Scrolled_Window;
      Task_Treeview : Gtk_Tree_View;
      Task_Treemodel : Gtk_Tree_Store;
      Alignment5 : Gtk_Alignment;
      Hbox1 : Gtk_Hbox;
      Add_Task_Button : Gtk_Button;
      Delete_Task_Button : Gtk_Button;
      Assign_Prio_Button : Gtk_Button;
      Label2 : Gtk_Label;
      Vbox6 : Gtk_Vbox;
      Scrolledwindow2 : Gtk_Scrolled_Window;
      Mutex_Treeview : Gtk_Tree_View;
      Mutex_Treemodel : Gtk_Tree_Store;
      Alignment9 : Gtk_Alignment;
      Hbox2 : Gtk_Hbox;
      Add_Mutex_Button : Gtk_Button;
      Delete_Mutex_Button : Gtk_Button;
      Assign_Ceilings_Button : Gtk_Button;
      Label3 : Gtk_Label;
      Vbox3 : Gtk_Vbox;
      Scrolledwindow3 : Gtk_Scrolled_Window;
      Usage_Treeview : Gtk_Tree_View;
      Usage_Treemodel : Gtk_Tree_Store;
      Alignment8 : Gtk_Alignment;
      Hbox5 : Gtk_Hbox;
      Add_Usage_Button : Gtk_Button;
      Delete_Usage_Button : Gtk_Button;
      Label4 : Gtk_Label;
      Vbox4 : Gtk_Vbox;
      Vbox7 : Gtk_Vbox;
      Scrolledwindow4 : Gtk_Scrolled_Window;
      Results_Treeview : Gtk_Tree_View;
      Results_Treemodel : Gtk_Tree_Store;
      Alignment7 : Gtk_Alignment;
      Hbox7 : Gtk_Hbox;
      Vbox8 : Gtk_Vbox;
      Label6 : Gtk_Label;
      Utilization_Entry : Gtk_Entry;
      Vbox9 : Gtk_Vbox;
      Label7 : Gtk_Label;
      Slack_Entry : Gtk_Entry;
      Hseparator1 : Gtk_Hseparator;
      Alignment6 : Gtk_Alignment;
      Hbox6 : Gtk_Hbox;
      Assign_Params_Button : Gtk_Button;
      Do_Analysis_Button : Gtk_Button;
      Label5 : Gtk_Label;
      --Tooltip : Gtk_Tooltip;
   end record;
   type Pt_Editor_Access is access all Pt_Editor_Record'Class;

   -- This is the main window
   Pt_Editor : Pt_Editor_Access;

   procedure Gtk_New (Pt_Editor : out Pt_Editor_Access);
   procedure Initialize (Pt_Editor : access Pt_Editor_Record'Class);

end Pt_Editor_Pkg;
