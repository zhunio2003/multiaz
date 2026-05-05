# ADR-005 — Flyway como Estándar de Migraciones de Base de Datos

**Fecha:** 2026-05-05  
**Estado:** Aceptado  
**Contexto:** T-02.1.2 — Esquema PostgreSQL del Prediction Orchestrator Service  
**Autor:** Miguel Zhunio

---

## Contexto

Durante la implementación de T-02.1.2 (Sprint 5), se identificó una inconsistencia arquitectónica en el proyecto: los servicios PostgreSQL no tienen un mecanismo unificado para gestionar el esquema de base de datos.

El estado actual del proyecto al momento de esta decisión:

- **auth-service** — usa `init.sql` montado como volumen en `docker-entrypoint-initdb.d/` del contenedor PostgreSQL
- **model-registry** — usa MongoDB, no aplica
- **prediction-orchestrator** — servicio nuevo, sin mecanismo definido aún

Esta inconsistencia genera tres problemas concretos:

1. **No escalable** — cada servicio nuevo podría adoptar un mecanismo diferente (`init.sql`, `ddl-auto: update`, scripts manuales), aumentando la carga cognitiva del equipo
2. **Sin historial de cambios** — ni `init.sql` ni `ddl-auto: update` llevan registro de qué cambios se aplicaron, cuándo y en qué orden
3. **Riesgo en producción** — `ddl-auto: update` permite que Hibernate tome decisiones autónomas sobre el esquema en producción, lo que puede resultar en pérdida de datos o cambios no auditables

La necesidad de definir un estándar único surgió al agregar el segundo servicio PostgreSQL al proyecto.

---

## Decisión

Adoptar **Flyway** como el estándar de migraciones de base de datos para todos los servicios PostgreSQL del proyecto MultIAZ.

### Configuración estándar adoptada

**Dependencia en `pom.xml`:**
```xml
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
</dependency>
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-database-postgresql</artifactId>
</dependency>
```

**Configuración en `application.yml` o archivo de config del servicio:**
```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
  flyway:
    enabled: true
    locations: classpath:db/migration
```

**Ubicación de scripts — dentro de cada microservicio:**
```
backend/core/<service-name>/
  src/main/resources/
    db/
      migration/
        V1__create_<tabla>_table.sql
        V2__add_index_<campo>.sql
```

**Convención de naming de scripts:**
```
V{número}__{descripción_en_snake_case}.sql
```
Ejemplos:
- `V1__create_predictions_table.sql`
- `V2__add_index_user_id.sql`
- `V3__add_completed_at_column.sql`

> **Regla:** Una vez que un script Vn es ejecutado en cualquier entorno, **nunca se modifica**. Los cambios posteriores van en un nuevo script con el siguiente número de versión.

---

## Alternativas Consideradas

### Alternativa A — `init.sql` por servicio (patrón actual de auth-service)

Cada servicio tiene un archivo `init.sql` montado como volumen en `docker-entrypoint-initdb.d/` del contenedor PostgreSQL.

**Pros:**
- Simple de entender
- Control total del SQL ejecutado
- Ya implementado en auth-service

**Contras:**
- Solo se ejecuta cuando el contenedor PostgreSQL se inicializa por primera vez — si la base de datos ya existe, el script no se re-ejecuta
- No hay historial de cambios — no se puede saber qué versión del esquema está en producción
- No es reproducible en entornos existentes sin destruir el volumen
- No escala: agregar una columna nueva requiere destruir y recrear el contenedor, perdiendo datos
- Cada servicio requiere un volumen montado adicional en `docker-compose.yml` — acoplamiento entre el contenedor de BD y el servicio

### Alternativa B — `ddl-auto: update` (Hibernate automático)

Hibernate compara las entidades Java con el esquema actual y aplica los cambios necesarios automáticamente al iniciar el servicio.

**Pros:**
- Cero configuración adicional
- Las tablas se crean automáticamente al levantar el servicio

