# SPRINT BACKLOG — Sprint 3

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 3  
**Fase:** Fase 1 — Fundación (Gateway) + Fase 2 — Experiencia del Usuario (Autenticación)  
**Fecha inicio:** 07/04/2026  
**Fecha fin:** 13/04/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

Completar la fundación técnica del sistema con el API Gateway como punto de entrada único, e implementar el flujo completo de autenticación de usuarios — registro, login, refresh token y recuperación de contraseña — en el backend (Auth Service) y en la app móvil (Flutter).

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Historias comprometidas | 5 |
| Tareas totales | 27 |
| Story Points comprometidos | 26 |
| Horas estimadas totales | 38 h |
| Duración del sprint | 1 semana (7 días) |
| Velocidad promedio de referencia | 26.5 SP (promedio Sprint 1 + Sprint 2) |

---

## 3. Riesgos Técnicos por Historia

| ID | Historia | Riesgo | Tecnología desconocida |
|----|----------|--------|------------------------|
| TS-18.1 | API Gateway | Bajo | Ninguna — implementado antes |
| HU-01.1 | Registro de Usuario | Alto | Spring Security, comunicación con API Gateway, pantallas Flutter |
| HU-01.2 | Inicio de Sesión | Alto | JWT en Spring Boot (`jjwt`), Spring Security |
| HU-01.3 | Refresh Token | Alto | Lógica de rotación de tokens, manejo de estado en Flutter |
| HU-01.4 | Recuperación de Contraseña | Alto | JavaMailSender, tokens de expiración, SMTP externo |

---

## 4. Sprint Backlog Detallado

---

### EP-18 — Exposición y Enrutamiento de Servicios

---

#### TS-18.1 — Configuración del API Gateway

**Story Points:** 3  
**Horas estimadas:** 4 h  
**Riesgo:** Bajo

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-18.1.1 | Crear el proyecto Spring Boot del API Gateway en `backend/core/api-gateway/` con la dependencia `spring-cloud-starter-gateway` y configurarlo para registrarse automáticamente en Eureka al arrancar. | 1 h | To Do |
| T-18.1.2 | Definir las rutas de enrutamiento en `application.yml`: rutas públicas (`/auth/register`, `/auth/login`, `/auth/recover`) y rutas protegidas (`/auth/**`, futuras rutas de otros servicios), con sus predicados y filtros correspondientes. | 1 h | To Do |
| T-18.1.3 | Implementar el filtro global de validación JWT: intercepta todas las peticiones a rutas protegidas, verifica el token y rechaza con HTTP 401 si es inválido o ausente, sin llegar al microservicio destino. | 1 h | To Do |
| T-18.1.4 | Configurar CORS de forma centralizada en el Gateway para permitir peticiones desde los clientes autorizados (Flutter mobile y React admin web), y agregar el servicio al `docker-compose.yml` verificando que levanta y responde health checks correctamente. | 1 h | To Do |

---

### EP-01 — Autenticación de Usuarios

---

#### HU-01.1 — Registro de Usuario

**Story Points:** 5  
**Horas estimadas:** 8 h  
**Riesgo:** Alto — Spring Security + comunicación con API Gateway + pantalla Flutter nueva

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-01.1.1 | Crear el proyecto Spring Boot del Auth Service en `backend/core/auth-service/` con las dependencias necesarias (`spring-security`, `spring-data-jpa`, `postgresql`, `jjwt`) y registrarlo en Eureka. Crear el esquema de base de datos `auth_db` en PostgreSQL con la tabla `users` (id, nombre, email, password_hash, rol, fecha_creación). | 2 h | To Do |
| T-01.1.2 | Implementar el endpoint `POST /auth/register`: validar que el email no esté registrado, encriptar la contraseña con BCrypt, persistir el usuario y devolver un JWT de acceso y refresh token al completar el registro. | 2 h | To Do |
| T-01.1.3 | Configurar Spring Security para proteger los endpoints del Auth Service: rutas públicas (`/auth/register`, `/auth/login`, `/auth/recover`) sin autenticación, resto de rutas protegidas con JWT válido. | 2 h | To Do |
| T-01.1.4 | Implementar la pantalla de registro en Flutter (`lib/screens/auth/register_screen.dart`): formulario con campos nombre, email y contraseña usando los componentes del design system, validaciones en cliente, llamada al endpoint de registro y navegación al home al completarse exitosamente. | 2 h | To Do |

