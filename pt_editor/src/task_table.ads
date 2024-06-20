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

with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Var_Strings; use Var_Strings;

package Task_Table is

   Name_Col  : constant:=0;
   C_Col     : constant:=1;
   T_Col     : constant:=2;
   D_Col     : constant:=3;
   Prio_Col  : constant:=4;
   Background_Col : constant:=5;

   procedure Initialize;

   procedure Add_New_Task (WCET, T, D, Prio : String);
   procedure Add_New_Task(Name, WCET, T, D, Prio : String);

   procedure Get_Task(Row : Positive; Name, WCET, T, D, Prio : out Var_String);

   function Num_Tasks return Natural;

   procedure Delete_Selected_Task(Deleted : out Boolean);

   function Task_Name_Is_In_Use
     (Name : String)
     return Boolean;

   function Task_Name_Is_Unique
     (Name : String; In_Row : Positive)
     return Boolean;

   procedure Fill_Task_Names (Combo : in out Gtk_Combo_Box_Text);

   function Selected_Task_Name return String;

   procedure Set_Priority(Name : String; Prio : Natural);

   Incorrect_Row : exception;

end Task_Table;
