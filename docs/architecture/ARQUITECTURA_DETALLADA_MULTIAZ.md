# ARQUITECTURA DEL SISTEMA MULTIAZ 

**Proyecto:** Plataforma de predicciones basada en inteligencia artificial  
**Tipo de arquitectura:** Microservicios  
**Versión del documento:** 1.0  
**Fecha:** 13 de Marzo del 2026

---

## 1. Visión General del Sistema

Este sistema es una **plataforma de predicciones** impulsada por modelos de Inteligencia Artificial de tipo NLP. No se trata de un sistema acoplado a un número fijo de modelos, sino de una plataforma **genérica, escalable y agnóstica** que permite registrar, orquestar y consumir modelos de IA como plugins independientes.

Actualmente la plataforma opera con 5 modelos de predicción (noticias, precios de autos, etc.), pero su diseño permite agregar nuevos modelos en el futuro sin modificar la arquitectura ni afectar los servicios existentes.

## Principios de diseño

- **Agnóstico a los modelos:** Las IAs son plugins que se enchufan a la plataforma. El sistema no depende de ningún modelo específico.
- **Desacoplamiento total:** Cada microservicio es independiente. Si uno cae, los demás siguen funcionando.
- **Escalabilidad horizontal:** Cada componente puede escalar de forma independiente según la demanda.
- **Contrato estándar:** Todas las IAs exponen la misma interfaz. La plataforma les envía datos y recibe predicciones en un formato común.
- **Preparado para crecer:** Agregar la IA número 6, 10 o 20 es tan simple como registrarla en el Model Registry.

---

## 2. Capas del Sistema

El sistema se organiza en **5 capas** bien definidas:

| # | Capa | Descripción |
|---|------|-------------|
| 1 | Capa de Entrada | Punto de acceso único al sistema |
| 2 | Capa de Servicios Core | Microservicios que hacen funcionar la plataforma |
| 3 | Capa de IAs | Los modelos de predicción como servicios independientes |
| 4 | Capa de Clientes | Las aplicaciones que usan las personas |
| 5 | Capa de Infraestructura Transversal | Componentes que sostienen todo el sistema |

---

## 3. Capa de entrada

### 3.1 API GATEWAY

Es la **puerta de entrada única** de todo el sistema. Toda petición, ya sea desde la aplicación web o la app móvil, pasa obligatoriamente por aquí.

**Responsabilidades:**

- Autenticación y validación de tokens en cada request.
- Rate limiting para controlar el abuso de peticiones por usuario.
- Enrutamiento inteligente de cada petición al microservicio correcto.
- Manejo de CORS para comunicación segura entre dominios.
- Versionado de la API para mantener compatibilidad con clientes anteriores.

**Regla fundamental:** Nada entra al sistema sin pasar por el API Gateway.

## 4. Capa de Servicios Core

Son los **9 microservicios** que constituyen el motor de la plataforma.

### 4.1 Auth Service (Servicio de Autenticación y Usuarios)

Gestiona todo lo relacionado con la identidad y el acceso de los usuarios al sistema.

**Funcionalidades:**

- Registro de nuevos usuarios.
- Inicio de sesión (login) con generación de tokens.
- Refresh tokens para mantener sesiones activas de forma segura.
- Recuperación de contraseña.
- Gestión de perfiles de usuario (datos personales, preferencias).
- Manejo de roles (Administrador y Usuario como mínimo).
- Auditoría de sesiones: quién se conectó, cuándo y desde dónde.

**Nota:** Actualmente todos los usuarios acceden a todas las predicciones. El sistema de roles permite distinguir entre administradores (acceso al panel web) y usuarios finales (acceso a la app móvil).

---

### 4.2 Model Registry Service (Servicio de Registro de Modelos)

Es el **cerebro de la plataforma** en lo que respecta al conocimiento de las IAs disponibles. Funciona como un catálogo centralizado de todos los modelos registrados.

**Funcionalidades:**

- Registro de cada modelo con su metadata completa:
  - Nombre y descripción.
  - Versión actual.
  - Tipo de predicción que realiza.
  - Modalidad de ejecución: **tiempo real**, **batch** o **ambas**.
  - Esquema de inputs requeridos.
  - Esquema de outputs que devuelve.
  - Endpoint o dirección del servicio.
