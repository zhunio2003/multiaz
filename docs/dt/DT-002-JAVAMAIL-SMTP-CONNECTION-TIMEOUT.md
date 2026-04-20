# DT-002 — Spring Security Bloquea POST Requests con HTTP 403 en Spring Boot 4.x

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Sprint detectado:** Sprint 3  
**Historia afectada:** HU-01.4 — Recuperación de Contraseña
**Prioridad:** Alta  
**Sprint destino:** Sprint 4  
**Autor:** Miguel Angel Zhunio Remache  
**Fecha:** 20 de abril de 2026

---

## Descripción

Connection timeout al conectar con sandbox.smtp.mailtrap.io:587 desde contenedor Docker

---

## Evidencia Observada

``` bash 

docker logs auth-service 2>&1 | grep -A 5 "ConnectException"

org.eclipse.angus.mail.util.MailConnectException: Couldn't connect to host, port: sandbox.smtp.mailtrap.io, 587; timeout -1;
  nested exception is:
        java.net.ConnectException: Connection timed out
        at org.eclipse.angus.mail.smtp.SMTPTransport.openServer(SMTPTransport.java:2243)
        at org.eclipse.angus.mail.smtp.SMTPTransport.protocolConnect(SMTPTransport.java:729)
```

---

## Configuración Actual

```yml
spring:
  mail:
    host: sandbox.smtp.mailtrap.io
    port: 587
    username: ${MAILTRAP_USER}
    password: ${MAILTRAP_PASSWORD}
```

---

## Hipótesis de Causa Raíz

Puerto 587 bloqueado por red del host / restricción de salida a internet desde contenedor

---

## Plan de Resolución para Sprint 4

Investigar en el siguiente orden — detener al encontrar la solución que funcione:

**Opcion 1 — Configurar red Docker para permitir salida al 587.**

**Opcion 2 — reemplazar Mailtrap sandbox por MailHog como SMTP local en Docker Compose**

---

## Impacto

HU-01.4 parcialmente completada — lógica backend correcta, envío de email bloqueado por infraestructura.

---



*MultIAZ — Sprint 3 | DT-002 | Abril 2026*
