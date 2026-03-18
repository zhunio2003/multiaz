# TECHNOLOGY STACK — DECISIONES TECNOLÓGICAS

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.0  
**Fecha:** 18 de Marzo del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento define las **decisiones tecnológicas** del sistema MultIAZ, asignando tecnologías concretas a cada uno de los 26 componentes establecidos en la arquitectura. Las decisiones fueron tomadas durante el Sprint 0 como parte de la preparación técnica previa al inicio del desarrollo.

**Documentos de referencia:**

- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).
- `ARQUITECTURA_INICIAL_MULTIAZ.md` — Diagrama de arquitectura de microservicios.
- `PRODUCT_VISION_BOARD_MULTIAZ.md` — Visión, usuarios, necesidades y objetivos de negocio.

---

## 2. Estrategia Tecnológica General

El sistema MultIAZ adopta una **arquitectura poliglota**, donde cada lenguaje se utiliza donde aporta mayor valor técnico:

| Lenguaje | Uso en el sistema | Justificación |
|----------|-------------------|---------------|
| Java | Microservicios core (lógica de negocio) | Estándar enterprise para microservicios. Spring Boot + Spring Cloud proporcionan un ecosistema maduro con seguridad, service discovery, configuración centralizada y gateway integrados. |
| Python | Servicios de IA y entrenamiento | Ecosistema nativo de Machine Learning (TensorFlow, PyTorch, scikit-learn). FastAPI como framework moderno y de alto rendimiento para APIs. |
| TypeScript | Aplicación web de administración | React con tipado estático para una SPA robusta y mantenible. |
| Dart | Aplicación móvil | Flutter para desarrollo multiplataforma (Android e iOS) con rendimiento nativo y UI pulida. |

**Principio:** Cada lenguaje está donde tiene justificación técnica, no es diversidad por capricho.

---

## 3. Capa de Servicios Core — 9 Microservicios

### 3.1 Auth Service (Servicio de Autenticación y Usuarios)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Seguridad | Spring Security (JWT, OAuth2) |
| Base de datos | PostgreSQL |

**Justificación de base de datos:** Maneja usuarios, roles, tokens y sesiones. Son datos transaccionales puros con relaciones claras (usuario tiene roles, usuario tiene sesiones). Requiere consistencia fuerte e integridad referencial, ideal para SQL.

---

### 3.2 Model Registry Service (Servicio de Registro de Modelos)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | PostgreSQL |

**Justificación de base de datos:** Almacena metadata de modelos, versiones, esquemas de inputs/outputs. Son datos estructurados con relaciones claras (modelo tiene versiones, cada versión tiene esquemas). Requiere consistencia fuerte.

---

### 3.3 Prediction Orchestrator Service (Servicio Orquestador de Predicciones)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | Ninguna propia |

**Justificación:** Es el director de orquesta del sistema: recibe solicitudes, consulta el Model Registry, llama a la IA correspondiente y delega el almacenamiento al Prediction Storage Service. Es pura lógica de coordinación, no persiste datos por sí mismo.

---

### 3.4 Scheduler Service (Servicio de Tareas Programadas)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Programación de tareas | Quartz Scheduler (integrado en Spring) |
| Base de datos | PostgreSQL |

**Justificación de base de datos:** Almacena la configuración de los jobs programados (frecuencia, modelo asociado, estado, historial de ejecuciones). Son datos estructurados y transaccionales.

---

### 3.5 Prediction Storage Service (Servicio de Almacenamiento de Predicciones)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | PostgreSQL + MongoDB |

**Justificación del modelo híbrido:** Los datos base de cada predicción (quién la solicitó, cuándo, qué modelo, resultado principal) van en PostgreSQL porque son consultables, filtrables y requieren integridad relacional. Los detalles expandidos de cada predicción (los JSON de inputs/outputs que varían por modelo, las estadísticas adicionales) van en MongoDB porque cada modelo tiene una estructura de respuesta diferente y los documentos flexibles son ideales para esto.

---

### 3.6 Dataset Management Service (Servicio de Gestión de Datasets)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | PostgreSQL |
| Almacenamiento de archivos | MinIO (Object Storage) |

**Justificación:** La metadata de los datasets (nombre, versión, tamaño, formato, asociación con modelo) es estructurada y relacional, va en PostgreSQL. Los archivos pesados de datasets (CSV, JSON de cientos de MB o GB) se almacenan en MinIO, no en la base de datos.

