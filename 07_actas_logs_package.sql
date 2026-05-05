-- Package para insertar filas en RCTL_ACTAS_LOGS.
-- Requiere tabla IDORRCC.RCTL_ACTAS_LOGS (ver 06_actas_logs_table.sql).

ALTER SESSION SET CURRENT_SCHEMA = IDORRCC;

CREATE OR REPLACE PACKAGE IDORRCC.RCPK_ACTAS_WS AS
  ----------------------------------------------------------------------------------------------------
  -- Nombre del Procedimiento : RCSP_INSERTAR_ACTAS_LOG
  -- Proposito                : Insertar un registro de auditoria en RCTL_ACTAS_LOGS
  -- Parametros               : p_vIdLog, p_vDeMensajeLog (obligatorios en logica de app); resto opcionales
  ----------------------------------------------------------------------------------------------------
  PROCEDURE RCSP_INSERTAR_ACTAS_LOG(
    p_vIdLog               IN rctl_actas_logs.id_log%TYPE,
    p_vDeMensajeLog        IN rctl_actas_logs.de_mensaje_log%TYPE,
    p_vCoDniSolicitante    IN rctl_actas_logs.co_dni_solicitante%TYPE DEFAULT NULL,
    p_vCoDniSolicitado     IN rctl_actas_logs.co_dni_solicitado%TYPE DEFAULT NULL,
    p_vDePerfilSolicitado  IN rctl_actas_logs.de_perfil_solicitado%TYPE DEFAULT NULL,
    p_vIpDireccionOrigen   IN rctl_actas_logs.ip_direccion_origen%TYPE DEFAULT NULL,
    p_vEsResultado         IN rctl_actas_logs.es_resultado%TYPE DEFAULT NULL,
    p_vDeMensajeError      IN rctl_actas_logs.de_mensaje_error%TYPE DEFAULT NULL
  );
END RCPK_ACTAS_WS;
/

CREATE OR REPLACE PACKAGE BODY IDORRCC.RCPK_ACTAS_WS AS
  PROCEDURE RCSP_INSERTAR_ACTAS_LOG(
    p_vIdLog               IN rctl_actas_logs.id_log%TYPE,
    p_vDeMensajeLog        IN rctl_actas_logs.de_mensaje_log%TYPE,
    p_vCoDniSolicitante    IN rctl_actas_logs.co_dni_solicitante%TYPE DEFAULT NULL,
    p_vCoDniSolicitado     IN rctl_actas_logs.co_dni_solicitado%TYPE DEFAULT NULL,
    p_vDePerfilSolicitado  IN rctl_actas_logs.de_perfil_solicitado%TYPE DEFAULT NULL,
    p_vIpDireccionOrigen   IN rctl_actas_logs.ip_direccion_origen%TYPE DEFAULT NULL,
    p_vEsResultado         IN rctl_actas_logs.es_resultado%TYPE DEFAULT NULL,
    p_vDeMensajeError      IN rctl_actas_logs.de_mensaje_error%TYPE DEFAULT NULL
  ) AS
  BEGIN
    INSERT INTO rctl_actas_logs (
      id_log,
      de_mensaje_log,
      co_dni_solicitante,
      co_dni_solicitado,
      de_perfil_solicitado,
      ip_direccion_origen,
      es_resultado,
      de_mensaje_error
    ) VALUES (
      p_vIdLog,
      p_vDeMensajeLog,
      p_vCoDniSolicitante,
      p_vCoDniSolicitado,
      p_vDePerfilSolicitado,
      p_vIpDireccionOrigen,
      p_vEsResultado,
      p_vDeMensajeError
    );
  END RCSP_INSERTAR_ACTAS_LOG;
END RCPK_ACTAS_WS;
/

-- Otorgar EXECUTE al usuario del pool jdbc/desarc en WebLogic (ajustar nombre de usuario):
-- GRANT EXECUTE ON IDORRCC.RCPK_ACTAS_WS TO <usuario_jdbc_desarc>;
