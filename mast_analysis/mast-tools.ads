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
--          Maria Cue              cuem@unican.es                    --
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

with MAST.Systems,MAST.Transactions,
  MAST.Processing_Resources, MAST.Operations;

package MAST.Tools is

   ----------------------------------------
   -- Worst Case Response Analysis tools --
   ----------------------------------------

   type Worst_Case_Analysis_Tool is access procedure
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);

   -------------
   -- Default --
   -------------

   procedure Default_RTA_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- Uses the default technique for the system:
   --  - if system is Monoprocessor_Only and Simple_Transactions_Only then
   --        - Classic_RM_Analysis for fixed priorities
   --        - EDF_Monoprocessor_Analysis for EDF
   --  - else
   --      Offset_Based_Optimized_Analysis


   ----------------------
   -- Single processor --
   ----------------------

   procedure Classic_RM_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- restricted to Monoprocessor_Only, Simple_Transactions_Only,
   -- Fixed_Priorities_Only, No_Permanent_Overridden_Priorities,
   -- No_Hard_Local_Deadlines,


   procedure Varying_Priorities_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- restricted to Monoprocessor_Only, Linear_Transactions_Only,
   -- Fixed_Priorities_Only, No_Permanent_FP_Inside_Composite_Operations,
   -- No_Intermediate_Timing_Requirements

   procedure EDF_Monoprocessor_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- restricted to Monoprocessor_Only, Simple_Transactions_Only,
   -- EDF_Only, SRP_Only, Referenced_Events_Are_External_Only,
   -- No_Hard_Local_Deadlines

   procedure EDF_Within_Priorities_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- restricted to Monoprocessor_Only, Simple_Transactions_Only and
   -- EDF_Within_Priorities_Only, Referenced_Events_Are_External_Only,
   -- No_Hard_Local_Deadlines


   -----------------
   -- Distributed --
   -----------------

   procedure Distributed_Mixed_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- Analysis for heterogeneous distributed systems
   -- restricted to Linear_Plus_Transactions_Only, FP_Or_EDF_Only
   -- Referenced_Events_Are_External_Only, No_Hard_Local_Deadlines, and
   -- No_Rate_Divisors_In_Multipath_Transactions,
   -- no shared resources if EDF_Only


   procedure Multipath_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   -- restricted to Regular_Transactions_Only and
   -- FP_Or_EDF_Only


   procedure Offset_Based_Optimized_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last);
   --MAST 1.3.8.0 version for now, until it's fixed for mixed systems


   -------------
   -- Slacks --
   -------------

   procedure Calculate_Transaction_Slack
     (Trans_Ref : in MAST.Transactions.Transaction_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- calculates the relative amount that the execution times of the
   -- actions of the transaction referenced by Trans_Ref may grow
   -- (or may need decreasing) for the system to continue
   -- being (or become) schedulable
   -- Ci* = Ci * (1+The_Slack/100) for all actions in the transaction

   procedure Calculate_Transaction_Slacks
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- Invokes Calculate_Transaction_Slack for all transactions in the system

   procedure Calculate_Processing_Resource_Slack
     (Res_Ref : in MAST.Processing_Resources.Processing_Resource_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- calculates the relative amount that the speed of the processing
   -- resource referenced by Res_Ref may be decreased
   -- (or may need inreasing) for the system to continue
   -- being (or become) schedulable
   -- Speed* = Speed * (1-The_Slack/10dw0) for the processing resource

   procedure Calculate_Processing_Resource_Slacks
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- Invokes Calculate_Processing_Resource_Slack for all processing
   -- resources in the system

   procedure Calculate_Operation_Slack
     (Op_Ref : in MAST.Operations.Operation_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- calculates the relative amount that the execution time of the
   -- operation referenced by Op_Ref may grow
   -- (or may need decreasing) for the system to continue
   -- being (or become) schedulable
   -- Ci* = Ci * (1+The_Slack/100) for that operation

  procedure Calculate_System_Slack
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=False);
   -- calculates the relative amount that the execution times of the
   -- actions of all the transactions in the system may grow
   -- (or may need decreasing) for the system to continue being
   -- (or become) schedulable
   -- Ci* = Ci * (1+The_Slack/100) for all actions in the system

   --------------------------------------------
   -- Scheduling Parameters Assignment tools --
   --------------------------------------------

   type Priority_Assignment_Tool is access procedure
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   procedure Monoprocessor_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   procedure Linear_HOSPA
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   procedure Linear_Simulated_Annealing_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   procedure Multipath_HOPA
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   procedure Multipath_Simulated_Annealing_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True);

   ------------------------------------
   -- Shared Resource Analysis Tools --
   ------------------------------------

   procedure Calculate_Ceilings_And_Levels
     (The_System : in out Mast.Systems.System;
      Verbose : in Boolean:=True);
   -- restrictions :
   --  PCP_SRP_Or_Priority_Inheritance_Only
   --  consistent shared resource usage
   --  all ceilings are consistent
   --  consistent shared resource usage for segments (i.e., all task
   --       segments unlock their locked resources)

   procedure Calculate_Blocking_Times
     (The_System : in out Mast.Systems.System;
      Verbose : in Boolean:=True);
   -- restrictions :
   --  PCP_SRP_Or_Priority_Inheritance_Only
   --  consistent shared resource usage
   --  all ceilings are consistent
   --  consistent shared resource usage for segments (i.e., all task
   --       segments unlock their locked resources)

   ------------------------
   -- Miscelaneous Tools --
   ------------------------

   procedure Utilization_Test
     (The_System : MAST.Systems.System;
      Suceeds : out Boolean;
      Verbose : in Boolean:=True);

   procedure Check_Shared_Resources_Total_Ordering
     (The_System : MAST.Systems.System;
      Ordered : out Boolean;
      Verbose : in Boolean:=True);

   procedure Check_Transaction_Schedulability
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Is_Schedulable : out Boolean;
      Verbose : in Boolean:=True);

   procedure Check_System_Schedulability
     (The_System : MAST.Systems.System;
      Is_Schedulable : out Boolean;
      Verbose : in Boolean:=True);

   function Calculate_Processing_Resource_Utilization
     (The_System : MAST.Systems.System;
      The_Pr : Mast.Processing_Resources.Processing_Resource_Ref;
      Verbose : Boolean := True) return Float;

   function Calculate_System_Utilization
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True) return Float;

   procedure Show_Debug_Results
     (The_System : MAST.Systems.System;
      File_Name : String);


end MAST.Tools;