---

### 3.7 Training Service (Servicio de Entrenamiento)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Python — FastAPI |
| Base de datos | MongoDB |

**Justificación de lenguaje:** El servicio de entrenamiento interactúa directamente con librerías de Machine Learning (TensorFlow, PyTorch, scikit-learn) que son nativas de Python. Usar Java aquí obligaría a depender de wrappers o llamadas externas innecesarias.

**Justificación de base de datos:** Las métricas de entrenamiento (accuracy, loss, precision, recall, F1-score por época) son datos variables y anidados que encajan naturalmente en documentos MongoDB. Cada entrenamiento puede generar métricas distintas según el modelo.

---

### 3.8 Logging & Monitoring Service (Servicio de Logs y Monitoreo)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | MongoDB |

**Justificación de base de datos:** Los logs son datos no estructurados por naturaleza: cada servicio genera logs con formatos distintos, los eventos de salud varían, las métricas cambian. Los documentos flexibles de MongoDB son ideales para almacenar esta variedad de datos.

---

### 3.9 Notification Service (Servicio de Notificaciones)

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Java — Spring Boot |
| Base de datos | PostgreSQL |

**Justificación de base de datos:** Registra qué notificaciones se enviaron, a quién, por qué canal, si fueron leídas. Son datos transaccionales y consultables con relaciones claras.

---

## 4. Capa de IAs — 5 Servicios de Inteligencia Artificial

### 4.1 Base Común

Todos los servicios de IA comparten la siguiente base tecnológica:

| Aspecto | Tecnología |
|---------|------------|
| Lenguaje y framework | Python — FastAPI |
| Contrato estándar | Interfaz genérica de entrada/salida común |
| Health check | Endpoint estándar de salud |

### 4.2 Tecnologías Específicas por Modelo

Las librerías de Machine Learning, la base de datos propia (si la necesita) y los detalles de preprocesamiento de cada servicio de IA se definirán en un documento aparte cuando se especifique cada modelo de predicción.

| # | Servicio | Librerías ML | Base de datos | Estado |
|---|----------|-------------|---------------|--------|
| 1 | IA Service 1 | Por definir | Por definir | Pendiente |
| 2 | IA Service 2 | Por definir | Por definir | Pendiente |
| 3 | IA Service 3 | Por definir | Por definir | Pendiente |
| 4 | IA Service 4 | Por definir | Por definir | Pendiente |
| 5 | IA Service 5 | Por definir | Por definir | Pendiente |

---

## 5. Capa de Clientes

### 5.1 Admin Web App (Aplicación Web de Administración)

| Aspecto | Tecnología |
|---------|------------|
| Framework | React |
| Lenguaje | TypeScript |
| Tipo de aplicación | Single Page Application (SPA) |

---

### 5.2 Mobile App (Aplicación Móvil)

| Aspecto | Tecnología |
|---------|------------|
| Framework | Flutter |
| Lenguaje | Dart |
| Plataformas | Android e iOS |

---

## 6. Capa de Infraestructura Transversal — 9 Componentes

### 6.1 Comunicación y Configuración

| Componente | Tecnología | Descripción |
|------------|------------|-------------|
| API Gateway | Spring Cloud Gateway | Punto de entrada único. Nativo del ecosistema Spring Cloud, se configura junto con los microservicios Java. |
| Message Broker | RabbitMQ | Cola de mensajes asíncrona. Ligero, fácil de configurar, soporta las colas necesarias para flujos batch, eventos de entrenamiento y alertas. |
| Service Discovery | Eureka (Spring Cloud) | Registro dinámico de servicios. Nativo de Spring Cloud, integración sin fricción con los microservicios Java. |
| Config Service | Spring Cloud Config | Configuración centralizada por ambiente (desarrollo, staging, producción). Nativo de Spring Cloud. |

### 6.2 Almacenamiento

| Componente | Tecnología | Descripción |
|------------|------------|-------------|
| Cache Service | Redis | Caché compartida de alto rendimiento. Estándar de la industria para caché, soporta TTL configurable y almacenamiento de sesiones. |
| Base de Datos SQL | PostgreSQL | Almacenamiento relacional para datos transaccionales (usuarios, predicciones, metadata de modelos, configuraciones de jobs, notificaciones). |
| Base de Datos NoSQL | MongoDB | Almacenamiento documental para datos no estructurados y variables (logs, métricas de entrenamiento, detalles expandidos de predicciones). |
| Object Storage | MinIO | Almacén de archivos pesados compatible con API de Amazon S3. Para datasets, modelos entrenados, backups y logs históricos. Independiente del proveedor cloud. |

