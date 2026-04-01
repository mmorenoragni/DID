-- Create table
create table DNID_LOGS
(
  fecha_log   DATE default SYSDATE not null,
  mensaje_log VARCHAR2(400) not null
)
tablespace TBL_IDODNIDIGITAL_DTA_01
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table DNID_LOGS
  is 'tabla de logs';
-- Create/Recreate indexes 
create index IDX_DNID_LOGS_FECHA_LOG on DNID_LOGS (FECHA_LOG)
  tablespace TBL_IDODNIDIGITAL_DTA_01
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
-- Grant/Revoke object privileges 
grant select on DNID_LOGS to IDUDNIDIGITAL;
