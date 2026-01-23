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
--          Yago Pereiro                                             --
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

with Mast.IO, Mast.Graphs.Links, Mast.Graphs.Event_Handlers, 
  Mast.Timing_Requirements, Mast.Scheduling_Parameters, Mast.XMI, 
  List_Exceptions;
package body Mast.Transactions is

   use type Graphs.Link_Lists.Index;
   use type Graphs.Event_Handler_Lists.Index;
   use type Results.Slack_Result_Ref;
   use type Operations.Operation_Ref;
   use type Scheduling_Servers.Scheduling_Server_Ref;
   use type Timing_Requirements.Timing_Requirement_Ref;

   Names_Length : constant Positive := 15;
   
   -- Global variable needed to access the current transaction when printing
   -- it to an XMI file.
   Current_XMI_Transaction : Regular_Transaction;
   
   -----------------------------
   -- Add_Internal_Event_Link --
   -----------------------------

   procedure Add_Internal_Event_Link
     (Trans : in out Transaction;
      The_Link : Mast.Graphs.Link_Ref)
   is
   begin
      Graphs.Link_Lists.Add
        (The_Link,Trans.Graph.Internal_Links_List);
   end Add_Internal_Event_Link;

   -----------------------
   -- Add_Event_Handler --
   -----------------------

   procedure Add_Event_Handler
     (Trans : in out Transaction;
      The_Event_Handler : Mast.Graphs.Event_Handler_Ref)
   is
   begin
      Graphs.Event_Handler_Lists.Add
        (The_Event_Handler,Trans.Graph.Event_Handler_List);
   end Add_Event_Handler;

   ------------
   -- Adjust --
   ------------

   procedure Adjust
     (Trans : in out Transaction;
      Sched_Servers : Scheduling_Servers.Lists.List;
      Operats       : Operations.Lists.List)
   is
   begin
      Graphs.Links.Adjust_Timing_Requirements(Trans.Graph);
      Graphs.Event_Handlers.Adjust(Trans.Graph,Sched_Servers,Operats);
   exception
      when Object_Not_Found =>
         Set_Exception_Message
           ("Error in Transaction "&Var_Strings.To_String(Trans.Name)&": "&
            Get_Exception_Message);
         raise;
   end Adjust;

   ------------
   -- Adjust --
   ------------

   procedure Adjust
     (The_List : in out Lists.List;
      Sched_Servers : Scheduling_Servers.Lists.List;
      Operats       : Operations.Lists.List)
   is
      Iterator : Lists.Iteration_Object;
      Trans_Ref : Transaction_Ref;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Trans_Ref,The_List,Iterator);
         Adjust(Trans_Ref.all,Sched_Servers,Operats);
      end loop;
   end Adjust;

   -----------
   -- Clone --
   -----------

   function Clone
     (The_List : Lists.List)
     return Lists.List
   is
      The_Copy : Lists.List;
      Iterator : Lists.Iteration_Object;
      Trans_Ref, Trans_Ref_Copy : Transaction_Ref;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Trans_Ref,The_List,Iterator);
         Trans_Ref_Copy:=Clone(Trans_Ref.all);
         Lists.Add(Trans_Ref_Copy,The_Copy);
      end loop;
      return The_Copy;
   end Clone;


   -----------
   -- Clone --
   -----------

   overriding function Clone
     (Trans : Regular_Transaction)
     return Transaction_Ref
   is
      Trans_Ref : Transaction_Ref;
   begin
      Trans_Ref:=new Regular_Transaction;
      Trans_Ref.Name:=Trans.Name;
      Trans_Ref.Graph:=Graphs.Clone(Trans.Graph);
      return Trans_Ref;
   end Clone;

   ----------------------------
   -- Cumulative_Rate_Factor --
   ----------------------------

   function Cumulative_Rate_Factor
     (Trans : Transaction)
     return Positive
   is
      Factor : Positive:=1;
      Iterator : Event_Handler_Iteration_Object;
      The_Event_Handler : Graphs.Event_Handler_Ref;
   begin
      Graphs.Event_Handler_Lists.Rewind
        (Trans.Graph.Event_Handler_List,
         Graphs.Event_Handler_Lists.Index(Iterator));
      for I in 1..Graphs.Event_Handler_Lists.Size
        (Trans.Graph.Event_Handler_List)
      loop
         Graphs.Event_Handler_Lists.Get_Next_Item
           (The_Event_Handler,Trans.Graph.Event_Handler_List,
            Graphs.Event_Handler_Lists.Index(Iterator));
         if The_Event_Handler.all in Graphs.Event_Handlers.Rate_Divisor'Class
         then
            Factor:=Factor*Graphs.Event_Handlers.Rate_Divisor'Class
              (The_Event_Handler.all).Rate_Factor;
         end if;
      end loop;
      return Factor;
   end Cumulative_Rate_Factor;

   ----------------------
   -- Equivalent_Tasks --
   ----------------------
   -- June 2025
   
   -- Return the number of equivalent tasks needed in the transaction
   -- if it has a bursty event processed through a polling server.  If
   -- the transaction has no such bursty event + polling server, the
   -- function returns 1
   
   function Num_Of_Equivalent_Tasks 
     (Trans : Transaction)
     return Positive 
   is
      Iterator : Link_Iteration_Object;
      The_Link: Mast.Graphs.Link_Ref;
      An_Event_Ref : Mast.Events.Event_Ref;
      Has_Bursty : Boolean := False;
      Has_Polling : Boolean := False;
      Max_Interval : Time := 0.0;
      Min_Polling_Period : Time := Large_Time;
      The_Event_Handler : Mast.Graphs.Event_Handler_Ref;
      Eh_Iterator : Event_Handler_Iteration_Object;
      Sched_Params : Scheduling_Parameters.Sched_Parameters_Ref;
      Params : Scheduling_Parameters.Polling_Policy;
      
   begin
      -- Loop for all external events, to find the maximum bursty
      -- interval
      Rewind_External_Event_Links(Trans, Iterator);
      for I in 1..Num_Of_External_Event_Links(Trans) loop
         Get_Next_External_Event_Link(Trans, The_Link, Iterator);
         
         An_Event_Ref := Mast.Graphs.Event_Of (The_Link.all);
         if An_Event_Ref.all in Mast.Events.Bursty_Event'Class then
            Max_Interval  := 
              Time'Max(Max_Interval, 
                       Mast.Events.Bursty_Event'Class(An_Event_Ref.all).
                         Bound_Interval);
            Has_Bursty := True;
         end if;
      end loop;
      
      if not Has_Bursty then
         return 1;
      end if;
      
      -- Loop for all event handlers to find the minimum polling period
      Rewind_Event_Handlers(Trans,Eh_Iterator);
      for Hdlr in 1..Num_Of_Event_Handlers(Trans) loop
         Get_Next_Event_Handler(Trans, The_Event_Handler, Eh_Iterator);
         if The_Event_Handler.all in Graphs.Event_Handlers.Activity'Class then
            Sched_Params := Graphs.Event_Handlers.Activity'Class
              (The_Event_Handler.all).Activity_Server.Server_Sched_Parameters;
            if Sched_Params.all in 
              Scheduling_Parameters.Polling_Policy'Class 
            then
               Params:=Scheduling_Parameters.Polling_Policy
                 (Sched_Params.all);
               Min_Polling_Period := Time'Min(Min_Polling_Period, 
                                              Params.Polling_Period);
               Has_Polling := True;
            end if;
         end if;
      end loop;
      
      if Has_Polling then
         return Natural(Time'Ceiling(Max_Interval/Min_Polling_Period));
      else
         return 1;
      end if;
         
   end Num_Of_Equivalent_Tasks;
   
   
   ------------------------------
   -- Find_Internal_Event_Link --
   ------------------------------

   function Find_Internal_Event_Link
     (Name : Var_Strings.Var_String;
      Trans : Transaction)
     return Mast.Graphs.Link_Ref
   is
      I : Graphs.Link_Lists.Index;
   begin
      I:=Graphs.Link_Lists.Find
        (Name,Trans.Graph.Internal_Links_List);
      if I=Graphs.Link_Lists.Null_Index then
         raise Link_Not_Found;
      else
         return Graphs.Link_Lists.Item
           (I,Trans.Graph.Internal_Links_List);
      end if;
   end Find_Internal_Event_Link;

   ------------------------------
   -- Find_Any_Link --
   ------------------------------

   function Find_Any_Link
     (Name : Var_Strings.Var_String;
      Trans : Transaction)
     return Mast.Graphs.Link_Ref
   is
      I : Graphs.Link_Lists.Index;
   begin
      I:=Graphs.Link_Lists.Find
        (Name,Trans.Graph.External_Links_List);
      if I=Graphs.Link_Lists.Null_Index then
         I:=Graphs.Link_Lists.Find
           (Name,Trans.Graph.Internal_Links_List);
         if I=Graphs.Link_Lists.Null_Index then
            raise Link_Not_Found;
         else
            return Graphs.Link_Lists.Item
              (I,Trans.Graph.Internal_Links_List);
         end if;
      else
         return Graphs.Link_Lists.Item
           (I,Trans.Graph.External_Links_List);
      end if;
   end Find_Any_Link;

   ------------------------------
   -- Find_Any_Event --
   ------------------------------

   function Find_Any_Event
     (Name : Var_Strings.Var_String;
      Trans : Transaction)
     return Mast.Events.Event_Ref
   is
      I : Graphs.Link_Lists.Index;
   begin
      I:=Graphs.Link_Lists.Find
        (Name,Trans.Graph.External_Links_List);
      if I=Graphs.Link_Lists.Null_Index then
         I:=Graphs.Link_Lists.Find
           (Name,Trans.Graph.Internal_Links_List);
         if I=Graphs.Link_Lists.Null_Index then
            raise Event_Not_Found;
         else
            return Graphs.Event_Of(Graphs.Link_Lists.Item
                                   (I,Trans.Graph.Internal_Links_List).all);
         end if;
      else
         return Graphs.Event_Of(Graphs.Link_Lists.Item
                                (I,Trans.Graph.External_Links_List).all);
      end if;
   end Find_Any_Event;

   -------------------
   -- Find_Position --
   -------------------
   
   -- This function obtains the position of the internal or external
   --  event with the given name in the event flow element list. This
   --  is used for XMI internal references The event flow element list
   --  contains, in this order, the external events, the internal
   --  events, and the event handlers.
   -- It returns an invalid position 999999 if the event name is not found   
   
   function Find_Position(Event_Name: Var_String) return Natural is
      Trans : constant Regular_Transaction := 
        Get_Current_XMI_Transaction;
      --  Num_External: Natural :=
      --    Num_Of_External_Event_Links(Trans);
      --  Num_Internal: Natural :=
      --    Num_Of_Internal_Event_Links(Trans);
      Iterator : Link_Iteration_Object;
      The_Link: Mast.Graphs.Link_Ref;
      Position : Natural := 0;
   begin
      Rewind_External_Event_Links(Trans, Iterator);
      for I in 1..Num_Of_External_Event_Links(Trans) loop
         Get_Next_External_Event_Link
           (Trans, The_Link, Iterator);
         if Mast.Graphs.Name(The_Link) = Event_Name then
            return Position;
         end if;
         Position := Position + 1;
      end loop;
      Rewind_Internal_Event_Links(Trans, Iterator);
      for I in 1..Num_Of_Internal_Event_Links(Trans) loop
         Get_Next_Internal_Event_Link
      (Trans, The_Link, Iterator);
         if Mast.Graphs.Name(The_Link) = Event_Name then
            return Position;
         end if;
         Position := Position + 1;
      end loop;
      -- The search failed, so we return an invalid Position
      return 999999;
   end Find_Position;
   
   
   ----------------------------------
   -- Get_Next_Internal_Event_Link --
   ----------------------------------

   procedure Get_Next_Internal_Event_Link
     (Trans : Transaction;
      The_Link : out Mast.Graphs.Link_Ref;
      Iterator : in out Link_Iteration_Object)
   is
   begin
      Graphs.Link_Lists.Get_Next_Item
        (The_Link,Trans.Graph.Internal_Links_List,
         Graphs.Link_Lists.Index(Iterator));
   end Get_Next_Internal_Event_Link;

   ----------------------------
   -- Get_Next_Event_Handler --
   ----------------------------

   procedure Get_Next_Event_Handler
     (Trans : Transaction;
      The_Event_Handler : out Mast.Graphs.Event_Handler_Ref;
      Iterator : in out Event_Handler_Iteration_Object)
   is
   begin
      Graphs.Event_Handler_Lists.Get_Next_Item
        (The_Event_Handler,Trans.Graph.Event_Handler_List,
         Graphs.Event_Handler_Lists.Index(Iterator));
   end Get_Next_Event_Handler;

   ----------
   -- Init --
   ----------

   procedure Init
     (Trans : in out Transaction;
      Name : Var_Strings.Var_String)
   is
   begin
      Trans.Name:=Name;
   end Init;

   ----------
   -- Name --
   ----------

   function Name
     (Trans : Transaction)
     return Var_Strings.Var_String
   is
   begin
      return Trans.Name;
   end Name;

   ----------
   -- Name --
   ----------

   function Name
     (Trans_Ref : Transaction_Ref)
     return Var_Strings.Var_String
   is
   begin
      return Trans_Ref.Name;
   end Name;

   ---------------------------------
   -- Num_Of_Internal_Event_Links --
   ---------------------------------

   function Num_Of_Internal_Event_Links
     (Trans : Transaction)
     return Natural
   is
   begin
      return Graphs.Link_Lists.Size
        (Trans.Graph.Internal_Links_List);
   end Num_Of_Internal_Event_Links;

   ---------------------------
   -- Num_Of_Event_Handlers --
   ---------------------------

   function Num_Of_Event_Handlers
     (Trans : Transaction)
     return Natural
   is
   begin
      return Graphs.Event_Handler_Lists.Size
        (Trans.Graph.Event_Handler_List);
   end Num_Of_Event_Handlers;

   ----------------------------------
   -- Has_Hard_Timing_Requirements --
   ----------------------------------

   function Has_Hard_Timing_Requirements
     (Trans : Transaction;
      Verbose : Boolean)
     return Boolean
   is
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Mast.Timing_Requirements.Timing_Requirement_Ref;
   begin
      Mast.Transactions.Rewind_Internal_Event_Links
        (Trans,Iterator);
      for J in 1..Mast.Transactions.Num_Of_Internal_Event_Links
        (Trans)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Trans,A_Link_Ref,Iterator);
         Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
           (Graphs.Links.Regular_Link(A_Link_Ref.all));
         if Tim_Req_Ref/=null and then
           (Tim_Req_Ref.all in
              Mast.Timing_Requirements.Hard_Global_Deadline'Class or else
              Tim_Req_Ref.all in
              Mast.Timing_Requirements.Hard_Local_Deadline'Class or else
              Tim_Req_Ref.all in
              Mast.Timing_Requirements.Max_Output_Jitter_Req'Class)
         then
            return True;
         end if;
      end loop;
      if Verbose then
         Ada.Text_IO.Put_Line("Waring: Transaction "&
                    Var_Strings.To_String(Mast.Transactions.Name(Trans))&
                    " has no hard timing requirements");
      end if;
      return False;
   end Has_Hard_Timing_Requirements;



   --------------------------------
   -- Print                      --
   --------------------------------

   overriding procedure Print
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False) is
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"Transaction (");
      Mast.IO.Print_Arg
        (File,"Type","regular",Indentation+3,Names_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Name",
         IO.Name_Image(Res.Name),Indentation+3,Names_Length);
      if Mast.Graphs.Link_Lists.Size
        (Res.Graph.External_Links_List)>0
      then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"External_Events","",Indentation+3,Names_Length);
         Mast.Graphs.Print
           (File,Res.Graph.External_Links_List,Indentation+3);
      end if;
      if Mast.Graphs.Link_Lists.Size
        (Res.Graph.Internal_Links_List)>0
      then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Internal_Events","",Indentation+3,Names_Length);
         Mast.Graphs.Print
           (File,Res.Graph.Internal_Links_List,Indentation+3);
      end if;
      if Mast.Graphs.Event_Handler_Lists.Size
        (Res.Graph.Event_Handler_List)>0
      then
         Mast.IO.Print_Separator(File);
         Mast.Graphs.Print
           (File,Res.Graph.Event_Handler_List,Indentation+3);
      end if;
      Mast.IO.Print_Separator(File,Mast.IO.Nothing,Finalize);
   end Print;

   --------------------------------
   -- Print_Results              --
   --------------------------------

   procedure Print_Results
     (File : Ada.Text_IO.File_Type;
      Res : in out Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      Names_Length : constant := 8;
      Has_Timing_Results : Boolean;
      Has_Results : Boolean:=False;
      Iter: Link_Iteration_Object;
      The_Link : Mast.Graphs.Link_Ref;
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"Transaction (");
      Mast.IO.Print_Arg
        (File,"Name",
         IO.Name_Image(Res.Name),Indentation+3,Names_Length);
      Has_Timing_Results:=
        Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0;
      Mast.Transactions.Rewind_Internal_Event_Links(Res,Iter);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Res)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Res, The_Link, Iter);
         Has_Results:= Mast.Graphs.Has_Results(The_Link.all);
         exit when Has_Results;
      end loop;
      if (Has_Timing_Results and Has_Results) or else
        Res.The_Slack_Result/=null
      then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Results","",Indentation+3,Names_Length);
         Mast.IO.Print_Separator(File,Mast.IO.Nothing);
         Mast.IO.Print_List_Item(File,Mast.IO.Left_Paren,
                                 Indentation+7);
         if Res.The_Slack_Result/=null then
            Results.Print(File,Res.The_Slack_Result.all,Indentation+8);
            if Has_Timing_Results then
               Mast.IO.Print_Separator(File);
            end if;
         end if;
         if Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0 then
            Mast.Graphs.Print_Results
              (File,Res.Graph.Internal_Links_List,Indentation+8);
         end if;
         Ada.Text_IO.Put(File,")");
      end if;
      Mast.IO.Print_Separator(File,Mast.IO.Nothing,Finalize);
   end Print_Results;

   --------------------------------
   -- Print                      --
   --------------------------------

   procedure Print
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print;

   --------------------------------
   -- Print_Results              --
   --------------------------------

   procedure Print_Results
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print_Results(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print_Results;

   --------------------------------
   -- Print_XML                  --
   --------------------------------

   overriding procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"<mast_mdl:Regular_Transaction ");
      Ada.Text_IO.Put_Line(File,"Name=""" & IO.Name_Image(Res.Name) & """ >");
      if Mast.Graphs.Link_Lists.Size
        (Res.Graph.External_Links_List)>0
      then
         Mast.Graphs.Print_XML
           (File,Res.Graph.External_Links_List,Indentation+3);
      end if;
      if Mast.Graphs.Link_Lists.Size
        (Res.Graph.Internal_Links_List)>0
      then
         Mast.Graphs.Print_XML
           (File,Res.Graph.Internal_Links_List,Indentation+3);
      end if;
      if Mast.Graphs.Event_Handler_Lists.Size
        (Res.Graph.Event_Handler_List)>0
      then
         Mast.Graphs.Print_XML
           (File,Res.Graph.Event_Handler_List,Indentation+3);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"</mast_mdl:Regular_Transaction> ");
   end Print_XML;

   --------------------------------
   -- Print_XML                  --
   --------------------------------

   procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print_XML(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print_XML;

   --------------------------------
   -- Print_XML_results          --
   --------------------------------

   procedure Print_XML_Results
     (File : Ada.Text_IO.File_Type;
      Res : in out Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Names_Length : constant := 8;
      Has_Timing_Results : Boolean;
      Has_Results : Boolean:=False;
      Iter: Link_Iteration_Object;
      The_Link : Mast.Graphs.Link_Ref;
   begin
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"<mast_res:Transaction ");
      Ada.Text_IO.Put_Line(File,"Name=""" & IO.Name_Image(Res.Name) & """ >");
      Has_Timing_Results:=
        Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0;
      Mast.Transactions.Rewind_Internal_Event_Links(Res,Iter);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Res)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Res, The_Link, Iter);
         Has_Results:= Mast.Graphs.Has_Results(The_Link.all);
         exit when Has_Results;
      end loop;
      if (Has_Timing_Results and Has_Results) or else
        Res.The_Slack_Result/=null
      then
         if Res.The_Slack_Result/=null then
            Results.Print_XML
              (File,Res.The_Slack_Result.all,Indentation+3,False);
            --  if Has_Timing_Results then
            --     null;
            --  end if;
         end if;
         if Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0 then
            Mast.Graphs.Print_XML_Results
              (File,Res.Graph.Internal_Links_List,Indentation+3);
         end if;
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File,"</mast_res:Transaction> ");
      end if;
   end Print_XML_Results;

   --------------------------------
   -- Print_XML_Results          --
   --------------------------------

   procedure Print_XML_Results
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print_XML_Results(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print_XML_Results;

   --------------------------------
   -- Print_XMI                  --
   --------------------------------

   overriding procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
   begin
      Set_Current_XMI_Transaction(Res);
      Mast.XMI.Add_Element_List_Item;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File,"<Element_List");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line(File,"xsi:type=""mast2:Regular_End_To_End_Flow""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line(File,"name=""" & 
              XMI.XMI_Name_Image(Res.Name, "e2e_") & """>");
      if Mast.Graphs.Link_Lists.Size(Res.Graph.External_Links_List)>0
      then
         Mast.Graphs.Print_XMI
           (File,Res.Graph.External_Links_List,Indentation+2);
      end if;
      if Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0
      then
         Mast.Graphs.Print_XMI
           (File,Res.Graph.Internal_Links_List,Indentation+2);
      end if;
      if Mast.Graphs.Event_Handler_Lists.Size(Res.Graph.Event_Handler_List)>0
      then
         Mast.Graphs.Print_XMI
           (File,Res.Graph.Event_Handler_List,Indentation+2);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File,"</Element_List> ");
   end Print_XMI;

   --------------------------------
   -- Print_XMI                  --
   --------------------------------

   procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print_XMI(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print_XMI;

   --------------------------------
   -- Print_XMI_results          --
   --------------------------------

   overriding procedure Print_XMI_Results
     (File : Ada.Text_IO.File_Type;
      Res : in out Regular_Transaction;
      Indentation : Positive;
      Finalize    : Boolean:=False)
   is
      -- Names_Length : constant := 8;
      Has_Timing_Results : Boolean;
      Has_Results : Boolean:=False;
      Iter: Link_Iteration_Object;
      The_Link : Mast.Graphs.Link_Ref;
   begin
      Set_Current_XMI_Transaction(Res);
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"<Element_List");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put(File,"xsi:type=""mast2_res:End_To_End_Flow_Result""");
      if Res.The_Slack_Result/=null then
         Ada.Text_IO.New_Line(File);
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
         Results.Print_XMI
      (File,Res.The_Slack_Result.all,Indentation+4,True);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+2));
      Ada.Text_IO.Put_Line(File,"<Model_Elem");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line(File,"xsi:type=""mast2:Regular_End_To_End_Flow"""); 
      Ada.Text_IO.Set_Col(File, Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line(File,"href=""" & 
              IO.Name_Image(Mast.XMI.Get_XMI_Model_File) & "#" &
              XMI.XMI_Name_Image(Res.Name, "e2e_") & """/>");
      Has_Timing_Results:=
        Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0;
      Mast.Transactions.Rewind_Internal_Event_Links(Res,Iter);
      for I in 1..Mast.Transactions.Num_Of_Internal_Event_Links(Res)
      loop
         Mast.Transactions.Get_Next_Internal_Event_Link
           (Res, The_Link, Iter);
         Has_Results:= Mast.Graphs.Has_Results(The_Link.all);
         exit when Has_Results;
      end loop;
      if Has_Timing_Results and Has_Results then
         if Mast.Graphs.Link_Lists.Size(Res.Graph.Internal_Links_List)>0 then
            Mast.Graphs.Print_XMI_Results
              (File,Res.Graph.Internal_Links_List,Indentation+2);
         end if;
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put_Line(File,"</Element_List> ");
      end if;
   end Print_XMI_Results;

   --------------------------------
   -- Print_XMI_Results          --
   --------------------------------

   procedure Print_XMI_Results
     (File : Ada.Text_IO.File_Type;
      The_List : in out Lists.List;
      Indentation : Positive)
   is
      Res_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Res_Ref,The_List,Iterator);
         Print_XMI_Results(File,Res_Ref.all,Indentation,True);
         Ada.Text_IO.New_Line(File);
      end loop;
   end Print_XMI_Results;
   
   -------------------------
   -- Remove_Event_Handler--
   -------------------------

   procedure Remove_Event_Handler
     (Trans : in out Transaction;
      The_Event_Handler : Mast.Graphs.Event_Handler_Ref)
   is
      Ind : Graphs.Event_Handler_Lists.Index;
      Ev_Ref : Graphs.Event_Handler_Ref;
   begin
      -- Delete handler from list
      Ind:=Graphs.Event_Handler_Lists.Find
        (The_Event_Handler,Trans.Graph.Event_Handler_List);
      if Ind=Graphs.Event_Handler_Lists.Null_Index then
         raise List_Exceptions.Not_Found;
      end if;
      Graphs.Event_Handler_Lists.Delete
        (Ind,Ev_Ref,Trans.Graph.Event_Handler_List);

      -- Delete handler from links referencing it
      Mast.Graphs.Remove_Event_Handler_From_List
        (Trans.Graph.Internal_Links_List, The_Event_Handler);
      Mast.Graphs.Remove_Event_Handler_From_List
        (Trans.Graph.External_Links_List, The_Event_Handler);
   end Remove_Event_Handler;


   --------------------------------
   -- Remove_Internal_Event_Link --
   --------------------------------

   procedure Remove_Internal_Event_Link
     (Trans : in out Transaction;
      The_Link : Mast.Graphs.Link_Ref)
   is
      Ind : Graphs.Link_Lists.Index;
      Ln_Ref : Graphs.Link_Ref;
   begin
      -- Delete link from list
      Ind:=Graphs.Link_Lists.Find
        (Graphs.Name(The_Link),Trans.Graph.Internal_Links_List);
      if Ind=Graphs.Link_Lists.Null_Index then
         raise List_Exceptions.Not_Found;
      end if;
      Graphs.Link_Lists.Delete
        (Ind,Ln_Ref,Trans.Graph.Internal_Links_List);

      -- Delete link from handlers referencing it
      Graphs.Remove_Link_From_List(Trans.Graph.Event_Handler_List, The_Link);
   end Remove_Internal_Event_Link;

   --------------------------------
   -- Remove_External_Event_Link --
   --------------------------------

   procedure Remove_External_Event_Link
     (Trans : in out Transaction;
      The_Link : Mast.Graphs.Link_Ref)
   is
      Ind : Graphs.Link_Lists.Index;
      Ln_Ref : Graphs.Link_Ref;
   begin
      -- Delete link from list
      Ind:=Graphs.Link_Lists.Find
        (Graphs.Name(The_Link),Trans.Graph.External_Links_List);
      if Ind=Graphs.Link_Lists.Null_Index then
         raise List_Exceptions.Not_Found;
      end if;
      Graphs.Link_Lists.Delete
        (Ind,Ln_Ref,Trans.Graph.External_Links_List);

      -- Delete link from handlers referencing it
      Graphs.Remove_Link_From_List(Trans.Graph.Event_Handler_List,The_Link);
   end Remove_External_Event_Link;

   ---------------------------------
   -- Rewind_Internal_Event_Links --
   ---------------------------------

   procedure Rewind_Internal_Event_Links
     (Trans : Transaction;
      Iterator : out Link_Iteration_Object)
   is
   begin
      Graphs.Link_Lists.Rewind
        (Trans.Graph.Internal_Links_List,
         Graphs.Link_Lists.Index(Iterator));
   end Rewind_Internal_Event_Links;

   ---------------------------
   -- Rewind_Event_Handlers --
   ---------------------------

   procedure Rewind_Event_Handlers
     (Trans : Transaction;
      Iterator : out Event_Handler_Iteration_Object)
   is
   begin
      Graphs.Event_Handler_Lists.Rewind
        (Trans.Graph.Event_Handler_List,
         Graphs.Event_Handler_Lists.Index(Iterator));
   end Rewind_Event_Handlers;

   -----------
   -- Scale --
   -----------

   procedure Scale
     (Trans : Transaction; Factor : Normalized_Execution_Time)
   is
      Iterator : Graphs.Event_Handler_Lists.Iteration_Object;
      EH_REf : Graphs.Event_Handler_Ref;
   begin
      Graphs.Event_Handler_Lists.Rewind
        (Trans.Graph.Event_Handler_List,Iterator);
      for I in 1..Graphs.Event_Handler_Lists.Size
        (Trans.Graph.Event_Handler_List)
      loop
         Graphs.Event_Handler_Lists.Get_Next_Item
           (EH_REf,Trans.Graph.Event_Handler_List,Iterator);
         if EH_REf.all in Graphs.Event_Handlers.Activity'Class then
            Operations.Scale(Graphs.Event_Handlers.Activity_Operation
                             (Graphs.Event_Handlers.Activity'Class
                              (EH_REf.all)).all,Factor);
         end if;
      end loop;
   end Scale;

   -----------------------------
   -- Add_External_Event_Link --
   -----------------------------

   procedure Add_External_Event_Link
     (Trans : in out Transaction;
      The_Link : Mast.Graphs.Link_Ref)
   is
   begin
      Graphs.Link_Lists.Add
        (The_Link,Trans.Graph.External_Links_List);
   end Add_External_Event_Link;

   ------------------------------
   -- Find_External_Event_Link --
   ------------------------------

   function Find_External_Event_Link
     (Name : Var_Strings.Var_String;
      Trans : Transaction)
     return Mast.Graphs.Link_Ref
   is
      I : Graphs.Link_Lists.Index;
   begin
      I:=Graphs.Link_Lists.Find
        (Name,Trans.Graph.External_Links_List);
      if I=Graphs.Link_Lists.Null_Index then
         raise Link_Not_Found;
      else
         return Graphs.Link_Lists.Item
           (I,Trans.Graph.External_Links_List);
      end if;
   end Find_External_Event_Link;

   ----------------------------------
   -- Get_Next_External_Event_Link --
   ----------------------------------

   procedure Get_Next_External_Event_Link
     (Trans : Transaction;
      The_Link : out Mast.Graphs.Link_Ref;
      Iterator : in out Link_Iteration_Object)
   is
   begin
      Graphs.Link_Lists.Get_Next_Item
        (The_Link,Trans.Graph.External_Links_List,
         Graphs.Link_Lists.Index(Iterator));
   end Get_Next_External_Event_Link;

   ---------------------------------
   -- Num_Of_External_Event_Links --
   ---------------------------------

   function Num_Of_External_Event_Links
     (Trans : Transaction)
     return Natural
   is
   begin
      return Graphs.Link_Lists.Size
        (Trans.Graph.External_Links_List);
   end Num_Of_External_Event_Links;

   ----------------------
   -- Set_Slack_Result --
   ----------------------

   procedure Set_Slack_Result
     (Trans : in out Transaction; Res : Results.Slack_Result_Ref)
   is
   begin
      Trans.The_Slack_Result:=Res;
   end Set_Slack_Result;

   ----------------------
   -- Slack_Result     --
   ----------------------

   function Slack_Result
     (Trans : Transaction) return Results.Slack_Result_Ref
   is
   begin
      return Trans.The_Slack_Result;
   end Slack_Result;

   ---------------------------------
   -- Rewind_External_Event_Links --
   ---------------------------------

   procedure Rewind_External_Event_Links
     (Trans : Transaction;
      Iterator : out Link_Iteration_Object)
   is
   begin
      Graphs.Link_Lists.Rewind
        (Trans.Graph.External_Links_List,
         Graphs.Link_Lists.Index(Iterator));
   end Rewind_External_Event_Links;

   ----------------------------------------
   -- List_References_Scheduling_Server  --
   ----------------------------------------

   function List_References_Scheduling_Server
     (Ss_Ref : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      The_List : Graphs.Event_Handler_Lists.List)
     return Boolean
   is
      Eh_Ref : Graphs.Event_Handler_Ref;
      Iterator : Graphs.Event_Handler_Lists.Index;
   begin
      Graphs.Event_Handler_Lists.Rewind(The_List,Iterator);
      for I in 1..Graphs.Event_Handler_Lists.Size(The_List) loop
         Graphs.Event_Handler_Lists.Get_Next_Item(Eh_Ref,The_List,Iterator);
         if Eh_Ref.all in Graphs.Event_Handlers.Activity'Class and then
           Graphs.Event_Handlers.Activity_Server
           (Graphs.Event_Handlers.Activity'class(Eh_Ref.all))=Ss_Ref
         then
            return True;
         end if;
      end loop;
      return False;
   end List_References_Scheduling_Server;


   ---------------------------------------
   -- List_References_Scheduling_Server --
   ---------------------------------------

   function List_References_Scheduling_Server
     (Ss_Ref : Mast.Scheduling_Servers.Scheduling_Server_Ref;
      The_List : Lists.List)
     return Boolean
   is
      Trans_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Trans_Ref,The_List,Iterator);
         if List_References_Scheduling_Server
           (Ss_Ref,Trans_Ref.Graph.Event_Handler_List)
         then
            return True;
         end if;
      end loop;
      return False;
   end List_References_Scheduling_Server;

   ----------------------------------------
   -- List_References_Operation          --
   ----------------------------------------

   function List_References_Operation
     (Op_Ref : Mast.Operations.Operation_Ref;
      The_List : Graphs.Event_Handler_Lists.List)
     return Boolean
   is
      Eh_Ref : Graphs.Event_Handler_Ref;
      Iterator : Graphs.Event_Handler_Lists.Index;
   begin
      Graphs.Event_Handler_Lists.Rewind(The_List,Iterator);
      for I in 1..Graphs.Event_Handler_Lists.Size(The_List) loop
         Graphs.Event_Handler_Lists.Get_Next_Item(Eh_Ref,The_List,Iterator);
         if Eh_Ref.all in Graphs.Event_Handlers.Activity'Class and then
           Graphs.Event_Handlers.Activity_Operation
           (Graphs.Event_Handlers.Activity'Class(Eh_Ref.all))=Op_Ref
         then
            return True;
         end if;
      end loop;
      return False;
   end List_References_Operation;

   ---------------------------------------
   -- List_References_Operation         --
   ---------------------------------------

   function List_References_Operation
     (Op_Ref : Mast.Operations.Operation_Ref;
      The_List : Lists.List)
     return Boolean
   is
      Trans_Ref : Transaction_Ref;
      Iterator : Lists.Index;
   begin
      Lists.Rewind(The_List,Iterator);
      for I in 1..Lists.Size(The_List) loop
         Lists.Get_Next_Item(Trans_Ref,The_List,Iterator);
         if List_References_Operation
           (Op_Ref,Trans_Ref.Graph.Event_Handler_List)
         then
            return True;
         end if;
      end loop;
      return False;
   end List_References_Operation;

   ------------------------------
   -- References_Event         --
   ------------------------------

   function References_Event
     (Evnt : Mast.Events.Event_Ref;
      Trans : Transaction)
     return Boolean
   is
   begin
      return Mast.Graphs.References_Event
        (Evnt,Trans.Graph.Internal_Links_List);
   end References_Event;
   
   ---------------------------------
   -- Set_Current_XMI_Transaction --
   ---------------------------------
   -- Sets the current transaction being printed in an XMI file
   -- This is needed to establish internal references to the events
   -- of the transaction
   procedure Set_Current_XMI_Transaction
     (Trans : in out Regular_Transaction)
   is
   begin
      Current_XMI_Transaction := Trans;
   end Set_Current_XMI_Transaction;
   
   ---------------------------------
   -- Get_Current_XMI_Transaction --
   ---------------------------------
   -- Gets the current transaction being printed in an XMI file
   -- This is needed to establish internal references to the events
   -- of the transaction
   function Get_Current_XMI_Transaction
     return Regular_Transaction
   is
   begin
      return Current_XMI_Transaction;
   end Get_Current_XMI_Transaction;
   

end Mast.Transactions;
