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
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.Box; use Gtk.Box;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with Pt_Editor_Pkg;
with pt_editor_Intl; use pt_editor_Intl;
with Filechooserdialog1_Pkg.Callbacks; use Filechooserdialog1_Pkg.Callbacks;

package body Filechooserdialog1_Pkg is

   procedure Gtk_New (Filechooserdialog1 : out Filechooserdialog1_Access) is
   begin
      Filechooserdialog1 := new Filechooserdialog1_Record;
      Filechooserdialog1_Pkg.Initialize (Filechooserdialog1);
   end Gtk_New;

   procedure Initialize 
     (Filechooserdialog1 : access Filechooserdialog1_Record'Class) 
   is
      pragma Suppress (All_Checks);
      Pixmaps_Dir : constant String := "pixmaps/";
   begin

      Gtk_New (Filechooserdialog1.Fileselection_Ok, -"OK");

      Gtk.File_Chooser_Dialog.Initialize
	(Filechooserdialog1,
	 Title => "Periodic Task Editor File Chooser",
	 Parent => Pt_Editor_Pkg.Pt_Editor,
	 Action => Action_Save);

      Set_Modal (Filechooserdialog1, True);

      Pack_Start
	(Get_Action_Area (Filechooserdialog1),
	 Filechooserdialog1.Fileselection_Ok,
	 Expand  => False,
	 Fill    => False,
	 Padding => 0);

      Gtk_New (Filechooserdialog1.Fileselection_Cancel, -"Cancel");

      Pack_Start
	(Get_Action_Area (Filechooserdialog1),
	 Filechooserdialog1.Fileselection_Cancel,
	 Expand  => False,
	 Fill    => False,
	 Padding => 0);

      --  Connect signals

      Button_Callback.Connect
	(Filechooserdialog1.Fileselection_Ok, "pressed",
	 Button_Callback.To_Marshaller 
	   (On_Fileselection_Ok_Pressed'Access), False);
      Button_Callback.Connect
	(Filechooserdialog1.Fileselection_Ok, "activate",
	 Button_Callback.To_Marshaller 
	   (On_Fileselection_Ok_Activate'Access), False);
      Button_Callback.Connect
	(Filechooserdialog1.Fileselection_Cancel, "pressed",
	 Button_Callback.To_Marshaller 
	   (On_Fileselection_Cancel_Pressed'Access), False);
      Button_Callback.Connect
	(Filechooserdialog1.Fileselection_Cancel, "activate",
	 Button_Callback.To_Marshaller 
	   (On_Fileselection_Cancel_Activate'Access), False);
   end Initialize;

end Filechooserdialog1_Pkg;
