-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2025                     --
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

with Mast.Graphs,Mast.Graphs.Event_Handlers, Mast.Graphs.Links,
  Mast.Events, Mast.Shared_Resources, Mast.Timing_Requirements, 
  Mast.Processing_Resources,
  Mast.Processing_Resources.Processor, Mast.Processing_Resources.Network,
  Mast.Schedulers, Mast.Schedulers.Primary, Mast.Schedulers.Secondary,
  Mast.Scheduling_Policies, Mast.Timers,
  Mast.Transaction_Operations, Mast.Linear_Translation,
  Mast.Tool_Exceptions,Mast.Operations,Mast.Results,
  Mast.Scheduling_Parameters, Mast.Scheduling_Servers, Mast.Tools,
  Mast.IO,

  Mast.Max_Numbers,
  Ada.Text_IO,Var_Strings;
-- Doubly_Linked_Lists;
use Ada.Text_IO,Var_Strings;
use type Mast.Graphs.Link_Ref;
use type Mast.Graphs.Event_Handler_Ref;
use type Mast.Events.Event_Ref;
use type Mast.Graphs.Event_Handler_Lists.Index;
use type Mast.Shared_Resources.Shared_Resource_Ref;
use type Mast.Timing_Requirements.Timing_Requirement_Ref;
use type Mast.Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
use type Mast.Operations.Operation_Ref;
use type Mast.Scheduling_Parameters.Sched_Parameters_Ref;
use type Mast.Scheduling_Servers.Scheduling_Server_Ref;
use type Mast.Processing_Resources.Processing_Resource_Ref;
use type Mast.Results.Timing_Result_Ref;
use type Mast.Timers.System_Timer_Ref;

