-- Esquema PostgreSQL del MVP — Fase 3.
-- Contiene exactamente las 21 tablas MVP aprobadas y no crea estructuras de ampliación.
-- PREF_ es un marcador temporal que se sustituirá solo cuando el autor confirme las iniciales.
-- Los valores PREVENTIVA, COLABORADOR y RETIRADA permanecen reservados en restricciones de
-- diseño, pero los Services y las interfaces del MVP no los habilitarán.
-- DUPLICADA y CANCELADA no se cargan en los catálogos MVP.
-- Este archivo define el esquema físico; Prisma deberá mapearlo sin eliminar restricciones.

BEGIN;

-- MVP: Catálogo de funciones autorizadas.
CREATE TABLE PREF_ROL (
    id_rol BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_ROL_BASE PRIMARY KEY (id_rol)
);

-- MVP: Persona con acceso o participación registrada.
CREATE TABLE PREF_USUARIO (
    id_usuario BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    nombre_acceso VARCHAR(80) NOT NULL UNIQUE,
    credencial_hash VARCHAR(255) NOT NULL,
    nombres VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    correo VARCHAR(254) UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PREF_PK_USUARIO_BASE PRIMARY KEY (id_usuario)
);

-- MVP: Asignación histórica de roles a usuarios.
CREATE TABLE PREF_USUARIO_ROL (
    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,
    fecha_desde TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hasta TIMESTAMPTZ,
    CONSTRAINT PREF_PK_USUARIO_ROL_BASE PRIMARY KEY (id_usuario, id_rol, fecha_desde),
    CONSTRAINT PREF_FK_USUARIO_ROL_1 FOREIGN KEY (id_usuario) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_USUARIO_ROL_2 FOREIGN KEY (id_rol) REFERENCES PREF_ROL (id_rol) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_USUARIO_ROL_1 CHECK (fecha_hasta IS NULL OR fecha_hasta >= fecha_desde)
);

CREATE INDEX PREF_IX_UR_ROL ON PREF_USUARIO_ROL (id_rol, fecha_hasta);

-- MVP: Sede física de la institución.
CREATE TABLE PREF_SEDE (
    id_sede BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(120) NOT NULL,
    direccion_referencia VARCHAR(300),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_SEDE_BASE PRIMARY KEY (id_sede)
);

-- MVP: Área física donde se reportan y ejecutan trabajos.
CREATE TABLE PREF_ESPACIO (
    id_espacio BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_sede BIGINT NOT NULL,
    codigo VARCHAR(40) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    tipo VARCHAR(60) NOT NULL,
    ubicacion_referencia VARCHAR(250),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_ESPACIO_BASE PRIMARY KEY (id_espacio),
    CONSTRAINT PREF_FK_ESPACIO_1 FOREIGN KEY (id_sede) REFERENCES PREF_SEDE (id_sede) ON DELETE RESTRICT,
    CONSTRAINT PREF_UQ_ESP_SEDE_COD UNIQUE (id_sede, codigo)
);

CREATE INDEX PREF_IX_ESP_SEDE ON PREF_ESPACIO (id_sede);

-- MVP: Autoriza quién puede verificar trabajos de un espacio.
CREATE TABLE PREF_RESPONSABLE_ESPACIO (
    id_responsabilidad BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_espacio BIGINT NOT NULL,
    id_usuario BIGINT NOT NULL,
    fecha_desde TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_hasta TIMESTAMPTZ,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT PREF_PK_RESPONSABLE__BASE PRIMARY KEY (id_responsabilidad),
    CONSTRAINT PREF_FK_RESPONSABLE__1 FOREIGN KEY (id_espacio) REFERENCES PREF_ESPACIO (id_espacio) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_RESPONSABLE__2 FOREIGN KEY (id_usuario) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_UQ_RESP_ESP_VIG UNIQUE (id_espacio, id_usuario, fecha_desde),
    CONSTRAINT PREF_CK_RESPONSABLE__1 CHECK (fecha_hasta IS NULL OR fecha_hasta >= fecha_desde)
);

