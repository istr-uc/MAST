pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__mast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__mast_analysis.adb");
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
   E134 : Short_Integer; pragma Import (Ada, E134, "gnat_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__streams_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "system__file_control_block_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "system__finalization_root_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "ada__finalization_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "system__file_io_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "system__storage_pools_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "system__finalization_masters_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "system__storage_pools__subpools_E");
   E153 : Short_Integer; pragma Import (Ada, E153, "ada__strings__unbounded_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "ada__calendar_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__text_io_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "system__pool_global_E");
   E330 : Short_Integer; pragma Import (Ada, E330, "system__random_seed_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "system__regexp_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "ada__directories_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "binary_trees_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "list_exceptions_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "doubly_linked_lists_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "dynamic_lists_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "associations_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "hash_lists_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "indexed_lists_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "mast_lex_dfa_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "mast_lex_io_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "mast_parser_error_report_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "priority_queues_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "var_strings_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "mast_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "mast__tool_exceptions_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "mast__annealing_parameters_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "mast__hospa_parameters_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "named_lists_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "symbol_table_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "mast_parser_tokens_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "mast__io_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "mast__scheduling_parameters_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "mast__scheduling_policies_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "mast__synchronization_parameters_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "mast__events_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "mast__graphs_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "mast__results_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "mast__processing_resources_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "mast__schedulers_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "mast__scheduling_servers_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "mast__schedulers__adjustment_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "mast__schedulers__secondary_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "mast__shared_resources_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "mast__operations_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "mast__drivers_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "mast__graphs__event_handlers_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "mast__processing_resources__network_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "mast__timers_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "mast__processing_resources__processor_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "mast__timing_requirements_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "mast__graphs__links_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "mast__transactions_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "mast__systems_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "mast__schedulers__primary_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "mast__xmi_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "mast__transaction_operations_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "mast__consistency_checks_E");
   E332 : Short_Integer; pragma Import (Ada, E332, "mast__max_numbers_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "mast_lex_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "trimmed_image_E");
   E294 : Short_Integer; pragma Import (Ada, E294, "mast__miscelaneous_tools_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "mast__restrictions_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "mast__tools_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "mast__linear_priority_assignment_tools_E");
   E340 : Short_Integer; pragma Import (Ada, E340, "mast__linear_scheduling_parameters_assignment_tools_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "mast__linear_translation_E");
   E342 : Short_Integer; pragma Import (Ada, E342, "mast__linear_task_analysis_tools_E");
   E344 : Short_Integer; pragma Import (Ada, E344, "mast__monoprocessor_tools_E");
   E334 : Short_Integer; pragma Import (Ada, E334, "mast__tools__schedulability_index_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E245 := E245 - 1;
      E257 := E257 - 1;
      E275 := E275 - 1;
      E239 := E239 - 1;
      E285 := E285 - 1;
      E277 := E277 - 1;
      E281 := E281 - 1;
      E273 := E273 - 1;
      E251 := E251 - 1;
      E267 := E267 - 1;
      E279 := E279 - 1;
      E233 := E233 - 1;
      E247 := E247 - 1;
      E243 := E243 - 1;
      E186 := E186 - 1;
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
      E253 := E253 - 1;
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
      E269 := E269 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__schedulers__finalize_spec");
      begin
         F15;
      end;
      E249 := E249 - 1;
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
      E241 := E241 - 1;
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
      E263 := E263 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__synchronization_parameters__finalize_spec");
      begin
         F20;
      end;
      E271 := E271 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__scheduling_policies__finalize_spec");
      begin
         F21;
      end;
      E261 := E261 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__scheduling_parameters__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "ada__directories__finalize_body");
      begin
         E309 := E309 - 1;
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "ada__directories__finalize_spec");
      begin
         F24;
      end;
      E317 := E317 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "system__regexp__finalize_spec");
      begin
         F25;
      end;
      E223 := E223 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "system__pool_global__finalize_spec");
      begin
         F26;
      end;
      E119 := E119 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "ada__text_io__finalize_spec");
      begin
         F27;
      end;
      E153 := E153 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "ada__strings__unbounded__finalize_spec");
      begin
         F28;
      end;
      E227 := E227 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "system__storage_pools__subpools__finalize_spec");
      begin
         F29;
      end;
      E219 := E219 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "system__finalization_masters__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "system__file_io__finalize_body");
      begin
         E129 := E129 - 1;
         F31;
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
      E134 := E134 + 1;
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
      E221 := E221 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E219 := E219 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E227 := E227 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E153 := E153 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E192 := E192 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E119 := E119 + 1;
      System.Pool_Global'Elab_Spec;
      E223 := E223 + 1;
      System.Random_Seed'Elab_Body;
      E330 := E330 + 1;
      System.Regexp'Elab_Spec;
      E317 := E317 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E309 := E309 + 1;
      E212 := E212 + 1;
      List_Exceptions'Elab_Spec;
      E136 := E136 + 1;
      E184 := E184 + 1;
      E291 := E291 + 1;
      E301 := E301 + 1;
      E237 := E237 + 1;
      E188 := E188 + 1;
      E354 := E354 + 1;
      mast_lex_io'elab_spec;
      E356 := E356 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E358 := E358 + 1;
      E336 := E336 + 1;
      Var_Strings'Elab_Spec;
      E151 := E151 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E138 := E138 + 1;
      Mast.Tool_Exceptions'Elab_Spec;
      Mast.Tool_Exceptions'Elab_Body;
      E171 := E171 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E169 := E169 + 1;
      Mast.Hospa_Parameters'Elab_Body;
      E289 := E289 + 1;
      E217 := E217 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E215 := E215 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E213 := E213 + 1;
      Mast.Io'Elab_Body;
      E190 := E190 + 1;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Body;
      E261 := E261 + 1;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Body;
      E271 := E271 + 1;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Body;
      E263 := E263 + 1;
      Mast.Events'Elab_Spec;
      Mast.Graphs'Elab_Spec;
      Mast.Graphs'Elab_Body;
      E241 := E241 + 1;
      Mast.Results'Elab_Spec;
      Mast.Processing_Resources'Elab_Spec;
      Mast.Processing_Resources'Elab_Body;
      E249 := E249 + 1;
      Mast.Schedulers'Elab_Spec;
      Mast.Schedulers'Elab_Body;
      E269 := E269 + 1;
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
      E253 := E253 + 1;
      Mast.Transactions'Elab_Spec;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E283 := E283 + 1;
      Mast.Xmi'Elab_Body;
      E235 := E235 + 1;
      Mast.Drivers'Elab_Body;
      E186 := E186 + 1;
      Mast.Events'Elab_Body;
      E243 := E243 + 1;
      Mast.Graphs.Event_Handlers'Elab_Body;
      E247 := E247 + 1;
      Mast.Operations'Elab_Body;
      E233 := E233 + 1;
      Mast.Processing_Resources.Network'Elab_Body;
      E279 := E279 + 1;
      Mast.Processing_Resources.Processor'Elab_Body;
      E267 := E267 + 1;
      Mast.Results'Elab_Body;
      E251 := E251 + 1;
      Mast.Schedulers.Primary'Elab_Body;
      E273 := E273 + 1;
      Mast.Schedulers.Secondary'Elab_Body;
      E281 := E281 + 1;
      Mast.Scheduling_Servers'Elab_Body;
      E277 := E277 + 1;
      Mast.Shared_Resources'Elab_Body;
      E285 := E285 + 1;
      Mast.Systems'Elab_Body;
      E239 := E239 + 1;
      Mast.Timers'Elab_Body;
      E275 := E275 + 1;
      Mast.Timing_Requirements'Elab_Body;
      E257 := E257 + 1;
      Mast.Transactions'Elab_Body;
      E245 := E245 + 1;
      Mast.Transaction_Operations'Elab_Spec;
      E287 := E287 + 1;
      Mast.Consistency_Checks'Elab_Body;
      E179 := E179 + 1;
      E332 := E332 + 1;
      E352 := E352 + 1;
      E305 := E305 + 1;
      E303 := E303 + 1;
      E342 := E342 + 1;
      Mast.Miscelaneous_Tools'Elab_Body;
      E294 := E294 + 1;
      E346 := E346 + 1;
      E307 := E307 + 1;
      Mast.Tools.Schedulability_Index'Elab_Spec;
      E334 := E334 + 1;
      E319 := E319 + 1;
      E340 := E340 + 1;
      E344 := E344 + 1;
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
   --   /home/michael/prog/mast/mast_analysis/binary_trees.o
   --   /home/michael/prog/mast/mast_analysis/list_exceptions.o
   --   /home/michael/prog/mast/mast_analysis/doubly_linked_lists.o
   --   /home/michael/prog/mast/mast_analysis/dynamic_lists.o
   --   /home/michael/prog/mast/mast_analysis/associations.o
   --   /home/michael/prog/mast/mast_analysis/hash_lists.o
   --   /home/michael/prog/mast/mast_analysis/indexed_lists.o
   --   /home/michael/prog/mast/mast_analysis/mast_analysis_help.o
   --   /home/michael/prog/mast/mast_analysis/mast_lex_dfa.o
   --   /home/michael/prog/mast/mast_analysis/mast_lex_io.o
   --   /home/michael/prog/mast/mast_analysis/mast_parser_error_report.o
   --   /home/michael/prog/mast/mast_analysis/mast_parser_goto.o
   --   /home/michael/prog/mast/mast_analysis/mast_parser_shift_reduce.o
   --   /home/michael/prog/mast/mast_analysis/priority_queues.o
   --   /home/michael/prog/mast/mast_analysis/var_strings.o
   --   /home/michael/prog/mast/mast_analysis/mast.o
   --   /home/michael/prog/mast/mast_analysis/mast-tool_exceptions.o
   --   /home/michael/prog/mast/mast_analysis/mast-annealing_parameters.o
   --   /home/michael/prog/mast/mast_analysis/mast-hospa_parameters.o
   --   /home/michael/prog/mast/mast_analysis/named_lists.o
   --   /home/michael/prog/mast/mast_analysis/symbol_table.o
   --   /home/michael/prog/mast/mast_analysis/mast_parser_tokens.o
   --   /home/michael/prog/mast/mast_analysis/mast-io.o
   --   /home/michael/prog/mast/mast_analysis/mast-scheduling_parameters.o
   --   /home/michael/prog/mast/mast_analysis/mast-scheduling_policies.o
   --   /home/michael/prog/mast/mast_analysis/mast-synchronization_parameters.o
   --   /home/michael/prog/mast/mast_analysis/mast-graphs.o
   --   /home/michael/prog/mast/mast_analysis/mast-processing_resources.o
   --   /home/michael/prog/mast/mast_analysis/mast-schedulers.o
   --   /home/michael/prog/mast/mast_analysis/mast-graphs-links.o
   --   /home/michael/prog/mast/mast_analysis/mast-schedulers-adjustment.o
   --   /home/michael/prog/mast/mast_analysis/mast-xmi.o
   --   /home/michael/prog/mast/mast_analysis/mast-drivers.o
   --   /home/michael/prog/mast/mast_analysis/mast-events.o
   --   /home/michael/prog/mast/mast_analysis/mast-graphs-event_handlers.o
   --   /home/michael/prog/mast/mast_analysis/mast-operations.o
   --   /home/michael/prog/mast/mast_analysis/mast-processing_resources-network.o
   --   /home/michael/prog/mast/mast_analysis/mast-processing_resources-processor.o
   --   /home/michael/prog/mast/mast_analysis/mast-results.o
   --   /home/michael/prog/mast/mast_analysis/mast-schedulers-primary.o
   --   /home/michael/prog/mast/mast_analysis/mast-schedulers-secondary.o
   --   /home/michael/prog/mast/mast_analysis/mast-scheduling_servers.o
   --   /home/michael/prog/mast/mast_analysis/mast-shared_resources.o
   --   /home/michael/prog/mast/mast_analysis/mast-systems.o
   --   /home/michael/prog/mast/mast_analysis/mast-timers.o
   --   /home/michael/prog/mast/mast_analysis/mast-timing_requirements.o
   --   /home/michael/prog/mast/mast_analysis/mast-transactions.o
   --   /home/michael/prog/mast/mast_analysis/mast-transaction_operations.o
   --   /home/michael/prog/mast/mast_analysis/mast-consistency_checks.o
   --   /home/michael/prog/mast/mast_analysis/mast-max_numbers.o
   --   /home/michael/prog/mast/mast_analysis/mast_lex.o
   --   /home/michael/prog/mast/mast_analysis/mast_parser.o
   --   /home/michael/prog/mast/mast_analysis/trimmed_image.o
   --   /home/michael/prog/mast/mast_analysis/mast-linear_translation.o
   --   /home/michael/prog/mast/mast_analysis/mast-linear_task_analysis_tools.o
   --   /home/michael/prog/mast/mast_analysis/mast-miscelaneous_tools.o
   --   /home/michael/prog/mast/mast_analysis/mast-restrictions.o
   --   /home/michael/prog/mast/mast_analysis/mast-tools.o
   --   /home/michael/prog/mast/mast_analysis/mast-tools-schedulability_index.o
   --   /home/michael/prog/mast/mast_analysis/mast-linear_priority_assignment_tools.o
   --   /home/michael/prog/mast/mast_analysis/mast-linear_scheduling_parameters_assignment_tools.o
   --   /home/michael/prog/mast/mast_analysis/mast-monoprocessor_tools.o
   --   /home/michael/prog/mast/mast_analysis/mast_analysis.o
   --   -L/home/michael/prog/mast/mast_analysis/
   --   -L/home/michael/prog/mast/mast_analysis/
   --   -L/home/michael/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/lib/gcc/x86_64-pc-linux-gnu/14.1.0/adalib/
   --   -static
   --   -lgnat
   --   -lm
   --   -ldl
--  END Object file/option list   

end ada_main;
