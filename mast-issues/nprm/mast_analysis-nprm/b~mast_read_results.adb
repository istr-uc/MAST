pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~mast_read_results.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~mast_read_results.adb");

with System.Restrictions;

package body ada_main is
   pragma Warnings (Off);

   procedure Do_Finalize;
   pragma Import (C, Do_Finalize, "system__standard_library__adafinal");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   procedure adainit is
      E009 : Boolean; pragma Import (Ada, E009, "system__secondary_stack_E");
      E013 : Boolean; pragma Import (Ada, E013, "system__soft_links_E");
      E019 : Boolean; pragma Import (Ada, E019, "system__exception_table_E");
      E108 : Boolean; pragma Import (Ada, E108, "ada__calendar_E");
      E070 : Boolean; pragma Import (Ada, E070, "ada__io_exceptions_E");
      E089 : Boolean; pragma Import (Ada, E089, "ada__strings_E");
      E048 : Boolean; pragma Import (Ada, E048, "ada__tags_E");
      E046 : Boolean; pragma Import (Ada, E046, "ada__streams_E");
      E072 : Boolean; pragma Import (Ada, E072, "interfaces__c_E");
      E063 : Boolean; pragma Import (Ada, E063, "system__finalization_root_E");
      E074 : Boolean; pragma Import (Ada, E074, "system__os_lib_E");
      E091 : Boolean; pragma Import (Ada, E091, "ada__strings__maps_E");
      E094 : Boolean; pragma Import (Ada, E094, "ada__strings__maps__constants_E");
      E065 : Boolean; pragma Import (Ada, E065, "system__finalization_implementation_E");
      E061 : Boolean; pragma Import (Ada, E061, "ada__finalization_E");
      E079 : Boolean; pragma Import (Ada, E079, "ada__finalization__list_controller_E");
      E077 : Boolean; pragma Import (Ada, E077, "system__file_control_block_E");
      E162 : Boolean; pragma Import (Ada, E162, "ada__streams__stream_io_E");
      E059 : Boolean; pragma Import (Ada, E059, "system__file_io_E");
      E045 : Boolean; pragma Import (Ada, E045, "ada__text_io_E");
      E135 : Boolean; pragma Import (Ada, E135, "binary_trees_E");
      E170 : Boolean; pragma Import (Ada, E170, "hash_lists_E");
      E156 : Boolean; pragma Import (Ada, E156, "indexed_lists_E");
      E139 : Boolean; pragma Import (Ada, E139, "list_exceptions_E");
      E081 : Boolean; pragma Import (Ada, E081, "mast_E");
      E172 : Boolean; pragma Import (Ada, E172, "mast__scheduling_parameters_E");
      E182 : Boolean; pragma Import (Ada, E182, "mast__scheduling_policies_E");
      E174 : Boolean; pragma Import (Ada, E174, "mast__synchronization_parameters_E");
      E200 : Boolean; pragma Import (Ada, E200, "mast__timers_E");
      E209 : Boolean; pragma Import (Ada, E209, "mast_lex_dfa_E");
      E211 : Boolean; pragma Import (Ada, E211, "mast_lex_io_E");
      E214 : Boolean; pragma Import (Ada, E214, "mast_parser_error_report_E");
      E227 : Boolean; pragma Import (Ada, E227, "mast_results_lex_dfa_E");
      E229 : Boolean; pragma Import (Ada, E229, "mast_results_lex_io_E");
      E232 : Boolean; pragma Import (Ada, E232, "mast_results_parser_error_report_E");
      E084 : Boolean; pragma Import (Ada, E084, "var_strings_E");
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
      E138 : Boolean; pragma Import (Ada, E138, "symbol_table_E");
      E136 : Boolean; pragma Import (Ada, E136, "mast_parser_tokens_E");
      E207 : Boolean; pragma Import (Ada, E207, "mast_lex_E");
      E230 : Boolean; pragma Import (Ada, E230, "mast_results_parser_tokens_E");
      E225 : Boolean; pragma Import (Ada, E225, "mast_results_lex_E");

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
           True, False, True, True, True, True, True, True, 
           False, False, True, False, True, False, False, False, 
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
      E013 := True;
      System.Secondary_Stack'Elab_Body;
      E009 := True;
      System.Exception_Table'Elab_Body;
      E019 := True;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E108 := True;
      Ada.Io_Exceptions'Elab_Spec;
      E070 := True;
      Ada.Strings'Elab_Spec;
      E089 := True;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E046 := True;
      Interfaces.C'Elab_Spec;
      E072 := True;
      System.Finalization_Root'Elab_Spec;
      E063 := True;
      System.Os_Lib'Elab_Body;
      E074 := True;
      Ada.Strings.Maps'Elab_Spec;
      E091 := True;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E094 := True;
      System.Finalization_Implementation'Elab_Spec;
      System.Finalization_Implementation'Elab_Body;
      E065 := True;
      Ada.Finalization'Elab_Spec;
      E061 := True;
      Ada.Finalization.List_Controller'Elab_Spec;
      E079 := True;
      System.File_Control_Block'Elab_Spec;
      E077 := True;
      Ada.Streams.Stream_Io'Elab_Spec;
      System.File_Io'Elab_Body;
      E059 := True;
      E162 := True;
      Ada.Tags'Elab_Body;
      E048 := True;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E045 := True;
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
      E227 := True;
      mast_results_lex_io'elab_spec;
      E229 := True;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E232 := True;
      Var_Strings'Elab_Spec;
      E084 := True;
      Mast'Elab_Body;
      E081 := True;
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
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E138 := True;
      Mast_Parser_Tokens'Elab_Spec;
      E136 := True;
      MAST.IO'ELAB_BODY;
      E106 := True;
      E207 := True;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E230 := True;
      E225 := True;
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
      pragma Import (Ada, Ada_Main_Program, "_ada_mast_read_results");

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
   --   ./binary_trees.o
   --   ./list_exceptions.o
   --   ./indexed_lists.o
   --   ./hash_lists.o
   --   ./mast_lex_dfa.o
   --   ./mast_lex_io.o
   --   ./mast_parser_error_report.o
   --   ./mast_parser_goto.o
   --   ./mast_parser_shift_reduce.o
   --   ./mast_results_lex_dfa.o
   --   ./mast_results_lex_io.o
   --   ./mast_results_parser_error_report.o
   --   ./mast_results_parser_goto.o
   --   ./mast_results_parser_shift_reduce.o
   --   ./var_strings.o
   --   ./mast.o
   --   ./mast-timers.o
   --   ./mast-synchronization_parameters.o
   --   ./mast-scheduling_policies.o
   --   ./mast-scheduling_parameters.o
   --   ./named_lists.o
   --   ./mast-events.o
   --   ./mast-graphs.o
   --   ./mast-processing_resources.o
   --   ./mast-processing_resources-processor.o
   --   ./mast-schedulers.o
   --   ./mast-schedulers-primary.o
   --   ./mast-schedulers-secondary.o
   --   ./mast-schedulers-adjustment.o
   --   ./mast-scheduling_servers.o
   --   ./mast-shared_resources.o
   --   ./mast-operations.o
   --   ./mast-drivers.o
   --   ./mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ./mast-timing_requirements.o
   --   ./mast-graphs-links.o
   --   ./mast-results.o
   --   ./mast-transactions.o
   --   ./mast-systems.o
   --   ./symbol_table.o
   --   ./mast_parser_tokens.o
   --   ./mast-io.o
   --   ./mast_lex.o
   --   ./mast_parser.o
   --   ./mast_results_parser_tokens.o
   --   ./mast_results_lex.o
   --   ./mast_results_parser.o
   --   ./mast_read_results.o
   --   -L./
   --   -L../utils/
   --   -L/home/mgh/gnat-2009/lib/gcc/i686-pc-linux-gnu/4.3.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
