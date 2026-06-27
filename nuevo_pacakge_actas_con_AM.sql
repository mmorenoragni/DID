create or replace package body DDPK_ACTAS_DNID as
  procedure DDSP_ACTA_MATRIMONIO_BY_DOC(p_num_doc   in varchar2, -- Cambiamos a VARCHAR2 para documentos
                                        p_recordset out SYS_REFCURSOR -- Parámetro de salida
                                        ) as
  begin
    open p_recordset for
      select M.FE_DE_CELEBRACION,
             M.NU_ACTA_MATRIMONIO,
             M.DE_CELEBRADO_LUGAR,
             nvl(U.NO_DEPARTAMENTO, ' ') DE_DEPARTAMENTO_CELEBRACION,

             nvl(U.NO_PROVINCIA, ' ') DE_PROVINCIA_CELEBRACION,

             nvl(U.NO_DISTRITO, ' ') DE_DISTRITO_CELEBRACION,

             nvl(U.DE_CENTRO_POBLADO, ' ') DE_CENTRO_POBLADO_CELEBRACION,



             nvl(M.CO_CELEBRADO_DPTO, ' ') CO_DEPARTAMENTO_CELEBRACION,

             nvl(M.CO_CELEBRADO_PROV, ' ') CO_PROVINCIA_CELEBRACION,

             nvl(M.CO_CELEBRADO_DIST, ' ') CO_DISTRITO_CELEBRACION,

             nvl(M.CO_CELEBRADO_LOCA, ' ') CO_CENTRO_POBLADO_CELEBRACION,
             (select D.DE_DOC_IDENTIDAD
                from IDORRCC.RCTR_TIPO_DOC_IDENTIDAD D
               where D.CO_TIPO_DOC_IDENTIDAD =
                     M.CO_TIPO_DOC_IDENTIDAD_CTYENTE1) as tipoDocCONYUGE1,
             M.NU_DOC_IDENTIDAD_CTYENTE1,
             (select D.DE_DOC_IDENTIDAD
                from IDORRCC.RCTR_TIPO_DOC_IDENTIDAD D
               where D.CO_TIPO_DOC_IDENTIDAD =
                     M.CO_TIPO_DOC_IDENTIDAD_CTYENTE2) as tipoDocCONYUGE2,
             M.NU_DOC_IDENTIDAD_CTYENTE2,
             case
               when M.IM_MATRIMONIOS is not null then
                M.IM_MATRIMONIOS
               else
                R.IM_ACTA
             end as IMAGEN_ANVERSO,
             case
               when M.IM_MATRIMONIOS_REV is not null then
                M.IM_MATRIMONIOS_REV
               else
                I.IM_ACTA
             end as IMAGEN_REVERSO
        from IDORRCC.RCTM_MATRIMONIOS M
        left join IDORRCC.RCTM_ESCANEO R
          on R.NU_ACTA = M.NU_ACTA_MATRIMONIO
         and R.CO_TIPO_ACTA = '02'
         and R.CO_LADO_ACTA = 'A'
         and R.IM_ACTA is not null
        left join IDORRCC.RCTM_ESCANEO I
          on I.NU_ACTA = M.NU_ACTA_MATRIMONIO
         and I.CO_TIPO_ACTA = '02'
         and I.CO_LADO_ACTA = 'B'
         and I.IM_ACTA is not null
         left join IDORRCC.GEVW_UBIGEOS U on U.CO_CONTINENTE=M.CO_CELEBRADO_CONT
         and U.CO_PAIS=N.CO_CELEBRADO_PAIS
         and U.CO_DEPARTAMENTO=N.CO_CELEBRADO_DPTO
         and U.CO_PROVINCIA=N.CO_CELEBRADO_PROV
         and U.CO_DISTRITO=N.CO_CELEBRADO_DIST
         and U.CO_CENTRO_POBLADO_O=N.CO_CELEBRADO_LOCA
       where M.CO_ESTADO_ACTA_MATRIMONIO = '1'
         and (M.NU_DOC_IDENTIDAD_CTYENTE1 = p_num_doc or
             M.NU_DOC_IDENTIDAD_CTYENTE2 = p_num_doc); -- Filtro por cualquiera de los dos
  end DDSP_ACTA_MATRIMONIO_BY_DOC;
  procedure DDSP_OBTENER_ACTA_NACIMIENTO(p_nu_cui    in varchar2,
                                         p_recordset out SYS_REFCURSOR) as
  begin
    open p_recordset for
      select N.NU_ACTA_NACIMIENTO,
             N.NU_CUI,
             nvl(N.CO_NACIDO_NATURAL_DPTO, ' ') CO_DEPARTAMENTO_NACIMIENTO,
             nvl(N.CO_NACIDO_NATURAL_PROV, ' ') CO_PROVINCIA_NACIMIENTO,
             nvl(N.CO_NACIDO_NATURAL_DIST, ' ') CO_DISTRITO_NACIMIENTO,
             nvl(N.CO_NACIDO_NATURAL_LOCA, ' ') CO_CENTRO_POBLADO_NACIMIENTO,
             nvl(UN.NO_DEPARTAMENTO, ' ') DE_DEPARTAMENTO_NACIMIENTO,
             nvl(UN.NO_PROVINCIA, ' ') DE_PROVINCIA_NACIMIENTO,
             nvl(UN.NO_DISTRITO, ' ') DE_DISTRITO_NACIMIENTO,
             nvl((select G.DE_TIPO_LUGAR from IDORRCC.RCTR_TIPO_LUGAR G
             where G.CO_TIPO_LUGAR=N.CO_TIPO_LUGAR_NACIMIENTO), ' ') DE_TIPO_LUGAR,
             nvl(N.NO_LUGAR_NACIMIENTO, ' ') NO_LUGAR,
             N.DE_PRE_NOMBRES,
             N.DE_PRIMER_APELLIDO,
             N.DE_SEGUNDO_APELLIDO,
             N.FE_NACIMIENTO,
             N.IM_NACIMIENTOS_REV  as IMAGEN_REVERSO,
             N.IM_NACIMIENTOS      as IMAGEN_ANVERSO
        from

  IDORRCC.RCTM_NACIMIENTOS N

