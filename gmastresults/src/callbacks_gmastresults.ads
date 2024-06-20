-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2000-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Yago Pereiro                                             --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------
with Gtk.Handlers;
pragma Elaborate_All (Gtk.Handlers);
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Tree_View_Column; use Gtk.Tree_View_Column;
with Gtk.Image_Menu_Item; use Gtk.Image_Menu_Item;
with Gtk.Button; use Gtk.Button;
with Gtk.GEntry; use Gtk.GEntry;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;

package Callbacks_Gmastresults is

   package Image_Menu_Item_Callback is new
     Gtk.Handlers.Callback (Gtk_Image_Menu_Item_Record);

   package Tree_Callback is new
     Gtk.Handlers.Callback (Gtk_Tree_View_Record);

   package Tree_Column_Callback is new
     Gtk.Handlers.Callback (Gtk_Tree_View_Column_Record);

   package Button_Callback is new
     Gtk.Handlers.Callback (Gtk_Button_Record);

   package Entry_Callback is new
     Gtk.Handlers.Callback (Gtk_Entry_Record);

   package Combo_Callback is new
     Gtk.Handlers.Callback (Gtk_Combo_Box_Text_Record);

end Callbacks_Gmastresults;
