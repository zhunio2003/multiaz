# SPRINT BACKLOG — Sprint 5

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 5  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-003)  
**Fecha inicio:** 05/05/2026  
**Fecha fin:** 11/05/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Construir el Prediction Orchestrator Service como núcleo de EP-02, habilitando el flujo completo de predicción en tiempo real: el usuario selecciona un modelo activo desde el catálogo, envía sus datos, y recibe el resultado de la IA en la misma petición. Al cierre del sprint, el sistema soporta su primer flujo de negocio end-to-end: autenticación → catálogo → predicción.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 3 |
| Tareas totales | 13 |
| Story Points comprometidos | 18 SP |
| Horas estimadas totales | 35 h |
| Duración del sprint | 1 semana (7 días) |
| Disponibilidad diaria | 5 h/día |
| Velocidad promedio de referencia | 22.5 SP (promedio acumulado 4 sprints) |

> **Nota de capacidad:** Se comprometieron 18 SP sobre una capacidad real calculada de 35 h (5 h/día × 7 días). La estimación está alineada con la capacidad disponible — se aplica directamente la acción de mejora #1 de la Retrospectiva del Sprint 4. El compromiso es conservador respecto al promedio histórico dado que TS-02.1 introduce dos tecnologías nuevas en el proyecto: `WebClient` (Spring WebFlux reactive client) y el primer AI Service Python/FastAPI.

---

## 3. Riesgos Técnicos por Item

| ID | Item | Tipo | Riesgo | Motivo |
|----|------|------|--------|--------|
| TS-02.1 | Prediction Orchestrator Service | Technical Story | Alto | `WebClient` no se ha usado en el proyecto — cliente HTTP reactivo nuevo. Diseño del contrato con AI Service requiere decisión antes de implementar. |
| HU-02.1 | Catálogo de Modelos — Flutter + React | Historia de Usuario | Medio | Integración con Model Registry ya existe; el riesgo es la consistencia del estado en ambos frontends. |
| DT-003 | Testcontainers para Model Registry | Deuda técnica | Bajo | Testcontainers es compatible con Spring Boot 4.x confirmado. Patrón nuevo pero bien documentado. |

---

## 4. Sprint Backlog Detallado

---

### EP-02 — Realización de Predicciones

---

#### TS-02.1 — Prediction Orchestrator Service

**Story:** "Como sistema, necesito un Prediction Orchestrator Service operativo, para que las solicitudes de predicción de los usuarios sean recibidas, validadas, enrutadas al AI Service correcto y los resultados almacenados y devueltos en tiempo real."

