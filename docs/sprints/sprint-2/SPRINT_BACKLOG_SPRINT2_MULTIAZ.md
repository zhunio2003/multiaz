# SPRINT BACKLOG — Sprint 2

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 2  
**Fase:** Fase 1 — Fundación (Frontend)  
**Fecha inicio:** 27/03/2026  
**Fecha fin:** 03/04/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

Establecer la fundación frontend completa del sistema MultIAZ: inicialización de los proyectos mobile y web, design system unificado y módulos de comunicación con el backend.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Technical Stories | 5 |
| Tareas totales | 27 |
| Story Points comprometidos | 26 |
| Horas estimadas totales | 37 h |
| Duración del sprint | 1 semana (7 días) |
| Velocidad base de referencia | 27 SP (Sprint 1) |

---

## 3. Sprint Backlog Detallado

---

### EP-17 — Fundación Frontend

---

#### TS-17.1 — Inicialización de la Mobile App (Flutter)

**Story Points:** 3  
**Horas estimadas:** 6 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-17.1.1 | Crear el proyecto Flutter base en la ruta `frontend/mobile-app/` usando el comando oficial de Flutter CLI, verificando que la estructura inicial generada compila y ejecuta sin errores. | 2 h | To Do |
| T-17.1.2 | Configurar el linter `flutter_lints` agregándolo como dependencia de desarrollo en `pubspec.yaml` y definiendo las reglas en `analysis_options.yaml`, verificando que se ejecuta sin errores ni warnings sobre el proyecto base. | 1 h | To Do |
| T-17.1.3 | Configurar el framework de testing `flutter_test` verificando que está disponible en el proyecto y escribir un test de ejemplo que ejecute exitosamente con `flutter test`. | 1 h | To Do |
| T-17.1.4 | Definir la estructura de carpetas por feature dentro de `lib/` siguiendo la convención de la industria: `screens/`, `widgets/`, `services/`, `models/` y `utils/`, con un archivo `.gitkeep` en cada carpeta vacía para que Git las rastree. | 2 h | To Do |

---

#### TS-17.2 — Design System de MultIAZ

**Story Points:** 8  
**Horas estimadas:** 10 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-17.2.1 | Definir la paleta de colores de MultIAZ: colores primario, secundario, acento, fondo, superficie, texto, éxito, error y advertencia con sus variantes para modo claro, documentados en `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`. | 3 h | To Do |
| T-17.2.2 | Definir la tipografía del sistema: familia tipográfica, tamaños para h1-h6, body, caption y button con sus pesos correspondientes, documentados en `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`. | 1 h | To Do |
| T-17.2.3 | Definir el spacing system: escala de espaciado consistente (4px, 8px, 12px, 16px, 24px, 32px, 48px) aplicable a márgenes, paddings y gaps, documentado en `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`. | 1 h | To Do |
| T-17.2.4 | Centralizar los tokens de diseño (colores, tipografía, spacing) en `ThemeData` de Flutter dentro de `lib/core/theme/`, sin hardcodear valores en los componentes. | 1 h | To Do |
| T-17.2.5 | Implementar los componentes base reutilizables en Flutter dentro de `lib/core/widgets/`: botón primario, botón secundario, campo de texto (input), card y app bar personalizada, cada uno con sus variantes (habilitado/deshabilitado/loading, con/sin error). | 2 h | To Do |
| T-17.2.6 | Implementar el layout de pantalla base en Flutter como widget reutilizable que todas las pantallas de Fase 2 usarán como estructura común. | 2 h | To Do |

---

#### TS-17.3 — Conexión con el Backend desde la Mobile App

**Story Points:** 5  
**Horas estimadas:** 7 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-17.3.1 | Agregar el paquete `dio` como dependencia en `pubspec.yaml` y crear el servicio HTTP centralizado en `lib/core/network/api_client.dart` configurado para dirigir todas las peticiones al API Gateway como punto de entrada único, con la URL base obtenida desde la configuración de la app. | 2 h | To Do |
| T-17.3.2 | Configurar el interceptor de autenticación en `api_client.dart` para agregar automáticamente el token JWT en el header `Authorization` de cada petición autenticada. | 2 h | To Do |
| T-17.3.3 | Implementar la lógica de renovación automática de token: si una petición recibe error 401, el interceptor intenta renovar el token usando el refresh token antes de reintentar la petición original. | 1 h | To Do |
| T-17.3.4 | Implementar la redirección automática al login cuando el refresh token ha expirado o es inválido, desacoplada del interceptor mediante un callback o evento. | 1 h | To Do |
| T-17.3.5 | Implementar el manejo centralizado de errores de red (timeout, sin conexión, errores 5xx) con mensajes claros al usuario sin exponer detalles técnicos. | 1 h | To Do |

---

#### TS-17.4 — Inicialización del Admin Web App (React)