---

#### HU-01.2 — Inicio de Sesión

**Story Points:** 5  
**Horas estimadas:** 7 h  
**Riesgo:** Alto — JWT generación con `jjwt`, Spring Security

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-01.2.1 | Implementar el servicio de generación de JWT en el Auth Service usando `jjwt`: access token con tiempo de expiración corto (15 minutos) y refresh token con expiración larga (7 días), ambos firmados con clave secreta obtenida desde el Config Service. | 2 h | To Do |
| T-01.2.2 | Implementar el endpoint `POST /auth/login`: validar credenciales contra la base de datos, verificar contraseña con BCrypt, generar y devolver access token + refresh token si son correctas. Si son incorrectas, responder con HTTP 401 sin revelar cuál campo falló. | 2 h | To Do |
| T-01.2.3 | Persistir el refresh token en la tabla `refresh_tokens` (token_hash, user_id, expiracion, usado) para poder validarlo e invalidarlo en los endpoints de renovación y logout. | 1 h | To Do |
| T-01.2.4 | Implementar la pantalla de login en Flutter (`lib/screens/auth/login_screen.dart`): formulario con campos email y contraseña usando los componentes del design system, llamada al endpoint de login, almacenamiento del JWT en almacenamiento seguro del dispositivo y navegación al home al autenticarse correctamente. | 2 h | To Do |

---

#### HU-01.3 — Refresh Token

**Story Points:** 5  
**Horas estimadas:** 7 h  
**Riesgo:** Alto — lógica de rotación de tokens, completamente nuevo

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-01.3.1 | Implementar el endpoint `POST /auth/refresh`: validar que el refresh token existe en base de datos, no ha sido usado y no ha expirado. Si es válido, generar un nuevo access token y un nuevo refresh token (rotación), marcar el anterior como usado e invalidar todas las sesiones si se detecta reutilización. | 3 h | To Do |
| T-01.3.2 | Implementar el endpoint `POST /auth/logout`: marcar el refresh token como inválido en base de datos para cerrar la sesión del usuario de forma segura. | 1 h | To Do |
| T-01.3.3 | Integrar la lógica de renovación automática de token en el `AuthInterceptor` de Flutter (ya implementado en TS-17.3): cuando el backend devuelve 401, usar el refresh token almacenado para obtener uno nuevo y reintentar la petición original de forma transparente. Si el refresh también falla, redirigir al login. | 3 h | To Do |

---

#### HU-01.4 — Recuperación de Contraseña

**Story Points:** 8  
**Horas estimadas:** 12 h  
**Riesgo:** Alto — JavaMailSender + SMTP externo + tokens de expiración, completamente nuevo

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-01.4.1 | Configurar JavaMailSender en el Auth Service con un proveedor SMTP externo (Gmail SMTP o Mailtrap para desarrollo): credenciales obtenidas desde el Config Service, nunca hardcodeadas. Crear la tabla `password_reset_tokens` (token_hash, user_id, expiracion, usado). | 2 h | To Do |
| T-01.4.2 | Implementar el endpoint `POST /auth/recover`: verificar que el email existe, generar un token de recuperación de un solo uso con expiración de 15 minutos, persistirlo en `password_reset_tokens` y enviarlo al email del usuario mediante JavaMailSender. | 3 h | To Do |
| T-01.4.3 | Implementar el endpoint `POST /auth/reset-password`: validar que el token de recuperación existe, no ha sido usado y no ha expirado. Si es válido, actualizar la contraseña con BCrypt, marcar el token como usado e invalidar todas las sesiones activas del usuario. | 3 h | To Do |
| T-01.4.4 | Implementar las pantallas de recuperación en Flutter: pantalla de solicitud (`lib/screens/auth/forgot_password_screen.dart`) con campo email y confirmación de envío, y pantalla de nueva contraseña (`lib/screens/auth/reset_password_screen.dart`) con campos nueva contraseña y confirmación usando los componentes del design system. | 4 h | To Do |

