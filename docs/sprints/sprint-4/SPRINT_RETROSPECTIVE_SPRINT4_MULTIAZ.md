# SPRINT RETROSPECTIVE — Sprint 4

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 4  
**Fase:** Fase 1 — Fundación (Deuda Técnica + CI/CD) + Fase 2 — Experiencia del Usuario (Autenticación completa) + Fase 3 — Administración (Model Registry)  
**Fecha:** 04 de mayo de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Verificación de Acciones de Mejora — Sprint 3

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Validar conectividad Docker antes de comprometer servicios externos | ✅ Cumplido — puerto SMTP validado desde contenedor antes de configurar MailHog; DT-002 resuelta sin iteraciones a ciegas |
| 2 | Aplicar checklist mental de entidades antes de escribir (`@Document`: snake_case en colección, camelCase en campos, `Optional` en repository) | ✅ Cumplido — `AiModel` implementado correctamente en primer intento; no se generaron errores de mapeo |
| 3 | Aplicar factor 1.5x en duración cuando >50% de los items tienen riesgo alto | ✅ Cumplido — 16 SP comprometidos para 7 días planificados con 2 items de riesgo alto; la extensión real fue esperada y documentada |

---

## 2. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | Las tres acciones de mejora del Sprint 3 se cumplieron en su totalidad. El factor 1.5x aplicado al comprometer SP fue correcto — el sprint entregó al 100% sin presión de tiempo artificial. Es la primera vez en cuatro sprints que las tres acciones se verifican como cumplidas. |
| 2 | DT-001, el item de mayor riesgo del sprint, se resolvió mediante diagnóstico metódico con logging TRACE — exactamente como se planificó. La causa raíz (race condition en startup) se identificó en la primera sesión de diagnóstico, sin iteraciones a ciegas. La estrategia de escalada temprana documentada en el Sprint Backlog funcionó. |
| 3 | TS-08.1 se completó aplicando el patrón ya establecido del Auth Service — la transferencia de conocimiento entre microservicios fue efectiva. La única tecnología nueva (MongoDB / `@Document`) se aprendió conceptualmente antes de escribir código, aplicando la acción de mejora del Sprint 2. |
| 4 | T-15.2.5 (backups) desbloqueada después de tres sprints diferida. Los conceptos de bash (arrays, `$?`, `PIPESTATUS`, subcomandos) se aprendieron desde cero y se aplicaron correctamente. El patrón utility container quedó documentado y replicable. |

---

## 3. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | La duración real del sprint fue 14 días versus los 7 planificados. Aunque la extensión estaba contemplada por el factor 1.5x, duplicar el tiempo de duración revela que la estimación de horas por tarea en el Sprint Backlog (49 h totales para 7 días) no refleja la capacidad real disponible. La planificación de capacidad necesita ajustarse. |
| 2 | Se cometieron errores de Git repetidos durante la ejecución: `git commit` antes de terminar el trabajo, intento de `git commit --amend` después de `git push`. Estos errores ya ocurrieron en sprints anteriores — no son errores de aprendizaje nuevo, son hábitos que no se han consolidado. |
| 3 | DT-003 se generó en T-08.1.6: Flapdoodle incompatible con Spring Boot 4.x dejó el test de integración del Model Registry deshabilitado. Aunque documentado correctamente, la incompatibilidad no fue detectada en el Sprint Planning — se llegó a la tarea sin saber que la librería estándar de MongoDB embebido no funciona en el framework. |
| 4 | Los errores en bash durante T-15.2.5 (comas en arrays, `$?` capturado sobre el comando equivocado, `PIPESTATUS` sin pipe) indican que se arrancó a escribir scripts antes de tener claridad sobre la sintaxis. Se corrigieron durante la ejecución pero generaron tiempo de depuración evitable. |

---

## 4. Acciones de Mejora — Sprint 5

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Antes de cada Sprint Planning, calcular la capacidad real disponible en horas para la semana — no asumir disponibilidad completa. Comprometer SP en función de esa capacidad calculada, no de la velocidad histórica bruta. | Miguel Angel Zhunio | El Sprint Backlog del Sprint 5 tiene la capacidad semanal calculada explícitamente antes de comprometer SP |
| 2 | Incorporar como hábito fijo antes de cada `git add`: ejecutar `git status`, leer el output completo, y solo entonces agregar archivos por nombre — nunca `git add .`. Si se comete un error de Git durante el sprint, registrarlo en el REPASO correspondiente. | Miguel Angel Zhunio | Cero errores de Git (`--amend` post-push, commit prematuro) durante el Sprint 5 |
| 3 | En el Sprint Planning, para cada tarea que involucre una librería de testing o herramienta nueva, verificar compatibilidad con Spring Boot 4.x antes de comprometer la tarea. Recurso de referencia: Spring Boot 4.x release notes y el repositorio de issues de la librería. | Miguel Angel Zhunio | DT-003 tiene un plan de resolución con alternativa verificada (Testcontainers) antes de arrancar Sprint 5 |

---

## 5. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 16 |
| Story Points completados | 16 |
| Tareas completadas | 16 / 16 |
| Tareas bloqueadas | 0 |
| Duración real | 14 días |
| Velocidad Sprint 4 | 16 SP |
| Velocidad promedio acumulada | 22.5 SP (4 sprints) |

---

## 6. Notas

- Sprint 4 cierra formalmente **EP-01 Autenticación** — la épica más crítica del sistema queda completamente operativa después de arrastrar deuda técnica desde Sprint 3.
- La reducción de velocidad (16 SP vs promedio histórico de 24.7 SP en sprints anteriores) fue una decisión de planificación consciente y correcta, no una señal de degradación de capacidad. El 100% de entrega lo confirma.
- Los errores de Git repetidos (observación #2) son el patrón más preocupante del sprint — no por su impacto técnico sino porque indican que el hábito no se ha internalizado después de cuatro sprints. La acción de mejora #2 apunta directamente a consolidarlo.
- Con EP-01 cerrada y Model Registry operativo, el sistema está listo para iniciar EP-02 (Predicciones) en Sprint 5 — el primer épica de negocio real del proyecto.

---

*MultIAZ — Sprint 4 Retrospective | Mayo 2026*
