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

with Ada.Text_IO, Ada.Command_Line, Ada.Exceptions, List_Exceptions,
  Ada.Characters.Handling, MAST_Parser, Mast.Systems, Mast.Consistency_Checks,
  Mast.Tools, Mast.Miscelaneous_Tools, Mast.IO, Mast.Timing_Requirements,
  Mast.HOSPA_Parameters, Mast.Annealing_Parameters, Mast.Restrictions,
  Mast.Operations, Mast.Processing_Resources, Mast.Tool_Exceptions,
  Mast_Parser_Error_Report, Var_Strings, Mast_Analysis_Help;
use  Mast, Ada.Text_IO, Ada.Command_Line, Ada.Exceptions, Var_Strings,
  Ada.Characters.Handling;
use type Mast.Tools.Worst_Case_Analysis_Tool;
use type Mast.Tools.Priority_Assignment_Tool;

-- GNAT dependent module. If compiling with another compiler you
-- can delete this with claus and its associated code (see below)
-- and make the XML to text conversion offline
with GNAT.OS_Lib; use type GNAT.OS_Lib.String_Access, GNAT.OS_Lib.String_List;

procedure Mast_Analysis is

   The_Tool                     : Tools.Worst_Case_Analysis_Tool;
   The_Priority_Assignment_Tool : Tools.Priority_Assignment_Tool;

   The_System                                : Mast.Systems.System;
   Input_File, Output_File, Description_File : File_Type;
   type Option is (
      Verbose,
      Calculate_Ceilings,
      Assign_Sched_Parameters,
      Assignment_Parameters,
      Dump_System_Description,
      Calculate_Slacks,
      Calculate_Operation_Slack,
      Check_Deadlocks);
   type Priority_Assignment_Technique is (
      Default,
      HOSPA,
      Annealing,
      Monoprocessor,
      Proportional_Distribution,
      Normalized_Distribution);
   User_Analysis                        : Mast.General_Analysis_Tools;
   isLocal                              : Boolean                       :=
     False;
   Flag                                 : array (Option) of Boolean     :=
     (Verbose                   => False,
      Calculate_Ceilings        => False,
      Assign_Sched_Parameters   => False,
      Assignment_Parameters     => False,
      Dump_System_Description   => False,
      Calculate_Slacks          => False,
      Calculate_Operation_Slack => False,
      Check_Deadlocks           => False);
   Technique                            : Priority_Assignment_Technique :=
     Default;
   Operation_Name                       : Var_String                    :=
     Null_Var_String;
   Op_Ref                               : Mast.Operations.Operation_Ref;
   The_Op_Index                         : Mast.Operations.Lists.Index;
   Parameters_Filename                  : Var_String                    :=
      To_Var_String ("assignment_parameters.txt");
   Description_Name                     : Var_String;
   Output_File_Specified                : Boolean                       :=
     False;
   Arg, Input_File_Arg, Output_File_Arg : Natural;
   Wrong_Format, Unrecognizable, Bad_Conversion, Program_Not_Found : exception;
   Schedulable, Success : Boolean := True;
   Stop_Factor : Positive := Mast.Default_Stop_Factor;

   procedure Close_Files is
   begin
      if Is_Open (Input_File) then
         Close (Input_File);
      end if;
      if Output_File_Specified then
         if Is_Open (Output_File) then
            Close (Output_File);
         end if;
      end if;
   end Close_Files;

