# SPRINT REVIEW — Sprint 2

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 2  
**Fase:** Fase 1 — Fundación (Frontend)  
**Fecha de Review:** 05 de abril de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Establecer la fundación frontend completa del sistema MultIAZ: inicialización de los proyectos mobile y web, design system unificado y módulos de comunicación con el backend.

**Resultado:** ✅ Sprint Goal cumplido.

---

## 2. Resumen de Resultados

| Concepto | Valor |
|----------|-------|
| Technical Stories comprometidas | 5 |
| Technical Stories completadas | 5 |
| Story Points comprometidos | 26 |
| Story Points completados | 26 |
| Tareas completadas | 27 / 27 |
| Tareas bloqueadas | 0 |
| Duración real del sprint | 7 días (entrega el 03/04/2026 a las 23:00) |
| **Velocidad Sprint 2** | **26 SP** |

> Sprint completado al 100% dentro del plazo establecido. Cierra formalmente la **Fase 1 — Fundación** del proyecto MultIAZ.

---

## 3. Incremento Entregado

### EP-17 — Fundación Frontend

---

#### TS-17.1 — Inicialización de la Mobile App (Flutter)
**Estado:** ✅ Done  
**Story Points:** 3

**Evidencia presentada:**
- Proyecto Flutter creado en `frontend/mobile-app/` usando Flutter CLI — compila y ejecuta sin errores.
- `flutter_lints` configurado en `pubspec.yaml` y `analysis_options.yaml` — `flutter analyze` sin issues.
- `flutter_test` verificado — test de ejemplo ejecuta exitosamente con `flutter test`.
- Estructura de carpetas por feature definida en `lib/`: `screens/`, `widgets/`, `services/`, `models/`, `utils/` con archivos `.gitkeep` para rastreo en Git.

**Decisiones técnicas relevantes:**
- Estructura por feature (no por tipo) — convención de industria para proyectos Flutter de escala media/grande.
- Analogía de referencia: `pubspec.yaml` = `pom.xml`, `lib/` = `src/main/java/`, `screens/` = `@Controller`, `pub.dev` = Maven Central.

---

#### TS-17.2 — Design System de MultIAZ
**Estado:** ✅ Done  
**Story Points:** 8

**Evidencia presentada:**
- Paleta de colores definida con 11 tokens, validados con WCAG AA (contraste mínimo 4.5:1) en coolors.co:
  - Primary `#25C278`, Secondary `#1FA362`, Accent `#0097A7`, Dark background `#121212`, Surface `#1E1E1E`
- Tipografía Poppins con escala completa h1–h6, body, caption y button documentada.
- Spacing system base 4px (4, 8, 12, 16, 24, 32, 48px) documentado en `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`.
- Tokens implementados en Flutter: `AppColors`, `AppTypography`, `AppSpacing`, `AppTheme` en `lib/core/theme/`.
- Componentes base implementados en `lib/core/widgets/`:
  - `PrimaryButton`, `SecondaryButton`, `AppTextField`, `AppCard`, `AppBarWidget`, `BaseLayout`

**Decisiones técnicas relevantes:**
- Design tokens como **Single Source of Truth** — si cambia un color, cambia en un único archivo.
- Validación WCAG obligatoria para todos los colores interactivos.

---

#### TS-17.3 — Conexión con el Backend desde la Mobile App (Flutter)
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- `ApiClient` Singleton implementado en `lib/core/network/api_client.dart` con `Dio`, `BaseOptions` y URL del API Gateway desde variable de entorno (`String.fromEnvironment`).
- `AuthInterceptor` implementado con inyección automática de JWT en `onRequest`.
- Renovación automática de token con retry transparente en `onError` — el usuario no percibe la renovación.
- Redirección automática al login via `onLogout` callback cuando el refresh token expira.
- `NetworkException` con mensajes limpios y manejo centralizado de errores de red.

**Decisiones técnicas relevantes:**
- Patrón Singleton para el cliente HTTP — una única instancia compartida en toda la app.
- `late final` + constructor privado `_internal()` — patrón Singleton idiomático en Dart.
- URL del gateway nunca hardcodeada — gestionada mediante `String.fromEnvironment` con `defaultValue: 'http://10.0.2.2:8080'` para el emulador Android.

---

#### TS-17.4 — Inicialización del Admin Web App (React)
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- Proyecto React/TypeScript creado con Vite en `frontend/admin-web-app/` — compila y ejecuta sin errores.
- ESLint configurado con `@typescript-eslint` + `eslint-plugin-react` + `eslint-config-prettier` — sin issues sobre el proyecto base.
- Prettier configurado — formato unificado en todo el proyecto.
- Vitest configurado como framework de testing (migración desde Jest — documentado en ADR-003).
- Design system implementado como CSS variables globales en `src/styles/variables.css` (mismos tokens que Flutter).
- Estructura por feature definida: `pages/`, `components/`, `services/`, `models/`, `utils/`.
- Componentes base reutilizables implementados: `PrimaryButton`, `SecondaryButton`, `AppTextField`, `AppCard`, `Sidebar`, `PageLayout` con CSS Modules.

**Decisiones técnicas relevantes:**
- CSS variables como implementación del design system en React — mismos valores que Flutter, sintaxis diferente.
- CSS Modules para estilos encapsulados por componente — evita colisiones de nombres en proyectos grandes.
- Vitest sobre Jest por compatibilidad nativa con Vite y configuración cero (ADR-003).

