-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                           GMastEditor                             --
--          Graphical Editor for Modelling and Analysis              --
--                    of Real-Time Applications                      --
--                                                                   --
--                       Copyright (C) 2005-2026                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors : Pilar del Rio                                           --
--           Michael Gonzalez                                        --
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
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gtk.Tree_Model; use Gtk.Tree_Model;
with Glib; use Glib;
with Ada.Text_IO; use Ada.Text_IO;
with Var_Strings; use Var_Strings;
with Mast.Graphs.Links;

with Mast.Transactions;
use type Mast.Transactions.Transaction_Ref;

package body Utilities is

   ---------------------------
   -- Set_Text_In_Combo_Box --
   ---------------------------

   procedure Set_Text_In_Combo_Box(Combo : Gtk_Combo_Box_Text; Text : String) 
   is
      Index,I : Gint:=0;
      Model : Gtk.Tree_Model.Gtk_Tree_Model;
      Iter : Gtk_Tree_Iter;
   begin
      -- obtain model
      Model:=Combo.Get_Model;
      if Model/=Null_Gtk_Tree_Model then
	 -- iterate model
	 Iter:=Get_Iter_First(Model);
	 Index:=-1;
	 I:=0; -- first row is 0
	 while Iter/=Null_Iter and then Index=-1 loop
	    -- find index of row containing the text 
	    if Get_String(Model,Iter,0)=Text then
	       Index:=I;
	    end if;
	    Next(Model,Iter);
	    I:=I+1;
	 end loop;
      end if;
      Set_Active(Combo,Index);
      Show_All(Combo);
   end Set_Text_In_Combo_Box;
   
   -----------------------------
   -- Set_Popdown_Strings     --
   -----------------------------
   procedure Set_Popdown_Strings
        (Combo : Gtk_Combo_Box_Text;
         List_Items: Gtk.Enums.String_List.Glist)
   is
   begin
      for I in 0..String_List.Length(List_Items)-1 loop
	 Combo.Append_Text(String_List.Nth_Data(List_Items,I));
      end loop;
   end Set_Popdown_Strings;
   
   -- mgh 2026: added de following procedure to populate a list with the 
   -- external and internal events of a transaction
   ------------------------------------
   -- Populate_List_With_Event_Names --
   ------------------------------------
   procedure Populate_List_With_Event_Names
     (List_Items: in out Gtk.Enums.String_List.Glist;
      Trans_Ref : Mast.Transactions.Transaction_Ref) 
   is
      Eve_Ref    : Mast.Graphs.Link_Ref;
      Eve_Index  : Mast.Transactions.Link_Iteration_Object;
      Eve_Name   : Var_Strings.Var_String;
   begin
      Free_String_List(List_Items);
      
      -- We search Events (External and Internal) of the transaction
      -- and show them in Ref_Event_Combo
      Mast.Transactions.Rewind_External_Event_Links
        (Trans_Ref.all,
         Eve_Index);
      for I in
        1 ..
        Mast.Transactions.Num_Of_External_Event_Links
        (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_External_Event_Link
           (Trans_Ref.all,
            Eve_Ref,
            Eve_Index);
         Eve_Name := Mast.Graphs.Name (Eve_Ref.all);
         String_List.Append (List_Items, To_String (Eve_Name));
      end loop;
      Mast.Transactions.Rewind_Internal_Event_Links
        (Trans_Ref.all,
         Eve_Index);
      for I in
        1 ..
        Mast.Transactions.Num_Of_Internal_Event_Links
          (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,
            Eve_Ref,
            Eve_Index);
         Eve_Name := Mast.Graphs.Name (Eve_Ref.all);
         String_List.Append (List_Items, To_String (Eve_Name));
      end loop;
      
   end Populate_List_With_Event_Names;
   
end Utilities;
