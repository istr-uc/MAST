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
--          Maria Cue              cuem@unican.es                    --
--          Juan Maria Rivas	   rivasjm@unican.es                 --
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

with MAST.Systems;
package Mast.Linear_Analysis_Tools is

   procedure Holistic_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Offset_Based_Unoptimized_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Offset_Based_Optimized_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Holistic_Local_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Holistic_Global_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Offset_Based_Local_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

   procedure Offset_Based_Global_EDF_Analysis
     (The_System : in out MAST.Systems.System;
      Verbose : in Boolean:=True;
      Stop_Factor_When_Not_Schedulable : in Positive:=Mast.Default_Stop_Factor);

end Mast.Linear_Analysis_Tools;
