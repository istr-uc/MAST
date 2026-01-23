pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__to_mast2.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__to_mast2.adb");
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
   E206 : Short_Integer; pragma Import (Ada, E206, "system__storage_pools_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "system__finalization_masters_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "system__storage_pools__subpools_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "ada__strings__unbounded_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "ada__calendar_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__text_io_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "system__pool_global_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "binary_trees_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "list_exceptions_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "doubly_linked_lists_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "hash_lists_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "indexed_lists_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "mast_lex_dfa_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "mast_lex_io_E");
   E296 : Short_Integer; pragma Import (Ada, E296, "mast_parser_error_report_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "var_strings_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "mast_E");
   E286 : Short_Integer; pragma Import (Ada, E286, "mast__tool_exceptions_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "named_lists_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "symbol_table_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "mast_parser_tokens_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "mast__io_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "mast__events_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "mast__graphs_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "mast__scheduling_parameters_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "mast__scheduling_policies_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "mast__synchronization_parameters_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "mast__results_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "mast__timing_requirements_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "mast__graphs__links_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "mast__processing_resources_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "mast__schedulers_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "mast__shared_resources_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "mast__operations_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "mast__schedulers__primary_E");
   E258 : Short_Integer; pragma Import (Ada, E258, "mast__scheduling_servers_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "mast__drivers_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "mast__processing_resources__network_E");
   E270 : Short_Integer; pragma Import (Ada, E270, "mast__schedulers__secondary_E");
   E276 : Short_Integer; pragma Import (Ada, E276, "mast__timers_E");
   E274 : Short_Integer; pragma Import (Ada, E274, "mast__processing_resources__processor_E");
   E272 : Short_Integer; pragma Import (Ada, E272, "mast__graphs__event_handlers_E");
   E284 : Short_Integer; pragma Import (Ada, E284, "mast__schedulers__adjustment_E");
   E280 : Short_Integer; pragma Import (Ada, E280, "mast__transactions_E");
   E282 : Short_Integer; pragma Import (Ada, E282, "mast__systems_E");
   E278 : Short_Integer; pragma Import (Ada, E278, "mast__transaction_operations_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "mast__consistency_checks_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "mast_lex_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E282 := E282 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "mast__systems__finalize_spec");
      begin
         F1;
      end;
      E280 := E280 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "mast__transactions__finalize_spec");
      begin
         F2;
      end;
      E272 := E272 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__graphs__event_handlers__finalize_spec");
      begin
         F3;
      end;
      E274 := E274 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__processing_resources__processor__finalize_spec");
      begin
         F4;
      end;
      E276 := E276 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__timers__finalize_spec");
      begin
         F5;
      end;
      E258 := E258 - 1;
      E270 := E270 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__schedulers__secondary__finalize_spec");
      begin
         F6;
      end;
      E268 := E268 - 1;
      E262 := E262 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__processing_resources__network__finalize_spec");
      begin
         F7;
      end;
      E164 := E164 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__drivers__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__scheduling_servers__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__schedulers__primary__finalize_spec");
      begin
         F10;
      end;
      E232 := E232 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__operations__finalize_spec");
      begin
         F11;
      end;
      E256 := E256 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__shared_resources__finalize_spec");
      begin
         F12;
      end;
      E264 := E264 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__finalize_spec");
      begin
         F13;
      end;
      E260 := E260 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__processing_resources__finalize_spec");
      begin
         F14;
      end;
      E238 := E238 - 1;
      E248 := E248 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__graphs__links__finalize_spec");
      begin
         F15;
      end;
      E250 := E250 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "mast__timing_requirements__finalize_spec");
      begin
         F16;
      end;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__results__finalize_spec");
      begin
         F17;
      end;
      E254 := E254 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__synchronization_parameters__finalize_spec");
      begin
         F18;
      end;
      E266 := E266 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__scheduling_policies__finalize_spec");
      begin
         F19;
      end;
      E252 := E252 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__scheduling_parameters__finalize_spec");
      begin
         F20;
      end;
      E242 := E242 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__graphs__finalize_spec");
      begin
         F21;
      end;
      E244 := E244 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__events__finalize_spec");
      begin
         F22;
      end;
      E208 := E208 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "system__pool_global__finalize_spec");
      begin
         F23;
      end;
      E119 := E119 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "ada__text_io__finalize_spec");
      begin
         F24;
      end;
      E142 := E142 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "ada__strings__unbounded__finalize_spec");
      begin
         F25;
      end;
      E212 := E212 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "system__storage_pools__subpools__finalize_spec");
      begin
         F26;
      end;
      E204 := E204 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "system__finalization_masters__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "system__file_io__finalize_body");
      begin
         E129 := E129 - 1;
         F28;
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
      E206 := E206 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E204 := E204 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E212 := E212 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E142 := E142 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E170 := E170 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E119 := E119 + 1;
      System.Pool_Global'Elab_Spec;
      E208 := E208 + 1;
      E197 := E197 + 1;
      List_Exceptions'Elab_Spec;
      E162 := E162 + 1;
      E161 := E161 + 1;
      E240 := E240 + 1;
      E166 := E166 + 1;
      E291 := E291 + 1;
      mast_lex_io'elab_spec;
      E293 := E293 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E296 := E296 + 1;
      Var_Strings'Elab_Spec;
      E140 := E140 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E137 := E137 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E286 := E286 + 1;
      E202 := E202 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E200 := E200 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E198 := E198 + 1;
      MAST.IO'ELAB_BODY;
      E168 := E168 + 1;
      MAST.EVENTS'ELAB_SPEC;
      MAST.EVENTS'ELAB_BODY;
      E244 := E244 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      MAST.GRAPHS'ELAB_BODY;
      E242 := E242 + 1;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Body;
      E252 := E252 + 1;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Body;
      E266 := E266 + 1;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Body;
      E254 := E254 + 1;
      MAST.RESULTS'ELAB_SPEC;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      MAST.TIMING_REQUIREMENTS'ELAB_BODY;
      E250 := E250 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      MAST.GRAPHS.LINKS'ELAB_BODY;
      E248 := E248 + 1;
      MAST.RESULTS'ELAB_BODY;
      E238 := E238 + 1;
      Mast.Processing_Resources'Elab_Spec;
      Mast.Processing_Resources'Elab_Body;
      E260 := E260 + 1;
      Mast.Schedulers'Elab_Spec;
      Mast.Schedulers'Elab_Body;
      E264 := E264 + 1;
      Mast.Shared_Resources'Elab_Spec;
      Mast.Shared_Resources'Elab_Body;
      E256 := E256 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      MAST.OPERATIONS'ELAB_BODY;
      E232 := E232 + 1;
      Mast.Schedulers.Primary'Elab_Spec;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Drivers'Elab_Spec;
      Mast.Drivers'Elab_Body;
      E164 := E164 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      Mast.Processing_Resources.Network'Elab_Body;
      E262 := E262 + 1;
      Mast.Schedulers.Primary'Elab_Body;
      E268 := E268 + 1;
      Mast.Schedulers.Secondary'Elab_Spec;
      Mast.Schedulers.Secondary'Elab_Body;
      E270 := E270 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_BODY;
      E258 := E258 + 1;
      Mast.Timers'Elab_Spec;
      Mast.Timers'Elab_Body;
      E276 := E276 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      Mast.Processing_Resources.Processor'Elab_Body;
      E274 := E274 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_BODY;
      E272 := E272 + 1;
      E284 := E284 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      MAST.TRANSACTIONS'ELAB_BODY;
      E280 := E280 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Systems'Elab_Body;
      E282 := E282 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E278 := E278 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E159 := E159 + 1;
      E289 := E289 + 1;
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
   --   /home/michael/prog/mast/to_mast2/binary_trees.o
   --   /home/michael/prog/mast/to_mast2/list_exceptions.o
   --   /home/michael/prog/mast/to_mast2/doubly_linked_lists.o
   --   /home/michael/prog/mast/to_mast2/hash_lists.o
   --   /home/michael/prog/mast/to_mast2/indexed_lists.o
   --   /home/michael/prog/mast/to_mast2/mast_lex_dfa.o
   --   /home/michael/prog/mast/to_mast2/mast_lex_io.o
   --   /home/michael/prog/mast/to_mast2/mast_parser_error_report.o
   --   /home/michael/prog/mast/to_mast2/mast_parser_goto.o
   --   /home/michael/prog/mast/to_mast2/mast_parser_shift_reduce.o
   --   /home/michael/prog/mast/to_mast2/to_mast2_help.o
   --   /home/michael/prog/mast/to_mast2/var_strings.o
   --   /home/michael/prog/mast/to_mast2/mast.o
   --   /home/michael/prog/mast/to_mast2/mast-tool_exceptions.o
   --   /home/michael/prog/mast/to_mast2/named_lists.o
   --   /home/michael/prog/mast/to_mast2/symbol_table.o
   --   /home/michael/prog/mast/to_mast2/mast_parser_tokens.o
   --   /home/michael/prog/mast/to_mast2/mast-io.o
   --   /home/michael/prog/mast/to_mast2/mast-events.o
   --   /home/michael/prog/mast/to_mast2/mast-graphs.o
   --   /home/michael/prog/mast/to_mast2/mast-scheduling_parameters.o
   --   /home/michael/prog/mast/to_mast2/mast-scheduling_policies.o
   --   /home/michael/prog/mast/to_mast2/mast-synchronization_parameters.o
   --   /home/michael/prog/mast/to_mast2/mast-timing_requirements.o
   --   /home/michael/prog/mast/to_mast2/mast-graphs-links.o
   --   /home/michael/prog/mast/to_mast2/mast-results.o
   --   /home/michael/prog/mast/to_mast2/mast-processing_resources.o
   --   /home/michael/prog/mast/to_mast2/mast-schedulers.o
   --   /home/michael/prog/mast/to_mast2/mast-shared_resources.o
   --   /home/michael/prog/mast/to_mast2/mast-operations.o
   --   /home/michael/prog/mast/to_mast2/mast-drivers.o
   --   /home/michael/prog/mast/to_mast2/mast-processing_resources-network.o
   --   /home/michael/prog/mast/to_mast2/mast-schedulers-primary.o
   --   /home/michael/prog/mast/to_mast2/mast-schedulers-secondary.o
   --   /home/michael/prog/mast/to_mast2/mast-scheduling_servers.o
   --   /home/michael/prog/mast/to_mast2/mast-timers.o
   --   /home/michael/prog/mast/to_mast2/mast-processing_resources-processor.o
   --   /home/michael/prog/mast/to_mast2/mast-graphs-event_handlers.o
   --   /home/michael/prog/mast/to_mast2/mast-schedulers-adjustment.o
   --   /home/michael/prog/mast/to_mast2/mast-transactions.o
   --   /home/michael/prog/mast/to_mast2/mast-systems.o
   --   /home/michael/prog/mast/to_mast2/mast-transaction_operations.o
   --   /home/michael/prog/mast/to_mast2/mast-consistency_checks.o
   --   /home/michael/prog/mast/to_mast2/mast_lex.o
   --   /home/michael/prog/mast/to_mast2/mast_parser.o
   --   /home/michael/prog/mast/to_mast2/to_mast2.o
   --   -L/home/michael/prog/mast/to_mast2/
   --   -L/home/michael/prog/mast/to_mast2/
   --   -L/home/michael/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/lib/gcc/x86_64-pc-linux-gnu/14.1.0/adalib/
   --   -static
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
