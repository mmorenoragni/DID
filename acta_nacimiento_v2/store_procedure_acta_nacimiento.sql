CREATE OR REPLACE PROCEDURE DDSP_OBTENER_ACTA_NACIMIENTO_POR_DATOS (
    p_primer_apellido     IN VARCHAR2,
    p_segundo_apellido    IN VARCHAR2,
    p_pre_nombres         IN VARCHAR2,
    p_nac_nat_cont        IN VARCHAR2,
    p_nac_nat_pais        IN VARCHAR2,
    p_nac_nat_dpto        IN VARCHAR2,
    p_nac_nat_prov        IN VARCHAR2,
    p_nac_nat_dist        IN VARCHAR2,
    p_nac_nat_loca        IN VARCHAR2,
    p_recordset           OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_recordset FOR
        SELECT
            N.NU_CUI,
            N.DE_PRE_NOMBRES,
            N.DE_PRIMER_APELLIDO,
            N.DE_SEGUNDO_APELLIDO,
            N.FE_NACIMIENTO,
            N.IM_NACIMIENTOS_REV AS IMAGEN_REVERSO,
            N.IM_NACIMIENTOS     AS IMAGEN_ANVERSO
        FROM
            IDORRCC.RCTM_NACIMIENTOS N
        WHERE
            N.CO_ESTADO_ACTA_NACIMIENTO = '1'
            AND N.DE_PRIMER_APELLIDO = p_primer_apellido
            AND N.DE_SEGUNDO_APELLIDO = p_segundo_apellido
            AND N.DE_PRE_NOMBRES = p_pre_nombres
            AND N.CO_NACIDO_NATURAL_CONT = p_nac_nat_cont
            AND N.CO_NACIDO_NATURAL_PAIS = p_nac_nat_pais
            AND N.CO_CO_NACIDO_NATURAL_DPTO = p_nac_nat_dpto
            AND N.CO_CO_NACIDO_NATURAL_PROV = p_nac_nat_prov
            AND N.CO_CO_NACIDO_NATURAL_DIST = p_nac_nat_dist
            AND N.CO_CO_NACIDO_NATURAL_LOCA = p_nac_nat_loca;
END;
/