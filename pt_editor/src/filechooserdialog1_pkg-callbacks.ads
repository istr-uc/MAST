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

with Gtk.Arguments;
with Gtk.Widget; use Gtk.Widget;

package Filechooserdialog1_Pkg.Callbacks is
   procedure On_Fileselection_Ok_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Fileselection_Ok_Activate
     (Object : access Gtk_Button_Record'Class);

   procedure On_Fileselection_Cancel_Pressed
     (Object : access Gtk_Button_Record'Class);

   procedure On_Fileselection_Cancel_Activate
     (Object : access Gtk_Button_Record'Class);

end Filechooserdialog1_Pkg.Callbacks;
