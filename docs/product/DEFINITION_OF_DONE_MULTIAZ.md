# DEFINITION OF DONE (DoD)

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.0  
**Fecha:** 18 de Marzo del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento define el **Definition of Done (DoD)** del proyecto MultIAZ: el acuerdo formal que establece cuándo un incremento de trabajo se considera terminado. El DoD es transversal a todo el proyecto y se aplica de forma consistente en cada nivel de entrega.

El DoD se estructura en **3 niveles**, cada uno construido sobre el anterior:

| Nivel | Alcance | Pregunta que responde |
|-------|---------|----------------------|
| Nivel 1 | Historia de Usuario / Technical Story | ¿Esta historia está terminada? |
| Nivel 2 | Sprint (Incremento) | ¿Este sprint entregó un incremento funcional? |
| Nivel 3 | Release (Lanzamiento a Producción) | ¿Esto está listo para usuarios reales? |

**Documentos de referencia:**

- `PRODUCT_BACKLOG_HISTORIAS_MULTIAZ.md` — Historias de Usuario y Technical Stories con criterios de aceptación.
- `PRODUCT_BACKLOG_EPICAS_MULTIAZ.md` — Épicas y fases de desarrollo.
- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).
- `TECHNOLOGY_STACK_MULTIAZ.md` — Decisiones tecnológicas del proyecto.

---

## 2. Nivel 1 — DoD por Historia de Usuario / Technical Story

Cada Historia de Usuario o Technical Story debe cumplir **todos** los puntos siguientes para considerarse terminada. No se acepta una historia como completada si algún punto queda pendiente.

---

### 2.1 Código

1. El código está subido al repositorio (GitHub) en la rama correspondiente.
2. El código cumple los estándares de codificación verificados por el linter del lenguaje correspondiente:
   - Java: Checkstyle (microservicios core — Spring Boot).
   - Python: Flake8 (Training Service y servicios de IA — FastAPI).
   - TypeScript: ESLint (Admin Web App — React).
   - Dart: dart analyze (Mobile App — Flutter).
3. No contiene credenciales, URLs ni configuraciones hardcodeadas en el código fuente. Las configuraciones se obtienen del Config Service (Spring Cloud Config).
4. Se realizó auto-revisión estructurada del código antes de marcar la historia como terminada.

---

### 2.2 Testing

5. La historia tiene pruebas unitarias que cubren la lógica de negocio implementada.
6. La historia tiene pruebas de integración cuando el servicio interactúa con otros componentes (base de datos, Message Broker, otros microservicios).
7. Todas las pruebas pasan exitosamente antes de considerar la historia como terminada.

**Frameworks de testing por lenguaje:**

| Lenguaje | Framework de pruebas | Componentes |
|----------|---------------------|-------------|
| Java | JUnit + Mockito | Microservicios core (Spring Boot) |
| Python | Pytest | Training Service + Servicios de IA (FastAPI) |
| TypeScript | Jest + React Testing Library | Admin Web App (React) |
| Dart | Flutter Test | Mobile App (Flutter) |

---

### 2.3 Despliegue

8. El servicio modificado se construye exitosamente como imagen Docker.
9. El pipeline de CI/CD (GitHub Actions) ejecuta las pruebas automáticamente y todas pasan.
10. El servicio está desplegado y funcionando en el ambiente de staging.

---

### 2.4 Documentación

11. Los endpoints del servicio están documentados y accesibles a través de Swagger/OpenAPI (generados automáticamente por Spring Boot y FastAPI).
12. Si la historia introduce una decisión técnica relevante, se documenta como un ADR (Architecture Decision Record) en `docs/adr/`.

---

### 2.5 Criterios de Aceptación

13. Todos los criterios de aceptación definidos en la historia están cumplidos y verificados.

---

### 2.6 Integración con el Sistema

14. El servicio modificado no rompe funcionalidades existentes de otros servicios (verificado mediante pruebas de integración y validación en staging).
15. Si la historia afecta la comunicación entre servicios (nuevos mensajes en RabbitMQ, nuevos endpoints, cambios en contratos de API), los servicios consumidores están actualizados y funcionan correctamente.

---

## 3. Nivel 2 — DoD de Sprint (Incremento)

Al finalizar cada sprint, el incremento entregado debe cumplir **todos** los puntos siguientes:

1. Todas las historias incluidas en el sprint cumplen el DoD de Historia (Nivel 1, los 15 puntos).
2. El incremento es funcional de extremo a extremo en el ambiente de staging. Los flujos completos que involucran las historias del sprint se verifican como operativos.
3. No se introducen regresiones: las funcionalidades terminadas en sprints anteriores siguen funcionando correctamente después de los cambios del sprint actual.
4. El Product Backlog está actualizado: las historias completadas están marcadas como terminadas, y las nuevas historias o cambios que surgieron durante el sprint están reflejados.

---

## 4. Nivel 3 — DoD de Release (Lanzamiento a Producción)

Cuando se decide lanzar un conjunto de incrementos a producción, se deben cumplir **todos** los puntos siguientes:

1. Todos los incrementos incluidos en el release cumplen el DoD de Sprint (Nivel 2).
2. Se ejecutaron pruebas de rendimiento básicas: el sistema responde dentro de tiempos aceptables bajo la carga esperada para los flujos principales (predicciones en tiempo real, consultas batch).
3. La documentación de usuario está actualizada: las funcionalidades nuevas que el usuario final o el administrador van a utilizar están documentadas (guías de uso).
4. Se realizó una verificación de seguridad básica: tokens de autenticación funcionan correctamente, endpoints están protegidos, no hay datos sensibles expuestos en logs ni respuestas.
5. Existe un plan de rollback documentado: si algo falla en producción, se puede revertir a la versión anterior de forma rápida y controlada.

---

## 5. Notas sobre la Evolución del DoD

El Definition of Done es un **documento vivo** que evoluciona con la madurez del proyecto y del equipo. En la práctica de Scrum, es válido y recomendado revisar y fortalecer el DoD al finalizar cada Sprint Review o Retrospectiva.

Aspectos que se incorporarán progresivamente conforme el proyecto avance:

- **Pruebas de API (contrato):** Verificación de que cada microservicio responde correctamente a las peticiones HTTP según su contrato definido (formato de entrada, formato de salida, códigos de error).
- **Cobertura mínima de pruebas:** Definición de un porcentaje mínimo de cobertura de código por pruebas unitarias (por ejemplo, 80%).
- **Pruebas de carga y estrés:** Verificación del comportamiento del sistema bajo condiciones de alta demanda.

---

## 6. Resumen

| Nivel | Puntos | Se aplica |
|-------|--------|-----------|
| Nivel 1 — Historia | 15 puntos (6 dimensiones) | A cada historia individual |
| Nivel 2 — Sprint | 4 puntos | Al finalizar cada sprint |
| Nivel 3 — Release | 5 puntos | Al lanzar a producción |
| **Total** | **24 puntos de verificación** | |
