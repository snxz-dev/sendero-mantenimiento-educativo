# Fase 3. Arquitectura, Stack Tecnológico y Selección del Motor de Base de Datos

## Gestión de incidencias y mantenimiento de infraestructura educativa

**Institución académica:** Instituto Superior Universitario Japón  
**Carrera:** Tecnología Superior en Desarrollo de Software  
**Autor:** Stalyn Mateo Sánchez Cevallos  
**Año:** 2026  
**Caso:** Centro de Formación Técnica Sendero, institución ficticia.  
**Estado:** diseño técnico cerrado. La implementación de Web, Desktop, Mobile y Backend continúa pendiente.

## 1. Decisión y justificación breve

Se adopta una arquitectura cliente-servidor con un backend modular único y una API REST compartida. Los clientes Web, Desktop y Mobile presentan funciones adecuadas a cada contexto de uso, pero no deciden por sí solos permisos, estados ni reglas críticas. Cada solicitud llega a Controllers, pasa a Services y utiliza Repositories implementados con Prisma para acceder a PostgreSQL.

La decisión reduce el número de lenguajes principales: TypeScript se empleará en las tres interfaces y en el backend. React se reutiliza entre Web y Desktop; React Native conserva el modelo de componentes y conocimientos de React en Mobile. El sistema evita microservicios, colas, Redis y orquestadores porque el alcance y la carga del MVP no los justifican.

La arquitectura seleccionada es:

`Web / Desktop / Mobile → REST API → Controllers → Services → Repositories/Prisma → PostgreSQL`

Los archivos fotográficos se almacenarán fuera de la base de datos en un directorio persistente administrado exclusivamente por el backend. PostgreSQL conservará metadatos, hash SHA-256 y una clave de almacenamiento opaca mediante la tabla `PREF_EVIDENCIA` ya aprobada.

## 2. Stack tecnológico aprobado

| Componente | Tecnología | Justificación para el MVP |
|---|---|---|
| Lenguaje principal | TypeScript | Mantiene tipado y conocimiento común en clientes y API. |
| Web | React + TypeScript + Vite | Adecuado para formularios, bandejas, consulta e indicadores; Vite simplifica el desarrollo local. |
| Desktop | Electron + React + TypeScript | Permite reutilizar componentes y flujos de React para la consola de coordinación. |
| Mobile | React Native + Expo + TypeScript | Facilita captura de fotografías y ejecución de tareas de campo con el mismo lenguaje. |
| Backend/API | Node.js + Express + TypeScript | Proporciona una API REST sencilla, explícita y suficiente para un monolito modular académico. |
| Contrato API | REST sobre HTTPS, JSON y `multipart/form-data` | JSON cubre datos; multipart permite recibir evidencias sin insertar binarios en PostgreSQL. |
| Validación | Zod en límites de entrada, más restricciones de PostgreSQL | Los esquemas compartidos evitan divergencias básicas; la API y la base siguen validando. |
| Autenticación | JWT firmado y Argon2id para credenciales | Se evita almacenar contraseñas; los tokens identifican al usuario en los tres clientes. |
| Autorización | Middleware de autenticación y políticas RBAC en Services | El rol habilita una operación y el servicio comprueba además contexto, estado y pertenencia. |
| Base de datos | PostgreSQL | Soporta claves, restricciones, transacciones e índices parciales necesarios para el modelo. |
| Acceso a datos | Prisma ORM | Aporta acceso tipado, migraciones y transacciones desde TypeScript sin reemplazar las reglas del servicio. |
| Evidencias | Filesystem persistente gestionado por backend | Es la opción más simple para el MVP y mantiene un único punto de control para los tres clientes. |
| Pruebas futuras | Vitest, Supertest, React Testing Library y Playwright | Cubren unidades, API, componentes y recorridos críticos cuando comience la implementación. |
| Documentación API | OpenAPI 3 con Swagger UI | Define endpoints, esquemas, seguridad y respuestas verificables para los tres clientes. |
| Organización | Monorepositorio con espacios de trabajo | Facilitará compartir contratos y utilidades sin crear servicios independientes. |

Las versiones exactas quedarán fijadas al crear los proyectos, después de aprobar esta fase. La selección de stack no implica que las dependencias estén instaladas ni que exista código funcional.

## 3. Arquitectura por capas

### 3.1. Clientes

