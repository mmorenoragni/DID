-- Script de alteración para tabla existente DNID_LOGS
-- Referencia funcional: dnid_logs-v2.sql

ALTER TABLE DNID_LOGS ADD (
  perfil_solicitado VARCHAR2(20),
  ip_address        VARCHAR2(45),
  status            VARCHAR2(10),
  error_message     VARCHAR2(400)
);

COMMENT ON COLUMN DNID_LOGS.PERFIL_SOLICITADO
  IS 'perfil solicitado: dni o dni_filiacion';

COMMENT ON COLUMN DNID_LOGS.IP_ADDRESS
  IS 'direccion IP de origen de la peticion';

COMMENT ON COLUMN DNID_LOGS.STATUS
  IS 'resultado de la operacion: OK o ERROR';

COMMENT ON COLUMN DNID_LOGS.ERROR_MESSAGE
  IS 'mensaje de error legible; null en caso exitoso';
