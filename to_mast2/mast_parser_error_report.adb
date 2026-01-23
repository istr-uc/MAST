-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2000-2014                     --
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


with Text_IO;
With  text_io;
Use  text_io;

package body Mast_Parser_Error_Report is

    The_File : Text_io.File_Type;

procedure Initialize_User_Error_Report is
begin
     put_line("Initializing error report...");
end;


procedure Terminate_User_Error_Report is
begin
    if Total_Errors > 0 then
       Text_IO.Put_Line("******************************************");
       Text_IO.Put_Line("Error list output in file: mast_parser.lis");
       Text_IO.Put_Line("******************************************");
    end if;
end;


procedure Report_Continuable_Error 
    (Line_Number : in Natural;
    Offset      : in Natural;
    Finish      : in Natural;
    Message     : in String;
    Error       : in Boolean)  is
    Msg : String:="  Error at line"&Integer'Image(line_number)&
              " Col:"&Integer'Image(Offset)&"-"&Integer'Image(Finish)
              &": "&message;
begin
     Text_IO.put_line(Msg);
     Put_Line("");
     Put_Line(Msg);
end;


    procedure Initialize_Output is
      begin
        Text_io.Create(The_File, Text_io.Out_File, "mast_parser.lis");
        initialize_user_error_report;
      end Initialize_Output;

    procedure Finish_Output is
      begin
        Text_io.Close(The_File);
        terminate_user_error_report;
      end Finish_Output;

    procedure Put(S: in String) is
    begin
      Text_io.put(The_File, S);
    end Put;

    procedure Put(C: in Character) is
    begin
      Text_io.put(The_File, C);
    end Put;

    procedure Put_Line(S: in String) is
    begin
      Text_io.put_Line(The_File, S);
    end Put_Line;


end Mast_Parser_Error_Report;