### 6.3 Operaciones

| Componente | Tecnología | Descripción |
|------------|------------|-------------|
| Log Aggregator | ELK Stack (Elasticsearch + Logstash + Kibana) | Agregación centralizada de logs. Elasticsearch para almacenamiento y búsqueda, Logstash para recolección, Kibana para visualización. |
| Container Orchestrator | Docker + Kubernetes | Docker para contenedorización de cada microservicio. Kubernetes para orquestación, self-healing, auto-scaling y rolling updates. |
| CI/CD Pipeline | GitHub Actions | Integración y despliegue continuo integrado con el repositorio. Pipelines como código, gratuito para proyectos. |

---

## 7. Herramientas Complementarias de Desarrollo

| Herramienta | Tecnología | Uso |
|-------------|------------|-----|
| Repositorio de código | GitHub | Monorepo del proyecto |
| Documentación de APIs | Swagger / OpenAPI | Generada automáticamente por Spring Boot y FastAPI |
| Testing backend Java | JUnit + Mockito | Pruebas unitarias y de integración para servicios Spring Boot |
| Testing backend Python | Pytest | Pruebas unitarias y de integración para servicios FastAPI |
| Testing frontend web | Jest + React Testing Library | Pruebas para componentes y lógica de la SPA React |
| Testing mobile | Flutter Test | Pruebas unitarias y de widgets para la app Flutter |

---

## 8. Resumen del Stack Tecnológico

### Por Lenguaje

| Lenguaje | Componentes |
|----------|-------------|
| Java (Spring Boot) | Auth, Model Registry, Orchestrator, Scheduler, Prediction Storage, Dataset Management, Logging & Monitoring, Notification + API Gateway, Service Discovery, Config Service |
| Python (FastAPI) | Training Service + 5 Servicios de IA |
| TypeScript (React) | Admin Web App |
| Dart (Flutter) | Mobile App |

### Por Base de Datos

| Base de datos | Servicios que la utilizan |
|---------------|--------------------------|
| PostgreSQL | Auth, Model Registry, Scheduler, Prediction Storage (datos base), Dataset Management (metadata), Notification |
| MongoDB | Prediction Storage (detalles expandidos), Training Service, Logging & Monitoring |
| Redis | Cache Service (compartido por todos los servicios) |
| MinIO | Object Storage (datasets, modelos entrenados, backups) |

### Conteo Total de Tecnologías

| Categoría | Tecnologías |
|-----------|-------------|
| Lenguajes de programación | 4 (Java, Python, TypeScript, Dart) |
| Frameworks | 4 (Spring Boot, FastAPI, React, Flutter) |
| Bases de datos | 4 (PostgreSQL, MongoDB, Redis, MinIO) |
| Infraestructura | 6 (Spring Cloud Gateway, Eureka, Spring Cloud Config, RabbitMQ, ELK Stack, Docker + Kubernetes) |
| Herramientas de desarrollo | 3 (GitHub, GitHub Actions, Swagger/OpenAPI) |
| Frameworks de testing | 4 (JUnit + Mockito, Pytest, Jest, Flutter Test) |
| **Total de tecnologías** | **25** |

---

## 9. Nota sobre Herramientas de Infraestructura

Las herramientas de infraestructura (RabbitMQ, MinIO, ELK Stack, Redis, etc.) son **productos ya construidos** que se despliegan como contenedores Docker, se configuran y se consumen desde los microservicios. El equipo de desarrollo no programa dentro de estas herramientas, sino que las utiliza a través de librerías cliente en Java o Python.

| Herramienta | Escrita en | Cómo se consume desde el proyecto |
|-------------|-----------|-----------------------------------|
| RabbitMQ | Erlang | Librerías cliente en Java (Spring AMQP) y Python (pika) |
| Redis | C | Librerías cliente en Java (Spring Data Redis) y Python (redis-py) |
| MinIO | Go | SDK compatible con Amazon S3 en Java (AWS SDK) y Python (boto3) |
| Elasticsearch | Java | Librerías cliente en Java (Spring Data Elasticsearch) |
| Logstash | Java | Configuración de pipelines de recolección de logs |
| Kibana | JavaScript | Interfaz web para visualización de logs (no requiere código) |
