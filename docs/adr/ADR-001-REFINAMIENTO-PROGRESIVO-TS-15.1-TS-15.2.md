# ADR-001 — APLICAR REFINAMIENTO PROGRESIVO EN LAS TS-15.1 y TS-15.2

**Fecha:** 19 de Marzo del 2026
**Estado:** Aceptado

---

## Contexto  

Las Technical Stories TS-15.1 (Cache Service) y TS-15.2 (Base de Datos Principal) pertenecen a la Fase 1 (Fundación). Sus criterios de aceptación actuales incluyen la definición de tipos de datos cacheables (TS-15.1, criterio 5) y la creación de esquemas iniciales con tablas y colecciones para los servicios core (TS-15.2, criterio 5). Sin embargo, los microservicios que consumirían esas estructuras (Auth Service, Model Registry, Prediction Storage, etc.) no se desarrollarán hasta la Fase 2. En la Fase 1 no existe ningún servicio que requiera tablas, colecciones ni datos cacheados.

---

## Decisión

Se modificaron los criterios de aceptación de las historias TS-15.1 y TS-15.2 aplicando el principio YAGNI (You Aren't Gonna Need It). En la Fase 1, las bases de datos se desplegarán con sus bases de datos lógicas creadas pero vacías, sin tablas ni colecciones. Los tipos de datos cacheables en Redis tampoco se definirán en esta fase. Las estructuras de tablas, colecciones y definiciones de caché se crearán cuando se desarrolle cada servicio en su fase correspondiente.

---

## Consecuencias

### Positivas:

- Se evita retrabajo en la definición de esquemas de tablas y colecciones que podrían cambiar durante el desarrollo de cada servicio.
- Los criterios de aceptación de las historias TS-15.1 y TS-15.2 son alcanzables dentro de la Fase 1, permitiendo cumplir el Definition of Done.

### Negativas:

- En cada sprint de la Fase 2, antes de desarrollar un servicio, se deberá crear su esquema de base de datos como paso previo, lo que añade tiempo adicional al desarrollo de cada servicio.