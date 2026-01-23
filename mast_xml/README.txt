-----------------------------------------------------------------------
--                              Mast                                 --
--     Modeling and Analysis Suite for Real-Time Applications        --
--                                                                   --
--                       Copyright (C) 2000-2019                     --
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
--	    Yago Pereiro Estevan                 		     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU  --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------

                            Version 1.5.1.4

                          XML Conversion Tools
                          --------------------

TABLE OF CONTENTS
-----------------

   1. Introduction
   2. Binary Installation
   3. Source Installation   
   4. Usage of the Conversion Tools
   5. Support, Problems, and Questions

1. INTRODUCTION
---------------

The XML conversion tools provide conversions between the XML and text
formats for the description of MAST systems, and for the results
obtained by using the analysis or simulation tools.

For a description on the XML and text formats see the documentation
section in the MAST Web page:

   http://mast.unican.es/

There are two tools included in this package, provided as separate
programs:

   - mast_xml_convert: converts MAST model descriptions between the XML
                       and text formats

   - mast_xml_convert_results: converts MAST results descriptions 
                               between the XML and text formats
   

2. BINARY INSTALLATION
----------------------

The binaries come with the mast binary installations. See the general
README file. Don't forget to put the executable files in a directory
contained in your PATH.

3. SOURCE INSTALLATION
----------------------

- Requires the gnat compiler (libre.adacore.com). We have used the
  Community 2019 version of gnat in Linux and in Windows.

- Unzip and extract the source files from the mast installation.  see
  the general README file for this purpose. The sources of the XML
  conversion tools will appear in the mast_xml directory.

- Library: Previous versions of gnat required a separate installation
  of the free-software xmlada library. However, current versions
  integrate the library with the compiler distribution.

- Compile the conversion tools:

    The tools can be compiled in Windows with the general compile.bat
    script and in Linux with the compile script. Alternatively, this
    can be done by invoking the following command in directory
    mast_xml, which uses projet files:

       gnatmake -P mast_xml_convert.gpr
       gnatmake -P mast_xml_convert_results.gpr

- Make the executable files mast_xml_convert and
  mast_xml_convert_results available, by adding the mast_xml directory
  to the $PATH environment variable, or by creating links to these
  files from a directory already included in the PATH.


4. USAGE OF THE CONVERSION TOOLS
------------------------------

mast_xml_convert:

   Usage: mast_xml_convert input-file <output-file>

   The program converts the input-file from XML to text if its name
   ends with ".xml", and from text to XML otherwise. The <> notation
   above indicates that the output-file is optional. If not present,
   the output goes to the standard output.

mast_xml_convert_results:

   Usage: 
     mast_xml_convert_results model-infile results-infile <results-outfile>

   The program converts the results-infile file from XML to text if
   its name ends with ".xml", and from text to XML otherwise. To
   interpret the results, the file with the MAST model is required. The
   <> notation above indicates that the results-outfile is
   optional. If not present, the output goes to the standard output.

The mast tools automatically use the conversion tools. Names ending in
".xml" are interpreted as XML files.


5. SUPPORT, PROBLEMS, AND QUESTIONS
-----------------------------------

   If you have any questions, comments, or need help in using MAST, please 
   send a message to:

         mgh@unican.es

   To download the most recent version of MAST please look in:

         http://mast.unican.es/

   Thanks for your interest in MAST,


                   The MAST team.

