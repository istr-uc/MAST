pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__mast_xml_convert_results.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__mast_xml_convert_results.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E062 : Short_Integer; pragma Import (Ada, E062, "system__os_lib_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "ada__exceptions_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "system__soft_links_E");
   E012 : Short_Integer; pragma Import (Ada, E012, "system__exception_table_E");
   E037 : Short_Integer; pragma Import (Ada, E037, "ada__containers_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__io_exceptions_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "ada__numerics_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "ada__strings_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "ada__strings__maps_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "ada__strings__maps__constants_E");
   E042 : Short_Integer; pragma Import (Ada, E042, "interfaces__c_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E073 : Short_Integer; pragma Import (Ada, E073, "system__object_reader_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "system__dwarf_lines_E");
   E092 : Short_Integer; pragma Import (Ada, E092, "system__soft_links__initialize_E");
   E036 : Short_Integer; pragma Import (Ada, E036, "system__traceback__symbolic_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__strings__utf_encoding_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "ada__tags_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__strings__text_buffers_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "gnat_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__streams_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "system__file_control_block_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "system__finalization_root_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "ada__finalization_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "system__file_io_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "system__storage_pools_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "system__finalization_masters_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "system__storage_pools__subpools_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "ada__strings__unbounded_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "ada__calendar_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__text_io_E");
   E349 : Short_Integer; pragma Import (Ada, E349, "ada__text_io__text_streams_E");
   E395 : Short_Integer; pragma Import (Ada, E395, "gnat__directory_operations_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "system__pool_global_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "system__regexp_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "ada__directories_E");
   E316 : Short_Integer; pragma Import (Ada, E316, "unicode_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "binary_trees_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "list_exceptions_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "hash_lists_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "indexed_lists_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "mast_lex_dfa_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "mast_lex_io_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "mast_parser_error_report_E");
   E298 : Short_Integer; pragma Import (Ada, E298, "mast_results_lex_dfa_E");
   E300 : Short_Integer; pragma Import (Ada, E300, "mast_results_lex_io_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "mast_results_parser_error_report_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "sax__htable_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "sax__pointers_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "unicode__ccs_E");
   E353 : Short_Integer; pragma Import (Ada, E353, "unicode__ccs__iso_8859_1_E");
   E355 : Short_Integer; pragma Import (Ada, E355, "unicode__ccs__iso_8859_15_E");
   E360 : Short_Integer; pragma Import (Ada, E360, "unicode__ccs__iso_8859_2_E");
   E363 : Short_Integer; pragma Import (Ada, E363, "unicode__ccs__iso_8859_3_E");
   E365 : Short_Integer; pragma Import (Ada, E365, "unicode__ccs__iso_8859_4_E");
   E367 : Short_Integer; pragma Import (Ada, E367, "unicode__ccs__windows_1251_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "unicode__ccs__windows_1252_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "unicode__ces_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "sax__symbols_E");
   E393 : Short_Integer; pragma Import (Ada, E393, "sax__locators_E");
   E391 : Short_Integer; pragma Import (Ada, E391, "sax__exceptions_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "unicode__ces__utf32_E");
   E375 : Short_Integer; pragma Import (Ada, E375, "unicode__ces__basic_8bit_E");
   E377 : Short_Integer; pragma Import (Ada, E377, "unicode__ces__utf16_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "unicode__ces__utf8_E");
   E389 : Short_Integer; pragma Import (Ada, E389, "sax__models_E");
   E387 : Short_Integer; pragma Import (Ada, E387, "sax__attributes_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "sax__utils_E");
   E312 : Short_Integer; pragma Import (Ada, E312, "dom__core_E");
   E351 : Short_Integer; pragma Import (Ada, E351, "unicode__encodings_E");
   E347 : Short_Integer; pragma Import (Ada, E347, "dom__core__nodes_E");
   E345 : Short_Integer; pragma Import (Ada, E345, "dom__core__attrs_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "dom__core__character_datas_E");
   E379 : Short_Integer; pragma Import (Ada, E379, "dom__core__documents_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "dom__core__elements_E");
   E400 : Short_Integer; pragma Import (Ada, E400, "input_sources_E");
   E402 : Short_Integer; pragma Import (Ada, E402, "input_sources__file_E");
   E404 : Short_Integer; pragma Import (Ada, E404, "input_sources__strings_E");
   E398 : Short_Integer; pragma Import (Ada, E398, "sax__readers_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "dom__readers_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "var_strings_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "mast_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "mast_xml_exceptions_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "named_lists_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "symbol_table_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "mast_parser_tokens_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "mast__io_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "mast__scheduling_parameters_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "mast__scheduling_policies_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "mast__synchronization_parameters_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "mast__events_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "mast__graphs_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "mast__results_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "mast__processing_resources_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "mast__schedulers_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "mast__scheduling_servers_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "mast__schedulers__adjustment_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "mast__schedulers__secondary_E");
   E258 : Short_Integer; pragma Import (Ada, E258, "mast__shared_resources_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "mast__operations_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "mast__drivers_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "mast__graphs__event_handlers_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "mast__processing_resources__network_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "mast__timers_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "mast__processing_resources__processor_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "mast__timing_requirements_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "mast__graphs__links_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "mast__transactions_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "mast__systems_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "mast__schedulers__primary_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "mast__xmi_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "mast_lex_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "mast_results_parser_tokens_E");
   E296 : Short_Integer; pragma Import (Ada, E296, "mast_results_lex_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "mast_xml_parser_E");
   E408 : Short_Integer; pragma Import (Ada, E408, "mast_xml_results_parser_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E220 := E220 - 1;
      E234 := E234 - 1;
      E254 := E254 - 1;
      E166 := E166 - 1;
      E258 := E258 - 1;
      E260 := E260 - 1;
      E266 := E266 - 1;
      E252 := E252 - 1;
      E226 := E226 - 1;
      E246 := E246 - 1;
      E262 := E262 - 1;
      E256 := E256 - 1;
      E222 := E222 - 1;
      E218 := E218 - 1;
      E264 := E264 - 1;
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
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__transactions__finalize_spec");
      begin
         F3;
      end;
      E230 := E230 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__graphs__links__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__timing_requirements__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__processing_resources__processor__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__timers__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__processing_resources__network__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__graphs__event_handlers__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__drivers__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__operations__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__shared_resources__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__secondary__finalize_spec");
      begin
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__scheduling_servers__finalize_spec");
      begin
         F14;
      end;
      E248 := E248 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__schedulers__finalize_spec");
      begin
         F15;
      end;
      E224 := E224 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "mast__processing_resources__finalize_spec");
      begin
         F16;
      end;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__results__finalize_spec");
      begin
         F17;
      end;
      E170 := E170 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__graphs__finalize_spec");
      begin
         F18;
      end;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__events__finalize_spec");
      begin
         F19;
      end;
      E242 := E242 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__synchronization_parameters__finalize_spec");
      begin
         F20;
      end;
      E250 := E250 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__scheduling_policies__finalize_spec");
      begin
         F21;
      end;
      E240 := E240 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__scheduling_parameters__finalize_spec");
      begin
         F22;
      end;
      E383 := E383 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "dom__readers__finalize_spec");
      begin
         F23;
      end;
      E398 := E398 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "sax__readers__finalize_spec");
      begin
         F24;
      end;
      E404 := E404 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "input_sources__strings__finalize_spec");
      begin
         F25;
      end;
      E402 := E402 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "input_sources__file__finalize_spec");
      begin
         F26;
      end;
      E400 := E400 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "input_sources__finalize_spec");
      begin
         F27;
      end;
      E312 := E312 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "dom__core__finalize_spec");
      begin
         F28;
      end;
      E343 := E343 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "sax__utils__finalize_spec");
      begin
         F29;
      end;
      E387 := E387 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "sax__attributes__finalize_spec");
      begin
         F30;
      end;
      E391 := E391 - 1;
      declare
         procedure F31;
         pragma Import (Ada, F31, "sax__exceptions__finalize_spec");
      begin
         F31;
      end;
      E335 := E335 - 1;
      declare
         procedure F32;
         pragma Import (Ada, F32, "sax__symbols__finalize_spec");
      begin
         F32;
      end;
      E341 := E341 - 1;
      declare
         procedure F33;
         pragma Import (Ada, F33, "sax__pointers__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "ada__directories__finalize_body");
      begin
         E279 := E279 - 1;
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "ada__directories__finalize_spec");
      begin
         F35;
      end;
      E289 := E289 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "system__regexp__finalize_spec");
      begin
         F36;
      end;
      E206 := E206 - 1;
      declare
         procedure F37;
         pragma Import (Ada, F37, "system__pool_global__finalize_spec");
      begin
         F37;
      end;
      E119 := E119 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "ada__text_io__finalize_spec");
      begin
         F38;
      end;
      E149 := E149 - 1;
      declare
         procedure F39;
         pragma Import (Ada, F39, "ada__strings__unbounded__finalize_spec");
      begin
         F39;
      end;
      E210 := E210 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "system__storage_pools__subpools__finalize_spec");
      begin
         F40;
      end;
      E202 := E202 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "system__finalization_masters__finalize_spec");
      begin
         F41;
      end;
      declare
         procedure F42;
         pragma Import (Ada, F42, "system__file_io__finalize_body");
      begin
         E129 := E129 - 1;
         F42;
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
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

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
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

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

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E012 := E012 + 1;
      Ada.Containers'Elab_Spec;
      E037 := E037 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E057 := E057 + 1;
      Ada.Numerics'Elab_Spec;
      E027 := E027 + 1;
      Ada.Strings'Elab_Spec;
      E009 := E009 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E096 := E096 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E099 := E099 + 1;
      Interfaces.C'Elab_Spec;
      E042 := E042 + 1;
      System.Exceptions'Elab_Spec;
      E021 := E021 + 1;
      System.Object_Reader'Elab_Spec;
      E073 := E073 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E049 := E049 + 1;
      System.Os_Lib'Elab_Body;
      E062 := E062 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E092 := E092 + 1;
      E014 := E014 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E036 := E036 + 1;
      E018 := E018 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E105 := E105 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E113 := E113 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E103 := E103 + 1;
      Gnat'Elab_Spec;
      E336 := E336 + 1;
      Ada.Streams'Elab_Spec;
      E121 := E121 + 1;
      System.File_Control_Block'Elab_Spec;
      E133 := E133 + 1;
      System.Finalization_Root'Elab_Spec;
      E132 := E132 + 1;
      Ada.Finalization'Elab_Spec;
      E130 := E130 + 1;
      System.File_Io'Elab_Body;
      E129 := E129 + 1;
      System.Storage_Pools'Elab_Spec;
      E204 := E204 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E202 := E202 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E210 := E210 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E149 := E149 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E177 := E177 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E119 := E119 + 1;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E349 := E349 + 1;
      Gnat.Directory_Operations'Elab_Spec;
      Gnat.Directory_Operations'Elab_Body;
      E395 := E395 + 1;
      System.Pool_Global'Elab_Spec;
      E206 := E206 + 1;
      System.Regexp'Elab_Spec;
      E289 := E289 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E279 := E279 + 1;
      Unicode'Elab_Body;
      E316 := E316 + 1;
      E195 := E195 + 1;
      List_Exceptions'Elab_Spec;
      E173 := E173 + 1;
      E228 := E228 + 1;
      E172 := E172 + 1;
      E273 := E273 + 1;
      mast_lex_io'elab_spec;
      E275 := E275 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E277 := E277 + 1;
      E298 := E298 + 1;
      mast_results_lex_io'elab_spec;
      E300 := E300 + 1;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E303 := E303 + 1;
      E333 := E333 + 1;
      Sax.Pointers'Elab_Spec;
      Sax.Pointers'Elab_Body;
      E341 := E341 + 1;
      Unicode.Ccs'Elab_Spec;
      E329 := E329 + 1;
      E353 := E353 + 1;
      E355 := E355 + 1;
      E360 := E360 + 1;
      E363 := E363 + 1;
      E365 := E365 + 1;
      E367 := E367 + 1;
      E372 := E372 + 1;
      Unicode.Ces'Elab_Spec;
      E325 := E325 + 1;
      Sax.Symbols'Elab_Spec;
      Sax.Symbols'Elab_Body;
      E335 := E335 + 1;
      E393 := E393 + 1;
      Sax.Exceptions'Elab_Spec;
      Sax.Exceptions'Elab_Body;
      E391 := E391 + 1;
      E327 := E327 + 1;
      E375 := E375 + 1;
      E377 := E377 + 1;
      E331 := E331 + 1;
      Sax.Models'Elab_Spec;
      E389 := E389 + 1;
      Sax.Attributes'Elab_Spec;
      Sax.Attributes'Elab_Body;
      E387 := E387 + 1;
      Sax.Utils'Elab_Spec;
      Sax.Utils'Elab_Body;
      E343 := E343 + 1;
      DOM.CORE'ELAB_SPEC;
      E312 := E312 + 1;
      E351 := E351 + 1;
      E347 := E347 + 1;
      E345 := E345 + 1;
      E385 := E385 + 1;
      E381 := E381 + 1;
      E379 := E379 + 1;
      Input_Sources'Elab_Spec;
      Input_Sources'Elab_Body;
      E400 := E400 + 1;
      Input_Sources.File'Elab_Spec;
      Input_Sources.File'Elab_Body;
      E402 := E402 + 1;
      Input_Sources.Strings'Elab_Spec;
      Input_Sources.Strings'Elab_Body;
      E404 := E404 + 1;
      Sax.Readers'Elab_Spec;
      Sax.Readers'Elab_Body;
      E398 := E398 + 1;
      DOM.READERS'ELAB_SPEC;
      DOM.READERS'ELAB_BODY;
      E383 := E383 + 1;
      Var_Strings'Elab_Spec;
      E147 := E147 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E135 := E135 + 1;
      Mast_Xml_Exceptions'Elab_Spec;
      Mast_Xml_Exceptions'Elab_Body;
      E307 := E307 + 1;
      E200 := E200 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E198 := E198 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E196 := E196 + 1;
      Mast.Io'Elab_Body;
      E175 := E175 + 1;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Body;
      E240 := E240 + 1;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Body;
      E250 := E250 + 1;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Body;
      E242 := E242 + 1;
      Mast.Events'Elab_Spec;
      Mast.Graphs'Elab_Spec;
      Mast.Graphs'Elab_Body;
      E170 := E170 + 1;
      Mast.Results'Elab_Spec;
      Mast.Processing_Resources'Elab_Spec;
      Mast.Processing_Resources'Elab_Body;
      E224 := E224 + 1;
      Mast.Schedulers'Elab_Spec;
      Mast.Schedulers'Elab_Body;
      E248 := E248 + 1;
      Mast.Scheduling_Servers'Elab_Spec;
      Mast.Schedulers.Secondary'Elab_Spec;
      Mast.Shared_Resources'Elab_Spec;
      Mast.Operations'Elab_Spec;
      Mast.Drivers'Elab_Spec;
      Mast.Graphs.Event_Handlers'Elab_Spec;
      Mast.Processing_Resources.Network'Elab_Spec;
      Mast.Timers'Elab_Spec;
      Mast.Processing_Resources.Processor'Elab_Spec;
      Mast.Timing_Requirements'Elab_Spec;
      Mast.Graphs.Links'Elab_Spec;
      Mast.Graphs.Links'Elab_Body;
      E230 := E230 + 1;
      Mast.Transactions'Elab_Spec;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E268 := E268 + 1;
      Mast.Xmi'Elab_Body;
      E236 := E236 + 1;
      Mast.Drivers'Elab_Body;
      E264 := E264 + 1;
      Mast.Events'Elab_Body;
      E218 := E218 + 1;
      Mast.Graphs.Event_Handlers'Elab_Body;
      E222 := E222 + 1;
      Mast.Operations'Elab_Body;
      E256 := E256 + 1;
      Mast.Processing_Resources.Network'Elab_Body;
      E262 := E262 + 1;
      Mast.Processing_Resources.Processor'Elab_Body;
      E246 := E246 + 1;
      Mast.Results'Elab_Body;
      E226 := E226 + 1;
      Mast.Schedulers.Primary'Elab_Body;
      E252 := E252 + 1;
      Mast.Schedulers.Secondary'Elab_Body;
      E266 := E266 + 1;
      Mast.Scheduling_Servers'Elab_Body;
      E260 := E260 + 1;
      Mast.Shared_Resources'Elab_Body;
      E258 := E258 + 1;
      Mast.Systems'Elab_Body;
      E166 := E166 + 1;
      Mast.Timers'Elab_Body;
      E254 := E254 + 1;
      Mast.Timing_Requirements'Elab_Body;
      E234 := E234 + 1;
      Mast.Transactions'Elab_Body;
      E220 := E220 + 1;
      E271 := E271 + 1;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E301 := E301 + 1;
      E296 := E296 + 1;
      Mast_Xml_Parser'Elab_Spec;
      E309 := E309 + 1;
      E408 := E408 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_mast_xml_convert_results");

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
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/michael/prog/mast/mast_xml/binary_trees.o
   --   /home/michael/prog/mast/mast_xml/list_exceptions.o
   --   /home/michael/prog/mast/mast_xml/hash_lists.o
   --   /home/michael/prog/mast/mast_xml/indexed_lists.o
   --   /home/michael/prog/mast/mast_xml/mast_lex_dfa.o
   --   /home/michael/prog/mast/mast_xml/mast_lex_io.o
   --   /home/michael/prog/mast/mast_xml/mast_parser_error_report.o
   --   /home/michael/prog/mast/mast_xml/mast_parser_goto.o
   --   /home/michael/prog/mast/mast_xml/mast_parser_shift_reduce.o
   --   /home/michael/prog/mast/mast_xml/mast_results_lex_dfa.o
   --   /home/michael/prog/mast/mast_xml/mast_results_lex_io.o
   --   /home/michael/prog/mast/mast_xml/mast_results_parser_error_report.o
   --   /home/michael/prog/mast/mast_xml/mast_results_parser_goto.o
   --   /home/michael/prog/mast/mast_xml/mast_results_parser_shift_reduce.o
   --   /home/michael/prog/mast/mast_xml/var_strings.o
   --   /home/michael/prog/mast/mast_xml/mast.o
   --   /home/michael/prog/mast/mast_xml/mast_xml_exceptions.o
   --   /home/michael/prog/mast/mast_xml/named_lists.o
   --   /home/michael/prog/mast/mast_xml/symbol_table.o
   --   /home/michael/prog/mast/mast_xml/mast_parser_tokens.o
   --   /home/michael/prog/mast/mast_xml/mast-io.o
   --   /home/michael/prog/mast/mast_xml/mast-scheduling_parameters.o
   --   /home/michael/prog/mast/mast_xml/mast-scheduling_policies.o
   --   /home/michael/prog/mast/mast_xml/mast-synchronization_parameters.o
   --   /home/michael/prog/mast/mast_xml/mast-graphs.o
   --   /home/michael/prog/mast/mast_xml/mast-processing_resources.o
   --   /home/michael/prog/mast/mast_xml/mast-schedulers.o
   --   /home/michael/prog/mast/mast_xml/mast-graphs-links.o
   --   /home/michael/prog/mast/mast_xml/mast-schedulers-adjustment.o
   --   /home/michael/prog/mast/mast_xml/mast-xmi.o
   --   /home/michael/prog/mast/mast_xml/mast-drivers.o
   --   /home/michael/prog/mast/mast_xml/mast-events.o
   --   /home/michael/prog/mast/mast_xml/mast-graphs-event_handlers.o
   --   /home/michael/prog/mast/mast_xml/mast-operations.o
   --   /home/michael/prog/mast/mast_xml/mast-processing_resources-network.o
   --   /home/michael/prog/mast/mast_xml/mast-processing_resources-processor.o
   --   /home/michael/prog/mast/mast_xml/mast-results.o
   --   /home/michael/prog/mast/mast_xml/mast-schedulers-primary.o
   --   /home/michael/prog/mast/mast_xml/mast-schedulers-secondary.o
   --   /home/michael/prog/mast/mast_xml/mast-scheduling_servers.o
   --   /home/michael/prog/mast/mast_xml/mast-shared_resources.o
   --   /home/michael/prog/mast/mast_xml/mast-systems.o
   --   /home/michael/prog/mast/mast_xml/mast-timers.o
   --   /home/michael/prog/mast/mast_xml/mast-timing_requirements.o
   --   /home/michael/prog/mast/mast_xml/mast-transactions.o
   --   /home/michael/prog/mast/mast_xml/mast_lex.o
   --   /home/michael/prog/mast/mast_xml/mast_parser.o
   --   /home/michael/prog/mast/mast_xml/mast_results_parser_tokens.o
   --   /home/michael/prog/mast/mast_xml/mast_results_lex.o
   --   /home/michael/prog/mast/mast_xml/mast_results_parser.o
   --   /home/michael/prog/mast/mast_xml/mast_xml_parser.o
   --   /home/michael/prog/mast/mast_xml/mast_xml_results_parser.o
   --   /home/michael/prog/mast/mast_xml/mast_xml_convert_results.o
   --   -L/home/michael/prog/mast/mast_xml/
   --   -L/home/michael/prog/mast/mast_xml/
   --   -L/home/michael/.local/share/alire/builds/xmlada_25.0.0_7f12fe3a/491f4fc1c53e9962115b4d147015304630bb0fe17452e174cc1c07e3972f8d1e/unicode/lib/static/
   --   -L/home/michael/.local/share/alire/builds/xmlada_25.0.0_7f12fe3a/491f4fc1c53e9962115b4d147015304630bb0fe17452e174cc1c07e3972f8d1e/sax/lib/static/
   --   -L/home/michael/.local/share/alire/builds/xmlada_25.0.0_7f12fe3a/491f4fc1c53e9962115b4d147015304630bb0fe17452e174cc1c07e3972f8d1e/input_sources/lib/static/
   --   -L/home/michael/.local/share/alire/builds/xmlada_25.0.0_7f12fe3a/491f4fc1c53e9962115b4d147015304630bb0fe17452e174cc1c07e3972f8d1e/dom/lib/static/
   --   -L/home/michael/.local/share/alire/builds/xmlada_25.0.0_7f12fe3a/491f4fc1c53e9962115b4d147015304630bb0fe17452e174cc1c07e3972f8d1e/schema/lib/static/
   --   -L/home/michael/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/lib/gcc/x86_64-pc-linux-gnu/14.1.0/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
