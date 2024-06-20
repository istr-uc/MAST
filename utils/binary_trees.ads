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
generic
   type Element is private;
   with function "=" (E1,E2 : Element) return Boolean;
   with function "<" (E1,E2 : Element) return Boolean;
package Binary_Trees is

   type Node is private;
   type Binary_Tree is private;
   Null_Node : constant Node;
   Null_Tree : constant Binary_Tree;
   Incorrect_Node : exception;

   function Create
     (Root_Element : in Element;
      Left_Branch,
      Right_Branch : in Binary_Tree:=Null_Tree)
     return Binary_Tree;

   function Root
     (The_Tree : Binary_Tree) return Node;

   function Parent
     (The_Node : Node;
      The_Tree : Binary_Tree) return Node;

   function Left_Child
     (The_Node : Node;
      The_Tree : Binary_Tree) return Node;

   function Right_Child
     (The_Node : Node;
      The_Tree : Binary_Tree) return Node;

   function Item
     (The_Node : Node;
      The_Tree : Binary_Tree) return Element;

   procedure Add_In_Order
     (The_Element   : Element;
      The_Tree      : in out Binary_Tree);

   function Find
     (The_Element   : Element;
      Starting_From : Node;
      The_Tree      : Binary_Tree) return Node;
   -- returns Null_Node if not found

   function Find
     (The_Element   : Element;
      The_Tree      : Binary_Tree) return Node;
   -- starts from the root; returns Null_Node if not found

private

   type Cell;
   type Node is access Cell;
   Null_Node : constant Node := null;
   type Cell is record
      Left_Child,
      Right_Child,
      Parent     : Node;
      Contents : Element;
   end record;
   type Binary_Tree is record
      Root : Node;
   end record;
   Null_Tree : constant Binary_Tree:=(Root => Null_Node);

end Binary_Trees;
