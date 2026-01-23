-----------------------------------------------------------------------
--                              To_Mast2                             --
--     Modelling and Analysis Suite for Real-Time Applications       --
--     Translation tool from MAST-1 format to MAST-2 format          --
-----------------------------------------------------------------------

   command format:
   ---------------

      to_mast2 -h
      to_mast2 -help
            does not make the translation, just prints help information

      to_mast2 [options] input_file [output_file]
            converts the input file to MAST2 format 

   tool description:
   -----------------
     
      The tool parses the input file. If it finds errors it reports
      them and stops. The list of errors can be found in the file
      'mast_parser.lis'. If there are no errors, the real-time system
      description is written to the output file, if specified, or else
      to the standard output.

      input_file : it has to be defined ussing the Mast-1 file format
      ----------   (see the Mast-1 file format definition)

      output_file: it will contain the results of the analysis
      -----------  if not specified, then the output goes to the standard
                   output
  
      options: the following options are defined:
      -------

        -v, -verbose:
              enable the verbose option

