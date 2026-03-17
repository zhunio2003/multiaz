# PRODUCT BACKLOG — HISTORIAS DE USUARIO Y TECHNICAL STORIES

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.0  
**Fecha:** 17 de Marzo del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento contiene las **Historias de Usuario** y **Technical Stories** del Product Backlog del sistema MultIAZ, organizadas por épica y fase de desarrollo. Cada historia incluye su descripción en formato estándar y sus criterios de aceptación.

**Documentos de referencia:**

- `PRODUCT_BACKLOG_EPICAS_MULTIAZ.md` — Épicas y fases de desarrollo.
- `PRODUCT_VISION_BOARD_MULTIAZ.md` — Visión, usuarios, necesidades y objetivos de negocio.
- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).

**Formato de las historias:**

- **Historias de Usuario:** "Como [tipo de usuario], quiero [acción], para [beneficio]."
- **Technical Stories:** "Como [sistema / equipo de desarrollo], necesito [capacidad técnica], para que [beneficio técnico o habilitación]."

---

## 2. Fase 1 — Fundación (Infraestructura)

**Objetivo:** Establecer la base técnica sin la cual ningún servicio puede existir.

---

### EP-14 — Comunicación y Configuración

---

#### TS-14.1 — Configuración del Message Broker

**Story:** "Como sistema, necesito un Message Broker configurado y operativo, para que los microservicios puedan comunicarse de forma asíncrona sin acoplamiento directo entre ellos."

**Criterios de aceptación:**

1. El Message Broker está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede publicar un mensaje en una cola y otro servicio lo consume exitosamente.
3. Los mensajes se entregan en orden y persisten hasta ser procesados (no se pierden si el consumidor está temporalmente caído).
4. Las colas necesarias para los flujos del sistema están creadas:
   - Trabajos batch (Scheduler → Orchestrator).
   - Predicción batch completada (Orchestrator → Prediction Storage y → Notification Service).
   - Entrenamiento completado (Training Service → Notification Service).
   - Alertas de monitoreo (Logging & Monitoring → Notification Service).

---

#### TS-14.2 — Configuración del Service Discovery

**Story:** "Como sistema, necesito un servicio de descubrimiento dinámico, para que los microservicios puedan localizarse entre sí automáticamente sin direcciones hardcodeadas en el código."

**Criterios de aceptación:**

1. El Service Discovery está desplegado, accesible y responde health checks correctamente.
2. Un microservicio al iniciar se registra automáticamente con su nombre y dirección.
3. Un microservicio puede consultar la ubicación de otro servicio por nombre y obtener su dirección actual.
4. Si un servicio se reinicia o escala en una dirección diferente, el registro se actualiza automáticamente sin intervención manual.
5. Si un servicio se cae, el Service Discovery lo detecta y lo marca como no disponible.

---

#### TS-14.3 — Configuración del Servicio de Configuración Centralizada

**Story:** "Como sistema, necesito un servicio de configuración centralizada, para que todos los microservicios obtengan sus configuraciones desde un único punto en lugar de tenerlas repetidas individualmente."

**Criterios de aceptación:**

1. El Config Service está desplegado, accesible y responde health checks correctamente.
2. Las configuraciones de todos los microservicios están almacenadas en un solo lugar (credenciales de base de datos, API keys, feature flags, etc.).
3. Cada microservicio consulta y obtiene sus configuraciones al arrancar correctamente.
4. Un cambio de configuración se realiza una sola vez en el Config Service y los servicios afectados lo reciben sin necesidad de redespliegue (actualización en caliente).
5. Se soportan configuraciones diferenciadas por ambiente: desarrollo, staging y producción.

---

### EP-15 — Almacenamiento

---

#### TS-15.1 — Configuración del Cache Service

**Story:** "Como sistema, necesito una capa de caché compartida, para que las consultas frecuentes se sirvan rápidamente sin golpear la base de datos en cada petición."

**Criterios de aceptación:**

1. El Cache Service está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede almacenar y recuperar datos desde la caché correctamente.
3. Los datos cacheados tienen un tiempo de expiración configurable (TTL) para evitar servir información desactualizada.
4. Ante un cache miss (dato no encontrado en caché), la consulta se redirige a la base de datos, y el resultado se almacena en caché para futuras consultas.
5. Los tipos de datos cacheables están definidos: predicciones batch frecuentes, metadata de modelos del Model Registry y sesiones de usuario.