**Contras:**
- **Inaceptable en producción** — Hibernate puede tomar decisiones destructivas (eliminar columnas, modificar tipos) sin intervención humana
- Sin historial de cambios — no hay registro de qué se modificó ni cuándo
- No reproducible — el esquema final depende del orden en que se levantaron los servicios
- No es auditadle en code reviews — los cambios de esquema no aparecen como archivos en el repositorio
- Considerado una mala práctica grave en la industria para cualquier entorno que no sea un prototipo desechable

### Alternativa C — Flyway ✅ (decisión tomada)

Herramienta de migración de base de datos versionada. Los scripts SQL se numeran, se versionan en Git junto al código del servicio, y Flyway lleva un registro en `flyway_schema_history` de qué scripts ya se ejecutaron.

**Pros:**
- Historial completo y auditable de cambios de esquema en Git
- Reproducible en cualquier entorno — misma secuencia de scripts, mismo esquema
- Seguro en producción — Hibernate con `ddl-auto: validate` solo verifica, nunca modifica
- Los scripts viajan con el microservicio — Database per Service completo
- Estándar de la industria para aplicaciones Spring Boot en producción
- Compatible con CI/CD — las migraciones se aplican automáticamente al desplegar

**Contras:**
- Requiere disciplina: un script ejecutado nunca se modifica
- auth-service requiere migración desde `init.sql` — deuda técnica documentada

---

## Consecuencias

### Positivas

- El proyecto tiene un único mecanismo de gestión de esquemas para todos los servicios PostgreSQL — sin ambigüedad para futuros colaboradores
- Cada cambio de esquema es un archivo SQL versionado en Git — auditable en code reviews como cualquier otro cambio de código
- `ddl-auto: validate` garantiza que el esquema en base de datos siempre coincide exactamente con las entidades Java — si no coincide, el servicio falla al iniciar con un error descriptivo en lugar de comportarse de forma inesperada
- Las migraciones son parte del microservicio — al desplegar un servicio nuevo, su esquema se aplica automáticamente sin pasos manuales

### Negativas

- **auth-service** tiene deuda técnica: debe migrar de `init.sql` a Flyway en un sprint posterior. Hasta entonces, la inconsistencia persiste en ese servicio
- Los scripts de migración son inmutables una vez ejecutados — errores en un script requieren un nuevo script correctivo, no editar el original

### Mitigación de deuda técnica — auth-service

La migración de auth-service a Flyway se documenta como ítem de deuda técnica (DT-004) para ser planificada en un sprint posterior. No bloquea ningún item comprometido en Sprint 5.

---

## Servicios Afectados

| Servicio | Base de datos | Acción |
|---|---|---|
| prediction-orchestrator | PostgreSQL | ✅ Implementa Flyway desde el inicio (Sprint 5) |
| auth-service | PostgreSQL | ⏳ Migrar de `init.sql` a Flyway — DT-004 (sprint posterior) |
| model-registry | MongoDB | No aplica — Flyway es exclusivo para bases de datos relacionales |
| api-gateway | Sin base de datos | No aplica |
| service-discovery | Sin base de datos | No aplica |

---

## Referencias

- [Flyway Documentation — Get Started with Spring Boot](https://documentation.red-gate.com/flyway/quickstart-how-flyway-works/quickstart-spring-boot)
- [Spring Boot Reference — Flyway Database Migrations](https://docs.spring.io/spring-boot/reference/data/sql.html#data.sql.flyway)
- [Flyway Naming Conventions](https://documentation.red-gate.com/flyway/flyway-cli-and-api/concepts/migrations#Migrations-NamingConventions)
- [Why ddl-auto update is dangerous in production — Vlad Mihalcea](https://vladmihalcea.com/hibernate-hbm2ddl-auto-schema/)

---

*MultIAZ — ADR-005 | Mayo 2026*
