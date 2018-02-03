CLASS zcl_todo_swagger DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_extension .
    INTERFACES zif_swag_handler .

    METHODS create
      IMPORTING
        !is_data      TYPE ztodo_data
      RETURNING
        VALUE(rs_key) TYPE ztodo_key .
    METHODS delete
      IMPORTING
        !is_key TYPE ztodo_key .
    METHODS list
      RETURNING
        VALUE(rt_list) TYPE ztodo_tt .
    METHODS update
      IMPORTING
        !iv_guid TYPE ztodo_key-guid
        !is_data TYPE ztodo_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TODO_SWAGGER IMPLEMENTATION.


  METHOD create.

    DATA: lo_todo TYPE REF TO zcl_todo.

    CREATE OBJECT lo_todo.

    lo_todo->create( is_data ).

  ENDMETHOD.


  METHOD delete.

    DATA: lo_todo TYPE REF TO zcl_todo.

    CREATE OBJECT lo_todo.

    lo_todo->delete( is_key ).

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

    DATA: lo_todo TYPE REF TO zcl_todo.

    CREATE OBJECT lo_todo.

    rt_list = lo_todo->list( ).

  ENDMETHOD.


  METHOD update.

    DATA: lo_todo TYPE REF TO zcl_todo.

    CREATE OBJECT lo_todo.

    lo_todo->update(
      iv_guid = iv_guid
      is_data = is_data ).

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
