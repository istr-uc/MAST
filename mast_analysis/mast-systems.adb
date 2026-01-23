-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2024                     --
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

with Mast.Processing_Resources.Network,
  Mast.Graphs,
  Mast.Graphs.Links,
  Mast.Timing_Requirements,
  Mast.Schedulers.Primary,
  Mast.Schedulers.Adjustment,
  Mast.XMI,
  Ada.Strings, 
  Ada.Strings.Fixed;
use Ada.Strings, Ada.Strings.Fixed;

package body Mast.Systems is

   -- use Mast;
   use type Results.Slack_Result_Ref;
   use type Results.Trace_Result_Ref;
   use type Processing_Resources.Processing_Resource_Ref;
   use type Timing_Requirements.Timing_Requirement_Ref;
   use type Ada.Text_IO.Count;
   
   -----------------------------------------
   -- Assign_Analysis_Tools_to_Processors --
   -----------------------------------------

   procedure Assign_Analysis_Tools_to_Processors
     (User_Analysis : Mast.General_Analysis_Tools;
      isLocal : Boolean := False;
      Sys : in out System;
      Verbose : Boolean := False) is
   begin
      Sys.The_Processor_Analysis_Tool.The_General_Analysis := User_Analysis;
      Sys.The_Processor_Analysis_Tool.isLocal := isLocal;
   end Assign_Analysis_Tools_to_Processors;

   ------------
   -- Adjust --
   ------------

   procedure Adjust(The_System : in out System) is
   begin
      -- shared resources need no adjustment

      -- rearrange all the internal pointers in operations
      Operations.Adjust(The_System.Operations,The_System.Shared_Resources);

      -- rearrange all the internal pointers in scheduling servers
      Scheduling_Servers.Adjust(The_System.Scheduling_Servers,
                                The_System.Schedulers);

      -- rearrange all the internal pointers in network drivers:
      Processing_Resources.Network.Adjust
        (The_System.Processing_Resources,The_System.Scheduling_Servers,
         The_System.Operations);

      -- rearrange all the internal pointers in schedulers:
      Schedulers.Adjustment.Adjust
        (The_System.Schedulers,The_System.Processing_Resources,
         The_System.Scheduling_Servers);

      -- rearrange all the internal pointers in transactions:
      --       timing requirements, links, event handlers
      Transactions.Adjust
        (The_System.Transactions,The_System.Scheduling_Servers,
         The_System.Operations);
