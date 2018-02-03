CLASS zcl_todo DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
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
ENDCLASS.
