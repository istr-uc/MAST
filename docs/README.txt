-----------------------------------------------------------------------
--                              Mast                                 --
--     Modeling and Analysis Suite for Real-Time Applications        --
--                                                                   --
--                       Copyright (C) 2000-2014                      --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
--                                                                   --
--                    URL: http://mast.unican.es/                    --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Julio Medina           medinajl@unican.es                --
--          Patricia Lopez         lopezpa@unican.es                 --
--          Juan Rivas Concepcion  rivasjm@unican.es                 --
--          Maria Cue Sampedro                                       --
--          Ola Redell                                               --
--          Yago Pereiro                                             --
--          Pilar del Rio                                            --
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

                            Version 1.5.0.0

TABLE OF CONTENTS
-----------------

   1. Analysis Tools Defined in the Mast Suite
   2. Binary Installation
   3. Source Installation   
   4. Usage of the Analysis Tools
   5. Priority Assignment Tools
   6. Support, Problems, and Questions

1. ANALYSIS TOOLS DEFINED IN THE MAST SUITE
-------------------------------------------

   Worst-case schedulability analysis:
      mast_analysis default
      mast_analysis holistic *
      mast_analysis offset_based
      mast_analysis offset_based_optimized
      mast_analysis classic_rm
      mast_analysis edf_monoprocessor
      mast_analysis edf_within_priorities
      mast_analysis varying_priorities

*The holistic analysis supports multipath transactions

2. BINARY INSTALLATION
----------------------

    Windows: 
      - unzip the file mast-bin-win-1-5-0-x.zip into a directory of your
        choice.
      - This causes the following files and directories to appear:
            mast_analysis.exe     : executable analysis tool
            gmast.bat             : script for invoking the graphical driver
            gmast_analysis.exe    : graphical driver for analysis tools
            gmastresults.exe      : graphical driver for viewing results
            gmasteditor.exe       : graphical editor for MAST models (alpha)
            mast_xml_convert.exe  : converter of MAST models between XML
                                    and text formats
            mast_xml_convert_results.exe : converter of MAST results between
                                           XML and text formats
            gmast_pt_editor.exe   : editor for simple periodic task models
	    to_mast2.exe          : converter to the MAST-2 model format
            *.dll                 : dll's for gnat
            docs                  : directory containing the MAST documents
            bin                   : directory containing dll's for GUI  
            etc                   : directory containing config files for GUI  
            lib                   : directory containing files for GUI  
            share                 : directory containing files for GUI  
            examples              : directory with examples
            README.txt            : this file
            mast-status.txt       : description of the current status

      - put both the MAST directory and the bin directory contained in
        it in the PATH environment variable, so that you can access
        the tools; you may create a link (shortcut) to the gmast.bat
        script in the desktop or another comfortable place.
         
    Linux (tested on Ubuntu 14.03):
      - requires a pdf reader for the documentation, and gtk-3.x
        (available in the Ubuntu distribution) for the GUI.
      - unzip and extract the files in mast-bin-linux-1-5-0-x.tar.gz into
        the directory of your choice:
            tar zxvf mast-bin-linux-1-5-0-x.tar.gz
      - This causes the following files to appear:
            mast_analysis         : executable tool
            gmast                 : script for invoking the graphical driver
            gmast_analysis        : graphical driver for analysis tools
            gmastresults          : graphical driver for viewing results
            gmasteditor           : graphical editor for MAST models (alpha)
            mast_xml_convert      : converter of MAST models between XML
                                    and text formats
            mast_xml_convert_results : converter of MAST results between XML
                                       and text formats
            gmast_pt_editor       : editor for simple periodic task models
	    to_mast2              : converter to the MAST-2 model format
            docs                  : directory containing the MAST documents
            examples              : directory with examples
            README.txt            : this file
            mast-status.txt       : description of the current status
            lib                   : directory containing dynamic libraries
      - put the MAST directory in the PATH, so that you can access the tools
        For example, if mast is in /usr/local/mast:
            export PATH=/usr/local/mast:$PATH
      - put the MAST/lib directory in the LD_LIBRARY_PATH, so that the
        libraries can be accessed when executing the programs
        For example, if mast is in /usr/local/mast:
            export LD_LIBRARY_PATH=/usr/local/mast/lib:$LD_LIBRARY_PATH

