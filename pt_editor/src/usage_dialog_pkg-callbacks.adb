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

with System; use System;
with Glib; use Glib;
with Gdk.Event; use Gdk.Event;
with Gdk.Types; use Gdk.Types;
with Gtk.Accel_Group; use Gtk.Accel_Group;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Style; use Gtk.Style;
with Gtk.Widget; use Gtk.Widget;

package body Usage_Dialog_Pkg.Callbacks is

   use Gtk.Arguments;

   -------------------------------------
   -- On_Usage_Cancel_Ebutton_Pressed --
   -------------------------------------

   procedure On_Usage_Cancel_Ebutton_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Usage_Dialog_Pkg.Usage_Dialog,Gtk_Response_Cancel);
   end On_Usage_Cancel_Ebutton_Pressed;

   --------------------------------
   -- On_Usage_Ok_Button_Pressed --
   --------------------------------

   procedure On_Usage_Ok_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin

      Response(Usage_Dialog_Pkg.Usage_Dialog,Gtk_Response_OK);
   end On_Usage_Ok_Button_Pressed;

end Usage_Dialog_Pkg.Callbacks;
