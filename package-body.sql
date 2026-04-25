CREATE OR REPLACE PACKAGE BODY DDPK_DNI_DNID AS

  /*---------------------------------------------------------------------------*/
  FUNCTION DDFU_GET_DESC_DOMINIO(p_vNO_DOMINIO VARCHAR2,
                                 p_vCO_DOMINIO VARCHAR2) RETURN VARCHAR2 IS
    v_vRETURN VARCHAR2(30);
  BEGIN
    --
    SELECT DE_DOM
      INTO v_vRETURN
      FROM GETR_DOMINIOS
     WHERE NO_DOM = p_vNO_DOMINIO
       AND CO_DOMINIO = p_vCO_DOMINIO
       AND ES_DOM = '1';
    --
    RETURN v_vRETURN;
    --
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
  END;
  /*---------------------------------------------------------------------------*/
  PROCEDURE DDSP_GET_DATOS_COMPLETO_DNI(p_nu_dni    IN VARCHAR2,
                                        p_recordset OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT A.NU_DNI AS CUI_DNI,
             A.PRENOM_INSCRITO AS PRENOMBRES,
             A.AP_PRIMER AS APELLIDO_PATERNO,
             A.AP_SEGUNDO AS APELLIDO_MATERNO,
             A.AP_CASADA AS APELLIDO_CASADA,
             A.FE_NACIMIENTO AS FECHA_NACIMIENTO,
             A.CO_CONTINENTE_NACI,
             A.CO_PAIS_NACI,
             A.CO_DEPARTAMENTO_NACI,
             A.CO_PROVINCIA_NACI,
             A.CO_DISTRITO_NACI,
             A.CO_CENTRO_POBLADO_NACI,
             TRIM(REPLACE(NVL(U_NACI.DE_UBIGEO_CAPTU, U_NACI.DE_UBIGEO),
                          '/',
                          ' / ')) AS LUGAR_NACIMIENTO,
             REPLACE(NVL(U_NACI.CO_UBIGEO, ''), '-', '') AS UBIGEO_NACIMIENTO,
             NVL(D_SEXO."DE_DOM", A.DE_GENERO) AS SEXO,
             TRIM(E.DE_ESTADO_CIVIL) AS ESTADO_CIVIL,
             
             -- (11) SOLUCIÓN PARA ORDIMAGE: Extraemos el BLOB del objeto
             CASE
               WHEN IMG.IM_FOTO IS NOT NULL THEN
                IMG.IM_FOTO.source.localData
               WHEN IMGM.IM_FOTO_MENOR IS NOT NULL THEN
                IMGM.IM_FOTO_MENOR.source.localData
               ELSE
                NULL
             END AS FOTO,
             
             REPLACE(NVL(U_DOM.CO_UBIGEO, ''), '-', '') AS UBIGEO_DOMICILIO,
             TRIM(REPLACE(NVL(U_DOM.DE_UBIGEO_CAPTU, U_DOM.DE_UBIGEO),
                          '/',
                          ' / ')) AS LUGAR_DOMICILIO,
             
             TRIM(REPLACE(REPLACE(REPLACE(DECODE(A.DE_PREF_DIRECCION,
                                                 NULL,
                                                 NULL,
                                                 DDFU_GET_DESC_DOMINIO('DE_PREF_DIRECCION',
                                                                       A.DE_PREF_DIRECCION)) || ' ' ||
                                          A.DE_DIRECCION || ' ' ||
                                          A.NU_DIRECCION || ' ' ||
                                          DECODE(A.DE_PREF_BLOCK,
                                                 NULL,
                                                 NULL,
                                                 DDFU_GET_DESC_DOMINIO('DE_PREF_BLOCK',
                                                                       A.DE_PREF_BLOCK)) || ' ' ||
                                          A.DE_BLOCK_CHALET || ' ' ||
                                          DECODE(A.DE_PREF_INTERIOR,
                                                 NULL,
                                                 NULL,
                                                 DDFU_GET_DESC_DOMINIO('DE_PREF_INTERIOR',
                                                                       A.DE_PREF_INTERIOR)) || ' ' ||
                                          A.DE_INTERIOR || ' ' ||
                                          DECODE(A.DE_PREF_URB,
                                                 NULL,
                                                 NULL,
                                                 DDFU_GET_DESC_DOMINIO('DE_PREF_URB',
                                                                       A.DE_PREF_URB)) || ' ' ||
                                          A.DE_URBANIZACION || ' ' ||
                                          DECODE(A.DE_ETAPA,
                                                 NULL,
                                                 NULL,
                                                 'ETAPA ' || A.DE_ETAPA) || ' ' ||
                                          DECODE(A.DE_MANZANA,
                                                 NULL,
                                                 NULL,
                                                 'MZ. ' || A.DE_MANZANA) || ' ' ||
                                          DECODE(A.DE_LOTE_DIRECCION,
                                                 NULL,
                                                 NULL,
                                                 'LT. ' ||
                                                 A.DE_LOTE_DIRECCION),
                                          '   ',
                                          ' '),
                                  '  ',
                                  ' '),
                          '  ',
                          ' ')) DOMICILIO,
             --
             
             G.DE_GRUPO_FACTOR AS GRUPO_FACTOR_SANGUINEO,
             OBS.LISTA_OBSERVACIONES AS OBSERVACIONES,
             A.CO_RESTRI AS COD_RESTRI,
             NVL(TRIM(NVL(DECODE(R.DE_CEL,
                                 NULL,
                                 NULL,
                                 DECODE(INSTR(R.DE_CEL, '-'),
                                        0,
                                        R.DE_CEL,
                                        SUBSTR(R.DE_CEL,
                                               INSTR(R.DE_CEL, '-') + 2))),
                          ' ')),
                 'SIN RESTRICCIÓN') AS RESTRICCION,
             --
             
             R.CO_GRUPO_RESTRI as GRUPO_RESTRI,
             A.FE_EMISION AS FECHA_EMISION_DNIE,
             CASE
               WHEN A.FE_CADUCIDAD IS NOT NULL AND
                    TO_NUMBER(TO_CHAR(A.FE_CADUCIDAD, 'YYYY')) = 3000 THEN
                'NO CADUCA'
               ELSE
                TO_CHAR(A.FE_CADUCIDAD, 'DD/MM/YYYY')
             END AS FECHA_CADUCIDAD_DNIE,
             A.CO_TIPO_DOC_PADRE AS TIPO_DOC_PROGENITOR1,
             A.NU_DOC_PADRE AS NUM_DOC_PROGENITOR1,
             A.CO_TIPO_DOC_MADRE AS TIPO_DOC_PROGENITOR2,
             A.NU_DOC_MADRE AS NUM_DOC_PROGENITOR2,
             A.DE_EMAIL AS EMAIL,
             'PER' AS NACIONALIDAD
        FROM IDOTABMAESTRA.GETM_ANI A
        LEFT JOIN IDOTABMAESTRA.GEVW_UBIGEOS U_NACI
          ON U_NACI.CO_DEPARTAMENTO = A.CO_DEPARTAMENTO_NACI
         AND U_NACI.CO_PROVINCIA = A.CO_PROVINCIA_NACI
         AND U_NACI.CO_DISTRITO = A.CO_DISTRITO_NACI
        LEFT JOIN IDOTABMAESTRA.GEVW_UBIGEOS U_DOM
          ON U_DOM.CO_DEPARTAMENTO = A.CO_DEPARTAMENTO_DOMICILIO
         AND U_DOM.CO_PROVINCIA = A.CO_PROVINCIA_DOMICILIO
         AND U_DOM.CO_DISTRITO = A.CO_DISTRITO_DOMICILIO
        LEFT JOIN IDOTABMAESTRA.GETR_ESTADO_CIVIL E
          ON E.CO_ESTADO_CIVIL = A.CO_ESTADO_CIVIL
        LEFT JOIN IDOTABMAESTRA.GETR_GRUPO_FACTOR_SANGUINEO G
          ON G.CO_GRUPO_FACTOR = A.CO_GRUPO_SANGUINEO
        LEFT JOIN IDOTABMAESTRA.GETM_RESTRICCION R
          ON R.CO_RESTRI = A.CO_RESTRI
        LEFT JOIN IDOTABMAESTRA.GETR_DOMINIOS D_SEXO
          ON D_SEXO.NO_DOM = 'TIPO_SEXO'
         AND D_SEXO.CO_DOMINIO = A.DE_GENERO
        LEFT JOIN (SELECT NU_DNI,
                          LTRIM(MAX(SYS_CONNECT_BY_PATH(DE_OBS, '; ')), '; ') AS LISTA_OBSERVACIONES
                     FROM (SELECT OD.NU_DNI,
                                  R_OBS.DE_OBS,
                                  ROW_NUMBER() OVER(PARTITION BY OD.NU_DNI ORDER BY OD.CO_OBS) AS rn
                             FROM IDOTABMAESTRA.GETM_OBSERVACION_DNI OD
                             JOIN IDOTABMAESTRA.GETR_OBSERVACION R_OBS
                               ON R_OBS.CO_OBS = OD.CO_OBS)
                    START WITH rn = 1
                   CONNECT BY PRIOR rn = rn - 1
                          AND PRIOR NU_DNI = NU_DNI
                    GROUP BY NU_DNI) OBS
          ON OBS.NU_DNI = A.NU_DNI
        LEFT JOIN IMAGADM.IDTP_IMAGENES IMG
          ON IMG.NU_FORMULARIO = A.NU_IMAG
         AND IMG.TI_DOC_REG_FICHA = A.TI_FICHA_IMAG
        LEFT JOIN IMAGADM.IDTP_IMAGEN_MENOR IMGM
          ON IMGM.NU_FORMULARIO = A.NU_IMAG
         AND IMGM.TI_DOC_REG_FICHA = A.TI_FICHA_IMAG
       WHERE A.NU_DNI = p_nu_dni;
  END DDSP_GET_DATOS_COMPLETO_DNI;
  /*---------------------------------------------------------------------------*/
  PROCEDURE DDSP_INSERT_DNID_LOG(p_id              IN dnid_logs.id%TYPE,
                                 p_mensaje_log     IN dnid_logs.mensaje_log%TYPE,
                                 p_dni_solicitante IN dnid_logs.dni_solicitante%TYPE DEFAULT NULL,
                                 p_dni_solicitado  IN dnid_logs.dni_solicitado%TYPE DEFAULT NULL) AS
  BEGIN
    INSERT INTO dnid_logs
      (id, mensaje_log, dni_solicitante, dni_solicitado)
    VALUES
      (p_id, p_mensaje_log, p_dni_solicitante, p_dni_solicitado);
  END DDSP_INSERT_DNID_LOG;
  /*---------------------------------------------------------------------------*/
END;
