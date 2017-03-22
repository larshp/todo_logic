class ZCL_TODO definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
  interfaces ZIF_SWAG_HANDLER .

  methods CREATE
    importing
      !IS_DATA type ZTODO_DATA
    returning
      value(RS_KEY) type ZTODO_KEY .
  methods DELETE
    importing
      !IS_KEY type ZTODO_KEY .
  methods LIST
    returning
      value(RT_LIST) type ZTODO_TT .
  methods UPDATE
    importing
      !IV_GUID type ZTODO_KEY-GUID
      !IS_DATA type ZTODO_DATA .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TODO IMPLEMENTATION.


  METHOD create.

    DATA: ls_todo TYPE ztodo.


    TRY.
        rs_key-guid = cl_system_uuid=>if_system_uuid_static~create_uuid_c22( ).
      CATCH cx_uuid_error.
        ASSERT 0 = 1.
    ENDTRY.

    MOVE-CORRESPONDING rs_key TO ls_todo.
    MOVE-CORRESPONDING is_data TO ls_todo.

    INSERT ztodo FROM ls_todo.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD delete.

    DELETE FROM ztodo WHERE guid = is_key-guid.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD if_http_extension~handle_request.

    DATA: lo_swag TYPE REF TO zcl_swag.


    CREATE OBJECT lo_swag
      EXPORTING
        ii_server = server
        iv_base   = '/sap/ztodo/rest'
        iv_title  = 'todo'.
    lo_swag->register( me ).

    lo_swag->run( ).

  ENDMETHOD.


  METHOD list.

    SELECT * FROM ztodo INTO TABLE rt_list.             "#EC CI_NOWHERE

  ENDMETHOD.


  METHOD update.

    DATA: ls_todo TYPE ztodo.


    ls_todo-guid = iv_guid.
    MOVE-CORRESPONDING is_data TO ls_todo.

    UPDATE ztodo FROM ls_todo.
    ASSERT sy-subrc = 0.

  ENDMETHOD.


  METHOD zif_swag_handler~meta.

    FIELD-SYMBOLS: <ls_meta> LIKE LINE OF rt_meta.


    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'List'(001).
    <ls_meta>-url-regex = '/list$'.
    <ls_meta>-method    = zcl_swag=>c_method-get.
    <ls_meta>-handler   = 'LIST'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'Create'(002).
    <ls_meta>-url-regex = '/create$'.
    <ls_meta>-method    = zcl_swag=>c_method-post.
    <ls_meta>-handler   = 'CREATE'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'Delete'(003).
    <ls_meta>-url-regex = '/delete$'.
    <ls_meta>-method    = zcl_swag=>c_method-post.
    <ls_meta>-handler   = 'DELETE'.

    APPEND INITIAL LINE TO rt_meta ASSIGNING <ls_meta>.
    <ls_meta>-summary   = 'Update'(004).
    <ls_meta>-url-regex = '/update/(w+)$'.
    APPEND 'IV_GUID' TO <ls_meta>-url-group_names.
    <ls_meta>-method    = zcl_swag=>c_method-post.
    <ls_meta>-handler   = 'UPDATE'.

  ENDMETHOD.
ENDCLASS.
