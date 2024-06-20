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
--          Maria Cue                                                --
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
--                                                                   --
-- This package contains types and operations that allow conversion  --
-- of a full MAST model into a simplified MAST model that is used    --
-- for the analysis.                                                 --
-- The simplifications made are:                                     --
--   - All the overheads are converted to the equivalent modelling   --
--     elements (such as additional WCET, new tasks or transactions  --
--   - All the analysis data is stored in tables that handled by the --
--     analysis tools more efficiently than if they were using the   --
--     list-based full MAST model                                    --
--   - Information that is needed for the scheduling parameters      --
--     assignment tools is also produced in the form of tables       --
--                                                                   --
-- The main table structure is an array of transactions; each        --
-- transaction contains an array of tasks, with each task having its --
-- own set of data                                                   --
--                                                                   --
-- Some transactions in the original model are split into several    --
-- transactions to manage special event handlers (such as            --
-- multicast) and some particular behaviours of schediling           --
-- policies such as the sporadic server                              --
--                                                                   --
-- The package receives as generic parameters the maximum number of  --
-- processors, of transactions and of tasks, and the associated      --
-- indexing types. Note that these maximum numbers correspond to the --
-- final simplified MAST model, not the original model. For          --
-- instance, if a transaction is split into several transactions,    --
-- all the new transactions have to be included in the maximum       --
-- number
-----------------------------------------------------------------------

with MAST.Systems,Mast.Graphs,Mast.Events,Mast.Scheduling_Parameters,
  Mast.Synchronization_Parameters, Mast.Linear_Analysis_Tools, Mast.Tools,
  Mast.Processing_Resources, Mast.Scheduling_Policies;

generic
   type Processor_ID_Type is range <>;
   type Transaction_ID_Type is range <>;
   type Task_ID_Type is range <>;
   Max_Processors : Processor_ID_Type;
   Max_Transactions : Transaction_ID_Type;
   Max_Tasks_Per_Transaction : Task_ID_Type;

package Mast.Linear_Translation is

   Max_OverDeadline : constant Natural := 100;
   -- This constants sets a finalization criterium for the analysis; when
   -- the response time of a transaction exceeds the associated deadline
   -- multiplied by the constant, the analysis is stopped.

   Analysis_Bound : Time;
   -- This variable sets another finalization criterium for the analysis;
   -- when the response times obtained so far exceed this value
   -- the analisys is stopped

   Max_Busy_Period : Time;
   -- This variable sets another finalization criterium for the analysis;
   -- when the length of the busy period obtained so far exceed this value
   -- the analisys is stopped


   --------------------History of recent changes--------------
   -- June 2014. To add support for multipath analysis, the
   -- following changes are made:
   --  - the type Transaction_Input_Type has the values:
   --      +External: the event trigering the transaction is external
   --      +Internal: the event triggering the transaction comes from
   --                 the finalization of a previous transaction,
   --                 which was assumed to be
   --                 the previous one in the transactions array
   --                 Now, the previous transaction is not necessarily
   --                 the previous one, but is marked in the
   --                 predecessor_trans_ref field, which is a reference to
   --                 an array of indexes into the transactions array
   --      +Join : This is a new value for the Transaction_Input_Type
   --              This value indicates that the transaction is activated
   --              from a join operation combining the output events of several
   --              other transactions. All the events from these transactions
   --              have to arrive, for the current transaction to be triggered
   --              These originating transactions are identified via the
   --              predecessor_trans_ref field, which is a reference to
   --              an array of indexes into the transactions array
   --
   --  - the predecessor_trans_ref field is added, as explained above;
   --    it is null for external transactions 
   --
   --  - the succcessor_trans_ref field is added: it is a reference to
   --    an array of indexes into the transactions array, indicating which
   --    transactions in the simplified model are the successors in the
   --    full model; it is null for regular transactions, it has one element
   --    transactions with independent sections and those entering into a join
   --    handler, and multiple elements for a transaction leading to a fork
   --    handler
   ---------------------------------------------------------------------
   
   type Transaction_Id_Array is array(Positive range <>) of Transaction_Id_Type;
   type Transaction_Id_Array_Ref is access all Transaction_Id_Array;
   
   type Kind_Of_Processor is (None, Processor, Network);
   -- Stores the kind of processing resource of the
   -- task in the transaction:
   --   Processor : if the processing resource is a processor
   --   Network :  if the processing resource is a network
   --   None :  if there is no processing resource

   type Event_Kinds is (Periodic,Sporadic,Bursty,Unbounded);
   -- Reflects the model for analysis, only
   -- Values are:
   --    Periodic : default analysis
   --    Sporadic : special treatment in offset-based methods
   --    Bursty : treated as sporadic
   --    Unbounded: self analysis is not relevant

   type Model_Levels is (Regular, Separate_Analysis,
                         Unbounded_Response, Unbounded_Effects);
   -- Regular:           Own analysis model is the same as model for
   --                    analysis of others
   -- Separate_Analysis: The own analysis model is different than the model
   --                    for the analysis of other tasks. (Cij,Tij) holds the
   --                    values for the other's analysis, while
   --                    (Cijown, Tijown) hold the values for the task's
   --                    own analysis.
   -- Unbounded_Response:Own analysis leads to unbounded response time
   -- Unbounded_Effects: effects on lower priority threads are unbounded

   type Transaction_Input_Type is (External, Internal, Join);
   --  Represents the type of the input event of the transaction:
   --      External : external event
   --      Internal : initial event coming from another transaction
   --                 (this used to be the one placed immediately before
   --                  in the transactions array)
   --                 (NEW) Now, the previous transaction is not necessarily
   --                 the previous one, but is marked in the
   --                 predecessor_trans_ref field, which is a reference to an
   --                 array of transaction indexes with only one element.
   --                 The predecessor transaction is one that in the full
   --                 model finishes with an event handler
   --                 of the type activity (check).
   --      Join :  (NEW) This is a new value for the Transaction_Input_Type
   --              This value indicates that the transaction is activated
   --              from a join operation combining the output events of several
   --              other transactions. All the events from these transactions
   --              have to arrive for the current transaction to be triggered
   --              These originating transactions are identified via the array
   --              of transaction indexes referenced by predecessor_trans_ref


   type Virtual_Priority is range 1..2**31-2;
   -- We do not include the value 2**31-1 to force range checking

   Max_Virtual_Priority : constant Virtual_Priority :=
     Virtual_Priority(10*Priority'Last);

   type Sched_Type is (FP, EDF_Local, EDF_Global);
   -- kind of scheduler used for this task
   
   type Priority_Assignment_Vars is record
      Hard_Prio : Boolean:=True;
      -- If TRUE, the object has an unchangeable priority
      S_P_Ref : Scheduling_Parameters.Sched_Parameters_Ref := null;
      -- Added to handle preemption levels
      Synch_P_Ref : Synchronization_Parameters.Synch_Parameters_Ref := null;
      -- pointer to the synchronization parameters that
      --   contains the preemption levels
      P_R_Ref : Processing_Resources.Processing_Resource_Ref :=null;
      S_Policy_Ref : Scheduling_Policies.Fixed_Priority_Policy_Ref:=null;
      Overridden_Ref : Scheduling_Parameters.Overridden_Sched_Parameters_Ref
        := null;
      Calculate_Factor : Boolean;  -- Mark to calculate factor
      Factor : Time;
      S : Time;        -- Slack
      Excess : Time;   -- Excess
      D_I : Time;      -- Initial deadline
      D_0 : Time;      -- Actual deadline
      D_1 : Time;      -- Deadline before
      Optimum_Prio : Priority;
      Virtual_Prio : Virtual_Priority;
      Preassigned_Prio : Priority;
      Preassigned  : Boolean:=False;
      Is_Polling : Boolean:=False;
      -- if True, this task is modelling a polling overhead; its priority
      --    is not assigned by the priority assignment tools
   end record;
   -- The previous type contains data associated to a task, that is
   --  needed for the assigmnent of scheduling parameters


   type Task_Data is record
      Cijown,
      Cbijown    : Time;          -- WCET and BCET for own task's analysis
      Cij,
      Cbij       : Time;          -- WCET and BCET for analysis of other tasks
      Tijown     : Time;          -- Period for own analysis
      Tij        : Time;          -- Period for analysis of other tasks
      Bij        : Time;          -- Blocking time
      Dij        : Time;          -- Global Deadline (timing requirement)
                                  --   referring to the external event
      SDij       : Time;          -- Scheduling deadline (for EDF tasks)
      Schedij    : Sched_Type;    -- FP, EDF_Local or EDF_Global scheduling
      Oij        : Time;          -- Activation phase
      Jij        : Time;          -- Calculated Jitter
      Jinit      : Time;          -- Initial Jitter
      Sched_Delay: Time;          -- Scheduling Delay
                                  --   Effect added at response time translation
      Oijmin     : Time;          -- Minimum (static) offset
      Oijmax     : Time;          -- Maximum offset
                                  --   These offsets represent a minimum and
                                  --   maximum amount of offset to be used for
                                  --   the task. The actual offset will be the
                                  --   maximum of the inherited offset and
                                  --   this field. It is also used to account
                                  --   for the delay of rate divisors
      Delayijmin : Time;          -- Minimum delay relative to previous task
      Delayijmax : Time;          -- Maximum delay relative to previous task
                                  --   These delays represent an amount to be
                                  --   added to the offset inherited by task ij
                                  --   from the previous task
      Model      : Model_Levels;  -- Modelling level for this task
      Jitter_Avoidance : Boolean; -- Scheduler avoids jitter effects on lower
                                  --   priority tasks
      Uses_Shared_Resources : Boolean; -- the task uses shared resources
                                       --   this is used to calculate remote
                                       --   blockings, not in the analysis
                                       --   itself
      Rij,Rbij   : Time;          -- Worst and Best case response times
      Prioij     : Priority;      -- Priority
      Procij     : Processor_ID_Type; -- Processor
      Resij      : MAST.Graphs.Link_Ref; -- Link to which
                                         -- results will be attached
                                         -- May 2014: if Resij=0
                                         -- this means that no results
                                         -- are calculated; this occurs in
                                         -- replicated tasks before a 
                                         -- rate divisor
      Max_Of_Best_Cases : Boolean -- indicates whether the best case
	:=False;                  -- response times are calculated as the
                                  -- maximum of several best cases (as
                                  -- corresponds to join handlers) 
                                  -- or as the minimum, which is the default
      Pav      : Priority_Assignment_Vars; -- Data for assignment of sched
                                           --  parameters
   end record;
   -- This record contains all the data associated with an individual task in
   --   the simplified MAST model

   type The_Transaction_Tasks is array
     (Task_ID_Type range 1..Max_Tasks_Per_Transaction) of Task_Data;
   -- Array of task data to be stored for each individual transaction in
   --  the simplified MAST model

   type Transaction_Data is record
      Transaction_Id : Transaction_ID_Type; -- Id of this transaction
      Ti : Time;              -- Transaction period; in general the analysis
                              --   tools should use the individual tij of each
                              --   task
      Ni : Task_ID_Type:=0;   -- Number of tasks in transaction
                              --   if zero, there are no more
                              --   transactions in the transactions array
      Evi : Events.Event_Ref; -- Pointer to external event
      Kind_Of_Event : Event_Kinds;
      The_Task : The_Transaction_Tasks;  -- Tasks of the transaction
      Trans_Input_Type : Transaction_Input_Type:=External;
      -- The way in which the transaction is triggered (From an external event,
      -- from an internal event generated by anoher transaction, or from
      -- a join operation of several other transactions
      Predecessor_Trans_Ref : Transaction_Id_Array_Ref:=null;
      -- the set of indexes into the transactions array indicating 
      -- the previous transactions:
      --    - null for external transactions
      --    - reference to a single-element array for internal transactions
      --    - reference to a multiple-element array for join-type transactions
      Successor_Trans_Ref : Transaction_Id_Array_Ref:=null;
      -- the set of indexes into the transactions array indicating 
      -- the following transactions:
      --    - null for transactions finishing at the last task
      --    - reference to a single-element transactions immediately followed
      --      by a single transaction
      --    - reference to a multiple-element array for transactions followed
      --      by a fork event handler
   end record;
   -- This is the data stored for each transaction in the simplified
   --  MAST model

   type Linear_Transaction_System is array
     (Transaction_ID_Type range 1..Max_Transactions)
     of Transaction_Data;
   -- This is the array of transactions in the simplified MAST model
   --
   --   In the case of a transaction that has a task that should
   --   be treated as independent, i.e., that does not ihnerit jitter or offset
   --   from the previous task, the original transition is split into two
   --   transactions, with the new transaction having the same Transaction Id,
   --   and having the parent transaction referenced as a predecessor.
   --
   --   When a transaction is split, subsequent parts have a
   --   Trans_Input_Type equal to "Internal", meaning that its input
   --   event comes from another transaction, which is referenced
   --   as a predecessor


   type Analysis_Data is record
      Analysis_Ref : Mast.Tools.Worst_Case_Analysis_Tool:=null;
   end record;

   type The_Analysis_Data is array
     (Processor_ID_Type range 1..Max_Processors) of Analysis_Data;
   -- This array contains the schedulability analysis tool that
   --  should be used for each processor


    procedure Translate_Linear_System
     (The_System : in MAST.Systems.System;
      Transaction : out Linear_Transaction_System;
      Verbose : in Boolean:=False);
    -- Converts The_System into the simplified MAST model stored in Transaction

   procedure Clear_Time_Results
     (Trans      : in out Linear_Transaction_System;
      The_System : in out MAST.Systems.System);

   procedure Translate_Linear_Analysis_Results
     (Trans      : in out Linear_Transaction_System;
      The_System : in out MAST.Systems.System);

   procedure Translate_Linear_System_With_Results
     (The_System : in MAST.Systems.System;
      Transaction : out Linear_Transaction_System;
      Verbose : in Boolean:=False);

   procedure Translate_Priorities
     (Transaction : in Linear_Transaction_System;
      The_System : in out MAST.Systems.System);

   procedure Translate_Deadlines
     (Transaction : in Linear_Transaction_System;
      The_System : in out MAST.Systems.System);

   procedure Translate_Deadlines_and_Priorities
     (Transaction : in Linear_Transaction_System;
      The_System : in out MAST.Systems.System);

   procedure Set_Response_Times_To_Large_Time 
     (Transaction : in out Linear_Transaction_System);
     
   procedure Show_Debug_Deadlines
     (Transaction : in Linear_Transaction_System);

   procedure Show_response
     (Transaction : in Linear_Transaction_System);

   function Get_Processor_Number
     (The_System : Systems.System;
      A_Proc_Ref : Processing_Resources.Processing_Resource_Ref)
     return Processor_Id_Type;

   function Get_Processor_Name
     (The_System : Systems.System;
      Proc_Number : Processor_Id_Type)
     return String;

   procedure Show_Linear_Translation
     (Transaction : in Linear_Transaction_System);

   procedure Show_Debug_Results
     (Transaction : in Linear_Transaction_System);

   procedure Show_Scheduling_Parameters
     (Transaction : in Linear_Transaction_System);


end Mast.Linear_Translation;
