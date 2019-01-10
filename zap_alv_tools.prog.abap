data: gt_data     type zkbj_hcp_tt_fbcj.

class lcl_handle_events definition deferred.
data: _o_alv        type ref to cl_salv_table,
      go_events     type ref to lcl_handle_events,
      gt_rows       type salv_t_row.

*----------------------------------------------------------------------*
*       CLASS lcl_handle_events DEFINITION
*----------------------------------------------------------------------*
class lcl_handle_events definition.
  public section.
    methods:
      on_user_command for event added_function of cl_salv_events
        importing e_salv_function.
endclass.                    "lcl_handle_events DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_handle_events IMPLEMENTATION
*----------------------------------------------------------------------*
class lcl_handle_events implementation.
  method on_user_command.
    perform handle_user_command using e_salv_function.
  endmethod.                    "on_user_command
endclass.                    "lcl_handle_events IMPLEMENTATION
*&---------------------------------------------------------------------*
*&      Form  ALV_INIT
*&---------------------------------------------------------------------*
form alv_init.

  data lv_msg type ref to cx_salv_msg.

  try.
      cl_salv_table=>factory(
        importing
          r_salv_table = _o_alv
        changing
          t_table      = gt_data ).

      perform alv_layout_settings.
      perform optimize_column_width.
      perform set_toolbar.
      perform display_settings.
      perform add_buttons.
      perform set_selection_mode.
      perform events_register.

    catch cx_salv_msg into lv_msg.
      "error handling
  endtry.

endform.                    " ALV_INIT
*&---------------------------------------------------------------------*
*&      Form  ALV_DISP
*&---------------------------------------------------------------------*
form alv_disp.
  _o_alv->display( ).
endform.                    " ALV_DISP
*&---------------------------------------------------------------------*
*&      Form  alv_layout_settings
*&---------------------------------------------------------------------*
form alv_layout_settings.
*RESTRICT_NONE  User can save layouts without restriction
*RESTRICT_USER_DEPENDANT  User can save layouts for herself/himself
*RESTRICT_USER_INDEPENDANT  User can save layout for all users
  data: lo_layout         type ref to cl_salv_layout,
        ls_layout_key     type salv_s_layout_key.

  lo_layout = _o_alv->get_layout( ).
  ls_layout_key-report = sy-repid.
  lo_layout->set_key( ls_layout_key ).
  lo_layout->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).
endform.                    "alv_layout_settings
*&---------------------------------------------------------------------*
*&      Form  optimize_column_width
*&---------------------------------------------------------------------*
form optimize_column_width.
  data lo_columns     type ref to cl_salv_columns_table.
  lo_columns = _o_alv->get_columns( ).
  lo_columns->set_optimize( ).
endform.                    "OPTIMIZE_COLUMN_WIDTH
*&---------------------------------------------------------------------*
*&      Form  set_toolbar
*&---------------------------------------------------------------------*
form set_toolbar.
  data lo_functions type ref to cl_salv_functions_list.
  lo_functions = _o_alv->get_functions( ).
  lo_functions->set_all( ).
endform.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      Form  display_settings
*&---------------------------------------------------------------------*
form display_settings.
  data lo_display_settings type ref to cl_salv_display_settings.
  lo_display_settings = _o_alv->get_display_settings( ).
  lo_display_settings->set_striped_pattern( if_salv_c_bool_sap=>true ).
  lo_display_settings->set_list_header( sy-title ). "
endform.                    " DISPLAY_SETTINGS
*&---------------------------------------------------------------------*
*&      Form  ADD_BUTTONS
*&---------------------------------------------------------------------*
form add_buttons.
  _o_alv->set_screen_status(
    pfstatus      =  'SALV_STANDARD'
    report        =  sy-repid
    set_functions = _o_alv->c_functions_all ).
endform.                    " ADD_BUTTONS
*&---------------------------------------------------------------------*
*&      Form  SET_SELECTION_MODE
*&---------------------------------------------------------------------*
form set_selection_mode.
  data lo_selections type ref to cl_salv_selections.
  lo_selections = _o_alv->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>cell ). "multiple ).
endform.                    " SET_SELECTION_MODE
*&---------------------------------------------------------------------*
*&      Form  handle_user_command
*&---------------------------------------------------------------------*
form handle_user_command using i_ucomm type salv_de_function.
*  case i_ucomm.
*    when 'RUN'.
  perform get_selections.
  perform run.
*  endcase.
endform.                    "handle_user_command
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTIONS
*&---------------------------------------------------------------------*
form get_selections.
  data: lo_selections   type ref to cl_salv_selections.
  refresh gt_rows.
  lo_selections = _o_alv->get_selections( ).
  gt_rows = lo_selections->get_selected_rows( ).
endform.                    " GET_SELECTIONS
*&---------------------------------------------------------------------*
*&      Form  EVENTS_REGISTER
*&---------------------------------------------------------------------*
form events_register.
  data: lo_events     type ref to cl_salv_events_table.
  lo_events = _o_alv->get_event( ).
  create object go_events.
  set handler go_events->on_user_command for lo_events.
endform.                    " EVENTS_REGISTER
*&---------------------------------------------------------------------*
*&      Form  run
*&---------------------------------------------------------------------*
form run.

endform.                    "run
*&---------------------------------------------------------------------*
*&      Form  ALV_REFRESH
*&---------------------------------------------------------------------*
form alv_refresh.
  _o_alv->refresh( ).
endform.                    " ALV_REFRESH
