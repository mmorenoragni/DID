SET SERVEROUTPUT ON;

DECLARE
  v_cursor SYS_REFCURSOR;

  -- El FETCH necesita recibir TODAS las columnas del SELECT en el mismo orden.
  -- Pero tú solo imprimiremos las 5 primeras para validar que funciona.
  TYPE t_dni IS RECORD (
    cui_dni                  VARCHAR2(50),
    prenombres               VARCHAR2(200),
    apellido_paterno        VARCHAR2(200),
    apellido_materno        VARCHAR2(200),
    apellido_casada         VARCHAR2(200),
    fe_nacimiento            DATE,

    co_continente_naci       VARCHAR2(50),
    co_pais_naci             VARCHAR2(50),
    co_departamento_naci    VARCHAR2(50),
    co_provincia_naci       VARCHAR2(50),
    co_distrito_naci        VARCHAR2(50),
    co_centro_pob_naci      VARCHAR2(50),

    lugar_nacimiento        VARCHAR2(400),
    ubigeo_nacimiento       VARCHAR2(50),
    sexo                     VARCHAR2(50),
    estado_civil            VARCHAR2(100),

    foto                     BLOB,

    ubigeo_domicilio        VARCHAR2(50),
    lugar_domicilio         VARCHAR2(400),
    domicilio               VARCHAR2(4000),

    grupo_factor_sanguineo  VARCHAR2(100),
    observaciones           VARCHAR2(4000),
    restriccion             VARCHAR2(200),

    fecha_emision_dnie      DATE,
    fecha_caducidad_dnie    VARCHAR2(50),

    tipo_doc_progenitor1   VARCHAR2(50),
    num_doc_progenitor1    VARCHAR2(50),
    tipo_doc_progenitor2   VARCHAR2(50),
    num_doc_progenitor2    VARCHAR2(50),

    email                   VARCHAR2(200),
    nacionalidad           VARCHAR2(10)
  );

  r_reg t_dni;
BEGIN
  SP_GET_DATOS_COMPLETO_DNI(
    p_nu_dni     => '12345678',  -- <- tu DNI
    p_recordset  => v_cursor
  );

  LOOP
    FETCH v_cursor INTO r_reg;
    EXIT WHEN v_cursor%NOTFOUND;

    -- Imprimir SOLO las 5 primeras columnas
    DBMS_OUTPUT.PUT_LINE('CUI_DNI=' || r_reg.cui_dni);
    DBMS_OUTPUT.PUT_LINE('PRENOMBRES=' || r_reg.prenombres);
    DBMS_OUTPUT.PUT_LINE('APELLIDO_PATERNO=' || r_reg.apellido_paterno);
    DBMS_OUTPUT.PUT_LINE('APELLIDO_MATERNO=' || r_reg.apellido_materno);
    DBMS_OUTPUT.PUT_LINE('APELLIDO_CASADA=' || r_reg.apellido_casada);

    DBMS_OUTPUT.PUT_LINE('--- OK: consulta retornó al menos una fila ---');
    EXIT; -- opcional: como filtra por DNI, normalmente es 1 fila
  END LOOP;

  CLOSE v_cursor;

EXCEPTION
  WHEN OTHERS THEN
    IF v_cursor%ISOPEN THEN CLOSE v_cursor; END IF;
    DBMS_OUTPUT.PUT_LINE('Error detectado: ' || SQLERRM);
END;
/