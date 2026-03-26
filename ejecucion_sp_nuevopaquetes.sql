DECLARE
  v_cursor SYS_REFCURSOR;

  TYPE t_dni IS RECORD (
    cui_dni                 VARCHAR2(50),
    prenombres              VARCHAR2(200),
    apellido_paterno       VARCHAR2(200),
    apellido_materno       VARCHAR2(200),
    apellido_casada        VARCHAR2(200),
    fe_nacimiento           DATE,

    co_continente_naci      VARCHAR2(50),
    co_pais_naci            VARCHAR2(50),
    co_departamento_naci   VARCHAR2(50),
    co_provincia_naci      VARCHAR2(50),
    co_distrito_naci       VARCHAR2(50),
    co_centro_pob_naci    VARCHAR2(50),

    lugar_nacimiento       VARCHAR2(400),
    ubigeo_nacimiento      VARCHAR2(50),
    sexo                    VARCHAR2(50),
    estado_civil           VARCHAR2(100),

    foto                    BLOB,

    ubigeo_domicilio       VARCHAR2(50),
    lugar_domicilio        VARCHAR2(400),
    domicilio              VARCHAR2(4000),

    grupo_factor_sanguineo VARCHAR2(100),
    observaciones          VARCHAR2(4000),
    restriccion            VARCHAR2(200),

    fecha_emision_dnie     DATE,
    fecha_caducidad_dnie   VARCHAR2(50),

    tipo_doc_progenitor1  VARCHAR2(50),
    num_doc_progenitor1   VARCHAR2(50),
    tipo_doc_progenitor2  VARCHAR2(50),
    num_doc_progenitor2   VARCHAR2(50),

    email                   VARCHAR2(200),
    nacionalidad           VARCHAR2(10)
  );

  r_reg t_dni;
BEGIN
  SP_GET_DATOS_COMPLETO_DNI(
    p_nu_dni    => '12345678',  -- <- cambia aquí
    p_recordset => v_cursor
  );

  LOOP
    FETCH v_cursor INTO r_reg;
    EXIT WHEN v_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('DNI: ' || r_reg.cui_dni);
    DBMS_OUTPUT.PUT_LINE('Nombres: ' || r_reg.prenombres);
    DBMS_OUTPUT.PUT_LINE('Apellidos: ' || r_reg.apellido_paterno || ' ' || r_reg.apellido_materno || ' ' || r_reg.apellido_casada);
    DBMS_OUTPUT.PUT_LINE('Fecha Nac: ' || TO_CHAR(r_reg.fe_nacimiento, 'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('Sexo: ' || r_reg.sexo);
    DBMS_OUTPUT.PUT_LINE('Estado Civil: ' || r_reg.estado_civil);

    DBMS_OUTPUT.PUT_LINE('Domicilio: ' || r_reg.domicilio);
    DBMS_OUTPUT.PUT_LINE('Restriccion: ' || r_reg.restriccion);
    DBMS_OUTPUT.PUT_LINE('Fecha Caducidad: ' || r_reg.fecha_caducidad_dnie);

    DBMS_OUTPUT.PUT_LINE('Email: ' || r_reg.email);
    DBMS_OUTPUT.PUT_LINE('Nacionalidad: ' || r_reg.nacionalidad);

    DBMS_OUTPUT.PUT_LINE(
      'Foto bytes: ' ||
      CASE WHEN r_reg.foto IS NULL THEN 'NULL' ELSE DBMS_LOB.GETLENGTH(r_reg.foto) END
    );

    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
  END LOOP;

  CLOSE v_cursor;

EXCEPTION
  WHEN OTHERS THEN
    IF v_cursor%ISOPEN THEN
      CLOSE v_cursor;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Error detectado: ' || SQLERRM);
END;
/