# PRODUCT BACKLOG — ÉPICAS Y FASES

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.0  
**Fecha:** 17 de Marzo del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento define las **épicas** del Product Backlog del sistema MultIAZ, organizadas en fases de desarrollo priorizadas. Las épicas fueron derivadas a partir del análisis de los tres tipos de usuario definidos en el Product Vision Board y de los componentes establecidos en la arquitectura del sistema.

**Documentos de referencia:**

- `PRODUCT_VISION_BOARD_MULTIAZ.md` — Visión, usuarios, necesidades y objetivos de negocio.
- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).
- `ARQUITECTURA_INICIAL_MULTIAZ.md` — Diagrama de arquitectura de microservicios.

---

## 2. Criterios de Priorización

Las épicas se organizaron en 4 fases siguiendo esta lógica:

| Fase | Pregunta clave | Enfoque |
|------|----------------|---------|
| Fase 1 | ¿Qué necesito para que el sistema exista? | Infraestructura técnica base |
| Fase 2 | ¿Qué necesito para que el usuario pueda hacer lo básico? | Experiencia del usuario final |
| Fase 3 | ¿Qué necesito para que el administrador gestione la plataforma? | Administración y operación |
| Fase 4 | ¿Qué son mejoras y funcionalidades avanzadas? | Funcionalidades de valor agregado |

---

## 3. Épicas del Sistema

Se identificaron **16 épicas** clasificadas en tres categorías según su origen:

### 3.1 Épicas de Usuario (Usuario Persona + Usuario Empresa)

Derivadas de las necesidades del Usuario Persona (uso esporádico, predicciones puntuales) y del Usuario Empresa (uso continuo, monitoreo automatizado) definidos en el Product Vision Board.

| ID | Épica | Descripción | Usuario principal |
|----|-------|-------------|-------------------|
| EP-01 | Autenticación de Usuarios | Registro, inicio de sesión, recuperación de contraseña, gestión de tokens y seguridad de acceso | Persona / Empresa |
| EP-02 | Realización de Predicciones | Flujo completo de solicitud de predicción en tiempo real: selección de modelo, ingreso de datos y recepción de resultado | Persona / Empresa |
| EP-03 | Historial de Predicciones | Consulta de predicciones realizadas previamente por el usuario, con búsqueda y filtros | Persona / Empresa |
| EP-04 | Gestión de Perfil de Usuario | Consulta y edición de datos personales, preferencias y visualización del plan actual | Persona / Empresa |
| EP-05 | Predicciones Automáticas | Ejecución programada de predicciones en modo batch, monitoreo continuo y consulta de resultados generados automáticamente | Empresa |
| EP-06 | Notificaciones | Notificaciones push, email e in-app sobre nuevas predicciones batch disponibles, nuevos modelos y alertas relevantes | Persona / Empresa |
| EP-07 | Recomendaciones Automatizadas | Sistema proactivo que genera recomendaciones basadas en tendencias detectadas sin que el usuario las solicite | Empresa |

### 3.2 Épicas del Administrador

Derivadas de las responsabilidades del Administrador del Sistema y de los módulos del Admin Web App definidos en la arquitectura.

| ID | Épica | Descripción |
|----|-------|-------------|
| EP-08 | Gestión de Modelos de IA | Registro de nuevos modelos, activación/desactivación, consulta de metadata y gestión del historial de versiones |
| EP-09 | Gestión de Datasets | Carga de datasets, versionado, validación de calidad, asociación con modelos y gestión de metadata |
| EP-10 | Entrenamiento de Modelos de IA | Lanzamiento de reentrenamientos, monitoreo de progreso, comparación de métricas entre versiones, promoción y rollback |
| EP-11 | Logs y Monitoreo | Consulta centralizada de logs, monitoreo de salud del sistema, alertas automáticas y dashboard de rendimiento |
| EP-12 | Gestión de Usuarios | Visualización de usuarios registrados, gestión de roles, consulta de actividad y suspensión/eliminación de cuentas |
| EP-13 | Análisis de Predicciones Globales | Consulta de todas las predicciones del sistema, estadísticas de uso por modelo/usuario/período y tendencias globales |

### 3.3 Épicas Técnicas (Infraestructura Transversal)

Derivadas de los 9 componentes de la Capa de Infraestructura Transversal de la arquitectura. Son **Technical Stories / Enabler Stories** que no aportan valor directo al usuario pero son imprescindibles para que la plataforma funcione.