3. SOURCE INSTALLATION
----------------------

      - Requires the gnat compiler (libre.adacore.com). We have used
        the GPL2014 version of gnat in Linux, and in Windows.

      - Unzip and extract the source files from mast-src-1-5-0-x.tar.gz 
        or from mast-src-1-5-0-x.zip into the directory of your choice. 
        This creates the following directories and files:
            mast_analysis   : directory containing the analysis tools
            utils           : directory containing sources for common modules
            gmast           : directory containing the graphical driver
            gmastresults    : directory with the graphical results viewer
            mast_xml        : directory with the XML converters
            gmasteditor     : directory with the graphical editor (beta)
            pt_editor       : directory with the periodic task model editor
	    to_mast2        : converter to the MAST-2 model format
            docs            : directory containing the MAST documents
            examples        : directory containing some examples
            README.txt      : this file
            mast-status.txt : description of the current status

        A script called compile can be called to compile all the mast programs.

        Alternatively, The tools can be compiled invoking the following 
        command in the mast_analysis directory:

             gnatmake -g -gnato -I../utils mast_analysis

      - For compiling the graphical driver, the graphical results
        viewer and the graphical editor you need GtkAda (available
        from http://libre.adacore.com/GtkAda/). We have used version
        3.8.4.

      - To compile in Linux, invoke the following commands in the
        gmast/src, the gmastresults/src and the gmasteditor/src
        directories, respectively:

             gnatmake -I../../mast_analysis -I../../utils gmast_analysis `gtkada-config`
             gnatmake -I../../mast_analysis -I../../utils gmastresults `gtkada-config`
             gnatmake -I../../mast_analysis -I../../utils -I../../gmast/src -I../../gmastresults/src gmasteditor `gtkada-config`

        Then set the appropriate PATH, or create links to the executable
        files somewhere in your search PATH.

        To compile in Windows, use the command:

             gnatmake -Ic:/Gtkada/include/gtkada -I../../mast_analysis -I../../utils gmast_analysis -largs -lgtkada
             gnatmake -Ic:/Gtkada/include/gtkada -I../../mast_analysis -I../../utils gmastresults -largs -lgtkada
             gnatmake -Ic:/Gtkada/include/gtkada -I../../mast_analysis -I../../gmast/src -I../../utils -I../../gmastresults/src gmasteditor -largs -lgtkada

        assuming that GtkAda is installed in directory c:\Gtkada. 
        Then, set the appropriate PATH, or move the executable program
        to a directory in the search PATH.

      - For compiling the XML conversion tools see the README.txt file
        in the mast_xml directory.

      - If you wish to add or change anything in the file format, you
        need the aflex and ayacc tools (available from the MAST Web
        page) to re-generate the mast file parser or the mast results
        parser. You can install the tools by unzipping and extracting the
        files from:
            aflex-ayacc-gnat.tar.gz
        this will create the directories
            ayacc
            aflex
        these are modified versions of ayacc and aflex with the
        following changes:
            - adapted for gnat
            - can accept input files with international characters (8
              bit characters)
        you need to compile the tools:
            - in the ayacc/src directory: gnatmake ayacc
            - in the aflex/src directory: gnatmake aflex
        and put the corresponding directories in the PATH, or create links
        to the executable files somewhere in your search PATH, or move the
        executable files to a directory that is in the PATH.

        The mast file parser description is in file
        "mast_parser.y". The lexical analyzer description for the mast
        file is in file "mast_lex.l". To regenerate the parser and the
        tools use the "generate" script.

        The parser for the results file has its description in file
        "mast_results_parser.y", and its lexical analyzer description
        in "mast_results_lex.l". To regenerate the results parser
        use the "generate_results" script.


4. USAGE OF THE ANALYSIS TOOLS
------------------------------

   graphical driver
   ----------------

      gmast

         The graphical driver displays the information about the
         tools, files and options available. After setting all the
         desired fields, pressing the "GO" button will produce a
         script, in a file named "mast_command" that invokes the
         mast_analysis tool with the appropriate arguments.

         If a results file has been defined, then it is possible to
         set the "View Results" option. In that case, after the
         analysis the graphical results viewer is invoked.

         The "Help" button in the graphical driver provides additional
         help.
         

   command format:
   ---------------

      mast_analysis -h
      mast_analysis -help 
            do not make the analysis, just print help information

      mast_analysis tool_name [options] input_file [output_file]
            execute the tool as described below.

   tool description:
   -----------------
     
      The tool parses the input file. If it finds errors it reports
      them and stops. The list of errors can be found in the file
      "mast_parser.lis". If there are no errors, the real-time system
      description is transformed according to the options specified,
      the analysis is performed, and the results are output to the
      output file, if specified, or else to the standard output.

      The mast tools automatically use the conversion tools. Names
      ending in ".xml" are interpreted as XML files.

      tool_name  : is one of the following (more to come)
      ---------       
           default                : uses the best tool available for
                                    the system: 
                                      - offset_based_slanted for systems
                                        with linear transactions
                                      - edf_monoprocessor for simple transaction
                                        systems scheduled under EDF
                                      - classic_rm for simple transaction
                                        systems scheduled under fixed priorities
           parse                  : does not make the analysis
           classic_rm             : classic response time analysis for fixed-
                                    priority systems with arbitrary deadlines
           varying_priorities     : varying priorities analysis for
                                    linear monoprocessor systems
           edf_monoprocessor      : response time analysis for EDF systems
           edf_within_priorities  : response time analysis for single 
                                    processor systems with hierarchical 
                                    scheduling: EDF on top of fixed
                                    priorities
           holistic               : holistic linear analysis both for fixed
                                    priority and EDF processing resources
           offset_based           : it defaults to the offset_based_slanted
                                    analysis
           offset_slanted         : offset-based linear analysis
                                    optimized to take advantage of the
                                    slanted nature of the consumption of 
                                    execution time; it is an evolution of the 
                                    offset_based_approx technique, but does 
                                    not make the optimization by the precedence
                                    relations done in the
                                    offset_based_approx_w_pr technique;
                                    it may or may not provide better results
                                    than that technique;
                                    For EDF processing resources, since 
                                    offset_based analysis is not yet 
                                    implemented for them, 
                                    the holistic analysis is used 
           offset_based_approx    : offset-based linear analysis
                                    with no optimizations. it provides
                                    results that are worse than in the
                                    offset_based_slanted technique; it is
                                    provided for comparison purposes
                                    For EDF processing resources, since 
                                    offset_based analysis is not yet 
                                    implemented for them, 
                                    the holistic analysis is used 
           offset_based_approx_w_pr:offset-based analysis with precedence 
                                    relations. it is like the 
                                    offset_based_approx technique
                                    but optimizing the analysis by using the 
                                    precedence relations in the transactions; 
                                    it may or may not provide better results 
                                    than the offset_based_slanted technique.
                                    For EDF processing resources, since 
                                    offset_based analysis is not yet 
                                    implemented for them, 
                                    the holistic analysis is used 
           offset_based_brute_force:exact offset-based linear analysis
                                    trying all possible combinations of tasks
                                    for generating the critical instant; this
                                    leads to exponential analysis times; this
                                    technique should only be used for very small
                                    examples; it does not take into account 
                                    precedence relations, so its results
                                    may or may not be the same as in the
                                    offset_based_approx_w_pr technique

      input_file : needs to be defined using the Mast file format (text or XML)
      ----------   (see the Mast file format definition)

      output_file: will contain the results of the analysis (text or XML)
      -----------  if not specified, then output goes to the standard
                   output in text format
  
      options: the following options are defined:
      -------

        -v, -verbose:
              enable the verbose option

        -c, -ceilings
              calculate ceilings for priority ceiling resources and
              preemption levels for the stack resource policy before
              the analysis

        -p, -sched_parameters
              make an optimum priority or scheduling parameters
              assignment before the analysis, using the specified
              assignment technique; this option always implies
              automatic calculation of the ceilings of priority
              ceiling resources, as if the -c option had been
              specified
                          
        -f factor, -stop_factor factor
              Analysis will stop iterating when the response time of a
              task exceeds its hard deadline multiplied by
              "factor". The default value is 100.
                
        -l, -local_edf
              Only used for EDF echeduling. If this flag is specified,
              Local EDF is used in EDF schedulers, with scheduling
              deadlines interpretated as local to the processing
              resource clock. Otherwise, Global EDF is used, with
              scheduling deadlines assumed to be relative to a
              system-wide clock.

        -t name, -technique name
              this option specifies the priority or scheduling
              parameters assignment technique named with "name"; it
              can be one of the following:
                   hospa      (default for multiprocessors)
                   pd
                   npd
                   annealing
                   monoprocessor (default for monoprocessors)

        -a filename, -assignment_parameters filename
              if this option is specified, the parameters used for
              assigning priorities with the HOSPA or annealing
              techniques are read from the specified filename; if the
              option is not specified, a default filename of
              "assignment_parameters.txt" is assumed; if that
              file does not exist, default parameters are used

        -d filename, -description filename
               if this option is specified, after parsing the file
               and, if required, calculating the ceilings, levels,
               priorities, and scheduling parameters, a description of
               the system is written to the filename specified in the
               option.

        -s, -slack
               if this option is specified, the analysis is iterated
               to obtain the system slack, the transaction
               slack for each transaction, and the processing resource
               slack for each processing resource.

        -os name, -operation_slack name
               if this option is specified, the analysis is iterated
               to obtain the operation slack for the operation named
               as "name".
               
   graphical results viewer
   ------------------------

      It is invoked directly from the gmast driver, if the
      corresponding option is selected:
         gmast

      gmast can be used with the -n or --non_editable_files options to
      disable the ability to edit the filenames; this is appropriate
      when invoking gmast from a tool that supplies the file names:
         gmast -n
         gmast --non_editable_files

      It can also be invoked directly from the command line:
         gmastresults model_file results_file

      where model_file is the file containing the mast system
      description, and results_file is the file containing the results
      of the analysis tools on that model_file

   graphical editor for the MAST model
   -----------------------------------

     To invoke the graphical editor use
         gmasteditor
     and then use the "File" menu to open or save a MAST model.

     Alternatively you can invoke the graphical editor with the
     filename that you want to open:

        gmasteditor mast_model_filename

     The graphical editor uses a complementary file with a ".mss" file
     extension to store information on the way the different elements
     of the mast model are displayed. If this is the first time you
     use the graphical editor on a specific model you will get a
     warning message saying that the ".mss" file is not found. In this
     case the gmasteditor tool will place your objects arbitrarily on
     the screen, and you may need some reorganization to get a clear
     visualization. Once the model is saved, the ".mss" file will
     be created to capture the object placement information.

   xml conversion tools
   --------------------

    Both the MAST model and the results obtained from the MASt tools
    can be saved in a special-purpose text format or as XML
    files. Conversion tools from and to both formats are provided in
    the mast_xml directory:

      mast_xml_convert  : converter of MAST models between XML
                          and text formats
      mast_xml_convert_results : converter of MAST results between
                                 XML and text formats

    See the README.txt file in the mast_xml directory for more
    information on how to use these converters.

    Graphical editor for periodic task models
    -----------------------------------------

    The objective of the Periodic Task Editor is to provide an easy
    way of defining a MAST model for a simple task system running on a
    single processor.

    The editor allows defining periodic tasks with their execution
    times (WCET), periods (T), and Deadlines (D). These tasks may
    interact by sharing mutual exclusion resources.

    The editor uses the MAST schedulability analysis tools to
    automatically assign priorities or scheduling parameters, and to
    obtain worst case response times and overall system utilization
    and slack.

    The model is stored in a file with termination ".pte", which can
    be later edited with this program.

    In addition, the tool saves the model in a file with termination
    "_mast.txt", which contains the full MAST model that can be edited
    with gmasteditor and used with the MAST analysis tools. However,
    if the full model is edited the changes are not carried back to
    the original ".pte" model.



5. PRIORITY AND SCHEDULING PARAMETERS ASSIGNMENT TOOLS
------------------------------------------------------

Configuring the assignment of scheduling parameters
----------------------------------------------------

    The configuration of the scheduling parameters assignment tools is
    needed in order to determine the following aspects:

       a) bounding the number of iterations performed by the algorithm to
          reach a sheduling parameter assignment that makes the system 
		  schedulable

       b) bounding the number of iterations to optimize, which are used
          after a feasible solution has been obtained to optimize and try
          reaching a better assignment.

       c) defining additional parameters for configuring the way in
          which the heuristic algorithm does its work. Changing these
          parameters may increase or decrease the quality of the
          solution, so it is advised to make small changes and compare
          the output obtained.

    The scheduling parameters assignment configuration values are
    found in the file assignment_parameters.txt, in the working
    directory.