**Story Points:** 5  
**Horas estimadas:** 9 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-17.4.1 | Crear el proyecto React con TypeScript en la ruta `frontend/admin-web-app/` del monorepo usando Vite como bundler con el template oficial `react-ts`, verificando que compila y ejecuta sin errores. | 3 h | To Do |
| T-17.4.2 | Configurar ESLint con las reglas recomendadas para React + TypeScript agregando los plugins `@typescript-eslint` y `eslint-plugin-react`, verificando que se ejecuta sin errores ni warnings sobre el proyecto base. | 1 h | To Do |
| T-17.4.3 | Configurar Prettier definiendo las reglas en `.prettierrc` e integrándolo con ESLint mediante `eslint-config-prettier` para evitar conflictos entre ambas herramientas. | 1 h | To Do |
| T-17.4.4 | Configurar Jest + React Testing Library e implementar un test de ejemplo que ejecute exitosamente con `npm test`. | 1 h | To Do |
| T-17.4.5 | Definir la estructura de carpetas por feature dentro de `src/`: `pages/`, `components/`, `services/`, `models/` y `utils/`, con un archivo `.gitkeep` en cada carpeta vacía. | 2 h | To Do |
| T-17.4.6 | Implementar los tokens de diseño de TS-17.2 como CSS variables en un archivo `src/core/theme/variables.css` siguiendo la documentación de `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`. | 1 h | To Do |
| T-17.4.7 | Implementar los componentes base reutilizables en React dentro de `src/core/components/`: botón primario, botón secundario, campo de texto, card, sidebar de navegación y layout de página base. | 1 h | To Do |

---

#### TS-17.5 — Conexión con el Backend desde el Admin Web App

**Story Points:** 5  
**Horas estimadas:** 5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-17.5.1 | Agregar el paquete `axios` como dependencia en `package.json` y crear el servicio HTTP centralizado en `src/core/network/apiClient.ts` configurado para dirigir todas las peticiones al API Gateway como punto de entrada único, con la URL base obtenida desde variables de entorno del proyecto (`.env`). | 1 h | To Do |
| T-17.5.2 | Configurar el interceptor de autenticación en `apiClient.ts` para agregar automáticamente el token JWT en el header `Authorization` de cada petición autenticada. | 1 h | To Do |
| T-17.5.3 | Implementar la lógica de renovación automática de token: si una petición recibe error 401, el interceptor intenta renovar el token usando el refresh token antes de reintentar la petición original. | 1 h | To Do |
| T-17.5.4 | Implementar la redirección automática al login cuando el refresh token ha expirado o es inválido, usando React Router para la navegación. | 1 h | To Do |
| T-17.5.5 | Implementar el manejo centralizado de errores de red (timeout, sin conexión, errores 5xx) con mensajes claros al usuario sin exponer detalles técnicos. | 1 h | To Do |

---

## 4. Resumen por Technical Story

| ID | Nombre | Épica | SP | Horas Est. | Tareas |
|----|--------|-------|----|------------|--------|
| TS-17.1 | Inicialización de la Mobile App (Flutter) | EP-17 | 3 | 6 h | 4 |
| TS-17.2 | Design System de MultIAZ | EP-17 | 8 | 10 h | 6 |
| TS-17.3 | Conexión con el Backend desde la Mobile App | EP-17 | 5 | 7 h | 5 |
| TS-17.4 | Inicialización del Admin Web App (React) | EP-17 | 5 | 9 h | 7 |
| TS-17.5 | Conexión con el Backend desde el Admin Web App | EP-17 | 5 | 5 h | 5 |
| **Total** | | | **26** | **37 h** | **27** |

---

## 5. Orden de Ejecución

| Orden | ID | Historia | Justificación |
|-------|----|----------|---------------|
| 1 | TS-17.1 | Inicialización Mobile App | Base del proyecto Flutter — bloquea TS-17.2 (implementación en código) |
| 2 | TS-17.2 | Design System | Define tokens y componentes base — bloquea TS-17.3, TS-17.4 y TS-17.5 |
| 3 | TS-17.4 | Inicialización Admin Web App | Requiere TS-17.2 completa para implementar design system en React |
| 4 | TS-17.3 | Conexión Backend Mobile App | Requiere TS-17.2 completa (componentes de error y feedback visual) |
| 5 | TS-17.5 | Conexión Backend Admin Web App | Requiere TS-17.4 completa |

---

## 6. Tareas Diferidas

| ID | Descripción | Motivo | Sprint Destino |
|----|-------------|--------|----------------|
| T-15.2.5 | Backups automáticos PostgreSQL y MongoDB → MinIO | Bloqueado: no existen esquemas reales de base de datos todavía | Sprint 3+ |
| T-16.2.2 | Pipeline CI/CD: ejecución de pruebas automatizadas | Bloqueado: no existen microservicios reales con pruebas que correr | Fase 2 |

---

## 7. Notas

- Sprint 2 cierra completamente la **Fase 1 — Fundación**, incluyendo la fundación frontend (EP-17).
- La velocidad base de referencia es 27 SP (Sprint 1). Se comprometieron 26 SP de forma conservadora al ser el segundo sprint.
- TS-17.4 y TS-17.5 (Admin Web App) se incluyeron en este sprint para cerrar Fase 1 completamente y evitar deuda cognitiva entre fases, aunque su dependencia directa es con Fase 3.
- A partir del Sprint 3 se inicia **Fase 2 — Experiencia del Usuario**, con desarrollo paralelo backend + frontend mobile por feature.
