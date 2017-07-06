************************************************************************
* KBJ S.A. All rights reserved.
* author: APRZEDPELSKI.
* email:  sy-email.
* date:   20170706.
************************************************************************
data: gt_data     type table of sflights.
data: _o_alv      type ref to cl_salv_table.


*&---------------------------------------------------------------------*
*&      Form  alv_init
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
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
  data: lo_layout         type ref to cl_salv_layout,
        ls_layout_key     type salv_s_layout_key.

  lo_layout = _o_alv->get_layout( ).

  ls_layout_key-report = sy-repid.
  lo_layout->set_key( ls_layout_key ).

*RESTRICT_NONE  User can save layouts without restriction
*RESTRICT_USER_DEPENDANT  User can save layouts for herself/himself
*RESTRICT_USER_INDEPENDANT  User can save layout for all users
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
