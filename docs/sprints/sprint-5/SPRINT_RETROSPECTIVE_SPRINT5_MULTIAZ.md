# SPRINT RETROSPECTIVE — Sprint 5

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 5  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-007)  
**Fecha:** 26 de mayo de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Verificación de Acciones de Mejora — Sprint 4

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Calcular capacidad real en horas antes de comprometer SP — no asumir disponibilidad completa | ✅ Cumplido — 35 h calculadas explícitamente (5 h/día × 7 días) antes del Planning. Los 18 SP comprometidos estaban alineados con esa capacidad. La extensión real del sprint se debió a factores externos (enfermedad, disponibilidad reducida), no a una estimación incorrecta. |
| 2 | `git status` antes de cada `git add`, archivos por nombre, nunca `git add .` | ⚠️ Sin evidencia documentada de errores — no se registraron incidentes de Git en el REPASO del sprint. Se asume cumplido, pero la ausencia de registro no es confirmación definitiva. |
| 3 | Verificar compatibilidad con Spring Boot 4.x para librerías nuevas antes de comprometer | ✅ Cumplido — Testcontainers verificado como compatible antes del Planning. `WebClient` (spring-boot-starter-webflux) utilizado sin problemas de compatibilidad. |

---

## 2. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | El orden de ejecución técnica se mantuvo sin excepciones durante todo el sprint. Ninguna tarea nueva fue abordada sin que sus prerequisitos estuvieran completos — el Prediction Orchestrator se construyó en el orden correcto: esquema → dominio → DTOs → cliente → servicio → controlador → Docker. Este hábito es consistente en todos los sprints y es la razón por la que no se generan bloqueos técnicos por dependencias incumplidas. |
| 2 | TS-02.1 (Prediction Orchestrator) se completó aplicando patrones ya establecidos en el proyecto — el patrón de microservicio del Auth Service y del Model Registry fue transferido correctamente. `WebClient` como tecnología nueva se integró sin incidentes. La estrategia de aprender el concepto antes de implementar sigue funcionando. |
| 3 | La mejora de UI realizada por iniciativa propia produjo un incremento de calidad real y observable: pantallas de Login y Register con design system aplicado consistentemente, logo MultIAZ presente, navegación entre pantallas funcional. Ver el sistema corriendo en un dispositivo físico con una interfaz de calidad fue el estímulo de motivación que el proyecto necesitaba en este punto del desarrollo. |
| 4 | El flujo end-to-end autenticación → catálogo → predicción quedó habilitado al cierre del sprint — es el primer flujo de negocio completo del sistema. Este es el hito más significativo desde el inicio del proyecto: el sistema ya hace algo real. |

---

## 3. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | La duración real del sprint fue aproximadamente 21 días versus los 7 planificados. A diferencia del Sprint 4 donde la extensión estaba prevista por el factor 1.5x, en este caso la extensión fue consecuencia de factores externos no anticipados: enfermedad y disponibilidad reducida por períodos. La planificación de capacidad fue correcta técnicamente — el problema fue la ausencia de un mecanismo para ajustar el sprint ante interrupciones prolongadas. |
| 2 | DT-007 (Testcontainers para Model Registry) fue postergada conscientemente una vez completadas las tareas comprometidas. La decisión de priorizar la mejora visual sobre la deuda técnica fue tomada unilateralmente sin comunicación previa. En un equipo real esto constituye una decisión de priorización que corresponde al equipo, no al desarrollador individual. La deuda técnica diferida acumula riesgo: DT-007 lleva dos sprints pendiente. |
| 3 | La mejora de UI, aunque produjo valor real, fue trabajo no planificado ejecutado sin incorporarlo formalmente al Sprint Backlog ni comunicarlo antes de iniciarlo. En un equipo Scrum, la transparencia sobre el trabajo en curso es obligatoria — no porque esté prohibido hacer mejoras, sino porque el equipo necesita saber qué se está construyendo en cada momento. El scope creep iniciado por el propio desarrollador, aunque bien intencionado, opaca la visibilidad del sprint. |
| 4 | La ausencia de valor observable durante sprints de backend puro generó desmotivación que impactó la duración del sprint. Esto no es un fallo de proceso en sí mismo, pero revela que el plan de sprints no había equilibrado suficientemente las entregas de backend con incrementos visibles para el usuario — algo que puede planificarse conscientemente en los sprints siguientes. |

---

## 4. Acciones de Mejora — Sprint 6

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Cuando se completen todas las tareas comprometidas del sprint con tiempo restante disponible, comunicarlo explícitamente antes de iniciar cualquier trabajo adicional — aunque sea trabajo en solitario. Registrar en el Sprint Backlog el trabajo adicional como tarea con descripción, estimación y justificación antes de ejecutarlo. | Miguel Angel Zhunio | El Sprint Backlog del Sprint 6 no tiene trabajo no planificado sin registrar. Si se agrega trabajo durante el sprint, aparece como tarea nueva con fecha de incorporación documentada. |
| 2 | DT-007 entra obligatoriamente al Sprint 6 como primer ítem del backlog — no como candidato opcional. Lleva dos sprints diferida y cada sprint adicional aumenta el riesgo de que los tests del Model Registry queden permanentemente deshabilitados. | Miguel Angel Zhunio | DT-007 aparece en el Sprint Backlog del Sprint 6 en posición 1 del orden de ejecución y está marcada como Done al cierre del sprint. |
| 3 | El Sprint 6 debe incluir al menos una historia de usuario que el usuario final pueda ejecutar de forma completa en el dispositivo físico: login real → catálogo real → predicción real con respuesta visible en pantalla. Si el sprint no puede comprometer ese flujo completo, se reduce el alcance hasta que sí pueda garantizarse. El criterio de éxito es observable, no técnico. | Miguel Angel Zhunio | Al cierre del Sprint 6, se graba o documenta con screenshots el flujo completo ejecutado en el dispositivo físico con backend levantado. |

---

## 5. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 18 |
| Story Points completados | 17 |
| Tareas completadas | 10 / 11 |
| Tareas bloqueadas | 0 |
| Duración real | ~21 días |
| Velocidad Sprint 5 | 17 SP |
| Velocidad promedio acumulada | 21.4 SP (5 sprints) |

---

## 6. Notas

- La motivación técnica es un factor real de productividad en proyectos individuales. El Sprint 5 mostró que trabajar durante sprints consecutivos sin ver resultados observables en el dispositivo genera desgaste. Los sprints siguientes deben planificarse garantizando que cada uno termina con algo que el usuario puede tocar — no solo con servicios que responden en Postman.
- DT-007 es el único ítem de deuda técnica abierta en el proyecto. Mantenerla abierta un sprint más es aceptable; tres sprints sería una señal de que nunca se va a resolver.
- Con el Prediction Orchestrator operativo, el sistema tiene todos los servicios backend necesarios para el flujo de predicción end-to-end. El foco de los próximos sprints se desplaza hacia la experiencia del usuario en la app móvil.

---

*MultIAZ — Sprint 5 Retrospective | Mayo 2026*
