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

with Gtk.Text_View; use Gtk.Text_View;
with Gtk.Text_Buffer; use Gtk.Text_Buffer;
with Gtk.Text_Iter; use Gtk.Text_Iter;
with Gtk.Button; use Gtk.Button;
with Gtk.About_Dialog; use Gtk.About_Dialog;
package Aboutdialog1_Pkg is

   type Aboutdialog1_Record is new Gtk_About_Dialog_Record with record
      Textview1 : Gtk_Text_View;
   end record;
   type Aboutdialog1_Access is access all Aboutdialog1_Record'Class;

   procedure Gtk_New (Aboutdialog1 : out Aboutdialog1_Access);
   procedure Initialize (Aboutdialog1 : access Aboutdialog1_Record'Class);

end Aboutdialog1_Pkg;
