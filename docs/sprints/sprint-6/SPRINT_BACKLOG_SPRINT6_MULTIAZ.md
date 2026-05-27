# SPRINT BACKLOG — Sprint 6

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 6  
**Fase:** Fase 2 — Experiencia del Usuario (EP-02 Predicciones) + Deuda Técnica (DT-007)  
**Fecha inicio:** 27/05/2026  
**Fecha fin:** 02/06/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

> Como usuario de la mobile-app, puedo seleccionar el AI Service de fake news para recibir una predicción real en base a los datos ingresados. Al cierre del sprint, el sistema ejecuta su primer flujo de predicción real end-to-end en dispositivo físico: autenticación → catálogo → selección de modelo → ingreso de datos → resultado FAKE / REAL visible en pantalla.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Items comprometidos | 3 |
| Tareas totales | 9 |
| Story Points comprometidos | 12 SP |
| Horas estimadas totales | 23 h |
| Duración del sprint | 1 semana (7 días) |
| Disponibilidad diaria | 5 h/día |
| Capacidad real calculada | 35 h |
| Velocidad promedio de referencia | 21.4 SP (promedio acumulado 5 sprints) |

> **Nota de capacidad:** Se comprometieron 12 SP sobre una capacidad real de 35 h. El compromiso es conservador respecto al promedio histórico por dos razones justificadas: (1) FastAPI es tecnología nueva en el proyecto — no existe ningún AI Service implementado hasta este sprint; (2) el NLP pipeline (vectorización + entrenamiento + inferencia) introduce incertidumbre técnica real. Comprometer conservador y entregar completo es preferible a comprometer al promedio y dejar el flujo end-to-end incompleto. Los 12 h restantes de capacidad disponible (35 h − 23 h) actúan como buffer para absorber la incertidumbre técnica.

---

## 3. Riesgos Técnicos por Item

| ID | Item | Tipo | Riesgo | Motivo |
|----|------|------|--------|--------|
| DT-007 | Testcontainers para Model Registry | Deuda técnica | Bajo | Testcontainers compatible con Spring Boot 4.x confirmado. Patrón documentado. Lleva 2 sprints diferida — sin excusa para diferir un sprint más. |
| TS-FN.1 | Fake News AI Service | Technical Story | Alto | FastAPI es tecnología nueva en el proyecto. El NLP pipeline (vectorización TF-IDF + clasificador) requiere decisiones de diseño antes de implementar. El entrenamiento depende de la calidad del dataset. |
| HU-02.2 | Realizar Predicción — Flutter | Historia de Usuario | Medio | Depende de que TS-FN.1 esté operativo. La incertidumbre es la experiencia de usuario del formulario dinámico de inputs. |

---

## 4. Sprint Backlog Detallado

---

### Deuda Técnica

---

#### DT-007 — Testcontainers para Model Registry Service

**Story Points:** 1  
**Horas estimadas:** 2 h  
**Riesgo:** Bajo — Testcontainers compatible con Spring Boot 4.x confirmado. Lleva 2 sprints diferida — es el primer item en ejecutarse.

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-DT007.1 | Agregar las dependencias `spring-boot-testcontainers` y `testcontainers:mongodb` al `pom.xml` del Model Registry. Reemplazar la anotación `@Disabled` en `ModelControllerTest` por configuración con `@TestConfiguration` + `@Bean MongoDBContainer`. Verificar que el test levanta un contenedor MongoDB real, inserta un `AiModel` y valida que `GET /models/{id}` retorna el documento correcto. El test debe pasar en verde local y en el pipeline de GitHub Actions. | 2 h | To Do |

---

### EP-02 — Realización de Predicciones

---

#### TS-FN.1 — Fake News AI Service

**Story:** "Como sistema, necesito un Fake News AI Service operativo en Python/FastAPI, para que el Prediction Orchestrator pueda enrutar solicitudes de clasificación de noticias y recibir un resultado real (FAKE / REAL) basado en un modelo de ML entrenado."

**Story Points:** 8  
**Horas estimadas:** 15 h  
**Riesgo:** Alto — FastAPI es tecnología nueva en el proyecto. NLP pipeline introduce incertidumbre técnica.

