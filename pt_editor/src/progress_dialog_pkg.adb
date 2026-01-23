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
with Gtk.Box; use Gtk.Box;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with pt_editor_Intl; use pt_editor_Intl;

package body Progress_Dialog_Pkg is

procedure Gtk_New (Progress_Dialog : out Progress_Dialog_Access) is
begin
   Progress_Dialog := new Progress_Dialog_Record;
   Progress_Dialog_Pkg.Initialize (Progress_Dialog);
end Gtk_New;

procedure Initialize (Progress_Dialog : access Progress_Dialog_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin
   Gtk.Dialog.Initialize (Progress_Dialog);
   Set_Border_Width (Progress_Dialog, 5);


   Gtk_New
     (Progress_Dialog.Alignment12, 0.1, 0.1, 0.1,
      0.1);

   Pack_Start
     (Get_Content_Area (Progress_Dialog),
      Progress_Dialog.Alignment12,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Progress_Dialog.Progress_Ok, -"OK");

   Pack_Start
     (Get_Action_Area (Progress_Dialog),
      Progress_Dialog.Progress_Ok,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   --  Connect signals

end Initialize;

end Progress_Dialog_Pkg;
