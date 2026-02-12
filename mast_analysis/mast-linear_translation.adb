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
--          Maria Cue                                                --
--          Juan Maria Rivas       rivasjm@unican.es                 --
--                                                                   --
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

with Mast.Transactions, Mast.Graphs, Mast.Graphs.Links,
  Mast.Graphs.Event_Handlers, Mast.Scheduling_Servers,
  Mast.Processing_Resources, Mast.Scheduling_Parameters,
  Mast.Timing_Requirements, Mast.Results, Mast.Events, Mast.Shared_Resources,
  Mast.Timers, Mast.Drivers, Mast.Processing_Resources.Processor,
  Mast.Processing_Resources.Network, Mast.Schedulers,
  Mast.Schedulers.Primary,
  Mast.Operations, Mast.Transaction_Operations, Mast.IO, Mast.Tool_Exceptions,
  Indexed_Lists, Ada.Text_IO, Ada.Float_Text_IO, Var_Strings, Trimmed_Image;
with Ada.Containers, Ada.Containers.Hashed_Maps, Ada.Strings.Hash;
-- with System.Storage_Elements;
use  Ada.Text_IO, Var_Strings, Trimmed_Image;
use type Mast.Graphs.Link_Ref;
use type Mast.Graphs.Event_Handler_Ref;
use type Mast.Events.Event_Ref;
use type Mast.Graphs.Link_Lists.Index;
use type Mast.Graphs.Event_Handler_Lists.Index;
use type Mast.Shared_Resources.Shared_Resource_Ref;
use type Mast.Timing_Requirements.Timing_Requirement_Ref;
use type Mast.Processing_Resources.Processing_Resource_Ref;
use type Mast.Timers.System_Timer_Ref;
use type Mast.Scheduling_Parameters.Sched_Parameters_Ref;
use type Mast.Scheduling_Servers.Scheduling_Server_Ref;
use type Mast.Scheduling_Parameters.Overridden_Sched_Parameters_Ref;
use type Mast.Operations.Operation_Ref;
use type Mast.Drivers.Rta_Overhead_Model_Type;

