pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__gmast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__gmast_analysis.adb");
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
   E435 : Short_Integer; pragma Import (Ada, E435, "ada__assertions_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "ada__strings__utf_encoding_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "ada__tags_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "ada__strings__text_buffers_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "gnat_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "interfaces__c__strings_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "ada__streams_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "system__file_control_block_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "system__finalization_root_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "ada__finalization_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "system__file_io_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "system__storage_pools_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "system__finalization_masters_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "system__storage_pools__subpools_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "ada__strings__unbounded_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__calendar_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "ada__text_io_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "system__pool_global_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "system__regexp_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__directories_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "glib_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gtkada__types_E");
   E266 : Short_Integer; pragma Import (Ada, E266, "gdk__frame_timings_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "glib__glist_E");
   E248 : Short_Integer; pragma Import (Ada, E248, "gdk__visual_E");
   E216 : Short_Integer; pragma Import (Ada, E216, "glib__gslist_E");
   E441 : Short_Integer; pragma Import (Ada, E441, "gmast_analysis_intl_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "gtkada__c_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "glib__object_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "glib__type_conversion_hooks_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "glib__types_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "glib__values_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "gtkada__bindings_E");
   E222 : Short_Integer; pragma Import (Ada, E222, "cairo_E");
   E224 : Short_Integer; pragma Import (Ada, E224, "cairo__region_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "gdk__rectangle_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "glib__generic_properties_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "gdk__color_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "gdk__rgba_E");
   E377 : Short_Integer; pragma Import (Ada, E377, "glib__key_file_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "glib__properties_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "gdk__device_tool_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "gdk__drawing_context_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "gdk__event_E");
   E276 : Short_Integer; pragma Import (Ada, E276, "glib__string_E");
   E274 : Short_Integer; pragma Import (Ada, E274, "glib__variant_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "glib__g_icon_E");
   E411 : Short_Integer; pragma Import (Ada, E411, "gtk__actionable_E");
   E280 : Short_Integer; pragma Import (Ada, E280, "gtk__builder_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "gtk__buildable_E");
   E351 : Short_Integer; pragma Import (Ada, E351, "gtk__cell_area_context_E");
   E367 : Short_Integer; pragma Import (Ada, E367, "gtk__css_section_E");
   E256 : Short_Integer; pragma Import (Ada, E256, "gtk__enums_E");
   E550 : Short_Integer; pragma Import (Ada, E550, "gtk__file_filter_E");
   E325 : Short_Integer; pragma Import (Ada, E325, "gtk__orientable_E");
   E379 : Short_Integer; pragma Import (Ada, E379, "gtk__paper_size_E");
   E375 : Short_Integer; pragma Import (Ada, E375, "gtk__page_setup_E");
   E385 : Short_Integer; pragma Import (Ada, E385, "gtk__print_settings_E");
   E554 : Short_Integer; pragma Import (Ada, E554, "gtk__stock_E");
   E288 : Short_Integer; pragma Import (Ada, E288, "gtk__target_entry_E");
   E286 : Short_Integer; pragma Import (Ada, E286, "gtk__target_list_E");
   E405 : Short_Integer; pragma Import (Ada, E405, "gtk__text_mark_E");
   E510 : Short_Integer; pragma Import (Ada, E510, "list_exceptions_E");
   E509 : Short_Integer; pragma Import (Ada, E509, "dynamic_lists_E");
   E543 : Short_Integer; pragma Import (Ada, E543, "mast_analysis_pixmaps_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "pango__enums_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "pango__attributes_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "pango__font_metrics_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "pango__language_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "pango__font_E");
   E391 : Short_Integer; pragma Import (Ada, E391, "gtk__text_attributes_E");
   E393 : Short_Integer; pragma Import (Ada, E393, "gtk__text_tag_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "pango__font_face_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "pango__font_family_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "pango__fontset_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "pango__matrix_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "pango__context_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "pango__font_map_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "pango__tabs_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "pango__layout_E");
   E381 : Short_Integer; pragma Import (Ada, E381, "gtk__print_context_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "gdk__frame_clock_E");
   E244 : Short_Integer; pragma Import (Ada, E244, "gdk__monitor_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "gdk__display_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "gdk__glcontext_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "gdk__pixbuf_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "gdk__screen_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "gdk__device_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "gdk__drag_contexts_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "gdk__window_E");
   E272 : Short_Integer; pragma Import (Ada, E272, "glib__action_group_E");
   E278 : Short_Integer; pragma Import (Ada, E278, "gtk__accel_group_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "gtk__adjustment_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gtk__cell_editable_E");
   E343 : Short_Integer; pragma Import (Ada, E343, "gtk__editable_E");
   E345 : Short_Integer; pragma Import (Ada, E345, "gtk__entry_buffer_E");
   E363 : Short_Integer; pragma Import (Ada, E363, "gtk__icon_source_E");
   E383 : Short_Integer; pragma Import (Ada, E383, "gtk__print_operation_preview_E");
   E282 : Short_Integer; pragma Import (Ada, E282, "gtk__selection_data_E");
   E401 : Short_Integer; pragma Import (Ada, E401, "gtk__clipboard_E");
   E284 : Short_Integer; pragma Import (Ada, E284, "gtk__style_E");
   E397 : Short_Integer; pragma Import (Ada, E397, "gtk__scrollable_E");
   E389 : Short_Integer; pragma Import (Ada, E389, "gtk__text_iter_E");
   E407 : Short_Integer; pragma Import (Ada, E407, "gtk__text_tag_table_E");
   E357 : Short_Integer; pragma Import (Ada, E357, "gtk__tree_model_E");
   E260 : Short_Integer; pragma Import (Ada, E260, "gtk__widget_E");
   E355 : Short_Integer; pragma Import (Ada, E355, "gtk__cell_renderer_E");
   E353 : Short_Integer; pragma Import (Ada, E353, "gtk__cell_layout_E");
   E349 : Short_Integer; pragma Import (Ada, E349, "gtk__cell_area_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "gtk__container_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "gtk__bin_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "gtk__box_E");
   E347 : Short_Integer; pragma Import (Ada, E347, "gtk__entry_completion_E");
   E369 : Short_Integer; pragma Import (Ada, E369, "gtk__misc_E");
   E371 : Short_Integer; pragma Import (Ada, E371, "gtk__notebook_E");
   E387 : Short_Integer; pragma Import (Ada, E387, "gtk__status_bar_E");
   E258 : Short_Integer; pragma Import (Ada, E258, "gtk__style_provider_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "gtk__settings_E");
   E365 : Short_Integer; pragma Import (Ada, E365, "gtk__style_context_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "gtk__icon_set_E");
   E359 : Short_Integer; pragma Import (Ada, E359, "gtk__image_E");
   E337 : Short_Integer; pragma Import (Ada, E337, "gtk__gentry_E");
   E403 : Short_Integer; pragma Import (Ada, E403, "gtk__text_child_anchor_E");
   E399 : Short_Integer; pragma Import (Ada, E399, "gtk__text_buffer_E");
   E395 : Short_Integer; pragma Import (Ada, E395, "gtk__text_view_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "gtk__window_E");
   E252 : Short_Integer; pragma Import (Ada, E252, "gtk__dialog_E");
   E373 : Short_Integer; pragma Import (Ada, E373, "gtk__print_operation_E");
   E220 : Short_Integer; pragma Import (Ada, E220, "gtk__arguments_E");
   E452 : Short_Integer; pragma Import (Ada, E452, "glib__menu_model_E");
   E409 : Short_Integer; pragma Import (Ada, E409, "gtk__action_E");
   E413 : Short_Integer; pragma Import (Ada, E413, "gtk__activatable_E");
   E446 : Short_Integer; pragma Import (Ada, E446, "gtk__alignment_E");
   E218 : Short_Integer; pragma Import (Ada, E218, "gtk__button_E");
   E548 : Short_Integer; pragma Import (Ada, E548, "gtk__file_chooser_E");
   E552 : Short_Integer; pragma Import (Ada, E552, "gtk__file_chooser_dialog_E");
   E527 : Short_Integer; pragma Import (Ada, E527, "gtk__frame_E");
   E466 : Short_Integer; pragma Import (Ada, E466, "gtk__grange_E");
   E536 : Short_Integer; pragma Import (Ada, E536, "gtk__main_E");
   E437 : Short_Integer; pragma Import (Ada, E437, "gtk__marshallers_E");
   E454 : Short_Integer; pragma Import (Ada, E454, "gtk__menu_item_E");
   E456 : Short_Integer; pragma Import (Ada, E456, "gtk__menu_shell_E");
   E450 : Short_Integer; pragma Import (Ada, E450, "gtk__menu_E");
   E448 : Short_Integer; pragma Import (Ada, E448, "gtk__label_E");
   E464 : Short_Integer; pragma Import (Ada, E464, "gtk__scrollbar_E");
   E462 : Short_Integer; pragma Import (Ada, E462, "gtk__scrolled_window_E");
   E529 : Short_Integer; pragma Import (Ada, E529, "gtk__table_E");
   E417 : Short_Integer; pragma Import (Ada, E417, "gtk__toggle_button_E");
   E415 : Short_Integer; pragma Import (Ada, E415, "gtk__check_button_E");
   E425 : Short_Integer; pragma Import (Ada, E425, "gtk__tooltip_E");
   E427 : Short_Integer; pragma Import (Ada, E427, "gtk__tree_selection_E");
   E429 : Short_Integer; pragma Import (Ada, E429, "gtk__tree_view_column_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "gtk__tree_view_E");
   E421 : Short_Integer; pragma Import (Ada, E421, "gtk__combo_box_E");
   E419 : Short_Integer; pragma Import (Ada, E419, "gtk__combo_box_text_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "callbacks_gmast_analysis_E");
   E444 : Short_Integer; pragma Import (Ada, E444, "gtkada__handlers_E");
   E531 : Short_Integer; pragma Import (Ada, E531, "error_inputfile_pkg_E");
   E533 : Short_Integer; pragma Import (Ada, E533, "error_inputfile_pkg__callbacks_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "error_window_pkg_E");
   E439 : Short_Integer; pragma Import (Ada, E439, "error_window_pkg__callbacks_E");
   E458 : Short_Integer; pragma Import (Ada, E458, "help_annealing_pkg_E");
   E460 : Short_Integer; pragma Import (Ada, E460, "help_annealing_pkg__callbacks_E");
   E523 : Short_Integer; pragma Import (Ada, E523, "help_hopa_pkg_E");
   E525 : Short_Integer; pragma Import (Ada, E525, "help_hopa_pkg__callbacks_E");
   E538 : Short_Integer; pragma Import (Ada, E538, "help_pkg_E");
   E540 : Short_Integer; pragma Import (Ada, E540, "help_pkg__callbacks_E");
   E479 : Short_Integer; pragma Import (Ada, E479, "var_strings_E");
   E468 : Short_Integer; pragma Import (Ada, E468, "mast_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "mast__tool_exceptions_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "mast__annealing_parameters_E");
   E493 : Short_Integer; pragma Import (Ada, E493, "mast__hospa_parameters_E");
   E491 : Short_Integer; pragma Import (Ada, E491, "mast__sched_param_assignment_parameters_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "annealing_window_pkg_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "annealing_window_pkg__callbacks_E");
   E517 : Short_Integer; pragma Import (Ada, E517, "hopa_window_pkg_E");
   E521 : Short_Integer; pragma Import (Ada, E521, "hopa_window_pkg__callbacks_E");
   E515 : Short_Integer; pragma Import (Ada, E515, "parameters_handling_E");
   E542 : Short_Integer; pragma Import (Ada, E542, "mast_analysis_pkg_E");
   E545 : Short_Integer; pragma Import (Ada, E545, "mast_analysis_pkg__callbacks_E");
   E557 : Short_Integer; pragma Import (Ada, E557, "var_string_utils_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E542 := E542 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "mast_analysis_pkg__finalize_spec");
      begin
         F1;
      end;
      E517 := E517 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "hopa_window_pkg__finalize_spec");
      begin
         F2;
      end;
      E175 := E175 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "annealing_window_pkg__finalize_spec");
      begin
         F3;
      end;
      E538 := E538 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "help_pkg__finalize_spec");
      begin
         F4;
      end;
      E523 := E523 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "help_hopa_pkg__finalize_spec");
      begin
         F5;
      end;
      E458 := E458 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "help_annealing_pkg__finalize_spec");
      begin
         F6;
      end;
      E179 := E179 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "error_window_pkg__finalize_spec");
      begin
         F7;
      end;
      E531 := E531 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "error_inputfile_pkg__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "gtkada__handlers__finalize_spec");
      begin
         E444 := E444 - 1;
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "callbacks_gmast_analysis__finalize_spec");
      begin
         E180 := E180 - 1;
         F10;
      end;
      E419 := E419 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "gtk__combo_box_text__finalize_spec");
      begin
         F11;
      end;
      E421 := E421 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "gtk__combo_box__finalize_spec");
      begin
         F12;
      end;
      E423 := E423 - 1;
      declare
         procedure F13;
         pragma Import (Ada, F13, "gtk__tree_view__finalize_spec");
      begin
         F13;
      end;
      E429 := E429 - 1;
      declare
         procedure F14;
         pragma Import (Ada, F14, "gtk__tree_view_column__finalize_spec");
      begin
         F14;
      end;
      E427 := E427 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "gtk__tree_selection__finalize_spec");
      begin
         F15;
      end;
      E425 := E425 - 1;
      declare
         procedure F16;
         pragma Import (Ada, F16, "gtk__tooltip__finalize_spec");
      begin
         F16;
      end;
      E415 := E415 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "gtk__check_button__finalize_spec");
      begin
         F17;
      end;
      E417 := E417 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "gtk__toggle_button__finalize_spec");
      begin
         F18;
      end;
      E529 := E529 - 1;
      declare
         procedure F19;
         pragma Import (Ada, F19, "gtk__table__finalize_spec");
      begin
         F19;
      end;
      E462 := E462 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "gtk__scrolled_window__finalize_spec");
      begin
         F20;
      end;
      E464 := E464 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "gtk__scrollbar__finalize_spec");
      begin
         F21;
      end;
      E448 := E448 - 1;
      declare
         procedure F22;
         pragma Import (Ada, F22, "gtk__label__finalize_spec");
      begin
         F22;
      end;
      E450 := E450 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "gtk__menu__finalize_spec");
      begin
         F23;
      end;
      E456 := E456 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "gtk__menu_shell__finalize_spec");
      begin
         F24;
      end;
      E454 := E454 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "gtk__menu_item__finalize_spec");
      begin
         F25;
      end;
      E466 := E466 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "gtk__grange__finalize_spec");
      begin
         F26;
      end;
      E527 := E527 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "gtk__frame__finalize_spec");
      begin
         F27;
      end;
      E552 := E552 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F28;
      end;
      E218 := E218 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "gtk__button__finalize_spec");
      begin
         F29;
      end;
      E446 := E446 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "gtk__alignment__finalize_spec");
      begin
         F30;
      end;
      E409 := E409 - 1;
      declare
         procedure F31;
         pragma Import (Ada, F31, "gtk__action__finalize_spec");
      begin
         F31;
      end;
      E452 := E452 - 1;
      declare
         procedure F32;
         pragma Import (Ada, F32, "glib__menu_model__finalize_spec");
      begin
         F32;
      end;
      E327 := E327 - 1;
      E260 := E260 - 1;
      E357 := E357 - 1;
      E395 := E395 - 1;
      E407 := E407 - 1;
      E399 := E399 - 1;
      E365 := E365 - 1;
      E284 := E284 - 1;
      E387 := E387 - 1;
      E373 := E373 - 1;
      E371 := E371 - 1;
      E337 := E337 - 1;
      E347 := E347 - 1;
      E345 := E345 - 1;
      E252 := E252 - 1;
      E321 := E321 - 1;
      E401 := E401 - 1;
      E355 := E355 - 1;
      E349 := E349 - 1;
      E323 := E323 - 1;
      E278 := E278 - 1;
      E244 := E244 - 1;
      E264 := E264 - 1;
      E227 := E227 - 1;
      E233 := E233 - 1;
      E231 := E231 - 1;
      declare
         procedure F33;
         pragma Import (Ada, F33, "gtk__print_operation__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "gtk__dialog__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "gtk__window__finalize_spec");
      begin
         F35;
      end;
      declare
         procedure F36;
         pragma Import (Ada, F36, "gtk__text_view__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "gtk__text_buffer__finalize_spec");
      begin
         F37;
      end;
      E403 := E403 - 1;
      declare
         procedure F38;
         pragma Import (Ada, F38, "gtk__text_child_anchor__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "gtk__gentry__finalize_spec");
      begin
         F39;
      end;
      E359 := E359 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "gtk__image__finalize_spec");
      begin
         F40;
      end;
      E361 := E361 - 1;
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
      E254 := E254 - 1;
      declare
         procedure F43;
         pragma Import (Ada, F43, "gtk__settings__finalize_spec");
      begin
         F43;
      end;
      declare
         procedure F44;
         pragma Import (Ada, F44, "gtk__status_bar__finalize_spec");
      begin
         F44;
      end;
      declare
         procedure F45;
         pragma Import (Ada, F45, "gtk__notebook__finalize_spec");
      begin
         F45;
      end;
      E369 := E369 - 1;
      declare
         procedure F46;
         pragma Import (Ada, F46, "gtk__misc__finalize_spec");
      begin
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "gtk__entry_completion__finalize_spec");
      begin
         F47;
      end;
      E317 := E317 - 1;
      declare
         procedure F48;
         pragma Import (Ada, F48, "gtk__box__finalize_spec");
      begin
         F48;
      end;
      E335 := E335 - 1;
      declare
         procedure F49;
         pragma Import (Ada, F49, "gtk__bin__finalize_spec");
      begin
         F49;
      end;
      declare
         procedure F50;
         pragma Import (Ada, F50, "gtk__container__finalize_spec");
      begin
         F50;
      end;
      declare
         procedure F51;
         pragma Import (Ada, F51, "gtk__cell_area__finalize_spec");
      begin
         F51;
      end;
      declare
         procedure F52;
         pragma Import (Ada, F52, "gtk__cell_renderer__finalize_spec");
      begin
         F52;
      end;
      declare
         procedure F53;
         pragma Import (Ada, F53, "gtk__widget__finalize_spec");
      begin
         F53;
      end;
      declare
         procedure F54;
         pragma Import (Ada, F54, "gtk__tree_model__finalize_spec");
      begin
         F54;
      end;
      declare
         procedure F55;
         pragma Import (Ada, F55, "gtk__text_tag_table__finalize_spec");
      begin
         F55;
      end;
      declare
         procedure F56;
         pragma Import (Ada, F56, "gtk__style__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "gtk__clipboard__finalize_spec");
      begin
         F57;
      end;
      E282 := E282 - 1;
      declare
         procedure F58;
         pragma Import (Ada, F58, "gtk__selection_data__finalize_spec");
      begin
         F58;
      end;
      E363 := E363 - 1;
      declare
         procedure F59;
         pragma Import (Ada, F59, "gtk__icon_source__finalize_spec");
      begin
         F59;
      end;
      declare
         procedure F60;
         pragma Import (Ada, F60, "gtk__entry_buffer__finalize_spec");
      begin
         F60;
      end;
      declare
         procedure F61;
         pragma Import (Ada, F61, "gtk__adjustment__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "gtk__accel_group__finalize_spec");
      begin
         F62;
      end;
      declare
         procedure F63;
         pragma Import (Ada, F63, "gdk__drag_contexts__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "gdk__device__finalize_spec");
      begin
         F64;
      end;
      E246 := E246 - 1;
      declare
         procedure F65;
         pragma Import (Ada, F65, "gdk__screen__finalize_spec");
      begin
         F65;
      end;
      E268 := E268 - 1;
      declare
         procedure F66;
         pragma Import (Ada, F66, "gdk__pixbuf__finalize_spec");
      begin
         F66;
      end;
      E333 := E333 - 1;
      declare
         procedure F67;
         pragma Import (Ada, F67, "gdk__glcontext__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "gdk__display__finalize_spec");
      begin
         F68;
      end;
      declare
         procedure F69;
         pragma Import (Ada, F69, "gdk__monitor__finalize_spec");
      begin
         F69;
      end;
      declare
         procedure F70;
         pragma Import (Ada, F70, "gdk__frame_clock__finalize_spec");
      begin
         F70;
      end;
      E381 := E381 - 1;
      declare
         procedure F71;
         pragma Import (Ada, F71, "gtk__print_context__finalize_spec");
      begin
         F71;
      end;
      E311 := E311 - 1;
      declare
         procedure F72;
         pragma Import (Ada, F72, "pango__layout__finalize_spec");
      begin
         F72;
      end;
      E315 := E315 - 1;
      declare
         procedure F73;
         pragma Import (Ada, F73, "pango__tabs__finalize_spec");
      begin
         F73;
      end;
      E309 := E309 - 1;
      declare
         procedure F74;
         pragma Import (Ada, F74, "pango__font_map__finalize_spec");
      begin
         F74;
      end;
      E291 := E291 - 1;
      declare
         procedure F75;
         pragma Import (Ada, F75, "pango__context__finalize_spec");
      begin
         F75;
      end;
      E305 := E305 - 1;
      declare
         procedure F76;
         pragma Import (Ada, F76, "pango__fontset__finalize_spec");
      begin
         F76;
      end;
      E301 := E301 - 1;
      declare
         procedure F77;
         pragma Import (Ada, F77, "pango__font_family__finalize_spec");
      begin
         F77;
      end;
      E303 := E303 - 1;
      declare
         procedure F78;
         pragma Import (Ada, F78, "pango__font_face__finalize_spec");
      begin
         F78;
      end;
      E393 := E393 - 1;
      declare
         procedure F79;
         pragma Import (Ada, F79, "gtk__text_tag__finalize_spec");
      begin
         F79;
      end;
      E295 := E295 - 1;
      declare
         procedure F80;
         pragma Import (Ada, F80, "pango__font__finalize_spec");
      begin
         F80;
      end;
      E299 := E299 - 1;
      declare
         procedure F81;
         pragma Import (Ada, F81, "pango__language__finalize_spec");
      begin
         F81;
      end;
      E297 := E297 - 1;
      declare
         procedure F82;
         pragma Import (Ada, F82, "pango__font_metrics__finalize_spec");
      begin
         F82;
      end;
      E313 := E313 - 1;
      declare
         procedure F83;
         pragma Import (Ada, F83, "pango__attributes__finalize_spec");
      begin
         F83;
      end;
      E405 := E405 - 1;
      declare
         procedure F84;
         pragma Import (Ada, F84, "gtk__text_mark__finalize_spec");
      begin
         F84;
      end;
      E286 := E286 - 1;
      declare
         procedure F85;
         pragma Import (Ada, F85, "gtk__target_list__finalize_spec");
      begin
         F85;
      end;
      E385 := E385 - 1;
      declare
         procedure F86;
         pragma Import (Ada, F86, "gtk__print_settings__finalize_spec");
      begin
         F86;
      end;
      E375 := E375 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "gtk__page_setup__finalize_spec");
      begin
         F87;
      end;
      E379 := E379 - 1;
      declare
         procedure F88;
         pragma Import (Ada, F88, "gtk__paper_size__finalize_spec");
      begin
         F88;
      end;
      E550 := E550 - 1;
      declare
         procedure F89;
         pragma Import (Ada, F89, "gtk__file_filter__finalize_spec");
      begin
         F89;
      end;
      E367 := E367 - 1;
      declare
         procedure F90;
         pragma Import (Ada, F90, "gtk__css_section__finalize_spec");
      begin
         F90;
      end;
      E351 := E351 - 1;
      declare
         procedure F91;
         pragma Import (Ada, F91, "gtk__cell_area_context__finalize_spec");
      begin
         F91;
      end;
      E280 := E280 - 1;
      declare
         procedure F92;
         pragma Import (Ada, F92, "gtk__builder__finalize_spec");
      begin
         F92;
      end;
      E274 := E274 - 1;
      declare
         procedure F93;
         pragma Import (Ada, F93, "glib__variant__finalize_spec");
      begin
         F93;
      end;
      E331 := E331 - 1;
      declare
         procedure F94;
         pragma Import (Ada, F94, "gdk__drawing_context__finalize_spec");
      begin
         F94;
      end;
      E237 := E237 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "gdk__device_tool__finalize_spec");
      begin
         F95;
      end;
      E194 := E194 - 1;
      declare
         procedure F96;
         pragma Import (Ada, F96, "glib__object__finalize_spec");
      begin
         F96;
      end;
      E266 := E266 - 1;
      declare
         procedure F97;
         pragma Import (Ada, F97, "gdk__frame_timings__finalize_spec");
      begin
         F97;
      end;
      E183 := E183 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "glib__finalize_spec");
      begin
         F98;
      end;
      declare
         procedure F99;
         pragma Import (Ada, F99, "ada__directories__finalize_body");
      begin
         E103 := E103 - 1;
         F99;
      end;
      declare
         procedure F100;
         pragma Import (Ada, F100, "ada__directories__finalize_spec");
      begin
         F100;
      end;
      E171 := E171 - 1;
      declare
         procedure F101;
         pragma Import (Ada, F101, "system__regexp__finalize_spec");
      begin
         F101;
      end;
      E190 := E190 - 1;
      declare
         procedure F102;
         pragma Import (Ada, F102, "system__pool_global__finalize_spec");
      begin
         F102;
      end;
      E173 := E173 - 1;
      declare
         procedure F103;
         pragma Import (Ada, F103, "ada__text_io__finalize_spec");
      begin
         F103;
      end;
      E146 := E146 - 1;
      declare
         procedure F104;
         pragma Import (Ada, F104, "ada__strings__unbounded__finalize_spec");
      begin
         F104;
      end;
      E198 := E198 - 1;
      declare
         procedure F105;
         pragma Import (Ada, F105, "system__storage_pools__subpools__finalize_spec");
      begin
         F105;
      end;
      E167 := E167 - 1;
      declare
         procedure F106;
         pragma Import (Ada, F106, "system__finalization_masters__finalize_spec");
      begin
         F106;
      end;
      declare
         procedure F107;
         pragma Import (Ada, F107, "system__file_io__finalize_body");
      begin
         E162 := E162 - 1;
         F107;
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
      E435 := E435 + 1;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      E116 := E116 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E124 := E124 + 1;
      Ada.Strings.Text_Buffers'Elab_Spec;
      E114 := E114 + 1;
      Gnat'Elab_Spec;
      E203 := E203 + 1;
      Interfaces.C.Strings'Elab_Spec;
      E188 := E188 + 1;
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
      E198 := E198 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E146 := E146 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E105 := E105 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E173 := E173 + 1;
      System.Pool_Global'Elab_Spec;
      E190 := E190 + 1;
      System.Regexp'Elab_Spec;
      E171 := E171 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E103 := E103 + 1;
      Glib'Elab_Spec;
      Gtkada.Types'Elab_Spec;
      E186 := E186 + 1;
      E183 := E183 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      Gdk.Frame_Timings'Elab_Body;
      E266 := E266 + 1;
      E214 := E214 + 1;
      Gdk.Visual'Elab_Body;
      E248 := E248 + 1;
      E216 := E216 + 1;
      E441 := E441 + 1;
      E208 := E208 + 1;
      Glib.Object'Elab_Spec;
      E196 := E196 + 1;
      Glib.Values'Elab_Body;
      E212 := E212 + 1;
      E202 := E202 + 1;
      Glib.Object'Elab_Body;
      E194 := E194 + 1;
      E210 := E210 + 1;
      E222 := E222 + 1;
      E224 := E224 + 1;
      E241 := E241 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E229 := E229 + 1;
      Gdk.Color'Elab_Spec;
      E262 := E262 + 1;
      E250 := E250 + 1;
      E377 := E377 + 1;
      E239 := E239 + 1;
      Gdk.Device_Tool'Elab_Spec;
      Gdk.Device_Tool'Elab_Body;
      E237 := E237 + 1;
      Gdk.Drawing_Context'Elab_Spec;
      Gdk.Drawing_Context'Elab_Body;
      E331 := E331 + 1;
      E235 := E235 + 1;
      E276 := E276 + 1;
      Glib.Variant'Elab_Spec;
      Glib.Variant'Elab_Body;
      E274 := E274 + 1;
      E339 := E339 + 1;
      Gtk.Actionable'Elab_Spec;
      E411 := E411 + 1;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E280 := E280 + 1;
      E319 := E319 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E351 := E351 + 1;
      Gtk.Css_Section'Elab_Spec;
      Gtk.Css_Section'Elab_Body;
      E367 := E367 + 1;
      E256 := E256 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E550 := E550 + 1;
      Gtk.Orientable'Elab_Spec;
      E325 := E325 + 1;
      Gtk.Paper_Size'Elab_Spec;
      Gtk.Paper_Size'Elab_Body;
      E379 := E379 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E375 := E375 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E385 := E385 + 1;
      E554 := E554 + 1;
      E288 := E288 + 1;
      Gtk.Target_List'Elab_Spec;
      Gtk.Target_List'Elab_Body;
      E286 := E286 + 1;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E405 := E405 + 1;
      List_Exceptions'Elab_Spec;
      E510 := E510 + 1;
      E509 := E509 + 1;
      Mast_Analysis_Pixmaps'Elab_Spec;
      E543 := E543 + 1;
      E293 := E293 + 1;
      Pango.Attributes'Elab_Spec;
      Pango.Attributes'Elab_Body;
      E313 := E313 + 1;
      Pango.Font_Metrics'Elab_Spec;
      Pango.Font_Metrics'Elab_Body;
      E297 := E297 + 1;
      Pango.Language'Elab_Spec;
      Pango.Language'Elab_Body;
      E299 := E299 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E295 := E295 + 1;
      E391 := E391 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E393 := E393 + 1;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E303 := E303 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E301 := E301 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E305 := E305 + 1;
      E307 := E307 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E291 := E291 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E309 := E309 + 1;
      Pango.Tabs'Elab_Spec;
      Pango.Tabs'Elab_Body;
      E315 := E315 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E311 := E311 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E381 := E381 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Monitor'Elab_Spec;
      Gdk.Display'Elab_Spec;
      Gdk.Glcontext'Elab_Spec;
      Gdk.Glcontext'Elab_Body;
      E333 := E333 + 1;
      Gdk.Pixbuf'Elab_Spec;
      E268 := E268 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E246 := E246 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Window'Elab_Spec;
      E329 := E329 + 1;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Icon_Source'Elab_Spec;
      Gtk.Icon_Source'Elab_Body;
      E363 := E363 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E282 := E282 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Style'Elab_Spec;
      Gtk.Scrollable'Elab_Spec;
      E397 := E397 + 1;
      E389 := E389 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Gtk.Tree_Model'Elab_Spec;
      Gtk.Widget'Elab_Spec;
      Gtk.Cell_Renderer'Elab_Spec;
      E353 := E353 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E335 := E335 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E317 := E317 + 1;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E369 := E369 + 1;
      Gtk.Notebook'Elab_Spec;
      Gtk.Status_Bar'Elab_Spec;
      E258 := E258 + 1;
      Gtk.Settings'Elab_Spec;
      Gtk.Settings'Elab_Body;
      E254 := E254 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      Gtk.Icon_Set'Elab_Body;
      E361 := E361 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E359 := E359 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E403 := E403 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Window'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Gtk.Print_Operation'Elab_Spec;
      E220 := E220 + 1;
      Gdk.Device'Elab_Body;
      E231 := E231 + 1;
      Gdk.Display'Elab_Body;
      E233 := E233 + 1;
      Gdk.Drag_Contexts'Elab_Body;
      E227 := E227 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E264 := E264 + 1;
      Gdk.Monitor'Elab_Body;
      E244 := E244 + 1;
      E272 := E272 + 1;
      Gtk.Accel_Group'Elab_Body;
      E278 := E278 + 1;
      Gtk.Adjustment'Elab_Body;
      E323 := E323 + 1;
      Gtk.Cell_Area'Elab_Body;
      E349 := E349 + 1;
      E341 := E341 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E355 := E355 + 1;
      Gtk.Clipboard'Elab_Body;
      E401 := E401 + 1;
      Gtk.Container'Elab_Body;
      E321 := E321 + 1;
      Gtk.Dialog'Elab_Body;
      E252 := E252 + 1;
      E343 := E343 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E345 := E345 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E347 := E347 + 1;
      Gtk.Gentry'Elab_Body;
      E337 := E337 + 1;
      Gtk.Notebook'Elab_Body;
      E371 := E371 + 1;
      Gtk.Print_Operation'Elab_Body;
      E373 := E373 + 1;
      E383 := E383 + 1;
      Gtk.Status_Bar'Elab_Body;
      E387 := E387 + 1;
      Gtk.Style'Elab_Body;
      E284 := E284 + 1;
      Gtk.Style_Context'Elab_Body;
      E365 := E365 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E399 := E399 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E407 := E407 + 1;
      Gtk.Text_View'Elab_Body;
      E395 := E395 + 1;
      Gtk.Tree_Model'Elab_Body;
      E357 := E357 + 1;
      Gtk.Widget'Elab_Body;
      E260 := E260 + 1;
      Gtk.Window'Elab_Body;
      E327 := E327 + 1;
      Glib.Menu_Model'Elab_Spec;
      Glib.Menu_Model'Elab_Body;
      E452 := E452 + 1;
      Gtk.Action'Elab_Spec;
      Gtk.Action'Elab_Body;
      E409 := E409 + 1;
      Gtk.Activatable'Elab_Spec;
      E413 := E413 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E446 := E446 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Button'Elab_Body;
      E218 := E218 + 1;
      Gtk.File_Chooser'Elab_Spec;
      E548 := E548 + 1;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E552 := E552 + 1;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E527 := E527 + 1;
      Gtk.Grange'Elab_Spec;
      Gtk.Grange'Elab_Body;
      E466 := E466 + 1;
      E536 := E536 + 1;
      E437 := E437 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Menu_Item'Elab_Body;
      E454 := E454 + 1;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu_Shell'Elab_Body;
      E456 := E456 + 1;
      Gtk.Menu'Elab_Spec;
      Gtk.Menu'Elab_Body;
      E450 := E450 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Label'Elab_Body;
      E448 := E448 + 1;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E464 := E464 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Scrolled_Window'Elab_Body;
      E462 := E462 + 1;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E529 := E529 + 1;
      Gtk.Toggle_Button'Elab_Spec;
      Gtk.Toggle_Button'Elab_Body;
      E417 := E417 + 1;
      Gtk.Check_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Body;
      E415 := E415 + 1;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E425 := E425 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_Selection'Elab_Body;
      E427 := E427 + 1;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Body;
      E429 := E429 + 1;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Tree_View'Elab_Body;
      E423 := E423 + 1;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box'Elab_Body;
      E421 := E421 + 1;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E419 := E419 + 1;
      Callbacks_Gmast_Analysis'Elab_Spec;
      E180 := E180 + 1;
      Gtkada.Handlers'Elab_Spec;
      E444 := E444 + 1;
      Error_Inputfile_Pkg'Elab_Spec;
      E533 := E533 + 1;
      E531 := E531 + 1;
      Error_Window_Pkg'Elab_Spec;
      E439 := E439 + 1;
      E179 := E179 + 1;
      Help_Annealing_Pkg'Elab_Spec;
      E460 := E460 + 1;
      E458 := E458 + 1;
      Help_Hopa_Pkg'Elab_Spec;
      E525 := E525 + 1;
      E523 := E523 + 1;
      Help_Pkg'Elab_Spec;
      E540 := E540 + 1;
      E538 := E538 + 1;
      Var_Strings'Elab_Spec;
      E479 := E479 + 1;
      Mast'Elab_Spec;
      Mast'Elab_Body;
      E468 := E468 + 1;
      Mast.Tool_Exceptions'Elab_Spec;
      Mast.Tool_Exceptions'Elab_Body;
      E483 := E483 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E481 := E481 + 1;
      Mast.Hospa_Parameters'Elab_Body;
      E493 := E493 + 1;
      E491 := E491 + 1;
      Annealing_Window_Pkg'Elab_Spec;
      E175 := E175 + 1;
      Hopa_Window_Pkg'Elab_Spec;
      E517 := E517 + 1;
      E515 := E515 + 1;
      E177 := E177 + 1;
      E521 := E521 + 1;
      Mast_Analysis_Pkg'Elab_Spec;
      E545 := E545 + 1;
      E542 := E542 + 1;
      E557 := E557 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_gmast_analysis");

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
   --   /home/michael/prog/mast/gmast/src/gmast_analysis_intl.o
   --   /home/michael/prog/mast/gmast/src/list_exceptions.o
   --   /home/michael/prog/mast/gmast/src/dynamic_lists.o
   --   /home/michael/prog/mast/gmast/src/mast_analysis_pixmaps.o
   --   /home/michael/prog/mast/gmast/src/callbacks_gmast_analysis.o
   --   /home/michael/prog/mast/gmast/src/error_inputfile_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/error_inputfile_pkg.o
   --   /home/michael/prog/mast/gmast/src/error_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/error_window_pkg.o
   --   /home/michael/prog/mast/gmast/src/help_annealing_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/help_annealing_pkg.o
   --   /home/michael/prog/mast/gmast/src/help_hopa_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/help_hopa_pkg.o
   --   /home/michael/prog/mast/gmast/src/help_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/help_pkg.o
   --   /home/michael/prog/mast/gmast/src/var_strings.o
   --   /home/michael/prog/mast/gmast/src/check_spaces.o
   --   /home/michael/prog/mast/gmast/src/mast.o
   --   /home/michael/prog/mast/gmast/src/mast-tool_exceptions.o
   --   /home/michael/prog/mast/gmast/src/mast-annealing_parameters.o
   --   /home/michael/prog/mast/gmast/src/mast-hospa_parameters.o
   --   /home/michael/prog/mast/gmast/src/mast-sched_param_assignment_parameters.o
   --   /home/michael/prog/mast/gmast/src/annealing_window_pkg.o
   --   /home/michael/prog/mast/gmast/src/hopa_window_pkg.o
   --   /home/michael/prog/mast/gmast/src/parameters_handling.o
   --   /home/michael/prog/mast/gmast/src/annealing_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/hopa_window_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/mast_analysis_pkg-callbacks.o
   --   /home/michael/prog/mast/gmast/src/mast_analysis_pkg.o
   --   /home/michael/prog/mast/gmast/src/var_string_utils.o
   --   /home/michael/prog/mast/gmast/src/read_past_values.o
   --   /home/michael/prog/mast/gmast/src/gmast_analysis.o
   --   -L/home/michael/prog/mast/gmast/src/
   --   -L/home/michael/prog/mast/gmast/src/
   --   -L/home/michael/.local/share/alire/builds/gtkada_25.0.1_d3787772/97a94b98c977366ab88bcc61398b89819b47808c7bde0b5c0bf68da8797aaebd/src/lib/gtkada/static/
   --   -L/home/michael/.local/share/alire/toolchains/gnat_native_14.1.3_965c1e0e/lib/gcc/x86_64-pc-linux-gnu/14.1.0/adalib/
   --   -static
   --   -shared-libgcc
   --   -shared-libgcc
   --   -shared-libgcc
   --   -lgnat
   --   -ldl
--  END Object file/option list   

end ada_main;
