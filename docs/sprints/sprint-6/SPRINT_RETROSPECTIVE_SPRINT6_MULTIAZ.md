# SPRINT RETROSPECTIVE — Sprint 6

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 6  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-007)  
**Fecha:** 06 de octubre de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Verificación de Acciones de Mejora — Sprint 5

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Comunicar explícitamente cuando se completen todas las tareas comprometidas antes de iniciar trabajo adicional. Registrar trabajo adicional en el Sprint Backlog con descripción, estimación y justificación. | ✅ Cumplido — no se ejecutó trabajo no planificado sin registrar durante el Sprint 6. El alcance del sprint se mantuvo dentro de los ítems comprometidos en el Planning. |
| 2 | DT-007 entra obligatoriamente al Sprint 6 como primer ítem del backlog — no como candidato opcional. | ✅ Cumplido — DT-007 fue el primer ítem ejecutado del sprint y está marcada como Done. Lleva cerrada desde la primera semana de trabajo del Sprint 6. |
| 3 | El Sprint 6 debe incluir al menos una historia de usuario ejecutable end-to-end en dispositivo físico, con screenshots al cierre. | ⚠️ Parcialmente cumplido — el flujo está implementado y funciona correctamente en todos sus componentes. La verificación en dispositivo físico fue bloqueada por PayJoy (modo desarrollador deshabilitado en dispositivo financiado). El criterio técnico se cumplió; el criterio observable en dispositivo quedó pendiente por causa externa. |

---

## 2. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | El primer AI Service real del proyecto fue implementado completamente en una tecnología nueva para el equipo — FastAPI/Python — sin incidentes de bloqueo técnico. El modelo TF-IDF + Logistic Regression alcanzó 98.82% de accuracy, muy por encima del criterio de aceptación de 85%. La estrategia de aprender el concepto antes de implementar (TF-IDF, pipelines sklearn, Pydantic schemas) siguió siendo efectiva. |
| 2 | DT-007 fue cerrada al inicio del sprint como se comprometió en la retrospectiva del Sprint 5. Llevar dos sprints una deuda técnica diferida y resolverla en cuanto entró al backlog confirmó que el mecanismo de deuda técnica explícita funciona — la clave es que entre al backlog con fecha, no que quede como pendiente informal. |
| 3 | El diagnóstico de problemas fue sistemático durante todo el sprint — desde el warning de `InconsistentVersionWarning` de scikit-learn hasta el problema de permisos del SDK Android. En ningún caso se avanzó sobre un error sin entender su causa raíz primero. Este hábito de diagnóstico antes de solución es lo que diferencia trabajo técnico sólido de trabajo que "funciona por suerte". |
| 4 | La arquitectura del servicio Python siguió los mismos principios de separación de responsabilidades que los servicios Java del proyecto: `main.py` maneja HTTP, `inference_service.py` maneja la lógica ML, `train.py` es independiente del servicio. El código es coherente con el resto del sistema aunque sean tecnologías distintas. |
| 5 | El flujo de predicción end-to-end está implementado completo por primera vez: un usuario puede autenticarse, ver el catálogo de modelos de IA, seleccionar fake-news, ingresar una noticia, y recibir FAKE/REAL con un score de confianza. Aunque la verificación visual en dispositivo quedó bloqueada, el sistema está técnicamente operativo. |

---