- Activación y desactivación de modelos sin eliminarlos.
- Historial de versiones de cada modelo para trazabilidad.
- Consulta del catálogo de modelos disponibles (consumido por la app móvil y el panel web).

**Importancia:** Cuando se agrega una nueva IA al sistema, se registra aquí y automáticamente queda disponible para el orquestador, la app móvil y el panel web sin tocar código.

---

### 4.3 Prediction Orchestrator Service (Servicio Orquestador de Predicciones)

Es el **director de orquesta** del sistema. Es el único componente que se comunica directamente con los servicios de IA.

**Funcionalidades:**

- Recibe solicitudes de predicción desde el API Gateway.
- Consulta el Model Registry para obtener la información del modelo solicitado.
- Llama al servicio de IA correspondiente con los datos del usuario.
- Devuelve la respuesta de la predicción al usuario.
- Persiste cada predicción realizada (delegando al Prediction Storage Service).
- Manejo de errores controlado: si una IA está caída, responde con un error limpio sin romper el sistema.

**Dos modos de operación:**

| Modo | Flujo | Caso de uso |
|------|-------|-------------|
| **Síncrono (Tiempo Real)** | La app pide → Orquestador llama a la IA → Devuelve respuesta al momento | Predicción de precios de autos |
| **Asíncrono (Batch)** | El Scheduler ejecuta la IA → Guarda resultados → La app consulta lo ya almacenado | Predicción de noticias |

**Regla fundamental:** Ni la web ni la app móvil hablan directamente con las IAs. Todo pasa por el orquestador.

---

### 4.4 Scheduler Service (Servicio de Tareas Programadas)

Es el **motor de ejecución batch** del sistema. Se encarga de ejecutar las IAs que funcionan en modo asíncrono según una frecuencia definida.

**Funcionalidades:**

- Ejecución programada de IAs batch según horario configurable (cada hora, diario, semanal, etc.).
- Publicación de trabajos en el Message Broker para desacoplar la ejecución.
- Reintentos automáticos en caso de fallo con estrategia configurable.
- Log detallado de cada ejecución: hora de inicio, hora de fin, estado (éxito/fallo), errores si los hubo.
- Capacidad de lanzar ejecuciones manuales desde el panel web de administración.

---

### 4.5 Prediction Storage Service (Servicio de Almacenamiento de Predicciones)

Es la **bodega central** de todas las predicciones generadas por el sistema, tanto en tiempo real como en batch.

**Funcionalidades:**

- Almacenamiento de predicciones con metadata completa: modelo utilizado, usuario que la solicitó, datos de entrada, resultado, fecha y hora, modo de ejecución (real-time o batch).
- Consulta de historial filtrable por usuario, por modelo, por rango de fechas o por tipo.
- Servir resultados de predicciones batch para consulta de los usuarios.
- Generación de estadísticas de uso:
  - Total de predicciones por período.
  - Modelo más utilizado.
  - Predicciones por usuario.
  - Tendencias de uso.

---

### 4.6 Dataset Management Service (Servicio de Gestión de Datasets)

Gestiona todo lo relacionado con los datos de entrenamiento de los modelos.

**Funcionalidades:**

- Carga (upload) de nuevos datasets.
- Versionado de datasets para no perder versiones anteriores.
- Validación de formato y calidad de los datos antes de ser utilizados.
- Asociación de cada dataset con su modelo correspondiente.
- Metadata de cada dataset: tamaño, número de registros, fecha de carga, descripción, formato.
- Almacenamiento de los archivos en el Object Storage.

---

### 4.7 Training Service (Servicio de Entrenamiento)

Permite reentrenar los modelos de IA con nuevos datos o con datasets actualizados.

**Funcionalidades:**

- Lanzar reentrenamiento de cualquier modelo con un dataset específico.
- Monitoreo del progreso del entrenamiento en tiempo real.
- Almacenamiento de métricas de cada entrenamiento: accuracy, loss, precision, recall, F1-score, etc.
- Comparación de versiones de un modelo para decidir si el nuevo supera al anterior.
- Promoción de un modelo nuevo a producción si las métricas son satisfactorias.
- Rollback a una versión anterior si la nueva presenta problemas.

---

### 4.8 Logging & Monitoring Service (Servicio de Logs y Monitoreo)

Es **los ojos del sistema**. Permite saber qué está pasando en todo momento.

**Funcionalidades:**

