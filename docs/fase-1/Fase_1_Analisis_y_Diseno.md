# Fase 1. Análisis y Diseño

## Gestión de incidencias y mantenimiento de infraestructura educativa

**Institución ficticia:** Centro de Formación Técnica Sendero.  
**Versión:** 1.0 — entrega para revisión del usuario.  
**Naturaleza:** caso académico creado y aprobado como escenario de trabajo. No corresponde a una investigación de campo.  
**Estado:** análisis elaborado; propuestas de esta fase pendientes de aprobación. Sin tecnologías seleccionadas, sin programación de aplicaciones y sin resultados de implementación.

## 1. Resumen ejecutivo y decisiones de alcance

El problema central es la falta de trazabilidad en la atención del mantenimiento de espacios educativos. Los avisos, las asignaciones y las evidencias se encuentran dispersos; por ello resulta difícil establecer qué está pendiente, quién debe actuar y si la intervención resolvió el problema.

Se propone un proceso que relaciona el reporte con una orden de trabajo, registra intervenciones y exige una verificación antes del cierre. La web concentrará solicitudes, verificación y consulta institucional; escritorio concentrará coordinación; móvil concentrará ejecución en campo. Compartir datos y reglas es una necesidad del sistema, no una selección de arquitectura en esta fase.

Se mantienen separados INCIDENCIA, ORDEN_TRABAJO, INTERVENCION, VERIFICACION e HISTORIAL_ESTADO. Una fotografía será evidencia de un reporte o una intervención; no sustituirá una verificación favorable.

Los entregables de esta fase son: análisis, factibilidad preliminar, requerimientos, reglas, metodología propuesta, matriz de actores y plataformas, ciclos de vida, criterios de aceptación, trazabilidad y cinco figuras reales con fuentes estructuradas. UML de casos de uso y clases, MER, arquitectura y mockups corresponden a fases posteriores.

## 2. Origen y confiabilidad de la información

| Clasificación | Contenido | Tratamiento |
|---|---|---|
| Confirmado por el usuario | Caso ficticio Sendero, dos sedes y dominio de mantenimiento educativo; tres plataformas; productos académicos; revisión por fases. | Base del trabajo. “Confirmado” significa aceptado para el caso, no observado en una institución. |
| Confirmado por el usuario | Separación conceptual, estados explícitos, matriz funcional, figuras estructuradas y exclusiones de alcance. | Condiciones obligatorias. |
| Escenario aprobado | Avisos por mensajes y llamadas, hoja de cálculo de coordinación, notas técnicas y fotografías dispersas. | Base para representar el proceso AS-IS. |
| Inferencia de análisis | Centralizar el historial puede reducir consultas repetidas y facilitar continuidad. | Hipótesis; no resultado demostrado. |
| Propuesta de esta fase | Estados, transiciones, permisos, reglas refinadas, requerimientos y metodología. | Se convierten en línea base solo después de la revisión. |
| Sin evidencia disponible | Frecuencia de fallas, tiempos actuales, presupuesto, infraestructura informática, disponibilidad del equipo, número de usuarios. | No cuantificar ni presentar mejoras como medidas. |

No se ha consultado ni reutilizado ningún proyecto anterior. Este documento es una especificación original del caso aprobado; no incorpora una encuesta, entrevista o rúbrica institucional que no exista.

## 3. Problema, causas, efectos y justificación

### 3.1. Problema central

La institución no dispone de un registro único y trazable que permita coordinar y verificar el mantenimiento desde el reporte hasta la aceptación del trabajo.

### 3.2. Relaciones causales del escenario

| Causa | Manifestación | Efecto planteado |
|---|---|---|
| Canales de recepción separados | Avisos sobre la misma falla no vinculados. | Duplicidad y necesidad de aclaraciones manuales. |
| Priorización informal | No queda registrada la razón del orden de atención. | Dificultad para justificar decisiones. |
| Agenda no consolidada | Asignaciones por teléfono sin control común. | Conflictos potenciales de horarios y responsabilidad. |
| Notas y fotografías dispersas | El siguiente técnico no dispone de todos los antecedentes. | Pérdida de continuidad. |
| Falta de aceptación formal | “Trabajo terminado” se interpreta como “problema resuelto”. | Cierres prematuros y seguimiento incompleto. |
| Fechas incompletas | No existe una secuencia confiable de eventos. | Indicadores de atención no reproducibles. |

### 3.3. Impacto y necesidad

Las fallas pueden limitar temporalmente el uso de espacios y demandar tiempo de coordinación. Su magnitud no está medida. El sistema se justifica por la necesidad de identificar responsabilidades, consolidar evidencias, conservar decisiones y comprobar la resolución. No se promete eliminar fallas físicas ni demostrar ahorros sin datos.

El software apoyará decisiones de mantenimiento; no diagnosticará automáticamente riesgos técnicos ni sustituirá los procedimientos de emergencia.

## 4. Objetivos y alcance

### 4.1. Objetivo general

Desarrollar y verificar un sistema integrado de escritorio, web y móvil para gestionar incidencias y órdenes de mantenimiento en Sendero, conservando trazabilidad desde el reporte hasta la verificación y proporcionando información medible de atención, programación y reaperturas.

### 4.2. Objetivos específicos

- OE-01: formalizar el proceso, responsabilidades, estados y reglas de atención.
- OE-02: modelar la información y sus restricciones sin duplicar hechos de negocio.
- OE-03: distribuir funciones según el contexto de uso de cada plataforma.
- OE-04: implementar posteriormente un flujo integrado con control de acceso y validaciones.
- OE-05: verificar los flujos y calcular indicadores reproducibles con evidencia.
- OE-06: documentar la solución, sus límites y las condiciones de operación.

### 4.3. Incluido

Reportes, aclaraciones, clasificación, duplicados, órdenes correctivas y preventivas manuales, técnicos responsables y colaboradores, programación, intervenciones, bloqueos, evidencias fotográficas, verificación, cierre, reapertura, cancelación, historial, consulta e indicadores. Administración mínima de usuarios, roles, sedes, espacios, responsables y categorías.

### 4.4. Excluido

Inventarios, compras, facturación, pagos, contratos, nómina, geolocalización continua, sensores, mantenimiento predictivo, integraciones académicas, funcionamiento offline y programación preventiva recurrente automática. No se crea un catálogo de activos o repuestos como sustituto encubierto de un inventario.

No se incluyen mensajería externa, notificaciones push o correos automáticos. La primera versión utilizará bandejas de pendientes y estados visibles dentro de las aplicaciones. Esas integraciones requerirían una ampliación explícita.

### 4.5. Restricciones

Las escrituras requieren conexión. Las operaciones fallidas no pueden mostrarse como confirmadas. Los datos de demostración serán ficticios. Las iniciales SQL deben ser proporcionadas por el usuario. El stack y la propuesta visual requieren revisión en sus fases. Se mantendrán revisiones al finalizar cada fase.

**Entorno de desarrollo confirmado por el usuario:** Arch Linux dentro de WSL. La creación del aplicativo, instalación de dependencias de desarrollo, ejecución y pruebas se realizarán en esa distribución; no se creará un entorno de desarrollo de la aplicación en Windows. El formato de distribución y el sistema destino de escritorio/móvil se decidirán después: desarrollar en WSL no define por sí mismo los dispositivos de destino. Los documentos de esta fase se entregan en la carpeta compartida de resultados.

