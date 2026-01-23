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

with Gtk.Button; use Gtk.Button;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;

package Filechooserdialog1_Pkg is

   type Filechooserdialog1_Record is new Gtk_File_Chooser_Dialog_Record with record
      Fileselection_Ok : Gtk_Button;
      Fileselection_Cancel : Gtk_Button;
   end record;
   type Filechooserdialog1_Access is access all Filechooserdialog1_Record'Class;

   procedure Gtk_New (Filechooserdialog1 : out Filechooserdialog1_Access);
   procedure Initialize (Filechooserdialog1 : access Filechooserdialog1_Record'Class);

   Filechooserdialog1 : Filechooserdialog1_Access;

end Filechooserdialog1_Pkg;
