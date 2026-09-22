# Sendero — Gestión de incidencias y mantenimiento educativo

Caso práctico académico para diseñar y desarrollar un sistema integrado de gestión de incidencias y órdenes de mantenimiento de infraestructura educativa. El proyecto contempla clientes web, escritorio y móvil, un backend compartido y una base de datos relacional.

La institución y los datos del caso son ficticios. El proyecto es independiente de cualquier trabajo anterior.

## Estado real del proyecto

| Fase | Estado | Evidencia disponible |
|---|---|---|
| Fase 1 — Análisis y Diseño | **Cerrada para revisión definitiva** | Problema, alcance, factibilidad preliminar, actores, procesos, requerimientos, reglas, clasificación MVP, estados y cinco figuras. |
| Fase 2 — Modelado UML y de datos | **Pendiente** | No iniciado. |
| Fase 3 — Arquitectura, stack y base de datos | **Pendiente** | No se han seleccionado tecnologías ni generado el SQL. |
| Fase 4 — Mockups y prototipo frontend | **Pendiente** | No iniciado. |
| Fase 5 — Implementación e integración | **Pendiente** | No existe código funcional de web, escritorio, móvil o backend. |
| Fase 6 — Pruebas, resultados y defensa | **Pendiente** | No existen pruebas de software ejecutadas ni resultados operativos. |

## Alcance del MVP

La primera versión obligatoria demostrará el flujo:

**Reporte → revisión/priorización → orden → asignación → intervención → evidencia → finalización técnica → verificación → cierre/reapertura → historial.**

Se documentan como ampliaciones posteriores la gestión formal de duplicados, órdenes preventivas, cancelaciones complejas, prevención automática de conflictos de agenda, correcciones históricas avanzadas y controles exhaustivos de concurrencia.

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

Todavía no se ha configurado un repositorio remoto ni existe un enlace permanente. Cuando se defina el alojamiento, el enlace se añadirá al README y al informe académico sin alterar la identificación de esta entrega.

## Autoría y licencia

Los datos académicos de autoría están pendientes. No se declara una licencia hasta que el autor la seleccione expresamente.

