# Fase 2. Modelado y Diseño de Base de Datos

## Gestión de incidencias y mantenimiento de infraestructura educativa

**Institución académica:** Instituto Superior Universitario Japón  
**Carrera:** Tecnología Superior en Desarrollo de Software  
**Autor:** Stalyn Mateo Sánchez Cevallos  
**Año:** 2026  
**Caso:** Centro de Formación Técnica Sendero, institución ficticia.  
**Estado:** Fase 2 cerrada con aprobación conceptual y correcciones finales. No se ha seleccionado un motor de base de datos ni se ha iniciado la implementación.

## 1. Propósito y límites de esta fase

Esta fase transforma los requerimientos aprobados en un modelo conceptual y relacional normalizado. Define entidades, atributos, claves, cardinalidades y restricciones; prepara un diccionario de datos y un **SQL preliminar basado en SQL estándar, sujeto a adaptación al motor seleccionado en Fase 3**.

El diseño mantiene dos alcances:

- **MVP:** 21 tablas que permiten demostrar el flujo reporte → revisión/priorización → orden → asignación → intervención → evidencia → finalización técnica → verificación → cierre/reapertura → historial.
- **Ampliaciones:** 4 tablas para duplicidad, cancelaciones formales, correcciones históricas y versiones de programación. Se documentan, pero no son obligatorias en la primera implementación.

No se crean tablas de inventarios, compras, facturación, geolocalización continua ni sincronización offline. Tampoco se programa backend, web, escritorio o móvil.

El alcance del MVP queda congelado en las 21 tablas de esta entrega. En las fases siguientes no se añadirán nuevas tablas salvo que se demuestre que un requerimiento MVP no puede satisfacerse con el modelo actual y la modificación se justifique explícitamente antes de realizarla. Las 4 tablas de ampliación no forman parte del compromiso de implementación inicial.

El script utiliza `PREF_` como marcador temporal. No representa las iniciales del autor. Antes del script definitivo deberá sustituirse por las iniciales confirmadas explícitamente y deberá adaptarse al motor elegido en Fase 3.

## 2. Decisiones de modelado

1. `INCIDENCIA`, `ORDEN_TRABAJO`, `INTERVENCION` y `VERIFICACION` son hechos distintos. La incidencia describe una necesidad; la orden organiza el trabajo; la intervención registra una ejecución; la verificación contiene un dictamen independiente.
2. `HISTORIAL_ESTADO` se conserva como concepto del dominio, pero se materializa en `HISTORIAL_INCIDENCIA` y `HISTORIAL_ORDEN`. Esta especialización permite claves foráneas reales hacia catálogos diferentes y evita una referencia polimórfica sin integridad.
3. `EVIDENCIA` guarda metadatos y una clave opaca de almacenamiento. El archivo binario queda fuera de la tabla. La estrategia física, límites, retención y almacenamiento se decidirán con la arquitectura.
4. Los estados y prioridades son catálogos porque tienen código, etiqueta, vigencia y uso referencial. Tipos simples y cerrados —tipo de orden, tipo de asignación, dictamen y estado del archivo— se expresan mediante `CHECK` en el SQL preliminar. El motor definitivo podrá convertirlos a enums si aporta una ventaja verificable.
5. `ORDEN_INCIDENCIA` permite evolucionar hacia varios reportes relacionados con una orden. Para el MVP, el caso demostrable utilizará un reporte principal por orden.
6. La reapertura conserva la misma orden e incrementa `ciclo_actual`. Asignaciones, verificaciones, bloqueos e historial identifican el número de ciclo correspondiente.
7. Las fechas de programación residen en `ASIGNACION_TECNICA`, asociadas al responsable y al ciclo. El control automático de solapamientos y las versiones completas de reprogramación quedan como ampliación.
8. Las tablas principales conservan el estado vigente y los historiales conservan cada transición. Ambos datos deben actualizarse en una sola transacción. El estado vigente facilita las bandejas; el historial aporta trazabilidad temporal.

