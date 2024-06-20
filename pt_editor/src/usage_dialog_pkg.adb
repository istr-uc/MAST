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
with Gtk; use Gtk;
with Gdk.Types; use Gdk.Types;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Enums; use Gtk.Enums;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with pt_editor_Intl; use pt_editor_Intl;
with Usage_Dialog_Pkg.Callbacks; use Usage_Dialog_Pkg.Callbacks;
with Ada.Text_IO; use Ada.Text_IO;

package body Usage_Dialog_Pkg is

procedure Gtk_New (Usage_Dialog : out Usage_Dialog_Access) is
begin
   Usage_Dialog := new Usage_Dialog_Record;
   Usage_Dialog_Pkg.Initialize (Usage_Dialog);
end Gtk_New;

procedure Initialize (Usage_Dialog : access Usage_Dialog_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";

begin
   Gtk.Dialog.Initialize (Usage_Dialog);
   Set_Border_Width (Usage_Dialog, 5);

   Gtk_New
     (Usage_Dialog.Alignment11, 0.5, 0.5, 1.0,
      1.0);

   Gtk_New_Vbox (Usage_Dialog.Vbox10, False, 0);

   Gtk_New_Hbox (Usage_Dialog.Hbox8, False, 0);

   Gtk_New (Usage_Dialog.Label13, -("Operation Name"));
   Set_Width_Chars(Usage_Dialog.Label13, 15);

   Pack_Start
     (Usage_Dialog.Hbox8,
      Usage_Dialog.Label13,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Usage_Dialog.Operation_Entry);
   Set_Invisible_Char (Usage_Dialog.Operation_Entry, UTF8_Get_Char ("@"));

   Pack_Start
     (Usage_Dialog.Hbox8,
      Usage_Dialog.Operation_Entry,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Pack_Start
     (Usage_Dialog.Vbox10,
      Usage_Dialog.Hbox8,
      Expand  => False,
      Fill    => False,
      Padding => 5);
   Usage_Dialog.Hbox8.Set_Tooltip_Text
     (-"Name of operation using a mutex");

   Gtk_New_Hbox (Usage_Dialog.Hbox9, False, 0);

   Gtk_New (Usage_Dialog.Label14, -("Task"));
   Set_Width_Chars(Usage_Dialog.Label14, 15);

   Pack_Start
     (Usage_Dialog.Hbox9,
      Usage_Dialog.Label14,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New(Usage_Dialog.Taskname_Combobox);

   Pack_Start
     (Usage_Dialog.Hbox9,
      Usage_Dialog.Taskname_Combobox,
      Expand  => True,
      Fill    => True,
      Padding => 0);

   Pack_Start
     (Usage_Dialog.Vbox10,
      Usage_Dialog.Hbox9,
      Expand  => False,
      Fill    => False,
      Padding => 5);
   Usage_Dialog.Hbox9.Set_Tooltip_Text
     (-"Name of the task using the mutex");

   Gtk_New_Hbox (Usage_Dialog.Hbox10, False, 0);

   Gtk_New (Usage_Dialog.Label15, -("Mutex"));
   Set_Width_Chars(Usage_Dialog.Label15, 15);

   Pack_Start
     (Usage_Dialog.Hbox10,
      Usage_Dialog.Label15,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New(Usage_Dialog.Mutexname_Combobox);

   Pack_Start
     (Usage_Dialog.Hbox10,
      Usage_Dialog.Mutexname_Combobox,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Pack_Start
     (Usage_Dialog.Vbox10,
      Usage_Dialog.Hbox10,
      Expand  => False,
      Fill    => False,
      Padding => 5);
   Usage_Dialog.Hbox10.Set_Tooltip_Text
     (-"Name of the mutex used");

   Gtk_New_Hbox (Usage_Dialog.Hbox11, False, 0);

   Gtk_New (Usage_Dialog.Label16, -("WCET"));
   Set_Width_Chars(Usage_Dialog.Label16, 15);

   Pack_Start
     (Usage_Dialog.Hbox11,
      Usage_Dialog.Label16,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Usage_Dialog.Wcet_Entry);
   Set_Invisible_Char (Usage_Dialog.Wcet_Entry, UTF8_Get_Char ("@"));

   Pack_Start
     (Usage_Dialog.Hbox11,
      Usage_Dialog.Wcet_Entry,
      Expand  => True,
      Fill    => True,
      Padding => 0);

   Pack_Start
     (Usage_Dialog.Vbox10,
      Usage_Dialog.Hbox11,
      Expand  => False,
      Fill    => False,
      Padding => 5);
   Usage_Dialog.Hbox11.Set_Tooltip_Text
     (-"Worst case execution time of the operation using the mutex");
   Add (Usage_Dialog.Alignment11, Usage_Dialog.Vbox10);
   Pack_Start
     (Usage_Dialog.Get_Content_Area,
      Usage_Dialog.Alignment11,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Usage_Dialog.Usage_Cancel_Ebutton, -"Cancel");

   Pack_Start
     (Get_Action_Area (Usage_Dialog),
      Usage_Dialog.Usage_Cancel_Ebutton,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Usage_Dialog.Usage_Ok_Button, -"OK");

   Pack_Start
     (Get_Action_Area (Usage_Dialog),
      Usage_Dialog.Usage_Ok_Button,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Usage_Dialog.Usage_Ok_Button.Set_Tooltip_Text
     (-"Press OK to add a new mutex usage");

   --  Connect signals

   Button_Callback.Connect
     (Usage_Dialog.Usage_Cancel_Ebutton, "pressed",
      Button_Callback.To_Marshaller
        (On_Usage_Cancel_Ebutton_Pressed'Access), False);
   Button_Callback.Connect
     (Usage_Dialog.Usage_Ok_Button, "pressed",
      Button_Callback.To_Marshaller (On_Usage_Ok_Button_Pressed'Access), False);
end Initialize;

end Usage_Dialog_Pkg;