**Story Points:** 13  
**Horas estimadas:** 26 h  
**Riesgo:** Alto — `WebClient` y primer AI Service Python/FastAPI son tecnologías nuevas en el proyecto

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-02.1.1 | Crear el proyecto Spring Boot del Prediction Orchestrator en `backend/core/prediction-orchestrator/` con las dependencias: `spring-boot-starter-web`, `spring-boot-starter-webflux` (para `WebClient`), `spring-boot-starter-data-jpa`, `postgresql`, `spring-cloud-starter-netflix-eureka-client`, `spring-cloud-starter-config`, `spring-boot-starter-actuator`, `lombok`. Configurar `application.yml` para registro en Eureka y Config Service. Consistencia obligatoria: nombre en `application.yml`, `pom.xml` artifactId, estructura de paquetes y nombre de carpeta. | 3 h | To Do |
| T-02.1.2 | Definir el esquema PostgreSQL del Prediction Orchestrator: tabla `predictions` con campos `id` (UUID), `user_id`, `model_id`, `model_name`, `input_data` (JSON), `output_data` (JSON), `status` (PENDING / COMPLETED / FAILED), `created_at`, `completed_at`. Crear la entidad `Prediction` con `@Entity`, `@Table`, los campos correspondientes y `PredictionStatus` enum en `enums/`. Crear `PredictionRepository` con `JpaRepository`. Agregar la base de datos `prediction_orchestrator` al `docker-compose.yml` bajo el servicio PostgreSQL existente. | 4 h | To Do |
| T-02.1.3 | Crear el `PredictionRequest` DTO (entrada: `modelId`, `inputData` como `Map<String, Object>`) y el `PredictionResponse` DTO (salida: `predictionId`, `modelId`, `modelName`, `result` como `Map<String, Object>`, `status`, `createdAt`). Estos DTOs son el contrato público del servicio — lo que el API Gateway expondrá al cliente. | 2 h | To Do |
| T-02.1.4 | Implementar el cliente HTTP hacia Model Registry usando `WebClient`. Crear `ModelRegistryClient` en `client/` que realice `GET /models/{id}` contra el servicio `model-registry` resuelto via Eureka (`lb://model-registry`). Debe retornar un `ModelDto` con los campos necesarios: `id`, `name`, `endpointUrl`, `status`. Si el modelo no existe o está INACTIVE, lanzar una excepción de negocio. | 4 h | To Do |
| T-02.1.5 | Implementar `PredictionService` con el método `predict(String userId, PredictionRequest request)`: (1) consultar el modelo en Model Registry via `ModelRegistryClient`, (2) validar que el modelo esté ACTIVE, (3) crear un registro `Prediction` con status PENDING y persistirlo, (4) llamar al `endpointUrl` del AI Service via `WebClient` con el `inputData`, (5) actualizar el registro con el resultado y status COMPLETED, (6) retornar el `PredictionResponse`. Si el AI Service falla, actualizar status a FAILED y retornar error descriptivo. | 7 h | To Do |
| T-02.1.6 | Implementar `PredictionController` con el endpoint `POST /predictions` protegido por JWT. Extraer el `userId` del token JWT del header `Authorization`. Delegar en `PredictionService`. Retornar HTTP 200 con `PredictionResponse` en caso de éxito, HTTP 404 si el modelo no existe, HTTP 503 si el AI Service no está disponible. Agregar ruta `/predictions/**` al API Gateway en `config/dev/api-gateway.yml`. | 3 h | To Do |
| T-02.1.7 | Agregar el servicio `prediction-orchestrator` al `docker-compose.yml` con su Dockerfile multi-stage. Configurar conexión a PostgreSQL en `config/dev/prediction-orchestrator.yml`. Verificar: servicio levanta, aparece en Eureka, responde `/actuator/health` con UP, y `POST /predictions` retorna respuesta coherente (puede ser error de AI Service no disponible — lo que importa es que el Orchestrator responde correctamente). | 3 h | To Do |

---

#### HU-02.1 — Catálogo de Modelos de Predicción

**Story:** "Como usuario, quiero ver la lista de modelos de predicción disponibles con su nombre, descripción y tipo, para elegir cuál utilizar."

**Story Points:** 4  
**Horas estimadas:** 7 h  
**Riesgo:** Medio — el backend (Model Registry) ya existe; el riesgo es la sincronización de estado en ambos frontends

