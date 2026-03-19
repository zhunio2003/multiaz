# DESPLIEGUE DOCKER — ESTRATEGIA DE CONTENEDORES

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.0  
**Fecha:** 19 de Marzo del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento define la **estrategia de despliegue con Docker** del sistema MultIAZ, detallando los contenedores, la asignación de puertos, las redes de comunicación y los volúmenes de persistencia necesarios para operar la plataforma completa. Las decisiones fueron tomadas durante el Sprint 0 como parte de la preparación técnica previa al inicio del desarrollo.

**Documentos de referencia:**

- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).
- `ARQUITECTURA_INICIAL_MULTIAZ.md` — Diagrama de arquitectura de microservicios.
- `TECHNOLOGY_STACK_MULTIAZ.md` — Decisiones tecnológicas y stack completo.

---

## 2. Estrategia General de Despliegue

Cada componente del sistema MultIAZ se despliega como un **contenedor Docker independiente**, siguiendo el principio de aislamiento de la arquitectura de microservicios. Esto permite que cada servicio se construya, despliegue, escale y actualice de forma autónoma sin afectar a los demás.

**Principios de despliegue:**

- **Un contenedor por servicio:** Cada microservicio y cada herramienta de infraestructura corre en su propio contenedor aislado.
- **Redes segmentadas:** Los contenedores se organizan en redes Docker que limitan la comunicación únicamente a los servicios que necesitan interactuar entre sí.
- **Persistencia garantizada:** Los datos críticos se almacenan en volúmenes Docker que sobreviven a reinicios y recreaciones de contenedores.
- **Convención de puertos:** Se utiliza un esquema de puertos organizado por rangos según la tecnología y el grupo funcional del servicio.

**Exclusiones:**

- **Mobile App (Flutter):** Se compila como aplicación nativa y se instala directamente en los dispositivos de los usuarios (Android e iOS). No requiere contenedor en la infraestructura del servidor.
- **CI/CD Pipeline (GitHub Actions):** Se ejecuta en los servidores de GitHub, no en la infraestructura propia del proyecto. No requiere contenedor.

---

## 3. Inventario de Contenedores

El sistema MultIAZ se compone de **26 contenedores Docker**, organizados en 5 grupos.

---

### 3.1 Capa de Entrada — 1 Contenedor

| Contenedor | Tecnología | Puerto | Descripción |
|------------|------------|--------|-------------|
| api-gateway | Spring Cloud Gateway | 8080 | Punto de acceso único al sistema. Autenticación, rate limiting, routing, CORS y versionado de API. |

---

### 3.2 Servicios Core (Java — Spring Boot) — 8 Contenedores

Los microservicios core escritos en Java utilizan el rango de puertos **8081–8089**, organizados por grupo funcional.

| Contenedor | Puerto | Grupo Funcional | Descripción |
|------------|--------|-----------------|-------------|
| auth-service | 8081 | Identidad y Acceso | Registro, login, JWT, refresh tokens, roles, perfiles y auditoría de sesiones. |
| prediction-orchestrator | 8082 | Motor de Predicciones | Director de orquesta del sistema. Único componente que se comunica con los servicios de IA. Modos síncrono y asíncrono. |
| model-registry | 8083 | Motor de Predicciones | Catálogo centralizado de modelos de IA. Metadata, versiones, esquemas y activación/desactivación. |
| prediction-storage | 8084 | Motor de Predicciones | Almacén central de todas las predicciones generadas (tiempo real y batch). Historial y estadísticas. |
| scheduler-service | 8085 | Motor de Predicciones | Motor de ejecución batch. Tareas programadas, reintentos automáticos y ejecución manual. |
| dataset-management | 8086 | Mejora de Modelos | Gestión de datasets de entrenamiento. Carga, versionado, validación y asociación con modelos. |
| logging-monitoring | 8087 | Operaciones | Recolección centralizada de logs, monitoreo de salud, rendimiento y generación de alertas automáticas. |
| notification-service | 8088 | Operaciones | Notificaciones push, email e in-app para usuarios y administradores. |

**Puerto 8089 reservado** para futuros servicios core en Java.

---

### 3.3 Servicios Python (FastAPI) — 6 Contenedores

Los servicios escritos en Python utilizan el rango de puertos **8090–8099**, separando el Training Service de los servicios de IA.

