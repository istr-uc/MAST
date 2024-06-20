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

with Ada.Text_IO,Ada.Command_Line,Ada.Exceptions,
  Ada.Characters.Handling,
  MAST_Parser,MAST.Systems,
  MAST.Consistency_Checks,
  Mast.Tool_Exceptions,
  Mast_Parser_Error_Report,Var_Strings,
  To_Mast2_Help;
use Mast,Ada.Text_IO,Ada.Command_Line,Ada.Exceptions,Var_Strings,
  Ada.Characters.Handling;

-- GNAT dependent module. If compiling with another compiler you
-- can delete this with clause and its associated code (see below)
-- and make the XML to text conversion offline
with Gnat.OS_Lib;
use type Gnat.OS_Lib.String_Access, Gnat.OS_Lib.String_List;

procedure To_Mast2
is

   The_System : MAST.Systems.System;
   Input_File, Output_File : File_Type;
   Verbose_Flag : Boolean:= False;
   Output_File_Specified : Boolean:= False;
   Success : Boolean;
   Arg, Input_File_Arg, Output_File_Arg : Natural;
   Wrong_Format,Unrecognizable,Bad_Conversion, Program_Not_Found : exception;

   procedure Close_Files is
   begin
      if Is_Open(Input_File) then
         Close(Input_File);
      end if;
      if Output_File_Specified then
         if Is_Open(Output_File) then
            Close(Output_File);
         end if;
      end if;
   end Close_Files;


