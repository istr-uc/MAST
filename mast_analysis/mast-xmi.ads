-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2024                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Julio Luis Medina      medinajl@unican.es                --
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


-- This package contains a variable with a copy of the MAST system,
--  which is used when printing xmi results to establish references
--  between elements.
--  It also contains a variable to keep track of the
--  number of Element_List items in the XMI file. This variable is used
--  to create references when creating end-to-end flows in an XMI file
-- Finally, there is an utility function to add a prefix to a name if 
--  necessary, to prevent duplicate names. If the name has not yet been 
--  registered, it is registered together with is prefix,
--  and the returned image is the same name. 
--  If the name was registered with the same perefix, the returned
--  image is the same name. 
--  If the name was registered for a different prefix, the return 
--  value is the name with the prefix.

with Mast.Systems, Var_Strings; 
use Mast.Systems, Var_Strings;
  
package Mast.XMI is
   
   procedure Set_XMI_System(The_System: System);
   
   function Get_XMI_System return System;
   
   procedure Set_XMI_Model_File(Model_File: Var_String);
   
   function Get_XMI_Model_File return Var_String;
   
   procedure Reset_Element_List;
   
   procedure Add_Element_List_Item;
   
   function Get_Size_Element_List return Natural;
   
   function XMI_Name_Image
     (Name: Var_String; Prefix: String) 
     return String;
   
end Mast.XMI;