## 3. Modelo conceptual

### 3.1. Entidades definitivas del MVP

| Área | Entidad | Responsabilidad conceptual |
|---|---|---|
| Identidad | ROL | Define una función autorizada. |
| Identidad | USUARIO | Identifica a una persona que accede o participa. |
| Identidad | USUARIO_ROL | Conserva la vigencia de los roles de cada usuario. |
| Ubicación | SEDE | Agrupa espacios físicos institucionales. |
| Ubicación | ESPACIO | Localiza reportes y trabajos. |
| Ubicación | RESPONSABLE_ESPACIO | Determina quién puede verificar un espacio y durante qué período. |
| Incidencias | CATEGORIA_INCIDENCIA | Clasifica el tipo de desperfecto. |
| Incidencias | PRIORIDAD | Ordena la atención sin fijar tiempos arbitrarios. |
| Incidencias | ESTADO_INCIDENCIA | Cataloga el estado vigente del reporte. |
| Incidencias | INCIDENCIA | Registra la necesidad informada por un solicitante. |
| Incidencias | ACLARACION_INCIDENCIA | Conserva pregunta y respuesta durante la revisión. |
| Trabajo | ESTADO_ORDEN | Cataloga el estado vigente de una orden. |
| Trabajo | ORDEN_TRABAJO | Organiza el alcance, prioridad y ciclo del trabajo. |
| Trabajo | ORDEN_INCIDENCIA | Vincula reportes y órdenes sin duplicar sus datos. |
| Trabajo | ASIGNACION_TECNICA | Asigna responsabilidad y programación por ciclo. |
| Ejecución | INTERVENCION | Registra una actividad técnica y su resultado. |
| Evidencia | EVIDENCIA | Conserva metadatos y referencia de una fotografía. |
| Control | VERIFICACION | Registra conformidad o inconformidad independiente. |
| Control | BLOQUEO_ORDEN | Registra impedimento y solución durante un ciclo. |
| Historial | HISTORIAL_INCIDENCIA | Conserva transiciones inmutables de incidencias. |
| Historial | HISTORIAL_ORDEN | Conserva transiciones inmutables de órdenes. |

### 3.2. Entidades de ampliación

| Entidad | Ampliación que resuelve | Motivo para aplazarla |
|---|---|---|
| DUPLICIDAD_INCIDENCIA | Relación formal entre reporte duplicado y principal. | El MVP demostrará un reporte principal sin consolidación de duplicados. |
| SOLICITUD_CANCELACION | Solicitud, decisión y fundamento de cancelaciones. | La resolución de cancelaciones con múltiples vínculos amplía los casos excepcionales. |
| CORRECCION_AUDITADA | Comparación entre valor anterior y nuevo. | Requiere políticas detalladas de autorización y tratamiento por tipo de dato. |
| VERSION_PROGRAMACION | Cada versión de una reasignación o reprogramación. | La primera versión conservará asignaciones por ciclo sin prevención avanzada de conflictos. |

### 3.3. Modelo Entidad-Relación

![Figura 6. Modelo Entidad-Relación del sistema Sendero](figuras/figura_06_mer.png)

**Figura 6. Modelo Entidad-Relación del sistema Sendero.** Fuente: elaboración propia. La definición formal se conserva en `figura_06_mer.mmd`.

## 4. Relaciones y cardinalidades

