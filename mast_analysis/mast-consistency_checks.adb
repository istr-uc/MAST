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

with Mast.Graphs,Mast.Graphs.Event_Handlers,
  Mast.Events, Mast.Operations, Mast.Shared_Resources,
  Mast.Transaction_Operations, Mast.Scheduling_Servers,
  Mast.Processing_Resources,Mast.Scheduling_Parameters,
  Mast.Processing_Resources.Network,
  Mast.Processing_Resources.Processor,
  Mast.Drivers,
  Mast.Timers,
  Mast.Schedulers, Mast.Schedulers.Primary, Mast.Schedulers.Secondary,
  Mast.Scheduling_Policies,
  Ada.Text_IO,Var_Strings,
  Doubly_Linked_Lists,List_Exceptions;

with Ada.Containers.Indefinite_Ordered_Sets;

use Ada.Text_IO,Var_Strings;
use type Mast.Graphs.Link_Ref;
use type Mast.Graphs.Event_Handler_Ref;
use type Mast.Events.Event_Ref;
use type Mast.Graphs.Link_Lists.Index;
use type Mast.Graphs.Event_Handler_Lists.Index;
use type Mast.Shared_Resources.Shared_Resource_Ref;
use type Mast.Scheduling_Servers.Scheduling_Server_Ref;
use type Mast.Operations.Operation_Ref;
use type Mast.Processing_Resources.Processing_Resource_Ref;
use type Mast.Scheduling_Parameters.Sched_Parameters_Ref;
use type Mast.Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
use type Mast.Schedulers.Scheduler_Ref;
use type Mast.Scheduling_Policies.Scheduling_Policy_Ref;
use type Mast.Processing_Resources.Processor.Processor_Ref;
use type Mast.Timers.System_Timer_Ref;
use Mast;

