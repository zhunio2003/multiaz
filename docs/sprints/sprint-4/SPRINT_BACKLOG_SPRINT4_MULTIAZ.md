# SPRINT BACKLOG — Sprint 4

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 4  
**Fase:** Fase 1 — Fundación (Deuda Técnica + CI/CD) + Fase 2 — Experiencia del Usuario (Autenticación completa) + Fase 3 — Administración (Model Registry)  
**Fecha inicio:** 21/04/2026  
**Fecha fin:** 27/04/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

Resolver la deuda técnica acumulada del Sprint 3 (login bloqueado y SMTP en Docker), activar las pruebas automatizadas del Auth Service en el pipeline CI/CD, implementar la estrategia de backups automáticos, y construir el Model Registry Service como prerequisito técnico de EP-02 y EP-08.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 5 |
| Tareas totales | 16 |
| Story Points comprometidos | 16 SP |
| Horas estimadas totales | 49 h |
| Duración del sprint | 1 semana (7 días) |
| Disponibilidad diaria | 7 h/día |
| Velocidad promedio de referencia | 24.7 SP (promedio Sprint 1 + Sprint 2 + Sprint 3) |

> **Nota:** Se comprometieron 16 SP de forma conservadora — por debajo de la velocidad de referencia — debido a dos factores: DT-001 tiene riesgo alto sin tiempo de resolución garantizado (bug de framework en Spring Boot 4.x), y TS-08.1 introduce MongoDB como tecnología nueva. Se aplica el factor 1.5x definido en la Retrospectiva del Sprint 3 para la estimación de duración en días.

---

## 3. Riesgos Técnicos por Item

| ID | Item | Tipo | Riesgo | Motivo |
|----|------|------|--------|--------|
| DT-001 | Fix HTTP 403 `POST /auth/login` | Deuda técnica | Alto | Bug de defaults de Spring Boot 4.x — causa raíz no identificada en Sprint 3 |
| DT-001 | MailHog reemplaza Mailtrap en Docker | Deuda técnica | Bajo | Cambio de configuración conocido, sin lógica nueva |
| T-16.2.2 | Tests unitarios Auth Service en CI/CD | Tarea diferida | Medio | JUnit 5 + Mockito conocidos, integración con pipeline requiere atención |
| T-15.2.5 | Backups PostgreSQL + MongoDB → MinIO | Tarea diferida | Bajo | Herramientas conocidas (`pg_dump`, `mongodump`), lógica de scripting simple |
| TS-08.1 | Model Registry Service | Technical Story | Alto | MongoDB + `@Document` + `MongoRepository` nuevos en el proyecto |

---

## 4. Sprint Backlog Detallado

---

### Deuda Técnica — EP-01 Autenticación

---

#### DT-001 — Fix HTTP 403 en `POST /auth/login` (Spring Boot 4.x)

**Story Points:** 3  
**Horas estimadas:** 6 h  
**Riesgo:** Alto — bug de defaults de framework, causa raíz requiere diagnóstico antes de aplicar fix

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-DT005.1 | Activar logging TRACE de Spring Security en el auth-service (`logging.level.org.springframework.security: TRACE`), levantar el stack y ejecutar `POST /auth/login` con Postman. Identificar la línea exacta del log que precede al 403 — buscar `denied`, `Failed to authorize` o `Checking authorization`. Documentar el hallazgo antes de tocar código. | 2 h | To Do |
| T-DT005.2 | Con la causa raíz identificada, aplicar el fix correspondiente en `SecurityConfig` del auth-service. Verificar que `POST /auth/login` retorna HTTP 200 con JWT válido. Verificar que rutas protegidas siguen retornando HTTP 401 sin token. | 3 h | To Do |
| T-DT005.3 | Remover el logging TRACE una vez resuelto el bug. Hacer commit del fix con mensaje descriptivo. Actualizar el estado de DT-001 como resuelto en la documentación. | 1 h | To Do |

---

#### DT-001 — MailHog reemplaza Mailtrap en Docker

