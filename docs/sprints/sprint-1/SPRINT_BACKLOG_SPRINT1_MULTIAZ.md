# SPRINT BACKLOG — Sprint 1

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum | Sprints de 1 semana  
**Sprint:** Sprint 1  
**Fase:** Fase 1 — Fundación (Infraestructura)  
**Fecha inicio:** 21/03/2026  
**Fecha fin:** 28/03/2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Sprint Goal

Establecer la infraestructura base completa del sistema MultIAZ: comunicación, configuración, almacenamiento y operaciones.

---

## 2. Resumen del Sprint

| Concepto | Valor |
|----------|-------|
| Technical Stories | 8 |
| Tareas totales | 29 |
| Story Points comprometidos | 27 |
| Horas estimadas totales | 31.5 h |
| Duración del sprint | 1 semana (7 días) |
| Horas promedio diarias | ~4.5 h/día |

---

## 3. Sprint Backlog Detallado

---

### EP-14 — Comunicación y Configuración

---

#### TS-14.1 — Configuración del Message Broker (RabbitMQ)

**Story Points:** 5  
**Horas estimadas:** 4.5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-14.1.1 | Crear el servicio de RabbitMQ en docker-compose.yml con la imagen oficial, los puertos 5672 y 15672, el volumen vol-rabbitmq y la red net-message. | 2 h | Done |
| T-14.1.2 | Verificar que RabbitMQ está operativo accediendo al panel de administración web en el puerto 15672. | 0.5 h | Done |
| T-14.1.3 | Realizar una prueba de publicación y consumo de mensajes para verificar que la comunicación funciona correctamente. | 1 h | Done |
| T-14.1.4 | Crear las 4 colas definidas en la arquitectura: trabajos batch, predicción batch completada, entrenamiento completado y alertas de monitoreo. | 1 h | Done |

---

#### TS-14.2 — Configuración del Service Discovery (Eureka)

**Story Points:** 5  
**Horas estimadas:** 4 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-14.2.1 | Crear el servicio de Eureka Server en docker-compose.yml con la imagen oficial, puerto 8761 y las redes net-gateway y net-prediction. | 1 h | Done |
| T-14.2.2 | Verificar que Eureka Server está operativo accediendo al dashboard web en el puerto 8761. | 0.5 h | Done |
| T-14.2.3 | Crear un microservicio temporal de prueba (Spring Boot) que se registre automáticamente en Eureka al iniciar. | 2 h | Done |
| T-14.2.4 | Verificar el registro y descubrimiento de servicios: confirmar que el microservicio de prueba aparece en el dashboard, que se puede consultar su ubicación por nombre y que al reiniciarlo el registro se actualiza automáticamente. | 0.5 h | Done |

---

#### TS-14.3 — Configuración del Servicio de Configuración Centralizada (Spring Cloud Config)

**Story Points:** 3  
**Horas estimadas:** 4.5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-14.3.1 | Crear el servicio de Spring Cloud Config en docker-compose.yml con la imagen oficial, puerto 8888 y la red net-gateway. | 2 h | Done |
| T-14.3.2 | Verificar que el Config Service está operativo accediendo al endpoint de health check en el puerto 8888. | 0.5 h | Done |
| T-14.3.3 | Crear el repositorio de configuraciones con la estructura de archivos por servicio y por ambiente (dev, staging, prod) con configuraciones básicas de ejemplo. | 1 h | Done |
| T-14.3.4 | Verificar que el microservicio temporal de prueba consulta y obtiene sus configuraciones del Config Service al arrancar, y que un cambio de configuración se recibe sin redespliegue. | 1 h | Done |

---

### EP-15 — Almacenamiento

---

#### TS-15.1 — Configuración del Cache Service (Redis)

**Story Points:** 1  
**Horas estimadas:** 2.5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-15.1.1 | Crear el servicio de Redis en docker-compose.yml con la imagen oficial, puerto 6379, volumen vol-redis y la red net-database. | 1 h | Done |
| T-15.1.2 | Verificar que Redis está operativo ejecutando un comando de health check (ping) desde la terminal. | 0.5 h | Done |
| T-15.1.3 | Realizar pruebas de almacenamiento y recuperación de datos en Redis, incluyendo la configuración de TTL y verificando que los datos expiran correctamente. | 1 h | Done |

---

#### TS-15.2 — Configuración de la Base de Datos Principal (PostgreSQL + MongoDB)

