# ADR-004 — AXIS VERSION PINNING ANTE SUPPLY CHAIN ATTACK EN LA HISTORIA TS 17.5

**Fecha:** 04 de Abril del 2026
**Estado:** Aceptado

---

## Contexto  

Durante la implementación de TS-17.5, antes de instalar axios como dependencia HTTP del Admin Web App, se identificó un incidente de seguridad crítico ocurrido el 31 de marzo de 2026.
Un actor norcoreano (atribuido por Microsoft Threat Intelligence como Sapphire Sleet / UNC1069 según Google Threat Intelligence Group) comprometió la cuenta npm del mantenedor principal del proyecto axios (jasonsaayman) y publicó dos versiones maliciosas:

- `axios@1.14.1`
- `axios@0.30.4`

Ambas versiones inyectaban una dependencia maliciosa (plain-crypto-js@4.2.1) cuyo script postinstall ejecutaba automáticamente un Remote Access Trojan (RAT) multiplataforma al correr npm install. El ataque fue pre-orquestado con 18 horas de anticipación y afectó a Windows, macOS y Linux.
El ataque estuvo activo desde aproximadamente las 00:21 UTC hasta las 03:15 UTC del 31 de marzo de 2026. Las versiones maliciosas fueron removidas del registro npm tras ser detectadas.

---

## Decisión

 
Instalar `axios` con versión pinneada explícita en lugar de resolución implícita a `latest`:
 
```bash
# ❌ Instalación sin versión — resuelve a latest automáticamente
npm install axios
 
# ✅ Instalación con versión pinneada
npm install axios@1.14.0
```
 
La versión `1.14.0` es la última versión verificada como segura en la rama `1.x` de axios.
 
---
 
## Alternativas Consideradas
 
### Alternativa A — Usar `fetch` nativo del browser
 
**Pros:**
- Sin dependencia externa — sin riesgo de supply chain attack
- Nativo en browsers modernos
 
**Contras:**
- No tiene interceptores — requeriría implementar el patrón manualmente
- Errores 4xx/5xx no son tratados como errores por defecto — requiere validación manual
- Timeouts requieren `AbortController` — código verbose
- En entrevistas técnicas, el patrón de interceptores con axios es lo esperado en proyectos React profesionales
 
### Alternativa B — Instalar axios sin versión (latest)
 
**Pros:**
- Siempre en la versión más reciente
 
**Contras:**
- Durante la ventana del ataque (00:21–03:15 UTC del 31-03-2026) hubiera instalado `axios@1.14.1` — la versión maliciosa
- En CI/CD con `npm install` sin lockfile, cada build podría resolver a una versión diferente
- Inaceptable en entornos de producción
 
### Alternativa C — axios@1.14.0 pinneada ✅ (decisión tomada)
 
**Pros:**
- Versión verificada y segura
- Control explícito sobre qué versión entra al proyecto
- `package-lock.json` garantiza reproducibilidad en todos los entornos
 
**Contras:**
- Requiere actualización manual para nuevas versiones
- Puede acumular deuda de actualizaciones si no se revisa periódicamente
 
---

## Consecuencias
 
### Positivas
 
- El proyecto no está expuesto al RAT distribuido en `axios@1.14.1`
- La versión queda fijada en `package.json` y `package-lock.json` — reproducible en cualquier entorno
- El equipo (o futuro colaborador) puede auditar exactamente qué versión de axios se usa
 
### Negativas
 
- Las actualizaciones de axios no son automáticas — deben revisarse manualmente
- Si se corre `npm install axios` sin versión en el futuro, npm respetará el `package-lock.json` en instalaciones limpias pero podría actualizar si se usa `npm update`
 
### Mitigación
 
- Revisar las notas de seguridad de axios en cada sprint antes de actualizar
- Verificar siempre el `package-lock.json` después de cualquier `npm install` o `npm update`
- Fuente de referencia: https://axios-http.com/docs/changelog
 
---
 
## Lección de Industria — Supply Chain Attacks en npm
 
Este incidente sigue el patrón de ataques de supply chain modernos:
 
```
1. Comprometer cuenta del mantenedor (credenciales robadas)
2. Pre-stagear dependencia maliciosa con historial "limpio"
3. Publicar versión nueva del paquete legítimo con dependencia inyectada
4. El postinstall hook ejecuta el payload automáticamente
5. El malware se auto-elimina para evitar detección forense
```
 
**Señales de alerta que los equipos de seguridad detectaron:**
- Las versiones maliciosas no tenían OIDC provenance metadata (axios siempre las incluía)
- No había commit ni tag correspondiente en el repositorio de GitHub
- La dependencia `plain-crypto-js` nunca había sido parte de axios
 
**Buenas prácticas derivadas:**
- Usar `npm ci` en CI/CD (respeta el lockfile estrictamente) en lugar de `npm install`
- Habilitar alertas de seguridad de Dependabot en GitHub
- Revisar el `package-lock.json` en code reviews — cambios inesperados en el árbol de dependencias son una señal de alerta
- Para dependencias críticas, verificar que la nueva versión tiene provenance metadata antes de actualizar

 
### Positivas
 
- El proyecto no está expuesto al RAT distribuido en `axios@1.14.1`
- La versión queda fijada en `package.json` y `package-lock.json` — reproducible en cualquier entorno
- El equipo (o futuro colaborador) puede auditar exactamente qué versión de axios se usa
 
### Negativas
 
- Las actualizaciones de axios no son automáticas — deben revisarse manualmente
- Si se corre `npm install axios` sin versión en el futuro, npm respetará el `package-lock.json` en instalaciones limpias pero podría actualizar si se usa `npm update`
 
### Mitigación
 
- Revisar las notas de seguridad de axios en cada sprint antes de actualizar
- Verificar siempre el `package-lock.json` después de cualquier `npm install` o `npm update`
- Fuente de referencia: https://axios-http.com/docs/changelog
 
---
 
## Lección de Industria — Supply Chain Attacks en npm
 
Este incidente sigue el patrón de ataques de supply chain modernos:
 
```
1. Comprometer cuenta del mantenedor (credenciales robadas)
2. Pre-stagear dependencia maliciosa con historial "limpio"
3. Publicar versión nueva del paquete legítimo con dependencia inyectada
4. El postinstall hook ejecuta el payload automáticamente
5. El malware se auto-elimina para evitar detección forense
```
 
**Señales de alerta que los equipos de seguridad detectaron:**
- Las versiones maliciosas no tenían OIDC provenance metadata (axios siempre las incluía)
- No había commit ni tag correspondiente en el repositorio de GitHub
- La dependencia `plain-crypto-js` nunca había sido parte de axios
 
**Buenas prácticas derivadas:**
- Usar `npm ci` en CI/CD (respeta el lockfile estrictamente) en lugar de `npm install`
- Habilitar alertas de seguridad de Dependabot en GitHub
- Revisar el `package-lock.json` en code reviews — cambios inesperados en el árbol de dependencias son una señal de alerta
- Para dependencias críticas, verificar que la nueva versión tiene provenance metadata antes de actualizar

## Referencias
 
- Microsoft Security Blog — Mitigating the Axios npm supply chain compromise (2026-04-01)
- Snyk Blog — Axios npm Package Compromised: Supply Chain Attack Delivers Cross-Platform RAT
- SANS Institute — Axios NPM Supply Chain Compromise Emergency Briefing (2026-04-01)
- StepSecurity — axios Compromised on npm: Malicious Versions Drop Remote Access Trojan
- Arctic Wolf — Supply Chain Attack Impacts Widely Used Axios npm Package