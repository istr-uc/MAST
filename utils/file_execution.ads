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

with Gnat.Strings;

package File_Execution is

   type String_Access is access all String;

   type String_List is array(Positive range <>) of Gnat.Strings.String_Access;

   ------------------
   -- Execute_File --
   ------------------
   -- This procedure executes the command found in the specified text
   -- file.
   -- The exit status of the command is returned in the Success
   -- parameter.
   -- If the file is not found or the program specified in the
   -- command is not found, Program_Not_Found will be raised

   procedure Execute_File
     (Filename : in String;
      Success  : out Boolean);


   ---------------------
   -- Execute_Command --
   ---------------------

   procedure Execute_Command
      (Command   : in String;
       Arguments : in String_List;
       Success   : out Boolean);
   -- This procedure executes the specified command with the specified
   -- arguments.
   -- The exit status of the command is returned in the Success
   -- parameter.
   -- If the file is not found or the program specified in the
   -- command is not found, Program_Not_Found will be raised

   ----------------
   -- Exceptions --
   ----------------

   Program_Not_Found : exception;

end File_Execution;
