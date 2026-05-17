# ADR-006: Migración de npm a pnpm con política de seguridad supply chain reforzada

**Fecha:** 2026-05-16  
**Estado:** Aceptado  
**Autor:** MiguelAngel Zhunio Remache

---
## Context

### Situación actual del proyecto

MultIAZ es un proyecto de portfolio orientado a entrevistas técnicas que incluye un cliente web administrativo (`frontend/admin-web-app/`) construido con **React 19.2 + Vite 8 + TypeScript 5.9**, donde se utilizaba `npm` como gestor de paquetes por defecto.

Dado que el proyecto está orientado a demostrar criterio profesional senior frente a reclutadores técnicos, la seguridad de la cadena de suministro de dependencias (supply chain security) constituye un punto de evaluación crítico que debe abordarse con decisiones documentadas y defensibles.

### El problema del ecosistema npm (2025–2026)

Durante el período septiembre 2025 — mayo 2026 se ha registrado una escalada sin precedentes de ataques contra el ecosistema npm. A diferencia de los incidentes históricos aislados, las campañas recientes presentan tres características nuevas: **auto-propagación tipo gusano** (worm-like behavior), **uso de credenciales legítimas vía compromiso de OIDC tokens**, y **publicación con SLSA Build Level 3 attestations válidas**, lo que vuelve inválidas las defensas tradicionales basadas en verificación de procedencia.

Cronología verificada de incidentes relevantes:

| Fecha | Incidente | Impacto |
|-------|-----------|---------|
| **Septiembre 2025** | Worm Shai-Hulud original | Primer caso de malware auto-replicante en npm |
| **Marzo 2026** | Compromiso de Trivy (Aqua Security) | Herramienta de seguridad atacada por TeamPCP |
| **31 marzo 2026** | Compromiso de axios `1.14.1` y `0.30.4` | Inyección de `plain-crypto-js@4.2.1` con RAT — **base del ADR-004** |
| **22 abril 2026** | Bitwarden CLI `@bitwarden/cli@2026.4.0` | Suplantación de gestor de contraseñas, robo de credenciales cloud |
| **29 abril 2026** | Mini Shai-Hulud — paquetes SAP | 4 paquetes oficiales SAP comprometidos con preinstall hook malicioso |
| **11 mayo 2026** | TanStack — 42 paquetes, 84 versiones | Primer ataque con SLSA Build L3 attestation válida — CVE-2026-45321 |
| **14 mayo 2026** | node-ipc `9.1.6`, `9.2.3`, `12.0.1` | Librería con 10M descargas semanales comprometida |

Patrón común: **scripts de instalación (`preinstall`, `postinstall`) ejecutándose automáticamente durante `npm install`** y robando credenciales de GitHub, npm, AWS, GCP, Azure, Kubernetes y Vault.

### Recomendaciones oficiales

El **20 de abril de 2026**, CISA (Cybersecurity and Infrastructure Security Agency, EE.UU.) emitió la alerta sobre el compromiso de axios recomendando explícitamente:

1. Configurar `ignore-scripts=true` en `.npmrc` para prevenir ejecución de scripts post-install.
2. Configurar `min-release-age=7` para evitar instalar paquetes recién publicados.
3. Pinear versiones de dependencias críticas a versiones conocidas como seguras.
4. Auditar repositorios, pipelines CI/CD y máquinas de desarrollo donde se haya ejecutado `npm install`.
5. Rotar credenciales potencialmente comprometidas.

### Por qué importa para MultIAZ

Este proyecto se construye sobre el principio de **buenas prácticas demostrables**. Mantener `npm` con configuración por defecto en mayo de 2026 — con el contexto de amenazas activas y recomendaciones oficiales de CISA — representa una decisión técnica indefendible frente a un reclutador técnico senior. La adopción de un gestor con protecciones nativas más estrictas (pnpm) constituye una decisión informada y alineada con el estado actual de la industria.

## Decision Drivers

Los siguientes factores fueron evaluados en orden de prioridad:

1. **Seguridad supply chain** *(prioridad máxima)* — capacidad nativa del gestor para prevenir ejecución de código malicioso durante la instalación.
2. **Integridad de builds reproducibles** — robustez del lockfile y verificación criptográfica de paquetes.
3. **Aislamiento de dependencias** — prevención de phantom dependencies (paquetes accesibles sin estar declarados).
4. **Performance de instalación** — tiempo de instalación en local y CI/CD.
5. **Eficiencia de almacenamiento** — uso de espacio en disco mediante store global compartido.
6. **Compatibilidad con el stack actual** — soporte nativo de React 19, Vite 8, TypeScript 5.9.
7. **Madurez y soporte** — adopción industrial, frecuencia de releases, calidad de documentación.

## Considered Options

