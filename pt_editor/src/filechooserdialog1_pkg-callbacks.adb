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
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;

with Ada.Text_IO; use Ada.Text_IO;

package body Filechooserdialog1_Pkg.Callbacks is

   use Gtk.Arguments;

   ---------------------------------
   -- On_Fileselection_Ok_Pressed --
   ---------------------------------

   procedure On_Fileselection_Ok_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      -- Note: Using the value 0 for the response, because in Windows
      -- the Gtk_Response_OK value has no effect
      Response(Filechooserdialog1_Pkg.Filechooserdialog1,0);
   end On_Fileselection_Ok_Pressed;

   ----------------------------------
   -- On_Fileselection_Ok_Activate --
   ----------------------------------

   procedure On_Fileselection_Ok_Activate
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      -- Note: Using the value 0 for the response, because in Windows
      -- the Gtk_Response_OK value has no effect
      Response(Filechooserdialog1_Pkg.Filechooserdialog1,0);
   end On_Fileselection_Ok_Activate;

   -------------------------------------
   -- On_Fileselection_Cancel_Pressed --
   -------------------------------------

   procedure On_Fileselection_Cancel_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Filechooserdialog1_Pkg.Filechooserdialog1,Gtk_Response_Close);
   end On_Fileselection_Cancel_Pressed;

   --------------------------------------
   -- On_Fileselection_Cancel_Activate --
   --------------------------------------

   procedure On_Fileselection_Cancel_Activate
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Response(Filechooserdialog1_Pkg.Filechooserdialog1,Gtk_Response_Close);
   end On_Fileselection_Cancel_Activate;

end Filechooserdialog1_Pkg.Callbacks;
