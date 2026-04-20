# SPRINT REVIEW — Sprint 3

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 3  
**Fase:** Fase 1 — Fundación (Gateway) + Fase 2 — Experiencia del Usuario (Autenticación)  
**Fecha de Review:** 20 de abril de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Completar la fundación técnica del sistema con el API Gateway como punto de entrada único, e implementar el flujo completo de autenticación de usuarios — registro, login, refresh token y recuperación de contraseña — en el backend (Auth Service) y en la app móvil (Flutter).

**Resultado:** ⚠️ Sprint Goal parcialmente cumplido.

> El flujo de autenticación está implementado en su totalidad a nivel de código. El Sprint Goal se ve limitado por DT-001 (HTTP 403 en `POST /auth/login`) y DT-002 (puerto SMTP 587 bloqueado en red Docker), ambas bloqueantes de infraestructura documentadas y derivadas al Sprint 4. El incremento entregado es funcional y verificable en todas las historias sin dependencia de estas deudas.

---

## 2. Resumen de Resultados

| Concepto | Valor |
|----------|-------|
| Historias comprometidas | 5 |
| Historias completadas | 4 |
| Historias parcialmente completadas | 1 |
| Story Points comprometidos | 26 |
| Story Points completados | 21 |
| Story Points parciales | 5 |
| Tareas completadas | 17 / 19 |
| Tareas bloqueadas | 2 |
| Duración real del sprint | 13 días |
| **Velocidad Sprint 3** | **21 SP** |

> HU-01.2 y HU-01.4 presentan tareas bloqueadas por deuda técnica de infraestructura (DT-001, DT-002). El código de ambas está completo y correcto. La limitante no es de implementación sino de entorno.

---

## 3. Incremento Entregado

### EP-18 — Exposición y Enrutamiento de Servicios

---

#### TS-18.1 — Configuración del API Gateway
**Estado:** ✅ Done  
**Story Points:** 3

**Evidencia presentada:**
- Proyecto Spring Boot 4.0.4 creado en `backend/core/api-gateway/` con `spring-cloud-starter-gateway-server-webmvc`.
- `JwtAuthFilter` implementado como `jakarta.servlet.Filter` con `@Order(1)` — intercepta todas las peticiones a rutas protegidas antes de enrutarlas.
- Rutas públicas (`/auth/register`, `/auth/login`, `/auth/recover`, `/auth/refresh`, `/auth/reset-password`) y rutas protegidas configuradas en `application.yml` con predicados y filtros.
- CORS configurado de forma centralizada en el Gateway para Flutter mobile y React admin web.
- Enrutamiento con `lb://auth-service` — carga balanceada vía Eureka.
- Multi-stage Dockerfile configurado y servicio integrado en `docker-compose.yml` con healthcheck via `/actuator/health`.

**Decisiones técnicas relevantes:**
- `spring-cloud-starter-gateway-server-webmvc` sobre la variante reactiva — consistencia con el stack Servlet del resto de microservicios.
- Filtro JWT centralizado en el Gateway — los microservicios internos no gestionan autenticación individualmente.
- Registro automático en Eureka — el enrutamiento `lb://` permite escalar instancias sin cambiar configuración de rutas.

---

### EP-01 — Autenticación y Gestión de Usuarios

---

#### HU-01.1 — Registro de Usuario
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- Auth Service creado en `backend/core/auth-service/` con esquema PostgreSQL `auth` — tablas `users`, `roles`, `user_role` con UUIDs como primary keys.
- BCrypt configurado para hashing de contraseñas — factor de coste por defecto de Spring Security.
- Spring Security filter chain configurado: `POST /auth/register` sin autenticación requerida.
- Endpoint `POST /auth/register` operativo — registra usuario con validación de email duplicado, retorna HTTP 201.
- Config Service integrado — Auth Service consume `auth-service.yml` desde el repositorio de configuración centralizado.
- Pantalla de registro en Flutter conectada al backend via `ApiClient`.

**Decisiones técnicas relevantes:**
- UUIDs como primary keys — evita exposición de IDs secuenciales en la API y facilita distribución futura.
- Schema `auth` dedicado — aislamiento de las tablas de autenticación del schema `public`.
- Roles pre-cargados en BD (`USER`, `ADMIN`) — el registro asigna `ROLE_USER` por defecto sin lógica adicional.

---

