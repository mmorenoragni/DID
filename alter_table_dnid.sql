ALTER TABLE DNID_LOGS ADD (
  id              VARCHAR2(36),
  dni_solicitante VARCHAR2(8),
  dni_solicitado  VARCHAR2(8)
);

-- Rellenar id en cada fila (ejemplo: UUID generado en la sesión o valores que ya tengas)
-- UPDATE DNID_LOGS SET id = ... WHERE id IS NULL;

ALTER TABLE DNID_LOGS MODIFY id NOT NULL;

ALTER TABLE DNID_LOGS ADD CONSTRAINT PK_DNID_LOGS PRIMARY KEY (id);