begin
   if Argument_Count = 0 then
      raise Wrong_Format;
   elsif Argument_Count = 1 then
      if (Argument (1) = "-h" or else Argument (1) = "-help") then
         Mast_Analysis_Help;
      else
         raise Wrong_Format;
      end if;
   else
      if Argument (1) = "parse" then
         null;
      elsif Argument (1) = "default" then
         The_Tool := Tools.Default_RTA_Analysis'Access;
         User_Analysis := Offset_Based_Slanted;
      elsif Argument (1) = "classic_rm" then
         The_Tool := Tools.Classic_RM_Analysis'Access;
      elsif Argument (1) = "non_preemptive_rm" OR Argument (1) = "nprm" then --New Technique added by Baldu
         The_Tool := Tools.Non_Preemptive_RM_Analysis'Access;
      elsif Argument (1) = "varying_priorities" then
         The_Tool := Tools.Varying_Priorities_Analysis'Access;
      elsif Argument (1) = "edf_monoprocessor" then
         The_Tool := Tools.EDF_Monoprocessor_Analysis'Access;
      elsif Argument (1) = "edf_within_priorities" then
         The_Tool := Tools.EDF_Within_Priorities_Analysis'Access;
      elsif Argument (1) = "holistic" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Holistic;
      elsif Argument (1) = "offset_based" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Offset_Based_Slanted;
      elsif Argument (1) = "offset_based_approx_w_pr" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Offset_Based_Approx_W_Pr;
         --The_Tool := Tools.Offset_Based_Optimized_Analysis'Access;
      elsif Argument (1) = "offset_based_approx" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Offset_Based_Approx;
      elsif Argument (1) = "offset_based_slanted" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Offset_Based_Slanted;
      elsif Argument (1) = "offset_based_brute_force" then
         The_Tool      := Tools.Distributed_Mixed_Analysis'Access;
         User_Analysis := Offset_Based_Brute_Force;
      else
         raise Wrong_Format;
      end if;
      Arg := 2;

      while Arg < Argument_Count loop
         if Argument (Arg) = "-v" or else Argument (Arg) = "-verbose" then
            Flag (Verbose) := True;
         elsif Argument (Arg) = "-c"
           or else Argument (Arg) = "-ceilings"
         then
            Flag (Calculate_Ceilings) := True;
         elsif Argument (Arg) = "-local" or else Argument (Arg) = "-l" then
            isLocal := True;
         elsif Argument (Arg) = "-p"
           or else Argument (Arg) = "-sched_parameters"
         then
            Flag (Assign_Sched_Parameters) := True;
            Flag (Calculate_Ceilings)      := True;
         elsif Argument (Arg) = "-f" or else
           Argument (Arg) = "-stop_factor" then
            Arg := Arg + 1;
            Stop_Factor := Integer'Value(Argument(Arg));

         elsif Argument (Arg) = "-t"
           or else Argument (Arg) = "-technique"
         then
            Arg := Arg + 1;
            if Argument (Arg) = "hospa" then
               Technique                    := HOSPA;
               HOSPA_Parameters.Set_HOSPA_will_Iterate(True);
               The_Priority_Assignment_Tool := Tools.Linear_HOSPA'Access;
            elsif Argument (Arg) = "pd" then
               Technique                    := Proportional_Distribution;
               HOSPA_Parameters.Set_HOSPA_will_Iterate(False);
               HOSPA_Parameters.Set_Initialization(HOSPA_Parameters.PD);
               The_Priority_Assignment_Tool := Tools.Linear_HOSPA'Access;

            elsif Argument (Arg) = "npd" then
               Technique                    := Normalized_Distribution;
               HOSPA_Parameters.Set_HOSPA_will_Iterate(False);
               HOSPA_Parameters.Set_Initialization(HOSPA_Parameters.NPD);
               The_Priority_Assignment_Tool := Tools.Linear_HOSPA'Access;

            elsif Argument (Arg) = "annealing" then
               Technique                    := Annealing;
               The_Priority_Assignment_Tool :=
                 Tools.Linear_Simulated_Annealing_Assignment'Access;
            elsif Argument (Arg) = "monoprocessor" then
               Technique                    := Monoprocessor;
               The_Priority_Assignment_Tool :=
                 Tools.Monoprocessor_Assignment'Access;
            else
               raise Wrong_Format;
            end if;
         elsif Argument (Arg) = "-a"
           or else Argument (Arg) = "-assignment_parameters"
         then
            Flag (Assignment_Parameters) := True;
            Flag(Calculate_Ceilings)     :=True;
            Arg                          := Arg + 1;
            Parameters_Filename          := To_Var_String (Argument (Arg));

         elsif Argument (Arg) = "-o"
           or else Argument (Arg) = "-ordering"
         then
            Flag (Check_Deadlocks) := True;
         elsif Argument (Arg) = "-d"
           or else Argument (Arg) = "-description"
         then
            Flag (Dump_System_Description) := True;
            Arg                            := Arg + 1;
            Description_Name               := To_Var_String (Argument (Arg));
         elsif Argument (Arg) = "-s" or else Argument (Arg) = "-slack" then
            Flag (Calculate_Slacks) := True;
         elsif Argument (Arg) = "-os"
           or else Argument (Arg) = "-operation_slack"
         then
            Flag (Calculate_Operation_Slack) := True;
            Arg                              := Arg + 1;
            Operation_Name                   :=
               To_Var_String (Argument (Arg));
         else
            if Arg = Argument_Count - 1 then
               Output_File_Specified := True;
            else
               raise Wrong_Format;
            end if;
         end if;
         Arg := Arg + 1;
      end loop;
      begin
         if Output_File_Specified then
            Input_File_Arg  := Argument_Count - 1;
            Output_File_Arg := Argument_Count;
            Ada.Text_IO.Create
              (Output_File,
               Out_File,
               Argument (Argument_Count));
         else
            Input_File_Arg := Argument_Count;
         end if;

         -- Read input file
         declare
            Input_Filename : String := Argument (Input_File_Arg);
         begin
            if Input_Filename'Length > 3
              and then To_Lower
                          (Input_Filename (
                  Input_Filename'Length - 3 .. Input_Filename'Length)) =
                       ".xml"
            then
               -- The following code is dependent on the GNAT compiler.
               -- If compiling with some other compiler you can comment it out,
               -- and make the conversion from XML to text format offline.
               declare
                  In_filename, In_Text_Filename, Program_Name :
                    GNAT.OS_Lib.String_Access;
               begin
                  In_filename      := new String'(Input_Filename);
                  In_Text_Filename :=
                    new String'(Input_Filename (
                     1 .. Input_Filename'Length - 3) &
                                "txt");
                  Put_Line ("Converting XML file");
                  Program_Name :=
                     GNAT.OS_Lib.Locate_Exec_On_Path ("mast_xml_convert");
                  if Program_Name = null then
                     raise Program_Not_Found;
                  end if;
                  GNAT.OS_Lib.Spawn
                    (Program_Name.all,
                     In_filename & In_Text_Filename,
                     Success);
                  if not Success then
                     raise Bad_Conversion;
                  end if;
                  Input_Filename := In_Text_Filename.all;
               end;
            end if;
            Ada.Text_IO.Open (Input_File, In_File, Input_Filename);
            Ada.Text_IO.Set_Input (Input_File);
            Put_Line ("MAST Version: " & Version_String);
            Put_Line ("Parsing input file: "&Input_Filename);
            begin
               MAST_Parser (The_System);
               Mast.Systems.Assign_Analysis_Tools_to_Processors
                 (User_Analysis => User_Analysis,
                  isLocal       => isLocal,
                  Sys           => The_System,
                  Verbose       => Flag (Verbose));
            exception
               when Constraint_Error =>
                  raise Unrecognizable;
            end;
         end;

         The_System.Generation_Tool    :=
            To_Var_String
              ("MAST Schedulability Analysis, version " & Version_String);
         The_System.Generation_Profile := To_Var_String (Command_Name);
         for A in 1 .. Argument_Count loop
            The_System.Generation_Profile := The_System.Generation_Profile &
                                             " " &
                                             Argument (A);
         end loop;

         Ada.Text_IO.Set_Input (Standard_Input);
         if Consistency_Checks.Consistent_Transaction_Graphs
              (The_System)
         then
            if Flag (Verbose) then
               Put_Line ("Consistent_Transaction_Graphs met");
            end if;
         else
            Tool_Exceptions.Set_Restriction_Message
              ("Consistent_Transaction_Graphs no met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;

         if Consistency_Checks.Consistent_Shared_Resource_Usage
              (The_System)
         then
            if Flag (Verbose) then
               Put_Line ("Consistent_Shared_Resource_Usage met");
            end if;
         else
            Tool_Exceptions.Set_Restriction_Message
              ("Consistent_Shared_Resource_Usage not met");
            raise Tool_Exceptions.Restriction_Not_Met;
         end if;

         if Flag (Assign_Sched_Parameters) then
            if Technique = Default then
               if Restrictions.Monoprocessor_Only (The_System, False)
                 and then Restrictions.Simple_Transactions_Only
                             (The_System,
                              False)
               then
                  Technique                    := Monoprocessor;
                  The_Priority_Assignment_Tool :=
                    Tools.Monoprocessor_Assignment'Access;
               else
                  Technique                    := HOSPA;
                  The_Priority_Assignment_Tool := Tools.Linear_HOSPA'Access;
               end if;
            end if;
            begin
               case Technique is
                  when HOSPA =>
                     HOSPA_Parameters.Load_Parameters
                       (To_String (Parameters_Filename));
                     HOSPA_Parameters.
                       Set_Stop_Factor_When_Not_Schedulable(Stop_Factor);

                  when Annealing =>
                     Annealing_Parameters.Load_Parameters
                       (To_String (Parameters_Filename));

                  when Proportional_Distribution |
                       Normalized_Distribution | Default | Monoprocessor =>
                     HOSPA_Parameters.
                       Set_Stop_Factor_When_Not_Schedulable(Stop_Factor);
               end case;
            exception
               when Tool_Exceptions.Invalid_Format =>
                  Tool_Exceptions.Set_Tool_Failure_Message
                    ("Invalid Format in priority assignment parameters file");
                  raise Tool_Exceptions.Tool_Failure;
            end;
            if (Technique = HOSPA) or
               (Technique = Proportional_Distribution) or
               (Technique = Normalized_Distribution) or
               (Technique = Annealing) or
               (Technique = Monoprocessor)
            then
               if The_Tool /= null then
                  Put_Line ("Invoking the priority assignment tool...");
                  The_Priority_Assignment_Tool
                    (The_System,
                     The_Tool,
                     Flag (Verbose));
               end if;
            end if;
         end if;

         if Flag (Calculate_Ceilings) then
            Put_Line ("Calculating Ceilings");
            Tools.Calculate_Ceilings_And_Levels (The_System, Flag (Verbose));
         end if;

         if Flag (Dump_System_Description) then
            Create (Description_File, Out_File, To_String (Description_Name));
            if Length (Description_Name) > 3
              and then To_String
                          (To_Lower
                              (Slice
                                  (Description_Name,
                                   Length (Description_Name) - 3,
                                   Length (Description_Name)))) =
                       ".xml"
            then
               Mast.Systems.Print_XML (Description_File, The_System, 1);
            else
               Mast.Systems.Print (Description_File, The_System);
            end if;
            Close (Description_File);
         end if;

         if Flag (Check_Deadlocks) then
            Put_Line ("----------------------------------------------------");
            Put_Line ("Total ordering check for resources not yet available");
            Put_Line ("----------------------------------------------------");
         end if;

         if The_Tool /= null then
            if Flag (Calculate_Slacks) then
               begin
                  Put_Line ("Calculating Transaction Slacks...");
                  Mast.Tools.Calculate_Transaction_Slacks
                    (The_System,The_Tool,Flag(Verbose));

                  Put_Line ("Calculating Processing Resource Slacks...");
                  Mast.Tools.Calculate_Processing_Resource_Slacks
                    (The_System,
                     The_Tool,
                     Flag (Verbose));
		  
                  Put_Line ("Calculating System Slack...");
                  Mast.Tools.Calculate_System_Slack
                    (The_System,
                     The_Tool,
                     Flag (Verbose));
               exception
                  when Timing_Requirements.Inconclusive =>
                     Put_Line
                       ("Inconclusive results when calculating slacks");
               end;
            end if;

            if Flag (Calculate_Operation_Slack) then
               begin
                  Put_Line ("Calculating Operation Slack...");
                  The_Op_Index :=
                     Operations.Lists.Find
                       (Operation_Name,
                        The_System.Operations);
                  Op_Ref       :=
                     Operations.Lists.Item
                       (The_Op_Index,
                        The_System.Operations);
                  Mast.Tools.Calculate_Operation_Slack
                    (Op_Ref,
                     The_System,
                     The_Tool,
                     Flag (Verbose));
               exception
                  when Timing_Requirements.Inconclusive =>
                     Put_Line
                       ("Inconclusive results when calculating slacks");
                  when List_Exceptions.Invalid_Index =>
                     Put_Line
                       ("Error: Operation " & Operation_Name & " not found");
               end;
            end if;

            Put_Line ("Final invocation of the analysis tool...");
            if not Mast.Restrictions.Feasible_Processing_Load
                     (The_System,
                      Flag (Verbose),
                      True)
            then
               -- No need to invoke the tool with this utilization level
	       -- The_Tool
               --  (The_System,
               --   Flag (Verbose),
               --   Stop_Factor_When_Not_Schedulable => 1);
	       
               Tool_Exceptions.Set_Restriction_Message
                 ("Utilization_Too_High");
               Put_Line ("------------------------------------");
               Put_Line ("   WARNING: UTILIZATION OVER 100%");
               Put_Line ("------------------------------------");
            else
               if not Systems.Has_Hard_Timing_Requirements(The_System,False)
               then
                  Put_Line("Warning: System has no hard timing requirements");
               end if;
	       -- Final invocation of the the tool 
               The_Tool (The_System, Flag (Verbose), Stop_Factor);
            end if;

            if Flag (Verbose) then
               Put_line("System Overview :");
               Mast.Miscelaneous_Tools.Print_System_Overview(The_system,False);
            end if;

            if Output_File_Specified then
               Put_Line
                 ("Printing results in file: " & Argument (Output_File_Arg));
               declare
                  Output_Filename : String := Argument (Output_File_Arg);
               begin
                  if (Output_Filename'Length > 3
                     and then To_Lower
                                 (Output_Filename (
                        Output_Filename'Length - 3 .. Output_Filename'Length))
                              =
                              ".xml")
                  then
                     Mast.Systems.Print_XML_Results (Output_File, The_System);
                  else
                     Mast.Systems.Print_Results (Output_File, The_System);
                  end if;
               end;
            else
               Put_Line ("Results:");
               Mast.Systems.Print_Results (Current_Output, The_System);
            end if;

            Miscelaneous_Tools.Check_System_Schedulability
              (The_System,
               Schedulable,
               Flag (Verbose));
            if Schedulable then
               Ada.Text_IO.Put_Line ("The system is schedulable");
            else
               Ada.Text_IO.Put_Line ("Timing requirements not met");
            end if;

         end if;
         if Schedulable then
            Ada.Text_IO.Put_Line ("Final analysis status: DONE");
         else
            Ada.Text_IO.Put_Line ("Final analysis status: NOT-SCHEDULABLE");
         end if;
         Close_Files;
      end;
   end if;

exception

   when Wrong_Format =>
      Put_Line ("Usage:");
      Put_Line ("    mast_analysis -help");
      Put_Line
        ("    mast_analysis tool_name [options] input_file " &
         "[output_file]");
      Put_Line ("        tool_name:");
      Put_Line ("          default");
      Put_Line ("          offset_based");
      Put_Line ("          offset_based_slanted");
      Put_Line ("          offset_based_approx_w_pr");
      Put_Line ("          offset_based_approx");
      Put_Line ("          offset_based_brute_force");
      Put_Line ("          holistic");
      Put_Line ("          edf_within_priorities");
      Put_Line ("          edf_monoprocessor");
      Put_Line ("          varying_priorities");
      Put_Line ("          classic_rm");
      Put_Line ("          non_preemptive_rm (or nprm)");
      Put_Line ("          parse");
      New_Line;
      Put_Line ("        options:");
      Put_Line ("          -v, -verbose");
      Put_Line ("          -c, -ceilings");
      Put_Line ("          -l, -local");
      Put_Line ("          -f factor, -stop_factor factor");
      Put_Line ("          -p, -sched_parameters");
      Put_Line ("          -t name, -technique name");
      Put_Line ("               name can be: hospa, pd, npd, annealing, monoprocessor");
      Put_Line ("          -a filename, -assignment_parameters filename");
      Put_Line ("          -d filename, -description filename");
      Put_Line ("          -s, -slack");
      Put_Line ("          -os name, -operation_slack name");
      begin
         Close_Files;
      exception
         when Status_Error =>
            null;
      end;
      Set_Exit_Status (Failure);

   when Name_Error | Status_Error | Use_Error =>
      Put_Line ("Input file not found");
      Close_Files;
      Set_Exit_Status (Failure);

   when Unrecognizable | End_Error | Layout_Error =>
      Put_Line ("Input file has unrecognizable format");
      Close_Files;
      Set_Exit_Status (Failure);

   when Program_Not_Found =>
      Ada.Text_IO.Put_Line ("The program ""mast_xml_convert"" was not found");
      Ada.Text_IO.Put_Line
        ("Check that it is installed, and that its " &
         "directory is in the PATH");
      Close_Files;
      Set_Exit_Status (Failure);

   when Bad_Conversion =>
      Ada.Text_IO.Put_Line ("Conversion from XML to text format failed");
      Close_Files;
      Set_Exit_Status (Failure);

   when Tool_Exceptions.Tool_Failure =>
      Put_Line ("Tool Failure exception");
      Put_Line (Tool_Exceptions.Tool_Failure_Message);
      New_Line;
      Ada.Text_IO.Put_Line ("Final analysis status: ERROR (Tool Failure)");
      Close_Files;
      Set_Exit_Status (Failure);

   when Tool_Exceptions.Restriction_Not_Met =>
      Put_Line ("Restriction Not Met");
      Put_Line (Tool_Exceptions.Restriction_Message);
      New_Line;
      Ada.Text_IO.Put_Line
        ("Final analysis status: ERROR (Restriction not met)");

      Set_Exit_Status (Failure);

   when Mast_Parser_Error_Report.Syntax_Error =>
      Close_Files;
      Set_Exit_Status (Failure);

   when Other_Exception : others =>
      Put_Line ("------------------Mast Internal Error ----------------");
      Put_Line
        ("-- Unexpected exception : " & Exception_Name (Other_Exception));
      Put_Line
        ("-- Exception Message : " & Exception_Message (Other_Exception));
      Put_Line ("--");
      Put_Line ("-- Please send e-mail to mgh@unican.es");
      Put_Line ("-- including the following information:");
      Put_Line ("--      . Exception name obtained");
      Put_Line ("--      . Command line with the options that were used");
      Put_Line ("--      . The input file as an e-mail attachment");
      Put_Line ("--      . The MAST version used");
      Put_Line ("-- we will try to contact you as soon as possible");
      Put_Line ("-- The MAST team");
      Put_Line ("------------------------------------------------------");
      New_Line;
      Ada.Text_IO.Put_Line ("Final analysis status: ERROR");
      Close_Files;
      Set_Exit_Status (Failure);

end Mast_Analysis;