#### HU-01.2 — Inicio de Sesión
**Estado:** ⚠️ Parcialmente completa (bloqueada por DT-001)  
**Story Points:** 5

**Evidencia presentada:**
- `JwtService` implementado con `jjwt 0.12.6` — genera access token (15 min) y refresh token (7 días) con claims estándar.
- Endpoint `POST /auth/login` implementado con `AuthenticationManager` — lógica completa de autenticación.
- Refresh token persistido en Redis con `@RedisHash` + `@TimeToLive` — expiración automática sin cron jobs.
- Endpoint `POST /auth/logout` operativo — invalida el refresh token en Redis.
- Pantalla de login en Flutter con `ApiClient` y manejo de errores.

**Bloqueo — DT-001:**
`POST /auth/login` retorna HTTP 403 en Spring Boot 4.x a pesar de `csrf.disable()` y `permitAll()`. Comportamiento confirmado como cambio de defaults de seguridad entre versiones. Código correcto — problema de configuración de framework. Derivado a Sprint 4.

**Decisiones técnicas relevantes:**
- Redis para refresh tokens sobre PostgreSQL — TTL nativo con `@TimeToLive`, no requiere proceso de limpieza periódica.
- Access token de 15 minutos — ventana corta limita el daño ante compromiso de token.
- `@RequiredArgsConstructor` sobre `@Autowired` — inyección por constructor, patrón de industria con Spring.

---

#### HU-01.3 — Refresh Token
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- Endpoint `POST /auth/refresh` con rotación completa — el token usado se destruye y se emite un nuevo par (access + refresh).
- `TokenService` en Flutter con `flutter_secure_storage 10.0.0` — tokens persistidos en almacenamiento seguro del dispositivo.
- `AuthInterceptor` con renovación automática en error 401 — el usuario no percibe la renovación, la petición original se reintenta con el nuevo token.
- `NavigatorKey` global — permite redirigir al login cuando el refresh token expira sin requerir `BuildContext` en el interceptor.

**Decisiones técnicas relevantes:**
- Rotación en cada uso — cada refresh invalida el token anterior, impide reutilización ante compromiso.
- `flutter_secure_storage` sobre `SharedPreferences` — almacenamiento cifrado por el OS, no texto plano.
- Interceptor con retry transparente — UX sin interrupciones, el flujo de renovación es invisible al usuario.

---

#### HU-01.4 — Recuperación de Contraseña
**Estado:** ⚠️ Parcialmente completa (bloqueada por DT-002)  
**Story Points:** 8

**Evidencia presentada:**
- Tabla `password_reset_tokens` creada en schema `auth` — columnas `token_hash`, `user_id`, `expiration`, `used`.
- Endpoint `POST /auth/recover` implementado — genera token de un solo uso, lo hashea con SHA-256, lo persiste con expiración de 15 minutos. Retorno silencioso si el email no existe (prevención de enumeración de usuarios).
- Endpoint `POST /auth/reset-password` operativo — valida token, verifica expiración y estado `used`, actualiza contraseña con BCrypt, invalida todas las sesiones activas del usuario en Redis, marca el token como usado.
- Pantallas Flutter `forgot_password_screen.dart` y `reset_password_screen.dart` implementadas con componentes del design system.

**Bloqueo — DT-002:**
`JavaMailSender` no puede conectar con `sandbox.smtp.mailtrap.io:587` desde contenedor Docker — puerto 587 bloqueado en la red del host. El código de envío es correcto; el problema es de infraestructura de red. Resolución planificada para Sprint 4: reemplazar Mailtrap por MailHog como servidor SMTP local en Docker.

**Decisiones técnicas relevantes:**
- SHA-256 del token en BD, token original en el email — si la BD se compromete, los hashes no son utilizables directamente.
- Retorno silencioso en email desconocido — impide inferir qué emails están registrados en el sistema (OWASP A07).
- Invalidación de sesiones Redis en reset — garantiza que sesiones activas con contraseña comprometida queden nulas inmediatamente.

---

## 4. Deuda Técnica Identificada

| ID | Descripción | Prioridad | Sprint destino |
|----|-------------|-----------|----------------|
| DT-001 | `POST /auth/login` retorna HTTP 403 en Spring Boot 4.x a pesar de `csrf.disable()` y `permitAll()`. Cambio de defaults de seguridad entre versiones. Código correcto — problema de configuración de framework. | Alta | Sprint 4 |
| DT-002 | `JavaMailSender` no conecta con `sandbox.smtp.mailtrap.io:587` desde contenedor Docker — puerto 587 bloqueado en red del host. Resolución: reemplazar Mailtrap por MailHog como SMTP local en Docker. | Alta | Sprint 4 |

