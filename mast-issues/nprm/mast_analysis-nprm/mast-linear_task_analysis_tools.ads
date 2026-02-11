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
--          Juan Maria Rivas       rivasjm@unican.es                 --
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

with Mast, Mast.Systems, Mast.Linear_Translation;

generic
   In_Max_Processors : Natural;
   In_Max_Transactions : Natural;
   In_Max_Tasks_Per_Transaction : Natural;

package Mast.Linear_Task_Analysis_Tools is

   type Processor_ID is new Natural;
   type Transaction_ID is new Natural;
   type Task_ID is new Natural;

   type Long_Int is range -(2 ** 31 - 1) .. 2 ** 31 - 2;

   Max_Processors            : constant Processor_ID   :=
      Processor_ID (In_Max_Processors);
   Max_Transactions          : constant Transaction_ID :=
      Transaction_ID (In_Max_Transactions);
   Max_Tasks_Per_Transaction : constant Task_ID        :=
      Task_ID (In_Max_Tasks_Per_Transaction);

   subtype Processor_ID_Type is Processor_ID range
      0 .. Processor_ID (Max_Processors);
   subtype Transaction_ID_Type is Transaction_ID range
      0 .. Transaction_ID (Max_Transactions);
   subtype Task_ID_Type is Task_ID range
      0 .. Task_ID (Max_Tasks_Per_Transaction);

   package Translation is new Linear_Translation (
      Processor_ID_Type,
      Transaction_ID_Type,
      Task_ID_Type,
      Processor_ID (Max_Processors),
      Transaction_ID (Max_Transactions),
      Task_ID (Max_Tasks_Per_Transaction));

   use Translation;

   ---------------------
   -- Distributed_RTA --
   ---------------------

   procedure Distributed_RTA
     (The_System                       : in out Mast.Systems.System;
      Verbose                          : in Boolean  := True;
      Stop_Factor_When_Not_Schedulable : in Positive :=
        Mast.Default_Stop_Factor);

   ----------------------------------------
   -- Task Analysis tools procedure type --
   ----------------------------------------

   -- I 	: Transaction ID (End-to-End Flow ID)
   -- J 	: Task ID (Step ID), inside I transaction
   -- Changes_Made	: True if the Response Time of the Task is modified
   -- Stop_Factor_When_Not_Schedulable : Establised analysis bound as:
   -- 		Rij > Stop_Factor_When_Not_Schedulable*EDi
   --		If bound is surpassed, then Rij = Large_Time (infinite)
   -- Over_Analysis_Bound : 	True if analysis bound is surpassed, then
   --				analysis loop is finished
   -- Verbose	: If True, aditional messages are shown on screen

   type Task_Analysis_Tool is access procedure
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   type Processor_Analysis_Accesses is
     array (1 .. Max_Processors) of Task_Analysis_Tool;

   procedure Initialize_Processor_Analysis_Accesses
     (The_System         : Mast.Systems.System;
      My_System          : Translation.Linear_Transaction_System;
      The_Accesses_Array : in out Processor_Analysis_Accesses;
      Verbose            : Boolean);

   ------------------------------
   -- Task analysis procedures --
   ------------------------------

   procedure Holistic_Task_FP
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Holistic_Task_EDF_Local
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Holistic_Task_EDF_Global
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_approx_w_pr_Task_FP	--previously Optimized
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_approx_Task_FP	--previously Unoptimized
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_Slanted_Task_FP	--Jukka
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_Brute_Force_Task_FP	--Original Tindell
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_approx_Task_EDF_Local
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_approx_w_pr_Task_EDF_Local
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   procedure Offset_Based_approx_Task_EDF_Global
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True);

   --Auxiliary global variables for offsets

   Aux_Tij, Aux_Cij, Aux_Cbij :
     array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;


   --Auxiliary Functions

   function img (Number : Long_Int) return String;



end Mast.Linear_Task_Analysis_Tools;