| Relación | Cardinalidad | Regla representada |
|---|---|---|
| ROL — USUARIO_ROL — USUARIO | ROL 1:N; USUARIO 1:N | Una persona puede tener varios roles y cada rol puede pertenecer a muchas personas; la entidad asociativa conserva vigencia. |
| SEDE — ESPACIO | 1:N | Todo espacio pertenece a una sede; una sede contiene ninguno o varios espacios. |
| ESPACIO — RESPONSABLE_ESPACIO — USUARIO | ESPACIO 1:N; USUARIO 1:N | Un espacio puede tener responsables sucesivos o concurrentes autorizados; una persona puede responder por varios espacios. |
| USUARIO — INCIDENCIA | 1:N | Cada incidencia tiene un solicitante; una persona puede reportar varias. |
| ESPACIO — INCIDENCIA | 1:N | Cada reporte identifica un espacio. |
| CATEGORIA_INCIDENCIA — INCIDENCIA | 1:N | Cada incidencia pertenece a una categoría vigente. |
| PRIORIDAD — INCIDENCIA | 1:N, opcional al registrar | La prioridad se confirma durante la revisión; inicialmente puede ser nula. |
| ESTADO_INCIDENCIA — INCIDENCIA | 1:N | Cada incidencia tiene exactamente un estado actual. |
| INCIDENCIA — ACLARACION_INCIDENCIA | 1:N | Una incidencia puede requerir varias aclaraciones. |
| INCIDENCIA — ORDEN_INCIDENCIA — ORDEN_TRABAJO | N:M estructural | El MVP usa un reporte principal por orden. La asociación evita copiar datos y deja preparada una consolidación futura. |
| ESPACIO — ORDEN_TRABAJO | 1:N | Toda orden se ejecuta en un espacio. En una orden correctiva deberá coincidir con el reporte vinculado. |
| PRIORIDAD — ORDEN_TRABAJO | 1:N | La orden conserva su prioridad operativa, incluida una futura preventiva sin incidencia. |
| ESTADO_ORDEN — ORDEN_TRABAJO | 1:N | Cada orden tiene un estado vigente. |
| ORDEN_TRABAJO — ASIGNACION_TECNICA | 1:N | Cada ciclo programado exige al menos una asignación responsable; colaboradores son ampliación. |
| USUARIO — ASIGNACION_TECNICA | 1:N | Un técnico puede recibir varias asignaciones en el tiempo. |
| ASIGNACION_TECNICA — INTERVENCION | 1:N | Toda intervención procede de una asignación válida. |
| INCIDENCIA — EVIDENCIA | 1:N, exclusivo | Una evidencia puede documentar un reporte o una intervención, nunca ambos. |
| INTERVENCION — EVIDENCIA | 1:N, exclusivo | La exclusividad se controla mediante un `CHECK` XOR. |
| ORDEN_TRABAJO — VERIFICACION | 1:N | Puede existir más de un dictamen durante sucesivos intentos o ciclos. |
| USUARIO — VERIFICACION | 1:N | El verificador debe ser responsable vigente del espacio y no haber intervenido técnicamente. |
| ORDEN_TRABAJO — BLOQUEO_ORDEN | 1:N | Cada impedimento conserva apertura y resolución. |
| INCIDENCIA — HISTORIAL_INCIDENCIA | 1:N | La creación y cada cambio agregan un evento; no se sobrescriben. |
| ORDEN_TRABAJO — HISTORIAL_ORDEN | 1:N | Cada transición identifica ciclo, autor, fecha y motivo cuando corresponda. |

## 5. Modelo relacional

### 5.1. Convenciones

- PK: clave primaria.
- FK: clave foránea.
- UQ: restricción de unicidad.
- NN: `NOT NULL`.
- Todos los nombres definitivos llevarán un prefijo de iniciales aún pendiente de confirmación.
- Los identificadores se proponen como `BIGINT GENERATED ALWAYS AS IDENTITY` por ser una construcción estándar; su sintaxis se adaptará al motor.
- Las fechas se expresan como `TIMESTAMP`. La política de zona horaria se definirá en Fase 3.
- Las bajas lógicas se representan con vigencia o `activo`; no se destruyen registros con historial.

### 5.2. Tablas del MVP

