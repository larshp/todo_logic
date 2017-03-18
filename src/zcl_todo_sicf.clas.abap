class ZCL_TODO_SICF definition
  public
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.

  methods READ_MIME
    importing
      !II_SERVER type ref to IF_HTTP_SERVER
      !IV_URL type STRING .
private section.
ENDCLASS.



CLASS ZCL_TODO_SICF IMPLEMENTATION.


  METHOD if_http_extension~handle_request.

    DATA: lv_path TYPE string,
          lv_name TYPE string,
          li_http TYPE REF TO if_http_extension.


    lv_path = server->request->get_header_field( '~path' ).

    IF lv_path CP '/sap/ztodo/rest/*'.
      CREATE OBJECT li_http TYPE zcl_todo.
      li_http->handle_request( server ).
    ELSE.
      FIND REGEX '/sap/ztodo/static/(.*)'
        IN lv_path
        SUBMATCHES lv_name ##NO_TEXT.

      IF lv_name IS INITIAL.
        lv_name = 'index.html' ##NO_TEXT.
      ENDIF.

      read_mime( ii_server = server
                 iv_url    = lv_name ).
    ENDIF.

  ENDMETHOD.


  METHOD read_mime.

    DATA: li_api  TYPE REF TO if_mr_api,
          lv_data TYPE xstring,
          lv_mime TYPE string,
          lv_url  TYPE string.


    CONCATENATE '/SAP/PUBLIC/ztodo/' iv_url INTO lv_url.

    li_api = cl_mime_repository_api=>if_mr_api~get_api( ).

    li_api->get(
      EXPORTING
        i_url       = lv_url
      IMPORTING
        e_content   = lv_data
        e_mime_type = lv_mime
      EXCEPTIONS
        not_found   = 1 ).
    IF sy-subrc = 1.
      ii_server->response->set_cdata( '404' ).
      ii_server->response->set_status( code = 404 reason = '404' ).
      RETURN.
    ENDIF.

    ii_server->response->set_compression( ).
    ii_server->response->set_content_type( lv_mime ).
    ii_server->response->set_data( lv_data ).

  ENDMETHOD.
ENDCLASS.
