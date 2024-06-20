pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~gmast_pt_editor.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~gmast_pt_editor.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E334 : Short_Integer; pragma Import (Ada, E334, "system__os_lib_E");
   E016 : Short_Integer; pragma Import (Ada, E016, "system__soft_links_E");
   E478 : Short_Integer; pragma Import (Ada, E478, "system__fat_flt_E");
   E462 : Short_Integer; pragma Import (Ada, E462, "system__fat_lflt_E");
   E465 : Short_Integer; pragma Import (Ada, E465, "system__fat_llf_E");
   E489 : Short_Integer; pragma Import (Ada, E489, "system__fat_sflt_E");
   E026 : Short_Integer; pragma Import (Ada, E026, "system__exception_table_E");
   E512 : Short_Integer; pragma Import (Ada, E512, "ada__containers_E");
   E067 : Short_Integer; pragma Import (Ada, E067, "ada__io_exceptions_E");
   E595 : Short_Integer; pragma Import (Ada, E595, "ada__numerics_E");
   E348 : Short_Integer; pragma Import (Ada, E348, "ada__strings_E");
   E350 : Short_Integer; pragma Import (Ada, E350, "ada__strings__maps_E");
   E353 : Short_Integer; pragma Import (Ada, E353, "ada__strings__maps__constants_E");
   E008 : Short_Integer; pragma Import (Ada, E008, "ada__tags_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "ada__streams_E");
   E062 : Short_Integer; pragma Import (Ada, E062, "interfaces__c_E");
   E064 : Short_Integer; pragma Import (Ada, E064, "interfaces__c__strings_E");
   E028 : Short_Integer; pragma Import (Ada, E028, "system__exceptions_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__finalization_root_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "ada__finalization_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "system__storage_pools_E");
   E069 : Short_Integer; pragma Import (Ada, E069, "system__finalization_masters_E");
   E094 : Short_Integer; pragma Import (Ada, E094, "system__storage_pools__subpools_E");
   E398 : Short_Integer; pragma Import (Ada, E398, "ada__calendar_E");
   E406 : Short_Integer; pragma Import (Ada, E406, "ada__calendar__time_zones_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "system__assertions_E");
   E083 : Short_Integer; pragma Import (Ada, E083, "system__pool_global_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "system__file_control_block_E");
   E518 : Short_Integer; pragma Import (Ada, E518, "ada__streams__stream_io_E");
   E330 : Short_Integer; pragma Import (Ada, E330, "system__file_io_E");
   E603 : Short_Integer; pragma Import (Ada, E603, "system__random_seed_E");
   E020 : Short_Integer; pragma Import (Ada, E020, "system__secondary_stack_E");
   E387 : Short_Integer; pragma Import (Ada, E387, "ada__strings__unbounded_E");
   E402 : Short_Integer; pragma Import (Ada, E402, "ada__directories_E");
   E421 : Short_Integer; pragma Import (Ada, E421, "system__regexp_E");
   E516 : Short_Integer; pragma Import (Ada, E516, "system__strings__stream_ops_E");
   E326 : Short_Integer; pragma Import (Ada, E326, "ada__text_io_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "glib_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "gtkada__types_E");
   E480 : Short_Integer; pragma Import (Ada, E480, "binary_trees_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "changes_control_E");
   E425 : Short_Integer; pragma Import (Ada, E425, "check_operations_E");
   E577 : Short_Integer; pragma Import (Ada, E577, "doubly_linked_lists_E");
   E609 : Short_Integer; pragma Import (Ada, E609, "dynamic_lists_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "file_operations_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "gdk__frame_timings_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "glib__glist_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "gdk__visual_E");
   E117 : Short_Integer; pragma Import (Ada, E117, "glib__gslist_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "glib__key_file_E");
   E090 : Short_Integer; pragma Import (Ada, E090, "glib__object_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "glib__string_E");
   E092 : Short_Integer; pragma Import (Ada, E092, "glib__type_conversion_hooks_E");
   E107 : Short_Integer; pragma Import (Ada, E107, "glib__types_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "glib__g_icon_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "glib__values_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "cairo_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "cairo__region_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "gdk__color_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "gdk__rectangle_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "gdk__rgba_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "glib__generic_properties_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "gtk__editable_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "gtkada__c_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "gtkada__bindings_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "gdk__frame_clock_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "gdk__types_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "gdk__event_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "gdk__display_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "gdk__pixbuf_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "glib__properties_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "gdk__screen_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "gdk__device_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "gdk__drag_contexts_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "gdk__window_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "glib__variant_E");
   E369 : Short_Integer; pragma Import (Ada, E369, "glib__menu_model_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "gtk__accel_group_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__actionable_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "gtk__adjustment_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "gtk__builder_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "gtk__buildable_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "gtk__cell_area_context_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "gtk__cell_editable_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "gtk__css_section_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "gtk__entry_buffer_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "gtk__enums_E");
   E505 : Short_Integer; pragma Import (Ada, E505, "gtk__file_filter_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "gtk__icon_source_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "gtk__orientable_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "gtk__paper_size_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "gtk__page_setup_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "gtk__print_settings_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "gtk__scrollable_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "gtk__selection_data_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "gtk__style_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "gtk__target_entry_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "gtk__target_list_E");
   E655 : Short_Integer; pragma Import (Ada, E655, "gtk__clipboard_E");
   E659 : Short_Integer; pragma Import (Ada, E659, "gtk__text_mark_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "gtk__tree_model_E");
   E375 : Short_Integer; pragma Import (Ada, E375, "gtk__tree_drag_dest_E");
   E377 : Short_Integer; pragma Import (Ada, E377, "gtk__tree_drag_source_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gtk__tree_sortable_E");
   E373 : Short_Integer; pragma Import (Ada, E373, "gtk__tree_store_E");
   E538 : Short_Integer; pragma Import (Ada, E538, "hash_lists_E");
   E524 : Short_Integer; pragma Import (Ada, E524, "indexed_lists_E");
   E484 : Short_Integer; pragma Import (Ada, E484, "list_exceptions_E");
   E629 : Short_Integer; pragma Import (Ada, E629, "associations_E");
   E461 : Short_Integer; pragma Import (Ada, E461, "mast_E");
   E459 : Short_Integer; pragma Import (Ada, E459, "global_options_E");
   E605 : Short_Integer; pragma Import (Ada, E605, "mast__annealing_parameters_E");
   E607 : Short_Integer; pragma Import (Ada, E607, "mast__hospa_parameters_E");
   E540 : Short_Integer; pragma Import (Ada, E540, "mast__scheduling_parameters_E");
   E552 : Short_Integer; pragma Import (Ada, E552, "mast__scheduling_policies_E");
   E542 : Short_Integer; pragma Import (Ada, E542, "mast__synchronization_parameters_E");
   E566 : Short_Integer; pragma Import (Ada, E566, "mast__timers_E");
   E583 : Short_Integer; pragma Import (Ada, E583, "mast__tool_exceptions_E");
   E511 : Short_Integer; pragma Import (Ada, E511, "model_operations_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "pango__enums_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "pango__attributes_E");
   E189 : Short_Integer; pragma Import (Ada, E189, "pango__font_metrics_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "pango__language_E");
   E187 : Short_Integer; pragma Import (Ada, E187, "pango__font_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "gtk__text_attributes_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "gtk__text_tag_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "gtk__text_iter_E");
   E661 : Short_Integer; pragma Import (Ada, E661, "gtk__text_tag_table_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "pango__font_face_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "pango__font_family_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "pango__fontset_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "pango__matrix_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "pango__context_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "pango__font_map_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "pango__tabs_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "pango__layout_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "gtk__print_context_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "gtk__print_operation_preview_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "gtk__widget_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__action_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__activatable_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "gtk__cell_renderer_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "gtk__cell_layout_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "gtk__cell_area_E");
   E337 : Short_Integer; pragma Import (Ada, E337, "gtk__cell_renderer_text_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "gtk__container_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "gtk__bin_E");
   E363 : Short_Integer; pragma Import (Ada, E363, "gtk__alignment_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "gtk__box_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "gtk__button_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "gtk__entry_completion_E");
   E503 : Short_Integer; pragma Import (Ada, E503, "gtk__file_chooser_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "gtk__frame_E");
   E645 : Short_Integer; pragma Import (Ada, E645, "gtk__grange_E");
   E509 : Short_Integer; pragma Import (Ada, E509, "gtk__main_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "gtk__marshallers_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "gtk__menu_item_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "gtk__image_menu_item_E");
   E371 : Short_Integer; pragma Import (Ada, E371, "gtk__menu_shell_E");
   E367 : Short_Integer; pragma Import (Ada, E367, "gtk__menu_E");
   E639 : Short_Integer; pragma Import (Ada, E639, "gtk__menu_bar_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "gtk__misc_E");
   E365 : Short_Integer; pragma Import (Ada, E365, "gtk__label_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "gtk__notebook_E");
   E643 : Short_Integer; pragma Import (Ada, E643, "gtk__scrollbar_E");
   E641 : Short_Integer; pragma Import (Ada, E641, "gtk__scrolled_window_E");
   E647 : Short_Integer; pragma Import (Ada, E647, "gtk__separator_E");
   E649 : Short_Integer; pragma Import (Ada, E649, "gtk__separator_menu_item_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "gtk__status_bar_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "gtk__style_provider_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "gtk__style_context_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "gtk__icon_set_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "gtk__image_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "gtk__gentry_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "gtk__spin_button_E");
   E657 : Short_Integer; pragma Import (Ada, E657, "gtk__text_child_anchor_E");
   E653 : Short_Integer; pragma Import (Ada, E653, "gtk__text_buffer_E");
   E663 : Short_Integer; pragma Import (Ada, E663, "gtk__text_view_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "gtk__toggle_button_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "gtk__check_button_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "gtk__radio_button_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "gtk__tooltip_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "gtk__tree_selection_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "gtk__tree_view_column_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "gtk__tree_view_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "gtk__combo_box_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "gtk__combo_box_text_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "gtk__window_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "gtk__dialog_E");
   E359 : Short_Integer; pragma Import (Ada, E359, "dialog1_pkg_E");
   E427 : Short_Integer; pragma Import (Ada, E427, "dialog_3_pkg_E");
   E431 : Short_Integer; pragma Import (Ada, E431, "dialog_yes_no_pkg_E");
   E651 : Short_Integer; pragma Import (Ada, E651, "gtk__about_dialog_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "aboutdialog1_pkg_E");
   E507 : Short_Integer; pragma Import (Ada, E507, "gtk__file_chooser_dialog_E");
   E499 : Short_Integer; pragma Import (Ada, E499, "filechooserdialog1_pkg_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "gtk__print_operation_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "gtk__arguments_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "dialog1_pkg__callbacks_E");
   E429 : Short_Integer; pragma Import (Ada, E429, "dialog_3_pkg__callbacks_E");
   E433 : Short_Integer; pragma Import (Ada, E433, "dialog_yes_no_pkg__callbacks_E");
   E501 : Short_Integer; pragma Import (Ada, E501, "filechooserdialog1_pkg__callbacks_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "callbacks_pt_editor_E");
   E318 : Short_Integer; pragma Import (Ada, E318, "gtkada__handlers_E");
   E615 : Short_Integer; pragma Import (Ada, E615, "priority_queues_E");
   E667 : Short_Integer; pragma Import (Ada, E667, "progress_dialog_pkg_E");
   E320 : Short_Integer; pragma Import (Ada, E320, "pt_editor_intl_E");
   E324 : Short_Integer; pragma Import (Ada, E324, "pt_editor_pkg_E");
   E396 : Short_Integer; pragma Import (Ada, E396, "pt_editor_pkg__callbacks_E");
   E587 : Short_Integer; pragma Import (Ada, E587, "trimmed_image_E");
   E633 : Short_Integer; pragma Import (Ada, E633, "usage_dialog_pkg_E");
   E635 : Short_Integer; pragma Import (Ada, E635, "usage_dialog_pkg__callbacks_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "var_strings_E");
   E473 : Short_Integer; pragma Import (Ada, E473, "mast__io_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "mutex_table_E");
   E486 : Short_Integer; pragma Import (Ada, E486, "named_lists_E");
   E514 : Short_Integer; pragma Import (Ada, E514, "mast__events_E");
   E522 : Short_Integer; pragma Import (Ada, E522, "mast__graphs_E");
   E532 : Short_Integer; pragma Import (Ada, E532, "mast__results_E");
   E550 : Short_Integer; pragma Import (Ada, E550, "mast__processing_resources_E");
   E564 : Short_Integer; pragma Import (Ada, E564, "mast__processing_resources__processor_E");
   E548 : Short_Integer; pragma Import (Ada, E548, "mast__schedulers_E");
   E546 : Short_Integer; pragma Import (Ada, E546, "mast__scheduling_servers_E");
   E562 : Short_Integer; pragma Import (Ada, E562, "mast__schedulers__adjustment_E");
   E568 : Short_Integer; pragma Import (Ada, E568, "mast__schedulers__secondary_E");
   E544 : Short_Integer; pragma Import (Ada, E544, "mast__shared_resources_E");
   E528 : Short_Integer; pragma Import (Ada, E528, "mast__operations_E");
   E560 : Short_Integer; pragma Import (Ada, E560, "mast__drivers_E");
   E526 : Short_Integer; pragma Import (Ada, E526, "mast__graphs__event_handlers_E");
   E558 : Short_Integer; pragma Import (Ada, E558, "mast__processing_resources__network_E");
   E536 : Short_Integer; pragma Import (Ada, E536, "mast__timing_requirements_E");
   E534 : Short_Integer; pragma Import (Ada, E534, "mast__graphs__links_E");
   E570 : Short_Integer; pragma Import (Ada, E570, "mast__transactions_E");
   E556 : Short_Integer; pragma Import (Ada, E556, "mast__systems_E");
   E592 : Short_Integer; pragma Import (Ada, E592, "mast__consistency_checks_E");
   E579 : Short_Integer; pragma Import (Ada, E579, "mast__linear_analysis_tools_E");
   E611 : Short_Integer; pragma Import (Ada, E611, "mast__max_numbers_E");
   E627 : Short_Integer; pragma Import (Ada, E627, "mast__miscelaneous_tools_E");
   E572 : Short_Integer; pragma Import (Ada, E572, "mast__restrictions_E");
   E554 : Short_Integer; pragma Import (Ada, E554, "mast__schedulers__primary_E");
   E589 : Short_Integer; pragma Import (Ada, E589, "mast__tools_E");
   E594 : Short_Integer; pragma Import (Ada, E594, "mast__linear_priority_assignment_tools_E");
   E623 : Short_Integer; pragma Import (Ada, E623, "mast__linear_scheduling_parameters_assignment_tools_E");
   E581 : Short_Integer; pragma Import (Ada, E581, "mast__linear_translation_E");
   E631 : Short_Integer; pragma Import (Ada, E631, "mast__monoprocessor_tools_E");
   E613 : Short_Integer; pragma Import (Ada, E613, "mast__tools__schedulability_index_E");
   E585 : Short_Integer; pragma Import (Ada, E585, "mast__transaction_operations_E");
   E625 : Short_Integer; pragma Import (Ada, E625, "mast__linear_task_analysis_tools_E");
   E471 : Short_Integer; pragma Import (Ada, E471, "results_table_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "symbol_table_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "mast_parser_tokens_E");
   E495 : Short_Integer; pragma Import (Ada, E495, "task_table_E");
   E497 : Short_Integer; pragma Import (Ada, E497, "usage_table_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "model_operations__finalize_body");
      begin
         E511 := E511 - 1;
         F1;
      end;
      E324 := E324 - 1;
      E546 := E546 - 1;
      E556 := E556 - 1;
      E554 := E554 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "mast__schedulers__primary__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__systems__finalize_spec");
      begin
         F3;
      end;
      E570 := E570 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__transactions__finalize_spec");
      begin
         F4;
      end;
      E532 := E532 - 1;
      E534 := E534 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__graphs__links__finalize_spec");
      begin
         F5;
      end;
      E536 := E536 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__timing_requirements__finalize_spec");
      begin
         F6;
      end;
      E558 := E558 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__processing_resources__network__finalize_spec");
      begin
         F7;
      end;
      E526 := E526 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__graphs__event_handlers__finalize_spec");
      begin
         F8;
      end;
      E560 := E560 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__drivers__finalize_spec");
      begin
         F9;
      end;
      E528 := E528 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__operations__finalize_spec");
      begin
         F10;
      end;
      E544 := E544 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__shared_resources__finalize_spec");
      begin
         F11;
      end;
      E568 := E568 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__schedulers__secondary__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__scheduling_servers__finalize_spec");
      begin
         F13;
      end;
      E548 := E548 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__schedulers__finalize_spec");
      begin
         F14;
      end;
      E564 := E564 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast__processing_resources__processor__finalize_spec");
      begin
         F15;
      end;
      E550 := E550 - 1;
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
      E522 := E522 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__graphs__finalize_spec");
      begin
         F18;
      end;
      E514 := E514 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__events__finalize_spec");
      begin
         F19;
      end;
      E540 := E540 - 1;
      E552 := E552 - 1;
      E542 := E542 - 1;
      E566 := E566 - 1;
      E633 := E633 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "usage_dialog_pkg__finalize_spec");
      begin
         F20;
      end;
      E006 := E006 - 1;
      E499 := E499 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "pt_editor_pkg__finalize_spec");
      begin
         F21;
      end;
      E359 := E359 - 1;
      E427 := E427 - 1;
      E431 := E431 - 1;
      E667 := E667 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "progress_dialog_pkg__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "gtkada__handlers__finalize_spec");
      begin
         E318 := E318 - 1;
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "callbacks_pt_editor__finalize_spec");
      begin
         E058 := E058 - 1;
         F24;
      end;
      E170 := E170 - 1;
      E142 := E142 - 1;
      E369 := E369 - 1;
      E176 := E176 - 1;
      E158 := E158 - 1;
      E223 := E223 - 1;
      E180 := E180 - 1;
      E655 := E655 - 1;
      E235 := E235 - 1;
      E661 := E661 - 1;
      E162 := E162 - 1;
      E285 := E285 - 1;
      E233 := E233 - 1;
      E227 := E227 - 1;
      E337 := E337 - 1;
      E156 := E156 - 1;
      E120 := E120 - 1;
      E225 := E225 - 1;
      E645 := E645 - 1;
      E299 := E299 - 1;
      E371 := E371 - 1;
      E367 := E367 - 1;
      E365 := E365 - 1;
      E255 := E255 - 1;
      E641 := E641 - 1;
      E273 := E273 - 1;
      E243 := E243 - 1;
      E215 := E215 - 1;
      E307 := E307 - 1;
      E653 := E653 - 1;
      E663 := E663 - 1;
      E305 := E305 - 1;
      E301 := E301 - 1;
      E315 := E315 - 1;
      E317 := E317 - 1;
      E309 := E309 - 1;
      E383 := E383 - 1;
      E209 := E209 - 1;
      E138 := E138 - 1;
      E651 := E651 - 1;
      E257 := E257 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "gtk__print_operation__finalize_spec");
      begin
         F25;
      end;
      declare
         procedure F26;
         pragma Import (Ada, F26, "filechooserdialog1_pkg__finalize_spec");
      begin
         F26;
      end;
      E507 := E507 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "aboutdialog1_pkg__finalize_spec");
      begin
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "gtk__about_dialog__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "dialog_yes_no_pkg__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "dialog_3_pkg__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "dialog1_pkg__finalize_spec");
      begin
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "gtk__dialog__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "gtk__window__finalize_spec");
      begin
         F34;
      end;
      E381 := E381 - 1;
      declare
         procedure F35;
         pragma Import (Ada, F35, "gtk__combo_box_text__finalize_spec");
      begin
         F35;
      end;
      declare
         procedure F36;
         pragma Import (Ada, F36, "gtk__combo_box__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "gtk__tree_view__finalize_spec");
      begin
         F37;
      end;
      declare
         procedure F38;
         pragma Import (Ada, F38, "gtk__tree_view_column__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "gtk__tree_selection__finalize_spec");
      begin
         F39;
      end;
      E313 := E313 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "gtk__tooltip__finalize_spec");
      begin
         F40;
      end;
      declare
         procedure F41;
         pragma Import (Ada, F41, "gtk__radio_button__finalize_spec");
      begin
         F41;
      end;
      E303 := E303 - 1;
      declare
         procedure F42;
         pragma Import (Ada, F42, "gtk__check_button__finalize_spec");
      begin
         F42;
      end;
      declare
         procedure F43;
         pragma Import (Ada, F43, "gtk__toggle_button__finalize_spec");
      begin
         F43;
      end;
      declare
         procedure F44;
         pragma Import (Ada, F44, "gtk__text_view__finalize_spec");
      begin
         F44;
      end;
      declare
         procedure F45;
         pragma Import (Ada, F45, "gtk__text_buffer__finalize_spec");
      begin
         F45;
      end;
      E657 := E657 - 1;
      declare
         procedure F46;
         pragma Import (Ada, F46, "gtk__text_child_anchor__finalize_spec");
      begin
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "gtk__spin_button__finalize_spec");
      begin
         F47;
      end;
      declare
         procedure F48;
         pragma Import (Ada, F48, "gtk__gentry__finalize_spec");
      begin
         F48;
      end;
      E237 := E237 - 1;
      declare
         procedure F49;
         pragma Import (Ada, F49, "gtk__image__finalize_spec");
      begin
         F49;
      end;
      E239 := E239 - 1;
      declare
         procedure F50;
         pragma Import (Ada, F50, "gtk__icon_set__finalize_spec");
      begin
         F50;
      end;
      declare
         procedure F51;
         pragma Import (Ada, F51, "gtk__style_context__finalize_spec");
      begin
         F51;
      end;
      declare
         procedure F52;
         pragma Import (Ada, F52, "gtk__status_bar__finalize_spec");
      begin
         F52;
      end;
      E649 := E649 - 1;
      declare
         procedure F53;
         pragma Import (Ada, F53, "gtk__separator_menu_item__finalize_spec");
      begin
         F53;
      end;
      E647 := E647 - 1;
      declare
         procedure F54;
         pragma Import (Ada, F54, "gtk__separator__finalize_spec");
      begin
         F54;
      end;
      declare
         procedure F55;
         pragma Import (Ada, F55, "gtk__scrolled_window__finalize_spec");
      begin
         F55;
      end;
      E643 := E643 - 1;
      declare
         procedure F56;
         pragma Import (Ada, F56, "gtk__scrollbar__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "gtk__notebook__finalize_spec");
      begin
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "gtk__label__finalize_spec");
      begin
         F58;
      end;
      E249 := E249 - 1;
      declare
         procedure F59;
         pragma Import (Ada, F59, "gtk__misc__finalize_spec");
      begin
         F59;
      end;
      E639 := E639 - 1;
      declare
         procedure F60;
         pragma Import (Ada, F60, "gtk__menu_bar__finalize_spec");
      begin
         F60;
      end;
      declare
         procedure F61;
         pragma Import (Ada, F61, "gtk__menu__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "gtk__menu_shell__finalize_spec");
      begin
         F62;
      end;
      E297 := E297 - 1;
      declare
         procedure F63;
         pragma Import (Ada, F63, "gtk__image_menu_item__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "gtk__menu_item__finalize_spec");
      begin
         F64;
      end;
      declare
         procedure F65;
         pragma Import (Ada, F65, "gtk__grange__finalize_spec");
      begin
         F65;
      end;
      E339 := E339 - 1;
      declare
         procedure F66;
         pragma Import (Ada, F66, "gtk__frame__finalize_spec");
      begin
         F66;
      end;
      declare
         procedure F67;
         pragma Import (Ada, F67, "gtk__entry_completion__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "gtk__button__finalize_spec");
      begin
         F68;
      end;
      E148 := E148 - 1;
      declare
         procedure F69;
         pragma Import (Ada, F69, "gtk__box__finalize_spec");
      begin
         F69;
      end;
      E363 := E363 - 1;
      declare
         procedure F70;
         pragma Import (Ada, F70, "gtk__alignment__finalize_spec");
      begin
         F70;
      end;
      E213 := E213 - 1;
      declare
         procedure F71;
         pragma Import (Ada, F71, "gtk__bin__finalize_spec");
      begin
         F71;
      end;
      declare
         procedure F72;
         pragma Import (Ada, F72, "gtk__container__finalize_spec");
      begin
         F72;
      end;
      declare
         procedure F73;
         pragma Import (Ada, F73, "gtk__cell_renderer_text__finalize_spec");
      begin
         F73;
      end;
      declare
         procedure F74;
         pragma Import (Ada, F74, "gtk__cell_area__finalize_spec");
      begin
         F74;
      end;
      declare
         procedure F75;
         pragma Import (Ada, F75, "gtk__cell_renderer__finalize_spec");
      begin
         F75;
      end;
      declare
         procedure F76;
         pragma Import (Ada, F76, "gtk__action__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "gtk__widget__finalize_spec");
      begin
         F77;
      end;
      E265 := E265 - 1;
      declare
         procedure F78;
         pragma Import (Ada, F78, "gtk__print_context__finalize_spec");
      begin
         F78;
      end;
      E201 := E201 - 1;
      declare
         procedure F79;
         pragma Import (Ada, F79, "pango__layout__finalize_spec");
      begin
         F79;
      end;
      E205 := E205 - 1;
      declare
         procedure F80;
         pragma Import (Ada, F80, "pango__tabs__finalize_spec");
      begin
         F80;
      end;
      E267 := E267 - 1;
      declare
         procedure F81;
         pragma Import (Ada, F81, "pango__font_map__finalize_spec");
      begin
         F81;
      end;
      E183 := E183 - 1;
      declare
         procedure F82;
         pragma Import (Ada, F82, "pango__context__finalize_spec");
      begin
         F82;
      end;
      E197 := E197 - 1;
      declare
         procedure F83;
         pragma Import (Ada, F83, "pango__fontset__finalize_spec");
      begin
         F83;
      end;
      E193 := E193 - 1;
      declare
         procedure F84;
         pragma Import (Ada, F84, "pango__font_family__finalize_spec");
      begin
         F84;
      end;
      E195 := E195 - 1;
      declare
         procedure F85;
         pragma Import (Ada, F85, "pango__font_face__finalize_spec");
      begin
         F85;
      end;
      declare
         procedure F86;
         pragma Import (Ada, F86, "gtk__text_tag_table__finalize_spec");
      begin
         F86;
      end;
      E279 := E279 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "gtk__text_tag__finalize_spec");
      begin
         F87;
      end;
      E187 := E187 - 1;
      declare
         procedure F88;
         pragma Import (Ada, F88, "pango__font__finalize_spec");
      begin
         F88;
      end;
      E191 := E191 - 1;
      declare
         procedure F89;
         pragma Import (Ada, F89, "pango__language__finalize_spec");
      begin
         F89;
      end;
      E189 := E189 - 1;
      declare
         procedure F90;
         pragma Import (Ada, F90, "pango__font_metrics__finalize_spec");
      begin
         F90;
      end;
      E203 := E203 - 1;
      declare
         procedure F91;
         pragma Import (Ada, F91, "pango__attributes__finalize_spec");
      begin
         F91;
      end;
      declare
         procedure F92;
         pragma Import (Ada, F92, "mast__timers__finalize_spec");
      begin
         F92;
      end;
      declare
         procedure F93;
         pragma Import (Ada, F93, "mast__synchronization_parameters__finalize_spec");
      begin
         F93;
      end;
      declare
         procedure F94;
         pragma Import (Ada, F94, "mast__scheduling_policies__finalize_spec");
      begin
         F94;
      end;
      declare
         procedure F95;
         pragma Import (Ada, F95, "mast__scheduling_parameters__finalize_spec");
      begin
         F95;
      end;
      E373 := E373 - 1;
      declare
         procedure F96;
         pragma Import (Ada, F96, "gtk__tree_store__finalize_spec");
      begin
         F96;
      end;
      declare
         procedure F97;
         pragma Import (Ada, F97, "gtk__tree_model__finalize_spec");
      begin
         F97;
      end;
      E659 := E659 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "gtk__text_mark__finalize_spec");
      begin
         F98;
      end;
      declare
         procedure F99;
         pragma Import (Ada, F99, "gtk__clipboard__finalize_spec");
      begin
         F99;
      end;
      E251 := E251 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "gtk__target_list__finalize_spec");
      begin
         F100;
      end;
      declare
         procedure F101;
         pragma Import (Ada, F101, "gtk__style__finalize_spec");
      begin
         F101;
      end;
      E178 := E178 - 1;
      declare
         procedure F102;
         pragma Import (Ada, F102, "gtk__selection_data__finalize_spec");
      begin
         F102;
      end;
      E271 := E271 - 1;
      declare
         procedure F103;
         pragma Import (Ada, F103, "gtk__print_settings__finalize_spec");
      begin
         F103;
      end;
      E259 := E259 - 1;
      declare
         procedure F104;
         pragma Import (Ada, F104, "gtk__page_setup__finalize_spec");
      begin
         F104;
      end;
      E263 := E263 - 1;
      declare
         procedure F105;
         pragma Import (Ada, F105, "gtk__paper_size__finalize_spec");
      begin
         F105;
      end;
      E241 := E241 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "gtk__icon_source__finalize_spec");
      begin
         F106;
      end;
      E505 := E505 - 1;
      declare
         procedure F107;
         pragma Import (Ada, F107, "gtk__file_filter__finalize_spec");
      begin
         F107;
      end;
      declare
         procedure F108;
         pragma Import (Ada, F108, "gtk__entry_buffer__finalize_spec");
      begin
         F108;
      end;
      E245 := E245 - 1;
      declare
         procedure F109;
         pragma Import (Ada, F109, "gtk__css_section__finalize_spec");
      begin
         F109;
      end;
      E229 := E229 - 1;
      declare
         procedure F110;
         pragma Import (Ada, F110, "gtk__cell_area_context__finalize_spec");
      begin
         F110;
      end;
      E152 := E152 - 1;
      declare
         procedure F111;
         pragma Import (Ada, F111, "gtk__builder__finalize_spec");
      begin
         F111;
      end;
      declare
         procedure F112;
         pragma Import (Ada, F112, "gtk__adjustment__finalize_spec");
      begin
         F112;
      end;
      declare
         procedure F113;
         pragma Import (Ada, F113, "gtk__accel_group__finalize_spec");
      begin
         F113;
      end;
      declare
         procedure F114;
         pragma Import (Ada, F114, "glib__menu_model__finalize_spec");
      begin
         F114;
      end;
      E281 := E281 - 1;
      declare
         procedure F115;
         pragma Import (Ada, F115, "glib__variant__finalize_spec");
      begin
         F115;
      end;
      E168 := E168 - 1;
      declare
         procedure F116;
         pragma Import (Ada, F116, "gdk__drag_contexts__finalize_spec");
      begin
         F116;
      end;
      E166 := E166 - 1;
      declare
         procedure F117;
         pragma Import (Ada, F117, "gdk__device__finalize_spec");
      begin
         F117;
      end;
      E140 := E140 - 1;
      declare
         procedure F118;
         pragma Import (Ada, F118, "gdk__screen__finalize_spec");
      begin
         F118;
      end;
      E174 := E174 - 1;
      declare
         procedure F119;
         pragma Import (Ada, F119, "gdk__pixbuf__finalize_spec");
      begin
         F119;
      end;
      declare
         procedure F120;
         pragma Import (Ada, F120, "gdk__display__finalize_spec");
      begin
         F120;
      end;
      declare
         procedure F121;
         pragma Import (Ada, F121, "gdk__frame_clock__finalize_spec");
      begin
         F121;
      end;
      E090 := E090 - 1;
      declare
         procedure F122;
         pragma Import (Ada, F122, "glib__object__finalize_spec");
      begin
         F122;
      end;
      E172 := E172 - 1;
      declare
         procedure F123;
         pragma Import (Ada, F123, "gdk__frame_timings__finalize_spec");
      begin
         F123;
      end;
      E060 := E060 - 1;
      declare
         procedure F124;
         pragma Import (Ada, F124, "glib__finalize_spec");
      begin
         F124;
      end;
      E326 := E326 - 1;
      declare
         procedure F125;
         pragma Import (Ada, F125, "ada__text_io__finalize_spec");
      begin
         F125;
      end;
      E402 := E402 - 1;
      E421 := E421 - 1;
      declare
         procedure F126;
         pragma Import (Ada, F126, "system__regexp__finalize_spec");
      begin
         F126;
      end;
      declare
         procedure F127;
         pragma Import (Ada, F127, "ada__directories__finalize_spec");
      begin
         F127;
      end;
      E387 := E387 - 1;
      declare
         procedure F128;
         pragma Import (Ada, F128, "ada__strings__unbounded__finalize_spec");
      begin
         F128;
      end;
      E069 := E069 - 1;
      E094 := E094 - 1;
      declare
         procedure F129;
         pragma Import (Ada, F129, "system__file_io__finalize_body");
      begin
         E330 := E330 - 1;
         F129;
      end;
      E518 := E518 - 1;
      declare
         procedure F130;
         pragma Import (Ada, F130, "ada__streams__stream_io__finalize_spec");
      begin
         F130;
      end;
      declare
         procedure F131;
         pragma Import (Ada, F131, "system__file_control_block__finalize_spec");
      begin
         E335 := E335 - 1;
         F131;
      end;
      E083 := E083 - 1;
      declare
         procedure F132;
         pragma Import (Ada, F132, "system__pool_global__finalize_spec");
      begin
         F132;
      end;
      declare
         procedure F133;
         pragma Import (Ada, F133, "system__storage_pools__subpools__finalize_spec");
      begin
         F133;
      end;
      declare
         procedure F134;
         pragma Import (Ada, F134, "system__finalization_masters__finalize_spec");
      begin
         F134;
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
      E478 := E478 + 1;
      System.Fat_Lflt'Elab_Spec;
      E462 := E462 + 1;
      System.Fat_Llf'Elab_Spec;
      E465 := E465 + 1;
      System.Fat_Sflt'Elab_Spec;
      E489 := E489 + 1;
      System.Exception_Table'Elab_Body;
      E026 := E026 + 1;
      Ada.Containers'Elab_Spec;
      E512 := E512 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E067 := E067 + 1;
      Ada.Numerics'Elab_Spec;
      E595 := E595 + 1;
      Ada.Strings'Elab_Spec;
      E348 := E348 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E353 := E353 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E066 := E066 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E028 := E028 + 1;
      System.Finalization_Root'Elab_Spec;
      E079 := E079 + 1;
      Ada.Finalization'Elab_Spec;
      E077 := E077 + 1;
      System.Storage_Pools'Elab_Spec;
      E081 := E081 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E398 := E398 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E406 := E406 + 1;
      System.Assertions'Elab_Spec;
      E293 := E293 + 1;
      System.Pool_Global'Elab_Spec;
      E083 := E083 + 1;
      System.File_Control_Block'Elab_Spec;
      E335 := E335 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E518 := E518 + 1;
      System.Random_Seed'Elab_Body;
      E603 := E603 + 1;
      System.File_Io'Elab_Body;
      E330 := E330 + 1;
      E094 := E094 + 1;
      System.Finalization_Masters'Elab_Body;
      E069 := E069 + 1;
      E064 := E064 + 1;
      E062 := E062 + 1;
      Ada.Tags'Elab_Body;
      E008 := E008 + 1;
      E350 := E350 + 1;
      System.Soft_Links'Elab_Body;
      E016 := E016 + 1;
      System.Os_Lib'Elab_Body;
      E334 := E334 + 1;
      System.Secondary_Stack'Elab_Body;
      E020 := E020 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E387 := E387 + 1;
      Ada.Directories'Elab_Spec;
      System.Regexp'Elab_Spec;
      E421 := E421 + 1;
      Ada.Directories'Elab_Body;
      E402 := E402 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E516 := E516 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E326 := E326 + 1;
      Glib'Elab_Spec;
      E060 := E060 + 1;
      Gtkada.Types'Elab_Spec;
      E113 := E113 + 1;
      E480 := E480 + 1;
      E423 := E423 + 1;
      E425 := E425 + 1;
      File_Operations'Elab_Spec;
      Gdk.Frame_Timings'Elab_Spec;
      E172 := E172 + 1;
      E115 := E115 + 1;
      Gdk.Visual'Elab_Spec;
      Gdk.Visual'Elab_Body;
      E144 := E144 + 1;
      E117 := E117 + 1;
      Glib.Object'Elab_Spec;
      E092 := E092 + 1;
      Glib.Values'Elab_Body;
      E109 := E109 + 1;
      E124 := E124 + 1;
      E126 := E126 + 1;
      Gdk.Color'Elab_Spec;
      E131 := E131 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E134 := E134 + 1;
      E111 := E111 + 1;
      Gtkada.Bindings'Elab_Spec;
      E099 := E099 + 1;
      E217 := E217 + 1;
      E107 := E107 + 1;
      E283 := E283 + 1;
      Glib.Object'Elab_Body;
      E090 := E090 + 1;
      Gdk.Rgba'Elab_Body;
      E136 := E136 + 1;
      Gdk.Color'Elab_Body;
      E164 := E164 + 1;
      E261 := E261 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Types'Elab_Spec;
      E132 := E132 + 1;
      Gdk.Event'Elab_Spec;
      E129 := E129 + 1;
      Gdk.Display'Elab_Spec;
      Gdk.Pixbuf'Elab_Spec;
      E174 := E174 + 1;
      Glib.Properties'Elab_Spec;
      E146 := E146 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E140 := E140 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Device'Elab_Body;
      E166 := E166 + 1;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Body;
      E168 := E168 + 1;
      Gdk.Window'Elab_Spec;
      E211 := E211 + 1;
      Glib.Variant'Elab_Spec;
      E281 := E281 + 1;
      Glib.Menu_Model'Elab_Spec;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Actionable'Elab_Spec;
      E287 := E287 + 1;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E152 := E152 + 1;
      E150 := E150 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E229 := E229 + 1;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Css_Section'Elab_Spec;
      E245 := E245 + 1;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Enums'Elab_Spec;
      E160 := E160 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E505 := E505 + 1;
      Gtk.Icon_Source'Elab_Spec;
      E241 := E241 + 1;
      Gtk.Orientable'Elab_Spec;
      E207 := E207 + 1;
      Gtk.Paper_Size'Elab_Spec;
      E263 := E263 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E259 := E259 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E271 := E271 + 1;
      Gtk.Scrollable'Elab_Spec;
      E311 := E311 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E178 := E178 + 1;
      Gtk.Style'Elab_Spec;
      E253 := E253 + 1;
      Gtk.Target_List'Elab_Spec;
      E251 := E251 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E659 := E659 + 1;
      Gtk.Tree_Model'Elab_Spec;
      E375 := E375 + 1;
      E377 := E377 + 1;
      Gtk.Tree_Store'Elab_Spec;
      Gtk.Tree_Store'Elab_Body;
      E373 := E373 + 1;
      List_Exceptions'Elab_Spec;
      E484 := E484 + 1;
      E524 := E524 + 1;
      E538 := E538 + 1;
      E609 := E609 + 1;
      E577 := E577 + 1;
      E629 := E629 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      Mast.Hospa_Parameters'Elab_Body;
      E607 := E607 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E605 := E605 + 1;
      Pango.Enums'Elab_Spec;
      E185 := E185 + 1;
      Pango.Attributes'Elab_Spec;
      E203 := E203 + 1;
      Pango.Font_Metrics'Elab_Spec;
      E189 := E189 + 1;
      Pango.Language'Elab_Spec;
      E191 := E191 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E187 := E187 + 1;
      E277 := E277 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E279 := E279 + 1;
      Gtk.Text_Iter'Elab_Spec;
      E275 := E275 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E195 := E195 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E193 := E193 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E197 := E197 + 1;
      E199 := E199 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E183 := E183 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E267 := E267 + 1;
      Pango.Tabs'Elab_Spec;
      E205 := E205 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E201 := E201 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E265 := E265 + 1;
      Gtk.Widget'Elab_Spec;
      Gtk.Action'Elab_Spec;
      Gtk.Activatable'Elab_Spec;
      E289 := E289 + 1;
      Gtk.Cell_Renderer'Elab_Spec;
      E231 := E231 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Cell_Renderer_Text'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E213 := E213 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E363 := E363 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E148 := E148 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.File_Chooser'Elab_Spec;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E339 := E339 + 1;
      Gtk.Grange'Elab_Spec;
      E509 := E509 + 1;
      E295 := E295 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Image_Menu_Item'Elab_Spec;
      Gtk.Image_Menu_Item'Elab_Body;
      E297 := E297 + 1;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu_Bar'Elab_Spec;
      Gtk.Menu_Bar'Elab_Body;
      E639 := E639 + 1;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E249 := E249 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Notebook'Elab_Spec;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E643 := E643 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Separator'Elab_Spec;
      Gtk.Separator'Elab_Body;
      E647 := E647 + 1;
      Gtk.Separator_Menu_Item'Elab_Spec;
      Gtk.Separator_Menu_Item'Elab_Body;
      E649 := E649 + 1;
      Gtk.Status_Bar'Elab_Spec;
      E247 := E247 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      E239 := E239 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E237 := E237 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Spin_Button'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E657 := E657 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Toggle_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Body;
      E303 := E303 + 1;
      Gtk.Radio_Button'Elab_Spec;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E313 := E313 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E381 := E381 + 1;
      Gtk.Window'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Dialog1_Pkg'Elab_Spec;
      Dialog_3_Pkg'Elab_Spec;
      Dialog_Yes_No_Pkg'Elab_Spec;
      Gtk.About_Dialog'Elab_Spec;
      Aboutdialog1_Pkg'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E507 := E507 + 1;
      Filechooserdialog1_Pkg'Elab_Spec;
      Gtk.Print_Operation'Elab_Spec;
      Gtk.Arguments'Elab_Spec;
      E122 := E122 + 1;
      Gtk.Print_Operation'Elab_Body;
      E257 := E257 + 1;
      Gtk.About_Dialog'Elab_Body;
      E651 := E651 + 1;
      Gtk.Dialog'Elab_Body;
      E138 := E138 + 1;
      Gtk.Window'Elab_Body;
      E209 := E209 + 1;
      Gtk.Combo_Box'Elab_Body;
      E383 := E383 + 1;
      Gtk.Tree_View'Elab_Body;
      E309 := E309 + 1;
      Gtk.Tree_View_Column'Elab_Body;
      E317 := E317 + 1;
      Gtk.Tree_Selection'Elab_Body;
      E315 := E315 + 1;
      Gtk.Radio_Button'Elab_Body;
      E301 := E301 + 1;
      Gtk.Toggle_Button'Elab_Body;
      E305 := E305 + 1;
      Gtk.Text_View'Elab_Body;
      E663 := E663 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E653 := E653 + 1;
      Gtk.Spin_Button'Elab_Body;
      E307 := E307 + 1;
      Gtk.Gentry'Elab_Body;
      E215 := E215 + 1;
      Gtk.Style_Context'Elab_Body;
      E243 := E243 + 1;
      Gtk.Status_Bar'Elab_Body;
      E273 := E273 + 1;
      Gtk.Scrolled_Window'Elab_Body;
      E641 := E641 + 1;
      Gtk.Notebook'Elab_Body;
      E255 := E255 + 1;
      Gtk.Label'Elab_Body;
      E365 := E365 + 1;
      Gtk.Menu'Elab_Body;
      E367 := E367 + 1;
      Gtk.Menu_Shell'Elab_Body;
      E371 := E371 + 1;
      Gtk.Menu_Item'Elab_Body;
      E299 := E299 + 1;
      Gtk.Grange'Elab_Body;
      E645 := E645 + 1;
      E503 := E503 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E225 := E225 + 1;
      Gtk.Button'Elab_Body;
      E120 := E120 + 1;
      Gtk.Container'Elab_Body;
      E156 := E156 + 1;
      Gtk.Cell_Renderer_Text'Elab_Body;
      E337 := E337 + 1;
      Gtk.Cell_Area'Elab_Body;
      E227 := E227 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E233 := E233 + 1;
      Gtk.Action'Elab_Body;
      E285 := E285 + 1;
      Gtk.Widget'Elab_Body;
      E162 := E162 + 1;
      E269 := E269 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E661 := E661 + 1;
      E341 := E341 + 1;
      E235 := E235 + 1;
      Gtk.Clipboard'Elab_Body;
      E655 := E655 + 1;
      Gtk.Style'Elab_Body;
      E180 := E180 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E223 := E223 + 1;
      E219 := E219 + 1;
      Gtk.Adjustment'Elab_Body;
      E158 := E158 + 1;
      Gtk.Accel_Group'Elab_Body;
      E176 := E176 + 1;
      Glib.Menu_Model'Elab_Body;
      E369 := E369 + 1;
      Gdk.Display'Elab_Body;
      E142 := E142 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E170 := E170 + 1;
      E221 := E221 + 1;
      E361 := E361 + 1;
      E429 := E429 + 1;
      E433 := E433 + 1;
      E501 := E501 + 1;
      Callbacks_Pt_Editor'Elab_Spec;
      E058 := E058 + 1;
      Gtkada.Handlers'Elab_Spec;
      E318 := E318 + 1;
      E615 := E615 + 1;
      Progress_Dialog_Pkg'Elab_Spec;
      E320 := E320 + 1;
      E667 := E667 + 1;
      E431 := E431 + 1;
      E427 := E427 + 1;
      E359 := E359 + 1;
      Pt_Editor_Pkg'Elab_Spec;
      E499 := E499 + 1;
      E006 := E006 + 1;
      E587 := E587 + 1;
      Usage_Dialog_Pkg'Elab_Spec;
      E635 := E635 + 1;
      E633 := E633 + 1;
      Var_Strings'Elab_Spec;
      E385 := E385 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E583 := E583 + 1;
      Global_Options'Elab_Body;
      E459 := E459 + 1;
      Mast'Elab_Body;
      E461 := E461 + 1;
      MAST.IO'ELAB_SPEC;
      E566 := E566 + 1;
      E542 := E542 + 1;
      E552 := E552 + 1;
      E540 := E540 + 1;
      Mutex_Table'Elab_Spec;
      E343 := E343 + 1;
      E486 := E486 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E514 := E514 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E522 := E522 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E550 := E550 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E564 := E564 + 1;
      Mast.Schedulers'Elab_Spec;
      E548 := E548 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E568 := E568 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E544 := E544 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E528 := E528 + 1;
      Mast.Drivers'Elab_Spec;
      E560 := E560 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E526 := E526 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E558 := E558 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E536 := E536 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E534 := E534 + 1;
      E532 := E532 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E570 := E570 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E554 := E554 + 1;
      E556 := E556 + 1;
      E562 := E562 + 1;
      E546 := E546 + 1;
      MAST.TOOLS.SCHEDULABILITY_INDEX'ELAB_SPEC;
      E613 := E613 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E585 := E585 + 1;
      E631 := E631 + 1;
      E581 := E581 + 1;
      E623 := E623 + 1;
      E594 := E594 + 1;
      MAST.RESTRICTIONS'ELAB_BODY;
      E572 := E572 + 1;
      MAST.MISCELANEOUS_TOOLS'ELAB_BODY;
      E627 := E627 + 1;
      E611 := E611 + 1;
      E579 := E579 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E592 := E592 + 1;
      E625 := E625 + 1;
      E589 := E589 + 1;
      Results_Table'Elab_Spec;
      E471 := E471 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E483 := E483 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E481 := E481 + 1;
      MAST.IO'ELAB_BODY;
      E473 := E473 + 1;
      Task_Table'Elab_Spec;
      E495 := E495 + 1;
      Usage_Table'Elab_Spec;
      E497 := E497 + 1;
      E396 := E396 + 1;
      E324 := E324 + 1;
      Model_Operations'Elab_Body;
      E511 := E511 + 1;
      File_Operations'Elab_Body;
      E435 := E435 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_gmast_pt_editor");

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
   --   ../../mast_analysis/binary_trees.o
   --   ./changes_control.o
   --   ./check_operations.o
   --   ../../mast_analysis/list_exceptions.o
   --   ../../mast_analysis/indexed_lists.o
   --   ../../mast_analysis/hash_lists.o
   --   ../../mast_analysis/dynamic_lists.o
   --   ../../mast_analysis/doubly_linked_lists.o
   --   ../../mast_analysis/associations.o
   --   ../../mast_analysis/mast-hospa_parameters.o
   --   ../../mast_analysis/mast-annealing_parameters.o
   --   ./dialog1_pkg-callbacks.o
   --   ./dialog_3_pkg-callbacks.o
   --   ./dialog_yes_no_pkg-callbacks.o
   --   ./filechooserdialog1_pkg-callbacks.o
   --   ./callbacks_pt_editor.o
   --   ../../mast_analysis/priority_queues.o
   --   ./pt_editor_intl.o
   --   ./progress_dialog_pkg.o
   --   ./dialog_yes_no_pkg.o
   --   ./dialog_3_pkg.o
   --   ./dialog1_pkg.o
   --   ./filechooserdialog1_pkg.o
   --   ./aboutdialog1_pkg.o
   --   ../../mast_analysis/trimmed_image.o
   --   ./usage_dialog_pkg-callbacks.o
   --   ./usage_dialog_pkg.o
   --   ../../utils/var_strings.o
   --   ../../mast_analysis/mast-tool_exceptions.o
   --   ./global_options.o
   --   ../../mast_analysis/mast.o
   --   ./mast-timers.o
   --   ./mast-synchronization_parameters.o
   --   ./mast-scheduling_policies.o
   --   ./mast-scheduling_parameters.o
   --   ./mutex_table.o
   --   ../../mast_analysis/named_lists.o
   --   ./mast-events.o
   --   ./mast-graphs.o
   --   ../../mast_analysis/mast-processing_resources.o
   --   ./mast-processing_resources-processor.o
   --   ./mast-schedulers.o
   --   ./mast-schedulers-secondary.o
   --   ./mast-shared_resources.o
   --   ../../mast_analysis/mast-operations.o
   --   ./mast-drivers.o
   --   ./mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ../../mast_analysis/mast-timing_requirements.o
   --   ./mast-graphs-links.o
   --   ./mast-results.o
   --   ./mast-transactions.o
   --   ./mast-schedulers-primary.o
   --   ../../mast_analysis/mast-systems.o
   --   ./mast-schedulers-adjustment.o
   --   ./mast-scheduling_servers.o
   --   ./mast-tools-schedulability_index.o
   --   ./mast-transaction_operations.o
   --   ./mast-monoprocessor_tools.o
   --   ./mast-linear_translation.o
   --   ./mast-linear_scheduling_parameters_assignment_tools.o
   --   ./mast-linear_priority_assignment_tools.o
   --   ../../mast_analysis/mast-restrictions.o
   --   ../../mast_analysis/mast-miscelaneous_tools.o
   --   ./mast-max_numbers.o
   --   ./mast-linear_analysis_tools.o
   --   ../../mast_analysis/mast-consistency_checks.o
   --   ./mast-linear_task_analysis_tools.o
   --   ./mast-tools.o
   --   ./results_table.o
   --   ../../mast_analysis/symbol_table.o
   --   ../../mast_analysis/mast_parser_tokens.o
   --   ../../mast_analysis/mast-io.o
   --   ./task_table.o
   --   ./usage_table.o
   --   ./pt_editor_pkg-callbacks.o
   --   ./pt_editor_pkg.o
   --   ./model_operations.o
   --   ./file_operations.o
   --   ./pt_editor.o
   --   ./gmast_pt_editor.o
   --   -L./
   --   -L../../utils/
   --   -L../../mast_analysis/
   --   -L/home/mgh/gnat2014/gtkada/lib/gtkada/relocatable/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
