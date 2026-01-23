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
--          Yago Pereiro                                             --
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

with Ada.Text_IO, Var_Strings;
use Var_Strings;

package Mast.Timers is

   type System_Timer is abstract tagged private;

   procedure Set_Worst_Overhead
     (Timer : in out System_Timer;
      Overhead : Normalized_Execution_Time);
   procedure Set_Avg_Overhead
     (Timer : in out System_Timer;
      Overhead : Normalized_Execution_Time);
   procedure Set_Best_Overhead
     (Timer : in out System_Timer;
      Overhead : Normalized_Execution_Time);
   procedure Set_Processor_Name
     (Timer : in out System_Timer;
      The_Processor_Name : Var_String);
   function Worst_Overhead
     (Timer : System_Timer) return Normalized_Execution_Time;
   function Avg_Overhead
     (Timer : System_Timer) return Normalized_Execution_Time;
   function Best_Overhead
     (Timer : System_Timer) return Normalized_Execution_Time;
   function Processor_Name
     (Timer : System_Timer) return Var_String;
   
   procedure Print
     (File : Ada.Text_IO.File_Type;
      Timer : in out System_Timer;
      Indentation : Positive;
      Finalize    : Boolean:=False);

   procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Timer : in out System_Timer;
      Indentation : Positive;
      Finalize    : Boolean:=False) is abstract;
   
   procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Timer : in out System_Timer;
      Indentation : Positive;
      Finalize    : Boolean:=False) is abstract;

   type System_Timer_Ref is access System_Timer'Class;

   function Clone
     (Timer : System_Timer)
     return System_Timer_Ref is abstract;

   ---------------------
   -- Alarm_Clock
   ---------------------

   type Alarm_Clock is new System_Timer with private;

   overriding procedure Print
     (File : Ada.Text_IO.File_Type;
      Timer : in out Alarm_Clock;
      Indentation : Positive;
      Finalize    : Boolean:=False);

overriding   procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Timer : in out Alarm_Clock;
      Indentation : Positive;
      Finalize    : Boolean:=False);

overriding   procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Timer : in out Alarm_Clock;
      Indentation : Positive;
      Finalize    : Boolean:=False);

   overriding function Clone
     (Timer : Alarm_Clock)
     return System_Timer_Ref;

   ---------------------
   -- Ticker
   ---------------------

   type Ticker is new System_Timer with private;

   procedure Set_Period
     (Timer : in out Ticker;
      The_Period : Time);

   function Period
     (Timer : Ticker) return Time;

   overriding procedure Print
     (File : Ada.Text_IO.File_Type;
      Timer : in out Ticker;
      Indentation : Positive;
      Finalize    : Boolean:=False);

   overriding procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Timer : in out Ticker;
      Indentation : Positive;
      Finalize    : Boolean:=False);

   overriding procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Timer : in out Ticker;
      Indentation : Positive;
      Finalize    : Boolean:=False);

   overriding function Clone
     (Timer : Ticker)
     return System_Timer_Ref;

private

   type System_Timer is abstract tagged record
      Worst_Overhead,
      Avg_Overhead,
      Best_Overhead : Normalized_Execution_Time:=0.0;
      The_Processor_Name : Var_String:=Null_Var_String;
   end record;

   type Alarm_Clock is new System_Timer with null record;

   type Ticker is new System_Timer with record
      Period : Time:=Large_Time;
   end record;

end Mast.Timers;