### Opción 1 — Mantener npm con `.npmrc` reforzado

**Pros:**
- Cero cambios en tooling existente.
- Comando familiar para cualquier desarrollador JavaScript.
- Default de Node.js, no requiere instalación adicional.

**Contras:**
- Lockfile (`package-lock.json`) menos estricto que pnpm en verificación de integridad.
- Sin store global: cada proyecto duplica `node_modules` en disco.
- Estructura `node_modules` flat permite **phantom dependencies** — un vector de ataque conocido.
- Configuración de seguridad debe construirse manualmente a partir de defaults inseguros.
- Sin protección nativa contra resolución de paquetes recién publicados (requiere flag manual `min-release-age`).
- Históricamente ha sido el blanco principal de los ataques recientes (todos los incidentes listados ocurrieron en npm).

### Opción 2 — Migrar a Yarn (v4 Berry)

**Pros:**
- Lockfile (`yarn.lock`) estricto con checksums.
- Plug'n'Play (PnP) opcional: elimina `node_modules` completamente.
- Workspaces nativos potentes para monorepos.

**Contras:**
- Ecosistema dividido entre Yarn Classic (v1) y Yarn Berry (v2+) genera confusión.
- Menor adopción reciente — pnpm ha tomado el liderazgo en proyectos nuevos.
- Plug'n'Play tiene incompatibilidades con algunas herramientas del ecosistema React.
- Curva de aprendizaje mayor que pnpm para alguien viniendo de npm.

### Opción 3 — Migrar a pnpm ← **DECISIÓN**

**Pros:**
- **Estructura no-flat de `node_modules`** mediante symlinks: previene phantom dependencies por diseño.
- **Store global con deduplicación**: ahorra espacio significativo y centraliza verificación.
- **Lockfile `pnpm-lock.yaml` con checksums SHA512** por paquete: detecta tampering criptográficamente.
- **`min-release-age` nativo desde v9**: protección temporal contra paquetes recién publicados.
- **`onlyBuiltDependencies` desde v10**: lista blanca explícita de paquetes autorizados a ejecutar scripts.
- **Verificación de provenance attestations por defecto**.
- **Performance**: hasta 3x más rápido que npm en instalaciones limpias.
- **Compatibilidad nativa** con React 19, Vite 8, TypeScript 5.9.
- **Adopción creciente**: utilizado por Vercel, TanStack (irónicamente), Vite, y la mayoría de proyectos modernos.

**Contras:**
- Comandos distintos a aprender (`pnpm install` vs `npm install`).
- Requiere actualización del pipeline CI/CD (GitHub Actions).
- Menor cantidad de tutoriales que npm (aunque suficiente).
- Algunos paquetes mal escritos asumen estructura flat de npm (raro, pero documentado).

### Opción 4 — Migrar a Bun

**Pros:**
- Extremadamente rápido (significativamente más que pnpm).
- Gestor + runtime + bundler todo-en-uno.
- API moderna y experiencia de desarrollador pulida.

**Contras:**
- **Menor madurez**: proyecto reciente, todavía evolucionando rápidamente.
- **Soporte de herramientas limitado**: algunas herramientas del ecosistema no funcionan correctamente.
- **Riesgo de cambios breaking** entre versiones.
- **No probado a escala en producción** en organizaciones grandes.
- **Para un proyecto de portfolio**: presentar Bun puede leerse como elección "hype-driven" en lugar de criterio maduro.

## Decision

Se adopta **pnpm** como gestor de paquetes oficial para todos los proyectos Node.js dentro del monorepo MultIAZ, configurado con políticas de seguridad reforzadas en `.npmrc` siguiendo las recomendaciones de CISA y el aprendizaje del ADR-004 sobre el incidente axios.

Esta política aplica a:
- `frontend/admin-web-app/` (alcance actual).
- Cualquier proyecto Node.js que se incorpore al monorepo en el futuro.

**No aplica a:**
- `frontend/mobile-app/` (Flutter — usa `pub`).
- `backend/core/*` (Java — usa Maven).
- `backend/ia-services/*` (Python — usa `pip`).

## Rationale

La elección de pnpm sobre las alternativas se justifica por cinco argumentos técnicos concretos:

### 1. Seguridad arquitectónica por diseño

La estructura no-flat de `node_modules` que utiliza pnpm — basada en un store global con symlinks aislados por proyecto — previene **phantom dependencies** estructuralmente. Una phantom dependency ocurre cuando código accede a un paquete que no está declarado en `package.json` pero es alcanzable porque otra dependencia lo introdujo transitivamente. Este patrón es un vector conocido en ataques supply chain: un atacante introduce un paquete malicioso como dependencia transitiva, sabiendo que el código víctima lo usará sin haberlo declarado explícitamente.

npm con su `node_modules` flat permite este patrón por defecto. pnpm lo bloquea por construcción.

