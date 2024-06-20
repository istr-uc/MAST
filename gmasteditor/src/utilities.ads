-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                           GMastEditor                             --
--          Graphical Editor for Modelling and Analysis              --
--                    of Real-Time Applications                      --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors : Michael Gonzalez Harbour                                --
--                                                                   --
-- Contact info: Michael Gonzalez       mgh@unican.es                --
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
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Gtk.Enums; use Gtk.Enums;

package Utilities is
   
   -- Set the text of a combo box text object to one of its rows
   procedure Set_Text_In_Combo_Box(Combo : Gtk_Combo_Box_Text; Text : String);
   
   -- set the popdown strings of a combo box text to the items 
   -- specified in the list
   procedure Set_Popdown_Strings
        (Combo : Gtk_Combo_Box_Text;
         List_Items: Gtk.Enums.String_List.Glist);

end Utilities;
