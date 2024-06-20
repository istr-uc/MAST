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

with Var_Strings; use Var_Strings;

package Usage_Table is

   Name_Col  : constant:=0;
   Taskname_Col  : constant:=1;
   Mutexname_Col  : constant:=2;
   WCET_Col  : constant:=3;
   Background_Col : constant:=4;

   procedure Initialize;

   procedure Add_New_Usage(Name,Taskname, Mutexname, WCET : String);

   procedure Get_Usage
     (Row : Positive; Name, Taskname, Mutexname, WCET : out Var_String);

   function Num_Usages return Natural;

   procedure Delete_Selected_Usage (Deleted : out Boolean);

   function Usage_Name_Is_Unique
     (Name : String; In_Row : Positive)
     return Boolean;

   function Task_Is_In_Use
     (Name : String)
     return Boolean;

   function Mutex_Is_In_Use
     (Name : String)
     return Boolean;

   function Usage_Name_Is_In_Use
     (Name : String)
     return Boolean;

   Incorrect_Row : exception;

   function Get_Last_Usage return Natural;

   procedure Increase_Last_Usage;

   procedure Set_Buttons;

end Usage_Table;

