# SPRINT BACKLOG — Sprint 7

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints por capacidad en horas (modelo adoptado en este Planning — ver sección 3)  
**Sprint:** Sprint 7  
**Fase:** Fase 2 — Experiencia del Usuario (cierre de EP-02, inicio de EP-03 Historial) + Deuda Técnica (DT-008, DT-009)  
**Fecha inicio:** 08/10/2026  
**Fecha fin:** Se define por capacidad — el sprint cierra al cumplir el Sprint Goal o al consumir el presupuesto de 25 h de foco, lo que ocurra primero  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Como usuario de la mobile-app, puedo consultar el historial de mis predicciones y abrir el detalle de cualquiera de ellas. Al cierre del sprint, el flujo login → catálogo → predicción FAKE / REAL → historial → detalle se ejecuta end-to-end en el emulador Android con evidencia (screenshots), HU-02.2 queda verificada formalmente, y cada usuario solo puede acceder a sus propias predicciones.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 3 |
| Tareas totales | 11 |
| Story Points comprometidos | 10 SP |
| Horas estimadas totales | 19 h |
| Presupuesto de horas (tope) | 25 h de foco |
| Colchón | 6 h (24 % del tope) |
| Trabajo previo al sprint (fuera del presupuesto) | 2 h — preparación del entorno Android (Acción de mejora #2) |
| Duración del sprint | Por capacidad — sin fecha fin calendario |
| Velocidad de referencia | 10–15 SP (Review Sprint 6). Promedio acumulado: 19.3 SP (6 sprints) |

> **Nota de capacidad:** Se comprometen 10 SP / 19 h, el extremo bajo del rango de referencia, por tres razones: (1) HU-03.1 es la primera historia del proyecto que combina un endpoint de lectura nuevo en el Orchestrator con una pantalla Flutter, y su diseño de seguridad (identidad del usuario tomada del JWT) no tiene precedente en el proyecto; (2) DT-009 es el primer arranque completo del stack contra el emulador, con riesgo de incidentes de entorno; (3) la proporción de ~1.9 h por SP proviene de un único sprint (Sprint 6), por lo que las estimaciones de este sprint son una hipótesis que el registro de horas reales debe calibrar. El colchón de 6 h existe para absorber esa incertidumbre, no para añadir alcance.

---

## 3. Modelo de Capacidad

*Acción de mejora #3 del Sprint 6.*

### 3.1 Contexto

La duración real de los sprints se ha desviado de la semana teórica de forma sostenida:

| Sprint | Duración planificada | Duración real |
|--------|---------------------|---------------|
| Sprint 1 | 7 días | 5 días |
| Sprint 2 | 7 días | 7 días |
| Sprint 3 | 7 días | 13 días |
| Sprint 4 | 7 días | 14 días |
| Sprint 5 | 7 días | ~21 días |
| Sprint 6 | 7 días | ~19 semanas |

Opciones evaluadas en el Planning:

| Opción | Descripción | Decisión |
|--------|-------------|----------|
| (a) | Mantener sprints de 1 semana asumiendo que la duración real varía | ❌ Descartada — perpetúa un compromiso temporal que no se cumple |
| **(b)** | **Planificar en horas de foco disponibles reales, sin asumir semanas calendario** | **✅ Adoptada** |
| (c) | Mini-milestones dentro de sprints más largos | ❌ Descartada — agrega ceremonia que un desarrollador individual no necesita |

> **Desviación consciente del Scrum Guide:** el Scrum Guide exige un timebox fijo. El modelo (b) lo reemplaza por un presupuesto de horas fijo. Es una adaptación documentada para un proyecto individual con disponibilidad variable, no una omisión.

### 3.2 Reglas del modelo

1. **Presupuesto:** 25 h de foco por sprint. **Compromiso:** 19 h de trabajo estimado. El tope es un límite, no una meta.
2. **Hora de foco:** tiempo efectivo de trabajo en tareas del sprint. Excluye pausas, búsqueda no relacionada y mantenimiento de entorno no planificado (ese se registra aparte, ver regla 5).
3. **Cierre:** el sprint termina cuando se cumple el Sprint Goal o cuando se consumen las 25 h, lo que ocurra primero.
4. **Presupuesto agotado sin cumplir el goal:** el sprint se cierra. Lo pendiente regresa al Product Backlog. El Sprint Review lo reporta como no cumplido, sin reinterpretar el goal. El presupuesto no se amplía durante el sprint.
5. **Trabajo no planificado:** se registra en este documento *antes* de ejecutarlo, con descripción, estimación y justificación (Acción de mejora #1 del Sprint 5), y descuenta del presupuesto.
6. **Registro de horas reales:** la columna «Horas reales» de cada tabla de tareas se completa al terminar cada tarea, no al final del sprint.
7. **Calibración:** el Review del sprint reporta la razón horas reales / horas estimadas y los SP completados por hora real. Esa razón es la base de la capacidad del Sprint 8.

### 3.3 Trabajo previo al sprint

| Actividad | Horas | Observación |
|-----------|-------|-------------|
| Preparación del entorno Android (liberar espacio, unificar SDK, validar emulador, app de prueba) | 2 h | Fuera del presupuesto: es precondición de la Acción de mejora #2, exigida *antes* del primer día del sprint |

### 3.4 Registro de capacidad (se completa durante el sprint)

| Item | Horas estimadas | Horas reales | Diferencia |
|------|-----------------|--------------|------------|
| DT-009 | 3 h | — | — |
| DT-008 | 1.5 h | — | — |
| HU-03.1 | 14.5 h | — | — |
| **Total** | **19 h** | **—** | **—** |

---

## 4. Plan de Verificación de Hardware

*Acción de mejora #1 del Sprint 6.*

### 4.1 Dependencia y restricción

La verificación de HU-02.2 (DT-009) y de HU-03.1 requiere ejecutar la app Flutter en un runtime Android. El único dispositivo físico disponible es un equipo financiado con PayJoy que deshabilita el modo desarrollador. **No se puede depender de ese dispositivo.**

### 4.2 Escalera de alternativas

| Nivel | Alternativa | Uso |
|-------|-------------|-----|
| 1 (primaria) | Emulador `multiaz_emulator` (Android 35, `google_apis`, x86_64) | Verificación de aceptación de DT-009 y HU-03.1 |
| 2 | Dispositivo físico de otra persona con depuración USB habilitada | Si el emulador presenta inestabilidad que no se resuelve dentro del presupuesto |
| 3 | `flutter run -d linux` | Solo para validar lógica e integración de red. **No sustituye** la aceptación en Android; se registra como desviación. Requiere instalar el toolchain de Linux (clang, CMake, ninja, GTK) y el almacenamiento seguro necesita `libsecret` con un keyring activo |

**Regla de escalado:** si `adb devices` muestra `offline` o el emulador se desconecta de forma recurrente durante una verificación, se registra como incidente, se detiene la tarea y se pasa al siguiente nivel de la escalera. No se continúa depurando el emulador por encima de 1 h sin decisión explícita.

### 4.3 Condición de entrada verificada (Acción de mejora #2)

Verificado el 08/10/2026, antes de iniciar el sprint:

| Verificación | Resultado |
|--------------|-----------|
| Espacio en disco | `/home`: 33 GB libres (91 % de uso; antes 7.0 GB, 99 %). `/`: 12 GB libres (87 %; antes 3.7 GB, 96 %) |
| SDK único | `ANDROID_HOME=/usr/lib/android-sdk`. Se eliminó del `.bashrc` la referencia a `~/Android/Sdk`. `which -a adb emulator` resuelve solo dentro de ese SDK. Emulador 37.2.12, `adb` 35.0.0 |
| Toolchain Android | `flutter doctor`: Android toolchain ✓ (licencias aceptadas) |
| Aceleración por hardware | `emulator -accel-check`: KVM instalado y utilizable |
| Emulador conectado | `adb devices` → `emulator-5554   device` (07:23) |
| App de prueba | App Flutter de prueba (creada fuera del repositorio) ejecutada en `multiaz_emulator` (07:31) — screenshot conservado como evidencia |
| Estabilidad sostenida | **Se reconfirma en T-DT009.2.** Si `adb devices` pasa a `offline`, aplica la regla de escalado de 4.2 |

### 4.4 Configuración conocida pendiente (no bloquea)

- El AVD `multiaz_emulator` tiene `hw.ramSize = 1536M`. Se sube a 2048M **solo** si aparece inestabilidad, y como cambio aislado, para poder atribuir la causa.
- `cmdline-tools` está instalado en la versión `11.0`, sin enlace `latest`. No bloquea; se corrige como cambio aparte si `flutter doctor` lo exige.

---

## 5. Riesgos Técnicos por Item

| ID | Item | Tipo | Riesgo | Motivo |
|----|------|------|--------|--------|
| DT-009 | Verificación end-to-end de HU-02.2 | Deuda técnica | Medio | Primer arranque completo del stack Docker y de la app en el emulador desde el cierre del Sprint 6. El estado de credenciales y datos persistidos en volúmenes no se ha verificado desde entonces. La URL base debe cambiar por entorno (`10.0.2.2` en el emulador). |
| DT-008 | Registro de servicios Python en Eureka | Deuda técnica | Bajo | Es una decisión de arquitectura con documentación, sin código. |
| HU-03.1 | Consulta de Historial de Predicciones | Historia de Usuario | Medio-Alto | No existe ningún endpoint de lectura en el Orchestrator (solo `POST /predictions`). Es la primera historia con backend y Flutter juntos desde TS-02.1. El diseño de identidad del usuario (JWT frente a header controlado por el cliente) no tiene precedente en el proyecto. La historia no fue refinada antes de este Planning. |

---

## 6. Sprint Backlog Detallado

---

### Deuda Técnica

---

#### DT-009 — Verificación end-to-end de HU-02.2

**Story Points:** 2  
**Horas estimadas:** 3 h  
**Riesgo:** Medio — primer arranque completo del stack sobre el emulador.

**Criterios de aceptación:**
1. La app Flutter obtiene la URL base del backend por configuración de compilación, no por valor fijo en el código, y funciona contra el emulador sin editar archivos entre entornos.
2. El flujo login → catálogo → seleccionar fake-news → ingresar título y texto → recibir FAKE / REAL con confianza visible se ejecuta en el emulador, con screenshots de cada paso.
3. Los 5 criterios de aceptación de HU-02.2 están verificados uno por uno, incluido el caso de AI Service no disponible (CA5).
4. La predicción realizada queda persistida en la tabla `predictions` de PostgreSQL (verificado por consulta directa).

| ID Tarea | Descripción de la Tarea | Horas Est. | Horas reales | Estado |
|----------|-------------------------|------------|--------------|--------|
| T-DT009.1 | Configurar la URL base de la app por entorno mediante `--dart-define` (variable `API_BASE_URL`) leída con `String.fromEnvironment`, con valor por defecto coherente. Valor para el emulador: `http://10.0.2.2:<puerto del API Gateway definido en docker/docker-compose.yml>`. Verificar en el `AndroidManifest.xml` que el tráfico HTTP sin cifrar está permitido para desarrollo (Android lo bloquea por defecto desde la API 28). Documentar el comando de ejecución por entorno. | 1.5 h | — | To Do |
| T-DT009.2 | Levantar el stack con Docker Compose y confirmar con `docker compose ps` que los servicios necesarios están `Up` / `healthy` (gateway, auth, model-registry, orchestrator, bases de datos, `fake-news-detector`). Confirmar con `curl` desde el host el health del gateway. Ejecutar el flujo completo en el emulador recorriendo los 5 CA de HU-02.2 con screenshots. Provocar el caso de AI Service no disponible (detener `fake-news-detector`) y verificar el mensaje de error. Consultar `predictions` en PostgreSQL y confirmar la fila. Reconfirmar la estabilidad de `adb devices` durante la sesión. | 1.5 h | — | To Do |

---

#### DT-008 — Registro de servicios Python en Eureka

**Story Points:** 1  
**Horas estimadas:** 1.5 h  
**Riesgo:** Bajo — decisión documentada, sin código.

**Decisión de Planning (opción 3 del Sprint Review 6):** los servicios Python no se registran en Eureka. El Prediction Orchestrator los invoca por el `endpointUrl` almacenado en el Model Registry (MongoDB), que es el contrato model-agnostic del proyecto. Registrarlos en Eureka no aporta descubrimiento adicional y obliga a agregar una dependencia de terceros (`py-eureka-client`) o a mantener un cliente HTTP propio, ampliando la superficie de la cadena de suministro (criterio coherente con ADR-004). La decisión se formaliza en ADR-007.

**Criterios de aceptación:**
1. Existe `ADR-007` en formato Michael Nygard (cuerpo en español, encabezados en inglés) con contexto, alternativas evaluadas (registro manual vía API REST de Eureka, `py-eureka-client`, no registrar), decisión y consecuencias.
2. El criterio de aceptación 1 de TS-FN.1 («se registra como `fake-news-detector` en Eureka») queda enmendado formalmente, no ignorado.

| ID Tarea | Descripción de la Tarea | Horas Est. | Horas reales | Estado |
|----------|-------------------------|------------|--------------|--------|
| T-DT008.1 | Redactar `ADR-007` siguiendo la plantilla de los ADR anteriores (numeración secuencial tras ADR-006), documentando contexto, las tres alternativas, la decisión y sus consecuencias (incluido qué se pierde: visibilidad de los servicios Python en el dashboard de Eureka y health-checking centralizado). | 1 h | — | To Do |
| T-DT008.2 | Registrar la enmienda del CA1 de TS-FN.1 en el Product Backlog y en las Adaptaciones del Sprint Review 7, referenciando ADR-007. | 0.5 h | — | To Do |

---

### EP-03 — Historial de Predicciones

---

#### HU-03.1 — Consulta de Historial de Predicciones

**Story:** "Como usuario, quiero consultar todas las predicciones que he realizado previamente, para poder revisarlas en cualquier momento."

**Story Points:** 7  
**Horas estimadas:** 14.5 h  
**Riesgo:** Medio-Alto — primer endpoint de lectura del Orchestrator; diseño de seguridad nuevo; backend y Flutter en la misma historia.

**Criterios de aceptación (Product Backlog):**
1. El usuario puede ver una lista de todas sus predicciones realizadas, ordenadas de la más reciente a la más antigua.
2. Cada predicción muestra: modelo utilizado, datos ingresados, resultado obtenido y fecha/hora de la consulta.
3. El usuario puede acceder al detalle completo de cualquier predicción del historial.

**Criterios técnicos (agregados en Planning):**
4. La identidad del usuario en los endpoints de lectura se obtiene del JWT validado, nunca de un header o parámetro que el cliente pueda modificar.
5. Un usuario que solicita una predicción ajena recibe `404` (no `403`, para no revelar que el recurso existe). Verificado con prueba automatizada y con un segundo usuario.
6. El historial vacío muestra un mensaje informativo, sin error.

| ID Tarea | Descripción de la Tarea | Horas Est. | Horas reales | Estado |
|----------|-------------------------|------------|--------------|--------|
| T-HU031.1 | Orchestrator — capa de datos y servicio: agregar a `PredictionRepository` la consulta por `user_id` ordenada por `created_at` descendente, y el método correspondiente en `PredictionService`. Sin paginación en este sprint (decisión consciente, ver Notas). | 2 h | — | To Do |
| T-HU031.2 | Orchestrator — endpoints: **primero verificar** cómo obtiene hoy el Orchestrator el `userId` en `POST /predictions` (header `X-User-Id` enviado por Flutter) y definir la fuente confiable para lectura (claim `sub` del JWT validado). Implementar `GET /predictions` (lista del usuario autenticado) y `GET /predictions/{id}` (detalle con verificación de pertenencia; ajeno → 404). Crear DTOs de respuesta específicos (no exponer la entidad JPA). La ruta `/predictions/**` ya existe en el API Gateway. | 3 h | — | To Do |
| T-HU031.3 | Orchestrator — pruebas: lista ordenada de más reciente a más antigua; lista vacía; detalle propio retorna 200; detalle de otro usuario retorna 404; sin token retorna 401. | 2 h | — | To Do |
| T-HU031.4 | Flutter — modelo y servicio: crear el modelo de ítem de historial y de detalle (`fromJson` coherente con los DTOs) y un servicio de historial que consuma `GET /predictions` y `GET /predictions/{id}` vía `ApiClient`. La identidad viaja en el token, no en headers propios. | 1.5 h | — | To Do |
| T-HU031.5 | Flutter — `HistoryScreen`: lista de predicciones con modelo, resultado y fecha; estado de carga; estado vacío con mensaje; manejo de error de red. Registrar la ruta en `AppRouter` y agregar el acceso desde `HomeScreen`. Seguir el patrón de `ModelCatalogScreen`. | 3 h | — | To Do |
| T-HU031.6 | Flutter — pantalla de detalle: al tocar un ítem del historial, navegar a la vista de detalle con datos ingresados, resultado, confianza y fecha/hora completos (CA3). | 2 h | — | To Do |
| T-HU031.7 | Verificación end-to-end en el emulador con screenshots: realizar al menos dos predicciones, verificar orden en el historial, abrir el detalle de cada una, verificar historial vacío con un usuario nuevo. Con `curl` y el token de un segundo usuario, confirmar que no puede leer predicciones ajenas (CA4 y CA5). | 1 h | — | To Do |

---

## 7. Resumen por Item y Orden de Ejecución

### Resumen por item

| ID | Nombre | Tipo | SP | Horas Est. | Tareas |
|----|--------|------|----|------------|--------|
| DT-009 | Verificación end-to-end de HU-02.2 | Deuda técnica | 2 | 3 h | 2 |
| DT-008 | Registro de servicios Python en Eureka | Deuda técnica | 1 | 1.5 h | 2 |
| HU-03.1 | Consulta de Historial de Predicciones | Historia de Usuario | 7 | 14.5 h | 7 |
| **Total** | | | **10 SP** | **19 h** | **11** |

### Orden de ejecución

| Orden | ID | Item | Justificación |
|-------|----|------|---------------|
| 1 | DT-009 | Verificación de HU-02.2 | Cierra una historia comprometida hace un sprint y valida el entorno bajo uso real antes de construir encima. Confirma que las predicciones se persisten (HU-03.1 necesita filas que leer) y deja resuelta la configuración de URL por entorno, que HU-03.1 reutiliza. |
| 2 | DT-008 | ADR-007 | Sin dependencias, 1.5 h. Se ejecuta tras DT-009 para liquidar la deuda sin ocupar el tramo de mayor riesgo. |
| 3 | HU-03.1 | Historial de predicciones | Core del sprint. Orden interno por dependencia: T-HU031.1 → .2 → .3 (backend completo y probado) → .4 → .5 → .6 (Flutter) → .7 (verificación). El frontend no se inicia hasta que los endpoints respondan correctamente. |

---

## 8. Verificación de Acciones de Mejora — Sprint 6

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Documentar las dependencias de hardware y una alternativa verificada de verificación antes del primer día del sprint | ✅ Aplicado — sección 4: dependencia, escalera de tres niveles y regla de escalado documentadas. |
| 2 | Configurar y verificar el entorno de emulación Android antes del primer día del sprint | ✅ Cumplido con seguimiento — verificado el 08/10/2026 (sección 4.3). La estabilidad sostenida se reconfirma en T-DT009.2. |
| 3 | Decidir formalmente el modelo de capacidad en el Planning | ✅ Aplicado — sección 3: modelo (b), presupuesto de 25 h, reglas de cierre y registro de horas reales. |

---

## 9. Notas

- **Corrección del Product Backlog:** el Sprint Review y la Retrospectiva del Sprint 6 etiquetaron HU-02.3 como «Historial de Predicciones». En el Product Backlog, HU-02.3 es **«Detalle de la Predicción»** (EP-02) y el historial es **HU-03.1** (EP-03). El Product Backlog es la fuente de verdad. HU-02.3 permanece pendiente: exige «factores considerados», y el modelo fake-news hoy solo retorna `result` y `confidence`, por lo que requerirá cambios en el servicio Python.
- **Arquitectura frente a implementación:** el diseño de arquitectura delega la persistencia de predicciones en el Prediction Storage Service; hoy el Orchestrator persiste directamente en su tabla `predictions` (PostgreSQL). HU-03.1 se implementa sobre el Orchestrator. La relación con el Prediction Storage Service queda como decisión de arquitectura futura, candidata a ADR.
- **Riesgo de seguridad existente (fuera del alcance de este sprint):** `POST /predictions` recibe el usuario en el header `X-User-Id`, valor controlado por el cliente. HU-03.1 no repite ese patrón en lectura (CA4), pero la escritura queda pendiente de revisión. Se evalúa en el Sprint Review 7 si se registra como deuda técnica.
- **Fuera de alcance:** filtros y búsqueda (HU-03.2), paginación del historial (se acepta el riesgo de listas largas mientras el volumen de datos sea de desarrollo), HU-02.3 y la vista de historial en admin-web-app.
- **Deuda de entorno identificada (no comprometida):** el SDK de Android reside en `/usr/lib/android-sdk` (ruta de paquete del sistema; convención: SDK dentro del home del usuario); `cmdline-tools` sin enlace `latest`; AVD con 1536M de RAM; `/home` al 91 % de uso. No se actualiza Flutter durante el sprint.
- **Velocidad de referencia:** 10–15 SP según el Sprint Review 6. Este sprint compromete 10 SP / 19 h, con un tope de 25 h.

---

*MultIAZ — Sprint 7 Backlog | Octubre 2026*