| Contenedor | Puerto | Grupo | Descripción |
|------------|--------|-------|-------------|
| training-service | 8090 | Mejora de Modelos | Reentrenamiento de modelos, monitoreo de progreso, métricas, comparación de versiones, promoción y rollback. |
| ia-service-1 | 8091 | Capa de IAs | Modelo de predicción NLP (por definir). |
| ia-service-2 | 8092 | Capa de IAs | Modelo de predicción NLP (por definir). |
| ia-service-3 | 8093 | Capa de IAs | Modelo de predicción NLP (por definir). |
| ia-service-4 | 8094 | Capa de IAs | Modelo de predicción NLP (por definir). |
| ia-service-5 | 8095 | Capa de IAs | Modelo de predicción NLP (por definir). |

**Puertos 8096–8099 reservados** para futuros servicios de IA. Agregar una nueva IA implica desplegar un nuevo contenedor en el siguiente puerto disponible y registrarla en el Model Registry.

---

### 3.4 Cliente Web — 1 Contenedor

| Contenedor | Tecnología | Puerto | Descripción |
|------------|------------|--------|-------------|
| admin-web-app | Nginx | 80 / 443 | Servidor web que sirve los archivos estáticos (HTML, CSS, JS) de la SPA React. Puerto 80 para HTTP y 443 para HTTPS. |

---

### 3.5 Infraestructura Transversal — 10 Contenedores

Herramientas de infraestructura desplegadas como contenedores Docker. Son productos ya construidos que se configuran y consumen desde los microservicios a través de librerías cliente.

#### Comunicación y Configuración

| Contenedor | Tecnología | Puerto | Descripción |
|------------|------------|--------|-------------|
| rabbitmq | RabbitMQ | 5672 / 15672 | Cola de mensajes asíncrona. Puerto 5672 para comunicación entre servicios (protocolo AMQP). Puerto 15672 para panel de administración web. |
| service-discovery | Eureka (Spring Cloud) | 8761 | Registro dinámico de servicios. Puerto 8761 es el estándar de Eureka. Los microservicios se registran aquí al iniciar y consultan la ubicación de otros servicios. |
| config-service | Spring Cloud Config | 8888 | Configuración centralizada por ambiente (desarrollo, staging, producción). Puerto 8888 es el estándar de Spring Cloud Config. |

#### Almacenamiento

| Contenedor | Tecnología | Puerto | Descripción |
|------------|------------|--------|-------------|
| redis | Redis | 6379 | Caché compartida de alto rendimiento. Predicciones batch frecuentes, metadata de modelos y sesiones de usuario. |
| postgresql | PostgreSQL | 5432 | Base de datos relacional para datos transaccionales: usuarios, predicciones, metadata de modelos, configuraciones de jobs y notificaciones. |
| mongodb | MongoDB | 27017 | Base de datos documental para datos no estructurados: logs, métricas de entrenamiento y detalles expandidos de predicciones. |
| minio | MinIO | 9000 / 9001 | Almacén de objetos compatible con API S3. Puerto 9000 para API de archivos. Puerto 9001 para consola web de administración. Almacena datasets, modelos entrenados, backups y logs históricos. |

#### Observabilidad (ELK Stack)

| Contenedor | Tecnología | Puerto | Descripción |
|------------|------------|--------|-------------|
| elasticsearch | Elasticsearch | 9200 | Motor de búsqueda y almacenamiento de logs indexados. Permite búsqueda y filtrado rápido sobre grandes volúmenes de logs. |
| logstash | Logstash | 5044 | Recolector y procesador de logs. Recibe logs de los contenedores a través del Docker logging driver, los transforma y los envía a Elasticsearch. |
| kibana | Kibana | 5601 | Interfaz web de visualización de logs. Consumida desde el módulo de Logs y Alertas del Admin Web App. |

---

## 4. Convención de Puertos

La asignación de puertos sigue un esquema organizado que permite identificar rápidamente el tipo de servicio por su rango de puerto.

| Rango | Grupo | Lenguaje |
|-------|-------|----------|
| 80 / 443 | Cliente web (Nginx) | — |
| 8080 | API Gateway | Java |
| 8081–8089 | Servicios core | Java (Spring Boot) |
| 8090–8099 | Training Service + Servicios de IA | Python (FastAPI) |
| 8761 | Service Discovery (Eureka) | Java |
| 8888 | Config Service (Spring Cloud Config) | Java |
| 5432 | PostgreSQL | — |
| 5672 / 15672 | RabbitMQ | — |
| 6379 | Redis | — |
| 9000 / 9001 | MinIO | — |
| 9200 | Elasticsearch | — |
| 5044 | Logstash | — |
| 5601 | Kibana | — |
| 27017 | MongoDB | — |