---

#### TS-15.2 — Configuración de la Base de Datos Principal

**Story:** "Como sistema, necesito almacenamiento persistente de datos, para que la información de usuarios, predicciones, metadata de modelos y logs se conserve de forma confiable y estructurada."

**Criterios de aceptación:**

1. Los servidores de base de datos (SQL y NoSQL) están desplegados, accesibles y responden health checks correctamente.
2. Dentro de los servidores, cada microservicio tiene su propio esquema o base de datos lógica independiente, siguiendo el patrón Database per Service.
3. Los datos transaccionales (usuarios, predicciones, metadata de modelos) se almacenan en base de datos relacional (SQL).
4. Los datos no estructurados (logs, eventos) se almacenan en base de datos NoSQL.
5. Los esquemas iniciales están creados con las tablas y colecciones necesarias para los servicios core del sistema.
6. Se cuenta con una estrategia de backups configurada para evitar pérdida de datos.

---

#### TS-15.3 — Configuración del Object Storage

**Story:** "Como sistema, necesito un almacén de objetos para archivos pesados y binarios, para que los datasets, modelos entrenados y backups se almacenen de forma independiente a la base de datos relacional."

**Criterios de aceptación:**

1. El Object Storage está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede subir y descargar archivos correctamente (datasets, modelos serializados).
3. Los archivos se organizan en una estructura lógica definida (por ejemplo, separando datasets, modelos entrenados, backups y logs históricos).
4. Se soportan archivos de gran tamaño (cientos de MB o GB) sin fallos ni timeouts.
5. Los backups de la base de datos se almacenan aquí según la estrategia definida en TS-15.2.

---

### EP-16 — Operaciones

---

#### TS-16.1 — Configuración del Container Orchestrator

**Story:** "Como sistema, necesito un orquestador de contenedores, para que todos los microservicios se desplieguen, escalen y se recuperen de fallos de forma automatizada."

**Criterios de aceptación:**

1. El orquestador de contenedores está desplegado y operativo.
2. Los microservicios se despliegan como contenedores gestionados por el orquestador.
3. Si un contenedor se cae, el orquestador lo levanta automáticamente (self-healing).
4. Un servicio puede escalar horizontalmente (más instancias) cuando la carga aumenta y reducir instancias cuando la carga baja.
5. Los despliegues se realizan sin downtime (rolling updates o blue-green deployment).
6. La red interna entre servicios está configurada para que los contenedores se comuniquen entre sí.
7. Los secrets y configuraciones sensibles se gestionan de forma segura dentro del orquestador.

---

#### TS-16.2 — Configuración del CI/CD Pipeline

**Story:** "Como equipo de desarrollo, necesitamos un pipeline de integración y despliegue continuo, para que el código pase automáticamente por pruebas, construcción y despliegue sin intervención manual."

**Criterios de aceptación:**

1. El pipeline se activa automáticamente cuando se sube un cambio al repositorio de código.
2. Se ejecutan pruebas automatizadas (unitarias e integración) y el pipeline se detiene si alguna falla.
3. Si las pruebas pasan, se construye automáticamente la imagen del contenedor del servicio modificado.
4. La imagen construida se despliega automáticamente en el ambiente de staging para validación.
5. Tras aprobación manual, se despliega en el ambiente de producción a través del Container Orchestrator (TS-16.1).

---

## 3. Fase 2 — Experiencia del Usuario

**Objetivo:** Permitir que el usuario final pueda usar la plataforma en sus funcionalidades esenciales.

*Pendiente de desarrollo.*

---

## 4. Fase 3 — Administración de la Plataforma

**Objetivo:** Dotar al administrador de las herramientas para gestionar y operar la plataforma de forma autónoma.

*Pendiente de desarrollo.*

---

## 5. Fase 4 — Mejoras Avanzadas

**Objetivo:** Funcionalidades de valor agregado que mejoran la experiencia pero no son esenciales para la operación básica.

*Pendiente de desarrollo.*

---
