pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~gmast_analysis.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~gmast_analysis.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E076 : Short_Integer; pragma Import (Ada, E076, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E433 : Short_Integer; pragma Import (Ada, E433, "system__fat_flt_E");
   E377 : Short_Integer; pragma Import (Ada, E377, "system__fat_lflt_E");
   E380 : Short_Integer; pragma Import (Ada, E380, "system__fat_llf_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__exception_table_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "ada__io_exceptions_E");
   E392 : Short_Integer; pragma Import (Ada, E392, "ada__strings_E");
   E394 : Short_Integer; pragma Import (Ada, E394, "ada__strings__maps_E");
   E397 : Short_Integer; pragma Import (Ada, E397, "ada__strings__maps__constants_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "ada__tags_E");
   E060 : Short_Integer; pragma Import (Ada, E060, "ada__streams_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "interfaces__c_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "interfaces__c__strings_E");
   E021 : Short_Integer; pragma Import (Ada, E021, "system__exceptions_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "system__finalization_root_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__finalization_E");
   E089 : Short_Integer; pragma Import (Ada, E089, "system__storage_pools_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "system__finalization_masters_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "system__storage_pools__subpools_E");
   E478 : Short_Integer; pragma Import (Ada, E478, "ada__calendar_E");
   E484 : Short_Integer; pragma Import (Ada, E484, "ada__calendar__time_zones_E");
   E327 : Short_Integer; pragma Import (Ada, E327, "system__assertions_E");
   E091 : Short_Integer; pragma Import (Ada, E091, "system__pool_global_E");
   E079 : Short_Integer; pragma Import (Ada, E079, "system__file_control_block_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "system__file_io_E");
   E009 : Short_Integer; pragma Import (Ada, E009, "system__secondary_stack_E");
   E399 : Short_Integer; pragma Import (Ada, E399, "ada__strings__unbounded_E");
   E476 : Short_Integer; pragma Import (Ada, E476, "ada__directories_E");
   E490 : Short_Integer; pragma Import (Ada, E490, "system__regexp_E");
   E058 : Short_Integer; pragma Import (Ada, E058, "ada__text_io_E");
   E107 : Short_Integer; pragma Import (Ada, E107, "glib_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "gtkada__types_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "dynamic_lists_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "gdk__frame_timings_E");
   E132 : Short_Integer; pragma Import (Ada, E132, "glib__glist_E");
   E160 : Short_Integer; pragma Import (Ada, E160, "gdk__visual_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "glib__gslist_E");
   E277 : Short_Integer; pragma Import (Ada, E277, "glib__key_file_E");
   E113 : Short_Integer; pragma Import (Ada, E113, "glib__object_E");
   E299 : Short_Integer; pragma Import (Ada, E299, "glib__string_E");
   E115 : Short_Integer; pragma Import (Ada, E115, "glib__type_conversion_hooks_E");
   E124 : Short_Integer; pragma Import (Ada, E124, "glib__types_E");
   E233 : Short_Integer; pragma Import (Ada, E233, "glib__g_icon_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "glib__values_E");
   E140 : Short_Integer; pragma Import (Ada, E140, "cairo_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "cairo__region_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "gdk__color_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "gdk__rectangle_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "gdk__rgba_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "glib__generic_properties_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "gmast_analysis_intl_E");
   E237 : Short_Integer; pragma Import (Ada, E237, "gtk__editable_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "gtkada__c_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "gtkada__bindings_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gdk__frame_clock_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "gdk__types_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "gdk__event_E");
   E158 : Short_Integer; pragma Import (Ada, E158, "gdk__display_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "gdk__pixbuf_E");
   E162 : Short_Integer; pragma Import (Ada, E162, "glib__properties_E");
   E156 : Short_Integer; pragma Import (Ada, E156, "gdk__screen_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "gdk__device_E");
   E184 : Short_Integer; pragma Import (Ada, E184, "gdk__drag_contexts_E");
   E227 : Short_Integer; pragma Import (Ada, E227, "gdk__window_E");
   E297 : Short_Integer; pragma Import (Ada, E297, "glib__variant_E");
   E344 : Short_Integer; pragma Import (Ada, E344, "glib__menu_model_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "gtk__accel_group_E");
   E303 : Short_Integer; pragma Import (Ada, E303, "gtk__actionable_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "gtk__adjustment_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "gtk__builder_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "gtk__buildable_E");
   E245 : Short_Integer; pragma Import (Ada, E245, "gtk__cell_area_context_E");
   E235 : Short_Integer; pragma Import (Ada, E235, "gtk__cell_editable_E");
   E261 : Short_Integer; pragma Import (Ada, E261, "gtk__css_section_E");
   E239 : Short_Integer; pragma Import (Ada, E239, "gtk__entry_buffer_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "gtk__enums_E");
   E495 : Short_Integer; pragma Import (Ada, E495, "gtk__file_filter_E");
   E257 : Short_Integer; pragma Import (Ada, E257, "gtk__icon_source_E");
   E223 : Short_Integer; pragma Import (Ada, E223, "gtk__orientable_E");
   E279 : Short_Integer; pragma Import (Ada, E279, "gtk__paper_size_E");
   E275 : Short_Integer; pragma Import (Ada, E275, "gtk__page_setup_E");
   E287 : Short_Integer; pragma Import (Ada, E287, "gtk__print_settings_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "gtk__scrollable_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "gtk__selection_data_E");
   E499 : Short_Integer; pragma Import (Ada, E499, "gtk__stock_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "gtk__style_E");
   E269 : Short_Integer; pragma Import (Ada, E269, "gtk__target_entry_E");
   E267 : Short_Integer; pragma Import (Ada, E267, "gtk__target_list_E");
   E356 : Short_Integer; pragma Import (Ada, E356, "gtk__clipboard_E");
   E360 : Short_Integer; pragma Import (Ada, E360, "gtk__text_mark_E");
   E251 : Short_Integer; pragma Import (Ada, E251, "gtk__tree_model_E");
   E436 : Short_Integer; pragma Import (Ada, E436, "list_exceptions_E");
   E376 : Short_Integer; pragma Import (Ada, E376, "mast_E");
   E410 : Short_Integer; pragma Import (Ada, E410, "mast__annealing_parameters_E");
   E426 : Short_Integer; pragma Import (Ada, E426, "mast__hospa_parameters_E");
   E424 : Short_Integer; pragma Import (Ada, E424, "mast__sched_param_assignment_parameters_E");
   E412 : Short_Integer; pragma Import (Ada, E412, "mast__tool_exceptions_E");
   E472 : Short_Integer; pragma Import (Ada, E472, "mast_analysis_pixmaps_E");
   E201 : Short_Integer; pragma Import (Ada, E201, "pango__enums_E");
   E219 : Short_Integer; pragma Import (Ada, E219, "pango__attributes_E");
   E205 : Short_Integer; pragma Import (Ada, E205, "pango__font_metrics_E");
   E207 : Short_Integer; pragma Import (Ada, E207, "pango__language_E");
   E203 : Short_Integer; pragma Import (Ada, E203, "pango__font_E");
   E293 : Short_Integer; pragma Import (Ada, E293, "gtk__text_attributes_E");
   E295 : Short_Integer; pragma Import (Ada, E295, "gtk__text_tag_E");
   E291 : Short_Integer; pragma Import (Ada, E291, "gtk__text_iter_E");
   E362 : Short_Integer; pragma Import (Ada, E362, "gtk__text_tag_table_E");
   E211 : Short_Integer; pragma Import (Ada, E211, "pango__font_face_E");
   E209 : Short_Integer; pragma Import (Ada, E209, "pango__font_family_E");
   E213 : Short_Integer; pragma Import (Ada, E213, "pango__fontset_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "pango__matrix_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "pango__context_E");
   E283 : Short_Integer; pragma Import (Ada, E283, "pango__font_map_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "pango__tabs_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "pango__layout_E");
   E281 : Short_Integer; pragma Import (Ada, E281, "gtk__print_context_E");
   E285 : Short_Integer; pragma Import (Ada, E285, "gtk__print_operation_preview_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "gtk__widget_E");
   E301 : Short_Integer; pragma Import (Ada, E301, "gtk__action_E");
   E305 : Short_Integer; pragma Import (Ada, E305, "gtk__activatable_E");
   E249 : Short_Integer; pragma Import (Ada, E249, "gtk__cell_renderer_E");
   E247 : Short_Integer; pragma Import (Ada, E247, "gtk__cell_layout_E");
   E243 : Short_Integer; pragma Import (Ada, E243, "gtk__cell_area_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "gtk__container_E");
   E229 : Short_Integer; pragma Import (Ada, E229, "gtk__bin_E");
   E338 : Short_Integer; pragma Import (Ada, E338, "gtk__alignment_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "gtk__box_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "gtk__button_E");
   E241 : Short_Integer; pragma Import (Ada, E241, "gtk__entry_completion_E");
   E493 : Short_Integer; pragma Import (Ada, E493, "gtk__file_chooser_E");
   E456 : Short_Integer; pragma Import (Ada, E456, "gtk__frame_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "gtk__grange_E");
   E465 : Short_Integer; pragma Import (Ada, E465, "gtk__main_E");
   E329 : Short_Integer; pragma Import (Ada, E329, "gtk__marshallers_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "gtk__menu_item_E");
   E348 : Short_Integer; pragma Import (Ada, E348, "gtk__menu_shell_E");
   E342 : Short_Integer; pragma Import (Ada, E342, "gtk__menu_E");
   E265 : Short_Integer; pragma Import (Ada, E265, "gtk__misc_E");
   E340 : Short_Integer; pragma Import (Ada, E340, "gtk__label_E");
   E271 : Short_Integer; pragma Import (Ada, E271, "gtk__notebook_E");
   E370 : Short_Integer; pragma Import (Ada, E370, "gtk__scrollbar_E");
   E368 : Short_Integer; pragma Import (Ada, E368, "gtk__scrolled_window_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "gtk__status_bar_E");
   E263 : Short_Integer; pragma Import (Ada, E263, "gtk__style_provider_E");
   E259 : Short_Integer; pragma Import (Ada, E259, "gtk__style_context_E");
   E255 : Short_Integer; pragma Import (Ada, E255, "gtk__icon_set_E");
   E253 : Short_Integer; pragma Import (Ada, E253, "gtk__image_E");
   E231 : Short_Integer; pragma Import (Ada, E231, "gtk__gentry_E");
   E458 : Short_Integer; pragma Import (Ada, E458, "gtk__table_E");
   E358 : Short_Integer; pragma Import (Ada, E358, "gtk__text_child_anchor_E");
   E354 : Short_Integer; pragma Import (Ada, E354, "gtk__text_buffer_E");
   E374 : Short_Integer; pragma Import (Ada, E374, "gtk__text_view_E");
   E309 : Short_Integer; pragma Import (Ada, E309, "gtk__toggle_button_E");
   E307 : Short_Integer; pragma Import (Ada, E307, "gtk__check_button_E");
   E319 : Short_Integer; pragma Import (Ada, E319, "gtk__tooltip_E");
   E321 : Short_Integer; pragma Import (Ada, E321, "gtk__tree_selection_E");
   E323 : Short_Integer; pragma Import (Ada, E323, "gtk__tree_view_column_E");
   E315 : Short_Integer; pragma Import (Ada, E315, "gtk__tree_view_E");
   E313 : Short_Integer; pragma Import (Ada, E313, "gtk__combo_box_E");
   E311 : Short_Integer; pragma Import (Ada, E311, "gtk__combo_box_text_E");
   E225 : Short_Integer; pragma Import (Ada, E225, "gtk__window_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "annealing_window_pkg_E");
   E460 : Short_Integer; pragma Import (Ada, E460, "error_inputfile_pkg_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "error_window_pkg_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "gtk__dialog_E");
   E497 : Short_Integer; pragma Import (Ada, E497, "gtk__file_chooser_dialog_E");
   E273 : Short_Integer; pragma Import (Ada, E273, "gtk__print_operation_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "gtk__arguments_E");
   E101 : Short_Integer; pragma Import (Ada, E101, "annealing_window_pkg__callbacks_E");
   E462 : Short_Integer; pragma Import (Ada, E462, "error_inputfile_pkg__callbacks_E");
   E331 : Short_Integer; pragma Import (Ada, E331, "error_window_pkg__callbacks_E");
   E104 : Short_Integer; pragma Import (Ada, E104, "callbacks_gmast_analysis_E");
   E336 : Short_Integer; pragma Import (Ada, E336, "gtkada__handlers_E");
   E350 : Short_Integer; pragma Import (Ada, E350, "help_annealing_pkg_E");
   E364 : Short_Integer; pragma Import (Ada, E364, "help_annealing_pkg__callbacks_E");
   E452 : Short_Integer; pragma Import (Ada, E452, "help_hopa_pkg_E");
   E454 : Short_Integer; pragma Import (Ada, E454, "help_hopa_pkg__callbacks_E");
   E467 : Short_Integer; pragma Import (Ada, E467, "help_pkg_E");
   E469 : Short_Integer; pragma Import (Ada, E469, "help_pkg__callbacks_E");
   E446 : Short_Integer; pragma Import (Ada, E446, "hopa_window_pkg_E");
   E450 : Short_Integer; pragma Import (Ada, E450, "hopa_window_pkg__callbacks_E");
   E442 : Short_Integer; pragma Import (Ada, E442, "parameters_handling_E");
   E389 : Short_Integer; pragma Import (Ada, E389, "var_strings_E");
   E471 : Short_Integer; pragma Import (Ada, E471, "mast_analysis_pkg_E");
   E474 : Short_Integer; pragma Import (Ada, E474, "mast_analysis_pkg__callbacks_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E471 := E471 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "mast_analysis_pkg__finalize_spec");
      begin
         F1;
      end;
      E446 := E446 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "hopa_window_pkg__finalize_spec");
      begin
         F2;
      end;
      E467 := E467 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "help_pkg__finalize_spec");
      begin
         F3;
      end;
      E452 := E452 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "help_hopa_pkg__finalize_spec");
      begin
         F4;
      end;
      E350 := E350 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "help_annealing_pkg__finalize_spec");
      begin
         F5;
      end;
      E099 := E099 - 1;
      E460 := E460 - 1;
      E103 := E103 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "gtkada__handlers__finalize_spec");
      begin
         E336 := E336 - 1;
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "callbacks_gmast_analysis__finalize_spec");
      begin
         E104 := E104 - 1;
         F7;
      end;
      E186 := E186 - 1;
      E158 := E158 - 1;
      E344 := E344 - 1;
      E192 := E192 - 1;
      E174 := E174 - 1;
      E239 := E239 - 1;
      E196 := E196 - 1;
      E356 := E356 - 1;
      E251 := E251 - 1;
      E362 := E362 - 1;
      E178 := E178 - 1;
      E301 := E301 - 1;
      E249 := E249 - 1;
      E243 := E243 - 1;
      E172 := E172 - 1;
      E136 := E136 - 1;
      E241 := E241 - 1;
      E372 := E372 - 1;
      E346 := E346 - 1;
      E348 := E348 - 1;
      E342 := E342 - 1;
      E340 := E340 - 1;
      E271 := E271 - 1;
      E368 := E368 - 1;
      E289 := E289 - 1;
      E259 := E259 - 1;
      E231 := E231 - 1;
      E354 := E354 - 1;
      E374 := E374 - 1;
      E309 := E309 - 1;
      E321 := E321 - 1;
      E323 := E323 - 1;
      E315 := E315 - 1;
      E313 := E313 - 1;
      E225 := E225 - 1;
      E154 := E154 - 1;
      E273 := E273 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "gtk__print_operation__finalize_spec");
      begin
         F8;
      end;
      E497 := E497 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "gtk__file_chooser_dialog__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "gtk__dialog__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "error_window_pkg__finalize_spec");
      begin
         F11;
      end;
      declare
         procedure F12;
         pragma Import (Ada, F12, "error_inputfile_pkg__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "annealing_window_pkg__finalize_spec");
      begin
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "gtk__window__finalize_spec");
      begin
         F14;
      end;
      E311 := E311 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "gtk__combo_box_text__finalize_spec");
      begin
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "gtk__combo_box__finalize_spec");
      begin
         F16;
      end;
      declare
         procedure F17;
         pragma Import (Ada, F17, "gtk__tree_view__finalize_spec");
      begin
         F17;
      end;
      declare
         procedure F18;
         pragma Import (Ada, F18, "gtk__tree_view_column__finalize_spec");
      begin
         F18;
      end;
      declare
         procedure F19;
         pragma Import (Ada, F19, "gtk__tree_selection__finalize_spec");
      begin
         F19;
      end;
      E319 := E319 - 1;
      declare
         procedure F20;
         pragma Import (Ada, F20, "gtk__tooltip__finalize_spec");
      begin
         F20;
      end;
      E307 := E307 - 1;
      declare
         procedure F21;
         pragma Import (Ada, F21, "gtk__check_button__finalize_spec");
      begin
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "gtk__toggle_button__finalize_spec");
      begin
         F22;
      end;
      declare
         procedure F23;
         pragma Import (Ada, F23, "gtk__text_view__finalize_spec");
      begin
         F23;
      end;
      declare
         procedure F24;
         pragma Import (Ada, F24, "gtk__text_buffer__finalize_spec");
      begin
         F24;
      end;
      E358 := E358 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "gtk__text_child_anchor__finalize_spec");
      begin
         F25;
      end;
      E458 := E458 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "gtk__table__finalize_spec");
      begin
         F26;
      end;
      declare
         procedure F27;
         pragma Import (Ada, F27, "gtk__gentry__finalize_spec");
      begin
         F27;
      end;
      E253 := E253 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "gtk__image__finalize_spec");
      begin
         F28;
      end;
      E255 := E255 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "gtk__icon_set__finalize_spec");
      begin
         F29;
      end;
      declare
         procedure F30;
         pragma Import (Ada, F30, "gtk__style_context__finalize_spec");
      begin
         F30;
      end;
      declare
         procedure F31;
         pragma Import (Ada, F31, "gtk__status_bar__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "gtk__scrolled_window__finalize_spec");
      begin
         F32;
      end;
      E370 := E370 - 1;
      declare
         procedure F33;
         pragma Import (Ada, F33, "gtk__scrollbar__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "gtk__notebook__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "gtk__label__finalize_spec");
      begin
         F35;
      end;
      E265 := E265 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "gtk__misc__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "gtk__menu__finalize_spec");
      begin
         F37;
      end;
      declare
         procedure F38;
         pragma Import (Ada, F38, "gtk__menu_shell__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "gtk__menu_item__finalize_spec");
      begin
         F39;
      end;
      declare
         procedure F40;
         pragma Import (Ada, F40, "gtk__grange__finalize_spec");
      begin
         F40;
      end;
      E456 := E456 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "gtk__frame__finalize_spec");
      begin
         F41;
      end;
      declare
         procedure F42;
         pragma Import (Ada, F42, "gtk__entry_completion__finalize_spec");
      begin
         F42;
      end;
      declare
         procedure F43;
         pragma Import (Ada, F43, "gtk__button__finalize_spec");
      begin
         F43;
      end;
      E164 := E164 - 1;
      declare
         procedure F44;
         pragma Import (Ada, F44, "gtk__box__finalize_spec");
      begin
         F44;
      end;
      E338 := E338 - 1;
      declare
         procedure F45;
         pragma Import (Ada, F45, "gtk__alignment__finalize_spec");
      begin
         F45;
      end;
      E229 := E229 - 1;
      declare
         procedure F46;
         pragma Import (Ada, F46, "gtk__bin__finalize_spec");
      begin
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "gtk__container__finalize_spec");
      begin
         F47;
      end;
      declare
         procedure F48;
         pragma Import (Ada, F48, "gtk__cell_area__finalize_spec");
      begin
         F48;
      end;
      declare
         procedure F49;
         pragma Import (Ada, F49, "gtk__cell_renderer__finalize_spec");
      begin
         F49;
      end;
      declare
         procedure F50;
         pragma Import (Ada, F50, "gtk__action__finalize_spec");
      begin
         F50;
      end;
      declare
         procedure F51;
         pragma Import (Ada, F51, "gtk__widget__finalize_spec");
      begin
         F51;
      end;
      E281 := E281 - 1;
      declare
         procedure F52;
         pragma Import (Ada, F52, "gtk__print_context__finalize_spec");
      begin
         F52;
      end;
      E217 := E217 - 1;
      declare
         procedure F53;
         pragma Import (Ada, F53, "pango__layout__finalize_spec");
      begin
         F53;
      end;
      E221 := E221 - 1;
      declare
         procedure F54;
         pragma Import (Ada, F54, "pango__tabs__finalize_spec");
      begin
         F54;
      end;
      E283 := E283 - 1;
      declare
         procedure F55;
         pragma Import (Ada, F55, "pango__font_map__finalize_spec");
      begin
         F55;
      end;
      E199 := E199 - 1;
      declare
         procedure F56;
         pragma Import (Ada, F56, "pango__context__finalize_spec");
      begin
         F56;
      end;
      E213 := E213 - 1;
      declare
         procedure F57;
         pragma Import (Ada, F57, "pango__fontset__finalize_spec");
      begin
         F57;
      end;
      E209 := E209 - 1;
      declare
         procedure F58;
         pragma Import (Ada, F58, "pango__font_family__finalize_spec");
      begin
         F58;
      end;
      E211 := E211 - 1;
      declare
         procedure F59;
         pragma Import (Ada, F59, "pango__font_face__finalize_spec");
      begin
         F59;
      end;
      declare
         procedure F60;
         pragma Import (Ada, F60, "gtk__text_tag_table__finalize_spec");
      begin
         F60;
      end;
      E295 := E295 - 1;
      declare
         procedure F61;
         pragma Import (Ada, F61, "gtk__text_tag__finalize_spec");
      begin
         F61;
      end;
      E203 := E203 - 1;
      declare
         procedure F62;
         pragma Import (Ada, F62, "pango__font__finalize_spec");
      begin
         F62;
      end;
      E207 := E207 - 1;
      declare
         procedure F63;
         pragma Import (Ada, F63, "pango__language__finalize_spec");
      begin
         F63;
      end;
      E205 := E205 - 1;
      declare
         procedure F64;
         pragma Import (Ada, F64, "pango__font_metrics__finalize_spec");
      begin
         F64;
      end;
      E219 := E219 - 1;
      declare
         procedure F65;
         pragma Import (Ada, F65, "pango__attributes__finalize_spec");
      begin
         F65;
      end;
      declare
         procedure F66;
         pragma Import (Ada, F66, "gtk__tree_model__finalize_spec");
      begin
         F66;
      end;
      E360 := E360 - 1;
      declare
         procedure F67;
         pragma Import (Ada, F67, "gtk__text_mark__finalize_spec");
      begin
         F67;
      end;
      declare
         procedure F68;
         pragma Import (Ada, F68, "gtk__clipboard__finalize_spec");
      begin
         F68;
      end;
      E267 := E267 - 1;
      declare
         procedure F69;
         pragma Import (Ada, F69, "gtk__target_list__finalize_spec");
      begin
         F69;
      end;
      declare
         procedure F70;
         pragma Import (Ada, F70, "gtk__style__finalize_spec");
      begin
         F70;
      end;
      E194 := E194 - 1;
      declare
         procedure F71;
         pragma Import (Ada, F71, "gtk__selection_data__finalize_spec");
      begin
         F71;
      end;
      E287 := E287 - 1;
      declare
         procedure F72;
         pragma Import (Ada, F72, "gtk__print_settings__finalize_spec");
      begin
         F72;
      end;
      E275 := E275 - 1;
      declare
         procedure F73;
         pragma Import (Ada, F73, "gtk__page_setup__finalize_spec");
      begin
         F73;
      end;
      E279 := E279 - 1;
      declare
         procedure F74;
         pragma Import (Ada, F74, "gtk__paper_size__finalize_spec");
      begin
         F74;
      end;
      E257 := E257 - 1;
      declare
         procedure F75;
         pragma Import (Ada, F75, "gtk__icon_source__finalize_spec");
      begin
         F75;
      end;
      E495 := E495 - 1;
      declare
         procedure F76;
         pragma Import (Ada, F76, "gtk__file_filter__finalize_spec");
      begin
         F76;
      end;
      declare
         procedure F77;
         pragma Import (Ada, F77, "gtk__entry_buffer__finalize_spec");
      begin
         F77;
      end;
      E261 := E261 - 1;
      declare
         procedure F78;
         pragma Import (Ada, F78, "gtk__css_section__finalize_spec");
      begin
         F78;
      end;
      E245 := E245 - 1;
      declare
         procedure F79;
         pragma Import (Ada, F79, "gtk__cell_area_context__finalize_spec");
      begin
         F79;
      end;
      E168 := E168 - 1;
      declare
         procedure F80;
         pragma Import (Ada, F80, "gtk__builder__finalize_spec");
      begin
         F80;
      end;
      declare
         procedure F81;
         pragma Import (Ada, F81, "gtk__adjustment__finalize_spec");
      begin
         F81;
      end;
      declare
         procedure F82;
         pragma Import (Ada, F82, "gtk__accel_group__finalize_spec");
      begin
         F82;
      end;
      declare
         procedure F83;
         pragma Import (Ada, F83, "glib__menu_model__finalize_spec");
      begin
         F83;
      end;
      E297 := E297 - 1;
      declare
         procedure F84;
         pragma Import (Ada, F84, "glib__variant__finalize_spec");
      begin
         F84;
      end;
      E184 := E184 - 1;
      declare
         procedure F85;
         pragma Import (Ada, F85, "gdk__drag_contexts__finalize_spec");
      begin
         F85;
      end;
      E182 := E182 - 1;
      declare
         procedure F86;
         pragma Import (Ada, F86, "gdk__device__finalize_spec");
      begin
         F86;
      end;
      E156 := E156 - 1;
      declare
         procedure F87;
         pragma Import (Ada, F87, "gdk__screen__finalize_spec");
      begin
         F87;
      end;
      E190 := E190 - 1;
      declare
         procedure F88;
         pragma Import (Ada, F88, "gdk__pixbuf__finalize_spec");
      begin
         F88;
      end;
      declare
         procedure F89;
         pragma Import (Ada, F89, "gdk__display__finalize_spec");
      begin
         F89;
      end;
      declare
         procedure F90;
         pragma Import (Ada, F90, "gdk__frame_clock__finalize_spec");
      begin
         F90;
      end;
      E113 := E113 - 1;
      declare
         procedure F91;
         pragma Import (Ada, F91, "glib__object__finalize_spec");
      begin
         F91;
      end;
      E188 := E188 - 1;
      declare
         procedure F92;
         pragma Import (Ada, F92, "gdk__frame_timings__finalize_spec");
      begin
         F92;
      end;
      E107 := E107 - 1;
      declare
         procedure F93;
         pragma Import (Ada, F93, "glib__finalize_spec");
      begin
         F93;
      end;
      E058 := E058 - 1;
      declare
         procedure F94;
         pragma Import (Ada, F94, "ada__text_io__finalize_spec");
      begin
         F94;
      end;
      E476 := E476 - 1;
      E490 := E490 - 1;
      declare
         procedure F95;
         pragma Import (Ada, F95, "system__regexp__finalize_spec");
      begin
         F95;
      end;
      declare
         procedure F96;
         pragma Import (Ada, F96, "ada__directories__finalize_spec");
      begin
         F96;
      end;
      E399 := E399 - 1;
      declare
         procedure F97;
         pragma Import (Ada, F97, "ada__strings__unbounded__finalize_spec");
      begin
         F97;
      end;
      E081 := E081 - 1;
      E095 := E095 - 1;
      declare
         procedure F98;
         pragma Import (Ada, F98, "system__file_io__finalize_body");
      begin
         E066 := E066 - 1;
         F98;
      end;
      declare
         procedure F99;
         pragma Import (Ada, F99, "system__file_control_block__finalize_spec");
      begin
         E079 := E079 - 1;
         F99;
      end;
      E091 := E091 - 1;
      declare
         procedure F100;
         pragma Import (Ada, F100, "system__pool_global__finalize_spec");
      begin
         F100;
      end;
      declare
         procedure F101;
         pragma Import (Ada, F101, "system__storage_pools__subpools__finalize_spec");
      begin
         F101;
      end;
      declare
         procedure F102;
         pragma Import (Ada, F102, "system__finalization_masters__finalize_spec");
      begin
         F102;
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
      E433 := E433 + 1;
      System.Fat_Lflt'Elab_Spec;
      E377 := E377 + 1;
      System.Fat_Llf'Elab_Spec;
      E380 := E380 + 1;
      System.Exception_Table'Elab_Body;
      E019 := E019 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E061 := E061 + 1;
      Ada.Strings'Elab_Spec;
      E392 := E392 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E397 := E397 + 1;
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
      E478 := E478 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E484 := E484 + 1;
      System.Assertions'Elab_Spec;
      E327 := E327 + 1;
      System.Pool_Global'Elab_Spec;
      E091 := E091 + 1;
      System.File_Control_Block'Elab_Spec;
      E079 := E079 + 1;
      System.File_Io'Elab_Body;
      E066 := E066 + 1;
      E095 := E095 + 1;
      System.Finalization_Masters'Elab_Body;
      E081 := E081 + 1;
      E109 := E109 + 1;
      E072 := E072 + 1;
      Ada.Tags'Elab_Body;
      E045 := E045 + 1;
      E394 := E394 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E076 := E076 + 1;
      System.Secondary_Stack'Elab_Body;
      E009 := E009 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E399 := E399 + 1;
      Ada.Directories'Elab_Spec;
      System.Regexp'Elab_Spec;
      E490 := E490 + 1;
      Ada.Directories'Elab_Body;
      E476 := E476 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E058 := E058 + 1;
      Glib'Elab_Spec;
      E107 := E107 + 1;
      Gtkada.Types'Elab_Spec;
      E130 := E130 + 1;
      Gdk.Frame_Timings'Elab_Spec;
      E188 := E188 + 1;
      E132 := E132 + 1;
      Gdk.Visual'Elab_Spec;
      Gdk.Visual'Elab_Body;
      E160 := E160 + 1;
      E134 := E134 + 1;
      Glib.Object'Elab_Spec;
      E115 := E115 + 1;
      Glib.Values'Elab_Body;
      E126 := E126 + 1;
      E140 := E140 + 1;
      E142 := E142 + 1;
      Gdk.Color'Elab_Spec;
      E147 := E147 + 1;
      Glib.Generic_Properties'Elab_Spec;
      Glib.Generic_Properties'Elab_Body;
      E150 := E150 + 1;
      E333 := E333 + 1;
      E128 := E128 + 1;
      Gtkada.Bindings'Elab_Spec;
      E118 := E118 + 1;
      E233 := E233 + 1;
      E124 := E124 + 1;
      E299 := E299 + 1;
      Glib.Object'Elab_Body;
      E113 := E113 + 1;
      Gdk.Rgba'Elab_Body;
      E152 := E152 + 1;
      Gdk.Color'Elab_Body;
      E180 := E180 + 1;
      E277 := E277 + 1;
      Gdk.Frame_Clock'Elab_Spec;
      Gdk.Types'Elab_Spec;
      E148 := E148 + 1;
      Gdk.Event'Elab_Spec;
      E145 := E145 + 1;
      Gdk.Display'Elab_Spec;
      Gdk.Pixbuf'Elab_Spec;
      E190 := E190 + 1;
      Glib.Properties'Elab_Spec;
      E162 := E162 + 1;
      Gdk.Screen'Elab_Spec;
      Gdk.Screen'Elab_Body;
      E156 := E156 + 1;
      Gdk.Device'Elab_Spec;
      Gdk.Device'Elab_Body;
      E182 := E182 + 1;
      Gdk.Drag_Contexts'Elab_Spec;
      Gdk.Drag_Contexts'Elab_Body;
      E184 := E184 + 1;
      Gdk.Window'Elab_Spec;
      E227 := E227 + 1;
      Glib.Variant'Elab_Spec;
      E297 := E297 + 1;
      Glib.Menu_Model'Elab_Spec;
      Gtk.Accel_Group'Elab_Spec;
      Gtk.Actionable'Elab_Spec;
      E303 := E303 + 1;
      Gtk.Adjustment'Elab_Spec;
      Gtk.Builder'Elab_Spec;
      Gtk.Builder'Elab_Body;
      E168 := E168 + 1;
      E166 := E166 + 1;
      Gtk.Cell_Area_Context'Elab_Spec;
      Gtk.Cell_Area_Context'Elab_Body;
      E245 := E245 + 1;
      Gtk.Cell_Editable'Elab_Spec;
      Gtk.Css_Section'Elab_Spec;
      E261 := E261 + 1;
      Gtk.Entry_Buffer'Elab_Spec;
      Gtk.Enums'Elab_Spec;
      E176 := E176 + 1;
      Gtk.File_Filter'Elab_Spec;
      Gtk.File_Filter'Elab_Body;
      E495 := E495 + 1;
      Gtk.Icon_Source'Elab_Spec;
      E257 := E257 + 1;
      Gtk.Orientable'Elab_Spec;
      E223 := E223 + 1;
      Gtk.Paper_Size'Elab_Spec;
      E279 := E279 + 1;
      Gtk.Page_Setup'Elab_Spec;
      Gtk.Page_Setup'Elab_Body;
      E275 := E275 + 1;
      Gtk.Print_Settings'Elab_Spec;
      Gtk.Print_Settings'Elab_Body;
      E287 := E287 + 1;
      Gtk.Scrollable'Elab_Spec;
      E317 := E317 + 1;
      Gtk.Selection_Data'Elab_Spec;
      Gtk.Selection_Data'Elab_Body;
      E194 := E194 + 1;
      E499 := E499 + 1;
      Gtk.Style'Elab_Spec;
      E269 := E269 + 1;
      Gtk.Target_List'Elab_Spec;
      E267 := E267 + 1;
      Gtk.Clipboard'Elab_Spec;
      Gtk.Text_Mark'Elab_Spec;
      Gtk.Text_Mark'Elab_Body;
      E360 := E360 + 1;
      Gtk.Tree_Model'Elab_Spec;
      List_Exceptions'Elab_Spec;
      E436 := E436 + 1;
      E435 := E435 + 1;
      Mast'Elab_Spec;
      MAST.TOOL_EXCEPTIONS'ELAB_SPEC;
      E424 := E424 + 1;
      Mast.Hospa_Parameters'Elab_Body;
      E426 := E426 + 1;
      Mast.Annealing_Parameters'Elab_Body;
      E410 := E410 + 1;
      Mast_Analysis_Pixmaps'Elab_Spec;
      E472 := E472 + 1;
      Pango.Enums'Elab_Spec;
      E201 := E201 + 1;
      Pango.Attributes'Elab_Spec;
      E219 := E219 + 1;
      Pango.Font_Metrics'Elab_Spec;
      E205 := E205 + 1;
      Pango.Language'Elab_Spec;
      E207 := E207 + 1;
      Pango.Font'Elab_Spec;
      Pango.Font'Elab_Body;
      E203 := E203 + 1;
      E293 := E293 + 1;
      Gtk.Text_Tag'Elab_Spec;
      Gtk.Text_Tag'Elab_Body;
      E295 := E295 + 1;
      Gtk.Text_Iter'Elab_Spec;
      E291 := E291 + 1;
      Gtk.Text_Tag_Table'Elab_Spec;
      Pango.Font_Face'Elab_Spec;
      Pango.Font_Face'Elab_Body;
      E211 := E211 + 1;
      Pango.Font_Family'Elab_Spec;
      Pango.Font_Family'Elab_Body;
      E209 := E209 + 1;
      Pango.Fontset'Elab_Spec;
      Pango.Fontset'Elab_Body;
      E213 := E213 + 1;
      E215 := E215 + 1;
      Pango.Context'Elab_Spec;
      Pango.Context'Elab_Body;
      E199 := E199 + 1;
      Pango.Font_Map'Elab_Spec;
      Pango.Font_Map'Elab_Body;
      E283 := E283 + 1;
      Pango.Tabs'Elab_Spec;
      E221 := E221 + 1;
      Pango.Layout'Elab_Spec;
      Pango.Layout'Elab_Body;
      E217 := E217 + 1;
      Gtk.Print_Context'Elab_Spec;
      Gtk.Print_Context'Elab_Body;
      E281 := E281 + 1;
      Gtk.Widget'Elab_Spec;
      Gtk.Action'Elab_Spec;
      Gtk.Activatable'Elab_Spec;
      E305 := E305 + 1;
      Gtk.Cell_Renderer'Elab_Spec;
      E247 := E247 + 1;
      Gtk.Cell_Area'Elab_Spec;
      Gtk.Container'Elab_Spec;
      Gtk.Bin'Elab_Spec;
      Gtk.Bin'Elab_Body;
      E229 := E229 + 1;
      Gtk.Alignment'Elab_Spec;
      Gtk.Alignment'Elab_Body;
      E338 := E338 + 1;
      Gtk.Box'Elab_Spec;
      Gtk.Box'Elab_Body;
      E164 := E164 + 1;
      Gtk.Button'Elab_Spec;
      Gtk.Entry_Completion'Elab_Spec;
      Gtk.File_Chooser'Elab_Spec;
      Gtk.Frame'Elab_Spec;
      Gtk.Frame'Elab_Body;
      E456 := E456 + 1;
      Gtk.Grange'Elab_Spec;
      E465 := E465 + 1;
      E329 := E329 + 1;
      Gtk.Menu_Item'Elab_Spec;
      Gtk.Menu_Shell'Elab_Spec;
      Gtk.Menu'Elab_Spec;
      Gtk.Misc'Elab_Spec;
      Gtk.Misc'Elab_Body;
      E265 := E265 + 1;
      Gtk.Label'Elab_Spec;
      Gtk.Notebook'Elab_Spec;
      Gtk.Scrollbar'Elab_Spec;
      Gtk.Scrollbar'Elab_Body;
      E370 := E370 + 1;
      Gtk.Scrolled_Window'Elab_Spec;
      Gtk.Status_Bar'Elab_Spec;
      E263 := E263 + 1;
      Gtk.Style_Context'Elab_Spec;
      Gtk.Icon_Set'Elab_Spec;
      E255 := E255 + 1;
      Gtk.Image'Elab_Spec;
      Gtk.Image'Elab_Body;
      E253 := E253 + 1;
      Gtk.Gentry'Elab_Spec;
      Gtk.Table'Elab_Spec;
      Gtk.Table'Elab_Body;
      E458 := E458 + 1;
      Gtk.Text_Child_Anchor'Elab_Spec;
      Gtk.Text_Child_Anchor'Elab_Body;
      E358 := E358 + 1;
      Gtk.Text_Buffer'Elab_Spec;
      Gtk.Text_View'Elab_Spec;
      Gtk.Toggle_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Spec;
      Gtk.Check_Button'Elab_Body;
      E307 := E307 + 1;
      Gtk.Tooltip'Elab_Spec;
      Gtk.Tooltip'Elab_Body;
      E319 := E319 + 1;
      Gtk.Tree_Selection'Elab_Spec;
      Gtk.Tree_View_Column'Elab_Spec;
      Gtk.Tree_View'Elab_Spec;
      Gtk.Combo_Box'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Spec;
      Gtk.Combo_Box_Text'Elab_Body;
      E311 := E311 + 1;
      Gtk.Window'Elab_Spec;
      Annealing_Window_Pkg'Elab_Spec;
      Error_Inputfile_Pkg'Elab_Spec;
      Error_Window_Pkg'Elab_Spec;
      Gtk.Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Spec;
      Gtk.File_Chooser_Dialog'Elab_Body;
      E497 := E497 + 1;
      Gtk.Print_Operation'Elab_Spec;
      Gtk.Arguments'Elab_Spec;
      E138 := E138 + 1;
      Gtk.Print_Operation'Elab_Body;
      E273 := E273 + 1;
      Gtk.Dialog'Elab_Body;
      E154 := E154 + 1;
      Gtk.Window'Elab_Body;
      E225 := E225 + 1;
      Gtk.Combo_Box'Elab_Body;
      E313 := E313 + 1;
      Gtk.Tree_View'Elab_Body;
      E315 := E315 + 1;
      Gtk.Tree_View_Column'Elab_Body;
      E323 := E323 + 1;
      Gtk.Tree_Selection'Elab_Body;
      E321 := E321 + 1;
      Gtk.Toggle_Button'Elab_Body;
      E309 := E309 + 1;
      Gtk.Text_View'Elab_Body;
      E374 := E374 + 1;
      Gtk.Text_Buffer'Elab_Body;
      E354 := E354 + 1;
      Gtk.Gentry'Elab_Body;
      E231 := E231 + 1;
      Gtk.Style_Context'Elab_Body;
      E259 := E259 + 1;
      Gtk.Status_Bar'Elab_Body;
      E289 := E289 + 1;
      Gtk.Scrolled_Window'Elab_Body;
      E368 := E368 + 1;
      Gtk.Notebook'Elab_Body;
      E271 := E271 + 1;
      Gtk.Label'Elab_Body;
      E340 := E340 + 1;
      Gtk.Menu'Elab_Body;
      E342 := E342 + 1;
      Gtk.Menu_Shell'Elab_Body;
      E348 := E348 + 1;
      Gtk.Menu_Item'Elab_Body;
      E346 := E346 + 1;
      Gtk.Grange'Elab_Body;
      E372 := E372 + 1;
      E493 := E493 + 1;
      Gtk.Entry_Completion'Elab_Body;
      E241 := E241 + 1;
      Gtk.Button'Elab_Body;
      E136 := E136 + 1;
      Gtk.Container'Elab_Body;
      E172 := E172 + 1;
      Gtk.Cell_Area'Elab_Body;
      E243 := E243 + 1;
      Gtk.Cell_Renderer'Elab_Body;
      E249 := E249 + 1;
      Gtk.Action'Elab_Body;
      E301 := E301 + 1;
      Gtk.Widget'Elab_Body;
      E178 := E178 + 1;
      E285 := E285 + 1;
      Gtk.Text_Tag_Table'Elab_Body;
      E362 := E362 + 1;
      E251 := E251 + 1;
      Gtk.Clipboard'Elab_Body;
      E356 := E356 + 1;
      Gtk.Style'Elab_Body;
      E196 := E196 + 1;
      Gtk.Entry_Buffer'Elab_Body;
      E239 := E239 + 1;
      E235 := E235 + 1;
      Gtk.Adjustment'Elab_Body;
      E174 := E174 + 1;
      Gtk.Accel_Group'Elab_Body;
      E192 := E192 + 1;
      Glib.Menu_Model'Elab_Body;
      E344 := E344 + 1;
      Gdk.Display'Elab_Body;
      E158 := E158 + 1;
      Gdk.Frame_Clock'Elab_Body;
      E186 := E186 + 1;
      E237 := E237 + 1;
      E462 := E462 + 1;
      E331 := E331 + 1;
      Callbacks_Gmast_Analysis'Elab_Spec;
      E104 := E104 + 1;
      Gtkada.Handlers'Elab_Spec;
      E336 := E336 + 1;
      E103 := E103 + 1;
      E460 := E460 + 1;
      E099 := E099 + 1;
      Help_Annealing_Pkg'Elab_Spec;
      E364 := E364 + 1;
      E350 := E350 + 1;
      Help_Hopa_Pkg'Elab_Spec;
      E454 := E454 + 1;
      E452 := E452 + 1;
      Help_Pkg'Elab_Spec;
      E469 := E469 + 1;
      E467 := E467 + 1;
      Hopa_Window_Pkg'Elab_Spec;
      E446 := E446 + 1;
      E450 := E450 + 1;
      E101 := E101 + 1;
      Var_Strings'Elab_Spec;
      E389 := E389 + 1;
      E442 := E442 + 1;
      MAST.TOOL_EXCEPTIONS'ELAB_BODY;
      E412 := E412 + 1;
      Mast'Elab_Body;
      E376 := E376 + 1;
      Mast_Analysis_Pkg'Elab_Spec;
      E474 := E474 + 1;
      E471 := E471 + 1;
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
   --   ./gmast_analysis_intl.o
   --   ../../mast_analysis/list_exceptions.o
   --   ../../mast_analysis/dynamic_lists.o
   --   ./mast-sched_param_assignment_parameters.o
   --   ./mast-hospa_parameters.o
   --   ../../mast_analysis/mast-annealing_parameters.o
   --   ./mast_analysis_pixmaps.o
   --   ./error_inputfile_pkg-callbacks.o
   --   ./error_window_pkg-callbacks.o
   --   ./callbacks_gmast_analysis.o
   --   ./error_window_pkg.o
   --   ./error_inputfile_pkg.o
   --   ./annealing_window_pkg.o
   --   ./help_annealing_pkg-callbacks.o
   --   ./help_annealing_pkg.o
   --   ./help_hopa_pkg-callbacks.o
   --   ./help_hopa_pkg.o
   --   ./help_pkg-callbacks.o
   --   ./help_pkg.o
   --   ./hopa_window_pkg.o
   --   ./hopa_window_pkg-callbacks.o
   --   ./annealing_window_pkg-callbacks.o
   --   ../../mast_analysis/var_strings.o
   --   ./parameters_handling.o
   --   ../../mast_analysis/mast-tool_exceptions.o
   --   ../../mast_analysis/mast.o
   --   ./check_spaces.o
   --   ./read_past_values.o
   --   ./gmast_analysis.o
   --   ./mast_analysis_pkg-callbacks.o
   --   ./mast_analysis_pkg.o
   --   -L./
   --   -L../../mast_analysis/
   --   -L../../utils/
   --   -L/home/mgh/gnat2014/gtkada/lib/gtkada/relocatable/
   --   -L/home/mgh/gnat2014/lib/gcc/i686-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
