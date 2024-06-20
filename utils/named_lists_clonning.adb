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
package body Named_Lists_Clonning is

   -----------
   -- Clone --
   -----------

   procedure Clone
     (Original_List : in Lists.List;
      The_Copy : out Lists.List)
   is
      Iterator : Lists.Iteration_Object;
      E, Copy_Of_E : Element;

   begin
      Lists.Rewind(Original_List,Iterator);
      for I in 1..Lists.Size(Original_List) loop
         Lists.Get_Next_Item(E,Original_List,Iterator);
         Clone(E,Copy_Of_E);
         Lists.Add(Copy_Of_E,The_Copy);
      end loop;
   end Clone;

end Named_Lists_Clonning;