| Tabla | PK | FK principales | Restricciones relevantes |
|---|---|---|---|
| PREF_ROL | id_rol | — | codigo UQ; activo NN. |
| PREF_USUARIO | id_usuario | — | nombre_acceso UQ; credencial_hash NN; correo UQ opcional. |
| PREF_USUARIO_ROL | id_usuario + id_rol + fecha_desde | usuario, rol | fecha_hasta ≥ fecha_desde. |
| PREF_SEDE | id_sede | — | codigo UQ; inactivación sin borrado histórico. |
| PREF_ESPACIO | id_espacio | sede | codigo UQ dentro de cada sede. |
| PREF_RESPONSABLE_ESPACIO | id_responsabilidad | espacio, usuario | vigencia válida; combinación espacio–usuario–inicio UQ. |
| PREF_CATEGORIA_INCIDENCIA | id_categoria | — | codigo UQ; activo NN. |
| PREF_PRIORIDAD | id_prioridad | — | codigo y nivel_orden UQ; nivel positivo. |
| PREF_ESTADO_INCIDENCIA | id_estado_incidencia | — | codigo UQ; indicador terminal. |
| PREF_INCIDENCIA | id_incidencia | solicitante, espacio, categoría, prioridad, estado | codigo UQ; prioridad puede ser nula antes de revisión. |
| PREF_ACLARACION_INCIDENCIA | id_aclaracion | incidencia, usuarios que preguntan/responden | respuesta, autor y fecha aparecen juntos. |
| PREF_ESTADO_ORDEN | id_estado_orden | — | codigo UQ; indicador terminal. |
| PREF_ORDEN_TRABAJO | id_orden | espacio, prioridad, estado, creador | codigo UQ; tipo válido; ciclo positivo; coherencia de fechas. |
| PREF_ORDEN_INCIDENCIA | id_orden + id_incidencia | orden, incidencia, vinculador | asociación sin atributos duplicados. |
| PREF_ASIGNACION_TECNICA | id_asignacion | orden, técnico, coordinador | ciclo positivo; fin programado posterior al inicio; una fila por orden–ciclo–técnico. |
| PREF_INTERVENCION | id_intervencion | asignación | fin ≥ inicio; una intervención cerrada exige fin y resultado. |
| PREF_EVIDENCIA | id_evidencia | incidencia o intervención, usuario | exactamente un objeto padre; clave de archivo UQ; tamaño positivo; huella SHA-256 de 64 caracteres. |
| PREF_VERIFICACION | id_verificacion | orden, verificador | ciclo positivo; dictamen válido; una inconformidad exige observación. |
| PREF_BLOQUEO_ORDEN | id_bloqueo | orden, usuarios de apertura/cierre | datos de resolución aparecen juntos; cierre ≥ apertura. |
| PREF_HISTORIAL_INCIDENCIA | id_historial_incidencia | incidencia, estados, autor | origen distinto de destino; referencia de operación. |
| PREF_HISTORIAL_ORDEN | id_historial_orden | orden, estados, autor | ciclo positivo; origen distinto de destino; referencia de operación. |

### 5.3. Tablas de ampliación

| Tabla | PK | Finalidad y restricción central |
|---|---|---|
| PREF_DUPLICIDAD_INCIDENCIA | id_incidencia_duplicada | Vincula una principal diferente; los ciclos y cadenas se validarán transaccionalmente. |
| PREF_SOLICITUD_CANCELACION | id_solicitud_cancelacion | Apunta exclusivamente a una incidencia o una orden; la resolución exige autor, fecha y motivo. |
| PREF_CORRECCION_AUDITADA | id_correccion | Conserva campo, valor anterior, valor nuevo, autorización y motivo. Su referencia es lógica porque abarca varios tipos de tabla. |
| PREF_VERSION_PROGRAMACION | id_version_programacion | Una versión única por asignación y número; fechas coherentes. |

### 5.4. Representación gráfica

![Figura 7. Modelo relacional normalizado del sistema Sendero](figuras/figura_07_modelo_relacional.png)