Five basic methods are provided. For single processor systems with
simple transactions, it is possible to find an optimum assignment. For
other more complex systems, optimum assignment is not known and
heuristic optimization algorithms are used:

   - Simulated annealing; it is a general-purpose optimization technique

   - HOSPA: it is a faster heuristic that usually gives better results
     than simulated annealing.
 
   - PD (Proportional Distribution): The assignment of priorities
     and/or deadlines is proportional to each task's WCET.

   - NPD (Normalized Proportional Distribution): The assignment of
     priorities and/or deadlines is proportional to each task's
     WCET, normalizing the results according to each processing
     resource's utilization.

Single processors with simple transactions
------------------------------------------

    The priority assignment algorithm for single processors with
    simple transactions does not need any parameter. It uses the
    deadline monotonic assignment if deadlines are smaller than or
    equal to the periods, or Audsley's algorithm in the case of
    deadlines larger than the periods.

    The scheduling deadline assiggnment algorithm for EDF in single
    processors with simple transactions just assigns the deadlines
    specified in the timing requirements as scheduling deadlines.


Simulated annealing configuration parameters (Fixed priorities only):
---------------------------------------------------------------------

 - Max_Iterations: maximum number of iterations to be performed by
   the algorithm.

 - Iterations_To_Optimize: maximum number of iterations to be
   performed by the algorithm after the first feasible solution has
   been reached.