join IDORRCC.RCTM_NACIMIENTOS_ACTORES M
on M.NU_ACTA_NACIMIENTO=N.NU_ACTA_NACIMIENTO
and M.CO_TIPO_ACTOR_NACIMIENTO='01'

join IDORRCC.RCTM_NACIMIENTOS_ACTORES P
on P.NU_ACTA_NACIMIENTO=N.NU_ACTA_NACIMIENTO
and P.CO_TIPO_ACTOR_NACIMIENTO='02'

left join IDORRCC.RCTM_ESCANEO R  on R.NU_ACTA=N.NU_ACTA_NACIMIENTO
and R.CO_TIPO_ACTA='01' and R.CO_LADO_ACTA='A' and R.IM_ACTA is not null

left join IDORRCC.RCTM_ESCANEO I on I.NU_ACTA=N.NU_ACTA_NACIMIENTO
and I.CO_TIPO_ACTA='01' and I.CO_LADO_ACTA='B' and I.IM_ACTA is not null

left join  IDORRCC.GEVW_UBIGEOS UN on   UN.CO_CONTINENTE =
N.CO_NACIDO_NATURAL_CONT  and UN.CO_PAIS = N.CO_NACIDO_NATURAL_PAIS
and UN.CO_DEPARTAMENTO = N.CO_NACIDO_NATURAL_DPTO

        and UN.CO_PROVINCIA = N.CO_NACIDO_NATURAL_PROV

        and UN.CO_DISTRITO = N.CO_NACIDO_NATURAL_DIST

        and UN.CO_CENTRO_POBLADO_O =N.CO_NACIDO_NATURAL_LOCA
       where N.CO_ESTADO_ACTA_NACIMIENTO = '1'
         and N.NU_CUI = p_nu_cui;
  end DDSP_OBTENER_ACTA_NACIMIENTO;
  procedure DDSP_OBTENER_AM_ACTA_NAC(p_nu_acta   in varchar2,
                                     p_recordset out SYS_REFCURSOR) as
  begin
    open p_recordset for
      select J.NU_ACTA_NACIMIENTO, J.DE_MATERIA, J.DE_TRANSCRIPCION
        from IDORRCC.RCTV_ACTA_RECTIFICACION_NAC J,
             IDORRCC.RCTR_NACIMIENTOS_PROCESOS   P
       where J.CO_PROCESO_NACIMIENTO = P.CO_PROCESO_NACIMIENTO
         and nvl(J.IN_LINEA, ' ') = '1'
         and J.ES_REGISTRO = '1'
         and nvl(P.IN_IMPRIME_AM, ' ') = '1'
         and J.NU_ACTA_NACIMIENTO = p_nu_acta;
  end DDSP_OBTENER_AM_ACTA_NAC;
  procedure DDSP_OBTENER_AM_ACTA_MAT(p_nu_acta   in varchar2,
                                     p_recordset out SYS_REFCURSOR) as
  begin
    open p_recordset for
      select J.NU_ACTA_MATRIMONIO, J.DE_MATERIA, J.DE_TRANSCRIPCION
        from IDORRCC.RCTV_ACTA_RECTIFICACION_MAT J,
             IDORRCC.RCTR_MATRIMONIOS_PROCESOS   P
       where J.CO_PROCESO_MATRIMONIO = P.CO_PROCESO_MATRIMONIO
         and nvl(J.IN_LINEA, ' ') = '1'
         and J.ES_REGISTRO = '1'
         and nvl(P.IN_IMPRIME_AM, ' ') = '1'
         and J.NU_ACTA_MATRIMONIO = p_nu_acta;
  end DDSP_OBTENER_AM_ACTA_MAT;
  procedure RCSP_INSERTAR_ACTAS_LOG(p_vIdLog              in rctl_actas_logs.id_log%type,
                                    p_vDeMensajeLog       in rctl_actas_logs.de_mensaje_log%type,
                                    p_vCoDniSolicitante   in rctl_actas_logs.co_dni_solicitante%type default null,
                                    p_vCoDniSolicitado    in rctl_actas_logs.co_dni_solicitado%type default null,
                                    p_vDePerfilSolicitado in rctl_actas_logs.de_perfil_solicitado%type default null,
                                    p_vIpDireccionOrigen  in rctl_actas_logs.ip_direccion_origen%type default null,
                                    p_vEsResultado        in rctl_actas_logs.es_resultado%type default null,
                                    p_vDeMensajeError     in rctl_actas_logs.de_mensaje_error%type default null) as
  begin
    insert into rctl_actas_logs
      (id_log,
       de_mensaje_log,
       co_dni_solicitante,
       co_dni_solicitado,
       de_perfil_solicitado,
       ip_direccion_origen,
       es_resultado,
       de_mensaje_error)
    values
      (p_vIdLog,
       p_vDeMensajeLog,
       p_vCoDniSolicitante,
       p_vCoDniSolicitado,
       p_vDePerfilSolicitado,
       p_vIpDireccionOrigen,
       p_vEsResultado,
       p_vDeMensajeError);
  end RCSP_INSERTAR_ACTAS_LOG;
end;