**Figura 7. Modelo relacional normalizado del sistema Sendero.** Fuente: elaboración propia. La figura resume PK y FK; el diccionario CSV contiene los 187 campos.

## 6. Normalización

### 6.1. Primera Forma Normal — 1FN

Cada campo contiene un valor atómico. Los roles, responsables, asignaciones, evidencias e intervenciones no se guardan como listas dentro de una columna. Las asociaciones repetibles se trasladan a tablas propias. Por ejemplo, una orden con varias intervenciones produce varias filas en `INTERVENCION`, no una lista de actividades en `ORDEN_TRABAJO`.

### 6.2. Segunda Forma Normal — 2FN

Las tablas con claves compuestas contienen atributos que dependen de toda la clave:

- En `USUARIO_ROL`, `fecha_hasta` depende del usuario, el rol y el inicio de vigencia.
- En `ORDEN_INCIDENCIA`, el autor y la fecha describen ese vínculo específico.

Las demás tablas usan claves simples, por lo que no presentan dependencias parciales respecto de una clave compuesta.

### 6.3. Tercera Forma Normal — 3FN

Los atributos descriptivos de roles, sedes, espacios, categorías, prioridades y estados se almacenan en sus catálogos. Las tablas operativas conservan solamente sus claves foráneas; por ejemplo, `INCIDENCIA` no repite el nombre de la sede, categoría o prioridad.

No se almacena el técnico directamente en `INTERVENCION`: se referencia la asignación que ya identifica al técnico, la orden y el ciclo. Esto evita dependencias transitivas y además prueba que el técnico estaba autorizado.

El estado vigente en `INCIDENCIA` y `ORDEN_TRABAJO` y los eventos del historial representan hechos distintos: uno describe la situación actual y el otro una secuencia temporal inmutable. La actualización debe ser atómica para controlar la redundancia deliberada.

El modelo cumple 3FN en su estructura propuesta. No se divide artificialmente texto descriptivo en tablas sin identidad de negocio.

## 7. Diccionario de datos

El diccionario completo está disponible en [diccionario_datos.csv](diccionario_datos.csv). Contiene, para cada uno de los 187 campos:

- alcance MVP o ampliación;
- tabla y propósito;
- nombre del campo;
- tipo y longitud;
- PK/FK;
- nulabilidad;
- unicidad;
- valor por defecto;
- tabla y campo referenciados;
- descripción funcional.

La fuente estructurada está disponible en [modelo_datos.json](modelo_datos.json). Estos dos archivos son la referencia para comprobar coherencia con el SQL y las figuras.

## 8. Estados y valores controlados

### 8.1. Catálogo de incidencia

| Código | MVP | Uso |
|---|---|---|
| REGISTRADA | Sí | Reporte recibido. |
| EN_REVISION | Sí | Evaluación del coordinador. |
| PENDIENTE_INFORMACION | Sí | Aclaración solicitada. |
| ADMITIDA | Sí | Reporte aceptado y priorizado. |
| EN_ATENCION | Sí | Orden activa en preparación, ejecución o bloqueo. |
| PENDIENTE_VERIFICACION | Sí | Trabajo remitido a dictamen. |
| RESUELTA | Sí | Orden cerrada con conformidad. |
| DESCARTADA | Sí | Reporte no procedente con motivo. |
| DUPLICADA | Ampliación | Reporte enlazado a uno principal. |
| CANCELADA | Ampliación | Reporte retirado mediante decisión formal. |

### 8.2. Catálogo de orden

| Código | MVP | Uso |
|---|---|---|
| BORRADOR | Sí | Orden aún incompleta. |
| PROGRAMADA | Sí | Responsable y fechas definidos. |
| EN_EJECUCION | Sí | Trabajo iniciado o retomado. |
| BLOQUEADA | Sí | Impedimento vigente. |
| FINALIZADA_TECNICAMENTE | Sí | Técnico declara trabajo terminado. |
| PENDIENTE_VERIFICACION | Sí | Resultado enviado al responsable del espacio. |
| VERIFICADA | Sí | Dictamen conforme vigente. |
| CERRADA | Sí | Cierre formal del coordinador. |
| CANCELADA | Ampliación | Orden detenida mediante decisión formal. |