**Story Points:** 5  
**Horas estimadas:** 8 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-15.2.1 | Crear los servicios de PostgreSQL y MongoDB en docker-compose.yml con las imágenes oficiales, puertos (5432 y 27017), volúmenes (vol-postgresql y vol-mongodb) y la red net-database. | 3 h | Done |
| T-15.2.2 | Verificar que ambos servidores están operativos ejecutando comandos de conexión (psql para PostgreSQL y mongosh para MongoDB). | 1 h | Done |
| T-15.2.3 | Crear las 6 bases de datos lógicas vacías en PostgreSQL: auth, model-registry, scheduler, prediction-storage, dataset-management y notification. | 2 h | Done |
| T-15.2.4 | Crear las 3 bases de datos lógicas vacías en MongoDB: prediction-storage-details, training y logging-monitoring. | 1 h | Done |
| T-15.2.5 | Configurar la estrategia de backups automáticos para PostgreSQL y MongoDB con almacenamiento en MinIO. | 1 h | Blocked |

---

#### TS-15.3 — Configuración del Object Storage (MinIO)

**Story Points:** 3  
**Horas estimadas:** 3.5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-15.3.1 | Crear el servicio de MinIO en docker-compose.yml con la imagen oficial, puertos 9000 y 9001, volumen vol-minio y la red net-database. | 1 h | Done |
| T-15.3.2 | Verificar que MinIO está operativo accediendo a la consola web de administración en el puerto 9001. | 0.5 h | Done |
| T-15.3.3 | Crear la estructura lógica de buckets en MinIO: datasets, trained-models, backups y historical-logs. | 1 h | Done |
| T-15.3.4 | Verificar la subida y descarga de archivos de prueba, incluyendo un archivo de gran tamaño, desde la consola web. | 1 h | Done |

---

### EP-16 — Operaciones

---

#### TS-16.1 — Configuración del Container Orchestrator (Docker Compose)

**Story Points:** 2  
**Horas estimadas:** 1.5 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-16.1.1 | Crear el archivo .env con las credenciales y configuraciones sensibles de todos los servicios (contraseñas de PostgreSQL, MongoDB, RabbitMQ, MinIO, Redis) y verificar que está incluido en .gitignore. | 1 h | Done |
| T-16.1.2 | Verificar que todos los contenedores del sistema se levantan correctamente con un solo comando (docker-compose up) y que las redes permiten la comunicación entre los servicios correspondientes. | 0.5 h | Done |

---

#### TS-16.2 — Configuración del CI/CD Pipeline (GitHub Actions)

**Story Points:** 3  
**Horas estimadas:** 3 h

| ID Tarea | Descripción de la Tarea | Horas Est. | Estado |
|----------|-------------------------|------------|--------|
| T-16.2.1 | Crear el archivo de workflow de GitHub Actions (.github/workflows/) que se active automáticamente al subir cambios al repositorio. | 1 h | Done |
| T-16.2.2 | Configurar el pipeline para que ejecute las pruebas automatizadas y se detenga si alguna falla. | 1 h | Blocked |
| T-16.2.3 | Configurar el pipeline para que construya la imagen Docker del servicio modificado tras pasar las pruebas exitosamente. | 1 h | Done |

---

## 4. Resumen por Technical Story

| ID | Nombre | Épica | SP | Horas Est. | Tareas |
|----|--------|-------|----|------------|--------|
| TS-14.1 | Configuración del Message Broker | EP-14 | 5 | 4.5 h | 4 |
| TS-14.2 | Configuración del Service Discovery | EP-14 | 5 | 4 h | 4 |
| TS-14.3 | Configuración del Servicio de Configuración Centralizada | EP-14 | 3 | 4.5 h | 4 |
| TS-15.1 | Configuración del Cache Service | EP-15 | 1 | 2.5 h | 3 |
| TS-15.2 | Configuración de la Base de Datos Principal | EP-15 | 5 | 8 h | 5 |
| TS-15.3 | Configuración del Object Storage | EP-15 | 3 | 3.5 h | 4 |
| TS-16.1 | Configuración del Container Orchestrator | EP-16 | 2 | 1.5 h | 2 |
| TS-16.2 | Configuración del CI/CD Pipeline | EP-16 | 3 | 3 h | 3 |
| **Total** | | | **27** | **31.5 h** | **29** |

---

## 5. ADRs Asociados a este Sprint

| ADR | Título | Estado |
|-----|--------|--------|
| ADR-001 | Aplicar refinamiento progresivo en las historias TS-15.1 y TS-15.2 | Aceptado |
| ADR-002 | Diferir la infraestructura de producción: usar Docker Compose como orquestador y limitar el CI/CD al ambiente de desarrollo | Aceptado |

---

## 6. Notas

- Este es el primer sprint del proyecto. No existe historial de velocidad previo. Los 27 Story Points comprometidos servirán como línea base para estimar la velocidad del equipo en sprints futuros.
- Los criterios de aceptación de las historias TS-15.1 (criterios 4 y 5) y TS-15.2 (criterio 5) fueron refinados aplicando el principio YAGNI, documentado en el ADR-001.
- Los criterios de la TS-16.1 (criterios 3, 4 y 5) y TS-16.2 (criterios 4 y 5) fueron diferidos por la decisión de usar Docker Compose como orquestador inicial, documentado en el ADR-002.
