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
with Mast.Processing_Resources, Mast.HOSPA_Parameters, Mast.Linear_Translation, Priority_Queues, Mast.Tools.Schedulability_Index,
  Mast.Scheduling_Parameters, Mast.Scheduling_Policies, Mast.Tools;

with Ada.Text_IO,
  Mast.Max_Numbers, Ada.Float_Text_IO;

use type Mast.Tools.Schedulability_Index.Index;
use Ada.Text_IO, Ada.Float_Text_IO;

package body Mast.Linear_Scheduling_Parameters_Assignment_Tools is

   ATC_Enabled : constant Boolean := False;
   Debug       : constant Boolean := false;
   My_Verbose  : constant Boolean := False;

   type Processor_ID is new Natural;
   type Transaction_ID is new Natural;
   type Task_ID is new Natural;

   procedure HOSPA
     (The_System : in out Mast.Systems.System;
      The_Tool   : Mast.Tools.Worst_Case_Analysis_Tool;
      Verbose    : Boolean := True)
   is

      Optimize : Boolean;

      K                                : HOSPA_Parameters.K_Pair;
      Ka, Kr                           : HOSPA_Parameters.K_Type;
      Analysis_Stop_Time               : constant Duration                :=
         HOSPA_Parameters.Get_Analysis_Stop_Time;
      Max_Iter                         : Integer;
      Schedulable, Overall_Schedulable : Boolean                 := False;
      Counter_Of_Iterations            : Integer                 := 0;
      Counter_Of_Aborted_Analysis      : Integer                 := 0;
      Optimizing                       : Boolean                 := False;
      Overiteration                    : Integer;
      Stop_Algorithm                   : Boolean;
      Stop_Factor_When_not_Schedulable : Positive;
      Optimum_Sched_Index, Sched_Index : Mast.Tools.Schedulability_Index.Index
         := Mast.Tools.Schedulability_Index.Lower_Index;
      Max_Processors                   : constant Processor_ID   :=
         Processor_ID (Processing_Resources.Lists.Size
                          (The_System.Processing_Resources));
      Max_Transactions                 : constant Transaction_ID :=
         Transaction_ID ((Mast.Max_Numbers.Calculate_Max_Transactions
                             (The_System)));
      Max_Tasks_Per_Transaction        : constant Task_ID        :=
         Task_ID (Mast.Max_Numbers.Calculate_Max_Tasks_Per_Transaction
                     (The_System));

      subtype Processor_ID_Type is Processor_ID range 0 .. Max_Processors;
      subtype Transaction_ID_Type is Transaction_ID range
         0 .. Max_Transactions;
      subtype Task_ID_Type is Task_ID range 0 .. Max_Tasks_Per_Transaction;
      package Translation is new Linear_Translation (
         Processor_ID_Type,
         Transaction_ID_Type,
         Task_ID_Type,
         Max_Processors,
         Max_Transactions,
         Max_Tasks_Per_Transaction);
      use Translation;
      My_System, My_Back_Up_System : Translation.Linear_Transaction_System;
      type List_For_Tasks is
        array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction)
               of Translation.Priority_Assignment_Vars;
      type List_For_Transactions is
        array (Transaction_ID_Type range 1 .. Max_Transactions)
               of List_For_Tasks;
      Pavs : List_For_Transactions;

      -------------------------------------
      -- Convert_Deadlines_To_Priorities --
      -------------------------------------

      procedure Convert_Deadlines_To_Priorities is

         Queue_Length :
           array (Processor_ID_Type range 1 .. Max_Processors) of Natural;
         pragma Unreferenced (Queue_Length);

         List_Of_Min_VP :
           array (Processor_ID_Type range 1 .. Max_Processors)
                  of Virtual_Priority;

         List_Of_Min_P :
           array (Processor_ID_Type range 1 .. Max_Processors) of Priority;

         List_Of_Max_P :
           array (Processor_ID_Type range 1 .. Max_Processors) of Priority;

         Optimization_In_Processor :
           array (Processor_ID_Type range 1 .. Max_Processors) of Boolean;
         pragma Unreferenced (Optimization_In_Processor);

         type Deadline_Element is record
            Transaction : Transaction_ID_Type;
            Action      : Task_ID_Type;
         end record;

         package Deadlines_Lists is new Priority_Queues (
            Element => Deadline_Element,
            Priority => Time,
            ">" => "<",
            "=" => "=");

         -- use Deadlines_Lists;

         Lists_For_Processors :
           array (Processor_ID_Type range 1 .. Max_Processors)
                  of Deadlines_Lists.Queue;

         Item          : Deadline_Element;
         Next_Priority : Virtual_Priority;
         Deadline      : Time;

         Empty_Lists : Boolean;

         ----------------------
         -- Priority_Mapping --
         ----------------------

         procedure Priority_Mapping is

            type Priority_Element is record
               Transaction : Transaction_ID_Type;
               Action      : Task_ID_Type;
            end record;

            package VP_Lists is new Priority_Queues (
               Element => Priority_Element,
               Priority => Virtual_Priority,
               ">" => ">",
               "=" => "=");

            -- use VP_Lists;

            package P_Lists is new Priority_Queues (
               Element => Priority_Element,
               Priority => Priority,
               ">" => ">",
               "=" => "=");

            -- use P_Lists;

            Lists_For_VP :
              array (Processor_ID_Type range 1 .. Max_Processors)
                     of VP_Lists.Queue;
            Lists_For_P  :
              array (Processor_ID_Type range 1 .. Max_Processors)
                     of P_Lists.Queue;

            Item1, Item2       : Priority_Element;
            Max_P, Min_P       : Priority;
            Max_VP, Min_VP, VP : Virtual_Priority;

         begin

            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when My_System (I).Ni = 0;
               for J in 1 .. My_System (I).Ni loop
                  Item1 := (Transaction => I, Action => J);
                  if not My_System (I).The_Task (J).Pav.Hard_Prio
                    and then not My_System (I).The_Task (J).Pav.Is_Polling
                  then
                     if My_System (I).The_Task (J).Pav.Preassigned then
                        P_Lists.Enqueue
                          (Item1,
                           My_System (I).The_Task (J).Pav.Preassigned_Prio,
                           Lists_For_P (My_System (I).The_Task (J).Procij));
                     else
                        VP_Lists.Enqueue
                          (Item1,
                           My_System (I).The_Task (J).Pav.Virtual_Prio,
                           Lists_For_VP (My_System (I).The_Task (J).Procij));
                     end if;
                  end if;
               end loop;
            end loop;

            for I in Processor_ID_Type range 1 .. Max_Processors loop
               Min_P  := List_Of_Max_P (I);
               Min_VP := Max_Virtual_Priority;
               -- Set minumum priorities to maximum values
               while not VP_Lists.Empty (Lists_For_VP (I)) loop
                  VP_Lists.Dequeue (Item2, VP, Lists_For_VP (I));
                  if VP <= Min_VP then
                     -- New stage
                     Max_P  := Min_P;
                     Max_VP := Min_VP;
                     loop
                        if not P_Lists.Empty (Lists_For_P (I)) then
                           P_Lists.Dequeue (Item1, Min_P, Lists_For_P (I));
                           Min_P  := Priority'Max (Min_P, List_Of_Min_P (I));
                           Min_VP :=
                             My_System (Item1.Transaction).The_Task (
                             Item1.Action).Pav.Virtual_Prio;
                           if VP > Min_VP then
                              exit;
                           end if;
                        else
                           Min_P  := List_Of_Min_P (I);
                           Min_VP := List_Of_Min_VP (I);
                           exit;
                        end if;
                     end loop;
                  end if;
                  if Debug then
                     Put ("   VP = " & Virtual_Priority'Image (VP));
                     Put ("   Max_P = " & Priority'Image (Max_P));
                     Put ("   Min_P = " & Priority'Image (Min_P));
                     Put ("   Max_VP = " & Virtual_Priority'Image (Max_VP));
                     Put_Line
                       ("   Min_VP = " & Virtual_Priority'Image (Min_VP));
                  end if;

                  My_System (Item2.Transaction).The_Task (Item2.Action).Prioij
                     :=
                    Priority (Long_Float'Floor
                                 ((Long_Float (VP) - Long_Float (Min_VP)) /
                                  (Long_Float (Max_VP) -
                                   Long_Float (Min_VP) +
                                   1.0) *
                                  (Long_Float (Max_P) -
                                   Long_Float (Min_P) +
                                   1.0) +
                                  Long_Float (Min_P)));

                  if Debug then
                     Put_Line
                       ("   Priority Assigned = " &
                        Priority'Image
                           (My_System (Item2.Transaction).The_Task (
                       Item2.Action).Prioij));
                  end if;
               end loop;
            end loop;
         end Priority_Mapping;

      begin

         --Put_line ("DEBUG : New convert deadlines to priorities");
         Empty_Lists := True;

         for I in Processor_ID_Type range 1 .. Max_Processors loop
            Optimization_In_Processor (I) := True;
         end loop;

         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               if not My_System (I).The_Task (J).Pav.Hard_Prio
                 and then not My_System (I).The_Task (J).Pav.Is_Polling
               then
                  Item := (Transaction => I, Action => J);
                  Deadlines_Lists.Enqueue
                    (Item,
                     My_System (I).The_Task (J).Pav.D_0,
                     Lists_For_Processors (My_System (I).The_Task (J).Procij));
                  Empty_Lists := False;
               end if;
            end loop;
         end loop;

         if not Empty_Lists then
            for I in Processor_ID_Type range 1 .. Max_Processors loop
               declare
                  J                   : Integer  := 0;
                  Background_Priority : Priority := Priority'First;
               begin
                  while not Deadlines_Lists.Empty (Lists_For_Processors (I))
                  loop
                     J := J + 1;
                     Deadlines_Lists.Dequeue
                       (Item,
                        Deadline,
                        Lists_For_Processors (I));
                     if J = 1 then
                        Next_Priority := Max_Virtual_Priority;
                     else
                        Next_Priority :=
                           Virtual_Priority'Pred (Next_Priority);
                     end if;
                     My_System (Item.Transaction).The_Task (Item.Action).Pav.
                       Virtual_Prio := Next_Priority;
                     if Debug then
                        Put
                          (" Next_VP = " &
                           Virtual_Priority'Image (Next_Priority));
                        Put (" with Deadline = " & Time'Image (Deadline));
                        Put (" at the position " & Integer'Image (J));
                        Put_Line
                          (" Preasssigned=" &
                           Boolean'Image
                              (My_System (Item.Transaction).The_Task (
                          Item.Action).Pav.Preassigned));
                     end if;
                     if
                          My_System (Item.Transaction).The_Task (Item.Action).
                          Pav.Preassigned
                     then
                        -- Check if the optimum priority assigment will be
                        -- performed for this processor
                        Optimization_In_Processor (I) := False;
                     end if;
                     if
                          My_System (Item.Transaction).The_Task (Item.Action).
                          Pav.S_P_Ref.all in
                          Scheduling_Parameters.Sporadic_Server_Policy'Class
                     then
                        begin
                           if Background_Priority <=
                              Mast.Scheduling_Parameters.Background_Priority
                                 (
                                Mast.Scheduling_Parameters.
                                Sporadic_Server_Policy (
                                My_System (Item.Transaction).The_Task (
                                Item.Action).Pav.S_P_Ref.all))
                           then
                              Background_Priority :=
                                Mast.Scheduling_Parameters.Background_Priority
                                (
                                Mast.Scheduling_Parameters.
                                Sporadic_Server_Policy (
                                My_System (Item.Transaction).The_Task (
                                Item.Action).Pav.S_P_Ref.all)) +
                                1;
                           end if;
                        exception
                           when Constraint_Error =>
                              Background_Priority :=
                              Mast.Scheduling_Parameters.Background_Priority
                                (
                                Mast.Scheduling_Parameters.
                                Sporadic_Server_Policy (
                                My_System (Item.Transaction).The_Task (
                                Item.Action).Pav.S_P_Ref.all));
                        end;
                     end if;
                  end loop;
                  Queue_Length (I) := J;
                  -- Store the number of task per processor for optimizing
                  -- priority assignment
                  List_Of_Min_VP (I) := Next_Priority;

                  if Background_Priority >
                     Scheduling_Policies.Min_Priority
                        (
                       My_System (Item.Transaction).The_Task (Item.Action).Pav.
                       S_Policy_Ref.all)
                  then
                     List_Of_Min_P (I) := Background_Priority;
                  else
                     List_Of_Min_P (I) :=
                        Scheduling_Policies.Min_Priority
                          (
                       My_System (Item.Transaction).The_Task (Item.Action).Pav.
                       S_Policy_Ref.all);
                  end if;
                  -- Store the minimum priority for each processor
                  List_Of_Max_P (I) :=
                     Scheduling_Policies.Max_Priority
                       (
                    My_System (Item.Transaction).The_Task (Item.Action).Pav.
                    S_Policy_Ref.all);
                  -- Store the maximum priority for each processor
                  if J >
                     Integer (List_Of_Max_P (I) - List_Of_Min_P (I) + 1)
                  then
                     -- Check if the optimum priority assigment will be
                     -- performed for this processor
                     Optimization_In_Processor (I) := False;
                  end if;
               end;
            end loop;

            Priority_Mapping;

         end if;

      end Convert_Deadlines_To_Priorities;

      -------------------------------------------
      -- Local to Global Deadlines  -------------
      -- My_System : Local SDij to Global SDij --
      -------------------------------------------

      procedure Local_To_Global_Deadlines is

         I, Extra : Transaction_ID_Type;
         Sum_D    : Time;

      begin

         I := 1;
         while My_System (I).Ni /= 0 loop
            Extra := 0;
            for J in Transaction_ID_Type range (I + 1) .. Max_Transactions
            loop
               exit when My_System (J).Transaction_Id /=
                         My_System (I).Transaction_Id;
               Extra := Extra + 1;
            end loop;

            Sum_D := 0.0;
            for K in 0 .. Extra loop
               for J in 1 .. My_System (I + K).Ni loop

                  if not (My_System (I + K).The_Task (J).Pav.Preassigned and then
                            (My_System (I + K).The_Task (J).Schedij =
                               EDF_Global))

                  then

                     Sum_D := Sum_D + My_System (I).The_Task (J).SDij;

                  end if;

                  if not My_System (I + K).The_Task (J).Pav.Preassigned then
                     if My_System (I + K).The_Task (J).Schedij =
                        EDF_Global or else HOSPA_Parameters.Get_Force_Global_Assignment
                     then
                        My_System (I + K).The_Task (J).SDij := Sum_D;
                     end if;
                  end if;

               end loop;
            end loop;
            exit when (I + Extra + 1) not  in Transaction_ID_Type;
            I := I + Extra + 1;
         end loop;

      end Local_To_Global_Deadlines;


      procedure Check_Global_Deadlines is
         I, Extra : Transaction_ID_Type;
         Prev_D : Time;
      begin
         I := 1;
         while My_System (I).Ni /= 0 loop
            Extra := 0;
            for J in Transaction_ID_Type range (I + 1) .. Max_Transactions
            loop
               exit when My_System (J).Transaction_Id /=
                         My_System (I).Transaction_Id;
               Extra := Extra + 1;
            end loop;

            Prev_D := 0.0;
            for K in 0 .. Extra loop
               for J in 1 .. My_System (I + K).Ni loop
                  if My_System (I + K).The_Task(J).Schedij = EDF_Global then
                     if My_System (I + K).The_Task(J).SDij < Prev_D then
                        Put("WARNING : Global Deadline inconsistency in task");
                        Put_Line(Transaction_ID_Type'Image(I)&","
                                 &Task_ID_Type'Image(J));
                     end if;
                     Prev_D := My_System (I + K).The_Task(J).SDij;
                  end if;
               end loop;
            end loop;

            exit when (I + Extra + 1) not  in Transaction_ID_Type;
            I := I + Extra + 1;
         end loop;

      end Check_Global_Deadlines;


      procedure Prio_to_Deadlines is
         I, Extra : Transaction_ID_Type;
         Sum_Prio : Natural;
         Dij      : Time;
      begin
         I := 1;
         while My_System (I).Ni /= 0 loop

            Extra := 0;
            for J in Transaction_ID_Type range (I + 1) .. Max_Transactions
            loop
               exit when My_System (J).Transaction_Id /=
                         My_System (I).Transaction_Id;
               Extra := Extra + 1;
            end loop;

            Sum_Prio := 0;
            for K in 0 .. Extra loop
               for J in 1 .. My_System (I + K).Ni loop
                  Sum_Prio := Sum_Prio +
                              Natural (My_System (I + K).The_Task (J).Prioij);
                  if My_System (I + K).The_Task (J).Dij /= Large_Time then
                     Dij := My_System (I + K).The_Task (J).Dij;
                  end if;
               end loop;
            end loop;

            for K in 0 .. Extra loop
               for J in 1 .. My_System (I + K).Ni loop
                  My_System (I + K).The_Task (J).SDij := Dij *
                                                         Time (Natural (
                    My_System (I + K).The_Task (J).Prioij) /
                                                               Sum_Prio);
               end loop;
            end loop;

            exit when (I + Extra + 1) not  in Transaction_ID_Type;
            I := I + Extra + 1;
         end loop;
      end Prio_to_Deadlines;
      pragma Unreferenced (Prio_to_Deadlines);

      --------------------
      -- Save Deadlines --
      --------------------

      -- Save Deadlines Pav.D_0 -> SDij
      procedure Save_Deadlines is
      begin
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            -- mgh: feb 2025, added the "exit when" condition to exit
            -- the loop after the last valid transaction has been processed
            for J in Task_ID_Type range 1 .. Max_Tasks_Per_Transaction loop
               exit when My_System (I).Ni = 0;
               if not My_System (I).The_Task (J).Pav.Preassigned then
                  My_System (I).The_Task (J).SDij :=
                    My_System (I).The_Task (J).Pav.D_0;
               end if;
            end loop;
         end loop;
      end Save_Deadlines;

      ---------------
      -- Save_Pavs --
      ---------------

      procedure Save_Pavs is
      begin
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            for J in Task_ID_Type range 1 .. Max_Tasks_Per_Transaction loop
               Pavs (I) (J)  := My_System (I).The_Task (J).Pav;
            end loop;
         end loop;
      end Save_Pavs;

      ------------------
      -- Restore_Pavs --
      ------------------

      procedure Restore_Pavs is
      begin
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            for J in Task_ID_Type range 1 .. Max_Tasks_Per_Transaction loop
               My_System (I).The_Task (J).Pav := Pavs (I) (J);
            end loop;
         end loop;
      end Restore_Pavs;

      -------------------------------
      -- Initialize_Deadlines_USER --
      -------------------------------

      procedure Initialize_Deadlines_USER is

         procedure USER_Preinitialization is
            Max_D : Time;
         begin

            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when My_System (I).Ni = 0;
               for J in 1 .. My_System (I).Ni loop
                  My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                    My_System (I).The_Task (J).Prioij;
                  My_System (I).The_Task (J).Pav.Optimum_Prio :=
                    My_System (I).The_Task (J).Prioij;
                  My_System (I).The_Task (J).Pav.D_1              :=
                    My_System (I).The_Task (J).SDij;
               end loop;
            end loop;

            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when My_System (I).Ni = 0;
               Max_D := Large_Time;
               for J in 1 .. My_System (I).Ni loop

                  -- Mark the actions with deadlines to calculate factors
                     if not My_System (I).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        if My_System (I).The_Task (J).Dij /= Large_Time and then
                          My_System (I).The_Task (J).Dij < Max_D
                        then
                           My_System (I).The_Task (J).Pav.Calculate_Factor
                             := True;
                           My_System (I).The_Task (J).Pav.D_0 :=
                             My_System (I).The_Task (J).Dij;
                           My_System (I).The_Task (J).Pav.D_I :=
                             My_System (I).The_Task (J).Dij;
                           Max_D := My_System (I).The_Task (J).Dij;
                        else
                           My_System (I).The_Task (J).Pav.Calculate_Factor
                             := False;
                           My_System (I).The_Task (J).Pav.D_0 :=
                             Large_Time;
                           My_System (I).The_Task (J).Pav.D_I :=
                             Large_Time;
                        end if;

                     elsif My_System (I).The_Task (J).Pav.Preassigned
                     then

                        --Preassigned global deadlines will be treated as a
                        --special kind of Global Deadline, but not as a timing
                        --requirement
                        if My_System (I).The_Task (J).Schedij = EDF_Global
                        then
                           My_System (I).The_Task (J).Pav.Calculate_Factor
                             := True;
                           My_System (I).The_Task (J).Pav.D_0 :=
                             My_System (I).The_Task (J).SDij;
                           My_System (I).The_Task (J).Pav.D_I :=
                             My_System (I).The_Task (J).SDij;
                        end if;

                        if My_System (I).The_Task (J).Dij /= Large_Time and then
                          My_System (I).The_Task (J).Dij < Max_D
                        then
                           My_System (I).The_Task (J).Pav.Calculate_Factor
                             := True;
                           My_System (I).The_Task (J).Pav.D_0 :=
                             My_System (I).The_Task (J).Dij;
                           My_System (I).The_Task (J).Pav.D_I :=
                             My_System (I).The_Task (J).Dij;
                           Max_D := My_System (I).The_Task (J).Dij;
                        else
                           My_System (I).The_Task (J).Pav.Calculate_Factor
                             := False;
                           My_System (I).The_Task (J).Pav.D_0 :=
                             Large_Time;
                           My_System (I).The_Task (J).Pav.D_I :=
                             Large_Time;
                        end if;
                     end if;
               end loop;
            end loop;
         end USER_Preinitialization;

      begin

         if Verbose then
            Put_Line ("USER Virtual Deadline Initialization");
         end if;
         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);
         Translation.Clear_Time_Results(My_System,The_System);

         USER_Preinitialization;
         Save_Pavs;

         -- SDij/Prioij -> The_System
         Translation.Translate_Deadlines_and_Priorities
           (My_System,The_System);

         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_USER;

      -----------------------------
      -- Initialize_Deadlines_PD --
      -----------------------------

      procedure Initialize_Deadlines_PD is

         -- Initialize deadlines according to WCETs
         Max_Factor                              : constant Time :=
            Large_Time;
         Max_D, Sum_C, Assigned_D, Factor : Time;

      begin

         if Verbose then
            Put_Line ("PD Virtual Deadline Initialization");
         end if;

         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);
         Translation.Clear_Time_Results(My_System,The_System);

--           if Debug then
--              for I in Transaction_ID_Type range 1 .. Max_Transactions loop
--                 exit when My_System (I).Ni = 0;
--                 for J in 1 .. My_System (I).Ni loop
--                    Put_line(Transaction_ID_Type'Image(I)&","&Task_ID_Type'Image(J)&
--                             " "&Sched_Type'Image(My_System (I).The_Task (J).Schedij)&
--                             " "&Boolean'Image(My_System (I).The_Task (J).Pav.Preassigned)&
--                             " "&Boolean'Image(My_System (I).The_Task (J).Pav.Hard_Prio));
--                    My_System (I).The_Task (J).Pav.Preassigned_Prio :=
--                      My_System (I).The_Task (J).Prioij;
--                    My_System (I).The_Task (J).Pav.D_1              :=
--                      My_System (I).The_Task (J).SDij;
--                 end loop;
--              end loop;
--           end if;

         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop
                     -- Mark the actions with deadlines to calculate factors
                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        if My_System (I + K).The_Task (J).Dij /= Large_Time and then
                          My_System (I + K).The_Task (J).Dij < Max_D
                        then
                           My_System (I + K).The_Task (J).Pav.Calculate_Factor
                             := True;
                           My_System (I + K).The_Task (J).Pav.D_0 :=
                             My_System (I + K).The_Task (J).Dij;
                           My_System (I + K).The_Task (J).Pav.D_I :=
                             My_System (I + K).The_Task (J).Dij;
                           Max_D := My_System (I + K).The_Task (J).Dij;
                        else
                           My_System (I + K).The_Task (J).Pav.Calculate_Factor
                             := False;
                           My_System (I + K).The_Task (J).Pav.D_0 :=
                             Large_Time;
                           My_System (I + K).The_Task (J).Pav.D_I :=
                             Large_Time;
                        end if;

--                       elsif My_System (I + K).The_Task (J).Pav.Preassigned
--                       then
--
--                          --Preassigned global deadlines will be treated as a
--                          --special kind of Global Deadline, but not as a timing
--                          --requirement
--                          if My_System (I + K).The_Task (J).Schedij = EDF_Global
--                          then
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := True;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               My_System (I + K).The_Task (J).SDij;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               My_System (I + K).The_Task (J).SDij;
--                          end if;
--
--                          if My_System (I + K).The_Task (J).Dij /= Large_Time and
--                            My_System (I + K).The_Task (J).Dij < Max_D
--                          then
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := True;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               My_System (I + K).The_Task (J).Dij;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               My_System (I + K).The_Task (J).Dij;
--                             Max_D := My_System (I + K).The_Task (J).Dij;
--                          else
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := False;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               Large_Time;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               Large_Time;
--                          end if;
                     end if;
                  end loop;
               end loop;

               --Factors
               Sum_C      := 0.0;
               --Sum_D      := 0.0;       --For preassigned local deadlines
               Assigned_D := 0.0;
               for K in 0 .. Extra loop
                  for J in 1 .. My_System (I + K).Ni loop
                     -- Calculate factors
                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        Sum_C := Sum_C +
                          My_System (I + K).The_Task (J).Cijown;
--                       elsif
--                         My_System (I + K).The_Task (J).Pav.Preassigned and
--                         (My_System (I + K).The_Task (J).Schedij = EDF_Local)
--                       then
--                          --Sum_D := Sum_D + My_System (I + K).The_Task (J).SDij;
--                          null;
                        if My_System (I + K).The_Task (J).Pav.Calculate_Factor
                        then
                           My_System (I + K).The_Task (J).Pav.Factor :=
                             (My_System (I + K).The_Task (J).Pav.D_0 -
                                  Assigned_D) / --- Sum_D) /
                                 Sum_C;
                           Sum_C := 0.0;
                           --Put(My_System (I + K).The_Task (J).Pav.Factor'Img);
                           --Sum_D := 0.0;
                           Assigned_D := My_System (I + K).The_Task (J).Pav.D_0;
                        else
                           My_System (I + K).The_Task (J).Pav.Factor := 1.0;
                        end if;
                     end if;

                  end loop;
               end loop;

               Factor := Max_Factor;
               for K in reverse 0..Extra
               loop
                  for J in reverse 1..My_System(I+K).Ni
                  loop
                     -- Calculate deadlines
                     if not My_System(I+K).The_Task(J).Pav.Preassigned and then
                       not My_System(I).The_Task(J).Pav.Is_Polling
                     then
                        if My_System(I+K).The_Task(J).Pav.Calculate_Factor then
                           Factor := My_System(I+K).The_Task(J).Pav.Factor;
                        end if;
                        if Factor = Max_Factor then
                           My_System(I+K).The_Task(J).Pav.D_0 := Large_Time;
                        else
                           My_System(I+K).The_Task(J).Pav.D_0 :=
                             My_System(I+K).The_Task(J).Cijown*Factor;
                        end if;
                     end if;
                  end loop;
               end loop;
               exit when (I+Extra+1) not in Transaction_ID_Type;
               I := I+Extra+1;
            end loop;
         end;

         --Translation.Show_Debug_Deadlines(My_System);

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System

         --Put_Line ("DEBUG - Initialize");

         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_PD;

      ------------------------------
      -- Initialize_Deadlines_NPD --
      ------------------------------

      procedure Initialize_Deadlines_NPD is

         -- Initialize deadlines according to WCETs

         Max_Factor                              : constant Time :=
            Large_Time;
         Max_D, Sum_C, Assigned_D, Factor : Time;

      begin
         if Verbose then
            Put_Line ("NPD Virtual Deadline Initialization");
         end if;
         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);
         Translation.Clear_Time_Results(My_System,The_System);

--           if Debug then
--              for I in Transaction_ID_Type range 1 .. Max_Transactions loop
--                 exit when My_System (I).Ni = 0;
--                 for J in 1 .. My_System (I).Ni loop
--                    Put_line(Transaction_ID_Type'Image(I)&","&Task_ID_Type'Image(J)&
--                             " "&Sched_Type'Image(My_System (I).The_Task (J).Schedij)&
--                             " "&Boolean'Image(My_System (I).The_Task (J).Pav.Preassigned)&
--                             " "&Boolean'Image(My_System (I).The_Task (J).Pav.Hard_Prio));
--                    My_System (I).The_Task (J).Pav.Preassigned_Prio :=
--                      My_System (I).The_Task (J).Prioij;
--                    My_System (I).The_Task (J).Pav.D_1              :=
--                      My_System (I).The_Task (J).SDij;
--                 end loop;
--              end loop;
--           end if;

         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop
                     -- Mark the actions with deadlines to calculate factors
                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        if My_System (I + K).The_Task (J).Dij /= Large_Time and then
                          My_System (I + K).The_Task (J).Dij < Max_D
                        then
                           My_System (I + K).The_Task (J).Pav.Calculate_Factor
                             := True;
                           My_System (I + K).The_Task (J).Pav.D_0 :=
                             My_System (I + K).The_Task (J).Dij;
                           My_System (I + K).The_Task (J).Pav.D_I :=
                             My_System (I + K).The_Task (J).Dij;
                           Max_D := My_System (I + K).The_Task (J).Dij;
                        else
                           My_System (I + K).The_Task (J).Pav.Calculate_Factor
                             := False;
                           My_System (I + K).The_Task (J).Pav.D_0 :=
                             Large_Time;
                           My_System (I + K).The_Task (J).Pav.D_I :=
                             Large_Time;
                        end if;

--                       elsif My_System (I + K).The_Task (J).Pav.Preassigned
--                       then
--
--                          --Preassigned global deadlines will be treated as a
--                          --special kind of Global Deadline, but not as a timing
--                          --requirement
--                          if My_System (I + K).The_Task (J).Schedij = EDF_Global
--                          then
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := True;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               My_System (I + K).The_Task (J).SDij;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               My_System (I + K).The_Task (J).SDij;
--                          end if;
--
--                          if My_System (I + K).The_Task (J).Dij /= Large_Time and
--                            My_System (I + K).The_Task (J).Dij < Max_D
--                          then
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := True;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               My_System (I + K).The_Task (J).Dij;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               My_System (I + K).The_Task (J).Dij;
--                             Max_D := My_System (I + K).The_Task (J).Dij;
--                          else
--                             My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                               := False;
--                             My_System (I + K).The_Task (J).Pav.D_0 :=
--                               Large_Time;
--                             My_System (I + K).The_Task (J).Pav.D_I :=
--                               Large_Time;
--                          end if;
                     end if;
                  end loop;
               end loop;

               --Factors
               Sum_C      := 0.0;
               --Sum_D      := 0.0;       --For preassigned local deadlines
               Assigned_D := 0.0;
               for K in 0 .. Extra loop
                  for J in 1 .. My_System (I + K).Ni loop
                     -- Calculate factors
                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        --Put_line(Sum_C'Img);
                        Sum_C := Sum_C +
                          My_System (I + K).The_Task (J).Cijown *
                                 Time (
                          Mast.Tools.Calculate_Processing_Resource_Utilization
                                         (The_System,
                               My_System (I + K).The_Task (J).Pav.P_R_Ref,
                                          False));

--                       elsif
--                         My_System (I + K).The_Task (J).Pav.Preassigned and
--                         (My_System (I + K).The_Task (J).Schedij = EDF_Local)
--                       then
--                          --Sum_D := Sum_D + My_System (I + K).The_Task (J).SDij;
--                          null;
                        if My_System (I + K).The_Task (J).Pav.Calculate_Factor
                        then
                           My_System (I + K).The_Task (J).Pav.Factor :=
                             (My_System (I + K).The_Task (J).Pav.D_0 -
                                  Assigned_D) / --- Sum_D) /
                                 Sum_C;
                           --Put_line("f "&My_System (I + K).The_Task (J).Pav.Factor'Img);
                           Sum_C := 0.0;
                           --Sum_D := 0.0;
                           Assigned_D := My_System (I + K).The_Task (J).Pav.D_0;
                        else
                           My_System (I + K).The_Task (J).Pav.Factor := 1.0;
                        end if;
                     end if;

                  end loop;
               end loop;

               Factor := Max_Factor;
               for K in reverse 0..Extra
               loop
                  for J in reverse 1..My_System(I+K).Ni
                  loop
                     -- Calculate deadlines
                     if not My_System(I+K).The_Task(J).Pav.Preassigned and then
                       not My_System(I).The_Task(J).Pav.Is_Polling
                     then
                        if My_System(I+K).The_Task(J).Pav.Calculate_Factor then
                           Factor := My_System(I+K).The_Task(J).Pav.Factor;
                        end if;
                        if Factor = Max_Factor then
                           My_System(I+K).The_Task(J).Pav.D_0 := Large_Time;
                        else
                           My_System (I + K).The_Task (J).Pav.D_0 :=
                             My_System (I + K).The_Task (J).Cijown *
                                                         Time ( Mast.Tools.
                             Calculate_Processing_Resource_Utilization
                                   (The_System,
                                    My_System (I + K).The_Task (J).Pav.P_R_Ref,
                                    True)) * Factor;
                        end if;
                     end if;
                  end loop;
               end loop;
               exit when (I+Extra+1) not in Transaction_ID_Type;
               I := I+Extra+1;
            end loop;
         end;

         --Translation.Show_Debug_Deadlines(My_System);
         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System

         --Put_Line ("DEBUG - Initialize");

         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_NPD;

      -----------------------------
      -- Initialize_Deadlines_ED --
      -----------------------------

      procedure Initialize_Deadlines_ED is

         -- Initialize deadlines according to WCETs
         Max_Factor                              : constant Time :=
            Large_Time;
         pragma Unreferenced (Max_Factor);
         Max_D, Sum_C : Time;
         pragma Unreferenced (Max_D);

      begin

         if Verbose then
            Put_Line ("ED Virtual Deadline Initialization");
         end if;

         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);


         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
            Last_Di : Time;
            Scaling_Factor : constant Integer :=
              HOSPA_Parameters.Get_Virtual_Deadlines_Scaling_Factor;
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop

                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then

                        if My_System (I + K).The_Task (J).Dij /= Large_Time
                        then
                           Last_Di :=
                             Time(Scaling_Factor) *
                             My_System (I + K).The_Task (J).Dij;
                           Sum_C := Time(0);
                        end if;

                        My_System(I+K).The_Task(J).Pav.D_0 :=
                          Last_Di - Sum_C;

                        Sum_C := Sum_C + My_System(I+K).The_Task(J).Cij;

                     end if;
                  end loop;
               end loop;

               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         --Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System


         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_ED;

      ------------------------------
      -- Initialize_Deadlines_EQF --
      ------------------------------

      procedure Initialize_Deadlines_EQF is

         -- Initialize deadlines according to WCETs
         Max_Factor                              : constant Time :=
            Large_Time;
         pragma Unreferenced (Max_Factor);
         Max_D, Sum_C : Time;
         pragma Unreferenced (Max_D);

      begin

         if Verbose then
            Put_Line ("EQF Virtual Deadline Initialization");
         end if;

         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);


         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
            Last_Di : Time;
            Scaling_Factor : constant Integer :=
              HOSPA_Parameters.Get_Virtual_Deadlines_Scaling_Factor;

         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop

                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then

                        if My_System (I + K).The_Task (J).Dij /= Large_Time
                        then
                           Last_Di := Time(Scaling_Factor)*
                             My_System (I + K).The_Task (J).Dij;
                           Sum_C := Time(0);
                        end if;

                        Sum_C := Sum_C + My_System(I+K).The_Task(J).Cij;

                        My_System(I+K).The_Task(J).Pav.D_0 :=
                          My_System(I+K).The_Task(J).Cij +
                          (Last_Di - Sum_C)*My_System(I+K).The_Task(J).Cij/
                          (Sum_C);

                     end if;
                  end loop;
               end loop;

               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         --Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System


         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_EQF;

      ------------------------------
      -- Initialize_Deadlines_EQS --
      ------------------------------

      procedure Initialize_Deadlines_EQS is

         -- Initialize deadlines according to WCETs
         Max_Factor                              : constant Time :=
            Large_Time;
         pragma Unreferenced (Max_Factor);
         Max_D, Sum_C : Time;
         pragma Unreferenced (Max_D);

      begin

         if Verbose then
            Put_Line ("EQS Virtual Deadline Initialization");
         end if;

         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);


         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
            Last_Di : Time;
            Scaling_Factor : constant Integer :=
              HOSPA_Parameters.Get_Virtual_Deadlines_Scaling_Factor;
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop

                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then

                        if My_System (I + K).The_Task (J).Dij /= Large_Time
                        then
                           Last_Di := Time(Scaling_Factor)*
                             My_System (I + K).The_Task (J).Dij;
                           Sum_C := Time(0);
                        end if;

                        Sum_C := Sum_C + My_System(I+K).The_Task(J).Cij;

                        My_System(I+K).The_Task(J).Pav.D_0 :=
                          My_System(I+K).The_Task(J).Cij +
                          (Last_Di - Sum_C) / Time(My_System(I+K).Ni - J + 1);

                     end if;
                  end loop;
               end loop;

               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         --Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System


         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_EQS;

      -----------------------------
      -- Initialize_Deadlines_UD --
      -----------------------------

      procedure Initialize_Deadlines_UD is

         -- Initialize deadlines according to WCETs
         Max_Factor                              : constant Time :=
            Large_Time;
         pragma Unreferenced (Max_Factor);
         Max_D : Time;
         pragma Unreferenced (Max_D);

      begin

         if Verbose then
            Put_Line ("UD Virtual Deadline Initialization");
         end if;

         Translation.Translate_Linear_System
           (The_System,
            My_System,
            My_Verbose);


         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Preassigned_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
            Last_Di : Time;
            Scaling_Factor : constant Integer :=
              HOSPA_Parameters.Get_Virtual_Deadlines_Scaling_Factor;
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Max_D := Large_Time;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop


                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then

                        if My_System (I + K).The_Task (J).Dij /= Large_Time
                        then
                           Last_Di :=
                             Time(Scaling_Factor) * My_System (I + K).The_Task (J).Dij;
                        end if;

                        My_System(I+K).The_Task(J).Pav.D_0 := Last_Di;

                     end if;
                  end loop;
               end loop;

               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         --Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System


         --First assignment is saved as optimum. If no assignment is schedulable
         --this one is going to be the solution returned
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            for J in 1 .. My_System (I).Ni loop
               My_System (I).The_Task (J).Pav.Optimum_Prio :=
                 My_System (I).The_Task (J).Prioij;
               My_System (I).The_Task (J).Pav.D_1              :=
                 My_System (I).The_Task (J).SDij;
            end loop;
         end loop;

         if Verbose then
            Put_Line ("Initial Assignment : ");
            Translation.Show_Scheduling_Parameters (My_System);
         end if;

      end Initialize_Deadlines_UD;

      --------------------------
      -- Assign_New_Deadlines --
      --------------------------

      procedure Assign_New_Deadlines is

         type Excess_Type is record
            Excess     : Time := 0.0;
            Less, Plus : Time := 0.0;
         end record;

         Excess_For_Processors     : array (Processor_ID_Type) of Excess_Type;
         Max_Excess_For_Events     :
           array (Transaction_ID_Type) of Excess_Type;
         Max_Excess_For_Processors : Time := 0.0;

         Sum_D, Assigned_D, Factor : Time;

      begin

         Translation.Translate_Linear_System_With_Results
           (The_System,
            My_System,
            My_Verbose);
         Restore_Pavs;

         --Cambio de Jitter de salida por Jitters de entrada (Jij = Ri-1)

--           declare
--              I     : Transaction_ID_Type;
--              Extra : Transaction_ID_Type;
--           begin
--              I := 1;
--              while My_System (I).Ni /= 0 loop
--                 -- Calculate Extra
--                 Extra := 0;
--                 for J in Transaction_ID_Type range
--                       (I + 1) .. Max_Transactions
--                 loop
--                    exit when My_System (J).Transaction_Id /=
--                              My_System (I).Transaction_Id;
--                    Extra := Extra + 1;
--                 end loop;
--
--                 for K in 0 .. Extra loop
--                    for J in 1 .. My_System (I + K).Ni loop
--                       begin
--                          if K = 0 and J = 1 then
--                             My_System (I + K).The_Task (J).Jij := Time (0);
--                          else
--                             if J = 1 and K > 0 then
--                                My_System (I + K).The_Task (J).Jij :=
--                                  My_System (I + K - 1).The_Task (
--                                  My_System (I + K - 1).Ni).Rij;
--                             else
--                                My_System (I + K).The_Task (J).Jij :=
--                                  My_System (I + K).The_Task (J - 1).Rij;
--                             end if;
--                          end if;
--                          --exception
--                          --   when CONSTRAINT_ERROR =>
--                          --      Put_line("I ="&Transaction_ID_Type'Image(I));
--                          --      Put_line("Extra
--                          --="&Transaction_ID_Type'Image(Extra));
--                          --      Put_line("J ="&Task_ID_Type'Image(J));
--                       end;
--                    end loop;
--                 end loop;
--
--                 exit when (I + Extra + 1) not  in Transaction_ID_Type;
--                 I := I + Extra + 1;
--              end loop;
--           end;

         -- Excesses for actions
         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
         -- Number of extra consecutive transactions with the same ID
         begin
            I := 1;
            while My_System (I).Ni /= 0 loop
               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               Assigned_D := 0.0;
               for K in 0..Extra
               loop
                  for J in 1..My_System(I+K).Ni
                  loop
                     -- Calculate factors
                     if My_System(I+K).The_Task(J).Pav.Calculate_Factor then
                        My_System(I+K).The_Task(J).Pav.Factor :=
                          My_System(I+K).The_Task(J).Rij/
                          (My_System(I+K).The_Task(J).Pav.D_I-Assigned_D);
                        Assigned_D := My_System(I+K).The_Task(J).Pav.D_I;
                     end if;
                  end loop;
               end loop;

               Factor := 1.0;
               for K in reverse 0..Extra
               loop
                  for J in reverse 1..My_System(I+K).Ni
                  loop
                     -- Calculate excesses
                     if not My_System(I+K).The_Task(J).Pav.Preassigned and then
                       not My_System(I).The_Task(J).Pav.Is_Polling
                     then
                        if My_System(I+K).The_Task(J).Pav.Calculate_Factor then
                           Factor := My_System(I+K).The_Task(J).Pav.Factor;
                        end if;
                        My_System(I+K).The_Task(J).Pav.Excess :=
                          (My_System(I+K).The_Task(J).Rij-
                           My_System(I+K).The_Task(J).Pav.D_0)*Factor;
                     end if;
                  end loop;
               end loop;
               exit when (I+Extra+1) not in Transaction_ID_Type;
               I := I+Extra+1;
            end loop;
         end;

         -- Maximum excesses for events and processing resources
         declare
            I, T_Id : Transaction_ID_Type;
            Extra   : Transaction_ID_Type;
         -- Number of extra consecutive transactions with the same ID
         begin
            I := 1;
            while My_System (I).Ni /= 0 loop
               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                    My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;
               T_Id := My_System (I).Transaction_Id;
               for K in 0 .. Extra loop
                  for J in 1 .. My_System (I + K).Ni loop
                     if not My_System(I+K).The_Task(J).Pav.Preassigned and then
                       not My_System(I).The_Task(J).Pav.Is_Polling
                     then
                        if My_System (I + K).The_Task (J).Pav.Excess > 0.0 then
                           Excess_For_Processors (
                                                  My_System (I + K).The_Task (J).Procij).Plus :=
                             Excess_For_Processors (
                                                    My_System (I + K).The_Task (J).Procij).Plus +
                               My_System (I + K).The_Task (J).Pav.Excess;
                           Max_Excess_For_Events (T_Id).Plus :=
                             Max_Excess_For_Events (T_Id).Plus +
                             My_System (I + K).The_Task (J).Pav.Excess;
                        else
                           Excess_For_Processors (
                                                  My_System (I + K).The_Task (J).Procij).Less :=
                             Excess_For_Processors (
                                                    My_System (I + K).The_Task (J).Procij).Less +
                               My_System (I + K).The_Task (J).Pav.Excess;
                           Max_Excess_For_Events (T_Id).Less :=
                             Max_Excess_For_Events (T_Id).Less +
                             My_System (I + K).The_Task (J).Pav.Excess;
                        end if;
                        --                       if abs (My_System (I + K).The_Task (J).Pav.Excess) >
                        --                          Max_Excess_For_Events (T_Id).Excess
                        --                       then
                        --                          Max_Excess_For_Events (T_Id).Excess :=
                        --                            abs (My_System (I + K).The_Task (J).Pav.Excess);
                        --                       end if;
                     end if;
                  end loop;
               end loop;

               Max_Excess_For_Events(T_Id).Excess :=
                 Max_Excess_For_Events(T_Id).Plus+
                 Max_Excess_For_Events(T_Id).Less;

               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         for I in Processor_ID_Type range 1 .. Max_Processors loop
            Excess_For_Processors (I).Excess :=
              Excess_For_Processors (I).Plus +
              Excess_For_Processors (I).Less;
            if abs (Excess_For_Processors (I).Excess) >
               Max_Excess_For_Processors
            then
               Max_Excess_For_Processors :=
                 abs (Excess_For_Processors (I).Excess);
            end if;
         end loop;

         -- Deadline assignment

         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            declare
               T_Id : Transaction_ID_Type;
               prev_D_0 : Time; --To store previous virtual deadline assignment
            begin
               T_Id := My_System (I).Transaction_Id;
               for J in 1 .. My_System (I).Ni loop
                  if not My_System (I).The_Task (J).Pav.Preassigned
                    and then not My_System (I).The_Task (J).Pav.Is_Polling
                  then
                     if My_System (I).The_Task (J).Pav.D_0 /=
                        Large_Time
                     then
                        prev_D_0 := My_System (I).The_Task (J).Pav.D_0;

                        My_System (I).The_Task (J).Pav.D_0 :=
                          My_System (I).The_Task (J).Pav.D_0 *
                          (1.0 +
                             Excess_For_Processors (
                               My_System (I).The_Task (J).Procij).Excess /
                           (Time (Kr) * Max_Excess_For_Processors)) *
                          (1.0 +
                             My_System (I).The_Task (J).Pav.Excess /
                           (Time (Ka) * Max_Excess_For_Events (T_Id).Excess));

                        --It's possible that the new virtual deadline is 0, and
                        --that will make the assignment to be NaN, and raise
                        --constraint errors
                        --Case when could be zero : ka=1, Transaction with
                        --one task, and not schedulable
                        -- exc(aj) = -x
                        -- Mex(ei) = x
                        -- D_0 = 0.0

                        if My_System (I).The_Task (J).Pav.D_0 = Time(0) then
                           My_System (I).The_Task (J).Pav.D_0 := prev_D_0;
                        end if;

                     end if;
                  end if;
               end loop;
            end;
         end loop;

         -- Adjustment of assigned deadlines to real deadlines

         declare
            I     : Transaction_ID_Type;
            Extra : Transaction_ID_Type;
--            Sum_C : Time ;
            --Sum_D_Pre : Time;

         -- Number of extra consecutive transactions with the same ID
         begin

            I := 1;
            while My_System (I).Ni /= 0 loop

               -- Calculate Extra
               Extra := 0;
               for J in Transaction_ID_Type range
                     (I + 1) .. Max_Transactions
               loop
                  exit when My_System (J).Transaction_Id /=
                            My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               --Sum WCET's for transaction I
               --With Sum_C we want to avoid that any task SDij be less than
               --its WCET
               --We achieve this in the Scaling (last step)
               --New Scaling :  SDij = SDij/Sum_SDij * (ED-Sum_C)
               --               SDij = SDij + Cij

               --For Local EDF preassigned deadlines, we add its SDij instead of
               --its Cij

--                 Sum_C := 0.0;
--                 Assigned_D := 0.0;
--                 Sum_D      := 0.0;
--                 Sum_D_Pre  := 0.0;
--
--                 for K in 0 .. Extra loop
--                    for J in 1 .. My_System (I + K).Ni loop
--
--                       if not(My_System(I + K).The_Task(J).Pav.Preassigned) or
--                         (My_System(I + K).The_Task(J).Pav.Preassigned and
--                          My_System(I + K).The_Task(J).Schedij = FP)
--                       then
--                          Sum_C := Sum_C + My_System (I + K).The_Task (J).Cij;
--                       end if;
--
--                       if not My_System (I + K).The_Task (J).Pav.Preassigned
--                         and then not My_System (I).The_Task (J).Pav.Is_Polling
--                       then
--                          Sum_D := Sum_D +
--                            My_System (I + K).The_Task (J).Pav.D_0;
--                       elsif My_System (I + K).The_Task (J).Pav.Preassigned and
--                         My_System (I + K).The_Task (J).Schedij = EDF_Local then
--                          Sum_D_Pre := Sum_D_Pre +
--                            My_System (I + K).The_Task (J).SDij;
--                       end if;
--
--                       if My_System (I + K).The_Task (J).Pav.Calculate_Factor
--                       then
--                          My_System (I + K).The_Task (J).Pav.Factor :=
--                            (My_System (I + K).The_Task (J).Pav.D_I -
--                             Assigned_D - Sum_C - Sum_D_Pre) / Sum_D;
--                          Sum_D                                     := 0.0;
--                          Sum_C                                     := 0.0;
--                          Assigned_D                                :=
--                            My_System (I + K).The_Task (J).Pav.D_I;
--                       end if;
--
--                    end loop;
--                 end loop;


               Assigned_D := 0.0;
               Sum_D      := 0.0;
               for K in 0 .. Extra loop
                  for J in 1 .. My_System (I + K).Ni loop
                     -- Calculate factors
                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        Sum_D := Sum_D +
                                 My_System (I + K).The_Task (J).Pav.D_0;
                     end if;
                     if My_System (I + K).The_Task (J).Pav.Calculate_Factor
                     then
                        My_System (I + K).The_Task (J).Pav.Factor :=
                          (My_System (I + K).The_Task (J).Pav.D_I -
                           Assigned_D) / Sum_D;
                        Sum_D                                     := 0.0;
                        Assigned_D                                :=
                          My_System (I + K).The_Task (J).Pav.D_I;
                     end if;
                  end loop;
               end loop;

               Factor := 1.0;
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop
                     -- Adjust deadlines


                     if not My_System (I + K).The_Task (J).Pav.Preassigned
                       and then not My_System (I).The_Task (J).Pav.Is_Polling
                     then
                        if My_System (I + K).The_Task (J).Pav.Calculate_Factor
                        then
                           Factor := My_System (I + K).The_Task (J).Pav.Factor;
                        end if;
                        My_System (I + K).The_Task (J).Pav.D_0 :=
                          My_System (I + K).The_Task (J).Pav.D_0 * Factor;
                        --To avoid the possibility that SDij could be less than Cij
                        --                          My_System (I + K).The_Task (J).Pav.D_0 :=
                        --                            My_System (I + K).The_Task (J).Pav.D_0 +
                        --                            My_System (I + K).The_Task (J).Cij;
                     end if;
                  end loop;
               end loop;
               exit when (I + Extra + 1) not  in Transaction_ID_Type;
               I := I + Extra + 1;
            end loop;
         end;

         Save_Deadlines;        -- Pav.D_0 -> SDij
         Save_Pavs;

         Convert_Deadlines_To_Priorities;      -- SDij -> Prioij
         Local_To_Global_Deadlines;       -- SDij -> SDij (Global)
         Check_Global_Deadlines;
         Translation.Translate_Deadlines_and_Priorities
           (My_System,
            The_System); -- SDij/Prioij -> The_System

         --Translation.Show_Debug_Deadlines(My_System);

      end Assign_New_Deadlines;

      ----------------------------
      -- Save_Optimum_Deadlines --
      ----------------------------

      procedure Save_Optimum_Deadlines is
      begin
         Mast.Tools.Schedulability_Index.Calculate_Schedulability_Index
           (The_System,
            Sched_Index,
            Verbose);
         --Mast.Tools.Schedulability_Index.Print (Sched_Index);
         if Sched_Index >= Optimum_Sched_Index then
            Optimum_Sched_Index := Sched_Index;
            if Verbose then
               Put
                 ("Saving optimum deadline assignment with " &
                  "schedulability index : ");
               Mast.Tools.Schedulability_Index.Print (Optimum_Sched_Index);
            end if;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when My_System (I).Ni = 0;
               for J in 1 .. My_System (I).Ni loop
                  if not My_System (I).The_Task (J).Pav.Preassigned
                    and then not My_System (I).The_Task (J).Pav.Is_Polling
                  then
                     My_System (I).The_Task (J).Pav.D_1          :=
                       My_System (I).The_Task (J).SDij;
                     Pavs (I) (J).D_1                            :=
                       My_System (I).The_Task (J).SDij;
                     My_System (I).The_Task (J).Pav.Optimum_Prio :=
                       My_System (I).The_Task (J).Prioij;
                     Pavs (I) (J).Optimum_Prio                   :=
                       My_System (I).The_Task (J).Prioij;
                  end if;
               end loop;
            end loop;
         end if;
      exception
         when Mast.Tools.Schedulability_Index.Inconclusive =>
            null;
      end Save_Optimum_Deadlines;

      -------------------------------
      -- Restore_Optimum_Deadlines --
      -------------------------------

      procedure Restore_Optimum_Deadlines is
      begin
         if Overall_Schedulable then
            if Verbose then
               Put
                 ("Restoring optimum deadline assignment with " &
                  "schedulability index : ");
               Mast.Tools.Schedulability_Index.Print (Optimum_Sched_Index);
            end if;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when My_System (I).Ni = 0;
               for J in 1 .. My_System (I).Ni loop
                  if not My_System (I).The_Task (J).Pav.Preassigned
                    and then not My_System (I).The_Task (J).Pav.Is_Polling
                  then
                     My_System (I).The_Task (J).SDij   :=
                       My_System (I).The_Task (J).Pav.D_1;
                     My_System (I).The_Task (J).Prioij :=
                       My_System (I).The_Task (J).Pav.Optimum_Prio;
                  end if;
               end loop;
            end loop;
            --Convert_Deadlines_To_Priorities;
            Translation.Translate_Deadlines_and_Priorities
              (My_System,
               The_System);
         end if;
--           else
--              for I in Transaction_ID_Type range 1 .. Max_Transactions loop
--                 exit when My_System (I).Ni = 0;
--                 for J in 1 .. My_System (I).Ni loop
--                    null;
--                    --use last assignment
--                    --It should restore the initial assignment, but for now I
--                    --leave it like this
--                    My_System (I).The_Task (J).Prioij :=
--                      My_System (I).The_Task (J).Pav.Preassigned_Prio;
--                    My_System (I).The_Task (J).SDij   :=
--                      My_System (I).The_Task (J).Pav.D_1;
--                 end loop;
--              end loop;
--              Translation.Translate_Deadlines_and_Priorities
--                (My_System,
--                 The_System);
--           end if;
      end Restore_Optimum_Deadlines;

      --------------------
      -- Stop_Condition --
      --------------------

      function Stop_Condition return Boolean is
      begin
         if Optimize then
            if Schedulable then
               Save_Optimum_Deadlines;
               Overall_Schedulable := True;
               if not Optimizing then
                  Optimizing := True;
               else
                  Overiteration := Overiteration - 1;
                  if Overiteration <= 0 then
                     return True;
                  end if;
               end if;
            else
               if Optimizing then
                  Overiteration := Overiteration - 1;
                  if Overiteration <= 0 then
                     return True;
                  end if;
               end if;
            end if;
         else
            if Schedulable then
               Save_Optimum_Deadlines;
               Overall_Schedulable := True;
               return True;
            end if;
         end if;
         return False;
      end Stop_Condition;

      Aborted : Boolean;

   begin

      Overiteration := HOSPA_Parameters.Get_Overiterations;
      Optimize      := (HOSPA_Parameters.Get_Overiterations /= 0);
      Stop_Factor_When_not_Schedulable :=
        HOSPA_Parameters.Get_Stop_Factor_When_Not_Schedulable;

      Optimum_Sched_Index := Mast.Tools.Schedulability_Index.First_Index;

      case HOSPA_Parameters.Get_Initialization is
         when HOSPA_Parameters.PD =>
            Initialize_Deadlines_PD;
         when HOSPA_Parameters.NPD =>
            Initialize_Deadlines_NPD;
         when HOSPA_Parameters.USER =>
            Initialize_Deadlines_USER;

         -- Kao-Molina
         when HOSPA_Parameters.UD =>
            Initialize_Deadlines_UD;
         when HOSPA_Parameters.ED =>
            Initialize_Deadlines_ED;
         when HOSPA_Parameters.EQS =>
            Initialize_Deadlines_EQS;
         when HOSPA_Parameters.EQF =>
            Initialize_Deadlines_EQF;
      end case;

      if Debug then
         Put_Line("Showing D_0");
         Show_Debug_Deadlines(My_System);
         Put_Line("Showing Scheduling Parameters");
         Show_Scheduling_Parameters(My_System);
         New_Line;
      end if;

      if Verbose then
         Put_Line ("Starting HOSPA algorithm...");
      end if;
      if HOSPA_Parameters.Get_HOSPA_will_Iterate then

         if Verbose then
            Put_Line ("Algorithm will iterate");
         end if;
         HOSPA_Parameters.Rewind_Iterations_List;
         for I in 1 .. HOSPA_Parameters.Size_Of_Iterations_List loop
            HOSPA_Parameters.Rewind_K_List;
            Max_Iter := HOSPA_Parameters.Get_Next_Iterations;
            --Initialize_Deadlines;
            for J in 1 .. HOSPA_Parameters.Size_Of_K_List loop
               K  := HOSPA_Parameters.Get_Next_K_Pair;
               Ka := HOSPA_Parameters.Get_Ka (K);
               Kr := HOSPA_Parameters.Get_Kr (K);
               for L in 1 .. Max_Iter loop
                  Mast.Tools.Calculate_Ceilings_And_Levels
                    (The_System,
                     My_Verbose);

                  My_Back_Up_System     := My_System;
                  Counter_Of_Iterations :=
                     Integer'Succ (Counter_Of_Iterations);
                  if Verbose then
                     Put
                       ("Starting analysis on iteration:" &
                        Integer'Image (Counter_Of_Iterations));
                     Put (" Ka :");
                     Put (Ka, 2, 2, 0);
                     Put (" Kr :");
                     Put (Kr, 2, 2, 0);
                     New_Line;
                  end if;


                  if Verbose then
                     Put_Line ("Iteration Scheduling Parameter Assignment");
                     Translation.Show_Scheduling_Parameters
                       (Transaction => My_System);
                  end if;

                  Aborted := False;
                  if ATC_Enabled then
                     select
                        delay Analysis_Stop_Time;
                        My_System                   := My_Back_Up_System;
                        Aborted                     := True;
                        Counter_Of_Aborted_Analysis :=
                           Integer'Succ (Counter_Of_Aborted_Analysis);
                     then abort
                        The_Tool (The_System, Verbose,
                                  Stop_Factor_When_not_Schedulable);
                     end select;
                  else
                     Aborted := False;
                     The_Tool (The_System, Verbose,
                               Stop_Factor_When_not_Schedulable);
                  end if;
                  if Verbose then
                     if Aborted then
                        Put_Line ("    -> Analysis aborted.");
                     else
                        Put_Line ("    -> Analysis finished.");
                     end if;
                  end if;
                  if Aborted then
                     Schedulable := False;
                  else
                     Mast.Tools.Check_System_Schedulability
                       (The_System,
                        Schedulable,
                        Verbose);
                  end if;
                  Stop_Algorithm := Stop_Condition;
                  exit when Stop_Algorithm or else
                            ((I = HOSPA_Parameters.Size_Of_Iterations_List) and then
                             (J = HOSPA_Parameters.Size_Of_K_List) and then
                             (L = Max_Iter));
                  -- New deadline assignment
                  if not Aborted then
                     Assign_New_Deadlines;

                     if Debug then
                        Put_Line("Showing D_0");
                        Show_Debug_Deadlines(My_System);
                        Put_Line("Showing Scheduling Parameters");
                        Show_Scheduling_Parameters(My_System);
                        New_Line;
                     end if;

                  else
                     null;
                  end if;

               end loop;
               exit when Stop_Algorithm;
            end loop;
            exit when Stop_Algorithm;
         end loop;

         Restore_Optimum_Deadlines;

      else
         --Iterations = 0

         if Verbose then
            Put_Line ("Algorithm will not iterate");
         end if;
         if Debug then
            Put_Line("DEBUG : a");
         end if;
         Mast.Tools.Calculate_Ceilings_And_Levels (The_System, My_Verbose);
         if Debug then
            Put_Line("DEBUG : b");
         end if;
         The_Tool (The_System, Verbose, Stop_Factor_When_not_Schedulable);
         Mast.Tools.Check_System_Schedulability
           (The_System,
            Overall_Schedulable,
            Verbose);

      end if;

      if Verbose then
         Put_Line ("Linear HOSPA statistics:");

         Put_Line ("System Final Scheduling Parameters Overview");
         Translation.Show_Scheduling_Parameters (Transaction => My_System);

         Put_Line
           ("   Total number of iterations ------------------------> " &
            Integer'Image (Counter_Of_Iterations));
         if Overall_Schedulable then
            Put_Line
              ("The deadline assignment process " &
               "makes the system schedulable");
         else
            Put_Line
              ("The deadline assignment process " &
               "does not make the system schedulable");
         end if;
      end if;

   end HOSPA;

end Mast.Linear_Scheduling_Parameters_Assignment_Tools;
