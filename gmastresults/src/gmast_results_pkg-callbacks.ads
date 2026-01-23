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
with Gtk.Arguments;
with Gtk.Widget; use Gtk.Widget;

package Gmast_Results_Pkg.Callbacks is
   function On_Gmast_Results_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean;

   procedure On_System_Open_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_System_Save_As_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Exit1_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Results_Open_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Results_Save_As_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Contents_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_About_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class);

   procedure On_Tree_Transactions_Row_Activated
     (Object : access Gtk_Tree_View_Record'Class;
      Params : Gtk.Arguments.Gtk_Args);

   procedure On_Tree_Transactions_Click_Column
     (Object : access Gtk_Tree_View_Column_Record'Class);
      --Params : Gtk.Arguments.Gtk_Args);

end Gmast_Results_Pkg.Callbacks;
