-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2025                     --
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
   Put_Line("      tool_name  : is one of the following:");
   Put_Line("      --------- ");
   Put_Line("          default                : uses the best tool available for");
   Put_Line("                                   the system: ");
   Put_Line("                                     - offset_based_slanted for systems");
   Put_Line("                                       with fixed-priority scheduling and");
   Put_Line("                                       linear transactions");
   Put_Line("                                     - offset_based_approx for systems with");
   Put_Line("                                       EDF Scheduling");
   Put_Line("                                     - edf_monoprocessor for simple");
   Put_Line("                                       transaction systems scheduled under");
   Put_Line("                                       EDF");
   Put_Line("                                     - classic_rm for simple transaction");
   Put_Line("                                       systems scheduled under fixed");
   Put_Line("                                       priorities");
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
   Put_Line("          offset_based           : it defaults to the offset_based_slanted"); 
   Put_Line("                                    analysis in fixed priority processors,");
   Put_Line("                                   and offset_based_approx analysis in EDF");
   Put_Line("                                   processors");
   Put_Line("          offset_based_slanted   : offset-based linear analysis");
   Put_Line("                                   optimized to take advantage of the");
   Put_Line("                                   slanted nature of the consumption of");
   Put_Line("                                   execution time; it is an evolution of the");
   Put_Line("                                   offset_based_approx technique, but does");
   Put_Line("                                   not make the optimization by the");
   Put_Line("                                   precedence relations done in the");
   Put_Line("                                   offset_based_approx_w_pr technique. It may");
   Put_Line("                                   or may not provide better results than");
   Put_Line("                                   that technique;");
   Put_Line("                                   For EDF processing resources, since");
   Put_Line("                                   this technique is not yet available,");
   Put_Line("                                   the offset_based_approx analysis is used"); 
   Put_Line("          offset_based_approx    : offset-based linear analysis");
   Put_Line("                                   with no optimizations. In fixed-priority");
   Put_Line("                                   processors it provides results that are");
   Put_Line("                                   worse than in the offset_based_slanted");
   Put_Line("                                   technique");
   Put_Line("          offset_based_approx_w_pr:offset-based linear analysis with ");
   Put_Line("                                   precedence relations.");
   Put_Line("                                   Like the offset_based_approx technique");
   Put_Line("                                   but optimizing the analysis by using the");
   Put_Line("                                   precedence relations in the transactions;");
   Put_Line("                                   it may or may not provide better results");
   Put_Line("                                   than the offset_based_slanted technique.");
   Put_Line("                                   For EDF processing resources it is not");
   Put_Line("                                   available and the");
   Put_Line("                                   offset_based_approx analysis is used.");
   Put_Line("          offset_based_brute_force:exact offset-based linear analysis");
   Put_Line("                                   trying all possible combinations of tasks");
   Put_Line("                                   for generating the critical instant; this");
   Put_Line("                                   leads to exponential analysis times; this");
   Put_Line("                                   technique should only be used for very");
   Put_Line("                                   small examples; it does not take into"); 
   Put_Line("                                   account precedence relations, so its");
   Put_Line("                                   results may or may not be better than in");
   Put_Line("                                   the offset_based_approx_w_pr technique.");
   Put_Line("                                   For EDF processing resources it is not");
   Put_Line("                                   available and the");
   Put_Line("                                   offset_based_approx analysis is used.");
   New_Line;
   New_Line;
   Put_Line("      input_file : needs to be defined ussing the Mast file format (text");
   Put_Line("      ----------   or XML) (see the Mast file format definition)");
   New_Line;
   Put_Line("      output_file: will contain the results of the analysis");
   Put_Line("      -----------  if not specified, then output goes to the standard");
   Put_Line("                   output in text format");
   New_Line;
   Put_Line("                   If an "".xmi"" extension is specified for the output file");
   Put_Line("                   the results of the analysis are written in XMI format");
   Put_Line("                   according to the MAST2-results metamodel. In this case,");
   Put_Line("                   it is necessary to also specify the ""-d"" option, using");
   Put_Line("                   a file name with an "".xmi"" extension for writing the");
   Put_Line("                   mast model in XMI format, according to the MAST2");
   Put_Line("                   metamodel.");
   Put_Line("  ");
   Put_Line("      options: the following options are defined:");
   Put_Line("      -------");
   New_Line;
   Put_Line("        -v, -verbose:");
   Put_Line("              enable the verbose option");
   New_Line;
   Put_Line("        -c, -ceilings");
   Put_Line("              calculate ceilings for priority ceiling resources and");
   Put_Line("              preemption levels for the stack resource policy before");
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
   Put_Line("        -f factor, -stop_factor factor:");
   Put_Line("              Analysis will stop iterating when the response time of a");
   Put_Line("              task exceeds its hard deadline multiplied by");
   Put_Line("              ""factor"". The default value is 100");
   New_Line;
   Put_Line("        -l, -local_edf:");
   Put_Line("              Only used for EDF echeduling. If this flag is specified,");
   Put_Line("              Local EDF is used in EDF schedulers, with scheduling");
   Put_Line("              deadlines interpretated as local to the processing");
   Put_Line("              resource clock. Otherwise, Global EDF is used, with");
   Put_Line("              scheduling deadlines assumed to be relative to a");
   Put_Line("              system-wide clock.");
   New_Line;
   Put_Line("        -t name, -technique name");
   Put_Line("              this option specifies the priority or scheduling");
   Put_Line("              parameters assignment technique named with ""name""; it");
   Put_Line("              can be one of the following (see the README.txt file for");
   Put_Line("              more information on the techniques:");
   Put_Line("                   hospa          (default for multiprocessors)");
   Put_Line("                   pd");
   Put_Line("                   npd");
   Put_Line("                   ud");
   Put_Line("                   ed");
   Put_Line("                   eqs");
   Put_Line("                   eqf");
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
   Put_Line("               option. This is how we can obtain the assignment parameters.");
   New_Line;
   Put_Line("               If the file name has an "".xmi"" extension the file will");
   Put_Line("               be written using the XMI format according to the MAST2");
   Put_Line("               metamodel.");
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
   Put_Line("               as ""name"".");
   New_Line;
   Put_Line("        -gsd, -force_global: forces a global deadline assignment, even");
   Put_Line("               for local analysis (LC-EDF-GSD)");
   New_Line;
   Put_Line("        -ds, -scale_vd: New virtual deadlines = vd*scale_factor (LC-EDF-DS)");
   New_Line;

end Mast_Analysis_Help;
