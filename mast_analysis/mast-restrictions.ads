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

with MAST.Systems,MAST.Transactions;

package MAST.Restrictions is

   ------------------------------
   -- System-Wide Restrictions --
   ------------------------------

   function Monoprocessor_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True) return Boolean;
   -- only one processing resource: a Fixed_Priority_CPU

   function Max_Processor_Utilization
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True;
      Calculate_Processing_Resource_Utilization : Boolean:=False)
     return Float;
   -- returns the maximum utilization level of all processing resources

   function Feasible_Processing_Load
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True;
      Calculate_Processing_Resource_Utilization : Boolean:=False)
     return Boolean;
   -- checks that Max_Processor_Utilization is under 100%

   function Fixed_Priority_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- All Scheduling servers have Fixed Priority parameters,
   -- all overriden parameters in operations are Fixed Priority,
   -- and all priorities are within the appropriate ranges for their
   -- processing resources. There are no secondary schedulers.

   function EDF_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- All Scheduling Servers have EDF or Interrupt Parameters,
   -- there are no overriden parameters in operations, and all interrupt
   -- priorities are within the appropriate ranges for their processing
   -- resources. There are no secondary schedulers.

   function EDF_Within_Priorities_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- The primary schedulers have a fixed priority policy.
   -- All secondary schedulers have an EDF policy and are scheduled
   -- under a scheduling server that is directy attached to a
   -- primary server.
   -- All operations with overridden priorities are executed by fixed
   -- priority scheduling servers
   -- All priorities are in range

   function Flat_FP_Or_EDF_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Each node is Fixed_Priorities_Only or EDF_Only
   -- and there are no overriden priorities in operations

   function FP_Or_EDF_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Each node is Fixed_Priorities_Only or EDF_Only

   function PCP_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- All Resources are PCP

   function PCP_Or_Priority_Inheritance_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- all resources are PCP or Priority Inheritance resources

   function PCP_SRP_Or_Priority_Inheritance_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- all resources are PCP, SRP, or Priority Inheritance resources
   -- all SRP resources are used by EDF tasks
   -- all Priority Inheritance resources are used by Fp tasks

   function SRP_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- All Resources are SRP

   function No_Shared_Resources
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Check if the Shared Resources List is empty or not

   function Referenced_Events_Are_External_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- No internal events are referenced

   function No_Intermediate_Timing_Requirements
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- No Timing requirements are attached to intermediate event channels,
   -- i.e., all timing requirements are attached to output events

   function No_Permanent_Overridden_Priorities
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that there is no operation with permanent overridden priorities

   function No_Permanent_FP_Inside_Composite_Operations
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that there is no composite operation that contains
   -- other operations with permanent overridden priorities

   function Non_Null_Periods
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that there is are no transaction periods equal to zero

   function No_Hard_Local_Deadlines
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks if there are no hard local deadlines in the transactions
   -- of the system

   -----------------------------------
   -- Transaction Kind Restrictions --
   -----------------------------------

   function Simple_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies Is_Simple_Transaction

   function Is_Simple_Transaction
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the transaction has only one segment
   --   (A segment is a continuous sequence of activities executed
   --    by the same server)

   function Linear_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies Is_Linear_Transaction

   function Is_Linear_Transaction
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- checks that the transaction only has one external event
   -- and that its Event handlers are all Activities.

   function Linear_Plus_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- Is_Linear_Plus_Transaction

   function Is_Linear_Plus_Transaction
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the transaction has no Concentrator or Barrier
   -- or Multicast or Delivery_Server or Query_Server event handlers

   function Regular_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- Is_Regular_Transaction

   function Is_Regular_Transaction
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the transaction is regular

   function No_Rate_Divisors
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the transaction has no rate divisors
   
   function No_Rate_Divisors
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the system has no rate divisors
   
   function No_Rate_Divisors_In_Multipath_Transactions
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks if there are no Rate Divisors in Multipath Transactions,
   -- i.e., those containing Concentrator, Barrier, Multicast,
   -- Delivery_Server, or Query_Server event handlers
      
   function No_Branch_Event_Handlers
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- No_Branch_Event_Handlers
   
   function No_Branch_Event_Handlers
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean;
   -- Checks that the transaction has no delivery server or query server
   -- event handlers
   
   function No_Merge_Event_Handlers
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- No_Merge_Event_Handlers
   
   function No_Merge_Event_Handlers
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean;
   -- Checks that the transaction has no concentrator
   -- event handlers
   
   function Single_Input_Event_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- Has_Single_Input_Event
   
   function Has_Single_Input_Event
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean;
   -- Checks that the transaction has exactly one input event
   
   function Restricted_Multipath_Transactions_Only
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that every transaction verifies
   -- Is_Restricted_Multipath_Transaction

   function Is_Restricted_Multipath_Transaction
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean;
   -- Checks that the transaction meets Has_Single_Input_Event,
   --  Has_No_Branch_Events, and Has No_Rate_Divisors if it is a
   --  Multipath_Transaction. It also checks that the following 
   --  constructs with a multipath event handlers, do not exist:
   --    - fork followed by fork
   --    - join followed by fork
   --    - join followed by join
   --    - merge followed by merge
   --    - fork at the end
   --    - join at the end
   --    - merge at the end
   
end MAST.Restrictions;
