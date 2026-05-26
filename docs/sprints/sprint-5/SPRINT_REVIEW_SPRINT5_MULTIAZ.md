# SPRINT REVIEW — Sprint 5

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 5  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-007)  
**Fecha de Review:** 26 de mayo de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Construir el Prediction Orchestrator Service como núcleo de EP-02, habilitando el flujo completo de predicción en tiempo real: el usuario selecciona un modelo activo desde el catálogo, envía sus datos, y recibe el resultado de la IA en la misma petición. Al cierre del sprint, el sistema soporta su primer flujo de negocio end-to-end: autenticación → catálogo → predicción.

**Resultado:** ✅ Sprint Goal cumplido — Prediction Orchestrator operativo y flujo de predicción end-to-end habilitado. UI móvil mejorada significativamente como trabajo adicional no planificado.

---

## 2. Resumen de Resultados

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 3 |
| Items completados | 2 |
| Story Points comprometidos | 18 |
| Story Points completados | 17 |
| Tareas completadas | 10 / 11 |
| Tareas bloqueadas | 0 |
| Duración real del sprint | ~21 días |
| **Velocidad Sprint 5** | **17 SP** |

> Sprint completado al 94%. DT-007 (Testcontainers para Model Registry) no fue ejecutada — se difiere al Sprint 6. El Sprint Goal principal fue cumplido en su totalidad: el Prediction Orchestrator está operativo y el catálogo de modelos funcional en ambos frontends. La duración extendida refleja interrupciones por enfermedad y disponibilidad reducida durante el período — no es una señal de degradación técnica.

---

## 3. Incremento Entregado

---

### EP-02 — Realización de Predicciones

---

#### TS-02.1 — Prediction Orchestrator Service
**Estado:**  Done  
**Story Points:** 13

**Evidencia presentada:**

**T-02.1.1 — Proyecto Spring Boot:**
- Proyecto creado en `backend/core/prediction-orchestrator/` con dependencias: `spring-boot-starter-web`, `spring-boot-starter-webflux` (WebClient), `spring-boot-starter-data-jpa`, `postgresql`, `spring-cloud-starter-netflix-eureka-client`, `spring-cloud-starter-config`, `spring-boot-starter-actuator`, `lombok`.
- Registrado en Eureka como `prediction-orchestrator`. Configuración obtenida desde Config Service en `config/dev/prediction-orchestrator.yml`.

**T-02.1.2 — Esquema PostgreSQL y modelo de dominio:**
- Base de datos `prediction_orchestrator` creada en PostgreSQL — independiente del esquema del `auth` service (patrón Database per Service).
- Entidad `Prediction` implementada con `@Entity`, `@Table`: campos `id` (UUID), `user_id`, `model_id`, `model_name`, `input_data` (JSON), `output_data` (JSON), `status` (enum `PredictionStatus`), `created_at`, `completed_at`.
- `PredictionStatus` enum en `enums/`: `PENDING`, `COMPLETED`, `FAILED`.
- `PredictionRepository` extendiendo `JpaRepository<Prediction, UUID>`.

**T-02.1.3 — DTOs de contrato:**
- `PredictionRequest` DTO: `modelId` (String), `inputData` (Map<String, Object>).
- `PredictionResponse` DTO: `predictionId`, `modelId`, `modelName`, `result` (Map<String, Object>), `status`, `createdAt`.
- Estos DTOs constituyen el contrato público del servicio — lo que el API Gateway expone al cliente móvil y web.

**T-02.1.4 — ModelRegistryClient con WebClient:**
- `ModelRegistryClient` implementado en `client/` usando `WebClient` con resolución Eureka (`lb://model-registry`).
- Consulta `GET /models/{id}` al Model Registry. Retorna `ModelDto` con campos: `id`, `name`, `endpointUrl`, `status`.
- Si el modelo no existe o está `INACTIVE`, lanza excepción de negocio — el Orchestrator rechaza la predicción antes de persistir nada.