La confirmación procede expresamente de la instrucción del usuario: “utiliza el WSL de Arch Linux que tengo para hacer el aplicativo”. Por tanto, no es una inferencia del análisis ni una decisión tecnológica tomada por el proyecto. La distribución disponible se identificó como `archlinux`; esto confirma el entorno de trabajo, pero no selecciona lenguajes, frameworks ni plataformas de destino.

La selección del soporte de escritorio, navegadores, dispositivos y versiones móviles se realizará después de conocer el entorno. No se asume que las tres plataformas funcionarán en cualquier dispositivo.

## 5. Procesos actual y propuesto

### 5.1. AS-IS — proceso actual del escenario

Un docente o responsable detecta el problema y lo comunica por un canal informal. El coordinador transcribe lo que recibe, consulta disponibilidad y encarga el trabajo. El técnico visita el espacio y comparte notas o fotografías. La coordinación interpreta el resultado y actualiza su registro cuando recibe información suficiente. Ante recurrencia o inconformidad, se produce otro aviso sin relación garantizada con el anterior.

Esta descripción procede del escenario ficticio aprobado; no es un levantamiento de campo. Los puntos de pérdida de trazabilidad son hipótesis de diseño del caso.

![Figura 1. Flujo actual de atención de incidencias](figuras/figura_01_asis.png)

**Figura 1. Flujo actual de atención de incidencias.** Fuente: elaboración propia a partir del escenario académico. Las discontinuidades representan ausencia de un registro común.

### 5.2. TO-BE — proceso propuesto

Recepción identificada → revisión → admisión → orden → programación → ejecución → revisión técnica → verificación del espacio → cierre. Aclaración, duplicidad, descarte, bloqueo e inconformidad son rutas controladas, no borrados de información.

Una orden preventiva comienza en planificación sin reporte previo. Se somete a las mismas reglas de ejecución, verificación y cierre que una correctiva.

![Figura 2. Flujo propuesto de atención y mantenimiento](figuras/figura_02_tobe.png)

**Figura 2. Flujo propuesto de atención y mantenimiento.** Fuente: elaboración propia. Las rutas excepcionales se detallan en las tablas de estados.

### 5.3. Entradas y salidas

| Proceso | Entrada mínima | Salida verificable | Responsable |
|---|---|---|---|
| Reportar | Espacio, categoría y descripción. | Incidencia identificada con autor y fecha. | Solicitante |
| Revisar | Reporte y aclaraciones. | Decisión motivada y prioridad si se admite. | Coordinador |
| Planificar | Incidencia admitida o actividad preventiva. | Orden con alcance, espacio y programación. | Coordinador |
| Asignar | Disponibilidad y funciones técnicas. | Responsable y participantes sin solapamiento. | Coordinador |
| Ejecutar | Orden programada y acceso al espacio. | Intervenciones, resultados y tiempos. | Técnicos asignados |
| Revisar el trabajo | Finalización técnica y evidencias. | Devolución o solicitud de verificación. | Coordinador |
| Verificar | Trabajo presentado y espacio intervenido. | Dictamen favorable o inconformidad. | Responsable del espacio |
| Cerrar | Verificación favorable vigente. | Cierre formal e incidencias resueltas. | Coordinador |
| Evaluar | Historial y fechas consistentes. | Indicadores con población y filtros explícitos. | Coordinador / responsable institucional |

## 6. Actores, permisos y plataformas

### 6.1. Actores

Solicitante: informa y consulta sus incidencias. Responsable del espacio: verifica trabajos de los espacios bajo su responsabilidad. Coordinador: gestiona el proceso y sus excepciones. Técnico: ejecuta trabajos asignados. Responsable institucional: consulta información consolidada. Administrador: mantiene accesos y catálogos; no obtiene por ese solo rol permiso para cerrar órdenes o verificar trabajos.

Una persona puede tener varios roles autorizados. El acceso depende del rol y del recurso: ser técnico no permite editar cualquier orden; ser responsable de un espacio no permite verificar otro. No habrá autorregistro público en el alcance inicial.

### 6.2. Matriz Actor × Plataforma × Funcionalidad

“—” significa que no se exige esa función en esa plataforma. No supone prohibición futura, pero evita triplicar las interfaces.

| Actor | Web | Escritorio | Móvil |
|---|---|---|---|
| Solicitante | Reportar, adjuntar fotos, aclarar, consultar lo propio y solicitar cancelación. | — | — |
| Responsable del espacio | Ver órdenes por verificar, revisar evidencias y emitir dictamen. También reportar si tiene rol de solicitante. | — | — |
| Coordinador | — | Revisar reportes; clasificar; gestionar duplicados; crear y programar órdenes; asignar; gestionar bloqueos y devoluciones; cerrar, cancelar y reabrir; consultar indicadores. | — |
| Técnico | — | — | Ver sus asignaciones e historial necesario; registrar intervenciones y fotografías. El responsable técnico puede iniciar, bloquear, reanudar y finalizar la orden. |
| Responsable institucional | Consultar indicadores y resúmenes autorizados. | — | — |
| Administrador | Gestionar usuarios, roles, sedes, espacios, responsables y categorías. | — | — |
| Todos los roles habilitados | Acceso y salida cuando tengan funciones web. | Acceso y salida del coordinador. | Acceso y salida del técnico. |

La web podrá adaptarse a distintos tamaños de pantalla; ello no reemplaza el entregable de cliente móvil para técnicos. Las funciones compartidas son acceso, validación, consulta contextual e historial pertinente; no se replica toda la administración.

![Figura 3. Actores y distribución funcional por plataforma](figuras/figura_03_plataformas.png)

**Figura 3. Actores y distribución funcional por plataforma.** Fuente: elaboración propia. “Técnico responsable” y “colaborador” son responsabilidades dentro de una asignación.

## 7. Ciclo de vida de las incidencias

### 7.1. Estados permitidos

| Estado | Significado |
|---|---|
| REGISTRADA | Reporte recibido y pendiente de evaluación. |
| EN_REVISION | El coordinador está evaluando admisibilidad, claridad y duplicidad. |
| PENDIENTE_INFORMACION | Se solicitó aclaración concreta al autor. |
| ADMITIDA | Reporte aceptado y priorizado; todavía no tiene una orden activa vinculada. |
| EN_ATENCION | Tiene orden activa vinculada fuera de la etapa de verificación favorable o pendiente. Incluye planificación, ejecución y bloqueos. |
| PENDIENTE_VERIFICACION | La orden fue enviada a verificación o ya está verificada pero aún no se cierra. La interfaz distingue ambas situaciones mediante el estado de la orden. |
| RESUELTA | La orden vinculada fue cerrada tras verificación favorable. |
| DESCARTADA | El reporte no procede y conserva una razón explícita. |
| DUPLICADA | El reporte apunta a una incidencia principal del mismo problema. |
| CANCELADA | Se retiró o dejó sin efecto mediante decisión del coordinador y motivo registrado. |

### 7.2. Transiciones válidas

