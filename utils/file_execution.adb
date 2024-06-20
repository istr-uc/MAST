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

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

-- GNAT dependent module. If compiling with another compiler you
-- can delete this with clause and its associated code (see below)
-- and replace it with some other portable code
with GNAT.OS_Lib;

package body File_Execution is

   Max_Characters : constant:=512;
   Max_Arguments : constant:=20;

   ------------------
   -- Execute_File --
   ------------------

   procedure Execute_File
     (Filename : in String;
      Success  : out Boolean)
   is
      Program_Name : GNAT.OS_Lib.String_Access;
      File : File_Type;
      Line : String(1..Max_Characters);
      N : Natural;
      Blank : Character_Set:=To_Set(" ") or To_Set(HT);
      Args : String_List(1..Max_Arguments);
      Nargs : Natural:=0;
      First, Last, Current : Natural;
   begin
      -- Open and read input file
      Open(File,In_File,Filename);
      Get_Line(File,Line,N);
      Close(File);

      if N>0 then
         -- Process the line to get the program name and arguments
         Current:=1;
         loop
            Find_Token(Line(Current..N),Blank,Outside,First,Last);
            exit when Last=0 or Nargs=Max_Arguments;
            Nargs:=Nargs+1;
            Args(Nargs):=new String'(Line(First..Last));
            Current:=Last+1;
         end loop;

         if Nargs>=1 then
            -- Invoke the command
            declare
               Final_Args : Gnat.OS_Lib.Argument_List(1..Nargs-1);
            begin
               for I in 1..Nargs-1 loop
                  Final_Args(I):=Args(I+1);
               end loop;

               Program_Name :=
                 GNAT.OS_Lib.Locate_Exec_On_Path (Args(1).all);
               if Gnat.OS_Lib."="(Program_Name,null) then
                  raise Program_Not_Found;
               end if;
               Put_Line ("Invoking "&Program_Name.all);
               GNAT.OS_Lib.Spawn
                 (Program_Name.all,
                  Final_Args,
                  Success);
            end;
         else
            Success:=False;
         end if;
      else
         Success:=False;
      end if;
   exception
      when Name_Error =>
         raise Program_Not_Found;
   end Execute_File;

   ---------------------
   -- Execute_Command --
   ---------------------

   procedure Execute_Command
     (Command   : in String;
      Arguments : in String_List;
      Success   : out Boolean)
   is
      Program_Name : GNAT.OS_Lib.String_Access;
      Final_Args : Gnat.OS_Lib.Argument_List(1..Arguments'Length);
   begin
      for I in 1..Arguments'Length loop
         Final_Args(I):=Arguments(I);
      end loop;

      Program_Name :=
        GNAT.OS_Lib.Locate_Exec_On_Path (Command);
      if Gnat.OS_Lib."="(Program_Name,null) then
         raise Program_Not_Found;
      end if;
      Put_Line ("Invoking "&Program_Name.all);
      GNAT.OS_Lib.Spawn
        (Program_Name.all,
         Final_Args,
         Success);
   end Execute_Command;

end File_Execution;