**T-02.1.5 — PredictionService:**
- Flujo de predicción implementado: (1) consultar modelo en Model Registry, (2) validar status `ACTIVE`, (3) persistir `Prediction` con status `PENDING`, (4) llamar al `endpointUrl` del AI Service via `WebClient`, (5) actualizar registro con resultado y status `COMPLETED`, (6) retornar `PredictionResponse`.
- Si el AI Service falla: registro actualizado a status `FAILED`, error descriptivo retornado al cliente.

**T-02.1.6 — PredictionController:**
- Endpoint `POST /predictions` protegido por JWT implementado.
- `userId` extraído del token JWT en header `Authorization`.
- Respuestas: HTTP 200 (predicción exitosa), HTTP 404 (modelo no encontrado), HTTP 503 (AI Service no disponible).
- Ruta `/predictions/**` agregada al API Gateway en `config/dev/api-gateway.yml`.

**T-02.1.7 — Docker integration:**
- Dockerfile multi-stage implementado: etapa `build` con `maven:3.9-eclipse-temurin-21`, etapa `runtime` con `eclipse-temurin:21-jre`.
- Servicio `prediction-orchestrator` agregado al `docker-compose.yml` con `depends_on` sobre `config-service`, `service-discovery` y `postgresql`.
- Verificación: servicio levanta, aparece en Eureka, responde `/actuator/health` con UP, `POST /predictions` retorna respuesta coherente.

**Decisiones técnicas relevantes:**
- `WebClient` sobre `RestTemplate` — `RestTemplate` está en modo mantenimiento en Spring Boot 4.x. `WebClient` es el cliente HTTP estándar actual para comunicación inter-servicios, con soporte reactivo nativo aunque se use de forma bloqueante.
- `lb://model-registry` — resolución de nombre via Eureka con load balancing automático. El prefijo `lb:` es obligatorio para que `WebClient` delegue la resolución al Discovery Client.
- Database per Service para `prediction_orchestrator` — cada microservicio tiene su propia base de datos. Acoplamiento entre esquemas es una violación directa de los principios de microservicios.

---

#### HU-02.1 — Catálogo de Modelos de Predicción
**Estado:**  Done  
**Story Points:** 4

**Evidencia presentada:**

**T-02.1.HU1.1 — Flutter ModelCatalogScreen:**
- `ModelCatalogScreen` implementada en `screens/catalog/`: consume `GET /models?status=ACTIVE` via `ApiClient` (Dio).
- `FutureBuilder` utilizado para manejo de estado de carga, error y lista vacía.
- Lista de modelos renderizada con nombre, descripción y tipo de predicción.
- Ruta `/catalog` registrada en `main.dart`.
- Pantalla de Login rediseñada: logo MultIAZ, campos email/password, botón primario `Login`, botón secundario `Recuperar contraseña`, opciones OAuth (Google, GitHub), link a Register. Design system aplicado (`#121212`, `#25C278`, Poppins).
- Pantalla de Register rediseñada: campos name/email/password, botón `Register`, opciones OAuth, link a Sign In. Consistencia visual garantizada con Login.

**T-02.1.HU1.2 — React ModelCatalog:**
- Componente `ModelCatalog` implementado en `admin-web-app`: consume `GET /models?status=ACTIVE` via `apiClient` (axios).
- Lista renderizada con nombre, descripción, tipo y estado del modelo.
- Design system MultIAZ aplicado (`#25C278`, Poppins).

**T-02.1.HU1.3 — Verificación end-to-end:**
- Flujo verificado: registro de modelo via `POST /models`, consulta en Flutter y React, modelo aparece en catálogo. Desactivación via Postman, modelo desaparece del catálogo en ambos frontends.

**Trabajo adicional no planificado — Mejora de UI Flutter:**
> Durante este sprint se realizó una revisión y mejora significativa de las pantallas de autenticación y navegación principal de la app móvil. Este trabajo no estaba en el Sprint Backlog comprometido — fue iniciativa del desarrollador para aumentar la calidad visual del producto y mantener la motivación técnica. El incremento resultante es un beneficio neto para el producto.