| ID | Origen → destino | Responsable del evento | Condiciones y resultado |
|---|---|---|---|
| I01 | Sin registro → REGISTRADA | Solicitante | Datos obligatorios válidos y espacio activo. Se conserva autor y fecha. |
| I02 | REGISTRADA → EN_REVISION | Coordinador | Inicia evaluación. |
| I03 | EN_REVISION → PENDIENTE_INFORMACION | Coordinador | Registra una pregunta o dato faltante específico. |
| I04 | PENDIENTE_INFORMACION → EN_REVISION | Solicitante autor | Aporta respuesta; no puede admitir su reporte. |
| I05 | EN_REVISION → ADMITIDA | Coordinador | Confirma pertinencia, categoría, prioridad y motivo. |
| I06 | EN_REVISION → DESCARTADA | Coordinador | Motivo de no procedencia obligatorio. |
| I07 | EN_REVISION → DUPLICADA | Coordinador | Referencia una incidencia principal admitida o en atención del mismo problema y espacio; no puede apuntar a sí misma ni a otro duplicado. |
| I08 | ADMITIDA → EN_ATENCION | Coordinador, al vincular orden | Orden correctiva no terminal y mismo espacio; ausencia de otra orden activa para esa incidencia. |
| I09 | EN_ATENCION → PENDIENTE_VERIFICACION | Sistema, por O07 | La orden vinculada se envía a verificación. |
| I10 | PENDIENTE_VERIFICACION → EN_ATENCION | Sistema, por O08 u O13 | Inconformidad o retiro justificado de una verificación ya favorable. |
| I11 | PENDIENTE_VERIFICACION → RESUELTA | Sistema, por O10 | Cierre formal de la orden con verificación favorable vigente. |
| I12 | RESUELTA → EN_ATENCION | Sistema, por O11 | Reapertura autorizada de la orden del mismo problema; afecta a sus incidencias principales vinculadas. |
| I13 | REGISTRADA, EN_REVISION, PENDIENTE_INFORMACION o ADMITIDA → CANCELADA | Coordinador | Motivo y solicitud o causa identificada; no tiene orden activa. |
| I14 | EN_ATENCION o PENDIENTE_VERIFICACION → ADMITIDA o CANCELADA | Sistema, por O12 | Al cancelar la orden, el coordinador debe decidir para cada incidencia si continúa pendiente de otra atención o si se cancela con motivo. |

No hay otras transiciones autorizadas. DESCARTADA, DUPLICADA y CANCELADA son terminales en la primera versión: un nuevo hecho se registra como nuevo reporte con referencia al anterior. Una incidencia no se marca RESUELTA manualmente. En DUPLICADA se muestra el avance de la principal sin cambiar el estado del duplicado ni sumar ambos al mismo indicador de resolución.

Una incidencia vinculada a una orden BLOQUEADA continúa EN_ATENCION y muestra el bloqueo de la orden. Así se evita multiplicar estados equivalentes entre ambos objetos.

![Figura 4. Estados y transiciones de una incidencia](figuras/figura_04_estados_incidencia.png)

**Figura 4. Estados y transiciones de una incidencia.** Fuente: elaboración propia. Los identificadores remiten a la tabla I01–I14; el panel inferior muestra cancelaciones agrupadas.

## 8. Ciclo de vida de las órdenes de trabajo

### 8.1. Estados permitidos

| Estado | Significado |
|---|---|
| BORRADOR | Orden creada, aún sin programación completa. |
| PROGRAMADA | Alcance, intervalo previsto, responsable y participantes definidos. |
| EN_EJECUCION | El técnico responsable inició o retomó el trabajo. |
| BLOQUEADA | Existe impedimento documentado que detiene el trabajo. |
| FINALIZADA_TECNICAMENTE | El técnico declara terminado el trabajo; falta revisión del coordinador. |
| PENDIENTE_VERIFICACION | El coordinador solicita dictamen del responsable del espacio. |
| VERIFICADA | Existe dictamen favorable vigente; falta cierre formal. |
| CERRADA | El coordinador formalizó el cierre. |
| CANCELADA | La orden dejó de ejecutarse por decisión motivada. |

### 8.2. Transiciones válidas

| ID | Origen → destino | Responsable | Condiciones y resultado |
|---|---|---|---|
| O01 | Sin orden → BORRADOR | Coordinador | Correctiva: al menos una incidencia admitida del mismo espacio. Preventiva: actividad y espacio definidos, sin incidencia obligatoria. |
| O02 | BORRADOR → PROGRAMADA | Coordinador | Intervalo válido, fecha prevista de término, un técnico responsable activo, colaboradores y responsable de verificación disponibles. No hay solapamientos. |
| O03 | PROGRAMADA → EN_EJECUCION | Técnico responsable | Confirma inicio real; asignación vigente e intervalo vigente o reprogramado que cubra ese inicio. |
| O04 | EN_EJECUCION → BLOQUEADA | Técnico responsable o coordinador | Registra motivo, descripción y próxima acción o condición necesaria. No se inventa una fecha de resolución. |
| O05 | BLOQUEADA → EN_EJECUCION | Técnico responsable | Impedimento atendido y autorización del coordinador registrada; programación vigente sin conflicto. |
| O06 | EN_EJECUCION → FINALIZADA_TECNICAMENTE | Técnico responsable | Al menos una intervención cerrada; ninguna intervención abierta; resultado, tiempos y evidencia visual o justificación de ausencia. |
| O07 | FINALIZADA_TECNICAMENTE → PENDIENTE_VERIFICACION | Coordinador | Revisa integridad del registro y designación vigente del verificador; no equivale a certificar técnicamente la reparación. |
| O08 | PENDIENTE_VERIFICACION → EN_EJECUCION | Responsable del espacio | Dictamen no conforme con motivo. Registra la devolución; un nuevo trabajo solo comienza con programación vigente y sin conflicto. |
| O09 | PENDIENTE_VERIFICACION → VERIFICADA | Responsable del espacio | Dictamen favorable, autor, fecha y observación. No participó como técnico en esa orden. |
| O10 | VERIFICADA → CERRADA | Coordinador | Verificación favorable vigente, sin nuevas intervenciones o incidencias añadidas después del dictamen y sin datos obligatorios faltantes. |
| O11 | CERRADA → EN_EJECUCION | Coordinador | Mismo defecto o trabajo, motivo de reapertura, técnico responsable y nueva programación sin conflicto; invalida la vigencia del dictamen anterior sin borrarlo. |
| O12 | Cualquier estado no terminal → CANCELADA | Coordinador | Motivo obligatorio; cerrar intervenciones abiertas con resultado interrumpido; decidir destino de cada incidencia vinculada. No se cancela una orden ya cerrada. |
| O13 | VERIFICADA → EN_EJECUCION | Coordinador | Se detecta problema antes del cierre; motivo registrado e invalidación de la vigencia del dictamen. Reprogramar antes de iniciar intervención. |
| O14 | FINALIZADA_TECNICAMENTE → EN_EJECUCION | Coordinador | Registro incompleto o trabajo pendiente: devuelve con motivo. Reprogramar si hace falta antes de iniciar nueva intervención. |

No se admite el cierre directo desde EN_EJECUCION o FINALIZADA_TECNICAMENTE. CANCELADA es terminal. Una falla distinta o una actividad preventiva posterior requiere nueva orden; no reapertura de una antigua para ocultar un nuevo trabajo.

Cambiar fecha o técnico en BORRADOR, PROGRAMADA, EN_EJECUCION o BLOQUEADA es una operación auditada, no un nuevo estado. Si hay una intervención abierta del técnico afectado, debe cerrarse antes de reasignarlo. Las devoluciones pueden dejar trabajo pendiente de reprogramación: no habilitan una nueva intervención por sí solas.