**Criterios de aceptación:**
1. El servicio levanta en Docker Compose y se registra como `fake-news-detector` en Eureka.
2. `POST /predict` recibe `{ "title": "...", "text": "..." }` y retorna `{ "result": "FAKE" | "REAL", "confidence": 0.xx }`.
3. El modelo fue entrenado con el dataset real (True.csv + Fake.csv) y tiene accuracy ≥ 85% en el set de validación.
4. El Prediction Orchestrator puede llamar al servicio exitosamente via WebClient.
5. El servicio responde `/health` con status UP.

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-FN.1.1 | Crear la estructura del proyecto en `backend/ia-services/fake-news-detector/`: `main.py`, `requirements.txt`, `Dockerfile`, carpetas `model/`, `schemas/`, `services/`, `training/`. Instalar y configurar FastAPI con uvicorn. Implementar el endpoint `/health` que retorna `{ "status": "UP" }`. Verificar que el servicio levanta localmente con `uvicorn main:app --reload`. | 2 h | To Do |
| T-FN.1.2 | Crear el script de entrenamiento en `training/train.py`: cargar `True.csv` y `Fake.csv`, agregar columna `label` (1 = REAL, 0 = FAKE), combinar los datasets, limpiar texto (lowercase, eliminar caracteres especiales), construir el pipeline `TfidfVectorizer + LogisticRegression` con scikit-learn, dividir en train/test (80/20), entrenar el modelo, evaluar accuracy en el set de test (objetivo ≥ 85%), serializar el modelo y el vectorizador en `model/fake_news_model.pkl` y `model/vectorizer.pkl` usando `joblib`. Ejecutar el script y verificar que los archivos `.pkl` se generan correctamente. | 4 h | To Do |
| T-FN.1.3 | Crear `schemas/prediction_schema.py` con los modelos Pydantic: `PredictionRequest` (campos: `title: str`, `text: str`) y `PredictionResponse` (campos: `result: str`, `confidence: float`). Estos schemas son el contrato del servicio con el Prediction Orchestrator. | 1 h | To Do |
| T-FN.1.4 | Implementar `services/inference_service.py`: cargar `fake_news_model.pkl` y `vectorizer.pkl` al iniciar el servicio (singleton), implementar el método `predict(title: str, text: str) -> PredictionResponse` que combina título y texto, vectoriza con TF-IDF, ejecuta `model.predict()` y `model.predict_proba()`, y retorna el resultado como `FAKE` o `REAL` con el score de confianza. | 3 h | To Do |
| T-FN.1.5 | Implementar el endpoint `POST /predict` en `main.py`: recibir `PredictionRequest`, delegar en `InferenceService`, retornar `PredictionResponse`. Manejar el caso de error si los modelos `.pkl` no están cargados. Verificar el endpoint con `curl` o Postman: enviar título y texto de una noticia real y una falsa, validar que el resultado es coherente. | 2 h | To Do |
| T-FN.1.6 | Crear el `Dockerfile` del servicio: imagen base `python:3.11-slim`, copiar `requirements.txt`, instalar dependencias, copiar el código fuente y los archivos `.pkl` del modelo entrenado, exponer puerto 8090, definir `CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8090"]`. Agregar el servicio `fake-news-detector` al `docker-compose.yml` con puerto `8090:8090`. Verificar que el servicio levanta en Docker, responde `/health` con UP y `POST /predict` retorna resultado correcto. Actualizar el `endpointUrl` del modelo `fake-news` registrado en MongoDB via Postman para que apunte a `http://fake-news-detector:8090/predict`. | 3 h | To Do |

---

#### HU-02.2 — Realizar Predicción en Tiempo Real (Flutter)

**Story:** "Como usuario, quiero seleccionar un modelo, ingresar los datos requeridos y recibir una predicción al instante, para tomar decisiones basadas en datos."

**Story Points:** 3  
**Horas estimadas:** 5 h  
**Riesgo:** Medio — depende de que TS-FN.1 esté operativo. El formulario de inputs debe adaptarse al esquema del modelo seleccionado.

