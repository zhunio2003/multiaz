# DT-010: INTERPRETACION INCONSISTENTE DE JWT_SECRET ENTRE API-GATEWAY y AUTH-SERVICE

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Sprint detectado:** Sprint 7  
**Historia afectada:** DT-009 y HU-03.1  
**Prioridad:** Alta  
**Sprint destino:** Sprint 7  
**Autor:** Miguel Angel Zhunio Remache  
**Fecha:** 9 de Octubre de 2026

---

## Descripción

Los servicios de API-GATEWAY y AUTH-SERVICE interpretan `JWT_SECRET` de forma distinta (texto frente a Base64), lo que provoca que al realizar una peticion al API-GATEWAY rechace con 401 todo token válido en las rutas protegidas.

Este problema no fue detectado antes debido a que las rutas anteriormente utilizadas (en este caso solo el /login) eran publicas, asi que el api-gateway nunca verifica una firma ahí. En el caso de las pruebas unitarias `JwtServiceTest` solo prueba al emisor y no la verificación del gateway.

Esta tarea no puede ser diferida para proximos sprints debido a que bloquea el CA2 de DT-009 y todo HU-03.1, porque ninguna ruta protegida funciona desde el cliente.  

## Evidencia Observada

Al realizar una peticion al gateway rechaza aunque el token sea valido.

```bash
curl -i "http://localhost:8080/models?status=ACTIVE" -H "Authorization: Bearer $TOKEN"
HTTP/1.1 401 
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 10 Oct 2026 04:27:13 GMT

{"timestamp":"2026-10-10T04:27:13.553Z","status":401,"error":"Unauthorized","path":"/models"}
```

En cambio al realizar una peticion directamente al servicio model-registry esta devuelve un 200. Esta peticion se puede con o sin el access token y siempre devolvera los modelos.

```bash
curl -i "http://localhost:8083/models?status=ACTIVE" -H "Authorization: Bearer $TOKEN"
HTTP/1.1 200 
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 10 Oct 2026 05:14:49 GMT

[{"id":"6a28e74255ae4c970c0346d4","name":"fake-news-detector","description":"Clasificador de noticias falsas usando TF-IDF y Logistic Regression","type":"NLP","status":"ACTIVE","endpointUrl":"http://fake-news-detector-multiaz:8091/predict","inputSchema":"{\"title\": \"string\", \"text\": \"string\"}","outputSchema":"{\"result\": \"string\", \"confidence\": \"float\"}","version":"1.0.0","createdAt":"2026-06-10T04:25:38.436"},{"id":"6a472ff7cdfee43a64badbf5","name":"fake-news-detector","description":"Clasificador de noticias falsas usando TF-IDF y Logistic Regression","type":"NLP","status":"ACTIVE","endpointUrl":"http://fake-news-detector-multiaz:8091/predict","inputSchema":"{\"title\": \"string\", \"text\": \"string\"}","outputSchema":"{\"result\": \"string\", \"confidence\": \"float\"}","version":"1.0.0","createdAt":"2026-07-03T03:43:51.479"}]
```

```bash
curl -i "http://localhost:8083/models?status=ACTIVE"
HTTP/1.1 200 
Content-Type: application/json
Transfer-Encoding: chunked
Date: Sat, 10 Oct 2026 04:36:49 GMT

[{"id":"6a28e74255ae4c970c0346d4","name":"fake-news-detector","description":"Clasificador de noticias falsas usando TF-IDF y Logistic Regression","type":"NLP","status":"ACTIVE","endpointUrl":"http://fake-news-detector-multiaz:8091/predict","inputSchema":"{\"title\": \"string\", \"text\": \"string\"}","outputSchema":"{\"result\": \"string\", \"confidence\": \"float\"}","version":"1.0.0","createdAt":"2026-06-10T04:25:38.436"},{"id":"6a472ff7cdfee43a64badbf5","name":"fake-news-detector","description":"Clasificador de noticias falsas usando TF-IDF y Logistic Regression","type":"NLP","status":"ACTIVE","endpointUrl":"http://fake-news-detector-multiaz:8091/predict","inputSchema":"{\"title\": \"string\", \"text\": \"string\"}","outputSchema":"{\"result\": \"string\", \"confidence\": \"float\"}","version":"1.0.0","createdAt":"2026-07-03T03:43:51.479"}]
```

## Configuración Actual

### API-GATEWAY
```java

  private SecretKey getSecretKey() {
    return Keys.hmacShaKeyFor(jwtSecret.getBytes());
  }

``` 

### AUTH-SERVICE
```java

  private SecretKey getSignKey() {
    return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secretString));
  }

```

## Estado Actual

Los dos servicios tienen distintas formas de leer la misma propiedad `jwt.secret`:

| Servicio | Qué hace con el texto del secreto |
|---|---|
| `auth-service` (firma) | `Decoders.BASE64.decode(secret)`: lo **decodifica** de Base64 y usa esos bytes |
| `api-gateway` (verifica) | `jwtSecret.getBytes()`: usa los **caracteres del texto** tal cual |

## Criterios de aceptación

1. La prueba automatizada positiva pasa: un token firmado como lo hace `auth-service` es aceptado por el `api-gateway`.
2. La prueba con la firma alterada devuelve `401`.
3. Una petición a `/models` por el puerto `8080` con un token fresco devuelve `200`.
4. `/auth/login` sigue funcionando.

## Plan de Resolución

| ID Tarea | Descripción | Horas Est. | Horas reales | Estado |
|---|---|---|---|---|
| T-DT010.1 | **Pruebas automatizadas (caso positivo)**: crear pruebas que firmen un token como lo hace el emisor (`auth-service`) y verifiquen que el gateway lo acepte correctamente. | 0.5 h | | Pendiente |
| T-DT010.2 | **Pruebas automatizadas (caso negativo)**: verificar que un token con la firma alterada, o firmado con otro secreto, sea rechazado con `401`. Sin esta prueba, un arreglo que deja pasar cualquier token también parecería funcionar. | 0.5 h | | Pendiente |
| T-DT010.3 | **Ajustar la lectura de `jwt.secret` en `api-gateway`**: modificar la forma en que el servicio lee la propiedad para que interprete el secreto igual que `auth-service` (decodificándolo de Base64) y ambos usen los mismos bytes. | 0.5 h | | Pendiente |
| T-DT010.4 | **Reconstruir la imagen del `api-gateway`**: generar de nuevo el `.jar` y la imagen, y recrear el contenedor. Sin este paso el contenedor sigue ejecutando el `.jar` anterior y el `curl` devolvería 401 aunque el arreglo esté hecho. | 0.5 h | | Pendiente |
| T-DT010.5 | **Validación manual con `curl`**: enviar una petición a `/models` por el puerto `8080` con un token válido y comprobar que la respuesta sea `200 OK`. | 0.5 h | | Pendiente |
| | **Total** | **2.5 h** | | |


## Impacto

Este problema no sumará al alcance del proyecto pero consumira las horas reservas de este sprint. Por lo cual el tope de 25 horas seguira igual. Pero gracias a esto se podra continuar con el trabajo del sprint.

Como se cuenta con 19 horas comprometidas mas 2.5 horas extras debido a esta tarea, ahora quedaria un total de 21.5 horas comprometidas y 3.5 horas de colchón. 