Al bloquear una orden se liberan los intervalos futuros no ejecutados de sus asignaciones, conservando su versión histórica. Reanudar exige nuevos intervalos o ratificar los vigentes sin conflicto. Las asignaciones se comparan como intervalos [inicio, fin): terminar a la hora en que comienza otra no se considera solapamiento. El control se aplica al responsable y a cada colaborador.

![Figura 5. Estados y transiciones de una orden de trabajo](figuras/figura_05_estados_orden.png)

**Figura 5. Estados y transiciones de una orden de trabajo.** Fuente: elaboración propia. Los identificadores remiten a O01–O14; cancelaciones se agrupan para mantener legibilidad.

### 8.3. Coherencia entre objetos y concurrencia

- La vinculación, los cambios de estado y su historial deben confirmarse como una sola operación de negocio: no se admite actualizar la orden y dejar las incidencias en un estado incompatible.
- Una incidencia tiene como máximo una orden correctiva activa. Una orden correctiva atiende una o varias incidencias principales del mismo problema y espacio. Las relaciones definitivas se resolverán en el modelado.
- Una orden preventiva atiende un espacio y no resuelve incidencias por asociación implícita. Un defecto descubierto en ella puede originar un nuevo reporte y orden correctiva relacionados como antecedente.
- En BORRADOR, PROGRAMADA, EN_EJECUCION o BLOQUEADA se pueden agregar incidencias admitidas del mismo problema; no después de la finalización técnica.
- Una decisión sobre una versión desactualizada debe rechazarse e indicar recarga. Esto incluye dos coordinadores asignando simultáneamente el mismo técnico o una verificación concurrente con cancelación.
- HISTORIAL_ESTADO conserva transiciones. Las reasignaciones, reprogramaciones y correcciones de datos también requieren auditoría, aunque no cambien el estado. Su estructura se decidirá después.

## 9. Reglas de negocio consolidadas

Las reglas RN-01–RN-16 de la ficha aprobada se conservan y se precisan mediante los ciclos anteriores. Las siguientes extensiones son propuestas explícitas de esta fase, no información atribuida a una institución real.

| Código | Regla o precisión |
|---|---|
| RN-01 | Toda incidencia identifica solicitante, espacio, categoría, descripción y fecha de registro. |
| RN-02 | El solicitante puede indicar urgencia; el coordinador confirma la prioridad operativa y su justificación. |
| RN-03 | Las prioridades son baja, media, alta y crítica, según los criterios propuestos en 9.1. No implican compromisos de tiempo todavía. |
| RN-04 | Un duplicado se vincula a una incidencia principal y se conserva en el historial. |
| RN-05 | Cada incidencia admite como máximo una orden correctiva activa; una orden puede atender varios reportes del mismo problema y espacio. |
| RN-06 | La orden preventiva identifica espacio, actividad y programación; no requiere reporte previo. Puede nacer como borrador antes de completar su programación. |
| RN-07 | Toda orden programada tiene exactamente un técnico responsable y puede incluir colaboradores. |
| RN-08 | Ningún técnico puede tener intervalos programados que se superpongan. |
| RN-09 | Solo los técnicos asignados registran intervenciones. El coordinador administra asignaciones y revisa los resultados. |
| RN-10 | Bloquear requiere motivo; reanudar requiere registrar la solución del impedimento y la autorización correspondiente. |
| RN-11 | La finalización técnica requiere intervención, tiempos, resultado y fotografía o justificación de su ausencia. |
| RN-12 | Finalizar técnicamente no cierra la orden: el responsable del espacio verifica y el coordinador formaliza el cierre. |
| RN-13 | La inconformidad devuelve a atención. La reapertura posterior al cierre requiere motivo y autorización del coordinador. |
| RN-14 | Cancelaciones, descartes y duplicados conservan motivo, autor e historial. |
| RN-15 | Cada cambio de estado conserva autor, fecha, estado anterior y nuevo. Las correcciones retrospectivas deben identificarse. |
| RN-16 | Usuarios y espacios con historial se inhabilitan cuando corresponda; no se eliminan destruyendo sus referencias. |
| RN-17 | El cierre exige verificación favorable vigente; quien intervino como técnico no puede verificar esa misma orden, aunque tenga ambos roles. |
| RN-18 | No hay cierre automático por silencio del verificador. El coordinador puede designar otro responsable autorizado del espacio, dejando motivo. |
| RN-19 | Los cambios de estado solo se realizan por las transiciones I01–I14 y O01–O14 y conservan actor, fecha, origen, destino y motivo cuando aplique. |
| RN-20 | La cancelación conserva registros; si la necesidad persiste, devuelve la incidencia a ADMITIDA. Cancelar la orden no demuestra resolución. |
| RN-21 | La reapertura mantiene las intervenciones y verificaciones anteriores, identifica un nuevo ciclo y exige otra verificación antes del cierre. |
| RN-22 | El responsable técnico controla los estados de ejecución; los colaboradores registran intervenciones propias y comunican impedimentos. |
| RN-23 | Cada intervención identifica técnico, orden, actividad, inicio, fin y resultado. Fin no puede ser anterior a inicio. Un técnico no registra intervalos de intervención superpuestos. |
| RN-24 | Los registros finalizados no se sobrescriben silenciosamente. Una corrección requiere autorización del coordinador, motivo y conservación del valor anterior. |
| RN-25 | La información de un duplicado no se elimina. Su vínculo principal no puede formar ciclos ni cadenas de duplicados. |
| RN-26 | Los intervalos programados de una persona no se superponen; los históricos ejecutados se conservan al reprogramar. |
| RN-27 | El solicitante consulta lo propio; el técnico, sus asignaciones; el verificador, sus espacios; la consulta institucional es consolidada; los catálogos se administran con permiso específico. |

### 9.1. Criterios iniciales de prioridad

| Nivel | Criterio de clasificación propuesto |
|---|---|
| Crítica | Riesgo aparente para personas o necesidad de restringir inmediatamente el uso del espacio. Activar el procedimiento institucional de emergencia fuera del sistema. |
| Alta | Espacio sin posibilidad de uso para su actividad prevista y sin alternativa disponible. |
| Media | Afectación parcial con alternativa temporal o uso limitado. |
| Baja | Deterioro que permite continuar la actividad sin la afectación anterior. |

El coordinador valida la prioridad y registra la razón; las aplicaciones no diagnostican peligros. No se fijan tiempos máximos por prioridad sin capacidad y políticas de atención. Las definiciones deberán revisarse con quien represente la operación institucional.

## 10. Requerimientos funcionales y aceptación

Los criterios siguientes son verificables en pruebas futuras; no son resultados de pruebas ejecutadas.

