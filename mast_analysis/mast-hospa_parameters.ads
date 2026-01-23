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

with Ada.Text_IO; use Ada;

package Mast.HOSPA_Parameters is

   subtype K_Type is Float;
   subtype Iteration_Type is Natural;
   type K_Pair is private;

   --Valid initialization algorithms. It cannot be private
   --I needs it to be visible from HOSPA
   type Valid_Initial_Assignments is (PD,NPD,USER,UD,ED,EQS,EQF);

   -- Load and store HOSPA parameters
   -- Load is made from the specified file.
   -- If the specified file does not exist or the parameters file
   -- format is not correct, default parameters are loaded, and
   -- in the second case an exception is raised.
   -- Store is made to the specified file.

   procedure Load_Parameters
     (File_Name : String := "assignment_parameters.txt");
   -- may raise File_Does_Not_Exist or Invalid_Format

   procedure Store_Parameters
     (Parameters_File : in out Text_IO.File_Type);

   procedure Load_Default_Parameters;

   -- Management of Initialization

   function Get_Initialization return Valid_Initial_Assignments;
   procedure Set_Initialization (Initial_Assig : Valid_Initial_Assignments);

   -- Management of K pairs: (Ka,Kr)

   function Get_Ka (K : K_Pair) return K_Type;
   procedure Set_Ka (Ka : K_Type;
                     K : in out K_Pair);
   function Get_Kr (K : K_Pair) return K_Type;
   procedure Set_Kr (Kr : K_Type;
                     K : in out K_Pair);

   function Get_default_K_Pair return K_Pair;

   -- List of K pairs

   procedure Init_K_List;
   procedure Rewind_K_List;

   function Get_Next_K_Pair return K_Pair;
   procedure Set_Next_K_Pair (K : K_Pair);

   function Size_Of_K_List return Natural;

   -- List of iterations for each K pair

   procedure Init_Iterations_List;
   procedure Rewind_Iterations_List;

   function Get_Next_Iterations return Iteration_Type;
   procedure Set_Next_Iterations (Iter : Iteration_Type);

   function Size_Of_Iterations_List return Natural;

   -- Overiteration in optimization

   function Get_Overiterations return Iteration_Type;
   procedure Set_Overiterations (Iter : Iteration_Type);

   -- Maximum time to run the analysis tool

   function Get_Analysis_Stop_Time return Duration;
   procedure Set_Analysis_Stop_Time (Stop_Time : Duration);

   -- Maximum time to run the analysis tool when Audsley algorithm is applied
   -- A value of 0.0 means that the algorithm will not be applied

   function Get_Audsley_Stop_Time return Duration;
   procedure Set_Audsley_Stop_Time (Stop_Time : Duration);

   -- Stop_Factor_When_Not_Schedulable

   function Get_Stop_Factor_When_Not_Schedulable return Positive;
   procedure Set_Stop_Factor_When_Not_Schedulable (Stop_Factor : Positive);

   --HOSPA_will_Iterate

   function Get_HOSPA_will_Iterate return Boolean;
   procedure Set_HOSPA_will_Iterate (will_Iterate : Boolean);

   --Force Global Assignment (LC-EDF-GSD)
   function Get_Force_Global_Assignment return Boolean;
   procedure Set_Force_Global_Assignment (force_global : Boolean);

   --Virtual_Deadlines_Scaling_Factor (LC-EDF-DS)
   function Get_Virtual_Deadlines_Scaling_Factor return Integer;
   procedure Set_Virtual_Deadlines_Scaling_Factor (factor : Integer);

private

   type K_Pair is record
      Ka,Kr : K_Type;
   end record;

end Mast.HOSPA_Parameters;


