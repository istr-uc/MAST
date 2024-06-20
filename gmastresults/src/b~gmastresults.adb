pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~gmastresults.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~gmastresults.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E076 : Short_Integer; pragma Import (Ada, E076, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E401 : Short_Integer; pragma Import (Ada, E401, "system__fat_flt_E");
   E349 : Short_Integer; pragma Import (Ada, E349, "system__fat_lflt_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "system__fat_llf_E");
   E415 : Short_Integer; pragma Import (Ada, E415, "system__fat_sflt_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exception_table_E");
   E587 : Short_Integer; pragma Import (Ada, E587, "ada__containers_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "ada__io_exceptions_E");
   E610 : Short_Integer; pragma Import (Ada, E610, "ada__numerics_E");
   E366 : Short_Integer; pragma Import (Ada, E366, "ada__strings_E");
   E368 : Short_Integer; pragma Import (Ada, E368, "ada__strings__maps_E");
   E371 : Short_Integer; pragma Import (Ada, E371, "ada__strings__maps__constants_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "ada__tags_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "ada__streams_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "interfaces__c_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "interfaces__c__strings_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "system__finalization_root_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__finalization_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "system__storage_pools_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "system__finalization_masters_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "system__storage_pools__subpools_E");
   E388 : Short_Integer; pragma Import (Ada, E388, "ada__calendar_E");
   E538 : Short_Integer; pragma Import (Ada, E538, "ada__calendar__time_zones_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "system__assertions_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "system__pool_global_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__file_control_block_E");
   E419 : Short_Integer; pragma Import (Ada, E419, "ada__streams__stream_io_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "system__file_io_E");
   E618 : Short_Integer; pragma Import (Ada, E618, "system__random_seed_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "system__secondary_stack_E");
   E373 : Short_Integer; pragma Import (Ada, E373, "ada__strings__unbounded_E");
   E534 : Short_Integer; pragma Import (Ada, E534, "ada__directories_E");
   E544 : Short_Integer; pragma Import (Ada, E544, "system__regexp_E");
   E417 : Short_Integer; pragma Import (Ada, E417, "system__strings__stream_ops_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "ada__text_io_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "glib_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "gtkada__types_E");
   E405 : Short_Integer; pragma Import (Ada, E405, "binary_trees_E");
   E595 : Short_Integer; pragma Import (Ada, E595, "doubly_linked_lists_E");
   E628 : Short_Integer; pragma Import (Ada, E628, "dynamic_lists_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "gdk__frame_timings_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "glib__glist_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "gdk__visual_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "glib__gslist_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "glib__key_file_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "glib__object_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "glib__string_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "glib__type_conversion_hooks_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "glib__types_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "glib__g_icon_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "glib__values_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "cairo_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "cairo__region_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "gdk__color_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "gdk__rectangle_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "gdk__rgba_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "glib__generic_properties_E");
   E509 : Short_Integer; pragma Import (Ada, E509, "gmastresults_intl_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "gtk__editable_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "gtkada__c_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "gtkada__bindings_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "gdk__frame_clock_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "gdk__types_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "gdk__event_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "gdk__display_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gdk__pixbuf_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "glib__properties_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "gdk__screen_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "gdk__device_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "gdk__drag_contexts_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "gdk__window_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "glib__variant_E");
   E524 : Short_Integer; pragma Import (Ada, E524, "glib__menu_model_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "gtk__accel_group_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "gtk__actionable_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "gtk__adjustment_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "gtk__builder_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "gtk__buildable_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "gtk__cell_area_context_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "gtk__cell_editable_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "gtk__css_section_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "gtk__entry_buffer_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "gtk__enums_E");
   E552 : Short_Integer; pragma Import (Ada, E552, "gtk__file_filter_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "gtk__icon_source_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "gtk__orientable_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "gtk__paper_size_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "gtk__page_setup_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "gtk__print_settings_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "gtk__scrollable_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "gtk__selection_data_E");
   E558 : Short_Integer; pragma Import (Ada, E558, "gtk__stock_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "gtk__style_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "gtk__target_entry_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "gtk__target_list_E");
   E578 : Short_Integer; pragma Import (Ada, E578, "gtk__clipboard_E");
   E582 : Short_Integer; pragma Import (Ada, E582, "gtk__text_mark_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "gtk__tree_model_E");
   E332 : Short_Integer; pragma Import (Ada, E332, "gtk__tree_drag_dest_E");
   E334 : Short_Integer; pragma Import (Ada, E334, "gtk__tree_drag_source_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "gtk__tree_sortable_E");
   E330 : Short_Integer; pragma Import (Ada, E330, "gtk__tree_store_E");
   E560 : Short_Integer; pragma Import (Ada, E560, "gtkada__file_selection_E");
   E562 : Short_Integer; pragma Import (Ada, E562, "gtkada__pixmaps_E");
   E561 : Short_Integer; pragma Import (Ada, E561, "gmastresults_pixmaps_E");
   E433 : Short_Integer; pragma Import (Ada, E433, "hash_lists_E");
   E425 : Short_Integer; pragma Import (Ada, E425, "indexed_lists_E");
   E344 : Short_Integer; pragma Import (Ada, E344, "list_exceptions_E");
   E656 : Short_Integer; pragma Import (Ada, E656, "associations_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "mast_E");
   E620 : Short_Integer; pragma Import (Ada, E620, "mast__annealing_parameters_E");
   E626 : Short_Integer; pragma Import (Ada, E626, "mast__hospa_parameters_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "mast__scheduling_parameters_E");
   E457 : Short_Integer; pragma Import (Ada, E457, "mast__scheduling_policies_E");
   E437 : Short_Integer; pragma Import (Ada, E437, "mast__synchronization_parameters_E");
   E471 : Short_Integer; pragma Import (Ada, E471, "mast__timers_E");
   E603 : Short_Integer; pragma Import (Ada, E603, "mast__tool_exceptions_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "mast_lex_dfa_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "mast_lex_io_E");
   E486 : Short_Integer; pragma Import (Ada, E486, "mast_parser_error_report_E");
   E499 : Short_Integer; pragma Import (Ada, E499, "mast_results_lex_dfa_E");
   E501 : Short_Integer; pragma Import (Ada, E501, "mast_results_lex_io_E");
   E504 : Short_Integer; pragma Import (Ada, E504, "mast_results_parser_error_report_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "pango__enums_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "pango__attributes_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "pango__font_metrics_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "pango__language_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "pango__font_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__text_attributes_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "gtk__text_tag_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__text_iter_E");
   E584 : Short_Integer; pragma Import (Ada, E584, "gtk__text_tag_table_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "pango__font_face_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "pango__font_family_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "pango__fontset_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "pango__matrix_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "pango__context_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "pango__font_map_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "pango__tabs_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "pango__layout_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "gtk__print_context_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "gtk__print_operation_preview_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "gtk__widget_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "gtk__action_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "gtk__activatable_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "gtk__cell_renderer_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "gtk__cell_layout_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "gtk__cell_area_E");
   E564 : Short_Integer; pragma Import (Ada, E564, "gtk__cell_renderer_pixbuf_E");
   E513 : Short_Integer; pragma Import (Ada, E513, "gtk__cell_renderer_text_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "gtk__container_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "gtk__bin_E");
   E516 : Short_Integer; pragma Import (Ada, E516, "gtk__alignment_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "gtk__box_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "gtk__button_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "gtk__entry_completion_E");
   E550 : Short_Integer; pragma Import (Ada, E550, "gtk__file_chooser_E");
   E518 : Short_Integer; pragma Import (Ada, E518, "gtk__frame_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "gtk__grange_E");
   E568 : Short_Integer; pragma Import (Ada, E568, "gtk__handle_box_E");
   E556 : Short_Integer; pragma Import (Ada, E556, "gtk__main_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "gtk__marshallers_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "gtk__menu_item_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "gtk__image_menu_item_E");
   E526 : Short_Integer; pragma Import (Ada, E526, "gtk__menu_shell_E");
   E522 : Short_Integer; pragma Import (Ada, E522, "gtk__menu_E");
   E570 : Short_Integer; pragma Import (Ada, E570, "gtk__menu_bar_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "gtk__misc_E");
   E520 : Short_Integer; pragma Import (Ada, E520, "gtk__label_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "gtk__notebook_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gtk__scrollbar_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "gtk__scrolled_window_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__status_bar_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "gtk__style_provider_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "gtk__style_context_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "gtk__icon_set_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "gtk__image_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "gtk__gentry_E");
   E572 : Short_Integer; pragma Import (Ada, E572, "gtk__table_E");
   E580 : Short_Integer; pragma Import (Ada, E580, "gtk__text_child_anchor_E");
   E576 : Short_Integer; pragma Import (Ada, E576, "gtk__text_buffer_E");
   E574 : Short_Integer; pragma Import (Ada, E574, "gtk__text_view_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "gtk__tooltip_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "gtk__tree_selection_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "gtk__tree_view_column_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "gtk__tree_view_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "gtk__combo_box_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "gtk__combo_box_text_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "gtk__window_E");
   E546 : Short_Integer; pragma Import (Ada, E546, "error_window_pkg_E");
   E530 : Short_Integer; pragma Import (Ada, E530, "gmast_results_pkg_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "gtk__dialog_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "dialog_event_pkg_E");
   E554 : Short_Integer; pragma Import (Ada, E554, "gtk__file_chooser_dialog_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "gtk__print_operation_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "gtk__arguments_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "dialog_event_pkg__callbacks_E");
   E548 : Short_Integer; pragma Import (Ada, E548, "error_window_pkg__callbacks_E");
   E532 : Short_Integer; pragma Import (Ada, E532, "gmast_results_pkg__callbacks_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "callbacks_gmastresults_E");
   E514 : Short_Integer; pragma Import (Ada, E514, "gtkada__handlers_E");
   E634 : Short_Integer; pragma Import (Ada, E634, "priority_queues_E");
   E605 : Short_Integer; pragma Import (Ada, E605, "trimmed_image_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "var_strings_E");
   E386 : Short_Integer; pragma Import (Ada, E386, "mast__io_E");
   E410 : Short_Integer; pragma Import (Ada, E410, "named_lists_E");
   E384 : Short_Integer; pragma Import (Ada, E384, "mast__events_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "mast__graphs_E");
   E431 : Short_Integer; pragma Import (Ada, E431, "mast__results_E");
   E455 : Short_Integer; pragma Import (Ada, E455, "mast__processing_resources_E");
   E469 : Short_Integer; pragma Import (Ada, E469, "mast__processing_resources__processor_E");
   E453 : Short_Integer; pragma Import (Ada, E453, "mast__schedulers_E");
   E451 : Short_Integer; pragma Import (Ada, E451, "mast__scheduling_servers_E");
   E467 : Short_Integer; pragma Import (Ada, E467, "mast__schedulers__adjustment_E");
   E473 : Short_Integer; pragma Import (Ada, E473, "mast__schedulers__secondary_E");
   E449 : Short_Integer; pragma Import (Ada, E449, "mast__shared_resources_E");
   E445 : Short_Integer; pragma Import (Ada, E445, "mast__operations_E");
   E465 : Short_Integer; pragma Import (Ada, E465, "mast__drivers_E");
   E443 : Short_Integer; pragma Import (Ada, E443, "mast__graphs__event_handlers_E");
   E463 : Short_Integer; pragma Import (Ada, E463, "mast__processing_resources__network_E");
   E439 : Short_Integer; pragma Import (Ada, E439, "mast__timing_requirements_E");
   E427 : Short_Integer; pragma Import (Ada, E427, "mast__graphs__links_E");
   E441 : Short_Integer; pragma Import (Ada, E441, "mast__transactions_E");
   E461 : Short_Integer; pragma Import (Ada, E461, "mast__systems_E");
   E593 : Short_Integer; pragma Import (Ada, E593, "mast__consistency_checks_E");
   E599 : Short_Integer; pragma Import (Ada, E599, "mast__linear_analysis_tools_E");
   E607 : Short_Integer; pragma Import (Ada, E607, "mast__max_numbers_E");
   E654 : Short_Integer; pragma Import (Ada, E654, "mast__miscelaneous_tools_E");
   E658 : Short_Integer; pragma Import (Ada, E658, "mast__restrictions_E");
   E459 : Short_Integer; pragma Import (Ada, E459, "mast__schedulers__primary_E");
   E586 : Short_Integer; pragma Import (Ada, E586, "mast__tools_E");
   E609 : Short_Integer; pragma Import (Ada, E609, "mast__linear_priority_assignment_tools_E");
   E636 : Short_Integer; pragma Import (Ada, E636, "mast__linear_scheduling_parameters_assignment_tools_E");
   E601 : Short_Integer; pragma Import (Ada, E601, "mast__linear_translation_E");
   E660 : Short_Integer; pragma Import (Ada, E660, "mast__monoprocessor_tools_E");
   E632 : Short_Integer; pragma Import (Ada, E632, "mast__tools__schedulability_index_E");
   E597 : Short_Integer; pragma Import (Ada, E597, "mast__transaction_operations_E");
   E652 : Short_Integer; pragma Import (Ada, E652, "mast__linear_task_analysis_tools_E");
   E408 : Short_Integer; pragma Import (Ada, E408, "symbol_table_E");
   E406 : Short_Integer; pragma Import (Ada, E406, "mast_parser_tokens_E");
   E475 : Short_Integer; pragma Import (Ada, E475, "mast_actions_E");
   E479 : Short_Integer; pragma Import (Ada, E479, "mast_lex_E");
   E502 : Short_Integer; pragma Import (Ada, E502, "mast_results_parser_tokens_E");
   E497 : Short_Integer; pragma Import (Ada, E497, "mast_results_lex_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E451 := E451 - 1;
      E461 := E461 - 1;
      E459 := E459 - 1;
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
      E441 := E441 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__transactions__finalize_spec");
      begin
         F3;
      end;
      E431 := E431 - 1;
      E427 := E427 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__graphs__links__finalize_spec");
      begin
         F4;
      end;
      E439 := E439 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__timing_requirements__finalize_spec");
      begin
         F5;
      end;
      E463 := E463 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__processing_resources__network__finalize_spec");
      begin
         F6;
      end;
      E443 := E443 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__graphs__event_handlers__finalize_spec");
      begin
         F7;
      end;
      E465 := E465 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__drivers__finalize_spec");
      begin
         F8;
      end;
      E445 := E445 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__operations__finalize_spec");
      begin
         F9;
      end;
      E449 := E449 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__shared_resources__finalize_spec");
      begin
         F10;
      end;
      E473 := E473 - 1;
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
      E453 := E453 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__schedulers__finalize_spec");
      begin
         F13;
      end;
      E469 := E469 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__processing_resources__processor__finalize_spec");
      begin
         F14;
      end;
      E455 := E455 - 1;
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
      E423 := E423 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__graphs__finalize_spec");
      begin
         F17;
      end;
      E384 := E384 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__events__finalize_spec");
      begin
         F18;
      end;
      E435 := E435 - 1;
      E457 := E457 - 1;
      E437 := E437 - 1;
      E471 := E471 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "gtkada__file_selection__finalize_body");
      begin
         E560 := E560 - 1;
         F19;
      end;
      E546 := E546 - 1;
      E530 := E530 - 1;
      E099 := E099 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "gtkada__handlers__finalize_spec");
      begin
         E514 := E514 - 1;
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "callbacks_gmastresults__finalize_spec");
      begin
         E100 := E100 - 1;
         F21;
      end;
      E182 := E182 - 1;
      E154 := E154 - 1;
      E524 := E524 - 1;
      E188 := E188 - 1;
      E170 := E170 - 1;
      E235 := E235 - 1;
      E192 := E192 - 1;
      E578 := E578 - 1;
      E247 := E247 - 1;
      E584 := E584 - 1;
      E174 := E174 - 1;
      E297 := E297 - 1;
      E245 := E245 - 1;
      E239 := E239 - 1;
      E513 := E513 - 1;
      E168 := E168 - 1;
      E132 := E132 - 1;
      E237 := E237 - 1;
      E343 := E343 - 1;
      E568 := E568 - 1;
      E325 := E325 - 1;
      E526 := E526 - 1;
      E522 := E522 - 1;
      E520 := E520 - 1;
      E267 := E267 - 1;
      E339 := E339 - 1;
      E285 := E285 - 1;
      E255 := E255 - 1;
      E227 := E227 - 1;
      E576 := E576 - 1;
      E574 := E574 - 1;
      E313 := E313 - 1;
      E315 := E315 - 1;
      E307 := E307 - 1;
      E305 := E305 - 1;
      E221 := E221 - 1;
      E150 := E150 - 1;
      E269 := E269 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "gtk__print_operation__finalize_spec");
      begin
         F22;
      end;
      E554 := E554 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "dialog_event_pkg__finalize_spec");
      begin
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "gtk__dialog__finalize_spec");
      begin
         F25;
      end;
      declare
         procedure F26;
         pragma Import (Ada, F26, "gmast_results_pkg__finalize_spec");
      begin
         F26;
      end;
      declare
         procedure F27;
         pragma Import (Ada, F27, "error_window_pkg__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "gtk__window__finalize_spec");
      begin
         F28;
      end;
      E303 := E303 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "gtk__combo_box_text__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "gtk__combo_box__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "gtk__tree_view__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "gtk__tree_view_column__finalize_spec");
      begin
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "gtk__tree_selection__finalize_spec");
      begin
         F33;
      end;
      E311 := E311 - 1;
      declare
         procedure F34;
         pragma Import (Ada, F34, "gtk__tooltip__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "gtk__text_view__finalize_spec");
      begin
         F35;
      end;
      declare
         procedure F36;
         pragma Import (Ada, F36, "gtk__text_buffer__finalize_spec");
      begin
         F36;
      end;
      E580 := E580 - 1;
      declare
         procedure F37;
         pragma Import (Ada, F37, "gtk__text_child_anchor__finalize_spec");
      begin
         F37;
      end;
      E572 := E572 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "gtk__table__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "gtk__gentry__finalize_spec");
      begin
         F39;
      end;
      E249 := E249 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "gtk__image__finalize_spec");
      begin
         F40;
      end;
      E251 := E251 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "gtk__icon_set__finalize_spec");
      begin
         F41;
      end;
      declare
         procedure F42;
         pragma Import (Ada, F42, "gtk__style_context__finalize_spec");
      begin
         F42;
      end;
      declare
         procedure F43;
         pragma Import (Ada, F43, "gtk__status_bar__finalize_spec");
      begin
         F43;
      end;
      declare
         procedure F44;
         pragma Import (Ada, F44, "gtk__scrolled_window__finalize_spec");
      begin
         F44;
      end;
      E341 := E341 - 1;
      declare
         procedure F45;
         pragma Import (Ada, F45, "gtk__scrollbar__finalize_spec");
      begin
         F45;
      end;
      declare
         procedure F46;
         pragma Import (Ada, F46, "gtk__notebook__finalize_spec");
      begin
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "gtk__label__finalize_spec");
      begin
         F47;
      end;
      E261 := E261 - 1;
      declare
         procedure F48;
         pragma Import (Ada, F48, "gtk__misc__finalize_spec");
      begin
         F48;
      end;
      E570 := E570 - 1;
      declare
         procedure F49;
         pragma Import (Ada, F49, "gtk__menu_bar__finalize_spec");
      begin
         F49;
      end;
      declare
         procedure F50;
         pragma Import (Ada, F50, "gtk__menu__finalize_spec");
      begin
         F50;
      end;
      declare
         procedure F51;
         pragma Import (Ada, F51, "gtk__menu_shell__finalize_spec");
      begin
         F51;
      end;
      E323 := E323 - 1;
      declare
         procedure F52;
         pragma Import (Ada, F52, "gtk__image_menu_item__finalize_spec");
      begin
         F52;
      end;
      declare
         procedure F53;
         pragma Import (Ada, F53, "gtk__menu_item__finalize_spec");
      begin
         F53;
      end;
      declare
         procedure F54;
         pragma Import (Ada, F54, "gtk__handle_box__finalize_spec");
      begin
         F54;
      end;
      declare
         procedure F55;
         pragma Import (Ada, F55, "gtk__grange__finalize_spec");
      begin
         F55;
      end;
      E518 := E518 - 1;
      declare
         procedure F56;
         pragma Import (Ada, F56, "gtk__frame__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "gtk__entry_completion__finalize_spec");
      begin
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "gtk__button__finalize_spec");
      begin
         F58;
      end;
      E160 := E160 - 1;
      declare
         procedure F59;
         pragma Import (Ada, F59, "gtk__box__finalize_spec");
      begin
         F59;
      end;
      E516 := E516 - 1;
      declare
         procedure F60;
         pragma Import (Ada, F60, "gtk__alignment__finalize_spec");
      begin
         F60;
      end;
      E225 := E225 - 1;
      declare
         procedure F61;
         pragma Import (Ada, F61, "gtk__bin__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "gtk__container__finalize_spec");
      begin
         F62;
      end;
      declare
         procedure F63;
         pragma Import (Ada, F63, "gtk__cell_renderer_text__finalize_spec");
      begin
         F63;
      end;
      E564 := E564 - 1;
      declare
         procedure F64;
         pragma Import (Ada, F64, "gtk__cell_renderer_pixbuf__finalize_spec");
      begin
         F64;
      end;
      declare
         procedure F65;
         pragma Import (Ada, F65, "gtk__cell_area__finalize_spec");
      begin
         F65;
      end;
      declare
         procedure F66;
         pragma Import (Ada, F66, "gtk__cell_renderer__finalize_spec");
      begin
         F66;
      end;
      declare
         procedure F67;
         pragma Import (Ada, F67, "gtk__action__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "gtk__widget__finalize_spec");
      begin
         F68;
      end;
      E277 := E277 - 1;
      declare
         procedure F69;
         pragma Import (Ada, F69, "gtk__print_context__finalize_spec");
      begin
         F69;
      end;
      E213 := E213 - 1;
      declare
         procedure F70;
         pragma Import (Ada, F70, "pango__layout__finalize_spec");
      begin
         F70;
      end;
      E217 := E217 - 1;
      declare
         procedure F71;
         pragma Import (Ada, F71, "pango__tabs__finalize_spec");
      begin
         F71;
      end;
      E279 := E279 - 1;
      declare
         procedure F72;
         pragma Import (Ada, F72, "pango__font_map__finalize_spec");
      begin
         F72;
      end;
      E195 := E195 - 1;
      declare
         procedure F73;
         pragma Import (Ada, F73, "pango__context__finalize_spec");
      begin
         F73;
      end;
      E209 := E209 - 1;
      declare
         procedure F74;
         pragma Import (Ada, F74, "pango__fontset__finalize_spec");
      begin
         F74;
      end;
      E205 := E205 - 1;
      declare
         procedure F75;
         pragma Import (Ada, F75, "pango__font_family__finalize_spec");
      begin
         F75;
      end;
      E207 := E207 - 1;
      declare
         procedure F76;
         pragma Import (Ada, F76, "pango__font_face__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "gtk__text_tag_table__finalize_spec");
      begin
         F77;
      end;
      E291 := E291 - 1;
      declare
         procedure F78;
         pragma Import (Ada, F78, "gtk__text_tag__finalize_spec");
      begin
         F78;
      end;
      E199 := E199 - 1;
      declare
         procedure F79;
         pragma Import (Ada, F79, "pango__font__finalize_spec");
      begin
         F79;
      end;
      E203 := E203 - 1;
      declare
         procedure F80;
         pragma Import (Ada, F80, "pango__language__finalize_spec");
      begin
         F80;
      end;
      E201 := E201 - 1;
      declare
         procedure F81;
         pragma Import (Ada, F81, "pango__font_metrics__finalize_spec");
      begin
         F81;
      end;
      E215 := E215 - 1;
      declare
         procedure F82;
         pragma Import (Ada, F82, "pango__attributes__finalize_spec");
      begin
         F82;
      end;
      declare
         procedure F83;
         pragma Import (Ada, F83, "mast__timers__finalize_spec");
      begin
         F83;
      end;
      declare
         procedure F84;
         pragma Import (Ada, F84, "mast__synchronization_parameters__finalize_spec");
      begin
         F84;
      end;
      declare
         procedure F85;
         pragma Import (Ada, F85, "mast__scheduling_policies__finalize_spec");
      begin
         F85;
      end;
      declare
         procedure F86;
         pragma Import (Ada, F86, "mast__scheduling_parameters__finalize_spec");
      begin
         F86;
      end;
      E330 := E330 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "gtk__tree_store__finalize_spec");
      begin
         F87;
      end;
      declare
         procedure F88;
         pragma Import (Ada, F88, "gtk__tree_model__finalize_spec");
      begin
         F88;
      end;
      E582 := E582 - 1;
      declare
         procedure F89;
         pragma Import (Ada, F89, "gtk__text_mark__finalize_spec");
      begin
         F89;
      end;
      declare
         procedure F90;
         pragma Import (Ada, F90, "gtk__clipboard__finalize_spec");
      begin
         F90;
      end;
      E263 := E263 - 1;
      declare
         procedure F91;
         pragma Import (Ada, F91, "gtk__target_list__finalize_spec");
      begin
         F91;
      end;
      declare
         procedure F92;
         pragma Import (Ada, F92, "gtk__style__finalize_spec");
      begin
         F92;
      end;
      E190 := E190 - 1;
      declare
         procedure F93;
         pragma Import (Ada, F93, "gtk__selection_data__finalize_spec");
      begin
         F93;
      end;
      E283 := E283 - 1;
      declare
         procedure F94;
         pragma Import (Ada, F94, "gtk__print_settings__finalize_spec");
      begin
         F94;
      end;
      E271 := E271 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "gtk__page_setup__finalize_spec");
      begin
         F95;
      end;
      E275 := E275 - 1;
      declare
         procedure F96;
         pragma Import (Ada, F96, "gtk__paper_size__finalize_spec");
      begin
         F96;
      end;
      E253 := E253 - 1;
      declare
         procedure F97;
         pragma Import (Ada, F97, "gtk__icon_source__finalize_spec");
      begin
         F97;
      end;
      E552 := E552 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "gtk__file_filter__finalize_spec");
      begin
         F98;
      end;
      declare
         procedure F99;
         pragma Import (Ada, F99, "gtk__entry_buffer__finalize_spec");
      begin
         F99;
      end;
      E257 := E257 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "gtk__css_section__finalize_spec");
      begin
         F100;
      end;
      E241 := E241 - 1;
      declare
         procedure F101;
         pragma Import (Ada, F101, "gtk__cell_area_context__finalize_spec");
      begin
         F101;
      end;
      E164 := E164 - 1;
      declare
         procedure F102;
         pragma Import (Ada, F102, "gtk__builder__finalize_spec");
      begin
         F102;
      end;
      declare
         procedure F103;
         pragma Import (Ada, F103, "gtk__adjustment__finalize_spec");
      begin
         F103;
      end;
      declare
         procedure F104;
         pragma Import (Ada, F104, "gtk__accel_group__finalize_spec");
      begin
         F104;
      end;
      declare
         procedure F105;
         pragma Import (Ada, F105, "glib__menu_model__finalize_spec");
      begin
         F105;
      end;
      E293 := E293 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "glib__variant__finalize_spec");
      begin
         F106;
      end;
      E180 := E180 - 1;
      declare
         procedure F107;
         pragma Import (Ada, F107, "gdk__drag_contexts__finalize_spec");
      begin
         F107;
      end;
      E178 := E178 - 1;
      declare
         procedure F108;
         pragma Import (Ada, F108, "gdk__device__finalize_spec");
      begin
         F108;
      end;
      E152 := E152 - 1;
      declare
         procedure F109;
         pragma Import (Ada, F109, "gdk__screen__finalize_spec");
      begin
         F109;
      end;
      E186 := E186 - 1;
      declare
         procedure F110;
         pragma Import (Ada, F110, "gdk__pixbuf__finalize_spec");
      begin
         F110;
      end;
      declare
         procedure F111;
         pragma Import (Ada, F111, "gdk__display__finalize_spec");
      begin
         F111;
      end;
      declare
         procedure F112;
         pragma Import (Ada, F112, "gdk__frame_clock__finalize_spec");
      begin
         F112;
      end;
      E109 := E109 - 1;
      declare
         procedure F113;
         pragma Import (Ada, F113, "glib__object__finalize_spec");
      begin
         F113;
      end;
      E184 := E184 - 1;
      declare
         procedure F114;
         pragma Import (Ada, F114, "gdk__frame_timings__finalize_spec");
      begin
         F114;
      end;
      E103 := E103 - 1;
      declare
         procedure F115;
         pragma Import (Ada, F115, "glib__finalize_spec");
      begin
         F115;
      end;
      E058 := E058 - 1;
      declare
         procedure F116;
         pragma Import (Ada, F116, "ada__text_io__finalize_spec");
      begin
         F116;
      end;
      E534 := E534 - 1;
      E544 := E544 - 1;
      declare
         procedure F117;
         pragma Import (Ada, F117, "system__regexp__finalize_spec");
      begin
         F117;
      end;
      declare
         procedure F118;
         pragma Import (Ada, F118, "ada__directories__finalize_spec");
      begin
         F118;
      end;
      E373 := E373 - 1;
      declare
         procedure F119;
         pragma Import (Ada, F119, "ada__strings__unbounded__finalize_spec");
      begin
         F119;
      end;
      E081 := E081 - 1;
      E095 := E095 - 1;
      declare
         procedure F120;
         pragma Import (Ada, F120, "system__file_io__finalize_body");
      begin
         E066 := E066 - 1;
         F120;
      end;
      E419 := E419 - 1;
      declare
         procedure F121;
         pragma Import (Ada, F121, "ada__streams__stream_io__finalize_spec");
      begin
         F121;
      end;
      declare
         procedure F122;
         pragma Import (Ada, F122, "system__file_control_block__finalize_spec");
      begin
         E079 := E079 - 1;
         F122;
      end;
      E091 := E091 - 1;
      declare
         procedure F123;
         pragma Import (Ada, F123, "system__pool_global__finalize_spec");
      begin
         F123;
      end;
      declare
         procedure F124;
         pragma Import (Ada, F124, "system__storage_pools__subpools__finalize_spec");
      begin
         F124;
      end;
      declare
         procedure F125;
         pragma Import (Ada, F125, "system__finalization_masters__finalize_spec");
      begin
         F125;
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
      E401 := E401 + 1;
      System.Fat_Lflt'Elab_Spec;
      E349 := E349 + 1;
      System.Fat_Llf'Elab_Spec;
      E352 := E352 + 1;
      System.Fat_Sflt'Elab_Spec;
      E415 := E415 + 1;
      System.Exception_Table'Elab_Body;
      E019 := E019 + 1;
      Ada.Containers'Elab_Spec;
      E587 := E587 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E061 := E061 + 1;
      Ada.Numerics'Elab_Spec;
      E610 := E610 + 1;
      Ada.Strings'Elab_Spec;
      E366 := E366 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E371 := E371 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E060 := E060 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E021 := E021 + 1;
      System.Finalization_Root'Elab_Spec;
      E070 := E070 + 1;
      Ada.Finalization'Elab_Spec;
      E068 := E068 + 1;
      System.Storage_Pools'Elab_Spec;
      E089 := E089 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E388 := E388 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E538 := E538 + 1;
      System.Assertions'Elab_Spec;
      E319 := E319 + 1;
      System.Pool_Global'Elab_Spec;
      E091 := E091 + 1;
      System.File_Control_Block'Elab_Spec;
      E079 := E079 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E419 := E419 + 1;
      System.Random_Seed'Elab_Body;
      E618 := E618 + 1;
      System.File_Io'Elab_Body;
      E066 := E066 + 1;
      E095 := E095 + 1;
      System.Finalization_Masters'Elab_Body;
      E081 := E081 + 1;
      E105 := E105 + 1;
      E072 := E072 + 1;
      Ada.Tags'Elab_Body;
      E045 := E045 + 1;
      E368 := E368 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E076 := E076 + 1;
      System.Secondary_Stack'Elab_Body;
      E009 := E009 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E373 := E373 + 1;
      Ada.Directories'Elab_Spec;
      System.Regexp'Elab_Spec;
      E544 := E544 + 1;
      Ada.Directories'Elab_Body;
      E534 := E534 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E417 := E417 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E058 := E058 + 1;
      Glib'Elab_Spec;
      E103 := E103 + 1;
      Gtkada.Types'Elab_Spec;
      E126 := E126 + 1;
      E405 := E405 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      E184 := E184 + 1;
      E128 := E128 + 1;
      Gdk.Visual'Elab_Spec;
      Gdk.Visual'Elab_Body;
      E156 := E156 + 1;
      E130 := E130 + 1;
      Glib.Object'Elab_Spec;
      E111 := E111 + 1;
      Glib.Values'Elab_Body;
      E122 := E122 + 1;
      E136 := E136 + 1;
      E138 := E138 + 1;
      Gdk.Color'Elab_Spec;
      E143 := E143 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E146 := E146 + 1;
      E509 := E509 + 1;
      E124 := E124 + 1;
      Gtkada.Bindings'Elab_Spec;
      E114 := E114 + 1;
      E229 := E229 + 1;
      E120 := E120 + 1;
      E295 := E295 + 1;
      Glib.Object'Elab_Body;
      E109 := E109 + 1;
      Gdk.Rgba'Elab_Body;
      E148 := E148 + 1;
      Gdk.Color'Elab_Body;
      E176 := E176 + 1;
      E273 := E273 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Types'Elab_Spec;
      E144 := E144 + 1;
      Gdk.Event'Elab_Spec;
      E141 := E141 + 1;
      Gdk.Display'Elab_Spec;
      Gdk.Pixbuf'Elab_Spec;
      E186 := E186 + 1;
      Glib.Properties'Elab_Spec;
      E158 := E158 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E152 := E152 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Device'Elab_Body;
      E178 := E178 + 1;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Body;
      E180 := E180 + 1;
      Gdk.Window'Elab_Spec;
      E223 := E223 + 1;
      Glib.Variant'Elab_Spec;
      E293 := E293 + 1;
      Glib.Menu_Model'Elab_Spec;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Actionable'Elab_Spec;
      E299 := E299 + 1;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E164 := E164 + 1;
      E162 := E162 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E241 := E241 + 1;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Css_Section'Elab_Spec;
      E257 := E257 + 1;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Enums'Elab_Spec;
      E172 := E172 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E552 := E552 + 1;
      Gtk.Icon_Source'Elab_Spec;
      E253 := E253 + 1;
      Gtk.Orientable'Elab_Spec;
      E219 := E219 + 1;
      Gtk.Paper_Size'Elab_Spec;
      E275 := E275 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E271 := E271 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E283 := E283 + 1;
      Gtk.Scrollable'Elab_Spec;
      E309 := E309 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E190 := E190 + 1;
      E558 := E558 + 1;
      Gtk.Style'Elab_Spec;
      E265 := E265 + 1;
      Gtk.Target_List'Elab_Spec;
      E263 := E263 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E582 := E582 + 1;
      Gtk.Tree_Model'Elab_Spec;
      E332 := E332 + 1;
      E334 := E334 + 1;
      Gtk.Tree_Store'Elab_Spec;
      Gtk.Tree_Store'Elab_Body;
      E330 := E330 + 1;
      Gtkada.Pixmaps'Elab_Spec;
      E562 := E562 + 1;
      Gmastresults_Pixmaps'Elab_Spec;
      E561 := E561 + 1;
      List_Exceptions'Elab_Spec;
      E344 := E344 + 1;
      E425 := E425 + 1;
      E433 := E433 + 1;
      E628 := E628 + 1;
      E595 := E595 + 1;
      E656 := E656 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      Mast.Hospa_Parameters'Elab_Body;
      E626 := E626 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E620 := E620 + 1;
      E481 := E481 + 1;
      mast_lex_io'elab_spec;
      E483 := E483 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E486 := E486 + 1;
      E499 := E499 + 1;
      mast_results_lex_io'elab_spec;
      E501 := E501 + 1;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E504 := E504 + 1;
      Pango.Enums'Elab_Spec;
      E197 := E197 + 1;
      Pango.Attributes'Elab_Spec;
      E215 := E215 + 1;
      Pango.Font_Metrics'Elab_Spec;
      E201 := E201 + 1;
      Pango.Language'Elab_Spec;
      E203 := E203 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E199 := E199 + 1;
      E289 := E289 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E291 := E291 + 1;
      Gtk.Text_Iter'Elab_Spec;
      E287 := E287 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E207 := E207 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E205 := E205 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E209 := E209 + 1;
      E211 := E211 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E195 := E195 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E279 := E279 + 1;
      Pango.Tabs'Elab_Spec;
      E217 := E217 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E213 := E213 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E277 := E277 + 1;
      Gtk.Widget'Elab_Spec;
      Gtk.Action'Elab_Spec;
      Gtk.Activatable'Elab_Spec;
      E301 := E301 + 1;
      Gtk.Cell_Renderer'Elab_Spec;
      E243 := E243 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Cell_Renderer_Pixbuf'Elab_Spec;
      Gtk.Cell_Renderer_Pixbuf'Elab_Body;
      E564 := E564 + 1;
      Gtk.Cell_Renderer_Text'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E225 := E225 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E516 := E516 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E160 := E160 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.File_Chooser'Elab_Spec;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E518 := E518 + 1;
      Gtk.Grange'Elab_Spec;
      Gtk.Handle_Box'Elab_Spec;
      E556 := E556 + 1;
      E321 := E321 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Image_Menu_Item'Elab_Spec;
      Gtk.Image_Menu_Item'Elab_Body;
      E323 := E323 + 1;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu_Bar'Elab_Spec;
      Gtk.Menu_Bar'Elab_Body;
      E570 := E570 + 1;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E261 := E261 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Notebook'Elab_Spec;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E341 := E341 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Status_Bar'Elab_Spec;
      E259 := E259 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      E251 := E251 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E249 := E249 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E572 := E572 + 1;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E580 := E580 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E311 := E311 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E303 := E303 + 1;
      Gtk.Window'Elab_Spec;
      Error_Window_Pkg'Elab_Spec;
      Gmast_Results_Pkg'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Dialog_Event_Pkg'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E554 := E554 + 1;
      Gtk.Print_Operation'Elab_Spec;
      Gtk.Arguments'Elab_Spec;
      E134 := E134 + 1;
      Gtk.Print_Operation'Elab_Body;
      E269 := E269 + 1;
      Gtk.Dialog'Elab_Body;
      E150 := E150 + 1;
      Gtk.Window'Elab_Body;
      E221 := E221 + 1;
      Gtk.Combo_Box'Elab_Body;
      E305 := E305 + 1;
      Gtk.Tree_View'Elab_Body;
      E307 := E307 + 1;
      Gtk.Tree_View_Column'Elab_Body;
      E315 := E315 + 1;
      Gtk.Tree_Selection'Elab_Body;
      E313 := E313 + 1;
      Gtk.Text_View'Elab_Body;
      E574 := E574 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E576 := E576 + 1;
      Gtk.Gentry'Elab_Body;
      E227 := E227 + 1;
      Gtk.Style_Context'Elab_Body;
      E255 := E255 + 1;
      Gtk.Status_Bar'Elab_Body;
      E285 := E285 + 1;
      Gtk.Scrolled_Window'Elab_Body;
      E339 := E339 + 1;
      Gtk.Notebook'Elab_Body;
      E267 := E267 + 1;
      Gtk.Label'Elab_Body;
      E520 := E520 + 1;
      Gtk.Menu'Elab_Body;
      E522 := E522 + 1;
      Gtk.Menu_Shell'Elab_Body;
      E526 := E526 + 1;
      Gtk.Menu_Item'Elab_Body;
      E325 := E325 + 1;
      Gtk.Handle_Box'Elab_Body;
      E568 := E568 + 1;
      Gtk.Grange'Elab_Body;
      E343 := E343 + 1;
      E550 := E550 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E237 := E237 + 1;
      Gtk.Button'Elab_Body;
      E132 := E132 + 1;
      Gtk.Container'Elab_Body;
      E168 := E168 + 1;
      Gtk.Cell_Renderer_Text'Elab_Body;
      E513 := E513 + 1;
      Gtk.Cell_Area'Elab_Body;
      E239 := E239 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E245 := E245 + 1;
      Gtk.Action'Elab_Body;
      E297 := E297 + 1;
      Gtk.Widget'Elab_Body;
      E174 := E174 + 1;
      E281 := E281 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E584 := E584 + 1;
      E336 := E336 + 1;
      E247 := E247 + 1;
      Gtk.Clipboard'Elab_Body;
      E578 := E578 + 1;
      Gtk.Style'Elab_Body;
      E192 := E192 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E235 := E235 + 1;
      E231 := E231 + 1;
      Gtk.Adjustment'Elab_Body;
      E170 := E170 + 1;
      Gtk.Accel_Group'Elab_Body;
      E188 := E188 + 1;
      Glib.Menu_Model'Elab_Body;
      E524 := E524 + 1;
      Gdk.Display'Elab_Body;
      E154 := E154 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E182 := E182 + 1;
      E233 := E233 + 1;
      E548 := E548 + 1;
      Callbacks_Gmastresults'Elab_Spec;
      E100 := E100 + 1;
      Gtkada.Handlers'Elab_Spec;
      E514 := E514 + 1;
      E099 := E099 + 1;
      E530 := E530 + 1;
      E546 := E546 + 1;
      Gtkada.File_Selection'Elab_Body;
      E560 := E560 + 1;
      E634 := E634 + 1;
      E605 := E605 + 1;
      Var_Strings'Elab_Spec;
      E361 := E361 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E603 := E603 + 1;
      Mast'Elab_Body;
      E346 := E346 + 1;
      MAST.IO'ELAB_SPEC;
      E471 := E471 + 1;
      E437 := E437 + 1;
      E457 := E457 + 1;
      E435 := E435 + 1;
      E410 := E410 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E384 := E384 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E423 := E423 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E455 := E455 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E469 := E469 + 1;
      Mast.Schedulers'Elab_Spec;
      E453 := E453 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E473 := E473 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E449 := E449 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E445 := E445 + 1;
      Mast.Drivers'Elab_Spec;
      E465 := E465 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E443 := E443 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E463 := E463 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E439 := E439 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E427 := E427 + 1;
      E431 := E431 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E441 := E441 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E459 := E459 + 1;
      E461 := E461 + 1;
      E467 := E467 + 1;
      E451 := E451 + 1;
      MAST.TOOLS.SCHEDULABILITY_INDEX'ELAB_SPEC;
      E632 := E632 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E597 := E597 + 1;
      E660 := E660 + 1;
      E601 := E601 + 1;
      E636 := E636 + 1;
      E609 := E609 + 1;
      MAST.RESTRICTIONS'ELAB_BODY;
      E658 := E658 + 1;
      MAST.MISCELANEOUS_TOOLS'ELAB_BODY;
      E654 := E654 + 1;
      E607 := E607 + 1;
      E599 := E599 + 1;
      MAST.CONSISTENCY_CHECKS'ELAB_BODY;
      E593 := E593 + 1;
      E652 := E652 + 1;
      E586 := E586 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E408 := E408 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E406 := E406 + 1;
      MAST.IO'ELAB_BODY;
      E386 := E386 + 1;
      Mast_Actions'Elab_Spec;
      E532 := E532 + 1;
      E327 := E327 + 1;
      E479 := E479 + 1;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E502 := E502 + 1;
      E497 := E497 + 1;
      E475 := E475 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_gmastresults");

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
   --   ./gmastresults_intl.o
   --   ./gmastresults_pixmaps.o
   --   ../../mast_analysis/list_exceptions.o
   --   ../../mast_analysis/indexed_lists.o
   --   ../../mast_analysis/hash_lists.o
   --   ../../mast_analysis/dynamic_lists.o
   --   ../../mast_analysis/doubly_linked_lists.o
   --   ../../mast_analysis/associations.o
   --   ../../mast_analysis/mast-hospa_parameters.o
   --   ../../mast_analysis/mast-annealing_parameters.o
   --   ../../mast_analysis/mast_lex_dfa.o
   --   ../../mast_analysis/mast_lex_io.o
   --   ../../mast_analysis/mast_parser_error_report.o
   --   ../../mast_analysis/mast_parser_goto.o
   --   ../../mast_analysis/mast_parser_shift_reduce.o
   --   ./mast_results_lex_dfa.o
   --   ./mast_results_lex_io.o
   --   ./mast_results_parser_error_report.o
   --   ./mast_results_parser_goto.o
   --   ./mast_results_parser_shift_reduce.o
   --   ./clear_results.o
   --   ./clear_timing_results.o
   --   ./resize_timing_results.o
   --   ./error_window_pkg-callbacks.o
   --   ./callbacks_gmastresults.o
   --   ./dialog_event_pkg.o
   --   ./gmast_results_pkg.o
   --   ./error_window_pkg.o
   --   ../../mast_analysis/priority_queues.o
   --   ../../mast_analysis/trimmed_image.o
   --   ../../mast_analysis/var_strings.o
   --   ../../mast_analysis/mast-tool_exceptions.o
   --   ../../mast_analysis/mast.o
   --   ../../mast_analysis/mast-timers.o
   --   ../../mast_analysis/mast-synchronization_parameters.o
   --   ../../mast_analysis/mast-scheduling_policies.o
   --   ../../mast_analysis/mast-scheduling_parameters.o
   --   ../../mast_analysis/named_lists.o
   --   ../../mast_analysis/mast-events.o
   --   ../../mast_analysis/mast-graphs.o
   --   ../../mast_analysis/mast-processing_resources.o
   --   ./mast-processing_resources-processor.o
   --   ../../mast_analysis/mast-schedulers.o
   --   ../../mast_analysis/mast-schedulers-secondary.o
   --   ./mast-shared_resources.o
   --   ../../mast_analysis/mast-operations.o
   --   ../../mast_analysis/mast-drivers.o
   --   ../../mast_analysis/mast-graphs-event_handlers.o
   --   ./mast-processing_resources-network.o
   --   ../../mast_analysis/mast-timing_requirements.o
   --   ../../mast_analysis/mast-graphs-links.o
   --   ./mast-results.o
   --   ../../mast_analysis/mast-transactions.o
   --   ../../mast_analysis/mast-schedulers-primary.o
   --   ../../mast_analysis/mast-systems.o
   --   ../../mast_analysis/mast-schedulers-adjustment.o
   --   ../../mast_analysis/mast-scheduling_servers.o
   --   ../../mast_analysis/mast-tools-schedulability_index.o
   --   ../../mast_analysis/mast-transaction_operations.o
   --   ../../mast_analysis/mast-monoprocessor_tools.o
   --   ../../mast_analysis/mast-linear_translation.o
   --   ../../mast_analysis/mast-linear_scheduling_parameters_assignment_tools.o
   --   ../../mast_analysis/mast-linear_priority_assignment_tools.o
   --   ../../mast_analysis/mast-restrictions.o
   --   ../../mast_analysis/mast-miscelaneous_tools.o
   --   ../../mast_analysis/mast-max_numbers.o
   --   ../../mast_analysis/mast-linear_analysis_tools.o
   --   ../../mast_analysis/mast-consistency_checks.o
   --   ../../mast_analysis/mast-linear_task_analysis_tools.o
   --   ../../mast_analysis/mast-tools.o
   --   ../../mast_analysis/symbol_table.o
   --   ../../mast_analysis/mast_parser_tokens.o
   --   ../../mast_analysis/mast-io.o
   --   ./draw_results.o
   --   ./draw_timing_results.o
   --   ./gmast_results_pkg-callbacks.o
   --   ./dialog_event_pkg-callbacks.o
   --   ./gmastresults.o
   --   ../../mast_analysis/mast_lex.o
   --   ../../mast_analysis/mast_parser.o
   --   ./mast_results_parser_tokens.o
   --   ./mast_results_lex.o
   --   ./mast_results_parser.o
   --   ./mast_actions.o
   --   -L./
   --   -L../../mast_analysis/
   --   -L../../utils/
   --   -L/home/mgh/gnat2014/gtkada/lib/gtkada/relocatable/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