| ID | El sistema debe permitir… | Criterio de aceptación principal |
|---|---|---|
| RF-01 | Identificar al usuario, iniciar y cerrar su sesión y aplicar permisos. | Un usuario sin rol o alcance sobre el recurso no puede ejecutar la acción, incluso si intenta omitir la interfaz. |
| RF-02 | Administrar usuarios y roles e inhabilitar accesos. | Inhabilitar impide nuevas acciones protegidas y preserva registros históricos. |
| RF-03 | Administrar sedes, espacios, responsables y categorías. | No se seleccionan registros inactivos para nuevas operaciones; los históricos siguen visibles. |
| RF-04 | Registrar incidencias con evidencia opcional. | Rechaza ausencia de espacio, categoría o descripción; genera identificador, autor y fecha tras guardado confirmado. |
| RF-05 | Consultar el estado y el historial de las incidencias propias. | Un solicitante no obtiene reportes ajenos cambiando su identificador. |
| RF-06 | Solicitar y responder aclaraciones. | I03 e I04 conservan pregunta, respuesta y autor. |
| RF-07 | Admitir, priorizar o descartar reportes. | Solo el coordinador ejecuta I05 o I06; prioridad y razón quedan registradas. |
| RF-08 | Marcar duplicados y mostrar su incidencia principal. | Rechaza autorreferencia, principal duplicada o de otro problema/espacio. |
| RF-09 | Registrar una solicitud de cancelación y resolverla. | El solicitante no cancela directamente; el coordinador aplica I13 u O12 según exista orden. |
| RF-10 | Crear órdenes correctivas y vincular incidencias admitidas. | Impide segunda orden activa para una incidencia y conserva vínculos de órdenes anteriores canceladas o cerradas. |
| RF-11 | Crear órdenes preventivas manuales. | Exige espacio y actividad; no exige incidencia ficticia para poder guardarlas. |
| RF-12 | Programar, asignar y reasignar técnicos. | Exige responsable y fechas válidas, rechaza solapamientos para todos los participantes y audita cambios. |
| RF-13 | Consultar asignaciones desde móvil. | El técnico ve órdenes propias y datos necesarios del espacio y antecedentes. |
| RF-14 | Iniciar, bloquear y reanudar órdenes. | Cumple O03–O05, permisos, motivos y condiciones de programación. |
| RF-15 | Registrar intervenciones y sus tiempos. | Cada técnico edita solo intervenciones propias abiertas; se rechazan tiempos inválidos y solapados. |
| RF-16 | Adjuntar y consultar evidencias autorizadas. | La evidencia queda ligada a su reporte o intervención; un archivo fallido no aparece como disponible. |
| RF-17 | Declarar finalización técnica. | O06 rechaza orden sin intervención cerrada o con alguna abierta, y exige evidencia o justificación. |
| RF-18 | Revisar la finalización y enviarla a verificación o devolverla. | El coordinador aplica O07 u O14 con condiciones y motivo pertinentes. |
| RF-19 | Registrar dictamen del responsable del espacio. | O08/O09 rechazan a quien no es responsable autorizado o participó como técnico. |
| RF-20 | Formalizar el cierre. | O10 exige dictamen favorable vigente y actualiza las incidencias vinculadas a RESUELTA. |
| RF-21 | Reabrir una orden cerrada. | O11 exige motivo, asignación y programación; conserva el cierre anterior y requiere nueva verificación. |
| RF-22 | Cancelar órdenes y resolver el destino de sus incidencias. | O12 exige motivos y una decisión por incidencia; ninguna queda EN_ATENCION con solo una orden cancelada. |
| RF-23 | Consultar historiales y decisiones auditadas. | Se identifica quién cambió qué y cuándo; un usuario ordinario no puede reescribir el historial. |
| RF-24 | Filtrar bandejas por estado, sede, espacio, prioridad y fechas pertinentes. | Los filtros respetan permisos y muestran claramente resultados vacíos. |
| RF-25 | Calcular y consultar indicadores definidos. | Los resultados exponen período, denominador y exclusiones; denominador cero produce “no calculable”. |
| RF-26 | Registrar correcciones autorizadas sin destruir el dato previo. | Muestra valor anterior, nuevo, autor, autorización y motivo. |
| RF-27 | Informar guardado, error y conflicto de versión. | Una respuesta fallida o incierta no se presenta como éxito; un reintento no duplica el registro. |

### 10.1. Clasificación de requerimientos funcionales

La clasificación no elimina ni renumera requerimientos. Define qué deberá implementarse para demostrar la primera versión y qué se conserva como evolución documentada. Cuando un requerimiento contiene controles avanzados, la delimitación indica la parte exigible en el MVP.

| Clasificación | Requerimientos | Delimitación de implementación |
|---|---|---|
| **MVP — primera versión obligatoria** | RF-01, RF-02, RF-03 | Acceso por roles y administración mínima de usuarios, sedes, espacios, responsables y categorías. Inhabilitación básica sin destruir historial. |
| **MVP — primera versión obligatoria** | RF-04, RF-05, RF-06, RF-07 | Reportar, consultar, aclarar, revisar, priorizar, admitir o descartar. |
| **MVP — primera versión obligatoria** | RF-10 | Crear una orden correctiva para una incidencia admitida. El caso principal de demostración utilizará una incidencia principal por orden; la relación con varios reportes queda modelada para evolución. |
| **MVP — primera versión obligatoria** | RF-12 | Programación básica y asignación de un técnico responsable con fechas válidas. La reasignación auditada y la prevención automática de solapamientos quedan como ampliación. |
| **MVP — primera versión obligatoria** | RF-13, RF-14, RF-15 | Consultar la asignación móvil; iniciar, bloquear, reanudar y registrar intervenciones con tiempos válidos. |
| **MVP — primera versión obligatoria** | RF-16, RF-17, RF-18 | Adjuntar evidencia; finalizar técnicamente; revisar y enviar a verificación o devolver con motivo. |
| **MVP — primera versión obligatoria** | RF-19, RF-20, RF-21 | Emitir dictamen, cerrar y reabrir conservando el ciclo anterior. |
| **MVP — primera versión obligatoria** | RF-23, RF-24, RF-25 | Historial de estados, filtros esenciales e indicadores académicos calculables con datos registrados. |
| **Mejora / ampliación posterior** | RF-08 | Gestión formal de duplicados, incluida prevención de cadenas o ciclos. |
| **Mejora / ampliación posterior** | RF-09, RF-22 | Solicitudes y resolución compleja de cancelaciones, especialmente cuando una orden agrupe varias incidencias. |
| **Mejora / ampliación posterior** | RF-11 | Órdenes preventivas manuales; se conserva en el análisis y el modelo para no bloquear su evolución. |
| **Mejora / ampliación posterior** | RF-26 | Correcciones autorizadas con conservación detallada del valor anterior. |
| **Mejora / ampliación posterior** | RF-27 | Detección de conflictos de versión e idempotencia avanzada de reintentos. El MVP sí debe mostrar éxito o error real conforme a RNF-03 y RNF-06. |

El MVP conserva el flujo obligatorio completo: **Reporte → revisión/priorización → orden → asignación → intervención → evidencia → finalización técnica → verificación → cierre/reapertura → historial.** Los elementos clasificados como ampliación permanecerán en los diagramas y reglas como alcance futuro, pero no se presentarán como implementados ni probados en la primera versión.

## 11. Requerimientos no funcionales