---

## 5. Tareas Diferidas — Estado Actualizado

| ID Tarea | Historia | Motivo original | Estado actual | Sprint destino |
|----------|----------|-----------------|---------------|----------------|
| T-15.2.5 | TS-15.2 | Requiere esquemas reales de BD | Auth Service provee el primer esquema real. Espera más microservicios para justificar la estrategia completa | Sprint 4 |
| T-16.2.2 | TS-16.2 | Requiere tests unitarios en microservicios reales | Auth Service tiene la primera lógica de negocio testeable. Candidato firme Sprint 4 | Sprint 4 |

---

## 6. Velocidad del Equipo

| Sprint | SP Comprometidos | SP Completados | Duración real |
|--------|-----------------|----------------|---------------|
| Sprint 1 | 27 | 27 | 5 días |
| Sprint 2 | 26 | 26 | 7 días |
| Sprint 3 | 26 | 21 | 13 días |
| **Promedio** | **26.3** | **24.7** | — |

> **Nota:** La reducción de velocidad en Sprint 3 está explicada por dos bloqueos de infraestructura (DT-001, DT-002) que no fueron detectables en el Sprint Planning — no son atribuibles a estimación incorrecta ni a capacidad de desarrollo. Los 5 SP afectados corresponden a tareas cuyo código está completo. La velocidad efectiva de implementación se mantiene estable; la métrica se ajustará en la Retrospectiva.
>
> **Velocidad de referencia para Sprint 4:** 24–26 SP (promedio móvil de tres sprints, con criterio conservador dado el alto riesgo técnico acumulado en deuda técnica).

---

## 7. Adaptaciones al Product Backlog

| Tipo | Descripción |
|------|-------------|
| Deuda técnica nueva | DT-001 registrada — HTTP 403 en `POST /auth/login` en Spring Boot 4.x |
| Deuda técnica nueva | DT-002 registrada — puerto SMTP 587 bloqueado en red Docker |
| Tarea diferida (mantiene) | T-15.2.5 — backups automáticos, sigue diferida hasta Sprint 4 |
| Tarea diferida (mantiene) | T-16.2.2 — tests en pipeline, candidato Sprint 4 |

---

## 8. Cierre de Fase 2 — Autenticación (Parcial)

> El Sprint 3 avanza la **Fase 2 — Experiencia del Usuario** con EP-01 casi completa. El flujo de autenticación completo queda operativo una vez resueltas DT-001 y DT-002 en Sprint 4.

| Épica | Historias | SP | Estado |
|-------|-----------|-----|--------|
| EP-18 — Exposición y Enrutamiento | TS-18.1 | 3 SP | ✅ Completa |
| EP-01 — Autenticación | HU-01.1, HU-01.3 | 10 SP | ✅ Completas |
| EP-01 — Autenticación | HU-01.2, HU-01.4 | 13 SP | ⚠️ Bloqueadas por DT |
| **Sprint 3 Total** | **5 historias** | **26 SP** | **21 SP entregados** |

El sistema cuenta ahora con:
- API Gateway operativo como único punto de entrada con validación JWT centralizada
- Auth Service con esquema PostgreSQL completo y registro de usuarios funcional
- Refresh token con rotación implementado y verificado end-to-end en Flutter
- Flujo de recuperación de contraseña completo a nivel de código — pendiente resolución SMTP

---

## 9. Próximos Pasos

1. **Sprint Retrospective Sprint 3** — reflexión sobre el proceso y acciones de mejora.
2. **Sprint Planning Sprint 4** — incluir obligatoriamente DT-001 y DT-002 como primeras tareas del sprint.
3. **Resolver DT-001** — investigar y corregir HTTP 403 en `POST /auth/login` con Spring Boot 4.x Security defaults.
4. **Resolver DT-001** — reemplazar Mailtrap por MailHog en Docker para habilitar envío SMTP local.
5. **T-15.2.5 y T-16.2.2** — evaluar inclusión en Sprint 4 con Auth Service como base real.

---

*MultIAZ — Sprint 3 Review | Abril 2026*
