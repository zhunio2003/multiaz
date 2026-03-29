# Design System — MultIAZ

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Versión:** 1.0  
**Autor:** Miguel Angel Zhunio Remache  
**Fecha:** 29/03/2026  

---

## 1. Principios de Diseño

MultIAZ es una plataforma de predicciones especializadas con IA dirigida a dos perfiles: usuarios no técnicos que necesitan confianza y claridad, y empresas que requieren profesionalismo y precisión técnica. El sistema visual refleja estos valores: **seriedad, tecnología y confianza**.

- **Dark mode:** Fondo oscuro como base. Transmite profesionalismo y seriedad.
- **Verde esmeralda como primario:** Diferenciación de marca. Simboliza verdad, precisión y datos reales — cualidades centrales de las predicciones de MultIAZ.
- **Cyan oscuro como acento:** Refuerza la identidad tecnológica con distancia visual suficiente del primario.
- **Accesibilidad primero:** Todos los colores interactivos y de texto cumplen mínimo WCAG AA (4.5:1).

---

## 2. Paleta de Colores — Modo Oscuro

### 2.1 Colores de Marca

#### `primary` — Verde Esmeralda
- **Hex:** `#25C278`
- **Uso:** Botones de acción principal, links activos, elementos interactivos destacados, indicadores de éxito.
- **Contraste vs `background`:** 8.09:1 — WCAG AAA ✅

#### `secondary` — Verde Esmeralda Oscuro
- **Hex:** `#1FA362`
- **Uso:** Estado hover y pressed del botón primario, acciones secundarias, bordes activos.
- **Contraste vs `background`:** 5.77:1 — WCAG AA ✅

#### `accent` — Cyan Oscuro
- **Hex:** `#0097A7`
- **Uso:** Badges, highlights de datos, iconos especiales, detalles de énfasis. Usar con moderación — máximo 10% de la interfaz.
- **Contraste vs `background`:** 8.00:1 — WCAG AAA ✅

---

### 2.2 Colores de Fondo y Superficie

#### `background` — Onyx
- **Hex:** `#121212`
- **Uso:** Fondo general de todas las pantallas de la aplicación.

#### `surface` — Carbon Black
- **Hex:** `#1E1E1E`
- **Uso:** Fondo de cards, modales, drawers, bottom sheets. Crea la percepción visual de capas flotando sobre el fondo.

---

### 2.3 Colores de Texto

