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

package body Window1_Pkg is

procedure Gtk_New (Window1 : out Window1_Access) is
begin
   Window1 := new Window1_Record;
   Window1_Pkg.Initialize (Window1);
end Gtk_New;

procedure Initialize (Window1 : access Window1_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin
   Gtk.Window.Initialize (Window1, Window_Toplevel);

   Gtk_New_Vbox (Window1.Vbox11, False, 0);

   Gtk_New_Hbox (Window1.Hbox8, False, 0);

   Pack_Start
     (Window1.Vbox11,
      Window1.Hbox8,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New_Hbox (Window1.Hbox9, False, 0);

   Gtk_New (Window1.Label9, -("The name"));

   Pack_Start
     (Window1.Hbox9,
      Window1.Label9,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pack_Start
     (Window1.Vbox11,
      Window1.Hbox9,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Add (Window1, Window1.Vbox11);

   --  Connect signals

end Initialize;

end Window1_Pkg;
