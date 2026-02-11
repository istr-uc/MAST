-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2015                     --
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

package Mast is

   -- Common Types

   type Priority is range 1..2**15-1;

   type Preemption_Level is range 0..2**15-1;

   subtype Percentage is Float range 0.0..100.0;

   subtype Unrestricted_Percentage is Float;

   type Request_Policy is (Scan,Prioritized,FIFO,LIFO);

   type Delivery_Policy is (Scan,Random);

   type Distribution_Function is (Uniform, Poisson);

   type Transmission_Kind is (Simplex, Half_Duplex, Full_Duplex);

   type General_Analysis_Tools is (Holistic,
                                   Offset_Based_approx_w_pr,    --optimized
                                   Offset_Based_approx,         --unoptimized
                                   Offset_Based_slanted,        --jukka
                                   Offset_Based_brute_force);   --tindell

   type Analysis_Tools is record
      The_General_Analysis : General_Analysis_Tools;
      isLocal   : Boolean := False;
   end record;

   -- Time types

   type Absolute_Time is digits 15;
   -- Absolute time measured from an arbotrary time origin,
   -- in unspecified units

   type Time_Interval is digits 15;
   -- Time intervals in unspecified time units
   -- (generally microseconds)

   subtype Time is Time_Interval;

   Large_Time : constant Time_Interval := 1.0E100;
   Small_Time : constant Time_Interval := 1.0E-100;
   Epsilon    : constant Time_Interval := 1.0E-12;

   Default_Stop_Factor : constant Positive := 100;

   function "<" (left : Time_Interval; right : Time_Interval)
                 return Boolean;
   function "<=" (left : Time_Interval; right : Time_Interval)
                  return Boolean;
   function ">" (left : Time_Interval; right : Time_Interval)
                 return Boolean;
   function ">=" (left : Time_Interval; right : Time_Interval)
                  return Boolean;
   function "=" (left : Time_Interval; right : Time_Interval)
                 return Boolean;

   function igual (left : Time_Interval;
                       right : Time_Interval;
                       debug : Boolean)
                       return Boolean;


   function "+" (Abs_Time : Absolute_Time; Interval : Time_Interval)
                return Absolute_Time;

   function "+" (Interval : Time_Interval; Abs_Time : Absolute_Time)
                return Absolute_Time;

   function "-" (Abs_Time : Absolute_Time; Interval : Time_Interval)
                return Absolute_Time;

   function "-" (Abs_Time1,Abs_Time2 : Absolute_Time)
                return Time_Interval;

   function Ceiling (X: Time) return Time;
   function Floor   (X: Time) return Time;

   type Normalized_Execution_Time is digits 15;
   -- Real execution time is
   -- Normalized_Execution_Time/Processor_Speed

   Large_Execution_Time : constant Normalized_Execution_Time := 1.0E100;

   type Bit_Count is digits 15;

   Large_Bit_Count : constant Bit_Count := 1.0E100;

   type Processor_Speed is digits 6;

   function "/" (E : Normalized_Execution_Time; S : Processor_Speed)
                return Time;

   function "*" (T : Time; S : Processor_Speed)
                return Normalized_Execution_Time;


   type Throughput_Value is digits 6;

   function "*" (N : Normalized_Execution_Time; T : Throughput_Value)
                return Bit_Count;

   function "/" (B : Bit_Count; T : Throughput_Value)
                return Normalized_Execution_Time;

   subtype Date is String(1..19);

   -- General exceptions

   Incorrect_Object : exception;

   Internal_Inconsistency : exception;

   Object_Not_Found : exception;

   -- General exception message

   procedure Set_Exception_Message(Message : in String);

   function Get_Exception_Message return String;

   -- Global Debug Switch

   Global_MAST_Debug : Boolean := False;

   -- Special MAST_Benchmark Results Output Switch

   Mast_Benchmark_Output : Boolean := False;
   Mast_Benchmark_Output_Filename : string(1..200);

   -- Mast Version

   Version_String : constant String:="1.5.1.0";

end Mast;
