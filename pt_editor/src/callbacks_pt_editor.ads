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

with Gtk.Handlers;
pragma Elaborate_All (Gtk.Handlers);
with Gtk.Image_Menu_Item; use Gtk.Image_Menu_Item;
with Gtk.Radio_Button; use Gtk.Radio_Button;
with Gtk.Spin_Button; use Gtk.Spin_Button;
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Button; use Gtk.Button;
with Glib.Object; use Glib.Object;

package Callbacks_pt_editor is

   package Image_Menu_Item_Callback is new
     Gtk.Handlers.Callback (Gtk_Image_Menu_Item_Record);

   package Radio_Button_Callback is new
     Gtk.Handlers.Callback (Gtk_Radio_Button_Record);

   package Spin_Button_Callback is new
     Gtk.Handlers.Callback (Gtk_Spin_Button_Record);

   package Tree_View_Callback is new
     Gtk.Handlers.Callback (Gtk_Tree_View_Record);

   package Button_Callback is new
     Gtk.Handlers.Callback (Gtk_Button_Record);

   package Object_Callback is new
     Gtk.Handlers.Callback (GObject_Record);


end Callbacks_pt_editor;
