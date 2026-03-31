# ADR-003 — MIGRAR DE JEST A VITEST COMO FRAMEWORK DE TESTING EN EL ADMIN WEB APP EN LA HISTORIA TS 17.4

**Fecha:** 31 de Marzo del 2026
**Estado:** Aceptado

---

## Contexto  

Durante la implementación de T-17.4.4 (Configurar Jest + React Testing Library) del Sprint 2, se intentó configurar Jest como framework de testing para el proyecto admin-web-app basado en Vite + React + TypeScript. La configuración encontró múltiples incompatibilidades técnicas no resolubles de forma simple:

verbatimModuleSyntax: La opción verbatimModuleSyntax: true definida en tsconfig.app.json de Vite es incompatible con la forma en que Jest procesa módulos CommonJS, generando errores de importación en los archivos de test.
JSX no reconocido: ts-jest no detecta automáticamente la configuración de JSX del proyecto, requiriendo un tsconfig separado exclusivo para Jest.
Módulos ESM: Jest tiene soporte limitado para ES Modules nativos, ecosistema que Vite usa por defecto.

Estas incompatibilidades requieren configuración adicional compleja y propensa a errores para un stack que Vitest resuelve de forma nativa.

---

## Decisión

Se reemplaza Jest por Vitest como framework de testing en frontend/admin-web-app/. React Testing Library (@testing-library/react) y sus matchers DOM (@testing-library/jest-dom) se mantienen, ya que son independientes del framework de testing.
Vitest está construido sobre Vite, comparte su configuración (vite.config.ts) y entiende de forma nativa TypeScript, JSX y ES Modules sin configuración adicional. La API de Vitest es compatible con Jest (describe, it, expect), por lo que los tests escritos en Vitest son prácticamente idénticos a los de Jest.
La configuración de Vitest se centraliza en vite.config.ts con las opciones globals: true, environment: 'jsdom' y setupFiles: ['@testing-library/jest-dom'].

---

## Consecuencias

### Positivas
 
- Eliminación de incompatibilidades con el stack Vite + TypeScript + ESM sin configuración adicional.
- Un único archivo de configuración (`vite.config.ts`) para bundling y testing — menos archivos de configuración que mantener.
- HMR en modo watch de tests: Vitest detecta cambios y re-ejecuta solo los tests afectados, al igual que Vite en desarrollo.
- API compatible con Jest: los patrones de testing (`describe`, `it`, `expect`) son los mismos, sin curva de aprendizaje adicional.
 
### Negativas
 
- El Sprint Backlog (T-17.4.4) especificaba explícitamente Jest + React Testing Library. Esta decisión se desvía del backlog original y debe ser registrada como cambio técnico justificado.
- Vitest es una herramienta más reciente que Jest — en proyectos con equipos grandes que ya usan Jest, esta migración requeriría consenso del equipo.