**Story Points:** 2  
**Horas estimadas:** 3 h  
**Riesgo:** Bajo — cambio de infraestructura de desarrollo, sin lógica nueva

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-DT006.1 | Agregar el servicio `mailhog` al `docker-compose.yml` con la imagen `mailhog/mailhog`, exponiendo el puerto SMTP `1025` para el envío y el puerto `8025` para la interfaz web de inspección de emails. | 1 h | To Do |
| T-DT006.2 | Actualizar la configuración de `JavaMailSender` en el `application-dev.yml` del auth-service en el Config Service: reemplazar las credenciales de Mailtrap por `host: mailhog`, `port: 1025`, sin usuario ni contraseña. | 1 h | To Do |
| T-DT006.3 | Verificar el flujo completo: ejecutar `POST /auth/recover` con un email registrado y confirmar que el email llega a la interfaz web de MailHog en `http://localhost:8025`. | 1 h | To Do |

---

### Tarea Diferida — EP-16 Operaciones

---

#### T-16.2.2 — Tests Unitarios Auth Service en Pipeline CI/CD

**Story Points:** 3  
**Horas estimadas:** 8 h  
**Riesgo:** Medio — JUnit 5 + Mockito conocidos, integración con GitHub Actions requiere atención

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-16.2.2.1 | Escribir tests unitarios para `JwtService`: verificar generación de access token con claims correctos, verificar extracción de username desde token, verificar detección de token expirado. Usar JUnit 5 + Mockito. | 3 h | To Do |
| T-16.2.2.2 | Escribir tests unitarios para `AuthService`: verificar registro con email duplicado lanza excepción, verificar login con credenciales incorrectas lanza excepción, verificar que la contraseña se encripta antes de persistir. Mockear el repository con Mockito. | 3 h | To Do |
| T-16.2.2.3 | Actualizar el workflow de GitHub Actions del auth-service para ejecutar `./mvnw test` como paso previo al build de la imagen Docker. Verificar que el pipeline falla correctamente si un test falla. | 2 h | To Do |

---

### Tarea Diferida — EP-15 Almacenamiento

---

#### T-15.2.5 — Backups Automáticos PostgreSQL + MongoDB → MinIO

**Story Points:** 3  
**Horas estimadas:** 6 h  
**Riesgo:** Bajo — herramientas conocidas, lógica de scripting simple

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-15.2.5.1 | Escribir script `backup-postgres.sh`: ejecutar `pg_dump` sobre `auth_db`, comprimir el resultado con `gzip`, nombrar el archivo con timestamp (`auth_db_YYYYMMDD_HHMMSS.sql.gz`) y subirlo al bucket `backups/postgres/` en MinIO usando el cliente `mc`. | 2 h | To Do |
| T-15.2.5.2 | Escribir script `backup-mongo.sh`: ejecutar `mongodump` sobre la base de datos del auth-service, comprimir el resultado con `tar.gz`, nombrar el archivo con timestamp y subirlo al bucket `backups/mongo/` en MinIO usando el cliente `mc`. | 2 h | To Do |
| T-15.2.5.3 | Agregar un servicio `backup-scheduler` al `docker-compose.yml` usando la imagen `alpine` con `cron` configurado para ejecutar ambos scripts automáticamente cada 24 horas. Verificar manualmente que ambos scripts ejecutan correctamente y los archivos aparecen en MinIO. | 2 h | To Do |

---

### EP-08 — Gestión de Modelos de IA

---

#### TS-08.1 — Model Registry Service

**Story Points:** 5  
**Horas estimadas:** 26 h  
**Riesgo:** Alto — MongoDB + `@Document` + `MongoRepository` nuevos en el proyecto

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-08.1.1 | Crear el proyecto Spring Boot del Model Registry Service en `backend/core/model-registry-service/` con las dependencias necesarias (`spring-boot-starter-web`, `spring-boot-starter-data-mongodb`, `spring-cloud-starter-netflix-eureka-client`, `spring-cloud-starter-config`, `spring-boot-starter-actuator`). Configurarlo para registrarse en Eureka y obtener su configuración desde el Config Service. | 4 h | To Do |
| T-08.1.2 | Crear el `@Document` `AiModel` en MongoDB con los campos: `id`, `name`, `description`, `type`, `status` (ACTIVE/INACTIVE), `endpointUrl`, `inputSchema`, `outputSchema`, `version`, `createdAt`. Crear la base de datos `model_registry_db` en MongoDB y el `MongoRepository` correspondiente (`AiModelRepository`). | 5 h | To Do |
| T-08.1.3 | Implementar `ModelService` con la lógica de negocio: `save(AiModel model)`, `findById(String id)`, `findAllByStatus(String status)`. Usar `@RequiredArgsConstructor` para inyección de dependencias. | 4 h | To Do |
| T-08.1.4 | Implementar `ModelController` con los endpoints REST: `POST /models` para registrar un modelo nuevo, `GET /models?status=ACTIVE` para consultar modelos activos, `GET /models/{id}` para consultar un modelo por ID. Retornar HTTP 404 si el modelo no existe en `GET /models/{id}`. | 5 h | To Do |
| T-08.1.5 | Agregar el servicio al `docker-compose.yml` con su Dockerfile multi-stage, configurar la conexión a MongoDB en el Config Service (`application-dev.yml`), y verificar que el servicio levanta, responde `UP` en `/actuator/health` y aparece registrado en Eureka. | 4 h | To Do |
| T-08.1.6 | Escribir un test que inserte un documento `AiModel` directamente en MongoDB y verifique que `GET /models/{id}` retorna el documento correcto con todos sus campos. | 4 h | To Do |

