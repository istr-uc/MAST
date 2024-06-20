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
with Gtk.Label; use Gtk.Label;
with Gtk.Button; use Gtk.Button;
package Window1_Pkg is

   type Window1_Record is new Gtk_Window_Record with record
      Vbox11 : Gtk_Vbox;
      Hbox8 : Gtk_Hbox;
      Hbox9 : Gtk_Hbox;
      Label9 : Gtk_Label;
   end record;
   type Window1_Access is access all Window1_Record'Class;

   procedure Gtk_New (Window1 : out Window1_Access);
   procedure Initialize (Window1 : access Window1_Record'Class);

end Window1_Pkg;