| ID / categoría | Condición propuesta | Verificación prevista |
|---|---|---|
| RNF-01 Seguridad | Los permisos deben comprobarse en cada operación protegida y en el acceso a evidencias. | Pruebas positivas y negativas por rol y recurso. |
| RNF-02 Integridad | Estados, vínculos e historial deben permanecer coherentes ante errores y concurrencia. | Provocar fallo intermedio y solicitudes simultáneas; comprobar ausencia de cambios parciales. |
| RNF-03 Usabilidad | Cada flujo debe mostrar estado actual, acción disponible, campos obligatorios y resultado comprensible. | Recorrido por tareas con lista de observaciones; no atribuir validación a usuarios que no participaron. |
| RNF-04 Accesibilidad | Web y escritorio deben permitir navegación por teclado con foco visible; formularios tendrán etiquetas y errores asociados; móvil tendrá nombres accesibles y alternativas al color. | Revisión manual de navegación y lector de pantalla disponible; evaluación posterior de contraste con criterio normativo documentado. No se declara certificación. |
| RNF-05 Rendimiento | Se medirán consulta de bandeja, guardado y carga de evidencia con entorno, volumen y concurrencia registrados. | Línea base posterior; umbrales pendientes antes de aceptar rendimiento. |
| RNF-06 Disponibilidad | Las interrupciones deben identificarse sin confirmar escrituras no realizadas. Debe existir procedimiento de recuperación. | Simulación de desconexión y restauración posterior; disponibilidad objetivo y tiempos de recuperación pendientes. |
| RNF-07 Mantenibilidad | Las reglas y transiciones deben localizarse y verificarse de forma consistente para los tres clientes. | Revisión de diseño y pruebas de una modificación controlada. No prescribe un patrón todavía. |
| RNF-08 Compatibilidad | Los flujos deben funcionar en una matriz de equipos y versiones aprobada. | Pruebas en las combinaciones acordadas después de seleccionar tecnología. |
| RNF-09 Portabilidad | Instalación, configuración y datos de prueba deben reproducirse en un segundo entorno compatible. | Seguir documentación desde un entorno limpio y registrar incidencias. |
| RNF-10 Protección de información | Credenciales y secretos no deben incorporarse al repositorio; evidencias no deben tener acceso público por defecto. | Inspección de configuración y pruebas de autorización. Retención y respaldo se definirán antes de implementación. |
| RNF-11 Auditabilidad | Las fechas, autores, cambios y correcciones deben mantenerse con referencia temporal coherente. | Reconstruir una atención completa y verificar orden de eventos y zona horaria de presentación. |

### 11.1. Clasificación de requerimientos no funcionales

| Clasificación | Requerimientos | Alcance |
|---|---|---|
| **MVP — primera versión obligatoria** | RNF-01, RNF-02 | Autorización por rol y recurso; integridad de los cambios del flujo principal. La simulación exhaustiva de concurrencia queda para evolución. |
| **MVP — primera versión obligatoria** | RNF-03, RNF-04 | Mensajes comprensibles, formularios etiquetados, foco visible y alternativas al color en los flujos principales. |
| **MVP — primera versión obligatoria** | RNF-06 | No confirmar escrituras fallidas y permitir recuperar la operación mediante un nuevo intento consciente del usuario; sin funcionamiento offline. |
| **MVP — primera versión obligatoria** | RNF-07, RNF-10, RNF-11 | Reglas consistentes, secretos fuera del repositorio, evidencias protegidas e historial reconstruible. |
| **Mejora / ampliación posterior** | RNF-05 | Pruebas de carga, concurrencia y umbrales cuantitativos una vez exista línea base y entorno definido. |
| **Mejora / ampliación posterior** | RNF-08 | Matriz ampliada de navegadores, equipos y versiones. El MVP se validará en los entornos concretos declarados para la defensa. |
| **Mejora / ampliación posterior** | RNF-09 | Reproducción en un segundo entorno compatible y ampliación de portabilidad. La instalación inicial sí deberá documentarse. |

No se establecen porcentajes de disponibilidad, tiempos de respuesta, capacidad de usuarios ni metas de mejora sin sustento. RNF-05, RNF-06 y RNF-08 requieren completar parámetros antes de la aceptación técnica final.

## 12. Información y conceptos del dominio

| Concepto | Información necesaria inicialmente | Límite conceptual |
|---|---|---|
| INCIDENCIA | Identificador, autor, espacio, categoría, descripción, prioridad, estado, fechas, aclaraciones y referencia principal si es duplicada. | Describe la necesidad reportada, no las actividades realizadas. |
| ORDEN_TRABAJO | Tipo, espacio, alcance, estado, programación, responsables, vínculos, motivos de cancelación/reapertura. | Autoriza y organiza el trabajo; no es el registro detallado de cada acción técnica. |
| INTERVENCION | Orden, técnico, actividad, inicio, fin, resultado y observaciones. | Describe una ejecución concreta. Una orden admite varias intervenciones. |
| VERIFICACION | Orden y ciclo evaluado, responsable, dictamen, observación, fecha y vigencia. | Registra aceptación o inconformidad; no se reduce a una fotografía o cambio de estado. |
| HISTORIAL_ESTADO | Objeto afectado, origen, destino, autor, momento, causa y evento relacionado. | Conserva transiciones; no sustituye todas las necesidades de auditoría. |
| Evidencia | Referencia al archivo, objeto al que pertenece, autor, fecha de carga, nombre descriptivo y tipo. | Archivo y metadatos se distinguirán explícitamente en el diseño posterior. |
| Asignación | Orden, técnico, responsabilidad e intervalos programados y su vigencia. | Permite colaboradores y evolución del plan sin perder antecedentes. |
| Verificador del espacio | Persona, espacio y vigencia de la autorización. | La autorización actual no altera dictámenes históricos. |

También se consideran Usuario, Rol, Sede, Espacio y Categoría. No se fijan tablas, claves, tipos, cardinalidades definitivas ni relaciones físicas en esta fase.

### 12.1. Evidencias fotográficas: requisitos y trabajo posterior

Se confirma que los binarios y sus metadatos se tratarán como responsabilidades distintas. No se ha seleccionado almacenamiento. En la Fase 3 se comparará dónde guardar archivos y cómo vincularlos de manera consistente con la información relacional.

La estrategia deberá cubrir: formatos y tamaños permitidos; autorización de carga y lectura; nombres internos; metadatos mínimos; cargas incompletas y archivos sin vínculo; consistencia de respaldo/restauración; retención y eliminación; tratamiento de ubicación u otros metadatos embebidos; prevención de exposición pública; consulta desde las tres plataformas.

No se fijan límites de tamaño ni plazos de conservación sin evaluación. Las fotografías se centrarán en la instalación, evitando rostros, documentos o información personal innecesaria. Una orden puede finalizar sin fotografía si existe justificación registrada; la verificación sigue siendo obligatoria.

## 13. Factibilidad preliminar

| Dimensión | Evaluación | Condiciones y evidencia pendiente |
|---|---|---|
| Técnica | El proceso está delimitado y es susceptible de automatización. La viabilidad tecnológica específica aún no se valida. | Conocer equipos y conectividad; evaluar soporte de cámara y archivos; probar integración y distribución de tres clientes después de aprobar stack. |
| Económica | No hay presupuesto ni costos observados; no procede calcular retorno o ahorro. | Estimar horas de análisis, desarrollo, pruebas y capacitación; infraestructura, respaldo, almacenamiento de fotos, distribución y mantenimiento; comparar alternativas sin atribuir costo cero al software gratuito. |
| Operativa | Los roles y el flujo pueden representarse, pero la aceptación institucional no está demostrada. | Validar disponibilidad de responsables, suplencias de verificación, disciplina de registro, formación y procedimiento de emergencia. En el caso ficticio se simularán estos roles declaradamente. |
| Temporal | La entrega académica completa implica modelado, tres clientes, integración y evidencias. | Definir calendario según alcance aprobado, equipo y entorno. La referencia a una hora prioriza esta entrega analítica; no constituye una promesa de implementación y verificación total en ese plazo. |

**Conclusión:** factibilidad preliminar condicionada, no dictamen definitivo. El alcance evita integraciones y funcionamiento offline para mantener el caso abordable, pero la estimación deberá actualizarse tras el diseño técnico.

### 13.1. Riesgos y respuesta