### 8.3. Valores mediante CHECK

| Campo | Valores | Alcance inicial |
|---|---|---|
| ORDEN_TRABAJO.tipo_orden | CORRECTIVA, PREVENTIVA | Solo CORRECTIVA en MVP. |
| ASIGNACION_TECNICA.tipo_asignacion | RESPONSABLE, COLABORADOR | Solo RESPONSABLE es obligatorio en MVP. |
| INTERVENCION.estado_registro | ABIERTO, CERRADO | Ambos requeridos. |
| EVIDENCIA.estado_archivo | DISPONIBLE, FALLIDA, RETIRADA | DISPONIBLE y fallo controlado requeridos; retiro depende de política futura. |
| VERIFICACION.dictamen | CONFORME, NO_CONFORME | Ambos requeridos. |

Las transiciones permitidas continúan definidas por I01–I14 y O01–O14 de Fase 1. Guardar estados en catálogos no autoriza cualquier cambio entre ellos.

Los valores `DUPLICADA`, `CANCELADA`, `PREVENTIVA`, `COLABORADOR`, `RETIRADA` y las estructuras marcadas como ampliación permanecen en el modelo para evolución y trazabilidad. Mientras sus funciones no estén implementadas, la futura interfaz MVP no deberá presentarlos en menús, formularios, filtros, acciones o mensajes como opciones disponibles. Su presencia en catálogos o restricciones no equivale a funcionalidad entregada.

## 9. Reglas de integridad

### 9.1. Integridad declarativa en el SQL preliminar

- PK para identidad y asociaciones.
- FK con `ON DELETE RESTRICT` para impedir la eliminación de hechos referenciados.
- `NOT NULL` en los datos obligatorios.
- `UNIQUE` para códigos públicos, accesos y claves de almacenamiento.
- `CHECK` para fechas, ciclos, XOR de evidencia, dictámenes y registros cerrados.
- Índices preliminares para bandejas, historiales, relaciones y agenda técnica.

### 9.2. Reglas transaccionales pendientes de adaptación al motor

Estas reglas no pueden garantizarse mediante un `CHECK` aislado y deberán implementarse como transacciones del servicio y, cuando convenga, restricciones o índices del motor:

1. Validar la matriz de transiciones y registrar entidad e historial en una misma transacción.
2. Mantener como máximo una orden correctiva activa por incidencia.
3. Mantener exactamente un técnico responsable vigente por orden y ciclo.
4. Comprobar que el técnico tenga rol y asignación vigentes antes de intervenir.
5. Comprobar que el verificador sea responsable vigente del espacio y no haya intervenido en esa orden.
6. Permitir cierre solo con verificación conforme vigente del ciclo actual.
7. Incrementar el ciclo en reapertura e invalidar el dictamen anterior sin borrarlo.
8. Confirmar conjuntamente almacenamiento del archivo y metadatos de evidencia, o compensar el fallo.
9. Impedir cambios o borrados ordinarios en las tablas de historial.
10. Para ampliaciones, prevenir cadenas de duplicados, solapamientos y conflictos de edición.

### 9.3. Integridad de evidencias

El archivo no se almacena como BLOB en esta propuesta. `clave_almacenamiento` localiza el objeto; `huella_sha256` permite comprobar integridad; `tipo_mime` y `tamano_bytes` conservan la validación realizada. El acceso al archivo deberá pasar por autorización y no mediante una URL pública permanente.

No se han fijado tamaños máximos, formatos definitivos ni retención. Esos valores dependen de la infraestructura y se resolverán en Fase 3.

## 10. Script SQL preliminar