**Criterios de aceptación:**
1. Al seleccionar el modelo fake-news desde el catálogo, el sistema presenta el formulario con los campos `title` y `text`.
2. El sistema valida que los campos no estén vacíos antes de enviar la solicitud.
3. La predicción se devuelve al usuario con el resultado (FAKE / REAL) y el nivel de confianza visible en pantalla.
4. Cada predicción realizada queda almacenada en el Prediction Orchestrator (PostgreSQL).
5. Si el AI Service no está disponible, se muestra un mensaje de error claro sin romper la navegación.

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-HU022.1 | Implementar en Flutter la pantalla de predicción `PredictionScreen`. Al navegar desde `ModelCatalogScreen` con un modelo seleccionado, mostrar el formulario correspondiente. Para el modelo fake-news: dos campos de texto (`title`, `text`). Implementar validación de campos vacíos. Conectar con `POST /predictions` via `ApiClient` (Dio) enviando `{ "modelId": "...", "inputData": { "title": "...", "text": "..." } }`. Mostrar resultado FAKE / REAL y confidence en pantalla. Manejar error de servicio no disponible con mensaje informativo. | 4 h | To Do |
| T-HU022.2 | Verificar flujo end-to-end completo en dispositivo físico: login real → catálogo real → seleccionar fake-news → ingresar título y texto → recibir FAKE / REAL en pantalla. Documentar con screenshots el flujo completo. Verificar en PostgreSQL que la predicción quedó persistida en la tabla `predictions`. | 1 h | To Do |

---

## 5. Resumen por Item

| ID | Nombre | Tipo | SP | Horas Est. | Tareas |
|----|--------|------|----|------------|--------|
| DT-007 | Testcontainers para Model Registry | Deuda técnica | 1 | 2 h | 1 |
| TS-FN.1 | Fake News AI Service | Technical Story | 8 | 15 h | 6 |
| HU-02.2 | Realizar Predicción — Flutter | Historia de Usuario | 3 | 5 h | 2 |
| **Total** | | | **12 SP** | **23 h** | **9** |

---

## 6. Orden de Ejecución

| Orden | ID | Item | Justificación |
|-------|----|------|---------------|
| 1 | DT-007 | Testcontainers Model Registry | Liquidar deuda técnica primero — 2h, sin riesgo, lleva 2 sprints diferida. Acción de mejora #2 de Retro 5 aplicada. |
| 2 | TS-FN.1 | Fake News AI Service | Core del sprint — mayor riesgo técnico, mayor duración. Se ejecuta con energía y contexto frescos. HU-02.2 no puede iniciarse sin este item completo. |
| 3 | HU-02.2 | Realizar Predicción — Flutter | Depende directamente de TS-FN.1. Se inicia una vez que `POST /predict` del AI Service responde correctamente en Docker. |

---

## 7. Verificación de Acciones de Mejora — Sprint 5

| # | Acción comprometida | Resultado |
|---|---------------------|-----------|
| 1 | Registrar trabajo adicional en Sprint Backlog antes de ejecutarlo | ✅ Cumplido — no hubo trabajo no planificado sin registrar durante Sprint 5 más allá de la mejora de UI ya documentada en la Retrospectiva. |
| 2 | DT-007 entra obligatoriamente al Sprint 6 en posición 1 | ✅ Aplicado — DT-007 es el primer item en el orden de ejecución de este sprint. |
| 3 | Flujo completo ejecutado en dispositivo físico con screenshots al cierre del sprint | Se verifica al cierre del Sprint 6 — tarea T-HU022.2 documenta este criterio. |

---

## 8. Notas

- Este sprint marca el primer uso de Python/FastAPI en el proyecto. El stack es diferente a Spring Boot — no hay Spring Cloud, no hay Eureka client nativo. La integración con el Orchestrator se hace via URL directa configurada en el `endpointUrl` del modelo registrado en MongoDB.
- El modelo de ML elegido (Logistic Regression + TF-IDF) es intencional — es el clasificador de texto más simple y eficiente para este caso. No se usa deep learning ni transformers: el objetivo es un modelo funcional, no el estado del arte.
- Los archivos `.pkl` del modelo entrenado se incluyen en la imagen Docker — el entrenamiento se hace una vez localmente y los artefactos se copian al contenedor. No hay reentrenamiento en runtime.
- La verificación end-to-end en dispositivo físico (T-HU022.2) es criterio de éxito del sprint — acción de mejora #3 de la Retro 5. Si el flujo no puede ejecutarse en el dispositivo, el sprint no se considera completo aunque todas las tareas individuales estén Done.
- Velocidad de referencia: 21.4 SP promedio acumulado (5 sprints). Sprint 6 compromete 12 SP — conservador y justificado por tecnología nueva. Buffer de 12 h disponibles para absorber incertidumbre técnica del AI Service.

---

*MultIAZ — Sprint 6 Backlog | Mayo 2026*
