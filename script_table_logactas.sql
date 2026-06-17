-- Create table
create table RCTL_ACTAS_LOGS
(
  fe_log               DATE default SYSDATE not null,
  de_mensaje_log       VARCHAR2(400) not null,
  id_log               VARCHAR2(36) not null,
  co_dni_solicitante   VARCHAR2(8) not null,
  co_dni_solicitado    VARCHAR2(8) not null,
  de_perfil_solicitado VARCHAR2(50),
  ip_direccion_origen  VARCHAR2(45),
  es_resultado         VARCHAR2(10),
  de_mensaje_error     VARCHAR2(400)
)
tablespace TBL_IDODNIDIGITAL_DTA_01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column RCTL_ACTAS_LOGS.fe_log
  is 'Fecha y hora del registro de log';
comment on column RCTL_ACTAS_LOGS.de_mensaje_log
  is 'Mensaje principal de auditoria generado por la aplicacion';
comment on column RCTL_ACTAS_LOGS.id_log
  is 'Identificador unico del evento de log (UUID)';
comment on column RCTL_ACTAS_LOGS.co_dni_solicitante
  is 'DNI del usuario o sistema que realiza la solicitud';
comment on column RCTL_ACTAS_LOGS.co_dni_solicitado
  is 'DNI consultado en la operacion';
comment on column RCTL_ACTAS_LOGS.de_perfil_solicitado
  is 'Profile solicitado (ej. ACTA_NACIMIENTO, ACTA_MATRIMONIO)';
comment on column RCTL_ACTAS_LOGS.ip_direccion_origen
  is 'Direccion IP de origen de la peticion';
comment on column RCTL_ACTAS_LOGS.es_resultado
  is 'Resultado de la operacion: OK o ERROR';
comment on column RCTL_ACTAS_LOGS.de_mensaje_error
  is 'Mensaje de error legible; NULL en caso exitoso';
