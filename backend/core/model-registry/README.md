# MODEL REGISTRY

Descripción breve de qué hace este servicio y su responsabilidad dentro del sistema (1-2 líneas).

## Stack

- Java 21
- Spring Boot 3.x
- Maven
- Base de datos: PostgreSQL
- Mensajería: Kafka / RabbitMQ (si aplica)

## Requisitos

- JDK 21
- Maven 3.9+
- Docker (para la base de datos y dependencias locales)

## Configuración

Variables de entorno principales:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `SERVER_PORT` | Puerto del servicio | `8081` |
| `DB_URL` | URL de la base de datos | `jdbc:postgresql://localhost:5432/mi_db` |
| `DB_USER` | Usuario de la BD | `postgres` |
| `DB_PASSWORD` | Contraseña de la BD | `secret` |

## Ejecutar en local

```bash
# Levantar dependencias (BD, broker, etc.)
docker compose up -d

# Correr el servicio
./mvnw spring-boot:run
```

## Tests

```bash
./mvnw test
```

## Endpoints principales

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/v1/recurso` | Lista recursos |
| POST | `/api/v1/recurso` | Crea un recurso |
| GET | `/api/v1/recurso/{id}` | Obtiene un recurso |

Documentación completa: `http://localhost:8081/swagger-ui.html`

## Dependencias con otros servicios

- **servicio-a**: para qué se usa (REST / evento)
- **servicio-b**: para qué se usa

## Docker

```bash
docker build -t model-registry .
docker run -p 8081:8081 model-registry
```

## Health check

`GET /actuator/health`
