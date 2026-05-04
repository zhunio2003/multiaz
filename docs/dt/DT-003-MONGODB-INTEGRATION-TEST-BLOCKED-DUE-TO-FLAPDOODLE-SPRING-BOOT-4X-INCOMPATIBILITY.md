# DT-003 — MongoDB integration test blocked due to Flapdoodle/Spring Boot 4.x incompatibility

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Sprint detectado:** Sprint 4  
**Historia afectada:** TS-08.1 — Model Registry Service  
**Prioridad:** Baja  
**Sprint destino:** Por definir  
**Autor:** Miguel Angel Zhunio Remache  
**Fecha:** 4 de mayo de 2026

---

## Descripción

`de.flapdoodle.embed.mongo.spring3x:4.18.0` no es compatible con Spring Boot 4.x. La librería referencia `org.springframework.boot.autoconfigure.mongo.MongoProperties`, clase eliminada en Spring Boot 4.x. El contexto de Spring falla al arrancar durante los tests.

---

## Evidencia Observada

```
Caused by: java.lang.ClassNotFoundException:
org.springframework.boot.autoconfigure.mongo.MongoProperties
at de.flapdoodle.embed.mongo.spring.autoconfigure
.EmbeddedMongoAutoConfiguration$SyncClientServerWrapperConfig
```

---

## Configuración Actual

```xml
<dependency>
    <groupId>de.flapdoodle.embed</groupId>
    <artifactId>de.flapdoodle.embed.mongo.spring3x</artifactId>
    <version>4.18.0</version>
    <scope>test</scope>
</dependency>
```

---

## Hipótesis de Causa Raíz

Flapdoodle `spring3x` fue construido para Spring Boot 3.x. En Spring Boot 4.x el paquete `org.springframework.boot.autoconfigure.mongo` fue reorganizado y `MongoProperties` eliminada. No existe aún una variante `spring4x` de Flapdoodle.

---

## Estado Actual

`ModelControllerTest` marcado con `@Disabled` para no bloquear el pipeline CI/CD. El test existe y está correctamente implementado — solo deshabilitado por incompatibilidad de dependencia.

---

## Plan de Resolución

Investigar en el siguiente orden — detener al encontrar la solución que funcione:

**Opción 1 —** Esperar release de Flapdoodle compatible con Spring Boot 4.x y actualizar la versión.

**Opción 2 —** Reemplazar Flapdoodle por Testcontainers con imagen real de MongoDB, eliminando la dependencia del MongoDB embebido.

---

## Impacto

TS-08.1 completada funcionalmente. El test de integración existe pero está deshabilitado — cobertura de MongoDB pendiente hasta resolución de esta deuda.

---

*MultIAZ — Sprint 4 | DT-003 | Mayo 2026*