| Riesgo | Consecuencia | Respuesta propuesta |
|---|---|---|
| Ampliar funciones en las tres plataformas | Mayor esfuerzo y discrepancias. | Mantener la matriz funcional aprobada. |
| Demora de verificación | Órdenes sin cierre. | Bandeja visible y suplencia autorizada; no cerrar por silencio. |
| Conflicto de edición | Estados o agendas incompatibles. | Validar versión y condiciones al confirmar; probar concurrencia. |
| Fotografías inaccesibles o sin vínculo | Evidencia incompleta. | Diseñar carga y respaldo consistentes en Fase 3. |
| Roles acumulados | Autoverificación del trabajo. | Aplicar separación por orden, aun cuando una persona tenga varios roles. |
| Medir con datos sintéticos | Conclusiones exageradas. | Diferenciar prueba de cálculo de mejora operativa real. |

## 14. Metodología propuesta y aplicación

Se propone **desarrollo iterativo e incremental con revisiones al cierre de fase**. La propuesta responde al equipo aún no definido, a la revisión explícita del usuario y a la necesidad de validar primero reglas y diseño antes de programar. No se declarará Scrum ni se inventarán Product Owner, Scrum Master o ceremonias que no se realicen.

El usuario actúa como aprobador del caso académico; no se le atribuye representación real de la institución ficticia. Quien desarrolle y documente el proyecto mantendrá el registro de decisiones, requisitos, pendientes y evidencias. Docentes, técnicos y responsables serán perfiles de validación simulada salvo participación real documentada.

### 14.1. Organización concreta

1. Aprobar esta línea base y resolver observaciones antes del modelado.
2. En Fase 2, modelar primero el flujo normal y luego comprobar excepciones con los mismos RF y estados.
3. En Fase 3, comparar alternativas, justificar decisiones y someter el stack a aprobación; confirmar iniciales antes del SQL definitivo.
4. En Fase 4, revisar mockups y validar tareas del prototipo; etiquetar simulaciones.
5. En Fase 5, desarrollar incrementos verificables: acceso y catálogos; reporte y revisión; programación; ejecución; verificación y cierre; indicadores e integración completa.
6. En Fase 6, contrastar la evidencia con los requisitos y preparar conclusiones, informe y defensa.

Cada incremento tendrá requerimientos seleccionados, criterios de aceptación, registro de cambios y demostración. Se considerará terminado solo si la funcionalidad prevista está integrada, las pruebas pertinentes se ejecutaron y la documentación refleja su estado. Una interfaz con datos simulados solo cumple los criterios del prototipo.

No se asignan duraciones o capacidad de equipo sin calendario confirmado. Antes de cambios estructurales importantes en un repositorio se deberá crear el commit de resguardo solicitado. La carpeta actual no es un repositorio Git; esta fase agrega documentación nueva y no modifica proyectos existentes.

## 15. Trazabilidad inicial

La matriz se extenderá con elementos UML, tablas, componentes, pantallas, pruebas y evidencias cuando existan. No se consignan artefactos futuros como terminados.

| Problema / objetivo | Requerimientos | Proceso y reglas | Evidencia futura |
|---|---|---|---|
| Avisos dispersos / OE-01 | RF-04–RF-09 | Reporte y revisión; I01–I07, I13. | Crear, aclarar, admitir, descartar y vincular duplicado. |
| Asignación informal / OE-01, OE-03 | RF-10–RF-14 | Planificación y ejecución; O01–O05, RN-26. | Programar y rechazar conflicto concurrente de técnico. |
| Pérdida de continuidad / OE-02, OE-04 | RF-15–RF-18, RF-23, RF-26 | Intervenciones y revisión; O06, O07, O14. | Historial completo con evidencias y corrección auditada. |
| Cierre prematuro / OE-01, OE-04 | RF-19–RF-22 | Verificación, cierre y excepciones; O08–O13. | Rechazo, aceptación, cierre y reapertura sin borrar datos. |
| Falta de medición / OE-05 | RF-24, RF-25 | Consulta institucional. | Recalcular indicadores a partir de eventos conocidos. |
| Acceso indebido / OE-04 | RF-01–RF-03, RF-16; RNF-01, RNF-10 | Acceso según rol y recurso. | Intentos autorizados y no autorizados por cada actor. |
| Datos inconsistentes / OE-02, OE-05 | RF-27; RNF-02, RNF-11 | Confirmación íntegra de operaciones. | Fallo intermedio y repetición sin duplicar. |
| Uso por plataforma / OE-03, OE-06 | Todos según matriz; RNF-03, RNF-04, RNF-08, RNF-09 | Flujo distribuido. | Recorrido web → escritorio → móvil → web → escritorio. |

## 16. Indicadores y evaluación posterior

| Indicador | Método | Valor esperado | Evidencia y límites |
|---|---|---|---|
| Tiempo hasta primera revisión | Fecha de I02 menos I01; informar mediana y cantidad de casos. | Meta pendiente de línea base. En pruebas, coincidencia con los eventos de referencia. | Historial; reportes no revisados se muestran aparte. |
| Tiempo hasta aceptación favorable inicial | Primera O09 vigente del ciclo inicial menos I01 de cada incidencia principal vinculada. | Meta operativa pendiente. | Se identifica el ciclo y se excluyen duplicados, descartados y cancelados. No confundir O09 con el cierre O10. |
| Cumplimiento de programación | Órdenes cuya finalización técnica aceptada ocurre antes o en el plazo de referencia ÷ órdenes con plazo de referencia vencido en el período, no canceladas × 100. | Meta pendiente. | Usar el plazo aprobado al iniciar el ciclo; conservar revisiones posteriores. Pendientes vencidas permanecen en denominador; canceladas se informan aparte. |
| Proporción de reaperturas | Órdenes de una cohorte de primer cierre con al menos una O11 en la ventana observada ÷ órdenes de esa cohorte con ventana completa × 100. | Meta y ventana pendientes. | Informar período y duración de ventana; cada orden se cuenta una vez. No mezclar devolución O08 con reapertura. |
| Antigüedad de pendientes | Momento de consulta menos I01 para incidencias no terminales. | Sin umbral fijado; visualizar distribución y casos. | Fecha de corte explícita; incluye pendientes de información y verificación. |

Denominador cero significa “no calculable”, no cero por ciento. Un conjunto sintético permite comprobar fórmulas; una comparación antes/después requiere observaciones reales comparables y no podrá inferirse del escenario ficticio.

## 17. Escenarios de aceptación previstos

**Estado de todos los escenarios: pendientes de ejecución.** No existe todavía una aplicación que pueda aprobar estas pruebas.

