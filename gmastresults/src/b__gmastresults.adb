pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__gmastresults.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__gmastresults.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E073 : Short_Integer; pragma Import (Ada, E073, "system__os_lib_E");
   E011 : Short_Integer; pragma Import (Ada, E011, "ada__exceptions_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__soft_links_E");
   E024 : Short_Integer; pragma Import (Ada, E024, "system__exception_table_E");
   E040 : Short_Integer; pragma Import (Ada, E040, "ada__containers_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__io_exceptions_E");
   E031 : Short_Integer; pragma Import (Ada, E031, "ada__numerics_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__strings_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__strings__maps_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "ada__strings__maps__constants_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "interfaces__c_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E084 : Short_Integer; pragma Import (Ada, E084, "system__object_reader_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "system__dwarf_lines_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "system__soft_links__initialize_E");
   E039 : Short_Integer; pragma Import (Ada, E039, "system__traceback__symbolic_E");
   E399 : Short_Integer; pragma Import (Ada, E399, "ada__assertions_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__strings__utf_encoding_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "ada__tags_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__strings__text_buffers_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "gnat_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "interfaces__c__strings_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "ada__streams_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "system__file_control_block_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "system__finalization_root_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "ada__finalization_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "system__file_io_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "system__storage_pools_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "system__finalization_masters_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "system__storage_pools__subpools_E");
   E439 : Short_Integer; pragma Import (Ada, E439, "ada__strings__unbounded_E");
   E453 : Short_Integer; pragma Import (Ada, E453, "ada__calendar_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__text_io_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "system__pool_global_E");
   E616 : Short_Integer; pragma Import (Ada, E616, "system__random_seed_E");
   E562 : Short_Integer; pragma Import (Ada, E562, "system__regexp_E");
   E552 : Short_Integer; pragma Import (Ada, E552, "ada__directories_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "glib_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "gtkada__types_E");
   E473 : Short_Integer; pragma Import (Ada, E473, "binary_trees_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "gdk__frame_timings_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "glib__glist_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "gdk__visual_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "glib__gslist_E");
   E659 : Short_Integer; pragma Import (Ada, E659, "gmastresults_intl_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "gtkada__c_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "glib__object_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "glib__type_conversion_hooks_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "glib__types_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "glib__values_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "gtkada__bindings_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "cairo_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "cairo__region_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "gdk__rectangle_E");
   E197 : Short_Integer; pragma Import (Ada, E197, "glib__generic_properties_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "gdk__color_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "gdk__rgba_E");
   E345 : Short_Integer; pragma Import (Ada, E345, "glib__key_file_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "glib__properties_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "gdk__device_tool_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "gdk__drawing_context_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "gdk__event_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "glib__string_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "glib__variant_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "glib__g_icon_E");
   E379 : Short_Integer; pragma Import (Ada, E379, "gtk__actionable_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "gtk__builder_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__buildable_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "gtk__cell_area_context_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "gtk__css_section_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "gtk__enums_E");
   E676 : Short_Integer; pragma Import (Ada, E676, "gtk__file_filter_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "gtk__orientable_E");
   E347 : Short_Integer; pragma Import (Ada, E347, "gtk__paper_size_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "gtk__page_setup_E");
   E353 : Short_Integer; pragma Import (Ada, E353, "gtk__print_settings_E");
   E589 : Short_Integer; pragma Import (Ada, E589, "gtk__stock_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "gtk__target_entry_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "gtk__target_list_E");
   E373 : Short_Integer; pragma Import (Ada, E373, "gtk__text_mark_E");
   E587 : Short_Integer; pragma Import (Ada, E587, "gtkada__pixmaps_E");
   E586 : Short_Integer; pragma Import (Ada, E586, "gmastresults_pixmaps_E");
   E424 : Short_Integer; pragma Import (Ada, E424, "list_exceptions_E");
   E601 : Short_Integer; pragma Import (Ada, E601, "doubly_linked_lists_E");
   E640 : Short_Integer; pragma Import (Ada, E640, "dynamic_lists_E");
   E647 : Short_Integer; pragma Import (Ada, E647, "associations_E");
   E496 : Short_Integer; pragma Import (Ada, E496, "hash_lists_E");
   E488 : Short_Integer; pragma Import (Ada, E488, "indexed_lists_E");
   E546 : Short_Integer; pragma Import (Ada, E546, "mast_lex_dfa_E");
   E548 : Short_Integer; pragma Import (Ada, E548, "mast_lex_io_E");
   E550 : Short_Integer; pragma Import (Ada, E550, "mast_parser_error_report_E");
   E571 : Short_Integer; pragma Import (Ada, E571, "mast_results_lex_dfa_E");
   E573 : Short_Integer; pragma Import (Ada, E573, "mast_results_lex_io_E");
   E576 : Short_Integer; pragma Import (Ada, E576, "mast_results_parser_error_report_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "pango__enums_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "pango__attributes_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "pango__font_metrics_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "pango__language_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "pango__font_E");
   E359 : Short_Integer; pragma Import (Ada, E359, "gtk__text_attributes_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "gtk__text_tag_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "pango__font_face_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "pango__font_family_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "pango__fontset_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "pango__matrix_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "pango__context_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "pango__font_map_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "pango__tabs_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "pango__layout_E");
   E349 : Short_Integer; pragma Import (Ada, E349, "gtk__print_context_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "gdk__frame_clock_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "gdk__monitor_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "gdk__display_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "gdk__glcontext_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "gdk__pixbuf_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "gdk__screen_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "gdk__device_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "gdk__drag_contexts_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "gdk__window_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "glib__action_group_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "gtk__accel_group_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "gtk__adjustment_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "gtk__cell_editable_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "gtk__editable_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "gtk__entry_buffer_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "gtk__icon_source_E");
   E351 : Short_Integer; pragma Import (Ada, E351, "gtk__print_operation_preview_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "gtk__selection_data_E");
   E369 : Short_Integer; pragma Import (Ada, E369, "gtk__clipboard_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "gtk__style_E");
   E365 : Short_Integer; pragma Import (Ada, E365, "gtk__scrollable_E");
   E357 : Short_Integer; pragma Import (Ada, E357, "gtk__text_iter_E");
   E375 : Short_Integer; pragma Import (Ada, E375, "gtk__text_tag_table_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "gtk__tree_model_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "gtk__widget_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "gtk__cell_renderer_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "gtk__cell_layout_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "gtk__cell_area_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__container_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "gtk__bin_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__box_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "gtk__entry_completion_E");
   E337 : Short_Integer; pragma Import (Ada, E337, "gtk__misc_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "gtk__notebook_E");
   E355 : Short_Integer; pragma Import (Ada, E355, "gtk__status_bar_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "gtk__style_provider_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "gtk__settings_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "gtk__style_context_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "gtk__icon_set_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "gtk__image_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "gtk__gentry_E");
   E371 : Short_Integer; pragma Import (Ada, E371, "gtk__text_child_anchor_E");
   E367 : Short_Integer; pragma Import (Ada, E367, "gtk__text_buffer_E");
   E363 : Short_Integer; pragma Import (Ada, E363, "gtk__text_view_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "gtk__window_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "gtk__dialog_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gtk__print_operation_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "gtk__arguments_E");
   E670 : Short_Integer; pragma Import (Ada, E670, "glib__menu_model_E");
   E377 : Short_Integer; pragma Import (Ada, E377, "gtk__action_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "gtk__activatable_E");
   E664 : Short_Integer; pragma Import (Ada, E664, "gtk__alignment_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gtk__button_E");
   E685 : Short_Integer; pragma Import (Ada, E685, "gtk__cell_renderer_pixbuf_E");
   E687 : Short_Integer; pragma Import (Ada, E687, "gtk__cell_renderer_text_E");
   E674 : Short_Integer; pragma Import (Ada, E674, "gtk__file_chooser_E");
   E678 : Short_Integer; pragma Import (Ada, E678, "gtk__file_chooser_dialog_E");
   E691 : Short_Integer; pragma Import (Ada, E691, "gtk__frame_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "gtk__grange_E");
   E693 : Short_Integer; pragma Import (Ada, E693, "gtk__handle_box_E");
   E680 : Short_Integer; pragma Import (Ada, E680, "gtk__main_E");
   E401 : Short_Integer; pragma Import (Ada, E401, "gtk__marshallers_E");
   E405 : Short_Integer; pragma Import (Ada, E405, "gtk__menu_item_E");
   E403 : Short_Integer; pragma Import (Ada, E403, "gtk__image_menu_item_E");
   E672 : Short_Integer; pragma Import (Ada, E672, "gtk__menu_shell_E");
   E668 : Short_Integer; pragma Import (Ada, E668, "gtk__menu_E");
   E666 : Short_Integer; pragma Import (Ada, E666, "gtk__label_E");
   E695 : Short_Integer; pragma Import (Ada, E695, "gtk__menu_bar_E");
   E421 : Short_Integer; pragma Import (Ada, E421, "gtk__scrollbar_E");
   E419 : Short_Integer; pragma Import (Ada, E419, "gtk__scrolled_window_E");
   E697 : Short_Integer; pragma Import (Ada, E697, "gtk__table_E");
   E389 : Short_Integer; pragma Import (Ada, E389, "gtk__tooltip_E");
   E412 : Short_Integer; pragma Import (Ada, E412, "gtk__tree_drag_dest_E");
   E414 : Short_Integer; pragma Import (Ada, E414, "gtk__tree_drag_source_E");
   E391 : Short_Integer; pragma Import (Ada, E391, "gtk__tree_selection_E");
   E416 : Short_Integer; pragma Import (Ada, E416, "gtk__tree_sortable_E");
   E410 : Short_Integer; pragma Import (Ada, E410, "gtk__tree_store_E");
   E393 : Short_Integer; pragma Import (Ada, E393, "gtk__tree_view_column_E");
   E387 : Short_Integer; pragma Import (Ada, E387, "gtk__tree_view_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "gtk__combo_box_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "gtk__combo_box_text_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "callbacks_gmastresults_E");
   E662 : Short_Integer; pragma Import (Ada, E662, "gtkada__handlers_E");
   E655 : Short_Integer; pragma Import (Ada, E655, "error_window_pkg_E");
   E657 : Short_Integer; pragma Import (Ada, E657, "error_window_pkg__callbacks_E");
   E682 : Short_Integer; pragma Import (Ada, E682, "gtkada__file_selection_E");
   E634 : Short_Integer; pragma Import (Ada, E634, "priority_queues_E");
   E437 : Short_Integer; pragma Import (Ada, E437, "var_strings_E");
   E426 : Short_Integer; pragma Import (Ada, E426, "mast_E");
   E620 : Short_Integer; pragma Import (Ada, E620, "mast__tool_exceptions_E");
   E618 : Short_Integer; pragma Import (Ada, E618, "mast__annealing_parameters_E");
   E638 : Short_Integer; pragma Import (Ada, E638, "mast__hospa_parameters_E");
   E478 : Short_Integer; pragma Import (Ada, E478, "named_lists_E");
   E476 : Short_Integer; pragma Import (Ada, E476, "symbol_table_E");
   E474 : Short_Integer; pragma Import (Ada, E474, "mast_parser_tokens_E");
   E451 : Short_Integer; pragma Import (Ada, E451, "mast__io_E");
   E528 : Short_Integer; pragma Import (Ada, E528, "mast__scheduling_parameters_E");
   E512 : Short_Integer; pragma Import (Ada, E512, "mast__scheduling_policies_E");
   E536 : Short_Integer; pragma Import (Ada, E536, "mast__synchronization_parameters_E");
   E449 : Short_Integer; pragma Import (Ada, E449, "mast__events_E");
   E486 : Short_Integer; pragma Import (Ada, E486, "mast__graphs_E");
   E494 : Short_Integer; pragma Import (Ada, E494, "mast__results_E");
   E492 : Short_Integer; pragma Import (Ada, E492, "mast__processing_resources_E");
   E510 : Short_Integer; pragma Import (Ada, E510, "mast__schedulers_E");
   E532 : Short_Integer; pragma Import (Ada, E532, "mast__scheduling_servers_E");
   E538 : Short_Integer; pragma Import (Ada, E538, "mast__schedulers__adjustment_E");
   E534 : Short_Integer; pragma Import (Ada, E534, "mast__schedulers__secondary_E");
   E530 : Short_Integer; pragma Import (Ada, E530, "mast__shared_resources_E");
   E526 : Short_Integer; pragma Import (Ada, E526, "mast__operations_E");
   E524 : Short_Integer; pragma Import (Ada, E524, "mast__drivers_E");
   E490 : Short_Integer; pragma Import (Ada, E490, "mast__graphs__event_handlers_E");
   E508 : Short_Integer; pragma Import (Ada, E508, "mast__processing_resources__network_E");
   E522 : Short_Integer; pragma Import (Ada, E522, "mast__timers_E");
   E518 : Short_Integer; pragma Import (Ada, E518, "mast__processing_resources__processor_E");
   E502 : Short_Integer; pragma Import (Ada, E502, "mast__timing_requirements_E");
   E498 : Short_Integer; pragma Import (Ada, E498, "mast__graphs__links_E");
   E484 : Short_Integer; pragma Import (Ada, E484, "mast__transactions_E");
   E506 : Short_Integer; pragma Import (Ada, E506, "mast__systems_E");
   E516 : Short_Integer; pragma Import (Ada, E516, "mast__schedulers__primary_E");
   E504 : Short_Integer; pragma Import (Ada, E504, "mast__xmi_E");
   E603 : Short_Integer; pragma Import (Ada, E603, "mast__transaction_operations_E");
   E599 : Short_Integer; pragma Import (Ada, E599, "mast__consistency_checks_E");
   E630 : Short_Integer; pragma Import (Ada, E630, "mast__max_numbers_E");
   E544 : Short_Integer; pragma Import (Ada, E544, "mast_lex_E");
   E574 : Short_Integer; pragma Import (Ada, E574, "mast_results_parser_tokens_E");
   E569 : Short_Integer; pragma Import (Ada, E569, "mast_results_lex_E");
   E540 : Short_Integer; pragma Import (Ada, E540, "mast_actions_E");
   E628 : Short_Integer; pragma Import (Ada, E628, "trimmed_image_E");
   E645 : Short_Integer; pragma Import (Ada, E645, "mast__miscelaneous_tools_E");
   E649 : Short_Integer; pragma Import (Ada, E649, "mast__restrictions_E");
   E591 : Short_Integer; pragma Import (Ada, E591, "mast__tools_E");
   E605 : Short_Integer; pragma Import (Ada, E605, "mast__linear_priority_assignment_tools_E");
   E636 : Short_Integer; pragma Import (Ada, E636, "mast__linear_scheduling_parameters_assignment_tools_E");
   E626 : Short_Integer; pragma Import (Ada, E626, "mast__linear_translation_E");
   E643 : Short_Integer; pragma Import (Ada, E643, "mast__linear_task_analysis_tools_E");
   E651 : Short_Integer; pragma Import (Ada, E651, "mast__monoprocessor_tools_E");
   E632 : Short_Integer; pragma Import (Ada, E632, "mast__tools__schedulability_index_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "dialog_event_pkg_E");
   E407 : Short_Integer; pragma Import (Ada, E407, "dialog_event_pkg__callbacks_E");
   E581 : Short_Integer; pragma Import (Ada, E581, "gmast_results_pkg_E");
   E583 : Short_Integer; pragma Import (Ada, E583, "gmast_results_pkg__callbacks_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E581 := E581 - 1;
      E135 := E135 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "gmast_results_pkg__finalize_spec");
      begin
         F1;
      end;
      declare
         procedure F2;
         pragma Import (Ada, F2, "dialog_event_pkg__finalize_spec");
      begin
         F2;
      end;
      E484 := E484 - 1;
      E502 := E502 - 1;
      E522 := E522 - 1;
      E506 := E506 - 1;
      E530 := E530 - 1;
      E532 := E532 - 1;
      E534 := E534 - 1;
      E516 := E516 - 1;
      E494 := E494 - 1;
      E518 := E518 - 1;
      E508 := E508 - 1;
      E526 := E526 - 1;
      E490 := E490 - 1;
      E449 := E449 - 1;
      E524 := E524 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "mast__schedulers__primary__finalize_spec");
      begin
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "mast__systems__finalize_spec");
      begin
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "mast__transactions__finalize_spec");
      begin
         F5;
      end;
      E498 := E498 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast__graphs__links__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast__timing_requirements__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast__processing_resources__processor__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast__timers__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast__processing_resources__network__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast__graphs__event_handlers__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast__drivers__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast__operations__finalize_spec");
      begin
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast__shared_resources__finalize_spec");
      begin
         F14;
      end;
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
      E510 := E510 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "mast__schedulers__finalize_spec");
      begin
         F17;
      end;
      E492 := E492 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "mast__processing_resources__finalize_spec");
      begin
         F18;
      end;
      declare
         procedure F19;
         pragma Import (Ada, F19, "mast__results__finalize_spec");
      begin
         F19;
      end;
      E486 := E486 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "mast__graphs__finalize_spec");
      begin
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast__events__finalize_spec");
      begin
         F21;
      end;
      E536 := E536 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast__synchronization_parameters__finalize_spec");
      begin
         F22;
      end;
      E512 := E512 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "mast__scheduling_policies__finalize_spec");
      begin
         F23;
      end;
      E528 := E528 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "mast__scheduling_parameters__finalize_spec");
      begin
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "gtkada__file_selection__finalize_body");
      begin
         E682 := E682 - 1;
         F25;
      end;
      E655 := E655 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "error_window_pkg__finalize_spec");
      begin
         F26;
      end;
      declare
         procedure F27;
         pragma Import (Ada, F27, "gtkada__handlers__finalize_spec");
      begin
         E662 := E662 - 1;
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "callbacks_gmastresults__finalize_spec");
      begin
         E136 := E136 - 1;
         F28;
      end;
      E383 := E383 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "gtk__combo_box_text__finalize_spec");
      begin
         F29;
      end;
      E385 := E385 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "gtk__combo_box__finalize_spec");
      begin
         F30;
      end;
      E387 := E387 - 1;
      declare
         procedure F31;
         pragma Import (Ada, F31, "gtk__tree_view__finalize_spec");
      begin
         F31;
      end;
      E393 := E393 - 1;
      declare
         procedure F32;
         pragma Import (Ada, F32, "gtk__tree_view_column__finalize_spec");
      begin
         F32;
      end;
      E410 := E410 - 1;
      declare
         procedure F33;
         pragma Import (Ada, F33, "gtk__tree_store__finalize_spec");
      begin
         F33;
      end;
      E391 := E391 - 1;
      declare
         procedure F34;
         pragma Import (Ada, F34, "gtk__tree_selection__finalize_spec");
      begin
         F34;
      end;
      E389 := E389 - 1;
      declare
         procedure F35;
         pragma Import (Ada, F35, "gtk__tooltip__finalize_spec");
      begin
         F35;
      end;
      E697 := E697 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "gtk__table__finalize_spec");
      begin
         F36;
      end;
      E419 := E419 - 1;
      declare
         procedure F37;
         pragma Import (Ada, F37, "gtk__scrolled_window__finalize_spec");
      begin
         F37;
      end;
      E421 := E421 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "gtk__scrollbar__finalize_spec");
      begin
         F38;
      end;
      E695 := E695 - 1;
      declare
         procedure F39;
         pragma Import (Ada, F39, "gtk__menu_bar__finalize_spec");
      begin
         F39;
      end;
      E666 := E666 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "gtk__label__finalize_spec");
      begin
         F40;
      end;
      E668 := E668 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "gtk__menu__finalize_spec");
      begin
         F41;
      end;
      E672 := E672 - 1;
      declare
         procedure F42;
         pragma Import (Ada, F42, "gtk__menu_shell__finalize_spec");
      begin
         F42;
      end;
      E403 := E403 - 1;
      declare
         procedure F43;
         pragma Import (Ada, F43, "gtk__image_menu_item__finalize_spec");
      begin
         F43;
      end;
      E405 := E405 - 1;
      declare
         procedure F44;
         pragma Import (Ada, F44, "gtk__menu_item__finalize_spec");
      begin
         F44;
      end;
      E693 := E693 - 1;
      declare
         procedure F45;
         pragma Import (Ada, F45, "gtk__handle_box__finalize_spec");
      begin
         F45;
      end;
      E423 := E423 - 1;
      declare
         procedure F46;
         pragma Import (Ada, F46, "gtk__grange__finalize_spec");
      begin
         F46;
      end;
      E691 := E691 - 1;
      declare
         procedure F47;
         pragma Import (Ada, F47, "gtk__frame__finalize_spec");
      begin
         F47;
      end;
      E678 := E678 - 1;
      declare
         procedure F48;
         pragma Import (Ada, F48, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F48;
      end;
      E687 := E687 - 1;
      declare
         procedure F49;
         pragma Import (Ada, F49, "gtk__cell_renderer_text__finalize_spec");
      begin
         F49;
      end;
      E685 := E685 - 1;
      declare
         procedure F50;
         pragma Import (Ada, F50, "gtk__cell_renderer_pixbuf__finalize_spec");
      begin
         F50;
      end;
      E186 := E186 - 1;
      declare
         procedure F51;
         pragma Import (Ada, F51, "gtk__button__finalize_spec");
      begin
         F51;
      end;
      E664 := E664 - 1;
      declare
         procedure F52;
         pragma Import (Ada, F52, "gtk__alignment__finalize_spec");
      begin
         F52;
      end;
      E377 := E377 - 1;
      declare
         procedure F53;
         pragma Import (Ada, F53, "gtk__action__finalize_spec");
      begin
         F53;
      end;
      E670 := E670 - 1;
      declare
         procedure F54;
         pragma Import (Ada, F54, "glib__menu_model__finalize_spec");
      begin
         F54;
      end;
      E295 := E295 - 1;
      E228 := E228 - 1;
      E325 := E325 - 1;
      E363 := E363 - 1;
      E375 := E375 - 1;
      E367 := E367 - 1;
      E333 := E333 - 1;
      E252 := E252 - 1;
      E355 := E355 - 1;
      E341 := E341 - 1;
      E339 := E339 - 1;
      E305 := E305 - 1;
      E315 := E315 - 1;
      E313 := E313 - 1;
      E220 := E220 - 1;
      E289 := E289 - 1;
      E369 := E369 - 1;
      E323 := E323 - 1;
      E317 := E317 - 1;
      E291 := E291 - 1;
      E246 := E246 - 1;
      E212 := E212 - 1;
      E232 := E232 - 1;
      E195 := E195 - 1;
      E201 := E201 - 1;
      E199 := E199 - 1;
      declare
         procedure F55;
         pragma Import (Ada, F55, "gtk__print_operation__finalize_spec");
      begin
         F55;
      end;
      declare
         procedure F56;
         pragma Import (Ada, F56, "gtk__dialog__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "gtk__window__finalize_spec");
      begin
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "gtk__text_view__finalize_spec");
      begin
         F58;
      end;
      declare
         procedure F59;
         pragma Import (Ada, F59, "gtk__text_buffer__finalize_spec");
      begin
         F59;
      end;
      E371 := E371 - 1;
      declare
         procedure F60;
         pragma Import (Ada, F60, "gtk__text_child_anchor__finalize_spec");
      begin
         F60;
      end;
      declare
         procedure F61;
         pragma Import (Ada, F61, "gtk__gentry__finalize_spec");
      begin
         F61;
      end;
      E327 := E327 - 1;
      declare
         procedure F62;
         pragma Import (Ada, F62, "gtk__image__finalize_spec");
      begin
         F62;
      end;
      E329 := E329 - 1;
      declare
         procedure F63;
         pragma Import (Ada, F63, "gtk__icon_set__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "gtk__style_context__finalize_spec");
      begin
         F64;
      end;
      E222 := E222 - 1;
      declare
         procedure F65;
         pragma Import (Ada, F65, "gtk__settings__finalize_spec");
      begin
         F65;
      end;
      declare
         procedure F66;
         pragma Import (Ada, F66, "gtk__status_bar__finalize_spec");
      begin
         F66;
      end;
      declare
         procedure F67;
         pragma Import (Ada, F67, "gtk__notebook__finalize_spec");
      begin
         F67;
      end;
      E337 := E337 - 1;
      declare
         procedure F68;
         pragma Import (Ada, F68, "gtk__misc__finalize_spec");
      begin
         F68;
      end;
      declare
         procedure F69;
         pragma Import (Ada, F69, "gtk__entry_completion__finalize_spec");
      begin
         F69;
      end;
      E285 := E285 - 1;
      declare
         procedure F70;
         pragma Import (Ada, F70, "gtk__box__finalize_spec");
      begin
         F70;
      end;
      E303 := E303 - 1;
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
         pragma Import (Ada, F73, "gtk__cell_area__finalize_spec");
      begin
         F73;
      end;
      declare
         procedure F74;
         pragma Import (Ada, F74, "gtk__cell_renderer__finalize_spec");
      begin
         F74;
      end;
      declare
         procedure F75;
         pragma Import (Ada, F75, "gtk__widget__finalize_spec");
      begin
         F75;
      end;
      declare
         procedure F76;
         pragma Import (Ada, F76, "gtk__tree_model__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "gtk__text_tag_table__finalize_spec");
      begin
         F77;
      end;
      declare
         procedure F78;
         pragma Import (Ada, F78, "gtk__style__finalize_spec");
      begin
         F78;
      end;
      declare
         procedure F79;
         pragma Import (Ada, F79, "gtk__clipboard__finalize_spec");
      begin
         F79;
      end;
      E250 := E250 - 1;
      declare
         procedure F80;
         pragma Import (Ada, F80, "gtk__selection_data__finalize_spec");
      begin
         F80;
      end;
      E331 := E331 - 1;
      declare
         procedure F81;
         pragma Import (Ada, F81, "gtk__icon_source__finalize_spec");
      begin
         F81;
      end;
      declare
         procedure F82;
         pragma Import (Ada, F82, "gtk__entry_buffer__finalize_spec");
      begin
         F82;
      end;
      declare
         procedure F83;
         pragma Import (Ada, F83, "gtk__adjustment__finalize_spec");
      begin
         F83;
      end;
      declare
         procedure F84;
         pragma Import (Ada, F84, "gtk__accel_group__finalize_spec");
      begin
         F84;
      end;
      declare
         procedure F85;
         pragma Import (Ada, F85, "gdk__drag_contexts__finalize_spec");
      begin
         F85;
      end;
      declare
         procedure F86;
         pragma Import (Ada, F86, "gdk__device__finalize_spec");
      begin
         F86;
      end;
      E214 := E214 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "gdk__screen__finalize_spec");
      begin
         F87;
      end;
      E236 := E236 - 1;
      declare
         procedure F88;
         pragma Import (Ada, F88, "gdk__pixbuf__finalize_spec");
      begin
         F88;
      end;
      E301 := E301 - 1;
      declare
         procedure F89;
         pragma Import (Ada, F89, "gdk__glcontext__finalize_spec");
      begin
         F89;
      end;
      declare
         procedure F90;
         pragma Import (Ada, F90, "gdk__display__finalize_spec");
      begin
         F90;
      end;
      declare
         procedure F91;
         pragma Import (Ada, F91, "gdk__monitor__finalize_spec");
      begin
         F91;
      end;
      declare
         procedure F92;
         pragma Import (Ada, F92, "gdk__frame_clock__finalize_spec");
      begin
         F92;
      end;
      E349 := E349 - 1;
      declare
         procedure F93;
         pragma Import (Ada, F93, "gtk__print_context__finalize_spec");
      begin
         F93;
      end;
      E279 := E279 - 1;
      declare
         procedure F94;
         pragma Import (Ada, F94, "pango__layout__finalize_spec");
      begin
         F94;
      end;
      E283 := E283 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "pango__tabs__finalize_spec");
      begin
         F95;
      end;
      E277 := E277 - 1;
      declare
         procedure F96;
         pragma Import (Ada, F96, "pango__font_map__finalize_spec");
      begin
         F96;
      end;
      E259 := E259 - 1;
      declare
         procedure F97;
         pragma Import (Ada, F97, "pango__context__finalize_spec");
      begin
         F97;
      end;
      E273 := E273 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "pango__fontset__finalize_spec");
      begin
         F98;
      end;
      E269 := E269 - 1;
      declare
         procedure F99;
         pragma Import (Ada, F99, "pango__font_family__finalize_spec");
      begin
         F99;
      end;
      E271 := E271 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "pango__font_face__finalize_spec");
      begin
         F100;
      end;
      E361 := E361 - 1;
      declare
         procedure F101;
         pragma Import (Ada, F101, "gtk__text_tag__finalize_spec");
      begin
         F101;
      end;
      E263 := E263 - 1;
      declare
         procedure F102;
         pragma Import (Ada, F102, "pango__font__finalize_spec");
      begin
         F102;
      end;
      E267 := E267 - 1;
      declare
         procedure F103;
         pragma Import (Ada, F103, "pango__language__finalize_spec");
      begin
         F103;
      end;
      E265 := E265 - 1;
      declare
         procedure F104;
         pragma Import (Ada, F104, "pango__font_metrics__finalize_spec");
      begin
         F104;
      end;
      E281 := E281 - 1;
      declare
         procedure F105;
         pragma Import (Ada, F105, "pango__attributes__finalize_spec");
      begin
         F105;
      end;
      E373 := E373 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "gtk__text_mark__finalize_spec");
      begin
         F106;
      end;
      E254 := E254 - 1;
      declare
         procedure F107;
         pragma Import (Ada, F107, "gtk__target_list__finalize_spec");
      begin
         F107;
      end;
      E353 := E353 - 1;
      declare
         procedure F108;
         pragma Import (Ada, F108, "gtk__print_settings__finalize_spec");
      begin
         F108;
      end;
      E343 := E343 - 1;
      declare
         procedure F109;
         pragma Import (Ada, F109, "gtk__page_setup__finalize_spec");
      begin
         F109;
      end;
      E347 := E347 - 1;
      declare
         procedure F110;
         pragma Import (Ada, F110, "gtk__paper_size__finalize_spec");
      begin
         F110;
      end;
      E676 := E676 - 1;
      declare
         procedure F111;
         pragma Import (Ada, F111, "gtk__file_filter__finalize_spec");
      begin
         F111;
      end;
      E335 := E335 - 1;
      declare
         procedure F112;
         pragma Import (Ada, F112, "gtk__css_section__finalize_spec");
      begin
         F112;
      end;
      E319 := E319 - 1;
      declare
         procedure F113;
         pragma Import (Ada, F113, "gtk__cell_area_context__finalize_spec");
      begin
         F113;
      end;
      E248 := E248 - 1;
      declare
         procedure F114;
         pragma Import (Ada, F114, "gtk__builder__finalize_spec");
      begin
         F114;
      end;
      E242 := E242 - 1;
      declare
         procedure F115;
         pragma Import (Ada, F115, "glib__variant__finalize_spec");
      begin
         F115;
      end;
      E299 := E299 - 1;
      declare
         procedure F116;
         pragma Import (Ada, F116, "gdk__drawing_context__finalize_spec");
      begin
         F116;
      end;
      E205 := E205 - 1;
      declare
         procedure F117;
         pragma Import (Ada, F117, "gdk__device_tool__finalize_spec");
      begin
         F117;
      end;
      E162 := E162 - 1;
      declare
         procedure F118;
         pragma Import (Ada, F118, "glib__object__finalize_spec");
      begin
         F118;
      end;
      E234 := E234 - 1;
      declare
         procedure F119;
         pragma Import (Ada, F119, "gdk__frame_timings__finalize_spec");
      begin
         F119;
      end;
      E139 := E139 - 1;
      declare
         procedure F120;
         pragma Import (Ada, F120, "glib__finalize_spec");
      begin
         F120;
      end;
      declare
         procedure F121;
         pragma Import (Ada, F121, "ada__directories__finalize_body");
      begin
         E552 := E552 - 1;
         F121;
      end;
      declare
         procedure F122;
         pragma Import (Ada, F122, "ada__directories__finalize_spec");
      begin
         F122;
      end;
      E562 := E562 - 1;
      declare
         procedure F123;
         pragma Import (Ada, F123, "system__regexp__finalize_spec");
      begin
         F123;
      end;
      E150 := E150 - 1;
      declare
         procedure F124;
         pragma Import (Ada, F124, "system__pool_global__finalize_spec");
      begin
         F124;
      end;
      E119 := E119 - 1;
      declare
         procedure F125;
         pragma Import (Ada, F125, "ada__text_io__finalize_spec");
      begin
         F125;
      end;
      E439 := E439 - 1;
      declare
         procedure F126;
         pragma Import (Ada, F126, "ada__strings__unbounded__finalize_spec");
      begin
         F126;
      end;
      E166 := E166 - 1;
      declare
         procedure F127;
         pragma Import (Ada, F127, "system__storage_pools__subpools__finalize_spec");
      begin
         F127;
      end;
      E146 := E146 - 1;
      declare
         procedure F128;
         pragma Import (Ada, F128, "system__finalization_masters__finalize_spec");
      begin
         F128;
      end;
      declare
         procedure F129;
         pragma Import (Ada, F129, "system__file_io__finalize_body");
      begin
         E129 := E129 - 1;
         F129;
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
      E024 := E024 + 1;
      Ada.Containers'Elab_Spec;
      E040 := E040 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E068 := E068 + 1;
      Ada.Numerics'Elab_Spec;
      E031 := E031 + 1;
      Ada.Strings'Elab_Spec;
      E055 := E055 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E057 := E057 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E060 := E060 + 1;
      Interfaces.C'Elab_Spec;
      E045 := E045 + 1;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Object_Reader'Elab_Spec;
      E084 := E084 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E050 := E050 + 1;
      System.Os_Lib'Elab_Body;
      E073 := E073 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E017 := E017 + 1;
      E015 := E015 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E039 := E039 + 1;
      E011 := E011 + 1;
      Ada.Assertions'Elab_Spec;
      E399 := E399 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E105 := E105 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E113 := E113 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E103 := E103 + 1;
      Gnat'Elab_Spec;
      E171 := E171 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E144 := E144 + 1;
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
      E148 := E148 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E146 := E146 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E166 := E166 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E439 := E439 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E453 := E453 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E119 := E119 + 1;
      System.Pool_Global'Elab_Spec;
      E150 := E150 + 1;
      System.Random_Seed'Elab_Body;
      E616 := E616 + 1;
      System.Regexp'Elab_Spec;
      E562 := E562 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E552 := E552 + 1;
      Glib'Elab_Spec;
      Gtkada.Types'Elab_Spec;
      E142 := E142 + 1;
      E139 := E139 + 1;
      E473 := E473 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      Gdk.Frame_Timings'Elab_Body;
      E234 := E234 + 1;
      E182 := E182 + 1;
      Gdk.Visual'Elab_Body;
      E216 := E216 + 1;
      E184 := E184 + 1;
      E659 := E659 + 1;
      E176 := E176 + 1;
      Glib.Object'Elab_Spec;
      E164 := E164 + 1;
      Glib.Values'Elab_Body;
      E180 := E180 + 1;
      E170 := E170 + 1;
      Glib.Object'Elab_Body;
      E162 := E162 + 1;
      E178 := E178 + 1;
      E190 := E190 + 1;
      E192 := E192 + 1;
      E209 := E209 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E197 := E197 + 1;
      Gdk.Color'Elab_Spec;
      E230 := E230 + 1;
      E218 := E218 + 1;
      E345 := E345 + 1;
      E207 := E207 + 1;
      Gdk.Device_Tool'Elab_Spec;
      Gdk.Device_Tool'Elab_Body;
      E205 := E205 + 1;
      Gdk.Drawing_Context'Elab_Spec;
      Gdk.Drawing_Context'Elab_Body;
      E299 := E299 + 1;
      E203 := E203 + 1;
      E244 := E244 + 1;
      Glib.Variant'Elab_Spec;
      Glib.Variant'Elab_Body;
      E242 := E242 + 1;
      E307 := E307 + 1;
      Gtk.Actionable'Elab_Spec;
      E379 := E379 + 1;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E248 := E248 + 1;
      E287 := E287 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E319 := E319 + 1;
      Gtk.Css_Section'Elab_Spec;
      Gtk.Css_Section'Elab_Body;
      E335 := E335 + 1;
      E224 := E224 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E676 := E676 + 1;
      Gtk.Orientable'Elab_Spec;
      E293 := E293 + 1;
      Gtk.Paper_Size'Elab_Spec;
      Gtk.Paper_Size'Elab_Body;
      E347 := E347 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E343 := E343 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E353 := E353 + 1;
      E589 := E589 + 1;
      E256 := E256 + 1;
      Gtk.Target_List'Elab_Spec;
      Gtk.Target_List'Elab_Body;
      E254 := E254 + 1;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E373 := E373 + 1;
      Gtkada.Pixmaps'Elab_Spec;
      E587 := E587 + 1;
      Gmastresults_Pixmaps'Elab_Spec;
      E586 := E586 + 1;
      List_Exceptions'Elab_Spec;
      E424 := E424 + 1;
      E601 := E601 + 1;
      E640 := E640 + 1;
      E647 := E647 + 1;
      E496 := E496 + 1;
      E488 := E488 + 1;
      E546 := E546 + 1;
      mast_lex_io'elab_spec;
      E548 := E548 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E550 := E550 + 1;
      E571 := E571 + 1;
      mast_results_lex_io'elab_spec;
      E573 := E573 + 1;
      Mast_Results_Parser_Error_Report'Elab_Spec;
      E576 := E576 + 1;
      E261 := E261 + 1;
      Pango.Attributes'Elab_Spec;
      Pango.Attributes'Elab_Body;
      E281 := E281 + 1;
      Pango.Font_Metrics'Elab_Spec;
      Pango.Font_Metrics'Elab_Body;
      E265 := E265 + 1;
      Pango.Language'Elab_Spec;
      Pango.Language'Elab_Body;
      E267 := E267 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E263 := E263 + 1;
      E359 := E359 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E361 := E361 + 1;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E271 := E271 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E269 := E269 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E273 := E273 + 1;
      E275 := E275 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E259 := E259 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E277 := E277 + 1;
      Pango.Tabs'Elab_Spec;
      Pango.Tabs'Elab_Body;
      E283 := E283 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E279 := E279 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E349 := E349 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Monitor'Elab_Spec;
      Gdk.Display'Elab_Spec;
      Gdk.Glcontext'Elab_Spec;
      Gdk.Glcontext'Elab_Body;
      E301 := E301 + 1;
      Gdk.Pixbuf'Elab_Spec;
      E236 := E236 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E214 := E214 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Window'Elab_Spec;
      E297 := E297 + 1;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Icon_Source'Elab_Spec;
      Gtk.Icon_Source'Elab_Body;
      E331 := E331 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E250 := E250 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Style'Elab_Spec;
      Gtk.Scrollable'Elab_Spec;
      E365 := E365 + 1;
      E357 := E357 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Gtk.Tree_Model'Elab_Spec;
      Gtk.Widget'Elab_Spec;
      Gtk.Cell_Renderer'Elab_Spec;
      E321 := E321 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E303 := E303 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E285 := E285 + 1;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E337 := E337 + 1;
      Gtk.Notebook'Elab_Spec;
      Gtk.Status_Bar'Elab_Spec;
      E226 := E226 + 1;
      Gtk.Settings'Elab_Spec;
      Gtk.Settings'Elab_Body;
      E222 := E222 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      Gtk.Icon_Set'Elab_Body;
      E329 := E329 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E327 := E327 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E371 := E371 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Window'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Gtk.Print_Operation'Elab_Spec;
      E188 := E188 + 1;
      Gdk.Device'Elab_Body;
      E199 := E199 + 1;
      Gdk.Display'Elab_Body;
      E201 := E201 + 1;
      Gdk.Drag_Contexts'Elab_Body;
      E195 := E195 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E232 := E232 + 1;
      Gdk.Monitor'Elab_Body;
      E212 := E212 + 1;
      E240 := E240 + 1;
      Gtk.Accel_Group'Elab_Body;
      E246 := E246 + 1;
      Gtk.Adjustment'Elab_Body;
      E291 := E291 + 1;
      Gtk.Cell_Area'Elab_Body;
      E317 := E317 + 1;
      E309 := E309 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E323 := E323 + 1;
      Gtk.Clipboard'Elab_Body;
      E369 := E369 + 1;
      Gtk.Container'Elab_Body;
      E289 := E289 + 1;
      Gtk.Dialog'Elab_Body;
      E220 := E220 + 1;
      E311 := E311 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E313 := E313 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E315 := E315 + 1;
      Gtk.Gentry'Elab_Body;
      E305 := E305 + 1;
      Gtk.Notebook'Elab_Body;
      E339 := E339 + 1;
      Gtk.Print_Operation'Elab_Body;
      E341 := E341 + 1;
      E351 := E351 + 1;
      Gtk.Status_Bar'Elab_Body;
      E355 := E355 + 1;
      Gtk.Style'Elab_Body;
      E252 := E252 + 1;
      Gtk.Style_Context'Elab_Body;
      E333 := E333 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E367 := E367 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E375 := E375 + 1;
      Gtk.Text_View'Elab_Body;
      E363 := E363 + 1;
      Gtk.Tree_Model'Elab_Body;
      E325 := E325 + 1;
      Gtk.Widget'Elab_Body;
      E228 := E228 + 1;
      Gtk.Window'Elab_Body;
      E295 := E295 + 1;
      Glib.Menu_Model'Elab_Spec;
      Glib.Menu_Model'Elab_Body;
      E670 := E670 + 1;
      Gtk.Action'Elab_Spec;
      Gtk.Action'Elab_Body;
      E377 := E377 + 1;
      Gtk.Activatable'Elab_Spec;
      E381 := E381 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E664 := E664 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Button'Elab_Body;
      E186 := E186 + 1;
      Gtk.Cell_Renderer_Pixbuf'Elab_Spec;
      Gtk.Cell_Renderer_Pixbuf'Elab_Body;
      E685 := E685 + 1;
      Gtk.Cell_Renderer_Text'Elab_Spec;
      Gtk.Cell_Renderer_Text'Elab_Body;
      E687 := E687 + 1;
      Gtk.File_Chooser'Elab_Spec;
      E674 := E674 + 1;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E678 := E678 + 1;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E691 := E691 + 1;
      Gtk.Grange'Elab_Spec;
      Gtk.Grange'Elab_Body;
      E423 := E423 + 1;
      Gtk.Handle_Box'Elab_Spec;
      Gtk.Handle_Box'Elab_Body;
      E693 := E693 + 1;
      E680 := E680 + 1;
      E401 := E401 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Menu_Item'Elab_Body;
      E405 := E405 + 1;
      Gtk.Image_Menu_Item'Elab_Spec;
      Gtk.Image_Menu_Item'Elab_Body;
      E403 := E403 + 1;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu_Shell'Elab_Body;
      E672 := E672 + 1;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu'Elab_Body;
      E668 := E668 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Label'Elab_Body;
      E666 := E666 + 1;
      Gtk.Menu_Bar'Elab_Spec;
      Gtk.Menu_Bar'Elab_Body;
      E695 := E695 + 1;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E421 := E421 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Scrolled_Window'Elab_Body;
      E419 := E419 + 1;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E697 := E697 + 1;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E389 := E389 + 1;
      E412 := E412 + 1;
      E414 := E414 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_Selection'Elab_Body;
      E391 := E391 + 1;
      E416 := E416 + 1;
      Gtk.Tree_Store'Elab_Spec;
      Gtk.Tree_Store'Elab_Body;
      E410 := E410 + 1;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Body;
      E393 := E393 + 1;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Tree_View'Elab_Body;
      E387 := E387 + 1;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box'Elab_Body;
      E385 := E385 + 1;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E383 := E383 + 1;
      Callbacks_Gmastresults'Elab_Spec;
      E136 := E136 + 1;
      Gtkada.Handlers'Elab_Spec;
      E662 := E662 + 1;
      Error_Window_Pkg'Elab_Spec;
      E657 := E657 + 1;
      E655 := E655 + 1;
      Gtkada.File_Selection'Elab_Body;
      E682 := E682 + 1;
      E634 := E634 + 1;
      Var_Strings'Elab_Spec;
      E437 := E437 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E426 := E426 + 1;
      Mast.Tool_Exceptions'Elab_Spec;
      Mast.Tool_Exceptions'Elab_Body;
      E620 := E620 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E618 := E618 + 1;
      Mast.Hospa_Parameters'Elab_Body;
      E638 := E638 + 1;
      E478 := E478 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E476 := E476 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E474 := E474 + 1;
      Mast.Io'Elab_Body;
      E451 := E451 + 1;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Body;
      E528 := E528 + 1;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Body;
      E512 := E512 + 1;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Body;
      E536 := E536 + 1;
      Mast.Events'Elab_Spec;
      Mast.Graphs'Elab_Spec;
      Mast.Graphs'Elab_Body;
      E486 := E486 + 1;
      Mast.Results'Elab_Spec;
      Mast.Processing_Resources'Elab_Spec;
      Mast.Processing_Resources'Elab_Body;
      E492 := E492 + 1;
      Mast.Schedulers'Elab_Spec;
      Mast.Schedulers'Elab_Body;
      E510 := E510 + 1;
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
      E498 := E498 + 1;
      Mast.Transactions'Elab_Spec;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E538 := E538 + 1;
      Mast.Xmi'Elab_Body;
      E504 := E504 + 1;
      Mast.Drivers'Elab_Body;
      E524 := E524 + 1;
      Mast.Events'Elab_Body;
      E449 := E449 + 1;
      Mast.Graphs.Event_Handlers'Elab_Body;
      E490 := E490 + 1;
      Mast.Operations'Elab_Body;
      E526 := E526 + 1;
      Mast.Processing_Resources.Network'Elab_Body;
      E508 := E508 + 1;
      Mast.Processing_Resources.Processor'Elab_Body;
      E518 := E518 + 1;
      Mast.Results'Elab_Body;
      E494 := E494 + 1;
      Mast.Schedulers.Primary'Elab_Body;
      E516 := E516 + 1;
      Mast.Schedulers.Secondary'Elab_Body;
      E534 := E534 + 1;
      Mast.Scheduling_Servers'Elab_Body;
      E532 := E532 + 1;
      Mast.Shared_Resources'Elab_Body;
      E530 := E530 + 1;
      Mast.Systems'Elab_Body;
      E506 := E506 + 1;
      Mast.Timers'Elab_Body;
      E522 := E522 + 1;
      Mast.Timing_Requirements'Elab_Body;
      E502 := E502 + 1;
      Mast.Transactions'Elab_Body;
      E484 := E484 + 1;
      Mast.Transaction_Operations'Elab_Spec;
      E603 := E603 + 1;
      Mast.Consistency_Checks'Elab_Body;
      E599 := E599 + 1;
      E630 := E630 + 1;
      E544 := E544 + 1;
      Mast_Results_Parser_Tokens'Elab_Spec;
      E574 := E574 + 1;
      E569 := E569 + 1;
      Mast_Actions'Elab_Spec;
      E540 := E540 + 1;
      E628 := E628 + 1;
      E626 := E626 + 1;
      E643 := E643 + 1;
      Mast.Miscelaneous_Tools'Elab_Body;
      E645 := E645 + 1;
      E649 := E649 + 1;
      E591 := E591 + 1;
      Mast.Tools.Schedulability_Index'Elab_Spec;
      E632 := E632 + 1;
      E605 := E605 + 1;
      E636 := E636 + 1;
      E651 := E651 + 1;
      Dialog_Event_Pkg'Elab_Spec;
      Gmast_Results_Pkg'Elab_Spec;
      E135 := E135 + 1;
      E581 := E581 + 1;
      E407 := E407 + 1;
      E583 := E583 + 1;
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
   --   /home/michael/prog/mast/gmastresults/src/binary_trees.o
   --   /home/michael/prog/mast/gmastresults/src/gmastresults_intl.o
   --   /home/michael/prog/mast/gmastresults/src/gmastresults_pixmaps.o
   --   /home/michael/prog/mast/gmastresults/src/list_exceptions.o
   --   /home/michael/prog/mast/gmastresults/src/doubly_linked_lists.o
   --   /home/michael/prog/mast/gmastresults/src/dynamic_lists.o
   --   /home/michael/prog/mast/gmastresults/src/associations.o
   --   /home/michael/prog/mast/gmastresults/src/hash_lists.o
   --   /home/michael/prog/mast/gmastresults/src/indexed_lists.o
   --   /home/michael/prog/mast/gmastresults/src/mast_lex_dfa.o
   --   /home/michael/prog/mast/gmastresults/src/mast_lex_io.o
   --   /home/michael/prog/mast/gmastresults/src/mast_parser_error_report.o
   --   /home/michael/prog/mast/gmastresults/src/mast_parser_goto.o
   --   /home/michael/prog/mast/gmastresults/src/mast_parser_shift_reduce.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_lex_dfa.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_lex_io.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_parser_error_report.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_parser_goto.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_parser_shift_reduce.o
   --   /home/michael/prog/mast/gmastresults/src/callbacks_gmastresults.o
   --   /home/michael/prog/mast/gmastresults/src/error_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmastresults/src/error_window_pkg.o
   --   /home/michael/prog/mast/gmastresults/src/priority_queues.o
   --   /home/michael/prog/mast/gmastresults/src/var_strings.o
   --   /home/michael/prog/mast/gmastresults/src/mast.o
   --   /home/michael/prog/mast/gmastresults/src/mast-tool_exceptions.o
   --   /home/michael/prog/mast/gmastresults/src/mast-annealing_parameters.o
   --   /home/michael/prog/mast/gmastresults/src/mast-hospa_parameters.o
   --   /home/michael/prog/mast/gmastresults/src/named_lists.o
   --   /home/michael/prog/mast/gmastresults/src/symbol_table.o
   --   /home/michael/prog/mast/gmastresults/src/mast_parser_tokens.o
   --   /home/michael/prog/mast/gmastresults/src/mast-io.o
   --   /home/michael/prog/mast/gmastresults/src/mast-scheduling_parameters.o
   --   /home/michael/prog/mast/gmastresults/src/mast-scheduling_policies.o
   --   /home/michael/prog/mast/gmastresults/src/mast-synchronization_parameters.o
   --   /home/michael/prog/mast/gmastresults/src/mast-graphs.o
   --   /home/michael/prog/mast/gmastresults/src/mast-processing_resources.o
   --   /home/michael/prog/mast/gmastresults/src/mast-schedulers.o
   --   /home/michael/prog/mast/gmastresults/src/mast-graphs-links.o
   --   /home/michael/prog/mast/gmastresults/src/mast-schedulers-adjustment.o
   --   /home/michael/prog/mast/gmastresults/src/mast-xmi.o
   --   /home/michael/prog/mast/gmastresults/src/mast-drivers.o
   --   /home/michael/prog/mast/gmastresults/src/mast-events.o
   --   /home/michael/prog/mast/gmastresults/src/mast-graphs-event_handlers.o
   --   /home/michael/prog/mast/gmastresults/src/mast-operations.o
   --   /home/michael/prog/mast/gmastresults/src/mast-processing_resources-network.o
   --   /home/michael/prog/mast/gmastresults/src/mast-processing_resources-processor.o
   --   /home/michael/prog/mast/gmastresults/src/mast-results.o
   --   /home/michael/prog/mast/gmastresults/src/mast-schedulers-primary.o
   --   /home/michael/prog/mast/gmastresults/src/mast-schedulers-secondary.o
   --   /home/michael/prog/mast/gmastresults/src/mast-scheduling_servers.o
   --   /home/michael/prog/mast/gmastresults/src/mast-shared_resources.o
   --   /home/michael/prog/mast/gmastresults/src/mast-systems.o
   --   /home/michael/prog/mast/gmastresults/src/mast-timers.o
   --   /home/michael/prog/mast/gmastresults/src/mast-timing_requirements.o
   --   /home/michael/prog/mast/gmastresults/src/mast-transactions.o
   --   /home/michael/prog/mast/gmastresults/src/mast-transaction_operations.o
   --   /home/michael/prog/mast/gmastresults/src/mast-consistency_checks.o
   --   /home/michael/prog/mast/gmastresults/src/mast-max_numbers.o
   --   /home/michael/prog/mast/gmastresults/src/mast_lex.o
   --   /home/michael/prog/mast/gmastresults/src/mast_parser.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_parser_tokens.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_lex.o
   --   /home/michael/prog/mast/gmastresults/src/mast_results_parser.o
   --   /home/michael/prog/mast/gmastresults/src/mast_actions.o
   --   /home/michael/prog/mast/gmastresults/src/trimmed_image.o
   --   /home/michael/prog/mast/gmastresults/src/mast-linear_translation.o
   --   /home/michael/prog/mast/gmastresults/src/mast-linear_task_analysis_tools.o
   --   /home/michael/prog/mast/gmastresults/src/mast-miscelaneous_tools.o
   --   /home/michael/prog/mast/gmastresults/src/mast-restrictions.o
   --   /home/michael/prog/mast/gmastresults/src/mast-tools.o
   --   /home/michael/prog/mast/gmastresults/src/mast-tools-schedulability_index.o
   --   /home/michael/prog/mast/gmastresults/src/mast-linear_priority_assignment_tools.o
   --   /home/michael/prog/mast/gmastresults/src/mast-linear_scheduling_parameters_assignment_tools.o
   --   /home/michael/prog/mast/gmastresults/src/mast-monoprocessor_tools.o
   --   /home/michael/prog/mast/gmastresults/src/clear_timing_results.o
   --   /home/michael/prog/mast/gmastresults/src/clear_results.o
   --   /home/michael/prog/mast/gmastresults/src/dialog_event_pkg.o
   --   /home/michael/prog/mast/gmastresults/src/draw_results.o
   --   /home/michael/prog/mast/gmastresults/src/gmast_results_pkg.o
   --   /home/michael/prog/mast/gmastresults/src/resize_timing_results.o
   --   /home/michael/prog/mast/gmastresults/src/draw_timing_results.o
   --   /home/michael/prog/mast/gmastresults/src/dialog_event_pkg-callbacks.o
   --   /home/michael/prog/mast/gmastresults/src/gmast_results_pkg-callbacks.o
   --   /home/michael/prog/mast/gmastresults/src/gmastresults.o
   --   -L/home/michael/prog/mast/gmastresults/src/
   --   -L/home/michael/prog/mast/gmastresults/src/
   --   -L/home/michael/.local/share/alire/builds/gtkada_25.0.1_d3787772/97a94b98c977366ab88bcc61398b89819b47808c7bde0b5c0bf68da8797aaebd/src/lib/gtkada/static/
   --   -L/home/michael/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/lib/gcc/x86_64-pc-linux-gnu/14.1.0/adalib/
   --   -static
   --   -shared-libgcc
   --   -shared-libgcc
   --   -shared-libgcc
   --   -lgnat
   --   -lm
   --   -ldl
--  END Object file/option list   

end ada_main;