**Criterio de organización para servicios propios:** Los servicios Java (Spring Boot) se agrupan en el rango 8081–8089 y los servicios Python (FastAPI) en el rango 8090–8099. Dentro de cada rango, los servicios se ordenan por grupo funcional: primero Identidad y Acceso, luego Motor de Predicciones, después Mejora de Modelos y finalmente Operaciones. Esto permite que al ver un puerto se identifique inmediatamente la tecnología y el grupo al que pertenece.

---

## 5. Redes Docker

El sistema utiliza **5 redes Docker** que segmentan la comunicación entre contenedores. Cada red agrupa los servicios que necesitan interactuar entre sí, siguiendo el principio de **mínimo privilegio de comunicación**: un contenedor solo puede ver a otros contenedores que están en su misma red.

Un contenedor puede pertenecer a **múltiples redes** simultáneamente cuando necesita comunicarse con servicios de diferentes grupos.

---

### 5.1 Red `net-gateway` — Exposición de Servicios

**Propósito:** Conectar el API Gateway con los microservicios core a los que redirige peticiones.

| Contenedor | Justificación |
|------------|---------------|
| api-gateway | Punto de entrada que redirige peticiones a los servicios core. |
| auth-service | Recibe peticiones de autenticación y validación de tokens. |
| prediction-orchestrator | Recibe solicitudes de predicción en tiempo real. |
| model-registry | Recibe consultas del catálogo de modelos. |
| prediction-storage | Recibe consultas de resultados de predicciones. |
| scheduler-service | Recibe consultas y ejecuciones manuales de tareas batch. |
| dataset-management | Recibe peticiones de gestión de datasets. |
| training-service | Recibe peticiones de lanzamiento de entrenamientos. |
| logging-monitoring | Recibe consultas de logs y estado del sistema. |

---

### 5.2 Red `net-database` — Acceso a Datos

**Propósito:** Conectar los microservicios con las bases de datos y servicios de almacenamiento que utilizan.

| Contenedor | Justificación |
|------------|---------------|
| postgresql | Base de datos relacional consumida por múltiples servicios core. |
| mongodb | Base de datos documental consumida por servicios con datos no estructurados. |
| redis | Caché compartida consumida por servicios que requieren respuestas rápidas. |
| minio | Object Storage consumido por servicios que gestionan archivos pesados. |
| auth-service | Persiste usuarios, roles y sesiones en PostgreSQL. |
| model-registry | Persiste metadata de modelos y versiones en PostgreSQL. |
| prediction-storage | Persiste predicciones en PostgreSQL, detalles expandidos en MongoDB y consulta caché en Redis. |
| scheduler-service | Persiste configuración de jobs y ejecuciones en PostgreSQL. |
| dataset-management | Persiste metadata en PostgreSQL y almacena archivos en MinIO. |
| notification-service | Persiste registro de notificaciones enviadas en PostgreSQL. |
| training-service | Persiste métricas de entrenamiento en MongoDB. Descarga datasets desde MinIO. |
| logging-monitoring | Persiste logs y eventos en MongoDB. |

---

### 5.3 Red `net-message` — Mensajería Asíncrona

**Propósito:** Conectar los microservicios que publican o consumen mensajes a través del Message Broker.

| Contenedor | Justificación |
|------------|---------------|
| rabbitmq | Message Broker central que gestiona todas las colas de mensajes. |
| scheduler-service | Publica trabajos batch en la cola para ejecución asíncrona. |
| prediction-orchestrator | Consume trabajos batch de la cola y publica eventos de predicción completada. |
| training-service | Publica eventos de entrenamiento completado. |
| notification-service | Consume eventos de predicciones batch listas, entrenamientos completados y alertas. |
| logging-monitoring | Publica alertas detectadas (servicio caído, tiempos de respuesta altos, tasa de error elevada). |

---

### 5.4 Red `net-prediction` — Comunicación con IAs

**Propósito:** Conectar el Prediction Orchestrator con los servicios de IA. Esta red aísla los modelos de predicción del resto del sistema, garantizando que solo el orquestador pueda invocarlos.

| Contenedor | Justificación |
|------------|---------------|
| prediction-orchestrator | Único componente autorizado para invocar a los servicios de IA. |
| ia-service-1 | Servicio de IA que recibe solicitudes de predicción del orquestador. |
| ia-service-2 | Servicio de IA que recibe solicitudes de predicción del orquestador. |
| ia-service-3 | Servicio de IA que recibe solicitudes de predicción del orquestador. |
| ia-service-4 | Servicio de IA que recibe solicitudes de predicción del orquestador. |
| ia-service-5 | Servicio de IA que recibe solicitudes de predicción del orquestador. |

