-----------------------------------------------------------------------
--                MAST Graphical Periodic Task Editor                --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 3 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, see                      --
-- <http://www.gnu.org/licenses/>.                                   --
--                                                                   --
-----------------------------------------------------------------------

with Changes_Control;
with Global_Options;
with Task_Table;
with Mutex_Table;
with Usage_Table;
with Results_Table;
with Dialog1_Pkg; use Dialog1_Pkg;

with Var_Strings; use Var_Strings;
with Mast; use Mast;
with Mast.Systems;
with Mast.Processing_Resources;
with Mast.Processing_Resources.Processor;
with Mast.Timers;
with Mast.Schedulers;
with Mast.Schedulers.Primary;
with Mast.Scheduling_Policies;
with Mast.Scheduling_Servers;
with Mast.Scheduling_Parameters;
with Mast.Synchronization_Parameters;
with Mast.Operations;
with Mast.Shared_Resources;
with Mast.Transactions;
with Mast.Events;
with Mast.Timing_Requirements;
with Mast.Graphs;
with Mast.Graphs.Links;
with Mast.Graphs.Event_Handlers;
with Mast.Tools;
with Mast.Restrictions;
with Mast.Results;
with Mast.Timing_Requirements;
with Mast.Restrictions;
with Mast.Tool_Exceptions;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Directories; use Ada.Directories;
with Ada.Containers.Vectors;