### 2. Lockfile criptográficamente robusto

`pnpm-lock.yaml` incluye **checksums SHA512** para cada paquete y cada versión. Si un atacante consigue publicar una versión maliciosa con el mismo número de versión (caso real en algunas variantes del ataque Shai-Hulud), pnpm detecta el cambio de hash al resolver. `package-lock.json` de npm también incluye hashes (SHA1/SHA512), pero la implementación histórica ha sido inconsistente.

### 3. Protecciones nativas alineadas con CISA

Las recomendaciones específicas de CISA (`ignore-scripts=true`, `min-release-age=7`) tienen soporte nativo y maduro en pnpm. En particular, `onlyBuiltDependencies` permite construir una **lista blanca explícita** de paquetes autorizados a ejecutar scripts post-install — funcionalidad superior al simple `ignore-scripts` de npm porque permite excepciones controladas (necesarias para paquetes legítimos como `esbuild` o `@swc/core`).

### 4. Alineación con el ADR-004

El ADR-004 estableció que axios debe permanecer pineado en `1.14.0` debido al incidente del 31 de marzo de 2026. La filosofía detrás del ADR-004 — pinning estricto, desconfianza por defecto, decisiones informadas — se generaliza naturalmente con la adopción de pnpm. Mientras que `npm` permite resolución laxa por defecto, pnpm con la configuración propuesta hace de la **estrictez la postura por defecto**.

### 5. Compatibilidad probada con el stack actual

pnpm es utilizado nativamente por Vite (uno de los principales bundlers JavaScript), funciona correctamente con React 19, y tiene soporte de primera clase para TypeScript. No se identifican incompatibilidades técnicas con el stack actual de MultIAZ.

## Consequences

### Positive

- **Reducción drástica de superficie de ataque** contra supply chain.
- **Lockfile más estricto** → builds más reproducibles entre máquinas y entornos.
- **Mejor performance de CI/CD** (instalaciones más rápidas, menor tiempo de pipeline).
- **Ahorro de espacio en disco** mediante store global compartido.
- **Demostración pública de criterio senior** en seguridad — punto a favor en evaluaciones técnicas externas.
- **Alineación con tendencia industrial** (Vercel, Next.js team, Vite, mayoría de proyectos modernos usan pnpm).

### Negative

- **Curva de aprendizaje**: comandos distintos (`pnpm install`, `pnpm add`, `pnpm dlx` en lugar de `npx`).
- **Actualización requerida del pipeline CI/CD** (GitHub Actions debe usar `pnpm/action-setup@v4`).
- **Actualización requerida del README** y documentación de onboarding.
- **Posible fricción inicial** con paquetes que asumen estructura flat (raro, pero requiere atención).
- **Si en el futuro se incorpora un desarrollador junior**, debe aprender pnpm específicamente.
- **Configuración `.npmrc` estricta** generará errores de instalación que requieren resolución manual los primeros días.

### Neutral

- Cambio de archivo de lockfile: `package-lock.json` → `pnpm-lock.yaml` (debe commitearse, igual que el anterior).
- Ajuste de `.gitignore` para mantener consistencia.
- Docker (cuando aplique a la imagen del frontend) requiere imagen base con pnpm preinstalado o instalación vía `corepack`.
- Comandos de scripts en `package.json` no cambian (`pnpm run dev` ejecuta los mismos scripts que `npm run dev`).

## Implementation

### Pasos de migración

1. **Limpiar estado previo en `frontend/admin-web-app/`:**
   - Eliminar `node_modules/` (si existe).
   - Eliminar `package-lock.json` (si existe).

