SET SERVEROUTPUT ON;

DECLARE
  l_rc SYS_REFCURSOR;

  -- 31 columnas (mismo orden que tu SELECT del SP)
  v_cui_dni            VARCHAR2(50);
  v_prenombres         VARCHAR2(200);
  v_apellido_paterno  VARCHAR2(200);
  v_apellido_materno  VARCHAR2(200);
  v_apellido_casada   VARCHAR2(200);
  v_fecha_nacimiento  DATE;

  v_co_continente_naci VARCHAR2(50);
  v_co_pais_naci       VARCHAR2(50);
  v_co_depart_naci     VARCHAR2(50);
  v_co_prov_naci       VARCHAR2(50);
  v_co_dist_naci      VARCHAR2(50);
  v_co_centro_pob_naci VARCHAR2(50);

  v_lugar_nacimiento  VARCHAR2(400);
  v_ubigeo_nacimiento VARCHAR2(50);
  v_sexo               VARCHAR2(50);
  v_estado_civil      VARCHAR2(100);

  v_foto               BLOB;

  v_ubigeo_domicilio  VARCHAR2(50);
  v_lugar_domicilio   VARCHAR2(400);
  v_domicilio         VARCHAR2(4000);

  v_grupo_factor      VARCHAR2(100);
  v_observaciones     VARCHAR2(4000);
  v_restriccion       VARCHAR2(200);

  v_fecha_emision     DATE;
  v_fecha_caducidad_dnie VARCHAR2(50);

  v_tipo_doc_progenitor1 VARCHAR2(50);
  v_num_doc_progenitor1  VARCHAR2(50);
  v_tipo_doc_progenitor2 VARCHAR2(50);
  v_num_doc_progenitor2  VARCHAR2(50);

  v_email              VARCHAR2(200);
  v_nacionalidad      VARCHAR2(10);
BEGIN
  SP_GET_DATOS_COMPLETO_DNI(
    p_nu_dni    => '12345678',  -- <- DNI a consultar
    p_recordset => l_rc
  );

  BEGIN
    FETCH l_rc INTO
      v_cui_dni,
      v_prenombres,
      v_apellido_paterno,
      v_apellido_materno,
      v_apellido_casada,
      v_fecha_nacimiento,
      v_co_continente_naci,
      v_co_pais_naci,
      v_co_depart_naci,
      v_co_prov_naci,
      v_co_dist_naci,
      v_co_centro_pob_naci,
      v_lugar_nacimiento,
      v_ubigeo_nacimiento,
      v_sexo,
      v_estado_civil,
      v_foto,
      v_ubigeo_domicilio,
      v_lugar_domicilio,
      v_domicilio,
      v_grupo_factor,
      v_observaciones,
      v_restriccion,
      v_fecha_emision,
      v_fecha_caducidad_dnie,
      v_tipo_doc_progenitor1,
      v_num_doc_progenitor1,
      v_tipo_doc_progenitor2,
      v_num_doc_progenitor2,
      v_email,
      v_nacionalidad;

    DBMS_OUTPUT.PUT_LINE('DNI: ' || v_cui_dni);
    DBMS_OUTPUT.PUT_LINE('Nombres: ' || v_prenombres);
    DBMS_OUTPUT.PUT_LINE('Apellidos: ' || v_apellido_paterno || ' ' || v_apellido_materno);
    DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
    DBMS_OUTPUT.PUT_LINE('Sexo: ' || v_sexo);
    DBMS_OUTPUT.PUT_LINE('Foto bytes: ' ||
      CASE WHEN v_foto IS NULL THEN 'NULL' ELSE DBMS_LOB.GETLENGTH(v_foto) END);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No existe data para ese DNI.');
  END;

  CLOSE l_rc;
END;
/