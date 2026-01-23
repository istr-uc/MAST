pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__gmasteditor.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__gmasteditor.adb");
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
   E419 : Short_Integer; pragma Import (Ada, E419, "ada__assertions_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "ada__strings__utf_encoding_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "ada__tags_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "ada__strings__text_buffers_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "gnat_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "interfaces__c__strings_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "ada__streams_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "system__file_control_block_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "system__finalization_root_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "ada__finalization_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "system__file_io_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "system__storage_pools_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "system__finalization_masters_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "system__storage_pools__subpools_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "ada__strings__unbounded_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__calendar_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "ada__text_io_E");
   E195 : Short_Integer; pragma Import (Ada, E195, "system__pool_global_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "system__regexp_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__directories_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "glib_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "gtkada__types_E");
   E501 : Short_Integer; pragma Import (Ada, E501, "binary_trees_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "change_control_E");
   E624 : Short_Integer; pragma Import (Ada, E624, "cut_strings_E");
   E766 : Short_Integer; pragma Import (Ada, E766, "file_execution_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "gdk__frame_timings_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "glib__glist_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "gdk__visual_E");
   E453 : Short_Integer; pragma Import (Ada, E453, "glib__graphs_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "glib__gslist_E");
   E457 : Short_Integer; pragma Import (Ada, E457, "glib__poll_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "gtkada__c_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "glib__object_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "glib__type_conversion_hooks_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "glib__types_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "glib__values_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "gtkada__bindings_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "cairo_E");
   E443 : Short_Integer; pragma Import (Ada, E443, "cairo__image_surface_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "cairo__region_E");
   E446 : Short_Integer; pragma Import (Ada, E446, "cairo__surface_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "gdk__rectangle_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "glib__generic_properties_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "gdk__color_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "gdk__rgba_E");
   E378 : Short_Integer; pragma Import (Ada, E378, "glib__key_file_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "glib__properties_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "gdk__device_tool_E");
   E332 : Short_Integer; pragma Import (Ada, E332, "gdk__drawing_context_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "gdk__event_E");
   E459 : Short_Integer; pragma Import (Ada, E459, "glib__spawn_E");
   E455 : Short_Integer; pragma Import (Ada, E455, "glib__main_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "glib__string_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "glib__variant_E");
   E340 : Short_Integer; pragma Import (Ada, E340, "glib__g_icon_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "gtk__actionable_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "gtk__builder_E");
   E320 : Short_Integer; pragma Import (Ada, E320, "gtk__buildable_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "gtk__cell_area_context_E");
   E368 : Short_Integer; pragma Import (Ada, E368, "gtk__css_section_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "gtk__enums_E");
   E656 : Short_Integer; pragma Import (Ada, E656, "gtk__file_filter_E");
   E326 : Short_Integer; pragma Import (Ada, E326, "gtk__orientable_E");
   E380 : Short_Integer; pragma Import (Ada, E380, "gtk__paper_size_E");
   E376 : Short_Integer; pragma Import (Ada, E376, "gtk__page_setup_E");
   E386 : Short_Integer; pragma Import (Ada, E386, "gtk__print_settings_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__target_entry_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__target_list_E");
   E406 : Short_Integer; pragma Import (Ada, E406, "gtk__text_mark_E");
   E641 : Short_Integer; pragma Import (Ada, E641, "gtkada__pixmaps_E");
   E468 : Short_Integer; pragma Import (Ada, E468, "list_exceptions_E");
   E516 : Short_Integer; pragma Import (Ada, E516, "hash_lists_E");
   E485 : Short_Integer; pragma Import (Ada, E485, "indexed_lists_E");
   E775 : Short_Integer; pragma Import (Ada, E775, "mast_analysis_pixmaps_E");
   E576 : Short_Integer; pragma Import (Ada, E576, "mast_editor_intl_E");
   E810 : Short_Integer; pragma Import (Ada, E810, "mast_lex_dfa_E");
   E812 : Short_Integer; pragma Import (Ada, E812, "mast_lex_io_E");
   E660 : Short_Integer; pragma Import (Ada, E660, "mast_parser_error_report_E");
   E294 : Short_Integer; pragma Import (Ada, E294, "pango__enums_E");
   E314 : Short_Integer; pragma Import (Ada, E314, "pango__attributes_E");
   E298 : Short_Integer; pragma Import (Ada, E298, "pango__font_metrics_E");
   E300 : Short_Integer; pragma Import (Ada, E300, "pango__language_E");
   E296 : Short_Integer; pragma Import (Ada, E296, "pango__font_E");
   E392 : Short_Integer; pragma Import (Ada, E392, "gtk__text_attributes_E");
   E394 : Short_Integer; pragma Import (Ada, E394, "gtk__text_tag_E");
   E304 : Short_Integer; pragma Import (Ada, E304, "pango__font_face_E");
   E302 : Short_Integer; pragma Import (Ada, E302, "pango__font_family_E");
   E306 : Short_Integer; pragma Import (Ada, E306, "pango__fontset_E");
   E308 : Short_Integer; pragma Import (Ada, E308, "pango__matrix_E");
   E292 : Short_Integer; pragma Import (Ada, E292, "pango__context_E");
   E310 : Short_Integer; pragma Import (Ada, E310, "pango__font_map_E");
   E316 : Short_Integer; pragma Import (Ada, E316, "pango__tabs_E");
   E312 : Short_Integer; pragma Import (Ada, E312, "pango__layout_E");
   E382 : Short_Integer; pragma Import (Ada, E382, "gtk__print_context_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "gdk__frame_clock_E");
   E410 : Short_Integer; pragma Import (Ada, E410, "gdk__monitor_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "gdk__display_E");
   E334 : Short_Integer; pragma Import (Ada, E334, "gdk__glcontext_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "gdk__pixbuf_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "gdk__screen_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "gdk__device_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "gdk__drag_contexts_E");
   E330 : Short_Integer; pragma Import (Ada, E330, "gdk__window_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "glib__action_group_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "gtk__accel_group_E");
   E324 : Short_Integer; pragma Import (Ada, E324, "gtk__adjustment_E");
   E342 : Short_Integer; pragma Import (Ada, E342, "gtk__cell_editable_E");
   E344 : Short_Integer; pragma Import (Ada, E344, "gtk__editable_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "gtk__entry_buffer_E");
   E364 : Short_Integer; pragma Import (Ada, E364, "gtk__icon_source_E");
   E384 : Short_Integer; pragma Import (Ada, E384, "gtk__print_operation_preview_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "gtk__selection_data_E");
   E402 : Short_Integer; pragma Import (Ada, E402, "gtk__clipboard_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__style_E");
   E398 : Short_Integer; pragma Import (Ada, E398, "gtk__scrollable_E");
   E390 : Short_Integer; pragma Import (Ada, E390, "gtk__text_iter_E");
   E408 : Short_Integer; pragma Import (Ada, E408, "gtk__text_tag_table_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "gtk__tree_model_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "gtk__widget_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "gtk__cell_renderer_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "gtk__cell_layout_E");
   E350 : Short_Integer; pragma Import (Ada, E350, "gtk__cell_area_E");
   E322 : Short_Integer; pragma Import (Ada, E322, "gtk__container_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "gtk__bin_E");
   E318 : Short_Integer; pragma Import (Ada, E318, "gtk__box_E");
   E348 : Short_Integer; pragma Import (Ada, E348, "gtk__entry_completion_E");
   E370 : Short_Integer; pragma Import (Ada, E370, "gtk__misc_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "gtk__notebook_E");
   E388 : Short_Integer; pragma Import (Ada, E388, "gtk__status_bar_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "gtk__style_provider_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "gtk__settings_E");
   E366 : Short_Integer; pragma Import (Ada, E366, "gtk__style_context_E");
   E362 : Short_Integer; pragma Import (Ada, E362, "gtk__icon_set_E");
   E360 : Short_Integer; pragma Import (Ada, E360, "gtk__image_E");
   E338 : Short_Integer; pragma Import (Ada, E338, "gtk__gentry_E");
   E404 : Short_Integer; pragma Import (Ada, E404, "gtk__text_child_anchor_E");
   E400 : Short_Integer; pragma Import (Ada, E400, "gtk__text_buffer_E");
   E396 : Short_Integer; pragma Import (Ada, E396, "gtk__text_view_E");
   E328 : Short_Integer; pragma Import (Ada, E328, "gtk__window_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "gtk__dialog_E");
   E374 : Short_Integer; pragma Import (Ada, E374, "gtk__print_operation_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "gtk__arguments_E");
   E448 : Short_Integer; pragma Import (Ada, E448, "gdk__cairo_E");
   E450 : Short_Integer; pragma Import (Ada, E450, "gdk__cursor_E");
   E429 : Short_Integer; pragma Import (Ada, E429, "glib__menu_model_E");
   E433 : Short_Integer; pragma Import (Ada, E433, "gtk__action_E");
   E437 : Short_Integer; pragma Import (Ada, E437, "gtk__activatable_E");
   E636 : Short_Integer; pragma Import (Ada, E636, "gtk__alignment_E");
   E608 : Short_Integer; pragma Import (Ada, E608, "gtk__button_E");
   E695 : Short_Integer; pragma Import (Ada, E695, "gtk__cell_renderer_text_E");
   E654 : Short_Integer; pragma Import (Ada, E654, "gtk__file_chooser_E");
   E664 : Short_Integer; pragma Import (Ada, E664, "gtk__file_chooser_dialog_E");
   E413 : Short_Integer; pragma Import (Ada, E413, "gtk__frame_E");
   E622 : Short_Integer; pragma Import (Ada, E622, "gtk__grange_E");
   E467 : Short_Integer; pragma Import (Ada, E467, "gtk__layout_E");
   E461 : Short_Integer; pragma Import (Ada, E461, "gtk__main_E");
   E421 : Short_Integer; pragma Import (Ada, E421, "gtk__marshallers_E");
   E431 : Short_Integer; pragma Import (Ada, E431, "gtk__menu_item_E");
   E439 : Short_Integer; pragma Import (Ada, E439, "gtk__menu_shell_E");
   E427 : Short_Integer; pragma Import (Ada, E427, "gtk__menu_E");
   E425 : Short_Integer; pragma Import (Ada, E425, "gtk__label_E");
   E789 : Short_Integer; pragma Import (Ada, E789, "gtk__menu_bar_E");
   E620 : Short_Integer; pragma Import (Ada, E620, "gtk__scrollbar_E");
   E618 : Short_Integer; pragma Import (Ada, E618, "gtk__scrolled_window_E");
   E638 : Short_Integer; pragma Import (Ada, E638, "gtk__separator_E");
   E791 : Short_Integer; pragma Import (Ada, E791, "gtk__separator_menu_item_E");
   E610 : Short_Integer; pragma Import (Ada, E610, "gtk__table_E");
   E801 : Short_Integer; pragma Import (Ada, E801, "gtk__toggle_button_E");
   E799 : Short_Integer; pragma Import (Ada, E799, "gtk__check_button_E");
   E604 : Short_Integer; pragma Import (Ada, E604, "gtk__tooltip_E");
   E592 : Short_Integer; pragma Import (Ada, E592, "gtk__tree_drag_dest_E");
   E594 : Short_Integer; pragma Import (Ada, E594, "gtk__tree_drag_source_E");
   E606 : Short_Integer; pragma Import (Ada, E606, "gtk__tree_selection_E");
   E596 : Short_Integer; pragma Import (Ada, E596, "gtk__tree_sortable_E");
   E590 : Short_Integer; pragma Import (Ada, E590, "gtk__tree_store_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "gtk__tree_view_column_E");
   E602 : Short_Integer; pragma Import (Ada, E602, "gtk__tree_view_E");
   E600 : Short_Integer; pragma Import (Ada, E600, "gtk__combo_box_E");
   E598 : Short_Integer; pragma Import (Ada, E598, "gtk__combo_box_text_E");
   E462 : Short_Integer; pragma Import (Ada, E462, "gtkada__handlers_E");
   E464 : Short_Integer; pragma Import (Ada, E464, "pango__cairo_E");
   E441 : Short_Integer; pragma Import (Ada, E441, "gtkada__canvas_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "var_strings_E");
   E470 : Short_Integer; pragma Import (Ada, E470, "mast_E");
   E565 : Short_Integer; pragma Import (Ada, E565, "mast_editor_E");
   E506 : Short_Integer; pragma Import (Ada, E506, "named_lists_E");
   E504 : Short_Integer; pragma Import (Ada, E504, "symbol_table_E");
   E502 : Short_Integer; pragma Import (Ada, E502, "mast_parser_tokens_E");
   E487 : Short_Integer; pragma Import (Ada, E487, "mast__io_E");
   E540 : Short_Integer; pragma Import (Ada, E540, "mast__scheduling_parameters_E");
   E550 : Short_Integer; pragma Import (Ada, E550, "mast__scheduling_policies_E");
   E542 : Short_Integer; pragma Import (Ada, E542, "mast__synchronization_parameters_E");
   E522 : Short_Integer; pragma Import (Ada, E522, "mast__events_E");
   E520 : Short_Integer; pragma Import (Ada, E520, "mast__graphs_E");
   E530 : Short_Integer; pragma Import (Ada, E530, "mast__results_E");
   E528 : Short_Integer; pragma Import (Ada, E528, "mast__processing_resources_E");
   E548 : Short_Integer; pragma Import (Ada, E548, "mast__schedulers_E");
   E556 : Short_Integer; pragma Import (Ada, E556, "mast__scheduling_servers_E");
   E562 : Short_Integer; pragma Import (Ada, E562, "mast__schedulers__adjustment_E");
   E560 : Short_Integer; pragma Import (Ada, E560, "mast__schedulers__secondary_E");
   E564 : Short_Integer; pragma Import (Ada, E564, "mast__shared_resources_E");
   E512 : Short_Integer; pragma Import (Ada, E512, "mast__operations_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "mast__drivers_E");
   E526 : Short_Integer; pragma Import (Ada, E526, "mast__graphs__event_handlers_E");
   E558 : Short_Integer; pragma Import (Ada, E558, "mast__processing_resources__network_E");
   E554 : Short_Integer; pragma Import (Ada, E554, "mast__timers_E");
   E546 : Short_Integer; pragma Import (Ada, E546, "mast__processing_resources__processor_E");
   E536 : Short_Integer; pragma Import (Ada, E536, "mast__timing_requirements_E");
   E532 : Short_Integer; pragma Import (Ada, E532, "mast__graphs__links_E");
   E524 : Short_Integer; pragma Import (Ada, E524, "mast__transactions_E");
   E518 : Short_Integer; pragma Import (Ada, E518, "mast__systems_E");
   E552 : Short_Integer; pragma Import (Ada, E552, "mast__schedulers__primary_E");
   E514 : Short_Integer; pragma Import (Ada, E514, "mast__xmi_E");
   E672 : Short_Integer; pragma Import (Ada, E672, "mast__transaction_operations_E");
   E808 : Short_Integer; pragma Import (Ada, E808, "mast_lex_E");
   E588 : Short_Integer; pragma Import (Ada, E588, "utilities_E");
   E724 : Short_Integer; pragma Import (Ada, E724, "add_link_dialog_pkg_E");
   E726 : Short_Integer; pragma Import (Ada, E726, "add_link_dialog_pkg__callbacks_E");
   E795 : Short_Integer; pragma Import (Ada, E795, "add_new_op_to_driver_dialog_pkg_E");
   E797 : Short_Integer; pragma Import (Ada, E797, "add_new_op_to_driver_dialog_pkg__callbacks_E");
   E803 : Short_Integer; pragma Import (Ada, E803, "add_new_server_to_driver_dialog_pkg_E");
   E805 : Short_Integer; pragma Import (Ada, E805, "add_new_server_to_driver_dialog_pkg__callbacks_E");
   E584 : Short_Integer; pragma Import (Ada, E584, "add_operation_dialog_pkg_E");
   E586 : Short_Integer; pragma Import (Ada, E586, "add_operation_dialog_pkg__callbacks_E");
   E612 : Short_Integer; pragma Import (Ada, E612, "add_shared_dialog_pkg_E");
   E614 : Short_Integer; pragma Import (Ada, E614, "add_shared_dialog_pkg__callbacks_E");
   E616 : Short_Integer; pragma Import (Ada, E616, "aux_window_pkg_E");
   E572 : Short_Integer; pragma Import (Ada, E572, "cop_dialog_pkg_E");
   E574 : Short_Integer; pragma Import (Ada, E574, "cop_dialog_pkg__callbacks_E");
   E569 : Short_Integer; pragma Import (Ada, E569, "driver_dialog_pkg_E");
   E793 : Short_Integer; pragma Import (Ada, E793, "driver_dialog_pkg__callbacks_E");
   E632 : Short_Integer; pragma Import (Ada, E632, "editor_error_window_pkg_E");
   E634 : Short_Integer; pragma Import (Ada, E634, "editor_error_window_pkg__callbacks_E");
   E728 : Short_Integer; pragma Import (Ada, E728, "external_dialog_pkg_E");
   E730 : Short_Integer; pragma Import (Ada, E730, "external_dialog_pkg__callbacks_E");
   E768 : Short_Integer; pragma Import (Ada, E768, "import_file_selection_pkg_E");
   E770 : Short_Integer; pragma Import (Ada, E770, "import_file_selection_pkg__callbacks_E");
   E644 : Short_Integer; pragma Import (Ada, E644, "item_menu_pkg_E");
   E646 : Short_Integer; pragma Import (Ada, E646, "item_menu_pkg__callbacks_E");
   E567 : Short_Integer; pragma Import (Ada, E567, "mast_editor__drivers_E");
   E582 : Short_Integer; pragma Import (Ada, E582, "mast_editor__operations_E");
   E678 : Short_Integer; pragma Import (Ada, E678, "mast_editor__processing_resources_E");
   E676 : Short_Integer; pragma Import (Ada, E676, "mast_editor__schedulers_E");
   E674 : Short_Integer; pragma Import (Ada, E674, "mast_editor__scheduling_servers_E");
   E670 : Short_Integer; pragma Import (Ada, E670, "mast_editor__shared_resources_E");
   E681 : Short_Integer; pragma Import (Ada, E681, "mast_editor__timers_E");
   E580 : Short_Integer; pragma Import (Ada, E580, "mast_editor_window_pkg_E");
   E764 : Short_Integer; pragma Import (Ada, E764, "mast_editor_window_pkg__callbacks_E");
   E714 : Short_Integer; pragma Import (Ada, E714, "message_tx_dialog_pkg_E");
   E716 : Short_Integer; pragma Import (Ada, E716, "message_tx_dialog_pkg__callbacks_E");
   E748 : Short_Integer; pragma Import (Ada, E748, "mieh_dialog_pkg_E");
   E750 : Short_Integer; pragma Import (Ada, E750, "mieh_dialog_pkg__callbacks_E");
   E752 : Short_Integer; pragma Import (Ada, E752, "moeh_dialog_pkg_E");
   E754 : Short_Integer; pragma Import (Ada, E754, "moeh_dialog_pkg__callbacks_E");
   E687 : Short_Integer; pragma Import (Ada, E687, "network_dialog_pkg_E");
   E689 : Short_Integer; pragma Import (Ada, E689, "network_dialog_pkg__callbacks_E");
   E652 : Short_Integer; pragma Import (Ada, E652, "open_file_selection_pkg_E");
   E658 : Short_Integer; pragma Import (Ada, E658, "open_file_selection_pkg__callbacks_E");
   E691 : Short_Integer; pragma Import (Ada, E691, "prime_sched_dialog_pkg_E");
   E693 : Short_Integer; pragma Import (Ada, E693, "prime_sched_dialog_pkg__callbacks_E");
   E697 : Short_Integer; pragma Import (Ada, E697, "processor_dialog_pkg_E");
   E699 : Short_Integer; pragma Import (Ada, E699, "processor_dialog_pkg__callbacks_E");
   E648 : Short_Integer; pragma Import (Ada, E648, "save_changes_dialog_pkg_E");
   E650 : Short_Integer; pragma Import (Ada, E650, "save_changes_dialog_pkg__callbacks_E");
   E666 : Short_Integer; pragma Import (Ada, E666, "save_file_selection_pkg_E");
   E668 : Short_Integer; pragma Import (Ada, E668, "save_file_selection_pkg__callbacks_E");
   E706 : Short_Integer; pragma Import (Ada, E706, "sched_server_dialog_pkg_E");
   E708 : Short_Integer; pragma Import (Ada, E708, "sched_server_dialog_pkg__callbacks_E");
   E702 : Short_Integer; pragma Import (Ada, E702, "second_sched_dialog_pkg_E");
   E704 : Short_Integer; pragma Import (Ada, E704, "second_sched_dialog_pkg__callbacks_E");
   E756 : Short_Integer; pragma Import (Ada, E756, "seh_dialog_pkg_E");
   E758 : Short_Integer; pragma Import (Ada, E758, "seh_dialog_pkg__callbacks_E");
   E736 : Short_Integer; pragma Import (Ada, E736, "select_ref_event_dialog_pkg_E");
   E738 : Short_Integer; pragma Import (Ada, E738, "select_ref_event_dialog_pkg__callbacks_E");
   E740 : Short_Integer; pragma Import (Ada, E740, "select_req_type_dialog_pkg_E");
   E742 : Short_Integer; pragma Import (Ada, E742, "select_req_type_dialog_pkg__callbacks_E");
   E710 : Short_Integer; pragma Import (Ada, E710, "shared_resource_dialog_pkg_E");
   E712 : Short_Integer; pragma Import (Ada, E712, "shared_resource_dialog_pkg__callbacks_E");
   E718 : Short_Integer; pragma Import (Ada, E718, "sop_dialog_pkg_E");
   E720 : Short_Integer; pragma Import (Ada, E720, "sop_dialog_pkg__callbacks_E");
   E683 : Short_Integer; pragma Import (Ada, E683, "timer_dialog_pkg_E");
   E685 : Short_Integer; pragma Import (Ada, E685, "timer_dialog_pkg__callbacks_E");
   E760 : Short_Integer; pragma Import (Ada, E760, "trans_dialog_pkg_E");
   E722 : Short_Integer; pragma Import (Ada, E722, "mast_editor__transactions_E");
   E746 : Short_Integer; pragma Import (Ada, E746, "mast_editor__event_handlers_E");
   E744 : Short_Integer; pragma Import (Ada, E744, "mast_editor__links_E");
   E732 : Short_Integer; pragma Import (Ada, E732, "internal_dialog_pkg_E");
   E734 : Short_Integer; pragma Import (Ada, E734, "internal_dialog_pkg__callbacks_E");
   E816 : Short_Integer; pragma Import (Ada, E816, "mast_editor__systems_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "editor_actions_E");
   E762 : Short_Integer; pragma Import (Ada, E762, "trans_dialog_pkg__callbacks_E");
   E774 : Short_Integer; pragma Import (Ada, E774, "wizard_activity_dialog_pkg_E");
   E777 : Short_Integer; pragma Import (Ada, E777, "wizard_completed_dialog_pkg_E");
   E779 : Short_Integer; pragma Import (Ada, E779, "wizard_input_dialog_pkg_E");
   E570 : Short_Integer; pragma Import (Ada, E570, "callbacks_mast_editor_E");
   E781 : Short_Integer; pragma Import (Ada, E781, "wizard_input_dialog_pkg__callbacks_E");
   E783 : Short_Integer; pragma Import (Ada, E783, "wizard_output_dialog_pkg_E");
   E785 : Short_Integer; pragma Import (Ada, E785, "wizard_transaction_dialog_pkg_E");
   E787 : Short_Integer; pragma Import (Ada, E787, "wizard_welcome_dialog_pkg_E");
   E772 : Short_Integer; pragma Import (Ada, E772, "simple_transaction_wizard_control_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "simple_transaction_wizard_control__finalize_body");
      begin
         E772 := E772 - 1;
         F1;
      end;
      E787 := E787 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "wizard_welcome_dialog_pkg__finalize_spec");
      begin
         F2;
      end;
      E785 := E785 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "wizard_transaction_dialog_pkg__finalize_spec");
      begin
         F3;
      end;
      E783 := E783 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "wizard_output_dialog_pkg__finalize_spec");
      begin
         F4;
      end;
      E779 := E779 - 1;
      E777 := E777 - 1;
      E774 := E774 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "trans_dialog_pkg__finalize_body");
      begin
         E760 := E760 - 1;
         F5;
      end;
      E683 := E683 - 1;
      E718 := E718 - 1;
      E710 := E710 - 1;
      E740 := E740 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "select_ref_event_dialog_pkg__finalize_body");
      begin
         E736 := E736 - 1;
         F6;
      end;
      E756 := E756 - 1;
      E702 := E702 - 1;
      E706 := E706 - 1;
      E666 := E666 - 1;
      E648 := E648 - 1;
      E697 := E697 - 1;
      E691 := E691 - 1;
      E652 := E652 - 1;
      E687 := E687 - 1;
      E752 := E752 - 1;
      E748 := E748 - 1;
      E714 := E714 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "mast_editor_window_pkg__finalize_body");
      begin
         E580 := E580 - 1;
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "mast_editor__transactions__finalize_body");
      begin
         E722 := E722 - 1;
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast_editor__shared_resources__finalize_body");
      begin
         E670 := E670 - 1;
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast_editor__scheduling_servers__finalize_body");
      begin
         E674 := E674 - 1;
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast_editor__schedulers__finalize_body");
      begin
         E676 := E676 - 1;
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast_editor__processing_resources__finalize_body");
      begin
         E678 := E678 - 1;
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast_editor__operations__finalize_body");
      begin
         E582 := E582 - 1;
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast_editor__links__finalize_body");
      begin
         E744 := E744 - 1;
         F14;
      end;
      E644 := E644 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "internal_dialog_pkg__callbacks__finalize_body");
      begin
         E734 := E734 - 1;
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "internal_dialog_pkg__finalize_body");
      begin
         E732 := E732 - 1;
         F16;
      end;
      E768 := E768 - 1;
      E728 := E728 - 1;
      E632 := E632 - 1;
      E569 := E569 - 1;
      E572 := E572 - 1;
      E616 := E616 - 1;
      E612 := E612 - 1;
      E584 := E584 - 1;
      E803 := E803 - 1;
      E795 := E795 - 1;
      E724 := E724 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "callbacks_mast_editor__finalize_spec");
      begin
         E570 := E570 - 1;
         F17;
      end;
      declare
         procedure F18;
         pragma Import (Ada, F18, "wizard_input_dialog_pkg__finalize_spec");
      begin
         F18;
      end;
      declare
         procedure F19;
         pragma Import (Ada, F19, "wizard_completed_dialog_pkg__finalize_spec");
      begin
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "wizard_activity_dialog_pkg__finalize_spec");
      begin
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "mast_editor__timers__finalize_body");
      begin
         E681 := E681 - 1;
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "mast_editor__event_handlers__finalize_body");
      begin
         E746 := E746 - 1;
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "mast_editor__drivers__finalize_body");
      begin
         E567 := E567 - 1;
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "driver_dialog_pkg__callbacks__finalize_body");
      begin
         E793 := E793 - 1;
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "editor_actions__finalize_body");
      begin
         E177 := E177 - 1;
         F25;
      end;
      declare
         procedure F26;
         pragma Import (Ada, F26, "editor_actions__finalize_spec");
      begin
         F26;
      end;
      E816 := E816 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "mast_editor__systems__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "internal_dialog_pkg__finalize_spec");
      begin
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "mast_editor__links__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "mast_editor__event_handlers__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "mast_editor__transactions__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "trans_dialog_pkg__finalize_spec");
      begin
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "timer_dialog_pkg__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "sop_dialog_pkg__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "shared_resource_dialog_pkg__finalize_spec");
      begin
         F35;
      end;
      declare
         procedure F36;
         pragma Import (Ada, F36, "select_req_type_dialog_pkg__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "select_ref_event_dialog_pkg__finalize_spec");
      begin
         F37;
      end;
      declare
         procedure F38;
         pragma Import (Ada, F38, "seh_dialog_pkg__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "second_sched_dialog_pkg__finalize_spec");
      begin
         F39;
      end;
      declare
         procedure F40;
         pragma Import (Ada, F40, "sched_server_dialog_pkg__finalize_spec");
      begin
         F40;
      end;
      declare
         procedure F41;
         pragma Import (Ada, F41, "save_file_selection_pkg__finalize_spec");
      begin
         F41;
      end;
      declare
         procedure F42;
         pragma Import (Ada, F42, "save_changes_dialog_pkg__finalize_spec");
      begin
         F42;
      end;
      declare
         procedure F43;
         pragma Import (Ada, F43, "processor_dialog_pkg__finalize_spec");
      begin
         F43;
      end;
      declare
         procedure F44;
         pragma Import (Ada, F44, "prime_sched_dialog_pkg__finalize_spec");
      begin
         F44;
      end;
      declare
         procedure F45;
         pragma Import (Ada, F45, "open_file_selection_pkg__finalize_spec");
      begin
         F45;
      end;
      declare
         procedure F46;
         pragma Import (Ada, F46, "network_dialog_pkg__finalize_spec");
      begin
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "moeh_dialog_pkg__finalize_spec");
      begin
         F47;
      end;
      declare
         procedure F48;
         pragma Import (Ada, F48, "mieh_dialog_pkg__finalize_spec");
      begin
         F48;
      end;
      declare
         procedure F49;
         pragma Import (Ada, F49, "message_tx_dialog_pkg__finalize_spec");
      begin
         F49;
      end;
      declare
         procedure F50;
         pragma Import (Ada, F50, "mast_editor_window_pkg__finalize_spec");
      begin
         F50;
      end;
      declare
         procedure F51;
         pragma Import (Ada, F51, "mast_editor__timers__finalize_spec");
      begin
         F51;
      end;
      declare
         procedure F52;
         pragma Import (Ada, F52, "mast_editor__shared_resources__finalize_spec");
      begin
         F52;
      end;
      declare
         procedure F53;
         pragma Import (Ada, F53, "mast_editor__scheduling_servers__finalize_spec");
      begin
         F53;
      end;
      declare
         procedure F54;
         pragma Import (Ada, F54, "mast_editor__schedulers__finalize_spec");
      begin
         F54;
      end;
      declare
         procedure F55;
         pragma Import (Ada, F55, "mast_editor__processing_resources__finalize_spec");
      begin
         F55;
      end;
      declare
         procedure F56;
         pragma Import (Ada, F56, "mast_editor__operations__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "mast_editor__drivers__finalize_spec");
      begin
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "item_menu_pkg__finalize_spec");
      begin
         F58;
      end;
      declare
         procedure F59;
         pragma Import (Ada, F59, "import_file_selection_pkg__finalize_spec");
      begin
         F59;
      end;
      declare
         procedure F60;
         pragma Import (Ada, F60, "external_dialog_pkg__finalize_spec");
      begin
         F60;
      end;
      declare
         procedure F61;
         pragma Import (Ada, F61, "editor_error_window_pkg__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "driver_dialog_pkg__finalize_spec");
      begin
         F62;
      end;
      declare
         procedure F63;
         pragma Import (Ada, F63, "cop_dialog_pkg__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "aux_window_pkg__finalize_spec");
      begin
         F64;
      end;
      declare
         procedure F65;
         pragma Import (Ada, F65, "add_shared_dialog_pkg__finalize_spec");
      begin
         F65;
      end;
      declare
         procedure F66;
         pragma Import (Ada, F66, "add_operation_dialog_pkg__finalize_spec");
      begin
         F66;
      end;
      declare
         procedure F67;
         pragma Import (Ada, F67, "add_new_server_to_driver_dialog_pkg__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "add_new_op_to_driver_dialog_pkg__finalize_spec");
      begin
         F68;
      end;
      declare
         procedure F69;
         pragma Import (Ada, F69, "add_link_dialog_pkg__finalize_spec");
      begin
         F69;
      end;
      E524 := E524 - 1;
      E536 := E536 - 1;
      E554 := E554 - 1;
      E518 := E518 - 1;
      E564 := E564 - 1;
      E556 := E556 - 1;
      E560 := E560 - 1;
      E552 := E552 - 1;
      E530 := E530 - 1;
      E546 := E546 - 1;
      E558 := E558 - 1;
      E512 := E512 - 1;
      E526 := E526 - 1;
      E522 := E522 - 1;
      E483 := E483 - 1;
      declare
         procedure F70;
         pragma Import (Ada, F70, "mast__schedulers__primary__finalize_spec");
      begin
         F70;
      end;
      declare
         procedure F71;
         pragma Import (Ada, F71, "mast__systems__finalize_spec");
      begin
         F71;
      end;
      declare
         procedure F72;
         pragma Import (Ada, F72, "mast__transactions__finalize_spec");
      begin
         F72;
      end;
      E532 := E532 - 1;
      declare
         procedure F73;
         pragma Import (Ada, F73, "mast__graphs__links__finalize_spec");
      begin
         F73;
      end;
      declare
         procedure F74;
         pragma Import (Ada, F74, "mast__timing_requirements__finalize_spec");
      begin
         F74;
      end;
      declare
         procedure F75;
         pragma Import (Ada, F75, "mast__processing_resources__processor__finalize_spec");
      begin
         F75;
      end;
      declare
         procedure F76;
         pragma Import (Ada, F76, "mast__timers__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "mast__processing_resources__network__finalize_spec");
      begin
         F77;
      end;
      declare
         procedure F78;
         pragma Import (Ada, F78, "mast__graphs__event_handlers__finalize_spec");
      begin
         F78;
      end;
      declare
         procedure F79;
         pragma Import (Ada, F79, "mast__drivers__finalize_spec");
      begin
         F79;
      end;
      declare
         procedure F80;
         pragma Import (Ada, F80, "mast__operations__finalize_spec");
      begin
         F80;
      end;
      declare
         procedure F81;
         pragma Import (Ada, F81, "mast__shared_resources__finalize_spec");
      begin
         F81;
      end;
      declare
         procedure F82;
         pragma Import (Ada, F82, "mast__schedulers__secondary__finalize_spec");
      begin
         F82;
      end;
      declare
         procedure F83;
         pragma Import (Ada, F83, "mast__scheduling_servers__finalize_spec");
      begin
         F83;
      end;
      E548 := E548 - 1;
      declare
         procedure F84;
         pragma Import (Ada, F84, "mast__schedulers__finalize_spec");
      begin
         F84;
      end;
      E528 := E528 - 1;
      declare
         procedure F85;
         pragma Import (Ada, F85, "mast__processing_resources__finalize_spec");
      begin
         F85;
      end;
      declare
         procedure F86;
         pragma Import (Ada, F86, "mast__results__finalize_spec");
      begin
         F86;
      end;
      E520 := E520 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "mast__graphs__finalize_spec");
      begin
         F87;
      end;
      declare
         procedure F88;
         pragma Import (Ada, F88, "mast__events__finalize_spec");
      begin
         F88;
      end;
      E542 := E542 - 1;
      declare
         procedure F89;
         pragma Import (Ada, F89, "mast__synchronization_parameters__finalize_spec");
      begin
         F89;
      end;
      E550 := E550 - 1;
      declare
         procedure F90;
         pragma Import (Ada, F90, "mast__scheduling_policies__finalize_spec");
      begin
         F90;
      end;
      E540 := E540 - 1;
      declare
         procedure F91;
         pragma Import (Ada, F91, "mast__scheduling_parameters__finalize_spec");
      begin
         F91;
      end;
      declare
         procedure F92;
         pragma Import (Ada, F92, "mast_editor__finalize_spec");
      begin
         E565 := E565 - 1;
         F92;
      end;
      E441 := E441 - 1;
      declare
         procedure F93;
         pragma Import (Ada, F93, "gtkada__canvas__finalize_spec");
      begin
         F93;
      end;
      declare
         procedure F94;
         pragma Import (Ada, F94, "gtkada__handlers__finalize_spec");
      begin
         E462 := E462 - 1;
         F94;
      end;
      E598 := E598 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "gtk__combo_box_text__finalize_spec");
      begin
         F95;
      end;
      E600 := E600 - 1;
      declare
         procedure F96;
         pragma Import (Ada, F96, "gtk__combo_box__finalize_spec");
      begin
         F96;
      end;
      E602 := E602 - 1;
      declare
         procedure F97;
         pragma Import (Ada, F97, "gtk__tree_view__finalize_spec");
      begin
         F97;
      end;
      E423 := E423 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "gtk__tree_view_column__finalize_spec");
      begin
         F98;
      end;
      E590 := E590 - 1;
      declare
         procedure F99;
         pragma Import (Ada, F99, "gtk__tree_store__finalize_spec");
      begin
         F99;
      end;
      E606 := E606 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "gtk__tree_selection__finalize_spec");
      begin
         F100;
      end;
      E604 := E604 - 1;
      declare
         procedure F101;
         pragma Import (Ada, F101, "gtk__tooltip__finalize_spec");
      begin
         F101;
      end;
      E799 := E799 - 1;
      declare
         procedure F102;
         pragma Import (Ada, F102, "gtk__check_button__finalize_spec");
      begin
         F102;
      end;
      E801 := E801 - 1;
      declare
         procedure F103;
         pragma Import (Ada, F103, "gtk__toggle_button__finalize_spec");
      begin
         F103;
      end;
      E610 := E610 - 1;
      declare
         procedure F104;
         pragma Import (Ada, F104, "gtk__table__finalize_spec");
      begin
         F104;
      end;
      E791 := E791 - 1;
      declare
         procedure F105;
         pragma Import (Ada, F105, "gtk__separator_menu_item__finalize_spec");
      begin
         F105;
      end;
      E638 := E638 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "gtk__separator__finalize_spec");
      begin
         F106;
      end;
      E618 := E618 - 1;
      declare
         procedure F107;
         pragma Import (Ada, F107, "gtk__scrolled_window__finalize_spec");
      begin
         F107;
      end;
      E620 := E620 - 1;
      declare
         procedure F108;
         pragma Import (Ada, F108, "gtk__scrollbar__finalize_spec");
      begin
         F108;
      end;
      E789 := E789 - 1;
      declare
         procedure F109;
         pragma Import (Ada, F109, "gtk__menu_bar__finalize_spec");
      begin
         F109;
      end;
      E425 := E425 - 1;
      declare
         procedure F110;
         pragma Import (Ada, F110, "gtk__label__finalize_spec");
      begin
         F110;
      end;
      E427 := E427 - 1;
      declare
         procedure F111;
         pragma Import (Ada, F111, "gtk__menu__finalize_spec");
      begin
         F111;
      end;
      E439 := E439 - 1;
      declare
         procedure F112;
         pragma Import (Ada, F112, "gtk__menu_shell__finalize_spec");
      begin
         F112;
      end;
      E431 := E431 - 1;
      declare
         procedure F113;
         pragma Import (Ada, F113, "gtk__menu_item__finalize_spec");
      begin
         F113;
      end;
      E467 := E467 - 1;
      declare
         procedure F114;
         pragma Import (Ada, F114, "gtk__layout__finalize_spec");
      begin
         F114;
      end;
      E622 := E622 - 1;
      declare
         procedure F115;
         pragma Import (Ada, F115, "gtk__grange__finalize_spec");
      begin
         F115;
      end;
      E413 := E413 - 1;
      declare
         procedure F116;
         pragma Import (Ada, F116, "gtk__frame__finalize_spec");
      begin
         F116;
      end;
      E664 := E664 - 1;
      declare
         procedure F117;
         pragma Import (Ada, F117, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F117;
      end;
      E695 := E695 - 1;
      declare
         procedure F118;
         pragma Import (Ada, F118, "gtk__cell_renderer_text__finalize_spec");
      begin
         F118;
      end;
      E608 := E608 - 1;
      declare
         procedure F119;
         pragma Import (Ada, F119, "gtk__button__finalize_spec");
      begin
         F119;
      end;
      E636 := E636 - 1;
      declare
         procedure F120;
         pragma Import (Ada, F120, "gtk__alignment__finalize_spec");
      begin
         F120;
      end;
      E433 := E433 - 1;
      declare
         procedure F121;
         pragma Import (Ada, F121, "gtk__action__finalize_spec");
      begin
         F121;
      end;
      E429 := E429 - 1;
      declare
         procedure F122;
         pragma Import (Ada, F122, "glib__menu_model__finalize_spec");
      begin
         F122;
      end;
      E328 := E328 - 1;
      E259 := E259 - 1;
      E358 := E358 - 1;
      E396 := E396 - 1;
      E408 := E408 - 1;
      E400 := E400 - 1;
      E366 := E366 - 1;
      E285 := E285 - 1;
      E388 := E388 - 1;
      E374 := E374 - 1;
      E372 := E372 - 1;
      E338 := E338 - 1;
      E348 := E348 - 1;
      E346 := E346 - 1;
      E251 := E251 - 1;
      E322 := E322 - 1;
      E402 := E402 - 1;
      E356 := E356 - 1;
      E350 := E350 - 1;
      E324 := E324 - 1;
      E279 := E279 - 1;
      E410 := E410 - 1;
      E263 := E263 - 1;
      E236 := E236 - 1;
      E231 := E231 - 1;
      E240 := E240 - 1;
      declare
         procedure F123;
         pragma Import (Ada, F123, "gtk__print_operation__finalize_spec");
      begin
         F123;
      end;
      declare
         procedure F124;
         pragma Import (Ada, F124, "gtk__dialog__finalize_spec");
      begin
         F124;
      end;
      declare
         procedure F125;
         pragma Import (Ada, F125, "gtk__window__finalize_spec");
      begin
         F125;
      end;
      declare
         procedure F126;
         pragma Import (Ada, F126, "gtk__text_view__finalize_spec");
      begin
         F126;
      end;
      declare
         procedure F127;
         pragma Import (Ada, F127, "gtk__text_buffer__finalize_spec");
      begin
         F127;
      end;
      E404 := E404 - 1;
      declare
         procedure F128;
         pragma Import (Ada, F128, "gtk__text_child_anchor__finalize_spec");
      begin
         F128;
      end;
      declare
         procedure F129;
         pragma Import (Ada, F129, "gtk__gentry__finalize_spec");
      begin
         F129;
      end;
      E360 := E360 - 1;
      declare
         procedure F130;
         pragma Import (Ada, F130, "gtk__image__finalize_spec");
      begin
         F130;
      end;
      E362 := E362 - 1;
      declare
         procedure F131;
         pragma Import (Ada, F131, "gtk__icon_set__finalize_spec");
      begin
         F131;
      end;
      declare
         procedure F132;
         pragma Import (Ada, F132, "gtk__style_context__finalize_spec");
      begin
         F132;
      end;
      E253 := E253 - 1;
      declare
         procedure F133;
         pragma Import (Ada, F133, "gtk__settings__finalize_spec");
      begin
         F133;
      end;
      declare
         procedure F134;
         pragma Import (Ada, F134, "gtk__status_bar__finalize_spec");
      begin
         F134;
      end;
      declare
         procedure F135;
         pragma Import (Ada, F135, "gtk__notebook__finalize_spec");
      begin
         F135;
      end;
      E370 := E370 - 1;
      declare
         procedure F136;
         pragma Import (Ada, F136, "gtk__misc__finalize_spec");
      begin
         F136;
      end;
      declare
         procedure F137;
         pragma Import (Ada, F137, "gtk__entry_completion__finalize_spec");
      begin
         F137;
      end;
      E318 := E318 - 1;
      declare
         procedure F138;
         pragma Import (Ada, F138, "gtk__box__finalize_spec");
      begin
         F138;
      end;
      E336 := E336 - 1;
      declare
         procedure F139;
         pragma Import (Ada, F139, "gtk__bin__finalize_spec");
      begin
         F139;
      end;
      declare
         procedure F140;
         pragma Import (Ada, F140, "gtk__container__finalize_spec");
      begin
         F140;
      end;
      declare
         procedure F141;
         pragma Import (Ada, F141, "gtk__cell_area__finalize_spec");
      begin
         F141;
      end;
      declare
         procedure F142;
         pragma Import (Ada, F142, "gtk__cell_renderer__finalize_spec");
      begin
         F142;
      end;
      declare
         procedure F143;
         pragma Import (Ada, F143, "gtk__widget__finalize_spec");
      begin
         F143;
      end;
      declare
         procedure F144;
         pragma Import (Ada, F144, "gtk__tree_model__finalize_spec");
      begin
         F144;
      end;
      declare
         procedure F145;
         pragma Import (Ada, F145, "gtk__text_tag_table__finalize_spec");
      begin
         F145;
      end;
      declare
         procedure F146;
         pragma Import (Ada, F146, "gtk__style__finalize_spec");
      begin
         F146;
      end;
      declare
         procedure F147;
         pragma Import (Ada, F147, "gtk__clipboard__finalize_spec");
      begin
         F147;
      end;
      E283 := E283 - 1;
      declare
         procedure F148;
         pragma Import (Ada, F148, "gtk__selection_data__finalize_spec");
      begin
         F148;
      end;
      E364 := E364 - 1;
      declare
         procedure F149;
         pragma Import (Ada, F149, "gtk__icon_source__finalize_spec");
      begin
         F149;
      end;
      declare
         procedure F150;
         pragma Import (Ada, F150, "gtk__entry_buffer__finalize_spec");
      begin
         F150;
      end;
      declare
         procedure F151;
         pragma Import (Ada, F151, "gtk__adjustment__finalize_spec");
      begin
         F151;
      end;
      declare
         procedure F152;
         pragma Import (Ada, F152, "gtk__accel_group__finalize_spec");
      begin
         F152;
      end;
      declare
         procedure F153;
         pragma Import (Ada, F153, "gdk__drag_contexts__finalize_spec");
      begin
         F153;
      end;
      declare
         procedure F154;
         pragma Import (Ada, F154, "gdk__device__finalize_spec");
      begin
         F154;
      end;
      E229 := E229 - 1;
      declare
         procedure F155;
         pragma Import (Ada, F155, "gdk__screen__finalize_spec");
      begin
         F155;
      end;
      E267 := E267 - 1;
      declare
         procedure F156;
         pragma Import (Ada, F156, "gdk__pixbuf__finalize_spec");
      begin
         F156;
      end;
      E334 := E334 - 1;
      declare
         procedure F157;
         pragma Import (Ada, F157, "gdk__glcontext__finalize_spec");
      begin
         F157;
      end;
      declare
         procedure F158;
         pragma Import (Ada, F158, "gdk__display__finalize_spec");
      begin
         F158;
      end;
      declare
         procedure F159;
         pragma Import (Ada, F159, "gdk__monitor__finalize_spec");
      begin
         F159;
      end;
      declare
         procedure F160;
         pragma Import (Ada, F160, "gdk__frame_clock__finalize_spec");
      begin
         F160;
      end;
      E382 := E382 - 1;
      declare
         procedure F161;
         pragma Import (Ada, F161, "gtk__print_context__finalize_spec");
      begin
         F161;
      end;
      E312 := E312 - 1;
      declare
         procedure F162;
         pragma Import (Ada, F162, "pango__layout__finalize_spec");
      begin
         F162;
      end;
      E316 := E316 - 1;
      declare
         procedure F163;
         pragma Import (Ada, F163, "pango__tabs__finalize_spec");
      begin
         F163;
      end;
      E310 := E310 - 1;
      declare
         procedure F164;
         pragma Import (Ada, F164, "pango__font_map__finalize_spec");
      begin
         F164;
      end;
      E292 := E292 - 1;
      declare
         procedure F165;
         pragma Import (Ada, F165, "pango__context__finalize_spec");
      begin
         F165;
      end;
      E306 := E306 - 1;
      declare
         procedure F166;
         pragma Import (Ada, F166, "pango__fontset__finalize_spec");
      begin
         F166;
      end;
      E302 := E302 - 1;
      declare
         procedure F167;
         pragma Import (Ada, F167, "pango__font_family__finalize_spec");
      begin
         F167;
      end;
      E304 := E304 - 1;
      declare
         procedure F168;
         pragma Import (Ada, F168, "pango__font_face__finalize_spec");
      begin
         F168;
      end;
      E394 := E394 - 1;
      declare
         procedure F169;
         pragma Import (Ada, F169, "gtk__text_tag__finalize_spec");
      begin
         F169;
      end;
      E296 := E296 - 1;
      declare
         procedure F170;
         pragma Import (Ada, F170, "pango__font__finalize_spec");
      begin
         F170;
      end;
      E300 := E300 - 1;
      declare
         procedure F171;
         pragma Import (Ada, F171, "pango__language__finalize_spec");
      begin
         F171;
      end;
      E298 := E298 - 1;
      declare
         procedure F172;
         pragma Import (Ada, F172, "pango__font_metrics__finalize_spec");
      begin
         F172;
      end;
      E314 := E314 - 1;
      declare
         procedure F173;
         pragma Import (Ada, F173, "pango__attributes__finalize_spec");
      begin
         F173;
      end;
      E406 := E406 - 1;
      declare
         procedure F174;
         pragma Import (Ada, F174, "gtk__text_mark__finalize_spec");
      begin
         F174;
      end;
      E287 := E287 - 1;
      declare
         procedure F175;
         pragma Import (Ada, F175, "gtk__target_list__finalize_spec");
      begin
         F175;
      end;
      E386 := E386 - 1;
      declare
         procedure F176;
         pragma Import (Ada, F176, "gtk__print_settings__finalize_spec");
      begin
         F176;
      end;
      E376 := E376 - 1;
      declare
         procedure F177;
         pragma Import (Ada, F177, "gtk__page_setup__finalize_spec");
      begin
         F177;
      end;
      E380 := E380 - 1;
      declare
         procedure F178;
         pragma Import (Ada, F178, "gtk__paper_size__finalize_spec");
      begin
         F178;
      end;
      E656 := E656 - 1;
      declare
         procedure F179;
         pragma Import (Ada, F179, "gtk__file_filter__finalize_spec");
      begin
         F179;
      end;
      E368 := E368 - 1;
      declare
         procedure F180;
         pragma Import (Ada, F180, "gtk__css_section__finalize_spec");
      begin
         F180;
      end;
      E352 := E352 - 1;
      declare
         procedure F181;
         pragma Import (Ada, F181, "gtk__cell_area_context__finalize_spec");
      begin
         F181;
      end;
      E281 := E281 - 1;
      declare
         procedure F182;
         pragma Import (Ada, F182, "gtk__builder__finalize_spec");
      begin
         F182;
      end;
      E275 := E275 - 1;
      declare
         procedure F183;
         pragma Import (Ada, F183, "glib__variant__finalize_spec");
      begin
         F183;
      end;
      E332 := E332 - 1;
      declare
         procedure F184;
         pragma Import (Ada, F184, "gdk__drawing_context__finalize_spec");
      begin
         F184;
      end;
      E244 := E244 - 1;
      declare
         procedure F185;
         pragma Import (Ada, F185, "gdk__device_tool__finalize_spec");
      begin
         F185;
      end;
      E205 := E205 - 1;
      declare
         procedure F186;
         pragma Import (Ada, F186, "glib__object__finalize_spec");
      begin
         F186;
      end;
      E453 := E453 - 1;
      declare
         procedure F187;
         pragma Import (Ada, F187, "glib__graphs__finalize_spec");
      begin
         F187;
      end;
      E265 := E265 - 1;
      declare
         procedure F188;
         pragma Import (Ada, F188, "gdk__frame_timings__finalize_spec");
      begin
         F188;
      end;
      E188 := E188 - 1;
      declare
         procedure F189;
         pragma Import (Ada, F189, "glib__finalize_spec");
      begin
         F189;
      end;
      declare
         procedure F190;
         pragma Import (Ada, F190, "ada__directories__finalize_body");
      begin
         E103 := E103 - 1;
         F190;
      end;
      declare
         procedure F191;
         pragma Import (Ada, F191, "ada__directories__finalize_spec");
      begin
         F191;
      end;
      E171 := E171 - 1;
      declare
         procedure F192;
         pragma Import (Ada, F192, "system__regexp__finalize_spec");
      begin
         F192;
      end;
      E195 := E195 - 1;
      declare
         procedure F193;
         pragma Import (Ada, F193, "system__pool_global__finalize_spec");
      begin
         F193;
      end;
      E173 := E173 - 1;
      declare
         procedure F194;
         pragma Import (Ada, F194, "ada__text_io__finalize_spec");
      begin
         F194;
      end;
      E146 := E146 - 1;
      declare
         procedure F195;
         pragma Import (Ada, F195, "ada__strings__unbounded__finalize_spec");
      begin
         F195;
      end;
      E209 := E209 - 1;
      declare
         procedure F196;
         pragma Import (Ada, F196, "system__storage_pools__subpools__finalize_spec");
      begin
         F196;
      end;
      E167 := E167 - 1;
      declare
         procedure F197;
         pragma Import (Ada, F197, "system__finalization_masters__finalize_spec");
      begin
         F197;
      end;
      declare
         procedure F198;
         pragma Import (Ada, F198, "system__file_io__finalize_body");
      begin
         E162 := E162 - 1;
         F198;
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
      E419 := E419 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E116 := E116 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E124 := E124 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E114 := E114 + 1;
      Gnat'Elab_Spec;
      E214 := E214 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E193 := E193 + 1;
      Ada.Streams'Elab_Spec;
      E112 := E112 + 1;
      System.File_Control_Block'Elab_Spec;
      E165 := E165 + 1;
      System.Finalization_Root'Elab_Spec;
      E134 := E134 + 1;
      Ada.Finalization'Elab_Spec;
      E110 := E110 + 1;
      System.File_Io'Elab_Body;
      E162 := E162 + 1;
      System.Storage_Pools'Elab_Spec;
      E169 := E169 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E167 := E167 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E209 := E209 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E146 := E146 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E105 := E105 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E173 := E173 + 1;
      System.Pool_Global'Elab_Spec;
      E195 := E195 + 1;
      System.Regexp'Elab_Spec;
      E171 := E171 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E103 := E103 + 1;
      Glib'Elab_Spec;
      Gtkada.Types'Elab_Spec;
      E191 := E191 + 1;
      E188 := E188 + 1;
      E501 := E501 + 1;
      E175 := E175 + 1;
      E624 := E624 + 1;
      File_Execution'Elab_Spec;
      E766 := E766 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      Gdk.Frame_Timings'Elab_Body;
      E265 := E265 + 1;
      E223 := E223 + 1;
      Gdk.Visual'Elab_Body;
      E271 := E271 + 1;
      Glib.Graphs'Elab_Spec;
      Glib.Graphs'Elab_Body;
      E453 := E453 + 1;
      E225 := E225 + 1;
      E457 := E457 + 1;
      E219 := E219 + 1;
      Glib.Object'Elab_Spec;
      E207 := E207 + 1;
      Glib.Values'Elab_Body;
      E203 := E203 + 1;
      E213 := E213 + 1;
      Glib.Object'Elab_Body;
      E205 := E205 + 1;
      E221 := E221 + 1;
      E201 := E201 + 1;
      E443 := E443 + 1;
      E227 := E227 + 1;
      E446 := E446 + 1;
      E199 := E199 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E238 := E238 + 1;
      Gdk.Color'Elab_Spec;
      E261 := E261 + 1;
      E249 := E249 + 1;
      E378 := E378 + 1;
      E246 := E246 + 1;
      Gdk.Device_Tool'Elab_Spec;
      Gdk.Device_Tool'Elab_Body;
      E244 := E244 + 1;
      Gdk.Drawing_Context'Elab_Spec;
      Gdk.Drawing_Context'Elab_Body;
      E332 := E332 + 1;
      E242 := E242 + 1;
      E459 := E459 + 1;
      E455 := E455 + 1;
      E277 := E277 + 1;
      Glib.Variant'Elab_Spec;
      Glib.Variant'Elab_Body;
      E275 := E275 + 1;
      E340 := E340 + 1;
      Gtk.Actionable'Elab_Spec;
      E435 := E435 + 1;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E281 := E281 + 1;
      E320 := E320 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E352 := E352 + 1;
      Gtk.Css_Section'Elab_Spec;
      Gtk.Css_Section'Elab_Body;
      E368 := E368 + 1;
      E255 := E255 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E656 := E656 + 1;
      Gtk.Orientable'Elab_Spec;
      E326 := E326 + 1;
      Gtk.Paper_Size'Elab_Spec;
      Gtk.Paper_Size'Elab_Body;
      E380 := E380 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E376 := E376 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E386 := E386 + 1;
      E289 := E289 + 1;
      Gtk.Target_List'Elab_Spec;
      Gtk.Target_List'Elab_Body;
      E287 := E287 + 1;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E406 := E406 + 1;
      Gtkada.Pixmaps'Elab_Spec;
      E641 := E641 + 1;
      List_Exceptions'Elab_Spec;
      E468 := E468 + 1;
      E516 := E516 + 1;
      E485 := E485 + 1;
      Mast_Analysis_Pixmaps'Elab_Spec;
      E775 := E775 + 1;
      E576 := E576 + 1;
      E810 := E810 + 1;
      mast_lex_io'elab_spec;
      E812 := E812 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E660 := E660 + 1;
      E294 := E294 + 1;
      Pango.Attributes'Elab_Spec;
      Pango.Attributes'Elab_Body;
      E314 := E314 + 1;
      Pango.Font_Metrics'Elab_Spec;
      Pango.Font_Metrics'Elab_Body;
      E298 := E298 + 1;
      Pango.Language'Elab_Spec;
      Pango.Language'Elab_Body;
      E300 := E300 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E296 := E296 + 1;
      E392 := E392 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E394 := E394 + 1;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E304 := E304 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E302 := E302 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E306 := E306 + 1;
      E308 := E308 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E292 := E292 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E310 := E310 + 1;
      Pango.Tabs'Elab_Spec;
      Pango.Tabs'Elab_Body;
      E316 := E316 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E312 := E312 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E382 := E382 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Monitor'Elab_Spec;
      Gdk.Display'Elab_Spec;
      Gdk.Glcontext'Elab_Spec;
      Gdk.Glcontext'Elab_Body;
      E334 := E334 + 1;
      Gdk.Pixbuf'Elab_Spec;
      E267 := E267 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E229 := E229 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Window'Elab_Spec;
      E330 := E330 + 1;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Icon_Source'Elab_Spec;
      Gtk.Icon_Source'Elab_Body;
      E364 := E364 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E283 := E283 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Style'Elab_Spec;
      Gtk.Scrollable'Elab_Spec;
      E398 := E398 + 1;
      E390 := E390 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Gtk.Tree_Model'Elab_Spec;
      Gtk.Widget'Elab_Spec;
      Gtk.Cell_Renderer'Elab_Spec;
      E354 := E354 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E336 := E336 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E318 := E318 + 1;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E370 := E370 + 1;
      Gtk.Notebook'Elab_Spec;
      Gtk.Status_Bar'Elab_Spec;
      E257 := E257 + 1;
      Gtk.Settings'Elab_Spec;
      Gtk.Settings'Elab_Body;
      E253 := E253 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      Gtk.Icon_Set'Elab_Body;
      E362 := E362 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E360 := E360 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E404 := E404 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Window'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Gtk.Print_Operation'Elab_Spec;
      E234 := E234 + 1;
      Gdk.Device'Elab_Body;
      E240 := E240 + 1;
      Gdk.Display'Elab_Body;
      E231 := E231 + 1;
      Gdk.Drag_Contexts'Elab_Body;
      E236 := E236 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E263 := E263 + 1;
      Gdk.Monitor'Elab_Body;
      E410 := E410 + 1;
      E273 := E273 + 1;
      Gtk.Accel_Group'Elab_Body;
      E279 := E279 + 1;
      Gtk.Adjustment'Elab_Body;
      E324 := E324 + 1;
      Gtk.Cell_Area'Elab_Body;
      E350 := E350 + 1;
      E342 := E342 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E356 := E356 + 1;
      Gtk.Clipboard'Elab_Body;
      E402 := E402 + 1;
      Gtk.Container'Elab_Body;
      E322 := E322 + 1;
      Gtk.Dialog'Elab_Body;
      E251 := E251 + 1;
      E344 := E344 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E346 := E346 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E348 := E348 + 1;
      Gtk.Gentry'Elab_Body;
      E338 := E338 + 1;
      Gtk.Notebook'Elab_Body;
      E372 := E372 + 1;
      Gtk.Print_Operation'Elab_Body;
      E374 := E374 + 1;
      E384 := E384 + 1;
      Gtk.Status_Bar'Elab_Body;
      E388 := E388 + 1;
      Gtk.Style'Elab_Body;
      E285 := E285 + 1;
      Gtk.Style_Context'Elab_Body;
      E366 := E366 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E400 := E400 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E408 := E408 + 1;
      Gtk.Text_View'Elab_Body;
      E396 := E396 + 1;
      Gtk.Tree_Model'Elab_Body;
      E358 := E358 + 1;
      Gtk.Widget'Elab_Body;
      E259 := E259 + 1;
      Gtk.Window'Elab_Body;
      E328 := E328 + 1;
      E448 := E448 + 1;
      Gdk.Cursor'Elab_Spec;
      E450 := E450 + 1;
      Glib.Menu_Model'Elab_Spec;
      Glib.Menu_Model'Elab_Body;
      E429 := E429 + 1;
      Gtk.Action'Elab_Spec;
      Gtk.Action'Elab_Body;
      E433 := E433 + 1;
      Gtk.Activatable'Elab_Spec;
      E437 := E437 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E636 := E636 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Button'Elab_Body;
      E608 := E608 + 1;
      Gtk.Cell_Renderer_Text'Elab_Spec;
      Gtk.Cell_Renderer_Text'Elab_Body;
      E695 := E695 + 1;
      Gtk.File_Chooser'Elab_Spec;
      E654 := E654 + 1;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E664 := E664 + 1;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E413 := E413 + 1;
      Gtk.Grange'Elab_Spec;
      Gtk.Grange'Elab_Body;
      E622 := E622 + 1;
      Gtk.Layout'Elab_Spec;
      Gtk.Layout'Elab_Body;
      E467 := E467 + 1;
      E461 := E461 + 1;
      E421 := E421 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Menu_Item'Elab_Body;
      E431 := E431 + 1;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu_Shell'Elab_Body;
      E439 := E439 + 1;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu'Elab_Body;
      E427 := E427 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Label'Elab_Body;
      E425 := E425 + 1;
      Gtk.Menu_Bar'Elab_Spec;
      Gtk.Menu_Bar'Elab_Body;
      E789 := E789 + 1;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E620 := E620 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Scrolled_Window'Elab_Body;
      E618 := E618 + 1;
      Gtk.Separator'Elab_Spec;
      Gtk.Separator'Elab_Body;
      E638 := E638 + 1;
      Gtk.Separator_Menu_Item'Elab_Spec;
      Gtk.Separator_Menu_Item'Elab_Body;
      E791 := E791 + 1;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E610 := E610 + 1;
      Gtk.Toggle_Button'Elab_Spec;
      Gtk.Toggle_Button'Elab_Body;
      E801 := E801 + 1;
      Gtk.Check_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Body;
      E799 := E799 + 1;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E604 := E604 + 1;
      E592 := E592 + 1;
      E594 := E594 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_Selection'Elab_Body;
      E606 := E606 + 1;
      E596 := E596 + 1;
      Gtk.Tree_Store'Elab_Spec;
      Gtk.Tree_Store'Elab_Body;
      E590 := E590 + 1;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Body;
      E423 := E423 + 1;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Tree_View'Elab_Body;
      E602 := E602 + 1;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box'Elab_Body;
      E600 := E600 + 1;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E598 := E598 + 1;
      Gtkada.Handlers'Elab_Spec;
      E462 := E462 + 1;
      E464 := E464 + 1;
      Gtkada.Canvas'Elab_Spec;
      Gtkada.Canvas'Elab_Body;
      E441 := E441 + 1;
      Var_Strings'Elab_Spec;
      E481 := E481 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E470 := E470 + 1;
      Mast_Editor'Elab_Spec;
      E565 := E565 + 1;
      E506 := E506 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E504 := E504 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E502 := E502 + 1;
      Mast.Io'Elab_Body;
      E487 := E487 + 1;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Body;
      E540 := E540 + 1;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Body;
      E550 := E550 + 1;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Body;
      E542 := E542 + 1;
      Mast.Events'Elab_Spec;
      Mast.Graphs'Elab_Spec;
      Mast.Graphs'Elab_Body;
      E520 := E520 + 1;
      Mast.Results'Elab_Spec;
      Mast.Processing_Resources'Elab_Spec;
      Mast.Processing_Resources'Elab_Body;
      E528 := E528 + 1;
      Mast.Schedulers'Elab_Spec;
      Mast.Schedulers'Elab_Body;
      E548 := E548 + 1;
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
      E532 := E532 + 1;
      Mast.Transactions'Elab_Spec;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E562 := E562 + 1;
      Mast.Xmi'Elab_Body;
      E514 := E514 + 1;
      Mast.Drivers'Elab_Body;
      E483 := E483 + 1;
      Mast.Events'Elab_Body;
      E522 := E522 + 1;
      Mast.Graphs.Event_Handlers'Elab_Body;
      E526 := E526 + 1;
      Mast.Operations'Elab_Body;
      E512 := E512 + 1;
      Mast.Processing_Resources.Network'Elab_Body;
      E558 := E558 + 1;
      Mast.Processing_Resources.Processor'Elab_Body;
      E546 := E546 + 1;
      Mast.Results'Elab_Body;
      E530 := E530 + 1;
      Mast.Schedulers.Primary'Elab_Body;
      E552 := E552 + 1;
      Mast.Schedulers.Secondary'Elab_Body;
      E560 := E560 + 1;
      Mast.Scheduling_Servers'Elab_Body;
      E556 := E556 + 1;
      Mast.Shared_Resources'Elab_Body;
      E564 := E564 + 1;
      Mast.Systems'Elab_Body;
      E518 := E518 + 1;
      Mast.Timers'Elab_Body;
      E554 := E554 + 1;
      Mast.Timing_Requirements'Elab_Body;
      E536 := E536 + 1;
      Mast.Transactions'Elab_Body;
      E524 := E524 + 1;
      Mast.Transaction_Operations'Elab_Spec;
      E672 := E672 + 1;
      E808 := E808 + 1;
      E588 := E588 + 1;
      Add_Link_Dialog_Pkg'Elab_Spec;
      E726 := E726 + 1;
      Add_New_Op_To_Driver_Dialog_Pkg'Elab_Spec;
      E797 := E797 + 1;
      Add_New_Server_To_Driver_Dialog_Pkg'Elab_Spec;
      E805 := E805 + 1;
      Add_Operation_Dialog_Pkg'Elab_Spec;
      E586 := E586 + 1;
      Add_Shared_Dialog_Pkg'Elab_Spec;
      E614 := E614 + 1;
      Aux_Window_Pkg'Elab_Spec;
      Cop_Dialog_Pkg'Elab_Spec;
      E574 := E574 + 1;
      Driver_Dialog_Pkg'Elab_Spec;
      Editor_Error_Window_Pkg'Elab_Spec;
      E634 := E634 + 1;
      External_Dialog_Pkg'Elab_Spec;
      E730 := E730 + 1;
      Import_File_Selection_Pkg'Elab_Spec;
      Item_Menu_Pkg'Elab_Spec;
      Mast_Editor.Drivers'Elab_Spec;
      Mast_Editor.Operations'Elab_Spec;
      Mast_Editor.Processing_Resources'Elab_Spec;
      Mast_Editor.Schedulers'Elab_Spec;
      Mast_Editor.Scheduling_Servers'Elab_Spec;
      Mast_Editor.Shared_Resources'Elab_Spec;
      Mast_Editor.Timers'Elab_Spec;
      Mast_Editor_Window_Pkg'Elab_Spec;
      Message_Tx_Dialog_Pkg'Elab_Spec;
      E716 := E716 + 1;
      Mieh_Dialog_Pkg'Elab_Spec;
      E750 := E750 + 1;
      Moeh_Dialog_Pkg'Elab_Spec;
      E754 := E754 + 1;
      Network_Dialog_Pkg'Elab_Spec;
      Open_File_Selection_Pkg'Elab_Spec;
      Prime_Sched_Dialog_Pkg'Elab_Spec;
      E689 := E689 + 1;
      E693 := E693 + 1;
      Processor_Dialog_Pkg'Elab_Spec;
      E699 := E699 + 1;
      Save_Changes_Dialog_Pkg'Elab_Spec;
      E646 := E646 + 1;
      Save_File_Selection_Pkg'Elab_Spec;
      Sched_Server_Dialog_Pkg'Elab_Spec;
      E708 := E708 + 1;
      Second_Sched_Dialog_Pkg'Elab_Spec;
      E704 := E704 + 1;
      Seh_Dialog_Pkg'Elab_Spec;
      E758 := E758 + 1;
      Select_Ref_Event_Dialog_Pkg'Elab_Spec;
      E738 := E738 + 1;
      Select_Req_Type_Dialog_Pkg'Elab_Spec;
      E742 := E742 + 1;
      Shared_Resource_Dialog_Pkg'Elab_Spec;
      E712 := E712 + 1;
      Sop_Dialog_Pkg'Elab_Spec;
      E720 := E720 + 1;
      Timer_Dialog_Pkg'Elab_Spec;
      E685 := E685 + 1;
      Trans_Dialog_Pkg'Elab_Spec;
      Mast_Editor.Transactions'Elab_Spec;
      Mast_Editor.Event_Handlers'Elab_Spec;
      Mast_Editor.Links'Elab_Spec;
      Internal_Dialog_Pkg'Elab_Spec;
      Mast_Editor.Systems'Elab_Spec;
      Mast_Editor.Systems'Elab_Body;
      E816 := E816 + 1;
      Editor_Actions'Elab_Spec;
      Editor_Actions'Elab_Body;
      E177 := E177 + 1;
      Driver_Dialog_Pkg.Callbacks'Elab_Body;
      E793 := E793 + 1;
      E770 := E770 + 1;
      Mast_Editor.Drivers'Elab_Body;
      E567 := E567 + 1;
      Mast_Editor.Event_Handlers'Elab_Body;
      E746 := E746 + 1;
      Mast_Editor.Timers'Elab_Body;
      E681 := E681 + 1;
      E658 := E658 + 1;
      E650 := E650 + 1;
      E668 := E668 + 1;
      E762 := E762 + 1;
      Wizard_Activity_Dialog_Pkg'Elab_Spec;
      Wizard_Completed_Dialog_Pkg'Elab_Spec;
      Wizard_Input_Dialog_Pkg'Elab_Spec;
      Callbacks_Mast_Editor'Elab_Spec;
      E570 := E570 + 1;
      E724 := E724 + 1;
      E795 := E795 + 1;
      E803 := E803 + 1;
      E584 := E584 + 1;
      E612 := E612 + 1;
      E616 := E616 + 1;
      E572 := E572 + 1;
      E569 := E569 + 1;
      E632 := E632 + 1;
      E728 := E728 + 1;
      E768 := E768 + 1;
      Internal_Dialog_Pkg'Elab_Body;
      E732 := E732 + 1;
      Internal_Dialog_Pkg.Callbacks'Elab_Body;
      E734 := E734 + 1;
      E644 := E644 + 1;
      Mast_Editor.Links'Elab_Body;
      E744 := E744 + 1;
      Mast_Editor.Operations'Elab_Body;
      E582 := E582 + 1;
      Mast_Editor.Processing_Resources'Elab_Body;
      E678 := E678 + 1;
      Mast_Editor.Schedulers'Elab_Body;
      E676 := E676 + 1;
      Mast_Editor.Scheduling_Servers'Elab_Body;
      E674 := E674 + 1;
      Mast_Editor.Shared_Resources'Elab_Body;
      E670 := E670 + 1;
      Mast_Editor.Transactions'Elab_Body;
      E722 := E722 + 1;
      Mast_Editor_Window_Pkg'Elab_Body;
      E580 := E580 + 1;
      E714 := E714 + 1;
      E748 := E748 + 1;
      E752 := E752 + 1;
      E687 := E687 + 1;
      E652 := E652 + 1;
      E691 := E691 + 1;
      E697 := E697 + 1;
      E648 := E648 + 1;
      E666 := E666 + 1;
      E706 := E706 + 1;
      E702 := E702 + 1;
      E756 := E756 + 1;
      Select_Ref_Event_Dialog_Pkg'Elab_Body;
      E736 := E736 + 1;
      E740 := E740 + 1;
      E710 := E710 + 1;
      E718 := E718 + 1;
      E683 := E683 + 1;
      Trans_Dialog_Pkg'Elab_Body;
      E760 := E760 + 1;
      E774 := E774 + 1;
      E777 := E777 + 1;
      E781 := E781 + 1;
      E779 := E779 + 1;
      Wizard_Output_Dialog_Pkg'Elab_Spec;
      E783 := E783 + 1;
      Wizard_Transaction_Dialog_Pkg'Elab_Spec;
      E785 := E785 + 1;
      Wizard_Welcome_Dialog_Pkg'Elab_Spec;
      E787 := E787 + 1;
      Simple_Transaction_Wizard_Control'Elab_Body;
      E772 := E772 + 1;
      E764 := E764 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_gmasteditor");

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
   --   /home/michael/prog/mast/gmasteditor/src/binary_trees.o
   --   /home/michael/prog/mast/gmasteditor/src/change_control.o
   --   /home/michael/prog/mast/gmasteditor/src/cut_strings.o
   --   /home/michael/prog/mast/gmasteditor/src/file_execution.o
   --   /home/michael/prog/mast/gmasteditor/src/list_exceptions.o
   --   /home/michael/prog/mast/gmasteditor/src/hash_lists.o
   --   /home/michael/prog/mast/gmasteditor/src/indexed_lists.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_analysis_pixmaps.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor_intl.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_lex_dfa.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_lex_io.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_parser_error_report.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_parser_goto.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_parser_shift_reduce.o
   --   /home/michael/prog/mast/gmasteditor/src/var_strings.o
   --   /home/michael/prog/mast/gmasteditor/src/mast.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor.o
   --   /home/michael/prog/mast/gmasteditor/src/named_lists.o
   --   /home/michael/prog/mast/gmasteditor/src/symbol_table.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_parser_tokens.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-io.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-scheduling_parameters.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-scheduling_policies.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-synchronization_parameters.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-graphs.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-processing_resources.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-schedulers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-graphs-links.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-schedulers-adjustment.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-xmi.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-drivers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-events.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-graphs-event_handlers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-operations.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-processing_resources-network.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-processing_resources-processor.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-results.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-schedulers-primary.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-schedulers-secondary.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-scheduling_servers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-shared_resources.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-systems.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-timers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-timing_requirements.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-transactions.o
   --   /home/michael/prog/mast/gmasteditor/src/mast-transaction_operations.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_lex.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_parser.o
   --   /home/michael/prog/mast/gmasteditor/src/utilities.o
   --   /home/michael/prog/mast/gmasteditor/src/add_link_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/add_new_op_to_driver_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/add_new_server_to_driver_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/add_operation_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/add_shared_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/cop_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/editor_error_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/external_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/message_tx_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/mieh_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/moeh_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/network_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/prime_sched_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/processor_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/item_menu_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/sched_server_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/second_sched_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/seh_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/select_ref_event_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/select_req_type_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/shared_resource_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/sop_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/timer_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-systems.o
   --   /home/michael/prog/mast/gmasteditor/src/editor_actions.o
   --   /home/michael/prog/mast/gmasteditor/src/driver_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/import_file_selection_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-drivers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-event_handlers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-timers.o
   --   /home/michael/prog/mast/gmasteditor/src/open_file_selection_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/save_changes_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/save_file_selection_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/trans_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/callbacks_mast_editor.o
   --   /home/michael/prog/mast/gmasteditor/src/add_link_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/add_new_op_to_driver_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/add_new_server_to_driver_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/add_operation_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/add_shared_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/aux_window_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/cop_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/driver_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/editor_error_window_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/external_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/import_file_selection_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/internal_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/internal_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/item_menu_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-links.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-operations.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-processing_resources.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-schedulers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-scheduling_servers.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-shared_resources.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor-transactions.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor_window_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/message_tx_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/mieh_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/moeh_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/network_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/open_file_selection_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/prime_sched_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/processor_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/save_changes_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/save_file_selection_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/sched_server_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/second_sched_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/seh_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/select_ref_event_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/select_req_type_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/shared_resource_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/sop_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/timer_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/trans_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_activity_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_completed_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_input_dialog_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_input_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_output_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_transaction_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/wizard_welcome_dialog_pkg.o
   --   /home/michael/prog/mast/gmasteditor/src/simple_transaction_wizard_control.o
   --   /home/michael/prog/mast/gmasteditor/src/mast_editor_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmasteditor/src/gmasteditor.o
   --   -L/home/michael/prog/mast/gmasteditor/src/
   --   -L/home/michael/prog/mast/gmasteditor/src/
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
