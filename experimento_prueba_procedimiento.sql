DECLARE
  v_rc            SYS_REFCURSOR;
  v_cursor_id     INTEGER;
  v_col_cnt       INTEGER;
  v_desc_tab      DBMS_SQL.DESC_TAB2;
  v_varchar       VARCHAR2(4000);
  v_blob          BLOB;
  v_status        INTEGER;
BEGIN
  -- 1) Ejecutas el SP
  SP_GET_DNI_ACTAS('12345678', v_rc);
  -- 2) Conviertes el ref cursor a cursor DBMS_SQL
  v_cursor_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);
  -- 3) Describes columnas devueltas
  DBMS_SQL.DESCRIBE_COLUMNS2(v_cursor_id, v_col_cnt, v_desc_tab);
  -- 4) Defines columnas (manejo básico: texto + blob)
  FOR i IN 1 .. v_col_cnt LOOP
    IF v_desc_tab(i).col_type = 113 THEN
      -- 113 = BLOB
      DBMS_SQL.DEFINE_COLUMN(v_cursor_id, i, v_blob);
    ELSE
      DBMS_SQL.DEFINE_COLUMN(v_cursor_id, i, v_varchar, 4000);
    END IF;
  END LOOP;
  -- 5) Iteras filas
  LOOP
    v_status := DBMS_SQL.FETCH_ROWS(v_cursor_id);
    EXIT WHEN v_status = 0;
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_desc_tab(i).col_type = 113 THEN
        DBMS_SQL.COLUMN_VALUE(v_cursor_id, i, v_blob);
        DBMS_OUTPUT.PUT_LINE(v_desc_tab(i).col_name || ' = [BLOB] ' ||
                             CASE WHEN v_blob IS NULL THEN 'NULL'
                                  ELSE 'bytes=' || DBMS_LOB.GETLENGTH(v_blob) END);
      ELSE
        DBMS_SQL.COLUMN_VALUE(v_cursor_id, i, v_varchar);
        DBMS_OUTPUT.PUT_LINE(v_desc_tab(i).col_name || ' = ' || NVL(v_varchar, 'NULL'));
      END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------------------');
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
EXCEPTION
  WHEN OTHERS THEN
    IF DBMS_SQL.IS_OPEN(v_cursor_id) THEN
      DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
    END IF;
    RAISE;
END;