HOSPA configuration parameters
---------------------------------------------------------------

The maximum number of iterations for this algorithm is not explicit,
and depends on the size of the List of K-pairs and the values for the
number of iterations declared in the iterations list.

 - Initial Assignment: Specifies what kind of initial parameters assignment
   will be used:
        - pd: The initial assignment of priorities and/or deadlines will be
          proportional to each task's WCET.
        - npd: The initial assignment of priorities and/or deadlines will be
          proportional to each task's WCET, normalizing the results according 
          to each processing resource's utilization.
        - user: The initial assignment of priorities and deadlines will be
          provided by the user in the MAST description file.
 
 - List of K-pairs: K values are heuristic constants used to modify
   the internal deadlines that are the basis of the algorithm. Normal
   values for these constants are between 1.0 and 3.0, and the usual
   number of different values that HOSPA may attempt is between 3 and 5.

    - Size_Of_K_List: number of K-pairs

    - Ka_List: list of constants for varying the priorities or the
      intermediate deadlines according to the response times of the
      activities in a transaction

    - Kr_List: list of constants for varying the priorities or the
      intermediate deadlines according to the response times of the
      activities in a processing resource

 - List of number of iterations to perform for each K-pair:
   Usually, this is a list with increasing values, starting for
   example with 10. Each value represents an attempt to find better 
   solutions for all values of the list of K-pairs.

    - Size_Of_Iterations_List: size of the iterations list

    - Iterations_List: list with the number of iterations to be
      performed by the algorithm for each K-pair

 - Iterations_To_Optimize: maximum number of iterations to be
   performed by the algorithm after the first feasible solution has
   been reached. 


PD: Proportional Distribution 
-----------------------------

No configuration parameters are needed for this technique


NPD:Normalized Proportional Distribution
----------------------------------------

No configuration parameters are needed for this technique



6. SUPPORT, PROBLEMS, AND QUESTIONS
-----------------------------------

   If you have any questions, comments, or need help in using MAST, please 
   send a message to:

         mgh@unican.es

   To download the most recent version of MAST please look in:

         http://mast.unican.es/

   Thanks for your interest in MAST,


                   The MAST team.