---

## 5. Resumen por Item

| ID | Nombre | Tipo | SP | Horas Est. | Tareas |
|----|--------|------|----|------------|--------|
| DT-001 | Fix HTTP 403 `POST /auth/login` | Deuda técnica | 3 | 6 h | 3 |
| DT-002 | MailHog reemplaza Mailtrap en Docker | Deuda técnica | 2 | 3 h | 3 |
| T-16.2.2 | Tests unitarios Auth Service en CI/CD | Tarea diferida | 3 | 8 h | 3 |
| T-15.2.5 | Backups PostgreSQL + MongoDB → MinIO | Tarea diferida | 3 | 6 h | 3 |
| TS-08.1 | Model Registry Service | Technical Story | 5 | 26 h | 6 |
| **Total** | | | **16** | **49 h** | **18** |

---

## 6. Orden de Ejecución

| Orden | ID | Item | Justificación |
|-------|----|------|---------------|
| 1 | DT-001 | Fix HTTP 403 login | Bloquea HU-01.2 — el login no funciona. Resuelve la deuda técnica más crítica del sprint. |
| 2 | DT-001 | MailHog en Docker | Bloquea HU-01.4 — el envío de email de recuperación no funciona. Independiente de DT-001. |
| 3 | T-16.2.2 | Tests Auth Service en CI/CD | Depende de DT-001 — los tests de login no pueden pasar con el bug activo. Se ejecuta con Auth Service funcional. |
| 4 | T-15.2.5 | Backups automáticos | Independiente de las deudas técnicas. Se ejecuta después de cerrar la deuda para no fragmentar el contexto de trabajo. |
| 5 | TS-08.1 | Model Registry Service | Prerequisito técnico de EP-08 y EP-02. Se ejecuta al final — es la única historia de construcción nueva del sprint. |

---

## 7. Verificación de Acciones de Mejora — Sprint 3

| # | Acción comprometida | Cómo se verifica en este sprint |
|---|---------------------|---------------------------------|
| 1 | Validar conectividad Docker antes de comprometer servicios externos | DT-001: se valida puerto SMTP desde contenedor antes de configurar MailHog |
| 2 | Checklist mental de entidades JPA antes de escribir | TS-08.1: aplicar el mismo checklist a `@Document` — snake_case en colección, camelCase en campos, Optional en repository |
| 3 | Factor 1.5x en duración cuando >50% historias tienen riesgo alto | Aplicado: 16 SP comprometidos en 7 días con 2 items de riesgo alto |

---

## 8. Notas

- Sprint 4 es un sprint de **consolidación y deuda** — su objetivo principal es dejar EP-01 completamente operativa antes de avanzar a EP-02.
- DT-001 es el item de mayor riesgo del sprint. Si la investigación con logs TRACE no identifica la causa raíz en la primera tarea, se escala inmediatamente — no se itera a ciegas como en Sprint 3.
- TS-08.1 es el único item de construcción nueva. Su riesgo está acotado: el patrón de microservicio ya está establecido desde el Auth Service — lo único nuevo es MongoDB en lugar de PostgreSQL.
- Al completar este sprint, EP-01 queda formalmente cerrada y el sistema tendrá su primer microservicio de negocio de Fase 3 operativo (Model Registry), habilitando el inicio de EP-02 en Sprint 5.
- Velocidad de referencia: 24.7 SP promedio acumulado. Sprint 4 compromete 16 SP — decisión consciente y justificada por riesgo técnico.

---

*MultIAZ — Sprint 4 Backlog | Abril 2026*
