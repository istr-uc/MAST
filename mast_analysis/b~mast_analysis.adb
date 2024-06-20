pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~mast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~mast_analysis.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E086 : Short_Integer; pragma Import (Ada, E086, "system__os_lib_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "system__soft_links_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "system__fat_flt_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "system__fat_lflt_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "system__fat_llf_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "system__fat_sflt_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__exception_table_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "ada__containers_E");
   E071 : Short_Integer; pragma Import (Ada, E071, "ada__io_exceptions_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "ada__numerics_E");
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
   E164 : Short_Integer; pragma Import (Ada, E164, "ada__calendar_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "ada__calendar__time_zones_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "system__pool_global_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "system__file_control_block_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "ada__streams__stream_io_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__file_io_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "system__random_seed_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "system__secondary_stack_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "ada__strings__unbounded_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "ada__directories_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "system__regexp_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "system__strings__stream_ops_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__text_io_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "binary_trees_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "doubly_linked_lists_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "dynamic_lists_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "hash_lists_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "indexed_lists_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "list_exceptions_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "associations_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "mast_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "mast__annealing_parameters_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "mast__hospa_parameters_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "mast__scheduling_parameters_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "mast__scheduling_policies_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "mast__synchronization_parameters_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "mast__timers_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "mast__tool_exceptions_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "mast_lex_dfa_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "mast_lex_io_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "mast_parser_error_report_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "priority_queues_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "trimmed_image_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "var_strings_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "mast__io_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "named_lists_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "mast__events_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "mast__graphs_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "mast__results_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "mast__processing_resources_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "mast__processing_resources__processor_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "mast__schedulers_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "mast__scheduling_servers_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "mast__schedulers__adjustment_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "mast__schedulers__secondary_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "mast__shared_resources_E");
   E187 : Short_Integer; pragma Import (Ada, E187, "mast__operations_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "mast__drivers_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "mast__graphs__event_handlers_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "mast__processing_resources__network_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "mast__timing_requirements_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "mast__graphs__links_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "mast__transactions_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "mast__systems_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "mast__consistency_checks_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "mast__linear_analysis_tools_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "mast__max_numbers_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "mast__miscelaneous_tools_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "mast__restrictions_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "mast__schedulers__primary_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "mast__tools_E");
   E282 : Short_Integer; pragma Import (Ada, E282, "mast__linear_priority_assignment_tools_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "mast__linear_scheduling_parameters_assignment_tools_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "mast__linear_translation_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "mast__monoprocessor_tools_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "mast__tools__schedulability_index_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "mast__transaction_operations_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "mast__linear_task_analysis_tools_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "symbol_table_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "mast_parser_tokens_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "mast_lex_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E219 := E219 - 1;
      E229 := E229 - 1;
      E227 := E227 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "mast__schedulers__primary__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "mast__systems__finalize_spec");
      begin
         F2;
      end;
      E241 := E241 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__transactions__finalize_spec");
      begin
         F3;
      end;
      E195 := E195 - 1;
      E207 := E207 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__graphs__links__finalize_spec");
      begin
         F4;
      end;
      E209 := E209 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__timing_requirements__finalize_spec");
      begin
         F5;
      end;
      E231 := E231 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__processing_resources__network__finalize_spec");
      begin
         F6;
      end;
      E243 := E243 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__graphs__event_handlers__finalize_spec");
      begin
         F7;
      end;
      E160 := E160 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__drivers__finalize_spec");
      begin
         F8;
      end;
      E187 := E187 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__operations__finalize_spec");
      begin
         F9;
      end;
      E217 := E217 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__shared_resources__finalize_spec");
      begin
         F10;
      end;
      E239 := E239 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__schedulers__secondary__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__scheduling_servers__finalize_spec");
      begin
         F12;
      end;
      E221 := E221 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__finalize_spec");
      begin
         F13;
      end;
      E235 := E235 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__processing_resources__processor__finalize_spec");
      begin
         F14;
      end;
      E223 := E223 - 1;
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
      E197 := E197 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__graphs__finalize_spec");
      begin
         F17;
      end;
      E199 := E199 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__events__finalize_spec");
      begin
         F18;
      end;
      E213 := E213 - 1;
      E225 := E225 - 1;
      E215 := E215 - 1;
      E237 := E237 - 1;
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
      E263 := E263 - 1;
      E273 := E273 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "system__regexp__finalize_spec");
      begin
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "ada__directories__finalize_spec");
      begin
         F25;
      end;
      E129 := E129 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "ada__strings__unbounded__finalize_spec");
      begin
         F26;
      end;
      E091 := E091 - 1;
      E105 := E105 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "system__file_io__finalize_body");
      begin
         E076 := E076 - 1;
         F27;
      end;
      E203 := E203 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "ada__streams__stream_io__finalize_spec");
      begin
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "system__file_control_block__finalize_spec");
      begin
         E089 := E089 - 1;
         F29;
      end;
      E101 := E101 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "system__pool_global__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "system__storage_pools__subpools__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "system__finalization_masters__finalize_spec");
      begin
         F32;
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
      E173 := E173 + 1;
      System.Fat_Lflt'Elab_Spec;
      E115 := E115 + 1;
      System.Fat_Llf'Elab_Spec;
      E118 := E118 + 1;
      System.Fat_Sflt'Elab_Spec;
      E185 := E185 + 1;
      System.Exception_Table'Elab_Body;
      E012 := E012 + 1;
      Ada.Containers'Elab_Spec;
      E254 := E254 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E071 := E071 + 1;
      Ada.Numerics'Elab_Spec;
      E283 := E283 + 1;
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
      E164 := E164 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E267 := E267 + 1;
      System.Pool_Global'Elab_Spec;
      E101 := E101 + 1;
      System.File_Control_Block'Elab_Spec;
      E089 := E089 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E203 := E203 + 1;
      System.Random_Seed'Elab_Body;
      E291 := E291 + 1;
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
      E129 := E129 + 1;
      Ada.Directories'Elab_Spec;
      System.Regexp'Elab_Spec;
      E273 := E273 + 1;
      Ada.Directories'Elab_Body;
      E263 := E263 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E201 := E201 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E068 := E068 + 1;
      E177 := E177 + 1;
      List_Exceptions'Elab_Spec;
      E110 := E110 + 1;
      E193 := E193 + 1;
      E211 := E211 + 1;
      E249 := E249 + 1;
      E158 := E158 + 1;
      E259 := E259 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      Mast.Hospa_Parameters'Elab_Body;
      E247 := E247 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E142 := E142 + 1;
      E331 := E331 + 1;
      mast_lex_io'elab_spec;
      E333 := E333 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E336 := E336 + 1;
      E297 := E297 + 1;
      E277 := E277 + 1;
      Var_Strings'Elab_Spec;
      E127 := E127 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E144 := E144 + 1;
      Mast'Elab_Body;
      E112 := E112 + 1;
      MAST.IO'ELAB_SPEC;
      E237 := E237 + 1;
      E215 := E215 + 1;
      E225 := E225 + 1;
      E213 := E213 + 1;
      E182 := E182 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E199 := E199 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E197 := E197 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E223 := E223 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E235 := E235 + 1;
      Mast.Schedulers'Elab_Spec;
      E221 := E221 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E239 := E239 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E217 := E217 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E187 := E187 + 1;
      Mast.Drivers'Elab_Spec;
      E160 := E160 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E243 := E243 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E231 := E231 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E209 := E209 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E207 := E207 + 1;
      E195 := E195 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E241 := E241 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E227 := E227 + 1;
      E229 := E229 + 1;
      E233 := E233 + 1;
      E219 := E219 + 1;
      MAST.TOOLS.SCHEDULABILITY_INDEX'ELAB_SPEC;
      E295 := E295 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E245 := E245 + 1;
      E323 := E323 + 1;
      E275 := E275 + 1;
      E305 := E305 + 1;
      E282 := E282 + 1;
      MAST.RESTRICTIONS'ELAB_BODY;
      E325 := E325 + 1;
      MAST.MISCELANEOUS_TOOLS'ELAB_BODY;
      E253 := E253 + 1;
      E293 := E293 + 1;
      E261 := E261 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E156 := E156 + 1;
      E321 := E321 + 1;
      E279 := E279 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E180 := E180 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E178 := E178 + 1;
      MAST.IO'ELAB_BODY;
      E162 := E162 + 1;
      E329 := E329 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_mast_analysis");

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
   --   ./trimmed_image.o
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
   --   ./mast-schedulers-secondary.o
   --   ./mast-shared_resources.o
   --   ./mast-operations.o
   --   ./mast-drivers.o
   --   ./mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ./mast-timing_requirements.o
   --   ./mast-graphs-links.o
   --   ./mast-results.o
   --   ./mast-transactions.o
   --   ./mast-schedulers-primary.o
   --   ./mast-systems.o
   --   ./mast-schedulers-adjustment.o
   --   ./mast-scheduling_servers.o
   --   ./mast-tools-schedulability_index.o
   --   ./mast-transaction_operations.o
   --   ./mast-monoprocessor_tools.o
   --   ./mast-linear_translation.o
   --   ./mast-linear_scheduling_parameters_assignment_tools.o
   --   ./mast-linear_priority_assignment_tools.o
   --   ./mast-restrictions.o
   --   ./mast-miscelaneous_tools.o
   --   ./mast-max_numbers.o
   --   ./mast-linear_analysis_tools.o
   --   ./mast-consistency_checks.o
   --   ./mast-linear_task_analysis_tools.o
   --   ./mast-tools.o
   --   ./symbol_table.o
   --   ./mast_parser_tokens.o
   --   ./mast-io.o
   --   ./mast_lex.o
   --   ./mast_parser.o
   --   ./mast_analysis.o
   --   -L./
   --   -L../utils/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
