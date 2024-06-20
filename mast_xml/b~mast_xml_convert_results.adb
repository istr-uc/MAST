pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~mast_xml_convert_results.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~mast_xml_convert_results.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E086 : Short_Integer; pragma Import (Ada, E086, "system__os_lib_E");
   E014 : Short_Integer; pragma Import (Ada, E014, "system__soft_links_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "system__fat_flt_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "system__fat_lflt_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "system__fat_llf_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "system__fat_sflt_E");
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
   E145 : Short_Integer; pragma Import (Ada, E145, "ada__calendar_E");
   E349 : Short_Integer; pragma Import (Ada, E349, "gnat__directory_operations_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "system__pool_global_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "system__file_control_block_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "ada__streams__stream_io_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__file_io_E");
   E018 : Short_Integer; pragma Import (Ada, E018, "system__secondary_stack_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "ada__strings__unbounded_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "system__strings__stream_ops_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__text_io_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "ada__text_io__text_streams_E");
   E270 : Short_Integer; pragma Import (Ada, E270, "unicode_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "binary_trees_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "hash_lists_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "indexed_lists_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "list_exceptions_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "mast_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "mast__scheduling_parameters_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "mast__scheduling_policies_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "mast__synchronization_parameters_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "mast__timers_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "mast_lex_dfa_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "mast_lex_io_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "mast_parser_error_report_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "mast_results_lex_dfa_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "mast_results_lex_io_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "mast_results_parser_error_report_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "mast_xml_exceptions_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "sax__htable_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "sax__pointers_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "unicode__ccs_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "unicode__ccs__iso_8859_1_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "unicode__ccs__iso_8859_15_E");
   E314 : Short_Integer; pragma Import (Ada, E314, "unicode__ccs__iso_8859_2_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "unicode__ccs__iso_8859_3_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "unicode__ccs__iso_8859_4_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "unicode__ccs__windows_1251_E");
   E326 : Short_Integer; pragma Import (Ada, E326, "unicode__ccs__windows_1252_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "unicode__ces_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "sax__symbols_E");
   E347 : Short_Integer; pragma Import (Ada, E347, "sax__locators_E");
   E345 : Short_Integer; pragma Import (Ada, E345, "sax__exceptions_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "sax__models_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "sax__attributes_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "sax__utils_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "dom__core_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "dom__core__documents_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "unicode__ces__utf32_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "unicode__ces__basic_8bit_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "input_sources_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "input_sources__file_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "input_sources__strings_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "sax__readers_E");
   E337 : Short_Integer; pragma Import (Ada, E337, "dom__readers_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "unicode__ces__utf16_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "unicode__ces__utf8_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "unicode__encodings_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "dom__core__nodes_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "dom__core__attrs_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "dom__core__character_datas_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "dom__core__elements_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "var_strings_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "mast__io_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "named_lists_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "mast__events_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "mast__graphs_E");
   E189 : Short_Integer; pragma Import (Ada, E189, "mast__results_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "mast__processing_resources_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "mast__processing_resources__processor_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "mast__schedulers_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "mast__scheduling_servers_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "mast__schedulers__adjustment_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "mast__schedulers__secondary_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "mast__shared_resources_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "mast__operations_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "mast__drivers_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "mast__graphs__event_handlers_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "mast__processing_resources__network_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "mast__timing_requirements_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "mast__graphs__links_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "mast__transactions_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "mast__systems_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "mast__schedulers__primary_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "mast_xml_parser_E");
   E362 : Short_Integer; pragma Import (Ada, E362, "mast_xml_results_parser_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "symbol_table_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "mast_parser_tokens_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "mast_lex_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "mast_results_parser_tokens_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "mast_results_lex_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E203 := E203 - 1;
      E139 := E139 - 1;
      E209 := E209 - 1;
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
      E227 := E227 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__transactions__finalize_spec");
      begin
         F3;
      end;
      E189 := E189 - 1;
      E185 := E185 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__graphs__links__finalize_spec");
      begin
         F4;
      end;
      E197 := E197 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__timing_requirements__finalize_spec");
      begin
         F5;
      end;
      E201 := E201 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__processing_resources__network__finalize_spec");
      begin
         F6;
      end;
      E229 := E229 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__graphs__event_handlers__finalize_spec");
      begin
         F7;
      end;
      E215 := E215 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__drivers__finalize_spec");
      begin
         F8;
      end;
      E217 := E217 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__operations__finalize_spec");
      begin
         F9;
      end;
      E219 := E219 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__shared_resources__finalize_spec");
      begin
         F10;
      end;
      E213 := E213 - 1;
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
      E205 := E205 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__finalize_spec");
      begin
         F13;
      end;
      E223 := E223 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__processing_resources__processor__finalize_spec");
      begin
         F14;
      end;
      E199 := E199 - 1;
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
      E141 := E141 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__graphs__finalize_spec");
      begin
         F17;
      end;
      E177 := E177 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__events__finalize_spec");
      begin
         F18;
      end;
      E193 := E193 - 1;
      E207 := E207 - 1;
      E195 := E195 - 1;
      E225 := E225 - 1;
      E337 := E337 - 1;
      E354 := E354 - 1;
      E297 := E297 - 1;
      E266 := E266 - 1;
      E352 := E352 - 1;
      E356 := E356 - 1;
      E358 := E358 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "dom__readers__finalize_spec");
      begin
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "sax__readers__finalize_spec");
      begin
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "input_sources__strings__finalize_spec");
      begin
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "input_sources__file__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "input_sources__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "dom__core__finalize_spec");
      begin
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "sax__utils__finalize_spec");
      begin
         F25;
      end;
      E341 := E341 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "sax__attributes__finalize_spec");
      begin
         F26;
      end;
      E345 := E345 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "sax__exceptions__finalize_spec");
      begin
         F27;
      end;
      E287 := E287 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "sax__symbols__finalize_spec");
      begin
         F28;
      end;
      E295 := E295 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "sax__pointers__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "mast__timers__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "mast__synchronization_parameters__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "mast__scheduling_policies__finalize_spec");
      begin
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "mast__scheduling_parameters__finalize_spec");
      begin
         F33;
      end;
      E303 := E303 - 1;
      declare
         procedure F34;
         pragma Import (Ada, F34, "ada__text_io__text_streams__finalize_spec");
      begin
         F34;
      end;
      E068 := E068 - 1;
      declare
         procedure F35;
         pragma Import (Ada, F35, "ada__text_io__finalize_spec");
      begin
         F35;
      end;
      E126 := E126 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "ada__strings__unbounded__finalize_spec");
      begin
         F36;
      end;
      E091 := E091 - 1;
      E105 := E105 - 1;
      declare
         procedure F37;
         pragma Import (Ada, F37, "system__file_io__finalize_body");
      begin
         E076 := E076 - 1;
         F37;
      end;
      E181 := E181 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "ada__streams__stream_io__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "system__file_control_block__finalize_spec");
      begin
         E089 := E089 - 1;
         F39;
      end;
      E101 := E101 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "system__pool_global__finalize_spec");
      begin
         F40;
      end;
      declare
         procedure F41;
         pragma Import (Ada, F41, "system__storage_pools__subpools__finalize_spec");
      begin
         F41;
      end;
      declare
         procedure F42;
         pragma Import (Ada, F42, "system__finalization_masters__finalize_spec");
      begin
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
      E158 := E158 + 1;
      System.Fat_Lflt'Elab_Spec;
      E112 := E112 + 1;
      System.Fat_Llf'Elab_Spec;
      E115 := E115 + 1;
      System.Fat_Sflt'Elab_Spec;
      E173 := E173 + 1;
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
      E145 := E145 + 1;
      Gnat.Directory_Operations'Elab_Spec;
      System.Pool_Global'Elab_Spec;
      E101 := E101 + 1;
      System.File_Control_Block'Elab_Spec;
      E089 := E089 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E181 := E181 + 1;
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
      Gnat.Directory_Operations'Elab_Body;
      E349 := E349 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E126 := E126 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E179 := E179 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E068 := E068 + 1;
      Ada.Text_Io.Text_Streams'Elab_Spec;
      E303 := E303 + 1;
      Unicode'Elab_Body;
      E270 := E270 + 1;
      E162 := E162 + 1;
      List_Exceptions'Elab_Spec;
      E166 := E166 + 1;
      E175 := E175 + 1;
      E191 := E191 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      E234 := E234 + 1;
      mast_lex_io'elab_spec;
      E236 := E236 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E239 := E239 + 1;
      E252 := E252 + 1;
      mast_results_lex_io'elab_spec;
      E254 := E254 + 1;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E257 := E257 + 1;
      Mast_Xml_Exceptions'Elab_Spec;
      E293 := E293 + 1;
      Sax.Pointers'Elab_Spec;
      E295 := E295 + 1;
      Unicode.Ccs'Elab_Spec;
      E283 := E283 + 1;
      E307 := E307 + 1;
      Unicode.Ces'Elab_Spec;
      E279 := E279 + 1;
      Sax.Symbols'Elab_Spec;
      E287 := E287 + 1;
      E347 := E347 + 1;
      Sax.Exceptions'Elab_Spec;
      E345 := E345 + 1;
      Sax.Models'Elab_Spec;
      Sax.Attributes'Elab_Spec;
      E341 := E341 + 1;
      Sax.Utils'Elab_Spec;
      DOM.CORE'ELAB_SPEC;
      E281 := E281 + 1;
      E329 := E329 + 1;
      Input_Sources'Elab_Spec;
      Input_Sources.File'Elab_Spec;
      Input_Sources.Strings'Elab_Spec;
      Sax.Readers'Elab_Spec;
      DOM.READERS'ELAB_SPEC;
      E331 := E331 + 1;
      E285 := E285 + 1;
      E358 := E358 + 1;
      E356 := E356 + 1;
      Sax.Readers'Elab_Body;
      E352 := E352 + 1;
      E266 := E266 + 1;
      Sax.Utils'Elab_Body;
      E297 := E297 + 1;
      E343 := E343 + 1;
      E305 := E305 + 1;
      E354 := E354 + 1;
      E301 := E301 + 1;
      E299 := E299 + 1;
      E339 := E339 + 1;
      E335 := E335 + 1;
      E337 := E337 + 1;
      E333 := E333 + 1;
      E309 := E309 + 1;
      E321 := E321 + 1;
      E326 := E326 + 1;
      E319 := E319 + 1;
      E317 := E317 + 1;
      E314 := E314 + 1;
      Var_Strings'Elab_Spec;
      E124 := E124 + 1;
      Mast_Xml_Exceptions'Elab_Body;
      E261 := E261 + 1;
      Mast'Elab_Body;
      E109 := E109 + 1;
      MAST.IO'ELAB_SPEC;
      E225 := E225 + 1;
      E195 := E195 + 1;
      E207 := E207 + 1;
      E193 := E193 + 1;
      E168 := E168 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E177 := E177 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E141 := E141 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E199 := E199 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E223 := E223 + 1;
      Mast.Schedulers'Elab_Spec;
      E205 := E205 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E213 := E213 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E219 := E219 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E217 := E217 + 1;
      Mast.Drivers'Elab_Spec;
      E215 := E215 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E229 := E229 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E201 := E201 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E197 := E197 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E185 := E185 + 1;
      E189 := E189 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E227 := E227 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E209 := E209 + 1;
      E139 := E139 + 1;
      E221 := E221 + 1;
      E203 := E203 + 1;
      Mast_Xml_Parser'Elab_Spec;
      E263 := E263 + 1;
      E362 := E362 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E165 := E165 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E163 := E163 + 1;
      MAST.IO'ELAB_BODY;
      E143 := E143 + 1;
      E232 := E232 + 1;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E255 := E255 + 1;
      E250 := E250 + 1;
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
   --   ../mast_analysis/var_strings.o
   --   ./mast_xml_exceptions.o
   --   ../mast_analysis/mast.o
   --   ./mast-timers.o
   --   ./mast-synchronization_parameters.o
   --   ./mast-scheduling_policies.o
   --   ./mast-scheduling_parameters.o
   --   ../mast_analysis/named_lists.o
   --   ./mast-events.o
   --   ./mast-graphs.o
   --   ../mast_analysis/mast-processing_resources.o
   --   ./mast-processing_resources-processor.o
   --   ./mast-schedulers.o
   --   ./mast-schedulers-secondary.o
   --   ./mast-shared_resources.o
   --   ../mast_analysis/mast-operations.o
   --   ./mast-drivers.o
   --   ./mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ../mast_analysis/mast-timing_requirements.o
   --   ./mast-graphs-links.o
   --   ./mast-results.o
   --   ./mast-transactions.o
   --   ./mast-schedulers-primary.o
   --   ../mast_analysis/mast-systems.o
   --   ./mast-schedulers-adjustment.o
   --   ./mast-scheduling_servers.o
   --   ./mast_xml_parser.o
   --   ./mast_xml_results_parser.o
   --   ../mast_analysis/symbol_table.o
   --   ../mast_analysis/mast_parser_tokens.o
   --   ../mast_analysis/mast-io.o
   --   ../mast_analysis/mast_lex.o
   --   ./mast_parser.o
   --   ./mast_results_parser_tokens.o
   --   ./mast_results_lex.o
   --   ./mast_results_parser.o
   --   ./mast_xml_convert_results.o
   --   -L./
   --   -L../mast_analysis/
   --   -L../utils/
   --   -L/home/mgh/gnat2014/lib/xmlada/static/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
