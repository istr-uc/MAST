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

with Var_Strings; use Var_Strings;

package Var_String_Utils is
   
   ----------------------------
   -- Find_Pos_Char_Unquoted --
   ----------------------------
   -- Find the position of the first occurrence of Char that is not within
   -- "" quotes, in the var_string Line. Returns 0 if not found

   function Find_Pos_Char_Unquoted
     (Char : Character;Line : Var_String)
     return Natural;
   
   
   ------------------------
   -- Find_Pos_Last_Char --
   ------------------------
   -- Find the position of the last occurrence of Char in var_string Line.
   -- Returns 0 if not found
   
   function Find_Pos_Last_Char
     (Char : Character; 
      Line : Var_String)
     return Natural;
   
   
   ---------------
   -- No_Quotes --
   ---------------
   -- Returns the var_string S without "" quotes, or  the complete S if
   -- it is not within quiotes.
   function No_Quotes (S : Var_String) return Var_String;
   
   
   ----------------
   -- First_Word --
   ----------------
   -- Returns the first word of Line unquoted, using a non quoted space as a
   -- delimiter and excluding any initial spaces. If no such word
   -- exists, it returns Null_Var_String.
   
   function First_Word 
     (Line : Var_String)
     return Var_String;
   
   -----------------------
   -- Delete_First_Word --
   -----------------------
   
   -- Returns the var_string Line without its first word and excluding
   -- any initial spaces.  It uses a non-quoted space as a
   -- delimiter. If no such word exists, or if Line had only one
   -- word, it returns Null_Var_String.
   
   function Delete_First_word 
     (Line : Var_String)
     return Var_String;
   
end Var_String_Utils;
