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

package body Dialog_3_Pkg.Callbacks is

   use Gtk.Arguments;

   -------------------------------
   -- On_Dialog_Button1_Pressed --
   -------------------------------

   procedure On_Dialog_Button1_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Dialog_3_Pkg.Dialog_3,Gtk_Response_Yes);
   end On_Dialog_Button1_Pressed;

   ---------------------------------
   -- On_Dialog_Button2_Pressed --
   ---------------------------------

   procedure On_Dialog_Button2_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Dialog_3_Pkg.Dialog_3,Gtk_Response_No);
   end On_Dialog_Button2_Pressed;

   ---------------------------------
   -- On_Dialog_Button3_Pressed --
   ---------------------------------

   procedure On_Dialog_Button3_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Dialog_3_Pkg.Dialog_3,Gtk_Response_Cancel);
   end On_Dialog_Button3_Pressed;

   -----------------------------
   -- On_Dialog_3_Delete_Event --
   -----------------------------

   function On_Dialog_3_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean
   is
      Arg1 : Gdk_Event := To_Event (Params, 1);
   begin
      return False;
   end On_Dialog_3_Delete_Event;

end Dialog_3_Pkg.Callbacks;