- Recolección centralizada de logs de todos los microservicios.
- Monitoreo de salud (health) de cada servicio y de cada IA.
- Monitoreo de rendimiento: tiempos de respuesta, uso de CPU/memoria, throughput.
- Generación de alertas automáticas cuando:
  - Un servicio se cae.
  - Los tiempos de respuesta superan un umbral.
  - La tasa de error aumenta.
  - Un modelo de IA no responde.
- Dashboard de métricas en tiempo real para el panel de administración.

---

### 4.9 Notification Service (Servicio de Notificaciones)

Maneja todas las comunicaciones y alertas del sistema hacia los usuarios y administradores.

**Funcionalidades:**

- Notificaciones a administradores:
  - Alertas cuando una IA se cae o presenta errores.
  - Aviso cuando un entrenamiento finaliza (éxito o fallo).
  - Alertas de rendimiento del sistema.
- Notificaciones a usuarios finales:
  - Aviso cuando hay nuevas predicciones batch disponibles.
  - Notificaciones sobre novedades o nuevos modelos disponibles.
- Canales de envío:
  - Notificaciones push a la app móvil.
  - Email.
  - Notificaciones in-app (dentro del panel web).

---

## 5. Capa de IAs (Servicios de Inteligencia Artificial)

Cada modelo de IA vive como un **microservicio completamente independiente**. Actualmente el sistema cuenta con 5 modelos de predicción, pero la arquitectura soporta la adición de nuevos modelos sin modificar ningún otro componente.

### 5.1 Características Comunes de Cada Servicio de IA

Todos los servicios de IA comparten las siguientes características:

- **Contrato estándar:** Cada IA expone la misma interfaz genérica. Recibe inputs en un formato definido y devuelve una predicción en un formato común.
- **Health Check propio:** Cada IA tiene un endpoint de salud para que el sistema sepa si está activa y funcionando.
- **Base de datos propia (si la necesita):** Cada IA puede tener su propio almacenamiento sin interferir con las demás.
- **Despliegue independiente:** Se despliega, escala y actualiza sin afectar a las demás IAs ni a la plataforma.
- **Declaración de tipo:** Al registrarse en el Model Registry, cada IA declara si es de tipo tiempo real, batch o ambas. El orquestador usa esta información para saber cómo tratarla.

### 5.2 Modelos Actuales

| # | Servicio | Estado |
|---|----------|--------|
| 1 | IA Service 1 | Por definir |
| 2 | IA Service 2 | Por definir |
| 3 | IA Service 3 | Por definir |
| 4 | IA Service 4 | Por definir |
| 5 | IA Service 5 | Por definir |

> Los detalles específicos de cada modelo (nombre, tipo de predicción, inputs/outputs) se definirán en un documento aparte una vez que se especifique cada uno.

### 5.3 Agregar una Nueva IA

Para agregar la IA número 6 (o cualquier nueva), el proceso es:

1. Desarrollar el servicio de IA respetando el contrato estándar.
2. Desplegarlo como un servicio independiente.
3. Registrarlo en el Model Registry con su metadata (nombre, tipo, endpoints, esquemas).
4. El orquestador, la app móvil y el panel web lo descubren automáticamente.

**No se modifica ningún otro servicio.**

---

## 6. Capa de Clientes

Son las dos aplicaciones que interactúan directamente con las personas. Ambas consumen los microservicios exclusivamente a través del API Gateway.

---

### 6.1 Admin Web App (Aplicación Web de Administración)

Es una **Single Page Application (SPA)** diseñada para el equipo técnico y los administradores del sistema.

**Módulos del Panel de Administración:**

- **Dashboard Principal:** Métricas generales del sistema en tiempo real: total de predicciones, modelos activos, salud del sistema, usuarios registrados, alertas activas.
- **Gestión de Modelos:** Registrar nuevos modelos de IA, activar/desactivar modelos existentes, ver detalles y metadata de cada modelo, historial de versiones.
- **Gestión de Datasets:** Subir nuevos datasets, ver datasets existentes y sus versiones, validar calidad de datos, asociar datasets a modelos.
- **Módulo de Entrenamiento:** Lanzar reentrenamientos de modelos, monitorear progreso en tiempo real, comparar métricas entre versiones, promover o hacer rollback de versiones.
- **Visor de Logs y Alertas:** Consultar logs centralizados de todos los servicios, filtrar por servicio, nivel de severidad o fecha, ver alertas activas y su historial.
- **Gestión de Usuarios:** Ver usuarios registrados, gestionar roles, ver actividad de usuarios, suspender o eliminar cuentas.
- **Historial de Predicciones:** Consultar todas las predicciones del sistema, filtrar por modelo, usuario, fecha o tipo, ver estadísticas y tendencias de uso.

