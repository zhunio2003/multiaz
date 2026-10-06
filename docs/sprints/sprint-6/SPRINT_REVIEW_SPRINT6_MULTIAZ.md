# SPRINT REVIEW — Sprint 6

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 6  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-007)  
**Fecha de Review:** 06 de octubre de 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Como usuario de la mobile-app, puedo seleccionar el AI Service de fake news para recibir una predicción real en base a los datos ingresados. Al cierre del sprint, el sistema ejecuta su primer flujo de predicción real end-to-end en dispositivo físico: autenticación → catálogo → selección de modelo → ingreso de datos → resultado FAKE / REAL visible en pantalla.

**Resultado:** ⚠️ Sprint Goal parcialmente cumplido — el flujo completo está implementado y funcional en todos sus componentes backend y mobile, pero la verificación en dispositivo físico quedó bloqueada por una restricción de hardware externa (dispositivo financiado con PayJoy, modo desarrollador deshabilitado por la plataforma). El código de `PredictionScreen`, `PredictionService` y el flujo de navegación están completos y correctos. La verificación end-to-end se completa en el Sprint 7 con acceso a dispositivo.

---

## 2. Resumen de Resultados

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 3 |
| Items completados | 2 |
| Items parciales | 1 |
| Story Points comprometidos | 12 |
| Story Points completados | ~9 |
| Tareas completadas | 8 / 9 |
| Tareas bloqueadas | 1 (T-HU022.2 — hardware) |
| Duración real del sprint | ~19 semanas (sprint extendido) |
| **Velocidad Sprint 6** | **~9 SP** |

> Sprint completado al 75% en SP. El Sprint Goal principal — tener el primer AI Service real operativo y el flujo de predicción implementado end-to-end — fue cumplido técnicamente. La verificación visual en dispositivo físico quedó bloqueada por PayJoy. DT-007 fue completada al 100% cerrando una deuda pendiente desde Sprint 4.

---

## 3. Incremento Entregado

---

### Deuda Técnica

---

#### DT-007 — Testcontainers para Model Registry Service
**Estado:** ✅ Done  
**Story Points:** 1

**Evidencia presentada:**

**T-DT007.1 — Testcontainers en Model Registry:**
- Dependencias `spring-boot-testcontainers` y `testcontainers:mongodb` agregadas al `pom.xml` del Model Registry.
- Anotación `@Disabled` eliminada de `ModelControllerTest`. Configuración reemplazada con `@TestConfiguration` + `@Bean MongoDBContainer`.
- Test levanta un contenedor MongoDB real, inserta un `AiModel` y valida que `GET /models/{id}` retorna el documento correcto.
- Pipeline de GitHub Actions pasa en verde con el test de integración real.

**Decisiones técnicas relevantes:**
- Testcontainers sobre Flapdoodle — Flapdoodle (`de.flapdoodle.embed.mongo`) es incompatible con Spring Boot 4.x. Testcontainers levanta un MongoDB real en Docker durante la ejecución del test — comportamiento idéntico al ambiente de producción, sin mocks ni emulaciones.
- Esta deuda llevaba diferida desde Sprint 4 — se priorizó correctamente al inicio del Sprint 6 antes de abordar trabajo nuevo.

---

### EP-02 — Realización de Predicciones

---

#### TS-FN.1 — Fake News AI Service
**Estado:** ✅ Done (con una deuda técnica generada — ver sección 4)  
**Story Points:** 8

**Evidencia presentada:**

**T-FN.1.1 — Estructura del proyecto y endpoint `/health`:**
- Estructura creada en `backend/ia-services/fake-news-detector/`: `main.py`, `requirements.txt`, `Dockerfile`, carpetas `model/`, `schemas/`, `services/`, `training/` con `__init__.py` en cada paquete Python.
- FastAPI instanciado en `main.py`. Endpoint `GET /health` implementado, retorna `{"status": "UP"}`.
- Servicio verificado localmente con `uvicorn main:app --reload`.