- **Web:** reporte de incidencias, aclaraciones, consulta de estados, verificación autorizada e indicadores según rol.
- **Desktop:** revisión, priorización, creación y asignación de órdenes, control de ejecución, cierre, reapertura y administración mínima.
- **Mobile:** consulta de asignaciones, inicio y finalización de intervenciones, bloqueo, captura y envío de evidencias.

Los clientes pueden ocultar acciones improcedentes y validar campos para mejorar la experiencia. Esas validaciones no otorgan permisos ni sustituyen la decisión del backend.

### 3.2. REST API y Controllers

Express recibirá solicitudes HTTPS. Los Controllers traducirán parámetros, cuerpo, archivos y contexto autenticado a comandos de aplicación. No contendrán reglas de transición ni consultas directas a PostgreSQL. Las respuestas utilizarán códigos HTTP coherentes y un formato de error común.

### 3.3. Services y reglas de negocio

Los Services serán la autoridad final. Cada operación comprobará rol, relación con el recurso, estado vigente, precondiciones y consistencia del ciclo. La creación de una orden, una finalización, una verificación, un cierre o una reapertura agrupará en una transacción todos los cambios de entidad e historial que deban confirmarse juntos.

Las transiciones se implementarán como políticas explícitas. La API rechazará toda transición ausente en la matriz MVP aprobada, aunque un cliente manipulado intente enviarla. Las funciones de duplicidad, cancelación formal, orden preventiva, colaboradores, retiro de evidencia y correcciones históricas no se expondrán mientras continúen como ampliación.

### 3.4. Repositories y Prisma

Los Repositories encapsularán consultas y persistencia. Prisma mapeará las 21 tablas existentes, conservará sus nombres físicos con prefijo `PREF_` hasta confirmar las iniciales definitivas y ejecutará transacciones. Las restricciones complejas que dependan de varias tablas se comprobarán en Services dentro de una transacción; PostgreSQL seguirá siendo la última barrera para claves, unicidad, nulabilidad y `CHECK`.

### 3.5. PostgreSQL y almacenamiento de evidencias

PostgreSQL mantendrá datos estructurados e historiales. El almacenamiento de archivos será un componente separado detrás de una interfaz interna, por lo que una migración futura a almacenamiento compatible con S3 no obligaría a cambiar Controllers ni reglas de negocio. Ningún cliente recibirá rutas físicas del servidor.

![Figura 8. Arquitectura técnica propuesta para el sistema Sendero](figuras/figura_08_arquitectura.png)

**Figura 8. Arquitectura técnica propuesta para el sistema Sendero.** Fuente: elaboración propia. La definición estructurada se conserva en `figura_08_arquitectura.mmd`.

## 4. Estrategia de autenticación y autorización

### 4.1. Inicio de sesión y contraseñas

El backend recibirá el nombre de acceso y la contraseña mediante HTTPS. Comparará la contraseña con `credencial_hash`; nunca registrará ni devolverá la contraseña. Se selecciona **Argon2id** como primera opción. bcrypt queda como alternativa compatible si el entorno presentara una limitación documentada, con un factor de trabajo medido antes de la entrega.

El hash incluirá sal aleatoria generada por la biblioteca. Los parámetros de costo serán configurables y se fijarán mediante medición en el entorno de despliegue. No se asignan cifras arbitrarias en esta fase.

### 4.2. JWT y manejo por cliente

Tras autenticar, la API emitirá un JWT de acceso firmado, de vida limitada, que contendrá un identificador de usuario y datos mínimos. No contendrá contraseñas ni datos sensibles innecesarios. Web mantendrá el token de acceso en memoria; Desktop y Mobile utilizarán el almacenamiento seguro proporcionado por el sistema operativo. No se guardará en `localStorage`.

La tabla congelada no incluye sesiones ni tokens de actualización. Por ello el MVP usará tokens de acceso limitados y solicitará un nuevo inicio de sesión al expirar. La renovación persistente y la revocación individual se documentan como evolución que requeriría revisar expresamente el modelo; no se introduce una tabla nueva en esta fase.

### 4.3. Protección y roles

Un middleware verificará firma, vigencia y formato del token. Después, la política de autorización consultará que el usuario siga activo y evaluará sus roles vigentes. Los Services comprobarán además las condiciones de negocio:

| Rol | Permisos principales del MVP |
|---|---|
| Solicitante | Reportar, responder aclaraciones y consultar sus incidencias. |
| Responsable del Espacio | Consultar trabajos de sus espacios y emitir verificación cuando no haya participado como técnico. |
| Coordinador | Revisar, priorizar, admitir o descartar, crear y programar órdenes, asignar técnico, resolver bloqueos y coordinar reaperturas. |
| Técnico | Consultar sus asignaciones, registrar intervenciones y bloqueos, cargar evidencia y solicitar finalización técnica. |
| Responsable Institucional | Consultar información e indicadores autorizados y cerrar órdenes verificadas conforme a política. |
| Administrador | Administrar usuarios, roles, sedes, espacios, responsables, categorías y catálogos habilitados. |

Tener un rol no basta para cualquier registro. Por ejemplo, un Técnico solo actuará sobre una asignación vigente propia; un Responsable del Espacio verificará únicamente espacios bajo su responsabilidad vigente; y nadie podrá verificar una orden en cuya ejecución participó cuando la regla de independencia lo prohíba.

## 5. Estrategia de evidencias fotográficas

El cliente enviará la fotografía a un endpoint autenticado mediante `multipart/form-data`. El backend aplicará el siguiente flujo:

1. comprobar permiso, incidencia o intervención asociada y estado compatible;
2. limitar tamaño y tipos aceptados según configuración aprobada durante implementación;
3. validar la firma real del archivo, sin confiar solo en nombre o MIME declarado;
4. calcular SHA-256 mientras recibe el contenido;
5. guardar primero en una ubicación temporal y mover de forma atómica a la ubicación definitiva;
6. crear en `PREF_EVIDENCIA` los metadatos, hash y `clave_almacenamiento` opaca;
7. servir la fotografía solo mediante un endpoint autorizado, con nombre de descarga seguro.

La ruta física no se expone y los archivos se mantienen fuera del directorio público del servidor. La copia de seguridad debe cubrir conjuntamente PostgreSQL y el directorio persistente para poder reconciliar metadatos y archivos. Si en el futuro se requieren varias instancias de backend, despliegue sin disco persistente o alta disponibilidad, la misma interfaz de almacenamiento podrá apuntar a S3 compatible; esa migración no forma parte del MVP.

## 6. Adaptación de la base de datos a PostgreSQL

El archivo `database/esquema_preliminar.sql` se adapta a PostgreSQL sin cambiar el modelo conceptual ni agregar tablas. El script ejecutable principal contiene exactamente 21 instrucciones `CREATE TABLE` del MVP. Las cuatro estructuras futuras continúan descritas en Fase 2, pero no se crean al ejecutar el esquema principal.

Los cambios físicos son:

- uso de `BIGINT GENERATED ALWAYS AS IDENTITY` para claves sustitutas;
- uso de `TIMESTAMPTZ` para fechas operativas y de auditoría;
- conservación de `BOOLEAN`, claves foráneas, `UNIQUE`, `CHECK` e índices B-tree;
- transacción DDL mediante `BEGIN` y `COMMIT`;
- índices únicos parciales para un responsable principal vigente por espacio, un técnico responsable vigente por orden y ciclo, y una verificación vigente por orden y ciclo;
- mantenimiento de catálogos para estados de incidencia y orden, evitando enums nativos que dificulten su evolución;
- conservación temporal de `PREF_` hasta que el autor confirme las iniciales del script definitivo.

Las operaciones de cambio de estado deberán bloquear la fila vigente con la estrategia transaccional apropiada, comprobar el estado esperado, actualizar la entidad e insertar el historial en la misma transacción. La regla de una orden correctiva activa por incidencia cruza `ORDEN_INCIDENCIA`, `ORDEN_TRABAJO` y su catálogo de estados; se controlará en el Service dentro de una transacción y podrá reforzarse posteriormente con una función o trigger PostgreSQL si las pruebas demuestran que es necesario. No se añade una tabla para resolverla.

Prisma se mapeará sobre este esquema existente. El SQL físico conserva la autoridad de restricciones que Prisma no represente completamente, incluidos índices parciales. Las migraciones futuras deberán revisarse para impedir que el ORM elimine esas restricciones.

## 7. Flujo técnico completo