| Pantalla mejorada | Mejoras aplicadas |
|---|---|
| `LoginScreen` | Logo MultIAZ, layout refinado, botones primary/secondary diferenciados, OAuth placeholders, navegación a Register |
| `RegisterScreen` | Consistencia visual con Login, campos name/email/password, OAuth placeholders, navegación a Sign In |
| `HomeScreen` | [Evidencia visual pendiente — screenshot por agregar] |
| `ModelCatalogScreen` (rediseño) | [Evidencia visual pendiente — screenshot por agregar] |

> **Nota:** Screenshots de Home y ModelCatalog pendientes de agregar a este documento.

---

## 4. Deuda Técnica — Estado Actualizado

| ID | Descripción | Prioridad | Estado | Sprint destino |
|----|-------------|-----------|--------|----------------|
| DT-007 | `ModelControllerTest` deshabilitado — Flapdoodle incompatible con Spring Boot 4.x. Requiere Testcontainers para tests de integración de MongoDB. | Media | 🔄 Diferida | Sprint 6 |

---

## 5. Velocidad del Equipo

| Sprint | SP Comprometidos | SP Completados | Duración real |
|--------|-----------------|----------------|---------------|
| Sprint 1 | 27 | 27 | 5 días |
| Sprint 2 | 26 | 26 | 7 días |
| Sprint 3 | 26 | 21 | 13 días |
| Sprint 4 | 16 | 16 | 14 días |
| Sprint 5 | 18 | 17 | ~21 días |
| **Promedio acumulado** | **22.6** | **21.4** | — |

> **Nota:** La velocidad del Sprint 5 (17 SP) refleja una duración extendida por factores externos (enfermedad, disponibilidad reducida) — no por complejidad técnica subestimada ni por bloqueos de implementación. El Sprint Goal fue cumplido al 100%. La DT-007 diferida (1 SP) tiene impacto mínimo en la entrega de valor. **Velocidad de referencia para Sprint 6: 18–20 SP** (promedio móvil conservador considerando disponibilidad variable).

---

## 6. Adaptaciones al Product Backlog

| Tipo | Descripción |
|------|-------------|
| Historia completada | HU-02.1 — Catálogo de Modelos cerrada en Sprint 5 |
| Technical Story completada | TS-02.1 — Prediction Orchestrator Service operativo |
| Deuda técnica diferida | DT-007 — Testcontainers Model Registry pasa a Sprint 6 |
| Mejora no planificada | UI Flutter mejorada en Login, Register, Home y Catálogo — incremento de calidad incorporado al producto |

---

## 7. Avance de EP-02 — Realización de Predicciones

| Historia / Story | Descripción | SP | Estado |
|---|---|---|---|
| TS-02.1 | Prediction Orchestrator Service | 13 SP | ✅ Completa (Sprint 5) |
| HU-02.1 | Catálogo de Modelos | 4 SP | ✅ Completa (Sprint 5) |
| HU-02.2 | Realizar Predicción (flujo usuario) | Por definir | 🔲 Pendiente |
| HU-02.3 | Historial de Predicciones | Por definir | 🔲 Pendiente |

El sistema cuenta ahora con:
- Prediction Orchestrator Service operativo — recibe, valida, enruta y persiste predicciones
- Comunicación inter-servicios Orchestrator ↔ Model Registry via WebClient + Eureka
- Contrato REST definido: `POST /predictions` protegido por JWT, expuesto via API Gateway
- Catálogo de modelos funcional en Flutter (mobile) y React (admin web) — filtrado por status ACTIVE
- UI móvil de autenticación y navegación significativamente mejorada
- Primer AI Service stub disponible como stretch goal (si aplica — confirmar en retrospectiva)

---

## 8. Próximos Pasos

1. **Sprint Retrospective Sprint 5** — reflexión sobre el proceso, duración extendida y trabajo no planificado.
2. **Sprint Planning Sprint 6** — definir el siguiente incremento de EP-02 (flujo de predicción desde el usuario en Flutter) y resolver DT-007.
3. **Primer AI Service real** — evaluar cuándo iniciar la implementación Python/FastAPI para reemplazar el stub del Orchestrator.

---

*MultIAZ — Sprint 5 Review | Mayo 2026*
