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

with Mast.Systems, Mast.Processing_Resources, Mast.Scheduling_Parameters,
     Mast.Processing_Resources.Processor, Ada.Containers.Ordered_Maps,
     Ada.Containers.Ordered_Sets, trimmed_image, Ada.Directories,
     Ada.Strings.Fixed;

with Ada.Sequential_IO;

use Trimmed_Image;

with Ada.Text_IO; use Ada.Text_IO;

package body Mast.Linear_Task_Analysis_Tools is

   debug_global : Boolean := False;

   ---------------------
   -- Distributed_RTA --
   ---------------------

   procedure Distributed_RTA
     (The_System                       : in out Mast.Systems.System;
      Verbose                          : in Boolean  := True;
      Stop_Factor_When_Not_Schedulable : in Positive :=
        Mast.Default_Stop_Factor)
   is

      My_System                 : Translation.Linear_Transaction_System;
      Done, Changes_Made, Over_Analysis_Bound : Boolean;
      Access_to_Task_Analysis   : Processor_Analysis_Accesses;

      procedure Initialize_Response_Times_And_Jitter
        (Transaction : in out Linear_Transaction_System)
      is
         Act_B, Act_W : Time;
	 Pred : Transaction_Id_Type;
	 Pred_Ref : Transaction_Id_Array_Ref;
	 Rmax : Time:=0.0;
	 Rbest: Time :=0.0;
      begin
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
			  (Task_Id_Type
			     (Transaction(Pred_Ref(Tr)).Ni)).Rij);
		     Rbest:=Time'Max 
		       (Rbest, Transaction (Pred_Ref(Tr)).The_Task 
			  (Task_Id_Type
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

            Transaction (I).The_Task (1).Oij  := Act_B;
            Transaction (I).The_Task (1).Jij  := Act_W - Act_B;
            Transaction (I).The_Task (1).Rbij := Act_B +
              Transaction (I).The_Task (1).
              Cbijown;
            Transaction (I).The_Task (1).Rij  := Act_W +
              Transaction (I).The_Task (1).
              Cijown;

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
               Transaction (I).The_Task (L).Oij  := Act_B;
               Transaction (I).The_Task (L).Jij  := Act_W - Act_B;
               Transaction (I).The_Task (L).Rbij := Act_B +
                 Transaction (I).The_Task (
                                           L).Cbijown;
               Transaction (I).The_Task (L).Rij  := Act_W +
                 Transaction (I).The_Task (
                                           L).Cijown;
            end loop;
         end loop;

      end Initialize_Response_Times_And_Jitter;

      ---------------------------------------------------
      -- Propagate the response times to the next task,
      -- calculating its equivalent offset and jitter
      ----------------------------------------------------
      procedure Propagate_Results_To_Next_Task
        (Transaction : in out Linear_Transaction_System;
         I : Transaction_ID_Type;
         J : Task_ID_Type)
      is
	 
	 procedure Propagate_Results
	   (Rworst, Rbest : in Time;
	    To_Tr : in Transaction_ID_Type; 
	    To_Tsk : in Task_ID_Type)
	 is
	 begin
	    -- Propagate Rworst/Rbest results into task To_Tsk 
	    -- in transaction To_Tr
	    Transaction (To_Tr).The_Task (To_Tsk).Oij:=
		    Time'Max
		    (Transaction (To_Tr).The_Task (To_Tsk).Oijmin,
		     Rbest + Transaction (To_Tr).The_Task (To_Tsk).Delayijmin);
            Transaction (To_Tr).The_Task (To_Tsk).Jij :=
              Time'Max
	      (Transaction (To_Tr).The_Task (To_Tsk).Oijmax,--?
	       Rworst + Transaction (To_Tr).The_Task (To_Tsk).Delayijmax) +
              Transaction (To_Tr).The_Task (To_Tsk).Jinit -
              Transaction (To_Tr).The_Task (To_Tsk).Oij;	    
	 end Propagate_Results;
	 
	 Succ : Transaction_Id_Type;
	 Num_Succ : Positive;
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
	    -- June 2014: added support for successor
	    if Transaction(I).Successor_Trans_Ref/=null then
	       Num_Succ:=Transaction(I).Successor_Trans_Ref.all'Length;
	       if Num_Succ=1 then
		  Succ:=Transaction(I).Successor_Trans_Ref(1);
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
			for Tr in Pred.all'Range loop
			   Rmax:=Time'Max 
			     (Rmax, Transaction (Pred(Tr)).The_Task 
				(Task_Id_Type
				   (Transaction(Pred(Tr)).Ni)).Rij);
			   Rbest:=Time'Max 
			     (Rbest, Transaction (Pred(Tr)).The_Task 
				(Task_Id_Type
				   (Transaction(Pred(Tr)).Ni)).Rbij);
			end loop;
			Propagate_Results
			  (Rworst   => Rmax,
			   Rbest    => Rbest,
			   To_Tr    => Succ,
			   To_Tsk   => 1);		     
		  end case;
	       else
		  -- NumSucc>1, therefore this is a fork handler
		  -- Propagate results to all successors
		  Rmax  :=Transaction (I).The_Task (J).Rij;
		  Rbest := Transaction (I).The_Task (J).Rbij;
		  for Tr in Transaction(I).Successor_Trans_Ref.all'Range loop
		     Propagate_Results
		       (Rworst   => Rmax,
			Rbest    => Rbest,
			To_Tr    => Transaction(I).Successor_Trans_Ref(Tr),
			To_Tsk   => 1);		     
		  end loop;
	       end if; -- Num_Succ
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
         Put_line("Stop Factor : "&Img(Stop_Factor_When_Not_Schedulable));
      end if;

      Access_to_Task_Analysis := (others => null);
      Translate_Linear_System (The_System, My_System, Verbose);
      Clear_Time_Results(My_System,The_System);

      Initialize_Processor_Analysis_Accesses
        (The_System         => The_System,
         My_System          => My_System,
         The_Accesses_Array => Access_to_Task_Analysis,
         Verbose            => Verbose);

      Initialize_Response_Times_And_Jitter (My_System);

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
                  exit when My_System (J).Transaction_Id /=
                    My_System (I).Transaction_Id;
                  Extra := Extra + 1;
               end loop;

               -- Find Higher (and < Large_Time) deadline in this transaction
               for K in reverse 0 .. Extra loop
                  for J in reverse 1 .. My_System (I + K).Ni loop
                     if My_System (I + K).The_Task (J).Dij < Large_Time
                       and My_System (I + K).The_Task (J).Dij > Max_D then
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

            --Put_line("DEBUG Analysis_Bound : "&Time'Image(Analysis_Bound));

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

               Propagate_Results_To_Next_Task(My_System,I,J);

               if debug_global and verbose then
                  Put_line(" R = "&
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
            end loop; --Task Loop

            Auxiliary_Finalization_for_Offsets (I);
            exit when Over_Analysis_Bound;
         end loop; --Transaction loop
	 
         exit when Done or Over_Analysis_Bound;

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
            Open(File_B,append_file,Mast_Benchmark_Output_Filename);
            Ada.Directories.Set_Directory("..");
            Put(File_B,"R  ");
            for I in 1 .. Max_Transactions loop
               Ni := My_System(I).Ni;
               Put(File_B,Img(My_System(I).The_Task(Ni).Rij,2)&" ");
               --Avg_R := Avg_R + My_System(I).The_Task(Ni).Rij;
            end loop;
            --Put_line(File_B,Img(Avg_R/time(Max_Transactions),2));
            New_line(File_B);
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
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      debug : Boolean := false;--(I=1) and (J=2) and debug_global;

      Transaction : Translation.Linear_Transaction_System renames My_System;

      function WTindell
        (Ta          : Transaction_ID_Type;
         K           : Task_ID_Type;
         Q           : Long_Int;
         Transaction : in Linear_Transaction_System)
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

               if (Transaction (I).The_Task (J).Procij = Proc) and
                 (Transaction (I).The_Task (J).Prioij >= Prio) and
                 not ((I = Ta) and (J = K))
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
                  if (Transaction (I).The_Task (J).Procij = Proc) and
                    (Transaction (I).The_Task (J).Prioij >= Prio) and
                    not ((I = Ta) and (J = K))
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

            if Debug then
               Put_line(Wc'Img);
            end if;

            Done  := Wc = Wcant;
            Wcant := Wc;
            exit when Done;
         end loop;
         return Wc;
      end WTindell;

      Q                    : Long_Int;
      R_Ij, W_Ij, Rmax, Di : Time;
      Ni                   : Task_ID_Type;

      --New Variables for Non-Preemptive
      Ci, Bi, Ti, Ji, Tant, Qm, Wm, Want, Rm : Time;
      Tm : Time := 0.0;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Holistic FP for Task : " &
              Transaction_ID_Type'Image (I) &
              "," & Task_ID_Type'Image (J));
      end if;

      Ni   := Transaction (I).Ni;
      Di   := Transaction (I).The_Task (Ni).Dij;
      Q    := 0;
      Rmax := 0.0;
      
      --Non-Preemptible init variables
      Ci:=Transaction(I).The_Task(J).Cijown;
      Ti:=Transaction(I).The_Task(J).Tijown;
      Ji:=Transaction(I).The_Task(J).Jinit;
      Bi:=Transaction(I).The_Task(J).Bij;

      if Transaction (I).The_Task (J).Model /= Unbounded_Response and
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then
         if Transaction(I).The_Task(J).Preemptible then
            --Start Preemptible analysis
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

                  exit when R_Ij = Large_Time;

               end if;

               exit when (W_Ij <= Time (Q) * Transaction (I).The_Task (J).Tijown)
                 or Transaction (I).The_Task (J).Model = Unbounded_Effects;
            end loop;

            -- Store the worst-case response time obtained
            if Rmax > Transaction (I).The_Task (J).Rij then
               Changes_Made := True;
               Transaction (I).The_Task (J).Rij := Rmax;
            end if;
         
            --End preemptible analysis
         else
            --Start Non_Preemptible analysis
            
            -- Calculate Tm and Qm
            Tant := 0.0;
            Tm := Ci;
            while Tant/=Tm loop
               Tant := Tm;
               Tm := Bi;
               for H in 1..Max_Transactions loop
                  exit when Transaction(H).Ni=0;
                  if Transaction(I).The_Task(J).Prioij<=Transaction(H).The_Task(Transaction(H).Ni).Prioij then --Higher or equal priority
                     Tm := Tm + Ceiling((Tant+Transaction(H).The_Task(Transaction(H).Ni).Jinit)/Transaction(H).The_Task(Transaction(H).Ni).Tijown)*Transaction(H).The_Task(Transaction(H).Ni).Cijown;
                  end if;
               end loop;
            end loop;
            Qm := Ceiling((Tm+Ji)/Ti);
            if Verbose then
               Put_Line("Convergence: "&Time_Interval'Image(Tm));
               Put_Line("Therefore, Qm is "&Time_Interval'Image(Qm));
            end if;

            -- Calculate Wm and Rm
            Rmax := 0.0;
            Want := Large_Time;
            for K in 0..Integer(Qm)-1 loop
               if K=0 then
                  Wm := Bi + Time_Interval(K)*Ci;
               else
                  Wm := Want + Ci; --For Qm>0 this is a best starting point
               end if;
               Want := Large_Time;
               while Want/=Wm loop
                  Want := Wm;
                  Wm := Bi + Time_Interval(K)*Ci;
                  for H in 1..Max_Transactions loop
                     exit when Transaction(H).Ni=0;
                     if Transaction(I).The_Task(J).Prioij<=Transaction(H).The_Task(Transaction(H).Ni).Prioij and Transaction_ID'Image(Transaction(I).Transaction_Id)/=Transaction_ID'Image(Transaction(H).Transaction_Id) then --(Higher priority) UPDATE: Changed to higher or equal priority, but exclude the actual task from the pool
                        --Wm := Wm + Ceiling((Want+Transaction(H).The_Task(Transaction(H).Ni).Jinit)/Transaction(H).The_Task(Transaction(H).Ni).Tijown)*Transaction(H).The_Task(Transaction(H).Ni).Cijown;
                        Wm := Wm + (Floor((Want+Transaction(H).The_Task(Transaction(H).Ni).Jinit)/Transaction(H).The_Task(Transaction(H).Ni).Tijown)+1.0)*Transaction(H).The_Task(Transaction(H).Ni).Cijown;  --Floor+1 instead of Ceiling
                     end if;
                  end loop;
               end loop;
               Rm := Ji + Wm - Time_Interval(K)*Ti + Ci;
               if Verbose then
                  Put_Line("Wm:"&Time_Interval'Image(Wm));
                  Put_Line("Rm:"&Time_Interval'Image(Rm));
               end if;
               if Rmax<Rm then
                  Rmax := Rm;
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

                  exit when R_Ij = Large_Time;

               end if;
               
            end loop;
            if Verbose then
               Put_Line("Ends with Wm="&Time_Interval'Image(Wm));
               Put_Line("Final Rm:"&Time_Interval'Image(Rmax));
               Put_Line ("------------------");
            end if;
            
            if Rmax > Transaction (I).The_Task (J).Rij then
               Transaction(I).The_Task(J).Rij := Rmax;
               Changes_Made := True;
            end if;
            --End Non_Preemptible analysis
         end if;
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
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Transaction : Translation.Linear_Transaction_System renames My_System;

      --Set_Psi          : array (1 .. 50000) of Time;
      Wbusy            : Time;
      pL               : Long_Int;
      --N_PSI          : Integer;
      --cnt              : Integer;
      Rmax, R_ab, W_ab : Time;
      Ni               : Task_ID_Type;
      debug : boolean := debug_global and (I=1) and (J=2);


      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Long_Int) return Long_Int is
      begin
         if X < 0 or Y < 0 then
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
                  if (Transaction (I).The_Task (J).Procij = Proc) and
                    not ((I = a) and (J = b))
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
         psi : time;

         procedure Insert (set : in out Psi_Container.Set;
                           element : time)
         is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin

         if Debug then
            Put_line("Build psi set : function");
            Put_line("Build psi set : a="&Img(Integer(a)));
            Put_line("Build psi set : b="&Img(Integer(b)));
         end if;

         Proc  := Transaction (A).The_Task (B).Procij;
         wbusy := Busy_Period (A, B);

         if Debug then
            Put_line("Build psi set : wbusy psi ="&Img(Integer(wbusy)));
         end if;

         -- (6)
         for P in
           1 ..Long_Int (Ceiling (wbusy / Transaction (A).The_Task (B).Tij))
         loop
            psi := Time (P - 1) * Transaction (A).The_Task (B).Tij +
              Transaction (A).The_Task (B).SDij;
            if debug then
               put_line("Build psi set : (6) p_psi = "&Img(P));
               put_line("Build psi set : (6) psi = "&Img(psi));
            end if;
            Insert(Psi_set,psi);
         end loop;

         -- (4)
         for I in Transaction_ID_Type range 1 .. Max_Transactions loop
            exit when Transaction (I).Ni = 0;
            for J in 1 .. Transaction (I).Ni loop
               if (Transaction (I).The_Task (J).Procij = Proc) and
                 not ((I = A) and (J = B))
               then
                  psi := Transaction (I).The_Task (J).SDij;
                  if debug then
                     put_line("Build psi set : (4) (sdij) psi = "&Img(psi));
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
                        put_line("Build psi set : (4) p_psi = "&Img(P));
                     end if;

                     if Time (P - 1) * Transaction (I).The_Task (J).Tij -
                       Transaction (I).The_Task (J).Jij >=
                       0.0
                     then
                        psi := Time (P - 1) * Transaction (I).The_Task (J).Tij -
                          Transaction (I).The_Task (J).Jij +
                          Transaction (I).The_Task (J).SDij;

                        if debug then
                           put_line("Build psi set : (4) psi = "&Img(psi));
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

         if Debug then
            Put_line("Wab function");
            Put_line("Wab_EDF_Local : a="&Img(Integer(a)));
            Put_line("Wab_EDF_Local : b="&Img(Integer(b)));
            Put_line("Wab_EDF_Local : p="&Img(p));
            Put_line("Wab_EDF_Local : D="&Img(D));
         end if;

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Time (p) * Transaction (a).The_Task (b).Cij;
         loop
            if Debug then
               Put_line("Wab_EDF_Local : Wcant="&Img(Wcant));
            end if;
            Wc := Time (p) * Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and
                    not ((I = a) and (J = b))
                  then
                     Wc := Wc + Wij_EDF_Local (I, J, Wcant, D);
                     if Debug then
                        put_line("Wab_EDF_Local : Wc partial sum = "&Img(Wc));
                     end if;
                  end if;
               end loop;
            end loop;
            if Debug then
               put_line("Wab_EDF_Local : Wc final = "&Img(Wc));
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

      if Verbose Then
         Put_line
           ("        Holistic EDF Local for Task : " &
              Transaction_ID_Type'Image (I) &
              "," &
              Task_ID_Type'Image (J));
      end if;


      if Transaction (I).The_Task (J).Model /= Unbounded_Response and
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then

         Ni   := Transaction (I).Ni;
         Rmax  := 0.0;
         Wbusy := Busy_Period (I, J);

         if debug then
            New_line;
            Put_Line("Wbusy = "&Img(Wbusy));
         end if;

         Clear(Psi_Set);
         Build_Set_PSI_EDF_Local (I, J);

         pL := Long_Int (Ceiling (Wbusy / Transaction (I).The_Task (J).Tij));

         for P in 1 .. pL loop

            if debug then
               put_line("p = "&Img(p));
            end if;

            Psi_Cursor := First(Psi_Set);
            while Has_Element(Psi_Cursor) loop

               psi := Element(Psi_Cursor);

               if debug then
                  put_line("psi = "&Img(psi));
                  put_line("? psi >= "&Img((Time (P - 1) * 
					      Transaction (I).The_Task (J).Tij +
                      Transaction (I).The_Task (J).SDij)));
                  put_line("? psi < "&Img((Time (P) * 
					     Transaction (I).The_Task (J).Tij +
                      Transaction (I).The_Task (J).SDij)));
               end if;

               if (psi >=
                     (Time (P - 1) * Transaction (I).The_Task (J).Tij +
                        Transaction (I).The_Task (J).SDij) and
                     psi <
                     (Time (P) * Transaction (I).The_Task (J).Tij +
                        Transaction (I).The_Task (J).SDij))
               then

                  W_ab := Wab_EDF_Local (I, J, P, psi);
                  if debug then
                     put_line("w_ab = "&Img(W_ab));
                  end if;

                  R_ab := W_ab - psi +
                    Transaction (I).The_Task (J).SDij +
                    Transaction (I).The_Task (J).Jij +
                    Transaction (I).The_Task (J).Oij;

                  if debug then
                     put_line("r_ab = "&Img(r_ab));
                     Put_line("Rmax = "&Img(Rmax));
                  end if;

                  if R_ab > Rmax then
                     Rmax := R_ab;

                     if debug then
                        Put_line("New Rmax = "&Img(Rmax));
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
               Put_line("New Rij");
               Put_line("Rij = "&Img(Rmax));
            end if;
         end if;
      end if;

      if debug then
         Put_line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
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
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Transaction : Translation.Linear_Transaction_System renames My_System;

      --Set_Psi          : array (1 .. 50000) of Time;
      Wbusy            : Time;
      pL               : Long_Int;
      --N_PSI, cnt       : Integer;
      Rmax, R_ab, W_ab : Time;
      Ni               : Task_ID_Type;

      Debug : Boolean := false;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Long_Int) return Long_Int is
      begin
         if X < 0 or Y < 0 then
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
                  if (Transaction (I).The_Task (J).Procij = Proc) and
                    not ((I = a) and (J = b))
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
            Put_line("Wab function");
            Put_line("Wab_EDF_Global : a="&Img(Integer(a)));
            Put_line("Wab_EDF_Global : b="&Img(Integer(b)));
            Put_line("Wab_EDF_Global : p="&Img(p));
            Put_line("Wab_EDF_Global : D="&Img(D));
         end if;

         Proc  := Transaction (a).The_Task (b).Procij;
         Wcant := Time (p) * Transaction (a).The_Task (b).Cij;
         loop
            if Debug then
               Put_line("Wab_EDF_Global : Wcant="&Img(Wcant));
            end if;
            Wc := Time (p) * Transaction (a).The_Task (b).Cij;
            for I in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               for J in 1 .. Transaction (I).Ni loop
                  if (Transaction (I).The_Task (J).Procij = Proc) and
                    not ((I = a) and (J = b))
                  then
                     Wc := Wc + Wij_EDF_Global (I, J, Wcant, D);
                     if Debug then
                        put_line("Wab_EDF_Global : Wc partial sum = "&Img(Wc));
                     end if;
                  end if;
               end loop;
            end loop;
            if Debug then
               put_line("Wab_EDF_Global : Wc final = "&Img(Wc));
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

      if Verbose and Debug_Global Then
         Put
           ("        Holistic EDF Global for Task : " &
              Transaction_ID_Type'Image (I) &
              "," &
              Task_ID_Type'Image (J));
      end if;


      if Transaction (I).The_Task (J).Model /= Unbounded_Response and
        Transaction (I).The_Task (J).Model /= Unbounded_Effects
      then

         Ni   := Transaction (I).Ni;
         Rmax  := 0.0;
         Wbusy := Busy_Period (I, J);
         pL :=
           Long_Int (Ceiling
             ((Wbusy + Transaction (I).The_Task (J).Jij) /
                  Transaction (I).The_Task (J).Tij));

         if debug then
            New_line;
            Put_Line("Wbusy = "&Img(Wbusy));
            Put_Line("pL = "&Img(pL));
         end if;

         for p in 1 .. pL loop

            if debug then
               Put_Line("p = "&Img(p));
            end if;

            Proc  := Transaction (I).The_Task (J).Procij;
            for A in Transaction_ID_Type range 1 .. Max_Transactions loop
               exit when Transaction (A).Ni = 0;
               for B in 1 .. Transaction (A).Ni loop
                  if (Transaction (A).The_Task (B).Procij = Proc) then
                     for P_for_psi in
                       1 .. Long_Int (Ceiling
                         ((wbusy +
                              Transaction (A).The_Task (B).Jij) /
                              Transaction (A).The_Task (B).Tij))
                     loop

                        if debug then
                           Put_Line("A,B = "&Img(Integer(A))&","&Img(Integer(B)));
                           Put_Line("p_psi = "&Img(P_for_psi));
                        end if;

                        Psi :=
                          Time (P_for_psi - 1) * Transaction (A).The_Task (B).Tij -
                          Transaction (A).The_Task (B).Jij +
                          Transaction (A).The_Task (B).SDij;

                        if debug then
                           Put_Line("psi = "&Img(Psi));
                           Put_Line("¿ psi >= "&Img((Time (p - 1) * Transaction (I).The_Task (J).Tij -
                               Transaction (I).The_Task (J).Jij +
                               Transaction (I).The_Task (J).SDij)));
                           Put_Line("psi < "&Img((Time (p) * Transaction (I).The_Task (J).Tij -
                               Transaction (I).The_Task (J).Jij +
                               Transaction (I).The_Task (J).SDij)));
                        end if;

                        --------------------

                        if (Psi >=
                            (Time (p - 1) * Transaction (I).The_Task (J).Tij -
                               Transaction (I).The_Task (J).Jij +
                               Transaction (I).The_Task (J).SDij) and
                              Psi <
                                (Time (p) * Transaction (I).The_Task (J).Tij -
                                   Transaction (I).The_Task (J).Jij +
                                   Transaction (I).The_Task (J).SDij))
                        then

                           W_ab := Wab_EDF_Global (I, J, p, Psi);

                           if debug then
                              Put_line("W_ab = "&Img(W_ab));
                           end if;


                           R_ab := W_ab -
                             Psi +
                               Transaction (I).The_Task (J).SDij +
                               Transaction (I).The_Task (J).Oij;

                           if debug then
                              Put_line("R_ab = "&Img(R_ab));
                              Put_line("Rmax = "&Img(Rmax));
                           end if;

                           if R_ab > Rmax then
                              Rmax := R_ab;
                              if debug then
                                 Put_line("New Rmax = "&Img(Rmax));
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

            if debug then
               Put_line("New Rij");
               Put_line("Rij = "&Img(Rmax));
            end if;

         end if;

         if Rmax > Analysis_Bound then
            Rmax := Analysis_Bound;
            Over_Analysis_Bound := True;
         end if;

      end if;

      if debug then
         Put_line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
      end if;

   end Holistic_Task_EDF_Global;


   --------------------------------------
   -- Offset_Based_Approx_W_Pr_Task_Fp --
   --------------------------------------

   procedure Offset_Based_approx_w_pr_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Debug : boolean := debug_global;

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : Transaction_ID_Type := I;
      B                  : Task_ID_Type        := J;
      P0, Pl             : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;

      H : Task_ID_Type;

      -------------------
      -- First_In_Hseg --
      -------------------

      function First_In_Hseg
        (I    : Transaction_ID_Type;
         J    : Task_ID_Type;
         Prio : Priority;
         Proc : Processor_ID_Type)
        return Task_ID_Type
      is
         H : Task_ID_Type;
      begin
         H := J;
         loop
            exit when (H = 1)
              or else ((Transaction (I).The_Task (H - 1).Prioij <
                          Prio) or
                         (Transaction (I).The_Task (H - 1).Procij /=
                            Proc));
            H := H - 1;
         end loop;
         return H;
      end First_In_Hseg;

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

      function In_MP
        (I    : Transaction_ID_Type;
         J    : Task_ID_Type;
         Prio : Priority;
         Proc : Processor_ID_Type)
        return Boolean
      is
      begin
         for L in 1 .. J loop
            if (Transaction (I).The_Task (L).Procij = Proc) and
              (Transaction (I).The_Task (L).Prioij < Prio)
            then
               return False;
            end if;
         end loop;
         return True;
      end In_MP;

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
                  Transaction (I).The_Task (Jj).Procij) and
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
            exit when (Transaction (I).The_Task (J).Procij = Proc) and
              (Transaction (I).The_Task (J).Prioij >= Prio);
            J := J - 1;
         end loop;
         H           := First_In_Hseg (I, J, Prio, Proc);
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

         if debug then
            Put_line("rc I ="&I'img);
            Put_line("rc H ="&H'img);
            Put_line("rc Jih ="&Transaction(I).The_Task(H).Jij'img);
            Put_line("rc FTikk ="&FTijk(I,K,K)'img);
            Put_line("rc Tik ="&Transaction(I).The_Task(K).Tij'img);
            Put_line("rc The_First_P ="&The_First_P'img);
            Put_line("rc P0kk ="&P0kk'img);
         end if;

         for P in The_First_P .. 0 loop
            PLinkial := 0.0;
            Sum      := 0.0;
            for J in 1 .. Transaction (I).Ni loop
               if Transaction (I).The_Task (J).Procij = Proc then
                  if Transaction (I).The_Task (J).Prioij >= Prio then
                     Cell := 0.0;
                     H    := First_In_Hseg (I, J, Prio, Proc);
                     P0   :=
                       Long_Int (-Floor
                                   ((Transaction (I).The_Task (H).Jij +
                                       FTijk (I, H, K)) /
                                      Transaction (I).The_Task (K).Tij) +
                                   Time'(1.0));
                     if (P >= P0) and
                       (T >
                          FTijk (I, H, K) +
                          Time (P - 1) * Transaction (I).The_Task (K).Tij)
                     then
                        Cell := Transaction (I).The_Task (J).Cij;
                     end if;
                     if (J > K and
                           P >= P0kk and
                           not Same_H (I, J, K, Prio))
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

         if debug then
            Put_line("acum1 ="&acum'img);
            Put_line("proc ="&proc'img);
            Put_line("prio ="&proc'img);
         end if;

         for J in 1 .. Transaction (I).Ni loop
            if (Transaction (I).The_Task (J).Procij = Proc) and
              In_MP (I, J, Prio, Proc)
            then
               if Transaction (I).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  H    := First_In_Hseg (I, J, Prio, Proc);
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

      function Busy_Period
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type)
        return Time
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         Prio                     : Priority;
         Proc                     : Processor_ID_Type;
         Done                     : Boolean;

         N : Integer := 1;

      begin
         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         Wcant := Transaction (A).The_Task (B).Cijown +
           Transaction (A).The_Task (B).Bij;
         if debug then
            Put_line("wcant ="&wc'img);
         end if;
         loop
            Wc := Wik_LH (A, C, Wcant, A, B) +
              Transaction (A).The_Task (B).Bij;

            if debug then
               Put_line("wc1 ="&wc'img);
            end if;

            for I in 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               if I /= A then
                  MaxWik := 0.0;
                  for K in 1 .. Transaction (I).Ni loop
                     if (Transaction (I).The_Task (K).Procij = Proc) and
                       (Transaction (I).The_Task (K).Prioij >= Prio) and
                       not ((I = A) and (K = B)) and
                       ((K = 1)
                        or else (Transaction (I).The_Task (K).Delayijmin /=
                                   0.0)
                          or else (Transaction (I).The_Task (K).Oijmin /= 0.0)
                          or else (Transaction (I).The_Task (K - 1).Procij /=
                                     Proc)
                          or else (Transaction (I).The_Task (K - 1).Prioij <
                                     Prio))
                     then
                        Wc_Ik := Wik_LH (I, K, Wcant, A, B);
                        if Wc_Ik > MaxWik then
                           MaxWik := Wc_Ik;
                        end if;
                     end if;
                  end loop;

                  Wc := Wc + MaxWik;

                  if debug then
                     Put_line("maxwik ="&MaxWik'img);
                     Put_line("wc2 ="&wc'img);
                  end if;

               end if;
            end loop;

--              if debug then
--                 declare
--                    package time_io is new Ada.Sequential_IO(Time);
--                    use time_io;
--                    f : time_io.File_Type;
--                    c : character;
--                 begin
--
--                    if N = 0 then
--
--                       time_io.Create(f,Out_File,"floats.txt");
--                       time_io.Write(f,wcant);
--                       time_io.Write(f,wc);
--                       time_io.Close(f);
--                       Ada.Text_IO.Get(c);
--
--                    end if;
--
--                    N := N - 1;
--
--                 end;
--
--              end if;

            if debug then
               Put_line("fin wcant ="&wcant'img);
               Put_line("fin wc ="&wc'img);
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
         H    := First_In_Hseg (A, B, Prio, Proc);
         if In_MP (A, B, Prio, Proc) then
            return Long_Int (Ceil0
                               ((Busy_Period (A, B, C) - FTijk (A, H, C)) /
                                  Transaction (A).The_Task (C).Tij));

         elsif (C < B) and not Same_H (A, B, C, Prio) then
            return Long_Int (-Floor
                               ((Transaction (A).The_Task (C).Jij +
                                   FTijk (A, C, C)) /
                                  Transaction (A).The_Task (C).Tij));
         else
            return 0;
         end if;
      exception
         when Constraint_Error =>
            return Long_Int'Last;
      end Calculate_PL;

      ----------------------------
      -- Resolve_Self_Conflicts --
      ----------------------------

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
            exit when (Transaction (A).The_Task (J).Procij = Proc) and
              (Transaction (A).The_Task (J).Prioij >= Prio);
            J := J - 1;
         end loop;
         H           := First_In_Hseg (A, J, Prio, Proc);
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
                     H    := First_In_Hseg (A, J, Prio, Proc);
                     P0   :=
                       Long_Int (-Floor
                                   ((Transaction (A).The_Task (H).Jij +
                                       FTijk (A, H, C)) /
                                      Transaction (A).The_Task (C).Tij) +
                                   Time'(1.0));
                     if (P >= P0) and
                       (T >
                          FTijk (A, H, C) +
                          Time (P - 1) * Transaction (A).The_Task (C).Tij)
                     then
                        Cell := Transaction (A).The_Task (J).Cij;
                     end if;
                     if (J > C) and
                       (P >= P0cc) and
                       not Same_H (A, J, C, Prio)
                     then
                        Cell := 0.0;
                     end if;
                     if (J < B) and
                       (P <= Pa) and
                       not Same_H (A, J, B, Prio)
                     then
                        Cell := 0.0;
                     end if;
                     if ((J >= B) and (P > Pa)) or
                       ((J > B) and (P = Pa))
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
            if (Transaction (A).The_Task (J).Procij = Proc) and
              In_MP (A, J, Prio, Proc)
            then
               if Transaction (A).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  H := First_In_Hseg (A, B, Prio, Proc);
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

      function W_DO_LH
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type;
         P    : Long_Int)
        return Time
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         Prio                     : Priority;
         Proc                     : Processor_ID_Type;
         Done                     : Boolean;
         P0                       : Long_Int;
      begin
         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
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
                     if (Transaction (I).The_Task (K).Procij = Proc) and
                       (Transaction (I).The_Task (K).Prioij >= Prio) and
                       not ((I = A) and (K = B)) and
                       ((K = 1)
                        or else (Transaction (I).The_Task (K - 1).Procij /=
                                   Proc)
                          or else (Transaction (I).The_Task (K - 1).Prioij <
                                     Prio))
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

      if Verbose Then
         Put_line
           ("        Offset Based Optimized FP for Task : " &
              Transaction_ID_Type'Image (I) & "," &
              Task_ID_Type'Image (J));
      end if;

      Over_Analysis_Bound := False;
      Changes_Made := False;

      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      -----------------------
      ------ MAIN PROC ------
      -----------------------

      Transaction (A).The_Task (B).Tij := Transaction (A).The_Task (B).Tijown;
      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         if Debug_Global then
            New_line;
            for Z in 1..Max_Transactions loop
               for X in 1..Transaction(Z).Ni loop
                  Put(" "&Transaction(Z).The_Task(X).Jij'Img);
               end loop;
               New_line;
            end loop;
            --Put_line("I,J : "&A'Img&","&B'Img);
            --Put_line("J : "&Transaction(A).The_Task(B).Jij'Img);
            --Put_line("R : "&Transaction(A).The_Task(B).Rij'Img);
         end if;

         H                   :=
           First_In_Hseg
           (A,
            B,
            Transaction (A).The_Task (B).Prioij,
            Transaction (A).The_Task (B).Procij);
         if debug then
            Put_line("hola1");
         end if;
         Rmax                := 0.0;
         Over_Analysis_Bound := False;
         for C in 1 .. Transaction (A).Ni loop

            if (Transaction (A).The_Task (C).Prioij >=
                  Transaction (A).The_Task (B).Prioij) and
              (Transaction (A).The_Task (C).Procij =
                 Transaction (A).The_Task (B).Procij) and
              Transaction (A).The_Task (B).Model /= Unbounded_Effects and
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
               if debug then
                  Put_line("hola1_1");
               end if;

               Pl := Calculate_PL (A, B, C);
               if debug then
                  Put_line("hola2");
               end if;
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
                        if debug then
                           Put_line("hola3");
                        end if;
                        W_Abc := W_DO_LH (A, B, C, P);
                        if debug then
                           Put_line(W_Abc'Img);
                        end if;
                        R_Abc := W_Abc -
                          FTijk (A, B, C) -
                          Time (P - 1) *
                          Transaction (A).The_Task (B).Tijown +
                          Transaction (A).The_Task (B).Oij;

                        if R_Abc > Rmax then
                           Rmax := R_Abc;
                        end if;

                        if debug then
                           --Put_line("      ");print_variation;
                           New_line;
                           Put_line("       P="&P'Img);
                           Put_line("       W_Abc="&W_Abc'Img);
                           Put_line("       R_Abc="&R_Abc'Img);
                           Put_line("       Rmax="&Rmax'Img);
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

   end Offset_Based_approx_w_pr_Task_FP;

   ---------------------------------
   -- Offset_Based_Approx_Task_FP --
   ---------------------------------

   procedure Offset_Based_approx_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : Transaction_ID_Type := I;
      B                  : Task_ID_Type        := J;
      P, P0              : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;
      Debug : Boolean := (I=1) and (J=2) and False;

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

         if debug then
            Put_line("Fijk : I,J,K = "&Img(Integer(I))&","&Img(Integer(J))&","&Img(Integer(J)));
            Put_line("Fijk : Tij = "&Img(Transaction (I).The_Task (J).Tij));
            Put_line("Fijk : Oik = "&Img(Transaction (I).The_Task (K).Oij));
            Put_line("Fijk : Jik = "&Img(Transaction (I).The_Task (K).Jij));
            Put_line("Fijk : Oij = "&Img(Transaction (I).The_Task (J).Oij));
            Put_line("Fijk : Mod = "&Img(Modulus
              (Transaction (I).The_Task (K).Oij +
                   Transaction (I).The_Task (K).Jij -
                   Transaction (I).The_Task (J).Oij,
                 Transaction (I).The_Task (J).Tij)));
            Put_line("Fijk : return = "&Img(Transaction (I).The_Task (J).Tij -
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

      ----------
      -- Wik --
      ----------

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
         Aux_Jitters :
           array (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Time;

      begin

         if Debug then
            Put_line("Wik function");
            Put_line("Wik : I="&Img(Integer(I)));
            Put_line("Wik : K="&Img(Integer(K)));
            Put_line("Wik : T="&Img(T));
            Put_line("Wik : A="&Img(Integer(A)));
            Put_line("Wik : B="&Img(Integer(B)));
         end if;

         if T = 0.0 then
            if Debug then
               Put_line("Wik : T=0 Return ="&Img(Transaction (I).The_Task (K).Cij));
            end if;
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

         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;
         for J in 1 .. Transaction (I).Ni loop
            if (Transaction (I).The_Task (J).Procij = Proc) and
              (Transaction (I).The_Task (J).Prioij >= Prio) and
              not ((I = A) and (J = B))
            then
               if Transaction (I).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  if debug then
                     Put_line("Wik : I,J ="&Img(Integer(I))&","&Img(Integer(J)));
                     Put_line("Wik : Acum prev ="&Img(Acum));
                     Put_line("Wik : Fijk ="&Img(Fijk (I, J, K)));
                     Put_line("Wik : Jij ="&Img(Transaction (I).The_Task (J).Jij));
                     Put_line("Wik : Tij ="&Img(Transaction (I).The_Task (J).Tij));
                  end if;
                  Acum :=
                    Acum +
                    (Floor
                           ((Transaction (I).The_Task (J).Jij + Fijk (I, J, K)) /
                              Transaction (I).The_Task (J).Tij) +
                         Ceiling
                           ((T - Fijk (I, J, K)) /
                              Transaction (I).The_Task (J).Tij)) *
                    Transaction (I).The_Task (J).Cij;
                  if Debug then
                     Put_line("Wik : Acum sum1 ="&Img(((Transaction (I).The_Task (J).Jij + Fijk (I, J, K)) /
                         Transaction (I).The_Task (J).Tij),10));
                     Put_line("Wik : Acum floor ="&Img(Floor
                       ((Transaction (I).The_Task (J).Jij + Fijk (I, J, K)) /
                            Transaction (I).The_Task (J).Tij),10));
                     Put_line("Wik : Acum sum2 ="&Img(((T - Fijk (I, J, K)) /
                         Transaction (I).The_Task (J).Tij)));
                     Put_line("Wik : Acum ceiling ="&Img(Ceiling
                       ((T - Fijk (I, J, K)) /
                            Transaction (I).The_Task (J).Tij)));
                     Put_line("Wik : Acum ="&Img(Acum));
                  end if;
               end if;
            end if;
         end loop;

         for J in 1 .. Transaction (I).Ni loop
            Transaction (I).The_Task (J).Jij := Aux_Jitters (J);
         end loop;

         return Acum;
      end Wik;

      ----------
      -- W_DO --
      ----------

      function W_DO
        (A    : Transaction_ID_Type;
         B, C : Task_ID_Type;
         Q    : Long_Int)
        return Time
      is
         Wc, Wcant, Wc_Ik, MaxWik : Time;
         Prio                     : Priority;
         Proc                     : Processor_ID_Type;
         Done                     : Boolean;
      begin

         if Debug then
            Put_line("W_DO function");
            Put_line("W_DO : a="&Img(Integer(a)));
            Put_line("W_DO : b="&Img(Integer(b)));
            Put_line("W_DO : c="&Img(Integer(C)));
            Put_line("W_DO : q="&Img(Q));
         end if;

         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         Wcant := Time (Q) * Transaction (A).The_Task (B).Cijown +
           Transaction (A).The_Task (B).Bij;
         loop
            if Debug then
               Put_line("W_DO : Wcant="&Img(Wcant));
            end if;
            Wc := Time (Q) * Transaction (A).The_Task (B).Cijown +
              Transaction (A).The_Task (B).Bij +
              Wik (A, C, Wcant, A, B);
            if Debug then
               Put_line("W_DO : Wc 1 ="&Img(Wc));
            end if;
            for I in 1 .. Max_Transactions loop
               exit when Transaction (I).Ni = 0;
               if I /= A then
                  MaxWik := 0.0;
                  for K in 1 .. Transaction (I).Ni loop
                     Wc_Ik := 0.0;
                     if (Transaction (I).The_Task (K).Procij = Proc) and
                       (Transaction (I).The_Task (K).Prioij >= Prio) and
                       not ((I = A) and (K = B))
                     then
                        if Transaction (I).The_Task (K).Model =
                          Unbounded_Effects
                        then
                           return Large_Time;
                        else
                           Wc_Ik := Wc_Ik + Wik (I, K, Wcant, A, B);
                           if Debug then
                              Put_line("W_DO : WC_ik="&Img(Wc_Ik));
                           end if;
                        end if;

                        if Wc_Ik > MaxWik then
                           MaxWik := Wc_Ik;
                           if Debug then
                              Put_line("W_DO : New Max Wc_ik="&Img(MaxWik));
                           end if;
                        end if;
                     end if;
                  end loop;
                  Wc := Wc + MaxWik;
                  if Debug then
                     Put_line("W_DO : WC 2 ="&Img(Wc));
                  end if;
               end if;
            end loop;
            Done  := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         if Debug then
            Put_line("W_DO : WC Final ="&Img(Wc));
         end if;
         return Wc;
      end W_DO;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset Based Unoptimized FP for Task : " &
              Transaction_ID_Type'Image (I) &
              "," &
              Task_ID_Type'Image (J));
      end if;

      Over_Analysis_Bound := False;
      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then
         Rmax := 0.0;
         for C in 1 .. Transaction (A).Ni loop
            if (Transaction (A).The_Task (C).Prioij >=
                  Transaction (A).The_Task (B).Prioij) and
              (Transaction (A).The_Task (C).Procij =
                 Transaction (A).The_Task (B).Procij) and
              Transaction (A).The_Task (B).Model /= Unbounded_Effects
            then
               P0 := -Long_Int (Floor
                                  ((Transaction (A).The_Task (B).Jij +
                                      Fijk (A, B, C)) /
                                     Transaction (A).The_Task (B).Tijown)) + 1;
               P  := P0 - 1;

               if debug then
                  New_line;
                  put_line("C = "&Img(Integer(C)));
                  put_line("P0 = "&Img(P0));
               end if;

               loop
                  P     := P + 1;
                  if debug then
                     put_line("P = "&Img(P));
                  end if;
                  W_Abc := W_DO (A, B, C, P - P0 + 1);
                  if debug then
                     put_line("W_Abc = "&Img(W_Abc));
                  end if;

                  R_Abc := -Fijk (A, B, C) -
                    Time (P - 1) *
                    Transaction (A).The_Task (B).Tijown +
                    W_Abc +
                      Transaction (A).The_Task (B).Oij;
                  if debug then
                     put_line("R_Abc = "&Img(R_Abc));
                  end if;


                  if R_Abc > Rmax then
                     Rmax := R_Abc;

                     if debug then
                        put_line("New Rmax = "&Img(Rmax));
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
                    Transaction (A).The_Task (B).Oij or
                    Transaction (A).The_Task (B).Model =
                    Unbounded_Effects;
               end loop;
            end if;
            exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
         end loop;
         -- Store the worst-case response time obtained

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;

            if debug then
               Put_line("New Rij");
               Put_line("Rij = "&Img(Rmax));
            end if;
         end if;

      end if;

      if debug then
         Put_line("Rij final = "&Img(Transaction (I).The_Task (J).Rij));
      end if;

   end Offset_Based_approx_Task_FP;


   ----------------------------------
   -- Offset_Based_Slanted_Task_FP --
   ----------------------------------

   procedure Offset_Based_Slanted_Task_FP
     (My_System                        : in out
        Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      debug : Boolean := (I=2) and (J=1) and debug_global;

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : Transaction_ID_Type := I;
      B                  : Task_ID_Type        := J;

      P, P0              : Long_Int;
      R_Abc, W_Abc, Rmax : Time;
      Ni                 : Task_ID_Type;
      Di                 : Time;
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
         return Transaction (I).The_Task (J).Tij -
           Modulus
           (Transaction (I).The_Task (K).Oij +
              Transaction (I).The_Task (K).Jij -
              Transaction (I).The_Task (J).Oij,
            Transaction (I).The_Task (J).Tij);
      end Fijk;


      ----------
      -- Wik ---
      ----------

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

         for J in 1 .. Transaction (i).Ni loop

            if (Transaction (I).The_Task (J).Procij = Proc) and
              (Transaction (I).The_Task (J).Prioij >= Prio) and
              not ((I = A) and (J = B))
            then
               acum := acum +
                 (Floor
                    ((Transaction (I).The_Task (J).Jij + Fijk (I, J, K)) /
                       Transaction (I).Ti) +
                    Ceiling
                    ((t - Fijk (I, J, K)) / Transaction (I).Ti)) *
                 Transaction (I).The_Task (J).Cij;
            end if;
         end loop;
         return acum;
      end Wik;


      ----------
      -- Iik ---
      ----------

      function Iik
        (I    : in Transaction_ID_Type;
         K    : in Task_ID_Type;
         C    : Time;
         A    : in Transaction_ID_Type;
         B    : in Task_ID_Type)
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
        (A    : in Transaction_ID_Type;
         B, C : in Task_ID_Type;
         Q    : in Long_Int)
        return Time
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

         N : Integer := 1;	--for debugging

      begin

         --time_io.Create(File,Out_File,"debug.txt");

         Proc  := Transaction (A).The_Task (B).Procij;
         Prio  := Transaction (A).The_Task (B).Prioij;
         wcant := Time (Q) * Transaction (A).The_Task (B).Cij +
           Transaction (A).The_Task (B).Bij;
         for i in 1 .. Max_Transactions loop
            Wis (i) := 0.0;
         end loop;

         loop
            Wis (A) := Iik (A, C, wcant - Wis (A), A, B);
            wc      := Time (Q) * Transaction (A).The_Task (B).Cij + Wis (A) +
              Transaction (A).The_Task (B).Bij;
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if (I /= A) then
                  maxWik := 0.0;
                  for K in 1 .. Transaction (I).Ni loop
                     if (Transaction (I).The_Task (K).Procij = Proc) and
                       (Transaction (I).The_Task (K).Prioij >= Prio) and
                       not ((I = A) and (K = B))
                     then
                        wc_ik := Iik (I, K, wcant - Wis (I), A, B);
                        if (wc_ik > maxWik) then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  Wis (I) := maxWik;
                  wc      := wc + maxWik;
               end if;
            end loop;

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

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset Based Slanted FP for Task : " &
              Transaction_ID_Type'Image (I) & "," & Task_ID_Type'Image (J));
      end if;

      Over_Analysis_Bound := False;
      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then
         Rmax := 0.0;
         for C in 1 .. Transaction (A).Ni loop
            if (Transaction (A).The_Task (C).Prioij >=
                  Transaction (A).The_Task (B).Prioij) and
              (Transaction (A).The_Task (C).Procij =
                 Transaction (A).The_Task (B).Procij) and
              Transaction (A).The_Task (B).Model /= Unbounded_Effects
            then
               P0 := -Long_Int (Floor
                                  ((Transaction (A).The_Task (B).Jij +
                                      Fijk (A, B, C)) /
                                     Transaction (A).The_Task (B).Tijown)) + 1;
               P  := P0 - 1;
               loop

                  P     := P + 1;

                  W_Abc := W_DO (A, B, C, P - P0 + 1);

                  R_Abc := -Fijk (A, B, C) -
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
                    Transaction (A).The_Task (B).Oij or
                    Transaction (A).The_Task (B).Model =
                    Unbounded_Effects;
               end loop;
            end if;
            exit when Transaction (A).The_Task (B).Model = Unbounded_Effects;
         end loop;
         -- Store the worst-case response time obtained

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

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
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Transaction        : Translation.Linear_Transaction_System renames
        My_System;
      A                  : Transaction_ID_Type := I;
      B                  : Task_ID_Type        := J;
      Ni                 : Task_ID_Type;
      Di                 : Time;

      debug : Boolean := false;

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
         return Transaction (I).The_Task (J).Tij -
           Modulus
           (Transaction (I).The_Task (K).Oij +
              Transaction (I).The_Task (K).Jij -
              Transaction (I).The_Task (J).Oij,
            Transaction (I).The_Task (J).Tij);
      end Fijk;

      ----------
      -- Wik --
      ----------

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

         Proc := Transaction (A).The_Task (B).Procij;
         Prio := Transaction (A).The_Task (B).Prioij;
         for J in 1 .. Transaction (I).Ni loop
            if (Transaction (I).The_Task (J).Procij = Proc) and
              (Transaction (I).The_Task (J).Prioij >= Prio) and
              not ((I = A) and (J = B))
            then
               if Transaction (I).The_Task (J).Model =
                 Unbounded_Effects
               then
                  return Large_Time;
               else
                  Acum :=
                    Acum +
                    (Floor
                       ((Transaction (I).The_Task (J).Jij + Fijk (I, J, K)) /
                          Transaction (I).The_Task (J).Tij) +
                       Ceiling
                       ((T - Fijk (I, J, K)) /
                          Transaction (I).The_Task (J).Tij)) *
                    Transaction (I).The_Task (J).Cij;
               end if;
            end if;
         end loop;

         for J in 1 .. Transaction (I).Ni loop
            Transaction (I).The_Task (J).Jij := Aux_Jitters (J);
         end loop;

         return Acum;
      end Wik;

      n : Transaction_ID_Type := Max_Transactions;
      m : array (1..n) of Task_ID_Type := (others => 0);
      type the_variation is array (1..n) of Task_ID_Type;
      v : the_variation;

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

               if V(I) /= 0 then
                  if (Transaction(I).The_Task(v(I)).Procij = Proc) and
                    (Transaction(I).The_Task(v(I)).Prioij >= Prio)
                  then
                     Wc := Wc + Wik (I, v(I), Wcant, A, B);
                  end if;
               end if;

            end loop;

            Done := (Wc = Wcant);
            Wcant := Wc;
            exit when Done;
         end loop;
         if False then
            Put_line("Wc ="&Wc'Img);
         end if;
         Return Wc;
      end W_DO_V;

      Rmax, Worst_Job_R : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset Based Brute Force FP for Task : " &
              Transaction_ID_Type'Image (I) &
              "," &
              Task_ID_Type'Image (J));
      end if;

      Ni                  := Transaction (A).Ni;
      Di                  := Transaction (A).The_Task (Ni).Dij;
      Rmax := 0.0;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         declare

            procedure print_variation (V : in the_variation) is
            begin
               for I in 1..n loop
                  Put(" "&V(I)'Img);
               end loop;
               --New_line;
            end print_variation;

            function is_valid_variation (V : in the_variation) return Boolean is

               procab : Processor_ID_Type := My_System(A).The_Task(B).Procij;

               --returns True if Transaction T crosses processor Proc
               function cross_processor (T : Transaction_ID_Type;
                                         Proc : Processor_ID_Type)
                                        return Boolean is
               begin
                  for J in 1..My_System(T).Ni loop
                     if My_System(T).The_Task(J).Procij = Proc then
                        return True;
                     end if;
                  end loop;
                  return False;
               end cross_processor;

            begin
               for I in 1..n loop
                  if (My_System(I).The_Task(V(I)).Procij /= Procab)
                  then
                     if cross_processor(I,procab) then
                        return false;
                     end if;
                  end if;
               end loop;
               return true;
            end is_valid_variation;

            procedure calculate_tasks_per_transaction is
            begin
               n := 0;
               for I in 1 .. Max_Transactions loop
                  exit when Transaction(I).Ni = 0;
                  n := n + 1;
                  m(I) := Transaction(I).Ni;
               end loop;
            end calculate_tasks_per_transaction;


            --Returns Max Response Time for the variation V and each P possible
            function Worst_Job_V (V : the_variation) return Time is

               Rmax_P, R_abc, W_Abc : Time;
               P, P0              : Long_Int;

            begin

               begin
                  P0 := -Long_Int (Floor
                    ((Transaction (A).The_Task (B).Jij +
                         Fijk (A, B, V(A))) /
                         Transaction (A).The_Task (B).Tijown)) + 1;

               exception
                  when CONSTRAINT_ERROR =>
                     if debug then
                        Put_Line("A="&A'Img);
                        Put_Line("B="&B'Img);
                        Put_Line("V(A)="&V(A)'Img);
                        Put_Line("Jij="&Transaction (A).The_Task (B).Jij'Img);
                        Put_line("Fijk="&Fijk(A, B, V(A))'Img);
                        Put_line("Tijown="&Transaction (A).The_Task (B).Tijown'Img);
                     end if;
                     raise;
               end;

               P  := P0 - 1;

               Rmax_P := Time(0);

               loop

                  P := P + 1;
                  W_Abc := W_DO_V(A => A,
                                  B => B,
                                  V => v,
                                  Q => P - P0 + 1);

                  --V(A) : task that starts busy period in own transaction
                  R_Abc := -Fijk (A, B, V(A)) -
                    Time (P - 1) *
                    Transaction (A).The_Task (B).Tijown +
                    W_Abc +
                    Transaction (A).The_Task (B).Oij;

                  if False then
                     Put_line("W_abc ="&W_Abc'Img);
                     Put_line("R_abc ="&R_Abc'Img);
                  end if;

                  if R_Abc > Rmax_P then
                     Rmax_P := R_Abc;
                  end if;

                  --- Determine if response time is higher than deadline
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

                  exit when R_Abc <=
                    Transaction (A).The_Task (B).Tijown +
                    Transaction (A).The_Task (B).Oij or
                    Transaction (A).The_Task (B).Model =
                    Unbounded_Effects;

               end loop;

               return Rmax_P;

            end Worst_Job_V;


            procedure process_var
              (i : in Transaction_ID_Type; v : in out the_variation) is
            begin
               for k in 1..m(i) loop

                  --if My_System(I).The_Task(k).Procij =
                  --  My_System(A).The_Task(B).Procij
                  --then
                  v(i) := k;
                  if (i = n) then

                     if Debug then
                        print_variation(V);
                        New_line;
                     end if;

                     --Use Variation
                     if is_valid_variation(v) then
                        Worst_Job_R := Worst_Job_V(v);
                        exit when Over_Analysis_Bound;
                        if Debug then
                           Put("  "&trimmed_image.Img(Float(Worst_Job_R)));
                        end if;
                        if Worst_Job_R > Rmax then
                           Rmax := Worst_Job_R;
                           if Debug then
                              Put("  Max");
                           end if;
                        end if;
                     end if;
                     if Debug then
                        New_line;
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
               new_line;
            end if;
            calculate_tasks_per_transaction;
            process_var(1,v);

         end;

         if Rmax > Transaction (A).The_Task (B).Rij then
            Changes_Made := True;
            Transaction (A).The_Task (B).Rij := Rmax;
         end if;

      end if;

   end Offset_Based_Brute_Force_Task_FP;


   -----------------------------------------
   -- Offset_Based_approx_Task_EDF_Global --
   -----------------------------------------

   procedure Offset_Based_approx_Task_EDF_Global
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is

      Transaction : Translation.Linear_Transaction_System renames My_System;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Time) return Time is
      begin
         if X < Time(0) or Y < Time(0) then
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
            Put_line("      Fijk : I,J,K = "&Img(Integer(I))&","&Img(Integer(J))&","&Img(Integer(K)));
            Put_line("      Fijk : Tij = "&Img(Transaction (I).The_Task (J).Tij));
            Put_line("      Fijk : Oik = "&Img(Transaction (I).The_Task (K).Oij));
            Put_line("      Fijk : Jik = "&Img(Transaction (I).The_Task (K).Jij));
            Put_line("      Fijk : Oij = "&Img(Transaction (I).The_Task (J).Oij));
            Put_line("      Fijk : Mod = "&Img(Modulus
              (Transaction (I).The_Task (K).Oij +
                   Transaction (I).The_Task (K).Jij -
                   Transaction (I).The_Task (J).Oij,
                 Transaction (I).The_Task (J).Tij)));
            Put_line("      Fijk : return = "&Img(Transaction (I).The_Task (J).Tij -
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
                 (floor((Transaction(I).The_Task(J).Jij+
                    Fijk(i,j,k))/Transaction(I).Ti)+Ceiling((t-Fijk(i,j,k))/
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
                           element : time) is
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
                        if I /= A or ((I=A) and (J=B) and (K=C)) then
                           p0 := Long_Int(-floor((Transaction(I).The_Task(J).Jij +
                                            Fijk(I,J,K))/Transaction(I).Ti) + Time(1));
                           pl := Long_Int(ceiling((wbusy-Fijk(I,J,K))/
                                            Transaction(I).Ti));

                           -- dij in paper is related to the offset, not the external event (that's why we substract the offset here)
                           for p in p0 .. pl loop
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
                          Fijk(A,B,C))/Transaction(A).Ti) + Time(1));
         pl := Long_Int(Ceiling((wbusy-Fijk(A,B,C))/Transaction(A).Ti));

         for p in p0..pl loop
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
            if Transaction(I).The_Task(J).Procij = proc and not((I=A) and (J=B)) then
               wt := Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                             Transaction(I).Ti) + Ceiling((T-Fijk(I,J,K))/
                                                            Transaction(I).Ti);
               if D > Time(1e10) then
                  wD := Time(1e10);
               else
                  wD:=Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                              Transaction(I).Ti) + Floor((D-Fijk(I,J,K) -
                      (Transaction(I).The_Task(J).SDij - Transaction(I).The_Task(J).Oij))/Transaction(I).Ti) +
                    Time(1);
               end if;
               acum := acum + Min0(wt,wd)*Transaction(I).The_Task(J).Cij;
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
                     if Transaction(I).The_Task(K).Procij = proc and
                     not((I=A) and (K=B)) then
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

      A : Transaction_ID_Type := I;
      B : Task_ID_Type        := J;
      p0,pl : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset EDF Global for Task : " &
              Transaction_ID_Type'Image (A) &
              "," &
              Task_ID_Type'Image (B));
      end if;


      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij then

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Global_Offsets(A,B,C);
               p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij + Fijk(A,B,C)) /
                              Transaction(A).Ti)+Time(1));
               pl := Long_Int(Ceiling ((Busy_Period(A,B,C)-Fijk(A,B,C)) /
                                Transaction(A).Ti));
               for p in p0 .. pl loop

                  Psi_Cursor := First(Psi_Set);

                  while Has_Element(Psi_Cursor) loop

                     psi := Element(Psi_Cursor);

                     if (psi <
                         (Fijk(A,B,C) + Time(p)*Transaction(A).Ti +
                            Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij) and
                           psi >=
                             (Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                                Transaction(A).The_Task(B).SDij - Transaction(A).The_Task(B).Oij))
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

                        if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or
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

   end Offset_Based_approx_Task_EDF_Global;
   
   
   ----------------------------------------
   -- Offset_Based_approx_Task_EDF_Local --
   ----------------------------------------

   procedure Offset_Based_approx_Task_EDF_Local
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
   is
      Transaction : Translation.Linear_Transaction_System renames My_System;

      -----------
      -- Min0 --
      -----------

      function Min0 (X, Y : Time) return Time is
      begin
         if X < Time(0) or Y < Time(0) then
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
         if x >= Time(0) then
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
	if Print = True then
            Put_line("Wabc");
            Put_line("I= " & Transaction_ID_Type'Image(I));
            Put_line("K= " & Task_ID_Type'Image(K));
            Put_line("A= " & Transaction_ID_Type'Image(A));
            Put_line("B= " & Task_ID_Type'Image(B));
            Put_line("T= " & Time'Image(T));
         end if;
         proc := Transaction(A).The_Task(B).Procij;
         acum := Time(0);
         for J in 1..Transaction(I).Ni loop
            if Transaction(I).The_Task(J).Procij = proc then
               acum := acum+
                 (floor((Transaction(I).The_Task(J).Jij+
                    Fijk(i,j,k))/Transaction(I).Ti)+Ceiling((t-Fijk(i,j,k))/
                      Transaction(I).Ti))*Transaction(I).The_Task(J).Cij;
               if Print = True then
                  Put_line("J= " & Task_ID_Type'Image(J));
                  Put_line("acum= " & Time'Image(acum));
                  Put_line("      Jij= " & Time'Image(Transaction(I).The_Task(J).Jij));
                  if j>1 then
                     Put_line("      Rij-1= " & Time'Image(Transaction(I).The_Task(J-1).Rij));
                     Put_line("      Dij-1= " & Time'Image(Transaction(I).The_Task(J-1).Dij));
                  end if;
                  Put_line("      Fijk= " & Time'Image(Fijk(i,j,k)));
                  Put_line("      Ti= " & Time'Image(Transaction(I).Ti));
                  Put_line("      Cij= " & Time'Image(Transaction(I).The_Task(J).Cij));

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
         if Print = True then
            Put_line("Busy_Period");
         end if;
         loop
            if Print = True then
               Put_line("loop");
            end if;
            if Print = True then
               wc := WikSinD(A,C,wcant,A,B, True);
            else
               wc := WikSinD(A,C,wcant,A,B, False);
            end if;

            if Print = True then
               Put_line("Wabc= " & Time'Image(wc));
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
                  if Print = True then
                     Put_line("W" & Transaction_ID'Image(I) & " = " & Time'Image(maxWik));
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
                           element : time) is
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
                        if I /= A or ((I=A) and (J=B) and (K=C)) then
                           p0 := Long_Int(-floor((Transaction(I).The_Task(J).Jij +
                               Fijk(I,J,K))/Transaction(I).Ti) + Time(1));
                           if False then
                              begin
                                 pl := Long_Int(ceiling((wbusy-Fijk(I,J,K))/
                                     Transaction(I).Ti));
                              exception
                                 when Constraint_Error =>
                                    Put_line("CONSTRAINT_ERROR_DETECTED");
                                    Put_line("wbusy : " & Time'Image(wbusy));
                                    Put_line("fijk : " & Time'Image(Fijk(I,J,K)));
                                    Put_line("ti : " & Time'Image(Transaction(I).Ti));
                                    Put_line("I : " & Transaction_ID_Type'Image(I));
                                    Put_line("J : " & Task_ID_Type'Image(J));
                                    Put_line("K : " & Task_ID_Type'Image(K));
                                    wbusy := Busy_Period(A,B,C,True);

                                 when Program_Error | Tasking_Error =>
                                    Put ("Error de flujo.");
                                 when others =>
                                    Put ("Otro error.");
                              end;
                           end if;

                           pl := Long_Int(ceiling((wbusy-Fijk(I,J,K))/
                               Transaction(I).Ti));

                           if p0 <= 0 then
                              psi := Transaction(I).The_Task(J).SDij;
                              Insert(Psi_Set, psi);
                           end if;

                           for p in 1 .. pl loop
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
            if Transaction(I).The_Task(J).Procij = proc and not((I=A) and (J=B)) then
               acum := acum + (Floor((Transaction(I).The_Task(J).Jij + Fijk(I,J,K))/
                   Transaction(I).Ti)) * heaviside(D - Transaction(I).The_Task(J).SDij)*
                   Transaction(I).The_Task(J).Cij;

               wt := Ceiling((T-Fijk(I,J,K))/ Transaction(I).Ti);
               if D > Time(1e10) then
                  wD := Time(1e10);
               else
                  wD:= Floor((D-Fijk(I,J,K) -
                      Transaction(I).The_Task(J).SDij)/Transaction(I).Ti) +
                    Time(1);
               end if;
               acum := acum + Min0(wt,wd)*Transaction(I).The_Task(J).Cij;
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

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wcant := Time(Q)*Transaction(A).The_Task(B).Cij;
         p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij + Fijk(A,B,C)) /
                              Transaction(A).Ti) + Time(1));
         loop

            wc := Time(Q)*Transaction(A).The_Task(B).Cij+Wik(A,C,wcant,A,B,X);

            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I/=A then
                  maxWik := Time(0);
                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc and
                     not((I=A) and (K=B)) then
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

      A : Transaction_ID_Type := I;
      B : Task_ID_Type        := J;
      p0,pl : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset EDF Local for Task : " &
              Transaction_ID_Type'Image (A) &
              "," &
              Task_ID_Type'Image (B));
      end if;


      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

          if False then
            for I in 1..Max_Transactions loop
               for J in 1.. Transaction(I).Ni loop
                  Put_line("Dij : " & Time'Image(Transaction (I).The_Task (J).Dij));
                  Put_line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
               end loop;
            end loop;
         end if;
         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij then

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Local_Offsets(A,B,C);
               p0 := Long_Int(-Floor((Transaction(A).The_Task(B).Jij + Fijk(A,B,C)) /
                                Transaction(A).Ti) + Time(1));
               pl := Long_Int(Ceiling ((Busy_Period(A,B,C,False)-Fijk(A,B,C)) /
                                Transaction(A).Ti));
               for p in p0 .. pl loop

                  if(p<=0)
                  then
                     Ax := Time(0);
                     W_abc := W_DO(A,B,C,p-p0+1,Transaction(A).The_Task(B).SDij,Transaction(A).The_Task(B).SDij);
                     R_abc := W_abc-Fijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                       Transaction(A).The_Task(B).Oij-Ax;

                     if R_abc > Rmax then
                        Rmax := R_abc;
                     end if;

                     if False then
                        if Rmax > 1.0E50 then
                           Put_line("A= " & Transaction_ID_Type'Image(A));
                           Put_line("B= " & Task_ID_Type'Image(B));
                           Put_line("C= " & Task_ID_Type'Image(C));
                           Put_line("W_abc= " & Time'Image(W_abc));
                           Put_line("Fijk= " & Time'Image(Fijk(A,B,C)));
                           Put_line("p= " & Long_Int'Image(p));
                           Put_line("Ti= " & Time'Image(Transaction(A).Ti));
                           Put_line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                           Put_line("Ax= " & Time'Image(Ax));
                        end if;
                     end if;

                     if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or
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

                        if (psi <
                            (Fijk(A,B,C) + Time(p)*Transaction(A).Ti +
                               Transaction(A).The_Task(B).SDij) and
                              psi >=
                                (Fijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                                   Transaction(A).The_Task(B).SDij))
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
                                 Put_line("A= " & Transaction_ID_Type'Image(A));
                                 Put_line("B= " & Task_ID_Type'Image(B));
                                 Put_line("C= " & Task_ID_Type'Image(C));
                                 Put_line("W_abc= " & Time'Image(W_abc));
                                 Put_line("Fijk= " & Time'Image(Fijk(A,B,C)));
                                 Put_line("p= " & Long_Int'Image(p));
                                 Put_line("Ti= " & Time'Image(Transaction(A).Ti));
                                 Put_line("Oij= " & Time'Image(Transaction(A).The_Task(B).Oij));
                                 Put_line("Ax= " & Time'Image(Ax));
                              end if;
                           end if;

                           if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or
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

   end Offset_Based_approx_Task_EDF_Local;
   
   
   ---------------------------------------------
   -- Offset_Based_approx_w_pr_Task_EDF_Local --
   ---------------------------------------------

   procedure Offset_Based_approx_w_pr_Task_EDF_Local
     (My_System                        : in out
     Translation.Linear_Transaction_System;
      I                                : Transaction_ID_Type;
      J                                : Task_ID_Type;
      Changes_Made                     : out Boolean;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last;
      Over_Analysis_Bound              : out Boolean;
      Verbose                          : in Boolean  := True)
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
         if X < Time(0) or Y < Time(0) then
            return Time(0);
         elsif X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;


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
         if X < 0 or Y < 0 then
            return 0;
         elsif  X < Y then
            return X;
         else
            return Y;
         end if;
      end Min0;


      ------------
      -- Heaviside --
      ------------

      function Heaviside
        (X : Time)
         return Long_Int
      is
      begin
         if x >= Time(0) then
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
               p := - Long_Int(Floor ((Transaction (I).The_Task (J).Jij + FPrimeijk(i,j,k))/
                                 Transaction (I).The_Task (J).Tij)) + 1;
            exception
               when Constraint_Error =>
                  Put_line("CONSTRAINT_ERROR_DETECTED");
                  Put_line("Jij : " & Time'Image(Transaction (I).The_Task (J).Jij));
                  Put_line("Rij-1 : " & Time'Image(Transaction (I).The_Task (J-1).Rij));
                  Put_line("Dij-1 : " & Time'Image(Transaction (I).The_Task (J-1).Dij));
                  Put_line("FPrime : " & Time'Image(FPrimeijk(i,j,k)));
                  Put_line("Tij : " & Time'Image(Transaction (I).The_Task (J).Tij));
                  Put_line("Ti : " & Time'Image(Transaction (I).Ti));
                  Put_line("I : " & Transaction_ID_Type'Image(I));
                  Put_line("J : " & Task_ID_Type'Image(J));
                  Put_line("K : " & Task_ID_Type'Image(K));

               when Program_Error | Tasking_Error =>
                  Put ("Error de flujo.");
               when others =>
                  Put ("Otro error.");
            end;
         end if;
         p := - Long_Int(Floor ((Transaction (I).The_Task (J).Jij + FPrimeijk(i,j,k))/
                                    Transaction (I).The_Task (J).Tij)) + 1;

         if False then
            Put_line("P0ijk");
            Put_line("FPrimeijk"& Time'Image(FPrimeijk(i,j,k)));
            Put_line("Jij"& Time'Image(Transaction (I).The_Task (J).Jij));
            Put_line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
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
            Put_line("pf_ijk");
            Put_line("FPrimeijk"& Time'Image(FPrimeijk(i,j,k)));
            Put_line("Fijk"& Time'Image(Fijk(i,j,k)));
            Put_line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
         end if;
         return - Long_Int(Floor ((FPrimeijk(i,j,k) - Fijk(i,j,k)) / Transaction (I).The_Task (J).Tij)) + 1;

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
         if SinD = True then
            if False then
               Put_line("PtDijk");
               Put_line("T"& Time'Image(T));
               Put_line("FPrimeijk"& Time'Image(FPrimeijk(i,j,k)));
               Put_line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
            end if;
            return Long_Int(Ceiling((T - FPrimeijk(i,j,k)) / Transaction (I).The_Task (J).Tij));
         else
            min1 := Long_Int(Ceiling((T - FPrimeijk(i,j,k)) / Transaction (I).The_Task (J).Tij));
            if False then
               begin
                  min2 := Long_Int(Floor((D - FPrimeijk(i,j,k) - Transaction (I).The_Task (J).SDij)/
                               Transaction (I).The_Task (J).Tij)) + 1;
               exception
                  when Constraint_Error =>
                     Put_line("CONSTRAINT_ERROR_DETECTED");
                     Put_line("D : " & Time'Image(D));
                     Put_line("FPrimeijk(i,j,k) : " & Time'Image(FPrimeijk(i,j,k)));
                     Put_line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
                     Put_line("Tij : " & Time'Image(Transaction (I).The_Task (J).Tij));

                  when Program_Error | Tasking_Error =>
                     Put ("Error de flujo.");
                  when others =>
                     Put ("Otro error.");
               end;
            end if;

            min2 := Long_Int(Floor((D - FPrimeijk(i,j,k) - Transaction (I).The_Task (J).SDij)/
                               Transaction (I).The_Task (J).Tij)) + 1;
            if False then
               Put_line("PtDijk");
               Put_line("T"& Time'Image(T));
               Put_line("D"& Time'Image(D));
               Put_line("FPrimeijk"& Time'Image(FPrimeijk(i,j,k)));
               Put_line("SDij"& Time'Image(Transaction (I).The_Task (J).SDij));
               Put_line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));
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
         type Matrix_Type is array(Long_Int range <>, Long_Int range <>) of Time;
         total : Time;
         p_min, p_max : Long_Int;
         max_section, sum : Time;
      begin

         p_min := PMin(I,K);
         p_max := PMax(I,K,T,D,SinD);

         if False and SinD = False then
            Put_line("p_min"& Long_Int'Image(p_min));
            Put_line("p_max"& Long_Int'Image(p_max));
         end if;

         declare
            conflictTable : Matrix_Type(1..Long_Int(Transaction(I).Ni), p_min..p_max):= (others => (others => Time(0)));
            p0j, pTDj, p0k : Long_Int;
            mp, hp : Boolean;
         begin

            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(K).Procij = Transaction(I).The_Task(J).Procij then
                  if False and SinD = False then
                     Put_line("J:"& Task_ID_Type'Image(J));
                  end if;
                  p0j := Pfijk(I,J,K);
                  if False and SinD = False then
                     Put_line("p0j:"& Long_Int'Image(p0j));

                     Put_line("pf_ijk");
                     Put_line("FPrimeijk"& Time'Image(FPrimeijk(i,j,k)));
                     Put_line("Fijk"& Time'Image(Fijk(i,j,k)));
                     Put_line("Oij"& Time'Image(Transaction (I).The_Task (J).Oij));
                     Put_line("Oik"& Time'Image(Transaction (I).The_Task (K).Oij));
                     Put_line("Jik"& Time'Image(Transaction (I).The_Task (K).Jij));
                     Put_line("Jij"& Time'Image(Transaction (I).The_Task (J).Jij));
                     Put_line("Ti"& Time'Image(Transaction (I).The_Task (J).Tij));

                  end if;
                  if SinD or Heaviside(D - Transaction(I).The_Task(J).SDij) = 1  then
                     p0j := P0ijk(I,J,K);
                     if False and SinD = False then
                        Put_line("p0j:"& Long_Int'Image(p0j));
                     end if;
                  end if;
                  pTDj := PtDijk(I,J,K,T,D,SinD);
                  if False and SinD = False then
                     Put_line("pTDj:"& Long_Int'Image(pTDj));
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

            if False and SinD = False then
               Put_line("Calculating");
            end if;
            for p in p_min .. p_max loop
               max_section := Time(0);
               sum := Time(0);

               if False and SinD = False then
                  Put_line("p:"& Long_Int'Image(p));
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
               if False and SinD = False then
                  Put_line("total:"& Time'Image(total));
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
                  if SinD or Heaviside(D - Transaction(I).The_Task(J).SDij) = 1 then
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



--  If the index of the job under analysis is bigger than the index of the critical instant (p=1) and
--  the job is not in the first section H, the situation is invalid, so the IncompatibleAnalysisSituationException is thrown

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
                        if (p >= Q and J > B) or (p > Q and J = B) then
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

         return Long_Int(Ceiling((Busy_Period(I,J,K) - FPrimeijk(i,j,k)) / Transaction (I).The_Task (J).Tij));

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
                           element : time) is
         begin
            if not Psi_Container.Contains(set,element) then
               Psi_Container.Insert(set,element);
            end if;
         end Insert;

      begin

         proc := Transaction(A).The_Task(B).Procij;
         wbusy := Busy_Period(A,B,C);

         if False then
            Put_line("wbusy: "& Time'Image(wbusy));
         end if;

         for I in 1 .. Max_Transactions loop
            exit when Transaction(I).Ni = 0;
            for J in 1 .. Transaction(I).Ni loop
               if Transaction(I).The_Task(J).Procij =proc then

                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc then
                        if I /= A or ((I=A) and (J=B) and (K=C)) then
                           p0 := P0ijk(I,J,K);
                           pl := PLijk(I,J,K);
                           pf := Pfijk(I,J,K);
                           if p0 < pf then
                              psi := Transaction(I).The_Task(J).SDij;
                              Insert(Psi_Set, psi);
                           end if;
                           if pf <= pl then
                              for p in pf .. pl loop
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
            Put_line("W_DO");
            Put_line("D: "& Time'Image(D));
            Put_line("X: "& Time'Image(X));
         end if;
         proc := Transaction(A).The_Task(B).Procij;
         wcant := Time(Q)*Transaction(A).The_Task(B).Cij;

         loop

            if False then
               Put_line("wcant: "& Time'Image(wcant));
            end if;
            wc := Wac(A,B,C,Q,wcant,X,False);
            if False then
               Put_line("wc A: "& Time'Image(wc));
            end if;
            for I in 1 .. Max_Transactions loop
               exit when Transaction(I).Ni = 0;
               if I/=A then
                  maxWik := Time(0);
                  for K in 1..Transaction(I).Ni loop
                     if Transaction(I).The_Task(K).Procij = proc and
                     not((I=A) and (K=B)) then
                        wc_ik := Wik(I,K,wcant,A,B,D,False);
                        if False then
                           Put_line("wc I,K("& Transaction_ID_Type'Image(I) & "-" & Task_ID_Type'Image(K) & ") :" & Time'Image(maxWik));
                        end if;
                        if wc_ik > maxWik then
                           maxWik := wc_ik;
                        end if;
                     end if;
                  end loop;
                  if False then
                     Put_line("wc I: "& Transaction_ID_Type'Image(I) & " - " & Time'Image(maxWik));
                  end if;
                  wc := wc + maxWik;
               end if;
            end loop;
            if False then
               Put_line("wc final: " & Time'Image(wc));
            end if;
            finish := (wc<=wcant);
            if wc > wcant then
               wcant := wc;
            end if;
            exit when finish;

         end loop;
         return wcant;

      end W_DO;

      A : Transaction_ID_Type := I;
      B : Task_ID_Type        := J;
      p0,pl,pf : Long_Int;
      R_abc,W_abc,Rmax,Ax : Time;
      psi : Time;

   begin

      Over_Analysis_Bound := False;
      Changes_Made := False;

      if Verbose then
         Put_line
           ("        Offset EDF Local with precedences for Task : " &
              Transaction_ID_Type'Image (A) &
              "," &
              Task_ID_Type'Image (B));
      end if;

       if False then
            for I in 1..Max_Transactions loop
               for J in 1.. Transaction(I).Ni loop
                  Put_line("SDij : " & Time'Image(Transaction (I).The_Task (J).SDij));
               end loop;
            end loop;
         end if;

      if Transaction (A).The_Task (B).Model /= Unbounded_Response and
        Transaction (A).The_Task (B).Model /= Unbounded_Effects
      then

         Rmax := Time(0);
         for C in 1..Transaction(A).Ni loop
            if Transaction(A).The_Task(B).Procij =
              Transaction(A).The_Task(C).Procij then

               if False then
                  Put_line("A: " & Transaction_ID_Type'Image(A));
                  Put_line("B: " & Task_ID_Type'Image(B));
                  Put_line("C: " & Task_ID_Type'Image(C));

               end if;

               Clear(Psi_Set);
               Build_Set_PSI_EDF_Local_Offsets_w_pr(A,B,C);
               if False then

                  Put_line("Psi builded");

               end if;
               p0 := P0ijk(A,B,C);
               pl := PLijk(A,B,C);
               pf := Pfijk(A,B,C);
               if False then
                  Put_line("p0"& Long_Int'Image(p0));
                  Put_line("pl"& Long_Int'Image(pl));
                  Put_line("pf"& Long_Int'Image(pf));
               end if;
               for p in p0 .. pl loop
                  if False then
                     Put_line("p"& Long_Int'Image(p));
                  end if;
                  --if((p<0)or((abs(FPrimeijk(A,B,C)-Fijk(A,B,C))<Epsilon)and(p=0)))
                  if(p < pf)
                  then
                     if False then
                        Put_line("Set0");
                     end if;
                     Ax := Time(0);
                     W_abc := W_DO(A,B,C,p-p0+1,Transaction(A).The_Task(B).SDij, Transaction(A).The_Task(B).SDij);
                     if False then
                        Put_line("W_abc: "& Time'Image(W_abc));
                     end if;
                     R_abc := W_abc-FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                       Transaction(A).The_Task(B).Oij-Ax;
                     if False then
                        Put_line("R_abc: "& Time'Image(R_abc));
                     end if;
                     if R_abc > Rmax then
                        Rmax := R_abc;
                     end if;

                     if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or
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
                        Put_line("Set1");
                     end if;
                     Psi_Cursor := First(Psi_Set);

                     while Has_Element(Psi_Cursor) loop

                        psi := Element(Psi_Cursor);
                        if False then
                           Put_line("psi: "& Time'Image(psi));
                        end if;
                        if (psi <
                            (FPrimeijk(A,B,C) + Time(p)*Transaction(A).Ti +
                               Transaction(A).The_Task(B).SDij) and
                              psi >=
                                (FPrimeijk(A,B,C) + Time(p-1)*Transaction(A).Ti +
                                   Transaction(A).The_Task(B).SDij))
                        then

                           Ax := psi-FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti -
                             Transaction(A).The_Task(B).SDij;
                           if False then
                              Put_line("Ax: "& Time'Image(Ax));
                           end if;
                           W_abc := W_DO(A,B,C,p-p0+1,psi, FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti - Transaction(A).The_Task(B).SDij);
                           if False then
                              Put_line("W_abc: "& Time'Image(W_abc));
                           end if;
                           R_abc := W_abc-FPrimeijk(A,B,C)-Time(p-1)*Transaction(A).Ti+
                             Transaction(A).The_Task(B).Oij-Ax;
                           if False then
                              Put_line("R_abc: "& Time'Image(R_abc));
                           end if;
                           if R_abc > Rmax then
                              Rmax := R_abc;
                           end if;

                           if ((Stop_Factor_When_Not_Schedulable /= Positive'Last) or
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

   end Offset_Based_approx_W_pr_Task_EDF_Local;
   
   --------------------------------------------
   -- Initialize_Processor_Analysis_Accesses --
   --------------------------------------------

   procedure Initialize_Processor_Analysis_Accesses
     (The_System         : Mast.Systems.System;
      My_System          : Translation.Linear_Transaction_System;
      The_Accesses_Array : in out Processor_Analysis_Accesses;
      Verbose            : Boolean)
   is

      isLocal       : Boolean                     :=
        The_System.The_Processor_Analysis_Tool.isLocal;
      User_Analysis : Mast.General_Analysis_Tools :=
        The_System.The_Processor_Analysis_Tool.The_General_Analysis;
      Proc          : Processor_ID_Type;
      I             : Transaction_ID_Type;
      Extra         : Transaction_ID_Type;
   begin
      if Verbose then
         Put_Line ("Initializing array of procedure accesses");
      end if;

      I := 1;
      while My_System (I).Ni /= 0 loop

         Extra := 0;
         for J in Transaction_ID_Type range (I + 1) .. Max_Transactions loop
            exit when My_System (J).Transaction_Id /=
              My_System (I).Transaction_Id;
            Extra := Extra + 1;
         end loop;

         for K in 0 .. Extra loop
            for J in 1 .. My_System (I + K).Ni loop
               Proc := My_System (I + K).The_Task (J).Procij;
               if The_Accesses_Array (Proc) = null then

                  if Verbose and Debug_Global Then
                     Put_Line
                       ("Proc " &
                          Processor_ID'Image (Proc) &
                          " : " &
                          General_Analysis_Tools'Image (User_Analysis) &
                          ", isLocalEDF=" &
                          Boolean'Image (isLocal));
                  end if;

                  if My_System (I + K).The_Task (J).Schedij = FP then

                     case User_Analysis is
                        when Holistic =>
                           The_Accesses_Array (Proc) :=
                             Holistic_Task_FP'Access;

                        when Offset_Based_approx_w_pr =>
                           The_Accesses_Array (Proc) :=
                             Offset_Based_approx_w_pr_Task_FP'Access;
                        when Offset_Based_approx =>
                           The_Accesses_Array (Proc) :=
                             Offset_Based_approx_Task_FP'Access;
                        when Offset_Based_slanted =>
                           The_Accesses_Array (Proc) :=
                             Offset_Based_Slanted_Task_FP'Access;
                        when Offset_Based_brute_force =>
                           The_Accesses_Array (Proc) :=
                             Offset_Based_Brute_Force_Task_FP'Access;
                     end case;

                  else
                     if isLocal then
                        case User_Analysis is
                           when Holistic =>
                              The_Accesses_Array (Proc) :=
                                Holistic_Task_EDF_Local'Access;
                           when Offset_Based_approx =>
                              The_Accesses_Array (Proc) :=
                                Offset_Based_approx_Task_EDF_Local'Access;
                           when Offset_Based_approx_w_pr =>
                              The_Accesses_Array (Proc) :=
                                Offset_Based_approx_w_pr_Task_EDF_Local'Access;
                           when others =>
                              The_Accesses_Array (Proc) :=
                                Holistic_Task_EDF_Local'Access;
                        end case;
                     else
                        case User_Analysis is
                           when Holistic =>
                              The_Accesses_Array (Proc) :=
                                Holistic_Task_EDF_Global'Access;
                           when Offset_Based_approx =>
                              The_Accesses_Array (Proc) :=
                                Offset_Based_approx_Task_EDF_Global'Access;
                           when others =>
                              The_Accesses_Array (Proc) :=
                                Holistic_Task_EDF_Global'Access;
                        end case;
                     end if;
                  end if;

               end if;

               --I'll comment this for now until I understand it
               --It's apparently tu support interruptions in EDF

               --                 else
               --
               --                    if The_Accesses_Array (Proc) = Holistic_Task_FP'Access or
               --                      The_Accesses_Array (Proc) = Offset_Based_Task_FP'Access or
               --                      The_Accesses_Array (Proc) =
               --                      Offset_Based_Unoptimized_Task_FP'Access then
               --
               --                       if My_System (I + K).The_Task (J).Schedij = EDF_Local or
               --                         My_System (I + K).The_Task (J).Schedij = EDF_Global then
               --
               --                          if isLocal then
               --
               --                             case User_Analysis is
               --                             when Holistic =>
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Local'Access;
               --                             when Offset_Based =>
               --                                --Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Local'Access;
               --                             when Offset_Based_Unoptimized =>
               --                                --Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Local'Access;
               --                             when Offset_Based_Brute_Force =>
               --                                --Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Local'Access;
               --                             end case;
               --
               --                          else
               --                             case User_Analysis is
               --                             when Holistic =>
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Global'Access;
               --                             when Offset_Based =>
               --                                -- Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Global'Access;
               --                             when Offset_Based_Unoptimized =>
               --                                -- Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Global'Access;
               --                             when Offset_Based_Brute_Force =>
               --                                --Not yet implemented
               --                                The_Accesses_Array (Proc) :=
               --                                  Holistic_Task_EDF_Global'Access;
               --                             end case;
               --                          end if;
               --
               --                       end if;

               --                    elsif
               --                      The_Accesses_Array (Proc) =
               --                       Holistic_Task_EDF_Local'Access or
               --                      The_Accesses_Array (Proc) =
               --                       Holistic_Task_EDF_Global'Access then
               --
               --                       if My_System (I + K).The_Task (J).Schedij = FP then
               --
               --                          if My_System (I + K).The_Task (J).Prioij >=
               --                            Mast.Processing_Resources.Processor.
               --                              Min_Interrupt_Priority
               --                                (Processing_Resources.Processor.
               --                                       Regular_Processor'Class
               --                                   (My_System (I + K).
               --                                      The_Task (J).Pav.P_R_Ref.all))
               --                            and My_System (I + K).The_Task (J).Prioij <=
               --                            Mast.Processing_Resources.Processor.
               --                              Max_Interrupt_Priority
               --                                (Processing_Resources.Processor.
               --                                       Regular_Processor'Class
               --                                   (My_System (I + K).
               --                                      The_Task (J).Pav.P_R_Ref.all))
               --                          then
               --
               --                             if isLocal then
               --
               --                                case User_Analysis is
               --                                when Holistic =>
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Local'Access;
               --                                when Offset_Based =>
               --                                   --Not yet implemented
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Local'Access;
               --                                when Offset_Based_Unoptimized =>
               --                                   --Not yet implemented
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Local'Access;
               --                                   when Offset_Based_Brute_Force =>
               --                                      --Not yet implemented
               --                                      The_Accesses_Array (Proc) :=
               --                                        Holistic_Task_EDF_Local'Access;
               --                                end case;
               --
               --                             else
               --                                case User_Analysis is
               --                                when Holistic =>
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Global'Access;
               --                                when Offset_Based =>
               --                                   -- Not yet implemented
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Global'Access;
               --                                when Offset_Based_Unoptimized =>
               --                                   -- Not yet implemented
               --                                   The_Accesses_Array (Proc) :=
               --                                     Holistic_Task_EDF_Global'Access;
               --                                   when Offset_Based_Brute_Force =>
               --                                      --Not yet implemented
               --                                      The_Accesses_Array (Proc) :=
               --                                        Holistic_Task_EDF_Global'Access;
               --                                end case;
               --                             end if;
               --
               --                          else
               --                             Put_line("WARNING : Step priority not in valid interruption range");
               --                          end if;
               --
               --
               --                       end if;
               --
               --                    end if;

               --               end if;

            end loop;
         end loop;
         exit when (I + Extra + 1) not  in Transaction_ID_Type;
         I := I + Extra + 1;
      end loop;
   end Initialize_Processor_Analysis_Accesses;

   function img (Number : Long_Int) return String is
   begin
      return Ada.Strings.Fixed.Trim(Number'Img,Ada.Strings.Left);
   end img;


end Mast.Linear_Task_Analysis_Tools;
