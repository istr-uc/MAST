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

with Ada.Text_IO;
use Ada.Text_IO;

with Var_Strings;

package body Mast is

   Exception_Message : Var_Strings.Var_String:=Var_Strings.Null_Var_String;

   -------------------------------------------------------------
   -- Boolean functions for Time_Interval type                --
   -- Redefined to avoid comparison with different precisions --
   -- Variables are stored as 64 bit floats, direct           --
   -- comparisons are performed in 80 bit registers (x86)     --
   -------------------------------------------------------------



   function "<" (left : Time_Interval; right : Time_Interval)
                 return Boolean is
      type Temp_Time_Interval is digits Time_Interval'Digits;
      a,b : Temp_Time_Interval;
   begin
      a := Temp_Time_Interval(left);
      b := Temp_Time_Interval(right);
      return (a < b);
   end "<";


   function "<=" (left : Time_Interval; right : Time_Interval)
                  return Boolean is
      type Temp_Time_Interval is digits Time_Interval'Digits;
      a,b : Temp_Time_Interval;
   begin
      a := Temp_Time_Interval(left);
      b := Temp_Time_Interval(right);
      return (a <= b);
   end "<=";


   function ">" (left : Time_Interval; right : Time_Interval)
                 return Boolean is
      type Temp_Time_Interval is digits Time_Interval'Digits;
      a,b : Temp_Time_Interval;
   begin
      a := Temp_Time_Interval(left);
      b := Temp_Time_Interval(right);
      return (a > b);
   end ">";


   function ">=" (left : Time_Interval; right : Time_Interval)
                  return Boolean is
      type Temp_Time_Interval is digits Time_Interval'Digits;
      a,b : Temp_Time_Interval;
   begin
      a := Temp_Time_Interval(left);
      b := Temp_Time_Interval(right);
      return (a >= b);
   end ">=";


   function "=" (left : Time_Interval; right : Time_Interval)
                 return Boolean is
   begin
      return abs(left-right) <= Time_Interval(10) * abs(left) * Time_Interval'Model_Epsilon;
   end "=";


   function igual (left : Time_Interval;
                       right : Time_Interval;
                       debug : Boolean)
                    return Boolean is
   begin
      if debug then
         Put_line("left ="&left'img);
         Put_line("right ="&right'img);
         Put_line("resta ="&Time_Interval'Image(left-right));
         Put_line("Epsilon ="& Time_Interval'Image(abs(left) * Time_Interval'Base'Model_Epsilon));
      end if;
      return abs(left-right) < abs(left) * Time_Interval'Base'Model_Epsilon;
   end igual;



   ---------
   -- "*" --
   ---------

   function "*"
     (T : Time;
      S : Processor_Speed)
     return Normalized_Execution_Time
   is
   begin
      return Normalized_Execution_Time(T)*Normalized_Execution_Time(S);
   end "*";

   ---------
   -- "*" --
   ---------

   function "*" (N : Normalized_Execution_Time; T : Throughput_Value)
                return Bit_Count
   is
   begin
      return Bit_Count(N*Normalized_Execution_Time(T));
   end "*";

   ---------
   -- "/" --
   ---------

   function "/"
     (E : Normalized_Execution_Time;
      S : Processor_Speed)
     return Time
   is
   begin
      return Time(E)/Time(S);
   end "/";

   ---------
   -- "/" --
   ---------

   function "/" (B : Bit_Count; T : Throughput_Value)
                return Normalized_Execution_Time
   is
   begin
      return Normalized_Execution_Time(B/Bit_Count(T));
   end "/";

   ---------
   -- "+" --
   ---------

   function "+"
     (Abs_Time : Absolute_Time;
      Interval : Time_Interval)
     return Absolute_Time
   is
   begin
      return Abs_Time+Absolute_Time(Interval);
   end "+";

   ---------
   -- "+" --
   ---------

   function "+"
     (Interval : Time_Interval;
      Abs_Time : Absolute_Time)
     return Absolute_Time
   is
   begin
      return Abs_Time+Absolute_Time(Interval);
   end "+";

   ---------
   -- "-" --
   ---------

   function "-"
     (Abs_Time : Absolute_Time;
      Interval : Time_Interval)
     return Absolute_Time
   is
   begin
      return Abs_Time-Absolute_Time(Interval);
   end "-";

   ---------
   -- "-" --
   ---------

   function "-"
     (Abs_Time1,Abs_Time2 : Absolute_Time)
     return Time_Interval
   is
   begin
      return Time_Interval(Abs_Time1)-Time_Interval(Abs_Time2);
   end "-";

   --------------
   -- Ceiling  --
   --------------

   function Ceiling(X: Time) return Time is
   begin
      if Abs(X-Time'Rounding(X))<Epsilon then
         return Time'Rounding(X);
      else
         return Time'Ceiling(X);
      end if;
   end Ceiling;

   ------------
   -- Floor  --
   ------------

   function Floor(X: Time) return Time is
   begin
      if Abs(X-Time'Rounding(X))<Epsilon then
         return Time'Rounding(X);
      else
         return Time'Floor(X);
      end if;
   end Floor;

   ----------------------------
   -- Set_Exception_Message  --
   ----------------------------

   procedure Set_Exception_Message(Message : in String)
   is
   begin
      Exception_Message:=Var_Strings.To_Var_String(Message);
   end Set_Exception_Message;

   ----------------------------
   -- Set_Exception_Message  --
   ----------------------------

   function Get_Exception_Message return String is
   begin
      return Var_Strings.To_String(Exception_Message);
   end Get_Exception_Message;

end Mast;