El archivo [esquema_preliminar.sql](../../database/esquema_preliminar.sql) contiene:

- creación de las 21 tablas del MVP;
- PK, FK, `NOT NULL`, `UNIQUE`, `CHECK` y valores por defecto;
- índices preliminares;
- carga inicial de roles, prioridades y estados;
- una sección separada para las 4 ampliaciones;
- comentarios sobre reglas que requieren adaptación al motor.

El script usa SQL estándar cuando resulta razonable, pero **no se declara ejecutado ni aprobado contra un motor**. La generación de identidad, nombres máximos de restricciones, tratamiento de booleanos, índices parciales, funciones de fecha y estrategia de transacciones deberán validarse después de seleccionar el motor.

No se incluye `CREATE DATABASE`, configuración de usuarios, almacenamiento físico, extensiones, procedimientos ni triggers específicos.

## 11. Trazabilidad entre MVP y tablas

| Requerimiento MVP | Tablas principales | Evidencia de diseño |
|---|---|---|
| RF-01 Acceso y permisos | USUARIO, ROL, USUARIO_ROL | Identidad, hash de credencial y vigencia de roles. |
| RF-02 Usuarios e inhabilitación | USUARIO, USUARIO_ROL | Indicador activo e historial referencial conservado. |
| RF-03 Sedes, espacios, responsables y categorías | SEDE, ESPACIO, RESPONSABLE_ESPACIO, CATEGORIA_INCIDENCIA | Catálogos normalizados y vigencias. |
| RF-04 Reportar con evidencia | INCIDENCIA, EVIDENCIA | Datos obligatorios y evidencia asociada exclusivamente al reporte. |
| RF-05 Consultar lo propio | INCIDENCIA, HISTORIAL_INCIDENCIA | Solicitante y secuencia de estados. |
| RF-06 Aclaraciones | ACLARACION_INCIDENCIA | Pregunta, respuesta, actores y fechas. |
| RF-07 Revisar y priorizar | INCIDENCIA, PRIORIDAD, ESTADO_INCIDENCIA, HISTORIAL_INCIDENCIA | Prioridad confirmada y decisión trazable. |
| RF-10 Crear orden correctiva | ORDEN_TRABAJO, ORDEN_INCIDENCIA | Identidad separada y vínculo explícito. |
| RF-12 Programar y asignar | ASIGNACION_TECNICA | Responsable, ciclo e intervalo programado. |
| RF-13 Consultar asignaciones | ASIGNACION_TECNICA, ORDEN_TRABAJO, ESPACIO | Datos necesarios para el técnico. |
| RF-14 Iniciar, bloquear y reanudar | ORDEN_TRABAJO, BLOQUEO_ORDEN, HISTORIAL_ORDEN | Impedimento, resolución y estados. |
| RF-15 Intervenciones y tiempos | INTERVENCION, ASIGNACION_TECNICA | Autorización y tiempos reales. |
| RF-16 Evidencias autorizadas | EVIDENCIA, INCIDENCIA, INTERVENCION | Metadatos separados del archivo. |
| RF-17 Finalización técnica | INTERVENCION, EVIDENCIA, ORDEN_TRABAJO, HISTORIAL_ORDEN | Prerrequisitos consultables y transición trazable. |
| RF-18 Revisión técnica | ORDEN_TRABAJO, HISTORIAL_ORDEN | Envío o devolución con motivo. |
| RF-19 Dictamen | VERIFICACION, RESPONSABLE_ESPACIO | Autoridad del verificador y resultado. |
| RF-20 Cierre | VERIFICACION, ORDEN_TRABAJO, INCIDENCIA, ambos historiales | Conformidad vigente y cambios correlacionados. |
| RF-21 Reapertura | ORDEN_TRABAJO, ASIGNACION_TECNICA, VERIFICACION, HISTORIAL_ORDEN | Nuevo ciclo sin borrar el anterior. |
| RF-23 Historial | HISTORIAL_INCIDENCIA, HISTORIAL_ORDEN | Autor, estados, fecha, motivo y referencia de operación. |
| RF-24 Filtros | INCIDENCIA, ORDEN_TRABAJO, catálogos e índices | Estado, prioridad, espacio y fechas disponibles. |
| RF-25 Indicadores | INCIDENCIA, ORDEN_TRABAJO, VERIFICACION, historiales | Eventos y fechas reproducibles; metas siguen pendientes. |

