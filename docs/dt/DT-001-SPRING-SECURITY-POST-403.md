# DT-001 — Spring Security Bloquea POST Requests con HTTP 403 en Spring Boot 4.x

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Sprint detectado:** Sprint 3  
**Historia afectada:** HU-01.2 — Inicio de Sesión  
**Prioridad:** Alta  
**Sprint destino:** Sprint 4  
**Autor:** Miguel Angel Zhunio Remache  
**Fecha:** 14 de abril de 2026

---

## Descripción

El endpoint `POST /auth/login` del `auth-service` retorna `HTTP 403 Forbidden` a pesar de que la configuración de Spring Security lo declara explícitamente como ruta pública con `permitAll()` y CSRF deshabilitado con `csrf.disable()`. El bloqueo ocurre directamente contra el `auth-service` en el puerto 8081 — independientemente del Gateway.

---

## Evidencia Observada

```
curl -X POST http://localhost:8081/auth/login
→ HTTP 403 Forbidden

Headers de respuesta:
  X-Content-Type-Options: nosniff
  X-XSS-Protection: 0
  Cache-Control: no-cache, no-store, max-age=0, must-revalidate
  X-Frame-Options: DENY
```

Estos headers son exclusivos de Spring Security — confirman que el bloqueo viene del framework, no de la aplicación.

---

## Configuración Actual

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
      .authorizeHttpRequests(auth -> auth
        .requestMatchers(
          "/auth/register",
          "/auth/login",
          "/auth/recover",
          "/actuator/health"
        ).permitAll()
        .anyRequest().authenticated()
      )
      .csrf(csrf -> csrf.disable())
      .sessionManagement(session ->
        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
    return http.build();
  }
}
```

---

## Comportamiento Comparado

| Endpoint | Método | Resultado | Observación |
|----------|--------|-----------|-------------|
| `/auth/register` | POST | ✅ HTTP 201 | Funciona correctamente |
| `/auth/login` | POST | ❌ HTTP 403 | Bloqueado por Spring Security |
| `/actuator/health` | GET | ✅ HTTP 200 | Funciona correctamente |

El hecho de que `/auth/register` funcione y `/auth/login` no, siendo ambos `POST` declarados en el mismo `permitAll()`, sugiere que el problema no es la configuración de CSRF en sí, sino algún comportamiento específico de Spring Security 6.x relacionado con el path o el orden de evaluación de los filtros.

---

## Hipótesis de Causa Raíz

Spring Boot 4.x usa Spring Security 6.3+, que introdujo cambios en el orden de evaluación de `SecurityFilterChain` y en el comportamiento de `requestMatchers`. Las hipótesis más probables son:

**Hipótesis 1 — Falta de especificación del método HTTP en `requestMatchers`**  
Spring Security 6.x recomienda especificar explícitamente el método HTTP para evitar ambigüedades. Sin `HttpMethod.POST`, Spring Security puede evaluar la regla solo para GET y bloquear POST por defecto.

**Hipótesis 2 — Conflicto con `SecurityFilterChain` de autoconfiguración**  
Spring Boot 4.x puede registrar múltiples `SecurityFilterChain` beans automáticamente. Si hay un bean de mayor precedencia que no incluye las reglas de `permitAll()`, ese bean evalúa primero y bloquea el request antes de que llegue al bean configurado manualmente.

**Hipótesis 3 — Cambio en el comportamiento de `csrf.disable()` en Spring Security 6.3**  
Spring Security 6.3 cambió el mecanismo CSRF por defecto a uno basado en cookies `SameSite`. El método `csrf.disable()` puede no desactivar completamente este mecanismo en Spring Boot 4.x.

---

## Intentos de Solución Aplicados (Sin Resultado)

| Intento | Resultado |
|---------|-----------|
| `csrf(csrf -> csrf.disable())` — forma lambda estándar | HTTP 403 persiste |
| `csrf(AbstractHttpConfigurer::disable)` — referencia de método | HTTP 403 persiste |
| Reconstrucción con `--no-cache` para descartar imagen vieja | HTTP 403 persiste |
| Agregar `SecurityConfig` al api-gateway con `anyRequest().permitAll()` | HTTP 403 persiste en auth-service |

---

## Plan de Resolución para Sprint 4

Investigar en el siguiente orden — detener al encontrar la solución que funcione:

**Paso 1 — Especificar método HTTP en `requestMatchers`:**
```java
.requestMatchers(HttpMethod.POST, "/auth/login").permitAll()
.requestMatchers(HttpMethod.POST, "/auth/register").permitAll()
.requestMatchers(HttpMethod.POST, "/auth/recover").permitAll()
.requestMatchers(HttpMethod.GET, "/actuator/health").permitAll()
```

**Paso 2 — Ignorar CSRF por ruta en lugar de deshabilitarlo globalmente:**
```java
.csrf(csrf -> csrf.ignoringRequestMatchers("/auth/**", "/actuator/**"))
```

**Paso 3 — Revisar beans de autoconfiguración activos:**
```bash
# Habilitar debug en application.yml y revisar qué SecurityFilterChain evalúa primero
logging:
  level:
    org.springframework.security: DEBUG
```

**Paso 4 — Consultar:**
- Spring Security 6.3 Migration Guide — sección `requestMatchers`
- Spring Boot 4.0 Release Notes — Breaking Changes in Security autoconfiguration
- Issues abiertos en `spring-projects/spring-security` en GitHub relacionados con `permitAll` y POST

---

## Impacto

| Historia | Estado | Motivo |
|----------|--------|--------|
| HU-01.2 — Inicio de Sesión | ⚠️ Parcialmente completada | Lógica backend correcta, prueba end-to-end bloqueada |
| HU-01.3 — Refresh Token | 🔴 Bloqueada | Depende de HU-01.2 completada |
| HU-01.4 — Recuperación de Contraseña | 🟡 No bloqueada directamente | Mismo patrón de SecurityConfig — puede manifestar el mismo bug |

> **Nota:** La lógica de negocio de `AuthService.login()`, `JwtService.generateAccessToken()` y `JwtService.generateRefreshToken()` está correctamente implementada y verificada. El bug es exclusivamente de configuración de Spring Security.

---

## Archivos Relacionados

- `backend/core/auth-service/src/main/java/com/multiaz/authservice/config/SecurityConfig.java`
- `backend/core/auth-service/pom.xml` — versión de Spring Boot 4.0.4 / Spring Security 6.x

---

*MultIAZ — Sprint 3 | DT-002 | Abril 2026*