---

## 5. Resumen por Historia

| ID | Nombre | Épica | SP | Horas Est. | Tareas |
|----|--------|-------|----|------------|--------|
| TS-18.1 | Configuración del API Gateway | EP-18 | 3 | 4 h | 4 |
| HU-01.1 | Registro de Usuario | EP-01 | 5 | 8 h | 4 |
| HU-01.2 | Inicio de Sesión | EP-01 | 5 | 7 h | 4 |
| HU-01.3 | Refresh Token | EP-01 | 5 | 7 h | 3 |
| HU-01.4 | Recuperación de Contraseña | EP-01 | 8 | 12 h | 4 |
| **Total** | | | **26** | **38 h** | **19** |

---

## 6. Orden de Ejecución

| Orden | ID | Historia | Justificación |
|-------|----|----------|---------------|
| 1 | TS-18.1 | API Gateway | Punto de entrada único — todos los servicios deben ser accesibles a través del Gateway antes de probar cualquier flujo de usuario |
| 2 | HU-01.1 | Registro de Usuario | Primer flujo end-to-end: crea el Auth Service, el esquema de BD y la primera pantalla Flutter. Valida que la comunicación Gateway → Auth Service → PostgreSQL → Flutter funciona |
| 3 | HU-01.2 | Inicio de Sesión | Requiere HU-01.1 completa (usuarios en BD). Introduce JWT — prerequisito para HU-01.3 |
| 4 | HU-01.3 | Refresh Token | Requiere HU-01.2 completa (generación de tokens). Cierra el ciclo de seguridad de sesiones |
| 5 | HU-01.4 | Recuperación de Contraseña | No bloquea ninguna otra historia. Funcionalidad independiente que se ejecuta al final del sprint |

---

## 7. Tareas Diferidas

| ID | Descripción | Motivo | Sprint Destino |
|----|-------------|--------|----------------|
| T-15.2.5 | Backups automáticos PostgreSQL y MongoDB → MinIO | Desbloqueado parcialmente: Auth Service tiene esquema real. Se ejecuta cuando existan más microservicios para justificar la estrategia completa | Sprint 4 |
| T-16.2.2 | Pipeline CI/CD: ejecución de pruebas automatizadas | Desbloqueado: Auth Service tendrá pruebas unitarias. Candidato para Sprint 4 | Sprint 4 |

---

## 8. Notas

- Sprint 3 inicia formalmente **Fase 2 — Experiencia del Usuario** con EP-01 como primera épica.
- TS-18.1 cierra la **Fase 1 — Fundación** completando EP-18. A partir de este sprint, toda la infraestructura base está operativa.
- El flujo de autenticación es el prerequisito arquitectónico para todas las historias de Fase 2 — sin Auth Service no hay usuarios, sin usuarios no hay predicciones, historial ni perfil.
- HU-01.4 tiene el riesgo técnico más alto del sprint (dos tecnologías completamente nuevas: JavaMailSender + SMTP). Si el sprint se ve comprometido, esta historia es la primera candidata a desbloquearse parcialmente — el backend puede completarse y el frontend diferirse.
- Las tareas diferidas T-15.2.5 y T-16.2.2 se desbloquean en este sprint: Auth Service provee el primer esquema real de BD y las primeras pruebas unitarias reales. Ambas son candidatas firmes para Sprint 4.
- Velocidad de referencia: 26.5 SP promedio acumulado. Sprint 3 compromete exactamente 26 SP — estimación conservadora justificada por el alto riesgo técnico distribuido en 4 de las 5 historias.