2. **Crear `.npmrc`** en `frontend/admin-web-app/` con la política de seguridad definida en la sección [Security Configuration](#security-configuration).

3. **Instalar pnpm globalmente** (si no está disponible):
   ```bash
   corepack enable
   corepack prepare pnpm@latest --activate
   ```
   > Nota: `corepack` viene incluido con Node.js 16.10+ y es la forma oficial recomendada por Node.js de gestionar gestores de paquetes alternativos.

4. **Regenerar dependencias:**
   ```bash
   cd frontend/admin-web-app
   pnpm install
   ```

5. **Verificar generación de `pnpm-lock.yaml`** y ausencia de `package-lock.json`.

6. **Actualizar `.gitignore`** del proyecto:
   - Confirmar que `node_modules/` está ignorado.
   - Confirmar que `pnpm-lock.yaml` **NO** está ignorado (debe versionarse).
   - Si existe entrada para `package-lock.json` permitirlo o no, según política — el lockfile no debe estar presente en este proyecto.

7. **Actualizar pipeline CI/CD** en `.github/workflows/` para usar `pnpm/action-setup@v4` y `pnpm install --frozen-lockfile`.

8. **Actualizar README principal** y README del proyecto frontend con las nuevas instrucciones:
   ```bash
   # Antes
   npm install
   npm run dev
   
   # Ahora
   pnpm install
   pnpm dev
   ```

9. **Documentar comandos equivalentes** en la sección de desarrollo del README.

### Security Configuration

Contenido del archivo `frontend/admin-web-app/.npmrc`:

```ini
# .npmrc — Política de seguridad supply chain (ADR-006)
# Versión reforzada post-Mini Shai-Hulud (mayo 2026)
# Referencia: docs/adr/ADR-006-MIGRATE-NPM-TO-PNPM-SUPPLY-CHAIN-SECURITY.md

# === Capa 1: Prevención de ejecución maliciosa ===
# Bloquea scripts pre/post-install — vector principal de ataque en Mini Shai-Hulud
ignore-scripts=true
# Lista blanca explícita de paquetes autorizados a ejecutar build scripts
onlyBuiltDependencies=[]

# === Capa 2: Control temporal de paquetes ===
# CISA: solo instalar paquetes con al menos 7 días de antigüedad
# Previene ataques zero-day como node-ipc (14 mayo 2026)
min-release-age=7

# === Capa 3: Integridad criptográfica ===
# Verifica checksums SHA512 contra el store global pnpm
verify-store-integrity=true

# === Capa 4: Control estricto de dependencias ===
# Falla si hay peer dependencies no resueltas
strict-peer-dependencies=true
# No instalar peer dependencies automáticamente — control manual explícito
auto-install-peers=false

# === Capa 5: Reproducibilidad de builds ===
# Garantizar presencia obligatoria de lockfile
lockfile=true
# Estructura no-flat de node_modules (previene phantom dependencies)
node-linker=isolated

# === Capa 6: Higiene de runtime ===
# Validar que la versión de Node coincide con engines en package.json
engine-strict=true
```

### Configuración complementaria en CI/CD

En el pipeline de GitHub Actions, agregar el flag `--frozen-lockfile` al comando de instalación:

```yaml
- name: Setup pnpm
  uses: pnpm/action-setup@v4
  with:
    version: 10

- name: Install dependencies
  run: pnpm install --frozen-lockfile
```

El flag `--frozen-lockfile` falla el build si el lockfile no coincide exactamente con `package.json`, previniendo que un PR malicioso modifique versiones sin actualizar el lockfile.

### Lista blanca de scripts (mantenimiento esperado)

La configuración `ignore-scripts=true` combinada con `onlyBuiltDependencies=[]` bloqueará la ejecución de scripts en TODOS los paquetes por defecto. Algunos paquetes legítimos requieren build scripts para funcionar (ej: `esbuild`, `@swc/core`, `sharp`). Cuando aparezcan errores relacionados, agregar el paquete específico a la lista blanca:

```ini
onlyBuiltDependencies=[esbuild, @swc/core]
```

Cada incorporación a esta lista debe ser **revisada y justificada** antes de agregarse. Esto es trabajo de mantenimiento esperado y constituye una **decisión consciente** sobre qué scripts ejecutar.

## References

### Incidentes de seguridad citados

- CISA Advisory — Compromiso de axios npm: https://www.cisa.gov/news-events/alerts/2026/04/20/supply-chain-compromise-impacts-axios-node-package-manager
- TanStack Postmortem (11 mayo 2026): https://tanstack.com/blog/npm-supply-chain-compromise-postmortem
- StepSecurity — Análisis node-ipc (14 mayo 2026): https://www.stepsecurity.io/blog/node-ipc-npm-supply-chain-attack
- Snyk — Análisis TanStack: https://snyk.io/blog/tanstack-npm-packages-compromised/
- Wiz — Mini Shai-Hulud: https://www.wiz.io/blog/mini-shai-hulud-strikes-again-tanstack-more-npm-packages-compromised
- Unit 42 (Palo Alto) — Threat landscape npm: https://unit42.paloaltonetworks.com/monitoring-npm-supply-chain-attacks/

### Documentación oficial

- pnpm — Documentación oficial: https://pnpm.io/
- pnpm — `.npmrc` configuration: https://pnpm.io/npmrc
- pnpm — Security features: https://pnpm.io/security
- Corepack — Node.js: https://nodejs.org/api/corepack.html
- GitHub Actions — `pnpm/action-setup`: https://github.com/pnpm/action-setup

### Referencias internas

- ADR-004: Axios version pinning supply chain attack
- ADR-005: Flyway database migration standard
- Conventional Commits: https://www.conventionalcommits.org/en/v1.0.0/

## Changelog

- **2026-05-16** — Creación del ADR (Sprint 4). Adopción de pnpm como gestor oficial del monorepo y política de seguridad reforzada en `.npmrc`.
