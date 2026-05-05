CREATE OR REPLACE PACKAGE BODY DDPK_ACTAS_DNID AS
  PROCEDURE DDSP_ACTA_MATRIMONIO_BY_DOC(p_num_doc   IN VARCHAR2, -- Cambiamos a VARCHAR2 para documentos
                                        p_recordset OUT SYS_REFCURSOR -- Parámetro de salida
                                        ) AS
  BEGIN
    OPEN p_recordset FOR
      SELECT M.FE_DE_CELEBRACION,
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
      SELECT N.NU_CUI,
             N.DE_PRE_NOMBRES,
             N.DE_PRIMER_APELLIDO,
             N.DE_SEGUNDO_APELLIDO,
             N.FE_NACIMIENTO,
             N.IM_NACIMIENTOS_REV  AS IMAGEN_REVERSO,
             N.IM_NACIMIENTOS      AS IMAGEN_ANVERSO
        FROM IDORRCC.RCTM_NACIMIENTOS N
       WHERE N.CO_ESTADO_ACTA_NACIMIENTO = '1'
         AND N.NU_CUI = p_nu_cui;
  END DDSP_OBTENER_ACTA_NACIMIENTO;
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