| ID | Escenario | Resultado esperado | RF principales |
|---|---|---|---|
| PA-01 | Reporte correcto y reporte incompleto. | Solo el correcto se guarda; los errores explican cómo corregir. | RF-04, RF-27 |
| PA-02 | Aclaración, duplicado y descarte. | Rutas y motivos válidos; sin autorreferencias ni pérdida de historial. | RF-06–RF-08 |
| PA-03 | Dos órdenes o dos asignaciones incompatibles simultáneas. | Solo una operación incompatible se confirma; no hay doble orden activa o agenda solapada. | RF-10, RF-12 |
| PA-04 | Flujo integrado normal. | Reporte web, asignación en escritorio, intervención móvil, verificación web y cierre en escritorio coherentes. | RF-04, RF-10–RF-20 |
| PA-05 | Bloqueo y reanudación. | Se conservan causa, autorización y programación; no se habilita trabajo en intervalo incompatible. | RF-12, RF-14 |
| PA-06 | Finalización incompleta o autoverificación. | Se rechazan ambas; no se cierra la orden. | RF-17–RF-20 |
| PA-07 | Inconformidad y posterior aceptación. | Se conserva cada dictamen y se exige nueva intervención cuando corresponda. | RF-15, RF-19 |
| PA-08 | Reapertura tras cierre. | Nuevo ciclo, motivo y programación; dictamen anterior visible y sin vigencia para el nuevo cierre. | RF-21, RF-23 |
| PA-09 | Cancelación con varias incidencias. | Cada una queda ADMITIDA o CANCELADA según decisión expresa. | RF-22 |
| PA-10 | Corte de conexión durante guardado o foto. | No informa éxito inexistente; reintentar no duplica; archivo incompleto no figura como evidencia válida. | RF-16, RF-27 |
| PA-11 | Acceso ajeno e inhabilitación de usuario. | Se deniega acceso a datos/archivos no autorizados y se conserva historial. | RF-01, RF-02, RF-05 |
| PA-12 | Indicadores con conjunto conocido y sin casos. | Valores recalculables; “no calculable” cuando corresponda. | RF-25 |
| PA-13 | Orden preventiva manual. | Recorre programación, ejecución, verificación y cierre sin incidencia artificial. | RF-11–RF-20 |

## 18. Material visual y control de esta entrega

| Número | Figura generada | Formatos |
|---|---|---|
| 1 | Flujo actual de atención de incidencias. | PNG, SVG y fuente Mermaid. |
| 2 | Flujo propuesto de atención y mantenimiento. | PNG, SVG y fuente Mermaid. |
| 3 | Actores y distribución funcional por plataforma. | PNG, SVG y fuente estructurada JSON. |
| 4 | Estados y transiciones de una incidencia. | PNG, SVG y fuente Mermaid. |
| 5 | Estados y transiciones de una orden de trabajo. | PNG, SVG y fuente Mermaid. |

Las figuras se dibujan de manera determinista a partir de nodos, textos y rutas estructuradas; no son imágenes técnicas producidas por generación visual automática. Los archivos Mermaid conservan la definición semántica de los flujos, y el JSON conserva la composición exportada. Las imágenes de estados resumen las cancelaciones; sus tablas definen exhaustivamente los permisos y condiciones.

Próximas figuras previstas, aún no elaboradas: Figura 6, Casos de Uso; Figura 7, Clases; Figura 8, MER; Figura 9, Arquitectura; Figura 10, Mockups Web; Figura 11, Mockups Desktop; Figura 12, Mockups Mobile. Se crearán progresivamente en sus fases. Las figuras de esta entrega no sustituyen los dos UML exigidos.

### 18.1. Revisión documental

Se revisaron consistencia entre estados y transiciones, cobertura de actores, restricciones y separación de conceptos. Esta revisión es documental; no constituye prueba de software, validación con usuarios reales ni aceptación institucional. La comprobación de archivos y figuras se registra en el archivo de control de entrega.

### 18.2. Decisiones para la revisión del usuario

Esta fase propone aprobar conjuntamente: ciclos I01–I14 y O01–O14 como modelo completo; distribución funcional; separación entre finalización, verificación y cierre; prohibición de autoverificación; reglas de cancelación y reapertura; RF-01–RF-27; RNF-01–RNF-11; clasificación MVP/ampliaciones; metodología incremental y alcance sin integraciones externas.

Información que puede completarse después sin bloquear esta revisión: denominación oficial de carrera, autoría y plantilla académica; iniciales SQL; equipo y calendario; equipos disponibles; parámetros de rendimiento, disponibilidad y retención. Estos datos deben resolverse antes de sus entregables dependientes.

## 19. Línea base del MVP y cierre de Fase 1

### 19.1. Transiciones exigidas en la primera versión

El modelo completo conserva I01–I14 y O01–O14. Para la implementación del MVP se exigirán I01–I06 e I08–I12; I07, I13 e I14 se mantienen como ampliaciones relacionadas con duplicidad y cancelación. En órdenes se exigirán O01–O11 y O14; O12 y O13 quedan como ampliaciones de cancelación y retiro de una verificación favorable antes del cierre.

El bloqueo O04/O05 permanece en el MVP porque permite documentar por qué una intervención no puede continuar. La reapertura O11 también permanece porque forma parte del flujo solicitado. En el MVP, la reapertura exigirá motivo y nueva asignación o ratificación del responsable; el control automático de solapamientos se implementará posteriormente.

### 19.2. Reglas del MVP y reglas de evolución

| Clasificación | Reglas | Aplicación |
|---|---|---|
| **MVP — primera versión obligatoria** | RN-01, RN-02, RN-03, RN-05 | Datos mínimos, prioridad confirmada y una sola orden correctiva activa por incidencia. La agrupación de varios reportes en una orden no será necesaria para demostrar el MVP. |
| **MVP — primera versión obligatoria** | RN-07, RN-09, RN-10, RN-11, RN-12, RN-13 | Responsable técnico, intervención autorizada, bloqueo, evidencia, finalización, verificación, cierre y reapertura. |
| **MVP — primera versión obligatoria** | RN-15, RN-16, RN-17, RN-18, RN-19 | Historial de estados, conservación referencial, separación de funciones y ausencia de cierre automático. |
| **MVP — primera versión obligatoria** | RN-21, RN-22, RN-23, RN-27 | Conservación del ciclo anterior, responsabilidades técnicas, datos válidos de intervención y acceso según rol/recurso. En RN-23 el MVP valida tiempos dentro de cada intervención; el control global de intervalos superpuestos queda para evolución. |
| **Mejora / ampliación posterior** | RN-04, RN-25 | Duplicados y prevención de cadenas o ciclos de duplicidad. |
| **Mejora / ampliación posterior** | RN-06 | Órdenes preventivas manuales. |
| **Mejora / ampliación posterior** | RN-08, RN-26 | Detección automática de solapamientos y conservación avanzada de versiones de programación. |
| **Mejora / ampliación posterior** | RN-14, RN-20 | Cancelaciones y resolución del destino de incidencias vinculadas. |
| **Mejora / ampliación posterior** | RN-24 | Corrección histórica con comparación de valores anteriores y nuevos. |

### 19.3. Estado real al cierre

- Completado: caso aprobado, análisis, factibilidad preliminar, actores, procesos, alcance, estados, requerimientos, reglas, clasificación MVP y cinco figuras de análisis.
- Documentado para evolución: duplicados, preventivos, cancelaciones complejas, control avanzado de agenda, correcciones históricas y concurrencia.
- Pendiente: UML de casos de uso y clases, MER, modelo relacional, diccionario, SQL, arquitectura, stack, mockups, prototipo, implementación, pruebas del software, indicadores ejecutados, informe final y defensa.
- Entorno confirmado expresamente por el usuario para el desarrollo futuro: Arch Linux dentro de WSL.
- Repositorio: la versión aprobada de esta fase se identificará con el tag `v0.1-fase-1`. Los tags `v0.2-informe` y `v1.0-entrega` quedan reservados para entregas futuras y no se crearán anticipadamente.

**Cierre de Fase 1:** entrega ajustada para aprobación definitiva. No se inicia Fase 2, no se seleccionan tecnologías y no se programan las aplicaciones hasta la siguiente autorización.