---

### 6.2 Mobile App (Aplicación Móvil)

Es la **cara al usuario final** del sistema. Su diseño debe ser limpio, intuitivo y centrado en la experiencia de consumo de predicciones.

**Funcionalidades:**

- **Registro y Login:** Creación de cuenta, inicio de sesión seguro, recuperación de contraseña.
- **Catálogo de Predicciones:** Lista de todos los modelos de IA disponibles con nombre, descripción y tipo.
- **Solicitud de Predicciones en Tiempo Real:** El usuario selecciona un modelo, ingresa los datos requeridos y recibe la predicción al instante.
- **Consulta de Resultados Batch:** Visualización de predicciones generadas periódicamente por las IAs batch, actualizadas según la frecuencia configurada.
- **Historial Personal:** Registro de todas las predicciones que el usuario ha solicitado, con posibilidad de volver a consultarlas.
- **Notificaciones Push:** Alertas cuando hay nuevas predicciones batch disponibles o cuando se agregan nuevos modelos al sistema.
- **Perfil de Usuario:** Gestión de datos personales y preferencias.

---

## 7. Capa de Infraestructura Transversal

Son los **9 componentes** que sostienen todo el sistema por debajo. No son microservicios de negocio, pero sin ellos la plataforma no podría funcionar de forma profesional.

---

### 7.1 Message Broker (Cola de Mensajes)

Sistema de mensajería asíncrona que permite la comunicación desacoplada entre servicios.

**Uso en el sistema:**

- El Scheduler publica trabajos batch en la cola en vez de llamar directamente a las IAs.
- Cuando un entrenamiento finaliza, se publica un evento que el Notification Service recoge.
- Cuando una predicción batch se completa, se notifica al Prediction Storage Service.
- Permite que los servicios no dependan unos de otros directamente: si el Notification Service está caído, los mensajes esperan en la cola sin perder nada.

---

### 7.2 Service Discovery (Descubrimiento de Servicios)

Directorio dinámico donde cada microservicio se registra al levantarse.

**Funcionamiento:**

- Cada servicio al iniciar dice: "Yo soy el Auth Service y estoy en esta dirección".
- Cuando el Orquestador necesita llamar a una IA, le pregunta al Service Discovery dónde encontrarla.
- Si un servicio se mueve, escala o se reinicia en otra dirección, el discovery se actualiza automáticamente.
- Elimina la necesidad de tener direcciones hardcodeadas en el código.

---

### 7.3  Config Service (Servicio de Configuración Centralizada)

Almacén único de configuraciones para todos los microservicios.

**Ventajas:**

- Todas las configuraciones viven en un solo lugar en vez de estar repetidas en cada servicio.
- Cambiar una configuración (credenciales de base de datos, API keys, feature flags) se hace una sola vez.
- Los servicios consultan sus configuraciones al arrancar y pueden recibir actualizaciones en caliente.
- Facilita el manejo de diferentes ambientes (desarrollo, staging, producción).

---

### 7.4 Cache Service (Servicio de Caché)

Capa de caché compartida para mejorar el rendimiento del sistema.

**Uso en el sistema:**

- Cachea respuestas de predicciones batch frecuentemente consultadas para no golpear la base de datos en cada petición.
- Almacena datos del Model Registry que no cambian cada segundo (metadata de modelos).
- Cachea información de sesiones de usuario para validaciones rápidas.
- Si 100 usuarios piden la misma predicción batch, se sirve desde caché una sola vez en lugar de consultar el storage 100 veces.

---

### 7.5 Base de Datos Principal

Almacenamiento persistente de los datos del sistema.

**Consideraciones de diseño:**

- Cada microservicio idealmente tiene su propio esquema o base de datos para mantener la independencia (patrón Database per Service).
- Los datos de usuarios, predicciones, metadata de modelos, logs e historial se almacenan aquí.
- Se recomienda usar bases de datos relacionales para datos transaccionales (usuarios, predicciones) y bases NoSQL para logs y datos no estructurados.