end Adjust;

   -----------
   -- Clone --
   -----------

   function Clone(The_System : System) return System
   is
      The_Copy : System;
   begin
      -- Clone the basic objects.
      -- Internal pointers will continue pointing at the old system
      The_Copy:=
        (Model_Name           => The_System.Model_Name,
         Model_Date           => The_System.Model_Date,
         System_PIP_Behaviour  => The_System.System_PIP_Behaviour,
         Generation_Tool      => The_System.Generation_Tool,
         Generation_Profile   => The_System.Generation_Profile,
         Generation_Date      => The_System.Generation_Date,
         Processing_Resources =>
           Processing_Resources.Clone(The_System.Processing_Resources),
         Schedulers =>
           Schedulers.Clone(The_System.Schedulers),
         Shared_Resources     =>
           Shared_Resources.Clone(The_System.Shared_Resources),
         Operations           =>
           Operations.Clone(The_System.Operations),
         Transactions         =>
           Transactions.Clone(The_System.Transactions),
         Scheduling_Servers   =>
           Scheduling_Servers.Clone(The_System.Scheduling_Servers),
         The_Slack_Result     => null,
         The_Trace_Result     => null,
         The_Processor_Analysis_Tool => The_System.The_Processor_Analysis_Tool,
    Inconclusive_Analysis_Results => False);

      Adjust(The_Copy);

      return The_Copy;

   end Clone;

   -------------------------------------
   -- Has_Hard_Timing_Requirements    --
   -------------------------------------
   function Has_Hard_Timing_Requirements
     (Sys : System; Verbose : Boolean)
     return Boolean
   is
      A_Link_Ref : Mast.Graphs.Link_Ref;
      Iterator : Transactions.Link_Iteration_Object;
      Tim_Req_Ref : Mast.Timing_Requirements.Timing_Requirement_Ref;
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      It : Transactions.Lists.Iteration_Object;
   begin
      Mast.Transactions.Lists.Rewind(Sys.Transactions,It);
      for I in 1..Mast.Transactions.Lists.Size(Sys.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,Sys.Transactions,It);
         Mast.Transactions.Rewind_Internal_Event_Links
           (Trans_Ref.all,Iterator);
         for J in 1..Mast.Transactions.Num_Of_Internal_Event_Links
           (Trans_Ref.all)
         loop
            Mast.Transactions.Get_Next_Internal_Event_Link
              (Trans_Ref.all,A_Link_Ref,Iterator);
            Tim_Req_Ref:=Graphs.Links.Link_Timing_Requirements
              (Graphs.Links.Regular_Link(A_Link_Ref.all));
            if Tim_Req_Ref/=null and then
              Mast.Timing_Requirements.Has_Hard_Requirement
              (Tim_Req_Ref.all)
            then
               return True;
            end if;
         end loop;
      end loop;
      if Verbose then
         Ada.Text_IO.Put_Line("Transaction: "&
                    Var_Strings.To_String(Mast.Transactions.Name(Trans_Ref))&
                    "  has no hard timing requirements");
      end if;
      return false;
   end Has_Hard_Timing_Requirements;




   ---------------
   -- Is_In_Use --
   ---------------

   function Is_In_Use
     (Proc_Ref : Mast.Processing_Resources.Processing_Resource_Ref;
      Sys : System)
     return Boolean
   is
      Sch_Ref : Schedulers.Scheduler_Ref;
      Iterator : Schedulers.Lists.Index;
   begin
      -- check whether the processing resource is being used in a
      -- primary scheduler in the system
      Schedulers.Lists.Rewind(Sys.Schedulers,Iterator);
      for I in 1..Schedulers.Lists.Size(Sys.Schedulers) loop
         Schedulers.Lists.Get_Next_Item(Sch_Ref,Sys.Schedulers,Iterator);
         if Sch_Ref.all in Schedulers.Primary.Primary_Scheduler'Class and then
           Schedulers.Primary.Host
           (Schedulers.Primary.Primary_Scheduler'Class(Sch_Ref.all))=Proc_Ref
         then
            return True;
         end if;
      end loop;
      return False; -- not being used
   end Is_In_Use;

   -----------
   -- Print --
   -----------

   procedure Print
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is
      Name_Length : constant := 19;
      First_Arg : Boolean:=True;
   begin
      if The_System.Model_Name/=Null_Var_String or else
        The_System.Model_Date/="                   " or else
        The_System.System_PIP_Behaviour /=Strict
      then
         Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
         Ada.Text_IO.Put(File,"Model (");
         if The_System.Model_Name/=Null_Var_String then
            Mast.IO.Print_Arg
              (File,"Model_Name",
               IO.Name_Image(The_System.Model_Name),Indentation+3,Name_Length);
            First_Arg:=False;
         end if;
         if The_System.Model_Date/="                   " then
            if not First_Arg then
               Mast.IO.Print_Separator(File);
            end if;
            Mast.IO.Print_Arg
              (File,"Model_Date",Mast.IO.Date_Image(The_System.Model_Date),
               Indentation+3,Name_Length);
            First_Arg:=False;
         end if;
         if not First_Arg then
            Mast.IO.Print_Separator(File);
         end if;
         Mast.IO.Print_Arg
           (File,"System_Pip_Behaviour",
            PIP_Behaviour'Image(The_System.System_PIP_Behaviour),
            Indentation+3,Name_Length);
         Mast.IO.Print_Separator(File,",",True);
         Ada.Text_IO.New_Line(File);
      end if;
      Mast.Processing_Resources.Print
        (File,The_System.Processing_Resources,Indentation);
      Mast.Schedulers.Print
        (File,The_System.Schedulers, Indentation);
      Mast.Scheduling_Servers.Print
        (File,The_System.Scheduling_Servers,Indentation);
      Mast.Shared_Resources.Print
        (File,The_System.Shared_Resources,Indentation);
      Mast.Operations.Print
        (File,The_System.Operations,Indentation);
      Mast.Transactions.Print
        (File,The_System.Transactions,Indentation);
   end Print;

   -------------------
   -- Print_Results --
   -------------------

   procedure Print_Results
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is
      Names_Length : constant := 18;
   begin

      -- Print system-specific results

      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put(File,"Real_Time_Situation (");
      if The_System.Model_Name/=Null_Var_String then
         Mast.IO.Print_Arg
           (File,"Model_Name",
            IO.Name_Image(The_System.Model_Name),Indentation+3,Names_Length);
         Mast.IO.Print_Separator(File);
      end if;
      if The_System.Model_Date/="                   " then
         Mast.IO.Print_Arg
           (File,"Model_Date",
            IO.Date_Image(The_System.Model_Date),Indentation+3,Names_Length);
         Mast.IO.Print_Separator(File);
      end if;
      Mast.IO.Print_Arg
        (File,"Generation_Tool",
         """"&To_String(The_System.Generation_Tool)&"""",
         Indentation+3,Names_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Generation_Profile",
         """"&To_String(The_System.Generation_Profile)&"""",
         Indentation+3,Names_Length);
      Mast.IO.Print_Separator(File);
      Mast.IO.Print_Arg
        (File,"Generation_Date",
         Mast.IO.Date_Image(The_System.Generation_Date),
         Indentation+3,Names_Length);
      if The_System.The_Trace_Result/=null or else
        The_System.The_Slack_Result/=null
      then
         Mast.IO.Print_Separator(File);
         Mast.IO.Print_Arg
           (File,"Results","",Indentation+3,Names_Length);
         Mast.IO.Print_Separator(File,Mast.IO.Nothing);
         Mast.IO.Print_List_Item(File,Mast.IO.Left_Paren,
                                 Indentation+7);
         if The_System.The_Slack_Result/=null then
            Results.Print(File,The_System.The_Slack_Result.all,Indentation+8);
            if The_System.The_Trace_Result/=null then
               Mast.IO.Print_Separator(File);
            end if;
         end if;
         if The_System.The_Trace_Result/=null then
            Results.Print(File,The_System.The_Trace_Result.all,Indentation+8);
         end if;
         Ada.Text_IO.Put(File,")");
      end if;
      Mast.IO.Print_Separator(File,Mast.IO.Nothing,True);
      Ada.Text_IO.New_Line(File);

      -- Now print rest of results

      Mast.Transactions.Print_Results
        (File,The_System.Transactions,Indentation);

      Mast.Processing_Resources.Print_Results
        (File,The_System.Processing_Resources,Indentation);

      Mast.Operations.Print_Results
        (File,The_System.Operations,Indentation);

      Mast.Shared_Resources.Print_Results
        (File,The_System.Shared_Resources,Indentation);

      Mast.Scheduling_Servers.Print_Results
        (File,The_System.Scheduling_Servers,Indentation);

   end Print_Results;

   ---------------
   -- Print_XML --
   ---------------

   procedure Print_XML
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is

   begin
      Ada.Text_IO.Put_Line
        (File,"<?xml version="&"""1.0"" encoding=""UTF-8""?>");
      -- deleted May 2014
      -- Ada.Text_IO.Put_Line
      --   (File,"<?mast fileType=""XML-Mast-Model-File"" version=""1.1""?>");
      Ada.Text_IO.Put_Line(File,"<mast_mdl:MAST_MODEL ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
     (File,"xmlns:mast_mdl="&
        """http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Model"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
      (File,"xsi:schemaLocation="&
      """http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Model "&
      "http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Model.xsd"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      if The_System.Model_Name=Null_Var_String then
         Ada.Text_IO.Put_Line
           (File,"Model_Name=""Unknown"" " );
      else
         Ada.Text_IO.Put_Line
           (File,"Model_Name=""" &
            IO.Name_Image(The_System.Model_Name) &""" " );
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      if The_System.Model_Date="                   " then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Today& """>");
      elsif Mast.IO.Date_Image(The_System.Model_Date)'Length<11 then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" & Mast.IO.Date_Image(The_System.Model_Date) &
            "T00:00:00"">");
      else
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Date_Image(The_System.Model_Date) & """>");
      end if;
      Mast.Processing_Resources.Print_XML
        (File,The_System.Processing_Resources,Indentation+3);
      Ada.Text_IO.New_Line(File);
      Mast.Schedulers.Print_XML(File,The_System.Schedulers,Indentation+3);
      Mast.Shared_Resources.Print_XML
        (File,The_System.Shared_Resources,Indentation+3);
      Ada.Text_IO.New_Line(File);
      Mast.Operations.Print_XML
        (File,The_System.Operations,Indentation+3);
      Ada.Text_IO.New_Line(File);
      Mast.Scheduling_Servers.Print_XML
        (File,The_System.Scheduling_Servers,Indentation+3);
      Ada.Text_IO.New_Line(File);
      Mast.Transactions.Print_XML
        (File,The_System.Transactions,Indentation+3);
      Ada.Text_IO.New_Line(File);
      Ada.Text_IO.Put_Line(File,"</mast_mdl:MAST_MODEL> ");
   end Print_XML;

   -----------------------
   -- Print_XML_Results --
   -----------------------

   procedure Print_XML_Results
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is
      --   Names_Length : constant := 18;
   begin
      Ada.Text_IO.Put_Line
        (File,"<?xml version="&"""1.0"" encoding=""UTF-8""?>");
      -- Deleted May 2014
      -- Ada.Text_IO.Put_Line
      --   (File,"<?mast fileType=""XML-Mast-Result-File"" version=""1.1""?>");
      Ada.Text_IO.Put_Line(File,"<mast_res:REAL_TIME_SITUATION ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"xmlns:mast_res="&
      """http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Result"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"xsi:schemaLocation="&
      """http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Result "&
      "http://mast.unican.es/xmlmast/xmlmast_1_4/Mast_Result.xsd"" ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      if The_System.Model_Name=Null_Var_String then
         Ada.Text_IO.Put_Line
           (File,"Model_Name=""Unknown"" " );
      else
         Ada.Text_IO.Put_Line
           (File,"Model_Name=""" &
            IO.Name_Image(The_System.Model_Name) &""" " );
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      if The_System.Model_Date="                   " then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Today& """ ");
      elsif Mast.IO.Date_Image(The_System.Model_Date)'Length<11 then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" & Mast.IO.Date_Image(The_System.Model_Date) &
            "T00:00:00"" ");
      else
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Date_Image(The_System.Model_Date) & """ ");
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"Generation_Tool=""" &
         To_String(The_System.Generation_Tool) & """ ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"Generation_Profile=""" &
         To_String(The_System.Generation_Profile) & """ ");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line
        (File,"Generation_Date=""" &
         Mast.IO.Date_Image(The_System.Generation_Date) & """>");

      -- Now print rest of results

      if The_System.The_Slack_Result/=null then
         Results.Print_XML
           (File,The_System.The_Slack_Result.all,Indentation+8,False);
      end if;
      Mast.Transactions.Print_XML_Results
        (File,The_System.Transactions,Indentation+6);
      Mast.Processing_Resources.Print_XML_Results
        (File,The_System.Processing_Resources,Indentation+6);
      Mast.Operations.Print_XML_Results
        (File,The_System.Operations,Indentation+6);
      Mast.Shared_Resources.Print_XML_Results
        (File,The_System.Shared_Resources,Indentation+6);
      Mast.Scheduling_Servers.Print_XML_Results
        (File,The_System.Scheduling_Servers,Indentation+6);
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+3));
      Ada.Text_IO.Put_Line(File,"</mast_res:REAL_TIME_SITUATION>");
   end Print_XML_Results;
   
   ---------------
   -- Print_XMI --
   ---------------

   procedure Print_XMI
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is
      Indent: constant Ada.Text_IO.Count := Ada.Text_IO.Count(Indentation);
   begin
      Ada.Text_IO.Set_Col(File, Indent);
      Ada.Text_IO.Put_Line
   (File, "<?xml version=""1.0"" encoding=""UTF-8""?>");
      Ada.Text_IO.Set_Col(File, Indent);
      Ada.Text_IO.Put_Line
   (File, "<mast2:Mast_Model");
      Ada.Text_IO.Set_Col(File, Indent+4);
      Ada.Text_IO.Put_Line
   (File, "xmi:version=""2.0""");
      Ada.Text_IO.Set_Col(File, Indent+4);
      Ada.Text_IO.Put_Line
   (File, "xmlns:xmi=""http://www.omg.org/XMI""");
      Ada.Text_IO.Set_Col(File, Indent+4);
      Ada.Text_IO.Put_Line
   (File, "xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""");
      Ada.Text_IO.Set_Col(File, Indent+4);
      Ada.Text_IO.Put_Line
   (File, "xmlns:mast2=""http://mast.unican.es/ecoremast/Mast2""");
      Ada.Text_IO.Set_Col(File, Indent+4);
      Ada.Text_IO.Put_Line
   (File, "xsi:schemaLocation=""http://mast.unican.es"&
      "/ecoremast/Mast2 /mastresults/Mast2.ecore""");
      
      Ada.Text_IO.Set_Col(File, Indent+4);
      if The_System.Model_Name=Null_Var_String then
         Ada.Text_IO.Put_Line
           (File,"name=""Unknown""");
      else
         Ada.Text_IO.Put_Line
           (File,"name=""" &
            IO.Name_Image(The_System.Model_Name) &"""" );
      end if;
      Ada.Text_IO.Set_Col(File, Indent+4);
      if The_System.Model_Date="                   " then
         Ada.Text_IO.Put_Line
           (File,"Date=""" & Mast.IO.Today & """");
      elsif Mast.IO.Date_Image(The_System.Model_Date)'Length<11 then
         Ada.Text_IO.Put_Line
           (File,"Date=""" & Mast.IO.Date_Image(The_System.Model_Date) &
            "T00:00:00""");
      else
         Ada.Text_IO.Put_Line
           (File,"Date=""" &
            Mast.IO.Date_Image(The_System.Model_Date) & """");
      end if;
      Ada.Text_IO.Set_Col(File, Indent+4);
         Ada.Text_IO.Put_Line
           (File,"System_PiP_Behavior=""" &
         The_System.System_PIP_Behaviour'img & """>");
      
      Mast.Processing_Resources.Print_XMI
        (File,The_System.Processing_Resources,Indentation+2);
      Ada.Text_IO.New_Line(File);
      Mast.Schedulers.Print_XMI(File,The_System.Schedulers,Indentation+2);
      Mast.Shared_Resources.Print_XMI
        (File,The_System.Shared_Resources,Indentation+2);
      Ada.Text_IO.New_Line(File);
      Mast.Operations.Print_XMI
        (File,The_System.Operations,Indentation+2);
      Ada.Text_IO.New_Line(File);
      Mast.Scheduling_Servers.Print_XMI
        (File,The_System.Scheduling_Servers,Indentation+2);
      Ada.Text_IO.New_Line(File);
      Mast.Transactions.Print_XMI
        (File,The_System.Transactions,Indentation+2);
      Ada.Text_IO.New_Line(File);
      Ada.Text_IO.Put_Line(File,"</mast2:Mast_Model> ");
   end Print_XMI;
   
   
   --------------------
   -- Get_Model_File --
   --
   -- Finds the name of the XMI file, which is the last part of the string 
   -- following the "-d" option
   -- Needs to be enhanced to support pathnames with spaces
   --------------------
   function Get_Model_File(Profile : String) return Var_String is
      Desc_Index: Natural;
      Space_Index: Natural;
      Slash_Index: Natural;
      Second_Part: Var_String;
      Pathname: Var_String;
      Trimmed_Profile : constant String := Trim(Profile, Both);
   begin
      -- Obtain index to "-d" option
      Desc_Index := Index(Source => Trimmed_Profile, Pattern => " -d ", 
            Going => Forward);
      -- Obtain the text following the -d option
      if Desc_Index = 0 then
         -- no "-d", so we return "unknown"
         return To_Var_String("unknown.xmi");
      else
         Second_Part:= 
      To_Var_String
      (Trim(Trimmed_Profile(Desc_Index+4..Trimmed_Profile'Last), Both));
      end if;
      -- Obtain index to space
      Space_Index := Index(Source => To_String(Second_Part),
            Pattern => " ", 
            Going => Forward);
      if Space_Index = 0 then
         -- There is no space, so we return "unknown"
         return To_Var_String("unknown.xmi");
      else
         -- Obtain The Pathname
         Pathname := To_Var_String(To_String(Second_Part)(1..Space_Index-1));
      end if;
      -- Obtain index to slash or backslash
      Slash_Index := Index(Source => To_String(Pathname),
            Pattern => "/", 
            Going => Backward);
      if Slash_Index = 0 then
         Slash_Index := Index(Source => To_String(Pathname),
               Pattern => "\", 
               Going => Backward);
      end if;
      if Slash_Index = 0 then
         -- no slash, so we take the whole string
         return Pathname;
      else
         return To_Var_String(To_String(Pathname)
            (Slash_Index+1..To_String(Pathname)'Last));
      end if;
   end Get_Model_File;
   
   -----------------------
   -- Print_XMI_Results --
   -----------------------

   procedure Print_XMI_Results
     (File : Ada.Text_IO.File_Type;
      The_System : in out System;
      Indentation : Positive:=1)
   is
      Model_Name : Var_String;
      Model_File: Var_String;
   begin
      Model_File := Get_Model_File(To_String(The_System.Generation_Profile));
      Mast.XMI.Set_XMI_Model_File(Model_File);
      if The_System.Model_Name=Null_Var_String then
         Model_Name := To_Var_String("Unknown");
      else
         Model_Name := To_Var_String(IO.Name_Image(The_System.Model_Name)); 
      end if;
      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line
        (File,"<?xml version="&"""1.0"" encoding=""UTF-8""?>");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File,"<mast2_res:Real_Time_Situation_Results");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"xmi:version=""2.0""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"xmlns:xmi=""http://www.omg.org/XMI""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
   (File, "xmlns:mast2=""http://mast.unican.es/ecoremast/Mast2""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
   (File, "xmlns:mast2_res=""http://mast.unican.es/ecoremast/Mast2_Results""");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
   (File, "xsi:schemaLocation=""http://mast.unican.es/ecoremast/Mast2 /mastresults/Mast2.ecore http://mast.unican.es/ecoremast/Mast2_Results /mastresults/Mast2_Results.ecore""");
      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
   (File,"Model_File=""" & To_String(Model_File) &"""" );
      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      if The_System.Model_Date="                   " then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Today& """ ");
      elsif Mast.IO.Date_Image(The_System.Model_Date)'Length<11 then
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" & Mast.IO.Date_Image(The_System.Model_Date) &
            "T00:00:00""");
      else
         Ada.Text_IO.Put_Line
           (File,"Model_Date=""" &
            Mast.IO.Date_Image(The_System.Model_Date) & """");
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Generator_Tool=""" &
         To_String(The_System.Generation_Tool) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Generation_Profile=""" &
         To_String(The_System.Generation_Profile) & """");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"Generation_Date=""" &
         Mast.IO.Date_Image(The_System.Generation_Date) & """");
      if The_System.The_Slack_Result/=null then
         Results.Print_XMI
           (File,The_System.The_Slack_Result.all,Indentation+4,True);
      end if;
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+2));
      Ada.Text_IO.Put_Line
        (File,"<Mast_Model");
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation+4));
      Ada.Text_IO.Put_Line
        (File,"href=""" & To_String(Mast.XMI.Get_XMI_Model_File) & "#" & 
      To_String(Model_Name) & """/>");

      -- Now print actual results

      Mast.Transactions.Print_XMI_Results
        (File,The_System.Transactions,Indentation+2);
      Mast.Processing_Resources.Print_XMI_Results
        (File,The_System.Processing_Resources,Indentation+2);
      Mast.Operations.Print_XMI_Results
        (File,The_System.Operations,Indentation+2);
      Mast.Shared_Resources.Print_XMI_Results
        (File,The_System.Shared_Resources,Indentation+2);
      Mast.Scheduling_Servers.Print_XMI_Results
        (File,The_System.Scheduling_Servers,Indentation+2);
      
      Ada.Text_IO.Set_Col(File,Ada.Text_IO.Count(Indentation));
      Ada.Text_IO.Put_Line(File,"</mast2_res:Real_Time_Situation_Results>");
   end Print_XMI_Results;
   
   ----------------------
   -- Set_Slack_Result --
   ----------------------

   procedure Set_Slack_Result
     (Sys : in out System; Res : Results.Slack_Result_Ref)
   is
   begin
      Sys.The_Slack_Result:=Res;
   end Set_Slack_Result;

   ----------------------
   -- Slack_Result     --
   ----------------------

   function Slack_Result
     (Sys : System) return Results.Slack_Result_Ref
   is
   begin
      return Sys.The_Slack_Result;
   end Slack_Result;

   ----------------------
   -- Set_Trace_Result --
   ----------------------

   procedure Set_Trace_Result
     (Sys : in out System; Res : Results.Trace_Result_Ref)
   is
   begin
      Sys.The_Trace_Result:=Res;
   end Set_Trace_Result;

   ----------------------
   -- Trace_Result     --
   ----------------------

   function Trace_Result
     (Sys : System) return Results.Trace_Result_Ref
   is
   begin
      return Sys.The_Trace_Result;
   end Trace_Result;


end Mast.Systems;
