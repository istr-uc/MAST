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

with Mast.Restrictions,Mast.Miscelaneous_Tools,
  Mast.Linear_Analysis_Tools,Mast.Tool_Exceptions,
  Mast.Linear_Priority_Assignment_Tools,
  Mast.Linear_Deadline_Assignment_Tools, Mast.Events,
  Mast.Monoprocessor_Tools, Mast.Results, Mast.Operations,
  Mast.Linear_Translation, Mast.Max_Numbers,
  Mast.Graphs.Links, Mast.Timing_Requirements, Mast.Graphs.Event_Handlers,
  Mast.Scheduling_Servers, Mast.Processing_Resources,
  Mast.Consistency_Checks, Mast.IO, Ada.Text_IO,Var_Strings;
use Ada.Text_IO,Var_Strings;
use type MAST.Graphs.Link_Ref;
use type MAST.Graphs.Event_Handler_Ref;
use type MAST.Events.Event_Ref;
use type MAST.Graphs.Event_Handler_Lists.Index;
use type Mast.Timing_Requirements.Timing_Requirement_Ref;
use type MAST.Operations.Operation_Ref;
use type MAST.Processing_Resources.Processing_Resource_Ref;
use type MAST.Results.Utilization_Result_Ref;

package body MAST.Tools is


   use type Results.Slack_Result_Ref;
   type Processor_ID is new Natural;
   type Transaction_ID is new Natural;
   type Task_ID is new Natural;
   type Long_Int is range -(2**31-1)..2**31-2;

   ------------------------------
   -- Calculate_Blocking_Times --
   ------------------------------

   procedure Calculate_Blocking_Times
     (The_System : in out Mast.Systems.System;
      Verbose : in Boolean:=True)
   is
   begin
      if not MAST.Restrictions.PCP_SRP_Or_Priority_Inheritance_Only
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("PCP_SRP_or_Priority_Inheritance_Only restriction "&
                     "not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      if not Consistency_Checks.Consistent_Shared_Resource_Usage
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("Consistent shared resource check not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      if not Consistency_Checks.Consistent_Shared_Resource_Usage_For_Segments
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("Consistent shared resource usage for segments"&
                     " check not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent for segment");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      Mast.Miscelaneous_Tools.Calculate_Blocking_Times (The_System,Verbose);
   end Calculate_Blocking_Times;

   -----------------------------------
   -- Calculate_Ceilings_And_Levels --
   -----------------------------------

   procedure Calculate_Ceilings_And_Levels
     (The_System : in out Mast.Systems.System;
      Verbose : in Boolean:=True)
   is
   begin
      if not MAST.Restrictions.PCP_SRP_Or_Priority_Inheritance_Only
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("PCP_SRP_or_Priority_Inheritance_Only restriction "&
                     "not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      if not Consistency_Checks.Consistent_Shared_Resource_Usage
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("Consistent shared resource check not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      if not Consistency_Checks.Consistent_Shared_Resource_Usage_For_Segments
        (The_System,Verbose)
      then
         if Verbose then
            Put_Line("Consistent shared resource usage for segments"&
                     " check not met");
         end if;
         Tool_Exceptions.Set_Restriction_Message
           ("Shared Resources not consistent for segment");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
      Mast.Miscelaneous_Tools.Calculate_Ceilings_And_Levels
        (The_System,Verbose);
   end Calculate_Ceilings_And_Levels;

   --------------------------------------------
   -- Calculate_System_Slack --
   --------------------------------------------

   procedure Calculate_System_Slack
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Max_Factor : constant Normalized_Execution_Time := 2.0**10;
      Small_Step : constant Normalized_Execution_Time := 0.01;
      Factor,Initial : Normalized_Execution_Time:=1.0;

      function Is_Schedulable return Boolean is
         Schedulable : Boolean;
      begin
         if Restrictions.Max_Processor_Utilization
           (The_System,False)>=1.0-Float(Small_Step)/2.0
         then
            return False;
         else
            ---- Stop_Factor_When_Not_Schedulable=>1 ------
            The_Tool(The_System,False,Stop_Factor_When_Not_Schedulable=>1);
            Check_System_Schedulability(The_System,Schedulable,False);
            return Schedulable;
         end if;
      exception
         when Tool_Exceptions.Restriction_Not_Met =>
            return False;
      end Is_Schedulable;

      function Find_Factor_In_Interval
        (Initial,Final : Normalized_Execution_Time)
        return Normalized_Execution_Time
      is
         Half : Normalized_Execution_Time:=(Initial+Final)/2.0;
      begin
         Operations.Scale(The_System.Operations,Half);
         if Is_Schedulable then
            if Final-Half<Small_Step then
               return Half;
            else
               return Find_Factor_In_Interval(Half,Final);
            end if;
         else -- not schedulable
            if Half-Initial<Small_Step then
               return Initial;
            else
               return Find_Factor_In_Interval(Initial,Half);
            end if;
         end if;
      end Find_Factor_In_Interval;

      function System_Has_Timing_Requirements return Boolean
      is
         A_Link_Ref : MAST.Graphs.Link_Ref;
         Iterator : Transactions.Link_Iteration_Object;
         Tim_Req_Ref : MAST.Timing_Requirements.Timing_Requirement_Ref;
         Trans_Ref : MAST.Transactions.Transaction_Ref;
         It : Transactions.Lists.Iteration_Object;
      begin
         MAST.Transactions.Lists.Rewind(The_System.Transactions,It);
         for I in 1..MAST.Transactions.Lists.Size(The_System.Transactions)
         loop
            MAST.Transactions.Lists.Get_Next_Item
              (Trans_Ref,The_System.Transactions,It);
            MAST.Transactions.Rewind_Internal_Event_Links
              (Trans_Ref.all,Iterator);
            for J in 1..MAST.Transactions.Num_Of_Internal_Event_Links
              (Trans_Ref.all)
            loop
               MAST.Transactions.Get_Next_Internal_Event_Link
                 (Trans_Ref.all,A_Link_Ref,Iterator);
               Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
                 (Graphs.Links.Regular_Link(A_Link_Ref.all));
               if Tim_Req_Ref=null then
                  return False;
               elsif Tim_Req_Ref.all in
                 Mast.Timing_Requirements.Hard_Global_Deadline'Class
                 or else Tim_Req_Ref.all in
                   Mast.Timing_Requirements.Hard_Local_Deadline'Class
                 or else Tim_Req_Ref.all in
                     Mast.Timing_Requirements.Max_Output_Jitter_Req'Class then
                  return True;
               end if;
            end loop;
         end loop;
         if Verbose then
            Put_Line("Transaction: "&
                     To_String(MAST.Transactions.Name(Trans_Ref))&
                     "  has no hard timing requirements");
         end if;
         return False;
      end System_Has_Timing_Requirements;

      The_Slack : Float;
      Res : Results.Slack_Result_Ref;

   begin
      -- no hard timing requirements
      if not System_Has_Timing_Requirements then
         return;
      -- Initial analysis
      elsif Is_Schedulable then
         -- duplicate times until not schedulable
         loop
            Initial:=Factor;
            Factor:=Factor*2.0;
            Operations.Scale(The_System.Operations,Factor);
            if not Is_Schedulable then
               Factor:=Find_Factor_In_Interval(Initial,Factor);
               exit;
            end if;
            exit when Factor>=Max_Factor;
         end loop;
      else  -- not schedulable
         Operations.Scale(The_System.Operations,0.0);
         if Is_Schedulable then
            Factor:=Find_Factor_In_Interval(0.0,1.0);
         else
            Factor:=0.0;
         end if;
      end if;
      The_Slack:=Float(Factor-1.0)*100.0;
      Res:=Systems.Slack_Result(The_System);
      if Res=null then
         Res:= new Results.Slack_Result;
      end if;
      Results.Set_Slack(Res.all,The_Slack);
      Systems.Set_Slack_Result(The_System,Res);
      Put_Line("System slack result: "&Float'Image(The_Slack));
      Operations.Scale(The_System.Operations,1.0);
   end Calculate_System_Slack;

   ---------------------------------
   -- Calculate_Transaction_Slack --
   ---------------------------------
   -- calculates the relative amount that the execution times of the
   -- actions of the transaction referenced by Trans_Ref may grow
   -- (or may need decreasing) for the system to continue
   -- being (or become) schedulable
   -- Ci* = Ci * (1+The_Slack) for all actions in the transaction

   procedure Calculate_Transaction_Slack
     (Trans_Ref : in MAST.Transactions.Transaction_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Max_Factor : constant Normalized_Execution_Time := 2.0**10;
      Small_Step : constant Normalized_Execution_Time := 0.01;
      Factor,Initial : Normalized_Execution_Time:=1.0;

      function Is_Schedulable return Boolean is
         Schedulable : Boolean;
      begin
         if Restrictions.Max_Processor_Utilization
           (The_System,False)>=1.0-Float(Small_Step)/2.0
         then
            return False;
         else
            ----- Stop_Factor_When_Not_Schedulable=>1 --------
            The_Tool(The_System,False,Stop_Factor_When_Not_Schedulable=>1);
            Check_System_Schedulability(The_System,Schedulable,False);
            return Schedulable;
         end if;
      exception
         when Tool_Exceptions.Restriction_Not_Met =>
            return False;
      end Is_Schedulable;

      function Find_Factor_In_Interval
        (Initial,Final : Normalized_Execution_Time)
        return Normalized_Execution_Time
      is
         Half : Normalized_Execution_Time:=(Initial+Final)/2.0;
      begin
         Transactions.Scale(Trans_Ref.all,Half);
         if Is_Schedulable then
            if Final-Half<Small_Step then
               return Half;
            else
               return Find_Factor_In_Interval(Half,Final);
            end if;
         else -- not schedulable
            if Half-Initial<Small_Step then
               return Initial;
            else
               return Find_Factor_In_Interval(Initial,Half);
            end if;
         end if;
      end Find_Factor_In_Interval;

      function Transaction_Has_Timing_Requirements
        (Trans_Ref : in MAST.Transactions.Transaction_Ref) return Boolean
      is
         A_Link_Ref : MAST.Graphs.Link_Ref;
         Iterator : Transactions.Link_Iteration_Object;
         Tim_Req_Ref : MAST.Timing_Requirements.Timing_Requirement_Ref;
      begin
         MAST.Transactions.Rewind_Internal_Event_Links
           (Trans_Ref.all,Iterator);
         for J in 1..MAST.Transactions.Num_Of_Internal_Event_Links
           (Trans_Ref.all)
         loop
            MAST.Transactions.Get_Next_Internal_Event_Link
              (Trans_Ref.all,A_Link_Ref,Iterator);
            Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
              (Graphs.Links.Regular_Link(A_Link_Ref.all));
            if Tim_Req_Ref=null then
               return True;
            elsif Tim_Req_Ref.all in
              Mast.Timing_Requirements.Hard_Global_Deadline'Class or else
            Tim_Req_Ref.all in
              Mast.Timing_Requirements.Hard_Local_Deadline'Class or else
            Tim_Req_Ref.all in
              Mast.Timing_Requirements.Max_Output_Jitter_Req'Class then
               return True;
            end if;
         end loop;
         if Verbose then
            Put_Line("Transaction: "&
                        To_String(MAST.Transactions.Name(Trans_Ref))&
                           " has no hard timing requirements");
         end if;
         return False;
      end Transaction_Has_Timing_Requirements;

      The_Slack : Float;
      Res : Results.Slack_Result_Ref;

   begin
      -- no hard timing requirements
      if not Transaction_Has_Timing_Requirements(Trans_Ref) then
         return;
      -- Initial analysis
      elsif Is_Schedulable then
         -- duplicate times until not schedulable
         loop
            Initial:=Factor;
            Factor:=Factor*2.0;
            Transactions.Scale(Trans_Ref.all,Factor);
            if not Is_Schedulable then
               Factor:=Find_Factor_In_Interval(Initial,Factor);
               exit;
            end if;
            exit when Factor>=Max_Factor;
         end loop;
      else  -- not schedulable
         Transactions.Scale(Trans_Ref.all,0.0);
         if Is_Schedulable then
            Factor:=Find_Factor_In_Interval(0.0,1.0);
         else
            Factor:=0.0;
         end if;
      end if;

      The_Slack:=Float(Factor-1.0)*100.0;
      Res:=Transactions.Slack_Result(Trans_Ref.all);
      if Res=null then
         Res:= new Results.Slack_Result;
      end if;
      Results.Set_Slack(Res.all,The_Slack);
      Transactions.Set_Slack_Result(Trans_Ref.all,Res);
      Transactions.Scale(Trans_Ref.all,1.0);
   end Calculate_Transaction_Slack;

   ----------------------------------
   -- Calculate_Transaction_Slacks --
   ----------------------------------
   -- Invokes Calculate_Transaction_Slack for all transactions in the system
   -- and stores the slacks in the results

   procedure Calculate_Transaction_Slacks
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Trans_Ref : Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Index;
   begin
      Transactions.Lists.Rewind(The_System.Transactions,Iterator);
      for I in 1..Transactions.Lists.Size(The_System.Transactions) loop
         Transactions.Lists.Get_Next_Item
           (Trans_Ref,The_System.Transactions,Iterator);
         if Verbose then
            Put_Line("Calculating Transaction Slack for "&
                     Transactions.Name(Trans_Ref));
         end if;
         Calculate_Transaction_Slack
           (Trans_Ref,The_System,The_Tool,Verbose);
      end loop;
   end Calculate_Transaction_Slacks;

   -----------------------------------------
   -- Calculate_Processing_Resource_Slack --
   -----------------------------------------
   -- calculates the relative amount that the speed of the processing
   -- resource referenced by Res_Ref may be decreased
   -- (or may need inreasing) for the system to continue
   -- being (or become) schedulable
   -- Speed* = Speed * (1-The_Slack/100) for the processing resource

   procedure Calculate_Processing_Resource_Slack
     (Res_Ref : in MAST.Processing_Resources.Processing_Resource_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Max_Factor : constant Processor_Speed := 2.0**6;
      Small_Step : constant Processor_Speed := 0.005;
      Factor,Initial : Processor_Speed:=1.0;

      function Is_Schedulable return Boolean is
         Schedulable : Boolean;
      begin
         if Restrictions.Max_Processor_Utilization
           (The_System,False)>=1.0-Float(Small_Step)/2.0
         then
            return False;
         else
            ----- Stop_Factor_When_Not_Schedulable=>1 ------
            The_Tool(The_System,False,Stop_Factor_When_Not_Schedulable=>1);
            Check_System_Schedulability(The_System,Schedulable,False);
            return Schedulable;
         end if;
      exception
         when Tool_Exceptions.Restriction_Not_Met =>
            return False;
      end Is_Schedulable;

      function Find_Factor_In_Interval
        (Initial,Final : Processor_Speed)
        return Processor_Speed
      is
         Half : Processor_Speed:=(Initial+Final)/2.0;
      begin
         Processing_Resources.Scale(Res_Ref.all,Half);
         if not Is_Schedulable then
            if Final-Half<Small_Step then
               return Half;
            else
               return Find_Factor_In_Interval(Half,Final);
            end if;
         else -- schedulable
            if Half-Initial<Small_Step then
               return Initial;
            else
               return Find_Factor_In_Interval(Initial,Half);
            end if;
         end if;
      end Find_Factor_In_Interval;

      function Processing_Resource_Has_Timing_Requirements
        (Res_Ref : in MAST.Processing_Resources.Processing_Resource_Ref)
         return Boolean
      is
         A_Link_Ref : MAST.Graphs.Link_Ref;
         Iterator : Transactions.Link_Iteration_Object;
         Tim_Req_Ref : MAST.Timing_Requirements.Timing_Requirement_Ref;
         Trans_Ref : MAST.Transactions.Transaction_Ref;
         It : Transactions.Lists.Iteration_Object;
         Ev_Handler : MAST.Graphs.Event_Handler_Ref;
         It_EH : Mast.Transactions.Event_Handler_Iteration_Object;
         Serv_Ref : Mast.Scheduling_Servers.Scheduling_Server_Ref;
         A_Proc_Ref : MAST.Processing_Resources.Processing_Resource_Ref;

      begin
         MAST.Transactions.Lists.Rewind(The_System.Transactions,It);
         for I in 1..MAST.Transactions.Lists.Size(The_System.Transactions)
         loop
            MAST.Transactions.Lists.Get_Next_Item
              (Trans_Ref,The_System.Transactions,It);
            MAST.Transactions.Rewind_Event_Handlers(Trans_Ref.all,It_EH);
            for J in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
            loop
               Mast.Transactions.Get_Next_Event_Handler(Trans_Ref.all, Ev_Handler, It_EH);
               if Ev_Handler.all in Mast.Graphs.Event_Handlers.Activity'Class
               then
                  Serv_Ref:=Mast.Graphs.Event_Handlers.Activity_Server(Mast.Graphs.Event_Handlers.Activity(Ev_Handler.all));
                  A_Proc_Ref:=MAST.Scheduling_Servers.Server_Processing_Resource(Serv_Ref.all);
                  if Res_Ref = A_Proc_Ref
                  then MAST.Transactions.Rewind_Internal_Event_Links(Trans_Ref.all,Iterator);
                     for K in 1..MAST.Transactions.Num_Of_Internal_Event_Links
                       (Trans_Ref.all)
                     loop
                        MAST.Transactions.Get_Next_Internal_Event_Link
                          (Trans_Ref.all,A_Link_Ref,Iterator);
                        Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
                          (Graphs.Links.Regular_Link(A_Link_Ref.all));
                        if Tim_Req_Ref=null then
                           return True;
                        elsif Tim_Req_Ref.all in
                          Mast.Timing_Requirements.Hard_Global_Deadline'Class or else
                        Tim_Req_Ref.all in
                          Mast.Timing_Requirements.Hard_Local_Deadline'Class or else
                        Tim_Req_Ref.all in
                          Mast.Timing_Requirements.Max_Output_Jitter_Req'Class then
                           return True;
                        end if;
                     end loop;

                     if Verbose then
                        Put_Line("Processing_Resource: "&
                                 To_String(MAST.Transactions.Name(Trans_Ref))&
                                 " has no hard timing requirements");
                     end if;

                     return False;
                  end if;

               end if;
            end loop;
         end loop;

         return False;
      end Processing_Resource_Has_Timing_Requirements;


      The_Slack : Float;
      Res : Results.Slack_Result_Ref;

   begin
       -- no hard timing requirements
      if not Processing_Resource_Has_Timing_Requirements(Res_Ref) then
         return;
      -- Initial analysis
      elsif not Is_Schedulable then
         -- duplicate speed until schedulable
         loop
            Initial:=Factor;
            Factor:=Factor*2.0;
            Processing_Resources.Scale(Res_Ref.all,Factor);
            if Is_Schedulable then
               Factor:=Find_Factor_In_Interval(Initial,Factor);
               exit;
            end if;
            exit when Factor>=Max_Factor;
         end loop;
      else  -- schedulable
            -- reduce speed until not schedulable
         Processing_Resources.Scale(Res_Ref.all,Small_Step);
         if not Is_Schedulable then
            Factor:=Find_Factor_In_Interval(Small_Step,1.0);
         else
            Factor:=Small_Step;
         end if;
      end if;
      The_Slack:=(1.0/Float(Factor)-1.0)*100.0;
      Res:=Processing_Resources.Slack_Result(Res_Ref.all);
      if Res=null then
         Res:= new Results.Slack_Result;
      end if;
      Results.Set_Slack(Res.all,The_Slack);
      Processing_Resources.Set_Slack_Result(Res_Ref.all,Res);
      Processing_Resources.Scale(Res_Ref.all,1.0);
   end Calculate_Processing_Resource_Slack;

   ------------------------------------------
   -- Calculate_Processing_Resource_Slacks --
   ------------------------------------------
   -- Invokes Calculate_Processing_Resource_Slack for all processing
   -- resources in the system

   procedure Calculate_Processing_Resource_Slacks
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Res_Ref : Processing_Resources.Processing_Resource_Ref;
      Iterator : Processing_Resources.Lists.Index;
   begin
      Processing_Resources.Lists.Rewind
        (The_System.Processing_Resources,Iterator);
      for I in 1..Processing_Resources.Lists.Size
        (The_System.Processing_Resources)
      loop
         Processing_Resources.Lists.Get_Next_Item
           (Res_Ref,The_System.Processing_Resources,Iterator);
         if Verbose then
            Put_Line("Calculating Processing Resource Slack for "&
                     Processing_Resources.Name(Res_Ref));
         end if;
         Calculate_Processing_Resource_Slack
           (Res_Ref,The_System,The_Tool,Verbose);
      end loop;
   end Calculate_Processing_Resource_Slacks;

   -------------------------------
   -- Calculate_Operation_Slack --
   -------------------------------
   -- calculates the relative amount that the execution time of the
   -- operation referenced by Op_Ref may grow
   -- (or may need decreasing) for the system to continue
   -- being (or become) schedulable
   -- Ci* = Ci * (1+The_Slack/100) for that operation

   procedure Calculate_Operation_Slack
     (Op_Ref : in MAST.Operations.Operation_Ref;
      The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
      Max_Factor : constant Normalized_Execution_Time := 2.0**10;
      Small_Step : constant Normalized_Execution_Time := 0.01;
      Factor,Initial : Normalized_Execution_Time:=1.0;

      function Is_Schedulable return Boolean is
         Schedulable : Boolean;
      begin
         if Restrictions.Max_Processor_Utilization
           (The_System,False)>=1.0-Float(Small_Step)/2.0
         then
            return False;
         else
            ----- Stop_Factor_When_Not_Schedulable=>1 ----
            The_Tool(The_System,False,Stop_Factor_When_Not_Schedulable=>1);
            Check_System_Schedulability(The_System,Schedulable,False);
            return Schedulable;
         end if;
      exception
         when Tool_Exceptions.Restriction_Not_Met =>
            return False;
      end Is_Schedulable;

      function Find_Factor_In_Interval
        (Initial,Final : Normalized_Execution_Time)
        return Normalized_Execution_Time
      is
         Half : Normalized_Execution_Time:=(Initial+Final)/2.0;
      begin
         Operations.Scale(Op_Ref.all,Half);
         if Is_Schedulable then
            if Final-Half<Small_Step then
               return Half;
            else
               return Find_Factor_In_Interval(Half,Final);
            end if;
         else -- not schedulable
            if Half-Initial<Small_Step then
               return Initial;
            else
               return Find_Factor_In_Interval(Initial,Half);
            end if;
         end if;
      end Find_Factor_In_Interval;

      function Find_Operation
        (Op_Origen : in Mast.Operations.Operation_Ref;
         Op_Destino : in Mast.Operations.Operation_Ref)
         return Boolean
      is
         It: Mast.Operations.Operation_Iteration_Object;
         Op_Out_Ref: Mast.Operations.Operation_Ref;
      begin
         if Op_Destino.all in Mast.Operations.Simple_Operation'Class
         then
            if Op_Origen = Op_Destino
            then
               return True;
            else
               return False;
            end if;
         elsif Op_Destino.all in Mast.Operations.Composite_Operation'Class
         then
            for I in 1..Mast.Operations.Num_Of_Operations
              (Mast.Operations.Composite_Operation(Op_Destino.all))
            loop
               Mast.Operations.Get_Next_Operation
                 (Mast.Operations.Composite_Operation
                    (Op_Destino.all), Op_Out_Ref, It);
               return Find_Operation(Op_Origen, Op_Out_Ref);
            end loop;
         elsif Op_Destino.all in Mast.Operations.Enclosing_Operation'Class
         then
            for I in 1..Mast.Operations.Num_Of_Operations
              (Mast.Operations.Enclosing_Operation(Op_Destino.all))
            loop
               Mast.Operations.Get_Next_Operation
                 (Mast.Operations.Enclosing_Operation
                    (Op_Destino.all), Op_Out_Ref, It);
               return Find_Operation(Op_Origen, Op_Out_Ref);
            end loop;
         end if;
         return False;
      end Find_Operation;

      function Operation_Has_Timing_Requirements
        (Op_Origen : in Mast.Operations.Operation_Ref)
         return Boolean
      is
         A_Link_Ref : MAST.Graphs.Link_Ref;
         Iterator : Transactions.Link_Iteration_Object;
         Tim_Req_Ref : MAST.Timing_Requirements.Timing_Requirement_Ref;
         Trans_Ref : MAST.Transactions.Transaction_Ref;
         It : Transactions.Lists.Iteration_Object;
         Ev_Handler : MAST.Graphs.Event_Handler_Ref;
         It_EH : Mast.Transactions.Event_Handler_Iteration_Object;
         Op_Destino : Mast.Operations.Operation_Ref;

      begin
         MAST.Transactions.Lists.Rewind(The_System.Transactions,It);
         for I in 1..MAST.Transactions.Lists.Size(The_System.Transactions)
         loop
            MAST.Transactions.Lists.Get_Next_Item
              (Trans_Ref,The_System.Transactions,It);
            for J in 1..Mast.Transactions.Num_Of_Event_Handlers(Trans_Ref.all)
            loop
               Mast.Transactions.Get_Next_Event_Handler
                 (Trans_Ref.all, Ev_Handler, It_EH);
               if Ev_Handler.all in Mast.Graphs.Event_Handlers.Activity'Class
               then
                  Op_Destino:= Mast.Graphs.Event_Handlers.Activity_Operation
                    (Mast.Graphs.Event_Handlers.Activity(Ev_Handler.all));
                  if Find_Operation(Op_Origen, Op_Destino)
                  then
                     MAST.Transactions.Rewind_Internal_Event_Links
                       (Trans_Ref.all,Iterator);
                     for K in 1..MAST.Transactions.Num_Of_Internal_Event_Links
                       (Trans_Ref.all)
                     loop
                        MAST.Transactions.Get_Next_Internal_Event_Link
                          (Trans_Ref.all,A_Link_Ref,Iterator);
                        Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
                          (Graphs.Links.Regular_Link(A_Link_Ref.all));
                        if Tim_Req_Ref=null then
                           return True;
                        elsif Tim_Req_Ref.all in
                          Mast.Timing_Requirements.Hard_Global_Deadline'Class
                          or else Tim_Req_Ref.all in
                            Mast.Timing_Requirements.Hard_Local_Deadline'Class
                            or else Tim_Req_Ref.all in
                              Mast.Timing_Requirements.Max_Output_Jitter_Req'Class
                        then
                           return True;
                        end if;
                     end loop;

                     if Verbose then
                        Put_Line("Operation: "&
                                 To_String(MAST.Transactions.Name(Trans_Ref))&
                                 " has no hard timing requirements");
                     end if;

                     return False;
                  end if;
               end if;
            end loop;
         end loop;

         return False;

      end Operation_Has_Timing_Requirements;

      The_Slack : Float;
      Res : Results.Slack_Result_Ref;

   begin
      -- no hard timing requirements
      if not Operation_Has_Timing_Requirements(Op_Ref) then
         return;
      -- Initial analysis
      elsif Is_Schedulable then
         -- duplicate times until not schedulable
         loop
            Initial:=Factor;
            Factor:=Factor*2.0;
            Operations.Scale(Op_Ref.all,Factor);
            if not Is_Schedulable then
               Factor:=Find_Factor_In_Interval(Initial,Factor);
               exit;
            end if;
            exit when Factor>=Max_Factor;
         end loop;
      else  -- not schedulable
         Operations.Scale(Op_Ref.all,0.0);
         if Is_Schedulable then
            Factor:=Find_Factor_In_Interval(0.0,1.0);
         else
            Factor:=0.0;
         end if;
      end if;
      The_Slack:=Float(Factor-1.0)*100.0;
      Res:=Operations.Slack_Result(Op_Ref.all);
      if Res=null then
         Res:= new Results.Slack_Result;
      end if;
      Results.Set_Slack(Res.all,The_Slack);
      Operations.Set_Slack_Result(Op_Ref.all,Res);
      Operations.Scale(Op_Ref.all,1.0);
   end Calculate_Operation_Slack;

   -------------------------------------------
   -- Check_Shared_Resources_Total_Ordering --
   -------------------------------------------

   procedure Check_Shared_Resources_Total_Ordering
     (The_System : in MAST.Systems.System;
      Ordered : out Boolean;
      Verbose : in Boolean:=True) renames
     Mast.Miscelaneous_Tools.Check_Shared_Resources_Total_Ordering;

   -------------------------
   -- Classic_RM_Analysis --
   -------------------------

   procedure Classic_RM_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.Fixed_Priority_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Monoprocessor_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Simple_Transactions_Only
           (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
           (The_System,Verbose)
           and then Mast.Restrictions.No_Permanent_Overridden_Priorities
           (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               Mast.Monoprocessor_Tools.RM_Analysis
              (The_System,Verbose,
               Stop_Factor_When_Not_Schedulable=>Positive'Last );
            end if;
         else
            if Verbose then
               Put_Line("Classic Rate Monotonic Analysis");
               Put_Line(" Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Classic Rate Monotonic Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met ;
--        end if;
   end Classic_RM_Analysis;

   ---------------------------------
   -- Check_System_Schedulability --
   ---------------------------------

   procedure Check_System_Schedulability
     (The_System : MAST.Systems.System;
      Is_Schedulable : out Boolean;
      Verbose : in Boolean:=True) renames
     Mast.Miscelaneous_Tools.Check_System_Schedulability;

   --------------------------------------
   -- Check_Transaction_Schedulability --
   --------------------------------------

   procedure Check_Transaction_Schedulability
     (Trans_Ref : MAST.Transactions.Transaction_Ref;
      Is_Schedulable : out Boolean;
      Verbose : in Boolean:=True) renames
     Mast.Miscelaneous_Tools.Check_Transaction_Schedulability;

   --------------------------------
   -- EDF_Monoprocessor_Analysis --
   --------------------------------

   procedure EDF_Monoprocessor_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then Mast.Restrictions.SRP_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Monoprocessor_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Simple_Transactions_Only
           (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
           (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               --Mast.EDF_Tools.EDF_Monoprocessor_Analysis (The_System,Verbose);
               Mast.Monoprocessor_Tools.
                        EDF_Monoprocessor_Analysis (The_System,Verbose);
            end if;
         else
            if Verbose then
               Put_Line ("EDF Monoprocessor Analysis");
               Put_Line ("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("EDF Monoprocessor Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message ("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met;
--        end if;
   end EDF_Monoprocessor_Analysis;

   ------------------------------------
   -- EDF_Within_Priorities_Analysis --
   ------------------------------------

   procedure EDF_Within_Priorities_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.EDF_Within_Priorities_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Monoprocessor_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Simple_Transactions_Only
           (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
           (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               -- Mast.EDF_Tools.EDF_Within_Priorities_Analysis
               --(The_System,Verbose);
               Mast.Monoprocessor_Tools.EDF_Within_Priorities_Analysis
                        (The_System,Verbose);
            end if;
         else
            if Verbose then
               Put_Line("EDF Within Priorities Analysis");
               Put_Line("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("EDF Within Priorities Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met ;
--        end if;
   end EDF_Within_Priorities_Analysis;

   -----------------
   -- Linear_HOPA --
   -----------------

   procedure Linear_HOPA
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose)
      then
         if Mast.Restrictions.Fixed_Priority_Only (The_System, Verbose)
           and then Mast.Restrictions.Linear_Plus_Transactions_Only
             (The_System,
              Verbose)
         then
            if (The_Tool = Holistic_Analysis'Access) or
              (The_Tool = Classic_RM_Analysis'Access) or
              (The_Tool = Varying_Priorities_Analysis'Access) or
              (The_Tool = Offset_Based_Analysis'Access) or
              (The_Tool = Offset_Based_Optimized_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Linear HOPA running...");
               end if;
               Mast.Linear_Priority_Assignment_Tools.HOPA
                 (The_System,The_Tool,Verbose);
            else
               if Verbose then
                  Put_Line("Linear HOPA");
                  Put_Line("  Incorrect analysis tool for Linear HOPA");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Linear HOPA");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         else
            Tool_Exceptions.Set_Restriction_Message
              ("Linear HOPA Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      else
         Tool_Exceptions.Set_Restriction_Message ("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
   end Linear_HOPA;


   ------------------------
   -- Linear_Local_HOSDA --
   ------------------------

   procedure Linear_Local_HOSDA
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose)
      then
         if Mast.Restrictions.EDF_Only (The_System, Verbose)
           and then Mast.Restrictions.Linear_Plus_Transactions_Only
             (The_System,
              Verbose)
         then
            if (The_Tool = Holistic_Local_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Local HOSDA running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.Local_HOSDA
                 (The_System,
                  The_Tool,
                  Verbose);
            else
               if Verbose then
                  Put_Line("Linear HOSDA");
                  Put_Line("  Incorrect analysis tool for Linear Local HOSDA");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Linear Local HOSDA");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         else
            Tool_Exceptions.Set_Restriction_Message
              ("Linear Local HOSDA Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      else
         Tool_Exceptions.Set_Restriction_Message ("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
   end Linear_Local_HOSDA;


   -------------------------
   -- Linear_Global_HOSDA --
   -------------------------

   procedure Linear_Global_HOSDA
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose)
      then
         if Mast.Restrictions.EDF_Only (The_System, Verbose)
           and then Mast.Restrictions.Linear_Plus_Transactions_Only
             (The_System,
              Verbose)
         then
            if (The_Tool = Holistic_Global_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Global HOSDA running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.Global_HOSDA
                 (The_System,
                  The_Tool,
                  Verbose);
            else
               if Verbose then
                  Put_Line("Linear HOSDA");
                  Put_Line("  Incorrect analysis tool for Linear Global HOSDA");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Linear Global HOSDA");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         else
            Tool_Exceptions.Set_Restriction_Message
              ("Linear Global HOSDA Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      else
         Tool_Exceptions.Set_Restriction_Message ("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
   end Linear_Global_HOSDA;


   --------------------------------------
   -- Proportional_Deadline_Assignment --
   --------------------------------------

   procedure Linear_Proportional_Local_Deadline_Assignment
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose) then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then
             Mast.Restrictions.Linear_Plus_Transactions_Only
               (The_System,
                Verbose)
         then
            if (The_Tool = Holistic_Local_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Proportional Local Deadline Assignment running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.
                 Proportional_Local_Deadline_Assignment
                   (The_System,
                    The_Tool,
                    Verbose);
            else
               if Verbose then
                  Put_Line("Incorrect analysis tool for Proportional Local Deadline");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Proportional Local Deadline");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         end if;
      end if;
   end Linear_Proportional_Local_Deadline_Assignment;



   procedure Linear_Proportional_Global_Deadline_Assignment
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose) then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then
             Mast.Restrictions.Linear_Plus_Transactions_Only
               (The_System,
                Verbose)
         then
            if (The_Tool = Holistic_Global_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Proportional Global Deadline Assignment running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.
                 Proportional_Global_Deadline_Assignment
                   (The_System,
                    The_Tool,
                    Verbose);
            else
               if Verbose then
                  Put_Line("Incorrect analysis tool for Proportional Global Deadline Assignment");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Proportional Global Deadline Assignment");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         end if;
      end if;
   end Linear_Proportional_Global_Deadline_Assignment;

   ------------------------------------
   -- Normalized_Deadline_Assignment --
   ------------------------------------

   procedure Linear_Normalized_Local_Deadline_Assignment
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose) then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then
             Mast.Restrictions.Linear_Plus_Transactions_Only
               (The_System,
                Verbose)
         then
            if (The_Tool = Holistic_Local_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Normalized Local Deadline Assignment running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.
                 Normalized_Local_Deadline_Assignment
                   (The_System,
                    The_Tool,
                    Verbose);
            else
               if Verbose then
                  Put_Line("Incorrect analysis tool for Normalized Local Deadline Assignment");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Normalized Local Deadline Assignment");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         end if;
      end if;
   end Linear_Normalized_Local_Deadline_Assignment;



   procedure Linear_Normalized_Global_Deadline_Assignment
     (The_System : in out Mast.Systems.System;
      The_Tool   : in Worst_Case_Analysis_Tool;
      Verbose    : in Boolean := True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose) then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then
             Mast.Restrictions.Linear_Plus_Transactions_Only
               (The_System,
                Verbose)
         then
            if (The_Tool = Holistic_Global_EDF_Analysis'Access)
            then
               if Verbose then
                  Put_Line ("Normalized Global Deadline Assignment running...");
               end if;
               Mast.Linear_Deadline_Assignment_Tools.
                 Normalized_Global_Deadline_Assignment
                   (The_System,
                    The_Tool,
                    Verbose);
            else
               if Verbose then
                  Put_Line("Incorrect analysis tool for Normalized Global Deadline Assignment");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Normalized Global Deadline Assignment");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         end if;
      end if;
   end Linear_Normalized_Global_Deadline_Assignment;

   -------------------------
   -- Multiple_Event_HOPA --
   -------------------------

   procedure Multiple_Event_HOPA
     (The_System : in out MAST.Systems.System;
      The_Tool: in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
   begin
      null;
   end Multiple_Event_HOPA;

   -----------------------
   -- Holistic_Analysis --
   -----------------------

   procedure Holistic_Analysis
     (The_System                       : in out Mast.Systems.System;
      Verbose                          : in Boolean  := True;
      Only_Check_Restrictions          : in Boolean  := False;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last)
   is
   begin
      if Mast.Restrictions.Fixed_Priority_Only (The_System, Verbose) then
         if Mast.Restrictions.Linear_Plus_Transactions_Only
           (The_System,
            Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
             (The_System,
              Verbose)
           and then Mast.Restrictions.No_Permanent_Overridden_Priorities
             (The_System,
              Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times (The_System, Verbose);
               Linear_Analysis_Tools.Holistic_Analysis
                 (The_System,
                  Verbose,
                  Stop_Factor_When_Not_Schedulable => Positive'Last);
            end if;
         else
            if Verbose then
               Put_Line ("Holistic Analysis");
               Put_Line ("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Holistic Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      end if;
   end Holistic_Analysis;


   ----------------------------------
   -- EDF Global Holistic_Analysis --
   ----------------------------------

   procedure Holistic_Global_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then MAST.Restrictions.No_Shared_Resources
             (The_System,Verbose)
           and then MAST.Restrictions.Linear_Plus_Transactions_Only
             (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
             (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               Mast.Linear_Analysis_Tools.
                 Holistic_Global_EDF_Analysis(The_System,Verbose);--,
               --Stop_Factor_When_Not_Schedulable);
            end if;
         else
            if Verbose then
               Put_Line("Holistic Global EDF Analysis");
               Put_Line("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Holistic Global EDF Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met ;
--        end if;
   end Holistic_Global_EDF_Analysis;


   ---------------------------------
   -- EDF Local Holistic_Analysis --
   ---------------------------------

   procedure Holistic_Local_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.EDF_Only
           (The_System,Verbose)
           and then MAST.Restrictions.No_Shared_Resources
             (The_System,Verbose)
           and then MAST.Restrictions.Linear_Plus_Transactions_Only
             (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
             (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               Mast.Linear_Analysis_Tools.
                 Holistic_Local_EDF_Analysis(The_System,Verbose);--,
               --Stop_Factor_When_Not_Schedulable);
            end if;
         else
            if Verbose then
               Put_Line("Holistic Local EDF Analysis");
               Put_Line("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Holistic Local EDF Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met ;
--        end if;
   end Holistic_Local_EDF_Analysis;

   ---------------------------------------
   -- Offset_Based_Analysis --
   ---------------------------------------

   procedure Offset_Based_Analysis
     (The_System                       : in out Mast.Systems.System;
      Verbose                          : in Boolean  := True;
      Only_Check_Restrictions          : in Boolean  := False;
      Stop_Factor_When_Not_Schedulable : in Positive := Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load (The_System, Verbose) then
         if Mast.Restrictions.Fixed_Priority_Only (The_System, Verbose)
           and then Mast.Restrictions.Linear_Plus_Transactions_Only
             (The_System,
              Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
             (The_System,
              Verbose)
           and then Mast.Restrictions.No_Permanent_Overridden_Priorities
             (The_System,
              Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times (The_System, Verbose);
               Linear_Analysis_Tools.Offset_Based_Unoptimized_Analysis
                 (The_System,
                  Verbose,
                  Stop_Factor_When_Not_Schedulable => Positive'Last);
            end if;
         else
            if Verbose then
               Put_Line ("Offset_Based_Analysis");
               Put_Line ("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Offset_Based analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
   end Offset_Based_Analysis;
   -------------------------------------
   -- Offset_Based_Optimized_Analysis --
   -------------------------------------

   procedure Offset_Based_Optimized_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
--        if Mast.Restrictions.Feasible_Processing_Load
--          (The_System,Verbose)
--        then
         if MAST.Restrictions.Fixed_Priority_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Linear_Plus_Transactions_Only
           (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
           (The_System,Verbose)
           and then Mast.Restrictions.No_Permanent_Overridden_Priorities
           (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               Linear_Analysis_Tools.Offset_Based_Optimized_Analysis
                 (The_System,Verbose,Stop_Factor_When_Not_Schedulable=>Positive'Last);
            end if;
         else
            if Verbose then
               Put_Line("Offset_Based_Optimized_Analysis");
               Put_Line("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Offset_Based_Optimized Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
--        else
--           Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
--           raise Tool_Exceptions.Restriction_Not_Met;
--        end if;
   end Offset_Based_Optimized_Analysis;

   ------------------------------
   -- Monoprocessor_Assignment --
   ------------------------------

   procedure Monoprocessor_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load
        (The_System,Verbose)
      then
         if MAST.Restrictions.Monoprocessor_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Simple_Transactions_Only
           (The_System,Verbose)
         then
            if MAST.Restrictions.Fixed_Priority_Only (The_System,Verbose)
            then
               if (The_Tool = Classic_RM_Analysis'Access)
                 or (The_Tool = Varying_Priorities_Analysis'Access)
                 or (The_Tool = Holistic_Analysis'Access)
                 or (The_Tool = Offset_Based_Analysis'Access)
                 or (The_Tool = Offset_Based_Optimized_Analysis'Access)
               then
                  if Verbose then
                     Put_Line("Monoprocessor Priority Assignment running...");
                  end if;
                  Mast.Monoprocessor_Tools.Priority_Assignment
                    (The_System,The_Tool,Verbose);
               else
                  if Verbose then
                     Put_Line("Monoprocessor Priority Assignment");
                     Put_Line("  Incorrect analysis tool for "&
                              "Monoprocessor Priority Assignment");
                  end if;
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Incorrect analysis tool for "&
                     "Monoprocessor Priority Assignment");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
            elsif MAST.Restrictions.EDF_Only (The_System,Verbose) or else
              MAST.Restrictions.EDF_Within_Priorities_Only (The_System,Verbose)
            then
               if (The_Tool = EDF_Monoprocessor_Analysis'Access)
                 or (The_Tool = EDF_Within_Priorities_Analysis'Access)
                 or (The_Tool = Holistic_Analysis'Access)
                 or (The_Tool = Offset_Based_Analysis'Access)
                 or (The_Tool = Offset_Based_Optimized_Analysis'Access)
               then
                  if Verbose then
                     Put_Line("Monoprocessor Deadline Assignment running...");
                  end if;
                  -- Mast.EDF_Tools.Deadline_Assignment (The_System,Verbose);
                  Mast.Monoprocessor_Tools.Deadline_Assignment
                        (The_System,Verbose);
               else
                  if Verbose then
                     Put_Line("Monoprocessor Deadline Assignment");
                     Put_Line("  Incorrect analysis tool for "&
                              "Monoprocessor Deadline Assignment");
                  end if;
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Incorrect analysis tool for "&
                     "Monoprocessor Deadline Assignment");
                  raise Tool_Exceptions.Tool_Failure;
               end if;
            else
               if Verbose then
                  Put_Line("Monoprocessor Assignment");
                  Put_Line("  Assignment tool not valid for "&
                           "this kind of system");
               end if;
               Tool_Exceptions.Set_Restriction_Message
                 ("Linear Monoprocessor Assigment Restrictions"&
                  " not met");
               raise Tool_Exceptions.Restriction_Not_Met;
            end if;
         else
            if Verbose then
               Put_Line("Monoprocessor Assignment");
               Put_Line("  Assignment tool not valid for "&
                        "this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Linear Monoprocessor Assigment Restrictions"&
               " not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;

      else
         Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
   end Monoprocessor_Assignment;

   -----------------------------
   -- Multiple_Event_Analysis --
   -----------------------------

   procedure Multiple_Event_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
      null;
   end Multiple_Event_Analysis;

   -------------------------------------------
   -- Linear_Simulated_Annealing_Assignment --
   -------------------------------------------

   procedure Linear_Simulated_Annealing_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load
        (The_System,Verbose)
      then
         if MAST.Restrictions.Fixed_Priority_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Linear_Plus_Transactions_Only
           (The_System,Verbose)
         then
            if (The_Tool = Holistic_Analysis'Access)
              or (The_Tool = Classic_RM_Analysis'Access)
              or (The_Tool = Varying_Priorities_Analysis'Access)
              or (The_Tool = Offset_Based_Analysis'Access)
              or (The_Tool = Offset_Based_Optimized_Analysis'Access)then
               if Verbose then
                  Put_Line("Linear Simulated Annealing running...");
               end if;
               Mast.Linear_Priority_Assignment_Tools.Simulated_Annealing
                 (The_System,The_Tool,Verbose);
            else
               if Verbose then
                  Put_Line("Linear Simulated Annealing");
                  Put_Line("  Incorrect analysis tool for"&
                           " Linear Simulated Annealing");
               end if;
               Tool_Exceptions.Set_Tool_Failure_Message
                 ("Incorrect analysis tool for Linear Simulated Annealing");
               raise Tool_Exceptions.Tool_Failure;
            end if;
         else
            if Verbose then
               Put_Line("Linear Simulated Annealing");
               Put_Line("  Priority assignment tool not valid for "&
                        "this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Linear Simulated Annealing Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      else
         Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met;
      end if;
   end Linear_Simulated_Annealing_Assignment;

   ---------------------------------------------------
   -- Multiple_Event_Simulated_Annealing_Assignment --
   ---------------------------------------------------

   procedure Multiple_Event_Simulated_Annealing_Assignment
     (The_System : in out MAST.Systems.System;
      The_Tool : in Worst_Case_Analysis_Tool;
      Verbose : in Boolean:=True)
   is
   begin
      null;
   end Multiple_Event_Simulated_Annealing_Assignment;

   ----------------------
   -- Utilization_Test --
   ----------------------

   procedure Utilization_Test
     (The_System : MAST.Systems.System;
      Suceeds : out Boolean;
      Verbose : in Boolean:=True) renames
     Mast.Miscelaneous_Tools.Utilization_Test;

   ---------------------------------
   -- Varying_Priorities_Analysis --
   ---------------------------------

   procedure Varying_Priorities_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Only_Check_Restrictions : in Boolean:=False;
      Stop_Factor_When_Not_Schedulable : in Positive:=Positive'Last)
   is
   begin
      if Mast.Restrictions.Feasible_Processing_Load
        (The_System,Verbose)
      then
         if MAST.Restrictions.Fixed_Priority_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Monoprocessor_Only
           (The_System,Verbose)
           and then MAST.Restrictions.Simple_Transactions_Only
           (The_System,Verbose)
           and then Mast.Restrictions.Referenced_Events_Are_External_Only
           (The_System,Verbose)
           and then Mast.Restrictions.No_Intermediate_Timing_Requirements
           (The_System,Verbose)
           and then Mast.Restrictions.
           No_Permanent_FP_Inside_Composite_Operations
           (The_System,Verbose)
         then
            if not Only_Check_Restrictions then
               Calculate_Blocking_Times(The_System,Verbose);
               Mast.Monoprocessor_Tools.Varying_Priorities_Analysis
                 (The_System,Verbose,
                  Stop_Factor_When_Not_Schedulable=>Positive'Last);
            end if;
         else
            if Verbose then
               Put_Line("Varying Priorities Analysis");
               Put_Line("  Analysis not valid for this kind of system");
            end if;
            Tool_Exceptions.Set_Restriction_Message
              ("Varying Priorities Analysis Restrictions not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
      else
         Tool_Exceptions.Set_Restriction_Message("Utilization_Too_High");
         raise Tool_Exceptions.Restriction_Not_Met ;
      end if;
   end Varying_Priorities_Analysis;

   -----------------------------------------------
   -- Calculate_Processing_Resource_Utilization --
   -----------------------------------------------

   function Calculate_Processing_Resource_Utilization
     (The_System : MAST.Systems.System;
      The_PR : Mast.Processing_Resources.Processing_Resource_Ref;
      Verbose : Boolean := True) return Float

   is
      Ut_Res: Float;
      Res : Results.Utilization_Result_Ref;

   begin
      Ut_Res:=
        Mast.Miscelaneous_Tools.Calculate_Processing_Resource_Utilization
          (The_System,The_PR,Verbose)*100.0;
      Res:= Processing_Resources.Utilization_Result(The_PR.all);
      if Res=null then
         Res:= new Results.Utilization_Result;
      end if;
      Results.Set_Total(Res.all,Ut_Res);
      Processing_Resources.Set_Utilization_Result(The_PR.all,Res);
      return (Ut_Res/100.0);

   end Calculate_Processing_Resource_Utilization;

   ----------------------------------
   -- Calculate_System_Utilization --
   ----------------------------------

   function Calculate_System_Utilization
     (The_System : MAST.Systems.System;
      Verbose : Boolean := True) return Float

   is
   begin
      if Mast.Restrictions.
        Linear_Plus_Transactions_Only (The_System,False) then
         return Mast.Miscelaneous_Tools.Calculate_System_Utilization
           (The_System,Verbose);
      else
         if Verbose then
            Put_Line("Calculate_System_Utilization not yet implemented for"&
                     " Multiple-Event systems");
         end if;
         Tool_Exceptions.Set_Tool_Failure_Message
           ("Calculate_System_Utilization not yet implemented for"&
            " Multiple-Event systems");
         raise Tool_Exceptions.Tool_Failure;
      end if;

   end Calculate_System_Utilization;

end MAST.Tools;
