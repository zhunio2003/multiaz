# SPRINT RETROSPECTIVE — Sprint 3

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 3  
**Fase:** Fase 1 — Fundación (Gateway) + Fase 2 — Experiencia del Usuario (Autenticación)  
**Fecha:** 20 de abril de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Verificación de Acciones de Mejora — Sprint 2

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Antes de arrancar cada historia técnica, entender el concepto central antes de escribir código | ✅ Cumplido — se aplicó consistentemente en TS-18.1, HU-01.1, HU-01.2 y HU-01.3. Hubo retrocesos puntuales en HU-01.4 (typos en entidades, lógica de expiración) pero el patrón concepto-antes-código se mantuvo como hábito. |
| 2 | Revisar REPASOs del Sprint 2 al inicio del Sprint 3 para reforzar comprensión de Dart y React | ✅ Cumplido — el conocimiento de Flutter acumulado en Sprint 2 se usó como base directa para HU-01.1 a HU-01.4 sin fricción de punto de partida. |
| 3 | Identificar en el Sprint Planning qué tecnologías son territorio desconocido y registrarlo como riesgo | ✅ Cumplido — el Sprint Backlog del Sprint 3 incluye columna de riesgo técnico por historia. JavaMailSender y SMTP fueron identificados como riesgo alto antes de ejecutar HU-01.4. |

---

## 2. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | El patrón concepto-antes-código se consolidó como hábito. En todas las historias del sprint se discutió primero el mecanismo (JWT, rotación de tokens, hashing, Spring Security filter chain) antes de escribir una línea. El tiempo de corrección por malentendidos conceptuales fue notablemente menor que en sprints anteriores. |
| 2 | La decisión de documentar y avanzar ante DT-001 fue correcta. Al bloquearse `POST /auth/login` con HTTP 403, la alternativa era dedicar tiempo indefinido a debuggear un comportamiento de framework sin garantía de resolución en el sprint. Registrar la deuda y continuar con HU-01.3 permitió completar refresh token y avanzar a HU-01.4 sin perder momentum. |
| 3 | Git discipline se mantuvo sólida durante todo el sprint. Commits atómicos con Conventional Commits, `git status` antes de cada add, sin `git add .` y con scopes descriptivos. Los commits del sprint son legibles como historial técnico autónomo. |
| 4 | El stack de seguridad del Auth Service quedó bien fundamentado. SHA-256 para tokens de recovery, retorno silencioso para prevenir enumeración, invalidación de sesiones Redis en reset de contraseña, rotación de refresh tokens — cada decisión tiene justificación de seguridad explícita y fue comprendida antes de implementarse. |

---

## 3. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | La duración real del sprint (13 días) duplicó la duración planificada (7 días). El sprint se extendió significativamente por la acumulación de territorio técnico nuevo (Spring Security, JWT, Redis, JavaMailSender, Flutter secure storage) distribuido en 5 historias con riesgo alto. La estimación en SP fue correcta; la estimación de duración en días no contempló suficientemente el tiempo de aprendizaje real por historia. |
| 2 | DT-002 (puerto SMTP bloqueado) no era detectable en el Sprint Planning sin haber intentado levantar el contenedor con la configuración de red real. Sin embargo, la infraestructura de red Docker debería haber sido validada antes de comprometer JavaMailSender como tecnología de sprint. La validación de entorno para dependencias externas (SMTP, puertos de salida) no estuvo en el checklist de arranque de historia. |
| 3 | Errores repetitivos en entidades JPA: typos en nombres de tabla, snake_case en campos Java, Optional ausente en repository methods, `@Autowired` en lugar de `@RequiredArgsConstructor`. Varios de estos patrones ya habían sido corregidos en HU-01.1 y HU-01.2 — se repitieron en HU-01.4. El conocimiento se aplicó en el momento de corrección pero no se internalizó como checklist previo a la escritura. |
| 4 | `plusMinutes` vs `minusMinutes` para expiración de tokens fue un error conceptual, no de sintaxis. Calcular la expiración en el pasado es una confusión del modelo mental de "token con TTL" — se resolvió pero requirió iteración en lugar de ser obvio desde el diseño. |

---

## 4. Acciones de Mejora — Sprint 4

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Para historias que dependan de servicios externos (SMTP, APIs de terceros, puertos de red), validar la conectividad desde el contenedor Docker **antes** de comprometer la historia en el sprint. Un `telnet` o `curl` desde dentro del contenedor es suficiente. No descubrir el bloqueo durante la implementación. | Miguel Angel Zhunio | DT-002 se resuelve en Sprint 4 sin generar nueva DT de infraestructura de red. |
| 2 | Antes de escribir cualquier entidad JPA nueva, repasar mentalmente el checklist: (1) nombre de tabla en snake_case correcto, (2) campos en camelCase, (3) Optional en repository methods que pueden no encontrar resultado, (4) inyección por constructor con `@RequiredArgsConstructor`. Aplicarlo como ritual de inicio de tarea, no como corrección posterior. | Miguel Angel Zhunio | En Sprint 4 las entidades JPA no presentan los errores recurrentes de Sprint 3. |
| 3 | Al estimar duración de sprint en días, aplicar un factor de 1.5x sobre la estimación inicial cuando más del 50% de las historias tienen tecnología nueva. Sprint 3 tenía 4 de 5 historias con riesgo alto — la duración debió estimarse en 10–11 días, no 7. La estimación en SP puede ser correcta mientras la duración en días es optimista. | Miguel Angel Zhunio | El Sprint 4 tiene una duración estimada en días que considera el factor de aprendizaje explícitamente en el Sprint Planning. |

---

## 5. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 26 |
| Story Points completados | 21 |
| Tareas completadas | 17 / 19 |
| Tareas bloqueadas | 2 |
| Duración real | 13 días |
| Velocidad Sprint 3 | 21 SP |
| Velocidad promedio acumulada | 24.7 SP (3 sprints) |

---

## 6. Notas

- La caída de velocidad a 21 SP es explicada en su totalidad por DT-001 y DT-002 — bloqueos de infraestructura no atribuibles a capacidad de implementación. Los 5 SP afectados tienen código completo y correcto.
- La extensión del sprint a 13 días refleja la carga de aprendizaje real de Spring Security + JWT + Redis + JavaMailSender + Flutter secure storage en un solo sprint. No es una anomalía — es información para calibrar mejor la planificación en Sprint 4.
- Las acciones de mejora definidas aquí serán verificadas al inicio del Sprint Planning del Sprint 4.

---

*MultIAZ — Sprint 3 Retrospective | Abril 2026*
