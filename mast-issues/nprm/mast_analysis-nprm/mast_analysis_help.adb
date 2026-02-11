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
procedure Mast_Analysis_Help is

begin

   Put_Line("-----------------------------------------------------------------------");
   Put_Line("--                              Mast                                 --");
   Put_Line("--     Modelling and Analysis Suite for Real-Time Applications       --");
   Put_Line("-----------------------------------------------------------------------");
   New_Line;
   Put_Line("   command format:");
   Put_Line("   ---------------");
   New_Line;
   Put_Line("      mast_analysis -h");
   Put_Line("      mast_analysis -help");
   Put_Line("            does not make the analysis, just prints help information");
   New_Line;
   Put_Line("      mast_analysis tool_name [options] input_file [output_file]");
   Put_Line("            executes the tool as described below.");
   New_Line;
   Put_Line("   tool description:");
   Put_Line("   -----------------");
   Put_Line("     ");
   Put_Line("      The tool parses the input file. If it finds errors it reports");
   Put_Line("      them and stops. The list of errors can be found in the file");
   Put_Line("      'mast_parser.lis'. If there are no errors, the real-time system");
   Put_Line("      description is transformed according to the options specified,");
   Put_Line("      the analysis is performed, and the results are output to the");
   Put_Line("      output file, if specified, or else to the standard output.");
   New_Line;

   Put_Line("      The mast tools automatically use the conversion tools. Names");
   Put_Line("      ending in "".xml"" are interpreted as XML files.");
   New_Line;

   Put_Line("      tool_name  : is one of the following (more to come)");
   Put_Line("      --------- ");
   Put_Line("          default                : uses the best tool available for");
   Put_Line("                                   the system: ");
   Put_Line("                                     - offset_based_slanted for systems");
   Put_Line("                                       with linear transactions");
   Put_Line("                                     - edf_monoprocessor for simple transaction");
   Put_Line("                                       systems scheduled under EDF");
   Put_Line("                                     - classic_rm for simple transaction");
   Put_Line("                                       systems scheduled under fixed priorities");
   Put_Line("          parse                  : does not make the analysis");
   Put_Line("          classic_rm             : classic response time analysis for fixed-");
   Put_Line("                                   priority systems with arbitrary deadlines");
   Put_Line("          varying_priorities     : varying priorities analysis for");
   Put_Line("                                   linear monoprocessor systems");
   Put_Line("          edf_monoprocessor      : response time analysis for EDF systems");
   Put_Line("          edf_within_priorities  : response time analysis for single");
   Put_Line("                                   processor systems with hierarchical");
   Put_Line("                                   scheduling: EDF on top of fixed");
   Put_Line("                                   priorities");
   Put_Line("          holistic               : holistic linear analysis both for fixed");
   Put_Line("                                   priorities, and EDF processing resources");
   Put_Line("          offset_based           : it defaults to the offset_based_slanted analysis");
   Put_Line("          offset_slanted         : offset-based linear analysis");
   Put_Line("                                   optimized to take advantage of the");
   Put_Line("                                   slanted nature of the consumption of execution");
   Put_Line("                                   time; it is an evolution of the offset_based_approx");
   Put_Line("                                   technique, but does not make the optimization");
   Put_Line("                                   by the precedence relations done in the");
   Put_Line("                                   offset_based_approx_w_pr technique");
   Put_Line("                                   it may or may not provide better results");
   Put_Line("                                   than that technique;");
   Put_Line("                                   For EDF processing resources, since offset_based");
   Put_Line("                                   analysis is not yet implemented for them, ");
   Put_Line("                                   the holistic analysis is used ");
   Put_Line("          offset_based_approx    : offset-based linear analysis");
   Put_Line("                                   with no optimizations. it provides");
   Put_Line("                                   results that are worse than in the");
   Put_Line("                                   offset_based_slanted technique; it is");
   Put_Line("                                   provided for comparison purposes");
   Put_Line("                                   For EDF processing resources, since offset_based");
   Put_Line("                                   analysis is not yet implemented for them, ");
   Put_Line("                                   the holistic analysis is used ");
   Put_Line("          offset_based_approx_w_pr:offset-based linear analysis");
   Put_Line("                                   like the offset_based_approx technique");
   Put_Line("                                   but optimizing the analysis by using the precedence");
   Put_Line("                                   relations in the transactions; it may or may not");
   Put_Line("                                   provide better results than the offset_based_slanted");
   Put_Line("                                   technique.");
   Put_Line("                                   For EDF processing resources, since offset_based");
   Put_Line("                                   analysis is not yet implemented for them, ");
   Put_Line("                                   the holistic analysis is used ");
   Put_Line("          offset_based_brute_force:exact offset-based linear analysis");
   Put_Line("                                   trying all possible combinations of tasks");
   Put_Line("                                   for generating the critical instant; this");
   Put_Line("                                   leads to exponential analysis times; this");
   Put_Line("                                   technique should only be used for very small");
   Put_Line("                                   examples; it does not take into account"); 
   Put_Line("                                   precedence relations, so its results");
   Put_Line("                                   may or may not be the same as in the");
   Put_Line("                                   offset_based_approx_w_pr technique");
   New_Line;
   New_Line;
   Put_Line("      input_file : needs to be defined ussing the Mast file format (text or XML)");
   Put_Line("      ----------   (see the Mast file format definition)");
   New_Line;
   Put_Line("      output_file: will contain the results of the analysis");
   Put_Line("      -----------  if not specified, then output goes to the standard");
   Put_Line("                   output");
   Put_Line("  ");
   Put_Line("      options: the following options are defined:");
   Put_Line("      -------");
   New_Line;
   Put_Line("        -v, -verbose:");
   Put_Line("              enable the verbose option");
   New_Line;
   Put_Line("        -c, -ceilings");
   Put_Line("              calculate ceilings for priority ceiling resources before");
   Put_Line("              the analysis");
   New_Line;
   Put_Line("        -p, -sched_parameters");
   Put_Line("              make an optimum priority or scheduling parameters");
   Put_Line("              assignment before the analysis, using the specified");
   Put_Line("              assignment technique; this option always implies");
   Put_Line("              automatic calculation of the ceilings of priority");
   Put_Line("              ceiling resources, as if the -c option had been");
   Put_Line("              specified");
   New_Line;
   Put_Line("        -l, -local_edf:");
   Put_Line("              Only used for EDF echeduling. If this flag is specified,");
   Put_Line("              Local EDF is used in EDF schedulers, with scheduling");
   Put_Line("              deadlines interpretated as local to the processing");
   Put_Line("              resource clock. Otherwise, Global EDF is used, with");
   Put_Line("              scheduling deadlines assumed to be relative to a");
   Put_Line("              system-wide clock.");
   New_line;
   Put_Line("        -f factor, -stop_factor factor:");
   Put_Line("              Analysis will stop iterating when the response time of a");
   Put_Line("              task exceeds its hard deadline multiplied by");
   Put_Line("              ""factor"". The default value is 100");
   New_line;
   Put_Line("        -t name, -technique name");
   Put_Line("              this option specifies the priority or scheduling");
   Put_Line("              parameters assignment technique named with ""name""; it");
   Put_Line("              can be one of the following:");
   Put_Line("                   hospa          (default for multiprocessors)");
   Put_Line("                   pd");
   Put_Line("                   npd");
   Put_Line("                   annealing");
   Put_Line("                   monoprocessor (default for monoprocessors)");
   New_Line;
   Put_Line("        -a filename, -assignment_parameters filename");
   Put_Line("              if this option is specified, the parameters used for");
   Put_Line("              assigning priorities with the hospa or annealing");
   Put_Line("              techniques are read from the specified filename; if the");
   Put_Line("              option is not specified, a default filename of");
   Put_Line("              ""assignment_parameters.txt"" is assumed; if that");
   Put_Line("              file does not exist, default parameters are used");
   New_Line;
   Put_Line("        -d filename, -description filename");
   Put_Line("               if this option is specified, after parsing the file");
   Put_Line("               and, if required, calculating the ceilings, levels,");
   Put_Line("               priorities, and scheduling parameters, a description of");
   Put_Line("               the system is written to the filename specified in the");
   Put_Line("               option.");
   New_Line;
   Put_Line("        -s, -slack");
   Put_Line("               if this option is specified, the analysis is iterated");
   Put_Line("               to obtain the system slack, the transaction");
   Put_Line("               slack for each transaction, and the processing resource");
   Put_Line("               slack for each processing resource.");
   New_Line;
   Put_Line("        -os name, -operation_slack name");
   Put_Line("               if this option is specified, the analysis is iterated");
   Put_Line("               to obtain the operation slack for the operation named");
   Put_Line("               as 'name'.");
   New_Line;
end Mast_Analysis_Help;