package body Mast.Linear_Translation is

   Debug : constant Boolean:=False;
   
   type Rate_Factors is array
     (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Positive;

   type Offset_Reqs is array
     (Task_ID_Type range 1 .. Max_Tasks_Per_Transaction) of Boolean;

   -- This type stores the type of the previous handler in a linear
   -- sequence
   type Type_Of_Handler is (Activity, Rate_Divisor, Offset_EH, Delay_EH);
   
   -- The following type is used to carry over the type of previous handler
   -- together with the delay or offset values from one transaction to another
   type Prev_Handler_Values_Type is record
      Min_Delay, Max_Delay : Time;
      Type_Of_Previous_Handler : Type_Of_Handler;
   end record;
   
   -- The following type is used to carry over the type of the previous
   -- processing resource together with its reference from one transaction
   -- to another
   type Prev_Processor_Values_Type is record
      Prev_Proc_Kind: Kind_Of_Processor;
      Proc_Ref, Network_Proc_Ref  :
        Mast.Processing_Resources.Processing_Resource_Ref;
   end record;
   
   type Trans_And_Event_Handler is record
      Trans_Ref: Transactions.Transaction_Ref;
      Hdler_Ref: Mast.Graphs.Event_Handler_Ref;
   end record;
   
   function Hash
     (T_And_E : Trans_And_Event_Handler) return Ada.Containers.Hash_Type;
   
   -- mapping from MAST.Graphs.Event_Handler_Ref 
   -- (reference to Barrier) to Transaction_Id_Type   
   package Maps is new Ada.Containers.Hashed_Maps
     (Key_Type => Trans_And_Event_Handler,
      Element_Type => Transaction_ID_Type,
      Hash => Hash,
      Equivalent_Keys => "=");
   
   -- Hashing function for a pointer
   function Hash 
     (T_And_E: Trans_And_Event_Handler) return Ada.Containers.Hash_Type 
   is
      Name : Var_String;
      Iter : Graphs.Event_Handlers.Iteration_Object;
      The_Link : Graphs.Link_Ref;
   begin
      -- March 2025: Function to_Integer produced a constraint_error
      -- in Windows. We have built a workaround basing the hash
      -- function on the name of the transaction and the output
      -- link. The first output link in case of a multi output event
      -- handler
      
      --return Ada.Containers.Hash_Type
      --        (System.Storage_Elements.To_Integer(Ref.all'Address));
      Name := T_And_E.Trans_Ref.Name;
      if T_And_E.Hdler_Ref.all in 
        Mast.Graphs.Event_Handlers.Simple_Event_Handler'Class 
      then
         Name := Name&Mast.Graphs.Event_Handlers.Simple_Event_Handler
           (T_And_E.Hdler_Ref.all).
           Output_Link.Name;
      elsif T_And_E.Hdler_Ref.all in 
        Mast.Graphs.Event_Handlers.Input_Event_Handler'class 
      then
         Name := Name&Mast.Graphs.Event_Handlers.Input_Event_Handler
           (T_And_E.Hdler_Ref.all).
           Output_Link.Name;     
      else -- it is an output event handler
         --   Get the name of the first output link
         Mast.Graphs.Event_Handlers.Output_Event_Handler(T_And_E.Hdler_Ref.all).
           Rewind_Output_Links(Iter);
         Mast.Graphs.Event_Handlers.Output_Event_Handler(T_And_E.Hdler_Ref.all).
           Get_Next_Output_Link(The_Link, Iter);
         Name:=Name&The_Link.Name;
      end if;    
      return Ada.Strings.Hash(To_String(Name));
   end Hash;
   
   ----------------------------
   -- Get_Processor_Name     --
   ----------------------------

   function Get_Processor_Name
     (The_System  : Systems.System;
      Proc_Number : Processor_ID_Type)
     return        String
   is
      Res_Ref       : Processing_Resources.Processing_Resource_Ref;
      Proc_Iterator : Processing_Resources.Lists.Iteration_Object;
   begin
      Mast.Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,
         Proc_Iterator);
      if Natural (Proc_Number) >
        Mast.Processing_Resources.Lists.Size
          (The_System.Processing_Resources)
      then
         Set_Exception_Message("Get_Processor_Name: Processor number too high");
         raise Internal_Inconsistency;
      end if;
      for K in 1 .. Proc_Number loop
         Mast.Processing_Resources.Lists.Get_Next_Item
           (Res_Ref,
            The_System.Processing_Resources,
            Proc_Iterator);
      end loop;
      return To_String (Processing_Resources.Name (Res_Ref));
   end Get_Processor_Name;

   ----------------------------
   -- Get_Processor_Number   --
   ----------------------------

   function Get_Processor_Number
     (The_System : Systems.System;
      A_Proc_Ref : Processing_Resources.Processing_Resource_Ref)
     return       Processor_ID_Type
   is
      Res_Ref       : Processing_Resources.Processing_Resource_Ref;
      Proc_Iterator : Processing_Resources.Lists.Iteration_Object;
   begin
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
         if Res_Ref = A_Proc_Ref then
            return Processor_ID_Type (K);
         end if;
      end loop;
      Set_Exception_Message("Processor reference not found");
      raise Internal_Inconsistency;
   end Get_Processor_Number;

   ----------------------------------
   -- Get_Min_Used_System_Priority --
   ---------------------------------

   function Get_Min_Used_System_Priority
     (The_System : Mast.Systems.System;
      A_Proc_Ref : Processing_Resources.Processing_Resource_Ref)
     return       Priority
   is
      Srvr_Ref         : Scheduling_Servers.Scheduling_Server_Ref;
      Srvr_Iterator    : Scheduling_Servers.Lists.Iteration_Object;
      Min_Prio, A_Prio : Priority := Priority'Last;
   begin
      Scheduling_Servers.Lists.Rewind
        (The_System.Scheduling_Servers,
         Srvr_Iterator);
      for I in
        1 ..
        Scheduling_Servers.Lists.Size (The_System.Scheduling_Servers)
      loop
         Scheduling_Servers.Lists.Get_Next_Item
           (Srvr_Ref,
            The_System.Scheduling_Servers,
            Srvr_Iterator);
         if Scheduling_Servers.Server_Processing_Resource (Srvr_Ref.all) =
           A_Proc_Ref
         then
            A_Prio := Scheduling_Servers.Base_Priority (Srvr_Ref.all);
            if A_Prio < Min_Prio then
               Min_Prio := A_Prio;
            end if;
         end if;
      end loop;
      return Min_Prio;
   end Get_Min_Used_System_Priority;


   -------------------------------------
   -- Expand_Rate_Divided_Transaction --
   -------------------------------------
   procedure Expand_Rate_Divided_Transaction
     (Transaction : in out Linear_Transaction_System;
      Rate_Divided_Tasks : Rate_Factors;
      Offset_Requirements : in out Offset_Reqs;
      I : Transaction_ID_Type;
      Start : Task_ID_Type;
      Ni : Task_ID_Type)
   is
      Rate_Id, Current_Id, Num_Tasks : Task_ID_Type;
      Found : Boolean:=False;
      End_Of_Tasks : Boolean:=False;
      New_Data : The_Transaction_Tasks;
      New_Factors : Rate_Factors;
      New_Offsets : Offset_Reqs:=(others=>False);
      Factor : Positive;
   begin
      -- This procedure expands a transaction containing rate divisors
      -- into its equivalent model, in which all tasks preceding a rate divisor
      -- are recursively replicated a number of times equal to the
      -- corresponding rate factor

      -- find Position of first rate divisor after Start
      Rate_Id:=Start;
      while not End_Of_Tasks and not Found loop
         if Rate_Divided_Tasks(Rate_Id) /= 1 then
            Found:=True;
         else
            if Rate_Id=Ni then
               End_Of_Tasks:=True;
            else
               Rate_Id:=Rate_Id+1;
            end if;
         end if;
      end loop;

      if Found then
         -- Rate divisor found; tasks before Rate_id will be replicated
         if Debug then
            Put_Line("Replicate tasks from start="&Start'Img&
                       " up to "&Rate_Id'Img);
         end if;
         
         Current_Id :=1;
         Factor:=Rate_Divided_Tasks(Rate_Id);
         Num_Tasks:=Rate_Id-1;
         for K in 1..Factor loop
            if Debug then
               Put_Line("Copy from: 1  to: "&
                          Task_ID_Type'Image(Num_Tasks));
               Put_Line("Into     : "&Current_Id'Img&" to: "&
                          Task_ID_Type'Image(Current_Id+Num_Tasks-1));
            end if;
            
            New_Data(Current_Id..Current_Id+Num_Tasks-1):=
              Transaction(I).The_Task(1..Num_Tasks);
            -- tasks after the second copy have no associated results
            if K>=2 then
               for Cur in Current_Id..Current_Id+Num_Tasks-1 loop
                  New_Data(Cur).Resij:=null;
               end loop;
            end if;
            New_Factors(Current_Id..Current_Id+Num_Tasks-1):=
              (others => 1);
            New_Offsets(Current_Id..Current_Id+Num_Tasks-1):=
              Offset_Requirements(1..Num_Tasks);
            New_Offsets(Current_Id+Num_Tasks-1):=True;
            if Debug then
               Put_Line
                 ("New Offsets=True : "&
                    Task_ID_Type'Image(Current_Id+Num_Tasks-1));
            end if;
            
            Current_Id:=Current_Id+Num_Tasks;
         end loop;
         -- Add tasks at or after Rate_Id
         New_Data(Current_Id..Current_Id+Ni-Rate_Id):=
           Transaction(I).The_Task(Rate_Id..Ni);
         New_Factors(Current_Id..Current_Id+Ni-Rate_Id):=
           Rate_Divided_Tasks(Rate_Id..Ni);
         New_Factors(Current_Id):=1;
         New_Offsets(Current_Id-1):=False;
         if Debug then  
            Put_Line("New Offsets=False: "&Task_ID_Type'Image(Current_Id-1));
         end if;
         
         -- Copy new task data into transaction system
         Transaction(I).The_Task:=New_Data;
         Transaction(I).Ni:=Current_Id+Ni-Rate_Id;
         Offset_Requirements:=New_Offsets;
         
         if Debug then
            Put("Offsets requirements al final: ");
            for X in 1..Transaction(I).Ni loop
               if Offset_Requirements(X) then
                  Put(X'Img&", ");
               end if;
            end loop;
            New_Line;
            Put("Results al final: ");
            for X in 1..Transaction(I).Ni loop
               if Transaction(I).The_Task(X).Resij/=null then
                  Put(X'Img&", ");
               end if;
            end loop;
            New_Line;
         end if;

         -- Recursively expand remaining rate divisors
         Expand_Rate_Divided_Transaction
           (Transaction,New_Factors,Offset_Requirements,
            I,Current_Id,Current_Id+Ni-Rate_Id);

      end if;

   end Expand_Rate_Divided_Transaction;



   -------------------------------
   -- Translate_Linear_System   --
   -------------------------------

   procedure Translate_Linear_System
     (The_System  : Mast.Systems.System;
      Transaction : out Linear_Transaction_System;
      Verbose     : Boolean := False)
   is
      
      package Overhead_Task_Lists is new Indexed_Lists (Task_Data, "=");
      
      -- List containing the overhead tasks to add to the simplified 
      -- transaction model
      Overhead_Task_List : Overhead_Task_Lists.List;
      

      -- mapping from MAST.Graphs.Event_Handler_Ref 
      -- (reference to Barrier) to Transaction_Id_Type
      Join_Map : Maps.Map;
      
      
      --This procedure adds one or more transactions into the
      --  simplified transaction model represented by variable
      --  Transaction.  The transaction data is obtained from the
      --  transaction in the general model with the id
      --  Current_Trans_Id, reference Trans_Ref, and external event
      --  External_Event_Ref, starting from its link The_Link_Ref. 
      --  The Prev_Processor_Values parameter specifies which is the kind
      --  (processor, network, none) of the previous processing resource, 
      --  together with its reference
      --  This is used to add the overheads in the coupled model when
      --  going from a network to a processor or from a processor to a network
      --  The new simplified transaction is added at index Index in the
      --  Transaction array       
      --  The parameter Last_Trans_Index reflects all the used or
      --  reserved transactions in the simplified transaction model;
      --  it is updated if new trasactions need to be added as a
      --  result of this call, to reflect the last index used
      
      procedure Add_Simplified_Transaction
        (Current_Trans_Id     : Transaction_ID_Type;
         Trans_Ref            : Mast.Transactions.Transaction_Ref;
         External_Event_Ref   : Mast.Events.Event_Ref;
         The_Link_Ref         : Mast.Graphs.Link_Ref;
         Index                : Transaction_ID_Type;
         Prev_Processor_Val   : Prev_Processor_Values_Type;
         Prev_Handler_Val     : Prev_Handler_Values_Type;
         Last_Trans_Index     : in out Transaction_ID_Type)
      is
         A_Link_Ref           : Mast.Graphs.Link_Ref:=The_Link_Ref;
         
         An_Event_Ref       : Mast.Events.Event_Ref;
         
         I : constant Transaction_ID_Type:=Index;
         
         An_Event_Handler_Ref, New_Event_Handler_Ref : 
           Mast.Graphs.Event_Handler_Ref;
         
         Prev_Proc_Values : Prev_Processor_Values_Type :=
           Prev_Processor_Val;
         
         Prev_Handler_Values : Prev_Handler_Values_Type:=Prev_Handler_Val;
         
         -- The following variables are used by the rate divisor event handlers
         -- to set information for the following activity
         Rate_Factor       : Positive;
         Cumulative_Rate_Factor : Positive;

         -- This variable indicates whether a transaction
         -- should be divided in two independent transactions
         Independent_Tasks  : Boolean:=False;
         
         -- This variable indicates whether the last event handler is a
         -- multipath handler, in which case the procedure must exit
         Multipath_Handler : Boolean:=False;

         -- This array contains for each task, the rate factor of the rate 
         -- divisor immediately preceding the task, if any
         -- If there is no preceding rate divisor for a task,
         -- its associated value is 1
         Rate_Divided_Tasks : Rate_Factors;

         -- This array will be used by the expansion of rate divisors to know
         -- where offsets are needed in the resulting transaction
         Offset_Requirements : Offset_Reqs;

         Offset : Time;

         -- This variable indicates whether the period of the transaction
         -- should be multiplied by the cumulative rate factor, because
         -- the transaction contains rate divisors
         Period_Should_Be_Increased : Boolean :=False;
         
         -- Index into task's array
         J : Task_ID_Type;
         
         Nxt_Link_Ref, Next_Link_Ref, New_Link_Ref :
           Mast.Graphs.Link_Ref;
         
         A_Server_Ref, Last_Server_Ref, Drv_Server_Ref :
           Mast.Scheduling_Servers.Scheduling_Server_Ref:=null;
         
         New_Sched_Server_Detected : Boolean;
         
         A_Proc_Ref : Mast.Processing_Resources.Processing_Resource_Ref;
         
         Speed : Processor_Speed;
         Throughput : Throughput_Value := 0.0;
         
         A_Scheduler_Ref                         : Schedulers.Scheduler_Ref;
         A_Sched_Policy_Ref                      :
           Mast.Scheduling_Policies.Scheduling_Policy_Ref;
         
         A_Timing_Req_Ref                        :
           Mast.Timing_Requirements.Timing_Requirement_Ref;
         A_Result_Ref                            : 
           Mast.Results.Timing_Result_Ref;
         
         Current_Proc_Kind       : Kind_Of_Processor;
         
         Proc_Num                                : Processor_ID_Type;   
         
         A_Sched_Param_Ref                       :
           Mast.Scheduling_Parameters.Sched_Parameters_Ref;
         A_Synch_Param_Ref                       :
           Mast.Synchronization_Parameters.Synch_Parameters_Ref;
         
         Min_System_Priority                : Priority;
         Max_System_Priority                : Priority;
         Min_Int_Priority                   : Priority;
         Max_Int_Priority                   : Priority;
         Min_Used_System_Priority           : Priority;
         
         Drv_Iterator                       :
           Processing_Resources.Network.Driver_Iteration_Object;
         Drv_Ref                            : Drivers.Driver_Ref;
         Driver_Proc_Ref                    :
           Mast.Processing_Resources.Processing_Resource_Ref;
         Driver_S_Policy_Ref                :
           Mast.Scheduling_Policies.Scheduling_Policy_Ref;
         
         WS_Ovhd, WR_Ovhd, BS_Ovhd, BR_Ovhd : Time;
         
         Timer_Ref                          : Timers.System_Timer_Ref;
         Timer_Jitter                       : Time;
         
         Segment_Prio              : Priority;
         Segment_Dij               : Time;
         Segment_Sched             : Sched_Type;
         -- mgh 2026: added the preemptimble flag
         Preemptible               : Boolean;
         Preassigned_Prio          : Boolean;
         Over_Ref                  :
           Mast.Scheduling_Parameters.Overridden_Sched_Parameters_Ref;    

         Max_Arrivals                            : Natural;
         
      begin
         Transaction (I).Transaction_Id := Current_Trans_Id;
         
         Transaction (I).Ni             :=
           Task_ID_Type (Mast.Transactions.Num_Of_Event_Handlers
                           (Trans_Ref.all));
         -- Final number will be smaller, because offsets, delays and
         -- rate divisors are not tasks.
         
         -- Initialize Oij, Jij, Jinit, Rij, Rbij, Sched_Delay, and
         -- Jitter_avoidance, Uses_Shared_Resources,
         -- Delayijmin, Delayijmax, Oijmin, Oijmax for all tasks
         for J in 1 .. Max_Tasks_Per_Transaction loop
            Transaction (I).The_Task (J).Oij                   := 0.0;
            Transaction (I).The_Task (J).Jij                   := 0.0;
            Transaction (I).The_Task (J).Jinit                 := 0.0;
            Transaction (I).The_Task (J).Rij                   := 0.0;
            Transaction (I).The_Task (J).Rbij                  := 0.0;
            Transaction (I).The_Task (J).Sched_Delay           := 0.0;
            Transaction (I).The_Task (J).Delayijmin            := 0.0;
            Transaction (I).The_Task (J).Delayijmax            := 0.0;
            Transaction (I).The_Task (J).Oijmin                := 0.0;
            Transaction (I).The_Task (J).Oijmax                := 0.0;
            Transaction (I).The_Task (J).Model                 := Regular;
            Transaction (I).The_Task (J).Schedij               := FP;
            Transaction (I).The_Task (J).Preemptible           := True;
            Transaction (I).The_Task (J).Jitter_Avoidance      := False;
            Rate_Divided_Tasks (J)                             := 1;
            Transaction (I).The_Task (J).Uses_Shared_Resources := False;
         end loop;
         
         -- Set the initial jitter for a periodic external event
         An_Event_Ref        := Mast.Graphs.Event_Of (A_Link_Ref.all);
         if An_Event_Ref/=null and then
           An_Event_Ref.all in Mast.Events.Periodic_Event'Class 
         then
            Transaction (I).The_Task (1).Jinit :=
              Mast.Events.Max_Jitter
                (Mast.Events.Periodic_Event'Class (An_Event_Ref.all));
         end if;
         
         Cumulative_Rate_Factor    := 1;
         J                         := 1;
         New_Sched_Server_Detected := True;
         -- for each event handler in the transaction
         loop
            An_Event_Handler_Ref :=
              Graphs.Output_Event_Handler (A_Link_Ref.all);
            -- check kind of event handler
            if An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Offset_Event_Handler'Class
            then
               -- Offset event handler
               Prev_Handler_Values.Min_Delay :=
                 Graphs.Event_Handlers.Delay_Min_Interval
                   (Graphs.Event_Handlers.Offset_Event_Handler'Class
                      (An_Event_Handler_Ref.all));
               Prev_Handler_Values.Max_Delay :=
                 Graphs.Event_Handlers.Delay_Max_Interval
                   (Graphs.Event_Handlers.Offset_Event_Handler'Class
                      (An_Event_Handler_Ref.all));
               Prev_Handler_Values.Type_Of_Previous_Handler := Offset_EH;
               
               -- check if referenced event coincides with transaction event
               if Graphs.Event_Handlers.Referenced_Event
                 (Graphs.Event_Handlers.Offset_Event_Handler'Class
                    (An_Event_Handler_Ref.all)) /=
                 External_Event_Ref
               then
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Referenced event in offset event handler is different" &
                       " than transaction event");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
               J             := J - 1; -- this is not a task
               Next_Link_Ref :=
                 Graphs.Event_Handlers.Output_Link
                   (Graphs.Event_Handlers.Simple_Event_Handler
                      (An_Event_Handler_Ref.all));
            elsif An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Delay_Event_Handler'Class
            then
               -- Delay event handler
               Prev_Handler_Values.Min_Delay :=
                 Graphs.Event_Handlers.Delay_Min_Interval
                   (Graphs.Event_Handlers.Delay_Event_Handler'Class
                      (An_Event_Handler_Ref.all));
               Prev_Handler_Values.Max_Delay :=
                 Graphs.Event_Handlers.Delay_Max_Interval
                   (Graphs.Event_Handlers.Delay_Event_Handler'Class
                      (An_Event_Handler_Ref.all));
               Prev_Handler_Values.Type_Of_Previous_Handler := Delay_EH;
               J                        := J - 1; -- this is not a task
               Next_Link_Ref            :=
                 Graphs.Event_Handlers.Output_Link
                   (Graphs.Event_Handlers.Simple_Event_Handler
                      (An_Event_Handler_Ref.all));
            elsif An_Event_Handler_Ref.all in
              Graphs.Event_Handlers.Rate_Divisor'Class
            then
               -- Rate divisor
               if Transaction(I).Ti/=Large_Time then
                  -- There is a rate divisor and period is not infinite
                  Period_Should_Be_Increased:=True;
               end if;
               Rate_Factor              :=
                 Graphs.Event_Handlers.Rate_Factor
                   (Graphs.Event_Handlers.Rate_Divisor'Class
                      (An_Event_Handler_Ref.all));
               Prev_Handler_Values.Type_Of_Previous_Handler := Rate_Divisor;
               Rate_Divided_Tasks (J)   := Rate_Factor;
               Cumulative_Rate_Factor:=Cumulative_Rate_Factor*Rate_Factor;
               -- rate divisor does not count as a task
               J                        := J - 1; 
               Next_Link_Ref            :=
                 Graphs.Event_Handlers.Output_Link
                   (Graphs.Event_Handlers.Simple_Event_Handler
                      (An_Event_Handler_Ref.all));
            elsif An_Event_Handler_Ref.all in 
              Graphs.Event_Handlers.Barrier'Class
            then
               -- Barrier (Join)
               declare
                  Tr : Transaction_ID_Type;
                  Found : Boolean:=False;
                  T_And_E : Trans_And_Event_Handler;
               begin
                  T_And_E := (Trans_Ref, An_Event_Handler_Ref);
                  if Join_Map.Contains(T_And_E) then
                     -- Transaction has been created at previous predecessor
                     Tr:=Join_Map.Element(T_And_E);
                     -- find non-zero element to set the predecessor
                     for Indx in 
                       Transaction (Tr).Predecessor_Trans_Ref.all'Range 
                     loop
                        if Transaction (Tr).Predecessor_Trans_Ref(Indx)=0 then
                           Transaction (Tr).Predecessor_Trans_Ref(Indx):=I;
                           Found:=True;
                           exit;
                        end if;
                     end loop;
                     if not Found then 
                        Set_Exception_Message ("Predecessor index not found");
                        raise Internal_Inconsistency;
                     end if;
                  else
                     -- new transaction will be in Last_Trans_Index+1
                     Last_Trans_Index:=Last_Trans_Index+1;
                     Tr:=Last_Trans_Index;
                     Join_Map.Insert((Trans_Ref, An_Event_Handler_Ref), Tr);
                     -- set predecessor
                     Transaction (Tr).Predecessor_Trans_Ref := 
                       new Transaction_Id_Array
                       (1..Graphs.Event_Handlers.Barrier
                          (An_Event_Handler_Ref.all).
                          Num_Of_Input_Links);
                     Transaction (Tr).Predecessor_Trans_Ref.all:=
                       (others=>0);
                     Transaction (Tr).Predecessor_Trans_Ref(1):=I;
                     
                     -- create successor transaction
                     Transaction(Tr).Trans_Input_Type:=Join;
                     Transaction(Tr).Ti:=Transaction(I).Ti;
                     Transaction(Tr).Evi:=Transaction(I).Evi;
                     Transaction(Tr).Kind_Of_Event:=
                       Transaction(I).Kind_Of_Event;
                     Next_Link_Ref :=
                       Graphs.Event_Handlers.Output_Link
                         (Graphs.Event_Handlers.Input_Event_Handler
                            (An_Event_Handler_Ref.all));
                     Add_Simplified_Transaction
                       (Current_Trans_Id,Trans_Ref,External_Event_Ref,
                        Next_Link_Ref,Tr,Prev_Proc_Values,
                        Prev_Handler_Values, Last_Trans_Index);
                  end if;        
                  -- set successor
                  Transaction (I).Successor_Trans_Ref := 
                    new Transaction_Id_Array(1..1);
                  Transaction (I).Successor_Trans_Ref(1):=Tr;
               end;        
               
               -- Join does not count as a task
               J := J - 1; 
               Multipath_Handler:=True;
               
            elsif An_Event_Handler_Ref.all in 
              Graphs.Event_Handlers.Multicast'Class
            then
               -- Multicast (Fork)
               declare
                  Tr, Trj :Transaction_ID_Type;
                  It : Mast.Graphs.Event_Handlers.Iteration_Object;
                  Found : Boolean;
               begin
                  Mast.Graphs.Event_Handlers.Rewind_Output_Links
                    (Graphs.Event_Handlers.Output_Event_Handler
                       (An_Event_Handler_Ref.all),It);
                  if J=1 then
                     -- Fork is at the beginning of the transaction
                     -- First output branch goes in current transaction (I)
                     Graphs.Event_Handlers.Get_Next_Output_Link
                       (Graphs.Event_Handlers.Output_Event_Handler
                          (An_Event_Handler_Ref.all),Next_Link_Ref,It);
                     
                     -- Rest of output branches go in new transactions
                     for Succ in 2..Graphs.Event_Handlers.Multicast
                       (An_Event_Handler_Ref.all).Num_Of_Output_Links
                     loop
                        Graphs.Event_Handlers.Get_Next_Output_Link
                          (Graphs.Event_Handlers.Output_Event_Handler
                             (An_Event_Handler_Ref.all),New_Link_Ref,It);
                        -- new transaction will be in Last_Trans_Index+1
                        Last_Trans_Index:=Last_Trans_Index+1;
                        Tr:=Last_Trans_Index;   
                        -- create successor transaction
                        Transaction(Tr).Trans_Input_Type:=External;
                        Transaction(Tr).Ti:=Transaction(I).Ti;
                        Transaction(Tr).Evi:=Transaction(I).Evi;
                        Transaction(Tr).Kind_Of_Event:=
                          Transaction(I).Kind_Of_Event;
                        Add_Simplified_Transaction
                          (Current_Trans_Id,Trans_Ref,External_Event_Ref,
                           New_Link_Ref,Tr,Prev_Proc_Values,
                           Prev_Handler_Values, Last_Trans_Index);
                        
                     end loop;
                     
                  else
                     -- Fork is in the middle of the transaction
                     -- create successor array
                     Transaction (I).Successor_Trans_Ref := 
                       new Transaction_Id_Array
                       (1..Graphs.Event_Handlers.Multicast
                          (An_Event_Handler_Ref.all).Num_Of_Output_Links);
                     
                     for Succ in 1..Graphs.Event_Handlers.Multicast
                       (An_Event_Handler_Ref.all).Num_Of_Output_Links
                     loop
                        Graphs.Event_Handlers.Get_Next_Output_Link
                          (Graphs.Event_Handlers.Output_Event_Handler
                             (An_Event_Handler_Ref.all),Next_Link_Ref,It);
                        if Next_Link_Ref.Output_Event_Handler.all in 
                          Graphs.Event_Handlers.Barrier'Class
                        then
                           --Fork followed by join
                           New_Event_Handler_Ref:=
                             Next_Link_Ref.Output_Event_Handler;
                           Found:=False;
                           if Join_Map.Contains((Trans_Ref, 
                                                 New_Event_Handler_Ref)) 
                           then
                              -- Transaction has been created at 
                              -- previous predecessor
                              Trj:=Join_Map.Element((Trans_Ref, 
                                                     New_Event_Handler_Ref));
                              -- find non-zero element to set the predecessor
                              for Indx in 
                                Transaction (Trj).
                                Predecessor_Trans_Ref.all'Range 
                              loop
                                 if Transaction (Trj).Predecessor_Trans_Ref
                                   (Indx)=0 
                                 then
                                    Transaction (Trj).Predecessor_Trans_Ref
                                      (Indx):=I;
                                    Found:=True;
                                    exit;
                                 end if;
                              end loop;
                              
                              if not Found then 
                                 Set_Exception_Message 
                                   ("Predecessor index not found");
                                 raise Internal_Inconsistency;
                              end if;
                           else
                              -- new transaction will be in Last_Trans_Index+1
                              Last_Trans_Index:=Last_Trans_Index+1;
                              Trj:=Last_Trans_Index;
                              Join_Map.Insert((Trans_Ref, 
                                               New_Event_Handler_Ref),Trj);
                              -- set predecessor
                              Transaction (Trj).Predecessor_Trans_Ref := 
                                new Transaction_Id_Array
                                (1..Graphs.Event_Handlers.Barrier
                                   (New_Event_Handler_Ref.all).
                                   Num_Of_Input_Links);
                              Transaction (Trj).Predecessor_Trans_Ref.all:=
                                (others=>0);
                              Transaction (Trj).Predecessor_Trans_Ref(1):=I;


                              -- create successor transaction
                              Transaction(Trj).Trans_Input_Type:=Join;
                              Transaction(Trj).Ti:=Transaction(I).Ti;
                              Transaction(Trj).Evi:=Transaction(I).Evi;
                              Transaction(Trj).Kind_Of_Event:=
                                Transaction(I).Kind_Of_Event;
                              New_Link_Ref :=
                                Graphs.Event_Handlers.Output_Link
                                  (Graphs.Event_Handlers.Input_Event_Handler
                                     (New_Event_Handler_Ref.all));
                              Add_Simplified_Transaction
                                (Current_Trans_Id,Trans_Ref,External_Event_Ref,
                                 New_Link_Ref,Trj,Prev_Proc_Values,
                                 Prev_Handler_Values, Last_Trans_Index);
                           end if;       
                           -- set successor
                           Transaction (I).Successor_Trans_Ref(Succ):=Trj;
                           
                        else
                           -- Fork not followed by join
                           if Next_Link_Ref.Output_Event_Handler.all in 
                             Graphs.Event_Handlers.Concentrator'Class
                           then
                              -- Fork followed by merge
                              -- Ignore the merge and continue with next handler
                              Next_Link_Ref :=
                                Graphs.Event_Handlers.Output_Link
                                  (Graphs.Event_Handlers.Input_Event_Handler
                                     (Next_Link_Ref.Output_Event_Handler.all));
                           end if;
                           -- new transaction will be in Last_Trans_Index+1
                           Last_Trans_Index:=Last_Trans_Index+1;
                           Tr:=Last_Trans_Index;
                           
                           -- Set Successor
                           Transaction (I).Successor_Trans_Ref(Succ):=Tr;
                           
                           -- set predecessor
                           Transaction (Tr).Predecessor_Trans_Ref := 
                             new Transaction_Id_Array(1..1);
                           Transaction (Tr).Predecessor_Trans_Ref(1):=I;
                           
                           -- create successor transaction
                           Transaction(Tr).Trans_Input_Type:=Internal;
                           Transaction(Tr).Ti:=Transaction(I).Ti;
                           Transaction(Tr).Evi:=Transaction(I).Evi;
                           Transaction(Tr).Kind_Of_Event:=
                             Transaction(I).Kind_Of_Event;
                           Add_Simplified_Transaction
                             (Current_Trans_Id,Trans_Ref,External_Event_Ref,
                              Next_Link_Ref,Tr,Prev_Proc_Values,
                              Prev_Handler_Values, Last_Trans_Index);
                        end if; -- fork followed by join
                     end loop;
                     Multipath_Handler:=True;
                  end if;
               end;
               -- Fork does not count as a task
               J := J - 1; 
               
            elsif An_Event_Handler_Ref.all in 
              Graphs.Event_Handlers.Concentrator'Class
            then
               -- Concentrator (Merge)
               -- No new transaction needed; we just continue in the same 
               -- transaction
               
               Next_Link_Ref :=
                 Graphs.Event_Handlers.Output_Link
                   (Graphs.Event_Handlers.Input_Event_Handler
                      (An_Event_Handler_Ref.all));
               
               -- Merge does not count as a task
               J := J - 1; 
               
            elsif An_Event_Handler_Ref.all in 
              Graphs.Event_Handlers.Delivery_Server'Class
            then
               -- Delivery_Server (Branch)
               Set_Exception_Message
                 ("Delivery_Server (Branch) event handler not supported");
               raise Internal_Inconsistency;          
            elsif An_Event_Handler_Ref.all in 
              Graphs.Event_Handlers.Barrier'Class
            then
               -- Query_Server (Branch)
               Set_Exception_Message
                 ("Query_Server (Branch) event handler not supported");
               raise Internal_Inconsistency;          
            elsif An_Event_Handler_Ref.all in Graphs.Event_Handlers.Activity'
                Class
            then
               

               -- Activity
               Last_Server_Ref           := A_Server_Ref;
               A_Server_Ref              :=
                 Mast.Graphs.Event_Handlers.Activity_Server
                   (Mast.Graphs.Event_Handlers.Activity (An_Event_Handler_Ref.
                                                           all));
               New_Sched_Server_Detected := A_Server_Ref /= Last_Server_Ref;
               A_Proc_Ref                :=
                 Mast.Scheduling_Servers.Server_Processing_Resource
                   (A_Server_Ref.all);
               Speed                     :=
                 Processing_Resources.Speed_Factor (A_Proc_Ref.all);
               A_Scheduler_Ref           :=
                 Scheduling_Servers.Server_Scheduler (A_Server_Ref.all);
               A_Sched_Policy_Ref        :=
                 Schedulers.Scheduling_Policy (A_Scheduler_Ref.all);
               -- check kind of processing resource
               if A_Proc_Ref.all in
                 Processing_Resources.Processor.Regular_Processor'Class
               then
                  Prev_Proc_Values.Proc_Ref          := A_Proc_Ref;
                  Current_Proc_Kind := Processor;
               elsif A_Proc_Ref.all in Processing_Resources.Network.Network'
                   Class
               then
                  Prev_Proc_Values.Network_Proc_Ref  := A_Proc_Ref;
                  Current_Proc_Kind := Network;
               else
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Kind of Processor is neither a Regular Processor" &
                       " nor a Network");
                  raise Tool_Exceptions.Tool_Failure;
               end if;

               if A_Sched_Policy_Ref.all in
                 Scheduling_Policies.Fixed_Priority_Policy'Class
               then
                  Min_System_Priority :=
                    Scheduling_Policies.Min_Priority
                      (Scheduling_Policies.Fixed_Priority_Policy'Class
                         (A_Sched_Policy_Ref.all));
                  Max_System_Priority :=
                    Scheduling_Policies.Max_Priority
                      (Scheduling_Policies.Fixed_Priority_Policy'Class
                         (A_Sched_Policy_Ref.all));
               else
                  Min_System_Priority := Priority'First;
                  Max_System_Priority := Priority'Last;
               end if;
               Min_Int_Priority := Min_System_Priority;
               Max_Int_Priority := Max_System_Priority;
               if A_Proc_Ref.all in
                 Processing_Resources.Processor.Regular_Processor'Class
               then
                  Max_Int_Priority :=
                    Processing_Resources.Processor.Max_Interrupt_Priority
                      (Processing_Resources.Processor.Regular_Processor'Class
                         (A_Proc_Ref.all));
                  Min_Int_Priority :=
                    Processing_Resources.Processor.Min_Interrupt_Priority
                      (Processing_Resources.Processor.Regular_Processor'Class
                         (A_Proc_Ref.all));
               end if;
               Min_Used_System_Priority :=
                 Get_Min_Used_System_Priority (The_System, A_Proc_Ref);

               -- Get task processor, and compare with the previous one,
               -- in order to add the coupled model driver's task which
               -- executes the send and receive operations in the driver
               -- when the RTA model is Coupled.

               if Prev_Proc_Values.Prev_Proc_Kind = None then
                  Prev_Proc_Values.Prev_Proc_Kind := Current_Proc_Kind;
               elsif Prev_Proc_Values.Prev_Proc_Kind = Processor then
                  Proc_Num := 
                    Get_Processor_Number 
                      (The_System, Prev_Proc_Values.Proc_Ref);
                  if Current_Proc_Kind = Network then
                     -- This is a message coming from a processor
                     Processing_Resources.Network.Rewind_Drivers
                       (Processing_Resources.Network.Network (A_Proc_Ref.all),
                        Drv_Iterator);
                     for D in
                       1 ..
                       Processing_Resources.Network.Num_Of_Drivers
                         (Processing_Resources.Network.Network (
                                                                A_Proc_Ref.all))
                     loop
                        Processing_Resources.Network.Get_Next_Driver
                          (Processing_Resources.Network.Network (A_Proc_Ref.all
                                                                ),
                           Drv_Ref,
                           Drv_Iterator);
                        if Drv_Ref.all in Drivers.Packet_Driver'Class then
                           case Drivers.Rta_Overhead_Model
                             (Drivers.Packet_Driver (Drv_Ref.all)) is
                              when Drivers.Coupled =>
                                 if Drv_Ref.all in
                                   Drivers.Character_Packet_Driver'Class
                                 then
                                    Drv_Server_Ref        :=
                                      Drivers.Character_Server
                                        (Drivers.Character_Packet_Driver'
                                           Class (Drv_Ref.all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;
                                    if Drivers.Character_Send_Operation
                                      (Drivers.Character_Packet_Driver'
                                         Class (Drv_Ref.all)) /=
                                      null
                                    then
                                       WS_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (
                                            Drivers.Character_Send_Operation
                                              (Drivers.
                                                 Character_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BS_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           (
                                            Drivers.Character_Send_Operation
                                              (Drivers.
                                                 Character_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WS_Ovhd := 0.0;
                                       BS_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then

                                       -- Add a send transaction before the
                                       -- activity that
                                       -- has a network processor.
                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WS_Ovhd,
                                          Cbijown               => BS_Ovhd,
                                          Cij                   => WS_Ovhd,
                                          Cbij                  => BS_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 elsif Drv_Ref.all in
                                   Drivers.RTEP_Packet_Driver'Class
                                 then
                                    Drv_Server_Ref        :=
                                      Drivers.Packet_Server
                                        (Drivers.RTEP_Packet_Driver'Class
                                           (Drv_Ref.all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;
                                    if Drivers.Packet_Send_Operation
                                      (Drivers.RTEP_Packet_Driver'Class
                                         ( Drv_Ref.all)) /=
                                      null
                                    then
                                       WS_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (Drivers.Packet_Send_Operation
                                              (Drivers.RTEP_Packet_Driver'
                                                 Class (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BS_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           (Drivers.Packet_Send_Operation
                                              (Drivers.RTEP_Packet_Driver'
                                                 Class (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WS_Ovhd := 0.0;
                                       BS_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then
                                       -- Add a send task before
                                       -- the activity that
                                       -- has a network processor.
                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WS_Ovhd,
                                          Cbijown               => BS_Ovhd,
                                          Cij                   => WS_Ovhd,
                                          Cbij                  => BS_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 else
                                    Drv_Server_Ref        :=
                                      Drivers.Packet_Server
                                        (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                        all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;
                                    if Drivers.Packet_Send_Operation
                                      (Drivers.Packet_Driver'Class
                                         (Drv_Ref.all)) /=
                                      null
                                    then
                                       WS_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (Drivers.Packet_Send_Operation
                                              (Drivers.Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BS_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           (Drivers.Packet_Send_Operation
                                              (Drivers.Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WS_Ovhd := 0.0;
                                       BS_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then
                                       -- Add a send task before
                                       -- the activity that
                                       -- has a network processor.

                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WS_Ovhd,
                                          Cbijown               => BS_Ovhd,
                                          Cij                   => WS_Ovhd,
                                          Cbij                  => BS_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 end if;
                              when others =>
                                 null;
                           end case;
                        end if;
                     end loop;
                     Prev_Proc_Values.Prev_Proc_Kind := Current_Proc_Kind;
                  end if;
               elsif Prev_Proc_Values.Prev_Proc_Kind = Network then
                  if Current_Proc_Kind = Processor then
                     Proc_Num :=
                       Get_Processor_Number (The_System, A_Proc_Ref);
                     Processing_Resources.Network.Rewind_Drivers
                       (Processing_Resources.Network.Network 
                          (Prev_Proc_Values.Network_Proc_Ref.all),
                        Drv_Iterator);
                     for D in
                       1 ..
                       Processing_Resources.Network.Num_Of_Drivers
                         (Processing_Resources.Network.Network
                            (Prev_Proc_Values.Network_Proc_Ref.all))
                     loop
                        Processing_Resources.Network.Get_Next_Driver
                          (Processing_Resources.Network.Network
                             (Prev_Proc_Values.Network_Proc_Ref.all),
                           Drv_Ref,
                           Drv_Iterator);
                        if Drv_Ref.all in Drivers.Packet_Driver'Class then
                           case Drivers.Rta_Overhead_Model
                             (Drivers.Packet_Driver (Drv_Ref.all)) is
                              when Drivers.Coupled =>
                                 if Drv_Ref.all in
                                   Drivers.Character_Packet_Driver'Class
                                 then
                                    Drv_Server_Ref        :=
                                      Drivers.Character_Server
                                        (Drivers.Character_Packet_Driver'
                                           Class (Drv_Ref.all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;

                                    if Drivers.Character_Receive_Operation
                                      (Drivers.Character_Packet_Driver'
                                         Class (Drv_Ref.all)) /=
                                      null
                                    then
                                       WR_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (
                                            Drivers.Character_Receive_Operation
                                              (Drivers.
                                                 Character_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BR_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           ( Drivers.Character_Receive_Operation
                                              (Drivers.
                                                 Character_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WR_Ovhd := 0.0;
                                       BR_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then
                                       -- Add a receive transaction after
                                       -- the activity
                                       -- that has a network processor,
                                       -- before the activity
                                       -- of the current Regular Processor.

                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WR_Ovhd,
                                          Cbijown               => BR_Ovhd,
                                          Cij                   => WR_Ovhd,
                                          Cbij                  => BR_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 elsif Drv_Ref.all in
                                   Drivers.RTEP_Packet_Driver'Class
                                 then
                                    Drv_Server_Ref        :=
                                      Drivers.Packet_Server
                                        (Drivers.RTEP_Packet_Driver'Class
                                           (Drv_Ref.all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;

                                    if Drivers.Packet_Receive_Operation
                                      (Drivers.RTEP_Packet_Driver'Class
                                         (Drv_Ref.all)) /=
                                      null
                                    then
                                       WR_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (
                                            Drivers.Packet_Receive_Operation
                                              (Drivers.RTEP_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BR_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           (
                                            Drivers.Packet_Receive_Operation
                                              (Drivers.RTEP_Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WR_Ovhd := 0.0;
                                       BR_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then
                                       -- Add a receive task after
                                       -- the activity
                                       -- that has a network processor,
                                       -- before the activity
                                       -- of the current Regular Processor.

                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WR_Ovhd,
                                          Cbijown               => BR_Ovhd,
                                          Cij                   => WR_Ovhd,
                                          Cbij                  => BR_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 else
                                    Drv_Server_Ref        :=
                                      Drivers.Packet_Server
                                        (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                        all));
                                    A_Sched_Param_Ref   :=
                                      Scheduling_Servers.
                                      Server_Sched_Parameters
                                        (Drv_Server_Ref.all);
                                    A_Synch_Param_Ref   :=
                                      Scheduling_Servers.
                                      Server_Synch_Parameters
                                        (Drv_Server_Ref.all);
                                    Driver_Proc_Ref     :=
                                      Scheduling_Servers.
                                      Server_Processing_Resource
                                        (Drv_Server_Ref.all);
                                    Driver_S_Policy_Ref :=
                                      Schedulers.Scheduling_Policy
                                        (
                                         Scheduling_Servers.Server_Scheduler
                                           (Drv_Server_Ref.all).all);
                                    Speed               :=
                                      Processing_Resources.Speed_Factor
                                        (Driver_Proc_Ref.all);
                                    if Driver_Proc_Ref.all in
                                      Processing_Resources.Network.Network'
                                        Class
                                    then
                                       Throughput :=
                                         Processing_Resources.Network.Throughput
                                           (Processing_Resources.Network.Network'
                                              Class (Driver_Proc_Ref.all));
                                    else
                                       Throughput := 0.0;
                                    end if;

                                    if Drivers.Packet_Receive_Operation
                                      (Drivers.Packet_Driver'Class
                                         (Drv_Ref.all)) /=
                                      null
                                    then
                                       WR_Ovhd :=
                                         Operations.Worst_Case_Execution_Time
                                           (
                                            Drivers.Packet_Receive_Operation
                                              (Drivers.Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                       BR_Ovhd :=
                                         Operations.Best_Case_Execution_Time
                                           (
                                            Drivers.Packet_Receive_Operation
                                              (Drivers.Packet_Driver'Class
                                                 (Drv_Ref.all)).all,
                                            Throughput) /
                                         Speed;
                                    else
                                       WR_Ovhd := 0.0;
                                       BR_Ovhd := 0.0;
                                    end if;

                                    if Proc_Num =
                                      Get_Processor_Number
                                        (The_System,
                                         Driver_Proc_Ref)
                                    then
                                       -- Add a receive task after
                                       -- the activity
                                       -- that has a network processor,
                                       -- before the activity
                                       -- of the current Regular Processor.

                                       Transaction (I).The_Task (J) :=
                                         (Cijown                => WR_Ovhd,
                                          Cbijown               => BR_Ovhd,
                                          Cij                   => WR_Ovhd,
                                          Cbij                  => BR_Ovhd,
                                          Tijown                =>
                                            Transaction (I).Ti,
                                          Tij                   =>
                                            Transaction (I).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            Transaction (I).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (I).The_Task (J).Pav);
                                       -- if interrupt priority, hard prio is
                                       --true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (I).The_Task (J).Pav.
                                         Hard_Prio :=
                                         Transaction (I).The_Task (J).Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (I).The_Task (J).Pav.
                                         Preassigned := True;
                                       Transaction (I).The_Task (J).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (I).The_Task (J).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       J := J + 1;
                                    end if;

                                 end if;
                              when others =>
                                 null;
                           end case;
                        end if;
                     end loop;
                  end if;
                  Prev_Proc_Values.Prev_Proc_Kind := Current_Proc_Kind;
               end if;

               -- Get Processor Number

               Proc_Num := Get_Processor_Number (The_System, A_Proc_Ref);

               -- If Activity is timed, and processor has an alarm clock
               -- system timer, add timer overhead

               if A_Proc_Ref.all in
                 Processing_Resources.Processor.Regular_Processor'Class
               then
                  Timer_Ref :=
                    Processing_Resources.Processor.The_System_Timer
                      (Processing_Resources.Processor.Regular_Processor'Class
                         (A_Proc_Ref.all));
               else
                  Timer_Ref := null;
               end if;
               Timer_Jitter := 0.0;
               if An_Event_Handler_Ref.all in
                 Graphs.Event_Handlers.System_Timed_Activity'Class
                 -- activity is timed
                 and then Timer_Ref /= null
                 -- there is a timer
                 and then not (J=1 and then 
                                 Transaction (I).Trans_Input_Type = Internal)
                 -- this is not the first task of an internal 
                 -- transaction (otherwise the overhead will have been
                 -- added to the previous transaction)
               then
                  if Timer_Ref.all in Timers.Alarm_Clock'Class then
                     Transaction (I).The_Task (J + 1)             :=
                       Transaction (I).The_Task (J);
                     Transaction (I).The_Task (J)                 :=
                       (Cijown                =>
                          Timers.Worst_Overhead (Timer_Ref.all) / Speed,
                        Cbijown               =>
                          Timers.Best_Overhead (Timer_Ref.all) / Speed,
                        Cij                   =>
                          Timers.Worst_Overhead (Timer_Ref.all) / Speed,
                        Cbij                  =>
                          Timers.Best_Overhead (Timer_Ref.all) / Speed,
                        Tijown                => Transaction (I).Ti,
                        -- remove *Accum_Rate_Factor,
                        Tij                   => Transaction (I).Ti,
                        -- remove *Accum_Rate_Factor,
                        Bij                   => 0.0,
                        Dij                   => Large_Time,
                        SDij                  => 0.0,
                        Schedij               => FP,
                        Preemptible           => True,
                        Oij                   => 0.0,
                        Jij                   => 0.0,
                        Jinit                 =>
                          Transaction (I).The_Task (J + 1).Jinit,
                        Sched_Delay           => 0.0,
                        Oijmin                => 0.0,
                        Oijmax                => 0.0,
                        Delayijmin            => 0.0,
                        Delayijmax            => 0.0,
                        Model                 => Regular,
                        Jitter_Avoidance      => False,
                        Uses_Shared_Resources => False,
                        Rij                   => 0.0,
                        Rbij                  => 0.0,
                        Prioij                =>
                          Processing_Resources.Processor.Max_Interrupt_Priority
                            (Processing_Resources.Processor.
                               Regular_Processor'Class (A_Proc_Ref.all)),
                        Procij                => Proc_Num,
                        Resij                 => null,
                        Max_Of_Best_Cases     => False,
                        Pav                   =>
                          Transaction (I).The_Task (J).Pav);
                     Transaction (I).The_Task (J + 1).Jinit       := 0.0;
                     Rate_Divided_Tasks(J+1) := 1;
                     Transaction (I).The_Task (J).Pav.Hard_Prio   := True;
                     Transaction (I).The_Task (J).Pav.Preassigned := True;
                     J                                            := J + 1;
                  elsif Timer_Ref.all in Timers.Ticker'Class then
                     Timer_Jitter :=
                       Timers.Period (Timers.Ticker'Class (Timer_Ref.all));
                  else
                     raise Incorrect_Object;
                  end if;
               end if;
               
               -- If the task is going to be independent, stop
               -- processing here; it will be resumed in the next
               -- call to add_simplified_transaction
               if  J>1 and then 
                 Mast.Scheduling_Servers.Server_Sched_Parameters
                   (A_Server_Ref.all).all in
                 Scheduling_Parameters.Sporadic_Server_Policy'Class
               then
                  Independent_Tasks:=True;
               else
                  -- Get Initial Delay, and static offset

                  case Prev_Handler_Values.Type_Of_Previous_Handler is
                     when Activity =>
                        Transaction (I).The_Task (J).Oijmin     := 0.0;
                        Transaction (I).The_Task (J).Oijmax     := 0.0;
                        Transaction (I).The_Task (J).Delayijmin := 0.0;
                        Transaction (I).The_Task (J).Delayijmax := 0.0;
                     when Offset_EH =>
                        Transaction (I).The_Task (J).Oijmin     := 
                          Prev_Handler_Values.Min_Delay;
                        Transaction (I).The_Task (J).Oijmax     := 
                          Prev_Handler_Values.Max_Delay;
                        Transaction (I).The_Task (J).Delayijmin := 0.0;
                        Transaction (I).The_Task (J).Delayijmax := 0.0;
                        -- Timer_Jitter is not changed here
                        -- the tools have to change it
                     when Delay_EH =>
                        Transaction (I).The_Task (J).Oijmin     := 0.0;
                        Transaction (I).The_Task (J).Oijmax     := 0.0;
                        Transaction (I).The_Task (J).Delayijmin := 
                          Prev_Handler_Values.Min_Delay;
                        Transaction (I).The_Task (J).Delayijmax := 
                          Prev_Handler_Values.Max_Delay;
                        -- Timer_Jitter is not changed here
                        -- the tools have to change it
                     when Rate_Divisor =>
                        null;
                        --Is done later
                        -- Removed because rate divisors are now treated by
                        -- replicating the part of the transaction previous 
                        -- to the rate divisor, and using offsets
                        --  Transaction (I).The_Task (J).Oijmin      := 0.0;
                        --  Transaction (I).The_Task (J).Oijmax      := 0.0;
                        --  Transaction (I).The_Task (J).Delayijmin  :=
                        --    Time(Rate_Factor-1)*
                        --    Accum_Rate_Factor*Transaction (I).Ti;
                        --  Transaction (I).The_Task (J).Delayijmax  :=
                        --    Time(Rate_Factor-1)*
                        --    Accum_Rate_Factor*Transaction (I).Ti;
                        --  if Transaction (I).Ti <
                        --    Large_Time * (1.0 + Epsilon)
                        --  then
                        --     Accum_Rate_Factor := Accum_Rate_Factor *
                        --       Time (Rate_Factor);
                        --  end if;
                  end case;

                  -- Set task's jitter
                  Transaction (I).The_Task (J).Jinit :=
                    Transaction (I).The_Task (J).Jinit + Timer_Jitter;

                  -- Get Priority
                  A_Sched_Param_Ref :=
                    Mast.Scheduling_Servers.Server_Sched_Parameters
                      (A_Server_Ref.all);
                  A_Synch_Param_Ref :=
                    Mast.Scheduling_Servers.Server_Synch_Parameters
                      (A_Server_Ref.all);
                  if A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Fixed_Priority_Parameters'Class
                  then
                     if New_Sched_Server_Detected then
                        Segment_Prio  :=
                          Mast.Scheduling_Parameters.The_Priority
                            (
                             Mast.Scheduling_Parameters.Fixed_Priority_Parameters'
                               Class (A_Sched_Param_Ref.all));
                        Segment_Dij   := 0.0;
                        Segment_Sched := FP;
                        
                        -- mgh 2026: Added the setting of the Preemptible flag
                        --Check if preemtible or not
                        Preemptible := 
                          not (A_Sched_Param_Ref.all in
                                 Scheduling_Parameters.
                                   Non_Preemptible_FP_Policy'Class);
                     end if;
                     
                     Transaction (I).The_Task (J).Pav.Preassigned :=
                       Mast.Scheduling_Parameters.Preassigned
                         (Mast.Scheduling_Parameters.Fixed_Priority_Parameters'
                            Class (A_Sched_Param_Ref.all));
                     if A_Sched_Param_Ref.all in
                       Scheduling_Parameters.Interrupt_FP_Policy'Class
                     then
                        Transaction (I).The_Task (J).Pav.Hard_Prio := True;
                     else
                        Transaction (I).The_Task (J).Pav.Hard_Prio   := False;
                        Transaction (I).The_Task (J).Pav.S_P_Ref     :=
                          A_Sched_Param_Ref;
                        Transaction (I).The_Task (J).Pav.Synch_P_Ref :=
                          A_Synch_Param_Ref;
                     end if;
                  elsif A_Sched_Param_Ref.all in
                    Scheduling_Parameters.EDF_Parameters'Class
                  then
                     Transaction (I).The_Task (J).Pav.S_P_Ref     :=
                       A_Sched_Param_Ref;
                     Transaction (I).The_Task (J).Pav.Synch_P_Ref :=
                       A_Synch_Param_Ref;
                     if New_Sched_Server_Detected then
                        Segment_Prio :=
                          Scheduling_Servers.Base_Priority (A_Server_Ref.all);
                        Segment_Dij  :=
                          Scheduling_Parameters.Deadline
                            (Mast.Scheduling_Parameters.EDF_Parameters'Class
                               (A_Sched_Param_Ref.all));

                        --For now, System-wide clock synchronization 
                        --availability is established by a flag to the 
                        --executable
                        if The_System.The_Processor_Analysis_Tool.isLocal then
                           Segment_Sched := EDF_Local;
                        else
                           Segment_Sched := EDF_Global;
                        end if;

                        Transaction (I).The_Task (J).Pav.Preassigned :=
                          Mast.Scheduling_Parameters.Preassigned
                            (Mast.Scheduling_Parameters.EDF_Parameters'
                               Class (A_Sched_Param_Ref.all));
                        --Force Hard_Prio to False for EDF tasks (this parameter
                        --should not be used for EDF)
                        --Transaction(I).The_Task(J).Pav.Hard_Prio := False;

                     end if;
                  end if;

                  -- Get Procij
                  Transaction (I).The_Task (J).Procij      := Proc_Num;
                  Transaction (I).The_Task (J).Pav.P_R_Ref := A_Proc_Ref;
                  if A_Sched_Policy_Ref.all in
                    Scheduling_Policies.Fixed_Priority_Policy'Class
                  then
                     Transaction (I).The_Task (J).Pav.S_Policy_Ref :=
                       Scheduling_Policies.Fixed_Priority_Policy_Ref
                         (A_Sched_Policy_Ref);
                  else
                     Transaction (I).The_Task (J).Pav.S_Policy_Ref := null;
                  end if;

                  -- Get Cij, Cbij, Prioij
                  Transaction_Operations.Get_Segment_Data_With_Permanent_FP
                    (Trans_Ref,
                     A_Link_Ref,
                     Next_Link_Ref,
                     Transaction (I).The_Task (J).Cij,
                     Transaction (I).The_Task (J).Cbij,
                     Transaction (I).The_Task (J).Uses_Shared_Resources,
                     Segment_Prio,
                     Preassigned_Prio,
                     Over_Ref);

                  Transaction (I).The_Task (J).Pav.Overridden_Ref := Over_Ref;
                  Transaction (I).The_Task (J).Prioij             :=
                    Segment_Prio;
                  -- mgh 2026: Set the preemptible flag
                  Transaction (I).The_Task (J).Preemptible         :=
                    Preemptible;
                  Transaction (I).The_Task (J).SDij               := 
                    Segment_Dij;
                  Transaction (I).The_Task (J).Schedij            :=
                    Segment_Sched;
                  -- Commented out because priority assignment does not
                  --  yet handle permanent overridden priorities

                  if Preassigned_Prio then
                     Transaction (I).The_Task (J).Pav.Preassigned := True;
                  end if;

                  if Transaction (I).Kind_Of_Event = Bursty then
                     Max_Arrivals                  :=
                       Mast.Events.Max_Arrivals
                         (Mast.Events.Bursty_Event'Class 
                            (External_Event_Ref.all));
                     Transaction (I).The_Task (J).Cij :=
                       Transaction (I).The_Task (J).Cij * Time (Max_Arrivals);
                  end if;
                  Transaction (I).The_Task (J).Cijown  :=
                    Transaction (I).The_Task (J).Cij;
                  Transaction (I).The_Task (J).Cbijown :=
                    Transaction (I).The_Task (J).Cbij;

                  -- Set Link for results
                  Transaction (I).The_Task (J).Resij := Next_Link_Ref;
                  
                  -- Get Bij

                  -- Calculate end of segment
                  Transaction_Operations.Identify_Segment_With_Permanent_FP
                    (Trans_Ref,
                     A_Link_Ref,
                     Nxt_Link_Ref);

                  if Mast.Graphs.Links.Has_Results
                    (Graphs.Links.Regular_Link (Nxt_Link_Ref.all))
                  then
                     A_Result_Ref                     :=
                       Mast.Graphs.Links.Link_Time_Results
                         (Mast.Graphs.Links.Regular_Link (Nxt_Link_Ref.all));
                     Transaction (I).The_Task (J).Bij :=
                       Mast.Results.Worst_Blocking_Time (A_Result_Ref.all);
                  else
                     Transaction (I).The_Task (J).Bij := 0.0;
                  end if;
                  if Transaction (I).Kind_Of_Event = Bursty then
                     Max_Arrivals                  :=
                       Mast.Events.Max_Arrivals
                         (Mast.Events.Bursty_Event'Class 
                            (External_Event_Ref.all));
                     Transaction (I).The_Task (J).Bij :=
                       Transaction (I).The_Task (J).Bij * Time (Max_Arrivals);
                  end if;

                  -- Get Dij
                  if Next_Link_Ref.all in Mast.Graphs.Links.Regular_Link'Class
                  then
                     A_Timing_Req_Ref :=
                       Mast.Graphs.Links.Link_Timing_Requirements
                         (Mast.Graphs.Links.Regular_Link (Next_Link_Ref.all));
                     if A_Timing_Req_Ref /= null
                       and then A_Timing_Req_Ref.all in
                       Timing_Requirements.Hard_Global_Deadline'Class
                     then
                        Transaction (I).The_Task (J).Dij :=
                          Mast.Timing_Requirements.The_Deadline
                            (Mast.Timing_Requirements.Deadline'Class
                               (A_Timing_Req_Ref.all));
                        if Analysis_Bound <
                          Transaction (I).The_Task (J).Dij
                        then
                           Analysis_Bound := Transaction (I).The_Task (J).Dij;
                        end if;
                     else
                        Transaction (I).The_Task (J).Dij := Large_Time;
                     end if;
                  else
                     raise Incorrect_Object;
                  end if;

                  -- Get Tij, Tijown
                  Transaction (I).The_Task (J).Tij    := Transaction (I).Ti;
                  --remove *Accum_Rate_Factor;
                  Transaction (I).The_Task (J).Tijown := Transaction (I).Ti;
                  --remove *Accum_Rate_Factor;
                  if Analysis_Bound < Transaction (I).The_Task (J).Tij then
                     Analysis_Bound := Transaction (I).The_Task (J).Tij;
                  end if;

                  -- Consider scheduling policies
                  if A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Fixed_Priority_Policy'Class
                    or else A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Non_Preemptible_FP_Policy'Class
                    or else A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Interrupt_FP_Policy'Class
                    or else A_Sched_Param_Ref.all in
                    Scheduling_Parameters.EDF_Policy'Class
                  then
                     case Transaction (I).Kind_Of_Event is
                        when Periodic | Sporadic | Bursty =>
                           Transaction (I).The_Task (J).Model := Regular;
                        when Unbounded =>
                           Transaction (I).The_Task (J).Model :=
                             Unbounded_Effects;
                     end case;
                  elsif A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Sporadic_Server_Policy'Class
                  then
                     declare
                        Css     : constant Time :=
                          Scheduling_Parameters.Initial_Capacity
                            (Scheduling_Parameters.Sporadic_Server_Policy'Class
                               (A_Sched_Param_Ref.all));
                        Tss     : constant Time :=
                          Scheduling_Parameters.Replenishment_Period
                            (Scheduling_Parameters.Sporadic_Server_Policy'Class
                               ( A_Sched_Param_Ref.all));
                        Cswitch : Time := 0.0;
                     begin
                        -- tbd: check what to do if there are rate divisors
                        -- and sporadic servers
                        if Scheduling_Parameters.Background_Priority
                          (Scheduling_Parameters.Sporadic_Server_Policy'Class
                             (A_Sched_Param_Ref.all)) >=
                          Min_Used_System_Priority
                        then
                           Transaction (I).The_Task (J).Model :=
                             Unbounded_Effects;
                           if Verbose then
                              Put_Line
                                ("Background prio of scheduling server " &
                                   To_String
                                     (Scheduling_Servers.Name (A_Server_Ref)) &
                                   " is too high");
                           end if;
                        else
                           if A_Proc_Ref.all in
                             Processing_Resources.Processor.Processor'Class
                           then
                              Cswitch :=
                                Scheduling_Policies.Worst_Context_Switch
                                  (Scheduling_Policies.Fixed_Priority'Class
                                     (A_Sched_Policy_Ref.all)) /
                                Speed;
                           end if;
                           case Transaction (I).Kind_Of_Event is
                              when Periodic | Sporadic | Bursty =>
                                 -- check if enough capacity
                                 if (Css / Tss) * (1.0 + Epsilon) >=
                                   Transaction (I).The_Task (J).Cij /
                                   (Transaction (I).Ti *
                                      Time(Cumulative_Rate_Factor))
                                 then -- enough capacity
                                    if Tss >
                                      (Transaction (I).Ti *
                                         Time(Cumulative_Rate_Factor))
                                    then -- case 1
                                       Transaction (I).The_Task (J).Sched_Delay
                                         := Tss - Css;
                                       Transaction (I).The_Task (J).Cij := Css +
                                         2.0 *
                                         Cswitch;
                                       Transaction (I).The_Task (J).Cbij := 0.0;
                                       Transaction (I).The_Task (J).Tij := Tss;
                                       Transaction (I).The_Task (J).
                                         Jitter_Avoidance := True;
                                       Transaction (I).The_Task (J).Model :=
                                         Separate_Analysis;
                                    else -- case 2
                                       if Css >=
                                         Transaction (I).The_Task (J).Cij
                                       then
                                          -- case 2.1
                                          Transaction (I).The_Task (J).Cij  :=
                                            Css + 2.0 * Cswitch;
                                          Transaction (I).The_Task (J).Cbij :=
                                            0.0;
                                          Transaction (I).The_Task (J).Tij  :=
                                            Tss;
                                          Transaction (I).The_Task (J).
                                            Jitter_Avoidance                :=
                                            True;
                                          Transaction (I).The_Task (J).Model :=
                                            Separate_Analysis;
                                       else
                                          -- case 2.2
                                          Transaction (I).The_Task (J).
                                            Sched_Delay :=
                                            (Time'Ceiling
                                               (Transaction (I).The_Task (J).
                                                  Cijown /
                                                  Css) -
                                               1.0) *
                                            Tss +
                                            Tss -
                                            Css;
                                          Transaction (I).The_Task (J).Cij :=
                                            Css + 2.0 * Cswitch;
                                          Transaction (I).The_Task (J).Cbij :=
                                            0.0;
                                          Transaction (I).The_Task (J).Tij :=
                                            Tss;
                                          Transaction (I).The_Task (J).
                                            Jitter_Avoidance := True;
                                          Transaction (I).The_Task (J).Model :=
                                            Separate_Analysis;
                                       end if;
                                    end if;
                                 else -- not enough capacity
                                    Transaction (I).The_Task (J).Cij  := Css +
                                      2.0 *
                                      Cswitch;
                                    Transaction (I).The_Task (J).Cbij := 0.0;
                                    Transaction (I).The_Task (J).Tij  := Tss;
                                    Transaction (I).The_Task (J).
                                      Jitter_Avoidance:= True;
                                    Transaction (I).The_Task (J).Model :=
                                      Unbounded_Response;
                                 end if;
                              when Unbounded =>
                                 Transaction (I).The_Task (J).Cij            :=
                                   Css + 2.0 * Cswitch;
                                 Transaction (I).The_Task (J).Cbij           :=
                                   0.0;
                                 Transaction (I).The_Task (J).Tij            :=
                                   Tss;
                                 Transaction (I).The_Task (J).Tijown         :=
                                   Tss;
                                 Transaction (I).The_Task (J).
                                   Jitter_Avoidance := True;
                                 Transaction (I).The_Task (J).Model          :=
                                   Unbounded_Response;
                           end case;
                        end if;
                     end;
                  elsif A_Sched_Param_Ref.all in
                    Scheduling_Parameters.Polling_Policy'Class
                  then
                     declare
                        Tpoll        : constant Time            :=
                          Scheduling_Parameters.Polling_Period
                            (Scheduling_Parameters.Polling_Policy'Class
                               (A_Sched_Param_Ref.all));
                        Speed_Factor : constant Processor_Speed :=
                          Processing_Resources.Speed_Factor (A_Proc_Ref.all);
                        Cpoll        : constant Time            :=
                          Scheduling_Parameters.Polling_Worst_Overhead
                            (Scheduling_Parameters.Polling_Policy'Class
                               (A_Sched_Param_Ref.all)) /
                          Speed_Factor;
                        Cbpoll       : constant Time            :=
                          Scheduling_Parameters.Polling_Best_Overhead
                            (Scheduling_Parameters.Polling_Policy'Class
                               (A_Sched_Param_Ref.all)) /
                          Speed_Factor;
                        Ovhd_Task, Event_Processing_Task : Task_Data;
                        Num_Of_Equivalent_Tasks : Task_ID_Type;
                        Bound_Interval : Time;
                     begin
                        -- tbd: check what to do if there are rate divisors
                        -- and polling servers
                        case Transaction (I).Kind_Of_Event is
                           when Periodic | Sporadic =>
                              if Tpoll <
                                (Transaction (I).Ti *
                                   Time(Cumulative_Rate_Factor))
                              then
                                 -- case 1
                                 --Transaction(I).The_Task(J).Sched_Delay:=
                                 --  Tpoll-
                                 --  Time'Min(Tpoll,Transaction (I).Ti *
                                 --  Time(Cumulative_Rate_Factor)-Tpoll);
                                 Transaction (I).The_Task (J).Jinit :=
                                   Transaction (I).The_Task (J).Jinit + Tpoll;
                                 Transaction (I).The_Task (J).Model := Regular;

                                 -- add additional polling overhead
                                 if Tpoll * (1.0 + Epsilon) <
                                   (Transaction (I).Ti *
                                      Time(Cumulative_Rate_Factor))
                                 then
                                    Ovhd_Task                :=
                                      Task_Data'
                                        (Cijown                => Cpoll,
                                         Cbijown               => Cbpoll,
                                         Cij                   => Cpoll,
                                         Cbij                  => Cbpoll,
                                         Tijown                =>
                                           (Transaction (I).Ti *
                                              Time(Cumulative_Rate_Factor)) *
                                             Tpoll /
                                             (Transaction (I).Ti *
                                                Time(Cumulative_Rate_Factor) -
                                                Tpoll),
                                         Tij                   =>
                                           (Transaction (I).Ti *
                                              Time(Cumulative_Rate_Factor)) *
                                             Tpoll /
                                             (Transaction (I).Ti *
                                                Time(Cumulative_Rate_Factor) -
                                                Tpoll),
                                         Bij                   => 0.0,
                                         Dij                   => Large_Time,
                                         SDij                  => 0.0,
                                         Schedij               => FP,
                                         Preemptible           => True,
                                         Oij                   => 0.0,
                                         Jij                   => 0.0,
                                         Jinit                 =>
                                           Transaction (I).Ti *
                                             Time(Cumulative_Rate_Factor) *
                                             Tpoll /
                                             (Transaction (I).Ti *
                                                Time(Cumulative_Rate_Factor) -
                                                Tpoll),
                                         Sched_Delay           => 0.0,
                                         Oijmin                => 0.0,
                                         Oijmax                => 0.0,
                                         Delayijmin            => 0.0,
                                         Delayijmax            => 0.0,
                                         Model                 => Regular,
                                         Jitter_Avoidance      => False,
                                         Uses_Shared_Resources => False,
                                         Rij                   => 0.0,
                                         Rbij                  => 0.0,
                                         Prioij                =>
                                           Transaction (I).The_Task (J).Prioij,
                                         Procij                =>
                                           Transaction (I).The_Task (J).Procij,
                                         Resij                 => null,
                                         Max_Of_Best_Cases     => False,
                                         Pav                   =>
                                           Transaction (I).The_Task (J).Pav);
                                    Ovhd_Task.Pav.Is_Polling := True;
                                    Overhead_Task_Lists.Add
                                      (Ovhd_Task,
                                       Overhead_Task_List);
                                    Transaction (I).The_Task (J).
                                      Pav.Hard_Prio := False;
                                 end if;

                              elsif Tpoll =
                                (Transaction (I).Ti *
                                   Time(Cumulative_Rate_Factor))
                              then
                                 -- case 2
                                 Transaction (I).The_Task (J).Tij   := Tpoll;
                                 Transaction (I).The_Task (J).Sched_Delay := 
                                   Tpoll;
                                 Transaction (I).The_Task (J).Model := Regular;


                              else -- case 3
                                 Transaction (I).The_Task (J).Tij   := Tpoll;
                                 Transaction (I).The_Task (J).Model :=
                                   Unbounded_Response;
                              end if;
                           when Bursty =>
                              
                              -- May 2025: Changed from a very
                              -- pessimistic model in which an event
                              -- was processed every polling period to
                              -- a more accurate model in which a
                              -- transaction with a period equal to
                              -- the bursty interval is created, with
                              -- a number of initial tasks equal to
                              -- max_arrivals, execution time of Cij,
                              -- and offsets starting from Tpoll and
                              -- increasing by Tpoll for each event.
                              -- In addition, a set of final tasks is
                              -- added to this transaction, separated
                              -- by offsets increasing in Tpoll
                              -- intervals to complete the polling
                              -- Bound_Interval. The execution time of
                              -- these overhead tasks is Cpoll.
                              -- This model is implemented only for 
                              -- simple transactions with only one task.
                              
                              Max_Arrivals                  :=
                                Mast.Events.Max_Arrivals
                                  (Mast.Events.Bursty_Event'Class
                                     (External_Event_Ref.all));
                              Bound_Interval := Mast.Events.Bound_Interval
                                  (Mast.Events.Bursty_Event'Class
                                     (External_Event_Ref.all));
                              Num_Of_Equivalent_Tasks := 
                                Task_ID_Type(Time'Ceiling
                                               (Bound_Interval / Tpoll));
                              
                              Transaction (I).The_Task (J).Cij    :=
                                Transaction (I).The_Task (J).Cij /
                                Time (Max_Arrivals);
                              Transaction (I).The_Task (J).Cijown :=
                                Transaction (I).The_Task (J).Cijown /
                                Time (Max_Arrivals);
                              Transaction (I).The_Task (J).Bij    :=
                                Transaction (I).The_Task (J).Bij /
                                Time (Max_Arrivals);
                              Transaction (I).The_Task (J).Tij :=
                                Bound_Interval;
                              Transaction (I).The_Task (J).Tijown :=
                                Bound_Interval;
                              if Tpoll *
                                Time (Max_Arrivals) *
                                (1.0 - Epsilon) <= Bound_Interval
                                -- Mast.Events.Bound_Interval
                                --  (Mast.Events.Bursty_Event'Class
                                --     (External_Event_Ref.all))
                              then
                                 -- case 1 : enough capacity
                                 
                                 -- Check that the equivalent tasks
                                 -- fit in the transaction
                                 if Max_Arrivals > 
                                   Natural(Num_Of_Equivalent_Tasks) 
                                 then
                                    Set_Exception_Message
                                      ("Equivalent tasks in burst+polling do "&
                                         "not fit in the transaction");
                                    raise Internal_Inconsistency;
                                 end if;
                                 
                                 -- Check that the transaction has only one task
                                 if Transaction(I).Ni /= 1 or else J /= 1 then
                                    Set_Exception_Message
                                      ("Transaction with burst+polling has "&
                                         "more than one task");
                                    raise Internal_Inconsistency;
                                 end if;
                                 
                                 -- Prepare data for equivalent transaction
                                 Transaction(I).Ni := Num_Of_Equivalent_Tasks;
                                 Transaction(I).The_Task(J).Oijmax := Tpoll;
                                 Transaction(I).The_Task(J).Oijmin := 0.0;
                                 
                                 -- Add more tasks to process external events
                                 Event_Processing_Task := 
                                   Transaction(I).The_Task(J);
                                 for K in 2..Max_Arrivals loop
                                    Event_Processing_Task.Oijmax :=
                                      Event_Processing_Task.Oijmax + Tpoll;
                                    Event_Processing_Task.Oijmin :=
                                      Event_Processing_Task.Oijmin + Tpoll;
                                    Transaction(I).The_Task(Task_ID_Type(K)) := 
                                      Event_Processing_Task;
                                 end loop;
                                 
                                 -- Add more tasks to model polling overhead
                                 Ovhd_Task                :=
                                   Task_Data'
                                     (Cijown                => Cpoll,
                                      Cbijown               => Cbpoll,
                                      Cij                   => Cpoll,
                                      Cbij                  => Cbpoll,
                                      Tijown                => Bound_Interval,
                                      Tij                   => Bound_Interval,
                                      Bij                   => 0.0,
                                      Dij                   => Large_Time,
                                      SDij                  => 0.0,
                                      Schedij               => FP,
                                      Preemptible           => True,
                                      Oij                   => 0.0,
                                      Jij                   => 0.0,
                                      Jinit                 => 0.0,
                                      Sched_Delay           => 0.0,
                                      Oijmin                => 
                                        Transaction (I).The_Task 
                                          (Task_ID_Type(Max_Arrivals)).Oijmax -
                                          Tpoll,
                                      Oijmax                => 
                                        Transaction (I).The_Task 
                                          (Task_ID_Type(Max_Arrivals)).Oijmax,
                                      Delayijmin            => 0.0,
                                      Delayijmax            => 0.0,
                                      Model                 => Regular,
                                      Jitter_Avoidance      => False,
                                      Uses_Shared_Resources => False,
                                      Rij                   => 0.0,
                                      Rbij                  => 0.0,
                                      Prioij                =>
                                        Transaction (I).The_Task (J).Prioij,
                                      Procij                =>
                                        Transaction (I).The_Task (J).Procij,
                                      Resij                 => null,
                                      Max_Of_Best_Cases     => False,
                                      Pav                   =>
                                        Transaction (I).The_Task (J).Pav);
                                 Ovhd_Task.Pav.Is_Polling := True;
                                 Ovhd_Task.Pav.Hard_Prio := False;
                                 
                                 for K in Task_ID_Type(Max_Arrivals+1) .. 
                                   Num_Of_Equivalent_Tasks 
                                 loop
                                    Ovhd_Task.Oijmax :=
                                      Ovhd_Task.Oijmax + Tpoll;
                                    Ovhd_Task.Oijmin :=
                                      Ovhd_Task.Oijmin + Tpoll;
                                    Transaction(I).The_Task(K) := 
                                      Ovhd_Task;
                                 end loop;
                                 
                                 -- update index for event handlers
                                 J := Num_Of_Equivalent_Tasks;

                                 -- May 2025: Previous model is left here commented
                                 -- -- mar 2025: The scheduling delay was too small
                                 -- -- previously Tpoll * Time (Max_Arrivals - 1)
                                 -- -- now increased to Tpoll * Time (Max_Arrivals)
                                 -- Transaction (I).The_Task (J).Sched_Delay :=
                                 --   Tpoll * Time (Max_Arrivals);
                                 -- -- mar 2025: There was excessive jitter
                                 -- --           Commented out this line
                                 -- -- Transaction (I).The_Task (J).Jinit       :=
                                 -- --  Transaction (I).The_Task (J).Jinit + Tpoll;
                                 -- Transaction (I).The_Task (J).Model       :=
                                 --   Regular;
                                 
                                 -- -- Add additional polling overhead
                                 -- -- Equivalent task with C=Cpoll and T=Tpoll
                                 -- Ovhd_Task                :=
                                 --   Task_Data'
                                 --     (Cijown                => Cpoll,
                                 --      Cbijown               => Cbpoll,
                                 --      Cij                   => Cpoll,
                                 --      Cbij                  => Cbpoll,
                                 --      Tijown                => Tpoll,
                                 --      Tij                   => Tpoll,
                                 --      Bij                   => 0.0,
                                 --      Dij                   => Large_Time,
                                 --      SDij                  => 0.0,
                                 --      Schedij               => FP,
                                 --      Oij                   => 0.0,
                                 --      Jij                   => 0.0,
                                 --      Jinit                 => 0.0,
                                 --      Sched_Delay           => 0.0,
                                 --      Oijmin                => 0.0,
                                 --      Oijmax                => 0.0,
                                 --      Delayijmin            => 0.0,
                                 --      Delayijmax            => 0.0,
                                 --      Model                 => Regular,
                                 --      Jitter_Avoidance      => False,
                                 --      Uses_Shared_Resources => False,
                                 --      Rij                   => 0.0,
                                 --      Rbij                  => 0.0,
                                 --      Prioij                =>
                                 --        Transaction (I).The_Task (J).Prioij,
                                 --      Procij                =>
                                 --        Transaction (I).The_Task (J).Procij,
                                 --      Resij                 => null,
                                 --      Max_Of_Best_Cases     => False,
                                 --      Pav                   =>
                                 --        Transaction (I).The_Task (J).Pav);
                                 -- Ovhd_Task.Pav.Is_Polling := True;
                                 -- Overhead_Task_Lists.Add
                                 --   (Ovhd_Task,
                                 --    Overhead_Task_List);
                                 -- Transaction (I).The_Task (J).
                                 --   Pav.Hard_Prio := False;
                                 
                              else -- case 2: not enough capacity
                                 Transaction (I).The_Task (J).Tij := Tpoll;
                                 Transaction (I).The_Task (J).Model :=
                                   Unbounded_Response;
                              end if;
                           when Unbounded =>
                              Transaction (I).The_Task (J).Tij    := Tpoll;
                              Transaction (I).The_Task (J).Tijown := Tpoll;
                              Transaction (I).The_Task (J).Model  :=
                                Unbounded_Response;
                        end case;
                     end;
                  else
                     Tool_Exceptions.Set_Tool_Failure_Message
                       ("Fixed priority scheduling policy not supported");
                     raise Tool_Exceptions.Tool_Failure;
                  end if;
               end if; -- independent tasks
                       -- Current Handler is an activity; set values for 
                       -- next time
               Prev_Handler_Values.Min_Delay := 0.0;
               Prev_Handler_Values.Max_Delay := 0.0;
               Prev_Handler_Values.Type_Of_Previous_Handler := Activity;
            else
               -- The event handler is of an unknown type
               Set_Exception_Message("Event Handler of unknown class");
               raise Internal_Inconsistency;
            end if; -- for event_handler check

            -- Finish event handler loop
            exit when 
              Graphs.Output_Event_Handler (Next_Link_Ref.all) = null or else
              Independent_Tasks or else Multipath_Handler;

            J          := J + 1;
            A_Link_Ref := Next_Link_Ref;

         end loop; -- event handler loop
         
         if Independent_Tasks then
            J:=J-1;
         end if;
         
         -- Get Ni
         Transaction (I).Ni := J;

         -- Expand transaction with rate divisors into equivalent model
         if Period_Should_Be_Increased then
            Offset_Requirements := (others => False);
            Expand_Rate_Divided_Transaction
              (Transaction,Rate_Divided_Tasks,Offset_Requirements,I,1,J);

            -- Set the offsets required in the model
            Offset:=0.0;
            for K in 1..Transaction(I).Ni loop
               if Offset_Requirements(K) then
                  -- new offset increase needed
                  Offset:=Offset+Transaction (I).Ti;
                  if Debug then
                     Put_Line("Offset at: "&K'Img);
                  end if;
                  
               end if;
               Transaction(I).The_Task(K+1).Oijmax:=
                 Transaction(I).The_Task(K+1).Oijmax+Offset;
               Transaction(I).The_Task(K+1).Oijmin:=
                 Transaction(I).The_Task(K+1).Oijmin+Offset;
            end loop;
            -- Adjust the period of the transaction
            Transaction (I).Ti := Transaction (I).Ti *
              Time(Trans_Ref.all.Cumulative_Rate_Factor);
         end if;


         -- Check if there are unbounded events that are not
         -- scheduled properly
         for T in 1 .. Transaction (I).Ni loop
            if Transaction (I).The_Task (T).Model = Unbounded_Effects and then
              Verbose
            then
               Put_Line
                 ("Warning: Transaction " &
                    Transactions.Name (Trans_Ref) &
                    " has unbounded event");
            end if;
         end loop;

         -- Split independent tasks into several transactions
         if Independent_Tasks then
            
            -- New transaction will have index Last_Trans_Index+1
            Last_Trans_Index:=Last_Trans_Index+1;
            
            Transaction (Last_Trans_Index).Trans_Input_Type := Internal;
            Transaction (Last_Trans_Index).Ti  := Transaction (I).Ti;
            Transaction (Last_Trans_Index).Evi := Transaction (I).Evi;
            Transaction (Last_Trans_Index).Kind_Of_Event :=
              Transaction (I).Kind_Of_Event;
            
            -- prececessor and successor
            Transaction (Last_Trans_Index).Predecessor_Trans_Ref := 
              new Transaction_Id_Array(1..1);
            Transaction (Last_Trans_Index).Predecessor_Trans_Ref(1):=I;
            Transaction (I).Successor_Trans_Ref := 
              new Transaction_Id_Array(1..1);
            Transaction (I).Successor_Trans_Ref(1):=Last_Trans_Index;
            
            Prev_Proc_Values:=(None,null,null); 
            -- because overheads have already been added
            
            Add_Simplified_Transaction
              (Current_Trans_Id,Trans_Ref,External_Event_Ref,
               A_Link_Ref,Last_Trans_Index,Prev_Proc_Values,
               Prev_Handler_Values, Last_Trans_Index);
         end if;
         
      end Add_Simplified_Transaction;
      
      
      Trans_Ref                               :
        Mast.Transactions.Transaction_Ref;
      A_Server_Ref                            :
        Mast.Scheduling_Servers.Scheduling_Server_Ref;
      A_Sched_Param_Ref                       :
        Mast.Scheduling_Parameters.Sched_Parameters_Ref;
      A_Synch_Param_Ref                       :
        Mast.Synchronization_Parameters.Synch_Parameters_Ref;
      A_Proc_Ref                              :
        Mast.Processing_Resources.Processing_Resource_Ref;
      A_Sched_Policy_Ref                      :
        Mast.Scheduling_Policies.Scheduling_Policy_Ref;
      A_Link_Ref                              : Mast.Graphs.Link_Ref;
      An_Event_Ref                            : Mast.Events.Event_Ref;
      Trans_Iterator                          :
        Transactions.Lists.Iteration_Object;
      EE_Iterator                             :
        Transactions.Link_Iteration_Object;
      Proc_Iterator                           :
        Processing_Resources.Lists.Iteration_Object;
      Proc_Num                                : Processor_ID_Type;
      Last_Trans_Id                           : Transaction_ID_Type;
      I, Current_Trans, Num_Trans        : Transaction_ID_Type;
      --    These are the current transaction indexes
      Timer_Ref                          : Timers.System_Timer_Ref;
      WS_Ovhd, WR_Ovhd, BS_Ovhd, BR_Ovhd : Time;
      Speed, Speed_ISR                   : Processor_Speed;
      pragma Unreferenced (Speed_ISR);
      Drv_Iterator                       :
        Processing_Resources.Network.Driver_Iteration_Object;
      Drv_Ref                            : Drivers.Driver_Ref;
      Min_Int_Priority                   : Priority;
      Max_Int_Priority                   : Priority;

      --  The following variables are used by the
      --  RT-EP driver transactions
      ISR_Server_Ref                               :
        Mast.Scheduling_Servers.Scheduling_Server_Ref;
      ISR_Sched_Param_Ref                          :
        Mast.Scheduling_Parameters.Sched_Parameters_Ref;
      ISR_Synch_Param_Ref                          :
        Mast.Synchronization_Parameters.Synch_Parameters_Ref;
      Driver_Proc_Ref, Driver_ISR_Proc_Ref         :
        Mast.Processing_Resources.Processing_Resource_Ref;
      Driver_S_Policy_Ref, Driver_ISR_S_Policy_Ref :
        Mast.Scheduling_Policies.Scheduling_Policy_Ref;
      -- Worst/Best Execution Times for the RT-EP Driver Operations
      WISR_Ovhd, WTC_Ovhd, WTM_Ovhd, WPD_Ovhd, WTR_Ovhd, WPR_Ovhd : Time;
      BISR_Ovhd, BTC_Ovhd, BTM_Ovhd, BPD_Ovhd, BTR_Ovhd, BPR_Ovhd : Time;
      Min_PTT                                                     :
        Normalized_Execution_Time; -- Minimum Packet Transmission Time
      CSwitch                                                     : Time;
      -- Context Switch Time
      number_stations                                             : Positive;
      -- Number of Staions (RT-EP driver constant)
      token_delay                                                 : Time;
      -- Token delay (RT-EP driver constant)
      failure_timeout                                             : Time;
      -- Failure Timeout (Error Handling RT-EP constant)
      max_blocking                                                :
        Normalized_Execution_Time; -- Network Maximum Blocking Time
      pragma Unreferenced (max_blocking);
      token_retries, t_r                                          : Natural;
      -- Token Retransmission Retries
      packet_retries, p_r                                         : Natural;
      -- Packet Retransmission Retries
      
      Throughput : Throughput_Value:=0.0;
      
      Prev_Proc_Values     : constant Prev_Processor_Values_Type:=(None,null,null);
      
      Prev_Handler_Values : Prev_Handler_Values_Type;

   begin
      -- Assumes Restricted_Multipath_Transactions_Only:
      --  - no merge(concentrator) or branch (delivery server or query server)
      --  - only one external event per transaction
      --  - no rate divisors in multipath transactions (those containing fork
      --    (multicast) or join(barrier)
      Analysis_Bound := 0.0;
      Mast.Transactions.Lists.Rewind
        (The_System.Transactions,
         Trans_Iterator);
      Last_Trans_Id :=0;
      Num_Trans:= Transaction_ID_Type (Transactions.Lists.Size
                                         (The_System.Transactions));
      
      -- Added Feb-2025 to prevent using uninitialized transaction ids
      -- Then deleted, as it was found unnecessary
      -- Initialize all transaction Ids to zeros
      -- for I in Transaction_ID_Type range 1..Max_Transactions loop
      --    Transaction(I).Transaction_Id:=0;
      -- end loop;
      
      -- loop for all transactions
      for Current_Trans_Id in Transaction_ID_Type range 1 ..Num_Trans 
      loop
         Last_Trans_Id:=Last_Trans_Id+1;
         I := Last_Trans_Id;
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,
            The_System.Transactions,
            Trans_Iterator);
         
         -- Get First Event Link
         Mast.Transactions.Rewind_External_Event_Links
           (Trans_Ref.all,
            EE_Iterator);
         Mast.Transactions.Get_Next_External_Event_Link
           (Trans_Ref.all,
            A_Link_Ref,
            EE_Iterator);
         
         --Translate each transaction

         Transaction (I).Trans_Input_Type := External;

         -- Get Evi, Ti, and kind_of_event for first event
         -- Initial phase is considered zero for worst-case analysis
         An_Event_Ref        := Mast.Graphs.Event_Of (A_Link_Ref.all);
         Transaction (I).Evi := An_Event_Ref;
         if An_Event_Ref.all in Mast.Events.Periodic_Event'Class then
            Transaction (I).Ti                 :=
              Mast.Events.Period
                (Mast.Events.Periodic_Event'Class (An_Event_Ref.all));
            
            Transaction (I).Kind_Of_Event      := Periodic;
         elsif An_Event_Ref.all in Mast.Events.Sporadic_Event'Class then
            Transaction (I).Ti            :=
              Mast.Events.Min_Interarrival
                (Mast.Events.Sporadic_Event'Class (An_Event_Ref.all));

            Transaction (I).Kind_Of_Event := Sporadic;
         elsif An_Event_Ref.all in Mast.Events.Singular_Event'Class then
            Transaction (I).Ti            := Large_Time;
            Transaction (I).Kind_Of_Event := Periodic;
         elsif An_Event_Ref.all in Mast.Events.Unbounded_Event'Class then
            Transaction (I).Ti            := Large_Time; -- So that analysis
                                                         --converges
            Transaction (I).Kind_Of_Event := Unbounded;
         elsif An_Event_Ref.all in Mast.Events.Bursty_Event'Class then
            Transaction (I).Ti            :=
              Mast.Events.Bound_Interval
                (Mast.Events.Bursty_Event'Class (An_Event_Ref.all));
            Transaction (I).Kind_Of_Event := Bursty;
         else
            raise Incorrect_Object;
         end if;
         
         Prev_Handler_Values.Min_Delay := 0.0;
         Prev_Handler_Values.Max_Delay := 0.0;
         Prev_Handler_Values.Type_Of_Previous_Handler := Activity;
         
         Add_Simplified_Transaction
           (Current_Trans_Id,Trans_Ref,An_Event_Ref,A_Link_Ref,I,
            Prev_Proc_Values,Prev_Handler_Values,Last_Trans_Id);
         
      end loop; -- Transaction loop
      
      Current_Trans := Last_Trans_Id;

      Analysis_Bound  := Analysis_Bound * Time (Max_OverDeadline);
      Max_Busy_Period := Analysis_Bound * Time (Max_OverDeadline);

      -- Add Processing Resource Overhead Tasks and Transactions

      Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,
         Proc_Iterator);
      Proc_Num := 0;
      for I in
        1 ..
        Processing_Resources.Lists.Size (The_System.Processing_Resources)
      loop
         Processing_Resources.Lists.Get_Next_Item
           (A_Proc_Ref,
            The_System.Processing_Resources,
            Proc_Iterator);
         Proc_Num := Proc_Num + 1;
         Speed    := Processing_Resources.Speed_Factor (A_Proc_Ref.all);
         if A_Proc_Ref.all in Processing_Resources.Network.Network'Class then
            Throughput :=
              Processing_Resources.Network.Throughput
                (Processing_Resources.Network.Network'Class (A_Proc_Ref.all));
         else
            Throughput := 0.0;
         end if;

         if A_Proc_Ref.all in Processing_Resources.Network.Network'Class then

            -- add the tasks and transactions associated
            -- with the network drivers
            Processing_Resources.Network.Rewind_Drivers
              (Processing_Resources.Network.Network (A_Proc_Ref.all),
               Drv_Iterator);
            for D in
              1 ..
              Processing_Resources.Network.Num_Of_Drivers
                (Processing_Resources.Network.Network (A_Proc_Ref.all))
            loop
               Processing_Resources.Network.Get_Next_Driver
                 (Processing_Resources.Network.Network (A_Proc_Ref.all),
                  Drv_Ref,
                  Drv_Iterator);
               if Drv_Ref.all in Drivers.Packet_Driver'Class then

                  -- For character drivers add character driver overhead
                  if Drv_Ref.all in Drivers.Character_Packet_Driver'Class then
                     A_Server_Ref        :=
                       Drivers.Character_Server
                         (Drivers.Character_Packet_Driver'Class (Drv_Ref.all))
                       ;
                     A_Sched_Param_Ref   :=
                       Scheduling_Servers.Server_Sched_Parameters
                         (A_Server_Ref.all);
                     A_Synch_Param_Ref   :=
                       Scheduling_Servers.Server_Synch_Parameters
                         (A_Server_Ref.all);
                     Driver_Proc_Ref     :=
                       Scheduling_Servers.Server_Processing_Resource
                         (A_Server_Ref.all);
                     Driver_S_Policy_Ref :=
                       Schedulers.Scheduling_Policy
                         (Scheduling_Servers.Server_Scheduler
                            (A_Server_Ref.all).all);
                     Speed               :=
                       Processing_Resources.Speed_Factor
                         (Driver_Proc_Ref.all);
                     if Driver_Proc_Ref.all in
                       Processing_Resources.Network.Network'Class
                     then
                        Throughput :=
                          Processing_Resources.Network.Throughput
                            (Processing_Resources.Network.Network'Class
                               (Driver_Proc_Ref.all));
                     else
                        Throughput := 0.0;
                     end if;
                     if Drivers.Character_Send_Operation
                       (Drivers.Character_Packet_Driver'Class (Drv_Ref.all)
                       ) /=
                       null
                     then
                        WS_Ovhd :=
                          Operations.Worst_Case_Execution_Time
                            (Drivers.Character_Send_Operation
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all)).all,
                             Throughput) /
                          Speed;
                        BS_Ovhd :=
                          Operations.Best_Case_Execution_Time
                            (Drivers.Character_Send_Operation
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all)).all,
                             Throughput) /
                          Speed;
                     else
                        WS_Ovhd := 0.0;
                        BS_Ovhd := 0.0;
                     end if;
                     if Drivers.Character_Receive_Operation
                       (Drivers.Character_Packet_Driver'Class (Drv_Ref.all)
                       ) /=
                       null
                     then
                        WR_Ovhd :=
                          Operations.Worst_Case_Execution_Time
                            (Drivers.Character_Receive_Operation
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all)).all,
                             Throughput) /
                          Speed;
                        BR_Ovhd :=
                          Operations.Best_Case_Execution_Time
                            (Drivers.Character_Receive_Operation
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all)).all,
                             Throughput) /
                          Speed;
                     else
                        WR_Ovhd := 0.0;
                        BR_Ovhd := 0.0;
                     end if;

                     case Processing_Resources.Network.Transmission_Mode
                       (Processing_Resources.Network.Network'Class
                          (A_Proc_Ref.all)) is
                        when Simplex | Half_Duplex =>
                           Current_Trans                                :=
                             Current_Trans + 1;
                           Transaction (Current_Trans).Transaction_Id   :=
                             Current_Trans;
                           Transaction (Current_Trans).Kind_Of_Event    :=
                             Periodic;
                           Transaction (Current_Trans).Trans_Input_Type :=
                             External;
                           Transaction (Current_Trans).Ti               :=
                             Drivers.Character_Transmission_Time
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all));
                           Transaction (Current_Trans).Ni               := 1;
                           Transaction (Current_Trans).The_Task (1)     :=
                             (Cijown                => Time'Max
                                (WS_Ovhd,
                                 WR_Ovhd),
                              Cbijown               => Time'Max
                                (BS_Ovhd,
                                 BR_Ovhd),
                              Cij                   => Time'Max
                                (WS_Ovhd,
                                 WR_Ovhd),
                              Cbij                  => Time'Max
                                (BS_Ovhd,
                                 BR_Ovhd),
                              Tijown                =>
                                Transaction (Current_Trans).Ti,
                              Tij                   =>
                                Transaction (Current_Trans).Ti,
                              Bij                   => 0.0,
                              Dij                   => Large_Time,
                              SDij                  => 0.0,
                              Schedij               => FP,
                              Preemptible           => True,
                              Oij                   => 0.0,
                              Jij                   => 0.0,
                              Jinit                 => 0.0,
                              Sched_Delay           => 0.0,
                              Oijmin                => 0.0,
                              Oijmax                => 0.0,
                              Delayijmin            => 0.0,
                              Delayijmax            => 0.0,
                              Model                 => Regular,
                              Jitter_Avoidance      => False,
                              Uses_Shared_Resources => False,
                              Rij                   => 0.0,
                              Rbij                  => 0.0,
                              Prioij                =>
                                Scheduling_Parameters.The_Priority
                                  (Scheduling_Parameters.
                                     Fixed_Priority_Parameters'Class
                                     (A_Sched_Param_Ref.all
                                     )),
                              Procij                => Get_Processor_Number
                                (The_System,
                                 Driver_Proc_Ref),
                              Resij                 => null,
                              Max_Of_Best_Cases     => False,
                              Pav                   =>
                                Transaction (Current_Trans).The_Task (1).Pav);
                           -- if interrupt priority, hard prio is true
                           if Driver_Proc_Ref.all in
                             Processing_Resources.
                               Processor.Regular_Processor'Class
                           then
                              Max_Int_Priority :=
                                Processing_Resources.Processor.
                                Max_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                              Min_Int_Priority :=
                                Processing_Resources.Processor.
                                Min_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                           else
                              Min_Int_Priority := Priority'First;
                              Max_Int_Priority := Priority'Last;
                           end if;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Hard_Prio :=
                             Transaction (Current_Trans).The_Task (1).Prioij in
                             Min_Int_Priority .. Max_Int_Priority;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Preassigned := True;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_P_Ref := A_Sched_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Synch_P_Ref := A_Synch_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             P_R_Ref := Driver_Proc_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_Policy_Ref :=
                             Scheduling_Policies.Fixed_Priority_Policy_Ref
                               (Driver_S_Policy_Ref);
                        when Full_Duplex =>
                           -- Send transaction
                           Current_Trans                                :=
                             Current_Trans + 1;
                           Transaction (Current_Trans).Transaction_Id   :=
                             Current_Trans;
                           Transaction (Current_Trans).Kind_Of_Event    :=
                             Periodic;
                           Transaction (Current_Trans).Trans_Input_Type :=
                             External;
                           Transaction (Current_Trans).Ti               :=
                             Drivers.Character_Transmission_Time
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all));
                           Transaction (Current_Trans).Ni               := 1;
                           Transaction (Current_Trans).The_Task (1)     :=
                             (Cijown                => WS_Ovhd,
                              Cbijown               => BS_Ovhd,
                              Cij                   => WS_Ovhd,
                              Cbij                  => BS_Ovhd,
                              Tijown                =>
                                Transaction (Current_Trans).Ti,
                              Tij                   =>
                                Transaction (Current_Trans).Ti,
                              Bij                   => 0.0,
                              Dij                   => Large_Time,
                              SDij                  => 0.0,
                              Schedij               => FP,
                              Preemptible           => True,
                              Oij                   => 0.0,
                              Jij                   => 0.0,
                              Jinit                 => 0.0,
                              Sched_Delay           => 0.0,
                              Oijmin                => 0.0,
                              Oijmax                => 0.0,
                              Delayijmin            => 0.0,
                              Delayijmax            => 0.0,
                              Model                 => Regular,
                              Jitter_Avoidance      => False,
                              Uses_Shared_Resources => False,
                              Rij                   => 0.0,
                              Rbij                  => 0.0,
                              Prioij                =>
                                Scheduling_Parameters.The_Priority
                                  (Scheduling_Parameters.
                                     Fixed_Priority_Parameters'Class
                                     (A_Sched_Param_Ref.all
                                     )),
                              Procij                => Get_Processor_Number
                                (The_System,
                                 Driver_Proc_Ref),
                              Resij                 => null,
                              Max_Of_Best_Cases     => False,
                              Pav                   =>
                                Transaction (Current_Trans).The_Task (1).Pav);
                           -- if interrupt priority, hard prio is true
                           if Driver_Proc_Ref.all in
                             Processing_Resources.
                               Processor.Regular_Processor'Class
                           then
                              Max_Int_Priority :=
                                Processing_Resources.Processor.
                                Max_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                              Min_Int_Priority :=
                                Processing_Resources.Processor.
                                Min_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                           else
                              Min_Int_Priority := Priority'First;
                              Max_Int_Priority := Priority'Last;
                           end if;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Hard_Prio :=
                             Transaction (Current_Trans).The_Task (1).Prioij in
                             Min_Int_Priority .. Max_Int_Priority;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Preassigned := True;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_P_Ref := A_Sched_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Synch_P_Ref := A_Synch_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             P_R_Ref := Driver_Proc_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_Policy_Ref :=
                             Scheduling_Policies.Fixed_Priority_Policy_Ref
                               ( Driver_S_Policy_Ref);
                           -- Receive transaction
                           Current_Trans                                :=
                             Current_Trans + 1;
                           Transaction (Current_Trans).Transaction_Id   :=
                             Current_Trans;
                           Transaction (Current_Trans).Kind_Of_Event    :=
                             Periodic;
                           Transaction (Current_Trans).Trans_Input_Type :=
                             External;
                           Transaction (Current_Trans).Ti               :=
                             Drivers.Character_Transmission_Time
                               (Drivers.Character_Packet_Driver'Class
                                  (Drv_Ref.all));
                           Transaction (Current_Trans).Ni               := 1;
                           Transaction (Current_Trans).The_Task (1)     :=
                             (Cijown                => WR_Ovhd,
                              Cbijown               => BR_Ovhd,
                              Cij                   => WR_Ovhd,
                              Cbij                  => BR_Ovhd,
                              Tijown                =>
                                Transaction (Current_Trans).Ti,
                              Tij                   =>
                                Transaction (Current_Trans).Ti,
                              Bij                   => 0.0,
                              Dij                   => Large_Time,
                              SDij                  => 0.0,
                              Schedij               => FP,
                              Preemptible           => True,
                              Oij                   => 0.0,
                              Jij                   => 0.0,
                              Jinit                 => 0.0,
                              Sched_Delay           => 0.0,
                              Oijmin                => 0.0,
                              Oijmax                => 0.0,
                              Delayijmin            => 0.0,
                              Delayijmax            => 0.0,
                              Model                 => Regular,
                              Jitter_Avoidance      => False,
                              Uses_Shared_Resources => False,
                              Rij                   => 0.0,
                              Rbij                  => 0.0,
                              Prioij                =>
                                Scheduling_Parameters.The_Priority
                                  (Scheduling_Parameters.
                                     Fixed_Priority_Parameters'Class
                                     (A_Sched_Param_Ref.all
                                     )),
                              Procij                => Get_Processor_Number
                                (The_System,
                                 Driver_Proc_Ref),
                              Resij                 => null,
                              Max_Of_Best_Cases     => False,
                              Pav                   =>
                                Transaction (Current_Trans).The_Task (1).Pav);
                           -- if interrupt priority, hard prio is true
                           if Driver_Proc_Ref.all in
                             Processing_Resources.
                               Processor.Regular_Processor'Class
                           then
                              Max_Int_Priority :=
                                Processing_Resources.Processor.
                                Max_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                              Min_Int_Priority :=
                                Processing_Resources.Processor.
                                Min_Interrupt_Priority
                                  (Processing_Resources.Processor.
                                     Regular_Processor'Class
                                     (Driver_Proc_Ref.all));
                           else
                              Min_Int_Priority := Priority'First;
                              Max_Int_Priority := Priority'Last;
                           end if;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Hard_Prio :=
                             Transaction (Current_Trans).The_Task (1).Prioij in
                             Min_Int_Priority .. Max_Int_Priority;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Preassigned := True;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_P_Ref := A_Sched_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             Synch_P_Ref := A_Synch_Param_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             P_R_Ref := Driver_Proc_Ref;
                           Transaction (Current_Trans).The_Task (1).Pav.
                             S_Policy_Ref :=
                             Scheduling_Policies.Fixed_Priority_Policy_Ref
                               ( Driver_S_Policy_Ref);
                     end case;
                  elsif Drv_Ref.all in Drivers.RTEP_Packet_Driver'Class then
                     -- for RTEP Packet Driver add additional overhead

                     case Drivers.Rta_Overhead_Model
                       (Drivers.Packet_Driver (Drv_Ref.all)) is
                        when Drivers.Decoupled =>
                           --
                           -- Decoupled Overhead Model
                           --
                           -- Packet_Server: running the driver (main thread)
                           A_Server_Ref        :=
                             Drivers.Packet_Server
                               (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all)
                               );
                           A_Sched_Param_Ref   :=
                             Scheduling_Servers.Server_Sched_Parameters
                               (A_Server_Ref.all);
                           Driver_Proc_Ref     :=
                             Scheduling_Servers.Server_Processing_Resource
                               (A_Server_Ref.all);
                           Driver_S_Policy_Ref :=
                             Schedulers.Scheduling_Policy
                               (Scheduling_Servers.Server_Scheduler
                                  (A_Server_Ref.all).all);
                           Speed               :=
                             Processing_Resources.Speed_Factor
                               (Driver_Proc_Ref.all);

                           -- Packet_Interrupt_Server: running ISR operation
                           ISR_Server_Ref          :=
                             Drivers.Packet_Interrupt_Server
                               (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all)
                               );
                           ISR_Sched_Param_Ref     :=
                             Scheduling_Servers.Server_Sched_Parameters
                               (ISR_Server_Ref.all);
                           ISR_Synch_Param_Ref     :=
                             Scheduling_Servers.Server_Synch_Parameters
                               (ISR_Server_Ref.all);
                           Driver_ISR_Proc_Ref     :=
                             Scheduling_Servers.Server_Processing_Resource
                               (ISR_Server_Ref.all);
                           Driver_ISR_S_Policy_Ref :=
                             Schedulers.Scheduling_Policy
                               (Scheduling_Servers.Server_Scheduler
                                  (ISR_Server_Ref.all).all);
                           Speed_ISR               :=
                             Processing_Resources.Speed_Factor
                               (Driver_ISR_Proc_Ref.all);

                           -- Packet_Server Processor Throughput
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Throughput :=
                                Processing_Resources.Network.Throughput
                                  (Processing_Resources.Network.Network'Class
                                     (A_Proc_Ref.all));
                           else
                              Throughput := 0.0;
                           end if;

                           -- Context Switch for Packet_Server Processor
                           if Driver_Proc_Ref.all in
                             Processing_Resources.Processor.Processor'Class
                           then
                              CSwitch :=
                                Scheduling_Policies.Worst_Context_Switch
                                  (Scheduling_Policies.Fixed_Priority'Class
                                     (Driver_S_Policy_Ref.all)) /
                                Speed;
                           end if;

                           -- Min Packet/Token Transmition Time
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Min_PTT :=
                                Processing_Resources.Network.
                                Min_Packet_Transmission_Time
                                  (Processing_Resources.Network.
                                     Packet_Based_Network
                                     (A_Proc_Ref.all));
                           else
                              Min_PTT := 0.0;
                           end if;

                           -- Token Delay
                           if Drivers.Token_Delay
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0.0
                           then
                              token_delay :=
                                Drivers.Token_Delay
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              token_delay := 0.0;
                           end if;

                           -- Number of stations
                           if Drivers.Number_Of_Stations
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              number_stations :=
                                Drivers.Number_Of_Stations
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              number_stations := 1;
                           end if;

                           -- Max Blocking Time
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              max_blocking :=
                                Processing_Resources.Network.Max_Blocking
                                  (
                                   Processing_Resources.Network.
                                     Packet_Based_Network'Class (A_Proc_Ref.all));
                           else
                              max_blocking := 0.0;
                           end if;

                           --Packet_ISR_Operation
                           if Drivers.Packet_ISR_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WISR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_ISR_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BISR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_ISR_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WISR_Ovhd := 0.0;
                              BISR_Ovhd := 0.0;
                           end if;

                           -- Tocken Check Operation
                           if Drivers.Token_Check_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTC_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Token_Check_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTC_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Token_Check_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTC_Ovhd := 0.0;
                              BTC_Ovhd := 0.0;
                           end if;

                           -- Token Manage Operation
                           if Drivers.Token_Manage_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTM_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Token_Manage_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTM_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Token_Manage_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTM_Ovhd := 0.0;
                              BTM_Ovhd := 0.0;
                           end if;

                           -- Packet/Token Discard Operation
                           if Drivers.Packet_Discard_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WPD_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Discard_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BPD_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Discard_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        ( Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WPD_Ovhd := 0.0;
                              BPD_Ovhd := 0.0;
                           end if;

                           -- Packet Send Operation
                           if Drivers.Packet_Send_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WS_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BS_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WS_Ovhd := 0.0;
                              BS_Ovhd := 0.0;
                           end if;

                           --Packet Receive Operation
                           if Drivers.Packet_Receive_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WR_Ovhd := 0.0;
                              BR_Ovhd := 0.0;
                           end if;

                           --- Error Handling Operations for RT-EP protocol ---

                           -- Failure Timeout
                           if Drivers.Failure_Timeout
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0.0
                           then
                              failure_timeout :=
                                Drivers.Failure_Timeout
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              failure_timeout := 0.0;
                           end if;

                           -- Token Retransmission Retries
                           if Drivers.Token_Transmission_Retries
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              token_retries :=
                                Drivers.Token_Transmission_Retries
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              token_retries := 0;
                           end if;

                           -- Packet Retransmission Retries
                           if Drivers.Packet_Transmission_Retries
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              packet_retries :=
                                Drivers.Packet_Transmission_Retries
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              packet_retries := 0;
                           end if;

                           -- Token Retransmission Operation
                           if Drivers.Token_Retransmission_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (
                                   Drivers.Token_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (
                                   Drivers.Token_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTR_Ovhd := 0.0;
                              BTR_Ovhd := 0.0;
                           end if;

                           -- Packet Retransmission Operation
                           if Drivers.Packet_Retransmission_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WPR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (
                                   Drivers.Packet_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BPR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (
                                   Drivers.Packet_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WPR_Ovhd := 0.0;
                              BPR_Ovhd := 0.0;
                           end if;

                           ---------------------------------
                           --- RT-EP Driver Transactions ---
                           ---------------------------------

                           case
                             Processing_Resources.Network.Transmission_Mode
                               (Processing_Resources.Network.Network'Class
                                  (A_Proc_Ref.all)) is
                              when Half_Duplex =>
                                 -- NEW MODEL TRANSACTION DISCARD --
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti := BISR_Ovhd +
                                   CSwitch +
                                   BPD_Ovhd +
                                   BISR_Ovhd +
                                   BTM_Ovhd +
                                   BTC_Ovhd +
                                   (Time (
                                          number_stations +
                                            1)) *
                                   (Time (
                                          Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (
                                         number_stations) *
                                   token_delay
                                   +
                                   Time (
                                         token_retries) *
                                   (BTR_Ovhd +
                                      failure_timeout) +
                                   Time ((
                                          Throughput_Value (34.0 * 8.0))
                                           / Throughput)
                                   ;
                                 Transaction (Current_Trans).Ni := 2;
                                 -- DISCARD
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WISR_Ovhd,
                                    Cbijown               => BISR_Ovhd,
                                    Cij                   => WISR_Ovhd,
                                    Cbij                  => BISR_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   => Large_Time,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (ISR_Sched_Param_Ref.
                                              all)),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_ISR_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := ISR_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := ISR_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_ISR_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_ISR_S_Policy_Ref);

                                 Transaction (Current_Trans).The_Task (2) :=
                                   (Cijown                => WPD_Ovhd,
                                    Cbijown               => BPD_Ovhd,
                                    Cij                   => WPD_Ovhd,
                                    Cbij                  => BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (2).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (2).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                                 -- NEW MODEL PACKET ACCEPTED
                                 -- Transaction InfoPacket Received
                                 -- (accepted packet )
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   BISR_Ovhd +
                                   CSwitch +
                                   BR_Ovhd +
                                   BISR_Ovhd -
                                   BISR_Ovhd -
                                   BPD_Ovhd +
                                   BTM_Ovhd +
                                   BTC_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BTC_Ovhd +
                                   BS_Ovhd +
                                   (Time (number_stations + 1)) *
                                   (Time (Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (number_stations) * token_delay +
                                   Time (token_retries) *
                                   (BTR_Ovhd + failure_timeout) +
                                   Time ((Throughput_Value (34.0 * 8.0)) /
                                           Throughput);
                                 Transaction (Current_Trans).Ni := 1;
                                 -- Transaction InfoPacket Received
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WR_Ovhd -
                                      WPD_Ovhd,
                                    Cbijown               => BR_Ovhd -
                                      BPD_Ovhd,
                                    Cij                   => WR_Ovhd -
                                      WPD_Ovhd,
                                    Cbij                  => BR_Ovhd -
                                      BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                                 -- NEW MODEL PACKET SENT
                                 -- Transaction InfoPacket Send
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   BISR_Ovhd +
                                   CSwitch +
                                   BS_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BR_Ovhd +
                                   BISR_Ovhd +
                                   BTC_Ovhd +
                                   BTM_Ovhd +
                                   Time (Min_PTT) +
                                   (Time (number_stations + 1)) *
                                   (Time (Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (number_stations) * token_delay +
                                   Time (token_retries) *
                                   (BTR_Ovhd + failure_timeout) +
                                   Time ((Throughput_Value (34.0 * 8.0)) /
                                           Throughput);
                                 Transaction (Current_Trans).Ni := 1;
                                 -- Transaction InfoPacket Send
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WS_Ovhd -
                                      WPD_Ovhd,
                                    Cbijown               => BS_Ovhd -
                                      BPD_Ovhd,
                                    Cij                   => WS_Ovhd -
                                      WPD_Ovhd,
                                    Cbij                  => BS_Ovhd -
                                      BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                                 -- Error Handling for the
                                 -- Transaction InfoPacket Send
                                 if packet_retries /= 0 then
                                    p_r := packet_retries;

                                    while p_r > 0 loop

                                       Transaction (Current_Trans).Ni :=
                                         Transaction (Current_Trans).Ni + 2;
                                       -- InfoPacket_Retransmitted
                                       Transaction (Current_Trans).The_Task
                                         ( Transaction (Current_Trans).Ni-1)
                                         :=
                                           (Cijown                => 0.0,
                                            Cbijown               => 0.0,
                                            Cij                   => 0.0,
                                            Cbij                  => 0.0,
                                            Tijown                =>
                                              Transaction (Current_Trans).Ti,
                                            Tij                   =>
                                              Transaction (Current_Trans).Ti,
                                            Bij                   => 0.0,
                                            Dij                   => Large_Time,
                                            SDij                  => 0.0,
                                            Schedij               => FP,
                                            Preemptible           => True,
                                            Oij                   => 0.0,
                                            Jij                   => 0.0,
                                            Jinit                 => 0.0,
                                            Sched_Delay           => 0.0,
                                            Oijmin                => 0.0,
                                            Oijmax                => 0.0,
                                            Delayijmin            =>
                                              failure_timeout,
                                            Delayijmax            =>
                                              failure_timeout,
                                            Model                 => Regular,
                                            Jitter_Avoidance      => False,
                                            Uses_Shared_Resources => False,
                                            Rij                   => 0.0,
                                            Rbij                  => 0.0,
                                            Prioij                =>
                                              Scheduling_Parameters.The_Priority
                                                (Scheduling_Parameters.
                                                   Fixed_Priority_Parameters'Class
                                                   (A_Sched_Param_Ref.all
                                                   )),
                                            Procij                =>
                                              Get_Processor_Number
                                                (The_System, Driver_Proc_Ref),
                                            Resij                 => null,
                                            Max_Of_Best_Cases     => False,
                                            Pav                   =>
                                              Transaction (Current_Trans).
                                                The_Task
                                                (Transaction (Current_Trans).Ni-1).
                                                Pav);
                                       -- if interrupt priority,
                                       -- hard prio is true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Hard_Prio :=
                                         Transaction (Current_Trans).The_Task
                                           (Transaction (Current_Trans).Ni - 1).
                                         Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Preassigned := True;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.S_P_Ref := ISR_Sched_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Synch_P_Ref :=
                                         ISR_Synch_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.P_R_Ref := Driver_ISR_Proc_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_ISR_S_Policy_Ref);

                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni) :=
                                         (Cijown                => WPR_Ovhd,
                                          Cbijown               => BPR_Ovhd,
                                          Cij                   => WPR_Ovhd,
                                          Cbij                  => BPR_Ovhd,
                                          Tijown                =>
                                            Transaction (Current_Trans).Ti,
                                          Tij                   =>
                                            Transaction (Current_Trans).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            -- march 2025: duplicated the 
                                            -- deadline
                                            2.0*Transaction (Current_Trans).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (A_Sched_Param_Ref.all
                                                 )),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (Current_Trans).
                                              The_Task
                                              (Transaction (Current_Trans).
                                                 Ni).Pav);
                                       -- if interrupt priority,
                                       -- hard prio is true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Hard_Prio :=
                                         Transaction (Current_Trans).The_Task
                                           (Transaction (Current_Trans).Ni).
                                         Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Preassigned := True;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         S_P_Ref := A_Sched_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Synch_P_Ref := A_Synch_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         P_R_Ref := Driver_Proc_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_S_Policy_Ref);
                                       p_r := p_r - 1;
                                    end loop;
                                 end if;

                                 -- NEW MODEL TOKEN_SEND
                                 -- Transaction token_send
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   BISR_Ovhd +
                                   CSwitch +
                                   BTC_Ovhd +
                                   BTM_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BTC_Ovhd +
                                   BS_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BR_Ovhd +
                                   (Time (number_stations + 1)) *
                                   (Time (Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (number_stations) * token_delay +
                                   Time (token_retries) *
                                   (BTR_Ovhd + failure_timeout) +
                                   Time ((Throughput_Value (34.0 * 8.0)) /
                                           Throughput);
                                 Transaction (Current_Trans).Ni := 1;
                                 -- token_send
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WTC_Ovhd +
                                      WTM_Ovhd -
                                      WPD_Ovhd,
                                    Cbijown               => BTC_Ovhd +
                                      BTM_Ovhd -
                                      BPD_Ovhd,
                                    Cij                   => WTC_Ovhd +
                                      WTM_Ovhd -
                                      WPD_Ovhd,
                                    Cbij                  => BTC_Ovhd +
                                      BTM_Ovhd -
                                      BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                                 -- Error Handling for the
                                 -- Transaction Token Send

                                 if token_retries /= 0 then
                                    t_r := token_retries;
                                    while t_r > 0 loop
                                       Transaction (Current_Trans).Ni :=
                                         Transaction (Current_Trans).Ni + 2;
                                       -- Transmit Token_Retransmitted
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         :=
                                           (Cijown                => 0.0,
                                            Cbijown               => 0.0,
                                            Cij                   => 0.0,
                                            Cbij                  => 0.0,
                                            Tijown                =>
                                              Transaction (Current_Trans).Ti,
                                            Tij                   =>
                                              Transaction (Current_Trans).Ti,
                                            Bij                   => 0.0,
                                            Dij                   => Large_Time,
                                            SDij                  => 0.0,
                                            Schedij               => FP,
                                            Preemptible           => True,
                                            Oij                   => 0.0,
                                            Jij                   => 0.0,
                                            Jinit                 => 0.0,
                                            Sched_Delay           => 0.0,
                                            Oijmin                => 0.0,
                                            Oijmax                => 0.0,
                                            Delayijmin            =>
                                              failure_timeout,
                                            Delayijmax            =>
                                              failure_timeout,
                                            Model                 => Regular,
                                            Jitter_Avoidance      => False,
                                            Uses_Shared_Resources => False,
                                            Rij                   => 0.0,
                                            Rbij                  => 0.0,
                                            Prioij                =>
                                              Scheduling_Parameters.The_Priority
                                                (Scheduling_Parameters.
                                                   Fixed_Priority_Parameters'Class
                                                   (ISR_Sched_Param_Ref.
                                                      all)),
                                            Procij                =>
                                              Get_Processor_Number
                                                (The_System, Driver_ISR_Proc_Ref),
                                            Resij                 => null,
                                            Max_Of_Best_Cases     => False,
                                            Pav                   =>
                                              Transaction (Current_Trans).
                                                The_Task
                                                (Transaction (Current_Trans).Ni-1).
                                                Pav);
                                       -- if interrupt priority,
                                       -- hard prio is true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Hard_Prio :=
                                         Transaction (Current_Trans).The_Task
                                           (Transaction (Current_Trans).Ni - 1).
                                         Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Preassigned := True;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.S_P_Ref := ISR_Sched_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.Synch_P_Ref :=
                                         ISR_Synch_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.P_R_Ref := Driver_ISR_Proc_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni-1)
                                         .Pav.S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_ISR_S_Policy_Ref);

                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni) :=
                                         (Cijown                => WTR_Ovhd,
                                          Cbijown               => BTR_Ovhd,
                                          Cij                   => WTR_Ovhd,
                                          Cbij                  => BTR_Ovhd,
                                          Tijown                =>
                                            Transaction (Current_Trans).Ti,
                                          Tij                   =>
                                            Transaction (Current_Trans).Ti,
                                          Bij                   => 0.0,
                                          Dij                   =>
                                            -- march 2025: duplicated the 
                                            -- deadline
                                            2.0*Transaction (Current_Trans).Ti,
                                          SDij                  => 0.0,
                                          Schedij               => FP,
                                          Preemptible           => True,
                                          Oij                   => 0.0,
                                          Jij                   => 0.0,
                                          Jinit                 => 0.0,
                                          Sched_Delay           => 0.0,
                                          Oijmin                => 0.0,
                                          Oijmax                => 0.0,
                                          Delayijmin            => 0.0,
                                          Delayijmax            => 0.0,
                                          Model                 => Regular,
                                          Jitter_Avoidance      => False,
                                          Uses_Shared_Resources => False,
                                          Rij                   => 0.0,
                                          Rbij                  => 0.0,
                                          Prioij                =>
                                            Scheduling_Parameters.The_Priority
                                              (Scheduling_Parameters.
                                                 Fixed_Priority_Parameters'Class
                                                 (ISR_Sched_Param_Ref.
                                                    all)),
                                          Procij                =>
                                            Get_Processor_Number
                                              (The_System, Driver_ISR_Proc_Ref),
                                          Resij                 => null,
                                          Max_Of_Best_Cases     => False,
                                          Pav                   =>
                                            Transaction (Current_Trans).
                                              The_Task
                                              (Transaction (Current_Trans).
                                                 Ni).Pav);
                                       -- if interrupt priority,
                                       -- hard prio is true
                                       if Driver_Proc_Ref.all in
                                         Processing_Resources.
                                           Processor.Regular_Processor'Class
                                       then
                                          Max_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Max_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                          Min_Int_Priority :=
                                            Processing_Resources.Processor.
                                            Min_Interrupt_Priority
                                              (Processing_Resources.Processor.
                                                 Regular_Processor'Class
                                                 (Driver_Proc_Ref.all));
                                       else
                                          Min_Int_Priority := Priority'First;
                                          Max_Int_Priority := Priority'Last;
                                       end if;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Hard_Prio :=
                                         Transaction (Current_Trans).The_Task
                                           (Transaction (Current_Trans).Ni).
                                         Prioij in
                                         Min_Int_Priority ..
                                           Max_Int_Priority;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Preassigned := True;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         S_P_Ref := ISR_Sched_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         Synch_P_Ref := ISR_Synch_Param_Ref;
                                       Transaction (Current_Trans).The_Task
                                         ( Transaction (Current_Trans).Ni).Pav.
                                         P_R_Ref := Driver_ISR_Proc_Ref;
                                       Transaction (Current_Trans).The_Task
                                         (Transaction (Current_Trans).Ni).Pav.
                                         S_Policy_Ref :=
                                         Scheduling_Policies.
                                         Fixed_Priority_Policy_Ref
                                           (Driver_ISR_S_Policy_Ref);
                                       t_r := t_r - 1;
                                    end loop;
                                 end if;

                              when Simplex | Full_Duplex =>
                                 null;
                           end case;

                        when Drivers.Coupled =>
                           --
                           -- Coupled Overhead Model
                           --
                           -- Packet_Server: running the driver (main thread)
                           A_Server_Ref        :=
                             Drivers.Packet_Server
                               (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all)
                               );
                           A_Sched_Param_Ref   :=
                             Scheduling_Servers.Server_Sched_Parameters
                               (A_Server_Ref.all);
                           Driver_Proc_Ref     :=
                             Scheduling_Servers.Server_Processing_Resource
                               (A_Server_Ref.all);
                           Driver_S_Policy_Ref :=
                             Schedulers.Scheduling_Policy
                               (Scheduling_Servers.Server_Scheduler
                                  (A_Server_Ref.all).all);
                           Speed               :=
                             Processing_Resources.Speed_Factor
                               (Driver_Proc_Ref.all);

                           -- Packet_Interrupt_Server: running ISR operation
                           ISR_Server_Ref          :=
                             Drivers.Packet_Interrupt_Server
                               (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all)
                               );
                           ISR_Sched_Param_Ref     :=
                             Scheduling_Servers.Server_Sched_Parameters
                               (ISR_Server_Ref.all);
                           ISR_Synch_Param_Ref     :=
                             Scheduling_Servers.Server_Synch_Parameters
                               (ISR_Server_Ref.all);
                           Driver_ISR_Proc_Ref     :=
                             Scheduling_Servers.Server_Processing_Resource
                               (ISR_Server_Ref.all);
                           Driver_ISR_S_Policy_Ref :=
                             Schedulers.Scheduling_Policy
                               (Scheduling_Servers.Server_Scheduler
                                  (ISR_Server_Ref.all).all);
                           Speed_ISR               :=
                             Processing_Resources.Speed_Factor
                               (Driver_ISR_Proc_Ref.all);

                           -- Packet_Server Network Throughput
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Throughput :=
                                Processing_Resources.Network.Throughput
                                  (Processing_Resources.Network.Network'Class
                                     (A_Proc_Ref.all));
                           else
                              Throughput := 0.0;
                           end if;

                           -- Context Switch for Packet_Server Processor
                           if Driver_Proc_Ref.all in
                             Processing_Resources.Processor.Processor'Class
                           then
                              CSwitch :=
                                Scheduling_Policies.Worst_Context_Switch
                                  (Scheduling_Policies.Fixed_Priority'Class
                                     (Driver_S_Policy_Ref.all)) /
                                Speed;

                           end if;

                           -- Min Packet/Token Transmition Time
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Min_PTT :=
                                Processing_Resources.Network.
                                Min_Packet_Transmission_Time
                                  (Processing_Resources.Network.
                                     Packet_Based_Network (A_Proc_Ref.all));
                           else
                              Min_PTT := 0.0;
                           end if;

                           -- Token Delay
                           if Drivers.Token_Delay
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0.0
                           then
                              token_delay :=
                                Drivers.Token_Delay
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              token_delay := 0.0;
                           end if;

                           -- Number of stations
                           if Drivers.Number_Of_Stations
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              number_stations :=
                                Drivers.Number_Of_Stations
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              number_stations := 1;
                           end if;

                           -- Max Blocking Time
                           if A_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              max_blocking :=
                                Processing_Resources.Network.Max_Blocking
                                  (
                                   Processing_Resources.Network.
                                     Packet_Based_Network'Class (A_Proc_Ref.all));
                           else
                              max_blocking := 0.0;
                           end if;

                           --Packet_ISR_Operation
                           if Drivers.Packet_ISR_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WISR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_ISR_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BISR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_ISR_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WISR_Ovhd := 0.0;
                              BISR_Ovhd := 0.0;
                           end if;

                           -- Tocken Check Operation
                           if Drivers.Token_Check_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTC_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Token_Check_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTC_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Token_Check_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTC_Ovhd := 0.0;
                              BTC_Ovhd := 0.0;
                           end if;

                           -- Token Manage Operation
                           if Drivers.Token_Manage_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTM_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Token_Manage_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTM_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Token_Manage_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTM_Ovhd := 0.0;
                              BTM_Ovhd := 0.0;
                           end if;

                           -- Packet/Token Discard Operation
                           if Drivers.Packet_Discard_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WPD_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Discard_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BPD_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Discard_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WPD_Ovhd := 0.0;
                              BPD_Ovhd := 0.0;
                           end if;
                           
                           -- Packet Send Operation
                           if Drivers.Packet_Send_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WS_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BS_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WS_Ovhd := 0.0;
                              BS_Ovhd := 0.0;
                           end if;

                           --Packet Receive Operation
                           if Drivers.Packet_Receive_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WR_Ovhd := 0.0;
                              BR_Ovhd := 0.0;
                           end if;

                           --- Error Handling Operations for RT-EP protocol ---
                           
                           
                           -- Failure Timeout
                           if Drivers.Failure_Timeout
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0.0
                           then
                              failure_timeout :=
                                Drivers.Failure_Timeout
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              failure_timeout := 0.0;
                           end if;

                           -- Token Retransmission Retries
                           if Drivers.Token_Transmission_Retries
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              token_retries :=
                                Drivers.Token_Transmission_Retries
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              token_retries := 0;
                           end if;

                           -- Packet Retransmission Retries
                           if Drivers.Packet_Transmission_Retries
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             0
                           then
                              packet_retries :=
                                Drivers.Packet_Transmission_Retries
                                  (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.
                                                                       all));
                           else
                              packet_retries := 0;
                           end if;

                           -- Token Retransmission Operation
                           if Drivers.Token_Retransmission_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WTR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (
                                   Drivers.Token_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BTR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (
                                   Drivers.Token_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WTR_Ovhd := 0.0;
                              BTR_Ovhd := 0.0;
                           end if;

                           -- Packet Retransmission Operation
                           if Drivers.Packet_Retransmission_Operation
                             (Drivers.RTEP_Packet_Driver'Class (Drv_Ref.all
                                                               )) /=
                             null
                           then
                              WPR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (
                                   Drivers.Packet_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                              BPR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (
                                   Drivers.Packet_Retransmission_Operation
                                     (Drivers.RTEP_Packet_Driver'Class
                                        (Drv_Ref.all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WPR_Ovhd := 0.0;
                              BPR_Ovhd := 0.0;
                           end if;
                           
                           ---------------------------------
                           --- RT-EP Driver Transactions ---
                           ---------------------------------

                           case
                             Processing_Resources.Network.Transmission_Mode
                               (Processing_Resources.Network.Network'Class
                                  (A_Proc_Ref.all)) is
                              when Half_Duplex =>

                                 -- NEW MODEL TRANSACTION DISCARD --
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti := BISR_Ovhd +
                                   CSwitch +
                                   BPD_Ovhd +
                                   BISR_Ovhd +
                                   BTM_Ovhd +
                                   BTC_Ovhd +
                                   (Time (
                                          number_stations +
                                            1)) *
                                   (Time (
                                          Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (
                                         number_stations) *
                                   token_delay
                                   +
                                   Time (
                                         token_retries) *
                                   (BTR_Ovhd +
                                      failure_timeout) +
                                   Time ((
                                          Throughput_Value (34.0 * 8.0))
                                           / Throughput)
                                   ;
                                 
                                 Transaction (Current_Trans).Ni := 2;
                                 -- DISCARD
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WISR_Ovhd,
                                    Cbijown               => BISR_Ovhd,
                                    Cij                   => WISR_Ovhd,
                                    Cbij                  => BISR_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   => Large_Time,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (ISR_Sched_Param_Ref.
                                              all)),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_ISR_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := ISR_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := ISR_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_ISR_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_ISR_S_Policy_Ref);

                                 Transaction (Current_Trans).The_Task (2) :=
                                   (Cijown                => WPD_Ovhd,
                                    Cbijown               => BPD_Ovhd,
                                    Cij                   => WPD_Ovhd,
                                    Cbij                  => BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (2).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (2).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (2).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                                 -- NEW MODEL TOKEN_SEND
                                 -- Transaction token_send
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   BISR_Ovhd +
                                   CSwitch +
                                   BTC_Ovhd +
                                   BTM_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BTC_Ovhd +
                                   BS_Ovhd +
                                   Time (Min_PTT) +
                                   BISR_Ovhd +
                                   BR_Ovhd +
                                   (Time (number_stations + 1)) *
                                   (Time (Min_PTT) +
                                      BISR_Ovhd +
                                      BTM_Ovhd +
                                      BTC_Ovhd) +
                                   Time (number_stations) * token_delay +
                                   Time (token_retries) *
                                   (BTR_Ovhd + failure_timeout) +
                                   Time ((Throughput_Value (34.0 * 8.0)) /
                                           Throughput);
                                 
                                 Transaction (Current_Trans).Ni := 1;
                                 -- token_send
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WTC_Ovhd +
                                      WTM_Ovhd -
                                      WPD_Ovhd,
                                    Cbijown               => BTC_Ovhd +
                                      BTM_Ovhd -
                                      BPD_Ovhd,
                                    Cij                   => WTC_Ovhd +
                                      WTM_Ovhd -
                                      WPD_Ovhd,
                                    Cbij                  => BTC_Ovhd +
                                      BTM_Ovhd -
                                      BPD_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   =>
                                      -- march 2025: duplicated the deadline
                                      2.0*Transaction (Current_Trans).Ti,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);

                              when Simplex | Full_Duplex =>
                                 null;
                           end case;
                     end case;

                  else
                     -- For all packet drivers, add packet driver overhead
                     case Drivers.Rta_Overhead_Model
                       (Drivers.Packet_Driver (Drv_Ref.all)) is
                        when Drivers.Decoupled =>
                           --
                           -- Decoupled overhead model
                           --
                           A_Server_Ref        :=
                             Drivers.Packet_Server
                               (Drivers.Packet_Driver'Class (Drv_Ref.all));
                           A_Sched_Param_Ref   :=
                             Scheduling_Servers.Server_Sched_Parameters
                               (A_Server_Ref.all);
                           A_Synch_Param_Ref   :=
                             Scheduling_Servers.Server_Synch_Parameters
                               (A_Server_Ref.all);
                           Driver_Proc_Ref     :=
                             Scheduling_Servers.Server_Processing_Resource
                               (A_Server_Ref.all);
                           Driver_S_Policy_Ref :=
                             Schedulers.Scheduling_Policy
                               (Scheduling_Servers.Server_Scheduler
                                  (A_Server_Ref.all).all);
                           Speed               :=
                             Processing_Resources.Speed_Factor
                               (Driver_Proc_Ref.all);
                           if Driver_Proc_Ref.all in
                             Processing_Resources.Network.Network'Class
                           then
                              Throughput :=
                                Processing_Resources.Network.Throughput
                                  (Processing_Resources.Network.Network'Class
                                     (Driver_Proc_Ref.all));
                           else
                              Throughput := 0.0;
                           end if;
                           if Drivers.Packet_Send_Operation
                             (Drivers.Packet_Driver'Class (Drv_Ref.all)) /=
                             null
                           then
                              WS_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                     all)).all,
                                   Throughput) /
                                Speed;
                              BS_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Send_Operation
                                     (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                     all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WS_Ovhd := 0.0;
                              BS_Ovhd := 0.0;
                           end if;
                           if Drivers.Packet_Receive_Operation
                             (Drivers.Packet_Driver'Class (Drv_Ref.all)) /=
                             null
                           then
                              WR_Ovhd :=
                                Operations.Worst_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                     all)).all,
                                   Throughput) /
                                Speed;
                              BR_Ovhd :=
                                Operations.Best_Case_Execution_Time
                                  (Drivers.Packet_Receive_Operation
                                     (Drivers.Packet_Driver'Class (Drv_Ref.
                                                                     all)).all,
                                   Throughput) /
                                Speed;
                           else
                              WR_Ovhd := 0.0;
                              BR_Ovhd := 0.0;
                           end if;

                           case
                             Processing_Resources.Network.Transmission_Mode
                               (Processing_Resources.Network.Network'Class
                                  (A_Proc_Ref.all)) is
                              when Simplex | Half_Duplex =>
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   Processing_Resources.Network.
                                   Min_Packet_Transmission_Time
                                     (Processing_Resources.Network.
                                        Packet_Based_Network'
                                        Class (A_Proc_Ref.all)) /
                                   Speed;
                                 Transaction (Current_Trans).Ni := 1;
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => Time'Max
                                      (WS_Ovhd,
                                       WR_Ovhd),
                                    Cbijown               => Time'Max
                                      (BS_Ovhd,
                                       BR_Ovhd),
                                    Cij                   => Time'Max
                                      (WS_Ovhd,
                                       WR_Ovhd),
                                    Cbij                  => Time'Max
                                      (BS_Ovhd,
                                       BR_Ovhd),
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   => Large_Time,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);
                              when Full_Duplex =>
                                 -- Send transaction
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   Processing_Resources.Network.
                                   Min_Packet_Transmission_Time
                                     (Processing_Resources.Network.
                                        Packet_Based_Network (A_Proc_Ref.all)) /
                                   Speed;
                                 Transaction (Current_Trans).Ni := 1;
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WS_Ovhd,
                                    Cbijown               => BS_Ovhd,
                                    Cij                   => WS_Ovhd,
                                    Cbij                  => BS_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   => Large_Time,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);
                                 -- Receive transaction
                                 Current_Trans := Current_Trans + 1;
                                 Transaction (Current_Trans).Transaction_Id :=
                                   Current_Trans;
                                 Transaction (Current_Trans).Kind_Of_Event :=
                                   Periodic;
                                 Transaction (Current_Trans).Trans_Input_Type
                                   := External;
                                 Transaction (Current_Trans).Ti :=
                                   Processing_Resources.Network.
                                   Min_Packet_Transmission_Time
                                     (Processing_Resources.Network.
                                        Packet_Based_Network'
                                        Class (A_Proc_Ref.all)) /
                                   Speed;
                                 Transaction (Current_Trans).Ni := 1;
                                 Transaction (Current_Trans).The_Task (1) :=
                                   (Cijown                => WR_Ovhd,
                                    Cbijown               => BR_Ovhd,
                                    Cij                   => WR_Ovhd,
                                    Cbij                  => BR_Ovhd,
                                    Tijown                =>
                                      Transaction (Current_Trans).Ti,
                                    Tij                   =>
                                      Transaction (Current_Trans).Ti,
                                    Bij                   => 0.0,
                                    Dij                   => Large_Time,
                                    SDij                  => 0.0,
                                    Schedij               => FP,
                                    Preemptible           => True,
                                    Oij                   => 0.0,
                                    Jij                   => 0.0,
                                    Jinit                 => 0.0,
                                    Sched_Delay           => 0.0,
                                    Oijmin                => 0.0,
                                    Oijmax                => 0.0,
                                    Delayijmin            => 0.0,
                                    Delayijmax            => 0.0,
                                    Model                 => Regular,
                                    Jitter_Avoidance      => False,
                                    Uses_Shared_Resources => False,
                                    Rij                   => 0.0,
                                    Rbij                  => 0.0,
                                    Prioij                =>
                                      Scheduling_Parameters.The_Priority
                                        (Scheduling_Parameters.
                                           Fixed_Priority_Parameters'Class
                                           (A_Sched_Param_Ref.all
                                           )),
                                    Procij                =>
                                      Get_Processor_Number
                                        (The_System, Driver_Proc_Ref),
                                    Resij                 => null,
                                    Max_Of_Best_Cases     => False,
                                    Pav                   =>
                                      Transaction (Current_Trans).The_Task (1).
                                        Pav);
                                 -- if interrupt priority, hard prio is true
                                 if Driver_Proc_Ref.all in
                                   Processing_Resources.
                                     Processor.Regular_Processor'Class
                                 then
                                    Max_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Max_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                    Min_Int_Priority :=
                                      Processing_Resources.Processor.
                                      Min_Interrupt_Priority
                                        (Processing_Resources.Processor.
                                           Regular_Processor'Class
                                           (Driver_Proc_Ref.all));
                                 else
                                    Min_Int_Priority := Priority'First;
                                    Max_Int_Priority := Priority'Last;
                                 end if;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Hard_Prio :=
                                   Transaction (Current_Trans).The_Task (1).
                                   Prioij in
                                   Min_Int_Priority .. Max_Int_Priority;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Preassigned := True;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_P_Ref := A_Sched_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   Synch_P_Ref := A_Synch_Param_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   P_R_Ref := Driver_Proc_Ref;
                                 Transaction (Current_Trans).The_Task (1).Pav.
                                   S_Policy_Ref :=
                                   Scheduling_Policies.
                                   Fixed_Priority_Policy_Ref
                                     (Driver_S_Policy_Ref);
                           end case;
                        when Drivers.Coupled =>
                           null;
                     end case;
                  end if;
               else
                  -- incorrect driver kind
                  raise Incorrect_Object;
               end if;
            end loop;
         elsif A_Proc_Ref.all in Processing_Resources.Processor.Processor'
             Class
         then
            --add the transactions caused by Ticker system timers
            Timer_Ref :=
              Processing_Resources.Processor.The_System_Timer
                (Processing_Resources.Processor.Regular_Processor'Class
                   (A_Proc_Ref.all));
            if Timer_Ref /= null
              and then Timer_Ref.all in Timers.Ticker'Class
            then
               Current_Trans                                             :=
                 Current_Trans + 1;
               Transaction (Current_Trans).Transaction_Id                :=
                 Current_Trans;
               Transaction (Current_Trans).Kind_Of_Event                 :=
                 Periodic;
               Transaction (Current_Trans).Trans_Input_Type              :=
                 External;
               Transaction (Current_Trans).Ti                            :=
                 Timers.Period (Timers.Ticker'Class (Timer_Ref.all));
               Transaction (Current_Trans).Ni                            := 1;
               Transaction (Current_Trans).The_Task (1)                  :=
                 (Cijown                =>
                    Timers.Worst_Overhead (Timer_Ref.all) / Speed,
                  Cbijown               =>
                    Timers.Best_Overhead (Timer_Ref.all) / Speed,
                  Cij                   =>
                    Timers.Worst_Overhead (Timer_Ref.all) / Speed,
                  Cbij                  =>
                    Timers.Best_Overhead (Timer_Ref.all) / Speed,
                  Tijown                => Transaction (Current_Trans).Ti,
                  Tij                   => Transaction (Current_Trans).Ti,
                  Bij                   => 0.0,
                  Dij                   => Large_Time,
                  SDij                  => 0.0,
                  Schedij               => FP,
                  Preemptible           => True,
                  Oij                   => 0.0,
                  Jij                   => 0.0,
                  Jinit                 => 0.0,
                  Sched_Delay           => 0.0,
                  Oijmin                => 0.0,
                  Oijmax                => 0.0,
                  Delayijmin            => 0.0,
                  Delayijmax            => 0.0,
                  Model                 => Regular,
                  Jitter_Avoidance      => False,
                  Uses_Shared_Resources => False,
                  Rij                   => 0.0,
                  Rbij                  => 0.0,
                  Prioij                =>
                    Processing_Resources.Processor.Max_Interrupt_Priority
                      (Processing_Resources.Processor.
                         Regular_Processor'Class (A_Proc_Ref.all)),
                  Procij                => Proc_Num,
                  Resij                 => null,
                  Max_Of_Best_Cases     => False,
                  Pav                   =>
                    Transaction (Current_Trans).The_Task (1).Pav);
               Transaction (Current_Trans).The_Task (1).Pav.Hard_Prio    :=
                 True;
               Transaction (Current_Trans).The_Task (1).Pav.Preassigned  :=
                 True;
               Transaction (Current_Trans).The_Task (1).Pav.P_R_Ref      :=
                 A_Proc_Ref;
               A_Sched_Policy_Ref        :=
                 Schedulers.Scheduling_Policy 
                   (Mast.Schedulers.Scheduler
                      (Mast.Schedulers.Primary.Find_Scheduler
                         (A_Proc_Ref,The_System).all));
               -- march 2025: added the following guard
               if A_Sched_Policy_Ref.all in 
                 Scheduling_Policies.Fixed_Priority_Policy 
               then
                  Transaction (Current_Trans).The_Task (1).Pav.S_Policy_Ref :=
                    Scheduling_Policies.Fixed_Priority_Policy_Ref
                      (A_Sched_Policy_Ref);
               else
                  Transaction (Current_Trans).The_Task (1).Pav.S_Policy_Ref :=
                    null;
               end if;
            end if;
         else
            raise Incorrect_Object;
         end if;
      end loop;

      -- Add overhead tasks

      declare
         The_Data : Task_Data;
         Iterator : Overhead_Task_Lists.Iteration_Object;
      begin
         Overhead_Task_Lists.Rewind (Overhead_Task_List, Iterator);
         for I in 1 .. Overhead_Task_Lists.Size (Overhead_Task_List) loop
            Overhead_Task_Lists.Get_Next_Item
              (The_Data,
               Overhead_Task_List,
               Iterator);
            Current_Trans                                := Current_Trans +
              1;
            Transaction (Current_Trans).Transaction_Id   := Current_Trans;
            Transaction (Current_Trans).Ti               := The_Data.Tij;
            Transaction (Current_Trans).Kind_Of_Event    := Periodic;
            Transaction (Current_Trans).Trans_Input_Type := External;
            Transaction (Current_Trans).Ni               := 1;
            Transaction (Current_Trans).The_Task (1)     := The_Data;
         end loop;
      end;

      -- Add empty transactions to fill array
      for Empty in Current_Trans + 1 .. Max_Transactions loop
         Transaction (Empty).Ti := Large_Time;
         Transaction (Empty).Ni := 0;
      end loop;

      -- Show data

      --        if Verbose then
      --           Put_Line("Transaction data obtained for analysis : ");
      --           Show_Linear_Translation(Transaction);
      --        end if;
   end Translate_Linear_System;

   -----------------------------
   -- Show_Linear_Translation --
   -----------------------------

   procedure Show_Linear_Translation
     (Transaction : Linear_Transaction_System)
   is
   begin
      for Trans in 1 .. Max_Transactions loop
         exit when Transaction (Trans).Ni = 0;
         --New_Line;
         Put
           ("Transaction : " &
              Transaction_ID_Type'Image (Trans) &
              " Period:" &
              IO.Time_Image (Transaction (Trans).Ti) &
              " ID= " &
              Transaction_ID_Type'Image (Transaction (Trans).Transaction_Id) &
              " Trans_Input_Type= " &
              Transaction_Input_Type'Image
                (Transaction (Trans).Trans_Input_Type));
         if Transaction(Trans).Predecessor_Trans_Ref/=null then
            Put(" Pred: ");
            for Pred in 1..Transaction
              (Trans).Predecessor_Trans_Ref.all'Length-1 
            loop
               Ada.Text_IO.Put
                 (Transaction(Trans).Predecessor_Trans_Ref(Pred)'Img&", ");
            end loop;
            Ada.Text_IO.Put(Transaction(Trans).Predecessor_Trans_Ref
                              (Transaction(Trans).Predecessor_Trans_Ref'Last)'Img);
         end if;
         if Transaction(Trans).Successor_Trans_Ref/=null then
            Put(" Succ: ");
            for Succ in 1..Transaction
              (Trans).Successor_Trans_Ref.all'Length-1 
            loop
               Ada.Text_IO.Put
                 (Transaction(Trans).Successor_Trans_Ref(Succ)'Img&", ");
            end loop;
            Ada.Text_IO.Put(Transaction(Trans).Successor_Trans_Ref
                              (Transaction(Trans).Successor_Trans_Ref'Last)'Img);
         end if;
         New_Line;
         for Tsk in 1 .. Transaction (Trans).Ni loop
            Put_Line
              ("   Task " &
                 Task_ID_Type'Image (Tsk) &
                 " Rbij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Rbij) &
                 " Rij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Rij) &
                 " Jij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Jij) &
                 " Prioij:" &
                 Priority'Image (Transaction (Trans).The_Task (Tsk).Prioij) &
                 " SDij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).SDij) &
                 " Cijown:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Cijown) &
                 " Cbijown:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Cbijown) &
                 " Cij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Cij) &
                 " Cbij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Cbij) &
                 " Tijown:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Tijown) &
                 " Tij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Tij) &
                 " Bij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Bij) &
                 " Dij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Dij) &
                 " Schedij:" &
                 Sched_Type'Image (Transaction (Trans).The_Task (Tsk).Schedij) &
                 " Preemptible:"&
                 (Transaction (Trans).The_Task (Tsk).Preemptible'Img) &
                 " Oij:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Oij) &
                 " Jinit:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Jinit) &
                 " Procij:" &
                 Processor_ID_Type'Image
                   (Transaction (Trans).The_Task (Tsk).Procij) &
                 " Sch_D:" &
                 IO.Time_Image (Transaction (Trans).
                                  The_Task (Tsk).Sched_Delay) &
                 " Delayijmin:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Delayijmin) &
                 " Delayijmax:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Delayijmax) &
                 " Oijmin:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Oijmin) &
                 " Oijmax:" &
                 IO.Time_Image (Transaction (Trans).The_Task (Tsk).Oijmax) &
                 " Model: " &
                 Model_Levels'Image (Transaction (Trans).The_Task (Tsk).Model) &
                 " JA : " &
                 Boolean'Image
                   (Transaction (Trans).The_Task (Tsk).Jitter_Avoidance));
         end loop;
      end loop;
   end Show_Linear_Translation;

   ---------------------------------------
   -- Translate_Linear_Analysis_Results --
   ---------------------------------------

   procedure Translate_Linear_Analysis_Results
     (Trans : in out Linear_Transaction_System;
      The_System  : in out Mast.Systems.System)
   is
      Next_Link_Ref : Mast.Graphs.Link_Ref;
      A_Result      : Mast.Results.Timing_Result_Ref;
      Resp_Time     : Time;
      Cumulate_Sched_Delay : Time;
   begin
      -- Check unschedulable cases
      -- Loop for all transactions
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Trans (I).Ni = 0;
         -- Loop for all tasks
         for J in 1 .. Trans (I).Ni loop
            if The_System.Inconclusive_Analysis_Results then
               -- Take into account systems with onconclusive results
               Trans (I).The_Task (J).Rij := Large_Time;
            elsif Trans (I).The_Task (J).Model = Unbounded_Effects then
               -- Take into account the tasks with unbounded effects on
               -- lower priority tasks
               for K in Transaction_ID_Type range 1 .. Max_Transactions loop
                  exit when Trans (K).Ni = 0;
                  for L in 1 .. Trans (K).Ni loop
                     if Trans (K).The_Task (L).Procij =
                       Trans (I).The_Task (J).Procij
                       and then Trans (K).The_Task (L).Prioij <=
                       Trans (I).The_Task (J).Prioij
                     then
                        Trans (K).The_Task (L).Rij := Large_Time;
                     end if;
                  end loop;
               end loop;
            end if;
         end loop;
      end loop;

      -- Set the result values for all transactions
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Trans (I).Ni = 0;
         Cumulate_Sched_Delay:=0.0;
         for J in 1 .. Trans (I).Ni loop
            -- Find link at the end of the segment
            Next_Link_Ref := Trans (I).The_Task (J).Resij;
            if Next_Link_Ref /= null then
               if Graphs.Has_Results (Next_Link_Ref.all) then
                  A_Result :=
                    Graphs.Links.Link_Time_Results
                      (Graphs.Links.Regular_Link (Next_Link_Ref.all));
               else
                  A_Result :=
                    Mast.Results.Create_Timing_Result (Next_Link_Ref);
               end if;
               -- Set the result values
               case Trans (I).The_Task (J).Model is
                  when Regular | Separate_Analysis =>
                     Cumulate_Sched_Delay:=Cumulate_Sched_Delay+
                       Trans (I).The_Task (J).Sched_Delay;
                     -- obtained response time
                     Resp_Time:=
                       Trans (I).The_Task (J).Rij +
                       Cumulate_Sched_Delay;
                     -- get maximum between previous time and new time
                     if Mast.Results.Has_Worst_Global_Response_Time
                       (A_Result.all,Trans (I).Evi)
                     then
                        Resp_Time:=
                          Time'Max
                            (Resp_Time,
                             Mast.Results.Worst_Global_Response_Time
                               (A_Result.all, Trans (I).Evi)+
                               Cumulate_Sched_Delay);
                     end if;
                     Mast.Results.Set_Worst_Global_Response_Time
                       (A_Result.all, Trans (I).Evi, Resp_Time);
                  when Unbounded_Response | Unbounded_Effects =>
                     Mast.Results.Set_Worst_Global_Response_Time
                       (A_Result.all, Trans (I).Evi, Large_Time);
               end case;
               -- Set best-case response time
               Resp_Time:=Trans (I).The_Task (J).Rbij;
               if Mast.Results.Has_Best_Global_Response_Time
                 (A_Result.all,Trans (I).Evi)
               then
                  -- Depending on behavior, the best response time
                  -- is calculated as a maximum or a minimum
                  -- join handlers require a maximum; all other handlers
                  -- require a minimum
                  if Trans (I).The_Task (J).Max_Of_Best_Cases then
                     Resp_Time:=Time'Max
                       (Resp_Time,
                        Mast.Results.Best_Global_Response_Time
                          (A_Result.all, Trans (I).Evi));
                  else
                     Resp_Time:=Time'Min
                       (Resp_Time,
                        Mast.Results.Best_Global_Response_Time
                          (A_Result.all, Trans (I).Evi));
                  end if;
               end if;
               Mast.Results.Set_Best_Global_Response_Time
                 (A_Result.all, Trans (I).Evi, Resp_Time);

               -- Set Jitter as difference between worst and best cases
               Mast.Results.Set_Jitter
                 (A_Result.all,
                  Trans (I).Evi,
                  Trans (I).The_Task (J).Rij - Trans (I).The_Task (J).Rbij);
            end if;
         end loop;
      end loop;
   end Translate_Linear_Analysis_Results;

   ------------------------------------------
   -- Clear_Time_Results --
   ------------------------------------------

   procedure Clear_Time_Results
     (Trans       : in out Linear_Transaction_System;
      The_System  : in out Mast.Systems.System)
   is
      Next_Link_Ref : Mast.Graphs.Link_Ref;
      A_Result      : Mast.Results.Timing_Result_Ref;
   begin
      -- Unset the inconclusive results flag
      The_System.Inconclusive_Analysis_Results:=False;
      
      -- Loop for all trasnsactions
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Trans (I).Ni = 0;
         for J in 1 .. Trans (I).Ni loop
            -- Find link at the end of the segment
            Next_Link_Ref := Trans (I).The_Task (J).Resij;
            if Next_Link_Ref /= null
              and then Graphs.Has_Results (Next_Link_Ref.all)
            then
               A_Result :=
                 Graphs.Links.Link_Time_Results
                   (Graphs.Links.Regular_Link (Next_Link_Ref.all));

               if A_Result.Has_Worst_Global_Response_Time
                 (Trans(I).Evi)
               then
                  -- The worst case is calculated as a maximum, 
                  -- therefore start with zero
                  A_Result.Set_Worst_Global_Response_Time
                    (Trans(I).Evi,0.0);
               end if;
               
               if A_Result.Has_Best_Global_Response_Time
                 (Trans(I).Evi)
               then
                  if Trans(I).The_Task(J).Max_Of_Best_Cases then
                     -- if best base is calculated as a maximum, 
                     -- start with zero
                     A_Result.Set_Best_Global_Response_Time
                       (Trans(I).Evi,0.0);
                  else
                     -- if best base is calculated as a minimum, 
                     -- start with large_time
                     A_Result.Set_Best_Global_Response_Time
                       (Trans(I).Evi,Large_Time);           
                  end if;
               end if;
               
            end if;
         end loop;
      end loop;
   end Clear_Time_Results;

   ------------------------------------------
   -- Translate_Linear_System_With_Results --
   ------------------------------------------

   procedure Translate_Linear_System_With_Results
     (The_System  : Mast.Systems.System;
      Transaction : out Linear_Transaction_System;
      Verbose     : Boolean := False)
   is
      Next_Link_Ref : Mast.Graphs.Link_Ref;
      A_Result      : Mast.Results.Timing_Result_Ref;
   begin
      Translate_Linear_System (The_System, Transaction, Verbose);
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            -- Find link at the end of the segment
            Next_Link_Ref := Transaction (I).The_Task (J).Resij;
            if Next_Link_Ref /= null
              and then Graphs.Has_Results (Next_Link_Ref.all)
            then
               A_Result :=
                 Graphs.Links.Link_Time_Results
                   (Graphs.Links.Regular_Link (Next_Link_Ref.all));
               -- Get the result values
               Transaction (I).The_Task (J).Rij  :=
                 Mast.Results.Worst_Global_Response_Time
                   (A_Result.all,
                    Transaction (I).Evi);
               Transaction (I).The_Task (J).Rbij :=
                 Mast.Results.Best_Global_Response_Time
                   (A_Result.all,
                    Transaction (I).Evi);
               Transaction (I).The_Task (J).Jij  :=
                 Mast.Results.Jitter (A_Result.all, Transaction (I).Evi);
            end if;
         end loop;
      end loop;
   end Translate_Linear_System_With_Results;

   --------------------------
   -- Translate_Priorities --
   --------------------------

   procedure Translate_Priorities
     (Transaction : Linear_Transaction_System;
      The_System  : in out Mast.Systems.System)
   is
      pragma Unreferenced (The_System);
   begin
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            -- Assign priorities via S_P_Ref field
            if not Transaction (I).The_Task (J).Pav.Hard_Prio
              and then not Transaction (I).The_Task (J).Pav.Preassigned
              and then not Transaction (I).The_Task (J).Pav.Is_Polling
              and then Transaction (I).The_Task (J).Pav.S_P_Ref /= null
            then
               if Transaction (I).The_Task (J).Pav.S_P_Ref.all in
                 Scheduling_Parameters.Fixed_Priority_Parameters'Class
               then
                  Mast.Scheduling_Parameters.Set_The_Priority
                    (Mast.Scheduling_Parameters.Fixed_Priority_Parameters
                       (Transaction (I).The_Task (J).Pav.S_P_Ref.all),
                     Transaction (I).The_Task (J).Prioij);
               else
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Incorrect writing of priorities");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
            end if;
         end loop;
      end loop;
   end Translate_Priorities;

   -------------------------
   -- Translate_Deadlines --
   -------------------------
   --¿Que hago con los Hard_Prio, Polling y Preassigned?
   --¿van a ser EDF_Parameters?

   procedure Translate_Deadlines
     (Transaction : Linear_Transaction_System;
      The_System  : in out Mast.Systems.System)
   is
      pragma Unreferenced (The_System);
   begin
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            -- Assign deadlines via S_P_Ref field
            --if not Transaction(I).The_Task(J).Pav.Hard_Prio
            --  and then
            if not Transaction (I).The_Task (J).Pav.Preassigned
              and then not Transaction (I).The_Task (J).Pav.Is_Polling
              and then Transaction (I).The_Task (J).Pav.S_P_Ref /= null
            then
               if Transaction (I).The_Task (J).Pav.S_P_Ref.all in
                 Scheduling_Parameters.EDF_Parameters'Class
               then
                  Mast.Scheduling_Parameters.Set_Deadline
                    (Mast.Scheduling_Parameters.EDF_Parameters
                       (Transaction (I).The_Task (J).Pav.S_P_Ref.all),
                     Transaction (I).The_Task (J).SDij);
               else
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Incorrect writing of deadlines");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
            end if;
         end loop;
      end loop;
   end Translate_Deadlines;

   ----------------------------------------
   -- Translate_Deadlines_and_Priorities --
   ----------------------------------------

   procedure Translate_Deadlines_and_Priorities
     (Transaction : Linear_Transaction_System;
      The_System  : in out Mast.Systems.System)
   is
      pragma Unreferenced (The_System);
   begin
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop

            if not Transaction (I).The_Task (J).Pav.Hard_Prio
              and then not Transaction (I).The_Task (J).Pav.Preassigned
              and then not Transaction (I).The_Task (J).Pav.Is_Polling
              and then Transaction (I).The_Task (J).Pav.S_P_Ref /= null
            then
               if Transaction (I).The_Task (J).Pav.S_P_Ref.all in
                 Scheduling_Parameters.Fixed_Priority_Parameters'Class
               then
                  Mast.Scheduling_Parameters.Set_The_Priority
                    (Mast.Scheduling_Parameters.Fixed_Priority_Parameters
                       (Transaction (I).The_Task (J).Pav.S_P_Ref.all),
                     Priority'Last);
               end if;
            end if;

         end loop;
      end loop;

      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            --              if Transaction(I).The_Task(J).Pav.Preassigned then
            --                 Put_line("preassigned");
            --              end if;
            --              if Transaction(I).The_Task(J).Pav.Is_Polling then
            --                 Put_line("is polling");
            --              end if;
            --              if Transaction(I).The_Task(J).Pav.Hard_Prio then
            --                 Put_line("hard prio");
            --              end if;
            --              if Transaction(I).The_Task(J).Pav.S_P_Ref = null
            --then
            --                 Put_line("is null");
            --              end if;
            if not Transaction (I).The_Task (J).Pav.Preassigned
              and then not Transaction (I).The_Task (J).Pav.Is_Polling
              and then Transaction (I).The_Task (J).Pav.S_P_Ref /= null
            then
               if Transaction (I).The_Task (J).Pav.S_P_Ref.all in
                 Scheduling_Parameters.EDF_Parameters'Class
               then
                  Mast.Scheduling_Parameters.Set_Deadline
                    (Mast.Scheduling_Parameters.EDF_Parameters
                       (Transaction (I).The_Task (J).Pav.S_P_Ref.all),
                     Transaction (I).The_Task (J).SDij);

               elsif Transaction (I).The_Task (J).Pav.S_P_Ref.all in
                 Scheduling_Parameters.Fixed_Priority_Parameters'Class
                 and then not Transaction (I).The_Task (J).Pav.Hard_Prio
               then

                  if Transaction (I).The_Task (J).Pav.Overridden_Ref /= null
                    and then Transaction (I).The_Task (J).Pav.Overridden_Ref.
                    all in Scheduling_Parameters.Overridden_FP_Parameters'Class
                  then

                     Scheduling_Parameters.Set_The_Priority
                       (Scheduling_Parameters.Overridden_FP_Parameters'Class
                          (Transaction (I).The_Task (J).Pav.Overridden_Ref.all),
                        Transaction (I).The_Task (J).Prioij);
                  end if;

                  if Transaction (I).The_Task (J).Prioij <
                    Mast.Scheduling_Parameters.The_Priority
                      (Mast.Scheduling_Parameters.Fixed_Priority_Parameters
                         (Transaction (I).The_Task (J).Pav.S_P_Ref.all))
                  then
                     Mast.Scheduling_Parameters.Set_The_Priority
                       (Mast.Scheduling_Parameters.Fixed_Priority_Parameters
                          (Transaction (I).The_Task (J).Pav.S_P_Ref.all),
                        Transaction (I).The_Task (J).Prioij);
                  end if;

               else
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Incorrect writing of scheduling parameters");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
            end if;

         end loop;
      end loop;
   end Translate_Deadlines_and_Priorities;
   
   
   --------------------------------------
   -- Set_Response_Times_To_Large_Time --
   --------------------------------------
   procedure Set_Response_Times_To_Large_Time 
     (Transaction : in out Linear_Transaction_System)
   is
      Next_Link_Ref : Mast.Graphs.Link_Ref;      
      A_Result     : Mast.Results.Timing_Result_Ref;
   begin
      for I in 1..Max_Transactions
      loop
         exit when Transaction(I).Ni=0;
         for K in 1..Transaction(I).Ni loop
            Transaction(I).The_Task(K).Model:=Unbounded_Effects;
            Transaction(I).The_Task(K).Rij:=Large_Time;
            Transaction(I).The_Task(K).Jij:=Large_Time;
            
            Next_Link_Ref:=Transaction(I).The_Task(K).Resij;
            if Next_Link_Ref/=null then
               if Graphs.Has_Results(Next_Link_Ref.all) then
                  A_Result:=Graphs.Links.Link_Time_Results
                    (Graphs.Links.Regular_Link(Next_Link_Ref.all));
               else
                  A_Result:=Mast.Results.Create_Timing_Result
                    (Next_Link_Ref);
               end if;
               -- Set the result values
               Mast.Results.Set_Worst_Global_Response_Time
                 (A_Result.all,
                  Transaction(I).Evi,Large_Time);
               Mast.Results.Set_Best_Global_Response_Time
                 (A_Result.all,
                  Transaction(I).Evi,Large_Time);
               Mast.Results.Set_Jitter
                 (A_Result.all,
                  Transaction(I).Evi,Large_Time);
            end if;
            
         end loop;
      end loop;
   end Set_Response_Times_To_Large_Time;
   
   
   --Show_Deadlines just for tests
   procedure Show_Debug_Deadlines
     (Transaction : Linear_Transaction_System)
   is
      Sum_D : Time;
      pragma Unreferenced (Sum_D);
   begin
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         Sum_D := 0.0;
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            --if Transaction(I).The_Task(J).Pav.S_P_Ref.all in
            --  Scheduling_Parameters.EDF_Parameters'Class
            --then
            Ada.Text_IO.Put (Img(Transaction (I).The_Task (J).Pav.D_0,2) & " ");
            --                 D := Mast.Scheduling_Parameters.Deadline
            --                   (Mast.Scheduling_Parameters.EDF_Parameters
            --                      (Transaction(I).The_Task(J).Pav.S_P_Ref.all
            --));
            --                 Sum_D := Sum_D + D;
            --Put(Current_Output,Transaction_ID_Type'Image(I)&","&Task_ID_Type'
            --Image(J)&" :");
            --Put(Current_Output,Time'Image(D)&" ");
            --end if;
         end loop;

         --Put("Suma : ");
         --Put_Line(Time'Image(Sum_D));
         New_Line;
      end loop;
   end Show_Debug_Deadlines;

   --     procedure Show_Scheduling_Parameters
   --       (Transaction : in Linear_Transaction_System;
   --        The_System : in MAST.Systems.System)
   --     is
   --        D : Time;
   --        Prio : Priority;
   --        isLocal : Boolean :=
   --The_System.The_Processor_Analysis_Tool.isLocal;
   --     begin
   --        for I in Transaction_ID_Type range 1..Max_Transactions loop
   --           exit when Transaction(I).Ni=0;
   --           Put(Transaction_ID_Type'Image(Transaction(I).Transaction_ID)&"
   --- ");
   --
   --           for J in 1..Transaction(I).Ni loop
   --
   --              begin
   --                 if Transaction(I).The_Task(J).Pav.S_P_Ref.all in
   --                   Scheduling_Parameters.EDF_Parameters'Class
   --                 then
   --                    D := Mast.Scheduling_Parameters.Deadline
   --                      (Mast.Scheduling_Parameters.EDF_Parameters
   --                         (Transaction(I).The_Task(J).Pav.S_P_Ref.all));
   --                    if isLocal then
   --                       Put("ld[ "&IO.Time_Image(D)&" ] ");
   --                    else
   --                       Put("gd[ "&IO.Time_Image(D)&" ] ");
   --                    end if;
   --
   --
   --                 elsif Transaction(I).The_Task(J).Pav.S_P_Ref.all in
   --                   Scheduling_Parameters.Fixed_Priority_Parameters'Class
   --                 then
   --                    Prio := Mast.Scheduling_Parameters.The_Priority
   --                      (Mast.Scheduling_Parameters.Fixed_Priority_Parameter
   --s
   --                         (Transaction(I).The_Task(J).Pav.S_P_Ref.all));
   --                    Put("p[ "&Priority'Image(Prio)&" ] ");
   --                 end if;
   --              exception
   --                 when CONSTRAINT_ERROR => null;
   --              end;
   --           end loop;
   --           New_line;
   --        end loop;
   --     end Show_Scheduling_Parameters;


   procedure Show_Scheduling_Parameters
     (Transaction : Linear_Transaction_System)
   is
      Extra : Transaction_ID_Type;
      I     : Transaction_ID_Type;
   begin
      I := 1;
      while Transaction (I).Ni /= 0 loop
         Extra := 0;
         for J in Transaction_ID_Type range (I + 1) .. Max_Transactions loop
            -- Feb 2025: added a new exit condition to prevent visiting
            -- transactions with no valid data
            exit when Transaction (J).Ni = 0 or else 
              Transaction (J).Transaction_Id /=
              Transaction (I).Transaction_Id;
            Extra := Extra + 1;
         end loop;

         for K in 0 .. Extra loop
            Put
              (Transaction_ID_Type'Image
                 (Transaction (I + K).Transaction_Id) &
                 " - ");
            for J in 1 .. Transaction (I + K).Ni loop
               case Transaction (I + K).The_Task (J).Schedij is
                  when FP =>
                     Put
                       ("p[ " &
                          Priority'Image
                            (Transaction (I + K).The_Task (J).Prioij) &
                          " ] ");
                  when EDF_Local =>
                     Put
                       ("ld[ " &
                          IO.Time_Image (Transaction (I + K).
                                           The_Task (J).SDij) &
                          " ] ");
                  when EDF_Global =>
                     Put
                       ("gd[ " &
                          IO.Time_Image (Transaction (I + K).
                                           The_Task (J).SDij) &
                          " ] ");
               end case;
            end loop;
         end loop;

         New_Line;
         exit when (I + Extra + 1) not  in Transaction_ID_Type;
         I := I + Extra + 1;
      end loop;
   end Show_Scheduling_Parameters;
   
   --Show_Deadlines just for tests
   procedure Show_response (Transaction : Linear_Transaction_System) is
      Extra : Transaction_ID_Type;
      I     : Transaction_ID_Type;
   begin
      I := 1;
      while Transaction (I).Ni /= 0 loop
         Extra := 0;
         for J in Transaction_ID_Type range (I + 1) .. Max_Transactions loop
            exit when Transaction (J).Transaction_Id /=
              Transaction (I).Transaction_Id;
            Extra := Extra + 1;
         end loop;

         for K in 0 .. Extra loop
            Put
              (Transaction_ID_Type'Image
                 (Transaction (I + K).Transaction_Id) &
                 " - ");
            for J in 1 .. Transaction (I + K).Ni loop
               Put
                 (" " &
                    IO.Time_Image (Transaction (I + K).The_Task (J).Rij) &
                    " ");
            end loop;
         end loop;

         New_Line;
         exit when (I + Extra + 1) not  in Transaction_ID_Type;
         I := I + Extra + 1;
      end loop;
   end Show_response;

   procedure Show_Debug_Results
     (Transaction : Linear_Transaction_System)
   is
   begin
      for I in Transaction_ID_Type range 1 .. Max_Transactions loop
         exit when Transaction (I).Ni = 0;
         for J in 1 .. Transaction (I).Ni loop
            Ada.Float_Text_IO.Put
              (Float (Transaction (I).The_Task (J).Rij),
               Exp => 0);
            Put (" ");
         end loop;
         New_Line;
      end loop;
   end Show_Debug_Results;

end Mast.Linear_Translation;