### 11.1. Trazabilidad de ampliaciones

| Requerimiento | Tabla o cambio previsto |
|---|---|
| RF-08 Duplicados | DUPLICIDAD_INCIDENCIA y estado DUPLICADA. |
| RF-09 / RF-22 Cancelaciones | SOLICITUD_CANCELACION y estados CANCELADA. |
| RF-11 Preventivas | ORDEN_TRABAJO.tipo_orden = PREVENTIVA; sin incidencia artificial. |
| RF-26 Correcciones | CORRECCION_AUDITADA. |
| RF-27 Conflictos avanzados | Mecanismo de versión a definir con el motor y servicio. |
| RN-08 / RN-26 Solapamientos | VERSION_PROGRAMACION más restricción o transacción dependiente del motor. |

## 12. Consultas y operaciones críticas previstas

Sin definir todavía controladores o repositorios, el modelo debe soportar:

- bandeja de incidencias por estado, prioridad, sede, espacio y fecha;
- órdenes asignadas a un técnico y ciclo vigente;
- historial completo de una incidencia y una orden;
- intervenciones abiertas antes de finalizar técnicamente;
- evidencia disponible por reporte o intervención;
- verificación conforme vigente para el ciclo actual;
- bloqueos abiertos;
- tiempos entre reporte, primera revisión, verificación y cierre;
- reaperturas por cohorte de cierre.

Los índices propuestos son preliminares. No se afirmará rendimiento hasta medir consultas reales con un motor, volumen y plan de ejecución conocidos.

## 13. Verificación documental de Fase 2

Las comprobaciones de esta fase deben confirmar:

- todos los campos del diccionario proceden de la fuente estructurada;
- cada FK apunta a una tabla y campo existente;
- las tablas tienen PK;
- las entidades del MVP y ampliaciones están separadas;
- el SQL contiene las 25 tablas en sus secciones correctas;
- las figuras se renderizan y sus letras se mantienen en negro;
- la trazabilidad cubre todos los RF clasificados como MVP;
- no se presenta el SQL como ejecutado contra un motor.

Estas son comprobaciones del diseño y los archivos. No son pruebas del aplicativo ni de una base de datos desplegada.

## 14. Decisiones pendientes para Fase 3

- Iniciales exactas que sustituirán `PREF_`.
- Motor relacional y versión.
- Estrategia de migraciones y datos iniciales.
- Tipos físicos de fecha y zona horaria.
- Estrategia de almacenamiento, carga, entrega, límites, retención y respaldo de fotografías.
- Restricciones dependientes del motor: índices parciales, concurrencia, una asignación responsable vigente y una orden activa por incidencia.
- Protección del hash de credenciales o integración con un proveedor de identidad.
- Parámetros medibles de rendimiento, disponibilidad y recuperación.

## 15. Estado de cierre propuesto

Fase 2 entrega un modelo conceptual, 25 entidades/tablas clasificadas, 187 campos, cardinalidades, MER, modelo relacional en 3FN, diccionario, reglas de integridad, SQL preliminar, trazabilidad y dos figuras renderizadas con fuentes Mermaid. El alcance de implementación queda congelado en las 21 tablas del MVP.

No se seleccionaron tecnologías, motor, arquitectura o frameworks. No se programaron aplicaciones ni se ejecutaron pruebas de base de datos. La Fase 2 queda oficialmente cerrada y el trabajo se detiene antes de cualquier decisión de Fase 3.