| ID | Épica | Componentes involucrados |
|----|-------|--------------------------|
| EP-14 | Comunicación y Configuración | Message Broker, Service Discovery, Config Service |
| EP-15 | Almacenamiento | Cache Service, Base de Datos Principal, Object Storage |
| EP-16 | Operaciones | Container Orchestrator, CI/CD Pipeline |
| EP-17 | Fundación Frontend | Admin Web App (React), Mobile App (Flutter) |


**Nota sobre EP-16:** El Log Aggregator, aunque está en el grupo de Operaciones de la arquitectura, se relaciona directamente con la épica EP-11 (Logs y Monitoreo) desde el punto de vista funcional.

---

## 4. Fases de Desarrollo

### Fase 1 — Fundación (Infraestructura)

**Objetivo:** Establecer la base técnica sin la cual ningún servicio puede existir.

| Prioridad | ID | Épica |
|-----------|----|-------|
| 1 | EP-14 | Comunicación y Configuración |
| 2 | EP-15 | Almacenamiento |
| 3 | EP-16 | Operaciones |
| 4 | EP-17 | Fundación Frontend |


**Justificación:** Sin base de datos, sin API Gateway, sin orquestador de contenedores ni pipeline de despliegue, no hay donde ejecutar ni desplegar los microservicios. Los modelos de IA pueden estar pre-entrenados y registrados manualmente en esta fase.

> Nota (EP-17): Las historias de Mobile App (TS-17.1, TS-17.2, TS-17.3) se ejecutan antes de Fase 2 (Experiencia del Usuario). Las historias de Admin Web App (TS-17.4, TS-17.5) se ejecutan antes de Fase 3 (Administración de la Plataforma). La TS-17.2 (Design System) define las decisiones de diseño para ambos clientes, pero la implementación en React se completa junto con TS-17.4.

---

### Fase 2 — Experiencia del Usuario

**Objetivo:** Permitir que el usuario final pueda usar la plataforma en sus funcionalidades esenciales.

| Prioridad | ID | Épica |
|-----------|----|-------|
| 4 | EP-01 | Autenticación de Usuarios |
| 5 | EP-02 | Realización de Predicciones |
| 6 | EP-03 | Historial de Predicciones |
| 7 | EP-04 | Gestión de Perfil de Usuario |
| 8 | EP-05 | Predicciones Automáticas |

**Justificación:** Autenticación es el prerequisito para todo. Después, el flujo básico de predicción es el core del sistema. El historial y perfil complementan la experiencia básica. Las predicciones automáticas habilitan el caso de uso empresarial.

---

### Fase 3 — Administración de la Plataforma

**Objetivo:** Dotar al administrador de las herramientas para gestionar y operar la plataforma de forma autónoma.

| Prioridad | ID | Épica |
|-----------|----|-------|
| 9 | EP-08 | Gestión de Modelos de IA |
| 10 | EP-09 | Gestión de Datasets |
| 11 | EP-10 | Entrenamiento de Modelos de IA |
| 12 | EP-11 | Logs y Monitoreo |
| 13 | EP-12 | Gestión de Usuarios |
| 14 | EP-13 | Análisis de Predicciones Globales |

**Justificación:** Para la operación continua de la plataforma, el administrador necesita gestionar modelos, actualizar datos de entrenamiento, monitorear la salud del sistema y administrar usuarios. Estas funcionalidades son operativas y necesarias antes de agregar mejoras avanEmpecemos por entender la estructura general de un DoD profesional para microservicios. Un DoD típicamente tiene dos niveles:zadas.

---

### Fase 4 — Mejoras Avanzadas

**Objetivo:** Funcionalidades de valor agregado que mejoran la experiencia pero no son esenciales para la operación básica.

| Prioridad | ID | Épica |
|-----------|----|-------|
| 15 | EP-06 | Notificaciones |
| 16 | EP-07 | Recomendaciones Automatizadas |

**Justificación:** Las notificaciones mejoran la experiencia pero el sistema funciona sin ellas. Las recomendaciones automatizadas son la funcionalidad más avanzada y con mayor complejidad técnica, pertenecen al plan de pago empresarial.

---

## 5. Resumen

| Concepto | Valor |
|----------|-------|
| Total de épicas | 17 |
| Épicas de usuario | 7 |
| Épicas de administrador | 6 |
| Épicas técnicas | 4 |
| Fases de desarrollo | 4 |
| Usuarios cubiertos | Usuario Persona, Usuario Empresa, Administrador del Sistema |
