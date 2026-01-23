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
with Ada.Text_IO;
use Ada.Text_IO;
procedure To_Mast2_Help is

begin

   Put_Line("-----------------------------------------------------------------------");
   Put_Line("--                              To_Mast2                             --");
   Put_Line("--     Modelling and Analysis Suite for Real-Time Applications       --");
   Put_Line("--     Transaltion tool from MAST-1 format to MAST-2 format          --");
   Put_Line("-----------------------------------------------------------------------");
   New_Line;
   Put_Line("   command format:");
   Put_Line("   ---------------");
   New_Line;
   Put_Line("      to_mast2 -h");
   Put_Line("      to_mast2 -help");
   Put_Line("            does not make the translation, just prints help information");
   New_Line;
   Put_Line("      to_mast2 [options] input_file [output_file]");
   Put_Line("            converts the input file to MAST2 format ");
   New_Line;
   Put_Line("   tool description:");
   Put_Line("   -----------------");
   Put_Line("     ");
   Put_Line("      The tool parses the input file. If it finds errors it reports");
   Put_Line("      them and stops. The list of errors can be found in the file");
   Put_Line("      'mast_parser.lis'. If there are no errors, the real-time system");
   Put_Line("      description is written to the output file, if specified, or else");
   Put_Line("      to the standard output.");
   New_Line;
   Put_Line("      input_file : it has to be defined ussing the Mast-1 file format");
   Put_Line("      ----------   (see the Mast-1 file format definition)");
   New_Line;
   Put_Line("      output_file: it will contain the results of the analysis");
   Put_Line("      -----------  if not specified, then the output goes to the standard");
   Put_Line("                   output");
   Put_Line("  ");
   Put_Line("      options: the following options are defined:");
   Put_Line("      -------");
   New_Line;
   Put_Line("        -v, -verbose:");
   Put_Line("              enable the verbose option");
   New_Line;
end To_Mast2_Help;