## 3. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | La acción de mejora 3 del Sprint 5 no pudo cumplirse completamente por una causa externa: el dispositivo físico disponible está bloqueado por PayJoy. Sin embargo, esto revela un problema de planificación: la dependencia de un único dispositivo físico para la verificación final es un riesgo que debió identificarse en el Planning. Si ese dispositivo falla o queda bloqueado, todo el criterio de verificación cae. |
| 2 | La configuración del entorno Android (SDK, NDK, emulador, permisos) consumió tiempo significativo no planificado y bloqueó la verificación de HU-02.2. El emulador presentó inestabilidad — crashes por espacio en disco, desconexiones ADB, tiempos de arranque excesivos. Este es un entorno que debió configurarse y verificarse antes del sprint, no durante él. |
| 3 | El sprint tuvo una duración real de varios meses versus los 7 días planificados. Esto no es exclusivamente un problema de este sprint — refleja un patrón acumulado en el proyecto donde los sprints teóricos de 1 semana tienen una duración real mucho mayor por disponibilidad reducida. El sistema de "sprint de 1 semana" no refleja la realidad operativa del proyecto. |
| 4 | El healthcheck del contenedor `fake-news-detector` falló inicialmente porque `python:3.11-slim` no incluye `wget` — herramienta asumida disponible por analogía con los servicios Java. Este tipo de asunciones sobre el entorno generan tiempo de diagnóstico no planificado. La lección es que cada imagen base tiene un conjunto distinto de herramientas instaladas y no se puede asumir equivalencia. |

---

## 4. Acciones de Mejora — Sprint 7

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Identificar y documentar las dependencias de hardware en el Planning antes de comprometer cualquier historia que requiera verificación en dispositivo. Si el único dispositivo disponible tiene restricciones (PayJoy, sin modo desarrollador), el Plan debe incluir una alternativa verificada — emulador estable, dispositivo secundario, o dispositivo de otra persona. | Miguel Angel Zhunio | El Sprint Backlog del Sprint 7 tiene documentada la alternativa de verificación para T-DT009 antes del inicio del sprint. |
| 2 | Configurar y verificar el entorno de emulación Android antes del primer día del sprint — no durante el sprint. El emulador debe arrancar, conectarse via ADB y ejecutar una app de prueba antes de comprometer cualquier tarea que lo requiera. | Miguel Angel Zhunio | Al inicio del Sprint 7, `adb devices` muestra el emulador conectado y estable antes de iniciar cualquier tarea de verificación móvil. |
| 3 | Evaluar formalmente si el esquema de "sprint de 1 semana teórica" sigue siendo útil dado que la duración real acumulada es mucho mayor. Opciones: (a) mantener sprints de 1 semana con la comprensión de que la duración real varía, (b) planificar sprints en horas disponibles reales sin asumir semanas calendario, (c) adoptar mini-milestones dentro de sprints más largos. Esta decisión se toma en el Planning del Sprint 7 — no se puede diferir indefinidamente. | Miguel Angel Zhunio | Sprint Planning del Sprint 7 documenta explícitamente el modelo de capacidad adoptado para el resto del proyecto. |

---

## 5. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 12 |
| Story Points completados | ~9 |
| Tareas completadas | 8 / 9 |
| Tareas bloqueadas | 1 (T-HU022.2 — hardware) |
| Duración real | ~19 semanas |
| Velocidad Sprint 6 | ~9 SP |
| Velocidad promedio acumulada | ~19.3 SP (6 sprints) |

---

## 6. Notas

- El Sprint 6 entregó el componente técnicamente más complejo del proyecto hasta la fecha: un servicio de Machine Learning real con entrenamiento, serialización, inferencia y containerización. El hecho de que la verificación visual no se completara por una restricción de hardware no reduce el valor técnico del incremento.
- La deuda técnica generada en este sprint (DT-008 Eureka para Python, DT-009 verificación dispositivo) es manejable y tiene solución clara. DT-009 es prioritaria porque bloquea el cierre formal de una historia de usuario comprometida.
- El patrón de sprints extendidos requiere una decisión formal en el Sprint 7 — no es sostenible continuar planificando en semanas cuando la ejecución real es en meses. La honestidad sobre la capacidad real es más útil que mantener la apariencia de sprints de 1 semana.
- Con el Fake News AI Service operativo, el sistema tiene su primer flujo de predicción real end-to-end funcional. El foco del Sprint 7 es cierre de pendientes (DT-009, DT-008) y avanzar en HU-02.3 (Historial de Predicciones).

---

*MultIAZ — Sprint 6 Retrospective | Octubre 2026*
