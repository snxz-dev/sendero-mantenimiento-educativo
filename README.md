# Sendero — Gestión de incidencias y mantenimiento educativo

Caso práctico académico para diseñar y desarrollar un sistema integrado de gestión de incidencias y órdenes de mantenimiento de infraestructura educativa. El proyecto contempla clientes web, escritorio y móvil, un backend compartido y una base de datos relacional.

La institución y los datos del caso son ficticios. El proyecto es independiente de cualquier trabajo anterior.

**Repositorio público:** [github.com/snxz-dev/sendero-mantenimiento-educativo](https://github.com/snxz-dev/sendero-mantenimiento-educativo)  
**Versión documental vigente:** [`v0.1-fase-1`](https://github.com/snxz-dev/sendero-mantenimiento-educativo/tree/v0.1-fase-1)

## Estado real del proyecto

| Fase | Estado | Evidencia disponible |
|---|---|---|
| Fase 1 — Análisis y Diseño | **Cerrada y publicada** | Problema, alcance, factibilidad preliminar, actores, procesos, requerimientos, reglas, clasificación MVP, estados y cinco figuras. Tag `v0.1-fase-1`. |
| Fase 2 — Modelado y diseño de base de datos | **Cerrada** | Modelo conceptual, MER, modelo relacional en 3FN, diccionario, SQL preliminar, integridad y trazabilidad. Referencia revisada: commit `331fa34`; correcciones de cierre registradas posteriormente. No se ha elegido motor. |
| Fase 3 — Arquitectura, stack y base de datos | **Pendiente** | No se ha seleccionado el motor de base de datos ni generado el SQL definitivo específico del motor. |
| Fase 4 — Mockups y prototipo frontend | **Pendiente** | No iniciado. |
| Fase 5 — Implementación e integración | **Pendiente** | No existe código funcional de web, escritorio, móvil o backend. |
| Fase 6 — Pruebas, resultados y defensa | **Pendiente** | No existen pruebas de software ejecutadas ni resultados operativos. |

## Alcance del MVP

La primera versión obligatoria demostrará el flujo:

**Reporte → revisión/priorización → orden → asignación → intervención → evidencia → finalización técnica → verificación → cierre/reapertura → historial.**

Se documentan como ampliaciones posteriores la gestión formal de duplicados, órdenes preventivas, cancelaciones complejas, prevención automática de conflictos de agenda, correcciones históricas avanzadas y controles exhaustivos de concurrencia. Los estados y acciones de esas ampliaciones, incluidos `DUPLICADA` y `CANCELADA`, no deben mostrarse como funciones disponibles en las interfaces del MVP mientras no estén implementados.

El alcance del MVP queda congelado en las 21 tablas aprobadas en Fase 2. No se añadirán tablas en fases posteriores salvo que un requerimiento MVP no pueda satisfacerse con el modelo actual y la modificación se justifique explícitamente antes de realizarla.

## Distribución funcional prevista

- Web: reporte, aclaraciones, consulta, verificación e indicadores autorizados.
- Escritorio: revisión, priorización, creación y asignación de órdenes, revisión técnica, cierre y reapertura.
- Móvil: consulta de asignaciones, intervenciones, bloqueos, tiempos y evidencias de campo.

Esta distribución es una definición funcional. La arquitectura y las tecnologías permanecen pendientes de análisis y aprobación.

## Estructura del repositorio

```text
docs/                 Documentación académica, figuras y fuentes de diagramas
apps/web/             Reservado para el cliente web
apps/desktop/         Reservado para el cliente de escritorio
apps/mobile/          Reservado para el cliente móvil
backend/              Reservado para backend y lógica compartida
database/             Reservado para modelos y scripts de base de datos
README.md             Estado y guía principal del proyecto
```

Los directorios de aplicaciones, backend y base de datos contienen únicamente archivos de reserva. Su presencia no significa que exista una implementación.

## Documentación disponible

- [Fase 1 — Análisis y Diseño](docs/fase-1/Fase_1_Analisis_y_Diseno.md)
- [Informe navegable de Fase 1](docs/fase-1/Fase_1_Analisis_y_Diseno.html)
- [Figuras y fuentes estructuradas](docs/fase-1/figuras/)
- [Control de la entrega](docs/fase-1/Control_de_entrega.md)
- [Fase 2 — Modelado y Diseño de Base de Datos](docs/fase-2/Fase_2_Modelado_y_Base_de_Datos.md)
- [Informe navegable de Fase 2](docs/fase-2/Fase_2_Modelado_y_Base_de_Datos.html)
- [Diccionario de datos de Fase 2](docs/fase-2/diccionario_datos.csv)
- [SQL preliminar basado en SQL estándar, sujeto a adaptación al motor seleccionado en Fase 3](database/esquema_preliminar.sql)

## Entorno de trabajo confirmado

El usuario indicó expresamente que el desarrollo futuro se realizará en **Arch Linux dentro de WSL**. Esto define el entorno de desarrollo, pero todavía no define lenguajes, frameworks ni sistemas de destino.

## Instalación y ejecución

No aplica en esta versión documental. Aún no existen dependencias, servicios, migraciones, variables de entorno ni comandos de ejecución del aplicativo. Las instrucciones se documentarán únicamente después de comprobarlas en las fases correspondientes.

## Versiones y entregas

- `v0.1-fase-1`: línea base documental de la Fase 1.
- `v0.2-informe`: reservado para la versión consolidada futura del informe.
- `v1.0-entrega`: reservado para la entrega final verificada.

Los tags reservados no deben crearse antes de que sus entregables existan.

## Repositorio remoto

El repositorio central está publicado en:

[https://github.com/snxz-dev/sendero-mantenimiento-educativo](https://github.com/snxz-dev/sendero-mantenimiento-educativo)

La rama principal es `main`. La línea base de esta fase se identifica con `v0.1-fase-1`.

## Autoría y licencia

**Autor:** Stalyn Mateo Sánchez Cevallos  
**Institución:** Instituto Superior Universitario Japón  
**Carrera:** Tecnología Superior en Desarrollo de Software  
**Año:** 2026

La licencia permanece pendiente hasta que el autor la seleccione expresamente.