1. El usuario se autentica y recibe un JWT de acceso.
2. El cliente envía una operación REST con datos validados localmente.
3. Express aplica límites, análisis del cuerpo y middleware de autenticación.
4. La autorización inicial verifica identidad y rol vigente.
5. El Controller construye un comando y delega al Service.
6. El Service consulta mediante Repository/Prisma, valida pertenencia, estado y transición.
7. Si hay cambios relacionados, Prisma abre una transacción PostgreSQL.
8. PostgreSQL aplica PK, FK, nulabilidad, unicidad y restricciones `CHECK`.
9. El Service registra el historial en la misma transacción y confirma o revierte todo el conjunto.
10. Si existe fotografía, el servicio coordina el archivo persistente con los metadatos; una falla deja un resultado explícito y reconciliable.
11. El Controller devuelve una respuesta sin exponer credenciales, rutas internas ni detalles de error sensibles.
12. Los tres clientes actualizan su vista a partir del resultado confirmado por la API.

## 8. Riesgos técnicos principales y mitigaciones

| Riesgo | Consecuencia | Mitigación prevista |
|---|---|---|
| Duplicar reglas en clientes | Transiciones distintas entre plataformas. | Centralizar permisos y estados en Services; compartir solo contratos y validación de formato. |
| Token robado | Uso indebido durante su vigencia. | HTTPS, vida limitada, almacenamiento seguro, datos mínimos y revalidación de usuario activo. |
| Configuración insegura de Electron | Acceso excesivo desde la interfaz. | `contextIsolation`, sandbox, sin integración Node en renderer, CSP restrictiva e IPC mínimo validado. |
| Archivo malicioso o demasiado grande | Consumo de recursos o exposición de contenido. | Límites, firma real, allowlist, nombres opacos, directorio no público y descarga autenticada. |
| Desfase entre archivo y metadatos | Evidencia huérfana o referencia rota. | Escritura temporal, movimiento atómico, estados explícitos, reconciliación y respaldo coordinado. |
| Condiciones de carrera | Dos transiciones incompatibles o responsables duplicados. | Transacciones, bloqueo/actualización condicional, restricciones parciales y pruebas de concurrencia dirigidas. |
| Migración Prisma elimina SQL manual | Pérdida de índices o restricciones. | Revisar el SQL de cada migración y conservar pruebas estructurales del esquema. |
| Diferencias de compilación desde WSL | Dificultad para empaquetar clientes nativos. | Desarrollar en Arch Linux WSL; documentar y ejecutar el empaquetado final en el sistema destino cuando Electron o Expo lo requieran. |
| Filesystem no persistente en despliegue | Pérdida de fotografías. | Exigir volumen persistente y respaldo; migrar a S3 compatible antes de usar múltiples instancias. |
| Dependencias cambian | Incompatibilidades futuras. | Fijar versiones y archivo de bloqueo al iniciar implementación; actualizar solo con validación. |

## 9. Estado al cierre de Fase 3

Quedan definidos la arquitectura, el stack, PostgreSQL, el acceso mediante Prisma, la autenticación, la autorización y el almacenamiento de evidencias. También queda preparada la adaptación física del SQL para PostgreSQL.

No existen aún aplicaciones funcionales, endpoints, migraciones ejecutadas, despliegues ni pruebas de software. Web, Desktop, Mobile y Backend continúan pendientes. La siguiente fase deberá comenzar con mockups y contratos antes de crear implementación, conforme a la planificación aprobada.

## 10. Referencias técnicas

- OWASP Foundation. *Password Storage Cheat Sheet*. https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
- Electron. *Security*. https://www.electronjs.org/docs/latest/tutorial/security
- Expo. *Camera*. https://docs.expo.dev/versions/latest/sdk/camera/
- Express. *Security best practices*. https://expressjs.com/en/advanced/best-practice-security.html
- PostgreSQL Global Development Group. *Constraints*. https://www.postgresql.org/docs/current/ddl-constraints.html
- PostgreSQL Global Development Group. *Transaction Isolation*. https://www.postgresql.org/docs/current/transaction-iso.html
- PostgreSQL Global Development Group. *Partial Indexes*. https://www.postgresql.org/docs/current/indexes-partial.html
- Prisma. *PostgreSQL database connector*. https://www.prisma.io/docs/orm/overview/databases/postgresql
- Prisma. *Transactions*. https://www.prisma.io/docs/orm/prisma-client/queries/transactions
