-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2026                     --
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

with
  Mast.Schedulers, Mast.Schedulers.Primary, Mast.Scheduling_Policies,
  Mast.Processing_Resources,
  Ada.Containers.Ordered_Sets, Trimmed_Image, Ada.Directories,
  Ada.Strings.Fixed,
  Var_Strings;

use Trimmed_Image, Var_Strings;

with Ada.Text_IO; use Ada.Text_IO;

package body Mast.Linear_Task_Analysis_Tools is
   
   debug_global : constant Boolean := False;

   type Available_Analysis_Tools is
     (Holistic_Task_Fp,
      Holistic_Task_Edf_Local,
      Holistic_Task_Edf_Global,
      Offset_Based_Approx_W_Pr_Task_Fp,  
      Offset_Based_Approx_Task_Fp,
      Offset_Based_Slanted_Task_Fp, 
      Offset_Based_Brute_Force_Task_Fp,  
      Offset_Based_Approx_Task_Edf_Local,
      Offset_Based_Approx_W_Pr_Task_Edf_Local,
      Offset_Based_Approx_Task_Edf_Global);
   
   ---------------------
   -- Distributed_RTA --
   ---------------------

   procedure Distributed_RTA
     (The_System                       : in out Mast.Systems.System;
      Verbose                          : Boolean  := True;
      Stop_Factor_When_Not_Schedulable : Positive :=
        Mast.Default_Stop_Factor)
   is

      My_System                 : Translation.Linear_Transaction_System;
      Done, Changes_Made, Over_Analysis_Bound : Boolean;
      Access_to_Task_Analysis   : Processor_Analysis_Accesses;

      procedure Initialize_Response_Times_And_Jitter
        (Transaction : in out Linear_Transaction_System)
      is
         Act_B, Act_W : Time;
         Pred : Transaction_ID_Type;
         Pred_Ref : Transaction_Id_Array_Ref;
         Rmax : Time:=0.0;
         Rbest: Time :=0.0;
         Done : Boolean; -- Added in April 2020
      begin
         loop
            Done:=True;
            for I in 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               case Transaction (I).Trans_Input_Type is
                  when Internal =>
                     -- June 2014: Predecessor transaction was I-1, and now is
                     -- in the Predecessor_Trans_Ref field
                     Pred:=Transaction(I).Predecessor_Trans_Ref(1);
                     Act_B :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmin,
                          Transaction (Pred).The_Task (Transaction (Pred).Ni).
                            Rbij +
                            Transaction (I).The_Task (1).Delayijmin);
                     Act_W :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmax,
                          Transaction (Pred).The_Task (Transaction (Pred).Ni).
                            Rij +
                            Transaction (I).The_Task (1).Delayijmax) +
                       Transaction (I).The_Task (1).Jinit;
                  when External =>
                     Act_B :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmin,
                          Transaction (I).The_Task (1).Delayijmin);
                     Act_W :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmax,
                          Transaction (I).The_Task (1).Delayijmax) +
                       Transaction (I).The_Task (1).Jinit;
                  when Join =>
                     -- get array of predecessors
                     Pred_Ref:=Transaction(I).Predecessor_Trans_Ref;
                     -- Find maximum worst and best case response times
                     -- from the last tasks of all precedessors
                     Rmax:=0.0;
                     Rbest:=0.0;
                     for Tr in Pred_Ref.all'Range loop
                        Rmax:=Time'Max 
                          (Rmax, Transaction (Pred_Ref(Tr)).The_Task 
                             (Task_ID_Type
                                (Transaction(Pred_Ref(Tr)).Ni)).Rij);
                        Rbest:=Time'Max 
                          (Rbest, Transaction (Pred_Ref(Tr)).The_Task 
                             (Task_ID_Type
                                (Transaction(Pred_Ref(Tr)).Ni)).Rbij);
                     end loop;
                     Act_B :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmin,
                          Rbest + Transaction (I).The_Task (1).Delayijmin);
                     Act_W :=
                       Time'Max
                         (Transaction (I).The_Task (1).Oijmax,
                          Rmax + Transaction (I).The_Task (1).Delayijmax) +
                       Transaction (I).The_Task (1).Jinit;
               end case;

               -- Changed in April 2020 to iterate as it is not possible to
               -- process Fork/Join combinations in order
               if Transaction (I).The_Task (1).Oij  /= Act_B then
                  Transaction (I).The_Task (1).Oij  := Act_B;
                  Done := False;
               end if;
               if Transaction (I).The_Task (1).Jij /= Act_W - Act_B then
                  Transaction (I).The_Task (1).Jij  := Act_W - Act_B;
                  Done := False;
               end if;
               if  Transaction (I).The_Task (1).Rbij /= Act_B +
                 Transaction (I).The_Task (1).Cbijown 
               then
                  Transaction (I).The_Task (1).Rbij := Act_B +
                    Transaction (I).The_Task (1).Cbijown;
                  Done := False;
               end if;          
               if Transaction (I).The_Task (1).Rij /= Act_W +
                 Transaction (I).The_Task (1).Cijown 
               then
                  Transaction (I).The_Task (1).Rij  := Act_W +
                    Transaction (I).The_Task (1).Cijown;
                  Done := False;
               end if;

               for L in 2 .. Transaction (I).Ni loop
                  Act_B                             :=
                    Time'Max
                      (Transaction (I).The_Task (L).Oijmin,
                       Transaction (I).The_Task (L - 1).Rbij +
                         Transaction (I).The_Task (L).Delayijmin);
                  Act_W                             :=
                    Time'Max
                      (Transaction (I).The_Task (L).Oijmax,
                       Transaction (I).The_Task (L - 1).Rij +
                         Transaction (I).The_Task (L).Delayijmax) +
                    Transaction (I).The_Task (L).Jinit;
                  -- Changed in April 2020 to iterate as it is not possible to
                  -- process Fork/Join combinations in order
                  if Transaction (I).The_Task (L).Oij /= Act_B then
                     Transaction (I).The_Task (L).Oij  := Act_B;
                     Done := False;
                  end if;
                  if Transaction (I).The_Task (L).Jij /= Act_W - Act_B then
                     Transaction (I).The_Task (L).Jij  := Act_W - Act_B;
                     Done := False;
                  end if;
                  if Transaction (I).The_Task (L).Rbij /= Act_B +
                    Transaction (I).The_Task (L).Cbijown 
                  then
                     Transaction (I).The_Task (L).Rbij := Act_B +
                       Transaction (I).The_Task (L).Cbijown;
                     Done := False;
                  end if;
                  if Transaction (I).The_Task (L).Rij /= Act_W +
                    Transaction (I).The_Task (L).Cijown 
                  then
                     -- mgh 2026: remove
                     if I=1 then
                        Put_Line("I=1 L="&L'Img&" initial Rij="&Transaction (I).The_Task (L).Rij'Img);
                     end if;
                     Transaction (I).The_Task (L).Rij  := Act_W +
                       Transaction (I).The_Task (L).Cijown;
                     Done := False;
                  end if;
               end loop;
            end loop;
            exit when Done;
         end loop;
      end Initialize_Response_Times_And_Jitter;

      ---------------------------------------------------
      -- Propagate the response times to the next task,
      -- calculating its equivalent offset and jitter
      ----------------------------------------------------
      procedure Propagate_Results_To_Next_Task
        (Transaction : in out Linear_Transaction_System;
         I : Transaction_ID_Type;
         J : Task_ID_Type;
         Changes : in out Boolean)
      is
         
         procedure Propagate_Results
           (Rworst, Rbest : Time;
            To_Tr : Transaction_ID_Type; 
            To_Tsk : Task_ID_Type)
         is
         begin
            -- Propagate Rworst/Rbest results into task To_Tsk 
            -- in transaction To_Tr
            if Transaction (To_Tr).The_Task (To_Tsk).Oij /=
              Time'Max
                (Transaction (To_Tr).The_Task (To_Tsk).Oijmin,
                 Rbest + Transaction (To_Tr).The_Task (To_Tsk).Delayijmin) 
            then
               Transaction (To_Tr).The_Task (To_Tsk).Oij:=
                 Time'Max
                   (Transaction (To_Tr).The_Task (To_Tsk).Oijmin,
                    Rbest + Transaction (To_Tr).The_Task (To_Tsk).Delayijmin);
               Changes := True;
            end if;
            
            if Transaction (To_Tr).The_Task (To_Tsk).Jij /=
              Time'Max
                (Transaction (To_Tr).The_Task (To_Tsk).Oijmax,--?
                 Rworst + Transaction (To_Tr).The_Task (To_Tsk).Delayijmax) +
              Transaction (To_Tr).The_Task (To_Tsk).Jinit -
              Transaction (To_Tr).The_Task (To_Tsk).Oij 
            then
               Transaction (To_Tr).The_Task (To_Tsk).Jij :=
                 Time'Max
                   (Transaction (To_Tr).The_Task (To_Tsk).Oijmax,--?
                    Rworst + Transaction (To_Tr).The_Task (To_Tsk).Delayijmax) +
                 Transaction (To_Tr).The_Task (To_Tsk).Jinit -
                 Transaction (To_Tr).The_Task (To_Tsk).Oij;
               Changes := True;
            end if;
         end Propagate_Results;
         
         Succ : Transaction_ID_Type;
         -- Num_Succ : Positive; Removed in July 2019
         Pred : Transaction_Id_Array_Ref;
         Rmax : Time:=0.0;
         Rbest: Time :=0.0;
         
      begin
         if J < Transaction (I).Ni then
            --  Transaction (I).The_Task (J + 1).Jij :=
            --    Time'Max(Transaction (I).The_Task (J + 1).Oijmax,
            --             Rmax + Transaction (I).The_Task (J + 1).Delayijmax) +
            --    Transaction (I).The_Task (J + 1).Jinit -
            --    Transaction (I).The_Task (J + 1).Oij;
            Rmax  :=Transaction (I).The_Task (J).Rij;
            Rbest := Transaction (I).The_Task (J).Rbij;
            Propagate_Results
              (Rworst   => Rmax,
               Rbest    => Rbest,
               To_Tr    => I,
               To_Tsk   => J+1);
         else -- last task in transaction
            --   June 2014: added support for successor
            if Transaction(I).Successor_Trans_Ref/=null then
               for Tr in Transaction(I).Successor_Trans_Ref.all'Range loop
                  -- July 2019: propagation to all successors (Fork)
                  Succ:=Transaction(I).Successor_Trans_Ref(Tr);
                  case Transaction (Succ).Trans_Input_Type is
                     when Internal =>
                        --  Transaction (Succ).The_Task (1).Jij :=
                        --    Time'Max
                        --    (Transaction (Succ).The_Task (1).Oijmax,
                        --     Rmax + Transaction (Succ).The_Task (1).
                        --        Delayijmax) +
                        --    Transaction (Succ).The_Task (1).Jinit -
                        --    Transaction (Succ).The_Task (1).Oij;
                        Rmax  :=Transaction (I).The_Task (J).Rij;
                        Rbest := Transaction (I).The_Task (J).Rbij;
                        Propagate_Results
                          (Rworst   => Rmax,
                           Rbest    => Rbest,
                           To_Tr    => Succ,
                           To_Tsk   => 1);
                     when External =>
                        -- This case is impossible, since external transactions
                        -- have no predecessor
                        Set_Exception_Message
                          ("External transaction with predecessor");
                        raise Internal_Inconsistency;
                     when Join =>
                        -- get array of predecessors
                        Pred:=Transaction(Succ).Predecessor_Trans_Ref;
                        -- Find maximum worst and best case response times
                        -- from the last tasks of all precedessors
                        Rmax := 0.0;
                        Rbest := 0.0;
                        for Tr in Pred.all'Range loop
                           Rmax:=Time'Max 
                             (Rmax, Transaction (Pred(Tr)).The_Task 
                                (Task_ID_Type
                                   (Transaction(Pred(Tr)).Ni)).Rij);
                           Rbest:=Time'Max 
                             (Rbest, Transaction (Pred(Tr)).The_Task 
                                (Task_ID_Type
                                   (Transaction(Pred(Tr)).Ni)).Rbij);
                        end loop;
                        Propagate_Results
                          (Rworst   => Rmax,
                           Rbest    => Rbest,
                           To_Tr    => Succ,
                           To_Tsk   => 1);           
                  end case;
               end loop;
            end if; -- Successor_Trans_Ref non null
         end if; -- last task in transaction or not
      end Propagate_Results_To_Next_Task;

      --------------------------------------------------------
      -- For simplicity of the response time analysis of a task,
      -- The period and WCET used for the own analysis of the task
      -- is copied to the general period and WCET; it is also
      -- stored in an auxiliary variable to be later restored
      ---------------------------------------------------------
      procedure Auxiliary_Initialization_for_Offsets
        (A : Transaction_ID_Type)
      is
      begin
         for B in 1 .. My_System (A).Ni loop
            Aux_Tij (B)                     := My_System (A).The_Task (B).Tij;
            My_System (A).The_Task (B).Tij  :=
              My_System (A).The_Task (B).Tijown;
            Aux_Cij (B)                     := My_System (A).The_Task (B).Cij;
            My_System (A).The_Task (B).Cij  :=
              My_System (A).The_Task (B).Cijown;
            Aux_Cbij (B)                    :=
              My_System (A).The_Task (B).Cbij;
            My_System (A).The_Task (B).Cbij :=
              My_System (A).The_Task (B).Cbijown;
         end loop;
      end Auxiliary_Initialization_for_Offsets;


      --------------------------------------------------------
      -- The general period and WCET are restored back to the
      -- values stored in an auxiliary variable by
      -- Auxiliary_Initialization_for_Offsets
      --------------------------------------------------------
      procedure Auxiliary_Finalization_for_Offsets
        (A : Transaction_ID_Type)
      is
      begin
         for B in 1 .. My_System (A).Ni loop
            My_System (A).The_Task (B).Tij  := Aux_Tij (B);
            My_System (A).The_Task (B).Cij  := Aux_Cij (B);
            My_System (A).The_Task (B).Cbij := Aux_Cbij (B);
         end loop;
      end Auxiliary_Finalization_for_Offsets;
      
   begin
      if Verbose then
         Put_Line ("Distributed RTA Mixed Analysis");
      end if;

      if debug_global then
         Put_Line("Stop Factor : "&Img(Stop_Factor_When_Not_Schedulable));
      end if;

      Access_to_Task_Analysis := (others => null);
      Translate_Linear_System (The_System, My_System, Verbose);
      Clear_Time_Results(My_System,The_System);

      Initialize_Processor_Analysis_Accesses
        (The_System         => The_System,
         -- My_System          => My_System,
         The_Accesses_Array => Access_to_Task_Analysis,
         Verbose            => Verbose);

      Initialize_Response_Times_And_Jitter (My_System);
      
      -- mgh 2026: remove
      Put_Line("After initialize I=1 J=2 Rij="&My_System(1).The_Task(2).Rij'Img);

      loop
         Done := True;
         for I in 1 .. Max_Transactions loop
            exit when My_System (I).Ni = 0;
            Auxiliary_Initialization_for_Offsets (I);

            -- Calculate Analysis_Bound for transaction
            declare
               Extra : Transaction_ID_Type;
               Max_D : Time := Time(0);
            begin
               Extra := 0;
               for J in Transaction_ID_Type range
                 (I + 1) .. Max_Transactions
               loop
                  -- mgh: feb 2025, added the ".Ni = 0" condition to
                  -- exit the loop before the first invalid transaction 
                  -- is reached
                  exit when My_System (J).Ni = 0 or else
                    My_System (J).Transaction_Id /= 
                    My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               -- Find Higher (and < Large_Time) deadline in this transaction
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop
                     if My_System (I + K).The_Task (J).Dij < Large_Time
                       and then My_System (I + K).The_Task (J).Dij > Max_D 
                     then
                        Max_D := My_System (I + K).The_Task (J).Dij;
                     end if;
                  end loop;
               end loop;
               
               if Max_D > Time(0) then
                  -- Transaction has at least one deadline requirement
                  Analysis_Bound := Max_D*
                    Time(Stop_Factor_When_Not_Schedulable);
               else
                  -- Transaction doesn't have any deadline requirement
                  -- In this case we stop after a number of times the period
                  Analysis_Bound := My_System(I).Ti*
                    Time(Integer'Max(100,Stop_Factor_When_Not_Schedulable));
               end if;
            end;

            -- Put_line("DEBUG Analysis_Bound : "&Time'Image(Analysis_Bound));

            for J in 1 .. My_System (I).Ni loop
               Over_Analysis_Bound := False;

               if debug_global then
                  Put("DEBUG : Task Analysis "&Img(Integer(I))&","
                        &Img(Integer(J)));
               end if;

               --Task Analysis
               Access_to_Task_Analysis (My_System (I).The_Task (J).Procij)
                 (My_System,
                  I,
                  J,
                  Changes_Made,
                  Stop_Factor_When_Not_Schedulable,
                  Over_Analysis_Bound,
                  Verbose);                                       
               
               -- July 2019: Removed to be done when the whole system has been 
               -- analysed
               --Propagate_Results_To_Next_Task(My_System,I,J);
               
               if debug_global and Verbose then
                  Put_Line(" R = "&
                             Img(My_System(I).The_Task(J).Rij,4));
                  --  else
                  --     if verbose then
                  --        New_line;
                  --     end if;
               end if;

               if Changes_Made then
                  Done := False;
               end if;

               exit when Over_Analysis_Bound;
               --if Over_Analysis_Bound then salir:=true; end if;
            end loop; --Task Loop
            
            -- mgh 2026: remove
            Put_Line("After analysis I=1 J=2 Rij="&My_System(1).The_Task(2).Rij'Img);
            
            Auxiliary_Finalization_for_Offsets (I);
            exit when Over_Analysis_Bound;
         end loop; --Transaction loop
         
         -- April 2020: propagate results for the whole system
         declare
            Changes : boolean;
         begin            
            loop
               Changes := False;
               for I in 1 .. Max_Transactions loop
                  for J in 1 .. My_System (I).Ni loop
                     Propagate_Results_To_Next_Task(My_System,I,J,Changes);
                  end loop;
               end loop;
               exit when not Changes;
            end loop;
         end;
         
         exit when Done or Over_Analysis_Bound;
         --exit when Done or salir;

      end loop;
      
      -- If we stopped because of the analysis bound, 
      -- set Inconclusive_Analysis_Results to true
      if Over_Analysis_Bound then
         -- Set_Response_Times_To_Large_Time(My_System);
         The_System.Inconclusive_Analysis_Results:=True;
      end if;
      
      if Mast_Benchmark_Output then
         declare
            File_B : File_Type;
            --Avg_R : Time;
            Ni : Task_ID_Type;
         begin
            --Avg_R := 0.0;
            Ada.Directories.Set_Directory("results");
            Open(File_B,Append_File,Mast_Benchmark_Output_Filename);
            Ada.Directories.Set_Directory("..");
            Put(File_B,"R  ");
            for I in 1 .. Max_Transactions loop
               Ni := My_System(I).Ni;
               Put(File_B,Img(My_System(I).The_Task(Ni).Rij,2)&" ");
               --Avg_R := Avg_R + My_System(I).The_Task(Ni).Rij;
            end loop;
            --Put_line(File_B,Img(Avg_R/time(Max_Transactions),2));
            New_Line(File_B);
            Close(File_B);
         end;
      end if;
      Translate_Linear_Analysis_Results (My_System, The_System);

   end Distributed_RTA;

   
   ----------------------
   -- Holistic_Task_FP --
   ----------------------

   procedure Holistic_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      debug : constant Boolean := false;--(I=1) and (J=2) and debug_global;

      Transaction : Translation.Linear_Transaction_System renames My_System;

      function WTindell
        (Ta          : Transaction_ID_Type;
         K           : Task_ID_Type;
         Q           : Long_Int;
         Transaction : Linear_Transaction_System)
        return        Time
      is
         Wc, Wcant, Jitter : Time;
         Prio              : Priority;
         Proc              : Processor_ID_Type;
         Done              : Boolean;

      begin
         Proc  := Transaction (Ta).The_Task (K).Procij;
         Prio  := Transaction (Ta).The_Task (K).Prioij;
         Wcant := Time (Q) * Transaction (Ta).The_Task (K).Cijown +
           Transaction (Ta).The_Task (K).Bij;
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when Transaction (I).Ni = 0;
            for J in 1 .. Transaction (I).Ni loop

               if (Transaction (I).The_Task (J).Procij = Proc) and then
                 (Transaction (I).The_Task (J).Prioij >= Prio) and then
                 not ((I = Ta) and then (J = K))
               then
                  Wcant := Wcant + Transaction (I).The_Task (J).Cij;
               end if;
            end loop;
         end loop;

         loop
            Wc := Time (Q) * Transaction (Ta).The_Task (K).Cijown +
              Transaction (Ta).The_Task (K).Bij;

            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and then
                    (Transaction (I).The_Task (J).Prioij >= Prio) and then
                    not ((I = Ta) and then (J = K))
                  then
                     if Transaction (I).The_Task (J).Model =
                       Unbounded_Effects
                     then
                        return Large_Time;
                     elsif Transaction (I).The_Task (J).Jitter_Avoidance then
                        Jitter := 0.0;
                     else
                        Jitter := Transaction (I).The_Task (J).Jij;
                     end if;
                     Wc := Wc +
                       Ceiling
                         ((Wcant + Jitter) /
                            Transaction (I).The_Task (J).Tij) *
                       Transaction (I).The_Task (J).Cij;
                  end if;
               end loop;
            end loop;

            if debug then
               Put_Line(Wc'Img);
            end if;

            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end WTindell;

      Q                    : Long_Int;
      R_Ij, W_Ij, Rmax, Di : Time;
      pragma Unreferenced (Di);
      Ni                   : Task_ID_Type;



   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_Line
           ("        Holistic FP for Task : " &
              Transaction_ID_Type'Image (I) &
              "," & Task_ID_Type'Image (J));
      end if;

      Ni   := Transaction (I).Ni;
      Di   := Transaction (I).The_Task (Ni).Dij;
      Q    := 0;
      Rmax := 0.0;

      if Transaction (I).The_Task (J).Model /= Unbounded_Response and then
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then
         loop
            Q    := Q + 1;
            W_Ij := WTindell (I, J, Q, Transaction);

            R_Ij := W_Ij +
              Transaction (I).The_Task (J).Jij -
              Time (Q - 1) * Transaction (I).The_Task (J).Tijown +
              Transaction (I).The_Task (J).Oij;
            if R_Ij > Rmax then
               Rmax := R_Ij;
            end if;

            if Rmax >= Analysis_Bound
            then
               if Verbose then
                  Put_Line(" Task over its Analysis Bound");
               end if;
               Changes_Made := True;
               for K in J .. Transaction (I).Ni loop
                  Transaction (I).The_Task (K).Model := Unbounded_Effects;
                  Transaction (I).The_Task (K).Rij   := Large_Time;
                  if K < Ni then
                     Transaction (I).The_Task (K).Jij := Large_Time;
                  end if;
               end loop;

               Over_Analysis_Bound := True;

               exit when R_Ij = Large_Time;

            end if;

            exit when (W_Ij <= Time (Q) * Transaction (I).The_Task (J).Tijown)
              or else Transaction (I).The_Task (J).Model = Unbounded_Effects;
         end loop;

         -- Store the worst-case response time obtained
         if Rmax > Transaction (I).The_Task (J).Rij then
            Changes_Made := True;
            Transaction (I).The_Task (J).Rij := Rmax;
         end if;

      end if;
      
      -- April 2025: Added the unbounded_response case
      if Transaction (I).The_Task (J).Model = Unbounded_Response then
         Transaction (I).The_Task (J).Rij := Large_Time;
      end if;
   end Holistic_Task_FP;

   -----------------------------
   -- Holistic_Task_EDF_Local --
   -----------------------------

   procedure Holistic_Task_EDF_Local
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      Transaction : Translation.Linear_Transaction_System renames My_System;

      --Set_Psi          : array (1 .. 50000) of Time;
      Wbusy            : Time;
      pL               : Long_Int;
      --N_PSI          : Integer;
      --cnt              : Integer;
      Rmax, R_ab, W_ab : Time;
      Ni               : Task_ID_Type;
      debug : constant boolean := debug_global and then (I=1) and then (J=2);


      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Long_Int) return Long_Int is
      begin
         if X < 0 or else Y < 0 then
            return 0;
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;

      -----------------
      -- Busy_Period --
      -----------------

      function Busy_Period
        (a    : Transaction_ID_Type;
         b    : Task_ID_Type)
        return Time
      is
         Wc, Wcant : Time;
         Proc      : Processor_ID_Type;
         Done      : Boolean;
      begin

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Transaction (a).The_Task (b).Cij;

         loop
            Wc := Ceiling (Wcant / Transaction (a).The_Task (b).Tij) *
              Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and then
                    not ((I = a) and then (J = b))
                  then
                     Wc := Wc +
                       Ceiling
                         ((Wcant + Transaction (I).The_Task (J).Jij) /
                            Transaction (I).The_Task (J).Tij) *
                       Transaction (I).The_Task (J).Cij;
                  end if;
               end loop;
            end loop;
            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end Busy_Period;

      -----------------------------
      -- Build_Set_PSI_EDF_Local --
      -----------------------------


      --BUG : When Stop_Factor_When_not_Schedulable is reached,
      --task jitter is set at Large_Time, and Busy Period is then
      --a very big number, that overflows Long_Int range, so a constraint
      --error is raised


      package Psi_Container is new Ada.Containers.Ordered_Sets (Time,"<","=");
      use Psi_Container;
      Psi_Set : Psi_Container.Set;
      Psi_Cursor : Psi_Container.Cursor;


      procedure Build_Set_PSI_EDF_Local
        (A : Transaction_ID_Type;
         B : Task_ID_Type)
      is
         wbusy : Time;
         Proc        : Processor_ID_Type;
         psi : Time;

         procedure Insert (set : in out Psi_Container.Set;
                           element : Time)
         is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin

         if debug then
            Put_Line("Build psi set : function");
            Put_Line("Build psi set : a="&Img(Integer(A)));
            Put_Line("Build psi set : b="&Img(Integer(B)));
         end if;

         Proc  := Transaction (A).The_Task (B).Procij;
         wbusy := Busy_Period (A, B);

         if debug then
            Put_Line("Build psi set : wbusy psi ="&Img(Integer(wbusy)));
         end if;

         -- (6)
         for P in
           1 ..Long_Int (Ceiling (wbusy / Transaction (A).The_Task (B).Tij))
         loop
            psi := Time (P - 1) * Transaction (A).The_Task (B).Tij +
              Transaction (A).The_Task (B).SDij;
            if debug then
               Put_Line("Build psi set : (6) p_psi = "&img(P));
               Put_Line("Build psi set : (6) psi = "&Img(psi));
            end if;
            Insert(Psi_Set,psi);
         end loop;

         -- (4)
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when Transaction (I).Ni = 0;
            for J in 1 .. Transaction (I).Ni loop
               if (Transaction (I).The_Task (J).Procij = Proc) and then
                 not ((I = A) and then (J = B))
               then
                  psi := Transaction (I).The_Task (J).SDij;
                  if debug then
                     Put_Line("Build psi set : (4) (sdij) psi = "&Img(psi));
                  end if;
                  Insert(Psi_Set,psi);
                  for P in
                    1 ..
                    Long_Int (Ceiling
                                ((wbusy +
                                    Transaction (I).The_Task (J).Jij) /
                                   Transaction (I).The_Task (J).Tij))
                  loop
                     if debug then
                        Put_Line("Build psi set : (4) p_psi = "&img(P));
                     end if;

                     if Time (P - 1) * Transaction (I).The_Task (J).Tij -
                       Transaction (I).The_Task (J).Jij >=
                       0.0
                     then
                        psi := Time (P - 1) * Transaction (I).The_Task (J).Tij -
                          Transaction (I).The_Task (J).Jij +
                          Transaction (I).The_Task (J).SDij;

                        if debug then
                           Put_Line("Build psi set : (4) psi = "&Img(psi));
                        end if;

                        Insert(Psi_Set,psi);
                     end if;

                  end loop;
               end if;
            end loop;
         end loop;

      end Build_Set_PSI_EDF_Local;


      ---------------------------------------
      -- Wij used for Local EDF Priorities --
      ---------------------------------------

      function Wij_EDF_Local
        (i    : Transaction_ID_Type;
         j    : Task_ID_Type;
         t    : Time;
         D    : Time)
        return Time
      is
         pt, pd : Long_Int;
      begin

         pt :=
           Long_Int (Ceiling
                       ((t + Transaction (i).The_Task (j).Jij) /
                          Transaction (i).The_Task (j).Tij));
         if Transaction (i).The_Task (j).SDij > D then
            pd := 0;
         else
            pd :=
              Long_Int (Floor
                          ((Transaction (i).The_Task (j).Jij + D -
                              Transaction (i).The_Task (j).SDij) /
                             Transaction (i).The_Task (j).Tij)) + 1;
         end if;
         return Time (Min0 (pt, pd)) * Transaction (i).The_Task (j).Cij;
      end Wij_EDF_Local;

      -------------------
      -- Wab_EDF_Local --
      -------------------

      function Wab_EDF_Local
        (a    : Transaction_ID_Type;
         b    : Task_ID_Type;
         p    : Long_Int;
         D    : Time)
        return Time
      is
         Wc, Wcant : Time;
         Proc      : Processor_ID_Type;
         Done      : Boolean;
      begin

         if debug then
            Put_Line("Wab function");
            Put_Line("Wab_EDF_Local : a="&Img(Integer(a)));
            Put_Line("Wab_EDF_Local : b="&Img(Integer(b)));
            Put_Line("Wab_EDF_Local : p="&img(p));
            Put_Line("Wab_EDF_Local : D="&Img(D));
         end if;

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Time (p) * Transaction (a).The_Task (b).Cij;
         loop
            if debug then
               Put_Line("Wab_EDF_Local : Wcant="&Img(Wcant));
            end if;
            Wc := Time (p) * Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and then
                    not ((I = a) and then (J = b))
                  then
                     Wc := Wc + Wij_EDF_Local (I, J, Wcant, D);
                     if debug then
                        Put_Line("Wab_EDF_Local : Wc partial sum = "&Img(Wc));
                     end if;
                  end if;
               end loop;
            end loop;
            if debug then
               Put_Line("Wab_EDF_Local : Wc final = "&Img(Wc));
            end if;
            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end Wab_EDF_Local;

      psi : Time;


   begin
      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Transaction (I).The_Task (J).Model /= Unbounded_Response and then
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then

         Ni   := Transaction (I).Ni;
         Rmax  := 0.0;
         Wbusy := Busy_Period (I, J);

         if debug then
            New_Line;
            Put_Line("Wbusy = "&Img(Wbusy));
         end if;

         Clear(Psi_Set);
         Build_Set_PSI_EDF_Local (I, J);

         pL := Long_Int (Ceiling (Wbusy / Transaction (I).The_Task (J).Tij));

         for P in 1 .. pL loop

            if debug then
               Put_Line("p = "&img(P));
            end if;

            Psi_Cursor := First(Psi_Set);
            while Has_Element(Psi_Cursor) loop

               psi := Element(Psi_Cursor);

               if debug then
                  Put_Line("psi = "&Img(psi));
                  Put_Line("? psi >= "&Img((Time (P - 1) * 
                                              Transaction (I).The_Task (J).Tij +
                                              Transaction (I).The_Task (J).SDij)));
                  Put_Line("? psi < "&Img((Time (P) * 
                                             Transaction (I).The_Task (J).Tij +
                                             Transaction (I).The_Task (J).SDij)));
               end if;

               if psi >=
                 (Time (P - 1) * Transaction (I).The_Task (J).Tij +
                    Transaction (I).The_Task (J).SDij) and then
                 psi <
                 (Time (P) * Transaction (I).The_Task (J).Tij +
                    Transaction (I).The_Task (J).SDij)
               then

                  W_ab := Wab_EDF_Local (I, J, P, psi);
                  if debug then
                     Put_Line("w_ab = "&Img(W_ab));
                  end if;

                  R_ab := W_ab - psi +
                    Transaction (I).The_Task (J).SDij +
                    Transaction (I).The_Task (J).Jij +
                    Transaction (I).The_Task (J).Oij;

                  if debug then
                     Put_Line("r_ab = "&Img(R_ab));
                     Put_Line("Rmax = "&Img(Rmax));
                  end if;

                  if R_ab > Rmax then
                     Rmax := R_ab;

                     if debug then
                        Put_Line("New Rmax = "&Img(Rmax));
                     end if;

                  end if;

                  if Rmax >= Analysis_Bound
                  then
                     if Verbose then
                        Put(" Task over its Analysis Bound");
                     end if;
                     Changes_Made := True;
                     for K in J .. Transaction (I).Ni loop
                        Transaction (I).The_Task (K).Model := Unbounded_Effects;
                        Transaction (I).The_Task (K).Rij   := Large_Time;
                        if K < Ni then
                           Transaction (I).The_Task (K).Jij := Large_Time;
                        end if;
                     end loop;

                     Over_Analysis_Bound := True;

                  end if;

                  exit when
                    Transaction (I).The_Task (J).Model = Unbounded_Effects;
               end if;
               Next(Psi_Cursor);
            end loop;
            exit when Transaction (I).The_Task (J).Model = Unbounded_Effects;
         end loop;

         if Rmax > Transaction (I).The_Task (J).Rij then
            Changes_Made := True;
            Transaction (I).The_Task (J).Rij := Rmax;
            if debug then
               Put_Line("New Rij");
               Put_Line("Rij = "&Img(Rmax));
            end if;
         end if;
      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (I).The_Task (J).Model = Unbounded_Response then
         Transaction (I).The_Task (J).Rij := Large_Time;
      end if;
      
      if debug then
         Put_Line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
      end if;

   end Holistic_Task_EDF_Local;


   ------------------------------
   -- Holistic_Task_EDF_Global --
   ------------------------------

   procedure Holistic_Task_EDF_Global
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      Transaction : Translation.Linear_Transaction_System renames My_System;

      --Set_Psi          : array (1 .. 50000) of Time;
      Wbusy            : Time;
      pL               : Long_Int;
      --N_PSI, cnt       : Integer;
      Rmax, R_ab, W_ab : Time;
      Ni               : Task_ID_Type;

      Debug : constant Boolean := false;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Long_Int) return Long_Int is
      begin
         if X < 0 or else Y < 0 then
            return 0;
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;

      -----------------
      -- Busy_Period --
      -----------------

      function Busy_Period
        (a    : Transaction_ID_Type;
         b    : Task_ID_Type)
        return Time
      is
         Wc, Wcant : Time;
         Proc      : Processor_ID_Type;
         Done      : Boolean;
      begin

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Transaction (a).The_Task (b).Cij;

         loop
            Wc := Ceiling (Wcant / Transaction (a).The_Task (b).Tij) *
              Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and then
                    not ((I = a) and then (J = b))
                  then
                     Wc := Wc +
                       Ceiling
                         ((Wcant + Transaction (I).The_Task (J).Jij) /
                            Transaction (I).The_Task (J).Tij) *
                       Transaction (I).The_Task (J).Cij;
                  end if;
               end loop;
            end loop;
            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end Busy_Period;


      ----------------------------------------
      -- Wij used for Global EDF Priorities --
      ----------------------------------------

      function Wij_EDF_Global
        (i    : Transaction_ID_Type;
         j    : Task_ID_Type;
         t    : Time;
         D    : Time)
        return Time
      is
         pt, pd : Long_Int;
      begin

         pt := Long_Int (Ceiling
                           ((t + Transaction (i).The_Task (j).Jij) /
                              Transaction (i).The_Task (j).Tij));

         pd := Long_Int (Floor
                           ((Transaction (i).The_Task (j).Jij +
                               D -
                               Transaction (i).The_Task (j).SDij) /
                              Transaction (i).The_Task (j).Tij)) + 1;

         return Time (Min0 (pt, pd)) * Transaction (i).The_Task (j).Cij;
      end Wij_EDF_Global;

      --------------------
      -- Wab_EDF_Global --
      --------------------

      function Wab_EDF_Global
        (a    : Transaction_ID_Type;
         b    : Task_ID_Type;
         p    : Long_Int;
         D    : Time)
        return Time
      is
         Wc, Wcant : Time;
         Proc      : Processor_ID_Type;
         Done      : Boolean;
      begin
         if Debug then
            Put_Line("Wab function");
            Put_Line("Wab_EDF_Global : a="&Img(Integer(a)));
            Put_Line("Wab_EDF_Global : b="&Img(Integer(b)));
            Put_Line("Wab_EDF_Global : p="&img(p));
            Put_Line("Wab_EDF_Global : D="&Img(D));
         end if;

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Time (p) * Transaction (a).The_Task (b).Cij;
         loop
            if Debug then
               Put_Line("Wab_EDF_Global : Wcant="&Img(Wcant));
            end if;
            Wc := Time (p) * Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and then
                    not ((I = a) and then (J = b))
                  then
                     Wc := Wc + Wij_EDF_Global (I, J, Wcant, D);
                     if Debug then
                        Put_Line("Wab_EDF_Global : Wc partial sum = "&Img(Wc));
                     end if;
                  end if;
               end loop;
            end loop;
            if Debug then
               Put_Line("Wab_EDF_Global : Wc final = "&Img(Wc));
            end if;
            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end Wab_EDF_Global;

      Psi : Time;
      Proc : Processor_ID_Type;



   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Transaction (I).The_Task (J).Model /= Unbounded_Response and then
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then

         Ni   := Transaction (I).Ni;
         Rmax  := 0.0;
         Wbusy := Busy_Period (I, J);
         pL :=
           Long_Int (Ceiling
                       ((Wbusy + Transaction (I).The_Task (J).Jij) /
                          Transaction (I).The_Task (J).Tij));

         if Debug then
            New_Line;
            Put_Line("Wbusy = "&Img(Wbusy));
            Put_Line("pL = "&img(pL));
         end if;

         for p in 1 .. pL loop

            if Debug then
               Put_Line("p = "&img(p));
            end if;

            Proc  := Transaction (I).The_Task (J).Procij;
            for A in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (A).Ni = 0;
               for B in 1 .. Transaction (A).Ni loop
                  if Transaction (A).The_Task (B).Procij = Proc then
                     for P_for_psi in
                       1 .. Long_Int (Ceiling
                                        ((Wbusy +
                                            Transaction (A).The_Task (B).Jij) /
                                           Transaction (A).The_Task (B).Tij))
                     loop

                        if Debug then
                           Put_Line("A,B = "&Img(Integer(A))&","&Img(Integer(B)));
                           Put_Line("p_psi = "&img(P_for_psi));
                        end if;

                        Psi :=
                          Time (P_for_psi - 1) * Transaction (A).The_Task (B).Tij -
                          Transaction (A).The_Task (B).Jij +
                          Transaction (A).The_Task (B).SDij;

                        if Debug then
                           Put_Line("psi = "&Img(Psi));
                           Put_Line("? psi >= "&Img((Time (p - 1) * Transaction (I).The_Task (J).Tij -
                                                       Transaction (I).The_Task (J).Jij +
                                                       Transaction (I).The_Task (J).SDij)));
                           Put_Line("psi < "&Img((Time (p) * Transaction (I).The_Task (J).Tij -
                                                    Transaction (I).The_Task (J).Jij +
                                                    Transaction (I).The_Task (J).SDij)));
                        end if;

                        --------------------

                        if Psi >=
                          (Time (p - 1) * Transaction (I).The_Task (J).Tij -
                             Transaction (I).The_Task (J).Jij +
                             Transaction (I).The_Task (J).SDij) and then
                          Psi <
                          (Time (p) * Transaction (I).The_Task (J).Tij -
                             Transaction (I).The_Task (J).Jij +
                             Transaction (I).The_Task (J).SDij)
                        then

                           W_ab := Wab_EDF_Global (I, J, p, Psi);

                           if Debug then
                              Put_Line("W_ab = "&Img(W_ab));
                           end if;


                           R_ab := W_ab -
                             Psi +
                             Transaction (I).The_Task (J).SDij +
                             Transaction (I).The_Task (J).Oij;

                           if Debug then
                              Put_Line("R_ab = "&Img(R_ab));
                              Put_Line("Rmax = "&Img(Rmax));
                           end if;

                           if R_ab > Rmax then
                              Rmax := R_ab;
                              if Debug then
                                 Put_Line("New Rmax = "&Img(Rmax));
                              end if;
                           end if;

                           if  Rmax >= Analysis_Bound
                           then
                              if Verbose then
                                 Put(" Task over its Analysis Bound");
                              end if;
                              Changes_Made := True;
                              for K in J .. Transaction (I).Ni loop
                                 Transaction (I).The_Task (K).Model :=
                                   Unbounded_Effects;
                                 Transaction (I).The_Task (K).Rij   :=
                                   Large_Time;
                                 if K < Ni then
                                    Transaction (I).The_Task (K).Jij :=
                                      Large_Time;
                                 end if;
                              end loop;

                              Over_Analysis_Bound := True;

                           end if;

                           exit when Transaction (I).The_Task (J).Model =
                             Unbounded_Effects;
                        end if;

                        ---------------------

                     end loop;
                  end if;
                  exit when Transaction (I).The_Task (J).Model =
                    Unbounded_Effects;
               end loop;
               exit when Transaction (I).The_Task (J).Model =
                 Unbounded_Effects;
            end loop;

            exit when Transaction (I).The_Task (J).Model = Unbounded_Effects;
         end loop;

         if Rmax > Transaction (I).The_Task (J).Rij then
            Changes_Made := True;
            Transaction (I).The_Task (J).Rij := Rmax;

            if Debug then
               Put_Line("New Rij");
               Put_Line("Rij = "&Img(Rmax));
            end if;

         end if;

         if Rmax > Analysis_Bound then
            Rmax := Analysis_Bound;
            Over_Analysis_Bound := True;
         end if;

      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (I).The_Task (J).Model = Unbounded_Response then
         Transaction (I).The_Task (J).Rij := Large_Time;
      end if;
      
      if Debug then
         Put_Line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
      end if;

   end Holistic_Task_EDF_Global;


   --------------------------------------
   -- Offset_Based_Approx_W_Pr_Task_Fp --
   --------------------------------------

   procedure Offset_Based_Approx_W_Pr_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      Debug : constant boolean := debug_global;

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : constant Transaction_ID_Type := I;
      B                  : constant Task_ID_Type        := J;
      P0, Pl             : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;
      pragma Unreferenced (Di);

      H : Task_ID_Type;
      
      -- mgh june 2025: Removed this function as the optimization that 
      -- it applied was considered too aggressive, leading to optimistic 
      -- results
      -------------------
      -- First_In_Hseg --
      -------------------

      -- function First_In_Hseg
      --   (I    : Transaction_ID_Type;
      --    J    : Task_ID_Type;
      --    Prio : Priority;
      --    Proc : Processor_ID_Type)
      --   return Task_ID_Type
      -- is
      --    H : Task_ID_Type;
      -- begin
      --    H := J;
      --    loop
      --       -- Added this exit condition to take into account that an offset
      --       -- or delay block prior to task J interrupt the H segment
      --       exit when Transaction (I).The_Task (H).Delayijmin /= 0.0
      --         or else Transaction (I).The_Task (H).Oijmin /= 0.0;

      --       exit when (H = 1)
      --         or else ((Transaction (I).The_Task (H - 1).Prioij <
      --                     Prio) or else
      --                    (Transaction (I).The_Task (H - 1).Procij /=
      --                       Proc));
      --       H := H - 1;
      --    end loop;
      --    return H;
      -- end First_In_Hseg;

      -------------
      -- Modulus --
      -------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;

      -----------
      -- In_MP --
      -----------
      -- Checks if task J in transaction I belongs to the set MP_i
      -- as defined in Equation (22) in RTSS-99 paper, when analysing a task
      -- of priority Prio executing in processor Proc
      -- The MP_i set denotes tasks in the first H section

      function In_MP
        (I    : Transaction_ID_Type;
         J    : Task_ID_Type;
         Prio : Priority;
         Proc : Processor_ID_Type)
        return Boolean
      is
      begin
         for L in 1 .. J loop
            if (Transaction (I).The_Task (L).Procij = Proc) and then
              (Transaction (I).The_Task (L).Prioij < Prio)
            then
               return False;
            end if;
         end loop;
         return True;
      end In_MP;
      
      ------------
      -- In_XPi --
      ------------
      -- Equation (27) in RTSS 99 paper.  Returns whether or not task
      -- K in transaction I belongs to the XPi(tau_ab) set, which is
      -- the set of potential tasks of transaction A that can initiate
      -- a critical instant for task tau_ab
      -- mgh june 2025: added this new function to group conditions that 
      -- were repeated in the code
      
      function In_Xpi 
        (I: Transaction_ID_Type;
         K: Task_ID_Type;
         A:Transaction_ID_Type;
         B:Task_ID_Type) 
        return Boolean 
      is
      begin
         return (Transaction(I).The_Task(K).Prioij>=
                   Transaction(A).The_Task(B).Prioij) and then
           (Transaction(I).The_Task(K).Procij=
                 Transaction(A).The_Task(B).Procij) and then
           Transaction(I).The_Task(K).Model /= Unbounded_Effects and then
           ((K=1) or else
              -- has external delay
              (Transaction(I).The_Task(K).Delayijmin/=0.0) or else
              (Transaction(I).The_Task(K).Delayijmax/=0.0) or else
              -- has external offset
              (Transaction(I).The_Task(K).Oijmin/=0.0) or else
              (Transaction(I).The_Task(K).Oijmax/=0.0) or else
              -- predecessor is not in same processor
              (Transaction(I).The_Task(K-1).Procij/=
                 Transaction(A).The_Task(B).Procij) or else
              -- predecessor has less priority
              (Transaction(I).The_Task(K-1).Prioij<
                 Transaction(A).The_Task(B).Prioij));
      end In_Xpi;
      
      ------------
      -- Ceil0 --
      ------------

      function Ceil0 (X : Time) return Time is
      begin
         if X < 0.0 then
            return 0.0;
         else
            return Ceiling (X);
         end if;
      end Ceil0;

      -----------
      -- FTijk --
      -----------
      -- Equation (17) in RTSS-99 paper 

      function FTijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
      begin
         return Transaction (I).The_Task (K).Tij -
           Modulus
             (Transaction (I).The_Task (K).Oij +
                Transaction (I).The_Task (K).Jij,
              Transaction (I).The_Task (K).Tij) +
           Transaction (I).The_Task (J).Oij;
      end FTijk;

      ------------
      -- Same_H --
      ------------
      -- Checks if tasks J and K in transaction I belong to 
      -- the same H section in the analysis of a task of priority Prio

      function Same_H
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type;
         Prio : Priority)
        return Boolean
      is
         Jj, Kk : Task_ID_Type;
      begin
         if J > K then
            Jj := K;
            Kk := J;
         else
            Jj := J;
            Kk := K;
         end if;
         for L in Jj .. Kk loop
            if (Transaction (I).The_Task (L).Procij =
                  Transaction (I).The_Task (Jj).Procij) and then
              (Transaction (I).The_Task (L).Prioij < Prio)
            then
               return False;
            end if;
         end loop;
         return True;
      end Same_H;

      -----------------------
      -- Resolve_Conflicts --
      -----------------------
      -- function RESOLVE_CONFLICTS in RTSS 99 paper.
      -- Returns the interference caused by tasks of transaction I at
      -- time T when analyzing task B in transaction A in a critical
      -- instant initiated by task K in transaction I, taking into
      -- account the possible conflicts and only jobs activated prior
      -- to the critical instant (with p'<=0)

      function Resolve_Conflicts
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         T    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         The_First_P, P0, P0kk      : Long_Int;
         Proc                       : Processor_ID_Type;
         Prio                       : Priority;
         J, H                       : Task_ID_Type;
         Total, PLinkial, Sum, Cell : Time;
      begin
         Total := 0.0;
         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         J     := Transaction (I).Ni;
         loop
            exit when (Transaction (I).The_Task (J).Procij = Proc) and then
              (Transaction (I).The_Task (J).Prioij >= Prio);
            J := J - 1;
         end loop;
         -- mgh june 2025: This optimization using the first task in the H 
         -- section is too aggressive. It has been suppressed and J is
         -- used for the H value
         -- H           := First_In_Hseg (I, J, Prio, Proc);
         H := J;
         -- Equation (19) in RTSS 99 paper
         The_First_P :=
           Long_Int (-Floor
                       ((Transaction (I).The_Task (H).Jij +
                           FTijk (I, H, K)) /
                          Transaction (I).The_Task (K).Tij) +
                       Time'(1.0));
         P0kk        :=
           Long_Int (-Floor
                       ((Transaction (I).The_Task (K).Jij +
                           FTijk (I, K, K)) /
                          Transaction (I).The_Task (K).Tij) +
                       Time'(1.0));

         if Debug then
            Put_Line("rc I ="&I'img);
            Put_Line("rc H ="&H'img);
            Put_Line("rc Jih ="&Transaction(I).The_Task(H).Jij'img);
            Put_Line("rc FTikk ="&FTijk(I,K,K)'img);
            Put_Line("rc Tik ="&Transaction(I).The_Task(K).Tij'img);
            Put_Line("rc The_First_P ="&The_First_P'img);
            Put_Line("rc P0kk ="&P0kk'img);
         end if;

         for P in The_First_P .. 0 loop
            PLinkial := 0.0;
            Sum      := 0.0;
            for J in 1 .. Transaction (I).Ni loop
               if Transaction (I).The_Task (J).Procij = Proc then
                  if Transaction (I).The_Task (J).Prioij >= Prio then
                     Cell := 0.0;
                     -- mgh june 2025: Suppressed optimization. Now using J 
                     -- H:=First_In_Hseg(I,J,Prio,Proc);
                     -- H    := First_In_Hseg (I, J, Prio, Proc);
                     H := J;
                     P0   :=
                       Long_Int (-Floor
                                   ((Transaction (I).The_Task (H).Jij +
                                       FTijk (I, H, K)) /
                                      Transaction (I).The_Task (K).Tij) +
                                   Time'(1.0));
                     -- The implementation adds (P-1) periods
                     -- instead of -(P-1) described in the RTSS 99
                     -- paper; this was an error in the paper, caused
                     -- by the fact that P is negative in this case
                     if (P >= P0) and then
                       (T > FTijk (I, H, K) +
                          Time (P - 1) * Transaction (I).The_Task (K).Tij)
                     then
                        Cell := Transaction (I).The_Task (J).Cij;
                     end if;
                     if J > K and then
                       P >= P0kk and then
                       not Same_H (I, J, K, Prio)
                     then
                        Cell := 0.0;
                     end if;
                     Sum := Sum + Cell;
                  else
                     Sum := 0.0;
                  end if;
                  if Sum > PLinkial then
                     PLinkial := Sum;
                  end if;
               end if;
            end loop;
            Total := Total + PLinkial;
         end loop;
         return Total;
      end Resolve_Conflicts;

      ------------
      -- Wik_LH --
      ------------
      -- Equation (24) in RTSS 99 paper.  This function
      -- returns the interference caused at time T by tasks in
      -- transaction I when analyzing task B in transaction A in a
      -- critical instant created with task K in transaction I.
      -- Similar to Resolve_Conflicts but adding the effects of jobs
      -- arriving after the critical instant and also managing jitter
      -- terms

      function Wik_LH
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         T    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         Acum        : Time;
         Prio        : Priority;
         Proc        : Processor_ID_Type;
         H           : Task_ID_Type;
         Aux_Jitters :
           array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;
      begin
         if T = 0.0 then
            return Transaction (I).The_Task (K).Cij;
         end if;

         -- Copy jitter terms into an auxiliar transaction
         -- to make zero all those marked as jitter_avoidance.
         -- Recover the original values at the end of the procedure.
         for J in 1 .. Transaction (I).Ni loop
            Aux_Jitters (J) := Transaction (I).The_Task (J).Jij;
            if Transaction (I).The_Task (J).Jitter_Avoidance then
               Transaction (I).The_Task (J).Jij := 0.0;
            end if;
         end loop;

         Acum := Resolve_Conflicts (I, K, T, A, B);
         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;

         if Debug then
            Put_Line("acum1 ="&Acum'img);
            Put_Line("proc ="&Proc'img);
            Put_Line("prio ="&Proc'img);
         end if;
         
         for J in 1 .. Transaction (I).Ni loop
            --mgh 2026: remove
            --if A=1 and then B=2 then
            --   Put_Line("In MP A=1 B=2 J="&J'Img&" In_MP="&In_Mp(I, J, Prio, Proc)'Img);
            --end if;

            if (Transaction (I).The_Task (J).Procij = Proc) and then
              In_MP (I, J, Prio, Proc)
            then
               if Transaction (I).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  -- mgh june 2025: Suppressed optimization using the
                  -- First_In_Hseg function The value J is used
                  -- instead 
                  -- H    := First_In_Hseg (I, J, Prio, Proc);
                  H := J;
                  Acum := Acum +
                    Ceil0
                      ((T - FTijk (I, H, K)) /
                         Transaction (I).The_Task (J).Tij) *
                    Transaction (I).The_Task (J).Cij;
               end if;
            end if;

         end loop;

         for J in 1 .. Transaction (I).Ni loop
            Transaction (I).The_Task (J).Jij := Aux_Jitters (J);
         end loop;
         return Acum;
      end Wik_LH;

      -----------------
      -- Busy_Period --
      -----------------
      -- Equation (39) in RTSS 99 paper.  This function
      -- returns the length of the busy period of task B in Transaction
      -- A when the critical instant is created with task C in the same
      -- transaction.

      function Busy_Period
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type)
        return Time
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         -- mgh june 2025: unnecessary variables, since the conditions
         -- are now checked in function In_XPi
         -- Prio                     : Priority;
         -- Proc                     : Processor_ID_Type;
         Done                     : Boolean;

         -- N : Integer := 1;

      begin
         -- Proc  := Transaction (A).The_Task (B).Procij;
         -- Prio  := Transaction (A).The_Task (B).Prioij;
         Wcant := Transaction (A).The_Task (B).Cijown +
           Transaction (A).The_Task (B).Bij;
         if Debug then
            Put_Line("wcant ="&Wc'img);
         end if;
         loop
            Wc := Wik_LH (A, C, Wcant, A, B) +
              Transaction (A).The_Task (B).Bij;

            if Debug then
               Put_Line("wc1 ="&Wc'img);
            end if;

            for I in 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               if I /= A then
                  MaxWik := 0.0;
                  for K in 1 .. Transaction (I).Ni loop
                     -- mgh: june 2025. We group the conditions into a
                     -- new function In_XPi, whixh adds more
                     -- conditions for maximum offsets and delays
                     if In_Xpi(I,K,A,B)
                       -- (Transaction (I).The_Task (K).Procij = Proc) and then
                       -- (Transaction (I).The_Task (K).Prioij >= Prio) and then
                       -- not ((I = A) and then (K = B)) and then
                       -- ((K = 1)
                       --    or else (Transaction (I).The_Task (K).Delayijmin /=
                       --               0.0)
                       --    or else (Transaction (I).The_Task (K).Oijmin /= 0.0)
                       --    or else (Transaction (I).The_Task (K - 1).Procij /=
                       --               Proc)
                       --    or else (Transaction (I).The_Task (K - 1).Prioij <
                       --               Prio))
                     then
                        Wc_Ik := Wik_LH (I, K, Wcant, A, B);
                        if Wc_Ik > MaxWik then
                           MaxWik := Wc_Ik;
                        end if;
                     end if;
                  end loop;

                  Wc := Wc + MaxWik;

                  if Debug then
                     Put_Line("maxwik ="&MaxWik'img);
                     Put_Line("wc2 ="&Wc'img);
                  end if;

               end if;
            end loop;

            if Debug then
               Put_Line("fin wcant ="&Wcant'img);
               Put_Line("fin wc ="&Wc'img);
            end if;

            Done  := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end Busy_Period;

      ------------------
      -- Calculate_PL --
      ------------------
      -- Equations (40) and (41) in the RTSS 99 paper.
      -- Returns the highest numbered job in the busy period of task B
      -- in Transaction A when the critical instant is created with
      -- task C in the same transaction.

      function Calculate_PL
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type)
        return Long_Int
      is
         Prio : Priority;
         Proc : Processor_ID_Type;
         H    : Task_ID_Type;
      begin
         Prio := Transaction (A).The_Task (B).Prioij;
         Proc := Transaction (A).The_Task (B).Procij;
         -- mgh june 2025: Suppressed this optimization. Using B instead of
         -- First_in_Hseg
         -- H    := First_In_Hseg (A, B, Prio, Proc);
         H := B;
         if In_MP (A, B, Prio, Proc) then
            -- Task B is in first H section for transaction A
            -- in relation with the priority and processor of tau_ab            
            return Long_Int (Ceil0
                               ((Busy_Period (A, B, C) - FTijk (A, H, C)) /
                                  Transaction (A).The_Task (C).Tij));

         elsif (C < B) and then not Same_H (A, B, C, Prio) then
            -- Equation (51) in Chapter 5 of J.C.Palencia's PhD Thesis
            -- Task C is not in the first H-section, but in an
            -- H-section previous to tau_ab's
            return Long_Int (-Floor
                               ((Transaction (A).The_Task (C).Jij +
                                   FTijk (A, C, C)) /
                                  Transaction (A).The_Task (C).Tij));
         else
            -- When task C is not in the first H-section and
            -- is in the same section as tau_ab the jobs after the
            -- critical instant cannot interfere
            return 0;
         end if;
      exception
         when Constraint_Error =>
            return Long_Int'Last;
      end Calculate_PL;

      ----------------------------
      -- Resolve_Self_Conflicts --
      ----------------------------
      -- Function RESOLVE_CONFLICTS_In_T_a in RTSS 99
      -- paper. Returns the interference caused by tasks of
      -- transaction A at time T when analyzing job Pa in task B in
      -- the same transaction A in a critical instant initiated by
      -- task C in the same transaction, taking into account the
      -- possible conflicts and only jobs activated prior to the
      -- critical instant (with p'<=0) Pa is the value used for p'_ab
      -- in the paper.

      function Resolve_Self_Conflicts
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type;
         T    : Time;
         Pa   : Long_Int)
        return Time
      is
         The_First_P, P0, P0cc      : Long_Int;
         Proc                       : Processor_ID_Type;
         Prio                       : Priority;
         J, H                       : Task_ID_Type;
         Total, PLinkial, Sum, Cell : Time;
      begin
         Total := 0.0;
         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         J     := Transaction (A).Ni;
         loop
            exit when (Transaction (A).The_Task (J).Procij = Proc) and then
              (Transaction (A).The_Task (J).Prioij >= Prio);
            J := J - 1;
         end loop;
         -- mgh june 2025: Suppressed optimization using the
         -- First_In_Hseg function The value J is used instead
         -- H           := First_In_Hseg (A, J, Prio, Proc);
         H := J;
         The_First_P :=
           Long_Int (-Floor
                       ((Transaction (A).The_Task (H).Jij +
                           FTijk (A, H, C)) /
                          Transaction (A).The_Task (C).Tij) +
                       Time'(1.0));
         P0cc        :=
           Long_Int (-Floor
                       ((Transaction (A).The_Task (C).Jij +
                           FTijk (A, C, C)) /
                          Transaction (A).The_Task (C).Tij) +
                       Time'(1.0));
         for P in The_First_P .. 0 loop
            PLinkial := 0.0;
            Sum      := 0.0;
            for J in 1 .. Transaction (A).Ni loop
               if Transaction (A).The_Task (J).Procij = Proc then
                  if Transaction (A).The_Task (J).Prioij >= Prio then
                     Cell := 0.0;
                     -- mgh june 2025: Suppressed optimization using the
                     -- First_In_Hseg function The value J is used
                     -- instead 
                     -- H    := First_In_Hseg (A, J, Prio, Proc);
                     H := J;
                     P0   :=
                       Long_Int (-Floor
                                   ((Transaction (A).The_Task (H).Jij +
                                       FTijk (A, H, C)) /
                                      Transaction (A).The_Task (C).Tij) +
                                   Time'(1.0));
                     if (P >= P0) and then
                       (T >
                          FTijk (A, H, C) +
                          Time (P - 1) * Transaction (A).The_Task (C).Tij)
                     then
                        Cell := Transaction (A).The_Task (J).Cij;
                     end if;
                     if (J > C) and then
                       (P >= P0cc) and then
                       not Same_H (A, J, C, Prio)
                     then
                        Cell := 0.0;
                     end if;
                     if (J < B) and then
                       (P <= Pa) and then
                       not Same_H (A, J, B, Prio)
                     then
                        Cell := 0.0;
                     end if;
                     if ((J >= B) and then (P > Pa)) or else
                       ((J > B) and then (P = Pa))
                     then
                        Cell := 0.0;
                     end if;
                     Sum := Sum + Cell;
                  else
                     Sum := 0.0;
                  end if;
                  if Sum > PLinkial then
                     PLinkial := Sum;
                  end if;
               end if;
            end loop;
            Total := Total + PLinkial;
         end loop;
         return Total;
      end Resolve_Self_Conflicts;

      ------------
      -- Wac_LH --
      ------------
      -- Equation (36) in RTSS 99
      -- paper. Returns the interference caused by tasks of
      -- transaction A at time T when analyzing job P in task B in
      -- the same transaction A in a critical instant initiated by
      -- task C in the same transaction, taking into account the
      -- possible conflicts and only jobs activated prior to the
      -- critical instant (with p'<=0). P is the value used for p'_ab
      -- in the paper.
      -- Similar to Resolve_Self_Conflicts but adding the effects of jobs
      -- arriving after the critical instant and also managing jitter
      -- terms

      function Wac_LH
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type;
         T    : Time;
         P    : Long_Int)
        return Time
      is
         Acum, Post  : Time;
         Prio        : Priority;
         Proc        : Processor_ID_Type;
         H           : Task_ID_Type;
         Aux_Jitters :
           array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;
      begin
         -- Copy jitter terms into an auxiliar transaction
         -- to make zero all those marked as jitter_avoidance.
         -- Recover the original values at the end of the procedure.
         for J in 1 .. Transaction (A).Ni loop
            Aux_Jitters (J) := Transaction (A).The_Task (J).Jij;
            if Transaction (A).The_Task (J).Jitter_Avoidance then
               Transaction (A).The_Task (J).Jij := 0.0;
            end if;
         end loop;

         Acum := Resolve_Self_Conflicts (A, B, C, T, P);
         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;
         Post := Time (P) * Transaction (A).The_Task (B).Cijown;
         for J in 1 .. Transaction (A).Ni loop
            if (Transaction (A).The_Task (J).Procij = Proc) and then
              In_MP (A, J, Prio, Proc)
            then
               if Transaction (A).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  -- mgh june 2025: Suppressed optimization using the
                  -- First_In_Hseg function The value B is used
                  -- instead 
                  -- H := First_In_Hseg (A, B, Prio, Proc);
                  H := B;
                  if J < B then
                     Acum := Acum +
                       Ceil0
                         ((T - FTijk (A, H, C)) /
                            Transaction (A).The_Task (J).Tij) *
                       Transaction (A).The_Task (J).Cij;
                  end if;
                  if J > B then
                     Post :=
                       Post +
                       Time'Min
                         (Time (P - 1),
                          Ceil0
                            ((T - FTijk (A, H, C)) /
                               Transaction (A).The_Task (J).Tij)) *
                       Transaction (A).The_Task (J).Cij;
                  end if;
               end if;
            end if;
         end loop;

         for J in 1 .. Transaction (A).Ni loop
            Transaction (A).The_Task (J).Jij := Aux_Jitters (J);
         end loop;

         return Acum + Time'Max (0.0, Post);
      end Wac_LH;

      -------------
      -- W_DO_LH --
      -------------
      -- Equation (37) in RTSS 99 paper.  This function
      -- returns the completion time of the Pth job of task B in
      -- transaction A when task C in the same transaction creates the
      -- critical instat

      function W_DO_LH
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type;
         P    : Long_Int)
        return Time
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         -- mgh june 2025: unnecessary variables, since the conditions
         -- are now checked in function In_XPi
         -- Prio                     : Priority;
         -- Proc                     : Processor_ID_Type;
         Done                     : Boolean;
         P0                       : Long_Int;
      begin
         -- Proc  := Transaction (A).The_Task (B).Procij;
         -- Prio  := Transaction (A).The_Task (B).Prioij;
         P0    :=
           -Long_Int (Floor
                        ((Transaction (A).The_Task (B).Jij +
                            FTijk (A, B, C)) /
                           Transaction (A).The_Task (B).Tij)) +
           1;
         Wcant := Time (P - P0 + 1) * Transaction (A).The_Task (B).Cijown +
           Transaction (A).The_Task (B).Bij;

         --if wcant=0.0 then wcant:=2.0*epsilon;end if;
         loop
            Wc := Wac_LH (A, B, C, Wcant, P) +
              Transaction (A).The_Task (B).Bij;
            for I in 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               if I /= A then
                  MaxWik := 0.0;
                  for K in 1 .. Transaction (I).Ni loop
                     -- mgh: june 2025. We group the conditions into a
                     -- new function In_XPi, whixh adds more
                     -- conditions for maximum offsets and delays
                     if In_Xpi(I,K,A,B)
                       -- (Transaction (I).The_Task (K).Procij = Proc) and then
                       -- (Transaction (I).The_Task (K).Prioij >= Prio) and then
                       -- not ((I = A) and then (K = B)) and then
                       -- ((K = 1)
                          
                       --    --mgh: jul 2023, we add the following two conditions
                       --    -- to interrupt an H segment if there is a delay
                       --    -- or offset block.
                          
                       --    or else (Transaction (I).The_Task (K).Delayijmin /= 0.0)
                       --    or else (Transaction (I).The_Task (K).Oijmin /= 0.0)

                          
                       --    or else (Transaction (I).The_Task (K - 1).Procij /=
                       --               Proc)
                       --    or else (Transaction (I).The_Task (K - 1).Prioij <
                       --               Prio))
                     then
                        Wc_Ik := Wik_LH (I, K, Wcant, A, B);
                        if Wc_Ik > MaxWik then
                           MaxWik := Wc_Ik;
                        end if;
                     end if;
                  end loop;
                  Wc := Wc + MaxWik;
               end if;
            end loop;
            Done  := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end W_DO_LH;



   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      -----------------------
      ------ MAIN PROC ------
      -----------------------

      Transaction (A).The_Task (B).Tij := Transaction (A).The_Task (B).Tijown;

      -- April 2025: Added the large_time cases
      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects and then
        Transaction (A).The_Task (B).Jij /= Large_Time and then
        Transaction (A).The_Task (B).Rij /= Large_Time
      then

         if debug_global then
            New_Line;
            for Z in 1..Max_Transactions loop
               for X in 1..Transaction(Z).Ni loop
                  Put(" "&Transaction(Z).The_Task(X).Jij'Img);
               end loop;
               New_Line;
            end loop;
            --Put_line("I,J : "&A'Img&","&B'Img);
            --Put_line("J : "&Transaction(A).The_Task(B).Jij'Img);
            --Put_line("R : "&Transaction(A).The_Task(B).Rij'Img);
         end if;
         -- mgh june 2025: Suppressed optimization. Using B instead
         -- of First_in_H_Seg
         
         -- H                   :=
         --   First_In_Hseg
         --     (A,
         --      B,
         --      Transaction (A).The_Task (B).Prioij,
         --      Transaction (A).The_Task (B).Procij);
         H := B;
         Rmax                := 0.0;
         Over_Analysis_Bound := False;
         -- Loop for all tasks in the current transaction
         for C in 1 .. Transaction (A).Ni loop

            if (Transaction (A).The_Task (C).Prioij >=
                  Transaction (A).The_Task (B).Prioij) and then
              (Transaction (A).The_Task (C).Procij =
                 Transaction (A).The_Task (B).Procij) and then
              Transaction (A).The_Task (B).Model /= Unbounded_Effects and then
              ((C = 1)
                 or else (Transaction (A).The_Task (C).Delayijmin /= 0.0)
                 or else (Transaction (A).The_Task (C).Oijmin /= 0.0)
                 or else (Transaction (A).The_Task (C - 1).Procij /=
                            Transaction (A).The_Task (B).Procij)
                 or else (Transaction (A).The_Task (C - 1).Prioij <
                            Transaction (A).The_Task (B).Prioij))

            then
               P0 :=
                 Long_Int (-Floor
                             ((Transaction (A).The_Task (H).Jij +
                                 FTijk (A, H, C)) /
                                Transaction (A).The_Task (B).Tijown) +
                             Time'(1.0));
               Pl := Calculate_PL (A, B, C);
               if Pl = Long_Int'Last then
                  for K in B .. Transaction (A).Ni loop
                     Transaction (A).The_Task (K).Model := Unbounded_Effects;
                     Transaction (A).The_Task (K).Rij   := Large_Time;
                  end loop;
               else
                  for P in P0 .. Pl loop
                     if Transaction (A).The_Task (B).Model /=
                       Unbounded_Effects
                     then
                        W_Abc := W_DO_LH (A, B, C, P);
                        
                        --mgh 2026: remove
                        if A=1 then
                           Put_Line("In W_DO_LH A=1 B="&B'Img&" C="&C'Img&" P="&P'Img&" W_Abc="&W_Abc'Img);
                        end if;
                        
                        if Debug then
                           Put_Line("W_Abc= "&W_Abc'Img);
                        end if;
                        R_Abc := W_Abc -
                          FTijk (A, B, C) -
                          Time (P - 1) *
                          Transaction (A).The_Task (B).Tijown +
                          Transaction (A).The_Task (B).Oij;
                        
                        --mgh 2026: remove
                        if A=1 and then B=2 then
                           Put_Line("In R_Abc A=1 B=2 C="&C'Img&" P="&P'Img&" R_Abc="&R_Abc'Img);
                        end if;

                        if R_Abc > Rmax then
                           Rmax := R_Abc;
                        end if;
                        
                        --mgh 2026: remove
                        if A=1 and then B=2 then
                           Put_Line("       A="&A'Img&" B="&B'Img);
                           Put_Line("       C="&C'Img);
                           Put_Line("       P="&P'Img);
                           Put_Line("       W_Abc="&W_Abc'Img);
                           Put_Line("       R_Abc="&R_Abc'Img);
                           Put_Line("       Rmax="&Rmax'Img);
                        end if;
                        

                        if Debug then
                           -- Put_line("      ");print_variation;
                           New_Line;
                           Put_Line("       P="&P'Img);
                           Put_Line("       W_Abc="&W_Abc'Img);
                           Put_Line("       R_Abc="&R_Abc'Img);
                           Put_Line("       Rmax="&Rmax'Img);
                        end if;

                        --- Determine if response time is higher than deadline
                        if Rmax >= Analysis_Bound
                        then
                           if Verbose then
                              Put(" Task over its Analysis Bound");
                           end if;
                           Changes_Made := True;
                           for K in J .. Transaction (I).Ni loop
                              Transaction (I).The_Task (K).Model :=
                                Unbounded_Effects;
                              Transaction (I).The_Task (K).Rij   := Large_Time;
                              if K < Ni then
                                 Transaction (I).The_Task (K).Jij := Large_Time;
                              end if;
                           end loop;

                           Over_Analysis_Bound := True;

                        end if;

                     end if;
                     exit when Transaction (I).The_Task (J).Model =
                       Unbounded_Effects;
                  end loop;
               end if;
            end if;
            exit when Transaction (I).The_Task (J).Model = Unbounded_Effects;
         end loop;
         
         if Rmax > Transaction (A).The_Task (B).Rij then
            Transaction (A).The_Task (B).Rij := Rmax;
            Changes_Made := True;
         end if;

         -------------------------------------------------
         -- The analysis needs Oij+Jij to be in non
         -- decreasing order for the tasks in a transaction
         -- If we find that case we estimate for the second
         -- task an Rij equal to the last task's Rij plus
         -- its own Cij
         for L in B + 1 .. Transaction (A).Ni loop
            if Transaction (A).The_Task (L).Rij <
              Transaction (A).The_Task (L - 1).Rij
            then
               Transaction (A).The_Task (L).Rij :=
                 Transaction (A).The_Task (L - 1).Rij +
                 Transaction (A).The_Task (L).Cij;
            
               --mgh 2026: remove
               if A=1 and then L=2 then
                  Put_Line("  Changed Rij="&Transaction (A).The_Task (L).Rij'Img);
               end if;
                        
            end if;
            
         end loop;
         -- As a result of applying Lemma 1, the estimation
         -- for a task ij may be better than for the previous
         -- task, because the Lemma may be applicable to that
         -- task ij but not to the preceding one
         -- In this case, we obtain a worst-case estimation for
         -- task ij-1 making its response time equal to
         -- Rij-1 = Rij-Cij}
         for L in reverse 1 .. B - 1 loop
            if Transaction (A).The_Task (L).Rij >
              Transaction (A).The_Task (L + 1).Rij
            then
               Transaction (A).The_Task (L).Rij :=
                 Transaction (A).The_Task (L + 1).Rij -
                 Transaction (A).The_Task (L + 1).Cij;
               --mgh 2026: remove
               if A=1 and then L=2 then
                  Put_Line("  Rev Changed Rij="&Transaction (A).The_Task (L).Rij'Img);
               end if;
                        
            end if;
         end loop;

         -- Jitter terms are reevaluated for all tasks,
         -- but this should be unnecessary, because it is done anyhow,
         -- at the end of the analysis for each task

         -- Reevaluate Jitters
         --  for L in 2 .. Transaction (A).Ni loop
         --     Transaction (A).The_Task (L).Jij :=
         --       Time'Max
         --       (Transaction (A).The_Task (L).Oijmax,
         --        Transaction (A).The_Task (L - 1).Rij +
         --          Transaction (A).The_Task (L).Delayijmax) +
         --       Transaction (A).The_Task (L).Jinit -
         --       Transaction (A).The_Task (L).Oij;
         --  end loop;

         --  if A < Max_Transactions
         --    and then Transaction (A + 1).Trans_Input_Type = Internal
         --  then
         --     Transaction (A + 1).The_Task (1).Jij :=
         --       Time'Max
         --       (Transaction (A + 1).The_Task (1).Oijmax,
         --        Transaction (A).The_Task (Transaction (A).Ni).Rij +
         --          Transaction (A + 1).The_Task (1).Delayijmax) +
         --       Transaction (A + 1).The_Task (1).Jinit -
         --       Transaction (A + 1).The_Task (1).Oij;
         --     for L in 2 .. Transaction (A + 1).Ni loop
         --        Transaction (A + 1).The_Task (L).Jij :=
         --          Time'Max
         --          (Transaction (A + 1).The_Task (L).Oijmax,
         --           Transaction (A + 1).The_Task (L - 1).Rij +
         --             Transaction (A + 1).The_Task (L).Delayijmax) +
         --          Transaction (A + 1).The_Task (L).Jinit -
         --          Transaction (A + 1).The_Task (L).Oij;
         --     end loop;
         --  end if;

      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response or else
        Transaction (A).The_Task (B).Jij = Large_Time 
      then
         for L in B .. Transaction(A).Ni loop
            Transaction (A).The_Task (L).Rij := Large_Time;
         end loop;
      end if;
      
      --mgh 2026: remove
      if A=1 and then B=2 then
         Put_Line("  Effective Rmax="&Rmax'Img&" B="&B'Img);
      end if;
                        
      
      
   end Offset_Based_Approx_W_Pr_Task_FP;

   ---------------------------------
   -- Offset_Based_Approx_Task_FP --
   ---------------------------------

   procedure Offset_Based_Approx_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : constant Transaction_ID_Type := I;
      B                  : constant Task_ID_Type        := J;
      P, P0              : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;
      pragma Unreferenced (Di);
      Debug : constant Boolean := (I=13) and then (J=2) and then debug_global;

      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;

      ----------
      -- Fijk --
      ----------

      function Fijk
        (I, L : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
         -- July 2019: L has been added as task K could belong to a different 
         -- transaction in the translated system
         -- So tasks (I,J) and (L,K) are managed
      begin
            
         -- mgh 2026: Changed False to True here:   
         if True then
            Put_Line("Fijk : I,J,L,K = "&Img(Integer(I))&","&Img(Integer(J))&
                       ","&Img(Integer(L))&","&Img(Integer(K)));
            Put_Line("Fijk : Tij = "&Img(Transaction (I).The_Task (J).Tij));
            Put_Line("Fijk : Olk = "&Img(Transaction (L).The_Task (K).Oij));
            Put_Line("Fijk : Jik = "&Img(Transaction (L).The_Task (K).Jij));
            Put_Line("Fijk : Oij = "&Img(Transaction (I).The_Task (J).Oij));
            Put_Line("Fijk : Mod = "&Img(Modulus
                                           (Transaction (L).The_Task (K).Oij +
                                              Transaction (L).The_Task (K).Jij -
                                              Transaction (I).The_Task (J).Oij,
                                            Transaction (I).The_Task (J).Tij)));
            Put_Line("Fijk : return = "&Img(Transaction (I).The_Task (J).Tij -
                                              Modulus
                                                (Transaction (L).The_Task (K).Oij +
                                                   Transaction (L).The_Task (K).Jij -
                                                   Transaction (I).The_Task (J).Oij,
                                                 Transaction (I).The_Task (J).Tij)));
         end if;

         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (L).The_Task (K).Oij +
                Transaction (L).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;

      ----------
      -- Wik --
      ----------
      -- July 2020: this function uses Fijk with transactions D and I 
      -- and tasks J and K
      
      function Wik
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         T    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         Acum        : Time := 0.0;
         Prio        : Priority;
         Proc        : Processor_ID_Type;
         -- July 2020: two-dimensional array to take into account 
         -- sub-transactions
         Aux_Jitters :
           array (Transaction_ID_Type range 1 .. Max_Transactions,
                  Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;

      begin

         if Debug then
            Put_Line("Wik function");
            Put_Line("Wik : I="&Img(Integer(I)));
            Put_Line("Wik : K="&Img(Integer(K)));
            Put_Line("Wik : T="&Img(T));
            Put_Line("Wik : A="&Img(Integer(A)));
            Put_Line("Wik : B="&Img(Integer(B)));
         end if;

         if T = 0.0 then
            if Debug then
               Put_Line("Wik : T=0 Return ="&Img(Transaction (I).The_Task (K).Cij));
            end if;
            return Transaction (I).The_Task (K).Cij;
         end if;         
         -- Copy jitter terms into an auxiliar transaction
         -- to make zero all those marked as jitter_avoidance.
         -- Recover the original values at the end of the procedure.
         for D in 1 .. Max_Transactions loop
            exit when Transaction (D).Ni = 0;
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then 
               for J in 1 .. Transaction (D).Ni loop
                  Aux_Jitters (D,J) := Transaction (D).The_Task (J).Jij;
                  if Transaction (D).The_Task (J).Jitter_Avoidance then
                     Transaction (D).The_Task (J).Jij := 0.0;
                  end if;
               end loop;
            end if;
         end loop;
         
         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;
         for D in 1 .. Max_Transactions loop
            exit when Transaction (D).Ni = 0;
            -- July 2020: check all translated transactions coming from the same one 
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then
               --Put_line("-------------------D = "&D'Img&"    I= "&I'Img);
               for J in 1 .. Transaction (D).Ni loop
                  if (Transaction (D).The_Task (J).Procij = Proc) and then
                    (Transaction (D).The_Task (J).Prioij >= Prio) and then
                    not ((D = A) and then (J = B))
                  then
                     if Transaction (D).The_Task (J).Model =
                       Unbounded_Effects
                     then
                        return Large_Time;
                     else
                        if Debug then
                           Put_Line("Wik : I,J ="&Img(Integer(D))&","&Img(Integer(J)));
                           Put_Line("Wik : Acum prev ="&Img(Acum));
                           Put_Line("Wik : Fijk ="&Img(Fijk (D, I, J, K)));
                           Put_Line("Wik : Jij ="&Img(Transaction (D).The_Task (J).Jij));
                           Put_Line("Wik : Tij ="&Img(Transaction (D).The_Task (J).Tij));
                        end if;
                        Acum :=
                          Acum +
                          (Floor
                             ((Transaction (D).The_Task (J).Jij + Fijk (D, I, J, K)) /
                                Transaction (D).The_Task (J).Tij) +
                             Ceiling
                               ((T - Fijk (D, I, J, K)) /
                                  Transaction (D).The_Task (J).Tij)) *
                          Transaction (D).The_Task (J).Cij;
                        if Debug then
                           Put_Line("Wik : Acum sum1 ="&Img(((Transaction (D).The_Task (J).Jij + Fijk (D, I, J, K)) /
                                                               Transaction (D).The_Task (J).Tij),10));
                           Put_Line("Wik : Acum floor ="&Img(Floor
                                                               ((Transaction (D).The_Task (J).Jij + Fijk (D, I, J, K)) /
                                                                  Transaction (D).The_Task (J).Tij),10));
                           Put_Line("Wik : Acum sum2 ="&Img(((T - Fijk (D, I, J, K)) /
                                                               Transaction (D).The_Task (J).Tij)));
                           Put_Line("Wik : Acum ceiling ="&Img(Ceiling
                                                                 ((T - Fijk (D, I, J, K)) /
                                                                    Transaction (D).The_Task (J).Tij)));
                           Put_Line("Wik : Acum ="&Img(Acum));
                        end if;
                     end if;
                  end if;
               end loop;  
            end if;
         end loop;
         
         for D in 1 .. Max_Transactions loop
            exit when Transaction (D).Ni = 0;
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then
               for J in 1 .. Transaction (D).Ni loop
                  Transaction (D).The_Task (J).Jij := Aux_Jitters (D,J);
               end loop;
            end if;
         end loop;

         return Acum;
      end Wik;

      ----------
      -- W_DO --
      ----------

      function W_DO
        (A, D : Transaction_ID_Type;
         B, C : Task_ID_Type;
         Q    : Long_Int)
        return Time
      -- July 2019: D has been added as task C could belong to a different 
      -- transaction in the translated system
      -- So tasks (A,B) and (D,C) are managed
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         Prio                     : Priority;
         Proc                     : Processor_ID_Type;
         Done                     : Boolean;
         Num_Trans                : Transaction_ID_Type := 0;
      begin
         
         -- mgh 2026:remove
         if A=1 and then B=2 then
            Put_Line("In W_DO A=1 B=2 C="&C'Img&" D="&D'Img&" Q="&Q'Img);
         end if;
         
         if Debug then
            Put_Line("W_DO function");
            Put_Line("W_DO : a="&Img(Integer(A)));
            Put_Line("W_DO : b="&Img(Integer(B)));
            Put_Line("W_DO : d="&Img(Integer(D)));
            Put_Line("W_DO : c="&Img(Integer(C)));
            Put_Line("W_DO : q="&img(Q));
         end if;

         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         Wcant := Time (Q) * Transaction (A).The_Task (B).Cijown +
           Transaction (A).The_Task (B).Bij;
         -- Calculate de number of real transactions
         for I in 1 .. Max_Transactions loop
            exit when Transaction (I).Ni = 0;
            if Transaction (I).Transaction_Id > Num_Trans then
               Num_Trans := Transaction (I).Transaction_Id;
            end if;
         end loop;
         
         loop
            if Debug then
               Put_Line("W_DO : Wcant="&Img(Wcant));
            end if;
            Wc := Time (Q) * Transaction (A).The_Task (B).Cijown +
              Transaction (A).The_Task (B).Bij +
              Wik (D, C, Wcant, A, B);
            if Debug then
               Put_Line("W_DO : Wc 1 ="&Img(Wc));
            end if;
            
            -- mgh 2026:remove
            if A=1 and then B=2 then
               Put_Line("In W_DO A=1 B=2 C="&C'Img&" D="&D'Img&" Wc 1 ="&Wc'Img);
            end if;
         
            for N in 1 .. Num_Trans loop
               if N /= Transaction (A).Transaction_Id then -- equivalent to I/=A
                  MaxWik := 0.0;
                  for I in 1 .. Max_Transactions loop
                     exit when Transaction (I).Ni = 0;
                     if Transaction (I).Transaction_Id = N then
                        for K in 1 .. Transaction (I).Ni loop
                           Wc_Ik := 0.0;
                           if (Transaction (I).The_Task (K).Procij = Proc) and then
                             (Transaction (I).The_Task (K).Prioij >= Prio) and then
                             not ((I = A) and then (K = B)) -- I=A really necessary?
                           then
                              if Transaction (I).The_Task (K).Model =
                                Unbounded_Effects
                              then
                                 return Large_Time;
                              else
                                 Wc_Ik := Wc_Ik + Wik (I, K, Wcant, A, B);
                                 if Debug then
                                    Put_Line("W_DO : WC_ik="&Img(Wc_Ik));
                                 end if;
                              end if;

                              if Wc_Ik > MaxWik then
                                 MaxWik := Wc_Ik;
                                 if Debug then
                                    Put_Line("W_DO : New Max Wc_ik="&Img(MaxWik));
                                 end if;
                              end if;
                           end if;
                        end loop;
                     end if;
                  end loop;
                  Wc := Wc + MaxWik;
                  if Debug then
                     Put_Line("W_DO : WC 2 ="&Img(Wc));
                  end if;
               end if;
            end loop;
            Done  := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         if Debug then
            Put_Line("W_DO : WC Final ="&Img(Wc));
         end if;
         
         -- mgh 2026:remove
         if A=1 and then B=2 then
            Put_Line("In W_DO A=1 B=2 C="&C'Img&" D="&D'Img&" Wc 3 ="&Wc'Img);
         end if;
         
         
         return Wc;
      end W_DO;
      --           loop
      --              if Debug then
      --                 Put_line("W_DO : Wcant="&Img(Wcant));
      --              end if;
      --              Wc := Time (Q) * Transaction (A).The_Task (B).Cijown +
      --                Transaction (A).The_Task (B).Bij +
      --                Wik (D, C, Wcant, A, B);
      --              if Debug then
      --                 Put_line("W_DO : Wc 1 ="&Img(Wc));
      --              end if;
      --              for I in 1 .. Max_Transactions loop
      --                 exit when Transaction (I).Ni = 0;
      --                 if Transaction (I).Transaction_Id /=
      --                   Transaction (A).Transaction_Id then --I/=A
      --                    MaxWik := 0.0;
      --                    for K in 1 .. Transaction (I).Ni loop
      --                       Wc_Ik := 0.0;
      --                       if (Transaction (I).The_Task (K).Procij = Proc) and
      --                         (Transaction (I).The_Task (K).Prioij >= Prio) and
      --                         not ((I = A) and (K = B)) -- I=A really necessary?
      --                       then
      --                          if Transaction (I).The_Task (K).Model =
      --                            Unbounded_Effects
      --                          then
      --                             return Large_Time;
      --                          else
      --                             Wc_Ik := Wc_Ik + Wik (I, K, Wcant, A, B);
      --                             if Debug then
      --                                Put_line("W_DO : WC_ik="&Img(Wc_Ik));
      --                             end if;
      --                          end if;
      --  
      --                          if Wc_Ik > MaxWik then
      --                             MaxWik := Wc_Ik;
      --                             if Debug then
      --                                Put_line("W_DO : New Max Wc_ik="&Img(MaxWik));
      --                             end if;
      --                          end if;
      --                       end if;
      --                    end loop;
      --                    Wc := Wc + MaxWik;
      --                    if Debug then
      --                       Put_line("W_DO : WC 2 ="&Img(Wc));
      --                    end if;
      --                 end if;
      --              end loop;
      --              Done  := (Wc = Wcant);
      --              Wcant := Wc;
      --              exit when Done;
      --           end loop;
      --           if Debug then
      --              Put_line("W_DO : WC Final ="&Img(Wc));
      --           end if;
      --           return Wc;

   begin

      Changes_Made := False;

      Over_Analysis_Bound := False;
      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then
         Rmax := 0.0;
         -- July 2019: Tasks (A,B) and (D,C)
         for D in 1 .. Max_Transactions loop
            -- mgh: feb 2025, added the exit when contition to exit the loop
            -- after the last valid transaction has been processed
            exit when Transaction (D).Ni = 0;
            
            -- July 2019: chech all translated transactions coming from the same one 
            if Transaction (A).Transaction_Id =
              Transaction (D).Transaction_Id 
            then
               for C in 1 .. Transaction (D).Ni loop
                  -- April 2020: C in the range transaction D
                  if (Transaction (D).The_Task (C).Prioij >=
                        Transaction (A).The_Task (B).Prioij) and then
                    (Transaction (D).The_Task (C).Procij =
                       Transaction (A).The_Task (B).Procij) and then
                    Transaction (A).The_Task (B).Model /= Unbounded_Effects
                  then
                     P0 := -Long_Int (Floor
                                        ((Transaction (A).The_Task (B).Jij +
                                            Fijk (A, D, B, C)) /
                                           Transaction (A).The_Task (B).Tijown)) + 1;
                     P  := P0 - 1;

                     if Debug then
                        New_Line;
                        Put_Line("D, C = "&Img(Integer(D))&", "&Img(Integer(C)));
                        Put_Line("P0 = "&img(P0));
                     end if;

                     loop
                        P     := P + 1;
                        if Debug then
                           Put_Line("P = "&img(P));
                        end if;
                        W_Abc := W_DO (A, D, B, C, P - P0 + 1);
                        
                        -- mgh 2026: remove
                        if A=1 and then B=2 then
                           Put_Line("W_Abc = "&Img(W_Abc)&" A=1, B=2, C="&C'Img&" D="&D'Img);
                        end if;
                        
                        if Debug then
                           Put_Line("W_Abc = "&Img(W_Abc));
                        end if;

                        R_Abc := -Fijk (A, D, B, C) -
                          Time (P - 1) *
                          Transaction (A).The_Task (B).Tijown +
                          W_Abc +
                          Transaction (A).The_Task (B).Oij;
                        if Debug then
                           Put_Line("R_Abc = "&Img(R_Abc));
                        end if;
                        
                        -- mgh 2026:remove
                        if A=1 and then B=2 then
                           Put_Line("After Fijk A=1 B=2 C="&C'Img&" D="&D'Img&" R_Abc ="&R_abc'Img);
                        end if;
         
                        


                        if R_Abc > Rmax then
                           Rmax := R_Abc;

                           if Debug then
                              Put_Line("New Rmax = "&Img(Rmax));
                           end if;
                        end if;

                        --- Determine if response time is higher than deadline
                        if Rmax >= Analysis_Bound
                        then
                           if Verbose then
                              Put(" Task over its Analysis Bound");
                           end if;
                           Changes_Made := True;
                           for K in B .. Transaction (A).Ni loop
                              Transaction (A).The_Task (K).Model :=
                                Unbounded_Effects;
                              Transaction (A).The_Task (K).Rij   := Large_Time;
                              if K < Ni then
                                 Transaction (I).The_Task (K).Jij := Large_Time;
                              end if;
                           end loop;

                           Over_Analysis_Bound := True;

                        end if;

                        exit when R_Abc <=
                          Transaction (A).The_Task (B).Tijown +
                          Transaction (A).The_Task (B).Oij or else
                          Transaction (A).The_Task (B).Model =
                          Unbounded_Effects;
                     end loop;
                  end if;
                  exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
               end loop;
            end if;
         end loop;
         -- Store the worst-case response time obtained

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;

            if Debug then
               Put_Line("New Rij"&A'Img&B'Img);
               Put_Line("Rij = "&Img(Rmax));
            end if;
         end if;

      end if;
      
      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

      if Debug then
         Put_Line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
      end if;

   end Offset_Based_Approx_Task_FP;


   ----------------------------------
   -- Offset_Based_Slanted_Task_FP --
   ----------------------------------

   procedure Offset_Based_Slanted_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      debug : constant Boolean := (I=3) and then (J=5) and then debug_global;

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : constant Transaction_ID_Type := I;
      B                  : constant Task_ID_Type        := J;

      P, P0              : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;
      pragma Unreferenced (Di);
      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;


      ----------
      -- Fijk --
      ----------

      function Fijk
        (I, L : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
         -- July 2019: L has been added as task K could belong to a different 
         -- transaction in the translated system
         -- So tasks (I,J) and (L,K) are managed
      begin
         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (L).The_Task (K).Oij +
                Transaction (L).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;


      ----------
      -- Wik ---
      ----------
      -- July 2020: this function uses Fijk with transactions D and I 
      -- and tasks J and K
      
      function Wik
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         t    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         acum : Time;
         Prio : Priority;
         Proc : Processor_ID_Type;
         --part : T_Ident_Particion;

      begin

         Prio := Transaction(A).The_Task(B).Prioij;
         Proc := Transaction(A).The_Task(B).Procij;
         acum := 0.0;

         for D in 1 .. Max_Transactions loop
            exit when Transaction (D).Ni = 0;
            -- July 2020: check all translated transactions coming from the same one 
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then
               
               for J in 1 .. Transaction (D).Ni loop

                  if (Transaction (D).The_Task (J).Procij = Proc) and then
                    (Transaction (D).The_Task (J).Prioij >= Prio) and then
                    not ((D = A) and then (J = B))
                  then
                     acum := acum +
                       (Floor
                          ((Transaction (D).The_Task (J).Jij + 
                              Fijk (D, I, J, K)) /
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                             -- Transaction (D).Ti) +
                             Transaction (D).The_Task(J).Tij) +
                          Ceiling
                            -- ((t - Fijk (D, I, J, K)) / Transaction (D).Ti)) *
                            ((t - Fijk (D, I, J, K)) / Transaction (D).The_Task(J).Tij)) *
                       Transaction (D).The_Task (J).Cij;
                  end if;
               end loop;
            end if;
         end loop;
         return acum;
         
         --           Prio := Transaction(A).The_Task(B).Prioij;
         --           Proc := Transaction(A).The_Task(B).Procij;
         --           acum := 0.0;
         --  
         --           for J in 1 .. Transaction (i).Ni loop
         --  
         --              if (Transaction (I).The_Task (J).Procij = Proc) and
         --                (Transaction (I).The_Task (J).Prioij >= Prio) and
         --                not ((I = A) and (J = B))
         --              then
         --                 acum := acum +
         --                   (Floor
         --                      ((Transaction (I).The_Task (J).Jij + Fijk (I, I, J, K)) /
         --                         Transaction (I).Ti) +
         --                      Ceiling
         --                      ((t - Fijk (I, I, J, K)) / Transaction (I).Ti)) *
         --                   Transaction (I).The_Task (J).Cij;
         --              end if;
         --           end loop;
         --           return acum;
      end Wik;

      ----------
      -- Iik ---
      ----------

      function Iik
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         C    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         wcant, wc : Time;
         Done     : Boolean;

      begin
         wcant := C;
         loop
            wc := C + Wik (I, K, wcant, A, B);
            Done := (wc = wcant);
            wcant := wc;
            exit when Done;
         end loop;
         return (wc - C);
      end Iik;


      -----------
      -- W_DO ---
      -----------

      function W_DO
        (A, D : Transaction_ID_Type;
         B, C : Task_ID_Type;
         Q    : Long_Int)
        return Time
      -- July 2019: D has been added as task C could belong to a different 
      -- transaction in the translated system
      -- So tasks (A,B) and (D,C) are managed
      is
         wc, wcant, wc_ik, maxWik : Time;
         Prio                     : Priority;
         Proc                     : Processor_ID_Type;
         Done                     : Boolean;
         Wis : array (1 .. Max_Transactions) of Time;

         --package time_io is new Ada.Sequential_IO(Time);
         --use time_io;
         --File : time_io.File_Type;

         --M : Integer := 4;

         -- N : Integer := 1; --for debugging
         Num_Trans                : Transaction_ID_Type := 0;

      begin

         --time_io.Create(File,Out_File,"debug.txt");

         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         wcant := Time (Q) * Transaction (A).The_Task (B).Cij +
           Transaction (A).The_Task (B).Bij;
         
         -- Calculate de number of real transactions
         for I in 1 .. Max_Transactions loop
            -- mgh: feb 2025, added the "exit when" instruction to 
            -- exit the loop when the last valid array element is reached
            exit when Transaction (I).Ni = 0;
            if Transaction (I).Transaction_Id > Num_Trans then
               Num_Trans := Transaction (I).Transaction_Id;
            end if;
         end loop;
         
         for i in 1 .. Num_Trans loop
            Wis (i) := 0.0;
         end loop;
         
         loop
            Wis (Transaction (A).Transaction_Id) := 
              Iik (D, C, wcant - Wis (Transaction (A).Transaction_Id), A, B);
            wc := Time (Q) * Transaction (A).The_Task (B).Cij + 
              Wis (Transaction (A).Transaction_Id) +
              Transaction (A).The_Task (B).Bij;
            for N in 1 .. Num_Trans loop
               if N /= Transaction (A).Transaction_Id then -- equivalent to I/=A
                  maxWik := 0.0;
                  for I in 1 .. Max_Transactions loop
                     exit when Transaction (I).Ni = 0;
                     if Transaction (I).Transaction_Id = N then
                        for K in 1 .. Transaction (I).Ni loop
                           if (Transaction (I).The_Task (K).Procij = Proc) and then
                             (Transaction (I).The_Task (K).Prioij >= Prio) and then
                             not ((I = A) and then (K = B)) -- I=A really necessary?
                           then
                              wc_ik := Iik (I, K, wcant - Wis (N), A, B);
                              if wc_ik > maxWik then
                                 maxWik := wc_ik;
                              end if;
                           end if;
                        end loop;
                     end if;
                  end loop;
                  Wis (N) := maxWik;
                  wc      := wc + maxWik;
               end if;
            end loop;
            --New_Line;
            --Put_Line ("WDO ARINC (wc,wcant) :" & Time'Image (wc) &
            --            " , " & Time'Image (wcant));

            --              declare
            --                 package time_io is new Ada.Sequential_IO(Time_Interval);
            --                 use time_io;
            --                 f : time_io.File_Type;
            --                 c : character;
            --              begin
            --
            --                 if debug and (N = 0) then
            --                    time_io.Create(f,Out_File,"floats.txt");
            --                    time_io.Write(f,wcant);
            --                    time_io.Write(f,wc);
            --                    time_io.Close(f);
            --                    Ada.Text_IO.Get(c);
            --                 end if;
            --
            --
            --                 --Done := igual(wc,wcant,debug);
            --
            --                 if debug then
            --                    N := N - 1;
            --                 end if;
            --
            --
            --              end;
            Done := (wc = wcant);
            wcant := wc;
            exit when Done;

         end loop;
         return wc;
      end W_DO;
      

   begin

      Changes_Made := False;

      Over_Analysis_Bound := False;
      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then
         Rmax := 0.0;
         -- July 2019: Tasks (A,B) and (D,C)
         for D in 1 .. Max_Transactions loop
            --mgh: Feb 2025. Added the "exit when" contition to exit the
            -- loop when the last valid transaction has been processed
            exit when Transaction (D).Ni = 0;
            -- July 2019: check all translated transactions coming from 
            -- the same one 
            if Transaction (A).Transaction_Id =
              Transaction (D).Transaction_Id 
            then      
               Ni := Transaction (D).Ni;
               for C in 1 .. Transaction (D).Ni loop
                  -- April 2020: C in the range transaction D
                  if (Transaction (D).The_Task (C).Prioij >=
                        Transaction (A).The_Task (B).Prioij) and then
                    (Transaction (D).The_Task (C).Procij =
                       Transaction (A).The_Task (B).Procij) and then
                    Transaction (A).The_Task (B).Model /= Unbounded_Effects
                  then
                     P0 := -Long_Int (Floor
                                        ((Transaction (A).The_Task (B).Jij +
                                            Fijk (A, D, B, C)) /
                                           Transaction (A).The_Task (B).Tijown)) + 1;
                     P  := P0 - 1;
                     loop
                        P     := P + 1;

                        W_Abc := W_DO (A, D, B, C, P - P0 + 1);

                        R_Abc := -Fijk (A, D, B, C) -
                          Time (P - 1) *
                          Transaction (A).The_Task (B).Tijown +
                          W_Abc +
                          Transaction (A).The_Task (B).Oij;

                        if debug then
                           Put("Rabc = "&R_Abc'Img);
                        end if;

                        if R_Abc > Rmax then
                           Rmax := R_Abc;
                        end if;

                        --- Determine if response time is higher than deadline
                        if Rmax >= Analysis_Bound
                        then
                           if Verbose then
                              Put(" Task over its Analysis Bound");
                           end if;
                           Changes_Made := True;
                           for K in B .. Transaction (A).Ni loop
                              Transaction (A).The_Task (K).Model :=
                                Unbounded_Effects;
                              Transaction (A).The_Task (K).Rij   := Large_Time;
                              if K < Ni then
                                 Transaction (I).The_Task (K).Jij := Large_Time;
                              end if;
                           end loop;

                           Over_Analysis_Bound := True;

                        end if;

                        exit when R_Abc <=
                          Transaction (A).The_Task (B).Tijown +
                          Transaction (A).The_Task (B).Oij or else
                          Transaction (A).The_Task (B).Model =
                          Unbounded_Effects;
                     end loop;
                  end if;
                  exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
               end loop;
            end if;
         end loop;
         -- Store the worst-case response time obtained

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;
      
      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

   end Offset_Based_Slanted_Task_FP;


   --------------------------------------
   -- Offset_Based_Brute_Force_Task_FP --
   --------------------------------------

   procedure Offset_Based_Brute_Force_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      pragma Unreferenced (Stop_Factor_When_Not_Schedulable);

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : constant Transaction_ID_Type := I;
      B                  : constant Task_ID_Type        := J;
      Ni                 : Task_ID_Type;
      Di                 : Time;
      pragma Unreferenced (Di);

      debug : constant Boolean := (I=13) and then (J=2) and then debug_global;

      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;

      ----------
      -- Fijk --
      ----------

      function Fijk
        (I, L : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
         -- July 2019: L has been added as task K could belong to a different 
         -- transaction in the translated system
         -- So tasks (I,J) and (L,K) are managed
      begin
         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (L).The_Task (K).Oij +
                Transaction (L).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;

      ----------
      -- Wik --
      ----------
      -- July 2020: this function uses Fijk with transactions D and I 
      -- and tasks J and K
      
      function Wik
        (I    : Transaction_ID_Type;
         K    : Task_ID_Type;
         T    : Time;
         A    : Transaction_ID_Type;
         B    : Task_ID_Type)
        return Time
      is
         Acum        : Time := 0.0;
         Prio        : Priority;
         Proc        : Processor_ID_Type;
         -- July 2020: two-dimensional array to take into account 
         -- sub-transactions
         Aux_Jitters :
           array (Transaction_ID_Type range 1 .. Max_Transactions,
                  Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;

      begin
         if T = 0.0 then
            return Transaction (I).The_Task (K).Cij;
         end if;
         -- Copy jitter terms into an auxiliar transaction
         -- to make zero all those marked as jitter_avoidance.
         -- Recover the original values at the end of the procedure.
         -- July 2020: two-dimensional array to take into account 
         -- sub-transactions
         for D in 1 .. Max_Transactions loop
            -- mgh: feb 2025, added the "exit when" condition to exit the loop
            -- after the last valid transaction has been processed
            exit when Transaction (D).Ni = 0;
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then 
               for J in 1 .. Transaction (D).Ni loop
                  Aux_Jitters (D,J) := Transaction (D).The_Task (J).Jij;
                  if Transaction (D).The_Task (J).Jitter_Avoidance then
                     Transaction (D).The_Task (J).Jij := 0.0;
                  end if;
               end loop;
            end if;
         end loop;

         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;
         
         for D in 1 .. Max_Transactions loop
            exit when Transaction (D).Ni = 0;
            -- July 2020: check all translated transactions coming from the same one 
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then      
               for J in 1 .. Transaction (D).Ni loop
                  if (Transaction (D).The_Task (J).Procij = Proc) and then
                    (Transaction (D).The_Task (J).Prioij >= Prio) and then
                    not ((D = A) and then (J = B))
                  then
                     if Transaction (D).The_Task (J).Model =
                       Unbounded_Effects
                     then
                        return Large_Time;
                     else
                        Acum :=
                          Acum +
                          (Floor
                             ((Transaction (D).The_Task (J).Jij + Fijk (D, I, J, K)) /
                                Transaction (D).The_Task (J).Tij) +
                             Ceiling
                               ((T - Fijk (D, I, J, K)) /
                                  Transaction (D).The_Task (J).Tij)) *
                          Transaction (D).The_Task (J).Cij;
                     end if;
                  end if;
               end loop;
            end if;
         end loop;

         for D in 1 .. Max_Transactions loop
            -- mgh: feb 2025, added the "exit when" condition to exit the loop
            -- when the last valid transaction has been processed
            exit when Transaction (D).Ni = 0;
            
            if Transaction (I).Transaction_Id =
              Transaction (D).Transaction_Id 
            then
               for J in 1 .. Transaction (D).Ni loop
                  Transaction (D).The_Task (J).Jij := Aux_Jitters (D,J);
               end loop;
            end if;
         end loop;

         return Acum;
      end Wik;

      
      n : Transaction_ID_Type := Max_Transactions;
      r : constant Task_ID_Type := Max_Tasks_Per_Transaction;
      type variation_type is record
         trans_num : Transaction_ID_Type;
         task_num : Task_ID_Type;
      end record;
      m : array (1..n) of Task_ID_Type := (others => 0);
      type the_variation is array (1..n) of Task_ID_Type;
      type variation_map is array (1..n, 1..r) of variation_type;
      -- July 2020: the variation_map maps the original data structure with 
      -- sub-transactions into  new one ordered by complete transactions
      -- It allows looping into the variations: any access to a pair 
      -- transaction/task should be searched in the map 
      v : the_variation;
      map : variation_map;

      function W_DO_V
        (A : Transaction_ID_Type;
         B : Task_ID_Type;
         V : the_variation;
         Q : Long_Int)
        return Time
      is
         Wc, Wcant : Time;
         Prio : Priority;
         Proc : Processor_ID_Type;
         Done : Boolean; 
         
      begin
         --Performs Equation [20]
         Proc := Transaction(A).The_Task(B).Procij;
         Prio := Transaction(A).The_Task(B).Prioij;
         Wcant := Time (Q) * Transaction(A).The_Task(B).Cijown +
           Transaction(A).The_Task(B).Bij;
         loop


            Wc := Time (Q) * Transaction(A).The_Task(B).Cijown +
              Transaction(A).The_Task(B).Bij;

            for I in 1..n loop
               if V(I) /= 0 then--and 
                                --(Transaction (map(I,V(I)).trans_num).Transaction_Id /=
                                --Transaction (A).Transaction_Id) then -- July 2019: + and I/=A
                  if (Transaction(map(I,V(I)).trans_num).The_Task(map(I,V(I)).task_num).Procij = Proc) and then
                    (Transaction(map(I,V(I)).trans_num).The_Task(map(I,V(I)).task_num).Prioij >= Prio)
                  then
                     Wc := Wc + Wik (map(I,V(I)).trans_num, map(I,V(I)).task_num, Wcant, A, B);
                  end if;
               end if;

            end loop;

            Done := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         
         if False then
            Put_Line("Wc ="&Wc'Img);
         end if;
         return Wc;
      end W_DO_V;

      Rmax, Worst_Job_R : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;
      Rmax := 0.0;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         declare

            procedure print_variation (V : the_variation) is
            begin
               for I in 1..n loop
                  Put(" "&V(I)'Img);
               end loop;
               --New_line;
            end print_variation;

            function is_valid_variation (V : the_variation) return Boolean is

               procab : constant Processor_ID_Type := My_System(A).The_Task(B).Procij;

               --returns True if Transaction T crosses processor Proc
               function cross_processor (T : Transaction_ID_Type;
                                         Proc : Processor_ID_Type)
                                        return Boolean is
               begin
                  for J in 1..m(T) loop
                     if My_System(map(T,J).trans_num).The_Task(map(T,J).task_num).Procij = Proc then
                        return True;
                     end if;
                  end loop;
                  return False;
               end cross_processor;

            begin
               for I in 1..n loop
                  if My_System(map(I,V(I)).trans_num).The_Task(map(I,V(I)).task_num).Procij /= procab
                  then
                     if cross_processor(I,procab) then
                        return false;
                     end if;
                  end if;
               end loop;
               return true;
            end is_valid_variation;

            procedure calculate_tasks_per_transaction is
               -- Calculates n and m for the real number of transactions
               -- and builds the variation_map
            begin
               n := 0;
               for I in 1 .. Max_Transactions loop
                  exit when Transaction(I).Ni = 0;
                  if n /= Transaction(I).Transaction_Id then
                     n := n + 1;
                  end if;
                  for J in 1..Transaction(I).Ni loop
                     map(n,m(n)+J) := (I,J);      
                  end loop;
                  m(n) := m(n)+Transaction(I).Ni;
               end loop;
               --                 Put_Line("Mapping");
               --                 for i in 1..n loop
               --                    Put_Line("m(i))"&m(i)'img);
               --                    for j in 1..m(i) loop
               --                       Put_Line(i'img&" "&j'img&" mapea en "&
               --                                  map(i,j).trans_num'img&" "&map(i,j).task_num'img);
               --                    end loop;
               --                 end loop;
               --                 Put_Line("End Mapping");
            end calculate_tasks_per_transaction;


            --Returns Max Response Time for the variation V and each P possible
            function Worst_Job_V (V : the_variation) return Time is

               Rmax_P, R_abc, W_Abc : Time;
               P, P0              : Long_Int;
               A_Id               : constant Transaction_ID_Type := 
                 Transaction(A).Transaction_Id;

            begin

               begin
                  P0 := -Long_Int (Floor
                                     ((Transaction (A).The_Task (B).Jij +
                                         Fijk (A, map(A_Id,V(A_Id)).trans_num, 
                                               B, map(A_Id,V(A_Id)).task_num)) /
                                        Transaction (A).The_Task (B).Tijown)) + 1;

               exception
                  when CONSTRAINT_ERROR =>
                     if debug then
                        Put_Line("A="&A'Img);
                        Put_Line("B="&B'Img);
                        Put_Line("V(A_Id)="&V(A_Id)'Img);
                        Put_Line("Jij="&Transaction (A).The_Task (B).Jij'Img);
                        Put_Line("Fijk="&Fijk (A, map(A_Id,V(A_Id)).trans_num, 
                                               B, map(A_Id,V(A_Id)).task_num)'Img);
                        Put_Line("Tijown="&Transaction (A).The_Task (B).Tijown'Img);
                     end if;
                     raise;
               end;

               P  := P0 - 1;

               Rmax_P := Time(0);

               loop

                  P := P + 1;
                  W_Abc := W_DO_V(A => A,
                                  B => B,
                                  V => V,
                                  Q => P - P0 + 1);

                  --V(A) : task that starts busy period in own transaction
                  R_abc := -Fijk (A, map(A_Id,V(A_Id)).trans_num, 
                                  B, map(A_Id,V(A_Id)).task_num) -
                    Time (P - 1) *
                    Transaction (A).The_Task (B).Tijown +
                    W_Abc +
                    Transaction (A).The_Task (B).Oij;

                  if False then
                     Put_Line("W_abc ="&W_Abc'Img);
                     Put_Line("R_abc ="&R_abc'Img);
                  end if;

                  if R_abc > Rmax_P then
                     Rmax_P := R_abc;
                  end if;

                  --- Determine if response time is higher than deadline
                  -- TO BE REVISED
                  if Rmax_P >= Analysis_Bound
                  then

                     if Verbose then
                        Put(" Task over its Analysis Bound");
                     end if;
                     Changes_Made := True;
                     for K in B .. Transaction (A).Ni loop
                        Transaction (A).The_Task (K).Model :=
                          Unbounded_Effects;
                        Transaction (A).The_Task (K).Rij   := Large_Time;
                        if K < Ni then
                           Transaction (I).The_Task (K).Jij := Large_Time;
                        end if;
                     end loop;
                     Over_Analysis_Bound := True;
                     Rmax_P := Large_Time;

                  end if;

                  exit when R_abc <=
                    Transaction (A).The_Task (B).Tijown +
                    Transaction (A).The_Task (B).Oij or else
                    Transaction (A).The_Task (B).Model =
                    Unbounded_Effects;

               end loop;

               return Rmax_P;

            end Worst_Job_V;


            procedure process_var
              (i : Transaction_ID_Type; v : in out the_variation) is
            begin
               for k in 1..m(i) loop

                  --if My_System(I).The_Task(k).Procij =
                  --  My_System(A).The_Task(B).Procij
                  --then
                  v(i) := k;
                  if i = n then

                     if debug then
                        print_variation(v);
                        New_Line;
                     end if;

                     --Use Variation
                     if is_valid_variation(v) then
                        Worst_Job_R := Worst_Job_V(v);
                        exit when Over_Analysis_Bound;
                        if debug then
                           Put("  "&Trimmed_Image.Img(Float(Worst_Job_R)));
                        end if;
                        if Worst_Job_R > Rmax then
                           Rmax := Worst_Job_R;
                           if debug then
                              Put("  Max");
                           end if;
                        end if;
                     end if;
                     if debug then
                        New_Line;
                     end if;

                  else
                     process_var(i+1,v);
                     exit when Over_Analysis_Bound;
                  end if;
                  --end if;

               end loop;
            end process_var;

         begin

            if debug then
               New_Line;
            end if;
            calculate_tasks_per_transaction;
            process_var(1,v);

         end;

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;
      
      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

   end Offset_Based_Brute_Force_Task_FP;


   -----------------------------------------
   -- Offset_Based_Approx_Task_EDF_Global --
   -----------------------------------------

   procedure Offset_Based_Approx_Task_EDF_Global
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is

      Transaction : Translation.Linear_Transaction_System renames My_System;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Time) return Time is
      begin
         if X < Time(0) or else Y < Time(0) then
            return Time(0);
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;

      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;

      ----------
      -- Fijk --
      ----------

      function Fijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
      begin

         if False then
            Put_Line("      Fijk : I,J,K = "&Img(Integer(I))&","&Img(Integer(J))&","&Img(Integer(K)));
            Put_Line("      Fijk : Tij = "&Img(Transaction (I).The_Task (J).Tij));
            Put_Line("      Fijk : Oik = "&Img(Transaction (I).The_Task (K).Oij));
            Put_Line("      Fijk : Jik = "&Img(Transaction (I).The_Task (K).Jij));
            Put_Line("      Fijk : Oij = "&Img(Transaction (I).The_Task (J).Oij));
            Put_Line("      Fijk : Mod = "&Img(Modulus
                                                 (Transaction (I).The_Task (K).Oij +
                                                    Transaction (I).The_Task (K).Jij -
                                                    Transaction (I).The_Task (J).Oij,
                                                  Transaction (I).The_Task (J).Tij)));
            Put_Line("      Fijk : return = "&Img(Transaction (I).The_Task (J).Tij -
                                                    Modulus
                                                      (Transaction (I).The_Task (K).Oij +
                                                         Transaction (I).The_Task (K).Jij -
                                                         Transaction (I).The_Task (J).Oij,
                                                       Transaction (I).The_Task (J).Tij)));
         end if;

         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (I).The_Task (K).Oij +
                Transaction (I).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;

      -------------
      -- WikSinD --
      -------------

      function WikSinD (I : Transaction_ID_Type;
                        K : Task_ID_Type;
                        T : Time;
                        A : Transaction_ID_Type;
                        B : Task_ID_Type) return Time
      is
         acum : Time;
         proc : Processor_ID_Type;
         Aux_Jitters :
           array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;
      begin

         --jitter=0 (sporadic server emulation)
         for J in 1 .. Transaction (I).Ni loop
            Aux_Jitters (J) := Transaction (I).The_Task (J).Jij;
            if False then --previously jitter_avoidance
               Transaction (I).The_Task (J).Jij := 0.0;
            end if;
         end loop;

         proc := Transaction(A).The_Task(B).Procij;
         acum := Time(0);
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc then
               acum := acum+
                 (Floor((Transaction(I).The_Task(J).Jij+
                           -- May 2025: Changed the transaction's period
                           -- for the task's period
                           Fijk(I,J,K))/Transaction(I).Ti)+Ceiling((T-Fijk(I,J,K))/
                                                                     Transaction(I).Ti))*Transaction(I).The_Task(J).Cij;
            end if;
         end loop;

         for J in 1 .. Transaction (I).Ni loop
            Transaction (I).The_Task (J).Jij := Aux_Jitters (J);
         end loop;

         return acum;

      end WikSinD;

      -----------------
      -- Busy_Period --
      -----------------

      function Busy_Period (A : Transaction_ID_Type;
                            B,C : Task_ID_Type) return Time
      is
         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;
      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Transaction(A).The_Task(B).Cij;
         loop

            wc := WikSinD(A,C,wcant,A,B);
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I /= A then
                  maxWik := Time(0);
                  for K in 1 .. Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        wc_ik := WikSinD(I,K,wcant,A,B);
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  wc := wc + maxWik;
               end if;
            end loop;
            finish := (wc = wcant);
            wcant := wc;
            exit when finish;
         end loop;
         return wc;

      end Busy_Period;

      --------------------------------------
      -- Build_Set_PSI_EDF_Global_Offsets --
      --------------------------------------

      package Psi_Container is new Ada.Containers.Ordered_Sets (Time,"<","=");
      use Psi_Container;
      Psi_Set : Psi_Container.Set;
      Psi_Cursor : Psi_Container.Cursor;

      procedure Build_Set_PSI_EDF_Global_Offsets
        (A : Transaction_ID_Type;
         B,C : Task_ID_Type)
      is
         p0,pl : Long_Int;
         proc : Processor_ID_Type;
         wbusy,psi : Time;

         procedure Insert (set : in out Psi_Container.Set;
                           element : Time) is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wbusy := Busy_Period(A,B,C);

         for I in 1 .. Max_Transactions loop
            exit when Transaction(I).Ni = 0;
            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(J).Procij =proc then

                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        if I /= A or else ((I=A) and then (J=B) and then (K=C)) then
                           p0 := Long_Int(-Floor((Transaction(I).The_Task(J).Jij +
         -- May 2025: Changed the transaction's period
         -- for the task's period
                                                    Fijk(I,J,K))/Transaction(I).Ti) + Time(1));
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                           pl := Long_Int(Ceiling((wbusy-Fijk(I,J,K))/
                                                    Transaction(I).Ti));

                           -- dij in paper is related to the offset, not the external event (that's why we substract the offset here)
                           for p in p0 .. pl loop
                              -- May 2025: Changed the transaction's period
                              -- for the task's period
                              psi := Fijk(I,J,K) + Time(p-1)*Transaction(I).Ti+
                                Transaction(I).The_Task(J).SDij -
                                Transaction(I).The_Task(J).Oij;
                              Insert(Psi_Set, psi);
                           end loop;

                        end if;
                     end if;
                  end loop;
               end if;
            end loop;
         end loop;

         p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij +
                                  -- May 2025: Changed the transaction's period
                                  -- for the task's period
                                  Fijk(A,B,C))/Transaction(A).Ti) + Time(1));
         pl := Long_Int(Ceiling((wbusy-Fijk(A,B,C))/Transaction(A).Ti));

         for p in p0..pl loop
            -- May 2025: Changed the transaction's period
            -- for the task's period
            psi := Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
              Transaction(A).The_Task(B).SDij-
              Transaction(A).The_Task(B).Oij;
            Insert(Psi_Set, psi);
         end loop;

      end Build_Set_PSI_EDF_Global_Offsets;

      ---------
      -- Wik --
      ---------

      function Wik (I : Transaction_ID_Type;
                    K : Task_ID_Type;
                    T : Time;
                    A : Transaction_ID_Type;
                    B : Task_ID_Type;
                    D : Time) return Time
      is

         acum,wt,wD : Time;
         proc : Processor_ID_Type;
         Aux_Jitters :
           array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;

      begin

         --jitter=0 (sporadic server emulation)
         for J in 1 .. Transaction (I).Ni loop
            Aux_Jitters (J) := Transaction (I).The_Task (J).Jij;
            if False then --previously jitter_avoidance
               Transaction (I).The_Task (J).Jij := 0.0;
            end if;
         end loop;

         proc := Transaction(A).The_Task(B).Procij;
         acum := Time(0);
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc and then not((I=A) and then (J=B)) then
               -- May 2025: Changed the transaction's period
               -- for the task's period
               wt := Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                             Transaction(I).Ti) + Ceiling((T-Fijk(I,J,K))/
                                                            Transaction(I).Ti);
               if D > Time(1e10) then
                  wD := Time(1e10);
               else
                  -- May 2025: Changed the transaction's period
                  -- for the task's period
                  wD:=Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                              Transaction(I).Ti) + Floor((D-Fijk(I,J,K) -
                                                            (Transaction(I).The_Task(J).SDij - Transaction(I).The_Task(J).Oij))/Transaction(I).Ti) +
                    Time(1);
               end if;
               acum := acum + Min0(wt,wD)*Transaction(I).The_Task(J).Cij;
            end if;
         end loop;

         for J in 1 .. Transaction (I).Ni loop
            Transaction (I).The_Task (J).Jij := Aux_Jitters (J);
         end loop;

         return acum;
      end Wik;

      ----------
      -- W_DO --
      ----------

      function W_DO (A : Transaction_ID_Type;
                     B,C : Task_ID_Type;
                     Q : Long_Int;
                     D,X : Time) return Time
      is

         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Time(Q)*Transaction(A).The_Task(B).Cij;
         loop

            --wc := Time(Q)*Transaction(A).The_Task(B).Cij+Wik(A,C,wcant,A,B,D);
            wc := Time(Q)*Transaction(A).The_Task(B).Cij+Wik(A,C,wcant,A,B,X);

            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I/=A then
                  maxWik := Time(0);
                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc and then
                       not((I=A) and then (K=B)) 
                     then
                        wc_ik := Wik(I,K,wcant,A,B,D);
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  wc := wc + maxWik;
               end if;
            end loop;

            finish := (wc=wcant);
            wcant := wc;
            exit when finish;

         end loop;
         return wc;

      end W_DO;

      A : constant Transaction_ID_Type := I;
      B : constant Task_ID_Type        := J;
      p0,pl : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij 
            then

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Global_Offsets(A,B,C);
               p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij +
                                        Fijk(A,B,C)) /
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                                       Transaction(A).Ti)+Time(1));
               pl := Long_Int(Ceiling ((Busy_Period(A,B,C)-Fijk(A,B,C)) /
                                         Transaction(A).Ti));
               for p in p0 .. pl loop

                  Psi_Cursor := First(Psi_Set);

                  while Has_Element(Psi_Cursor) loop

                     psi := Element(Psi_Cursor);

                     if psi <
                       -- May 2025: Changed the transaction's period
                       -- for the task's period
                       (Fijk(A,B,C) + Time(p)*Transaction(A).Ti +
                          Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij) and then
                       psi >=
                       (Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                          Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij)
                     then

                        Ax := psi-(Fijk(A,B,C)+Time(p-1)*Transaction(A).Ti +
                                     (Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij));
                        W_abc := W_DO(A,B,C,p-p0+1,psi,Fijk(A,B,C)-
                                        Time(p-1)*Transaction(A).Ti-
                                        (Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij));
                        R_abc := W_abc-Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti-Ax+Transaction(A).The_Task(B).Oij;

                        if R_abc > Rmax then
                           Rmax := R_abc;
                        end if;

                        if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or else
                              (R_abc >= Large_Time))
                          and then Rmax >= Analysis_Bound
                        then
                           Rmax := Large_Time;
                           if Verbose then
                              Put(" Task over its Analysis Bound");
                           end if;
                           Changes_Made := True;
                           for K in B .. Transaction (A).Ni loop
                              Transaction (A).The_Task (K).Model := Unbounded_Effects;
                              Transaction (A).The_Task (K).Rij   := Large_Time;
                              if K < Transaction (A).Ni then
                                 Transaction (A).The_Task (K+1).Jij := Large_Time;
                              end if;
                           end loop;

                           Over_Analysis_Bound := True;

                        end if;

                        exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;


                     end if;
                     Next(Psi_Cursor);
                  end loop; -- psi
                  exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
               end loop; -- p
               exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
            end if;
         end loop; -- C

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

   end Offset_Based_Approx_Task_EDF_Global;
   
   
   ----------------------------------------
   -- Offset_Based_Approx_Task_EDF_Local --
   ----------------------------------------

   procedure Offset_Based_Approx_Task_EDF_Local
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      Transaction : Translation.Linear_Transaction_System renames My_System;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Time) return Time is
      begin
         if X < Time(0) or else Y < Time(0) then
            return Time(0);
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;

      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;

      ------------
      -- Heaviside --
      ------------

      function Heaviside
        (X : Time)
        return Time
      is
      begin
         if X >= Time(0) then
            return Time(1);
         else
            return Time(0);
         end if;

      end Heaviside;

      ----------
      -- Fijk --
      ----------

      function Fijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
      begin

         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (I).The_Task (K).Oij +
                Transaction (I).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;

      -------------
      -- WikSinD --
      -------------

      function WikSinD (I : Transaction_ID_Type;
                        K : Task_ID_Type;
                        T : Time;
                        A : Transaction_ID_Type;
                        B : Task_ID_Type;
                        Print : Boolean) return Time
      is
         acum : Time;
         proc : Processor_ID_Type;
      begin
         if Print then
            Put_Line("Wabc");
            Put_Line("I= " & Transaction_ID_Type'Image(I));
            Put_Line("K= " & Task_ID_Type'Image(K));
            Put_Line("A= " & Transaction_ID_Type'Image(A));
            Put_Line("B= " & Task_ID_Type'Image(B));
            Put_Line("T= " & Time'Image(T));
         end if;
         proc := Transaction(A).The_Task(B).Procij;
         acum := Time(0);
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc then
               acum := acum+
                 (Floor((Transaction(I).The_Task(J).Jij+
                           -- May 2025: Changed the transaction's period
                           -- for the task's period
                           Fijk(I,J,K))/Transaction(I).Ti)+Ceiling((T-Fijk(I,J,K))/
                                                                     Transaction(I).Ti))*Transaction(I).The_Task(J).Cij;
               if Print then
                  Put_Line("J= " & Task_ID_Type'Image(J));
                  Put_Line("acum= " & Time'Image(acum));
                  Put_Line("      Jij= " & Time'Image(Transaction(I).The_Task(J).Jij));
                  if J>1 then
                     Put_Line("      Rij-1= " & Time'Image(Transaction(I).The_Task(J-1).Rij));
                     Put_Line("      Dij-1= " & Time'Image(Transaction(I).The_Task(J-1).Dij));
                  end if;
                  Put_Line("      Fijk= " & Time'Image(Fijk(I,J,K)));
                  Put_Line("      Ti= " & Time'Image(Transaction(I).Ti));
                  Put_Line("      Cij= " & Time'Image(Transaction(I).The_Task(J).Cij));

               end if;
            end if;
         end loop;
         return acum;

      end WikSinD;

      -----------------
      -- Busy_Period --
      -----------------

      function Busy_Period (A : Transaction_ID_Type;
                            B,C : Task_ID_Type;
                            Print : Boolean) return Time
      is
         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;
      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Transaction(A).The_Task(B).Cij;
         if Print then
            Put_Line("Busy_Period");
         end if;
         loop
            if Print then
               Put_Line("loop");
            end if;
            if Print then
               wc := WikSinD(A,C,wcant,A,B, True);
            else
               wc := WikSinD(A,C,wcant,A,B, False);
            end if;

            if Print then
               Put_Line("Wabc= " & Time'Image(wc));
            end if;
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I /= A then
                  maxWik := Time(0);
                  for K in 1 .. Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        wc_ik := WikSinD(I,K,wcant,A,B,False);
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  if Print then
                     Put_Line("W" & Transaction_ID'Image(I) & " = " & Time'Image(maxWik));
                  end if;
                  wc := wc + maxWik;
               end if;
            end loop;
            finish := (wc<=wcant);
            if wc > wcant then
               wcant := wc;
            end if;
            exit when finish;
         end loop;
         return wcant;

      end Busy_Period;

      --------------------------------------
      -- Build_Set_PSI_EDF_Local_Offsets --
      --------------------------------------

      package Psi_Container is new Ada.Containers.Ordered_Sets (Time,"<","=");
      use Psi_Container;
      Psi_Set : Psi_Container.Set;
      Psi_Cursor : Psi_Container.Cursor;

      procedure Build_Set_PSI_EDF_Local_Offsets
        (A : Transaction_ID_Type;
         B,C : Task_ID_Type)
      is
         p0,pl : Long_Int;
         proc : Processor_ID_Type;
         wbusy,psi : Time;

         procedure Insert (set : in out Psi_Container.Set;
                           element : Time) is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wbusy := Busy_Period(A,B,C,False);

         for I in 1 .. Max_Transactions loop
            exit when Transaction(I).Ni = 0;
            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(J).Procij =proc then

                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        if I /= A or else ((I=A) and then (J=B) and then (K=C)) then
                           p0 := Long_Int(-Floor((Transaction(I).The_Task(J).Jij +
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                                                    Fijk(I,J,K))/Transaction(I).Ti) + Time(1));
                           if False then
                              begin
                                 pl := Long_Int(Ceiling((wbusy-Fijk(I,J,K))/
                                                          Transaction(I).Ti));
                              exception
                                 when Constraint_Error =>
                                    Put_Line("CONSTRAINT_ERROR_DETECTED");
                                    Put_Line("wbusy : " & Time'Image(wbusy));
                                    Put_Line("fijk : " & Time'Image(Fijk(I,J,K)));
                                    Put_Line("ti : " & Time'Image(Transaction(I).Ti));
                                    Put_Line("I : " & Transaction_ID_Type'Image(I));
                                    Put_Line("J : " & Task_ID_Type'Image(J));
                                    Put_Line("K : " & Task_ID_Type'Image(K));
                                    wbusy := Busy_Period(A,B,C,True);

                                 when Program_Error | Tasking_Error =>
                                    Put ("Error de flujo.");
                                 when others =>
                                    Put ("Otro error.");
                              end;
                           end if;
                           
                           -- May 2025: Changed the transaction's period
                           -- for the task's period
                           pl := Long_Int(Ceiling((wbusy-Fijk(I,J,K))/
                                                    Transaction(I).Ti));

                           if p0 <= 0 then
                              psi := Transaction(I).The_Task(J).SDij;
                              Insert(Psi_Set, psi);
                           end if;

                           for p in 1 .. pl loop
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                              psi := Fijk(I,J,K) + Time(p-1)*Transaction(I).Ti+
                                Transaction(I).The_Task(J).SDij;
                              Insert(Psi_Set, psi);
                           end loop;

                        end if;
                     end if;
                  end loop;
               end if;
            end loop;
         end loop;

      end Build_Set_PSI_EDF_Local_Offsets;

      ---------
      -- Wik --
      ---------

      function Wik (I : Transaction_ID_Type;
                    K : Task_ID_Type;
                    T : Time;
                    A : Transaction_ID_Type;
                    B : Task_ID_Type;
                    D : Time) return Time
      is

         acum,wt,wD : Time;
         proc : Processor_ID_Type;

      begin

         proc := Transaction(A).The_Task(B).Procij;
         acum := Time(0);
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc and then not((I=A) and then (J=B)) then
               acum := acum + (Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                                       Transaction(I).Ti)) * Heaviside(D - Transaction(I).The_Task(J).SDij)*
                 Transaction(I).The_Task(J).Cij;

               wt := Ceiling((T-Fijk(I,J,K))/ Transaction(I).Ti);
               if D > Time(1e10) then
                  wD := Time(1e10);
               else
                  wD:= Floor((D-Fijk(I,J,K) -
                                Transaction(I).The_Task(J).SDij)/Transaction(I).Ti) +
                    Time(1);
               end if;
               acum := acum + Min0(wt,wD)*Transaction(I).The_Task(J).Cij;
            end if;
         end loop;
         return acum;
      end Wik;

      ----------
      -- W_DO --
      ----------

      function W_DO (A : Transaction_ID_Type;
                     B,C : Task_ID_Type;
                     Q : Long_Int;
                     D, X : Time) return Time
      is

         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;
         p0 : Long_Int;
         pragma Unreferenced (p0);

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Time(Q)*Transaction(A).The_Task(B).Cij;
         -- May 2025: Changed the transaction's period
         -- for the task's period
         p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij + Fijk(A,B,C)) /
                                 Transaction(A).Ti) + Time(1));
         loop

            wc := Time(Q)*Transaction(A).The_Task(B).Cij+Wik(A,C,wcant,A,B,X);

            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I/=A then
                  maxWik := Time(0);
                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc and then
                       not((I=A) and then (K=B)) 
                     then
                        wc_ik := Wik(I,K,wcant,A,B,D);
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  wc := wc + maxWik;
               end if;
            end loop;

            finish := (wc<=wcant);
            if wc > wcant then
               wcant := wc;
            end if;
            exit when finish;

         end loop;
         return wcant;

      end W_DO;

      A : constant Transaction_ID_Type := I;
      B : constant Task_ID_Type        := J;
      p0,pl : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         if False then
            for I in 1..Max_Transactions loop
               for J in 1.. Transaction(I).Ni loop
                  Put_Line("Dij : " & Time'Image(Transaction (I).The_Task (J).Dij));
                  Put_Line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
               end loop;
            end loop;
         end if;
         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij 
            then

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Local_Offsets(A,B,C);
               p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij + Fijk(A,B,C)) /
                             -- May 2025: Changed the transaction's period
                             -- for the task's period
                                       Transaction(A).Ti) + Time(1));
               pl := Long_Int(Ceiling ((Busy_Period(A,B,C,False)-Fijk(A,B,C)) /
                                         Transaction(A).Ti));
               for p in p0 .. pl loop

                  if p<=0 then
                     Ax := Time(0);
                     W_abc := W_DO(A,B,C,p-p0+1,Transaction(A).The_Task(B).SDij,Transaction(A).The_Task(B).SDij);
                     R_abc := W_abc-Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                       Transaction(A).The_Task(B).Oij-Ax;

                     if R_abc > Rmax then
                        Rmax := R_abc;
                     end if;

                     if False then
                        if Rmax > 1.0E50 then
                           Put_Line("A= " & Transaction_ID_Type'Image(A));
                           Put_Line("B= " & Task_ID_Type'Image(B));
                           Put_Line("C= " & Task_ID_Type'Image(C));
                           Put_Line("W_abc= " & Time'Image(W_abc));
                           Put_Line("Fijk= " & Time'Image(Fijk(A,B,C)));
                           Put_Line("p= " & Long_Int'Image(p));
                           Put_Line("Ti= " & Time'Image(Transaction(A).Ti));
                           Put_Line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                           Put_Line("Ax= " & Time'Image(Ax));
                        end if;
                     end if;

                     if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or else
                           (R_abc >= Large_Time))
                       and then Rmax >= Analysis_Bound
                     then
                        if Verbose then
                           Put(" Task over its Analysis Bound");
                           --                             Put_line("Rmax= " & Time'Image(Rmax));
                           --                             Put_line("Stop_Factor_When_Not_Schedulable= " & Positive'Image(Stop_Factor_When_Not_Schedulable));
                           --                             Put_line("Positive'Last= " & Positive'Image(Positive'Last));
                           --                             Put_line("R_abc= " & Time'Image(R_abc));
                           --                             Put_line("Analysis_Bound= " & Time'Image(Analysis_Bound));
                           --  
                           --                             Put_line("A= " & Transaction_ID_Type'Image(A));
                           --                             Put_line("B= " & Task_ID_Type'Image(B));
                           --                             Put_line("C= " & Task_ID_Type'Image(C));
                           --                             Put_line("W_abc= " & Time'Image(W_abc));
                           --                             Put_line("Fijk= " & Time'Image(Fijk(A,B,C)));
                           --                             Put_line("p= " & Long_Int'Image(p));
                           --                             Put_line("Ti= " & Time'Image(Transaction(A).Ti));
                           --                             Put_line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                           --                             Put_line("Ax= " & Time'Image(Ax));
                        end if;
                        Rmax := Large_Time;

                        Changes_Made := True;
                        for K in B .. Transaction (A).Ni loop
                           Transaction (A).The_Task (K).Model := Unbounded_Effects;
                           Transaction (A).The_Task (K).Rij   := Large_Time;
                           if K < Transaction (A).Ni then
                              Transaction (A).The_Task (K+1).Jij := Large_Time;
                           end if;
                        end loop;

                        Over_Analysis_Bound := True;

                     end if;

                     exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;

                  else -- p>0

                     Psi_Cursor := First(Psi_Set);

                     while Has_Element(Psi_Cursor) loop

                        psi := Element(Psi_Cursor);

                        if psi <
                          -- May 2025: Changed the transaction's period
                          -- for the task's period
                          (Fijk(A,B,C) + Time(p)*Transaction(A).Ti +
                             Transaction(A).The_Task(B).SDij) and then
                          psi >=
                          (Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                             Transaction(A).The_Task(B).SDij)
                        then

                           Ax := psi-Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti -
                             Transaction(A).The_Task(B).SDij;
                           W_abc := W_DO(A,B,C,p-p0+1,psi,Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti - Transaction(A).The_Task(B).SDij );
                           R_abc := W_abc-Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                             Transaction(A).The_Task(B).Oij-Ax;

                           if R_abc > Rmax then
                              Rmax := R_abc;
                           end if;

                           if False then
                              if Rmax > 1.0E50 then
                                 Put_Line("A= " & Transaction_ID_Type'Image(A));
                                 Put_Line("B= " & Task_ID_Type'Image(B));
                                 Put_Line("C= " & Task_ID_Type'Image(C));
                                 Put_Line("W_abc= " & Time'Image(W_abc));
                                 Put_Line("Fijk= " & Time'Image(Fijk(A,B,C)));
                                 Put_Line("p= " & Long_Int'Image(p));
                                 Put_Line("Ti= " & Time'Image(Transaction(A).Ti));
                                 Put_Line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                                 Put_Line("Ax= " & Time'Image(Ax));
                              end if;
                           end if;

                           if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or else
                                 (R_abc >= Large_Time))
                             and then Rmax >= Analysis_Bound
                           then
                              if Verbose then
                                 Put(" Task over its Analysis Bound");
                                 --                                   Put_line("Rmax= " & Time'Image(Rmax));
                                 --                                   Put_line("Stop_Factor_When_Not_Schedulable= " & Positive'Image(Stop_Factor_When_Not_Schedulable));
                                 --                                   Put_line("Positive'Last= " & Positive'Image(Positive'Last));
                                 --                                   Put_line("R_abc= " & Time'Image(R_abc));
                                 --                                   Put_line("Analysis_Bound= " & Time'Image(Analysis_Bound));
                                 --  
                                 --                                   Put_line("A= " & Transaction_ID_Type'Image(A));
                                 --                                   Put_line("B= " & Task_ID_Type'Image(B));
                                 --                                   Put_line("C= " & Task_ID_Type'Image(C));
                                 --                                   Put_line("W_abc= " & Time'Image(W_abc));
                                 --                                   Put_line("Fijk= " & Time'Image(Fijk(A,B,C)));
                                 --                                   Put_line("p= " & Long_Int'Image(p));
                                 --                                   Put_line("Ti= " & Time'Image(Transaction(A).Ti));
                                 --                                   Put_line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                                 --                                   Put_line("Ax= " & Time'Image(Ax));
                              end if;
                              Rmax := Large_Time;

                              Changes_Made := True;
                              for K in B .. Transaction (A).Ni loop
                                 Transaction (A).The_Task (K).Model := Unbounded_Effects;
                                 Transaction (A).The_Task (K).Rij   := Large_Time;
                                 if K < Transaction (A).Ni then
                                    Transaction (A).The_Task (K+1).Jij := Large_Time;
                                 end if;
                              end loop;

                              Over_Analysis_Bound := True;

                           end if;

                           exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;


                        end if;
                        Next(Psi_Cursor);
                     end loop; -- psi
                  end if;
                  exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
               end loop; -- p

            end if;
            exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
         end loop; -- C

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

   end Offset_Based_Approx_Task_EDF_Local;
   
   
   ---------------------------------------------
   -- Offset_Based_Approx_W_Pr_Task_EDF_Local --
   ---------------------------------------------

   procedure Offset_Based_Approx_W_Pr_Task_EDF_Local
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : Boolean  := True)
   is
      Transaction : Translation.Linear_Transaction_System renames My_System;

      ------------
      -- Modulus --
      ------------

      function Modulus (A, B : Time) return Time is
      begin
         return A - Floor (A / B) * B;
      end Modulus;


      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Time) return Time is
      begin
         if X < Time(0) or else Y < Time(0) then
            return Time(0);
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;
      pragma Unreferenced (Min0);


      -----------
      -- Min --
      -----------

      function Min (X, Y : Time) return Time is
      begin
         if X < Y then
            return X;
         else
            return Y;
         end if;
      end Min;
      pragma Unreferenced (Min);


      -----------
      -- Min --
      -----------

      function Min (X, Y : Long_Int) return Long_Int is
      begin
         if X < Y then
            return X;
         else
            return Y;
         end if;
      end Min;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Long_Int) return Long_Int is
      begin
         if X < 0 or else Y < 0 then
            return 0;
         elsif  X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;
      pragma Unreferenced (Min0);


      ------------
      -- Heaviside --
      ------------

      function Heaviside
        (X : Time)
        return Long_Int
      is
      begin
         if X >= Time(0) then
            return 1;
         else
            return 0;
         end if;

      end Heaviside;


      ----------
      -- Fijk --
      ----------

      function Fijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
      begin

         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (I).The_Task (K).Oij +
                Transaction (I).The_Task (K).Jij -
                Transaction (I).The_Task (J).Oij,
              Transaction (I).The_Task (J).Tij);
      end Fijk;


      ----------
      -- FPrimeijk --
      ----------

      function FPrimeijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Time
      is
      begin

         return Transaction (I).The_Task (J).Tij -
           Modulus
             (Transaction (I).The_Task (K).Oij +
                Transaction (I).The_Task (K).Jij,
              Transaction (I).The_Task (J).Tij) +
           Transaction (I).The_Task (J).Oij;
      end FPrimeijk;


      ----------
      -- P0ijk --
      ----------

      function P0ijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Long_Int
      is
         p : Long_Int;
      begin

         if False then
            begin
               p := - Long_Int(Floor ((Transaction (I).The_Task (J).Jij + FPrimeijk(I,J,K))/
                                        Transaction (I).The_Task (J).Tij)) + 1;
            exception
               when Constraint_Error =>
                  Put_Line("CONSTRAINT_ERROR_DETECTED");
                  Put_Line("Jij : " & Time'Image(Transaction (I).The_Task (J).Jij));
                  Put_Line("Rij-1 : " & Time'Image(Transaction (I).The_Task (J-1).Rij));
                  Put_Line("Dij-1 : " & Time'Image(Transaction (I).The_Task (J-1).Dij));
                  Put_Line("FPrime : " & Time'Image(FPrimeijk(I,J,K)));
                  Put_Line("Tij : " & Time'Image(Transaction (I).The_Task (J).Tij));
                  Put_Line("Ti : " & Time'Image(Transaction (I).Ti));
                  Put_Line("I : " & Transaction_ID_Type'Image(I));
                  Put_Line("J : " & Task_ID_Type'Image(J));
                  Put_Line("K : " & Task_ID_Type'Image(K));

               when Program_Error | Tasking_Error =>
                  Put ("Error de flujo.");
               when others =>
                  Put ("Otro error.");
            end;
         end if;
         p := - Long_Int(Floor ((Transaction (I).The_Task (J).Jij + FPrimeijk(I,J,K))/
                                  Transaction (I).The_Task (J).Tij)) + 1;

         if False then
            Put_Line("P0ijk");
            Put_Line("FPrimeijk"& Time'Image(FPrimeijk(I,J,K)));
            Put_Line("Jij"& Time'Image(Transaction (I).The_Task (J).Jij));
            Put_Line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
         end if;
         return p;

      end P0ijk;

      ----------
      -- PMin --
      ----------

      function PMin
        (I    : Transaction_ID_Type;
         K : Task_ID_Type)
        return Long_Int
      is
         proc : Processor_ID_Type;
         result : Long_Int;
      begin
         result := Long_Int'Last;
         proc := Transaction(I).The_Task(K).Procij;
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc then
               if P0ijk(I,J,K) < result then
                  result := P0ijk(I,J,K);
               end if;
            end if;
         end loop;

         return result;

      end PMin;

      ----------
      -- Pfijk --
      ----------

      function Pfijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Long_Int
      is
      begin
         if False then
            Put_Line("pf_ijk");
            Put_Line("FPrimeijk"& Time'Image(FPrimeijk(I,J,K)));
            Put_Line("Fijk"& Time'Image(Fijk(I,J,K)));
            Put_Line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
         end if;
         return - Long_Int(Floor ((FPrimeijk(I,J,K) - Fijk(I,J,K)) / Transaction (I).The_Task (J).Tij)) + 1;

      end Pfijk;

      ----------
      -- PtDijk --
      ----------

      function PtDijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type;
         T,D : Time;
         SinD : Boolean)
        return Long_Int
      is
         min1,min2 : Long_Int;
      begin
         if SinD then
            if False then
               Put_Line("PtDijk");
               Put_Line("T"& Time'Image(T));
               Put_Line("FPrimeijk"& Time'Image(FPrimeijk(I,J,K)));
               Put_Line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
            end if;
            return Long_Int(Ceiling((T - FPrimeijk(I,J,K)) / Transaction (I).The_Task (J).Tij));
         else
            min1 := Long_Int(Ceiling((T - FPrimeijk(I,J,K)) / Transaction (I).The_Task (J).Tij));
            if False then
               begin
                  min2 := Long_Int(Floor((D - FPrimeijk(I,J,K) - Transaction (I).The_Task (J).SDij)/
                                           Transaction (I).The_Task (J).Tij)) + 1;
               exception
                  when Constraint_Error =>
                     Put_Line("CONSTRAINT_ERROR_DETECTED");
                     Put_Line("D : " & Time'Image(D));
                     Put_Line("FPrimeijk(i,j,k) : " & Time'Image(FPrimeijk(I,J,K)));
                     Put_Line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
                     Put_Line("Tij : " & Time'Image(Transaction (I).The_Task (J).Tij));

                  when Program_Error | Tasking_Error =>
                     Put ("Error de flujo.");
                  when others =>
                     Put ("Otro error.");
               end;
            end if;

            min2 := Long_Int(Floor((D - FPrimeijk(I,J,K) - Transaction (I).The_Task (J).SDij)/
                                     Transaction (I).The_Task (J).Tij)) + 1;
            if False then
               Put_Line("PtDijk");
               Put_Line("T"& Time'Image(T));
               Put_Line("D"& Time'Image(D));
               Put_Line("FPrimeijk"& Time'Image(FPrimeijk(I,J,K)));
               Put_Line("SDij"& Time'Image(Transaction (I).The_Task (J).SDij));
               Put_Line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
            end if;

            return Min(min1, min2);
         end if;
      end PtDijk;


      ----------
      -- PMax --
      ----------

      function PMax
        (I    : Transaction_ID_Type;
         K : Task_ID_Type;
         T,D : Time;
         SinD : Boolean)
        return Long_Int
      is
         proc : Processor_ID_Type;
         result : Long_Int;
      begin
         result := Long_Int'First;
         proc := Transaction(I).The_Task(K).Procij;
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc then
               if PtDijk(I,J,K,T,D,SinD) > result then
                  result := PtDijk(I,J,K,T,D,SinD);
               end if;
            end if;
         end loop;

         return result;

      end PMax;


      -----------------------
      -- Resolve_Conflicts --
      -----------------------

      function Resolve_Conflicts
        (I : Transaction_ID_Type;
         K : Task_ID_Type;
         T : Time;
         A : Transaction_ID_Type;
         B : Task_ID_Type;
         D : Time;
         SinD : Boolean)
        return Time
      is
         pragma Unreferenced (A, B);
         type Matrix_Type is array(Long_Int range <>, Long_Int range <>) of Time;
         total : Time;
         p_min, p_max : Long_Int;
         max_section, sum : Time;
      begin

         p_min := PMin(I,K);
         p_max := PMax(I,K,T,D,SinD);

         if False and then (SinD = False) then
            Put_Line("p_min"& Long_Int'Image(p_min));
            Put_Line("p_max"& Long_Int'Image(p_max));
         end if;

         declare
            conflictTable : Matrix_Type(1..Long_Int(Transaction(I).Ni), p_min..p_max):= (others => (others => Time(0)));
            p0j, pTDj, p0k : Long_Int;
            mp, hp : Boolean;
         begin

            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(K).Procij = Transaction(I).The_Task(J).Procij then
                  if False and then (SinD = False) then
                     Put_Line("J:"& Task_ID_Type'Image(J));
                  end if;
                  p0j := Pfijk(I,J,K);
                  if False and then (SinD = False) then
                     Put_Line("p0j:"& Long_Int'Image(p0j));

                     Put_Line("pf_ijk");
                     Put_Line("FPrimeijk"& Time'Image(FPrimeijk(I,J,K)));
                     Put_Line("Fijk"& Time'Image(Fijk(I,J,K)));
                     Put_Line("Oij"& Time'Image(Transaction (I).The_Task (J).Oij));
                     Put_Line("Oik"& Time'Image(Transaction (I).The_Task (K).Oij));
                     Put_Line("Jik"& Time'Image(Transaction (I).The_Task (K).Jij));
                     Put_Line("Jij"& Time'Image(Transaction (I).The_Task (J).Jij));
                     Put_Line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));

                  end if;
                  if SinD or else Heaviside(D - Transaction(I).The_Task(J).SDij) = 1  then
                     p0j := P0ijk(I,J,K);
                     if False and then (SinD = False) then
                        Put_Line("p0j:"& Long_Int'Image(p0j));
                     end if;
                  end if;
                  pTDj := PtDijk(I,J,K,T,D,SinD);
                  if False and then (SinD = False) then
                     Put_Line("pTDj:"& Long_Int'Image(pTDj));
                  end if;

                  if pTDj >= p0j then
                     for p in p0j .. pTDj loop
                        conflictTable(Long_Int(J),p) := Transaction(I).The_Task(J).Cij;
                     end loop;
                  end if;
               end if;
            end loop;

            -- reductionIk
            p0k := P0ijk(I,K,K);
            for p in p0k .. p_max loop
               hp:=True;
               for J in K+1 .. Transaction(I).Ni loop
                  if Transaction(I).The_Task(K).Procij = Transaction(I).The_Task(J).Procij then
                     if hp = False then
                        conflictTable(Long_Int(J),p) := Time(0);
                     elsif conflictTable(Long_Int(J),p) = Time(0) then
                        hp := False;
                     end if;
                  end if;
               end loop;
            end loop;

            -- reductionCTAfterCI

            for p in 1 .. p_max loop
               mp:=True;
               for J in 1 .. Transaction(I).Ni loop
                  if Transaction(I).The_Task(K).Procij = Transaction(I).The_Task(J).Procij then
                     if mp = False then
                        conflictTable(Long_Int(J),p) := Time(0);
                     elsif conflictTable(Long_Int(J),p) = Time(0) then
                        mp := False;
                     end if;
                  end if;
               end loop;
            end loop;

            total := Time(0);

            if False and then (SinD = False) then
               Put_Line("Calculating");
            end if;
            for p in p_min .. p_max loop
               max_section := Time(0);
               sum := Time(0);

               if False and then (SinD = False) then
                  Put_Line("p:"& Long_Int'Image(p));
               end if;

               for J in 1 .. Transaction(I).Ni loop
                  if Transaction(I).The_Task(K).Procij = Transaction(I).The_Task(J).Procij then
                     if conflictTable(Long_Int(J),p) = Time(0) then
                        sum := Time(0);
                     else
                        sum := sum + conflictTable(Long_Int(J),p);
                     end if;
                     if sum > max_section then
                        max_section := sum;
                     end if;
                  end if;
               end loop;
               total := total + max_section;
               if False and then (SinD = False) then
                  Put_Line("total:"& Time'Image(total));
               end if;
            end loop;

         end;

         return total;
      end Resolve_Conflicts;


      -----------------------
      -- Resolve_Conflicts_Ta --
      -----------------------

      function Resolve_Conflicts_Ta
        (A : Transaction_ID_Type;
         B,C : Task_ID_Type;
         Q : Long_Int;
         T : Time;
         D : Time;
         SinD : Boolean)
        return Time
      is
         type Matrix_Type is array(Long_Int range <>, Long_Int range <>) of Time;
         total : Time;
         p_min, p_max, p0acc : Long_Int;
         max_section, sum : Time;
         t_abInMP, sameH : Boolean;
      begin

         p_min := PMin(A,C);
         p_max := PMax(A,C,T,D,SinD);
         declare
            conflictTable : Matrix_Type(1..Long_Int(Transaction(A).Ni), p_min..p_max):= (others => (others => Time(0)));
            p0j, pTDj : Long_Int;
            mp : Boolean;
         begin

            for J in 1 .. Transaction(A).Ni loop
               if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                  p0j := Pfijk(A,B,C);
                  if SinD or else Heaviside(D - Transaction(I).The_Task(J).SDij) = 1 then
                     p0j := P0ijk(A,J,C);
                  end if;
                  pTDj := PtDijk(A,J,C,T,D,SinD);

                  if pTDj >= p0j then
                     for p in p0j .. pTDj loop
                        conflictTable(Long_Int(J),p) := Transaction(I).The_Task(J).Cij;
                     end loop;
                  end if;
               end if;
            end loop;



            --  If the index of the job under analysis is bigger than
            --  the index of the critical instant (p=1) and the job is
            --  not in the first section H, the situation is invalid,
            --  so the IncompatibleAnalysisSituationException is
            --  thrown

            if Q > p_max then
               return Time(0);
            elsif Q > 1 then
               t_abInMP := True;
               for J in 1 .. Transaction(A).Ni loop
                  if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                     if conflictTable(Long_Int(J),Q) = Time(0) then
                        t_abInMP := False;
                     end if;
                  end if;
               end loop;
               if t_abInMP = False then
                  return Time(0);
               end if;
            end if;

            -- reductionCTAfterCI

            for p in 1 .. p_max loop
               mp:=True;
               for J in 1 .. Transaction(A).Ni loop
                  if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                     if mp = False then
                        conflictTable(Long_Int(J),p) := Time(0);
                     elsif conflictTable(Long_Int(J),p) = Time(0) then
                        mp := False;
                     end if;
                  end if;
               end loop;
            end loop;

            -- reductionCT1
            p0acc := P0ijk(A,C,C);
            if p0acc <= 0 then
               for p in p0acc .. 0 loop
                  sameH:=True;
                  if C+1 <= Transaction(A).Ni then
                     for J in C + 1 .. Transaction(A).Ni loop
                        if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                           if sameH = False then
                              conflictTable(Long_Int(J),p) := Time(0);
                           elsif conflictTable(Long_Int(J),p) = Time(0) then
                              sameH := False;
                           end if;
                        end if;
                     end loop;
                  end if;
               end loop;
            end if;


            -- reductionCT2
            if p_min <= Q then
               for p in p_min .. Q loop
                  sameH:=True;
                  if B - 1 >= 1 then
                     for J in reverse 1 .. B - 1 loop
                        if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                           if sameH = False then
                              conflictTable(Long_Int(J),p) := Time(0);
                           elsif conflictTable(Long_Int(J),p) = Time(0) then
                              sameH := False;
                           end if;
                        end if;
                     end loop;
                  end if;
               end loop;
            end if;

            -- reductionCT3
            if Q <= p_max then
               for p in Q .. p_max loop
                  for J in B .. Transaction(A).Ni loop
                     if Transaction(A).The_Task(C).Procij = Transaction(A).The_Task(J).Procij then
                        -- if (p >= Q and then J > B) or else (p > Q and then J = B) then
                        if (J > B) or else (p > Q and then J = B) then
                           conflictTable(Long_Int(J),p) := Time(0);
                        end if;
                     end if;
                  end loop;
               end loop;
            end if;


            total := Time(0);

            for p in p_min .. p_max loop
               max_section := Time(0);
               sum := Time(0);

               for J in 1 .. Transaction(I).Ni loop
                  if Transaction(I).The_Task(C).Procij = Transaction(I).The_Task(J).Procij then
                     if conflictTable(Long_Int(J),p) = Time(0) then
                        sum := Time(0);
                     else
                        sum := sum + conflictTable(Long_Int(J),p);
                     end if;
                     if sum > max_section then
                        max_section := sum;
                     end if;
                  end if;
               end loop;
               total := total + max_section;
            end loop;

         end;

         return total;
      end Resolve_Conflicts_Ta;


      ---------
      -- Wik --
      ---------

      function Wik (I : Transaction_ID_Type;
                    K : Task_ID_Type;
                    T : Time;
                    A : Transaction_ID_Type;
                    B : Task_ID_Type;
                    D : Time;
                    SinD : Boolean) return Time
      is

      begin

         return Resolve_Conflicts(I,K,T,A,B,D,SinD);

      end Wik;


      -------------
      -- WikSinD --
      -------------

      function WikSinD (I : Transaction_ID_Type;
                        K : Task_ID_Type;
                        T : Time;
                        A : Transaction_ID_Type;
                        B : Task_ID_Type) return Time
      is

      begin

         return Wik(I,K,T,A,B,Time(0),True);

      end WikSinD;


      -----------------
      -- Busy_Period --
      -----------------

      function Busy_Period
        (A    : Transaction_ID_Type;
         B,C : Task_ID_Type)
        return Time
      is
         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;
      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Transaction(A).The_Task(B).Cij;
         loop

            wc := WikSinD(A,C,wcant,A,B);
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I /= A then
                  maxWik := Time(0);
                  for K in 1 .. Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        wc_ik := WikSinD(I,K,wcant,A,B);
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;

                  end loop;
                  wc := wc + maxWik;
               end if;
            end loop;
            finish := (wc<=wcant);
            if wc > wcant then
               wcant := wc;
            end if;
            exit when finish;
         end loop;
         return wcant;

      end Busy_Period;


      ----------
      -- PLijk --
      ----------

      function PLijk
        (I    : Transaction_ID_Type;
         J, K : Task_ID_Type)
        return Long_Int
      is

      begin

         return Long_Int(Ceiling((Busy_Period(I,J,K) - FPrimeijk(I,J,K)) / Transaction (I).The_Task (J).Tij));

      end PLijk;


      --------------------------------------
      -- Build_Set_PSI_EDF_Local_Offsets_w_pr --
      --------------------------------------

      package Psi_Container is new Ada.Containers.Ordered_Sets (Time,"<","=");
      use Psi_Container;
      Psi_Set : Psi_Container.Set;
      Psi_Cursor : Psi_Container.Cursor;

      procedure Build_Set_PSI_EDF_Local_Offsets_w_pr
        (A : Transaction_ID_Type;
         B,C : Task_ID_Type)
      is
         p0,pl,pf : Long_Int;
         proc : Processor_ID_Type;
         wbusy,psi : Time;

         procedure Insert (set : in out Psi_Container.Set;
                           element : Time) is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin
         proc := Transaction(A).The_Task(B).Procij;
         wbusy := Busy_Period(A,B,C);

         if False then
            Put_Line("wbusy: "& Time'Image(wbusy));
         end if;

         for I in 1 .. Max_Transactions loop
            exit when Transaction(I).Ni = 0;
            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(J).Procij =proc then

                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        if I /= A or else ((I=A) and then (J=B) and then (K=C)) then
                           p0 := P0ijk(I,J,K);
                           pl := PLijk(I,J,K);
                           pf := Pfijk(I,J,K);
                           if p0 < pf then
                              psi := Transaction(I).The_Task(J).SDij;
                              Insert(Psi_Set, psi);
                           end if;
                           if pf <= pl then
                              for p in pf .. pl loop
         -- May 2025: Changed the transaction's period
         -- for the task's period
                                 psi := Fijk(I,J,K) + Time(p-1)*Transaction(I).Ti+
                                   Transaction(I).The_Task(J).SDij;
                                 Insert(Psi_Set, psi);
                              end loop;
                           end if;

                        end if;
                     end if;
                  end loop;

                  p0 := P0ijk(A,B,C);
                  pl := PLijk(A,B,C);
                  pf := Pfijk(A,B,C);

                  if p0 < pf then
                     psi := Transaction(A).The_Task(B).SDij;
                     Insert(Psi_Set, psi);
                  end if;

                  if pf <= pl then
                     for p in 1..pl loop
         -- May 2025: Changed the transaction's period
         -- for the task's period
                        psi := Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                          Transaction(A).The_Task(B).SDij;
                        Insert(Psi_Set, psi);
                     end loop;
                  end if;
               end if;
            end loop;
         end loop;

      end Build_Set_PSI_EDF_Local_Offsets_w_pr;


      ---------
      -- Wac --
      ---------

      function Wac (A : Transaction_ID_Type;
                    B,C : Task_ID_Type;
                    P : Long_Int;
                    T : Time;
                    D : Time;
                    SinD : Boolean) return Time
      is

      begin

         return Resolve_Conflicts_Ta(A,B,C,P,T,D,SinD);

      end Wac;





      ----------
      -- W_DO --
      ----------

      function W_DO (A : Transaction_ID_Type;
                     B,C : Task_ID_Type;
                     Q : Long_Int;
                     D,X : Time) return Time
      is

         wc,wcant,wc_ik,maxWik : Time;
         proc : Processor_ID_Type;
         finish : Boolean;

      begin
         if False then
            Put_Line("W_DO");
            Put_Line("D: "& Time'Image(D));
            Put_Line("X: "& Time'Image(X));
         end if;
         proc := Transaction(A).The_Task(B).Procij;
         wcant := Transaction(A).The_Task(B).Cij; --Fix 10/02/16

         loop

            if False then
               Put_Line("wcant: "& Time'Image(wcant));
            end if;
            wc := Wac(A,B,C,Q,wcant,X,False);
            if False then
               Put_Line("wc A: "& Time'Image(wc));
            end if;
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I/=A then
                  maxWik := Time(0);
                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc and then
                       not((I=A) and then (K=B)) 
                     then
                        wc_ik := Wik(I,K,wcant,A,B,D,False);
                        if False then
                           Put_Line("wc I,K("& Transaction_ID_Type'Image(I) & "-" & Task_ID_Type'Image(K) & ") :" & Time'Image(maxWik));
                        end if;
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  if False then
                     Put_Line("wc I: "& Transaction_ID_Type'Image(I) & " - " & Time'Image(maxWik));
                  end if;
                  wc := wc + maxWik;
               end if;
            end loop;
            if False then
               Put_Line("wc final: " & Time'Image(wc));
            end if;
            finish := (wc<=wcant);
            if wc > wcant then
               wcant := wc;
            end if;
            exit when finish;

         end loop;
         return wcant;

      end W_DO;

      A : constant Transaction_ID_Type := I;
      B : constant Task_ID_Type        := J;
      p0,pl,pf : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if False then
         for I in 1..Max_Transactions loop
            for J in 1.. Transaction(I).Ni loop
               Put_Line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
            end loop;
         end loop;
      end if;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and then
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij 
            then

               if False then
                  Put_Line("A: " & Transaction_ID_Type'Image(A));
                  Put_Line("B: " & Task_ID_Type'Image(B));
                  Put_Line("C: " & Task_ID_Type'Image(C));

               end if;

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Local_Offsets_w_pr(A,B,C);
               if False then

                  Put_Line("Psi builded");

               end if;
               p0 := P0ijk(A,B,C);
               pl := PLijk(A,B,C);
               pf := Pfijk(A,B,C);
               if False then
                  Put_Line("p0"& Long_Int'Image(p0));
                  Put_Line("pl"& Long_Int'Image(pl));
                  Put_Line("pf"& Long_Int'Image(pf));
               end if;
               for p in p0 .. pl loop
                  if False then
                     Put_Line("p"& Long_Int'Image(p));
                  end if;
                  --if((p<0)or((abs(FPrimeijk(A,B,C)-Fijk(A,B,C))<Epsilon)and(p=0)))
                  if p < pf then
                     if False then
                        Put_Line("Set0");
                     end if;
                     Ax := Time(0);
                     W_abc := W_DO(A,B,C,p,Transaction(A).The_Task(B).SDij, Transaction(A).The_Task(B).SDij); --Fix 10/02/16
                     if False then
                        Put_Line("W_abc: "& Time'Image(W_abc));
                     end if;
                     -- May 2025: Changed the transaction's period
                     -- for the task's period
                     R_abc := W_abc-FPrimeijk(A,B,C)-Time(p-1)*
                       Transaction(A).Ti+
                       Transaction(A).The_Task(B).Oij-Ax;
                     if False then
                        Put_Line("R_abc: "& Time'Image(R_abc));
                     end if;
                     if R_abc > Rmax then
                        Rmax := R_abc;
                     end if;

                     if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or else
                           (R_abc >= Large_Time))
                       and then Rmax >= Analysis_Bound
                     then
                        if Verbose then
                           Put(" Task over its Analysis Bound");
                        end if;
                        Changes_Made := True;
                        for K in B .. Transaction (A).Ni loop
                           Transaction (A).The_Task (K).Model := Unbounded_Effects;
                           Transaction (A).The_Task (K).Rij   := Large_Time;
                           if K < Transaction (A).Ni then
                              Transaction (A).The_Task (K+1).Jij := Large_Time;
                           end if;
                        end loop;

                        Over_Analysis_Bound := True;

                     end if;

                     exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;

                  else
                     if False then
                        Put_Line("Set1");
                     end if;
                     Psi_Cursor := First(Psi_Set);

                     while Has_Element(Psi_Cursor) loop

                        psi := Element(Psi_Cursor);
                        if False then
                           Put_Line("psi: "& Time'Image(psi));
                        end if;
                        if psi <
         -- May 2025: Changed the transaction's period
         -- for the task's period
                          (FPrimeijk(A,B,C) + Time(p)*Transaction(A).Ti +
                             Transaction(A).The_Task(B).SDij) and then
                          psi >=
                          (FPrimeijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                             Transaction(A).The_Task(B).SDij)
                        then

                           Ax := psi-FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti -
                             Transaction(A).The_Task(B).SDij;
                           if False then
                              Put_Line("Ax: "& Time'Image(Ax));
                           end if;
         -- May 2025: Changed the transaction's period
         -- for the task's period
                           W_abc := W_DO(A,B,C,p,psi, FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti - Transaction(A).The_Task(B).SDij); --Fix 10/02/16
                           if False then
                              Put_Line("W_abc: "& Time'Image(W_abc));
                           end if;
                           R_abc := W_abc-FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                             Transaction(A).The_Task(B).Oij-Ax;
                           if False then
                              Put_Line("R_abc: "& Time'Image(R_abc));
                           end if;
                           if R_abc > Rmax then
                              Rmax := R_abc;
                           end if;

                           if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or else
                                 (R_abc >= Large_Time))
                             and then Rmax >= Analysis_Bound
                           then
                              if Verbose then
                                 Put(" Task over its Analysis Bound");
                              end if;
                              Changes_Made := True;
                              for K in B .. Transaction (A).Ni loop
                                 Transaction (A).The_Task (K).Model := Unbounded_Effects;
                                 Transaction (A).The_Task (K).Rij   := Large_Time;
                                 if K < Transaction (A).Ni then
                                    Transaction (A).The_Task (K+1).Jij := Large_Time;
                                 end if;
                              end loop;

                              Over_Analysis_Bound := True;

                           end if;

                           exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;


                        end if;
                        Next(Psi_Cursor);
                     end loop; -- psi
                  end if;
                  exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
               end loop; -- p

            end if;
            exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
         end loop; -- C

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;

      -- April 2025: Added the unbounded_response case
      if Transaction (A).The_Task (B).Model = Unbounded_Response then
         Transaction (A).The_Task (B).Rij := Large_Time;
      end if;

   end Offset_Based_Approx_W_Pr_Task_EDF_Local;
   
   --------------------------------------------
   -- Initialize_Processor_Analysis_Accesses --
   --------------------------------------------

   procedure Initialize_Processor_Analysis_Accesses
     (The_System         : Mast.Systems.System;
      -- My_System          : Translation.Linear_Transaction_System;
      The_Accesses_Array : in out Processor_Analysis_Accesses;
      Verbose            : Boolean)
   is

      isLocal       : constant Boolean                     :=
        The_System.The_Processor_Analysis_Tool.isLocal;
      User_Analysis : constant Mast.General_Analysis_Tools :=
        The_System.The_Processor_Analysis_Tool.The_General_Analysis;
      Proc : Processor_ID;
      Res_Ref       : Processing_Resources.Processing_Resource_Ref;
      Sched_Ref : Schedulers.Primary.Primary_Scheduler_Ref;
      A_Sched_Policy_Ref : Scheduling_Policies.Scheduling_Policy_Ref;
      Actual_Tool: Available_Analysis_Tools;
      Proc_Iterator : Processing_Resources.Lists.Iteration_Object;
   begin
      if Verbose then
         Put_Line ("Initializing array of procedure accesses");
      end if;
      
      -- Iterate over all the processing resources
      Mast.Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,
         Proc_Iterator);
      for K in
        1 ..
        Mast.Processing_Resources.Lists.Size
          (The_System.Processing_Resources)
      loop
         Mast.Processing_Resources.Lists.Get_Next_Item
           (Res_Ref,
            The_System.Processing_Resources,
            Proc_Iterator);
         Proc:=Processor_ID(K);
         Sched_Ref := Mast.Schedulers.Primary.Find_Scheduler
           (Res_Ref,
            The_System);
         A_Sched_Policy_Ref        :=
           Sched_Ref.Scheduling_Policy;
         if A_Sched_Policy_Ref.all in  
           Scheduling_Policies.Fixed_Priority_Policy'class 
         then
            case User_Analysis is
               when Holistic =>
                  The_Accesses_Array (Proc) :=
                    Holistic_Task_FP'Access;
                  Actual_Tool := Holistic_Task_Fp;
               when Offset_Based_Approx_W_Pr =>
                  The_Accesses_Array (Proc) :=
                    Offset_Based_Approx_W_Pr_Task_FP'Access;
                  Actual_Tool := Offset_Based_Approx_W_Pr_Task_Fp;
               when Offset_Based_Approx =>
                  The_Accesses_Array (Proc) :=
                    Offset_Based_Approx_Task_FP'Access;
                  Actual_Tool := Offset_Based_Approx_Task_Fp;
               when Offset_Based_Slanted =>
                  The_Accesses_Array (Proc) :=
                    Offset_Based_Slanted_Task_FP'Access;
                  Actual_Tool := Offset_Based_Slanted_Task_Fp;
               when Offset_Based_Brute_Force =>
                  The_Accesses_Array (Proc) :=
                    Offset_Based_Brute_Force_Task_FP'Access;
                  Actual_Tool := Offset_Based_Brute_Force_Task_Fp;
            end case;

         else -- Is EDF
            if isLocal then -- local EDF
               case User_Analysis is
                  when Holistic =>
                     The_Accesses_Array (Proc) :=
                       Holistic_Task_EDF_Local'Access;
                     Actual_Tool := Holistic_Task_Edf_Local;
                  when Offset_Based_Approx =>
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Local'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Local;
                  when Offset_Based_Slanted =>
                     -- Downgrade to Offset_Based_Approx_Task_EDF_Local
                     -- mgh: March 2025: added the following message 
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Local'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Local;
                  when Offset_Based_Approx_W_Pr =>
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_W_Pr_Task_EDF_Local'Access;
                     Actual_Tool := Offset_Based_Approx_W_Pr_Task_Edf_Local;
                  when Offset_Based_Brute_Force =>
                     -- Downgrade to Offset_Based_Approx_Task_EDF_Local
                     -- mgh: March 2025: added the following message 
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Local'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Local;
               end case;
            else -- global EDF
               case User_Analysis is
                  when Holistic =>
                     The_Accesses_Array (Proc) :=
                       Holistic_Task_EDF_Global'Access;
                     Actual_Tool := Holistic_Task_Edf_Global;
                  when Offset_Based_Approx =>
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Global'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Global;
                  when Offset_Based_Slanted =>
                     -- Downgrade to Offset_Based_Approx_Task_EDF_Global
                     -- mgh: March 2025: added the following message 
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Global'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Global;
                  when Offset_Based_Approx_W_Pr =>
                     -- Mgh: march 2025 added the case for approx_w_pr
                     -- accessing the approx analysis, because
                     -- approx_w_pr is not implemented for global EDF
                     -- Downgrade to Offset_Based_Approx_Task_EDF_Global
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Global'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Global;
                  when Offset_Based_Brute_Force =>
                     -- Downgrade to Offset_Based_Approx_Task_EDF_Global
                     -- mgh: March 2025: added the following message 
                     The_Accesses_Array (Proc) :=
                       Offset_Based_Approx_Task_EDF_Global'Access;
                     Actual_Tool := Offset_Based_Approx_Task_Edf_Global;
               end case;
            end if;
         end if;
         
         -- Report type of analysis
         if Verbose then
            Put_Line
              ("Actual analysis in "&
                 To_String(Res_Ref.Name)&": "&
                 Actual_Tool'Img);
         end if;
      end loop;
               
   end Initialize_Processor_Analysis_Accesses;

   function img (Number : Long_Int) return String is
   begin
      return Ada.Strings.Fixed.Trim(Number'Img,Ada.Strings.Left);
   end img;


end Mast.Linear_Task_Analysis_Tools;
