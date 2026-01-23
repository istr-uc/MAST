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

with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Button; use Gtk.Button;
package Progress_Dialog_Pkg is

   type Progress_Dialog_Record is new Gtk_Dialog_Record with record
      Alignment12 : Gtk_Alignment;
      Progress_Ok : Gtk_Button;
   end record;
   type Progress_Dialog_Access is access all Progress_Dialog_Record'Class;

   procedure Gtk_New (Progress_Dialog : out Progress_Dialog_Access);
   procedure Initialize (Progress_Dialog : access Progress_Dialog_Record'Class);

end Progress_Dialog_Pkg;
