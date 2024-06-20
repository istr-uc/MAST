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
with Mast;

package Global_Options is

      type Policy is (FP, EDF);

      procedure Initialize;

      function Get_Policy return Policy;

      procedure Set_Policy(P : Policy);

      function  Get_Context_Switch return Mast.Normalized_Execution_Time;

      procedure  Set_Context_Switch (Cs : Mast.Normalized_Execution_Time);

      function Get_Timer_Jitter return Mast.Time;

      procedure Set_Timer_Jitter (J : Mast.Time);

      function Get_System_Name return String;

      procedure Set_System_Name( Name : String);

      function Is_System_Name_Defined return Boolean;

      procedure Unset_System_Name;

end Global_Options;
