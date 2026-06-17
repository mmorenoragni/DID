CREATE OR REPLACE PACKAGE BODY DDPK_ACTAS_DNID AS
  PROCEDURE DDSP_ACTA_MATRIMONIO_BY_DOC(p_num_doc   IN VARCHAR2, -- Cambiamos a VARCHAR2 para documentos
                                        p_recordset OUT SYS_REFCURSOR -- Parámetro de salida
                                        ) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT M.FE_DE_CELEBRACION,
             M.NU_ACTA_MATRIMONIO,
             M.DE_CELEBRADO_LUGAR,
             (SELECT D.DE_DOC_IDENTIDAD
                FROM IDORRCC.RCTR_TIPO_DOC_IDENTIDAD D
               WHERE D.CO_TIPO_DOC_IDENTIDAD =
                     M.CO_TIPO_DOC_IDENTIDAD_CTYENTE1) AS tipoDocCONYUGE1,
             M.NU_DOC_IDENTIDAD_CTYENTE1,
             (SELECT D.DE_DOC_IDENTIDAD
                FROM IDORRCC.RCTR_TIPO_DOC_IDENTIDAD D
               WHERE D.CO_TIPO_DOC_IDENTIDAD =
                     M.CO_TIPO_DOC_IDENTIDAD_CTYENTE2) AS tipoDocCONYUGE2,
             M.NU_DOC_IDENTIDAD_CTYENTE2,
             CASE
               WHEN M.IM_MATRIMONIOS IS NOT NULL THEN
                M.IM_MATRIMONIOS
               ELSE
                R.IM_ACTA
             END AS IMAGEN_ANVERSO,
             CASE
               WHEN M.IM_MATRIMONIOS_REV IS NOT NULL THEN
                M.IM_MATRIMONIOS_REV
               ELSE
                I.IM_ACTA
             END AS IMAGEN_REVERSO
        FROM IDORRCC.RCTM_MATRIMONIOS M
        LEFT JOIN IDORRCC.RCTM_ESCANEO R
          ON R.NU_ACTA = M.NU_ACTA_MATRIMONIO
         AND R.CO_TIPO_ACTA = '02'
         AND R.CO_LADO_ACTA = 'A'
         AND R.IM_ACTA IS NOT NULL
        LEFT JOIN IDORRCC.RCTM_ESCANEO I
          ON I.NU_ACTA = M.NU_ACTA_MATRIMONIO
         AND I.CO_TIPO_ACTA = '02'
         AND I.CO_LADO_ACTA = 'B'
         AND I.IM_ACTA IS NOT NULL
       WHERE M.CO_ESTADO_ACTA_MATRIMONIO = '1'
         AND (M.NU_DOC_IDENTIDAD_CTYENTE1 = p_num_doc OR
             M.NU_DOC_IDENTIDAD_CTYENTE2 = p_num_doc); -- Filtro por cualquiera de los dos
  END DDSP_ACTA_MATRIMONIO_BY_DOC;
  PROCEDURE DDSP_OBTENER_ACTA_NACIMIENTO(p_nu_cui    IN VARCHAR2,
                                         p_recordset OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT N.NU_ACTA_NACIMIENTO,
             N.NU_CUI,
             NVL(N.CO_NACIDO_NATURAL_DPTO, ' ') CO_DEPARTAMENTO_NACIMIENTO,
             NVL(N.CO_NACIDO_NATURAL_PROV, ' ') CO_PROVINCIA_NACIMIENTO,
             NVL(N.CO_NACIDO_NATURAL_DIST, ' ') CO_DISTRITO_NACIMIENTO,
             NVL(N.CO_NACIDO_NATURAL_LOCA, ' ') CO_CENTRO_POBLADO_NACIMIENTO,
             NVL(UN.NO_DEPARTAMENTO, ' ') DE_DEPARTAMENTO_NACIMIENTO,
             NVL(UN.NO_PROVINCIA, ' ') DE_PROVINCIA_NACIMIENTO,
             NVL(UN.NO_DISTRITO, ' ') DE_DISTRITO_NACIMIENTO,
             NVL((SELECT G.DE_TIPO_LUGAR FROM IDORRCC.RCTR_TIPO_LUGAR G
             WHERE G.CO_TIPO_LUGAR=N.CO_TIPO_LUGAR_NACIMIENTO), ' ') DE_TIPO_LUGAR,
             NVL(N.NO_LUGAR_NACIMIENTO, ' ') NO_LUGAR,
             N.DE_PRE_NOMBRES,
             N.DE_PRIMER_APELLIDO,
             N.DE_SEGUNDO_APELLIDO,
             N.FE_NACIMIENTO,
             N.IM_NACIMIENTOS_REV  AS IMAGEN_REVERSO,
             N.IM_NACIMIENTOS      AS IMAGEN_ANVERSO
        FROM

  IDORRCC.RCTM_NACIMIENTOS N

JOIN IDORRCC.RCTM_NACIMIENTOS_ACTORES M
ON M.NU_ACTA_NACIMIENTO=N.NU_ACTA_NACIMIENTO
AND M.CO_TIPO_ACTOR_NACIMIENTO='01'

JOIN IDORRCC.RCTM_NACIMIENTOS_ACTORES P
ON P.NU_ACTA_NACIMIENTO=N.NU_ACTA_NACIMIENTO
AND P.CO_TIPO_ACTOR_NACIMIENTO='02'

LEFT JOIN IDORRCC.RCTM_ESCANEO R  ON R.NU_ACTA=N.NU_ACTA_NACIMIENTO
AND R.CO_TIPO_ACTA='01' AND R.CO_LADO_ACTA='A' AND R.IM_ACTA IS NOT NULL

LEFT JOIN IDORRCC.RCTM_ESCANEO I ON I.NU_ACTA=N.NU_ACTA_NACIMIENTO
AND I.CO_TIPO_ACTA='01' AND I.CO_LADO_ACTA='B' AND I.IM_ACTA IS NOT NULL

LEFT JOIN  IDORRCC.GEVW_UBIGEOS UN ON   UN.CO_CONTINENTE =
N.CO_NACIDO_NATURAL_CONT  AND UN.CO_PAIS = N.CO_NACIDO_NATURAL_PAIS
AND UN.CO_DEPARTAMENTO = N.CO_NACIDO_NATURAL_DPTO

        AND UN.CO_PROVINCIA = N.CO_NACIDO_NATURAL_PROV

        AND UN.CO_DISTRITO = N.CO_NACIDO_NATURAL_DIST

        AND UN.CO_CENTRO_POBLADO_O =N.CO_NACIDO_NATURAL_LOCA
       WHERE N.CO_ESTADO_ACTA_NACIMIENTO = '1'
         AND N.NU_CUI = p_nu_cui;
  END DDSP_OBTENER_ACTA_NACIMIENTO;
  PROCEDURE DDSP_OBTENER_AM_ACTA_NAC(p_nu_acta   IN VARCHAR2,
                                     p_recordset OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT J.NU_ACTA_NACIMIENTO, J.DE_MATERIA, J.DE_TRANSCRIPCION
        FROM IDORRCC.RCTV_ACTA_RECTIFICACION_NAC J,
             IDORRCC.RCTR_NACIMIENTOS_PROCESOS   P
       WHERE J.CO_PROCESO_NACIMIENTO = P.CO_PROCESO_NACIMIENTO
         AND NVL(J.IN_LINEA, ' ') = '1'
         AND J.ES_REGISTRO = '1'
         AND NVL(P.IN_IMPRIME_AM, ' ') = '1'
         AND J.NU_ACTA_NACIMIENTO = p_nu_acta;
  END DDSP_OBTENER_AM_ACTA_NAC;
  PROCEDURE DDSP_OBTENER_AM_ACTA_MAT(p_nu_acta   IN VARCHAR2,
                                     p_recordset OUT SYS_REFCURSOR) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT J.NU_ACTA_MATRIMONIO, J.DE_MATERIA, J.DE_TRANSCRIPCION
        FROM IDORRCC.RCTV_ACTA_RECTIFICACION_MAT J,
             IDORRCC.RCTR_MATRIMONIOS_PROCESOS   P
       WHERE J.CO_PROCESO_MATRIMONIO = P.CO_PROCESO_MATRIMONIO
         AND NVL(J.IN_LINEA, ' ') = '1'
         AND J.ES_REGISTRO = '1'
         AND NVL(P.IN_IMPRIME_AM, ' ') = '1'
         AND J.NU_ACTA_MATRIMONIO = p_nu_acta;
  END DDSP_OBTENER_AM_ACTA_MAT;
  PROCEDURE RCSP_INSERTAR_ACTAS_LOG(p_vIdLog              IN rctl_actas_logs.id_log%TYPE,
                                    p_vDeMensajeLog       IN rctl_actas_logs.de_mensaje_log%TYPE,
                                    p_vCoDniSolicitante   IN rctl_actas_logs.co_dni_solicitante%TYPE DEFAULT NULL,
                                    p_vCoDniSolicitado    IN rctl_actas_logs.co_dni_solicitado%TYPE DEFAULT NULL,
                                    p_vDePerfilSolicitado IN rctl_actas_logs.de_perfil_solicitado%TYPE DEFAULT NULL,
                                    p_vIpDireccionOrigen  IN rctl_actas_logs.ip_direccion_origen%TYPE DEFAULT NULL,
                                    p_vEsResultado        IN rctl_actas_logs.es_resultado%TYPE DEFAULT NULL,
                                    p_vDeMensajeError     IN rctl_actas_logs.de_mensaje_error%TYPE DEFAULT NULL) AS
  BEGIN
    INSERT INTO rctl_actas_logs
      (id_log,
       de_mensaje_log,
       co_dni_solicitante,
       co_dni_solicitado,
       de_perfil_solicitado,
       ip_direccion_origen,
       es_resultado,
       de_mensaje_error)
    VALUES
      (p_vIdLog,
       p_vDeMensajeLog,
       p_vCoDniSolicitante,
       p_vCoDniSolicitado,
       p_vDePerfilSolicitado,
       p_vIpDireccionOrigen,
       p_vEsResultado,
       p_vDeMensajeError);
  END RCSP_INSERTAR_ACTAS_LOG;
END;