**T-FN.1.2 — Script de entrenamiento:**
- Script `training/train.py` implementado con pipeline completo: carga de `Fake.csv` y `True.csv`, columna `label` (0=FAKE, 1=REAL), combinación con `pd.concat`, columna `content = title + text`, división train/test 80/20 con `random_state=42`.
- Pipeline `TfidfVectorizer + LogisticRegression` construido con `sklearn.pipeline.Pipeline`.
- Accuracy en set de validación: **98.82%** — supera el criterio de aceptación de ≥85%.
- Modelo serializado en `model/fake_news_model.pkl` con `joblib`.
- Versión de scikit-learn pineada en `requirements.txt` (`scikit-learn==1.8.0`) para garantizar compatibilidad entre entrenamiento local y contenedor Docker.

**T-FN.1.3 — Schemas Pydantic:**
- `schemas/prediction_schema.py` implementado con dos schemas:
  - `PredictionRequest`: campos `title: str`, `text: str`
  - `PredictionResponse`: campos `result: str`, `confidence: float`
- Estos schemas son el contrato del servicio con el Prediction Orchestrator.

**T-FN.1.4 — InferenceService:**
- `services/inference_service.py` implementado: carga del modelo `.pkl` al iniciar el servicio (singleton), método `predict(title, text) -> PredictionResponse` que combina título y texto, vectoriza con TF-IDF, ejecuta `model.predict()` y `model.predict_proba()`, retorna resultado como `FAKE` o `REAL` con score de confianza.

**T-FN.1.5 — Endpoint `POST /predict`:**
- Endpoint implementado en `main.py`: recibe `PredictionRequest`, delega en `InferenceService`, retorna `PredictionResponse`.
- Verificación con curl:
  - `{"title": "Breaking: Aliens land in Washington", "text": "..."}` → `{"result": "FAKE", "confidence": 0.87}`
  - `{"title": "Federal Reserve raises interest rates", "text": "..."}` → `{"result": "REAL", "confidence": 0.80}`

**T-FN.1.6 — Dockerfile e integración Docker Compose:**
- Dockerfile implementado: imagen base `python:3.11-slim`, copia `requirements.txt`, instala dependencias, copia código fuente y `.pkl`, expone puerto `8091`, `CMD uvicorn main:app --host 0.0.0.0 --port 8091`.
- `.dockerignore` creado: excluye `venv/`, `__pycache__/`, `*.pyc`, `data/` — contexto de build reducido de 498MB a 955 bytes.
- Servicio `fake-news-detector-multiaz` agregado al `docker-compose.yml` con puerto `8091:8091`, red `net-prediction`, healthcheck con `CMD-SHELL` usando `urllib` (imagen slim no incluye `wget`).
- Modelo `fake-news-detector` registrado en MongoDB via Model Registry:
  - `endpointUrl: http://fake-news-detector-multiaz:8091/predict`
  - `status: ACTIVE`
  - `inputSchema: {"title": "string", "text": "string"}`
- Verificación: servicio levanta en Docker Compose, responde `/health` con UP, `POST /predict` retorna resultado correcto, healthcheck en estado `healthy`.

**Decisiones técnicas relevantes:**
- `python:3.11-slim` sobre imagen completa — imagen minimalista, reduce superficie de ataque y tiempo de build. El contexto de build pasó de 498MB a 955B tras agregar `.dockerignore`.
- TF-IDF + Logistic Regression sobre deep learning — para clasificación de texto con dataset etiquetado de 44k artículos, Logistic Regression sobre vectores TF-IDF da 98.82% de accuracy en segundos de entrenamiento. Deep learning añadiría complejidad sin ganancia significativa de accuracy.
- Puerto 8091 — asignado según el documento de despliegue `DESPLIEGUE_DOCKER_MULTIAZ.md`: rango 8090-8095 reservado para servicios Python, puerto 8090 reservado para `training-service`.
- Healthcheck con `CMD-SHELL` + `urllib` — `python:3.11-slim` no incluye `wget` ni `curl`. `urllib` es parte de la librería estándar de Python, siempre disponible en cualquier imagen Python.
- Versión scikit-learn pineada — `InconsistentVersionWarning` detectado al primer build: el modelo fue entrenado con 1.8.0 local pero el contenedor instaló 1.9.0. Versiones distintas de scikit-learn pueden generar resultados incorrectos al deserializar `.pkl`.

