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

with Ada.Characters.Handling; use Ada.Characters.Handling;

package body Check_Operations is

   ---------------------------
   -- Is_Correct_Identifier --
   ---------------------------

   function Is_Correct_Identifier(Name : String) return Boolean is
      C : Character;
   begin
      if Name'Length>0 and then To_Upper(Name(Name'First)) not in 'A'..'Z'
      then
         return False;
      end if;
      for I in Name'Range loop
         C:=Name(I);
         if not (C in 'A'..'Z' or else C in 'a'..'z' or else
                   C in '0'..'9' or else C='.' or else C='_')
         then
            return False;
         end if;
      end loop;
      return True;
   end Is_Correct_Identifier;


   ---------------------
   -- Is_Correct_Time --
   ---------------------

   function Is_Correct_Time (Value : String) return Boolean is
      F : Float range 0.0..Float'Last;
   begin
      F:=Float'Value(Value);
      return True;
   exception
      when Constraint_Error =>
         return False;
   end Is_Correct_Time;

   ---------------------
   -- Is_Correct_Prio --
   ---------------------

   function Is_Correct_Prio (Value : String) return Boolean is
      I : Positive;
   begin
      I:=Positive'Value(Value);
      return True;
   exception
      when Constraint_Error =>
         return False;
   end Is_Correct_Prio;

end Check_Operations;
