# SPRINT REVIEW — Sprint 1

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 1  
**Fase:** Fase 1 — Fundación (Infraestructura)  
**Fecha de Review:** 26 de marzo de 2026  
**Autor:** Miguel Angel Zhunio Remache  

---

## 1. Sprint Goal

> Establecer la infraestructura base completa del sistema MultIAZ: comunicación, configuración, almacenamiento y operaciones.

**Resultado:** ✅ Sprint Goal cumplido.

---

## 2. Resumen de Resultados

| Concepto | Valor |
|----------|-------|
| Technical Stories comprometidas | 8 |
| Technical Stories completadas | 8 |
| Story Points comprometidos | 27 |
| Story Points completados | 27 |
| Tareas completadas | 27 / 29 |
| Tareas bloqueadas | 2 |
| Duración real del sprint | 5 días (2 días de anticipación) |
| **Velocidad establecida (línea base)** | **27 SP** |

> Esta es la primera velocidad registrada del equipo. Servirá como línea base para la planificación del Sprint 2.

---

## 3. Incremento Entregado

### EP-14 — Comunicación y Configuración

---

#### TS-14.1 — Configuración del Message Broker (RabbitMQ)
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- Contenedor `rabbitmq` levantado con imagen `rabbitmq:4-management`, puertos `5672` y `15672`, volumen persistente y red `net-message`.
- Panel de administración web accesible en `http://localhost:15672`.
- 4 colas creadas y en estado `running`: `batch-jobs`, `batch-prediction-completed`, `monitoring-alerts`, `training-completed`.
- Prueba de publicación y consumo exitosa: mensaje `Hello World!` publicado en cola `batch-jobs` y consumido correctamente.

**Decisiones técnicas relevantes:**
- Credenciales gestionadas mediante variables de entorno desde archivo `.env`, nunca hardcodeadas en `docker-compose.yml`.

---

#### TS-14.2 — Configuración del Service Discovery (Eureka)
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- Servicio `service-discovery` construido con imagen propia (Dockerfile multi-stage con Maven + Eclipse Temurin 21) debido a que las imágenes públicas de Eureka en Docker Hub están desactualizadas (+5 años sin mantenimiento).
- Dashboard web accesible en `http://localhost:8761`.
- Microservicio temporal `test-service` registrado automáticamente al iniciar — visible en el dashboard como `TEST-SERVICE UP (1)`.
- Re-registro automático verificado: al reiniciar el contenedor, la instancia desaparece y vuelve a registrarse correctamente.

**Configuración clave del servidor Eureka:**
```yaml
eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
```
> El servidor Eureka no debe registrarse a sí mismo. Esta configuración es obligatoria.

---

#### TS-14.3 — Configuración del Servicio de Configuración Centralizada (Spring Cloud Config)
**Estado:** ✅ Done  
**Story Points:** 3

**Evidencia presentada:**
- Servicio `config-service` construido con imagen propia (Dockerfile multi-stage). Puerto `8888` expuesto.
- Repositorio de configuraciones estructurado por ambiente dentro del monorepo:
  ```
  config/
  ├── dev/
  │   ├── application.yml
  │   ├── auth-service.yml
  │   ├── test-service.yml
  │   └── [resto de servicios]
  ├── staging/
  │   └── [mismos archivos]
  └── prod/
      └── [mismos archivos]
  ```
- Endpoint `http://localhost:8888/test-service/dev` expone correctamente la configuración del servicio.
- `test-service` consume la propiedad `app.message: "Hello World Miguel!"` desde el Config Service y la devuelve en `http://localhost:9090/config-test`.

**Incidencia registrada durante el sprint:**
- **Problema:** Al arrancar el stack, `test-service` devolvía `NO RESPONSE` (valor por defecto).
- **Causa raíz:** El prefijo `optional:` en `spring.config.import` permite que Spring arranque sin la configuración si el Config Service no está listo al momento del arranque. `depends_on` garantiza el orden de inicio del contenedor, no la disponibilidad del servicio.
- **Solución aplicada:** Reiniciar el `test-service` una vez el `config-service` está completamente operativo.
- **Solución definitiva (Sprint 2+):** Implementar readiness probes en Kubernetes para garantizar que un servicio no arranque hasta que sus dependencias estén listas para aceptar tráfico.

**Deuda técnica identificada:**
- El ambiente `staging/` no tiene archivo `test-service.yml`. Todos los ambientes deben tener paridad de archivos de configuración.

---

### EP-15 — Almacenamiento

---

#### TS-15.1 — Configuración del Cache Service (Redis)
**Estado:** ✅ Done  
**Story Points:** 1

**Evidencia presentada:**
- Contenedor `redis` levantado con imagen `redis:8`, puerto `6379`, volumen persistente y red `net-database`.
- Health check verificado: `docker exec -it redis redis-cli -a <pass> ping` → `PONG`.
- Pruebas de almacenamiento:
  - `SET usuario:1 "Miguel Angel"` → `OK` / `GET usuario:1` → `"Miguel Angel"`
  - `SET sesion:abc123 "token-activo" EX 5` → TTL expirado correctamente → `GET` devuelve `(nil)`, `TTL` devuelve `-2`.

---

#### TS-15.2 — Configuración de la Base de Datos Principal (PostgreSQL + MongoDB)
**Estado:** ✅ Done (con 1 tarea bloqueada)  
**Story Points:** 5

**Evidencia presentada:**
- Contenedores `postgresql` (imagen `postgres:17`) y `mongodb` (imagen `mongo:8`) levantados en red `net-database`.
- Conectividad verificada con `psql` y `mongosh`.
- **PostgreSQL — 6 bases de datos lógicas creadas:**
  - `auth`, `dataset-management`, `model-registry`, `notification`, `prediction-storage`, `scheduler`
