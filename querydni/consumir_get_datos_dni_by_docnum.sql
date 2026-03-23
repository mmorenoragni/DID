SET SERVEROUTPUT ON;
DECLARE
    v_cursor SYS_REFCURSOR;
    v_ap_primer               IDOTABMAESTRA.GETM_ANI.AP_PRIMER%TYPE;
    v_ap_segundo              IDOTABMAESTRA.GETM_ANI.AP_SEGUNDO%TYPE;
    v_prenom_inscrito         IDOTABMAESTRA.GETM_ANI.PRENOM_INSCRITO%TYPE;
    v_fe_nacimiento           IDOTABMAESTRA.GETM_ANI.FE_NACIMIENTO%TYPE;
    v_co_continente_naci      IDOTABMAESTRA.GETM_ANI.CO_CONTINENTE_NACI%TYPE;
    v_co_pais_naci            IDOTABMAESTRA.GETM_ANI.CO_PAIS_NACI%TYPE;
    v_co_departamento_naci    IDOTABMAESTRA.GETM_ANI.CO_DEPARTAMENTO_NACI%TYPE;
    v_co_provincia_naci       IDOTABMAESTRA.GETM_ANI.CO_PROVINCIA_NACI%TYPE;
    v_co_distrito_naci        IDOTABMAESTRA.GETM_ANI.CO_DISTRITO_NACI%TYPE;
    v_co_centro_poblado_naci  IDOTABMAESTRA.GETM_ANI.CO_CENTRO_POBLADO_NACI%TYPE;
BEGIN
    get_datos_dni_by_docnum('42429440', v_cursor);
    LOOP
        FETCH v_cursor INTO
            v_ap_primer, v_ap_segundo, v_prenom_inscrito, v_fe_nacimiento,
            v_co_continente_naci, v_co_pais_naci, v_co_departamento_naci,
            v_co_provincia_naci, v_co_distrito_naci, v_co_centro_poblado_naci;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            v_prenom_inscrito || ' ' || v_ap_primer || ' ' || v_ap_segundo
        );
    END LOOP;
    CLOSE v_cursor;
END;