package body Model_Operations is

   package Mss_Description is new
     Ada.Containers.Vectors (Positive,Var_String,"=");

   Model : access Mast.Systems.System;
   Mss : Mss_Description.Vector;
   The_Tool : Tools.Worst_Case_Analysis_Tool;

   --------------------
   -- Generate_Model --
   --------------------

   procedure Generate_Model is
      CPU : Mast.Processing_Resources.Processing_Resource_Ref;
      Timer : Timers.System_Timer_Ref;
      Scheduler : Schedulers.Scheduler_Ref;
      Policy : Scheduling_Policies.Scheduling_Policy_Ref;
      Param : Mast.Scheduling_Parameters.Sched_Parameters_Ref;
      Server : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      Synch_Param : Mast.Synchronization_Parameters.Synch_Parameters_Ref;
      Mutex : Shared_Resources.Shared_Resource_Ref;
      Op,Enc : Operations.Operation_Ref;
      Trans : Transactions.Transaction_Ref;
      Ev,Ev2 : Events.Event_Ref;
      Lnk : Graphs.Link_Ref;
      Step : Graphs.Event_Handler_Ref;
      Req : Timing_Requirements.Timing_Requirement_Ref;
      Name,WCET,T,D,Prio, Taskname, Mutexname : Var_String;
      Xpos, Ypos : Natural;
      Xlimit : constant Natural:=1000;
   begin
      -- If there is no model to generate, exit procedure
      if not (Changes_Control.Changes_Made_Since_Last_Model_Generated and then
                Task_Table.Num_Tasks>0)
      then
         return;
      end if;

      -- Create new model
      Model:=new Mast.Systems.System;
      case Global_Options.Get_Policy is
         when Global_Options.FP =>
            The_Tool:=Tools.Classic_RM_Analysis'Access;
         when Global_Options.EDF =>
            The_Tool:=Tools.EDF_Monoprocessor_Analysis'Access;
      end case;
      Mss.Clear;
      Mss.Append(To_Var_String(" "));

      if Global_Options.Get_System_Name/="" then
         Model.Model_Name:=To_Var_String
           (Simple_Name(Global_Options.Get_System_Name));
      end if;
      Model.Generation_Tool:=To_Var_String("MAST Periodic Task Editor");


      -- Create processor
      CPU:=new Processing_Resources.Processor.Regular_Processor;
      Processing_Resources.Init(CPU.all,To_Var_String("cpu"));
      Processing_Resources.Lists.Add(CPU,Model.Processing_Resources);
      Mss.Append(To_Var_String("ME_Processing_Resource Me_Regular_Processor"&
                                 " cpu Proc_Res_Canvas 175 54 "));


      -- Create System Timer
      if Global_Options.Get_Timer_Jitter/=0.0 then
         Timer:=new Timers.Ticker;
         Timers.Set_Period(Timers.Ticker(Timer.all),
                           Global_Options.Get_Timer_Jitter);
         Processing_Resources.Processor.Set_System_Timer
           (Processing_Resources.Processor.Regular_Processor(CPU.all),Timer);
         Mss.Append(To_Var_String
                      ("ME_Timer Me_System_Timer cpu Proc_Res_Canvas 29 201 "));
      end if;

      -- Create Scheduling policy
      case Global_Options.Get_Policy is
         when Global_Options.FP =>
            Policy:=new Scheduling_Policies.Fixed_Priority;
            Scheduling_Policies.Set_Worst_Context_Switch
              (Scheduling_Policies.Fixed_Priority(Policy.all),
                 Global_Options.Get_Context_Switch);
         when Global_Options.EDF =>
            Policy:=new Scheduling_Policies.EDF;
            Scheduling_Policies.Set_Worst_Context_Switch
              (Scheduling_Policies.EDF(Policy.all),
                 Global_Options.Get_Context_Switch);
      end case;

      -- Create scheduler
      Scheduler:=new Schedulers.Primary.Primary_Scheduler;
      Schedulers.Init(Scheduler.all,To_Var_String("cpu_scheduler"));
      Schedulers.Primary.Set_Host
        (Schedulers.Primary.Primary_Scheduler(Scheduler.all),CPU);
      Schedulers.Set_Scheduling_Policy(Scheduler.all,Policy);
      schedulers.Lists.Add(Scheduler,Model.Schedulers);
      Mss.Append(To_Var_String("ME_Scheduler Me_Primary_Scheduler "&
                                 "cpu_scheduler Proc_Res_Canvas 390 178 "));
      Mss.Append(To_Var_String("ME_Scheduler Me_Primary_Scheduler "&
                                 "cpu_scheduler Sched_Server_Canvas 200 40 "));

      -- Create Schedulable resources
      Xpos:=20;
      YPos:=140;
      for Row in 1..Task_Table.Num_Tasks loop
         Task_Table.Get_Task(Row,Name,WCET,T,D,Prio);
         case Global_Options.Get_Policy is
            when Global_Options.FP =>
               -- Create scheduling parameters
               Param:=new Scheduling_Parameters.Fixed_Priority_Policy;
               Scheduling_Parameters.Set_The_Priority
                 (Scheduling_Parameters.Fixed_Priority_Parameters(Param.all),
                  Priority'Value(To_String(Prio)));
               -- Create schedulable resource
               Server:=new Scheduling_Servers.Scheduling_Server;
               Scheduling_Servers.Init (Server.all,To_Lower(Name));
               Scheduling_Servers.Set_Server_Scheduler
                 (Server.all,Scheduler);
               Scheduling_Servers.Set_Server_Sched_Parameters
                 (Server.all,Param);
            when Global_Options.EDF =>
               -- Create scheduling parameters
               Param:=new Scheduling_Parameters.EDF_Policy;
               Scheduling_Parameters.Set_Deadline
                 (Scheduling_Parameters.EDF_Parameters(Param.all),
                  Time'Value(To_String(D)));
               -- Create synchronization parameters
               Synch_Param:=new Synchronization_Parameters.SRP_Parameters;
               Synchronization_Parameters.Set_Preemption_Level
                 (Synchronization_Parameters.SRP_Parameters(Synch_Param.all),
                  Preemption_Level'Value(To_String(Prio)));
               -- Create schedulable resource
               Server:=new Scheduling_Servers.Scheduling_Server;
               Scheduling_Servers.Init (Server.all,To_Lower(Name));
               Scheduling_Servers.Set_Server_Scheduler
                 (Server.all,Scheduler);
               Scheduling_Servers.Set_Server_Sched_Parameters
                 (Server.all,Param);
               Scheduling_Servers.Set_Server_Synch_Parameters
                 (Server.all,Synch_Param);
         end case;
         Scheduling_Servers.Lists.Add(Server,Model.Scheduling_Servers);
         Mss.Append("ME_Scheduling_Server Me_Server "&To_Lower(Name)&
                      " Sched_Server_Canvas"&Natural'Image(Xpos)&
                      Natural'Image(Ypos)&" ");
         Xpos:=Xpos+180;
         if Xpos>=Xlimit then
            Xpos:=20;
            Ypos:=YPos+50;
         end if;
      end loop;

      -- Create task operations
      Xpos:=140;
      YPos:=30;
      for Row in 1..Task_Table.Num_Tasks loop
         Task_Table.Get_Task(Row,Name,WCET,T,D,Prio);
         Op:=new Operations.Enclosing_Operation;
         Operations.Init(Op.all,To_Lower(Name));
         Operations.Set_Worst_Case_Execution_Time
           (Operations.Enclosing_Operation(Op.all),
            Normalized_Execution_Time'Value(To_String(WCET)));
         Operations.Lists.Add(Op,Model.Operations);
         Mss.Append("ME_Operation Me_Enclosing_Operation "&To_Lower(Name)
                      &" Operation_Canvas"&Natural'Image(Xpos)&
                      Natural'Image(Ypos)&" ");
         Xpos:=Xpos+220;
      end loop;

      -- Create mutexes
      Xpos:=20;
      YPos:=40;
      for Row in 1..Mutex_Table.Num_Mutexes loop
         Mutex_Table.Get_Mutex(Row,Name,Prio);
         case Global_Options.Get_Policy is
            when Global_Options.FP =>
               -- Create mutex
               Mutex:=new Shared_Resources.Immediate_Ceiling_Resource;
               Shared_Resources.Init(Mutex.all,To_Lower(Name));
               Shared_Resources.Set_Ceiling
                 (Shared_Resources.Immediate_Ceiling_Resource(Mutex.all),
                 Priority'Value(To_String(Prio)));
               Mss.Append("ME_Shared_Resource Me_Immediate_Ceiling_Resource "&
                            To_Lower(Name)&
                            " Shared_Res_Canvas"&Natural'Image(Xpos)&
                            Natural'Image(Ypos)&" ");
            when Global_Options.EDF =>
               -- Create mutex
               Mutex:=new Shared_Resources.SRP_Resource;
               Shared_Resources.Init(Mutex.all,To_Lower(Name));
               Shared_Resources.Set_Level
                 (Shared_Resources.SRP_Resource(Mutex.all),
                 Preemption_Level'Value(To_String(Prio)));
               Mss.Append("ME_Shared_Resource Me_SRP_Resource "&
                            To_Lower(Name)&
                            " Shared_Res_Canvas"&Natural'Image(Xpos)&
                            Natural'Image(Ypos)&" ");
         end case;
         Shared_Resources.Lists.Add(Mutex,Model.Shared_Resources);
         Xpos:=Xpos+160;
         if Xpos>=Xlimit then
            Xpos:=20;
            Ypos:=YPos+50;
         end if;
      end loop;

      -- Create operations that are mutex usages
      Xpos:=20;
      YPos:=200;
      for Row in 1..Usage_Table.Num_Usages loop
         Usage_Table.Get_Usage(Row,Name,Taskname,Mutexname,WCET);
         Op:=new Operations.Simple_Operation;
         Operations.Init(Op.all,To_Lower(Name));
         Operations.Set_Worst_Case_Execution_Time
           (Operations.Simple_Operation(Op.all),
            Normalized_Execution_Time'Value(To_String(WCET)));
         --Find mutex
         Mutex:=Shared_Resources.Lists.Item
           (Shared_Resources.Lists.Find
              (To_Lower(Mutexname),Model.Shared_Resources),
            Model.Shared_Resources);
         Operations.Add_Resource
           (Operations.Simple_Operation(Op.all), Mutex);
         --Find task and add to task operation
         Enc:=Operations.Lists.Item
           (Operations.Lists.Find
              (To_Lower(Taskname),Model.Operations),Model.Operations);
         Operations.Add_Operation
           (Operations.Enclosing_Operation(Enc.all),Op);
         Operations.Lists.Add(Op,Model.Operations);
         Mss.Append("ME_Operation Me_Simple_Operation "&To_Lower(Name)&
                      " Operation_Canvas"&Natural'Image(Xpos)&
                      Natural'Image(Ypos)&" ");
         Xpos:=Xpos+160;
      end loop;

      -- Create end-to-end flows
      Xpos:=20;
      YPos:=50;
      for Row in 1..Task_Table.Num_Tasks loop
         Task_Table.Get_Task(Row,Name,WCET,T,D,Prio);

         -- Create end to end flow
         Trans := new Transactions.Regular_Transaction;
         Transactions.Init(Trans.all,To_Lower(Name));

         -- Create Workload event and associated link
         Ev := new Events.Periodic_Event;
         Events.Set_Period(Events.Periodic_Event(Ev.all),
                           Time'Value(To_String(T)));
         Events.Init(Ev.all,To_Lower(Name)&".input");
         Lnk:=new Graphs.Links.Regular_Link;
         Graphs.Set_Event(Lnk.all,Ev);
         Transactions.Add_External_Event_Link(Trans.all,Lnk);
         Mss.Append("ME_Transaction Me_Regular_Transaction "&To_Lower(Name)&
                      " Transaction_Canvas"&Natural'Image(Xpos)&
                      Natural'Image(Ypos)&" ");
         Mss.Append("ME_Link Me_External_Link "&To_Lower(Name)&
                      ".input,"&To_Lower(Name)&" "&To_Lower(Name)&" 20 160 ");
         Mss.Append("ME_Link Me_Internal_Link "&To_Lower(Name)&
                      ".output,"&To_Lower(Name)&" "&To_Lower(Name)&" 320 160 ");
         Mss.Append("ME_Event_Handler Me_Simple_Event_Handler 1,"&
                      To_Lower(Name)&" "&To_Lower(Name)&" 160 40 ");
         Xpos:=Xpos+160;
         if Xpos>=Xlimit then
            Xpos:=20;
            Ypos:=YPos+50;
         end if;

         -- Create Step
         Step:= new Graphs.Event_Handlers.System_Timed_Activity;
         Graphs.Event_Handlers.Set_Activity_Operation
           (Graphs.Event_Handlers.System_Timed_Activity(Step.all),
            Operations.Lists.Item
              (Operations.Lists.Find
                 (To_Lower(Name),Model.Operations),Model.Operations));
         Graphs.Event_Handlers.Set_Activity_Server
           (Graphs.Event_Handlers.System_Timed_Activity(Step.all),
            Scheduling_Servers.Lists.Item
              (Scheduling_Servers.Lists.Find
                 (To_Lower(Name),Model.Scheduling_Servers),
               Model.Scheduling_Servers));
         Graphs.Event_Handlers.Set_Input_Link
           (Graphs.Event_Handlers.System_Timed_Activity(Step.all),Lnk);
         Graphs.Set_Output_Event_Handler(Lnk.all,Step);
         Transactions.Add_Event_Handler(Trans.all,Step);

         -- Create output event
         Ev2 := new Events.Internal_Event;
         Events.Init(Ev2.all,To_Lower(Name)&".output");
         Lnk:=new Graphs.Links.Regular_Link;
         Graphs.Set_Event(Lnk.all,Ev2);
         Transactions.Add_Internal_Event_Link(Trans.all,Lnk);


         -- Create Timing Requirement
         Req:= new Timing_Requirements.Hard_Global_Deadline;
         Timing_Requirements.Set_The_Deadline
           (Timing_Requirements.Hard_Global_Deadline(Req.all),
            Time'Value(To_String(D)));
         Timing_Requirements.Set_Event
           (Timing_Requirements.Hard_Global_Deadline(Req.all),Ev);
         Graphs.Links.Set_Link_Timing_Requirements
           (Graphs.Links.Regular_Link(Lnk.all),Req);
         Graphs.Event_Handlers.Set_Output_Link
           (Graphs.Event_Handlers.System_Timed_Activity(Step.all),Lnk);
         Graphs.Set_Input_Event_Handler(Lnk.all,Step);

         -- Add transaction to system
         Transactions.Lists.Add(Trans,Model.Transactions);

      end loop;

      Changes_Control.Model_Generated;

   end Generate_Model;

   -----------------
   -- Clear_Model --
   -----------------

   procedure Clear_Model is
   begin
      Model:= null;
      Changes_Control.Model_Generated;
   end Clear_Model;

   ----------------
   -- Save_Model --
   ----------------

   procedure Save_Model is
      Name: String :=Global_Options.Get_System_Name;
      Output_File : File_Type;
   begin
      if Global_Options.Is_System_Name_Defined and then Task_Table.Num_Tasks>0
      then
         declare
            Model_Name : String:=Name(Name'First..Name'Last-4)&"_mast.txt";
         begin
            Generate_Model;
            Ada.Text_IO.Create(Output_File,Out_File,Model_Name);
            Systems.Print(Output_File,Model.all);
            Close(Output_File);
            Ada.Text_IO.Create(Output_File,Out_File,
                               Name(Name'First..Name'Last-4)&"_mast.mss");
            for I in Mss.First_Index..Mss.Last_Index loop
               Put_Line(Output_File,Mss.Element(I));
            end loop;
            Close(Output_File);
            Put_Line("MAST model was saved to: "&Model_Name);
         end;
      end if;
   end Save_Model;

   ---------------------
   -- Assign_Ceilings --
   ---------------------

   procedure Assign_Ceilings is
      Mutex  : Shared_Resources.Shared_Resource_Ref;
      Iterator : Shared_Resources.Lists.Index;
   begin
      if Task_Table.Num_Tasks>0 and then Mutex_Table.Num_Mutexes>0 then
         Generate_Model;

         Tools.Calculate_Ceilings_And_Levels(Model.all,False);

         Shared_Resources.Lists.Rewind(Model.Shared_Resources,Iterator);
         for I in 1..Shared_Resources.Lists.Size(Model.Shared_Resources) loop
            Shared_Resources.Lists.Get_Next_Item
              (Mutex,Model.Shared_Resources,Iterator);
            case Global_Options.Get_Policy is
               when Global_Options.FP =>
                  Mutex_Table.Set_Priority
                    (To_String(Shared_Resources.Name(Mutex)),
                     Natural(Shared_Resources.Ceiling
                               (Shared_Resources.Immediate_Ceiling_Resource
                                  (Mutex.all))));
               when Global_Options.EDF =>
                  Mutex_Table.Set_Priority
                    (To_String(Shared_Resources.Name(Mutex)),
                     Natural(Shared_Resources.Level
                               (Shared_Resources.SRP_Resource(Mutex.all))));
            end case;
         end loop;
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("No Tasks or Mutexes to make assignment");
      end if;
   exception
      when Tool_Exceptions.Tool_Failure =>
         Run_Dialog("Tool Failure exception: "&
                      Tool_Exceptions.Tool_Failure_Message);

      when Tool_Exceptions.Restriction_Not_Met =>
         Run_Dialog("Restriction Not Met: "&
                      Tool_Exceptions.Restriction_Message);
   end Assign_Ceilings;

   -----------------------
   -- Assign_Parameters --
   -----------------------

   procedure Assign_Parameters is
      Server : Scheduling_Servers.Scheduling_Server_Ref;
      Iterator : Scheduling_Servers.Lists.Index;
   begin
      if Task_Table.Num_Tasks>0 then
         Generate_Model;
         Tools.Monoprocessor_Assignment(Model.all,The_Tool,False);
         Changes_Control.Change_Was_Made;
         case Global_Options.Get_Policy is
            when Global_Options.FP =>
               Scheduling_Servers.Lists.Rewind
                 (Model.Scheduling_Servers,Iterator);
               for I in 1..Scheduling_Servers.Lists.Size
                 (Model.Scheduling_Servers)
               loop
                  Scheduling_Servers.Lists.Get_Next_Item
                    (Server,Model.Scheduling_Servers,Iterator);
                  Task_Table.Set_Priority
                    (To_String(Scheduling_Servers.Name(server)),
                     Natural(Scheduling_Servers.Base_Priority(Server.all)));
               end loop;
            when Global_Options.EDF =>
               Scheduling_Servers.Lists.Rewind
                 (Model.Scheduling_Servers,Iterator);
               for I in 1..Scheduling_Servers.Lists.Size
                 (Model.Scheduling_Servers)
               loop
                  Scheduling_Servers.Lists.Get_Next_Item
                    (Server,Model.Scheduling_Servers,Iterator);
                  Task_Table.Set_Priority
                    (To_String(Scheduling_Servers.Name(server)),
                     Natural(Scheduling_Servers.Base_Level(Server.all)));
               end loop;
         end case;
         if Mutex_Table.Num_Mutexes>0 then
            Assign_Ceilings;
         end if;
      else
         Run_Dialog("No Tasks to make assignment");
      end if;
   exception
      when Tool_Exceptions.Tool_Failure =>
         Run_Dialog("Tool Failure exception: "&
                      Tool_Exceptions.Tool_Failure_Message);

      when Tool_Exceptions.Restriction_Not_Met =>
         Run_Dialog("Restriction Not Met: "&
                      Tool_Exceptions.Restriction_Message);
   end Assign_Parameters;

   -----------------
   -- Do_Analysis --
   -----------------

   procedure Do_Analysis is
      Trans : Transactions.Transaction_Ref;
      Iterator : Transactions.Lists.Index;
      Proc_Iter : Processing_Resources.Lists.Index;
      Lnk_Iter : Transactions.Link_Iteration_Object;
      Lnk : Graphs.Link_Ref;
      Cpu : Processing_Resources.Processing_Resource_Ref;
      B,D,R : Time;
      Slack : Float;
      Res : Results.Timing_Result_Ref;
   begin
      if Task_Table.Num_Tasks>0 then
         -- do analysis
         Generate_Model;
         if not Restrictions.Non_Null_Periods(Model.all,False) then
            Tool_Exceptions.Set_Restriction_Message ("There are Null Periods");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;
         Mast.Tools.Calculate_Transaction_Slacks
           (Model.all,The_Tool,True);
         Mast.Tools.Calculate_System_Slack
           (Model.all,The_Tool,True);
         if not Restrictions.Feasible_Processing_Load
           (Model.all,False,True)
         then
            Tool_Exceptions.Set_Restriction_Message ("Utilization_Too_High");
         else
            The_Tool(Model.all,True);
         end if;

         Results_Table.Initialize;
         -- Set system slack result
         Results_Table.Set_System_Slack
           (Results.Slack(Systems.Slack_Result(Model.all).all ));

         -- Get processor
         Processing_Resources.Lists.Rewind
           (Model.Processing_Resources,Proc_Iter);
         Processing_Resources.Lists.Get_Next_Item
           (Cpu,Model.Processing_Resources,Proc_Iter);

         -- Set Utilization result
         Results_Table.Set_System_Utilization
           (Results.Total
              (Processing_Resources.Utilization_Result(CPU.all).all));

         -- Loop for all transactions
         Transactions.Lists.Rewind(Model.Transactions,Iterator);
         for I in 1..Transactions.Lists.Size(Model.Transactions)
         loop
            Transactions.Lists.Get_Next_Item
              (Trans,Model.Transactions,Iterator);
            -- Get results for thread
            Transactions.Rewind_Internal_Event_Links(Trans.all,Lnk_Iter);
            Transactions.Get_Next_Internal_Event_Link(Trans.all,Lnk,Lnk_Iter);
            Res:=Graphs.Links.Link_Time_Results
              (Graphs.Links.Regular_Link(Lnk.all));
            B:=Results.Worst_Blocking_Time(Res.all);
            D:=Timing_Requirements.The_Deadline
              (Timing_Requirements.Deadline
                 ( Graphs.Links.Link_Timing_Requirements
                     (Graphs.Links.Regular_Link(Lnk.all)).all));
            R:=Results.Worst_Global_Response_Time(Res.all);
            Slack:=Results.Slack(Transactions.Slack_Result(Trans.all).all);
            Results_Table.Add_New_Result
              (To_String(Transactions.Name(Trans)),B,D,R,Slack);
         end loop;
      else
         Run_Dialog("There are no tasks to analyze");
      end if;
   exception
      when Tool_Exceptions.Tool_Failure =>
         Run_Dialog("Tool Failure exception: "&
                      Tool_Exceptions.Tool_Failure_Message);

      when Tool_Exceptions.Restriction_Not_Met =>
         Run_Dialog("Restriction Not Met: "&
                      Tool_Exceptions.Restriction_Message);
   end Do_Analysis;

end Model_Operations;
