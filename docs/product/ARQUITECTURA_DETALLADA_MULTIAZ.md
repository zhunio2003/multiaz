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