**Incidencia registrada durante el sprint:**
| Error | Causa | Solución |
|-------|-------|----------|
| Jest incompatible con Vite ESM | Jest requiere transformación adicional para módulos ESM — incompatibilidad con el ecosistema Vite | Migración a Vitest (ADR-003) |

---

#### TS-17.5 — Conexión con el Backend desde el Admin Web App (React)
**Estado:** ✅ Done  
**Story Points:** 5

**Evidencia presentada:**
- `apiClient.ts` implementado con `axios.create()`, `baseURL` desde variable de entorno Vite (`import.meta.env.VITE_API_GATEWAY_URL`) y timeout configurado.
- Interceptor de request con inyección automática de JWT desde `localStorage`.
- Renovación automática de token con `refreshClient` separado y retry transparente en error 401.
- Redirección automática al login con `window.location.href` cuando el refresh token expira o es inválido.
- `NetworkError` con factory method `fromAxiosError()` y manejo centralizado de errores de red (timeout, sin conexión, errores 5xx).

**Decisiones técnicas relevantes:**
- `axios` sobre `fetch` nativo — interceptores, timeouts y manejo de errores HTTP integrados.
- `refreshClient` separado del `apiClient` principal — evita bucle infinito al renovar el token (el interceptor no se aplica a sí mismo).
- Versión pinneada `axios@1.14.0` por incidente de seguridad detectado (supply chain attack en `axios@1.14.1` — ADR-004).

**Incidencia de seguridad registrada:**
| Incidente | Descripción | Acción tomada |
|-----------|-------------|---------------|
| Supply chain attack axios | El 31/03/2026, las versiones `axios@1.14.1` y `axios@0.30.4` fueron comprometidas con un RAT multiplataforma via `plain-crypto-js@4.2.1` | Instalación pinneada en `axios@1.14.0` — decisión documentada en ADR-004 |

---

## 4. Tareas Diferidas — Estado Actualizado

| ID Tarea | Historia | Motivo original | Estado actual | Sprint/Fase destino |
|----------|----------|-----------------|---------------|---------------------|
| T-15.2.5 | TS-15.2 | Requiere esquemas reales de base de datos | Sigue diferida — sin esquemas hasta Fase 2 | Sprint 3+ |
| T-16.2.2 | TS-16.2 | Requiere tests unitarios en microservicios reales | Sigue diferida — sin microservicios hasta Fase 2 | Fase 2 |

---

## 5. Deuda Técnica Identificada

| ID | Descripción | Prioridad | Sprint destino |
|----|-------------|-----------|----------------|
| DT-004 | No existe un proceso definido para revisar y actualizar `axios` de forma controlada. Las actualizaciones deben hacerse manualmente comparando el changelog y verificando vulnerabilidades antes de cambiar la versión en `package.json`. | Alta | Sprint 3 |

> **Contexto DT-004:** Consecuencia directa de ADR-004 (version pinning). El pinning protege contra instalaciones automáticas de versiones comprometidas, pero genera la responsabilidad de revisar actualizaciones manualmente. Sin un proceso definido, la dependencia puede quedar desactualizada indefinidamente.

---

## 6. Velocidad del Equipo

| Sprint | SP Comprometidos | SP Completados | Duración real |
|--------|-----------------|----------------|---------------|
| Sprint 1 | 27 | 27 | 5 días |
| Sprint 2 | 26 | 26 | 7 días |
| **Promedio** | **26.5** | **26.5** | — |

> **Velocidad de referencia para Sprint 3: 26–27 SP.** Se establece promedio móvil de dos sprints como base de planificación.

---

## 7. Adaptaciones al Product Backlog

| Tipo | Descripción |
|------|-------------|
| Tarea diferida (mantiene) | T-15.2.5 (backups) — permanece diferida hasta Sprint 3+ |
| Tarea diferida (mantiene) | T-16.2.2 (tests en pipeline) — permanece diferida hasta Fase 2 |
| Deuda técnica nueva | DT-004 registrada — proceso de actualización controlada de `axios` |
| ADR registrado | ADR-004 — axios version pinning por supply chain attack |

---

## 8. Cierre de Fase 1

> Con el Sprint 2 completado, la **Fase 1 — Fundación** queda formalmente cerrada.

| Fase | Épicas completadas | Stories completadas | SP totales |
|------|-------------------|---------------------|------------|
| Fase 1 — Infraestructura (Sprint 1) | EP-14, EP-15, EP-16 | 8 Technical Stories | 27 SP |
| Fase 1 — Frontend (Sprint 2) | EP-17 | 5 Technical Stories | 26 SP |
| **Fase 1 Total** | **4 épicas** | **13 Technical Stories** | **53 SP** |

El sistema cuenta ahora con:
- Stack de infraestructura completo levantable con `docker-compose up`
- Mobile App Flutter con design system y capa de red lista
- Admin Web App React/TypeScript con design system y capa de red lista
- Pipeline CI/CD operativo en GitHub Actions

---

## 9. Próximos Pasos

1. **Sprint Retrospective Sprint 2** — reflexión sobre el proceso del Sprint 2 y cierre formal de Fase 1.
2. **Sprint Planning Sprint 3** — inicio de Fase 2 con desarrollo paralelo backend + frontend mobile por feature. Auth Service como primer candidato.
3. **Definir proceso DT-004** — establecer criterios para revisión y actualización controlada de `axios` durante Sprint 3.
4. **Resolver T-15.2.5** — scripts de backup automático para PostgreSQL y MongoDB con destino MinIO, una vez existan esquemas reales en Fase 2.