CREATE INDEX PREF_IX_RESP_USU ON PREF_RESPONSABLE_ESPACIO (id_usuario, fecha_hasta);
CREATE UNIQUE INDEX PREF_UQ_RESP_PRINCIPAL_VIG
    ON PREF_RESPONSABLE_ESPACIO (id_espacio)
    WHERE fecha_hasta IS NULL AND es_principal = TRUE;

-- MVP: Clasificación funcional del desperfecto.
CREATE TABLE PREF_CATEGORIA_INCIDENCIA (
    id_categoria BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_CATEGORIA_IN_BASE PRIMARY KEY (id_categoria)
);

-- MVP: Catálogo ordenado de prioridad operativa.
CREATE TABLE PREF_PRIORIDAD (
    id_prioridad BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(60) NOT NULL,
    nivel_orden INTEGER NOT NULL UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_PRIORIDAD_BASE PRIMARY KEY (id_prioridad),
    CONSTRAINT PREF_CK_PRIORIDAD_1 CHECK (nivel_orden > 0)
);

-- MVP: Catálogo del ciclo de vida de incidencias.
CREATE TABLE PREF_ESTADO_INCIDENCIA (
    id_estado_incidencia BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    es_terminal BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_ESTADO_INCID_BASE PRIMARY KEY (id_estado_incidencia)
);

-- MVP: Necesidad reportada por un solicitante.
CREATE TABLE PREF_INCIDENCIA (
    id_incidencia BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    id_solicitante BIGINT NOT NULL,
    id_espacio BIGINT NOT NULL,
    id_categoria BIGINT NOT NULL,
    id_prioridad BIGINT,
    id_estado_incidencia BIGINT NOT NULL,
    descripcion VARCHAR(2000) NOT NULL,
    urgencia_declarada BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PREF_PK_INCIDENCIA_BASE PRIMARY KEY (id_incidencia),
    CONSTRAINT PREF_FK_INCIDENCIA_1 FOREIGN KEY (id_solicitante) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_INCIDENCIA_2 FOREIGN KEY (id_espacio) REFERENCES PREF_ESPACIO (id_espacio) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_INCIDENCIA_3 FOREIGN KEY (id_categoria) REFERENCES PREF_CATEGORIA_INCIDENCIA (id_categoria) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_INCIDENCIA_4 FOREIGN KEY (id_prioridad) REFERENCES PREF_PRIORIDAD (id_prioridad) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_INCIDENCIA_5 FOREIGN KEY (id_estado_incidencia) REFERENCES PREF_ESTADO_INCIDENCIA (id_estado_incidencia) ON DELETE RESTRICT
);

CREATE INDEX PREF_IX_INC_BANDEJA ON PREF_INCIDENCIA (id_estado_incidencia, id_prioridad, fecha_registro);
CREATE INDEX PREF_IX_INC_ESPACIO ON PREF_INCIDENCIA (id_espacio, fecha_registro);