begin
   if Argument_Count=0 then
      raise Wrong_Format;
   elsif Argument_Count=1 then
      if (Argument(1)="-h" or else Argument(1)="-help")
      then
         To_Mast2_Help;
         return;
      end if;
   end if;
   Arg:=1;
   if Argument(Arg)="-v" or else Argument(Arg)="-verbose" then
      Verbose_Flag:=True;
      Arg:=Arg+1;
   end if;
   if Arg=Argument_Count-1 then
      Output_File_Specified:=True;
   elsif Arg>Argument_Count or Argument_Count-Arg>1 then
      raise Wrong_Format;
   end if;
   if Output_File_Specified then
      Input_File_Arg:=Argument_Count-1;
      Output_File_Arg:=Argument_Count;
      Ada.Text_IO.Create(Output_File,Out_File,Argument(Argument_Count));
   else
      Input_File_Arg:=Argument_Count;
   end if;

   -- Read input file
   declare
      Input_Filename : String:=Argument(Input_File_Arg);
   begin
      if Input_Filename'Length>3 and then
        To_lower(Input_Filename
                   (Input_Filename'Length-3..Input_Filename'Length))=".xml"
      then
         -- The following code is dependent on the GNAT compiler.
         -- If compiling with some other compiler you can comment it out,
         -- and make the conversion from XML to text format offline.
         declare
            In_filename, In_Text_Filename, Program_Name :
              Gnat.OS_Lib.String_Access;
         begin
            In_Filename:=new String'(Input_Filename);
            In_Text_Filename:=new String'
              (Input_Filename(1..Input_Filename'Length-3)&"txt");
            Put_Line("Converting XML file");
            Program_Name:=Gnat.Os_Lib.Locate_Exec_On_Path
              ("mast_xml_convert");
            if Program_Name=null then
               raise Program_Not_Found;
            end if;
            Gnat.OS_Lib.Spawn
              (Program_Name.all,In_Filename&In_Text_Filename, Success);
            if not Success then
               raise Bad_Conversion;
            end if;
            Input_Filename:=In_Text_Filename.all;
         end;
      end if;
      Ada.Text_IO.Open(Input_File,In_File,Input_Filename);
      Ada.Text_IO.Set_Input(Input_File);
      Put_Line("MAST Version: "&Version_String);
      Put_Line("Parsing input file");
      begin
         MAST_Parser(The_System);
      exception
         when Constraint_Error =>
            raise Unrecognizable;
      end;
   end;

   The_System.Generation_Tool:=
     To_Var_String("MAST Schedulability Analysis, version "&
                     Version_String);
   The_System.Generation_Profile:=To_Var_String(Command_Name);
   for A in 1..Argument_Count loop
      The_System.Generation_Profile:=The_System.Generation_Profile&
        " "&Argument(A);
   end loop;

   Ada.Text_IO.Set_Input(Standard_Input);
   if Consistency_Checks.Consistent_Transaction_Graphs(The_System)
   then
      if Verbose_Flag Then
         Put_Line("Consistent_Transaction_Graphs met");
      end if;
   else
      Tool_Exceptions.Set_Restriction_Message
        ("Consistent_Transaction_Graphs not met");
      raise Tool_Exceptions.Restriction_Not_Met;
   end if;

   if Consistency_Checks.Consistent_Shared_Resource_Usage(The_System)
   then
      if Verbose_Flag then
         Put_Line("Consistent_Shared_Resource_Usage met");
      end if;
   else
      Tool_Exceptions.Set_Restriction_Message
        ("Consistent_Shared_Resource_Usage no met");
      raise Tool_Exceptions.Restriction_Not_Met;
   end if;

   -- Write output file

   if Output_File_Specified then
      Put_Line("Printing results in file: "&
                 Argument(Output_File_Arg));
      declare
         Output_Filename : String:=Argument(Output_File_Arg);
      begin
         if (Output_Filename'Length>3 and then
               To_Lower(Output_Filename(Output_Filename'Length-3..
                                          Output_Filename'Length))=
               ".xml")
         then
            Mast.Systems.Print_XML(Output_File,The_System,1);
         else
            Mast.Systems.Print(Output_File,The_System);
         end if;
      end;
   else
      Put_Line("Results:");
      Mast.Systems.Print(Current_Output,The_System);
   end if;

   Close_Files;

exception

   when Wrong_Format =>
      Put_Line("Usage:");
      Put_Line("    to_mast2 -help");
      Put_Line("    to_mast2 [options] input_file [output_file]");
      New_Line;
      Put_Line("        options:");
      Put_Line("          -v, -verbose");
      begin
         Close_Files;
      exception
         when Status_Error =>
            null;
      end;
      Set_Exit_Status(Failure);

   when Name_Error |Status_Error | Use_Error=>
      Put_Line("Input file not found");
      Close_Files;
      Set_Exit_Status(Failure);

   when Unrecognizable | End_Error | Layout_Error =>
      Put_Line("Input file has unrecognizable format");
      Close_Files;
      Set_Exit_Status(Failure);

   when Program_Not_Found =>
      Ada.Text_IO.Put_Line("The program ""mast_xml_convert"" was not found");
      Ada.Text_IO.Put_Line("Check that it is installed, and that its "&
                             "directory is in the PATH");
      Close_Files;
      Set_Exit_Status(Failure);

   when Bad_Conversion =>
      Ada.Text_IO.Put_Line
        ("Conversion from XML to text format failed");
      Close_Files;
      Set_Exit_Status(Failure);

   when Tool_Exceptions.Restriction_Not_Met =>
      Put_Line("Restriction Not Met");
      Put_Line(Tool_Exceptions.Restriction_Message);
      New_Line;
      Ada.Text_IO.Put_Line
        ("Final analysis status: ERROR (Restriction not met)");

      Set_Exit_Status(Failure);

   when Mast_Parser_Error_Report.Syntax_Error =>
      Close_Files;
      Set_Exit_Status(Failure);

   when Other_Exception : others =>
      Put_Line ("------------------Mast Internal Error ----------------");
      Put_Line ("-- Unexpected exception : "&
                  Exception_Name(Other_Exception));
      Put_Line ("-- Exception Message : "&
                  Exception_Message(Other_Exception));
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
      Ada.Text_IO.Put_Line
        ("Final analysis status: ERROR");
      Close_Files;
      Set_Exit_Status(Failure);

end To_Mast2;
