# ADR-007 — Adopción de react-router 8 para la navegación del Admin Web App

**Fecha:** 10 de Noviembre del 2026
**Estado:** Aceptado

---

## Contexto

El Admin Web App tenía una sola pantalla visible a la vez, elegida con un `if` en `App.tsx` (login o dashboard).
El panel necesita **8 módulos** (Dashboard, Modelos, Datasets, Entrenamiento, Predicciones, Usuarios, Logs y Configuración), según la arquitectura (sección 6.1) y las épicas EP-08 a EP-13. Además requiere:

- URLs propias por módulo (`/modelos`, `/usuarios`…) para compartir enlaces, recargar y usar el botón "atrás".
- Rutas privadas: sin sesión, redirigir al login y volver a la página pedida después de entrar.
- Un layout común (sidebar) que no se vuelva a montar al cambiar de página.
- Una página 404 y un manejo de errores de render.

Hasta ahora el proyecto evitó dependencias nuevas (ADR-006). Un router a mano (escuchar `popstate`, comparar rutas, anidar layouts, restaurar el scroll) es justo el tipo de problema **difícil de hacer bien** que conviene delegar a una librería.

---

## Decisión

Adoptar **react-router `8.5.1`**, con versión fijada exacta (`--save-exact`), usando el modo de datos (`createBrowserRouter` + `RouterProvider`).

- Rutas anidadas: `RequireAuth` (guardia) → `AppShell` (layout con `<Outlet />`) → la página.
- `NavLink` en el sidebar: marca solo el enlace activo con `aria-current="page"`.
- Las rutas de los módulos se generan desde `src/core/navigation.ts`, la misma lista que usa el menú (fuente única de verdad).
- La sesión pasa a un **Context** (`AuthProvider` / `useAuth`), porque la necesitan el guardia, el login y el layout.

---

## Alternativas consideradas

### A — Router hecho a mano
- ✅ Cero dependencias.
- ❌ Hay que reimplementar historial, rutas anidadas, parámetros, redirecciones, restauración de scroll y errores. Mucho código propio y fácil de hacer mal.

### B — react-router 7.18.5 (rama anterior)
- ✅ Muy probada, con abundante documentación.
- ❌ La rama 8 es estable desde junio de 2026 y la API que usamos es la misma. Empezar un proyecto nuevo en una versión mayor anterior suma una migración futura sin beneficio.

### C — TanStack Router
- ✅ Tipado de rutas muy fuerte.
- ❌ El ecosistema TanStack sufrió el compromiso del 11 de mayo de 2026 (CVE-2026-45321, ver ADR-006). Además es menos conocido y tiene más curva de aprendizaje para este proyecto.

---

## Verificación de seguridad (política ADR-006)

| Control | Resultado |
|---|---|
| Antigüedad mínima de 7 días (`minimumReleaseAge`) | `8.5.1` publicada el 27/10/2026 ✅ |
| Versión fijada exacta | `"react-router": "8.5.1"` (sin `^`) ✅ |
| Dependencias transitivas | 2 (`cookie-es`, `@remix-run/route-pattern`) |
| Requisitos | React ≥ 19.2.7 (tenemos 19.3.1) y Node ≥ 22.22 (tenemos 24) ✅ |

---

## Consecuencias

### Positivas
- El menú navega de verdad, sin recargar la página, y cada módulo tiene su URL.
- El guardia de rutas y la vuelta a la página pedida tras el login funcionan con muy poco código.
- Agregar un módulo nuevo = agregar un objeto en `navigation.ts`.

### Negativas
- Una dependencia más que vigilar y actualizar.
- **En producción**, el servidor web debe responder `index.html` para cualquier ruta (*SPA fallback*). Si no, recargar en `/modelos` da un 404 del servidor. Ejemplo en nginx: `try_files $uri /index.html;`. En desarrollo, Vite ya lo hace.
- La sesión sigue en memoria: al recargar se pierde (salvo con el atajo de desarrollo). Se resolverá con TS-17.5 (tokens).
