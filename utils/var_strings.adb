-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
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

-- Oct. 2014. Changed to use Ada.Strings.Unbounded

with Ada.Text_IO, Ada.Characters.Handling;
use Ada;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body Var_Strings is

   function To_String     (V : Var_String) return String is
   begin
      return To_String(V.Str);
   end To_String;

   function To_Var_String (S : String)     return Var_String is
   begin
      return (Str=>To_Unbounded_String(S));
   end To_Var_String;

   function Length (V : Var_String) return Natural is
   begin
      return Length(V.Str);
   end Length;

   procedure Get_Line (V : out Var_String) is
   begin
      V.Str:=To_Unbounded_String(Text_IO.Get_Line);
   end Get_Line;

   procedure Put_Line (V : in Var_String) is
   begin
      Text_IO.Put_Line(To_String(V.Str));
   end Put_Line;

   procedure Put (V : in Var_String) is
   begin
      Text_IO.Put(To_String(V.Str));
   end Put;

   procedure Get_Line (F : in out Text_IO.File_Type; V : out Var_String) is
   begin
      V.Str:=To_Unbounded_String(Text_IO.Get_Line(F));
   end Get_Line;

   procedure Put_Line (F : in out Text_IO.File_Type; V : in Var_String) is
   begin
      Text_IO.Put_Line(F,To_String(V.Str));
   end Put_Line;

   procedure Put (F : in out Text_IO.File_Type; V : in Var_String) is
   begin
      Text_IO.Put(F,To_String(V.Str));
   end Put;

   function "&" (V1,V2 : Var_String) return Var_String is
   begin
      return (Str=>V1.Str&V2.Str);
   end "&";

   function "&" (V : Var_String; S : String) return Var_String is
   begin
      return (Str=>V.Str&S);      
   end "&";

   function "&" (S : String; V : Var_String) return Var_String is
   begin
      return (Str=>S&V.Str);      
   end "&";

   function "&" (V : Var_String; C : Character) return Var_String is
   begin
      return (Str=>V.Str&C);      
   end "&";


   function "=" (V1,V2 : Var_String) return Boolean is
   begin
      return V1.Str=V2.Str;
   end "=";

   function ">" (V1,V2 : Var_String) return Boolean is
   begin
      return V1.Str>V2.Str;
   end ">";

   function "<" (V1,V2 : Var_String) return Boolean is
   begin
      return V1.Str<V2.Str;
   end "<";

   function ">=" (V1,V2 : Var_String) return Boolean is
   begin
      return V1.Str>=V2.Str;
   end ">=";

   function "<=" (V1,V2 : Var_String) return Boolean is
   begin
      return V1.Str<=V2.Str;
   end "<=";


   function Element (V : Var_String; Index : Positive) return Character is
   begin
      if Index>Length(V.Str) then
         raise Constraint_Error;
      end if;
      return Element(V.Str,Index);
   end Element;


   function Slice (V : Var_String; Index1: Positive; Index2 : Natural)
                  return Var_String is
      Res : Var_String;
   begin
      if Index1>Length(V.Str)+1 or Index2>Length(V.Str) then
         raise Constraint_Error;
      end if;
      return (Str=>To_Unbounded_String(Slice(V.Str,Index1,Index2)));
   end Slice;


   function To_Upper (V : Var_String) return Var_String is
   begin
      return (Str=> To_Unbounded_String
	(Characters.Handling.To_Upper(To_String(V.Str))));
   end To_Upper;

   function To_Lower (V : Var_String) return Var_String is
   begin
      return (Str=> To_Unbounded_String
	(Characters.Handling.To_Lower(To_String(V.Str))));
   end To_Lower;


   procedure Translate_To_Upper (V : in out Var_String) is
   begin
      V.Str:=To_Unbounded_String
	(Characters.Handling.To_Upper(To_String(V.Str)));
   end Translate_To_Upper;

   procedure Translate_To_Lower (V : in out Var_String) is
   begin
      V.Str:=To_Unbounded_String
	(Characters.Handling.To_Lower(To_String(V.Str)));
   end Translate_To_Lower;

end Var_Strings;
