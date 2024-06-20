pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~gmasteditor.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~gmasteditor.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E136 : Short_Integer; pragma Import (Ada, E136, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "system__fat_flt_E");
   E396 : Short_Integer; pragma Import (Ada, E396, "system__fat_lflt_E");
   E157 : Short_Integer; pragma Import (Ada, E157, "system__fat_llf_E");
   E433 : Short_Integer; pragma Import (Ada, E433, "system__fat_sflt_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exception_table_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "ada__io_exceptions_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "ada__numerics_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "ada__strings_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "ada__strings__maps_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "ada__strings__maps__constants_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "ada__tags_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "ada__streams_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "interfaces__c_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "interfaces__c__strings_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E117 : Short_Integer; pragma Import (Ada, E117, "system__finalization_root_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "ada__finalization_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "system__storage_pools_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "system__finalization_masters_E");
   E102 : Short_Integer; pragma Import (Ada, E102, "system__storage_pools__subpools_E");
   E047 : Short_Integer; pragma Import (Ada, E047, "ada__calendar_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__calendar__time_zones_E");
   E352 : Short_Integer; pragma Import (Ada, E352, "system__assertions_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "system__pool_global_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "system__file_control_block_E");
   E451 : Short_Integer; pragma Import (Ada, E451, "ada__streams__stream_io_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "system__file_io_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "system__secondary_stack_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "ada__strings__unbounded_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "ada__directories_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "system__regexp_E");
   E449 : Short_Integer; pragma Import (Ada, E449, "system__strings__stream_ops_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "ada__text_io_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "glib_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gtkada__types_E");
   E425 : Short_Integer; pragma Import (Ada, E425, "binary_trees_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "change_control_E");
   E590 : Short_Integer; pragma Import (Ada, E590, "cut_strings_E");
   E691 : Short_Integer; pragma Import (Ada, E691, "file_execution_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "gdk__frame_timings_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "glib__glist_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "gdk__visual_E");
   E388 : Short_Integer; pragma Import (Ada, E388, "glib__graphs_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "glib__gslist_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "glib__key_file_E");
   E390 : Short_Integer; pragma Import (Ada, E390, "glib__main_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "glib__object_E");
   E364 : Short_Integer; pragma Import (Ada, E364, "glib__string_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "glib__type_conversion_hooks_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "glib__types_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "glib__g_icon_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "glib__values_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "cairo_E");
   E378 : Short_Integer; pragma Import (Ada, E378, "cairo__image_surface_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "cairo__region_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "cairo__surface_E");
   E228 : Short_Integer; pragma Import (Ada, E228, "gdk__color_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "gdk__rectangle_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "gdk__rgba_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "glib__generic_properties_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__editable_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "gtkada__c_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "gtkada__bindings_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "gdk__frame_clock_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "gdk__types_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "gdk__event_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "gdk__display_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "gdk__pixbuf_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "gdk__cairo_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "glib__properties_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "gdk__cursor_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "gdk__screen_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "gdk__device_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "gdk__drag_contexts_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "gdk__window_E");
   E362 : Short_Integer; pragma Import (Ada, E362, "glib__variant_E");
   E360 : Short_Integer; pragma Import (Ada, E360, "glib__menu_model_E");
   E242 : Short_Integer; pragma Import (Ada, E242, "gtk__accel_group_E");
   E370 : Short_Integer; pragma Import (Ada, E370, "gtk__actionable_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "gtk__adjustment_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "gtk__builder_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "gtk__buildable_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "gtk__cell_area_context_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__cell_editable_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "gtk__css_section_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__entry_buffer_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "gtk__enums_E");
   E553 : Short_Integer; pragma Import (Ada, E553, "gtk__file_filter_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "gtk__icon_source_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "gtk__orientable_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "gtk__paper_size_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "gtk__page_setup_E");
   E337 : Short_Integer; pragma Import (Ada, E337, "gtk__print_settings_E");
   E400 : Short_Integer; pragma Import (Ada, E400, "gtk__scrollable_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "gtk__selection_data_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "gtk__style_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "gtk__target_entry_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "gtk__target_list_E");
   E702 : Short_Integer; pragma Import (Ada, E702, "gtk__clipboard_E");
   E706 : Short_Integer; pragma Import (Ada, E706, "gtk__text_mark_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "gtk__tree_model_E");
   E511 : Short_Integer; pragma Import (Ada, E511, "gtk__tree_drag_dest_E");
   E513 : Short_Integer; pragma Import (Ada, E513, "gtk__tree_drag_source_E");
   E515 : Short_Integer; pragma Import (Ada, E515, "gtk__tree_sortable_E");
   E509 : Short_Integer; pragma Import (Ada, E509, "gtk__tree_store_E");
   E597 : Short_Integer; pragma Import (Ada, E597, "gtkada__pixmaps_E");
   E459 : Short_Integer; pragma Import (Ada, E459, "hash_lists_E");
   E441 : Short_Integer; pragma Import (Ada, E441, "indexed_lists_E");
   E401 : Short_Integer; pragma Import (Ada, E401, "list_exceptions_E");
   E403 : Short_Integer; pragma Import (Ada, E403, "mast_E");
   E461 : Short_Integer; pragma Import (Ada, E461, "mast__scheduling_parameters_E");
   E473 : Short_Integer; pragma Import (Ada, E473, "mast__scheduling_policies_E");
   E463 : Short_Integer; pragma Import (Ada, E463, "mast__synchronization_parameters_E");
   E485 : Short_Integer; pragma Import (Ada, E485, "mast__timers_E");
   E696 : Short_Integer; pragma Import (Ada, E696, "mast_analysis_pixmaps_E");
   E503 : Short_Integer; pragma Import (Ada, E503, "mast_editor_intl_E");
   E755 : Short_Integer; pragma Import (Ada, E755, "mast_lex_dfa_E");
   E757 : Short_Integer; pragma Import (Ada, E757, "mast_lex_io_E");
   E561 : Short_Integer; pragma Import (Ada, E561, "mast_parser_error_report_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "pango__enums_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "pango__attributes_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "pango__font_metrics_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "pango__language_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "pango__font_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "gtk__text_attributes_E");
   E345 : Short_Integer; pragma Import (Ada, E345, "gtk__text_tag_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gtk__text_iter_E");
   E708 : Short_Integer; pragma Import (Ada, E708, "gtk__text_tag_table_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "pango__font_face_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "pango__font_family_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "pango__fontset_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "pango__matrix_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "pango__context_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "pango__font_map_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "pango__tabs_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "pango__layout_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "gtk__print_context_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "gtk__print_operation_preview_E");
   E226 : Short_Integer; pragma Import (Ada, E226, "gtk__widget_E");
   E368 : Short_Integer; pragma Import (Ada, E368, "gtk__action_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "gtk__activatable_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "gtk__cell_renderer_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "gtk__cell_layout_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "gtk__cell_area_E");
   E533 : Short_Integer; pragma Import (Ada, E533, "gtk__cell_renderer_text_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "gtk__container_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "gtk__bin_E");
   E631 : Short_Integer; pragma Import (Ada, E631, "gtk__alignment_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "gtk__box_E");
   E531 : Short_Integer; pragma Import (Ada, E531, "gtk__button_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "gtk__entry_completion_E");
   E551 : Short_Integer; pragma Import (Ada, E551, "gtk__file_chooser_E");
   E348 : Short_Integer; pragma Import (Ada, E348, "gtk__frame_E");
   E539 : Short_Integer; pragma Import (Ada, E539, "gtk__grange_E");
   E398 : Short_Integer; pragma Import (Ada, E398, "gtk__layout_E");
   E392 : Short_Integer; pragma Import (Ada, E392, "gtk__main_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "gtk__marshallers_E");
   E366 : Short_Integer; pragma Import (Ada, E366, "gtk__menu_item_E");
   E374 : Short_Integer; pragma Import (Ada, E374, "gtk__menu_shell_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "gtk__menu_E");
   E722 : Short_Integer; pragma Import (Ada, E722, "gtk__menu_bar_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "gtk__misc_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "gtk__label_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "gtk__notebook_E");
   E537 : Short_Integer; pragma Import (Ada, E537, "gtk__scrollbar_E");
   E535 : Short_Integer; pragma Import (Ada, E535, "gtk__scrolled_window_E");
   E541 : Short_Integer; pragma Import (Ada, E541, "gtk__separator_E");
   E724 : Short_Integer; pragma Import (Ada, E724, "gtk__separator_menu_item_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "gtk__status_bar_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "gtk__style_provider_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "gtk__style_context_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "gtk__icon_set_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "gtk__image_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "gtk__gentry_E");
   E543 : Short_Integer; pragma Import (Ada, E543, "gtk__table_E");
   E704 : Short_Integer; pragma Import (Ada, E704, "gtk__text_child_anchor_E");
   E700 : Short_Integer; pragma Import (Ada, E700, "gtk__text_buffer_E");
   E710 : Short_Integer; pragma Import (Ada, E710, "gtk__text_view_E");
   E746 : Short_Integer; pragma Import (Ada, E746, "gtk__toggle_button_E");
   E744 : Short_Integer; pragma Import (Ada, E744, "gtk__check_button_E");
   E523 : Short_Integer; pragma Import (Ada, E523, "gtk__tooltip_E");
   E525 : Short_Integer; pragma Import (Ada, E525, "gtk__tree_selection_E");
   E527 : Short_Integer; pragma Import (Ada, E527, "gtk__tree_view_column_E");
   E521 : Short_Integer; pragma Import (Ada, E521, "gtk__tree_view_E");
   E519 : Short_Integer; pragma Import (Ada, E519, "gtk__combo_box_E");
   E517 : Short_Integer; pragma Import (Ada, E517, "gtk__combo_box_text_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "gtk__window_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "gtk__dialog_E");
   E586 : Short_Integer; pragma Import (Ada, E586, "add_link_dialog_pkg_E");
   E740 : Short_Integer; pragma Import (Ada, E740, "add_new_op_to_driver_dialog_pkg_E");
   E748 : Short_Integer; pragma Import (Ada, E748, "add_new_server_to_driver_dialog_pkg_E");
   E621 : Short_Integer; pragma Import (Ada, E621, "add_operation_dialog_pkg_E");
   E625 : Short_Integer; pragma Import (Ada, E625, "add_shared_dialog_pkg_E");
   E499 : Short_Integer; pragma Import (Ada, E499, "cop_dialog_pkg_E");
   E496 : Short_Integer; pragma Import (Ada, E496, "driver_dialog_pkg_E");
   E557 : Short_Integer; pragma Import (Ada, E557, "editor_error_window_pkg_E");
   E545 : Short_Integer; pragma Import (Ada, E545, "external_dialog_pkg_E");
   E570 : Short_Integer; pragma Import (Ada, E570, "gtk__file_chooser_dialog_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "gtk__print_operation_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "gtk__arguments_E");
   E588 : Short_Integer; pragma Import (Ada, E588, "add_link_dialog_pkg__callbacks_E");
   E742 : Short_Integer; pragma Import (Ada, E742, "add_new_op_to_driver_dialog_pkg__callbacks_E");
   E750 : Short_Integer; pragma Import (Ada, E750, "add_new_server_to_driver_dialog_pkg__callbacks_E");
   E623 : Short_Integer; pragma Import (Ada, E623, "add_operation_dialog_pkg__callbacks_E");
   E627 : Short_Integer; pragma Import (Ada, E627, "add_shared_dialog_pkg__callbacks_E");
   E501 : Short_Integer; pragma Import (Ada, E501, "cop_dialog_pkg__callbacks_E");
   E738 : Short_Integer; pragma Import (Ada, E738, "driver_dialog_pkg__callbacks_E");
   E559 : Short_Integer; pragma Import (Ada, E559, "editor_error_window_pkg__callbacks_E");
   E547 : Short_Integer; pragma Import (Ada, E547, "external_dialog_pkg__callbacks_E");
   E376 : Short_Integer; pragma Import (Ada, E376, "gtkada__canvas_E");
   E629 : Short_Integer; pragma Import (Ada, E629, "aux_window_pkg_E");
   E393 : Short_Integer; pragma Import (Ada, E393, "gtkada__handlers_E");
   E549 : Short_Integer; pragma Import (Ada, E549, "import_file_selection_pkg_E");
   E555 : Short_Integer; pragma Import (Ada, E555, "import_file_selection_pkg__callbacks_E");
   E572 : Short_Integer; pragma Import (Ada, E572, "internal_dialog_pkg_E");
   E599 : Short_Integer; pragma Import (Ada, E599, "item_menu_pkg_E");
   E601 : Short_Integer; pragma Import (Ada, E601, "item_menu_pkg__callbacks_E");
   E617 : Short_Integer; pragma Import (Ada, E617, "mast_editor_window_pkg_E");
   E689 : Short_Integer; pragma Import (Ada, E689, "mast_editor_window_pkg__callbacks_E");
   E675 : Short_Integer; pragma Import (Ada, E675, "message_tx_dialog_pkg_E");
   E677 : Short_Integer; pragma Import (Ada, E677, "message_tx_dialog_pkg__callbacks_E");
   E726 : Short_Integer; pragma Import (Ada, E726, "mieh_dialog_pkg_E");
   E728 : Short_Integer; pragma Import (Ada, E728, "mieh_dialog_pkg__callbacks_E");
   E730 : Short_Integer; pragma Import (Ada, E730, "moeh_dialog_pkg_E");
   E732 : Short_Integer; pragma Import (Ada, E732, "moeh_dialog_pkg__callbacks_E");
   E649 : Short_Integer; pragma Import (Ada, E649, "network_dialog_pkg_E");
   E651 : Short_Integer; pragma Import (Ada, E651, "network_dialog_pkg__callbacks_E");
   E607 : Short_Integer; pragma Import (Ada, E607, "open_file_selection_pkg_E");
   E609 : Short_Integer; pragma Import (Ada, E609, "open_file_selection_pkg__callbacks_E");
   E395 : Short_Integer; pragma Import (Ada, E395, "pango__cairo_E");
   E653 : Short_Integer; pragma Import (Ada, E653, "prime_sched_dialog_pkg_E");
   E655 : Short_Integer; pragma Import (Ada, E655, "prime_sched_dialog_pkg__callbacks_E");
   E657 : Short_Integer; pragma Import (Ada, E657, "processor_dialog_pkg_E");
   E659 : Short_Integer; pragma Import (Ada, E659, "processor_dialog_pkg__callbacks_E");
   E603 : Short_Integer; pragma Import (Ada, E603, "save_changes_dialog_pkg_E");
   E605 : Short_Integer; pragma Import (Ada, E605, "save_changes_dialog_pkg__callbacks_E");
   E611 : Short_Integer; pragma Import (Ada, E611, "save_file_selection_pkg_E");
   E613 : Short_Integer; pragma Import (Ada, E613, "save_file_selection_pkg__callbacks_E");
   E667 : Short_Integer; pragma Import (Ada, E667, "sched_server_dialog_pkg_E");
   E669 : Short_Integer; pragma Import (Ada, E669, "sched_server_dialog_pkg__callbacks_E");
   E663 : Short_Integer; pragma Import (Ada, E663, "second_sched_dialog_pkg_E");
   E665 : Short_Integer; pragma Import (Ada, E665, "second_sched_dialog_pkg__callbacks_E");
   E734 : Short_Integer; pragma Import (Ada, E734, "seh_dialog_pkg_E");
   E736 : Short_Integer; pragma Import (Ada, E736, "seh_dialog_pkg__callbacks_E");
   E576 : Short_Integer; pragma Import (Ada, E576, "select_ref_event_dialog_pkg_E");
   E578 : Short_Integer; pragma Import (Ada, E578, "select_ref_event_dialog_pkg__callbacks_E");
   E580 : Short_Integer; pragma Import (Ada, E580, "select_req_type_dialog_pkg_E");
   E582 : Short_Integer; pragma Import (Ada, E582, "select_req_type_dialog_pkg__callbacks_E");
   E671 : Short_Integer; pragma Import (Ada, E671, "shared_resource_dialog_pkg_E");
   E673 : Short_Integer; pragma Import (Ada, E673, "shared_resource_dialog_pkg__callbacks_E");
   E679 : Short_Integer; pragma Import (Ada, E679, "sop_dialog_pkg_E");
   E681 : Short_Integer; pragma Import (Ada, E681, "sop_dialog_pkg__callbacks_E");
   E645 : Short_Integer; pragma Import (Ada, E645, "timer_dialog_pkg_E");
   E647 : Short_Integer; pragma Import (Ada, E647, "timer_dialog_pkg__callbacks_E");
   E685 : Short_Integer; pragma Import (Ada, E685, "trans_dialog_pkg_E");
   E687 : Short_Integer; pragma Import (Ada, E687, "trans_dialog_pkg__callbacks_E");
   E507 : Short_Integer; pragma Import (Ada, E507, "utilities_E");
   E413 : Short_Integer; pragma Import (Ada, E413, "var_strings_E");
   E417 : Short_Integer; pragma Import (Ada, E417, "mast__io_E");
   E492 : Short_Integer; pragma Import (Ada, E492, "mast_editor_E");
   E430 : Short_Integer; pragma Import (Ada, E430, "named_lists_E");
   E447 : Short_Integer; pragma Import (Ada, E447, "mast__events_E");
   E445 : Short_Integer; pragma Import (Ada, E445, "mast__graphs_E");
   E443 : Short_Integer; pragma Import (Ada, E443, "mast__results_E");
   E471 : Short_Integer; pragma Import (Ada, E471, "mast__processing_resources_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "mast__processing_resources__processor_E");
   E469 : Short_Integer; pragma Import (Ada, E469, "mast__schedulers_E");
   E467 : Short_Integer; pragma Import (Ada, E467, "mast__scheduling_servers_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "mast__schedulers__adjustment_E");
   E487 : Short_Integer; pragma Import (Ada, E487, "mast__schedulers__secondary_E");
   E465 : Short_Integer; pragma Import (Ada, E465, "mast__shared_resources_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "mast__operations_E");
   E415 : Short_Integer; pragma Import (Ada, E415, "mast__drivers_E");
   E491 : Short_Integer; pragma Import (Ada, E491, "mast__graphs__event_handlers_E");
   E479 : Short_Integer; pragma Import (Ada, E479, "mast__processing_resources__network_E");
   E457 : Short_Integer; pragma Import (Ada, E457, "mast__timing_requirements_E");
   E455 : Short_Integer; pragma Import (Ada, E455, "mast__graphs__links_E");
   E489 : Short_Integer; pragma Import (Ada, E489, "mast__transactions_E");
   E477 : Short_Integer; pragma Import (Ada, E477, "mast__systems_E");
   E475 : Short_Integer; pragma Import (Ada, E475, "mast__schedulers__primary_E");
   E635 : Short_Integer; pragma Import (Ada, E635, "mast__transaction_operations_E");
   E494 : Short_Integer; pragma Import (Ada, E494, "mast_editor__drivers_E");
   E619 : Short_Integer; pragma Import (Ada, E619, "mast_editor__operations_E");
   E641 : Short_Integer; pragma Import (Ada, E641, "mast_editor__processing_resources_E");
   E639 : Short_Integer; pragma Import (Ada, E639, "mast_editor__schedulers_E");
   E637 : Short_Integer; pragma Import (Ada, E637, "mast_editor__scheduling_servers_E");
   E633 : Short_Integer; pragma Import (Ada, E633, "mast_editor__shared_resources_E");
   E643 : Short_Integer; pragma Import (Ada, E643, "mast_editor__timers_E");
   E683 : Short_Integer; pragma Import (Ada, E683, "mast_editor__transactions_E");
   E615 : Short_Integer; pragma Import (Ada, E615, "mast_editor__event_handlers_E");
   E584 : Short_Integer; pragma Import (Ada, E584, "mast_editor__links_E");
   E574 : Short_Integer; pragma Import (Ada, E574, "internal_dialog_pkg__callbacks_E");
   E761 : Short_Integer; pragma Import (Ada, E761, "mast_editor__systems_E");
   E428 : Short_Integer; pragma Import (Ada, E428, "symbol_table_E");
   E426 : Short_Integer; pragma Import (Ada, E426, "mast_parser_tokens_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "editor_actions_E");
   E753 : Short_Integer; pragma Import (Ada, E753, "mast_lex_E");
   E695 : Short_Integer; pragma Import (Ada, E695, "wizard_activity_dialog_pkg_E");
   E698 : Short_Integer; pragma Import (Ada, E698, "wizard_completed_dialog_pkg_E");
   E712 : Short_Integer; pragma Import (Ada, E712, "wizard_input_dialog_pkg_E");
   E497 : Short_Integer; pragma Import (Ada, E497, "callbacks_mast_editor_E");
   E714 : Short_Integer; pragma Import (Ada, E714, "wizard_input_dialog_pkg__callbacks_E");
   E716 : Short_Integer; pragma Import (Ada, E716, "wizard_output_dialog_pkg_E");
   E718 : Short_Integer; pragma Import (Ada, E718, "wizard_transaction_dialog_pkg_E");
   E720 : Short_Integer; pragma Import (Ada, E720, "wizard_welcome_dialog_pkg_E");
   E693 : Short_Integer; pragma Import (Ada, E693, "simple_transaction_wizard_control_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      declare
         procedure F1;
         pragma Import (Ada, F1, "simple_transaction_wizard_control__finalize_body");
      begin
         E693 := E693 - 1;
         F1;
      end;
      E720 := E720 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "wizard_welcome_dialog_pkg__finalize_spec");
      begin
         F2;
      end;
      E718 := E718 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "wizard_transaction_dialog_pkg__finalize_spec");
      begin
         F3;
      end;
      E716 := E716 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "wizard_output_dialog_pkg__finalize_spec");
      begin
         F4;
      end;
      E712 := E712 - 1;
      E586 := E586 - 1;
      E740 := E740 - 1;
      E748 := E748 - 1;
      E621 := E621 - 1;
      E625 := E625 - 1;
      E499 := E499 - 1;
      E496 := E496 - 1;
      E557 := E557 - 1;
      E545 := E545 - 1;
      E629 := E629 - 1;
      E549 := E549 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "internal_dialog_pkg__finalize_body");
      begin
         E572 := E572 - 1;
         F5;
      end;
      E599 := E599 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "mast_editor_window_pkg__finalize_body");
      begin
         E617 := E617 - 1;
         F6;
      end;
      E675 := E675 - 1;
      E726 := E726 - 1;
      E730 := E730 - 1;
      E649 := E649 - 1;
      E607 := E607 - 1;
      E653 := E653 - 1;
      E657 := E657 - 1;
      E603 := E603 - 1;
      E611 := E611 - 1;
      E667 := E667 - 1;
      E663 := E663 - 1;
      E734 := E734 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "select_ref_event_dialog_pkg__finalize_body");
      begin
         E576 := E576 - 1;
         F7;
      end;
      E580 := E580 - 1;
      E671 := E671 - 1;
      E679 := E679 - 1;
      E645 := E645 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "trans_dialog_pkg__finalize_body");
      begin
         E685 := E685 - 1;
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "mast_editor__operations__finalize_body");
      begin
         E619 := E619 - 1;
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "mast_editor__processing_resources__finalize_body");
      begin
         E641 := E641 - 1;
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "mast_editor__schedulers__finalize_body");
      begin
         E639 := E639 - 1;
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "mast_editor__scheduling_servers__finalize_body");
      begin
         E637 := E637 - 1;
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "mast_editor__shared_resources__finalize_body");
      begin
         E633 := E633 - 1;
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "mast_editor__transactions__finalize_body");
      begin
         E683 := E683 - 1;
         F14;
      end;
      declare
         procedure F15;
         pragma Import (Ada, F15, "mast_editor__links__finalize_body");
      begin
         E584 := E584 - 1;
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "internal_dialog_pkg__callbacks__finalize_body");
      begin
         E574 := E574 - 1;
         F16;
      end;
      E695 := E695 - 1;
      E698 := E698 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "callbacks_mast_editor__finalize_spec");
      begin
         E497 := E497 - 1;
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
         pragma Import (Ada, F21, "editor_actions__finalize_body");
      begin
         E151 := E151 - 1;
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "driver_dialog_pkg__callbacks__finalize_body");
      begin
         E738 := E738 - 1;
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "mast_editor__drivers__finalize_body");
      begin
         E494 := E494 - 1;
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "mast_editor__timers__finalize_body");
      begin
         E643 := E643 - 1;
         F24;
      end;
      declare
         procedure F25;
         pragma Import (Ada, F25, "mast_editor__event_handlers__finalize_body");
      begin
         E615 := E615 - 1;
         F25;
      end;
      declare
         procedure F26;
         pragma Import (Ada, F26, "editor_actions__finalize_spec");
      begin
         F26;
      end;
      E761 := E761 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "mast_editor__systems__finalize_spec");
      begin
         F27;
      end;
      declare
         procedure F28;
         pragma Import (Ada, F28, "mast_editor__links__finalize_spec");
      begin
         F28;
      end;
      declare
         procedure F29;
         pragma Import (Ada, F29, "mast_editor__event_handlers__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "mast_editor__transactions__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "mast_editor__timers__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "mast_editor__shared_resources__finalize_spec");
      begin
         F32;
      end;
      declare
         procedure F33;
         pragma Import (Ada, F33, "mast_editor__scheduling_servers__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "mast_editor__schedulers__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "mast_editor__processing_resources__finalize_spec");
      begin
         F35;
      end;
      declare
         procedure F36;
         pragma Import (Ada, F36, "mast_editor__operations__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "mast_editor__drivers__finalize_spec");
      begin
         F37;
      end;
      E467 := E467 - 1;
      E477 := E477 - 1;
      E475 := E475 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "mast__schedulers__primary__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "mast__systems__finalize_spec");
      begin
         F39;
      end;
      E489 := E489 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "mast__transactions__finalize_spec");
      begin
         F40;
      end;
      E443 := E443 - 1;
      E455 := E455 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "mast__graphs__links__finalize_spec");
      begin
         F41;
      end;
      E457 := E457 - 1;
      declare
         procedure F42;
         pragma Import (Ada, F42, "mast__timing_requirements__finalize_spec");
      begin
         F42;
      end;
      E479 := E479 - 1;
      declare
         procedure F43;
         pragma Import (Ada, F43, "mast__processing_resources__network__finalize_spec");
      begin
         F43;
      end;
      E491 := E491 - 1;
      declare
         procedure F44;
         pragma Import (Ada, F44, "mast__graphs__event_handlers__finalize_spec");
      begin
         F44;
      end;
      E415 := E415 - 1;
      declare
         procedure F45;
         pragma Import (Ada, F45, "mast__drivers__finalize_spec");
      begin
         F45;
      end;
      E435 := E435 - 1;
      declare
         procedure F46;
         pragma Import (Ada, F46, "mast__operations__finalize_spec");
      begin
         F46;
      end;
      E465 := E465 - 1;
      declare
         procedure F47;
         pragma Import (Ada, F47, "mast__shared_resources__finalize_spec");
      begin
         F47;
      end;
      E487 := E487 - 1;
      declare
         procedure F48;
         pragma Import (Ada, F48, "mast__schedulers__secondary__finalize_spec");
      begin
         F48;
      end;
      declare
         procedure F49;
         pragma Import (Ada, F49, "mast__scheduling_servers__finalize_spec");
      begin
         F49;
      end;
      E469 := E469 - 1;
      declare
         procedure F50;
         pragma Import (Ada, F50, "mast__schedulers__finalize_spec");
      begin
         F50;
      end;
      E483 := E483 - 1;
      declare
         procedure F51;
         pragma Import (Ada, F51, "mast__processing_resources__processor__finalize_spec");
      begin
         F51;
      end;
      E471 := E471 - 1;
      declare
         procedure F52;
         pragma Import (Ada, F52, "mast__processing_resources__finalize_spec");
      begin
         F52;
      end;
      declare
         procedure F53;
         pragma Import (Ada, F53, "mast__results__finalize_spec");
      begin
         F53;
      end;
      E445 := E445 - 1;
      declare
         procedure F54;
         pragma Import (Ada, F54, "mast__graphs__finalize_spec");
      begin
         F54;
      end;
      E447 := E447 - 1;
      declare
         procedure F55;
         pragma Import (Ada, F55, "mast__events__finalize_spec");
      begin
         F55;
      end;
      declare
         procedure F56;
         pragma Import (Ada, F56, "mast_editor__finalize_spec");
      begin
         E492 := E492 - 1;
         F56;
      end;
      E461 := E461 - 1;
      E473 := E473 - 1;
      E463 := E463 - 1;
      E485 := E485 - 1;
      declare
         procedure F57;
         pragma Import (Ada, F57, "trans_dialog_pkg__finalize_spec");
      begin
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "timer_dialog_pkg__finalize_spec");
      begin
         F58;
      end;
      declare
         procedure F59;
         pragma Import (Ada, F59, "sop_dialog_pkg__finalize_spec");
      begin
         F59;
      end;
      declare
         procedure F60;
         pragma Import (Ada, F60, "shared_resource_dialog_pkg__finalize_spec");
      begin
         F60;
      end;
      declare
         procedure F61;
         pragma Import (Ada, F61, "select_req_type_dialog_pkg__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "select_ref_event_dialog_pkg__finalize_spec");
      begin
         F62;
      end;
      declare
         procedure F63;
         pragma Import (Ada, F63, "seh_dialog_pkg__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "second_sched_dialog_pkg__finalize_spec");
      begin
         F64;
      end;
      declare
         procedure F65;
         pragma Import (Ada, F65, "sched_server_dialog_pkg__finalize_spec");
      begin
         F65;
      end;
      declare
         procedure F66;
         pragma Import (Ada, F66, "save_file_selection_pkg__finalize_spec");
      begin
         F66;
      end;
      declare
         procedure F67;
         pragma Import (Ada, F67, "save_changes_dialog_pkg__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "processor_dialog_pkg__finalize_spec");
      begin
         F68;
      end;
      declare
         procedure F69;
         pragma Import (Ada, F69, "prime_sched_dialog_pkg__finalize_spec");
      begin
         F69;
      end;
      E376 := E376 - 1;
      declare
         procedure F70;
         pragma Import (Ada, F70, "open_file_selection_pkg__finalize_spec");
      begin
         F70;
      end;
      declare
         procedure F71;
         pragma Import (Ada, F71, "network_dialog_pkg__finalize_spec");
      begin
         F71;
      end;
      declare
         procedure F72;
         pragma Import (Ada, F72, "moeh_dialog_pkg__finalize_spec");
      begin
         F72;
      end;
      declare
         procedure F73;
         pragma Import (Ada, F73, "mieh_dialog_pkg__finalize_spec");
      begin
         F73;
      end;
      declare
         procedure F74;
         pragma Import (Ada, F74, "message_tx_dialog_pkg__finalize_spec");
      begin
         F74;
      end;
      declare
         procedure F75;
         pragma Import (Ada, F75, "mast_editor_window_pkg__finalize_spec");
      begin
         F75;
      end;
      declare
         procedure F76;
         pragma Import (Ada, F76, "item_menu_pkg__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "internal_dialog_pkg__finalize_spec");
      begin
         F77;
      end;
      declare
         procedure F78;
         pragma Import (Ada, F78, "import_file_selection_pkg__finalize_spec");
      begin
         F78;
      end;
      declare
         procedure F79;
         pragma Import (Ada, F79, "gtkada__handlers__finalize_spec");
      begin
         E393 := E393 - 1;
         F79;
      end;
      declare
         procedure F80;
         pragma Import (Ada, F80, "aux_window_pkg__finalize_spec");
      begin
         F80;
      end;
      declare
         procedure F81;
         pragma Import (Ada, F81, "gtkada__canvas__finalize_spec");
      begin
         F81;
      end;
      E234 := E234 - 1;
      E196 := E196 - 1;
      E360 := E360 - 1;
      E242 := E242 - 1;
      E222 := E222 - 1;
      E289 := E289 - 1;
      E246 := E246 - 1;
      E702 := E702 - 1;
      E301 := E301 - 1;
      E708 := E708 - 1;
      E226 := E226 - 1;
      E368 := E368 - 1;
      E299 := E299 - 1;
      E293 := E293 - 1;
      E533 := E533 - 1;
      E220 := E220 - 1;
      E531 := E531 - 1;
      E291 := E291 - 1;
      E539 := E539 - 1;
      E366 := E366 - 1;
      E374 := E374 - 1;
      E358 := E358 - 1;
      E356 := E356 - 1;
      E321 := E321 - 1;
      E535 := E535 - 1;
      E339 := E339 - 1;
      E309 := E309 - 1;
      E281 := E281 - 1;
      E700 := E700 - 1;
      E710 := E710 - 1;
      E746 := E746 - 1;
      E525 := E525 - 1;
      E527 := E527 - 1;
      E521 := E521 - 1;
      E519 := E519 - 1;
      E275 := E275 - 1;
      E208 := E208 - 1;
      E323 := E323 - 1;
      declare
         procedure F82;
         pragma Import (Ada, F82, "gtk__print_operation__finalize_spec");
      begin
         F82;
      end;
      E570 := E570 - 1;
      declare
         procedure F83;
         pragma Import (Ada, F83, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F83;
      end;
      declare
         procedure F84;
         pragma Import (Ada, F84, "external_dialog_pkg__finalize_spec");
      begin
         F84;
      end;
      declare
         procedure F85;
         pragma Import (Ada, F85, "editor_error_window_pkg__finalize_spec");
      begin
         F85;
      end;
      declare
         procedure F86;
         pragma Import (Ada, F86, "driver_dialog_pkg__finalize_spec");
      begin
         F86;
      end;
      declare
         procedure F87;
         pragma Import (Ada, F87, "cop_dialog_pkg__finalize_spec");
      begin
         F87;
      end;
      declare
         procedure F88;
         pragma Import (Ada, F88, "add_shared_dialog_pkg__finalize_spec");
      begin
         F88;
      end;
      declare
         procedure F89;
         pragma Import (Ada, F89, "add_operation_dialog_pkg__finalize_spec");
      begin
         F89;
      end;
      declare
         procedure F90;
         pragma Import (Ada, F90, "add_new_server_to_driver_dialog_pkg__finalize_spec");
      begin
         F90;
      end;
      declare
         procedure F91;
         pragma Import (Ada, F91, "add_new_op_to_driver_dialog_pkg__finalize_spec");
      begin
         F91;
      end;
      declare
         procedure F92;
         pragma Import (Ada, F92, "add_link_dialog_pkg__finalize_spec");
      begin
         F92;
      end;
      declare
         procedure F93;
         pragma Import (Ada, F93, "gtk__dialog__finalize_spec");
      begin
         F93;
      end;
      declare
         procedure F94;
         pragma Import (Ada, F94, "gtk__window__finalize_spec");
      begin
         F94;
      end;
      E517 := E517 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "gtk__combo_box_text__finalize_spec");
      begin
         F95;
      end;
      declare
         procedure F96;
         pragma Import (Ada, F96, "gtk__combo_box__finalize_spec");
      begin
         F96;
      end;
      declare
         procedure F97;
         pragma Import (Ada, F97, "gtk__tree_view__finalize_spec");
      begin
         F97;
      end;
      declare
         procedure F98;
         pragma Import (Ada, F98, "gtk__tree_view_column__finalize_spec");
      begin
         F98;
      end;
      declare
         procedure F99;
         pragma Import (Ada, F99, "gtk__tree_selection__finalize_spec");
      begin
         F99;
      end;
      E523 := E523 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "gtk__tooltip__finalize_spec");
      begin
         F100;
      end;
      E744 := E744 - 1;
      declare
         procedure F101;
         pragma Import (Ada, F101, "gtk__check_button__finalize_spec");
      begin
         F101;
      end;
      declare
         procedure F102;
         pragma Import (Ada, F102, "gtk__toggle_button__finalize_spec");
      begin
         F102;
      end;
      declare
         procedure F103;
         pragma Import (Ada, F103, "gtk__text_view__finalize_spec");
      begin
         F103;
      end;
      declare
         procedure F104;
         pragma Import (Ada, F104, "gtk__text_buffer__finalize_spec");
      begin
         F104;
      end;
      E704 := E704 - 1;
      declare
         procedure F105;
         pragma Import (Ada, F105, "gtk__text_child_anchor__finalize_spec");
      begin
         F105;
      end;
      E543 := E543 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "gtk__table__finalize_spec");
      begin
         F106;
      end;
      declare
         procedure F107;
         pragma Import (Ada, F107, "gtk__gentry__finalize_spec");
      begin
         F107;
      end;
      E303 := E303 - 1;
      declare
         procedure F108;
         pragma Import (Ada, F108, "gtk__image__finalize_spec");
      begin
         F108;
      end;
      E305 := E305 - 1;
      declare
         procedure F109;
         pragma Import (Ada, F109, "gtk__icon_set__finalize_spec");
      begin
         F109;
      end;
      declare
         procedure F110;
         pragma Import (Ada, F110, "gtk__style_context__finalize_spec");
      begin
         F110;
      end;
      declare
         procedure F111;
         pragma Import (Ada, F111, "gtk__status_bar__finalize_spec");
      begin
         F111;
      end;
      E724 := E724 - 1;
      declare
         procedure F112;
         pragma Import (Ada, F112, "gtk__separator_menu_item__finalize_spec");
      begin
         F112;
      end;
      E541 := E541 - 1;
      declare
         procedure F113;
         pragma Import (Ada, F113, "gtk__separator__finalize_spec");
      begin
         F113;
      end;
      declare
         procedure F114;
         pragma Import (Ada, F114, "gtk__scrolled_window__finalize_spec");
      begin
         F114;
      end;
      E537 := E537 - 1;
      declare
         procedure F115;
         pragma Import (Ada, F115, "gtk__scrollbar__finalize_spec");
      begin
         F115;
      end;
      declare
         procedure F116;
         pragma Import (Ada, F116, "gtk__notebook__finalize_spec");
      begin
         F116;
      end;
      declare
         procedure F117;
         pragma Import (Ada, F117, "gtk__label__finalize_spec");
      begin
         F117;
      end;
      E315 := E315 - 1;
      declare
         procedure F118;
         pragma Import (Ada, F118, "gtk__misc__finalize_spec");
      begin
         F118;
      end;
      E722 := E722 - 1;
      declare
         procedure F119;
         pragma Import (Ada, F119, "gtk__menu_bar__finalize_spec");
      begin
         F119;
      end;
      declare
         procedure F120;
         pragma Import (Ada, F120, "gtk__menu__finalize_spec");
      begin
         F120;
      end;
      declare
         procedure F121;
         pragma Import (Ada, F121, "gtk__menu_shell__finalize_spec");
      begin
         F121;
      end;
      declare
         procedure F122;
         pragma Import (Ada, F122, "gtk__menu_item__finalize_spec");
      begin
         F122;
      end;
      E398 := E398 - 1;
      declare
         procedure F123;
         pragma Import (Ada, F123, "gtk__layout__finalize_spec");
      begin
         F123;
      end;
      declare
         procedure F124;
         pragma Import (Ada, F124, "gtk__grange__finalize_spec");
      begin
         F124;
      end;
      E348 := E348 - 1;
      declare
         procedure F125;
         pragma Import (Ada, F125, "gtk__frame__finalize_spec");
      begin
         F125;
      end;
      declare
         procedure F126;
         pragma Import (Ada, F126, "gtk__entry_completion__finalize_spec");
      begin
         F126;
      end;
      declare
         procedure F127;
         pragma Import (Ada, F127, "gtk__button__finalize_spec");
      begin
         F127;
      end;
      E210 := E210 - 1;
      declare
         procedure F128;
         pragma Import (Ada, F128, "gtk__box__finalize_spec");
      begin
         F128;
      end;
      E631 := E631 - 1;
      declare
         procedure F129;
         pragma Import (Ada, F129, "gtk__alignment__finalize_spec");
      begin
         F129;
      end;
      E279 := E279 - 1;
      declare
         procedure F130;
         pragma Import (Ada, F130, "gtk__bin__finalize_spec");
      begin
         F130;
      end;
      declare
         procedure F131;
         pragma Import (Ada, F131, "gtk__container__finalize_spec");
      begin
         F131;
      end;
      declare
         procedure F132;
         pragma Import (Ada, F132, "gtk__cell_renderer_text__finalize_spec");
      begin
         F132;
      end;
      declare
         procedure F133;
         pragma Import (Ada, F133, "gtk__cell_area__finalize_spec");
      begin
         F133;
      end;
      declare
         procedure F134;
         pragma Import (Ada, F134, "gtk__cell_renderer__finalize_spec");
      begin
         F134;
      end;
      declare
         procedure F135;
         pragma Import (Ada, F135, "gtk__action__finalize_spec");
      begin
         F135;
      end;
      declare
         procedure F136;
         pragma Import (Ada, F136, "gtk__widget__finalize_spec");
      begin
         F136;
      end;
      E331 := E331 - 1;
      declare
         procedure F137;
         pragma Import (Ada, F137, "gtk__print_context__finalize_spec");
      begin
         F137;
      end;
      E267 := E267 - 1;
      declare
         procedure F138;
         pragma Import (Ada, F138, "pango__layout__finalize_spec");
      begin
         F138;
      end;
      E271 := E271 - 1;
      declare
         procedure F139;
         pragma Import (Ada, F139, "pango__tabs__finalize_spec");
      begin
         F139;
      end;
      E333 := E333 - 1;
      declare
         procedure F140;
         pragma Import (Ada, F140, "pango__font_map__finalize_spec");
      begin
         F140;
      end;
      E249 := E249 - 1;
      declare
         procedure F141;
         pragma Import (Ada, F141, "pango__context__finalize_spec");
      begin
         F141;
      end;
      E263 := E263 - 1;
      declare
         procedure F142;
         pragma Import (Ada, F142, "pango__fontset__finalize_spec");
      begin
         F142;
      end;
      E259 := E259 - 1;
      declare
         procedure F143;
         pragma Import (Ada, F143, "pango__font_family__finalize_spec");
      begin
         F143;
      end;
      E261 := E261 - 1;
      declare
         procedure F144;
         pragma Import (Ada, F144, "pango__font_face__finalize_spec");
      begin
         F144;
      end;
      declare
         procedure F145;
         pragma Import (Ada, F145, "gtk__text_tag_table__finalize_spec");
      begin
         F145;
      end;
      E345 := E345 - 1;
      declare
         procedure F146;
         pragma Import (Ada, F146, "gtk__text_tag__finalize_spec");
      begin
         F146;
      end;
      E253 := E253 - 1;
      declare
         procedure F147;
         pragma Import (Ada, F147, "pango__font__finalize_spec");
      begin
         F147;
      end;
      E257 := E257 - 1;
      declare
         procedure F148;
         pragma Import (Ada, F148, "pango__language__finalize_spec");
      begin
         F148;
      end;
      E255 := E255 - 1;
      declare
         procedure F149;
         pragma Import (Ada, F149, "pango__font_metrics__finalize_spec");
      begin
         F149;
      end;
      E269 := E269 - 1;
      declare
         procedure F150;
         pragma Import (Ada, F150, "pango__attributes__finalize_spec");
      begin
         F150;
      end;
      declare
         procedure F151;
         pragma Import (Ada, F151, "mast__timers__finalize_spec");
      begin
         F151;
      end;
      declare
         procedure F152;
         pragma Import (Ada, F152, "mast__synchronization_parameters__finalize_spec");
      begin
         F152;
      end;
      declare
         procedure F153;
         pragma Import (Ada, F153, "mast__scheduling_policies__finalize_spec");
      begin
         F153;
      end;
      declare
         procedure F154;
         pragma Import (Ada, F154, "mast__scheduling_parameters__finalize_spec");
      begin
         F154;
      end;
      E509 := E509 - 1;
      declare
         procedure F155;
         pragma Import (Ada, F155, "gtk__tree_store__finalize_spec");
      begin
         F155;
      end;
      declare
         procedure F156;
         pragma Import (Ada, F156, "gtk__tree_model__finalize_spec");
      begin
         F156;
      end;
      E706 := E706 - 1;
      declare
         procedure F157;
         pragma Import (Ada, F157, "gtk__text_mark__finalize_spec");
      begin
         F157;
      end;
      declare
         procedure F158;
         pragma Import (Ada, F158, "gtk__clipboard__finalize_spec");
      begin
         F158;
      end;
      E317 := E317 - 1;
      declare
         procedure F159;
         pragma Import (Ada, F159, "gtk__target_list__finalize_spec");
      begin
         F159;
      end;
      declare
         procedure F160;
         pragma Import (Ada, F160, "gtk__style__finalize_spec");
      begin
         F160;
      end;
      E244 := E244 - 1;
      declare
         procedure F161;
         pragma Import (Ada, F161, "gtk__selection_data__finalize_spec");
      begin
         F161;
      end;
      E337 := E337 - 1;
      declare
         procedure F162;
         pragma Import (Ada, F162, "gtk__print_settings__finalize_spec");
      begin
         F162;
      end;
      E325 := E325 - 1;
      declare
         procedure F163;
         pragma Import (Ada, F163, "gtk__page_setup__finalize_spec");
      begin
         F163;
      end;
      E329 := E329 - 1;
      declare
         procedure F164;
         pragma Import (Ada, F164, "gtk__paper_size__finalize_spec");
      begin
         F164;
      end;
      E307 := E307 - 1;
      declare
         procedure F165;
         pragma Import (Ada, F165, "gtk__icon_source__finalize_spec");
      begin
         F165;
      end;
      E553 := E553 - 1;
      declare
         procedure F166;
         pragma Import (Ada, F166, "gtk__file_filter__finalize_spec");
      begin
         F166;
      end;
      declare
         procedure F167;
         pragma Import (Ada, F167, "gtk__entry_buffer__finalize_spec");
      begin
         F167;
      end;
      E311 := E311 - 1;
      declare
         procedure F168;
         pragma Import (Ada, F168, "gtk__css_section__finalize_spec");
      begin
         F168;
      end;
      E295 := E295 - 1;
      declare
         procedure F169;
         pragma Import (Ada, F169, "gtk__cell_area_context__finalize_spec");
      begin
         F169;
      end;
      E216 := E216 - 1;
      declare
         procedure F170;
         pragma Import (Ada, F170, "gtk__builder__finalize_spec");
      begin
         F170;
      end;
      declare
         procedure F171;
         pragma Import (Ada, F171, "gtk__adjustment__finalize_spec");
      begin
         F171;
      end;
      declare
         procedure F172;
         pragma Import (Ada, F172, "gtk__accel_group__finalize_spec");
      begin
         F172;
      end;
      declare
         procedure F173;
         pragma Import (Ada, F173, "glib__menu_model__finalize_spec");
      begin
         F173;
      end;
      E362 := E362 - 1;
      declare
         procedure F174;
         pragma Import (Ada, F174, "glib__variant__finalize_spec");
      begin
         F174;
      end;
      E232 := E232 - 1;
      declare
         procedure F175;
         pragma Import (Ada, F175, "gdk__drag_contexts__finalize_spec");
      begin
         F175;
      end;
      E230 := E230 - 1;
      declare
         procedure F176;
         pragma Import (Ada, F176, "gdk__device__finalize_spec");
      begin
         F176;
      end;
      E194 := E194 - 1;
      declare
         procedure F177;
         pragma Import (Ada, F177, "gdk__screen__finalize_spec");
      begin
         F177;
      end;
      E238 := E238 - 1;
      declare
         procedure F178;
         pragma Import (Ada, F178, "gdk__pixbuf__finalize_spec");
      begin
         F178;
      end;
      declare
         procedure F179;
         pragma Import (Ada, F179, "gdk__display__finalize_spec");
      begin
         F179;
      end;
      declare
         procedure F180;
         pragma Import (Ada, F180, "gdk__frame_clock__finalize_spec");
      begin
         F180;
      end;
      E171 := E171 - 1;
      declare
         procedure F181;
         pragma Import (Ada, F181, "glib__object__finalize_spec");
      begin
         F181;
      end;
      E388 := E388 - 1;
      declare
         procedure F182;
         pragma Import (Ada, F182, "glib__graphs__finalize_spec");
      begin
         F182;
      end;
      E236 := E236 - 1;
      declare
         procedure F183;
         pragma Import (Ada, F183, "gdk__frame_timings__finalize_spec");
      begin
         F183;
      end;
      E161 := E161 - 1;
      declare
         procedure F184;
         pragma Import (Ada, F184, "glib__finalize_spec");
      begin
         F184;
      end;
      E147 := E147 - 1;
      declare
         procedure F185;
         pragma Import (Ada, F185, "ada__text_io__finalize_spec");
      begin
         F185;
      end;
      E045 := E045 - 1;
      E145 := E145 - 1;
      declare
         procedure F186;
         pragma Import (Ada, F186, "system__regexp__finalize_spec");
      begin
         F186;
      end;
      declare
         procedure F187;
         pragma Import (Ada, F187, "ada__directories__finalize_spec");
      begin
         F187;
      end;
      E089 := E089 - 1;
      declare
         procedure F188;
         pragma Import (Ada, F188, "ada__strings__unbounded__finalize_spec");
      begin
         F188;
      end;
      E106 := E106 - 1;
      E102 := E102 - 1;
      declare
         procedure F189;
         pragma Import (Ada, F189, "system__file_io__finalize_body");
      begin
         E130 := E130 - 1;
         F189;
      end;
      E451 := E451 - 1;
      declare
         procedure F190;
         pragma Import (Ada, F190, "ada__streams__stream_io__finalize_spec");
      begin
         F190;
      end;
      declare
         procedure F191;
         pragma Import (Ada, F191, "system__file_control_block__finalize_spec");
      begin
         E139 := E139 - 1;
         F191;
      end;
      E141 := E141 - 1;
      declare
         procedure F192;
         pragma Import (Ada, F192, "system__pool_global__finalize_spec");
      begin
         F192;
      end;
      declare
         procedure F193;
         pragma Import (Ada, F193, "system__storage_pools__subpools__finalize_spec");
      begin
         F193;
      end;
      declare
         procedure F194;
         pragma Import (Ada, F194, "system__finalization_masters__finalize_spec");
      begin
         F194;
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
      E396 := E396 + 1;
      System.Fat_Llf'Elab_Spec;
      E157 := E157 + 1;
      System.Fat_Sflt'Elab_Spec;
      E433 := E433 + 1;
      System.Exception_Table'Elab_Body;
      E019 := E019 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E115 := E115 + 1;
      Ada.Numerics'Elab_Spec;
      E152 := E152 + 1;
      Ada.Strings'Elab_Spec;
      E076 := E076 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E081 := E081 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E114 := E114 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E021 := E021 + 1;
      System.Finalization_Root'Elab_Spec;
      E117 := E117 + 1;
      Ada.Finalization'Elab_Spec;
      E112 := E112 + 1;
      System.Storage_Pools'Elab_Spec;
      E119 := E119 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E047 := E047 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E055 := E055 + 1;
      System.Assertions'Elab_Spec;
      E352 := E352 + 1;
      System.Pool_Global'Elab_Spec;
      E141 := E141 + 1;
      System.File_Control_Block'Elab_Spec;
      E139 := E139 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E451 := E451 + 1;
      System.File_Io'Elab_Body;
      E130 := E130 + 1;
      E102 := E102 + 1;
      System.Finalization_Masters'Elab_Body;
      E106 := E106 + 1;
      E163 := E163 + 1;
      E049 := E049 + 1;
      Ada.Tags'Elab_Body;
      E091 := E091 + 1;
      E078 := E078 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E136 := E136 + 1;
      System.Secondary_Stack'Elab_Body;
      E009 := E009 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E089 := E089 + 1;
      Ada.Directories'Elab_Spec;
      System.Regexp'Elab_Spec;
      E145 := E145 + 1;
      Ada.Directories'Elab_Body;
      E045 := E045 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E449 := E449 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E147 := E147 + 1;
      Glib'Elab_Spec;
      E161 := E161 + 1;
      Gtkada.Types'Elab_Spec;
      E186 := E186 + 1;
      E425 := E425 + 1;
      E149 := E149 + 1;
      E590 := E590 + 1;
      File_Execution'Elab_Spec;
      E691 := E691 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      E236 := E236 + 1;
      E188 := E188 + 1;
      Gdk.Visual'Elab_Spec;
      Gdk.Visual'Elab_Body;
      E240 := E240 + 1;
      Glib.Graphs'Elab_Spec;
      E388 := E388 + 1;
      E190 := E190 + 1;
      Glib.Object'Elab_Spec;
      E173 := E173 + 1;
      Glib.Values'Elab_Body;
      E169 := E169 + 1;
      E167 := E167 + 1;
      E378 := E378 + 1;
      E192 := E192 + 1;
      E381 := E381 + 1;
      Gdk.Color'Elab_Spec;
      E165 := E165 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E204 := E204 + 1;
      E184 := E184 + 1;
      Gtkada.Bindings'Elab_Spec;
      E176 := E176 + 1;
      E283 := E283 + 1;
      E182 := E182 + 1;
      E364 := E364 + 1;
      Glib.Object'Elab_Body;
      E171 := E171 + 1;
      Gdk.Rgba'Elab_Body;
      E206 := E206 + 1;
      Gdk.Color'Elab_Body;
      E228 := E228 + 1;
      E390 := E390 + 1;
      E327 := E327 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Types'Elab_Spec;
      E202 := E202 + 1;
      Gdk.Event'Elab_Spec;
      E201 := E201 + 1;
      Gdk.Display'Elab_Spec;
      Gdk.Pixbuf'Elab_Spec;
      E238 := E238 + 1;
      E383 := E383 + 1;
      Glib.Properties'Elab_Spec;
      E212 := E212 + 1;
      Gdk.Cursor'Elab_Spec;
      E385 := E385 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E194 := E194 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Device'Elab_Body;
      E230 := E230 + 1;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Body;
      E232 := E232 + 1;
      Gdk.Window'Elab_Spec;
      E277 := E277 + 1;
      Glib.Variant'Elab_Spec;
      E362 := E362 + 1;
      Glib.Menu_Model'Elab_Spec;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Actionable'Elab_Spec;
      E370 := E370 + 1;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E216 := E216 + 1;
      E214 := E214 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E295 := E295 + 1;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Css_Section'Elab_Spec;
      E311 := E311 + 1;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Enums'Elab_Spec;
      E224 := E224 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E553 := E553 + 1;
      Gtk.Icon_Source'Elab_Spec;
      E307 := E307 + 1;
      Gtk.Orientable'Elab_Spec;
      E273 := E273 + 1;
      Gtk.Paper_Size'Elab_Spec;
      E329 := E329 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E325 := E325 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E337 := E337 + 1;
      Gtk.Scrollable'Elab_Spec;
      E400 := E400 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E244 := E244 + 1;
      Gtk.Style'Elab_Spec;
      E319 := E319 + 1;
      Gtk.Target_List'Elab_Spec;
      E317 := E317 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E706 := E706 + 1;
      Gtk.Tree_Model'Elab_Spec;
      E511 := E511 + 1;
      E513 := E513 + 1;
      Gtk.Tree_Store'Elab_Spec;
      Gtk.Tree_Store'Elab_Body;
      E509 := E509 + 1;
      Gtkada.Pixmaps'Elab_Spec;
      E597 := E597 + 1;
      List_Exceptions'Elab_Spec;
      E401 := E401 + 1;
      E441 := E441 + 1;
      E459 := E459 + 1;
      Mast'Elab_Spec;
      Mast.Scheduling_Parameters'Elab_Spec;
      Mast.Scheduling_Policies'Elab_Spec;
      Mast.Synchronization_Parameters'Elab_Spec;
      Mast.Timers'Elab_Spec;
      Mast_Analysis_Pixmaps'Elab_Spec;
      E696 := E696 + 1;
      E503 := E503 + 1;
      E755 := E755 + 1;
      mast_lex_io'elab_spec;
      E757 := E757 + 1;
      Mast_Parser_Error_Report'Elab_Spec;
      E561 := E561 + 1;
      Pango.Enums'Elab_Spec;
      E251 := E251 + 1;
      Pango.Attributes'Elab_Spec;
      E269 := E269 + 1;
      Pango.Font_Metrics'Elab_Spec;
      E255 := E255 + 1;
      Pango.Language'Elab_Spec;
      E257 := E257 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E253 := E253 + 1;
      E343 := E343 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E345 := E345 + 1;
      Gtk.Text_Iter'Elab_Spec;
      E341 := E341 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E261 := E261 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E259 := E259 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E263 := E263 + 1;
      E265 := E265 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E249 := E249 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E333 := E333 + 1;
      Pango.Tabs'Elab_Spec;
      E271 := E271 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E267 := E267 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E331 := E331 + 1;
      Gtk.Widget'Elab_Spec;
      Gtk.Action'Elab_Spec;
      Gtk.Activatable'Elab_Spec;
      E372 := E372 + 1;
      Gtk.Cell_Renderer'Elab_Spec;
      E297 := E297 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Cell_Renderer_Text'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E279 := E279 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E631 := E631 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E210 := E210 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.File_Chooser'Elab_Spec;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E348 := E348 + 1;
      Gtk.Grange'Elab_Spec;
      Gtk.Layout'Elab_Spec;
      Gtk.Layout'Elab_Body;
      E398 := E398 + 1;
      E392 := E392 + 1;
      E354 := E354 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu_Bar'Elab_Spec;
      Gtk.Menu_Bar'Elab_Body;
      E722 := E722 + 1;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E315 := E315 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Notebook'Elab_Spec;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E537 := E537 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Separator'Elab_Spec;
      Gtk.Separator'Elab_Body;
      E541 := E541 + 1;
      Gtk.Separator_Menu_Item'Elab_Spec;
      Gtk.Separator_Menu_Item'Elab_Body;
      E724 := E724 + 1;
      Gtk.Status_Bar'Elab_Spec;
      E313 := E313 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      E305 := E305 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E303 := E303 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E543 := E543 + 1;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E704 := E704 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Toggle_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Body;
      E744 := E744 + 1;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E523 := E523 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E517 := E517 + 1;
      Gtk.Window'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Add_Link_Dialog_Pkg'Elab_Spec;
      Add_New_Op_To_Driver_Dialog_Pkg'Elab_Spec;
      Add_New_Server_To_Driver_Dialog_Pkg'Elab_Spec;
      Add_Operation_Dialog_Pkg'Elab_Spec;
      Add_Shared_Dialog_Pkg'Elab_Spec;
      Cop_Dialog_Pkg'Elab_Spec;
      Driver_Dialog_Pkg'Elab_Spec;
      Editor_Error_Window_Pkg'Elab_Spec;
      External_Dialog_Pkg'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E570 := E570 + 1;
      Gtk.Print_Operation'Elab_Spec;
      Gtk.Arguments'Elab_Spec;
      E199 := E199 + 1;
      Gtk.Print_Operation'Elab_Body;
      E323 := E323 + 1;
      Gtk.Dialog'Elab_Body;
      E208 := E208 + 1;
      Gtk.Window'Elab_Body;
      E275 := E275 + 1;
      Gtk.Combo_Box'Elab_Body;
      E519 := E519 + 1;
      Gtk.Tree_View'Elab_Body;
      E521 := E521 + 1;
      Gtk.Tree_View_Column'Elab_Body;
      E527 := E527 + 1;
      Gtk.Tree_Selection'Elab_Body;
      E525 := E525 + 1;
      Gtk.Toggle_Button'Elab_Body;
      E746 := E746 + 1;
      Gtk.Text_View'Elab_Body;
      E710 := E710 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E700 := E700 + 1;
      Gtk.Gentry'Elab_Body;
      E281 := E281 + 1;
      Gtk.Style_Context'Elab_Body;
      E309 := E309 + 1;
      Gtk.Status_Bar'Elab_Body;
      E339 := E339 + 1;
      Gtk.Scrolled_Window'Elab_Body;
      E535 := E535 + 1;
      Gtk.Notebook'Elab_Body;
      E321 := E321 + 1;
      Gtk.Label'Elab_Body;
      E356 := E356 + 1;
      Gtk.Menu'Elab_Body;
      E358 := E358 + 1;
      Gtk.Menu_Shell'Elab_Body;
      E374 := E374 + 1;
      Gtk.Menu_Item'Elab_Body;
      E366 := E366 + 1;
      Gtk.Grange'Elab_Body;
      E539 := E539 + 1;
      E551 := E551 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E291 := E291 + 1;
      Gtk.Button'Elab_Body;
      E531 := E531 + 1;
      Gtk.Container'Elab_Body;
      E220 := E220 + 1;
      Gtk.Cell_Renderer_Text'Elab_Body;
      E533 := E533 + 1;
      Gtk.Cell_Area'Elab_Body;
      E293 := E293 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E299 := E299 + 1;
      Gtk.Action'Elab_Body;
      E368 := E368 + 1;
      Gtk.Widget'Elab_Body;
      E226 := E226 + 1;
      E335 := E335 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E708 := E708 + 1;
      E515 := E515 + 1;
      E301 := E301 + 1;
      Gtk.Clipboard'Elab_Body;
      E702 := E702 + 1;
      Gtk.Style'Elab_Body;
      E246 := E246 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E289 := E289 + 1;
      E285 := E285 + 1;
      Gtk.Adjustment'Elab_Body;
      E222 := E222 + 1;
      Gtk.Accel_Group'Elab_Body;
      E242 := E242 + 1;
      Glib.Menu_Model'Elab_Body;
      E360 := E360 + 1;
      Gdk.Display'Elab_Body;
      E196 := E196 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E234 := E234 + 1;
      E287 := E287 + 1;
      E588 := E588 + 1;
      E742 := E742 + 1;
      E750 := E750 + 1;
      E623 := E623 + 1;
      E627 := E627 + 1;
      E501 := E501 + 1;
      E559 := E559 + 1;
      E547 := E547 + 1;
      Gtkada.Canvas'Elab_Spec;
      Aux_Window_Pkg'Elab_Spec;
      Gtkada.Handlers'Elab_Spec;
      E393 := E393 + 1;
      Import_File_Selection_Pkg'Elab_Spec;
      Internal_Dialog_Pkg'Elab_Spec;
      Item_Menu_Pkg'Elab_Spec;
      Mast_Editor_Window_Pkg'Elab_Spec;
      Message_Tx_Dialog_Pkg'Elab_Spec;
      E677 := E677 + 1;
      Mieh_Dialog_Pkg'Elab_Spec;
      E728 := E728 + 1;
      Moeh_Dialog_Pkg'Elab_Spec;
      E732 := E732 + 1;
      Network_Dialog_Pkg'Elab_Spec;
      Open_File_Selection_Pkg'Elab_Spec;
      E395 := E395 + 1;
      Gtkada.Canvas'Elab_Body;
      E376 := E376 + 1;
      Prime_Sched_Dialog_Pkg'Elab_Spec;
      E655 := E655 + 1;
      Processor_Dialog_Pkg'Elab_Spec;
      Save_Changes_Dialog_Pkg'Elab_Spec;
      Save_File_Selection_Pkg'Elab_Spec;
      Sched_Server_Dialog_Pkg'Elab_Spec;
      Second_Sched_Dialog_Pkg'Elab_Spec;
      E665 := E665 + 1;
      Seh_Dialog_Pkg'Elab_Spec;
      E736 := E736 + 1;
      Select_Ref_Event_Dialog_Pkg'Elab_Spec;
      E578 := E578 + 1;
      Select_Req_Type_Dialog_Pkg'Elab_Spec;
      E582 := E582 + 1;
      Shared_Resource_Dialog_Pkg'Elab_Spec;
      E673 := E673 + 1;
      Sop_Dialog_Pkg'Elab_Spec;
      E681 := E681 + 1;
      Timer_Dialog_Pkg'Elab_Spec;
      E647 := E647 + 1;
      Trans_Dialog_Pkg'Elab_Spec;
      E687 := E687 + 1;
      E669 := E669 + 1;
      Var_Strings'Elab_Spec;
      E413 := E413 + 1;
      E507 := E507 + 1;
      Mast'Elab_Body;
      E403 := E403 + 1;
      MAST.IO'ELAB_SPEC;
      E485 := E485 + 1;
      E463 := E463 + 1;
      E473 := E473 + 1;
      E461 := E461 + 1;
      Mast_Editor'Elab_Spec;
      E492 := E492 + 1;
      E601 := E601 + 1;
      E430 := E430 + 1;
      MAST.EVENTS'ELAB_SPEC;
      E447 := E447 + 1;
      MAST.GRAPHS'ELAB_SPEC;
      E445 := E445 + 1;
      MAST.RESULTS'ELAB_SPEC;
      Mast.Processing_Resources'Elab_Spec;
      E471 := E471 + 1;
      Mast.Processing_Resources.Processor'Elab_Spec;
      E483 := E483 + 1;
      Mast.Schedulers'Elab_Spec;
      E469 := E469 + 1;
      MAST.SCHEDULING_SERVERS'ELAB_SPEC;
      Mast.Schedulers.Secondary'Elab_Spec;
      E487 := E487 + 1;
      Mast.Shared_Resources'Elab_Spec;
      E465 := E465 + 1;
      MAST.OPERATIONS'ELAB_SPEC;
      E435 := E435 + 1;
      Mast.Drivers'Elab_Spec;
      E415 := E415 + 1;
      MAST.GRAPHS.EVENT_HANDLERS'ELAB_SPEC;
      E491 := E491 + 1;
      Mast.Processing_Resources.Network'Elab_Spec;
      E479 := E479 + 1;
      MAST.TIMING_REQUIREMENTS'ELAB_SPEC;
      E457 := E457 + 1;
      MAST.GRAPHS.LINKS'ELAB_SPEC;
      E455 := E455 + 1;
      E443 := E443 + 1;
      MAST.TRANSACTIONS'ELAB_SPEC;
      E489 := E489 + 1;
      Mast.Systems'Elab_Spec;
      Mast.Schedulers.Primary'Elab_Spec;
      E475 := E475 + 1;
      E477 := E477 + 1;
      E481 := E481 + 1;
      E467 := E467 + 1;
      MAST.TRANSACTION_OPERATIONS'ELAB_SPEC;
      E635 := E635 + 1;
      Mast_Editor.Drivers'Elab_Spec;
      Mast_Editor.Operations'Elab_Spec;
      Mast_Editor.Processing_Resources'Elab_Spec;
      Mast_Editor.Schedulers'Elab_Spec;
      E659 := E659 + 1;
      E651 := E651 + 1;
      Mast_Editor.Scheduling_Servers'Elab_Spec;
      Mast_Editor.Shared_Resources'Elab_Spec;
      Mast_Editor.Timers'Elab_Spec;
      Mast_Editor.Transactions'Elab_Spec;
      Mast_Editor.Event_Handlers'Elab_Spec;
      Mast_Editor.Links'Elab_Spec;
      Mast_Editor.Systems'Elab_Spec;
      E761 := E761 + 1;
      Symbol_Table'Elab_Spec;
      Symbol_Table'Elab_Body;
      E428 := E428 + 1;
      Mast_Parser_Tokens'Elab_Spec;
      E426 := E426 + 1;
      MAST.IO'ELAB_BODY;
      E417 := E417 + 1;
      Editor_Actions'Elab_Spec;
      Mast_Editor.Event_Handlers'Elab_Body;
      E615 := E615 + 1;
      Mast_Editor.Timers'Elab_Body;
      E643 := E643 + 1;
      Mast_Editor.Drivers'Elab_Body;
      E494 := E494 + 1;
      E613 := E613 + 1;
      E605 := E605 + 1;
      E609 := E609 + 1;
      E555 := E555 + 1;
      Driver_Dialog_Pkg.Callbacks'Elab_Body;
      E738 := E738 + 1;
      E753 := E753 + 1;
      Editor_Actions'Elab_Body;
      E151 := E151 + 1;
      Wizard_Activity_Dialog_Pkg'Elab_Spec;
      Wizard_Completed_Dialog_Pkg'Elab_Spec;
      Wizard_Input_Dialog_Pkg'Elab_Spec;
      Callbacks_Mast_Editor'Elab_Spec;
      E497 := E497 + 1;
      E698 := E698 + 1;
      E695 := E695 + 1;
      Internal_Dialog_Pkg.Callbacks'Elab_Body;
      E574 := E574 + 1;
      Mast_Editor.Links'Elab_Body;
      E584 := E584 + 1;
      Mast_Editor.Transactions'Elab_Body;
      E683 := E683 + 1;
      Mast_Editor.Shared_Resources'Elab_Body;
      E633 := E633 + 1;
      Mast_Editor.Scheduling_Servers'Elab_Body;
      E637 := E637 + 1;
      Mast_Editor.Schedulers'Elab_Body;
      E639 := E639 + 1;
      Mast_Editor.Processing_Resources'Elab_Body;
      E641 := E641 + 1;
      Mast_Editor.Operations'Elab_Body;
      E619 := E619 + 1;
      Trans_Dialog_Pkg'Elab_Body;
      E685 := E685 + 1;
      E645 := E645 + 1;
      E679 := E679 + 1;
      E671 := E671 + 1;
      E580 := E580 + 1;
      Select_Ref_Event_Dialog_Pkg'Elab_Body;
      E576 := E576 + 1;
      E734 := E734 + 1;
      E663 := E663 + 1;
      E667 := E667 + 1;
      E611 := E611 + 1;
      E603 := E603 + 1;
      E657 := E657 + 1;
      E653 := E653 + 1;
      E607 := E607 + 1;
      E649 := E649 + 1;
      E730 := E730 + 1;
      E726 := E726 + 1;
      E675 := E675 + 1;
      Mast_Editor_Window_Pkg'Elab_Body;
      E617 := E617 + 1;
      E599 := E599 + 1;
      Internal_Dialog_Pkg'Elab_Body;
      E572 := E572 + 1;
      E549 := E549 + 1;
      E629 := E629 + 1;
      E545 := E545 + 1;
      E557 := E557 + 1;
      E496 := E496 + 1;
      E499 := E499 + 1;
      E625 := E625 + 1;
      E621 := E621 + 1;
      E748 := E748 + 1;
      E740 := E740 + 1;
      E586 := E586 + 1;
      E714 := E714 + 1;
      E712 := E712 + 1;
      Wizard_Output_Dialog_Pkg'Elab_Spec;
      E716 := E716 + 1;
      Wizard_Transaction_Dialog_Pkg'Elab_Spec;
      E718 := E718 + 1;
      Wizard_Welcome_Dialog_Pkg'Elab_Spec;
      E720 := E720 + 1;
      Simple_Transaction_Wizard_Control'Elab_Body;
      E693 := E693 + 1;
      E689 := E689 + 1;
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
   --   ./change_control.o
   --   ./cut_strings.o
   --   ./file_execution.o
   --   ../../mast_analysis/list_exceptions.o
   --   ../../mast_analysis/indexed_lists.o
   --   ../../mast_analysis/hash_lists.o
   --   ../../gmast/src/mast_analysis_pixmaps.o
   --   ./mast_editor_intl.o
   --   ../../mast_analysis/mast_lex_dfa.o
   --   ../../mast_analysis/mast_lex_io.o
   --   ../../mast_analysis/mast_parser_error_report.o
   --   ../../mast_analysis/mast_parser_goto.o
   --   ../../mast_analysis/mast_parser_shift_reduce.o
   --   ./add_link_dialog_pkg-callbacks.o
   --   ./add_new_op_to_driver_dialog_pkg-callbacks.o
   --   ./add_new_server_to_driver_dialog_pkg-callbacks.o
   --   ./add_operation_dialog_pkg-callbacks.o
   --   ./add_shared_dialog_pkg-callbacks.o
   --   ./cop_dialog_pkg-callbacks.o
   --   ./editor_error_window_pkg-callbacks.o
   --   ./external_dialog_pkg-callbacks.o
   --   ./message_tx_dialog_pkg-callbacks.o
   --   ./mieh_dialog_pkg-callbacks.o
   --   ./moeh_dialog_pkg-callbacks.o
   --   ./prime_sched_dialog_pkg-callbacks.o
   --   ./second_sched_dialog_pkg-callbacks.o
   --   ./seh_dialog_pkg-callbacks.o
   --   ./select_ref_event_dialog_pkg-callbacks.o
   --   ./select_req_type_dialog_pkg-callbacks.o
   --   ./shared_resource_dialog_pkg-callbacks.o
   --   ./sop_dialog_pkg-callbacks.o
   --   ./timer_dialog_pkg-callbacks.o
   --   ./trans_dialog_pkg-callbacks.o
   --   ./sched_server_dialog_pkg-callbacks.o
   --   ../../mast_analysis/var_strings.o
   --   ./utilities.o
   --   ../../mast_analysis/mast.o
   --   ./mast-timers.o
   --   ./mast-synchronization_parameters.o
   --   ./mast-scheduling_policies.o
   --   ./mast-scheduling_parameters.o
   --   ./mast_editor.o
   --   ./item_menu_pkg-callbacks.o
   --   ../../mast_analysis/named_lists.o
   --   ./mast-events.o
   --   ./mast-graphs.o
   --   ../../mast_analysis/mast-processing_resources.o
   --   ./mast-processing_resources-processor.o
   --   ./mast-schedulers.o
   --   ./mast-schedulers-secondary.o
   --   ./mast-shared_resources.o
   --   ./mast-operations.o
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
   --   ./mast-transaction_operations.o
   --   ./processor_dialog_pkg-callbacks.o
   --   ./network_dialog_pkg-callbacks.o
   --   ./mast_editor-systems.o
   --   ../../mast_analysis/symbol_table.o
   --   ../../mast_analysis/mast_parser_tokens.o
   --   ../../mast_analysis/mast-io.o
   --   ./mast_editor-event_handlers.o
   --   ./mast_editor-timers.o
   --   ./mast_editor-drivers.o
   --   ./save_file_selection_pkg-callbacks.o
   --   ./save_changes_dialog_pkg-callbacks.o
   --   ./open_file_selection_pkg-callbacks.o
   --   ./import_file_selection_pkg-callbacks.o
   --   ./driver_dialog_pkg-callbacks.o
   --   ./gmasteditor.o
   --   ../../mast_analysis/mast_lex.o
   --   ./mast_parser.o
   --   ./editor_actions.o
   --   ./callbacks_mast_editor.o
   --   ./wizard_completed_dialog_pkg.o
   --   ./wizard_activity_dialog_pkg.o
   --   ./internal_dialog_pkg-callbacks.o
   --   ./mast_editor-links.o
   --   ./mast_editor-transactions.o
   --   ./mast_editor-shared_resources.o
   --   ./mast_editor-scheduling_servers.o
   --   ./mast_editor-schedulers.o
   --   ./mast_editor-processing_resources.o
   --   ./mast_editor-operations.o
   --   ./trans_dialog_pkg.o
   --   ./timer_dialog_pkg.o
   --   ./sop_dialog_pkg.o
   --   ./shared_resource_dialog_pkg.o
   --   ./select_req_type_dialog_pkg.o
   --   ./select_ref_event_dialog_pkg.o
   --   ./seh_dialog_pkg.o
   --   ./second_sched_dialog_pkg.o
   --   ./sched_server_dialog_pkg.o
   --   ./save_file_selection_pkg.o
   --   ./save_changes_dialog_pkg.o
   --   ./processor_dialog_pkg.o
   --   ./prime_sched_dialog_pkg.o
   --   ./open_file_selection_pkg.o
   --   ./network_dialog_pkg.o
   --   ./moeh_dialog_pkg.o
   --   ./mieh_dialog_pkg.o
   --   ./message_tx_dialog_pkg.o
   --   ./mast_editor_window_pkg.o
   --   ./item_menu_pkg.o
   --   ./internal_dialog_pkg.o
   --   ./import_file_selection_pkg.o
   --   ./aux_window_pkg.o
   --   ./external_dialog_pkg.o
   --   ./editor_error_window_pkg.o
   --   ./driver_dialog_pkg.o
   --   ./cop_dialog_pkg.o
   --   ./add_shared_dialog_pkg.o
   --   ./add_operation_dialog_pkg.o
   --   ./add_new_server_to_driver_dialog_pkg.o
   --   ./add_new_op_to_driver_dialog_pkg.o
   --   ./add_link_dialog_pkg.o
   --   ./wizard_input_dialog_pkg-callbacks.o
   --   ./wizard_input_dialog_pkg.o
   --   ./wizard_output_dialog_pkg.o
   --   ./wizard_transaction_dialog_pkg.o
   --   ./wizard_welcome_dialog_pkg.o
   --   ./simple_transaction_wizard_control.o
   --   ./mast_editor_window_pkg-callbacks.o
   --   -L./
   --   -L../../mast_analysis/
   --   -L../../utils/
   --   -L../../gmast/src/
   --   -L../../gmastresults/src/
   --   -L/home/mgh/gnat2014/gtkada/lib/gtkada/relocatable/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