- **MongoDB — 3 bases de datos lógicas creadas:**
  - `logging-monitoring`, `prediction-storage-details`, `training`

**Tarea bloqueada:**
| Tarea | Motivo | Plan |
|-------|--------|------|
| T-15.2.5 — Backups automáticos | Requiere scripts de backup con destino MinIO. Se bloqueó por dependencia de orden de ejecución dentro del sprint. | Sprint 2 — sesión dedicada |

**Decisiones técnicas aplicadas:**
- Bases de datos creadas manualmente aplicando el principio **YAGNI** (ADR-001). Los esquemas (tablas y colecciones reales) serán creados por cada microservicio en Fase 2 mediante **Flyway** (PostgreSQL) y las propias aplicaciones (MongoDB).
- En MongoDB se usó `db.createCollection("init")` como placeholder para forzar la persistencia de la base de datos vacía.

---

#### TS-15.3 — Configuración del Object Storage (MinIO)
**Estado:** ✅ Done  
**Story Points:** 3

**Evidencia presentada:**
- Contenedor `minio` levantado con imagen `minio/minio:latest` (Verified Publisher), puertos `9000` (API) y `9001` (consola web), volumen persistente y red `net-database`.
- Consola web accesible en `http://localhost:9001`.
- 4 buckets creados: `backups`, `datasets`, `historical-logs`, `trained-models`.
- Subida verificada: archivo de 2.4 MiB en bucket `datasets`.
- Descarga verificada desde la consola web.

---

### EP-16 — Operaciones

---

#### TS-16.1 — Configuración del Container Orchestrator (Docker Compose)
**Estado:** ✅ Done  
**Story Points:** 2

**Evidencia presentada:**
- Archivo `.env` centraliza todas las credenciales: RabbitMQ, Redis, PostgreSQL, MongoDB, MinIO.
- `.env` confirmado en `.gitignore` mediante `git check-ignore -v docker/.env` → `.gitignore:2:docker/.env`.
- Stack completo levantado con `docker-compose up`:

| Contenedor | Imagen | Puertos | Estado |
|------------|--------|---------|--------|
| minio | minio/minio:latest | 9000-9001 | Up |
| mongodb | mongo:8 | 27017 | Up |
| postgresql | postgres:17 | 5432 | Up |
| redis | redis:8 | 6379 | Up |
| rabbitmq | rabbitmq:4-management | 5672, 15672 | Up |
| service-discovery | docker-service-discovery | 8761 | Up |
| config-service | docker-config-service | 8888 | Up |

---

#### TS-16.2 — Configuración del CI/CD Pipeline (GitHub Actions)
**Estado:** ✅ Done (con 1 tarea bloqueada)  
**Story Points:** 3

**Evidencia presentada:**
- Workflow `ci.yml` creado en `.github/workflows/`.
- Pipeline en verde — `build succeeded` en 1m 13s en GitHub Actions.
- Steps ejecutados correctamente:
  1. `Set up job`
  2. `Checkout code`
  3. `Set up Docker Buildx`
  4. `Build config-service` (31s)
  5. `Build service-discovery` (28s)
  6. `Complete job`

**Tarea bloqueada:**
| Tarea | Motivo | Plan |
|-------|--------|------|
| T-16.2.2 — Tests en el pipeline | No existen tests unitarios en los servicios Java actuales. Sin tests no tiene sentido configurar este paso. | Fase 2 — al desarrollar los microservicios reales |

---

## 4. Tareas Bloqueadas — Resumen

| ID Tarea | Historia | Motivo | Sprint/Fase destino |
|----------|----------|--------|---------------------|
| T-15.2.5 | TS-15.2 | Requiere scripts de backup con destino MinIO | Sprint 2 |
| T-16.2.2 | TS-16.2 | Requiere tests unitarios — inexistentes en Fase 1 | Fase 2 |

---

## 5. Deuda Técnica Identificada

| ID | Descripción | Prioridad | Sprint destino |
|----|-------------|-----------|----------------|
| DT-001 | El ambiente `staging/` no tiene `test-service.yml`. Todos los ambientes deben tener paridad de archivos de configuración. | Baja | Sprint 2 |
| DT-002 | El `test-service` debe eliminarse del `docker-compose.yml` una vez que los microservicios reales de Fase 2 estén disponibles. | Media | Fase 2 |
| DT-003 | Implementar readiness probes para garantizar orden de arranque correcto entre servicios dependientes. | Alta | Kubernetes (Fase 3+) |

---

## 6. Velocidad del Equipo

| Sprint | SP Comprometidos | SP Completados | Duración real |
|--------|-----------------|----------------|---------------|
| Sprint 1 | 27 | 27 | 5 días |

> **Línea base establecida: 27 Story Points por sprint.** Este valor se usará como referencia para el Sprint Planning del Sprint 2. Al tratarse del primer sprint, no se aplica promedio móvil — la estimación del Sprint 2 se ajustará con criterio conservador.

---

## 7. Adaptaciones al Product Backlog

| Tipo | Descripción |
|------|-------------|
| Tarea diferida | T-15.2.5 (backups) pasa al Sprint 2 |
| Tarea diferida | T-16.2.2 (tests en pipeline) pasa a Fase 2 |
| Deuda técnica | DT-001, DT-002, DT-003 registradas para seguimiento |

---

## 8. Próximos Pasos

1. **Sprint Retrospective** — reflexión sobre el proceso del Sprint 1.
2. **Sprint Planning Sprint 2** — planificación con velocidad base de 27 SP.
3. **Resolver T-15.2.5** — scripts de backup automático para PostgreSQL y MongoDB con destino MinIO.
4. **Iniciar Fase 2** — desarrollo de los microservicios core (Auth Service como primer candidato).