#### `onPrimary` — Negro
- **Hex:** `#000000`
- **Uso:** Texto e iconos que aparecen encima del color `primary` (#25C278). Por ejemplo, el label de un botón verde.
- **Contraste vs `primary`:** Alto ✅ (el primario es claro, requiere texto oscuro)

#### `onBackground` — Blanco
- **Hex:** `#FFFFFF`
- **Uso:** Texto principal sobre `background` y `surface`.
- **Contraste vs `background`:** 18.10:1 — WCAG AAA ✅

#### `onSurface` — Gris Claro
- **Hex:** `#E0E0E0`
- **Uso:** Texto secundario, subtítulos, labels de menor jerarquía sobre `surface`.
- **Contraste vs `background`:** 13.10:1 — WCAG AAA ✅

---

### 2.4 Colores Semánticos

#### `success` — Verde Esmeralda
- **Hex:** `#25C278`
- **Uso:** Mensajes de éxito, predicciones completadas, estados positivos. Comparte valor con `primary` — refuerza coherencia visual.
- **Contraste vs `background`:** 8.09:1 — WCAG AAA ✅

#### `error` — Rojo Material
- **Hex:** `#F44336`
- **Uso:** Mensajes de error, validaciones fallidas, estados críticos. Su naturaleza agresiva es intencional — los errores deben llamar la atención inmediatamente.
- **Contraste vs `background`:** 5.09:1 — WCAG AA ✅

#### `warning` — Amber
- **Hex:** `#FFC107`
- **Uso:** Advertencias, alertas de baja prioridad, estados que requieren atención pero no son críticos.
- **Contraste vs `background`:** 11.49:1 — WCAG AAA ✅

---

### 2.5 Resumen de la Paleta

| Token | Hex | Contraste vs #121212 | WCAG |
|-------|-----|----------------------|------|
| `primary` | `#25C278` | 8.09:1 | AAA ✅ |
| `secondary` | `#1FA362` | 5.77:1 | AA ✅ |
| `accent` | `#0097A7` | 8.00:1 | AAA ✅ |
| `background` | `#121212` | — | — |
| `surface` | `#1E1E1E` | — | — |
| `onPrimary` | `#000000` | — | — |
| `onBackground` | `#FFFFFF` | 18.10:1 | AAA ✅ |
| `onSurface` | `#E0E0E0` | 13.10:1 | AAA ✅ |
| `success` | `#25C278` | 8.09:1 | AAA ✅ |
| `error` | `#F44336` | 5.09:1 | AA ✅ |
| `warning` | `#FFC107` | 11.49:1 | AAA ✅ |

---

## 3. Tipografía

### 3.1 Familia Tipográfica

| Propiedad | Valor |
|-----------|-------|
| **Fuente** | Poppins |
| **Tipo** | Sans-serif geométrica |
| **Origen** | Google Fonts |
| **Justificación** | Equilibra la accesibilidad para usuarios no técnicos (Marta) con el profesionalismo requerido por usuarios empresariales (Pichincha). Su geometría limpia refuerza la identidad tecnológica de MultIAZ. |

---

### 3.2 Escala Tipográfica

| Elemento | Tamaño | Weight | Uso |
|----------|--------|--------|-----|
| `h1` | 32px | Bold (700) | Títulos de pantalla principal |
| `h2` | 28px | Bold (700) | Títulos de sección mayor |
| `h3` | 24px | SemiBold (600) | Subtítulos de sección |
| `h4` | 20px | SemiBold (600) | Títulos de cards y modales |
| `h5` | 18px | Medium (500) | Labels de grupo, encabezados menores |
| `h6` | 16px | Medium (500) | Labels de campo, subtítulos de card |
| `body` | 14px | Regular (400) | Texto de contenido general |
| `caption` | 12px | Regular (400) | Texto auxiliar, notas, timestamps |
| `button` | 14px | SemiBold (600) | Labels de botones y acciones |

---

### 3.3 Reglas de Uso Tipográfico

- Nunca usar más de 3 niveles de jerarquía tipográfica en una misma pantalla.
- El peso `Regular (400)` es exclusivo para contenido de lectura — nunca para acciones.
- El peso `SemiBold (600)` es el mínimo para cualquier elemento interactivo.
- El tamaño mínimo de texto visible en la app es `12px` (`caption`).

---

## 4. Spacing System

### 4.1 Escala de Espaciado

El sistema usa una base de **4px** con incrementos consistentes. Todos los márgenes, paddings y gaps deben usar exclusivamente estos valores.

| Token | Valor | Uso principal |
|-------|-------|---------------|
| `spacing-1` | 4px | Separación mínima entre elementos relacionados (icono + texto) |
| `spacing-2` | 8px | Padding interno de chips, badges, tags |
| `spacing-3` | 12px | Separación entre elementos de un mismo grupo |
| `spacing-4` | 16px | Padding interno de cards y botones — unidad base de layout |
| `spacing-6` | 24px | Separación entre secciones dentro de una pantalla |
| `spacing-8` | 32px | Margen horizontal de la pantalla (padding lateral general) |
| `spacing-12` | 48px | Separación entre secciones mayores, espaciado vertical entre cards |

---

### 4.2 Reglas de Uso del Spacing

- **Nunca hardcodear valores** — siempre usar los tokens definidos en esta escala.
- El padding lateral estándar de toda pantalla es `spacing-8` (32px).
- La separación mínima entre dos elementos interactivos (botones) es `spacing-4` (16px) para evitar toques accidentales.
- El gap entre cards en un listado es `spacing-3` (12px).
- Elementos dentro de una misma card usan `spacing-2` (8px) entre sí.

---

## 5. Reglas de Uso Generales

- El `accent` nunca debe usarse como fondo de botones grandes — solo en elementos pequeños.
- El `primary` y el `accent` nunca deben aparecer adyacentes sin separación visual.
- El `error` no se suaviza — su intensidad es parte de su función semántica.
- Todos los textos interactivos deben usar colores de la paleta validados contra su fondo correspondiente.
- Ningún valor de color, fuente o espaciado debe hardcodearse en los componentes — siempre referenciar los tokens definidos en este documento.