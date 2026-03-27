CREATE OR REPLACE PROCEDURE sp_insert_dnid_log (
    p_mensaje_log IN dnid_logs.mensaje_log%TYPE
)
AS
BEGIN
    INSERT INTO dnid_logs (mensaje_log)
    VALUES (p_mensaje_log);
END sp_insert_dnid_log;