**Criterios de aceptación:**
1. El usuario puede consultar el catálogo de todos los modelos de IA activos en la plataforma.
2. Cada modelo muestra su nombre, descripción y tipo de predicción que realiza.
3. Los modelos desactivados por el administrador no aparecen en el catálogo.
4. El catálogo se actualiza automáticamente cuando se registran o desactivan modelos en el Model Registry.

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-02.1.HU1.1 | Implementar en Flutter (`mobile-app`) la pantalla de catálogo de modelos. Crear `ModelCatalogScreen` que consuma `GET /models?status=ACTIVE` via `ApiClient` (Dio) y renderice la lista de modelos con nombre, descripción y tipo. Usar `FutureBuilder` para el estado de carga. Manejar el caso de lista vacía con un mensaje informativo. | 3 h | To Do |
| T-02.1.HU1.2 | Implementar en React (`admin-web-app`) la vista de catálogo de modelos disponibles para el usuario administrador. Crear el componente `ModelCatalog` que consuma `GET /models?status=ACTIVE` via `apiClient` (axios) y renderice la lista con nombre, descripción, tipo y estado. Aplicar design system MultIAZ (#25C278, Poppins). | 2 h | To Do |
| T-02.1.HU1.3 | Verificar flujo end-to-end: registrar un modelo via `POST /models` (Postman), consultar el catálogo en Flutter y React, verificar que el modelo aparece. Desactivar el modelo via Postman y verificar que desaparece del catálogo en ambos frontends. | 2 h | To Do |

---

### Deuda Técnica

---

#### DT-003 — Testcontainers para Model Registry Service

**Story Points:** 1  
**Horas estimadas:** 2 h  
**Riesgo:** Bajo — Testcontainers compatible con Spring Boot 4.x confirmado antes del sprint

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-DT007.1 | Agregar la dependencia `spring-boot-testcontainers` y `testcontainers:mongodb` al `pom.xml` del Model Registry. Reemplazar la anotación `@Disabled` en `ModelControllerTest` por la configuración con `@TestConfiguration` + `@Bean MongoDBContainer`. Verificar que el test levanta un contenedor MongoDB real, inserta un `AiModel` y valida que `GET /models/{id}` retorna el documento correcto. El test debe pasar en verde local y en el pipeline de GitHub Actions. | 2 h | To Do |

---

## 5. Resumen por Item

| ID | Nombre | Tipo | SP | Horas Est. | Tareas |
|----|--------|------|----|------------|--------|
| TS-02.1 | Prediction Orchestrator Service | Technical Story | 13 | 26 h | 7 |
| HU-02.1 | Catálogo de Modelos — Flutter + React | Historia de Usuario | 4 | 7 h | 3 |
| DT-003 | Testcontainers para Model Registry | Deuda técnica | 1 | 2 h | 1 |
| **Total** | | | **18** | **35 h** | **11** |

---

## 6. Orden de Ejecución

| Orden | ID | Item | Justificación |
|-------|----|------|---------------|
| 1 | TS-02.1 | Prediction Orchestrator Service | Core del sprint — sin Orchestrator no hay flujo de predicción. Es el item de mayor riesgo y mayor duración; se ejecuta primero cuando la energía y el contexto están frescos. |
| 2 | HU-02.1 | Catálogo de Modelos | Depende del Model Registry (ya operativo) — se ejecuta en paralelo con TS-02.1 una vez que T-02.1.1 esté completa y el contexto del sprint sea claro. Si el tiempo se ajusta, tiene prioridad sobre DT-003. |
| 3 | DT-003 | Testcontainers Model Registry | Deuda técnica de baja urgencia — se ejecuta al final, solo si la capacidad lo permite. No bloquea ningún item comprometido. |

---

## 7. Verificación de Acciones de Mejora — Sprint 4

| # | Acción comprometida | Cómo se verifica en este sprint |
|---|---------------------|---------------------------------|
| 1 | Calcular capacidad real en horas antes de comprometer SP | ✅ Aplicado: 35 h calculadas explícitamente (5 h/día × 7 días). Los 18 SP comprometidos están alineados con esa capacidad — no con la velocidad histórica bruta. |
| 2 | `git status` antes de cada `git add`, archivos por nombre, nunca `git add .` | Se verifica al final del sprint: cero errores de Git documentados en el REPASO (no `--amend` post-push, no commits prematuros, no `git add .`). |
| 3 | Verificar compatibilidad con Spring Boot 4.x para librerías nuevas antes de comprometer | ✅ Aplicado: Testcontainers verificado como compatible antes del Planning. `WebClient` (spring-boot-starter-webflux) es dependencia oficial de Spring — sin riesgo de incompatibilidad. |

---

## 8. Stretch Goal — AI Service (Python/FastAPI)

> **Condición:** Solo se inicia si TS-02.1 está completado con tiempo restante en el sprint.

Si el Prediction Orchestrator queda operativo y hay capacidad disponible, se arranca el primer AI Service como stub funcional:

- Crear `backend/ia-services/prediction-service/` con FastAPI
- Endpoint `POST /predict` que recibe `inputData` y retorna un resultado simulado (respuesta hardcodeada)
- El objetivo no es un modelo de IA real — es validar que el Orchestrator puede llamar al AI Service y recibir respuesta end-to-end
- Docker Compose: agregar el servicio y verificar que el flujo completo funciona

Este stretch goal no tiene SP asignados ni tareas formales — no forma parte del compromiso del sprint.

---

## 9. Notas

- Sprint 5 marca el inicio de **EP-02 — Realización de Predicciones**, la primera épica de negocio real del proyecto. A partir de aquí el sistema comienza a tener valor observable para el usuario final.
- `WebClient` es el cliente HTTP reactivo de Spring — se usa en lugar de `RestTemplate` porque es el estándar actual para comunicación inter-servicios en Spring Boot 4.x. No confundir con WebFlux completo: se usa solo el cliente, no el stack reactivo completo.
- La base de datos `prediction_orchestrator` en PostgreSQL es independiente del esquema del `auth` service — cada microservicio tiene su propia base de datos. Este es el patrón Database per Service establecido desde el Sprint 1.
- El AI Service que se llamará en este sprint puede ser un stub (respuesta simulada) — lo que importa es que el Orchestrator esté correctamente conectado. La IA real se implementa en sprints posteriores.
- Velocidad de referencia: 22.5 SP promedio acumulado (4 sprints). Sprint 5 compromete 18 SP — conservador y alineado con capacidad real de 35 h calculadas explícitamente.

---

*MultIAZ — Sprint 5 Backlog | Mayo 2026*