-- MVP: Pregunta del coordinador y respuesta del solicitante.
CREATE TABLE PREF_ACLARACION_INCIDENCIA (
    id_aclaracion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_incidencia BIGINT NOT NULL,
    pregunta VARCHAR(1000) NOT NULL,
    preguntado_por BIGINT NOT NULL,
    fecha_pregunta TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    respuesta VARCHAR(2000),
    respondido_por BIGINT,
    fecha_respuesta TIMESTAMPTZ,
    CONSTRAINT PREF_PK_ACLARACION_I_BASE PRIMARY KEY (id_aclaracion),
    CONSTRAINT PREF_FK_ACLARACION_I_1 FOREIGN KEY (id_incidencia) REFERENCES PREF_INCIDENCIA (id_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ACLARACION_I_2 FOREIGN KEY (preguntado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ACLARACION_I_3 FOREIGN KEY (respondido_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_ACLARACION_I_1 CHECK ((respuesta IS NULL AND respondido_por IS NULL AND fecha_respuesta IS NULL) OR (respuesta IS NOT NULL AND respondido_por IS NOT NULL AND fecha_respuesta IS NOT NULL)),
    CONSTRAINT PREF_CK_ACLARACION_I_2 CHECK (fecha_respuesta IS NULL OR fecha_respuesta >= fecha_pregunta)
);

CREATE INDEX PREF_IX_ACL_INC ON PREF_ACLARACION_INCIDENCIA (id_incidencia, fecha_pregunta);

-- MVP: Catálogo del ciclo de vida de órdenes.
CREATE TABLE PREF_ESTADO_ORDEN (
    id_estado_orden BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    es_terminal BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_ESTADO_ORDEN_BASE PRIMARY KEY (id_estado_orden)
);

-- MVP: Unidad de planificación, ejecución y cierre del mantenimiento.
CREATE TABLE PREF_ORDEN_TRABAJO (
    id_orden BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    codigo VARCHAR(30) NOT NULL UNIQUE,
    tipo_orden VARCHAR(20) NOT NULL DEFAULT 'CORRECTIVA',
    id_espacio BIGINT NOT NULL,
    id_prioridad BIGINT NOT NULL,
    id_estado_orden BIGINT NOT NULL,
    alcance VARCHAR(2000) NOT NULL,
    creado_por BIGINT NOT NULL,
    ciclo_actual INTEGER NOT NULL DEFAULT 1,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_fin_tecnica TIMESTAMPTZ,
    fecha_cierre TIMESTAMPTZ,
    CONSTRAINT PREF_PK_ORDEN_TRABAJ_BASE PRIMARY KEY (id_orden),
    CONSTRAINT PREF_FK_ORDEN_TRABAJ_1 FOREIGN KEY (id_espacio) REFERENCES PREF_ESPACIO (id_espacio) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ORDEN_TRABAJ_2 FOREIGN KEY (id_prioridad) REFERENCES PREF_PRIORIDAD (id_prioridad) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ORDEN_TRABAJ_3 FOREIGN KEY (id_estado_orden) REFERENCES PREF_ESTADO_ORDEN (id_estado_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ORDEN_TRABAJ_4 FOREIGN KEY (creado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_ORDEN_TRABAJ_1 CHECK (tipo_orden IN ('CORRECTIVA','PREVENTIVA')),
    CONSTRAINT PREF_CK_ORDEN_TRABAJ_2 CHECK (ciclo_actual > 0),
    CONSTRAINT PREF_CK_ORDEN_TRABAJ_3 CHECK (fecha_fin_tecnica IS NULL OR fecha_fin_tecnica >= fecha_creacion),
    CONSTRAINT PREF_CK_ORDEN_TRABAJ_4 CHECK (fecha_cierre IS NULL OR fecha_cierre >= fecha_creacion)
);

CREATE INDEX PREF_IX_ORD_BANDEJA ON PREF_ORDEN_TRABAJO (id_estado_orden, id_prioridad, fecha_creacion);
CREATE INDEX PREF_IX_ORD_ESP ON PREF_ORDEN_TRABAJO (id_espacio, fecha_creacion);

-- MVP: Vínculo entre orden correctiva e incidencia; en MVP se usa un reporte principal.
CREATE TABLE PREF_ORDEN_INCIDENCIA (
    id_orden BIGINT NOT NULL,
    id_incidencia BIGINT NOT NULL,
    vinculado_por BIGINT NOT NULL,
    fecha_vinculacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PREF_PK_ORDEN_INCIDE_BASE PRIMARY KEY (id_orden, id_incidencia),
    CONSTRAINT PREF_FK_ORDEN_INCIDE_1 FOREIGN KEY (id_orden) REFERENCES PREF_ORDEN_TRABAJO (id_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ORDEN_INCIDE_2 FOREIGN KEY (id_incidencia) REFERENCES PREF_INCIDENCIA (id_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ORDEN_INCIDE_3 FOREIGN KEY (vinculado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT
);

CREATE INDEX PREF_IX_OI_INC ON PREF_ORDEN_INCIDENCIA (id_incidencia);

-- MVP: Responsabilidad y programación de un técnico por ciclo.
CREATE TABLE PREF_ASIGNACION_TECNICA (
    id_asignacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_orden BIGINT NOT NULL,
    numero_ciclo INTEGER NOT NULL,
    id_tecnico BIGINT NOT NULL,
    tipo_asignacion VARCHAR(20) NOT NULL DEFAULT 'RESPONSABLE',
    programada_inicio TIMESTAMPTZ NOT NULL,
    programada_fin TIMESTAMPTZ NOT NULL,
    asignado_por BIGINT NOT NULL,
    fecha_asignacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vigente BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_fin_vigencia TIMESTAMPTZ,
    CONSTRAINT PREF_PK_ASIGNACION_T_BASE PRIMARY KEY (id_asignacion),
    CONSTRAINT PREF_FK_ASIGNACION_T_1 FOREIGN KEY (id_orden) REFERENCES PREF_ORDEN_TRABAJO (id_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ASIGNACION_T_2 FOREIGN KEY (id_tecnico) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_ASIGNACION_T_3 FOREIGN KEY (asignado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_UQ_ASIG_CIC_TEC UNIQUE (id_orden, numero_ciclo, id_tecnico),
    CONSTRAINT PREF_CK_ASIGNACION_T_1 CHECK (numero_ciclo > 0),
    CONSTRAINT PREF_CK_ASIGNACION_T_2 CHECK (tipo_asignacion IN ('RESPONSABLE','COLABORADOR')),
    CONSTRAINT PREF_CK_ASIGNACION_T_3 CHECK (programada_fin > programada_inicio),
    CONSTRAINT PREF_CK_ASIGNACION_T_4 CHECK (fecha_fin_vigencia IS NULL OR fecha_fin_vigencia >= fecha_asignacion)
);

CREATE INDEX PREF_IX_ASIG_TEC_AGENDA ON PREF_ASIGNACION_TECNICA (id_tecnico, programada_inicio, programada_fin);
CREATE INDEX PREF_IX_ASIG_ORD_VIG ON PREF_ASIGNACION_TECNICA (id_orden, numero_ciclo, vigente);
CREATE UNIQUE INDEX PREF_UQ_ASIG_RESP_VIG
    ON PREF_ASIGNACION_TECNICA (id_orden, numero_ciclo)
    WHERE vigente = TRUE AND tipo_asignacion = 'RESPONSABLE';

-- MVP: Actividad técnica concreta realizada dentro de una asignación.
CREATE TABLE PREF_INTERVENCION (
    id_intervencion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_asignacion BIGINT NOT NULL,
    fecha_inicio TIMESTAMPTZ NOT NULL,
    fecha_fin TIMESTAMPTZ,
    actividad VARCHAR(2000) NOT NULL,
    resultado VARCHAR(2000),
    estado_registro VARCHAR(10) NOT NULL DEFAULT 'ABIERTO',
    fecha_registro TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PREF_PK_INTERVENCION_BASE PRIMARY KEY (id_intervencion),
    CONSTRAINT PREF_FK_INTERVENCION_1 FOREIGN KEY (id_asignacion) REFERENCES PREF_ASIGNACION_TECNICA (id_asignacion) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_INTERVENCION_1 CHECK (estado_registro IN ('ABIERTO','CERRADO')),
    CONSTRAINT PREF_CK_INTERVENCION_2 CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio),
    CONSTRAINT PREF_CK_INTERVENCION_3 CHECK ((estado_registro = 'ABIERTO' AND fecha_fin IS NULL) OR (estado_registro = 'CERRADO' AND fecha_fin IS NOT NULL AND resultado IS NOT NULL))
);

CREATE INDEX PREF_IX_INT_ASIG ON PREF_INTERVENCION (id_asignacion, fecha_inicio);

-- MVP: Metadatos de una fotografía vinculada a incidencia o intervención; el binario se almacena fuera de la tabla.
CREATE TABLE PREF_EVIDENCIA (
    id_evidencia BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_incidencia BIGINT,
    id_intervencion BIGINT,
    nombre_original VARCHAR(255) NOT NULL,
    clave_almacenamiento VARCHAR(500) NOT NULL UNIQUE,
    tipo_mime VARCHAR(100) NOT NULL,
    tamano_bytes BIGINT NOT NULL,
    huella_sha256 CHAR(64) NOT NULL,
    descripcion VARCHAR(500),
    cargado_por BIGINT NOT NULL,
    fecha_carga TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_archivo VARCHAR(15) NOT NULL DEFAULT 'DISPONIBLE',
    CONSTRAINT PREF_PK_EVIDENCIA_BASE PRIMARY KEY (id_evidencia),
    CONSTRAINT PREF_FK_EVIDENCIA_1 FOREIGN KEY (id_incidencia) REFERENCES PREF_INCIDENCIA (id_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_EVIDENCIA_2 FOREIGN KEY (id_intervencion) REFERENCES PREF_INTERVENCION (id_intervencion) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_EVIDENCIA_3 FOREIGN KEY (cargado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_EVIDENCIA_1 CHECK (((id_incidencia IS NOT NULL AND id_intervencion IS NULL) OR (id_incidencia IS NULL AND id_intervencion IS NOT NULL))),
    CONSTRAINT PREF_CK_EVIDENCIA_2 CHECK (tamano_bytes > 0),
    CONSTRAINT PREF_CK_EVIDENCIA_3 CHECK (CHAR_LENGTH(huella_sha256) = 64),
    CONSTRAINT PREF_CK_EVIDENCIA_4 CHECK (estado_archivo IN ('DISPONIBLE','FALLIDA','RETIRADA'))
);

CREATE INDEX PREF_IX_EVI_INC ON PREF_EVIDENCIA (id_incidencia);
CREATE INDEX PREF_IX_EVI_INT ON PREF_EVIDENCIA (id_intervencion);

-- MVP: Dictamen independiente sobre el resultado de un ciclo de orden.
CREATE TABLE PREF_VERIFICACION (
    id_verificacion BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_orden BIGINT NOT NULL,
    numero_ciclo INTEGER NOT NULL,
    id_verificador BIGINT NOT NULL,
    dictamen VARCHAR(20) NOT NULL,
    observacion VARCHAR(1500),
    fecha_verificacion TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    vigente BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT PREF_PK_VERIFICACION_BASE PRIMARY KEY (id_verificacion),
    CONSTRAINT PREF_FK_VERIFICACION_1 FOREIGN KEY (id_orden) REFERENCES PREF_ORDEN_TRABAJO (id_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_VERIFICACION_2 FOREIGN KEY (id_verificador) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_VERIFICACION_1 CHECK (numero_ciclo > 0),
    CONSTRAINT PREF_CK_VERIFICACION_2 CHECK (dictamen IN ('CONFORME','NO_CONFORME')),
    CONSTRAINT PREF_CK_VERIFICACION_3 CHECK (dictamen <> 'NO_CONFORME' OR observacion IS NOT NULL)
);

CREATE INDEX PREF_IX_VER_ORD_CIC ON PREF_VERIFICACION (id_orden, numero_ciclo, fecha_verificacion);
CREATE UNIQUE INDEX PREF_UQ_VER_VIGENTE
    ON PREF_VERIFICACION (id_orden, numero_ciclo)
    WHERE vigente = TRUE;

-- MVP: Impedimento y posterior resolución durante un ciclo.
CREATE TABLE PREF_BLOQUEO_ORDEN (
    id_bloqueo BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_orden BIGINT NOT NULL,
    numero_ciclo INTEGER NOT NULL,
    motivo VARCHAR(1000) NOT NULL,
    abierto_por BIGINT NOT NULL,
    fecha_apertura TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolucion VARCHAR(1000),
    cerrado_por BIGINT,
    fecha_cierre TIMESTAMPTZ,
    CONSTRAINT PREF_PK_BLOQUEO_ORDE_BASE PRIMARY KEY (id_bloqueo),
    CONSTRAINT PREF_FK_BLOQUEO_ORDE_1 FOREIGN KEY (id_orden) REFERENCES PREF_ORDEN_TRABAJO (id_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_BLOQUEO_ORDE_2 FOREIGN KEY (abierto_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_BLOQUEO_ORDE_3 FOREIGN KEY (cerrado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_BLOQUEO_ORDE_1 CHECK (numero_ciclo > 0),
    CONSTRAINT PREF_CK_BLOQUEO_ORDE_2 CHECK ((resolucion IS NULL AND cerrado_por IS NULL AND fecha_cierre IS NULL) OR (resolucion IS NOT NULL AND cerrado_por IS NOT NULL AND fecha_cierre IS NOT NULL)),
    CONSTRAINT PREF_CK_BLOQUEO_ORDE_3 CHECK (fecha_cierre IS NULL OR fecha_cierre >= fecha_apertura)
);

CREATE INDEX PREF_IX_BLOQ_ORD ON PREF_BLOQUEO_ORDEN (id_orden, numero_ciclo, fecha_cierre);

-- MVP: Transiciones inmutables del estado de una incidencia.
CREATE TABLE PREF_HISTORIAL_INCIDENCIA (
    id_historial_incidencia BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_incidencia BIGINT NOT NULL,
    id_estado_origen BIGINT,
    id_estado_destino BIGINT NOT NULL,
    cambiado_por BIGINT NOT NULL,
    fecha_cambio TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(1000),
    referencia_operacion VARCHAR(64) NOT NULL,
    CONSTRAINT PREF_PK_HISTORIAL_IN_BASE PRIMARY KEY (id_historial_incidencia),
    CONSTRAINT PREF_FK_HISTORIAL_IN_1 FOREIGN KEY (id_incidencia) REFERENCES PREF_INCIDENCIA (id_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_IN_2 FOREIGN KEY (id_estado_origen) REFERENCES PREF_ESTADO_INCIDENCIA (id_estado_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_IN_3 FOREIGN KEY (id_estado_destino) REFERENCES PREF_ESTADO_INCIDENCIA (id_estado_incidencia) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_IN_4 FOREIGN KEY (cambiado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_HISTORIAL_IN_1 CHECK (id_estado_origen IS NULL OR id_estado_origen <> id_estado_destino)
);

CREATE INDEX PREF_IX_HI_INC ON PREF_HISTORIAL_INCIDENCIA (id_incidencia, fecha_cambio);
CREATE INDEX PREF_IX_HI_OP ON PREF_HISTORIAL_INCIDENCIA (referencia_operacion);

-- MVP: Transiciones inmutables del estado de una orden.
CREATE TABLE PREF_HISTORIAL_ORDEN (
    id_historial_orden BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    id_orden BIGINT NOT NULL,
    numero_ciclo INTEGER NOT NULL,
    id_estado_origen BIGINT,
    id_estado_destino BIGINT NOT NULL,
    cambiado_por BIGINT NOT NULL,
    fecha_cambio TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo VARCHAR(1000),
    referencia_operacion VARCHAR(64) NOT NULL,
    CONSTRAINT PREF_PK_HISTORIAL_OR_BASE PRIMARY KEY (id_historial_orden),
    CONSTRAINT PREF_FK_HISTORIAL_OR_1 FOREIGN KEY (id_orden) REFERENCES PREF_ORDEN_TRABAJO (id_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_OR_2 FOREIGN KEY (id_estado_origen) REFERENCES PREF_ESTADO_ORDEN (id_estado_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_OR_3 FOREIGN KEY (id_estado_destino) REFERENCES PREF_ESTADO_ORDEN (id_estado_orden) ON DELETE RESTRICT,
    CONSTRAINT PREF_FK_HISTORIAL_OR_4 FOREIGN KEY (cambiado_por) REFERENCES PREF_USUARIO (id_usuario) ON DELETE RESTRICT,
    CONSTRAINT PREF_CK_HISTORIAL_OR_1 CHECK (numero_ciclo > 0),
    CONSTRAINT PREF_CK_HISTORIAL_OR_2 CHECK (id_estado_origen IS NULL OR id_estado_origen <> id_estado_destino)
);

CREATE INDEX PREF_IX_HO_ORD ON PREF_HISTORIAL_ORDEN (id_orden, numero_ciclo, fecha_cambio);
CREATE INDEX PREF_IX_HO_OP ON PREF_HISTORIAL_ORDEN (referencia_operacion);

-- Datos iniciales de catálogos. Los identificadores se generan; la aplicación debe resolverlos por código.
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('SOLICITANTE','Solicitante');
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('RESPONSABLE_ESPACIO','Responsable del espacio');
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('COORDINADOR','Coordinador de mantenimiento');
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('TECNICO','Técnico de mantenimiento');
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('RESPONSABLE_INSTITUCIONAL','Responsable institucional');
INSERT INTO PREF_ROL (codigo,nombre) VALUES ('ADMINISTRADOR','Administrador');
INSERT INTO PREF_PRIORIDAD (codigo,nombre,nivel_orden) VALUES ('BAJA','Baja',1);
INSERT INTO PREF_PRIORIDAD (codigo,nombre,nivel_orden) VALUES ('MEDIA','Media',2);
INSERT INTO PREF_PRIORIDAD (codigo,nombre,nivel_orden) VALUES ('ALTA','Alta',3);
INSERT INTO PREF_PRIORIDAD (codigo,nombre,nivel_orden) VALUES ('CRITICA','Crítica',4);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('REGISTRADA','Registrada',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('EN_REVISION','En revisión',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('PENDIENTE_INFORMACION','Pendiente de información',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('ADMITIDA','Admitida',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('EN_ATENCION','En atención',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('PENDIENTE_VERIFICACION','Pendiente de verificación',FALSE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('RESUELTA','Resuelta',TRUE);
INSERT INTO PREF_ESTADO_INCIDENCIA (codigo,nombre,es_terminal) VALUES ('DESCARTADA','Descartada',TRUE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('BORRADOR','Borrador',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('PROGRAMADA','Programada',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('EN_EJECUCION','En ejecución',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('BLOQUEADA','Bloqueada',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('FINALIZADA_TECNICAMENTE','Finalizada técnicamente',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('PENDIENTE_VERIFICACION','Pendiente de verificación',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('VERIFICADA','Verificada',FALSE);
INSERT INTO PREF_ESTADO_ORDEN (codigo,nombre,es_terminal) VALUES ('CERRADA','Cerrada',TRUE);

-- Reglas entre varias tablas que la capa Services debe validar dentro de una transacción:
-- 1) transición permitida y actualización atómica de entidad + historial;
-- 2) una orden correctiva activa por incidencia;
-- 3) verificador responsable vigente del espacio y distinto de participantes técnicos;
-- 4) cierre solo con verificación CONFORME vigente y ausencia de bloqueos abiertos;
-- 5) consistencia entre el archivo externo y PREF_EVIDENCIA.

COMMIT;
