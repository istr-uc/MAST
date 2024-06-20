pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~test_xml_results.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~test_xml_results.adb");

with System.Restrictions;

package body ada_main is
   pragma Warnings (Off);

   procedure Do_Finalize;
   pragma Import (C, Do_Finalize, "system__standard_library__adafinal");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   procedure adainit is
      E022 : Boolean; pragma Import (Ada, E022, "system__secondary_stack_E");
      E018 : Boolean; pragma Import (Ada, E018, "system__soft_links_E");
      E012 : Boolean; pragma Import (Ada, E012, "system__exception_table_E");
      E108 : Boolean; pragma Import (Ada, E108, "ada__calendar_E");
      E080 : Boolean; pragma Import (Ada, E080, "ada__io_exceptions_E");
      E009 : Boolean; pragma Import (Ada, E009, "ada__strings_E");
      E055 : Boolean; pragma Import (Ada, E055, "ada__tags_E");
      E064 : Boolean; pragma Import (Ada, E064, "ada__streams_E");
      E082 : Boolean; pragma Import (Ada, E082, "interfaces__c_E");
      E073 : Boolean; pragma Import (Ada, E073, "system__finalization_root_E");
      E084 : Boolean; pragma Import (Ada, E084, "system__os_lib_E");
      E048 : Boolean; pragma Import (Ada, E048, "ada__strings__maps_E");
      E051 : Boolean; pragma Import (Ada, E051, "ada__strings__maps__constants_E");
      E313 : Boolean; pragma Import (Ada, E313, "gnat__directory_operations_E");
      E075 : Boolean; pragma Import (Ada, E075, "system__finalization_implementation_E");
      E071 : Boolean; pragma Import (Ada, E071, "ada__finalization_E");
      E089 : Boolean; pragma Import (Ada, E089, "ada__finalization__list_controller_E");
      E241 : Boolean; pragma Import (Ada, E241, "ada__strings__unbounded_E");
      E087 : Boolean; pragma Import (Ada, E087, "system__file_control_block_E");
      E162 : Boolean; pragma Import (Ada, E162, "ada__streams__stream_io_E");
      E069 : Boolean; pragma Import (Ada, E069, "system__file_io_E");
      E063 : Boolean; pragma Import (Ada, E063, "ada__text_io_E");
      E266 : Boolean; pragma Import (Ada, E266, "ada__text_io__text_streams_E");
      E135 : Boolean; pragma Import (Ada, E135, "binary_trees_E");
      E170 : Boolean; pragma Import (Ada, E170, "hash_lists_E");
      E156 : Boolean; pragma Import (Ada, E156, "indexed_lists_E");
      E139 : Boolean; pragma Import (Ada, E139, "list_exceptions_E");
      E091 : Boolean; pragma Import (Ada, E091, "mast_E");
      E172 : Boolean; pragma Import (Ada, E172, "mast__scheduling_parameters_E");
      E182 : Boolean; pragma Import (Ada, E182, "mast__scheduling_policies_E");
      E174 : Boolean; pragma Import (Ada, E174, "mast__synchronization_parameters_E");
      E200 : Boolean; pragma Import (Ada, E200, "mast__timers_E");
      E209 : Boolean; pragma Import (Ada, E209, "mast_lex_dfa_E");
      E211 : Boolean; pragma Import (Ada, E211, "mast_lex_io_E");
      E214 : Boolean; pragma Import (Ada, E214, "mast_parser_error_report_E");
      E228 : Boolean; pragma Import (Ada, E228, "mast_results_lex_dfa_E");
      E230 : Boolean; pragma Import (Ada, E230, "mast_results_lex_io_E");
      E233 : Boolean; pragma Import (Ada, E233, "mast_results_parser_error_report_E");
      E237 : Boolean; pragma Import (Ada, E237, "mast_xml_exceptions_E");
      E260 : Boolean; pragma Import (Ada, E260, "sax__htable_E");
      E316 : Boolean; pragma Import (Ada, E316, "sax__pointers_E");
      E248 : Boolean; pragma Import (Ada, E248, "unicode_E");
      E256 : Boolean; pragma Import (Ada, E256, "unicode__ccs_E");
      E270 : Boolean; pragma Import (Ada, E270, "unicode__ccs__iso_8859_1_E");
      E272 : Boolean; pragma Import (Ada, E272, "unicode__ccs__iso_8859_15_E");
      E277 : Boolean; pragma Import (Ada, E277, "unicode__ccs__iso_8859_2_E");
      E280 : Boolean; pragma Import (Ada, E280, "unicode__ccs__iso_8859_3_E");
      E282 : Boolean; pragma Import (Ada, E282, "unicode__ccs__iso_8859_4_E");
      E284 : Boolean; pragma Import (Ada, E284, "unicode__ccs__windows_1251_E");
      E289 : Boolean; pragma Import (Ada, E289, "unicode__ccs__windows_1252_E");
      E252 : Boolean; pragma Import (Ada, E252, "unicode__ces_E");
      E244 : Boolean; pragma Import (Ada, E244, "dom__core_E");
      E296 : Boolean; pragma Import (Ada, E296, "dom__core__documents_E");
      E329 : Boolean; pragma Import (Ada, E329, "mast_xml_parser_extension_E");
      E310 : Boolean; pragma Import (Ada, E310, "sax__locators_E");
      E308 : Boolean; pragma Import (Ada, E308, "sax__exceptions_E");
      E306 : Boolean; pragma Import (Ada, E306, "sax__models_E");
      E304 : Boolean; pragma Import (Ada, E304, "sax__attributes_E");
      E327 : Boolean; pragma Import (Ada, E327, "sax__utils_E");
      E254 : Boolean; pragma Import (Ada, E254, "unicode__ces__utf32_E");
      E292 : Boolean; pragma Import (Ada, E292, "unicode__ces__basic_8bit_E");
      E320 : Boolean; pragma Import (Ada, E320, "input_sources_E");
      E322 : Boolean; pragma Import (Ada, E322, "input_sources__file_E");
      E325 : Boolean; pragma Import (Ada, E325, "input_sources__strings_E");
      E318 : Boolean; pragma Import (Ada, E318, "sax__readers_E");
      E300 : Boolean; pragma Import (Ada, E300, "dom__readers_E");
      E294 : Boolean; pragma Import (Ada, E294, "unicode__ces__utf16_E");
      E258 : Boolean; pragma Import (Ada, E258, "unicode__ces__utf8_E");
      E246 : Boolean; pragma Import (Ada, E246, "sax__encodings_E");
      E268 : Boolean; pragma Import (Ada, E268, "unicode__encodings_E");
      E264 : Boolean; pragma Import (Ada, E264, "dom__core__nodes_E");
      E262 : Boolean; pragma Import (Ada, E262, "dom__core__attrs_E");
      E302 : Boolean; pragma Import (Ada, E302, "dom__core__character_datas_E");
      E298 : Boolean; pragma Import (Ada, E298, "dom__core__elements_E");
      E094 : Boolean; pragma Import (Ada, E094, "var_strings_E");
      E106 : Boolean; pragma Import (Ada, E106, "mast__io_E");
      E141 : Boolean; pragma Import (Ada, E141, "named_lists_E");
      E158 : Boolean; pragma Import (Ada, E158, "mast__events_E");
      E154 : Boolean; pragma Import (Ada, E154, "mast__graphs_E");
      E152 : Boolean; pragma Import (Ada, E152, "mast__results_E");
      E104 : Boolean; pragma Import (Ada, E104, "mast__processing_resources_E");
      E198 : Boolean; pragma Import (Ada, E198, "mast__processing_resources__processor_E");
      E180 : Boolean; pragma Import (Ada, E180, "mast__schedulers_E");
      E184 : Boolean; pragma Import (Ada, E184, "mast__schedulers__primary_E");
      E178 : Boolean; pragma Import (Ada, E178, "mast__scheduling_servers_E");
      E196 : Boolean; pragma Import (Ada, E196, "mast__schedulers__adjustment_E");
      E188 : Boolean; pragma Import (Ada, E188, "mast__schedulers__secondary_E");
      E194 : Boolean; pragma Import (Ada, E194, "mast__shared_resources_E");
      E192 : Boolean; pragma Import (Ada, E192, "mast__operations_E");
      E190 : Boolean; pragma Import (Ada, E190, "mast__drivers_E");
      E204 : Boolean; pragma Import (Ada, E204, "mast__graphs__event_handlers_E");
      E176 : Boolean; pragma Import (Ada, E176, "mast__processing_resources__network_E");
      E168 : Boolean; pragma Import (Ada, E168, "mast__timing_requirements_E");
      E164 : Boolean; pragma Import (Ada, E164, "mast__graphs__links_E");
      E202 : Boolean; pragma Import (Ada, E202, "mast__transactions_E");
      E102 : Boolean; pragma Import (Ada, E102, "mast__systems_E");
      E239 : Boolean; pragma Import (Ada, E239, "mast_xml_parser_E");
      E334 : Boolean; pragma Import (Ada, E334, "mast_xml_results_parser_E");
      E138 : Boolean; pragma Import (Ada, E138, "symbol_table_E");
      E136 : Boolean; pragma Import (Ada, E136, "mast_parser_tokens_E");
      E207 : Boolean; pragma Import (Ada, E207, "mast_lex_E");
      E231 : Boolean; pragma Import (Ada, E231, "mast_results_parser_tokens_E");
      E226 : Boolean; pragma Import (Ada, E226, "mast_results_lex_E");

      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Zero_Cost_Exceptions : Integer;
      pragma Import (C, Zero_Cost_Exceptions, "__gl_zero_cost_exceptions");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");
   begin
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, False, True, True, False, True, True, True, 
           True, True, False, False, True, False, False, True, 
           True, True, True, True, True, True, True, True, 
           False, False, True, False, True, False, False, True, 
           False, False, True, False, False, False, True, False, 
           False, True, False, True, False, False, False, False, 
           False, False, True, True, True, False, False, True, 
           False, True, True, False, True, True, True, False, 
           False, False, False, False, False, False),
         Count => (0, 0, 0, 0, 0, 0, 0),
         Unknown => (False, False, False, False, False, False, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Zero_Cost_Exceptions := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      System.Soft_Links'Elab_Body;
      E018 := True;
      System.Secondary_Stack'Elab_Body;
      E022 := True;
      System.Exception_Table'Elab_Body;
      E012 := True;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E108 := True;
      Ada.Io_Exceptions'Elab_Spec;
      E080 := True;
      Ada.Strings'Elab_Spec;
      E009 := True;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E064 := True;
      Interfaces.C'Elab_Spec;
      E082 := True;
      System.Finalization_Root'Elab_Spec;
      E073 := True;
      System.Os_Lib'Elab_Body;
      E084 := True;
      Ada.Strings.Maps'Elab_Spec;
      E048 := True;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E051 := True;
      Gnat.Directory_Operations'Elab_Spec;
      Gnat.Directory_Operations'Elab_Body;
      E313 := True;
      System.Finalization_Implementation'Elab_Spec;
      System.Finalization_Implementation'Elab_Body;
      E075 := True;
      Ada.Finalization'Elab_Spec;
      E071 := True;
      Ada.Finalization.List_Controller'Elab_Spec;
      E089 := True;
      Ada.Strings.Unbounded'Elab_Spec;
      E241 := True;
      System.File_Control_Block'Elab_Spec;
      E087 := True;
      Ada.Streams.Stream_Io'Elab_Spec;
      System.File_Io'Elab_Body;
      E069 := True;
      E162 := True;
      Ada.Tags'Elab_Body;
      E055 := True;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E063 := True;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E266 := True;
      E135 := True;
      List_Exceptions'Elab_Spec;
      E139 := True;
      E156 := True;
      E170 := True;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      E209 := True;
      mast_lex_io'elab_spec;
      E211 := True;
      Mast_Parser_Error_Report'Elab_Spec;
      E214 := True;
      E228 := True;
      mast_results_lex_io'elab_spec;
      E230 := True;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E233 := True;
      Mast_Xml_Exceptions'Elab_Spec;
      E260 := True;
      Sax.Pointers'Elab_Spec;
      E316 := True;
      Unicode.Ccs'Elab_Spec;
      E256 := True;
      E270 := True;
      Unicode.Ces'Elab_Spec;
      E252 := True;
      DOM.CORE'ELAB_SPEC;
      Sax.Locators'Elab_Spec;
      E310 := True;
      Sax.Exceptions'Elab_Spec;
      E308 := True;
      Sax.Models'Elab_Spec;
      Sax.Attributes'Elab_Spec;
      E304 := True;
      E254 := True;
      E292 := True;
      Input_Sources'Elab_Spec;
      Input_Sources.File'Elab_Spec;
      Input_Sources.Strings'Elab_Spec;
      Sax.Readers'Elab_Spec;
      DOM.READERS'ELAB_SPEC;
      E294 := True;
      E258 := True;
      E325 := True;
      E322 := True;
      Sax.Encodings'Elab_Spec;
      E246 := True;
      E306 := True;
      E268 := True;
      E320 := True;
      E329 := True;
      E262 := True;
      E302 := True;
      E298 := True;
      E300 := True;
      E296 := True;
      E264 := True;
      E318 := True;
      Sax.Utils'Elab_Body;
      E327 := True;
      E244 := True;
      Unicode'Elab_Body;
      E248 := True;
      E272 := True;
      E284 := True;
      E289 := True;
      E282 := True;
      E280 := True;
      E277 := True;
      Var_Strings'Elab_Spec;
      E094 := True;
      Mast_Xml_Exceptions'Elab_Body;
      E237 := True;
      Mast'Elab_Body;
      E091 := True;
      E200 := True;
      E174 := True;
      E182 := True;
      E172 := True;
      E141 := True;
      MAST.EVENTS'ELAB_SPEC;
      E158 := True;
      MAST.GRAPHS'ELAB_SPEC;
      E154 := True;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E104 := True;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E198 := True;
      Mast.Schedulers'Elab_Spec;
      E180 := True;
      Mast.Schedulers.Primary'Elab_Spec;
      E184 := True;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E188 := True;
      E196 := True;
      E178 := True;
      Mast.Shared_Resources'Elab_Spec;
      E194 := True;
      MAST.OPERATIONS'ELAB_SPEC;
      E192 := True;
      Mast.Drivers'Elab_Spec;
      E190 := True;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E204 := True;
      Mast.Processing_Resources.Network'Elab_Spec;
      E176 := True;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E168 := True;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E164 := True;
      E152 := True;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E202 := True;
      Mast.Systems'Elab_Spec;
      E102 := True;
      Mast_Xml_Parser'Elab_Spec;
      E239 := True;
      E334 := True;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E138 := True;
      Mast_Parser_Tokens'Elab_Spec;
      E136 := True;
      MAST.IO'ELAB_BODY;
      E106 := True;
      E207 := True;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E231 := True;
      E226 := True;
   end adainit;

   procedure adafinal is
   begin
      Do_Finalize;
   end adafinal;

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure initialize (Addr : System.Address);
      pragma Import (C, initialize, "__gnat_initialize");

      procedure finalize;
      pragma Import (C, finalize, "__gnat_finalize");

      procedure Ada_Main_Program;
      pragma Import (Ada, Ada_Main_Program, "_ada_test_xml_results");

      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Break_Start;
      Ada_Main_Program;
      Do_Finalize;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   ../mast_analysis/binary_trees.o
   --   ../mast_analysis/list_exceptions.o
   --   ../mast_analysis/indexed_lists.o
   --   ../mast_analysis/hash_lists.o
   --   ../mast_analysis/mast_lex_dfa.o
   --   ../mast_analysis/mast_lex_io.o
   --   ../mast_analysis/mast_parser_error_report.o
   --   ../mast_analysis/mast_parser_goto.o
   --   ../mast_analysis/mast_parser_shift_reduce.o
   --   ./mast_results_lex_dfa.o
   --   ./mast_results_lex_io.o
   --   ./mast_results_parser_error_report.o
   --   ./mast_results_parser_goto.o
   --   ./mast_results_parser_shift_reduce.o
   --   ./mast_xml_parser_extension.o
   --   ../mast_analysis/var_strings.o
   --   ./mast_xml_exceptions.o
   --   ../mast_analysis/mast.o
   --   ../mast_analysis/mast-timers.o
   --   ../mast_analysis/mast-synchronization_parameters.o
   --   ../mast_analysis/mast-scheduling_policies.o
   --   ../mast_analysis/mast-scheduling_parameters.o
   --   ../mast_analysis/named_lists.o
   --   ../mast_analysis/mast-events.o
   --   ../mast_analysis/mast-graphs.o
   --   ../mast_analysis/mast-processing_resources.o
   --   ../mast_analysis/mast-processing_resources-processor.o
   --   ../mast_analysis/mast-schedulers.o
   --   ../mast_analysis/mast-schedulers-primary.o
   --   ../mast_analysis/mast-schedulers-secondary.o
   --   ../mast_analysis/mast-schedulers-adjustment.o
   --   ../mast_analysis/mast-scheduling_servers.o
   --   ../mast_analysis/mast-shared_resources.o
   --   ../mast_analysis/mast-operations.o
   --   ../mast_analysis/mast-drivers.o
   --   ../mast_analysis/mast-graphs-event_handlers.o
   --   ../mast_analysis/mast-processing_resources-network.o
   --   ../mast_analysis/mast-timing_requirements.o
   --   ../mast_analysis/mast-graphs-links.o
   --   ../mast_analysis/mast-results.o
   --   ../mast_analysis/mast-transactions.o
   --   ../mast_analysis/mast-systems.o
   --   ./mast_put_results.o
   --   ./mast_xml_parser.o
   --   ./mast_xml_results_parser.o
   --   ../mast_analysis/symbol_table.o
   --   ../mast_analysis/mast_parser_tokens.o
   --   ../mast_analysis/mast-io.o
   --   ../mast_analysis/mast_lex.o
   --   ../mast_analysis/mast_parser.o
   --   ./mast_results_parser_tokens.o
   --   ./mast_results_lex.o
   --   ./mast_results_parser.o
   --   ./test_xml_results.o
   --   -L./
   --   -L../mast_analysis/
   --   -L../utils/
   --   -L/home/mgh/gnat/xmlada/lib/xmlada/static/
   --   -L/home/mgh/gnat-2009/lib/gcc/i686-pc-linux-gnu/4.3.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
