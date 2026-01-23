pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~mast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~mast_analysis.adb");

with System.Restrictions;

package body ada_main is
   pragma Warnings (Off);

   procedure Do_Finalize;
   pragma Import (C, Do_Finalize, "system__standard_library__adafinal");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   procedure adainit is
      E018 : Boolean; pragma Import (Ada, E018, "system__soft_links_E");
      E012 : Boolean; pragma Import (Ada, E012, "system__exception_table_E");
      E080 : Boolean; pragma Import (Ada, E080, "ada__io_exceptions_E");
      E262 : Boolean; pragma Import (Ada, E262, "ada__numerics_E");
      E009 : Boolean; pragma Import (Ada, E009, "ada__strings_E");
      E048 : Boolean; pragma Import (Ada, E048, "ada__strings__maps_E");
      E051 : Boolean; pragma Import (Ada, E051, "ada__strings__maps__constants_E");
      E055 : Boolean; pragma Import (Ada, E055, "ada__tags_E");
      E064 : Boolean; pragma Import (Ada, E064, "ada__streams_E");
      E082 : Boolean; pragma Import (Ada, E082, "interfaces__c_E");
      E084 : Boolean; pragma Import (Ada, E084, "interfaces__c__strings_E");
      E145 : Boolean; pragma Import (Ada, E145, "ada__calendar_E");
      E266 : Boolean; pragma Import (Ada, E266, "system__random_numbers_E");
      E022 : Boolean; pragma Import (Ada, E022, "system__secondary_stack_E");
      E073 : Boolean; pragma Import (Ada, E073, "system__finalization_root_E");
      E075 : Boolean; pragma Import (Ada, E075, "system__finalization_implementation_E");
      E071 : Boolean; pragma Import (Ada, E071, "ada__finalization_E");
      E112 : Boolean; pragma Import (Ada, E112, "ada__strings__unbounded_E");
      E094 : Boolean; pragma Import (Ada, E094, "ada__finalization__list_controller_E");
      E092 : Boolean; pragma Import (Ada, E092, "system__file_control_block_E");
      E191 : Boolean; pragma Import (Ada, E191, "ada__streams__stream_io_E");
      E069 : Boolean; pragma Import (Ada, E069, "system__file_io_E");
      E089 : Boolean; pragma Import (Ada, E089, "system__os_lib_E");
      E063 : Boolean; pragma Import (Ada, E063, "ada__text_io_E");
      E163 : Boolean; pragma Import (Ada, E163, "binary_trees_E");
      E139 : Boolean; pragma Import (Ada, E139, "doubly_linked_lists_E");
      E237 : Boolean; pragma Import (Ada, E237, "dynamic_lists_E");
      E199 : Boolean; pragma Import (Ada, E199, "hash_lists_E");
      E181 : Boolean; pragma Import (Ada, E181, "indexed_lists_E");
      E097 : Boolean; pragma Import (Ada, E097, "list_exceptions_E");
      E241 : Boolean; pragma Import (Ada, E241, "associations_E");
      E099 : Boolean; pragma Import (Ada, E099, "mast_E");
      E110 : Boolean; pragma Import (Ada, E110, "mast__annealing_parameters_E");
      E235 : Boolean; pragma Import (Ada, E235, "mast__hospa_parameters_E");
      E201 : Boolean; pragma Import (Ada, E201, "mast__scheduling_parameters_E");
      E213 : Boolean; pragma Import (Ada, E213, "mast__scheduling_policies_E");
      E203 : Boolean; pragma Import (Ada, E203, "mast__synchronization_parameters_E");
      E225 : Boolean; pragma Import (Ada, E225, "mast__timers_E");
      E118 : Boolean; pragma Import (Ada, E118, "mast__tool_exceptions_E");
      E299 : Boolean; pragma Import (Ada, E299, "mast_lex_dfa_E");
      E301 : Boolean; pragma Import (Ada, E301, "mast_lex_io_E");
      E304 : Boolean; pragma Import (Ada, E304, "mast_parser_error_report_E");
      E274 : Boolean; pragma Import (Ada, E274, "priority_queues_E");
      E102 : Boolean; pragma Import (Ada, E102, "var_strings_E");
      E143 : Boolean; pragma Import (Ada, E143, "mast__io_E");
      E168 : Boolean; pragma Import (Ada, E168, "named_lists_E");
      E187 : Boolean; pragma Import (Ada, E187, "mast__events_E");
      E185 : Boolean; pragma Import (Ada, E185, "mast__graphs_E");
      E183 : Boolean; pragma Import (Ada, E183, "mast__results_E");
      E211 : Boolean; pragma Import (Ada, E211, "mast__processing_resources_E");
      E223 : Boolean; pragma Import (Ada, E223, "mast__processing_resources__processor_E");
      E209 : Boolean; pragma Import (Ada, E209, "mast__schedulers_E");
      E215 : Boolean; pragma Import (Ada, E215, "mast__schedulers__primary_E");
      E207 : Boolean; pragma Import (Ada, E207, "mast__scheduling_servers_E");
      E233 : Boolean; pragma Import (Ada, E233, "mast__schedulers__adjustment_E");
      E217 : Boolean; pragma Import (Ada, E217, "mast__schedulers__secondary_E");
      E205 : Boolean; pragma Import (Ada, E205, "mast__shared_resources_E");
      E175 : Boolean; pragma Import (Ada, E175, "mast__operations_E");
      E141 : Boolean; pragma Import (Ada, E141, "mast__drivers_E");
      E219 : Boolean; pragma Import (Ada, E219, "mast__graphs__event_handlers_E");
      E221 : Boolean; pragma Import (Ada, E221, "mast__processing_resources__network_E");
      E197 : Boolean; pragma Import (Ada, E197, "mast__timing_requirements_E");
      E195 : Boolean; pragma Import (Ada, E195, "mast__graphs__links_E");
      E229 : Boolean; pragma Import (Ada, E229, "mast__transactions_E");
      E231 : Boolean; pragma Import (Ada, E231, "mast__systems_E");
      E137 : Boolean; pragma Import (Ada, E137, "mast__consistency_checks_E");
      E243 : Boolean; pragma Import (Ada, E243, "mast__linear_analysis_tools_E");
      E270 : Boolean; pragma Import (Ada, E270, "mast__max_numbers_E");
      E239 : Boolean; pragma Import (Ada, E239, "mast__miscelaneous_tools_E");
      E293 : Boolean; pragma Import (Ada, E293, "mast__restrictions_E");
      E247 : Boolean; pragma Import (Ada, E247, "mast__tools_E");
      E249 : Boolean; pragma Import (Ada, E249, "mast__linear_deadline_assignment_tools_E");
      E268 : Boolean; pragma Import (Ada, E268, "mast__linear_global_deadline_assignment_tools_E");
      E284 : Boolean; pragma Import (Ada, E284, "mast__linear_local_deadline_assignment_tools_E");
      E286 : Boolean; pragma Import (Ada, E286, "mast__linear_priority_assignment_tools_E");
      E245 : Boolean; pragma Import (Ada, E245, "mast__linear_translation_E");
      E291 : Boolean; pragma Import (Ada, E291, "mast__monoprocessor_tools_E");
      E272 : Boolean; pragma Import (Ada, E272, "mast__tools__schedulability_index_E");
      E227 : Boolean; pragma Import (Ada, E227, "mast__transaction_operations_E");
      E166 : Boolean; pragma Import (Ada, E166, "symbol_table_E");
      E164 : Boolean; pragma Import (Ada, E164, "mast_parser_tokens_E");
      E297 : Boolean; pragma Import (Ada, E297, "mast_lex_E");

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
           False, False, True, False, True, False, False, True, 
           False, False, True, False, True, False, True, True, 
           False, True, False, True, False, False, False, False, 
           False, False, True, True, True, False, False, True, 
           False, True, True, False, True, True, False, False, 
           False, False, False, True, False, False),
         Count => (0, 0, 0, 0, 3, 0, 0),
         Unknown => (False, False, False, False, True, False, False));
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

      System.Exception_Table'Elab_Body;
      E012 := True;
      Ada.Io_Exceptions'Elab_Spec;
      E080 := True;
      Ada.Numerics'Elab_Spec;
      E262 := True;
      Ada.Strings'Elab_Spec;
      E009 := True;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E051 := True;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E064 := True;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E145 := True;
      E084 := True;
      E082 := True;
      Ada.Tags'Elab_Body;
      E055 := True;
      E048 := True;
      System.Soft_Links'Elab_Body;
      E018 := True;
      System.Secondary_Stack'Elab_Body;
      E022 := True;
      System.Random_Numbers'Elab_Body;
      E266 := True;
      System.Finalization_Root'Elab_Spec;
      E073 := True;
      System.Finalization_Implementation'Elab_Spec;
      System.Finalization_Implementation'Elab_Body;
      E075 := True;
      Ada.Finalization'Elab_Spec;
      E071 := True;
      Ada.Strings.Unbounded'Elab_Spec;
      E112 := True;
      Ada.Finalization.List_Controller'Elab_Spec;
      E094 := True;
      System.File_Control_Block'Elab_Spec;
      E092 := True;
      Ada.Streams.Stream_Io'Elab_Spec;
      E191 := True;
      System.Os_Lib'Elab_Body;
      E089 := True;
      System.File_Io'Elab_Body;
      E069 := True;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E063 := True;
      E163 := True;
      List_Exceptions'Elab_Spec;
      E097 := True;
      E181 := True;
      E199 := True;
      E237 := True;
      E139 := True;
      E241 := True;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      Mast.Hospa_Parameters'Elab_Body;
      E235 := True;
      Mast.Annealing_Parameters'Elab_Body;
      E110 := True;
      E299 := True;
      mast_lex_io'elab_spec;
      E301 := True;
      Mast_Parser_Error_Report'Elab_Spec;
      E304 := True;
      E274 := True;
      Var_Strings'Elab_Spec;
      E102 := True;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E118 := True;
      Mast'Elab_Body;
      E099 := True;
      E225 := True;
      E203 := True;
      E213 := True;
      E201 := True;
      E168 := True;
      MAST.EVENTS'ELAB_SPEC;
      E187 := True;
      MAST.GRAPHS'ELAB_SPEC;
      E185 := True;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E211 := True;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E223 := True;
      Mast.Schedulers'Elab_Spec;
      E209 := True;
      Mast.Schedulers.Primary'Elab_Spec;
      E215 := True;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E217 := True;
      E233 := True;
      E207 := True;
      Mast.Shared_Resources'Elab_Spec;
      E205 := True;
      MAST.OPERATIONS'ELAB_SPEC;
      E175 := True;
      Mast.Drivers'Elab_Spec;
      E141 := True;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E219 := True;
      Mast.Processing_Resources.Network'Elab_Spec;
      E221 := True;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E197 := True;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E195 := True;
      E183 := True;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E229 := True;
      Mast.Systems'Elab_Spec;
      E231 := True;
      E270 := True;
      E247 := True;
      MAST.TOOLS.SCHEDULABILITY_INDEX'ELAB_SPEC;
      E272 := True;
      E249 := True;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E227 := True;
      E291 := True;
      E245 := True;
      E286 := True;
      E284 := True;
      E268 := True;
      MAST.RESTRICTIONS'ELAB_BODY;
      E293 := True;
      MAST.MISCELANEOUS_TOOLS'ELAB_BODY;
      E239 := True;
      E243 := True;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E137 := True;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E166 := True;
      Mast_Parser_Tokens'Elab_Spec;
      E164 := True;
      MAST.IO'ELAB_BODY;
      E143 := True;
      E297 := True;
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
      pragma Import (Ada, Ada_Main_Program, "_ada_mast_analysis");

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
   --   ./mast_analysis_help.o
   --   ./binary_trees.o
   --   ./list_exceptions.o
   --   ./indexed_lists.o
   --   ./hash_lists.o
   --   ./dynamic_lists.o
   --   ./doubly_linked_lists.o
   --   ./associations.o
   --   ./mast-hospa_parameters.o
   --   ./mast-annealing_parameters.o
   --   ./mast_lex_dfa.o
   --   ./mast_lex_io.o
   --   ./mast_parser_error_report.o
   --   ./mast_parser_goto.o
   --   ./mast_parser_shift_reduce.o
   --   ./priority_queues.o
   --   ./var_strings.o
   --   ./mast-tool_exceptions.o
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
   --   ./mast-max_numbers.o
   --   ./mast-tools.o
   --   ./mast-tools-schedulability_index.o
   --   ./mast-linear_deadline_assignment_tools.o
   --   ./mast-transaction_operations.o
   --   ./mast-monoprocessor_tools.o
   --   ./mast-linear_translation.o
   --   ./mast-linear_priority_assignment_tools.o
   --   ./mast-linear_local_deadline_assignment_tools.o
   --   ./mast-linear_global_deadline_assignment_tools.o
   --   ./mast-restrictions.o
   --   ./mast-miscelaneous_tools.o
   --   ./mast-linear_analysis_tools.o
   --   ./mast-consistency_checks.o
   --   ./symbol_table.o
   --   ./mast_parser_tokens.o
   --   ./mast-io.o
   --   ./mast_lex.o
   --   ./mast_parser.o
   --   ./mast_analysis.o
   --   -L./
   --   -L../utils/
   --   -L/home/mgh/gnat-gpl-2010/lib/gcc/i686-pc-linux-gnu/4.3.6/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
