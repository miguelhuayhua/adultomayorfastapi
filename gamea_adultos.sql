PGDMP     3                    {            gamea_adultos    14.9    14.9 b    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16394    gamea_adultos    DATABASE     k   CREATE DATABASE gamea_adultos WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Bolivia.1252';
    DROP DATABASE gamea_adultos;
                postgres    false            �            1255    16587    caso_x_distrito()    FUNCTION     N  CREATE FUNCTION public.caso_x_distrito() RETURNS TABLE(distrito integer, cantidad_casos bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT d.distrito, COUNT(c.id_caso) AS cantidad_casos
    FROM caso c
    JOIN domicilio d ON c.id_adulto = d.id_domicilio
    WHERE c.estado = 1
    GROUP BY d.distrito;
END;
$$;
 (   DROP FUNCTION public.caso_x_distrito();
       public          postgres    false            �            1255    32777    casos_x_accion()    FUNCTION        CREATE FUNCTION public.casos_x_accion() RETURNS TABLE(accion character varying, cantidad_casos bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT accion_realizada, COUNT(*) AS cantidad_casos
    FROM caso
    WHERE estado = 1
    GROUP BY accion_realizada;
END;
$$;
 '   DROP FUNCTION public.casos_x_accion();
       public          postgres    false            �            1255    16601    casos_x_dia()    FUNCTION     h  CREATE FUNCTION public.casos_x_dia() RETURNS bigint
    LANGUAGE plpgsql
    AS $$
BEGIN
    DECLARE
        cantidad bigint;
    BEGIN
        -- Contamos los casos registrados por día
        SELECT COUNT(*) INTO cantidad
        FROM caso
        WHERE TO_DATE(fecha_registro, 'YYYY-MM-DD') IS NOT NULL;
        
        RETURN cantidad;
    END;
END;
$$;
 $   DROP FUNCTION public.casos_x_dia();
       public          postgres    false            �            1255    16598    casos_x_genero()    FUNCTION     N  CREATE FUNCTION public.casos_x_genero() RETURNS TABLE(genero character varying, cantidad bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT am.genero, COUNT(c.id_caso) AS cantidad
    FROM adulto_mayor am
    LEFT JOIN caso c ON am.id_adulto = c.id_adulto
    WHERE c.estado = 1
    GROUP BY am.genero;
END;
$$;
 '   DROP FUNCTION public.casos_x_genero();
       public          postgres    false            �            1255    16591    casos_x_mes()    FUNCTION     H  CREATE FUNCTION public.casos_x_mes() RETURNS TABLE(mes numeric, cantidad_casos bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT EXTRACT(MONTH FROM TO_DATE(fecha_registro, 'YYYY-MM-DD')) - 1 AS mes, COUNT(*) AS cantidad_casos
    FROM caso
    WHERE estado = 1
    GROUP BY mes
    ORDER BY mes;
END;
$$;
 $   DROP FUNCTION public.casos_x_mes();
       public          postgres    false            �            1255    16600    casos_x_mes_actual()    FUNCTION     �  CREATE FUNCTION public.casos_x_mes_actual() RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    mes_actual integer;
    año_actual integer;
    cantidad_casos bigint;
BEGIN
    -- Obtenemos el mes y año actuales
    SELECT EXTRACT(MONTH FROM NOW()) INTO mes_actual;
    SELECT EXTRACT(YEAR FROM NOW()) INTO año_actual;

    -- Contamos los casos registrados en el mes y año actual
    SELECT COUNT(*) INTO cantidad_casos
    FROM caso
    WHERE EXTRACT(MONTH FROM TO_DATE(fecha_registro, 'YYYY-MM-DD')) = mes_actual
    AND EXTRACT(YEAR FROM TO_DATE(fecha_registro, 'YYYY-MM-DD')) = año_actual;

    RETURN cantidad_casos;
END;
$$;
 +   DROP FUNCTION public.casos_x_mes_actual();
       public          postgres    false            �            1255    16602    citaciones_x_mes()    FUNCTION     &  CREATE FUNCTION public.citaciones_x_mes() RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    mes_actual text;
    cantidad_citaciones bigint;
BEGIN
    -- Obtenemos el mes y año actuales en formato 'YYYY-MM'
    mes_actual := EXTRACT(YEAR FROM NOW()) || '-' || LPAD(EXTRACT(MONTH FROM NOW())::TEXT, 2, '0');

    -- Contamos las citaciones del mes actual
    SELECT COUNT(*) INTO cantidad_citaciones
    FROM citacion
    WHERE estado = 1
    AND SUBSTRING(fecha_creacion FROM 1 FOR 7) = mes_actual;

    RETURN cantidad_citaciones;
END;
$$;
 )   DROP FUNCTION public.citaciones_x_mes();
       public          postgres    false            �            1255    16597    conteo_tipologia()    FUNCTION       CREATE FUNCTION public.conteo_tipologia() RETURNS TABLE(tipologia character varying, cantidad_casos bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT c.tipologia, COUNT(*) AS cantidad_casos
    FROM caso c
    WHERE c.estado = 1
    GROUP BY c.tipologia;
END;
$$;
 )   DROP FUNCTION public.conteo_tipologia();
       public          postgres    false                       1255    40967    proximas_citaciones()    FUNCTION     V  CREATE FUNCTION public.proximas_citaciones() RETURNS TABLE(citacion_id character varying, fecha_citacion date, hora_citacion character varying, id_caso character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT citacion.id_citacion, TO_DATE(citacion.fecha_citacion, 'YYYY-MM-DD') AS fecha_citacion, citacion.hora_citacion, citacion.id_caso
    FROM citacion
    WHERE TO_DATE(citacion.fecha_citacion, 'YYYY-MM-DD') >= NOW()::date
    AND TO_DATE(citacion.fecha_citacion, 'YYYY-MM-DD') <= (NOW() + INTERVAL '7 days')::date
	AND citacion.suspendido=0 AND ESTADO =1;
END;
$$;
 ,   DROP FUNCTION public.proximas_citaciones();
       public          postgres    false            �            1255    16599    rango_edades()    FUNCTION     �  CREATE FUNCTION public.rango_edades() RETURNS TABLE(rango text, cantidad bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        CASE
            WHEN edad BETWEEN 60 AND 69 THEN '60-69'
            WHEN edad BETWEEN 70 AND 79 THEN '70-79'
            WHEN edad BETWEEN 80 AND 89 THEN '80-89'
            WHEN edad >= 90 THEN '90 o más'
        END AS rango,
        COUNT(*) AS cantidad
    FROM adulto_mayor
    WHERE edad >= 60
    GROUP BY rango
    ORDER BY MIN(edad);
END;
$$;
 %   DROP FUNCTION public.rango_edades();
       public          postgres    false                       1255    16606    suspendidos_x_mes()    FUNCTION     �  CREATE FUNCTION public.suspendidos_x_mes() RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    cantidad_suspendidos bigint;
BEGIN
    -- Contamos las citaciones suspendidas del mes actual
    SELECT COUNT(*) INTO cantidad_suspendidos
    FROM citacion
    WHERE estado = 1
    AND TO_DATE(fecha_creacion, 'YYYY-MM-DD') >= NOW()::date
    AND TO_DATE(fecha_creacion, 'YYYY-MM-DD') <= (NOW() + INTERVAL '30 days')::date
    AND suspendido = 1;
    RETURN cantidad_suspendidos;
END;
$$;
 *   DROP FUNCTION public.suspendidos_x_mes();
       public          postgres    false            �            1255    16621     total_horas_acceso_usuario(text)    FUNCTION     �  CREATE FUNCTION public.total_horas_acceso_usuario(id_usuario_param text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_hours bigint;
BEGIN
    SELECT COALESCE(EXTRACT(EPOCH FROM SUM(CAST(fecha_hora_salida AS time) - CAST(fecha_hora_acceso AS time))), 0)
    INTO total_hours
    FROM acceso_usuario
    WHERE id_usuario = id_usuario_param;
    
    RETURN total_hours;
END;
$$;
 H   DROP FUNCTION public.total_horas_acceso_usuario(id_usuario_param text);
       public          postgres    false            �            1259    16398    acceso_usuario    TABLE     8  CREATE TABLE public.acceso_usuario (
    id_acceso character varying NOT NULL,
    estado smallint DEFAULT 1,
    id_usuario character varying NOT NULL,
    fecha_hora_acceso timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_hora_salida timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
 "   DROP TABLE public.acceso_usuario;
       public         heap    postgres    false            �            1259    16408    acciones_usuario    TABLE        CREATE TABLE public.acciones_usuario (
    id_accion character varying(20) NOT NULL,
    tabla character varying NOT NULL,
    tipo character varying NOT NULL,
    id_usuario character varying NOT NULL,
    fecha_hora_accion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 $   DROP TABLE public.acciones_usuario;
       public         heap    postgres    false            �            1259    16425    adulto_mayor    TABLE     I  CREATE TABLE public.adulto_mayor (
    id_adulto character varying(20) NOT NULL,
    nombre text NOT NULL,
    paterno text,
    materno text,
    edad integer,
    ci integer,
    genero character varying(20),
    f_nacimiento date,
    estado_civil character varying,
    nro_referencia integer,
    ocupacion character varying,
    beneficios character varying,
    grado character varying,
    expedido character varying,
    estado smallint DEFAULT 1 NOT NULL,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    complemento character varying
);
     DROP TABLE public.adulto_mayor;
       public         heap    postgres    false            �            1259    16443    caso    TABLE     �  CREATE TABLE public.caso (
    id_caso character varying(20) NOT NULL,
    fecha_registro character varying,
    hora_registro character varying,
    tipologia character varying,
    nro_caso character varying,
    descripcion_hechos text,
    peticion character varying,
    id_adulto character varying,
    estado smallint DEFAULT 1 NOT NULL,
    accion_realizada character varying,
    ult_modificacion timestamp with time zone
);
    DROP TABLE public.caso;
       public         heap    postgres    false            �            1259    16452    citacion    TABLE     �  CREATE TABLE public.citacion (
    id_citacion character varying(20) NOT NULL,
    fecha_creacion character varying,
    id_caso character varying(20) NOT NULL,
    fecha_citacion character varying,
    numero integer,
    hora_citacion character varying,
    suspendido smallint DEFAULT 0,
    estado smallint DEFAULT 1,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.citacion;
       public         heap    postgres    false            �            1259    16461    citado    TABLE     0  CREATE TABLE public.citado (
    id_citado character varying(20) NOT NULL,
    id_citacion character varying(20) NOT NULL,
    nombres_apellidos text,
    ult_modificacion time with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado smallint DEFAULT 1 NOT NULL,
    genero character varying(20)
);
    DROP TABLE public.citado;
       public         heap    postgres    false            �            1259    16470 
   denunciado    TABLE     �  CREATE TABLE public.denunciado (
    id_denunciado character varying(20) NOT NULL,
    nombres character varying NOT NULL,
    paterno character varying,
    materno character varying,
    genero character varying(20),
    parentezco character varying,
    ci integer,
    expedido character varying(15),
    estado smallint DEFAULT 1 NOT NULL,
    id_caso character varying(20) NOT NULL,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    complemento character varying
);
    DROP TABLE public.denunciado;
       public         heap    postgres    false            �            1259    16416    detalle_acta_compromiso    TABLE     �   CREATE TABLE public.detalle_acta_compromiso (
    id_compromiso character varying(20) NOT NULL,
    id_caso character varying NOT NULL,
    ult_modificacion time with time zone DEFAULT CURRENT_TIMESTAMP,
    estado smallint DEFAULT 1 NOT NULL
);
 +   DROP TABLE public.detalle_acta_compromiso;
       public         heap    postgres    false            �            1259    16434    detalle_audiencia_suspendida    TABLE     V  CREATE TABLE public.detalle_audiencia_suspendida (
    id_audiencia_suspendida character varying(20) NOT NULL,
    causa character varying,
    observacion character varying,
    ult_modificacion time with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado smallint DEFAULT 1 NOT NULL,
    id_citacion character varying(20) NOT NULL
);
 0   DROP TABLE public.detalle_audiencia_suspendida;
       public         heap    postgres    false            �            1259    16479 	   domicilio    TABLE     �  CREATE TABLE public.domicilio (
    id_domicilio character varying(20) NOT NULL,
    distrito integer,
    zona text,
    calle_av text,
    nro_vivienda integer,
    area character varying,
    otra_area character varying,
    actual smallint DEFAULT 1 NOT NULL,
    tipo_domicilio character varying,
    otro_domicilio character varying,
    ult_modificacion time with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado smallint DEFAULT 1,
    id_adulto character varying(20) NOT NULL
);
    DROP TABLE public.domicilio;
       public         heap    postgres    false            �            1259    16489    hijo    TABLE     "  CREATE TABLE public.hijo (
    id_hijo character varying(20) NOT NULL,
    nombres_apellidos character varying,
    genero character varying,
    estado smallint DEFAULT 1 NOT NULL,
    id_adulto character varying,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.hijo;
       public         heap    postgres    false            �            1259    16498    persona    TABLE       CREATE TABLE public.persona (
    id_persona character varying(20) NOT NULL,
    nombres character varying NOT NULL,
    paterno character varying,
    materno character varying,
    genero character varying(15),
    profesion character varying,
    ci integer,
    expedido character varying(10),
    celular integer,
    f_nacimiento date,
    cargo character varying,
    estado smallint DEFAULT 1 NOT NULL,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    complemento character varying
);
    DROP TABLE public.persona;
       public         heap    postgres    false            �            1259    16611    sec_audiencia_suspendida    SEQUENCE     �   CREATE SEQUENCE public.sec_audiencia_suspendida
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sec_audiencia_suspendida;
       public          postgres    false            �            1259    16607    sec_id_acceso    SEQUENCE     v   CREATE SEQUENCE public.sec_id_acceso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.sec_id_acceso;
       public          postgres    false            �            1259    16608    sec_id_accion    SEQUENCE     v   CREATE SEQUENCE public.sec_id_accion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.sec_id_accion;
       public          postgres    false            �            1259    16609    sec_id_acta_compromiso    SEQUENCE        CREATE SEQUENCE public.sec_id_acta_compromiso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.sec_id_acta_compromiso;
       public          postgres    false            �            1259    16610    sec_id_adulto    SEQUENCE     v   CREATE SEQUENCE public.sec_id_adulto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.sec_id_adulto;
       public          postgres    false            �            1259    16612    sec_id_caso    SEQUENCE     t   CREATE SEQUENCE public.sec_id_caso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.sec_id_caso;
       public          postgres    false            �            1259    16613    sec_id_citacion    SEQUENCE     x   CREATE SEQUENCE public.sec_id_citacion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.sec_id_citacion;
       public          postgres    false            �            1259    16614    sec_id_citado    SEQUENCE     v   CREATE SEQUENCE public.sec_id_citado
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.sec_id_citado;
       public          postgres    false            �            1259    16615    sec_id_denunciado    SEQUENCE     z   CREATE SEQUENCE public.sec_id_denunciado
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sec_id_denunciado;
       public          postgres    false            �            1259    16616    sec_id_domicilio    SEQUENCE     y   CREATE SEQUENCE public.sec_id_domicilio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.sec_id_domicilio;
       public          postgres    false            �            1259    16617    sec_id_hijo    SEQUENCE     t   CREATE SEQUENCE public.sec_id_hijo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.sec_id_hijo;
       public          postgres    false            �            1259    16618    sec_id_persona    SEQUENCE     w   CREATE SEQUENCE public.sec_id_persona
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.sec_id_persona;
       public          postgres    false            �            1259    16619    sec_id_seguimiento    SEQUENCE     {   CREATE SEQUENCE public.sec_id_seguimiento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sec_id_seguimiento;
       public          postgres    false            �            1259    16620    sec_id_usuario    SEQUENCE     w   CREATE SEQUENCE public.sec_id_usuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.sec_id_usuario;
       public          postgres    false            �            1259    16507    seguimiento    TABLE     Z  CREATE TABLE public.seguimiento (
    id_seguimiento character varying(20) NOT NULL,
    detalle_seguimiento text,
    id_caso character varying(20),
    fecha_seguimiento character varying,
    hora_seguimiento character varying,
    estado smallint DEFAULT 1 NOT NULL,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.seguimiento;
       public         heap    postgres    false            �            1259    16517    usuario    TABLE     D  CREATE TABLE public.usuario (
    id_usuario character varying(20) NOT NULL,
    usuario text NOT NULL,
    password text NOT NULL,
    fotografia text,
    id_persona character varying(20) NOT NULL,
    estado smallint DEFAULT 1 NOT NULL,
    ult_modificacion timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.usuario;
       public         heap    postgres    false            y          0    16398    acceso_usuario 
   TABLE DATA                 public          postgres    false    209   ;�       z          0    16408    acciones_usuario 
   TABLE DATA                 public          postgres    false    210   U�       |          0    16425    adulto_mayor 
   TABLE DATA                 public          postgres    false    212   o�       ~          0    16443    caso 
   TABLE DATA                 public          postgres    false    214   ��                 0    16452    citacion 
   TABLE DATA                 public          postgres    false    215   ��       �          0    16461    citado 
   TABLE DATA                 public          postgres    false    216   ��       �          0    16470 
   denunciado 
   TABLE DATA                 public          postgres    false    217   ׆       {          0    16416    detalle_acta_compromiso 
   TABLE DATA                 public          postgres    false    211   �       }          0    16434    detalle_audiencia_suspendida 
   TABLE DATA                 public          postgres    false    213   �       �          0    16479 	   domicilio 
   TABLE DATA                 public          postgres    false    218   %�       �          0    16489    hijo 
   TABLE DATA                 public          postgres    false    219   ?�       �          0    16498    persona 
   TABLE DATA                 public          postgres    false    220   Y�       �          0    16507    seguimiento 
   TABLE DATA                 public          postgres    false    221   }�       �          0    16517    usuario 
   TABLE DATA                 public          postgres    false    222   ��       �           0    0    sec_audiencia_suspendida    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sec_audiencia_suspendida', 1, true);
          public          postgres    false    227            �           0    0    sec_id_acceso    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sec_id_acceso', 1, true);
          public          postgres    false    223            �           0    0    sec_id_accion    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sec_id_accion', 1, true);
          public          postgres    false    224            �           0    0    sec_id_acta_compromiso    SEQUENCE SET     D   SELECT pg_catalog.setval('public.sec_id_acta_compromiso', 1, true);
          public          postgres    false    225            �           0    0    sec_id_adulto    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sec_id_adulto', 1, true);
          public          postgres    false    226            �           0    0    sec_id_caso    SEQUENCE SET     9   SELECT pg_catalog.setval('public.sec_id_caso', 1, true);
          public          postgres    false    228            �           0    0    sec_id_citacion    SEQUENCE SET     =   SELECT pg_catalog.setval('public.sec_id_citacion', 1, true);
          public          postgres    false    229            �           0    0    sec_id_citado    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sec_id_citado', 1, true);
          public          postgres    false    230            �           0    0    sec_id_denunciado    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sec_id_denunciado', 1, true);
          public          postgres    false    231            �           0    0    sec_id_domicilio    SEQUENCE SET     >   SELECT pg_catalog.setval('public.sec_id_domicilio', 1, true);
          public          postgres    false    232            �           0    0    sec_id_hijo    SEQUENCE SET     9   SELECT pg_catalog.setval('public.sec_id_hijo', 1, true);
          public          postgres    false    233            �           0    0    sec_id_persona    SEQUENCE SET     <   SELECT pg_catalog.setval('public.sec_id_persona', 2, true);
          public          postgres    false    234            �           0    0    sec_id_seguimiento    SEQUENCE SET     @   SELECT pg_catalog.setval('public.sec_id_seguimiento', 1, true);
          public          postgres    false    235            �           0    0    sec_id_usuario    SEQUENCE SET     <   SELECT pg_catalog.setval('public.sec_id_usuario', 2, true);
          public          postgres    false    236            �           2606    16407 "   acceso_usuario acceso_usuario_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.acceso_usuario
    ADD CONSTRAINT acceso_usuario_pkey PRIMARY KEY (id_acceso);
 L   ALTER TABLE ONLY public.acceso_usuario DROP CONSTRAINT acceso_usuario_pkey;
       public            postgres    false    209            �           2606    16415 &   acciones_usuario acciones_usuario_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.acciones_usuario
    ADD CONSTRAINT acciones_usuario_pkey PRIMARY KEY (id_accion);
 P   ALTER TABLE ONLY public.acciones_usuario DROP CONSTRAINT acciones_usuario_pkey;
       public            postgres    false    210            �           2606    16433    adulto_mayor adulto_mayor_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.adulto_mayor
    ADD CONSTRAINT adulto_mayor_pkey PRIMARY KEY (id_adulto);
 H   ALTER TABLE ONLY public.adulto_mayor DROP CONSTRAINT adulto_mayor_pkey;
       public            postgres    false    212            �           2606    16451    caso caso_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.caso
    ADD CONSTRAINT caso_pkey PRIMARY KEY (id_caso);
 8   ALTER TABLE ONLY public.caso DROP CONSTRAINT caso_pkey;
       public            postgres    false    214            �           2606    16460    citacion citacion_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.citacion
    ADD CONSTRAINT citacion_pkey PRIMARY KEY (id_citacion);
 @   ALTER TABLE ONLY public.citacion DROP CONSTRAINT citacion_pkey;
       public            postgres    false    215            �           2606    16469    citado citado_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.citado
    ADD CONSTRAINT citado_pkey PRIMARY KEY (id_citado);
 <   ALTER TABLE ONLY public.citado DROP CONSTRAINT citado_pkey;
       public            postgres    false    216            �           2606    16478    denunciado denunciado_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.denunciado
    ADD CONSTRAINT denunciado_pkey PRIMARY KEY (id_denunciado);
 D   ALTER TABLE ONLY public.denunciado DROP CONSTRAINT denunciado_pkey;
       public            postgres    false    217            �           2606    16424 4   detalle_acta_compromiso detalle_acta_compromiso_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.detalle_acta_compromiso
    ADD CONSTRAINT detalle_acta_compromiso_pkey PRIMARY KEY (id_compromiso);
 ^   ALTER TABLE ONLY public.detalle_acta_compromiso DROP CONSTRAINT detalle_acta_compromiso_pkey;
       public            postgres    false    211            �           2606    16442 >   detalle_audiencia_suspendida detalle_audiencia_suspendida_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.detalle_audiencia_suspendida
    ADD CONSTRAINT detalle_audiencia_suspendida_pkey PRIMARY KEY (id_audiencia_suspendida);
 h   ALTER TABLE ONLY public.detalle_audiencia_suspendida DROP CONSTRAINT detalle_audiencia_suspendida_pkey;
       public            postgres    false    213            �           2606    16488    domicilio domicilio_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.domicilio
    ADD CONSTRAINT domicilio_pkey PRIMARY KEY (id_domicilio);
 B   ALTER TABLE ONLY public.domicilio DROP CONSTRAINT domicilio_pkey;
       public            postgres    false    218            �           2606    16497    hijo hijo_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.hijo
    ADD CONSTRAINT hijo_pkey PRIMARY KEY (id_hijo);
 8   ALTER TABLE ONLY public.hijo DROP CONSTRAINT hijo_pkey;
       public            postgres    false    219            �           2606    16506    persona persona_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id_persona);
 >   ALTER TABLE ONLY public.persona DROP CONSTRAINT persona_pkey;
       public            postgres    false    220            �           2606    16515    seguimiento seguimiento_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.seguimiento
    ADD CONSTRAINT seguimiento_pkey PRIMARY KEY (id_seguimiento);
 F   ALTER TABLE ONLY public.seguimiento DROP CONSTRAINT seguimiento_pkey;
       public            postgres    false    221            �           2606    16525    usuario usuario_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario);
 >   ALTER TABLE ONLY public.usuario DROP CONSTRAINT usuario_pkey;
       public            postgres    false    222            �           2606    16551    denunciado fk2_id_caso    FK CONSTRAINT     �   ALTER TABLE ONLY public.denunciado
    ADD CONSTRAINT fk2_id_caso FOREIGN KEY (id_caso) REFERENCES public.caso(id_caso) NOT VALID;
 @   ALTER TABLE ONLY public.denunciado DROP CONSTRAINT fk2_id_caso;
       public          postgres    false    217    214    3281            �           2606    16531    acciones_usuario fk2_id_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY public.acciones_usuario
    ADD CONSTRAINT fk2_id_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) NOT VALID;
 I   ALTER TABLE ONLY public.acciones_usuario DROP CONSTRAINT fk2_id_usuario;
       public          postgres    false    3297    210    222            �           2606    16566    domicilio fk3_id_adulto    FK CONSTRAINT     �   ALTER TABLE ONLY public.domicilio
    ADD CONSTRAINT fk3_id_adulto FOREIGN KEY (id_adulto) REFERENCES public.adulto_mayor(id_adulto) NOT VALID;
 A   ALTER TABLE ONLY public.domicilio DROP CONSTRAINT fk3_id_adulto;
       public          postgres    false    212    3277    218            �           2606    16556 #   detalle_acta_compromiso fk3_id_caso    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_acta_compromiso
    ADD CONSTRAINT fk3_id_caso FOREIGN KEY (id_caso) REFERENCES public.caso(id_caso) NOT VALID;
 M   ALTER TABLE ONLY public.detalle_acta_compromiso DROP CONSTRAINT fk3_id_caso;
       public          postgres    false    214    3281    211            �           2606    16571    hijo fk4_id_adulto    FK CONSTRAINT     �   ALTER TABLE ONLY public.hijo
    ADD CONSTRAINT fk4_id_adulto FOREIGN KEY (id_adulto) REFERENCES public.adulto_mayor(id_adulto) NOT VALID;
 <   ALTER TABLE ONLY public.hijo DROP CONSTRAINT fk4_id_adulto;
       public          postgres    false    212    3277    219            �           2606    16576    seguimiento fk5_id_caso    FK CONSTRAINT     �   ALTER TABLE ONLY public.seguimiento
    ADD CONSTRAINT fk5_id_caso FOREIGN KEY (id_caso) REFERENCES public.caso(id_caso) NOT VALID;
 A   ALTER TABLE ONLY public.seguimiento DROP CONSTRAINT fk5_id_caso;
       public          postgres    false    214    3281    221            �           2606    16536    caso fk_id_adulto    FK CONSTRAINT     �   ALTER TABLE ONLY public.caso
    ADD CONSTRAINT fk_id_adulto FOREIGN KEY (id_adulto) REFERENCES public.adulto_mayor(id_adulto) NOT VALID;
 ;   ALTER TABLE ONLY public.caso DROP CONSTRAINT fk_id_adulto;
       public          postgres    false    214    212    3277            �           2606    16541    citacion fk_id_caso    FK CONSTRAINT     �   ALTER TABLE ONLY public.citacion
    ADD CONSTRAINT fk_id_caso FOREIGN KEY (id_caso) REFERENCES public.caso(id_caso) NOT VALID;
 =   ALTER TABLE ONLY public.citacion DROP CONSTRAINT fk_id_caso;
       public          postgres    false    214    3281    215            �           2606    16546    citado fk_id_citacion    FK CONSTRAINT     �   ALTER TABLE ONLY public.citado
    ADD CONSTRAINT fk_id_citacion FOREIGN KEY (id_citacion) REFERENCES public.citacion(id_citacion) NOT VALID;
 ?   ALTER TABLE ONLY public.citado DROP CONSTRAINT fk_id_citacion;
       public          postgres    false    215    3283    216            �           2606    16561 +   detalle_audiencia_suspendida fk_id_citacion    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_audiencia_suspendida
    ADD CONSTRAINT fk_id_citacion FOREIGN KEY (id_citacion) REFERENCES public.citacion(id_citacion) NOT VALID;
 U   ALTER TABLE ONLY public.detalle_audiencia_suspendida DROP CONSTRAINT fk_id_citacion;
       public          postgres    false    215    3283    213            �           2606    16581    usuario fk_id_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_id_persona FOREIGN KEY (id_persona) REFERENCES public.persona(id_persona) NOT VALID;
 ?   ALTER TABLE ONLY public.usuario DROP CONSTRAINT fk_id_persona;
       public          postgres    false    220    3293    222            �           2606    16526    acceso_usuario fk_id_usuario    FK CONSTRAINT     �   ALTER TABLE ONLY public.acceso_usuario
    ADD CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuario(id_usuario) NOT VALID;
 F   ALTER TABLE ONLY public.acceso_usuario DROP CONSTRAINT fk_id_usuario;
       public          postgres    false    3297    222    209            y   
   x���          z   
   x���          |   
   x���          ~   
   x���             
   x���          �   
   x���          �   
   x���          {   
   x���          }   
   x���          �   
   x���          �   
   x���          �     x�M��n�0��}�s�&��� ݕS�H�u��%�4��H�J{���Z�eK������mJOI^@J�tiE��\JV0M��H�]4��ȵT��r�k��VW>%��y#sP�vj+��Zʪ��r���7|+kM�Xv�WQ�~����w�^��&;''�;G�8�Oyb��dY�c�M���G�?����ߴ5�{�$��C�1\�A���}����YV��7��.�.	�,�A��ċ�(�|ơ�,[ ��e�9K��PV���g��0[h�      �   
   x���          �     x�=��n�@F�<�]��	3#�Ѯ�����ݘ�{�0��b߾�4ݝ|9'�/�M�/� ��|ńt��*�bz�c���Z��I-�U�.��QZ0�u�hU��V�crmO�J1�D&��w�MSso3�S�%V��f�q�p9at"�.�͛���srkɗ�!�v�H4���/��1bz+n���}�����[L,�%��5S�]b��IRW��x�}fq��6�6g��jNWlI(e���M]s��u �v�:/ �[_<?���i^�     