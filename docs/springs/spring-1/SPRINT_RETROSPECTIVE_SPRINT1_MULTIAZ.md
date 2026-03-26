# SPRINT RETROSPECTIVE — Sprint 1

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 1  
**Fase:** Fase 1 — Fundación (Infraestructura)  
**Fecha:** 26 de marzo de 2026  
**Autor:** Miguel Angel Zhunio Remache  

---

## 1. ¿Qué salió bien?

| # | Observación |
|---|-------------|
| 1 | El orden de ejecución de las tareas en el Sprint Backlog funcionó correctamente. La secuencia lógica de infraestructura (config → discovery → storage → CI/CD) permitió avanzar sin bloqueos mayores entre historias. |
| 2 | El stack completo levanta con un solo comando (`docker-compose up`). Resultado directo de haber planificado correctamente las redes, volúmenes y dependencias entre servicios durante el Sprint Planning. |

---

## 2. ¿Qué salió mal?

| # | Observación |
|---|-------------|
| 1 | GitHub Actions era territorio completamente desconocido al inicio del sprint — concepto de workflows, runners, sintaxis YAML y triggers. Se llegó a la tarea con conocimiento cero, lo que generó estancamiento y tiempo no planificado de investigación durante la ejecución. |
| 2 | El orden de dependencias entre algunas tareas no fue evidente desde el inicio, generando interrupciones — comenzar una tarea, descubrir un bloqueante, saltar a otra, y volver. Esto se resolvió pero generó fricción innecesaria. |

---

## 3. Acciones de Mejora — Sprint 2

| # | Acción | Responsable | Verificación |
|---|--------|-------------|--------------|
| 1 | Leer la documentación oficial de GitHub Actions antes de arrancar el Sprint 2: conceptos de workflows, triggers, jobs y steps. Recurso: `https://docs.github.com/en/actions` | Miguel Angel Zhunio | Al inicio del Sprint 2 se puede explicar el flujo completo sin consultar documentación básica |
| 2 | Durante el Sprint Planning del Sprint 2, ordenar las historias por dependencia técnica explícita antes de comprometerse — igual que se hizo con la infraestructura en Sprint 1 | Miguel Angel Zhunio | El Sprint Backlog del Sprint 2 tiene el orden de ejecución definido antes de arrancar |
| 3 | Para T-15.2.5 (backups automáticos), revisar la documentación de `pg_dump` y `mongodump` **antes** de ejecutar la tarea, no durante | Miguel Angel Zhunio | La tarea se ejecuta sin estancamiento por desconocimiento de herramientas |

---

## 4. Métricas del Sprint

| Métrica | Valor |
|---------|-------|
| Story Points comprometidos | 27 |
| Story Points completados | 27 |
| Tareas completadas | 27 / 29 |
| Tareas bloqueadas | 2 |
| Duración real | 5 días |
| Velocidad base establecida | 27 SP |

---