---

### 7.6 Object Storage (Almacenamiento de Objetos)

Almacén de archivos pesados y binarios que no pertenecen a una base de datos relacional.

**Contenido almacenado:**

- Datasets subidos para entrenamiento (pueden ser archivos de cientos de MB o GB).
- Modelos entrenados (archivos binarios de los modelos serializados).
- Logs históricos archivados que ya no se consultan frecuentemente pero deben conservarse.
- Backups de datos.

---

### 7.7 Log Aggregator (Agregador de Logs)

Recolector centralizado de logs de todos los microservicios del sistema.

**Funcionalidades:**

- Cada microservicio envía sus logs a este componente central.
- Permite buscar, filtrar y analizar logs desde un solo punto (consumido por el panel web).
- Correlación de eventos entre servicios: rastrear una petición desde que entra por el Gateway hasta que la IA responde.
- Sin este componente, habría que entrar servicio por servicio para saber qué pasó ante un error.

---

### 7.8 Container Orchestrator (Orquestador de Contenedores)

Gestiona todos los contenedores donde corren los microservicios.

**Responsabilidades:**

- Levantar automáticamente servicios que se caen (self-healing).
- Escalar horizontalmente un servicio si tiene mucha carga (más instancias).
- Reducir instancias cuando la carga baja para optimizar recursos.
- Gestionar despliegues sin downtime (rolling updates / blue-green deployment).
- Administrar la red interna entre servicios.
- Gestionar secrets y configuraciones sensibles.

---

### 7.9 CI/CD Pipeline (Integración y Despliegue Continuo)

Sistema automatizado que gestiona el ciclo de vida del código desde el commit hasta producción.

**Flujo:**

1. El desarrollador sube un cambio al repositorio de código.
2. Automáticamente se ejecutan las pruebas (unitarias, integración).
3. Si las pruebas pasan, se construye la imagen del contenedor.
4. Se despliega en el ambiente de staging para validación.
5. Tras aprobación, se despliega en producción.

---

## 8. Resumen de Componentes

### Conteo Total del Sistema

| Capa | Componentes | Cantidad |
|------|-------------|----------|
| Capa de Entrada | API Gateway | 1 |
| Servicios Core | Auth, Model Registry, Orchestrator, Scheduler, Prediction Storage, Dataset Management, Training, Logging & Monitoring, Notification | 9 |
| Capa de IAs | Servicios de IA independientes | 5 (escalable) |
| Clientes | Admin Web App, Mobile App | 2 |
| Infraestructura Transversal | Message Broker, Service Discovery, Config Service, Cache, DB Principal, Object Storage, Log Aggregator, Container Orchestrator, CI/CD Pipeline | 9 |
| **Total** | | **26 componentes** |

---

## 9. Flujos Principales del Sistema

### 9.1 Predicción en Tiempo Real

```
Usuario (App Móvil)
    → API Gateway (autenticación + routing)
        → Prediction Orchestrator
            → Consulta Model Registry (¿dónde está la IA?)
            → Llama al Servicio de IA correspondiente
            ← Recibe predicción
            → Guarda en Prediction Storage
        ← Devuelve predicción al usuario
```

### 9.2 Predicción Batch

```
Scheduler (según frecuencia configurada)
    → Publica trabajo en Message Broker
        → Prediction Orchestrator recoge el trabajo
            → Llama al Servicio de IA correspondiente
            ← Recibe predicción
            → Guarda en Prediction Storage
            → Publica evento "predicción lista" en Message Broker
                → Notification Service recoge el evento
                    → Envía push notification a usuarios
```

### 9.3 Consulta de Predicción Batch (Usuario)

```
Usuario (App Móvil)
    → API Gateway
        → Prediction Storage Service
            → Consulta Cache (¿está cacheado?)
                → Sí: devuelve desde caché
                → No: consulta DB, cachea resultado, devuelve
        ← Muestra resultados al usuario
```

### 9.4 Reentrenamiento de Modelo

```
Administrador (Web App)
    → API Gateway
        → Training Service
            → Obtiene dataset del Dataset Management Service
            → Inicia entrenamiento
            → Publica progreso periódicamente
            → Al finalizar: guarda métricas
            → Publica evento en Message Broker
                → Notification Service notifica al admin
                → Admin compara métricas y decide promover o no
```

---