package body Mast.Consistency_Checks is

   package Resource_Lists is new Doubly_Linked_Lists
     (Element => Mast.Shared_Resources.Shared_Resource_Ref,
      "="     => "=");

   use type Resource_Lists.Index;

   ---------------
   -- Message   --
   ---------------

   procedure Message (Verbose : Boolean;
                      Restriction_Name, Message_Line1 : String;
                      Message_Line2,Message_Line3 : String:="") is
   begin
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

   --------------------------------------
   -- Consistent_Shared_Resource_Usage --
   --------------------------------------

   function Consistent_Shared_Resource_Usage
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:=
        "Consistent Shared Resource Usage";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));

      Inconsistency : exception;

      procedure Process_Operation_Resources
        (The_Operation_Ref : Mast.Operations.Operation_Ref;
         Locked_Resources : in out Resource_Lists.List)
      is
         An_Act_Ref : Mast.Operations.Operation_Ref;
         Res_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
         The_Res_Index : Resource_Lists.Index;
         Iterator : Operations.Resource_Iteration_Object;
         Op_Iterator : Operations.Operation_Iteration_Object;
      begin
         if The_Operation_Ref.all in
           Mast.Operations.Simple_Operation'Class
         then
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
               -- Rule 2: no resource is locked if it was already locked
               if Resource_Lists.Find(Res_Ref,Locked_Resources)/=
                 Resource_Lists.Null_Index
               then
                  Message(Verbose,Restriction_Name,Trans_Name,
                          "Rule 2 not met: resource locked twice",
                          "Resource: "&
             To_String(Mast.Shared_Resources.Name(Res_Ref)));
                  raise Inconsistency;
               else
                  Resource_Lists.Add(Res_Ref,Locked_Resources);
               end if;
            end loop;
            -- check unlocked resources
            Mast.Operations.Rewind_Unlocked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all),
               Iterator);
            for I in 1..Mast.Operations.Num_Of_Unlocked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all))
            loop
               Mast.Operations.Get_Next_Unlocked_Resource
                 (Mast.Operations.Simple_Operation(The_Operation_Ref.all),
                  Res_Ref,Iterator);
               -- Rule 3: no resource is unlocked if not previously locked
               The_Res_Index:= Resource_Lists.Find
                 (Res_Ref,Locked_Resources);
               if  The_Res_Index=Resource_Lists.Null_Index
               then
                  Message(Verbose,Restriction_Name,Trans_Name,
                          "Rule 3 not met: unlocked resource that was "&
             "not previously locked",
                          "Resource: "&
             To_String(Mast.Shared_Resources.Name(Res_Ref)));
                  raise Inconsistency;
               else
                  Resource_Lists.Delete
                    (The_Res_Index,Locked_Resources,Res_Ref);
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
               Process_Operation_Resources(An_Act_Ref,Locked_Resources);
            end loop;
         elsif The_Operation_Ref.all in
           Mast.Operations.Message_Transmission_Operation'Class
         then
            null; -- messages have no shared resources
         else
            raise Incorrect_Object;
         end if;
      end Process_Operation_Resources;

      procedure Traverse_Paths_From_Link
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref;
         Locked_Resources : in out Resource_Lists.List)
      is
         An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
         Next_Link_Ref : Mast.Graphs.Link_Ref;
         Cloned_Locked_Resources : Resource_Lists.List;
         Iterator : Graphs.Event_Handlers.Iteration_Object;
      begin
         if The_Link_Ref=null then
            return;
         end if;
         An_Event_Handler_Ref:=Mast.Graphs.Output_Event_Handler
           (The_Link_Ref.all);
         if An_Event_Handler_Ref/=null then
            if An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Simple_Event_Handler'Class
            then
               if An_Event_Handler_Ref.all in
                 Mast.Graphs.Event_Handlers.Activity'Class
               then
                  Process_Operation_Resources
                    (Mast.Graphs.Event_Handlers.Activity_Operation
             (Mast.Graphs.Event_Handlers.Activity
           (An_Event_Handler_Ref.all)),
                     Locked_Resources);
               end if;
               Next_Link_Ref:=Mast.Graphs.Event_Handlers.Output_Link
                 (Mast.Graphs.Event_Handlers.Simple_Event_Handler
          (An_Event_Handler_Ref.all));
               Traverse_Paths_From_Link
                 (Trans_Ref,Next_Link_Ref,Locked_Resources);
            elsif An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Output_Event_Handler'Class
            then
               Mast.Graphs.Event_Handlers.Rewind_Output_Links
                 (Mast.Graphs.Event_Handlers.Output_Event_Handler
          (An_Event_Handler_Ref.all),Iterator);
               for I in 1..Mast.Graphs.Event_Handlers.Num_Of_Output_Links
                 (Mast.Graphs.Event_Handlers.Output_Event_Handler
          (An_Event_Handler_Ref.all))
               loop
                  Mast.Graphs.Event_Handlers.Get_Next_Output_Link
                    (Mast.Graphs.Event_Handlers.Output_Event_Handler
             (An_Event_Handler_Ref.all),
                     Next_Link_Ref,Iterator);
                  Cloned_Locked_Resources:=Resource_Lists.Clon
                    (Locked_Resources);
                  Traverse_Paths_From_Link
                    (Trans_Ref,Next_Link_Ref,Cloned_Locked_Resources);
               end loop;
            else -- input Event_Handler
               Next_Link_Ref:=Mast.Graphs.Event_Handlers.Output_Link
                 (Mast.Graphs.Event_Handlers.Input_Event_Handler
          (An_Event_Handler_Ref.all));
               Traverse_Paths_From_Link
                 (Trans_Ref,Next_Link_Ref,Locked_Resources);
            end if;
         else
            -- end of a path
            -- Rule 1: all locked resources are unlocked
            if not Resource_Lists.Empty(Locked_Resources) then
               Message(Verbose,Restriction_Name,Trans_Name,
                       "Rule 1 not met: not all locked resources "&
          "were unlocked");
               raise Inconsistency;
            end if;
         end if;
      end Traverse_Paths_From_Link;

      Locked_Resources : Resource_Lists.List;
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
         Resource_Lists.Init(Locked_Resources);
         Traverse_Paths_From_Link
           (Trans_Ref,A_Link_Ref,Locked_Resources);
      end loop;
      return True;
   exception
      when Inconsistency =>
         return False;
   end Consistent_Shared_Resource_Usage;

   --------------------------------------
   -- Consistent_Shared_Resource_Usage --
   --------------------------------------

   function Consistent_Shared_Resource_Usage
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Copy_Of_Trans_List : constant Mast.Transactions.Lists.List:=
        The_System.Transactions;
      Iterator : Transactions.Lists.Index;
   begin
      -- Loop for every transaction
      Mast.Transactions.Lists.Rewind(Copy_Of_Trans_List,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(Copy_Of_Trans_List)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,Copy_Of_Trans_List,Iterator);
         if not Consistent_Shared_Resource_Usage(Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end Consistent_Shared_Resource_Usage;

   ---------------------------------------------------
   -- Consistent_Shared_Resource_Usage_For_Segments --
   ---------------------------------------------------
   -- Checks the following rule for the specified transaction:
   --    all locked resources in a segment are unlocked in that segment

   function Consistent_Shared_Resource_Usage_For_Segments
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:=
        "Consistent Shared Resource Usage For Segments";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));

      Inconsistency : exception;

      procedure Process_Operation_Resources
        (The_Operation_Ref : Mast.Operations.Operation_Ref;
         Locked_Resources : in out Resource_Lists.List)
      is
         An_Act_Ref : Mast.Operations.Operation_Ref;
         Res_Ref : Mast.Shared_Resources.Shared_Resource_Ref;
         The_Res_Index : Resource_Lists.Index;
         Iterator : Operations.Resource_Iteration_Object;
         Op_Iterator : Operations.Operation_Iteration_Object;
      begin
         if The_Operation_Ref.all in
           Mast.Operations.Simple_Operation'Class
         then
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
               Resource_Lists.Add(Res_Ref,Locked_Resources);
            end loop;
            -- check unlocked resources
            Mast.Operations.Rewind_Unlocked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all),
               Iterator);
            for I in 1..Mast.Operations.Num_Of_Unlocked_Resources
              (Mast.Operations.Simple_Operation(The_Operation_Ref.all))
            loop
               Mast.Operations.Get_Next_Unlocked_Resource
                 (Mast.Operations.Simple_Operation(The_Operation_Ref.all),
                  Res_Ref,Iterator);
               The_Res_Index:=Resource_Lists.Find(Res_Ref,Locked_Resources);
               Resource_Lists.Delete
                 (The_Res_Index,Locked_Resources,Res_Ref);
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
               Process_Operation_Resources(An_Act_Ref,Locked_Resources);
            end loop;
         else
            raise Incorrect_Object;
         end if;
      end Process_Operation_Resources;

      procedure Check_Segment
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref;
         Next_Link_Ref : out Mast.Graphs.Link_Ref)
      is
         pragma Unreferenced (Trans_Ref);
         An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Locked_Resources : Resource_Lists.List;
      begin
         An_Event_Handler_Ref:=Mast.Graphs.
           Output_Event_Handler(The_Link_Ref.all);
         if An_Event_Handler_Ref=null or else An_Event_Handler_Ref.all not in
           Mast.Graphs.Event_Handlers.Activity'Class
         then
            raise Incorrect_Object;
         end if;
         Srvr_Ref:=Graphs.Event_Handlers.Activity_Server
           (Graphs.Event_Handlers.Activity(An_Event_Handler_Ref.all));
         loop
            Next_Link_Ref:=Mast.Graphs.Event_Handlers.Output_Link
              (Mast.Graphs.Event_Handlers.Activity
       (An_Event_Handler_Ref.all));
            An_Event_Handler_Ref:=Mast.Graphs.
              Output_Event_Handler(Next_Link_Ref.all);
            exit when An_Event_Handler_Ref=null or else
              An_Event_Handler_Ref.all not in
              Mast.Graphs.Event_Handlers.Activity'Class or else
              Srvr_Ref/=Graphs.Event_Handlers.Activity_Server
              (Graphs.Event_Handlers.Activity(An_Event_Handler_Ref.all));
            Process_Operation_Resources
              (Mast.Graphs.Event_Handlers.Activity_Operation
       (Mast.Graphs.Event_Handlers.Activity
          (An_Event_Handler_Ref.all)),
               Locked_Resources);
         end loop;
         -- end of a segment
         -- Rule 1: all locked resources are unlocked
         if not Resource_Lists.Empty(Locked_Resources) then
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule not met: not all locked resources "&
            "were unlocked in segment");
            raise Inconsistency;
         end if;
      end Check_Segment;

      procedure Traverse_Paths_From_Link
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref)
      is
         An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
         Next_Link_Ref : Mast.Graphs.Link_Ref;
         Iterator : Graphs.Event_Handlers.Iteration_Object;
      begin
         if The_Link_Ref=null then
            return;
         end if;
         An_Event_Handler_Ref:=Mast.Graphs.Output_Event_Handler
           (The_Link_Ref.all);
         if An_Event_Handler_Ref/=null then
            if An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Simple_Event_Handler'Class
            then
               if An_Event_Handler_Ref.all in
                 Mast.Graphs.Event_Handlers.Activity'Class
               then
                  Check_Segment
                    (Trans_Ref,The_Link_Ref,Next_Link_Ref);
               end if;
               Traverse_Paths_From_Link
                 (Trans_Ref,Next_Link_Ref);
            elsif An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Output_Event_Handler'Class
            then
               Mast.Graphs.Event_Handlers.Rewind_Output_Links
                 (Mast.Graphs.Event_Handlers.Output_Event_Handler
          (An_Event_Handler_Ref.all),Iterator);
               for I in 1..Mast.Graphs.Event_Handlers.Num_Of_Output_Links
                 (Mast.Graphs.Event_Handlers.Output_Event_Handler
          (An_Event_Handler_Ref.all))
               loop
                  Mast.Graphs.Event_Handlers.Get_Next_Output_Link
                    (Mast.Graphs.Event_Handlers.Output_Event_Handler
             (An_Event_Handler_Ref.all),
                     Next_Link_Ref,Iterator);
                  Traverse_Paths_From_Link
                    (Trans_Ref,Next_Link_Ref);
               end loop;
            else -- input Event_Handler
               Next_Link_Ref:=Mast.Graphs.Event_Handlers.Output_Link
                 (Mast.Graphs.Event_Handlers.Input_Event_Handler
          (An_Event_Handler_Ref.all));
               Traverse_Paths_From_Link
                 (Trans_Ref,Next_Link_Ref);
            end if;
         end if;
      end Traverse_Paths_From_Link;

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
         Traverse_Paths_From_Link
           (Trans_Ref,A_Link_Ref);
      end loop;
      return True;
   exception
      when Inconsistency =>
         return False;
   end Consistent_Shared_Resource_Usage_For_Segments;

   ---------------------------------------------------
   -- Consistent_Shared_Resource_Usage_For_Segments --
   ---------------------------------------------------

   function Consistent_Shared_Resource_Usage_For_Segments
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Copy_Of_Trans_List : constant Mast.Transactions.Lists.List:=
        The_System.Transactions;
      Iterator : Transactions.Lists.Index;
   begin
      -- Loop for every transaction
      Mast.Transactions.Lists.Rewind(Copy_Of_Trans_List,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(Copy_Of_Trans_List)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,Copy_Of_Trans_List,Iterator);
         if not Consistent_Shared_Resource_Usage_For_Segments
           (Trans_Ref,Verbose)
         then
            return False;
         end if;
      end loop;
      return True;
   end Consistent_Shared_Resource_Usage_For_Segments;

   -----------------------------------
   -- Consistent_Transaction_Graphs --
   -----------------------------------

   function Consistent_Transaction_Graphs
     (Trans_Ref : Mast.Transactions.Transaction_Ref;
      Verbose : Boolean := True)
     return Boolean
   is
      Restriction_Name : constant String:="Consistent Transaction Graph";
      Trans_Name : constant String:="Transaction: "&
        To_String(Mast.Transactions.Name(Trans_Ref));
      A_Link_Ref : Mast.Graphs.Link_Ref;
      An_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref;
      Visited_Links_List : Mast.Graphs.Link_Lists.List;
      Visited_Event_Handlers_List : Mast.Graphs.Event_Handler_Lists.List;
      Initial_Event_Handler : Graphs.Event_Handler_Ref;

      Circular_Dependency : exception;

      procedure Add_To_Visited
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref) is
         pragma Unreferenced (Trans_Ref);
      begin
         Mast.Graphs.Link_Lists.Add(The_Link_Ref,Visited_Links_List);
      end Add_To_Visited;

      procedure Add_To_Visited
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref)
      is
         pragma Unreferenced (Trans_Ref);
         The_Index : Mast.Graphs.Event_Handler_Lists.Index;
      begin
         The_Index:=Mast.Graphs.Event_Handler_Lists.Find
           (The_Event_Handler_Ref,Visited_Event_Handlers_List);
         if The_Index=Mast.Graphs.Event_Handler_Lists.Null_Index then
            Mast.Graphs.Event_Handler_Lists.Add
              (The_Event_Handler_Ref,Visited_Event_Handlers_List);
         else
            raise List_Exceptions.Already_Exists;
         end if;
      end Add_To_Visited;

      procedure Iterate_Transaction_Paths is new
        Mast.Transaction_Operations.Traverse_Paths_From_Link_Once
        (Operation_For_Links  => Add_To_Visited,
         Operation_For_Event_Handlers => Add_To_Visited);

      procedure Check_Circular_Dependencies
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref) is
         pragma Unreferenced (Trans_Ref);
      begin
         if The_Link_Ref/=null and then
           Graphs.Output_Event_Handler(The_Link_Ref.all)=
           Initial_Event_Handler
         then
            raise Circular_Dependency;
         end if;
      end Check_Circular_Dependencies;

      procedure Check_Circular_Dependencies
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref) is
      begin
         null;
      end Check_Circular_Dependencies;

      procedure Iterate_From_Input_Event_Handler is new
        Mast.Transaction_Operations.Traverse_Paths_From_Link_Once
        (Operation_For_Links  => Check_Circular_Dependencies,
         Operation_For_Event_Handlers => Check_Circular_Dependencies);

      function Message_Ops_On_Network
        (Op_Ref : Operations.Operation_Ref;
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref)
        return Boolean
      is
         Iterator : Operations.Operation_Iteration_Object;
         An_Op_Ref : Operations.Operation_Ref;
      begin
         if Op_Ref.all in
           Operations.Simple_Operation'Class
         then
            return True;
         elsif Op_Ref.all in
           Operations.Composite_Operation'Class
         then
            -- iterate for internal operations
            Operations.Rewind_Operations
              (Operations.Composite_Operation'Class(Op_Ref.all),Iterator);
            for I in 1..Operations.Num_Of_Operations
              (Operations.Composite_Operation'Class(Op_Ref.all))
            loop
               Operations.Get_Next_Operation
                 (Operations.Composite_Operation'Class(Op_Ref.all),
                  An_Op_Ref,Iterator);
               if not Message_Ops_On_Network(An_Op_Ref,Srvr_Ref) then
                  return False;
               end if;
            end loop;
            return True;
         elsif Op_Ref.all in
           Operations.Message_Transmission_Operation'Class
         then
            begin
               if Scheduling_Servers.Server_Processing_Resource
                 (Srvr_Ref.all).all not in
                 Processing_Resources.Network.Network'Class
               then
                  return False;
               end if;
            exception
               when Incorrect_Object =>
                  return False;
            end;
            return True;
         else
            raise Incorrect_Object;
         end if;
      end Message_Ops_On_Network;

      function Message_Size_OK
        (Op_Ref : Operations.Operation_Ref;
         Network_Ref : Processing_Resources.Network.Network_Ref;
         Processor_Ref : Processing_Resources.Processor.Processor_Ref)
        return Boolean
      is
         Drv_Ref : Drivers.Driver_Ref;
         Drv_Iter : Processing_Resources.Network.Driver_Iteration_Object;
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Proc_Ref : Processing_Resources.Processing_Resource_Ref;
         The_Throughput : constant Throughput_Value:=
           Processing_Resources.Network.Throughput(Network_Ref.all);
      begin
         if Network_Ref.all in
           Processing_Resources.Network.Packet_Based_Network'class
         then
            Processing_Resources.Network.Rewind_Drivers
              (Network_Ref.all,Drv_Iter);
            for I in 1..Processing_Resources.Network.Num_Of_Drivers
              (Network_Ref.all)
            loop
               Processing_Resources.Network.Get_Next_Driver
                 (Network_Ref.all,Drv_Ref,Drv_Iter);
               if Drv_Ref.all in Drivers.Packet_Driver'Class then
                  Srvr_Ref := Drivers.Packet_Server
                    (Drivers.Packet_Driver'Class(Drv_Ref.all));
                  if Srvr_Ref /= null then
                     Proc_Ref:=Scheduling_Servers.Server_Processing_Resource
             (Srvr_Ref.all);
                     if  Proc_Ref.all in
             Processing_Resources.Processor.Processor'Class and then
             Processing_Resources.Processor.Processor_Ref(Proc_Ref) =
             Processor_Ref
           then
         if not Drivers.Message_Partitioning
           (Drivers.Packet_Driver'Class(Drv_Ref.all))
         then
            return Operations.Worst_Case_Execution_Time
              (Op_Ref.all,The_Throughput) <=
              Processing_Resources.Network.
              Max_Packet_Transmission_Time
              (Processing_Resources.Network.Packet_Based_Network
            (Network_Ref.all));
         else
            return True;
         end if;
                     end if;
                  end if;
               else
                  raise Incorrect_Object;
               end if;
            end loop;
            -- No driver found means that the message size is not limited
            return True;
         else
            raise Incorrect_Object;
         end if;
      end Message_Size_OK;

      function Message_Size_OK_In_Sender
        (Op_Ref : Operations.Operation_Ref;
         Net_Ref : Processing_Resources.Network.Network_Ref;
         An_Event_Handler_Ref : Graphs.Event_Handler_Ref)
        return Boolean
      is
         Prev_Ev_Hdler_Ref : Graphs.Event_Handler_Ref;
         Prev_Link_Ref : Graphs.Link_Ref;
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Proc_Ref : Processing_Resources.Processing_Resource_Ref;
         Processor_Ref : Processing_Resources.Processor.Processor_Ref;
         Iter : Graphs.Event_Handlers.Iteration_Object;
      begin
         if An_Event_Handler_Ref.all in
           Graphs.Event_Handlers.Input_Event_Handler'Class
         then
            Graphs.Event_Handlers.Rewind_Input_Links
              (Graphs.Event_Handlers.Input_Event_Handler'Class
       (An_Event_Handler_Ref.all),Iter);
            for I in 1..Graphs.Event_Handlers.Num_Of_Input_Links
              (Graphs.Event_Handlers.Input_Event_Handler'Class
       (An_Event_Handler_Ref.all))
            loop
               Graphs.Event_Handlers.Get_Next_Input_Link
                 (Graphs.Event_Handlers.Input_Event_Handler'Class
          (An_Event_Handler_Ref.all),Prev_Link_Ref,Iter);
               if Prev_Link_Ref/=null then
                  Prev_Ev_Hdler_Ref:=Graphs.Input_Event_Handler
                    (Prev_Link_Ref.all);
                  if Prev_Ev_Hdler_Ref/=null then
                     if Prev_Ev_Hdler_Ref.all in
                       Graphs.Event_Handlers.Activity'Class
                     then
                        Srvr_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
                          (Mast.Graphs.Event_Handlers.Activity'class
              (Prev_Ev_Hdler_Ref.all));
                        if Srvr_Ref/=null then
                           Proc_Ref:=
                             Scheduling_Servers.Server_Processing_Resource
                             (Srvr_Ref.all);
                           if Proc_Ref/=null and then Proc_Ref.all in
                             Processing_Resources.Processor.Processor'Class
                           then
                              Processor_Ref:=
                                Processing_Resources.Processor.Processor_Ref
                                (Proc_Ref);
                              if not Message_Size_OK
                                (Op_Ref,Net_Ref,Processor_Ref)
                              then
                                 return False;
                              end if;
                           end if;
                        end if;
                     else
                        if not Message_Size_OK_In_Sender
                          (Op_Ref,Net_Ref,Prev_Ev_Hdler_Ref)
                        then
                           return False;
                        end if;
                     end if;
                  end if;
               end if;
            end loop;
            -- If control reaches here all sizes have already been checked
            return True;
         else
            if An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Simple_Event_Handler'Class
            then
               Prev_Link_Ref:=Graphs.Event_Handlers.Input_Link
                 (Graphs.Event_Handlers.Simple_Event_Handler'Class
          (An_Event_Handler_Ref.all));
            elsif An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Output_Event_Handler'Class
            then
               Prev_Link_Ref:=Graphs.Event_Handlers.Input_Link
                 (Graphs.Event_Handlers.Output_Event_Handler'Class
          (An_Event_Handler_Ref.all));
            else
               raise Incorrect_Object;
            end if;
            if Prev_Link_Ref/=null then
               Prev_Ev_Hdler_Ref:=Graphs.Input_Event_Handler
                 (Prev_Link_Ref.all);
               if Prev_Ev_Hdler_Ref/=null then
                  if Prev_Ev_Hdler_Ref.all in
                    Graphs.Event_Handlers.Activity'Class
                  then
                     Srvr_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
                       (Mast.Graphs.Event_Handlers.Activity'class
           (Prev_Ev_Hdler_Ref.all));
                     if Srvr_Ref/=null then
                        Proc_Ref:=
                          Scheduling_Servers.Server_Processing_Resource
                          (Srvr_Ref.all);
                        if Proc_Ref/=null and then Proc_Ref.all in
                          Processing_Resources.Processor.Processor'Class
                        then
                           Processor_Ref:=
                             Processing_Resources.Processor.Processor_Ref
                             (Proc_Ref);
                           return Message_Size_OK
                             (Op_Ref,Net_Ref,Processor_Ref);
                        else
                           return True;
                        end if;
                     else
                        return True;
                     end if;
                  else
                     return Message_Size_OK_In_Sender
                       (Op_Ref,Net_Ref,Prev_Ev_Hdler_Ref);
                  end if;
               else
                  return True;
               end if;
            else
               return True;
            end if;
         end if;
      end Message_Size_OK_In_Sender;

      function Message_Size_OK_In_Receiver
        (Op_Ref : Operations.Operation_Ref;
         Net_Ref : Processing_Resources.Network.Network_Ref;
         An_Event_Handler_Ref : Graphs.Event_Handler_Ref)
        return Boolean
      is
         Post_Ev_Hdler_Ref : Graphs.Event_Handler_Ref;
         Post_Link_Ref : Graphs.Link_Ref;
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Proc_Ref : Processing_Resources.Processing_Resource_Ref;
         Processor_Ref : Processing_Resources.Processor.Processor_Ref;
         Iter : Graphs.Event_Handlers.Iteration_Object;
      begin
         if An_Event_Handler_Ref.all in
           Graphs.Event_Handlers.Output_Event_Handler'Class
         then
            Graphs.Event_Handlers.Rewind_Output_Links
              (Graphs.Event_Handlers.Output_Event_Handler'Class
       (An_Event_Handler_Ref.all),Iter);
            for I in 1..Graphs.Event_Handlers.Num_Of_Output_Links
              (Graphs.Event_Handlers.Output_Event_Handler'Class
       (An_Event_Handler_Ref.all))
            loop
               Graphs.Event_Handlers.Get_Next_Output_Link
                 (Graphs.Event_Handlers.Output_Event_Handler'Class
          (An_Event_Handler_Ref.all),Post_Link_Ref,Iter);
               if Post_Link_Ref/=null then
                  Post_Ev_Hdler_Ref:=Graphs.Output_Event_Handler
                    (Post_Link_Ref.all);
                  if Post_Ev_Hdler_Ref/=null then
                     if Post_Ev_Hdler_Ref.all in
                       Graphs.Event_Handlers.Activity'Class
                     then
                        Srvr_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
                          (Mast.Graphs.Event_Handlers.Activity'class
              (Post_Ev_Hdler_Ref.all));
                        if Srvr_Ref/=null then
                           Proc_Ref:=
                             Scheduling_Servers.Server_Processing_Resource
                             (Srvr_Ref.all);
                           if Proc_Ref/=null and then Proc_Ref.all in
                             Processing_Resources.Processor.Processor'Class
                           then
                              Processor_Ref:=
                                Processing_Resources.Processor.Processor_Ref
                                (Proc_Ref);
                              if not Message_Size_OK
                                (Op_Ref,Net_Ref,Processor_Ref)
                              then
                                 return False;
                              end if;
                           end if;
                        end if;
                     else
                        if not Message_Size_OK_In_Receiver
                          (Op_Ref,Net_Ref,Post_Ev_Hdler_Ref)
                        then
                           return False;
                        end if;
                     end if;
                  end if;
               end if;
            end loop;
            -- If control reaches here all sizes have already been checked
            return True;
         else
            if An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Simple_Event_Handler'Class
            then
               Post_Link_Ref:=Graphs.Event_Handlers.Output_Link
                 (Graphs.Event_Handlers.Simple_Event_Handler'Class
          (An_Event_Handler_Ref.all));
            elsif An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Input_Event_Handler'Class
            then
               Post_Link_Ref:=Graphs.Event_Handlers.Output_Link
                 (Graphs.Event_Handlers.Input_Event_Handler'Class
          (An_Event_Handler_Ref.all));
            else
               raise Incorrect_Object;
            end if;
            if Post_Link_Ref/=null then
               Post_Ev_Hdler_Ref:=Graphs.Output_Event_Handler
                 (Post_Link_Ref.all);
               if Post_Ev_Hdler_Ref/=null then
                  if Post_Ev_Hdler_Ref.all in
                    Graphs.Event_Handlers.Activity'Class
                  then
                     Srvr_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
                       (Mast.Graphs.Event_Handlers.Activity'class
           (Post_Ev_Hdler_Ref.all));
                     if Srvr_Ref/=null then
                        Proc_Ref:=
                          Scheduling_Servers.Server_Processing_Resource
                          (Srvr_Ref.all);
                        if Proc_Ref/=null and then Proc_Ref.all in
                          Processing_Resources.Processor.Processor'Class
                        then
                           Processor_Ref:=
                             Processing_Resources.Processor.Processor_Ref
                             (Proc_Ref);
                           return Message_Size_OK
                             (Op_Ref,Net_Ref,Processor_Ref);
                        else
                           return True;
                        end if;
                     else
                        return True;
                     end if;
                  else
                     return Message_Size_OK_In_Receiver
                       (Op_Ref,Net_Ref,Post_Ev_Hdler_Ref);
                  end if;
               else
                  return True;
               end if;
            else
               return True;
            end if;
         end if;
      end Message_Size_OK_In_Receiver;

      Link_Iterator : Transactions.Link_Iteration_Object;
      Event_Iterator : Transactions.Event_Handler_Iteration_Object;
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Op_Ref : Operations.Operation_Ref;
      Ev_Ref : Events.Event_Ref;

   begin
      -- Rule 1: At least one input Link
      if Transactions.Num_Of_External_Event_Links(Trans_Ref.all)=0 then
         Message(Verbose,Restriction_Name,Trans_Name,
                 "Rule 1 not met: No input Links");
         return False;
      end if;
      -- Loop for all external event links, to check rules 2, 26, 26a
      Mast.Transactions.Rewind_External_Event_Links
        (Trans_Ref.all,Link_Iterator);
      for I in 1..Mast.Transactions.Num_Of_External_Event_Links
        (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_External_Event_Link
           (Trans_Ref.all,A_Link_Ref,Link_Iterator);
         -- Rule 2: Each input Link directed at one Event_Handler,
         -- and with an external event
         if Mast.Graphs.Output_Event_Handler(A_Link_Ref.all)=null or else
           Graphs.Event_Of(A_Link_Ref.all)=null
         then
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 2 not met: input Link has no Event_Handler, "&
                      "or has no external event",
                    "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
            return False;
         else
            Ev_Ref:=Graphs.Event_Of(A_Link_Ref.all);
            if Ev_Ref.all in Events.Periodic_Event'Class and then
              Events.Period(Events.Periodic_Event'Class(Ev_Ref.all))=0.0
            then
               Message(Verbose,"Consistency Checks",Trans_Name,
                       "Rule 26 not met: Transaction has null period",
                       "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
               return False;
            elsif Ev_Ref.all in Events.Sporadic_Event'Class and then
              Events.Min_Interarrival
              (Events.Sporadic_Event'Class(Ev_Ref.all))=0.0
            then
               Message
                 (Verbose,"Consistency Checks",Trans_Name,
                  "Rule 26a not met: Transaction has null Min_Interarrival",
                  "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
               return False;
            end if;
         end if;
      end loop;
      -- Loop for all internal event links, to check rule 3
      Mast.Transactions.Rewind_Internal_Event_Links
        (Trans_Ref.all,Link_Iterator);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links
        (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,A_Link_Ref,Link_Iterator);
         -- Rule 3: Each non-input Link comes from a Event_Handler
         if Mast.Graphs.Input_Event_Handler(A_Link_Ref.all)=null then
            Message
              (Verbose,Restriction_Name,Trans_Name,
               "Rule 3 not met: non-input Link has no "&
       "input Event_Handler",
               "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
            return False;
         end if;
      end loop;

      -- Loop for all Event_Handlers, to check Rules 4, 5, 6, 10,
      --   11, 22, 25 and 14

      Mast.Transactions.Rewind_Event_Handlers
        (Trans_Ref.all,Event_Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Event_Iterator);
         -- Rule 4: Each simple Event_Handler has an input Link
         --   and an output Link
         if An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Simple_Event_Handler'Class
         then
            if Mast.Graphs.Event_Handlers.Input_Link
              (Mast.Graphs.Event_Handlers.Simple_Event_Handler
       (An_Event_Handler_Ref.all))=null or else
              Mast.Graphs.Event_Handlers.Output_Link
              (Mast.Graphs.Event_Handlers.Simple_Event_Handler
       (An_Event_Handler_Ref.all))=null
            then
               Message
                 (Verbose,Restriction_Name,Trans_Name,
                  "Rule 4 not met: Simple Event_Handler has no "&
          "input link or no output Link");
               return False;
            end if;
            -- Rule 10: All Activities have an operation
            -- Rule 11: All Activities have a scheduling server
            if An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Activity'Class
            then
               Op_Ref:=Mast.Graphs.Event_Handlers.Activity_Operation
                 (Mast.Graphs.Event_Handlers.Activity
          (An_Event_Handler_Ref.all));
               Srvr_Ref:=Mast.Graphs.Event_Handlers.Activity_Server
                 (Mast.Graphs.Event_Handlers.Activity
          (An_Event_Handler_Ref.all));
               if Op_Ref=null then
                  Message
                    (Verbose,Restriction_Name,Trans_Name,
                     "Rule 10 not met: Activity has no operation");
                  return False;
               else
                  -- Rule 22: All Message Transmission Operations are
                  --          executed by scheduling servers executing
                  --          on a network
                  if not Message_Ops_On_Network(Op_Ref, Srvr_Ref)
                  then
                     Message
                       (Verbose,Restriction_Name,Trans_Name,
                        "Rule 22 not met: Message operation "&
           To_String(Operations.Name(Op_Ref))&
           " is not executed on a network");
                     return False;
                  end if;
                  -- Rule 25: The size of each message sent through a network
                  --          driver that does not support message
                  --          partitioning is smaller than the
                  --          maximum allowable message size
                  if Srvr_Ref/=null then
                     declare
                        Sch_Ref : Schedulers.Scheduler_Ref;
                        Proc_Ref :
                          Processing_Resources.Processing_Resource_Ref;
                        Net_Ref : Processing_Resources.Network.Network_Ref;
                     begin
                        Sch_Ref:=Scheduling_Servers.Server_Scheduler
                          (Srvr_Ref.all);
                        if Sch_Ref/=null and then Sch_Ref.all in
                          Schedulers.Primary.Primary_Scheduler
                        then
                           Proc_Ref:=Schedulers.Primary.Host
                             (Schedulers.Primary.Primary_Scheduler'Class
            (Sch_Ref.all));
                           if Proc_Ref/=null and then Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Net_Ref:=Processing_Resources.Network.Network_Ref
                                (Proc_Ref);
                              if (not Message_Size_OK_In_Sender
                (Op_Ref,Net_Ref,An_Event_Handler_Ref))
                                or else
                                (not Message_Size_OK_In_Receiver
               (Op_Ref,Net_Ref,An_Event_Handler_Ref))
                              then
                                 Message
                                   (Verbose,Restriction_Name,Trans_Name,
                                    "Rule 25 not met: Message size of "&
                  To_String(Operations.Name(Op_Ref))&
                  " too large for network driver");
                                 return False;
                              end if;
                           end if;
                        end if;
                     end;
                  end if;
               end if;
               if Srvr_Ref=null then
                  Message
                    (Verbose,Restriction_Name,Trans_Name,
                     "Rule 11 not met: Activity has no scheduling server");
                  return False;
               end if;
            elsif An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Delay_Event_Handler'Class or else
              An_Event_Handler_Ref.all in
              Mast.Graphs.Event_Handlers.Rate_Divisor'Class
            then
               -- Rule 14: All rate divisors, offset and delay event handlers
               --          are only followed by activities
               declare
                  Out_Lnk: constant Graphs.Link_Ref:=
                    Mast.Graphs.Event_Handlers.Output_Link
                    (Mast.Graphs.Event_Handlers.Simple_Event_Handler
             (An_Event_Handler_Ref.all));
                  Next_Evnt_Hdlr: constant Graphs.Event_Handler_Ref:=
                    Mast.Graphs.Output_Event_Handler(Out_Lnk.all);
               begin
                  if Next_Evnt_Hdlr=null or else not
                    (Next_Evnt_Hdlr.all in
                       Graphs.Event_Handlers.Activity'Class)
                  then
                     Message
                       (Verbose,Restriction_Name,Trans_Name,
                        "Rule 14 not met: Rate Divisor, Delay, or Offest"&
           " are not followed by activity");
                     return False;
                  end if;
               end;
            end if;
         elsif An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Input_Event_Handler'Class
         then
            -- Rule 5: Each input Event_Handler has 2 or more input
            --         links and an output Link
            if Mast.Graphs.Event_Handlers.Num_Of_Input_Links
              (Mast.Graphs.Event_Handlers.Input_Event_Handler
       (An_Event_Handler_Ref.all))<=1 or else
              Mast.Graphs.Event_Handlers.Output_Link
              (Mast.Graphs.Event_Handlers.Input_Event_Handler
       (An_Event_Handler_Ref.all))=null
            then
               Message
                 (Verbose,Restriction_Name,Trans_Name,
                  "Rule 5 not met: Input Event_Handler has <2 "&
          "input links or no output Link");
               return False;
            end if;
         elsif An_Event_Handler_Ref.all in
           Mast.Graphs.Event_Handlers.Output_Event_Handler'Class
         then
            -- Rule 6: Each output Event_Handler has 2 or more
            --         output Links and an input Link
            if Mast.Graphs.Event_Handlers.Num_Of_Output_Links
              (Mast.Graphs.Event_Handlers.Output_Event_Handler
       (An_Event_Handler_Ref.all))<=1 or else
              Mast.Graphs.Event_Handlers.Input_Link
              (Mast.Graphs.Event_Handlers.Output_Event_Handler
       (An_Event_Handler_Ref.all))=null
            then
               Message
                 (Verbose,Restriction_Name,Trans_Name,
                  "Rule 6 not met: Output Event_Handler has <2 "&
          "output links or no input Link");
               return False;
            end if;
         else
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Unknown Event_Handler Type");
            return False;
         end if;
      end loop;

      -- loop for all paths starting from input Links
      Mast.Transactions.Rewind_External_Event_Links
        (Trans_Ref.all,Link_Iterator);
      begin
         for I in 1..Mast.Transactions.Num_Of_External_Event_Links
           (Trans_Ref.all)
         loop
            Mast.Transactions.Get_Next_External_Event_Link
              (Trans_Ref.all,A_Link_Ref,Link_Iterator);
            Iterate_Transaction_Paths (Trans_Ref,A_Link_Ref);
         end loop;
      exception
         when List_Exceptions.Already_Exists =>
            -- Rule 7: No circular dependencies
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 7 not met: Circular dependecy");
            return False;
      end;

      -- Check circular dependencies for Input Event Handlers
      Mast.Transactions.Rewind_Event_Handlers
        (Trans_Ref.all,Event_Iterator);
      begin
         for I in 1..Mast.Transactions.Num_Of_Event_Handlers
           (Trans_Ref.all)
         loop
            Mast.Transactions.Get_Next_Event_Handler
              (Trans_Ref.all,Initial_Event_Handler,Event_Iterator);
            if Initial_Event_Handler.all in
              Graphs.Event_Handlers.Input_Event_Handler'Class
            then
               Iterate_From_Input_Event_Handler
                 (Trans_Ref,Graphs.
          Event_Handlers.Output_Link
          (Graphs.Event_Handlers.Input_Event_Handler
             (Initial_Event_Handler.all)));
            end if;
         end loop;
      exception
         when Circular_Dependency =>
            -- Rule 7: No circular dependencies
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 7 not met: Circular dependecy");
            return False;
      end;

      -- Loop for all external event Links, to check Rule 8
      Mast.Transactions.Rewind_External_Event_Links
        (Trans_Ref.all,Link_Iterator);
      for I in 1..Mast.Transactions.Num_Of_External_Event_Links
        (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_External_Event_Link
           (Trans_Ref.all,A_Link_Ref,Link_Iterator);
         -- Rule 8: No isolated Links
         if Mast.Graphs.Link_Lists.Find
           (Mast.Graphs.Name(A_Link_Ref),Visited_Links_List)=
           Mast.Graphs.Link_Lists.Null_Index
         then
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 8 not met: isolated Link, ",
                    "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
            return False;
         end if;
      end loop;

      -- Loop for all internal event Links, to check Rule 8
      Mast.Transactions.Rewind_Internal_Event_Links
        (Trans_Ref.all,Link_Iterator);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links
        (Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans_Ref.all,A_Link_Ref,Link_Iterator);
         -- Rule 8: No isolated Links
         if Mast.Graphs.Link_Lists.Find
           (Mast.Graphs.Name(A_Link_Ref),Visited_Links_List)=
           Mast.Graphs.Link_Lists.Null_Index
         then
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 8 not met: isolated Link, ",
                    "Link: "&To_String(Mast.Graphs.Name(A_Link_Ref)));
            return False;
         end if;
      end loop;

      -- Loop for all Event_Handlers, to check Rule 9
      Mast.Transactions.Rewind_Event_Handlers
        (Trans_Ref.all,Event_Iterator);
      for I in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
      loop
         Mast.Transactions.Get_Next_Event_Handler
           (Trans_Ref.all,An_Event_Handler_Ref,Event_Iterator);
         -- Rule 9: No isolated Event_Handlers
         if Mast.Graphs.Event_Handler_Lists.Find
           (An_Event_Handler_Ref,Visited_Event_Handlers_List)=
           Mast.Graphs.Event_Handler_Lists.Null_Index
         then
            Message(Verbose,Restriction_Name,Trans_Name,
                    "Rule 9 not met: isolated Event_Handler, ");
            return False;
         end if;
      end loop;

      -- All consistency checks met
      return True;
   end Consistent_Transaction_Graphs;

   -----------------------------------
   -- Consistent_Transaction_Graphs --
   -----------------------------------

   function Consistent_Transaction_Graphs
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Index;
   begin
      -- Loop for every transaction
      Mast.Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size(The_System.Transactions) loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if not Consistent_Transaction_Graphs(Trans_Ref,Verbose) then
            return False;
         end if;
      end loop;

      -- loop for all schedulers to check for rules 15-17,23-24
      declare
         Restriction_Name : constant String:="Consistent Transaction Graph";
         Iterator : Schedulers.Lists.Iteration_Object;
         Sched_Ref : Schedulers.Scheduler_Ref;
         Host_Ref : Processing_Resources.Processing_Resource_Ref;
         Proc_List : Processing_Resources.Lists.List;
         SS_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         SS_List : Scheduling_Servers.Lists.List;
      begin
         Schedulers.Lists.Rewind(The_System.Schedulers,Iterator);
         for I in 1..Schedulers.Lists.Size(The_System.Schedulers) loop
            Schedulers.Lists.Get_Next_Item
              (Sched_Ref,The_System.Schedulers,Iterator);
            declare
               Sched_Name : constant String:="Scheduler: "&
                 To_String(Mast.Schedulers.Name(Sched_Ref));
            begin
               if Sched_Ref.all in
                 Schedulers.Primary.Primary_Scheduler'Class
               then
                  -- Rule 15: All primary schedulers have a processing resource
                  Host_Ref:=Schedulers.Primary.Host
                    (Schedulers.Primary.Primary_Scheduler'Class
             (Sched_Ref.all));
                  if Host_Ref=null then
                     Message(Verbose,Restriction_Name,Sched_Name,
                             "Rule 15 not met: Primary scheduler has no "&
                "processing resource");
                     return False;
                  else
                     -- Rule 23: Each processing resource has at most
                     --          one primary scheduler
                     begin
                        Processing_Resources.Lists.Add(Host_Ref,Proc_List);
                     exception
                        when List_Exceptions.Already_Exists =>
                           Message(Verbose,Restriction_Name,Sched_Name,
                                   "Rule 23 not met: Two primary schedulers "&
                 "have the same processing resource");
                           return False;
                     end;
                  end if;
               elsif Sched_Ref.all in
                 Schedulers.Secondary.Secondary_Scheduler'Class
               then
                  -- Rule 16: All secondary schedulers have a scheduling server
                  SS_Ref:=Schedulers.Secondary.Server
                    (Schedulers.Secondary.Secondary_Scheduler'Class
             (Sched_Ref.all));
                  if SS_Ref=null then
                     Message(Verbose,Restriction_Name,Sched_Name,
                             "Rule 16 not met: Secondary scheduler has no "&
                "scheduling server");
                     return False;
                  else
                     -- Rule 24: Each scheduling server has at most
                     --          one secondary scheduler
                     begin
                        Scheduling_Servers.Lists.Add(SS_Ref,SS_List);
                     exception
                        when List_Exceptions.Already_Exists =>
                           Message(Verbose,Restriction_Name,Sched_Name,
                                   "Rule 24 not met: Two secondary schedulers"&
                 " have the same scheduling server");
                           return False;
                     end;
                  end if;
               else
                  raise Incorrect_Object;
               end if;

               -- Rule 17: All Schedulers have a scheduling policy
               if Schedulers.Scheduling_Policy(Sched_Ref.all)=null then
                  Message(Verbose,Restriction_Name,Sched_Name,
                          "Rule 17 not met: Scheduler has no "&
             "scheduling policy");
                  return False;
               end if;
               -- Rule 18: All scheduling policies of the type
               --          FP_Packet_Based are associated with a primary
               --          scheduler located on a network
               if Schedulers.Scheduling_Policy(Sched_Ref.all).all in
                 Scheduling_Policies.FP_Packet_Based'Class
               then
                  if not (Sched_Ref.all in
             Schedulers.Primary.Primary_Scheduler'Class
             and then
             Schedulers.Primary.Host
             (Schedulers.Primary.Primary_Scheduler'Class
                (Sched_Ref.all)).all in
             Processing_Resources.Network.Network'Class)
                  then
                     Message(Verbose,Restriction_Name,Sched_Name,
                             "Rule 18 not met: Schedulers with Packet_Based "&
                "policy not assigned to a network");
                     return False;
                  end if;
               else
                  -- Rule 27: All scheduling policies of a type that is not
                  --          FP_Packet_Based and associated with a primary
                  --          scheduler must be located on a processor
                  if Sched_Ref.all in
                    Schedulers.Primary.Primary_Scheduler'Class
                    and then
          not (Schedulers.Primary.Host
            (Schedulers.Primary.Primary_Scheduler'Class
               (Sched_Ref.all)).all in
            Processing_Resources.Processor.Processor'Class)
                  then
                     Message(Verbose,Restriction_Name,Sched_Name,
                             "Rule 27 not met: Primary schedulers with non "&
                "Packet_Based policy not assigned to a"&
                " processor");
                     return False;
                  end if;
               end if;
            end;
         end loop;
      end;

      declare
         Restriction_Name : constant String:="Consistent Transaction Graph";
         Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Srvr_Iterator : Scheduling_Servers.Lists.Iteration_Object;
         Sched_Ref : Schedulers.Scheduler_Ref;
         Sch_Params_Ref : Scheduling_Parameters.Sched_Parameters_Ref;
      begin
         -- Loop for every Scheduling Server to check rules 12, 13, 19, 20,
         --  21, 26c, 26d
         Mast.Scheduling_Servers.Lists.Rewind
           (The_System.Scheduling_Servers,Srvr_Iterator);
         for I in 1..Mast.Scheduling_Servers.Lists.Size
           (The_System.Scheduling_Servers)
         loop
            Mast.Scheduling_Servers.Lists.Get_Next_Item
              (Srvr_Ref,The_System.Scheduling_Servers,Srvr_Iterator);
            declare
               Srvr_Name : constant String:="Scheduling Server: "&
                 To_String(Mast.Scheduling_Servers.Name(Srvr_Ref));
            begin
               -- Rule 12: All scheduling servers have a scheduler
               Sched_Ref:=Scheduling_Servers.Server_Scheduler(Srvr_Ref.all);
               if Sched_Ref=null then
                  Message(Verbose,Restriction_Name,Srvr_Name,
                          "Rule 12 not met: Server has no scheduler");
                  return False;
               end if;
               -- Rule 13: All Scheduling servers have scheduling parameters
               Sch_Params_Ref:=Scheduling_Servers.Server_Sched_Parameters
                 (Srvr_Ref.all);
               if Sch_Params_Ref=null then
                  Message(Verbose,Restriction_Name,Srvr_Name,
                          "Rule 13 not met: Server has no "&
             "scheduling_parameters");
                  return False;
               end if;
               if Sch_Params_Ref.all in
                 Scheduling_Parameters.Fixed_Priority_Parameters'Class
               then
                  -- Rule 19: All scheduling servers with parameters of the FP
                  -- family are associated with schedulers having a policy of
                  -- the FP family
                  if not (Schedulers.Scheduling_Policy(Sched_Ref.all).all in
             Scheduling_Policies.Fixed_Priority_Policy'Class)
                  then
                     Message(Verbose,Restriction_Name,Srvr_Name,
                             "Rule 19 not met: Server FP parameters are "&
                "incompatible with schedulers's sched policy");
                     return False;
                  end if;

                  -- Rule 21: All scheduling servers with parameters of the
                  -- type Interrupt_FP_Policy are associated with primary
                  -- schedulers
                  if Sch_Params_Ref.all in
                    Scheduling_Parameters.Interrupt_FP_Policy'Class and then
                    Sched_Ref.all not in
                    Schedulers.Primary.Primary_Scheduler'class
                  then
                     Message(Verbose,Restriction_Name,Srvr_Name,
                             "Rule 21 not met: Server Interrupt_FP params "&
                "not associated with primary scheduler");
                     return False;
                  end if;

                  -- check rules 26c and 26d
                  if Sch_Params_Ref.all in
                    Scheduling_Parameters.Polling_Policy'Class
                  then
                     if Scheduling_Parameters.Polling_Policy'Class
                       (Sch_Params_Ref.all).Polling_Period=0.0
                     then
                        Message(Verbose,Restriction_Name,Srvr_Name,
                                "Rule 26c not met: Polling Period "&
                                  "is zero");
                        return False;
                     end if;
                  elsif Sch_Params_Ref.all in
                    Scheduling_Parameters.Sporadic_Server_Policy'Class
                  then
                     if Scheduling_Parameters.Sporadic_Server_Policy'Class
                       (Sch_Params_Ref.all).Replenishment_Period=0.0
                     then
                        Message(Verbose,Restriction_Name,Srvr_Name,
                                "Rule 26d not met: Replenishment Period "&
                                  "is zero");
                        return False;
                     end if;
                  end if;

               elsif Sch_Params_Ref.all in
                 Scheduling_Parameters.EDF_Parameters'Class
               then

                  -- Rule 20: All scheduling servers with parameters of the EDF
                  -- family are associated with schedulers having a policy of
                  -- the EDF family
                  if not (Schedulers.Scheduling_Policy(Sched_Ref.all).all in
             Scheduling_Policies.EDF_Policy'Class)
                  then
                     Message(Verbose,Restriction_Name,Srvr_Name,
                             "Rule 20 not met: Server EDF parameters are "&
                "incompatible with schedulers's sched policy");
                     return False;
                  end if;
               else
                  raise Incorrect_Object;
               end if;

            end;
         end loop;
      end;

      declare
         Restriction_Name : constant String:="Consistent Transaction Graph";
         Res_Ref : Processing_Resources.Processing_Resource_Ref;
         Timer_Ref : Timers.System_Timer_Ref;
         Iterator : Processing_Resources.Lists.Index;
      begin
         -- loop for all processing resources to check rule 26b
         Processing_Resources.Lists.Rewind
           (The_System.Processing_Resources,Iterator);
         for I in 1..Processing_Resources.Lists.Size
           (The_System.Processing_Resources)
         loop
            Processing_Resources.Lists.Get_Next_Item
              (Res_Ref,The_System.Processing_Resources,Iterator);
            if Res_Ref.all in
              Processing_Resources.Processor.Regular_Processor'Class
            then
               Timer_Ref:=Processing_Resources.Processor.The_System_Timer
                 (Processing_Resources.Processor.Regular_Processor'Class
                    (Res_Ref.all));
               if Timer_Ref/=null then
                  if Timer_Ref.all in Timers.Ticker'Class then
                     if Timers.Period(Timers.Ticker'Class(Timer_Ref.all))=0.0
                     then
                        Message(Verbose,Restriction_Name,
                                To_String(Res_Ref.Name),
                                "Rule 26b not met: Ticker period is zero");
                        return False;
                     end if;
                  end if;
               end if;
            end if;
         end loop;
      end;

      -- All consistency checks met
      return True;
   end Consistent_Transaction_Graphs;
   
   
   -----------------------------
   -- Priorities_Are_In_Range --
   -----------------------------

   function Priorities_Are_In_Range
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True)
     return Boolean
   is

      function Priorities_Are_In_Range
        (Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
         Verbose : Boolean := True)
        return Boolean
      is
         Max_Int_Prio,Min_Int_Prio,Max_Prio,Min_Prio : Priority;
         Proc_Ref : Processing_Resources.Processing_Resource_Ref;
         Sched_Policy_Ref : Scheduling_Policies.Scheduling_Policy_Ref;
         Sched_Param_Ref : Scheduling_Parameters.Sched_Parameters_Ref;
      begin
         if Scheduling_Servers.Server_Scheduler(Srvr_Ref.all).all in
           Schedulers.Primary.Primary_Scheduler'Class
         then
            Proc_Ref:=Scheduling_Servers.Server_Processing_Resource
              (Srvr_Ref.all);
         end if;
         Sched_Policy_Ref:=Schedulers.Scheduling_Policy
           (Scheduling_Servers.Server_Scheduler
         (Srvr_Ref.all).all);
         if Sched_Policy_Ref.all in
           Scheduling_Policies.Fixed_Priority_Policy'Class
         then
            Max_Prio:=Scheduling_Policies.Max_Priority
              (Scheduling_Policies.Fixed_Priority_Policy'Class
       (Sched_Policy_Ref.all));
            Min_Prio:=Scheduling_Policies.Min_Priority
              (Scheduling_Policies.Fixed_Priority_Policy'Class
       (Sched_Policy_Ref.all));
            if Proc_Ref /= null and then Proc_Ref.all in
              Processing_Resources.Processor.Regular_Processor'Class
            then
               Max_Int_Prio:=
                 Processing_Resources.Processor.Max_Interrupt_Priority
                 (Processing_Resources.Processor.Regular_Processor'Class
          (Proc_Ref.all));
               Min_Int_Prio:=
                 Processing_Resources.Processor.Min_Interrupt_Priority
                 (Processing_Resources.Processor.Regular_Processor'Class
          (Proc_Ref.all));
               if Min_Int_Prio>Max_Int_Prio or else Min_Prio>Min_Int_Prio
                 or else Max_Prio>Max_Int_Prio
               then
                  if Verbose then
                     Put_Line("Interrupt priority range is null or wrong");
                  end if;
                  return False;
               end if;
            else
               Max_Int_Prio:=Priority'Last;
               Min_Int_Prio:=Priority'Last;
            end if;
            if Min_Prio>Max_Prio then
               if Verbose then
                  Put_Line("Priority range is null");
               end if;
               return False;
            end if;
            Sched_Param_Ref:=Scheduling_Servers.Server_Sched_Parameters
              (Srvr_Ref.all);
            if Sched_Param_Ref.all in
              Scheduling_Parameters.Fixed_Priority_Parameters'Class
            then
               if Sched_Param_Ref.all in
                 Scheduling_Parameters.Interrupt_FP_Policy'Class
               then
                  if Scheduling_Parameters.The_Priority
                    (Scheduling_Parameters.Fixed_Priority_Parameters
             (Sched_Param_Ref.all)) not in Min_Int_Prio..Max_Int_Prio
                  then
                     if Verbose then
                        Put_Line("Interrupt Priority of server "&
               Scheduling_Servers.Name(Srvr_Ref)&
               " is out of range");
                     end if;
                     return False;
                  end if;
               else
                  if Scheduling_Parameters.The_Priority
                    (Scheduling_Parameters.Fixed_Priority_Parameters
             (Sched_Param_Ref.all)) not in Min_Prio..Max_Prio
                  then
                     if Verbose then
                        Put_Line("Priority of server "&
               Scheduling_Servers.Name(Srvr_Ref)&
               " is out of range");
                     end if;
                     return False;
                  end if;
               end if;
               if Sched_Param_Ref.all in
                 Scheduling_Parameters.Sporadic_Server_Policy'Class
               then
                  if Scheduling_Parameters.Background_Priority
                    (Scheduling_Parameters.Sporadic_Server_Policy
             (Sched_Param_Ref.all)) not in Min_Prio..Max_Prio
                  then
                     if Verbose then
                        Put_Line("Background priority is out of range");
                     end if;
                     return False;
                  end if;
                  if Scheduling_Parameters.Initial_Capacity
                    (Scheduling_Parameters.Sporadic_Server_Policy
             (Sched_Param_Ref.all)) >
                    Scheduling_Parameters.Replenishment_Period
                    (Scheduling_Parameters.Sporadic_Server_Policy
             (Sched_Param_Ref.all))
                  then
                     if Verbose then
                        Put_Line("Initial_Capacity is larger than "&
               "Replenishment Period");
                     end if;
                     return False;
                  end if;
               end if;
            else
               raise Incorrect_Object;
            end if;
         end if;
         return True;
      end Priorities_Are_In_Range;

      Priorities_Out_Of_Range : exception;

      procedure Operation_For_Event_Handlers
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Event_Handler_Ref : Mast.Graphs.Event_Handler_Ref)
      is
         pragma Unreferenced (Trans_Ref);
         procedure Check_Operation_Priorities
           (Op_Ref : Operations.Operation_Ref;
            Sched_Policy_Ref :Scheduling_Policies.Fixed_Priority_Policy_Ref)
         is
            Iterator : Operations.Operation_Iteration_Object;
            New_Op_Ref : Operations.Operation_Ref;
         begin
            -- Check Overridden Priorities
            if Operations.New_Sched_Parameters(Op_Ref.all)/=null then
               if Scheduling_Parameters.The_Priority
                 (Scheduling_Parameters.Overridden_FP_Parameters'Class
          (Operations.New_Sched_Parameters(Op_Ref.all).all)) not in
                 Scheduling_Policies.Min_Priority(Sched_Policy_Ref.all)..
                 Scheduling_Policies.Max_Priority(Sched_Policy_Ref.all)
               then
                  if Verbose then
                     Put_Line
                       ("Operation "&
           Operations.Name(Op_Ref)&
           " has overridden priority out of range");
                  end if;
                  raise Priorities_Out_Of_Range;
               end if;
            end if;
            if Op_Ref.all in Operations.Composite_Operation'Class
            then
               Operations.Rewind_Operations
                 (Operations.Composite_Operation(Op_Ref.all),
                  Iterator);
               for I in 1..Operations.Num_Of_Operations
                 (Operations.Composite_Operation(Op_Ref.all))
               loop
                  Operations.Get_Next_Operation
                    (Operations.Composite_Operation(Op_Ref.all),
                     New_Op_Ref,Iterator);
                  Check_Operation_Priorities
                    (New_Op_Ref,Sched_Policy_Ref);
               end loop;
            end if;
         end Check_Operation_Priorities;

         Sched_Policy_Ref :Scheduling_Policies.Scheduling_Policy_Ref;
      begin
         if The_Event_Handler_Ref.all in
           Graphs.Event_Handlers.Activity'Class
         then
            Sched_Policy_Ref:=Schedulers.Scheduling_Policy
              (Scheduling_Servers.Server_Scheduler
       (Graphs.Event_Handlers.Activity_Server
          (Graphs.Event_Handlers.Activity
             (The_Event_Handler_Ref.all)).all).all);
            if Sched_Policy_Ref.all in
              Scheduling_Policies.Fixed_Priority_Policy'Class
            then
               Check_Operation_Priorities
                 (Graphs.Event_Handlers.Activity_Operation
          (Graphs.Event_Handlers.Activity(The_Event_Handler_Ref.all)),
                  Scheduling_Policies.Fixed_Priority_Policy_Ref
          (Sched_Policy_Ref));
            end if;
         end if;
      end Operation_For_Event_Handlers;

      procedure Operation_For_Links
        (Trans_Ref : Mast.Transactions.Transaction_Ref;
         The_Link_Ref : Mast.Graphs.Link_Ref) is
      begin
         null;
      end Operation_For_Links;

      procedure Check_Priorities_Of_Activities is new
        Transaction_Operations.Traverse_Paths_From_Link_Once
        (Operation_For_Event_Handlers,Operation_For_Links);


      Proc_Iteration_Object : Processing_Resources.Lists.Iteration_Object;
      Proc_Ref : Processing_Resources.Processing_Resource_Ref;
      Drv_Iteration_Object : Processing_Resources.Network.
        Driver_Iteration_Object;
      Drv_Ref : Drivers.Driver_Ref;
      Srvr_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Srvr_Iterator : Scheduling_Servers.Lists.Iteration_Object;
      Trans_Ref : Transactions.Transaction_Ref;
      Tr_Iterator : Transactions.Lists.Iteration_Object;
      A_Link_Ref : Mast.Graphs.Link_Ref;
      L_Iterator : Transactions.Link_Iteration_Object;

   begin
      -- Check drivers
      Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Proc_Iteration_Object);
      for Proc in 1..Processing_Resources.Lists.Size
        (The_System.Processing_Resources)
      loop
         Processing_Resources.Lists.Get_Next_Item
           (Proc_Ref,The_System.Processing_Resources,
            Proc_Iteration_Object);
         if Proc_Ref.all in Processing_Resources.Network.Network'Class then
            Processing_Resources.Network.Rewind_Drivers
              (Processing_Resources.Network.Network'Class(Proc_Ref.all),
               Drv_Iteration_Object);
            for Drv in 1..Processing_Resources.Network.Num_Of_Drivers
              (Processing_Resources.Network.Network'Class(Proc_Ref.all))
            loop
               Processing_Resources.Network.Get_Next_Driver
                 (Processing_Resources.Network.Network'Class(Proc_Ref.all),
                  Drv_Ref, Drv_Iteration_Object);
               if Drv_Ref.all in Drivers.Packet_Driver'Class then
                  if not Priorities_Are_In_Range
                    (Drivers.Packet_Server(Drivers.Packet_Driver(Drv_Ref.all)))
                  then
                     if Verbose then
                        Put_Line
                          ("Packet server of driver in "&
              Processing_Resources.Name(Proc_Ref)&
              " has priority out of range");
                     end if;
                     return False;
                  end if;
                  if Drv_Ref.all in Drivers.Character_Packet_Driver'Class
                  then
                     if not Priorities_Are_In_Range
                       (Drivers.Character_Server
           (Drivers.Character_Packet_Driver(Drv_Ref.all)),
                        Verbose)
                     then
                        if Verbose then
                           Put_Line
                             ("Character server of driver in "&
            Processing_Resources.Name(Proc_Ref)&
            " has priority out of range");
                        end if;
                        return False;
                     end if;
                  elsif Drv_Ref.all in Drivers.RTEP_Packet_Driver'Class then
                     if not Priorities_Are_In_Range
                       (Drivers.Packet_Interrupt_Server
           (Drivers.RTEP_Packet_Driver(Drv_Ref.all)),
                        Verbose)
                     then
                        if Verbose then
                           Put_Line
                             ("Packet interrupt server of driver in "&
            Processing_Resources.Name(Proc_Ref)&
            " has priority out of range");
                        end if;
                        return False;
                     end if;
                  end if;
               else
                  raise Incorrect_Object;
               end if;
            end loop;
         end if;
      end loop;

      -- Check Scheduling Servers
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,Srvr_Iterator);
      for I in 1..Scheduling_Servers.Lists.Size
        (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,The_System.Scheduling_Servers,Srvr_Iterator);
         if not Priorities_Are_In_Range(Srvr_Ref,Verbose)
         then
            if Verbose then
               Put_Line
                 ("Server "&Scheduling_Servers.Name(Srvr_Ref)&
          " has priority out of range");
            end if;
            return False;
         end if;
      end loop;

      -- Check Operation overriden parameters
      -- loop for each path in the transaction
      Transactions.Lists.Rewind(The_System.Transactions,Tr_Iterator);
      for I in 1..Transactions.Lists.Size(The_System.Transactions)
      loop
         Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Tr_Iterator);
         Transactions.Rewind_External_Event_Links(Trans_Ref.all,L_Iterator);
         for I in 1..Transactions.Num_Of_External_Event_Links
           (Trans_Ref.all)
         loop
            Transactions.Get_Next_External_Event_Link
              (Trans_Ref.all,A_Link_Ref,L_Iterator);
            Check_Priorities_Of_Activities (Trans_Ref,A_Link_Ref);
         end loop;
      end loop;
      if Verbose then
         Put_Line("Priorities are all in range");
      end if;
      return True;
   exception
      when Priorities_Out_Of_Range =>
         return False;
   end Priorities_Are_In_Range;
   
   
   --------------------------------
   -- Consistent_Network_Drivers --
   --------------------------------

   function Consistent_Network_Drivers
     (The_System : Mast.Systems.System;
      Verbose : Boolean := True) 
     return Boolean
   is
      Proc_Iteration_Object : Processing_Resources.Lists.Iteration_Object;
      Proc_Ref, Srv_Proc_Ref : Processing_Resources.Processing_Resource_Ref;
      pragma Unreferenced (Srv_Proc_Ref);
      Drv_Iteration_Object : Processing_Resources.Network.
        Driver_Iteration_Object;
      Drv_Ref : Drivers.Driver_Ref;
      Srv_Ref : Scheduling_Servers.Scheduling_Server_Ref;
      Pair_Name : Var_String;
      
      -- To check that there are no duplicate pairs of networks-processors
      -- We create a set of strings where each string is the  
      -- processor name appended to the network name with a '-' separator
      -- in between
      package Name_Sets is new Ada.Containers.Indefinite_Ordered_Sets 
   (String, "<", "=");
      
      Name_Set : Name_Sets.Set := Name_Sets.Empty_Set;
      
   begin
      -- Iterate through processors and drivers
      Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Proc_Iteration_Object);
      for Proc in 1..Processing_Resources.Lists.Size
        (The_System.Processing_Resources)
      loop
         Processing_Resources.Lists.Get_Next_Item
           (Proc_Ref,The_System.Processing_Resources,
            Proc_Iteration_Object);
         if Proc_Ref.all in Processing_Resources.Network.Network'Class then
            Processing_Resources.Network.Rewind_Drivers
              (Processing_Resources.Network.Network'Class(Proc_Ref.all),
               Drv_Iteration_Object);
            for Drv in 1..Processing_Resources.Network.Num_Of_Drivers
              (Processing_Resources.Network.Network'Class(Proc_Ref.all))
            loop
               Processing_Resources.Network.Get_Next_Driver
                 (Processing_Resources.Network.Network'Class(Proc_Ref.all),
                  Drv_Ref, Drv_Iteration_Object);
               if Drv_Ref.all in Drivers.Packet_Driver'Class then
                  Srv_Ref := 
          Drivers.Packet_Server(Drivers.Packet_Driver(Drv_Ref.all));
                  if Srv_Ref = null then
                     -- Rule 2- Every driver has a scheduling server
                     if Verbose then
                        Put_Line
                          ("A driver in network " & To_String
              (Processing_Resources.Name(Proc_Ref)) &
              " has no packet server");
                     end if;
                     return False;
                  end if;
        
                  Srv_Proc_Ref := 
          Scheduling_Servers.Server_Processing_Resource(Srv_Ref.all);
                  Pair_Name := Processing_Resources.Name(Proc_Ref) & '-' &
          Processing_Resources.Name
          (Scheduling_Servers.Server_Processing_Resource
             (Srv_Ref.all));
                  if Name_Set.Contains(To_String(Pair_Name)) then
           -- Rule 1- There is at most one driver per 
           -- processor-network pair
                     if Verbose then
                        Put_Line
                          ("The network-processor pair " & To_String(Pair_Name)
              & " has more than one network driver");
                     end if;
                     return False;
                  end if;
                  Name_Set.Insert(To_String(Pair_Name));
        
                  if Drivers.Packet_Send_Operation
                    (Drivers.Packet_Driver(Drv_Ref.all)) = null
                    or else Drivers.Packet_Receive_Operation
                      (Drivers.Packet_Driver(Drv_Ref.all)) = null
                  then
                     -- Rule 3- Every driver has a send and receive operation
                     if Verbose then
                        Put_Line
                          ("A driver in network " & To_String
                             (Processing_Resources.Name(Proc_Ref)) &
                             " has no send or receive operation");
                     end if;
                     return False;
                  end if;
        
               else
                  raise Incorrect_Object;
               end if;
            end loop;
         end if;
      end loop;
      return True;
      
   end Consistent_Network_Drivers;

   -------------------------------------
   -- Consistent_Processing_Resources --
   -------------------------------------
   -- Checks that all processing resources without have a scheduler

   function Consistent_Processing_Resources
      (The_System : Mast.Systems.System;
       Verbose : Boolean := True)
   return Boolean 
   is
      Res_Ref: Processing_Resources.Processing_Resource_Ref;
      Proc_Iterator : Processing_Resources.Lists.Iteration_Object;
   begin
      Mast.Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Proc_Iterator);
      for K in 1..Mast.Processing_Resources.Lists.Size
         (The_System.Processing_Resources)
      loop
         Mast.Processing_Resources.Lists.Get_Next_Item
            (Res_Ref,The_System.Processing_Resources,Proc_Iterator);
         if not Res_Ref.Has_Scheduler then
            return False;
         end if;
      end loop;
      -- All processing resources had a scheduler
      return True;
   end Consistent_Processing_Resources;


end Mast.Consistency_Checks;