---

#### HU-02.2 — Realizar Predicción en Tiempo Real (Flutter)
**Estado:** ⚠️ Parcial — código completo, verificación bloqueada por hardware  
**Story Points:** 3 (parcial — ~1 SP acreditado)

**Evidencia presentada:**

**T-HU022.1 — PredictionScreen Flutter:**
- `models/prediction_result.dart` implementado: clase `PredictionResult` con campos `modelId`, `predictionId`, `modelName`, `result`, `confidence`. `fromJson` extrae `result` y `confidence` del mapa anidado `result['result']` y `result['confidence']`.
- `services/prediction_service.dart` implementado: método `predict(modelId, userId, inputData)` llama `POST /predictions` via `ApiClient` con header `X-User-Id` requerido por el Orchestrator.
- `TokenService.getUserId()` implementado: decodifica el JWT del storage seguro, extrae el claim `sub` (UUID del usuario) del payload Base64 — sin dependencias externas, usando solo `dart:convert`.
- `ApiClient.post()` actualizado para aceptar headers opcionales: `Map<String, dynamic>? headers` pasados como `Options(headers: headers)` a Dio.
- `PredictionScreen` implementada como `StatefulWidget`: recibe `AiModel` por parámetro, dos `TextEditingController` para `title` y `text` con `dispose()` correcto, estado `_isLoading` y `_result`, método `_predict()` async con `try/catch/finally`, `CircularProgressIndicator` durante carga, resultado visible en pantalla.
- `AppRouter` actualizado: ruta `/predict` con extracción de `AiModel` via `ModalRoute.of(context)!.settings.arguments`.
- `ModelCatalogScreen` actualizado: `onTap` en `ListTile` navega a `/predict` pasando el modelo como argumento.
- `HomeScreen` actualizado: botón "Nueva predicción" navega a `/catalog`.
- `flutter analyze` limpio — 0 errores, 0 warnings en archivos nuevos.

**T-HU022.2 — Verificación end-to-end en dispositivo físico:**
- **Estado: Bloqueado** — el dispositivo físico disponible es un equipo financiado con PayJoy que deshabilita el modo desarrollador hasta completar el pago. El emulador Android fue configurado (`avdmanager`, SDK 35, NDK 28.2) pero presentó inestabilidad en el ambiente de desarrollo (crashes por espacio en disco, desconexiones ADB). La verificación visual queda pendiente para Sprint 7.

**Causa raíz del bloqueo:** restricción externa de hardware — no es un problema de código ni de arquitectura.

---

## 4. Deuda Técnica — Estado Actualizado

| ID | Descripción | Prioridad | Estado | Sprint destino |
|----|-------------|-----------|--------|----------------|
| DT-007 | Testcontainers para Model Registry | Media | ✅ Cerrada | Sprint 6 |
| DT-008 | Registro de `fake-news-detector` en Eureka | Baja | 🔲 Nueva | Sprint 7 |
| DT-009 | Verificación end-to-end HU-02.2 en dispositivo físico | Alta | 🔲 Nueva | Sprint 7 |

**DT-008 — Eureka registration para servicios Python:**
FastAPI no tiene cliente Eureka nativo (equivalente a `spring-cloud-starter-netflix-eureka-client`). El criterio de aceptación 1 de TS-FN.1 indica que el servicio debe registrarse en Eureka. Las opciones son: (1) implementar registro manual via HTTP a la API REST de Eureka en el startup de FastAPI, (2) usar `py-eureka-client` librería de terceros, (3) re-evaluar si el registro en Eureka es necesario para servicios Python dado que el Orchestrator los llama por `endpointUrl` directo desde MongoDB. Esta decisión se toma en Sprint Planning 7. 

