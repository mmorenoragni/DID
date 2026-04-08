CREATE OR REPLACE PACKAGE DDPK_DNI_DNID AS
  --*************************************************************************************************
  -- Nombre               : IDODNIDIGITAL.DDPK_DNI_DNID
  -- Autor                : Mariano Moreno (IUGO)
  -- Version              : 1.0
  -- Descripcion          : Logica de Negocio para los Servicios de DNI digital - base de datos DNI
  -- Cambio               : Pase a producción
  -- Requerimientos       : Conexión con BD DNI - {a definir} => DB
  -- Cambio:              : {a definir}
  -- Comentarios DBA      :
  -- Fecha       Modificado por        Revisado por      Visado por          Descripcion del Cambio
  -- ==========  ==============        ==============    ============    =============================
  -- {a definir} Mariano Moreno                                          Pase a Producción
  -- *************************************************************************************************
  --
  ----------------------------------------------------------------------------------------------------
  -- Nombre del Procedimiento : DDSP_GET_DATOS_COMPLETO_DNI
  -- Autor                    : Mariano Moreno
  -- Versión                  : 1.0
  -- Creado                   : {a definir}
  -- Modificado               : {a definir}
  -- Propósito                : OBTENER INFORMACION NECESARIA PARA LA CREACION DE CREDENCIALES VERIFICABLES DNIDd
  -- Requerimientos           : Conexión con la base de datos DNI - {a definifr}.
  -- Parámetros               : p_nu_dni                 (IN)  : NUMERO DE DNIe
  --                            CUI_DNI                  (OUT) : NUMERO DE DOCUMENTO
  --                            PRENOMBRES               (OUT) : PRENOMBRE INSCRITO DE LA PERSONA
  --                            APELLIDO_PATERNO         (OUT) : APELLIDO PATERNO DE LA PERSONA
  --                            APELLIDO_MATERNO         (OUT) : APELLIDO MATERNO DE LA PERSONA
  --                            APELLIDO_CASADA          (OUT) : APELLIDO DE CASADA DE LA PERSONA
  --                            FE_NACIMIENTO            (OUT) : FECHA DE NACIMIENTO
  --                            CO_CONTINENTE_NACI       (OUT) : CONTIENENTE DE NACIMIENTO
  --                            CO_PAIS_NACI             (OUT) : PAIS DE NACIMIENTO
  --                            CO_DEPARTAMENTO_NACI     (OUT) : DEPARTAMENTO DE NACIMIENTO
  --                            CO_PROVINCIA_NACI        (OUT) : PROVINCIA DE NACIMIENTO
  --                            CO_DISTRITO_NACI         (OUT) : DISTRITO DE NACIMIENTO
  --                            CO_CENTRO_POBLADO_NACI   (OUT) : CENTRO PROBLADO DE NACIMIENTO
  --                            LUGAR_NACIMIENTO         (OUT) : LUCAS DE NACIMIENTO DE LA PERSONA REFERENCIA AL UBIGEO
  --                            ESTADO_CIVIL             (OUT) : ESTADO CIVIL DE LA PERSONA
  --                            FOTO                     (OUT) : FOTO DE LA CEDULA DE LA PERSONA
  --                            UBIGEO_DOMICILIO         (OUT) : CODIGO DE UBIGEO DEL DOMICILIO DE LA PERSONA
  --                            LUGAR_DOMICILIO          (OUT) : LUGAR DONDE RESIDE EL DOMICILIO
  --                            DOMICILIO                (OUT) : DOMICILIO NUMERICO Y CALLE
  --                            GRUPO_FACTOR_SANGUINEO   (OUT) : FACTOR SANGUINEO DE LA PERSONA
  --                            OBSERVACIONES            (OUT) : LISTA DE OBSERVACIONES ADJUNTAS
  --                            RESTRICCION              (OUT) : RESTRICCIONES DEL USUARIO
  --                            FECHA_EMISION_DNIE       (OUT) : FECHA EN QUE SE EMITIO EL DNID
  --                            FECHA_CADUCIDAD_DNIE     (OUT) : FECHA DE EXPIRACION DEL DNID
  --                            TIPO_DOC_PROGENITOR1     (OUT) : TIPO DE DOCUMENTO DEL PADRE
  --                            NUM_DOC_PROGENITOR1      (OUT) : NUMERO DE DOCUMENTO DEL PADRE
  --                            TIPO_DOC_PROGENITOR2     (OUT) : TIPO DE DOCUMETNO DE LA MADRE
  --                            NUM_DOC_PROGENITOR2      (OUT) : NUMERO DE DOCUMETNO DE LA MADRE
  --                            EMAIL                    (OUT) : DIRECCION DE CORREO ELECTRONICO DE LA PERSONA
  --                            NACIONALIDAD             (OUT) : NACIONALIDAD DE LA PERSONA
  ----------------------------------------------------------------------------------------------------
  PROCEDURE DDSP_GET_DATOS_COMPLETO_DNI(p_nu_dni    IN VARCHAR2,
                                        p_recordset OUT SYS_REFCURSOR);
  -- Nombre del Procedimiento : DDSP_INSERT_DNID_LOG
  -- Autor                    : Mariano Moreno
  -- Versión                  : 1.0
  -- Creado                   : {a definir}
  -- Modificado               : {a definir}
  -- Propósito                : OBTENER INFORMACION NECESARIA PARA LA CREACION DE CREDENCIALES VERIFICABLES DNIDd
  -- Requerimientos           : Conexión con la base de datos DNI - {a definifr}.
  -- Parámetros               : p_nu_dni                 (IN)  : NUMERO DE DNIe
  ----------------------------------------------------------------------------------------------------
  PROCEDURE DDSP_INSERT_DNID_LOG(
  p_id              IN dnid_logs.id%TYPE,
  p_mensaje_log     IN dnid_logs.mensaje_log%TYPE,
  p_dni_solicitante IN dnid_logs.dni_solicitante%TYPE DEFAULT NULL,
  p_dni_solicitado  IN dnid_logs.dni_solicitado%TYPE  DEFAULT NULL
);
END;
