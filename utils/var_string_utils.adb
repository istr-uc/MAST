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

package body Var_String_Utils is

   function Find_Pos_Char_Unquoted(Char : Character;Line : Var_String)
                                  return Natural is
      Within_Quotes : Boolean:=False;
   begin
      for i in 1..Length(Line) loop
         if Element(Line,i)='"' then
            Within_Quotes:=not Within_Quotes;
         end if;
         if not Within_Quotes and then Element(Line,i)=Char then
            return i;
         end if;
      end loop;
      return 0;
   end Find_Pos_Char_Unquoted;

   function Find_Pos_Last_Char(Char : Character;Line : Var_String)
                              return Natural is
   begin
      for i in reverse 1..Length(Line) loop
         if Element(Line,i)=Char then
            return i;
         end if;
      end loop;
      return 0;
   end Find_Pos_Last_Char;

   function No_Quotes (S : Var_String) return Var_String is
   begin
      if Length(S)>=2 and then
        (Element(S,1)='"' and then Element(S,Length(S))='"')
      then
         return Slice(S,2,Length(S)-1);
      else
         return S;
      end if;
   end No_Quotes;


   function First_Word (Line : Var_String)
                       return Var_String is
      no_spaces : Var_String;
      pos_sp : Natural;
   begin
      for i in 1..Length(Line) loop
         if Element(Line,i)/=' ' then
            no_spaces:=Slice(Line,i,Length(Line));
            pos_sp := Find_Pos_Char_Unquoted(' ',no_spaces);
            if pos_sp=0 then
               return No_Quotes(no_spaces);
            else
               return No_Quotes(Slice (no_spaces,1,pos_sp-1));
            end if;
         end if;
      end loop;
      return Null_Var_String;
   end First_Word;

   function Delete_First_word (Line : Var_String)
                              return Var_String is
      No_Spaces : Var_String;
      Pos_Sp : Natural;
   begin
      for i in 1..Length(Line) loop
         if Element(Line,i)/=' ' then
            No_Spaces:=Slice(Line,i,Length(Line));
            Pos_Sp:=Find_Pos_Char_Unquoted(' ',No_Spaces);
            if Pos_Sp=0 then
               return Null_Var_String;
            else
               return Slice(No_Spaces,Pos_Sp,Length(No_Spaces));
            end if;
         end if;
      end loop;
      return Null_Var_String;
   end Delete_First_word;

end Var_String_Utils;