**Nota:** Al agregar una nueva IA al sistema, solo es necesario desplegar su contenedor dentro de esta red y registrarla en el Model Registry.

---

### 5.5 Red `net-logging` — Observabilidad

**Propósito:** Conectar el servicio de Logging & Monitoring con el ELK Stack para el envío y procesamiento de logs centralizados.

| Contenedor | Justificación |
|------------|---------------|
| logging-monitoring | Envía logs procesados y métricas al ELK Stack. |
| elasticsearch | Almacena y permite la búsqueda de logs indexados. |
| logstash | Recolecta, transforma y enruta logs hacia Elasticsearch. |
| kibana | Interfaz de visualización de logs consumida desde el panel de administración. |

**Nota sobre logs de contenedores:** Los demás contenedores del sistema envían sus logs a Logstash a través del **Docker logging driver**, una funcionalidad nativa de Docker que no requiere que los contenedores estén en la misma red. Esto permite recolectar logs de todos los servicios sin exponerlos en la red de observabilidad.

---

### 5.6 Resumen de Pertenencia a Redes

La siguiente tabla muestra a qué redes pertenece cada contenedor. Los contenedores que participan en múltiples flujos del sistema aparecen en varias redes simultáneamente.

| Contenedor | net-gateway | net-database | net-message | net-prediction | net-logging |
|------------|:-----------:|:------------:|:-----------:|:--------------:|:-----------:|
| api-gateway | ✅ | | | | |
| auth-service | ✅ | ✅ | | | |
| prediction-orchestrator | ✅ | | ✅ | ✅ | |
| model-registry | ✅ | ✅ | | | |
| prediction-storage | ✅ | ✅ | | | |
| scheduler-service | ✅ | ✅ | ✅ | | |
| dataset-management | ✅ | ✅ | | | |
| training-service | ✅ | ✅ | ✅ | | |
| logging-monitoring | ✅ | ✅ | ✅ | | ✅ |
| notification-service | | ✅ | ✅ | | |
| ia-service-1 | | | | ✅ | |
| ia-service-2 | | | | ✅ | |
| ia-service-3 | | | | ✅ | |
| ia-service-4 | | | | ✅ | |
| ia-service-5 | | | | ✅ | |
| admin-web-app | | | | | |
| postgresql | | ✅ | | | |
| mongodb | | ✅ | | | |
| redis | | ✅ | | | |
| minio | | ✅ | | | |
| rabbitmq | | | ✅ | | |
| elasticsearch | | | | | ✅ |
| logstash | | | | | ✅ |
| kibana | | | | | ✅ |
| service-discovery | ✅ | | | ✅ | |
| config-service | ✅ | | | | |

**Observaciones:**

- El **Prediction Orchestrator** es el servicio más conectado del sistema, participando en 3 redes: recibe peticiones del Gateway, consume/publica mensajes del Broker y se comunica con las IAs.
- El **Logging & Monitoring Service** participa en 4 redes: recibe peticiones del Gateway, persiste datos en MongoDB, publica alertas en el Broker y envía logs al ELK Stack.
- Los **servicios de IA** están aislados en una única red, accesibles exclusivamente a través del Orchestrator.
- El **Admin Web App (Nginx)** no pertenece a ninguna red interna: sirve archivos estáticos que el navegador del administrador descarga, y las peticiones del navegador se dirigen al API Gateway por HTTPS público.
- El **Service Discovery (Eureka)** pertenece a la red gateway (para que los servicios core se registren y se descubran) y a la red prediction (para que los servicios de IA también se registren).
- El **Config Service** pertenece a la red gateway para que los servicios core obtengan sus configuraciones al arrancar.

---

## 6. Volúmenes Docker

El sistema utiliza **6 volúmenes Docker** para garantizar la persistencia de datos críticos. Sin volúmenes, los datos almacenados dentro de un contenedor se perderían si el contenedor se reinicia, se recrea o se actualiza.

