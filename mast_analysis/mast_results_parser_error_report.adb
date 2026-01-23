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
--          Julio Luis Medina      medinajl@unican.es                --
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

with Ada; use Ada;
with  Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Directories;

package body Mast_Results_Parser_Error_Report is

   The_File : Text_IO.File_Type;

procedure Initialize_User_Error_Report is
begin
      Put_Line("Initializing error report...");
end Initialize_User_Error_Report;


procedure Terminate_User_Error_Report is
begin
      if Total_Errors > 0 then
         Text_IO.Put_Line("**************************************************");
         Text_IO.Put_Line("Error list output in file: mast_results_parser.lis");
         Text_IO.Put_Line("In: "&Ada.Directories.Current_Directory);
         Text_IO.Put_Line("**************************************************");
      end if;
end Terminate_User_Error_Report;


procedure Report_Continuable_Error 
    (Line_Number : Natural;
    Offset      : Natural;
    Finish      : Natural;
    Message     : String;
    Error       : Boolean)  is
      pragma Unreferenced (Error);
      Msg : constant String:="  Error at line"&Integer'Image(Line_Number)&
              " Col:"&Integer'Image(Offset)&"-"&Integer'Image(Finish)
              &": "&Message;
begin
      Text_IO.Put_Line(Msg);
      Put_Line("");
      Put_Line(Msg);
end Report_Continuable_Error;


   procedure Initialize_Output is
      begin
      Text_IO.Create(The_File, Text_IO.Out_File, "mast_results_parser.lis");
      Initialize_User_Error_Report;
      end Initialize_Output;

   procedure Finish_Output is
      begin
      Text_IO.Close(The_File);
      Terminate_User_Error_Report;
      end Finish_Output;

   procedure Put(S: String) is
   begin
      Text_IO.Put(The_File, S);
   end Put;

   procedure Put(C: Character) is
   begin
      Text_IO.Put(The_File, C);
   end Put;

   procedure Put_Line(S: String) is
   begin
      Text_IO.Put_Line(The_File, S);
   end Put_Line;


end Mast_Results_Parser_Error_Report;