---

## 5. Velocidad del Equipo

| Sprint | SP Comprometidos | SP Completados | Duración real |
|--------|-----------------|----------------|---------------|
| Sprint 1 | 27 | 27 | 5 días |
| Sprint 2 | 26 | 26 | 7 días |
| Sprint 3 | 26 | 21 | 13 días |
| Sprint 4 | 16 | 16 | 14 días |
| Sprint 5 | 18 | 17 | ~21 días |
| Sprint 6 | 12 | ~9 | ~19 semanas |
| **Promedio acumulado** | **20.8** | **19.3** | — |

> La velocidad del Sprint 6 (~9 SP) refleja la naturaleza exploratoria del sprint: FastAPI era tecnología nueva en el proyecto, el NLP pipeline introdujo incertidumbre técnica real, y la configuración del entorno de emulación Android consumió tiempo no planificado. El Sprint Goal técnico fue cumplido — el AI Service está operativo con 98.82% de accuracy. La reducción de SP completados respecto al compromiso se explica por T-HU022.2 bloqueada por hardware, no por capacidad técnica. **Velocidad de referencia para Sprint 7: 10–15 SP** (conservador, considerando pendientes de verificación y configuración de entorno estabilizada).

---

## 6. Adaptaciones al Product Backlog

| Tipo | Descripción |
|------|-------------|
| Deuda técnica cerrada | DT-007 — Testcontainers Model Registry cerrada en Sprint 6 |
| Technical Story completada | TS-FN.1 — Fake News AI Service operativo, 98.82% accuracy |
| Historia parcial | HU-02.2 — código completo, verificación bloqueada por hardware |
| Deuda técnica nueva | DT-008 — Eureka registration para FastAPI |
| Deuda técnica nueva | DT-009 — Verificación end-to-end HU-02.2 en dispositivo |

---

## 7. Avance de EP-02 — Realización de Predicciones

| Historia / Story | Descripción | SP | Estado |
|---|---|---|---|
| TS-02.1 | Prediction Orchestrator Service | 13 SP | ✅ Completa (Sprint 5) |
| HU-02.1 | Catálogo de Modelos | 4 SP | ✅ Completa (Sprint 5) |
| TS-FN.1 | Fake News AI Service | 8 SP | ✅ Completa (Sprint 6) |
| HU-02.2 | Realizar Predicción (flujo usuario) | 3 SP | ⚠️ Parcial (Sprint 6 — verificación pendiente) |
| HU-02.3 | Historial de Predicciones | Por definir | 🔲 Pendiente |

El sistema cuenta ahora con:
- Fake News AI Service operativo en Docker — TF-IDF + Logistic Regression, 98.82% accuracy
- Endpoint `POST /predict` funcional: recibe `{title, text}`, retorna `{result, confidence}`
- Modelo registrado en MongoDB con `endpointUrl` correcto apuntando al contenedor Docker
- `PredictionScreen` Flutter implementada completa — formulario, validación, llamada al Orchestrator, resultado en pantalla
- `TokenService.getUserId()` — decodificación de JWT sin dependencias externas
- Navegación completa: Home → Catálogo → Predicción con paso de argumentos
- Flujo end-to-end listo para verificación en dispositivo físico

---

## 8. Próximos Pasos

1. **Sprint Retrospective Sprint 6** — reflexión sobre la gestión de entorno de emulación y la incertidumbre técnica de FastAPI.
2. **Sprint Planning Sprint 7** — priorizar DT-009 (verificación HU-02.2), DT-008 (Eureka para Python), y definir siguiente incremento de EP-02 (HU-02.3 Historial de Predicciones).
3. **Acceso a dispositivo físico** — resolver la situación PayJoy o conseguir acceso a dispositivo alternativo para cerrar T-HU022.2.

---

*MultIAZ — Sprint 6 Review | Octubre 2026*