| Volumen | Contenedor | Datos que Persiste |
|---------|------------|--------------------|
| vol-postgresql | postgresql | Datos transaccionales: usuarios, roles, sesiones, predicciones (datos base), metadata de modelos, versiones, configuraciones de jobs, historial de ejecuciones y registro de notificaciones. |
| vol-mongodb | mongodb | Datos no estructurados: logs del sistema, métricas de entrenamiento (accuracy, loss, precision, recall, F1-score), detalles expandidos de predicciones (inputs/outputs variables por modelo). |
| vol-redis | redis | Datos de caché: predicciones batch frecuentemente consultadas, metadata de modelos del Model Registry y sesiones de usuario. Aunque la caché puede regenerarse, la persistencia evita un arranque en frío tras un reinicio. |
| vol-minio | minio | Archivos pesados: datasets de entrenamiento (CSV, JSON de cientos de MB o GB), modelos de IA entrenados (archivos serializados), backups de bases de datos y logs históricos archivados. |
| vol-elasticsearch | elasticsearch | Logs indexados: todos los logs recolectados del sistema, procesados por Logstash e indexados para búsqueda y filtrado rápido desde Kibana. |
| vol-rabbitmq | rabbitmq | Mensajes en tránsito: mensajes publicados en colas que aún no han sido procesados por el consumidor correspondiente. La persistencia garantiza que ningún mensaje se pierda si el Broker se reinicia. |

---

## 7. Variables de Entorno

Cada contenedor recibe su configuración a través de **variables de entorno**, gestionadas por el Config Service (Spring Cloud Config) para los microservicios propios y por archivos de configuración Docker para las herramientas de infraestructura.

### 7.1 Variables Comunes a Todos los Microservicios

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `SPRING_PROFILES_ACTIVE` / `APP_ENV` | Ambiente de ejecución activo | `dev`, `staging`, `prod` |
| `CONFIG_SERVER_URL` | URL del Config Service | `http://config-service:8888` |
| `EUREKA_SERVER_URL` | URL del Service Discovery | `http://service-discovery:8761/eureka` |
| `RABBITMQ_HOST` | Host del Message Broker | `rabbitmq` |
| `RABBITMQ_PORT` | Puerto del Message Broker | `5672` |

### 7.2 Variables de Conexión a Bases de Datos

| Variable | Descripción | Servicios que la utilizan |
|----------|-------------|---------------------------|
| `POSTGRES_HOST` / `POSTGRES_PORT` | Conexión a PostgreSQL | Auth, Model Registry, Scheduler, Prediction Storage, Dataset Management, Notification |
| `POSTGRES_DB` | Nombre de la base de datos lógica del servicio | Cada servicio tiene su propia base de datos |
| `POSTGRES_USER` / `POSTGRES_PASSWORD` | Credenciales de acceso a PostgreSQL | Cada servicio tiene sus propias credenciales |
| `MONGODB_URI` | Cadena de conexión a MongoDB | Prediction Storage, Training Service, Logging & Monitoring |
| `REDIS_HOST` / `REDIS_PORT` | Conexión a Redis | Prediction Storage |
| `MINIO_ENDPOINT` / `MINIO_ACCESS_KEY` / `MINIO_SECRET_KEY` | Conexión a MinIO | Dataset Management, Training Service |

### 7.3 Consideraciones de Seguridad

- Las credenciales de bases de datos, API keys y tokens **nunca se almacenan en texto plano** en archivos de configuración ni en el código fuente.
- En ambiente de desarrollo, las credenciales se gestionan a través de archivos `.env` excluidos del repositorio (listados en `.gitignore`).
- En ambientes de staging y producción, las credenciales se gestionan a través de **secrets de Kubernetes**, inyectados como variables de entorno en los contenedores de forma segura.
- El Config Service almacena configuraciones no sensibles (feature flags, URLs de servicios, parámetros de negocio). Las credenciales sensibles se manejan exclusivamente a través de secrets.

---

## 8. Resumen

### Conteo General

| Concepto | Cantidad |
|----------|----------|
| Contenedores Docker | 26 |
| Redes Docker | 5 |
| Volúmenes Docker | 6 |
| Puertos asignados | 30 (contando puertos duales) |

### Distribución de Contenedores

| Grupo | Contenedores | Rango de Puertos |
|-------|-------------|------------------|
| Capa de Entrada | 1 | 8080 |
| Servicios Core (Java) | 8 | 8081–8088 |
| Servicios Python | 6 | 8090–8095 |
| Cliente Web | 1 | 80 / 443 |
| Infraestructura | 10 | Puertos estándar de cada tecnología |

### Componentes Excluidos del Despliegue Docker

| Componente | Razón de exclusión |
|------------|-------------------|
| Mobile App (Flutter) | Se compila como aplicación nativa instalada en dispositivos de los usuarios. |
| CI/CD Pipeline (GitHub Actions) | Se ejecuta en los servidores de GitHub, no en la infraestructura propia. |
