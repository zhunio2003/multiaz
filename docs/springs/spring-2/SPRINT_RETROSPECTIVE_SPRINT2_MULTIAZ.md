# SPRINT RETROSPECTIVE — Sprint 2

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 2  
**Fase:** Fase 1 — Fundación (Frontend)  
**Fecha:** 05 de abril de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Verificación de Acciones de Mejora — Sprint 1

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Leer documentación de GitHub Actions antes de arrancar Sprint 2 | ✅ Cumplido |
| 2 | Ordenar historias por dependencia técnica explícita en el Sprint Planning | ✅ Cumplido — Sprint Backlog con orden de ejecución definido antes de arrancar |
| 3 | Revisar documentación de `pg_dump` y `mongodump` antes de T-15.2.5 | ➖ No aplica — T-15.2.5 sigue diferida |

---

## 2. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | El orden de ejecución definido en el Sprint Planning funcionó sin bloqueos entre historias. La secuencia TS-17.1 → TS-17.2 → TS-17.4 → TS-17.3 → TS-17.5 respetó las dependencias técnicas y permitió avanzar linealmente sin interrupciones. Lección del Sprint 1 aplicada correctamente. |
| 2 | El sprint se completó dentro del plazo establecido — 7 días, entrega el último día. Sin adelanto pero sin retraso. La estimación de 26 SP fue conservadora y acertada para un sprint con territorio técnico completamente nuevo. |

---

## 3. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | El sprint cubrió tecnologías completamente desconocidas desde el rol de backend (diseño de sistemas, tokens, paleta de colores, espaciado, tipografía). El tiempo de aprendizaje no estaba planificado explícitamente, lo que generó fricción en las primeras historias del sprint. |
| 2 | Los design patterns en Dart/Flutter (Singleton, Factory constructor, patrón de callback) generaron confusión significativa. La analogía inicial con patrones de Spring Boot (`@Controller`, beans) no aplica — son paradigmas distintos. Se llegó a las tareas con conocimiento cero sobre estos conceptos en el contexto de Dart. |
| 3 | El aprendizaje en varias historias quedó a nivel táctico: el código funciona y fue escrito por el desarrollador, pero la comprensión conceptual de algunos mecanismos es parcial. Esto aplica especialmente a Dart, React y el funcionamiento interno de los interceptores. |

---

## 4. Acciones de Mejora — Sprint 3

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Antes de arrancar cada historia técnica en Sprint 3, dedicar tiempo explícito a entender el concepto central de la tarea — qué problema resuelve, por qué se usa ese approach, cómo encaja en la arquitectura — antes de escribir una sola línea de código. El código viene después de la comprensión, no al revés. | Miguel Angel Zhunio | Al finalizar cada historia, se puede explicar el concepto implementado sin consultar el código |
| 2 | Para las tecnologías con comprensión parcial del Sprint 2 (Dart, React, interceptores HTTP), revisar los REPASOs correspondientes al inicio del Sprint 3 antes de continuar construyendo sobre esa base. Los REPASOs documentan exactamente lo que se aprendió — usarlos como punto de partida. | Miguel Angel Zhunio | Al inicio de Sprint 3 se puede responder preguntas conceptuales básicas sobre Dart y React sin fricción |
| 3 | En el Sprint Planning del Sprint 3, identificar explícitamente qué tecnologías o conceptos son territorio desconocido para las historias comprometidas, y registrarlo en el Sprint Backlog como riesgo. No descubrirlo durante la ejecución. | Miguel Angel Zhunio | El Sprint Backlog del Sprint 3 tiene una columna o nota de riesgos técnicos por historia |

---

## 5. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 26 |
| Story Points completados | 26 |
| Tareas completadas | 27 / 27 |
| Tareas bloqueadas | 0 |
| Duración real | 7 días |
| Velocidad Sprint 2 | 26 SP |
| Velocidad promedio acumulada | 26.5 SP (2 sprints) |

---

## 6. Notas

- Este sprint cierra formalmente la **Fase 1 — Fundación** del proyecto MultIAZ (53 SP en 2 sprints).
- La observación #3 de "¿Qué salió mal?" no es un error de ejecución — es una limitación natural de aprender tecnologías nuevas mientras se entrega. Se registra como área de mejora continua, no como falla del sprint.
- Las acciones de mejora definidas aquí serán verificadas al inicio del Sprint Planning del Sprint 3.
