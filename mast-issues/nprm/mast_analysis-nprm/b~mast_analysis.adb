pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~mast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~mast_analysis.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E018 : Short_Integer; pragma Import (Ada, E018, "system__soft_links_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "system__fat_flt_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "system__fat_lflt_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "system__fat_llf_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "system__fat_sflt_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__exception_table_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "ada__containers_E");
   E086 : Short_Integer; pragma Import (Ada, E086, "ada__io_exceptions_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "ada__numerics_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "ada__strings_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "ada__strings__maps_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__strings__maps__constants_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__tags_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "ada__streams_E");
   E088 : Short_Integer; pragma Import (Ada, E088, "interfaces__c_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "interfaces__c__strings_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "ada__calendar_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "ada__calendar__time_zones_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "system__random_numbers_E");
   E022 : Short_Integer; pragma Import (Ada, E022, "system__secondary_stack_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "system__finalization_root_E");
   E069 : Short_Integer; pragma Import (Ada, E069, "ada__finalization_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "ada__strings__unbounded_E");
   E080 : Short_Integer; pragma Import (Ada, E080, "system__storage_pools_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "ada__directories_E");
   E067 : Short_Integer; pragma Import (Ada, E067, "ada__finalization__heap_management_E");
   E093 : Short_Integer; pragma Import (Ada, E093, "system__os_lib_E");
   E098 : Short_Integer; pragma Import (Ada, E098, "system__pool_global_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "system__file_control_block_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "ada__streams__stream_io_E");
   E085 : Short_Integer; pragma Import (Ada, E085, "system__file_io_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "system__regexp_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "system__strings__stream_ops_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "ada__text_io_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "ada__text_io__generic_aux_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "binary_trees_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "doubly_linked_lists_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "dynamic_lists_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "hash_lists_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "indexed_lists_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "list_exceptions_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "associations_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "mast_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "mast__annealing_parameters_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "mast__hospa_parameters_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "mast__scheduling_parameters_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "mast__scheduling_policies_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "mast__synchronization_parameters_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "mast__timers_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "mast__tool_exceptions_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "mast_lex_dfa_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "mast_lex_io_E");
   E330 : Short_Integer; pragma Import (Ada, E330, "mast_parser_error_report_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "priority_queues_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "trimmed_image_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "var_strings_E");
   E155 : Short_Integer; pragma Import (Ada, E155, "mast__io_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "named_lists_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "mast__events_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "mast__graphs_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "mast__results_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "mast__processing_resources_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "mast__processing_resources__processor_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "mast__schedulers_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "mast__scheduling_servers_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "mast__schedulers__adjustment_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "mast__schedulers__secondary_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "mast__shared_resources_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "mast__operations_E");
   E153 : Short_Integer; pragma Import (Ada, E153, "mast__drivers_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "mast__graphs__event_handlers_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "mast__processing_resources__network_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "mast__timing_requirements_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "mast__graphs__links_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "mast__transactions_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "mast__systems_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "mast__consistency_checks_E");
   E258 : Short_Integer; pragma Import (Ada, E258, "mast__linear_analysis_tools_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "mast__max_numbers_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "mast__miscelaneous_tools_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "mast__restrictions_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "mast__schedulers__primary_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "mast__tools_E");
   E278 : Short_Integer; pragma Import (Ada, E278, "mast__linear_priority_assignment_tools_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "mast__linear_scheduling_parameters_assignment_tools_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "mast__linear_translation_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "mast__monoprocessor_tools_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "mast__tools__schedulability_index_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "mast__transaction_operations_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "mast__linear_task_analysis_tools_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "symbol_table_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "mast_parser_tokens_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "mast_lex_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
      LE_Set : Boolean;
      pragma Import (Ada, LE_Set, "__gnat_library_exception_set");
   begin
      E175 := E175 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "symbol_table__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "mast__consistency_checks__finalize_body");
      begin
         E149 := E149 - 1;
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__miscelaneous_tools__finalize_body");
      begin
         E250 := E250 - 1;
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__restrictions__finalize_body");
      begin
         E319 := E319 - 1;
         F4;
      end;
      E216 := E216 - 1;
      E226 := E226 - 1;
      E224 := E224 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__schedulers__primary__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__systems__finalize_spec");
      begin
         F6;
      end;
      E238 := E238 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__transactions__finalize_spec");
      begin
         F7;
      end;
      E192 := E192 - 1;
      E204 := E204 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__graphs__links__finalize_spec");
      begin
         F8;
      end;
      E206 := E206 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__timing_requirements__finalize_spec");
      begin
         F9;
      end;
      E228 := E228 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__processing_resources__network__finalize_spec");
      begin
         F10;
      end;
      E240 := E240 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__graphs__event_handlers__finalize_spec");
      begin
         F11;
      end;
      E153 := E153 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__drivers__finalize_spec");
      begin
         F12;
      end;
      E184 := E184 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__operations__finalize_spec");
      begin
         F13;
      end;
      E214 := E214 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__shared_resources__finalize_spec");
      begin
         F14;
      end;
      E236 := E236 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__schedulers__secondary__finalize_spec");
      begin
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "mast__scheduling_servers__finalize_spec");
      begin
         F16;
      end;
      E218 := E218 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__schedulers__finalize_spec");
      begin
         F17;
      end;
      E232 := E232 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__processing_resources__processor__finalize_spec");
      begin
         F18;
      end;
      E220 := E220 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__processing_resources__finalize_spec");
      begin
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__results__finalize_spec");
      begin
         F20;
      end;
      E194 := E194 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__graphs__finalize_spec");
      begin
         F21;
      end;
      E196 := E196 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__events__finalize_spec");
      begin
         F22;
      end;
      E210 := E210 - 1;
      E222 := E222 - 1;
      E212 := E212 - 1;
      E234 := E234 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "mast__timers__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "mast__synchronization_parameters__finalize_spec");
      begin
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "mast__scheduling_policies__finalize_spec");
      begin
         F25;
      end;
      declare
         procedure F26;
         pragma Import (Ada, F26, "mast__scheduling_parameters__finalize_spec");
      begin
         F26;
      end;
      declare
         procedure F27;
         pragma Import (Ada, F27, "ada__text_io__generic_aux__finalize_body");
      begin
         E167 := E167 - 1;
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "ada__text_io__finalize_body");
      begin
         E065 := E065 - 1;
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "ada__text_io__finalize_spec");
      begin
         F29;
      end;
      E260 := E260 - 1;
      E269 := E269 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "system__regexp__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "ada__streams__stream_io__finalize_body");
      begin
         E200 := E200 - 1;
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "system__file_io__finalize_body");
      begin
         E085 := E085 - 1;
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "ada__streams__stream_io__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "system__file_control_block__finalize_spec");
      begin
         E096 := E096 - 1;
         F34;
      end;
      E098 := E098 - 1;
      declare
         procedure F35;
         pragma Import (Ada, F35, "system__pool_global__finalize_spec");
      begin
         F35;
      end;
      E067 := E067 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "ada__finalization__heap_management__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "ada__directories__finalize_spec");
      begin
         F37;
      end;
      E122 := E122 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "ada__strings__unbounded__finalize_spec");
      begin
         F38;
      end;
      E072 := E072 - 1;
      declare
         procedure F39;
         pragma Import (Ada, F39, "system__finalization_root__finalize_spec");
      begin
         F39;
      end;
      if LE_Set then
         declare
            LE : Ada.Exceptions.Exception_Occurrence;
            pragma Import (Ada, LE, "__gnat_library_exception");
            procedure Raise_From_Controlled_Operation (X : Ada.Exceptions.Exception_Occurrence;  From_Abort : Boolean);
            pragma Import (Ada, Raise_From_Controlled_Operation, "__gnat_raise_from_controlled_operation");
         begin
            Raise_From_Controlled_Operation (LE, False);
         end;
      end if;
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
      Zero_Cost_Exceptions := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E168 := E168 + 1;
      System.Fat_Lflt'Elab_Spec;
      E108 := E108 + 1;
      System.Fat_Llf'Elab_Spec;
      E111 := E111 + 1;
      System.Fat_Sflt'Elab_Spec;
      E182 := E182 + 1;
      System.Exception_Table'Elab_Body;
      E012 := E012 + 1;
      Ada.Containers'Elab_Spec;
      E251 := E251 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E086 := E086 + 1;
      Ada.Numerics'Elab_Spec;
      E279 := E279 + 1;
      Ada.Strings'Elab_Spec;
      E009 := E009 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E053 := E053 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E070 := E070 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E157 := E157 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E264 := E264 + 1;
      E090 := E090 + 1;
      E088 := E088 + 1;
      Ada.Tags'Elab_Body;
      E057 := E057 + 1;
      E050 := E050 + 1;
      System.Soft_Links'Elab_Body;
      E018 := E018 + 1;
      System.Secondary_Stack'Elab_Body;
      E022 := E022 + 1;
      System.Random_Numbers'Elab_Body;
      E285 := E285 + 1;
      System.Finalization_Root'Elab_Spec;
      E072 := E072 + 1;
      Ada.Finalization'Elab_Spec;
      E069 := E069 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E122 := E122 + 1;
      System.Storage_Pools'Elab_Spec;
      E080 := E080 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Finalization.Heap_Management'Elab_Spec;
      E067 := E067 + 1;
      System.Os_Lib'Elab_Body;
      E093 := E093 + 1;
      System.Pool_Global'Elab_Spec;
      E098 := E098 + 1;
      System.File_Control_Block'Elab_Spec;
      E096 := E096 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      System.File_Io'Elab_Body;
      E085 := E085 + 1;
      Ada.Streams.Stream_Io'Elab_Body;
      E200 := E200 + 1;
      System.Regexp'Elab_Spec;
      E269 := E269 + 1;
      Ada.Directories'Elab_Body;
      E260 := E260 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E198 := E198 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E065 := E065 + 1;
      Ada.Text_Io.Generic_Aux'Elab_Body;
      E167 := E167 + 1;
      E172 := E172 + 1;
      List_Exceptions'Elab_Spec;
      E103 := E103 + 1;
      E190 := E190 + 1;
      E208 := E208 + 1;
      E246 := E246 + 1;
      E151 := E151 + 1;
      E256 := E256 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      Mast.Hospa_Parameters'Elab_Body;
      E244 := E244 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E135 := E135 + 1;
      E325 := E325 + 1;
      mast_lex_io'elab_spec;
      E327 := E327 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E330 := E330 + 1;
      E291 := E291 + 1;
      E273 := E273 + 1;
      Var_Strings'Elab_Spec;
      E120 := E120 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E137 := E137 + 1;
      Mast'Elab_Body;
      E105 := E105 + 1;
      MAST.IO'ELAB_SPEC;
      E234 := E234 + 1;
      E212 := E212 + 1;
      E222 := E222 + 1;
      E210 := E210 + 1;
      E177 := E177 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E196 := E196 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E194 := E194 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E220 := E220 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E232 := E232 + 1;
      Mast.Schedulers'Elab_Spec;
      E218 := E218 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E236 := E236 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E214 := E214 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E184 := E184 + 1;
      Mast.Drivers'Elab_Spec;
      E153 := E153 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E240 := E240 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E228 := E228 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E206 := E206 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E204 := E204 + 1;
      E192 := E192 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E238 := E238 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E224 := E224 + 1;
      E226 := E226 + 1;
      E230 := E230 + 1;
      E216 := E216 + 1;
      MAST.TOOLS.SCHEDULABILITY_INDEX'ELAB_SPEC;
      E289 := E289 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E242 := E242 + 1;
      E317 := E317 + 1;
      E271 := E271 + 1;
      E299 := E299 + 1;
      E278 := E278 + 1;
      MAST.RESTRICTIONS'ELAB_BODY;
      E319 := E319 + 1;
      MAST.MISCELANEOUS_TOOLS'ELAB_BODY;
      E250 := E250 + 1;
      E287 := E287 + 1;
      E258 := E258 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E149 := E149 + 1;
      E315 := E315 + 1;
      E275 := E275 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E175 := E175 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E173 := E173 + 1;
      MAST.IO'ELAB_BODY;
      E155 := E155 + 1;
      E323 := E323 + 1;
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
   --   .\mast_analysis_help.o
   --   .\binary_trees.o
   --   .\list_exceptions.o
   --   .\indexed_lists.o
   --   .\hash_lists.o
   --   .\dynamic_lists.o
   --   .\doubly_linked_lists.o
   --   .\associations.o
   --   .\mast-hospa_parameters.o
   --   .\mast-annealing_parameters.o
   --   .\mast_lex_dfa.o
   --   .\mast_lex_io.o
   --   .\mast_parser_error_report.o
   --   .\mast_parser_goto.o
   --   .\mast_parser_shift_reduce.o
   --   .\priority_queues.o
   --   .\trimmed_image.o
   --   .\var_strings.o
   --   .\mast-tool_exceptions.o
   --   .\mast.o
   --   .\mast-timers.o
   --   .\mast-synchronization_parameters.o
   --   .\mast-scheduling_policies.o
   --   .\mast-scheduling_parameters.o
   --   .\named_lists.o
   --   .\mast-events.o
   --   .\mast-graphs.o
   --   .\mast-processing_resources.o
   --   .\mast-processing_resources-processor.o
   --   .\mast-schedulers.o
   --   .\mast-schedulers-secondary.o
   --   .\mast-shared_resources.o
   --   .\mast-operations.o
   --   .\mast-drivers.o
   --   .\mast-graphs-event_handlers.o
   --   .\mast-processing_resources-network.o
   --   .\mast-timing_requirements.o
   --   .\mast-graphs-links.o
   --   .\mast-results.o
   --   .\mast-transactions.o
   --   .\mast-schedulers-primary.o
   --   .\mast-systems.o
   --   .\mast-schedulers-adjustment.o
   --   .\mast-scheduling_servers.o
   --   .\mast-tools-schedulability_index.o
   --   .\mast-transaction_operations.o
   --   .\mast-monoprocessor_tools.o
   --   .\mast-linear_translation.o
   --   .\mast-linear_scheduling_parameters_assignment_tools.o
   --   .\mast-linear_priority_assignment_tools.o
   --   .\mast-restrictions.o
   --   .\mast-miscelaneous_tools.o
   --   .\mast-max_numbers.o
   --   .\mast-linear_analysis_tools.o
   --   .\mast-consistency_checks.o
   --   .\mast-linear_task_analysis_tools.o
   --   .\mast-tools.o
   --   .\symbol_table.o
   --   .\mast_parser_tokens.o
   --   .\mast-io.o
   --   .\mast_lex.o
   --   .\mast_parser.o
   --   .\mast_analysis.o
   --   -L.\
   --   -L../utils\
   --   -LC:/GNAT/2011/lib/gcc/i686-pc-mingw32/4.5.3/adalib/
   --   -static
   --   -lgnat
   --   -Wl,--stack=0x2000000
--  END Object file/option list   

end ada_main;
