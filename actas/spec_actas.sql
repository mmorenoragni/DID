CREATE OR REPLACE PACKAGE DDPK_ACTAS_DNID AS
  --*************************************************************************************************
  -- Nombre               : IDODNIDIGITAL.DDPK_DNI_DNID
  -- Autor                : Mariano Moreno (IUGO)
  -- Version              : 1.0
  -- Descripcion          : Logica de Negocio para los Servicios de DNI digital - base de datos DNI
  -- Cambio               : Pase a producción
  -- Requerimientos       : Conexión con BD DNI - IDDLEM01
  -- Cambio:              : 20.03.2023 - Pase a Producción
  -- Comentarios DBA      :
  -- Fecha       Modificado por        Revisado por      Visado por          Descripcion del Cambio
  -- ==========  ==============        ==============    ============    =============================
  -- 20/03/2023  Jose Vidal Flores                                       Pase a Producción
  -- 20/03/2023  Jose Vidal Flores                                       Implementar SP: IMSP_GET_DATOS_RENOVACION_CD - Datos para la renovacion de CD
  -- *************************************************************************************************
  --
  ----------------------------------------------------------------------------------------------------
  -- Nombre del Procedimiento : DDSP_ACTA_MATRIMONIO_BY_DOC
  -- Autor                    : Mariano Moreno
  -- Versión                  : 1.0
  -- Creado                   : 20/03/2023
  -- Modificado               : 04/04/2023
  -- Propósito                : OBTENER INFORMACION NECESARIA PARA LA RENOVACION DE CERTIFICADOS DIGITALES DEL DNIe
  -- Requerimientos           : Conexión con la base de datos DNI - IDDLEM01.
  -- Parámetros               : p_vNU_DNI                (IN OUT)  : NUMERO DE DNIe
  --                            p_vNU_CAN                (OUT) : NUMERO DE CAN DEL DNIe
  --                            p_vNU_FICHA_REG          (OUT) : NUMERO DE FICHA REGISTRAL
  --                            p_vDE_UBIGEO_LINEA1      (OUT) : DESCRIPCION DE UBIGEO LINEA 1
  --                            p_vDE_UBIGEO_LINEA2      (OUT) : DESCRIPCION DE UBIGEO LINEA 2
  --                            p_vDE_DIRECCION_LINEA1   (OUT) : DESCRIPCION DE DIRECCION LINEA 1
  --                            p_vDE_DIRECCION_LINEA2   (OUT) : DESCRIPCION DE DIRECCION LINEA 2
  --                            p_vDE_DIRECCION_LINEA3   (OUT) : DESCRIPCION DE DIRECCION LINEA 3
  --                            p_vDE_CORREO             (OUT) : DIRECCION DE EMAIL
  --                            p_vNU_PUK                (OUT) : VALOR DEL PUK DEL DNIe
  --                            p_vCO_TIPO_FICHA         (OUT) : CODIGO DE TIPO DE FICHA REGISTRAL
  --                            p_vNU_SERIE_TARJETA      (OUT) : NUMERO DE SERIE DE TARJETA DEL DNIe
  --                            p_vIN_VERSION_DNIE       (OUT) : INDICADOR DE VERSION DEL DNIe
  --                            p_bIM_WSQ_HUELLA1        (OUT) : WSQ HUELLA 1
  --                            p_bIM_WSQ_HUELLA2        (OUT) : WSQ HUELLA 2
  --                            p_nNU_LOTE               (OUT) : NUMERO DE LOTE ASOCIADO A LA ULTIMA ENTREGA DEL DNIe
  --                            p_vCO_RESULT             (OUT) : CODIGO DEL RESULTADO
  --                            p_vDE_RESULT             (OUT) : DESCRIPCION DEL RESULTADO
  ----------------------------------------------------------------------------------------------------
  PROCEDURE DDSP_ACTA_MATRIMONIO_BY_DOC(p_num_doc   IN VARCHAR2, -- Cambiamos a VARCHAR2 para documentos
                                        p_recordset OUT SYS_REFCURSOR -- Parámetro de salida
                                        );
  ----------------------------------------------------------------------------------------------------
  -- Nombre del Procedimiento : DDSP_GET_RECTIFICACION_NAC
  -- Autor                    : Mariano Moreno
  -- Versión                  : 1.0
  -- Creado                   : 20/03/2023
  -- Modificado               : 04/04/2023
  -- Propósito                : OBTENER INFORMACION NECESARIA PARA LA RENOVACION DE CERTIFICADOS DIGITALES DEL DNIe
  -- Requerimientos           : Conexión con la base de datos DNI - IDDLEM01.
  -- Parámetros               : p_vNU_DNI                (IN OUT)  : NUMERO DE DNIe
  --                            p_vNU_CAN                (OUT) : NUMERO DE CAN DEL DNIe
  --                            p_vNU_FICHA_REG          (OUT) : NUMERO DE FICHA REGISTRAL
  --                            p_vDE_UBIGEO_LINEA1      (OUT) : DESCRIPCION DE UBIGEO LINEA 1
  --                            p_vDE_UBIGEO_LINEA2      (OUT) : DESCRIPCION DE UBIGEO LINEA 2
  --                            p_vDE_DIRECCION_LINEA1   (OUT) : DESCRIPCION DE DIRECCION LINEA 1
  --                            p_vDE_DIRECCION_LINEA2   (OUT) : DESCRIPCION DE DIRECCION LINEA 2
  --                            p_vDE_DIRECCION_LINEA3   (OUT) : DESCRIPCION DE DIRECCION LINEA 3
  --                            p_vDE_CORREO             (OUT) : DIRECCION DE EMAIL
  --                            p_vNU_PUK                (OUT) : VALOR DEL PUK DEL DNIe
  --                            p_vCO_TIPO_FICHA         (OUT) : CODIGO DE TIPO DE FICHA REGISTRAL
  --                            p_vNU_SERIE_TARJETA      (OUT) : NUMERO DE SERIE DE TARJETA DEL DNIe
  --                            p_vIN_VERSION_DNIE       (OUT) : INDICADOR DE VERSION DEL DNIe
  --                            p_bIM_WSQ_HUELLA1        (OUT) : WSQ HUELLA 1
  --                            p_bIM_WSQ_HUELLA2        (OUT) : WSQ HUELLA 2
  --                            p_nNU_LOTE               (OUT) : NUMERO DE LOTE ASOCIADO A LA ULTIMA ENTREGA DEL DNIe
  --                            p_vCO_RESULT             (OUT) : CODIGO DEL RESULTADO
  --                            p_vDE_RESULT             (OUT) : DESCRIPCION DEL RESULTADO
  ----------------------------------------------------------------------------------------------------
  PROCEDURE DDSP_OBTENER_ACTA_NACIMIENTO(p_nu_cui    IN VARCHAR2,
                                         p_recordset OUT SYS_REFCURSOR);
  PROCEDURE RCSP_INSERTAR_ACTAS_LOG(p_vIdLog              IN rctl_actas_logs.id_log%TYPE,
                                    p_vDeMensajeLog       IN rctl_actas_logs.de_mensaje_log%TYPE,
                                    p_vCoDniSolicitante   IN rctl_actas_logs.co_dni_solicitante%TYPE DEFAULT NULL,
                                    p_vCoDniSolicitado    IN rctl_actas_logs.co_dni_solicitado%TYPE DEFAULT NULL,
                                    p_vDePerfilSolicitado IN rctl_actas_logs.de_perfil_solicitado%TYPE DEFAULT NULL,
                                    p_vIpDireccionOrigen  IN rctl_actas_logs.ip_direccion_origen%TYPE DEFAULT NULL,
                                    p_vEsResultado        IN rctl_actas_logs.es_resultado%TYPE DEFAULT NULL,
                                    p_vDeMensajeError     IN rctl_actas_logs.de_mensaje_error%TYPE DEFAULT NULL);
END;