package body Mast.Restrictions is

   --  package Resource_Lists is new Doubly_Linked_Lists
   --    (Element => Mast.Shared_Resources.Shared_Resource_Ref,
   --     "="     => "=");

   -- use type Resource_Lists.Index;

   ---------------
   -- Message   --
   ---------------

   procedure Message (Verbose : Boolean;
                      Restriction_Name, Message_Line1 : String;
                      Message_Line2,Message_Line3 : String:="") is
   begin
      Tool_Exceptions.Set_Restriction_Message(Restriction_Name);
      if Verbose then
         Put_Line("Detected Restriction Failure in: "&Restriction_Name);
         Put_Line("   "&Message_Line1);
         if Message_Line2/="" then
            Put_Line("   "&Message_Line2);
         end if;
         if Message_Line3/="" then
            Put_Line("   "&Message_Line3);
         end if;
      end if;
   end Message;


   -----------------------------
   -- Primary_Schedulers_Only --
   -----------------------------

   function Primary_Schedulers_Only
     (The_System : Mast.Systems.System;
      Restriction_Name : String;
      Verbose : Boolean := True)
     return Boolean
   is
      Sched_Ref : Schedulers.Scheduler_Ref;
      Sched_Iterator : Schedulers.Lists.Iteration_Object;
   begin
      Schedulers.Lists.Rewind
        (The_System.Schedulers,Sched_Iterator);
      for I in 1..Schedulers.Lists.Size
        (The_System.Schedulers)
      loop
         Schedulers.Lists.Get_Next_Item
           (Sched_Ref,The_System.Schedulers,Sched_Iterator);
         if Sched_Ref.all in Schedulers.Secondary.Secondary_Scheduler'Class
         then
            Message(Verbose,Restriction_Name,"Scheduler: "&
                      To_String(Mast.Schedulers.Name(Sched_Ref)));
            return False;
         end if;
      end loop;
      return True;
   end Primary_Schedulers_Only;

   --------------------------------------
   -- Consistent_Overridden_Priorities --
   --------------------------------------

   function Consistent_Overridden_Priorities
     (The_System : Mast.Systems.System;
      Restriction_Name : String;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Transactions.Transaction_Ref;
      Trans_Iterator : Transactions.Lists.Iteration_Object;
      New_Sp : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
      Hdlr_Ref : Graphs.Event_Handler_Ref;
      Hdlr_Iterator : Transactions.Event_Handler_Iteration_Object;
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Op_Ref : Operations.Operation_Ref;
      -- Op_Iterator : Operations.Lists.Iteration_Object;
      Sch_Params_Ref : Scheduling_Parameters.Sched_Parameters_Ref;
   begin
      Transactions.Lists.Rewind
        (The_System.Transactions,Trans_Iterator);
      for I in 1..Transactions.Lists.Size(The_System.Transactions) loop
         Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Trans_Iterator);
         -- loop for event handlers
         Transactions.Rewind_Event_Handlers(Trans_Ref.all,Hdlr_Iterator);
         for H in 1..Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
         loop
            Transactions.Get_Next_Event_Handler
              (Trans_Ref.all, Hdlr_Ref, Hdlr_Iterator);
            if Hdlr_Ref.all in Graphs.Event_Handlers.Activity'Class then
               Op_Ref:=Graphs.Event_Handlers.Activity_Operation
                 (Graphs.Event_Handlers.Activity'Class(Hdlr_Ref.all));
               if Op_Ref/=null then
                  New_Sp:=Operations.New_Sched_Parameters(Op_Ref.all);
                  if New_Sp/=null then
                     Srvr_Ref:=Graphs.Event_Handlers.Activity_Server
                       (Graphs.Event_Handlers.Activity'Class(Hdlr_Ref.all));
                     if Srvr_Ref/=null then
                        Sch_Params_Ref:=
                          Scheduling_Servers.Server_Sched_Parameters
                            (Srvr_Ref.all);
                        if Sch_Params_Ref/=null and then
                          Sch_Params_Ref.all not in
                          Scheduling_Parameters.Fixed_Priority_Parameters'Class
                        then
                           Message(Verbose,Restriction_Name,"Operation: "&
                                     To_String(Mast.Operations.Name(Op_Ref)));
                           return False;
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end loop;
      end loop;
      return True;
   end Consistent_Overridden_Priorities;

   -------------------------------
   -- Max_Processor_Utilization --
   -------------------------------

   function Max_Processor_Utilization
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True;
      Calculate_Processing_Resource_Utilization : Boolean:=False) return Float

   is
      type Processor_ID is new Natural;
      type Transaction_ID is new Natural;
      type Task_ID is new Natural;

      Max_Processors:constant Processor_ID:=Processor_ID
        (Processing_Resources.Lists.Size
           (The_System.Processing_Resources));
      Max_Transactions:constant Transaction_ID:=Transaction_ID
        ((Mast.Max_Numbers.Calculate_Max_Transactions(The_System)));
      Max_Tasks_Per_Transaction:constant Task_ID:=Task_ID
        (Mast.Max_Numbers.Calculate_Max_Tasks_Per_Transaction(The_System));

      subtype Processor_ID_Type is Processor_ID
        range 0..Max_Processors;
      subtype Transaction_ID_Type is Transaction_ID
        range 0..Max_Transactions;
      subtype Task_ID_Type is Task_ID
        range 0..Max_Tasks_Per_Transaction;

      package Translation is new Linear_Translation
        (Processor_ID_Type, Transaction_ID_Type, Task_ID_Type,
         Max_Processors, Max_Transactions, Max_Tasks_Per_Transaction);

      use Translation;

      Transaction : Linear_Transaction_System;
      Utilization : array(1..Max_Processors) of Time :=
        (others => 0.0);
      Max_Utilization : Time:=Time'First;
      Res_Ref : Processing_Resources.Processing_Resource_Ref;
      -- Iterator : Processing_Resources.Lists.Index;

      Proc_Ref : Processing_Resources.Processing_Resource_Ref;

      function Get_Processor_Ref
        (The_System : Systems.System;
         Proc_Number : Processor_ID_Type)
        return Processing_Resources.Processing_Resource_Ref
      is
         Res_Ref: Processing_Resources.Processing_Resource_Ref;
         Proc_Iterator : Processing_Resources.Lists.Iteration_Object;
      begin
         Mast.Processing_Resources.Lists.Rewind
           (The_System.Processing_Resources,Proc_Iterator);
         if Natural(Proc_Number) > Mast.Processing_Resources.Lists.Size
           (The_System.Processing_Resources)
         then
            if Verbose then
               Put_Line("Internal error: incorrect processor number");
            end if;
            Tool_Exceptions.Set_Tool_Failure_Message
              ("Incorrect processor number");
            raise Tool_Exceptions.Tool_Failure;
         end if;
         for K in 1..Proc_Number loop
            Mast.Processing_Resources.Lists.Get_Next_Item
              (Res_Ref,The_System.Processing_Resources,Proc_Iterator);
         end loop;
         return Res_Ref;
      end Get_Processor_Ref;


   begin
      if Restricted_Multipath_Transactions_Only (The_System,False) then
         Translate_Linear_System(The_System,Transaction,False);
         for Tr in Transaction_ID_Type range 1..Max_Transactions loop
            exit when Transaction(Tr).Ni=0;
            -- uses Cij and Tij, which are values for the analysis
            -- of other tasks.
            for Tsk in 1..Transaction(Tr).Ni loop
               Proc_Ref:=Get_Processor_Ref
                 (The_System,Transaction(Tr).The_Task(Tsk).Procij);
               Utilization(Transaction(Tr).The_Task(Tsk).Procij):=
                 Time(Tools.Calculate_Processing_Resource_Utilization
                        (The_System,Proc_Ref,Verbose));
            end loop;
         end loop;
         for Pr in Processor_ID_Type range 1..Max_Processors loop
            if Calculate_Processing_Resource_Utilization then
               Res_Ref:=Get_Processor_Ref(The_System, Pr);
               if Verbose then
                  Ada.Text_IO.Put_Line
                    (" Utilization of "&Var_Strings.To_String
                       (Mast.Processing_Resources.Name(Res_Ref.all))&" : "&
                       Mast.IO.Time_Image(Utilization(Pr)*Time(100.0))&"%");
               end if;
               if Utilization(Pr)>=1.0 then
                  Put_Line("Processor "&Get_Processor_Name(The_System,Pr)&
                             " exceeds 100% utilization");
               end if;
            end if;
            if Utilization(Pr)>Max_Utilization then
               Max_Utilization:=Utilization(Pr);
            end if;
         end loop;
         if Max_Utilization>=1.0 then
            Set_Response_Times_To_Large_Time(Transaction);
         end if;
      else
         if Verbose then
            Put_Line("Feasible_Processing_Load not yet implemented for"&
                       " unrestricted multi-path systems");
         end if;
         Tool_Exceptions.Set_Tool_Failure_Message
           ("Feasible_Processing_Load not yet implemented for"&
              " unrestricted multi-path systems");
         raise Tool_Exceptions.Tool_Failure;
      end if;
      if Max_Utilization >= Float'Large then
         return Float'Large;
      else
         begin
            return Float(Max_Utilization);
         exception
            when Constraint_Error =>
               return Float'Large;
         end;
      end if;
   end Max_Processor_Utilization;

   --------------
   -- EDF_Only --
   --------------

   function EDF_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- All Scheduling Servers have EDF or Interrupt Parameters,
   -- there are no overriden parameters in operations, and all interrupt
   -- priorities are within the appropriate ranges for their processing
   -- resources. There are no secondary schedulers.
   is
      Restriction_Name : constant String:="EDF_Only";
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Iterator : Scheduling_Servers.Lists.Iteration_Object;
      Op_Ref : Operations.Operation_Ref;
      Op_Iterator : Operations.Lists.Iteration_Object;
      New_Sp : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
   begin
      if not Primary_Schedulers_Only(The_System,Restriction_Name,Verbose) then
         return False;
      end if;
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,Iterator);
      for I in 1..Scheduling_Servers.Lists.Size
        (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,The_System.Scheduling_Servers,Iterator);
         if Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.EDF_Parameters'Class
           and then
           Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.Interrupt_FP_Policy'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
         if Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Processor.Processor'Class
           and then
           Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Network.Network'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
      end loop;
      Operations.Lists.Rewind
        (The_System.Operations,Op_Iterator);
      for I in 1..Operations.Lists.Size(The_System.Operations) loop
         Operations.Lists.Get_Next_Item
           (Op_Ref,The_System.Operations,Op_Iterator);
         New_Sp:=Operations.New_Sched_Parameters(Op_Ref.all);
         if New_Sp/=null then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Operations.Name(Op_Ref)));
            return False;
         end if;
      end loop;
      return True;
   end EDF_Only;

   --------------------------------
   -- EDF_Within_Priorities_Only --
   --------------------------------

   function EDF_Within_Priorities_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- The primary schedulers have a fixed priority policy.
   -- All secondary schedulers have an EDF policy and are scheduled
   -- under a scheduling server that is directy attached to a
   -- primary server.
   -- All operations with overridden priorities are executed by fixed
   -- priority scheduling servers
   -- All priorities are in range
   is

      Restriction_Name : constant String:="EDF_Within_Priorities_Only";
      Sched_Ref : Schedulers.Scheduler_Ref;
      Spolicy_Ref : Scheduling_Policies.Scheduling_Policy_Ref;
      Iterator : Schedulers.Lists.Iteration_Object;

   begin
      Schedulers.Lists.Rewind
        (The_System.Schedulers,Iterator);
      for I in 1..Schedulers.Lists.Size
        (The_System.Schedulers)
      loop
         Schedulers.Lists.Get_Next_Item
           (Sched_Ref,The_System.Schedulers,Iterator);
         Spolicy_Ref:=Schedulers.Scheduling_Policy(Sched_Ref.all);
         if Sched_Ref.all in Schedulers.Primary.Primary_Scheduler'Class then
            if Spolicy_Ref.all not in
              Scheduling_Policies.Fixed_Priority_Policy'Class
            then
               Message(Verbose,Restriction_Name,"Scheduler: "&
                         To_String(Mast.Schedulers.Name(Sched_Ref)));
               return False;
            end if;
         elsif Sched_Ref.all in Schedulers.Secondary.Secondary_Scheduler'Class
         then
            if Spolicy_Ref.all not in
              Scheduling_Policies.EDF_Policy'Class
            then
               Message(Verbose,Restriction_Name,"Scheduler: "&
                         To_String(Mast.Schedulers.Name(Sched_Ref)));
               return False;
            end if;
            if Scheduling_Servers.Server_Scheduler
              (Schedulers.Secondary.Server
                 (Schedulers.Secondary.Secondary_Scheduler'Class
                    (Sched_Ref.all)).all).all not in
              Schedulers.Primary.Primary_Scheduler'Class
            then
               Message(Verbose,Restriction_Name,"Scheduler: "&
                         To_String(Mast.Schedulers.Name(Sched_Ref)));
               return False;
            end if;
         else
            raise Incorrect_Object;
         end if;
      end loop;
      if not Consistent_Overridden_Priorities
        (The_System,Restriction_Name,Verbose)
      then
         return False;
      end if;
      return True;
   end EDF_Within_Priorities_Only;
   
   ------------------------------------------
   -- No_Timers_In_EDF_Processing_Resource --
   ------------------------------------------
   
   function No_Timers_In_EDF_Processing_Resource
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean is
      -- There are no timers in any of the EDF processing resources
      -- present in the system.
      Restriction_Name : constant String:=
        "No_Timers_In_EDF_Processing_Resource";
      Sched_Ref : Schedulers.Scheduler_Ref;
      Spolicy_Ref : Scheduling_Policies.Scheduling_Policy_Ref;
      Proc_Ref : Processing_Resources.Processing_Resource_Ref;
      Iterator : Schedulers.Lists.Iteration_Object;
      
   begin
      Schedulers.Lists.Rewind
        (The_System.Schedulers,Iterator);
      for I in 1..Schedulers.Lists.Size
        (The_System.Schedulers)
      loop
         Schedulers.Lists.Get_Next_Item
           (Sched_Ref,The_System.Schedulers,Iterator);
         -- We only look at EDF schedulers
         Spolicy_Ref:=Schedulers.Scheduling_Policy(Sched_Ref.all);
         if Spolicy_Ref.all in Scheduling_Policies.EDF_Policy'Class
         then
            -- We only look at primary schedulers, which are the ones 
            -- hosted in a processing resource
            if Sched_Ref.all in Schedulers.Primary.Primary_Scheduler'Class then
               Proc_Ref := Sched_Ref.Host;
               -- We only look at Processors, which are the only resources 
               -- that can have timers
               if Proc_Ref.all in
                 Processing_Resources.Processor.Regular_Processor'Class
               then
                  -- Now we check for timers
                  if Processing_Resources.Processor.Regular_Processor
                    (Proc_Ref.all).The_System_Timer /= null 
                  then
                     Message(Verbose,Restriction_Name,"Processor: "&
                               To_String(Proc_Ref.Name));
                     return False;
                  end if;
               end if;
            end if;
         end if;
      end loop;
      -- No timers found in EDF processors
      return True;      
   end No_Timers_In_EDF_Processing_Resource;
   
   ------------------------------
   -- Feasible_Processing_Load --
   ------------------------------

   function Feasible_Processing_Load
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True;
      Calculate_Processing_Resource_Utilization : Boolean:=False) return Boolean
   -- checks that the utilization level of each processing resource
   -- is under 100%
   is
      Feasible : Boolean;
   begin
      Feasible:=Max_Processor_Utilization
        (The_System,Verbose,Calculate_Processing_Resource_Utilization)<1.0;
      if Verbose and Feasible then
         Put_Line("Utilization load of resources is under 100%");
      end if;
      return Feasible;
   end Feasible_Processing_Load;

   -------------------------
   -- Flat_FP_Or_EDF_Only --
   -------------------------

   function Flat_FP_Or_EDF_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- Each node is Fixed_Priorities_Only or EDF_Only, and there
   -- are no overriden priorities in operations
   is
      Restriction_Name : constant String:="Flat_FP_Or_EDF_Only";
      Iterator : Scheduling_Servers.Lists.Iteration_Object;
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Op_Ref : Operations.Operation_Ref;
      Op_Iterator : Operations.Lists.Iteration_Object;
      New_Sp : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
   begin
      if not Primary_Schedulers_Only(The_System,Restriction_Name,Verbose) then
         return False;
      end if;
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,Iterator);
      for I in 1..Scheduling_Servers.Lists.Size
        (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,The_System.Scheduling_Servers,Iterator);
         if Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.EDF_Parameters'Class
           and then
           Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.Fixed_Priority_Parameters'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
         if Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Processor.Processor'Class
           and then
           Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Network.Network'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
      end loop;
      if not Consistent_Overridden_Priorities
        (The_System,Restriction_Name,Verbose)
      then
         if Verbose then
            Put_Line("Not consistent overriden priorities");
         end if;
         return False;
      end if;
      Operations.Lists.Rewind
        (The_System.Operations,Op_Iterator);
      for I in 1..Operations.Lists.Size(The_System.Operations) loop
         Operations.Lists.Get_Next_Item
           (Op_Ref,The_System.Operations,Op_Iterator);
         New_Sp:=Operations.New_Sched_Parameters(Op_Ref.all);
         if New_Sp/=null then
            if Verbose then
               Put_Line("Overriden new Scheduling Parameters detected");
            end if;
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Operations.Name(Op_Ref)));
            return False;
         end if;
      end loop;
      return True;
   end Flat_FP_Or_EDF_Only;

   -------------------------
   -- FP_Or_EDF_Only --
   -------------------------

   function FP_Or_EDF_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- Each node is Fixed_Priorities_Only or EDF_Only
   is
      Restriction_Name : constant String:="FP_Or_EDF_Only";
      Iterator : Scheduling_Servers.Lists.Iteration_Object;
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      -- Op_Ref : Operations.Operation_Ref;
      -- Op_Iterator : Operations.Lists.Iteration_Object;
      -- New_Sp : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
   begin
      if not Primary_Schedulers_Only(The_System,Restriction_Name,Verbose) then
         return False;
      end if;
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,Iterator);
      for I in 1..Scheduling_Servers.Lists.Size
        (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,The_System.Scheduling_Servers,Iterator);
         if Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.EDF_Parameters'Class
           and then
           Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.Fixed_Priority_Parameters'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
         if Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Processor.Processor'Class
           and then
           Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Network.Network'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
      end loop;
      if not Consistent_Overridden_Priorities
        (The_System,Restriction_Name,Verbose)
      then
         if Verbose then
            Put_Line("Not consistent overriden priorities");
         end if;
         return False;
      end if;
      return True;
   end FP_Or_EDF_Only;

   --------------------------------
   -- Is_Linear_Plus_Transaction --
   --------------------------------

   function Is_Linear_Plus_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Linear_Plus_Transactions_Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Iterator : Transactions.Event_Handler_Iteration_Object;
   begin
      Mast.Transactions.Rewind_Event_Handlers(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Iterator);
         if An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Concentrator'Class
           or else An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Barrier'Class
           or else An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Multicast'Class
           or else An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Delivery_Server'Class
           or else An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Query_Server'Class
         then
            Message(Verbose,Restriction_Name,Trans_Name);
            return False;
         end if;
      end loop;
      return True;
   end Is_Linear_Plus_Transaction;

   ---------------------------
   -- Is_Linear_Transaction --
   ---------------------------

   function Is_Linear_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Linear_Transactions_Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Iterator : Transactions.Event_Handler_Iteration_Object;
   begin
      if Transactions.Num_Of_External_Event_Links(Trans_Ref.all)/=1
      then
         Message(Verbose,Restriction_Name,Trans_Name);
         return False;
      end if;
      Mast.Transactions.Rewind_Event_Handlers(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Iterator);
         if An_Event_Handler_Ref.all not in
           Mast.Graphs.Event_Handlers.Activity'Class
         then
            Message(Verbose,Restriction_Name,Trans_Name);
            return False;
         end if;
      end loop;
      return True;
   end Is_Linear_Transaction;

   ----------------------
   -- No_Rate_Divisors --
   ----------------------

   function No_Rate_Divisors
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="No_Rate_Divisors";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Iterator : Transactions.Event_Handler_Iteration_Object;
   begin
      Mast.Transactions.Rewind_Event_Handlers(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Iterator);
         if An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Rate_Divisor'Class
         then
            Message(Verbose,Restriction_Name,Trans_Name);
            return False;
         end if;
      end loop;
      return True;
   end No_Rate_Divisors;
   
   
   ----------------------
   -- No_Rate_Divisors --
   ----------------------

   function No_Rate_Divisors
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not No_Rate_Divisors(Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end No_Rate_Divisors;
   
   
   ----------------------------
   -- Is_Regular_Transaction --
   ----------------------------

   function Is_Regular_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Regular_Transactions_Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
   begin
      if Trans_Ref.all not in Transactions.Regular_Transaction'Class then
         Message(Verbose,Restriction_Name,Trans_Name);
         return False;
      else
         return True;
      end if;
   end Is_Regular_Transaction;

   ---------------------------
   -- Is_Simple_Transaction --
   ---------------------------

   function Is_Simple_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Simple_Transactions_Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      A_Link_Ref,Last_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
   begin
      Transactions.Rewind_External_Event_Links(Trans_Ref.all,Iterator);
      Transactions.Get_Next_External_Event_Link
        (Trans_Ref.all,A_Link_Ref,Iterator);
      Transaction_Operations.Identify_Segment
        (Trans_Ref,A_Link_Ref,Last_Link_Ref);
      if Transactions.Num_Of_External_Event_Links(Trans_Ref.all)/=1
        or else Graphs.Output_Event_Handler(Last_Link_Ref.all)/=null
      then
         Message(Verbose,Restriction_Name,Trans_Name);
         return False;
      end if;
      return True;
   exception
      when Transaction_Operations.Incorrect_Link =>
         Message(Verbose,Restriction_Name,Trans_Name);
         return False;
   end Is_Simple_Transaction;

   -------------------------
   -- Fixed_Priority_Only --
   -------------------------

   function Fixed_Priority_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Fixed_Priority_Only";
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Op_Ref : Operations.Operation_Ref;
      Iterator : Scheduling_Servers.Lists.Iteration_Object;
      Op_Iterator : Operations.Lists.Iteration_Object;
      New_Sp : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
   begin
      if not Primary_Schedulers_Only(The_System,Restriction_Name,Verbose) then
         return False;
      end if;
      -- check scheduling servers are fixed priority
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,Iterator);
      for I in 1..Scheduling_Servers.Lists.Size
        (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,The_System.Scheduling_Servers,Iterator);
         if Scheduling_Servers.Server_Sched_Parameters(Srvr_Ref.all).all
           not in Scheduling_Parameters.Fixed_Priority_Parameters'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
         if Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Processor.Processor'Class
           and then
           Scheduling_Servers.Server_Processing_Resource(Srvr_Ref.all).all
           not in Processing_Resources.Network.Network'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Scheduling_Servers.Name(Srvr_Ref)));
            return False;
         end if;
      end loop;
      -- check overridden priorities
      Operations.Lists.Rewind
        (The_System.Operations,Op_Iterator);
      for I in 1..Operations.Lists.Size(The_System.Operations) loop
         Operations.Lists.Get_Next_Item
           (Op_Ref,The_System.Operations,Op_Iterator);
         New_Sp:=Operations.New_Sched_Parameters(Op_Ref.all);
         if New_Sp/=null and then New_Sp.all not in
           Scheduling_Parameters.Overridden_FP_Parameters'Class
         then
            Message(Verbose,Restriction_Name,"Server: "&
                      To_String(Mast.Operations.Name(Op_Ref)));
            return False;
         end if;
      end loop;
      return True;
   end Fixed_Priority_Only;

   -----------------------------------
   -- Linear_Plus_Transactions_Only --
   -----------------------------------

   function Linear_Plus_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Is_Linear_Plus_Transaction(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Linear_Plus_Transactions_Only;

   ------------------------------
   -- Linear_Transactions_Only --
   ------------------------------

   function Linear_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Is_Linear_Transaction(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Linear_Transactions_Only;

   ------------------------------------------------
   -- No_Rate_Divisors_In_Multipath_Transactions --
   ------------------------------------------------

   function No_Rate_Divisors_In_Multipath_Transactions
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Is_Linear_Plus_Transaction(Trans_Ref,Verbose) and then
           not No_Rate_Divisors(Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end No_Rate_Divisors_In_Multipath_Transactions;


   ------------------------
   -- Monoprocessor_Only --
   ------------------------

   function Monoprocessor_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Monoprocessor_Only";
      Proc_Ref : Processing_Resources.Processing_Resource_Ref;
      Iterator : Processing_Resources.Lists.Iteration_Object;
   begin
      Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Iterator);
      Processing_Resources.Lists.Get_Next_Item
        (Proc_Ref,The_System.Processing_Resources,Iterator);
      if Processing_Resources.Lists.Size
        (The_System.Processing_Resources)/=1
        or else Proc_Ref.all not in
        Processing_Resources.Processor.Processor'Class
      then
         Message(Verbose,Restriction_Name,"");
         return False;
      else
         return True;
      end if;
   end Monoprocessor_Only;

   -------------------------------
   -- Regular_Transactions_Only --
   -------------------------------

   function Regular_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Is_Regular_Transaction(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Regular_Transactions_Only;

   ----------------------------------------
   -- No_Permanent_Overridden_Priorities --
   ----------------------------------------

   function No_Permanent_FP_Inside_Composite_Operations
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      Restriction_Name : constant String:=
        "No_Permanent_FP_Inside_Composite_Operations";
      Op_Ref : Operations.Operation_Ref;
      Iterator : Operations.Lists.Index;
      Over_Ref : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
      Int_Op_Ref : Operations.Operation_Ref;
      Int_Iterator : Operations.Operation_Iteration_Object;
   begin
      Operations.Lists.Rewind(The_System.Operations,Iterator);
      for I in 1..Operations.Lists.Size(The_System.Operations) loop
         Operations.Lists.Get_Next_Item(Op_Ref,The_System.Operations,Iterator);
         if Op_Ref.all in Operations.Composite_Operation then
            Operations.Rewind_Operations
              (Operations.Composite_Operation'Class(Op_Ref.all),Int_Iterator);
            for I in 1..Operations.Num_Of_Operations
              (Operations.Composite_Operation'Class(Op_Ref.all))
            loop
               Operations.Get_Next_Operation
                 (Operations.Composite_Operation'Class(Op_Ref.all),
                  Int_Op_Ref,Int_Iterator);
               Over_Ref:=Operations.New_Sched_Parameters(Int_Op_Ref.all);
               if Over_Ref/=null and then Over_Ref.all in
                 Scheduling_Parameters.Overridden_Permanent_FP_Parameters'Class
               then
                  Message(Verbose,Restriction_Name,
                          To_String("Operation: "&
                                      Operations.Name(Op_Ref)));
                  return False;
               end if;
            end loop;
         end if;
      end loop;
      return True;
   end No_Permanent_FP_Inside_Composite_Operations;

   ----------------------------------------
   -- No_Permanent_Overridden_Priorities --
   ----------------------------------------

   function No_Permanent_Overridden_Priorities
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      Restriction_Name : constant String:="No_Permanent_Overridden_Priorities";
      Op_Ref : Operations.Operation_Ref;
      Iterator : Operations.Lists.Index;
      Over_Ref : Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
   begin
      Operations.Lists.Rewind(The_System.Operations,Iterator);
      for I in 1..Operations.Lists.Size(The_System.Operations) loop
         Operations.Lists.Get_Next_Item(Op_Ref,The_System.Operations,Iterator);
         Over_Ref:=Operations.New_Sched_Parameters(Op_Ref.all);
         if Over_Ref/=null and then Over_Ref.all in
           Scheduling_Parameters.Overridden_Permanent_FP_Parameters'Class
         then
            Message(Verbose,Restriction_Name,To_String
                      ("Operation: " & Operations.Name(Op_Ref)));
            return False;
         end if;
      end loop;
      return True;
   end No_Permanent_Overridden_Priorities;


   --------------
   -- PCP_Only --
   --------------

   function PCP_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="PCP Only";
      Resource_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
      Iterator : Mast.Shared_Resources.Lists.Iteration_Object;
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      for I in 1..Mast.Shared_Resources.Lists.Size
        (The_System.Shared_Resources)
      loop
         Mast.Shared_Resources.Lists.Get_Next_Item
           (Resource_Ref,The_System.Shared_Resources,Iterator);
         if Resource_Ref.all not in
           Mast.Shared_Resources.Immediate_Ceiling_Resource'Class
         then
            Message(Verbose,Restriction_Name,"Resource: "&
                      To_String(Mast.Shared_Resources.Name(Resource_Ref.all)));
            return False;
         end if;
      end loop;
      return True;
   end PCP_Only;

   -----------------------------------------
   -- No_Intermediate_Timing_Requirements --
   -----------------------------------------

   function No_Intermediate_Timing_Requirements
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:=
        "No_Intermediate_Timing_Requirements";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Timing_Requirements.Timing_Requirement_Ref;
   begin
      Mast.Transactions.Rewind_Internal_Event_Links(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,A_Link_Ref,Iterator);
         Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
           (Graphs.Links.Regular_Link(A_Link_Ref.all));
         if Tim_Req_Ref/=null then
            if Graphs.Output_Event_Handler(A_Link_Ref.all)/=null
            then
               Message(Verbose,Restriction_Name,Trans_Name);
               return False;
            end if;
         end if;
      end loop;
      return True;
   end No_Intermediate_Timing_Requirements;


   -----------------------------------------
   -- No_Intermediate_Timing_Requirements --
   -----------------------------------------

   function No_Intermediate_Timing_Requirements
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not No_Intermediate_Timing_Requirements (Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end No_Intermediate_Timing_Requirements;


   --------------------------------------
   -- PCP_Or_Priority_Inheritance_Only --
   --------------------------------------

   function PCP_Or_Priority_Inheritance_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="PCP or PIP Only";
      Resource_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
      Iterator : Mast.Shared_Resources.Lists.Iteration_Object;
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      for I in 1..Mast.Shared_Resources.Lists.Size
        (The_System.Shared_Resources)
      loop
         Mast.Shared_Resources.Lists.Get_Next_Item
           (Resource_Ref,The_System.Shared_Resources,Iterator);
         if Resource_Ref.all not in
           Mast.Shared_Resources.Immediate_Ceiling_Resource'Class and then
           Resource_Ref.all not in
           Mast.Shared_Resources.Priority_Inheritance_Resource'Class
         then
            Message(Verbose,Restriction_Name,"Resource: "&
                      To_String(Mast.Shared_Resources.Name(Resource_Ref.all)));
            return False;
         end if;
      end loop;
      return True;
   end PCP_Or_Priority_Inheritance_Only;

   ------------------------------------------
   -- Resource_Scheduling_Restrictions_Met --
   ------------------------------------------

   function Resource_Scheduling_Restrictions_Met
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   -- for the specified transaction:
   --    all SRP resources are used by EDF tasks
   --    all Priority Inheritance resources are used by Fp tasks
   is
      Restriction_Name : constant String:="PCP SRP or PIP Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));

      Inconsistency : exception;

      procedure Process_Operation_Resources
        (The_Operation_Ref : Mast.Operations.Operation_Ref;
         The_Server_Ref : Scheduling_Servers.Scheduling_Server_Ref)
      is
         An_Act_Ref : Mast.Operations.Operation_Ref;
         Res_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
         -- The_Res_Index : Resource_Lists.Index;
         Iterator : Operations.Resource_Iteration_Object;
         Op_Iterator : Operations.Operation_Iteration_Object;
         Sched_Params_Ref : Scheduling_Parameters.Sched_Parameters_Ref;
      begin
         if The_Operation_Ref.all in
           Mast.Operations.Simple_Operation'Class
         then
            Sched_Params_Ref:=Scheduling_Servers.Server_Sched_Parameters
              (The_Server_Ref.all);
            -- check locked resources
            Mast.Operations.Rewind_Locked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all),
               Iterator);
            for I in 1..Mast.Operations.Num_Of_Locked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all))
            loop
               Mast.Operations.Get_Next_Locked_Resource
                 (Mast.Operations.Simple_Operation
                    (The_Operation_Ref.all),
                  Res_Ref,Iterator);
               if Res_Ref.all in Shared_Resources.SRP_Resource'Class then
                  -- all SRP resources are used by EDF tasks
                  if Sched_Params_Ref.all not in
                    Scheduling_Parameters.EDF_Parameters'Class
                  then
                     Message(Verbose,Restriction_Name,Trans_Name,
                             "SRP resource used by non EDF server. ",
                             "Resource: "&
                               To_String(Mast.Shared_Resources.Name(Res_Ref)));
                     raise Inconsistency;
                  end if;
               elsif Res_Ref.all in
                 Shared_Resources.Priority_Inheritance_Resource'Class
               then
                  -- all Priority Inheritance resources are used by Fp tasks
                  if Sched_Params_Ref.all not in
                    Scheduling_Parameters.Fixed_Priority_Parameters'Class
                  then
                     Message(Verbose,Restriction_Name,Trans_Name,
                             "PIP resource used by non FP server. ",
                             "Resource: "&
                               To_String(Mast.Shared_Resources.Name(Res_Ref)));
                     raise Inconsistency;
                  end if;
               end if;
            end loop;
         elsif The_Operation_Ref.all in
           Mast.Operations.Composite_Operation'Class
         then
            -- Iterate over all Operations
            Mast.Operations.Rewind_Operations
              (Mast.Operations.Composite_Operation(The_Operation_Ref.all),
               Op_Iterator);
            for I in 1..Mast.Operations.Num_Of_Operations
              (Mast.Operations.Composite_Operation(The_Operation_Ref.all))
            loop
               Mast.Operations.Get_Next_Operation
                 (Mast.Operations.Composite_Operation
                    (The_Operation_Ref.all),
                  An_Act_Ref,Op_Iterator);
               Process_Operation_Resources(An_Act_Ref,The_Server_Ref);
            end loop;
         end if;
      end Process_Operation_Resources;

      procedure Process_Operation_Resources
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref)
      is
         pragma Unreferenced (Trans_Ref);
         The_Operation_Ref : Mast.Operations.Operation_Ref;
         The_Server_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      begin
         if The_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Activity'Class
         then
            The_Operation_Ref:=Mast.Graphs.Event_Handlers.Activity_Operation
              (Mast.Graphs.Event_Handlers.Activity'Class
                 (The_Event_Handler_Ref.all));
            The_Server_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
              (Mast.Graphs.Event_Handlers.Activity'Class
                 (The_Event_Handler_Ref.all));
            if The_Operation_Ref/=null then
               Process_Operation_Resources(The_Operation_Ref,The_Server_Ref);
            end if;
         end if;
      end Process_Operation_Resources;

      procedure Null_Operation
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref) is
      begin
         null;
      end Null_Operation;

      procedure Iterate_Transaction_Paths is new
        Mast.Transaction_Operations.Traverse_Paths_From_Link_Once
        (Operation_For_Links  => Null_Operation,
         Operation_For_Event_Handlers => Process_Operation_Resources);

      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;

   begin
      -- loop for each path in the transaction
      Transactions.Rewind_External_Event_Links(Trans_Ref.all,Iterator);
      for I in 1..Transactions.Num_Of_External_Event_Links
        (Trans_Ref.all)
      loop
         Transactions.Get_Next_External_Event_Link
           (Trans_Ref.all,A_Link_Ref,Iterator);
         Iterate_Transaction_Paths(Trans_Ref,A_Link_Ref);
      end loop;
      return True;
   exception
      when Inconsistency =>
         return False;
   end Resource_Scheduling_Restrictions_Met;

   ------------------------------------------
   -- Resource_Scheduling_Restrictions_Met --
   ------------------------------------------

   function Resource_Scheduling_Restrictions_Met
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- all SRP resources are used by EDF tasks
   -- all Priority Inheritance resources are used by Fp tasks
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Index;
   begin
      -- Loop for every transaction
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Resource_Scheduling_Restrictions_Met(Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end Resource_Scheduling_Restrictions_Met;

   ------------------------------------------
   -- PCP_SRP_Or_Priority_Inheritance_Only --
   ------------------------------------------

   function PCP_SRP_Or_Priority_Inheritance_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- all resources are PCP, SRP, or Priority Inheritance resources
   -- all SRP resources are used by EDF tasks
   -- all Priority Inheritance resources are used by Fp tasks
   is
      Restriction_Name : constant String:="PCP SRP or PIP Only";
      Resource_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
      Iterator : Mast.Shared_Resources.Lists.Iteration_Object;
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      for I in 1..Mast.Shared_Resources.Lists.Size
        (The_System.Shared_Resources)
      loop
         Mast.Shared_Resources.Lists.Get_Next_Item
           (Resource_Ref,The_System.Shared_Resources,Iterator);
         if Resource_Ref.all not in
           Mast.Shared_Resources.Immediate_Ceiling_Resource'Class and then
           Resource_Ref.all not in
           Mast.Shared_Resources.Priority_Inheritance_Resource'Class and then
           Resource_Ref.all not in
           Mast.Shared_Resources.SRP_Resource'Class
         then
            Message(Verbose,Restriction_Name,"Resource: "&
                      To_String(Mast.Shared_Resources.Name(Resource_Ref.all)));
            return False;
         end if;
      end loop;
      return Resource_Scheduling_Restrictions_Met(The_System,Verbose);
   end PCP_SRP_Or_Priority_Inheritance_Only;

   -----------------------------------------
   -- Referenced_Events_Are_External_Only --
   -----------------------------------------

   function Referenced_Events_Are_External_Only
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:=
        "Referenced_Events_Are_External_Only";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Timing_Requirements.Timing_Requirement_Ref;
   begin
      Mast.Transactions.Rewind_Internal_Event_Links(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,A_Link_Ref,Iterator);
         Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
           (Graphs.Links.Regular_Link(A_Link_Ref.all));
         if Tim_Req_Ref/=null then
            if (Tim_Req_Ref.all in Timing_Requirements.Global_Deadline'Class
                  and then Timing_Requirements.Event
                    (Timing_Requirements.Global_Deadline
                       (Tim_Req_Ref.all))/=null 
                  and then Timing_Requirements.Event
                    (Timing_Requirements.Global_Deadline
                       (Tim_Req_Ref.all)).all not in Events.External_Event'Class)
              or else
              (Tim_Req_Ref.all in
                 Timing_Requirements.Max_Output_Jitter_Req'Class
                 and then Timing_Requirements.Event
                   (Timing_Requirements.Max_Output_Jitter_Req
                      (Tim_Req_Ref.all)).all not in Events.External_Event'Class)
            then
               Message(Verbose,Restriction_Name,Trans_Name);
               return False;
            end if;
         end if;
      end loop;
      return True;
   end Referenced_Events_Are_External_Only;


   -----------------------------------------
   -- Referenced_Events_Are_External_Only --
   -----------------------------------------

   function Referenced_Events_Are_External_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Referenced_Events_Are_External_Only(Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end Referenced_Events_Are_External_Only;
   
   ------------------------------------------------------
   -- Global_Timing_Requirements_Have_Referenced_Event --
   ------------------------------------------------------
   
   function Global_Timing_Requirements_Have_Referenced_Event
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:=
        "Global_Timing_Requirements_Have_Referenced_Event";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Timing_Requirements.Timing_Requirement_Ref;
   begin
      Mast.Transactions.Rewind_Internal_Event_Links(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,A_Link_Ref,Iterator);
         Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
           (Graphs.Links.Regular_Link(A_Link_Ref.all));
         if Tim_Req_Ref/=null then
            if (Tim_Req_Ref.all in Timing_Requirements.Global_Deadline'Class 
                  and then
                  Timing_Requirements.Event
                    (Timing_Requirements.Global_Deadline
                       (Tim_Req_Ref.all))=null)
              or else
              (Tim_Req_Ref.all in
                 Timing_Requirements.Max_Output_Jitter_Req'Class
                 and then Timing_Requirements.Event
                   (Timing_Requirements.Max_Output_Jitter_Req
                      (Tim_Req_Ref.all))=null)
            then
               Message(Verbose,Restriction_Name,Trans_Name);
               return False;
            end if;
         end if;
      end loop;
      return True;
   end Global_Timing_Requirements_Have_Referenced_Event;

   ------------------------------------------------------
   -- Global_Timing_Requirements_Have_Referenced_Event --
   ------------------------------------------------------
   
   function Global_Timing_Requirements_Have_Referenced_Event
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Global_Timing_Requirements_Have_Referenced_Event
           (Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end Global_Timing_Requirements_Have_Referenced_Event;
   
   ------------------------------
   -- Simple_Transactions_Only --
   ------------------------------

   function Simple_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Is_Simple_Transaction(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Simple_Transactions_Only;

   --------------
   -- SRP_Only --
   --------------

   function SRP_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- All Resources are SRP
   is
      Restriction_Name : constant String:="SRP Only";
      Resource_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
      Iterator : Mast.Shared_Resources.Lists.Iteration_Object;
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      for I in 1..Mast.Shared_Resources.Lists.Size
        (The_System.Shared_Resources)
      loop
         Mast.Shared_Resources.Lists.Get_Next_Item
           (Resource_Ref,The_System.Shared_Resources,Iterator);
         if Resource_Ref.all not in
           Mast.Shared_Resources.SRP_Resource'Class
         then
            Message(Verbose,Restriction_Name,"Resource: "&
                      To_String(Mast.Shared_Resources.Name(Resource_Ref.all)));
            return False;
         end if;
      end loop;
      return True;
   end SRP_Only;

   function No_Shared_Resources
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   -- Check if the Shared Resources List is empty or not
   is
      Restriction_Name : constant String:="No_Shared_Resources";
      Iterator : Mast.Shared_Resources.Lists.Iteration_Object;
   begin
      Mast.Shared_Resources.Lists.Rewind
        (The_System.Shared_Resources,Iterator);
      if Mast.Shared_Resources.Lists.Size(The_System.Shared_Resources)/=0
      then
         Message(Verbose,Restriction_Name,
                 "List of Shared Resources is not empty");
         return False;
      else
         return True;
      end if;
   end No_Shared_Resources;
   
   ----------------------
   -- Non_Null_Periods --
   ----------------------   
   -- Checks that there is are no transaction periods equal to zero
   function Non_Null_Periods
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      pragma Unreferenced (Verbose);
      Restriction_Name : constant String:="Non_Null_Periods";
      pragma Unreferenced (Restriction_Name);
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Iteration_Object;
      L_Iterator : Transactions.Link_Iteration_Object;
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Ev_Ref : Events.Event_Ref;
   begin
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         Transactions.Rewind_External_Event_Links(Trans_Ref.all,L_Iterator);
         for I in 1..Transactions.Num_Of_External_Event_Links
           (Trans_Ref.all)
         loop
            Transactions.Get_Next_External_Event_Link
              (Trans_Ref.all,A_Link_Ref,L_Iterator);
            Ev_Ref:=Graphs.Event_Of(A_Link_Ref.all);
            if Ev_Ref.all in Events.Periodic_Event'Class then
               if Events.Period(Events.Periodic_Event'Class(Ev_Ref.all))=0.0
               then
                  return False;
               end if;
            end if;
         end loop;
      end loop;
      return True;
   end Non_Null_Periods;


   -----------------------------
   -- No_Hard_Local_Deadlines --
   -----------------------------
   function No_Hard_Local_Deadlines
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) return Boolean
   is
      Restriction_Name : constant String:="No Hard Local Deadlines";
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Mast.Timing_Requirements.Timing_Requirement_Ref;
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         -- Loop for all internal events in the transaction
         Mast.Transactions.Rewind_Internal_Event_Links
           (Trans_Ref.all,Iterator);
         for J in 1..Mast.Transactions.Num_Of_Internal_Event_Links
           (Trans_Ref.all)
         loop
            Mast.Transactions.Get_Next_Internal_Event_Link
              (Trans_Ref.all,A_Link_Ref,Iterator);
            Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
              (Graphs.Links.Regular_Link(A_Link_Ref.all));
            -- Check the timing requirement of the internal event
            if Tim_Req_Ref/=null and then
              Mast.Timing_Requirements.Has_Hard_Local_Requirement
                (Tim_Req_Ref.all)
            then
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref.all)));
               return False;
            end if;
         end loop;
      end loop;
      -- No hard local deadlines found
      return True;
   end No_Hard_Local_Deadlines;
   
   ---------------------------------
   -- No_Branch_Event_Handlers --
   ---------------------------------
   -- Checks that every transaction verifies
   -- No_Branch_Event_Handlers
   function No_Branch_Event_Handlers
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean 
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if not No_Branch_Event_Handlers(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end No_Branch_Event_Handlers;
   
   ---------------------------------
   -- No_Branch_Event_Handlers --
   ---------------------------------
   -- Checks that the transaction has no delivery server or query server
   -- event handlers
   function No_Branch_Event_Handlers
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="No_Branch_Event_Handlers";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Iterator : Transactions.Event_Handler_Iteration_Object;
   begin
      Mast.Transactions.Rewind_Event_Handlers(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Iterator);
         if An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Delivery_Server'Class or else
           An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Query_Server'Class
         then
            Message(Verbose,Restriction_Name,Trans_Name);
            return False;
         end if;
      end loop;
      return True;
      
   end No_Branch_Event_Handlers;

   
   -----------------------------
   -- No_Merge_Event_Handlers --
   -----------------------------
   -- Checks that every transaction verifies
   -- No_Merge_Event_Handlers
   function No_Merge_Event_Handlers
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean 
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if not No_Merge_Event_Handlers(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end No_Merge_Event_Handlers;

   
   -----------------------------
   -- No_Merge_Event_Handlers --
   -----------------------------
   -- Checks that the transaction has no concentrator
   -- event handlers
   function No_Merge_Event_Handlers
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean 
   is
      Restriction_Name : constant String:="No_Merge_Event_Handlers";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Iterator : Transactions.Event_Handler_Iteration_Object;
   begin
      Mast.Transactions.Rewind_Event_Handlers(Trans_Ref.all,Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Iterator);
         if An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Concentrator'Class
         then
            Message(Verbose,Restriction_Name,Trans_Name);
            return False;
         end if;
      end loop;
      return True;
      
   end No_Merge_Event_Handlers;
   
   
   ------------------------------------------
   -- Single_Input_Event_Transactions_Only --
   ------------------------------------------
   -- Checks that every transaction verifies
   -- Has_Single_Input_Event
   function Single_Input_Event_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean 
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if not Has_Single_Input_Event(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Single_Input_Event_Transactions_Only;

   
   ----------------------------
   -- Has_Single_Input_Event --
   ----------------------------
   -- Checks that the transaction has exactly one input event
   function Has_Single_Input_Event
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose   : Boolean := True)
     return Boolean 
   is
      Restriction_Name : constant String:="Has_Single_Input_Event";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
   begin
      if Transactions.Num_Of_External_Event_Links(Trans_Ref.all) /= 1 then
         Message(Verbose,Restriction_Name,Trans_Name);
         return False;    
      end if;
      return True;
      
   end Has_Single_Input_Event;

   
   --------------------------------------------
   -- Restricted_Multipath_Transactions_Only --
   --------------------------------------------
   -- Checks that every transaction verifies
   -- Is_Restricted_Multipath_Transaction
   function Restricted_Multipath_Transactions_Only
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean 
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if not Is_Restricted_Multipath_Transaction(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;
      return True;
   end Restricted_Multipath_Transactions_Only;


   -----------------------------------------
   -- Is_Restricted_Multipath_Transaction --
   -----------------------------------------
   
   -- Checks that the transaction meets Has_Single_Input_Event,
   -- Has_No_Branch_Events and Has No_Rate_Divisors if it is a
   -- Multipath_Transaction
   
   -- In addition, it checks that the following constructs with
   -- multipath event handlers, do not exist:
   --    - Fork followed by fork
   --    - Fork at the end
   --    - Join followed by fork or join
   --    - Merge followed by merge
   --    - Merge at the end
   
   --    - join after merge
   --    - Join at the end
   
   
   function Is_Restricted_Multipath_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean 
   is
      Hdlr_Ref, Next_Hdlr_Ref : Graphs.Event_Handler_Ref;
      Hdlr_Iterator : Transactions.Event_Handler_Iteration_Object;
      It : Mast.Graphs.Event_Handlers.Iteration_Object;
      Next_Link_Ref : Mast.Graphs.Link_Ref;
      OK : Boolean;
      Restriction_Name : constant String:=
        "Is_Restricted_Multipath_Transaction";
      
      procedure Operation_For_Event_Handlers
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref) is
      begin 
         if The_Event_Handler_Ref.all in Graphs.Event_Handlers.Barrier'Class
         then
            OK := False;
         end if;
      end Operation_For_Event_Handlers;
      
      procedure Null_Op
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref) is
      begin 
         null;
      end Null_Op;
      
      procedure Traverse_Paths_Once is new 
        Transaction_Operations.Traverse_Paths_From_Link_Once
        (Operation_For_Event_Handlers, Null_Op);
      
   begin
      OK:= Has_Single_Input_Event(Trans_Ref,Verbose) and then 
        No_Branch_Event_Handlers(Trans_Ref,Verbose) and then
        (Is_Linear_Plus_Transaction(Trans_Ref, False) or else
           No_Rate_Divisors(Trans_Ref,Verbose));
      if not OK then
         return False;
      end if;
      -- Loop for all event handlers
      Transactions.Rewind_Event_Handlers(Trans_Ref.all,Hdlr_Iterator);
      for H in 1..Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Transactions.Get_Next_Event_Handler
           (Trans_Ref.all, Hdlr_Ref, Hdlr_Iterator);
         -- check that the following constructs with a multipath event
         --  handlers, do not exist:
         
         --    - fork followed by fork or fork at the end
         if Hdlr_Ref.all in Graphs.Event_Handlers.Multicast'Class then
            -- Iterate over all output links
            Mast.Graphs.Event_Handlers.Rewind_Output_Links
              (Graphs.Event_Handlers.Output_Event_Handler
                 (Hdlr_Ref.all),It);
            
            for Succ in 1..Graphs.Event_Handlers.Output_Event_Handler
              (Hdlr_Ref.all).Num_Of_Output_Links
            loop
               Graphs.Event_Handlers.Get_Next_Output_Link
                 (Graphs.Event_Handlers.Output_Event_Handler
                    (Hdlr_Ref.all),Next_Link_Ref,It);
               Next_Hdlr_Ref:=Next_Link_Ref.Output_Event_Handler;
               if Next_Hdlr_Ref=null then
                  -- Fork at the end
                  Message(Verbose,Restriction_Name,"Transaction: "&
                            To_String(Mast.Transactions.Name(Trans_Ref)),
                          "Restriction: Fork at the end");
                  return False;
               elsif Next_Hdlr_Ref.all in
                 Graphs.Event_Handlers.Multicast'Class 
               then
                  -- Fork followed by fork
                  Message(Verbose,Restriction_Name,"Transaction: "&
                            To_String(Mast.Transactions.Name(Trans_Ref)),
                          "Restriction: Fork followed by fork");
                  return False;
               end if;
            end loop;
         end if;
         
         --    - join followed by fork or join or join at the end
         if Hdlr_Ref.all in Graphs.Event_Handlers.Barrier'Class then
            -- Get output link
            Next_Link_Ref:=Graphs.Event_Handlers.Input_Event_Handler
              (Hdlr_Ref.all).Output_Link;
            Next_Hdlr_Ref:=Next_Link_Ref.Output_Event_Handler;
            if Next_Hdlr_Ref=null then
               -- join at the end
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref)),
                       "Restriction: Join at the end");
               return False;
            elsif Next_Hdlr_Ref.all in
              Graphs.Event_Handlers.Multicast'Class or else 
              Next_Hdlr_Ref.all in
              Graphs.Event_Handlers.Barrier'Class
            then
               -- join followed by fork or join
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref)),
                       "Restriction: Join followed by fork or join");
               return False;
            end if;
         end if;
         
         -- merge followed by merge or merge at the end or join after merge
         if Hdlr_Ref.all in Graphs.Event_Handlers.Concentrator'Class then
            -- Get output link
            Next_Link_Ref:=Graphs.Event_Handlers.Input_Event_Handler
              (Hdlr_Ref.all).Output_Link;
            Next_Hdlr_Ref:=Next_Link_Ref.Output_Event_Handler;
            if Next_Hdlr_Ref=null 
            then 
               -- merge at the end
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref)),
                       "Restriction: Merge at the end");
               return False;
            elsif Next_Hdlr_Ref.all in
              Graphs.Event_Handlers.Concentrator'Class 
            then
               -- Merge followed by merge
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref)),
                       "Restriction: Merge followed by merge");
               return False;
            end if;
            
            -- Check for join after merge
            OK:=True;
            Traverse_Paths_Once (Trans_Ref, Next_Link_Ref);
            if not OK then
               Message(Verbose,Restriction_Name,"Transaction: "&
                         To_String(Mast.Transactions.Name(Trans_Ref)),
                       "Restriction: Join after merge");
               return False;
            end if;
         end if;
         
      end loop;

      -- Everything OK
      return True;

   end Is_Restricted_Multipath_Transaction;
   
   
   ------------------------------------------
   -- Has_Bursty_Event_With_Polling_Server --
   ------------------------------------------
   
   -- Checks that at least one transaction verifies
   -- Has_Bursty_Event_With_Polling_Server. In these systems,
   -- transactions verifying Has_Bursty_Event_With_Polling_Server are
   -- modelled with a transactions with offsets, and therefore require
   -- an offset-based scheduling analysis technique
   
   function Has_Bursty_Event_With_Polling_Server
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean 
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if Has_Bursty_Event_With_Polling_Server(Trans_Ref,Verbose) then
            return True;
         end if;
      end loop;
      return False;
   end Has_Bursty_Event_With_Polling_Server;
   
   ------------------------------------------
   -- Has_Bursty_Event_With_Polling_Server --
   ------------------------------------------
   -- Checks that the transaction is simple and has a bursty event
   -- that is processed by a single activity scheduled with a polling
   -- server policy
   
   function Has_Bursty_Event_With_Polling_Server
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Lnk_Iterator : Transactions.Link_Iteration_Object;
      Hdlr_Iterator : Transactions.Event_Handler_Iteration_Object;
      The_Link : Mast.Graphs.Link_Ref;
      The_Event_Handler : Mast.Graphs.Event_Handler_Ref;
   
   begin
      if Is_Simple_Transaction(Trans_Ref, False) then
         Trans_Ref.Rewind_External_Event_Links(Lnk_Iterator);
         Trans_Ref.Get_Next_External_Event_Link(The_Link, Lnk_Iterator);
         if The_Link.Event_Of.all in Events.Bursty_Event'Class then
            Trans_Ref.Rewind_Event_Handlers(Hdlr_Iterator);
            Trans_Ref.Get_Next_Event_Handler(The_Event_Handler, Hdlr_Iterator);
            if The_Event_Handler.all in Graphs.Event_Handlers.Activity'Class  
            then
               if Graphs.Event_Handlers.Activity'Class(The_Event_Handler.all).
                 Activity_Server.Server_Sched_Parameters.all in
                 Scheduling_Parameters.Polling_Policy'Class
               then
                  if Verbose then
                     -- Print message
                     Put_Line("Transaction "&To_String(Trans_Ref.Name)&
                       " has bursty event processed through a polling server");
                  end if;
                  return True;
               end if;
            end if;
         end if;
      end if;
      return False;
   end Has_Bursty_Event_With_Polling_Server;
   
   
   --------------------------------------------------------------------
   -- Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction --
   --------------------------------------------------------------------
   -- Checks that no transaction verifies
   -- Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction. Systems
   -- with transactions that are not simple and have bursty events
   -- processed through polling servers cannot be analyzed in the
   -- current version of mast.
   function Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      -- Loop for all transactions
      Mast.Transactions.Lists.Rewind(The_System.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,It);
         if Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction
           (Trans_Ref,Verbose) 
         then
            return True;
         end if;
      end loop;
      return False;
   end Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction;
   
   
   --------------------------------------------------------------------
   -- Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction --
   --------------------------------------------------------------------
   -- Checks that the transaction is not simple and has a bursty event
   -- that is processed by a single activity scheduled with a polling
   -- server policy
   function Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Lnk_Iterator : Transactions.Link_Iteration_Object;
      Hdlr_Iterator : Transactions.Event_Handler_Iteration_Object;
      The_Link : Mast.Graphs.Link_Ref;
      The_Event_Handler : Mast.Graphs.Event_Handler_Ref;
   
   begin
      if not Is_Simple_Transaction(Trans_Ref, False) then
         Trans_Ref.Rewind_External_Event_Links(Lnk_Iterator);
         -- Iterate through all external event links
         for I in 1..Trans_Ref.Num_Of_External_Event_Links loop
            Trans_Ref.Get_Next_External_Event_Link(The_Link, Lnk_Iterator);
            if The_Link.Event_Of.all in Events.Bursty_Event'Class then
               Trans_Ref.Rewind_Event_Handlers(Hdlr_Iterator);
               -- Iterate through all event handlers
               for J in 1..Trans_Ref.Num_Of_Event_Handlers loop
                  Trans_Ref.Get_Next_Event_Handler
                    (The_Event_Handler, Hdlr_Iterator);
                  if The_Event_Handler.all in 
                    Graphs.Event_Handlers.Activity'Class  
                  then
                     if Graphs.Event_Handlers.Activity'Class
                       (The_Event_Handler.all).
                       Activity_Server.Server_Sched_Parameters.all in
                       Scheduling_Parameters.Polling_Policy'Class
                     then
                        if Verbose then
                           -- Print message
                           Put_Line("Transaction "&To_String(Trans_Ref.Name)&
                                      " has bursty event processed "&
                                      "through a polling server");
                        end if;
                        return True;
                     end if;
                  end if;
               end loop;
            end if;
         end loop;
      end if;
      return False;
   end Has_Bursty_Event_With_Polling_Server_In_Non_Simple_Transaction;
   
   
end Mast.Restrictions;
