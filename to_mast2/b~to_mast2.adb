pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~to_mast2.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~to_mast2.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E086 : Short_Integer; pragma Import (Ada, E086, "system__os_lib_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "system__soft_links_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "system__fat_flt_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "system__fat_lflt_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "system__fat_llf_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "system__fat_sflt_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__exception_table_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "ada__io_exceptions_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "ada__strings_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "ada__strings__maps_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "ada__strings__maps__constants_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "ada__tags_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "ada__streams_E");
   E082 : Short_Integer; pragma Import (Ada, E082, "interfaces__c_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "system__exceptions_E");
   E080 : Short_Integer; pragma Import (Ada, E080, "system__finalization_root_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "ada__finalization_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "system__storage_pools_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "system__finalization_masters_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "system__storage_pools__subpools_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "ada__calendar_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "system__pool_global_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "system__file_control_block_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "ada__streams__stream_io_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__file_io_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "system__secondary_stack_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "ada__strings__unbounded_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "system__strings__stream_ops_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__text_io_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "binary_trees_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "doubly_linked_lists_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "hash_lists_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "indexed_lists_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "list_exceptions_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "mast_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "mast__scheduling_parameters_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "mast__scheduling_policies_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "mast__synchronization_parameters_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "mast__timers_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "mast__tool_exceptions_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "mast_lex_dfa_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "mast_lex_io_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "mast_parser_error_report_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "var_strings_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "mast__io_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "named_lists_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "mast__events_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "mast__graphs_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "mast__results_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "mast__processing_resources_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "mast__processing_resources__processor_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "mast__schedulers_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "mast__schedulers__primary_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "mast__scheduling_servers_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "mast__schedulers__adjustment_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "mast__schedulers__secondary_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "mast__shared_resources_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "mast__operations_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "mast__drivers_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "mast__graphs__event_handlers_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "mast__processing_resources__network_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "mast__timing_requirements_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "mast__graphs__links_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "mast__transactions_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "mast__systems_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "mast__consistency_checks_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "mast__transaction_operations_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "symbol_table_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "mast_parser_tokens_E");
   E258 : Short_Integer; pragma Import (Ada, E258, "mast_lex_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E251 := E251 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "mast__systems__finalize_spec");
      begin
         F1;
      end;
      E249 := E249 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "mast__transactions__finalize_spec");
      begin
         F2;
      end;
      E203 := E203 - 1;
      E215 := E215 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__graphs__links__finalize_spec");
      begin
         F3;
      end;
      E217 := E217 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__timing_requirements__finalize_spec");
      begin
         F4;
      end;
      E237 := E237 - 1;
      E227 := E227 - 1;
      E239 := E239 - 1;
      E231 := E231 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__processing_resources__network__finalize_spec");
      begin
         F5;
      end;
      E241 := E241 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__graphs__event_handlers__finalize_spec");
      begin
         F6;
      end;
      E134 := E134 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__drivers__finalize_spec");
      begin
         F7;
      end;
      E195 := E195 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__operations__finalize_spec");
      begin
         F8;
      end;
      E225 := E225 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__shared_resources__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__schedulers__secondary__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__scheduling_servers__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__schedulers__primary__finalize_spec");
      begin
         F12;
      end;
      E233 := E233 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__finalize_spec");
      begin
         F13;
      end;
      E243 := E243 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__processing_resources__processor__finalize_spec");
      begin
         F14;
      end;
      E229 := E229 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__processing_resources__finalize_spec");
      begin
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "mast__results__finalize_spec");
      begin
         F16;
      end;
      E205 := E205 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__graphs__finalize_spec");
      begin
         F17;
      end;
      E207 := E207 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__events__finalize_spec");
      begin
         F18;
      end;
      E221 := E221 - 1;
      E235 := E235 - 1;
      E223 := E223 - 1;
      E245 := E245 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__timers__finalize_spec");
      begin
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__synchronization_parameters__finalize_spec");
      begin
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__scheduling_policies__finalize_spec");
      begin
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__scheduling_parameters__finalize_spec");
      begin
         F22;
      end;
      E068 := E068 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "ada__text_io__finalize_spec");
      begin
         F23;
      end;
      E116 := E116 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "ada__strings__unbounded__finalize_spec");
      begin
         F24;
      end;
      E091 := E091 - 1;
      E105 := E105 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "system__file_io__finalize_body");
      begin
         E076 := E076 - 1;
         F25;
      end;
      E211 := E211 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "ada__streams__stream_io__finalize_spec");
      begin
         F26;
      end;
      declare
         procedure F27;
         pragma Import (Ada, F27, "system__file_control_block__finalize_spec");
      begin
         E089 := E089 - 1;
         F27;
      end;
      E101 := E101 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "system__pool_global__finalize_spec");
      begin
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "system__storage_pools__subpools__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "system__finalization_masters__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
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
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
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

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E161 := E161 + 1;
      System.Fat_Lflt'Elab_Spec;
      E112 := E112 + 1;
      System.Fat_Llf'Elab_Spec;
      E149 := E149 + 1;
      System.Fat_Sflt'Elab_Spec;
      E193 := E193 + 1;
      System.Exception_Table'Elab_Body;
      E012 := E012 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E071 := E071 + 1;
      Ada.Strings'Elab_Spec;
      E009 := E009 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E052 := E052 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E070 := E070 + 1;
      Interfaces.C'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E026 := E026 + 1;
      System.Finalization_Root'Elab_Spec;
      E080 := E080 + 1;
      Ada.Finalization'Elab_Spec;
      E078 := E078 + 1;
      System.Storage_Pools'Elab_Spec;
      E099 := E099 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E138 := E138 + 1;
      System.Pool_Global'Elab_Spec;
      E101 := E101 + 1;
      System.File_Control_Block'Elab_Spec;
      E089 := E089 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E211 := E211 + 1;
      System.File_Io'Elab_Body;
      E076 := E076 + 1;
      E105 := E105 + 1;
      System.Finalization_Masters'Elab_Body;
      E091 := E091 + 1;
      E082 := E082 + 1;
      Ada.Tags'Elab_Body;
      E056 := E056 + 1;
      E048 := E048 + 1;
      System.Soft_Links'Elab_Body;
      E014 := E014 + 1;
      System.Os_Lib'Elab_Body;
      E086 := E086 + 1;
      System.Secondary_Stack'Elab_Body;
      E018 := E018 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E116 := E116 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E209 := E209 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E068 := E068 + 1;
      E183 := E183 + 1;
      List_Exceptions'Elab_Spec;
      E132 := E132 + 1;
      E201 := E201 + 1;
      E219 := E219 + 1;
      E131 := E131 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      E260 := E260 + 1;
      mast_lex_io'elab_spec;
      E262 := E262 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E265 := E265 + 1;
      Var_Strings'Elab_Spec;
      E114 := E114 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E255 := E255 + 1;
      Mast'Elab_Body;
      E111 := E111 + 1;
      MAST.IO'ELAB_SPEC;
      E245 := E245 + 1;
      E223 := E223 + 1;
      E235 := E235 + 1;
      E221 := E221 + 1;
      E188 := E188 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E207 := E207 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E205 := E205 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E229 := E229 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E243 := E243 + 1;
      Mast.Schedulers'Elab_Spec;
      E233 := E233 + 1;
      Mast.Schedulers.Primary'Elab_Spec;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E253 := E253 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E225 := E225 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E195 := E195 + 1;
      Mast.Drivers'Elab_Spec;
      E134 := E134 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E241 := E241 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E231 := E231 + 1;
      E239 := E239 + 1;
      E227 := E227 + 1;
      E237 := E237 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E217 := E217 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E215 := E215 + 1;
      E203 := E203 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E249 := E249 + 1;
      Mast.Systems'Elab_Spec;
      E251 := E251 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E247 := E247 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E129 := E129 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E186 := E186 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E184 := E184 + 1;
      MAST.IO'ELAB_BODY;
      E136 := E136 + 1;
      E258 := E258 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_to_mast2");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   ./to_mast2_help.o
   --   ./binary_trees.o
   --   ./list_exceptions.o
   --   ./indexed_lists.o
   --   ./hash_lists.o
   --   ./doubly_linked_lists.o
   --   ./mast_lex_dfa.o
   --   ./mast_lex_io.o
   --   ./mast_parser_error_report.o
   --   ./mast_parser_goto.o
   --   ./mast_parser_shift_reduce.o
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
   --   ./mast-schedulers-adjustment.o
   --   ./mast-shared_resources.o
   --   ./mast-operations.o
   --   ./mast-drivers.o
   --   ./mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ./mast-schedulers-secondary.o
   --   ./mast-scheduling_servers.o
   --   ./mast-schedulers-primary.o
   --   ./mast-timing_requirements.o
   --   ./mast-graphs-links.o
   --   ./mast-results.o
   --   ./mast-transactions.o
   --   ./mast-systems.o
   --   ./mast-transaction_operations.o
   --   ./mast-consistency_checks.o
   --   ./symbol_table.o
   --   ./mast_parser_tokens.o
   --   ./mast-io.o
   --   ./mast_lex.o
   --   ./mast_parser.o
   --   ./to_mast2.o
   --   -L./
   --   -L../utils/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
