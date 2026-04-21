# PRODUCT BACKLOG — HISTORIAS DE USUARIO Y TECHNICAL STORIES

**Proyecto:** MultIAZ — Plataforma de Predicción Especializada  
**Metodología:** Scrum  
**Versión del documento:** 1.2  
**Fecha:** 21 de Abril del 2026  
**Autor:** Miguel Angel Zhunio Remache

---

## 1. Introducción

Este documento contiene las **Historias de Usuario** y **Technical Stories** del Product Backlog del sistema MultIAZ, organizadas por épica y fase de desarrollo. Cada historia incluye su descripción en formato estándar y sus criterios de aceptación.

**Documentos de referencia:**

- `PRODUCT_BACKLOG_EPICAS_MULTIAZ.md` — Épicas y fases de desarrollo.
- `PRODUCT_VISION_BOARD_MULTIAZ.md` — Visión, usuarios, necesidades y objetivos de negocio.
- `ARQUITECTURA_DETALLADA_MULTIAZ.md` — Arquitectura completa del sistema (26 componentes).

**Formato de las historias:**

- **Historias de Usuario:** "Como [tipo de usuario], quiero [acción], para [beneficio]."
- **Technical Stories:** "Como [sistema / equipo de desarrollo], necesito [capacidad técnica], para que [beneficio técnico o habilitación]."

---

## 2. Fase 1 — Fundación (Infraestructura)

**Objetivo:** Establecer la base técnica sin la cual ningún servicio puede existir.

---

### EP-14 — Comunicación y Configuración

---

#### TS-14.1 — Configuración del Message Broker

**Story:** "Como sistema, necesito un Message Broker configurado y operativo, para que los microservicios puedan comunicarse de forma asíncrona sin acoplamiento directo entre ellos."

**Criterios de aceptación:**

1. El Message Broker está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede publicar un mensaje en una cola y otro servicio lo consume exitosamente.
3. Los mensajes se entregan en orden y persisten hasta ser procesados (no se pierden si el consumidor está temporalmente caído).
4. Las colas necesarias para los flujos del sistema están creadas:
   - Trabajos batch (Scheduler → Orchestrator).
   - Predicción batch completada (Orchestrator → Prediction Storage y → Notification Service).
   - Entrenamiento completado (Training Service → Notification Service).
   - Alertas de monitoreo (Logging & Monitoring → Notification Service).

---

#### TS-14.2 — Configuración del Service Discovery

**Story:** "Como sistema, necesito un servicio de descubrimiento dinámico, para que los microservicios puedan localizarse entre sí automáticamente sin direcciones hardcodeadas en el código."

**Criterios de aceptación:**

1. El Service Discovery está desplegado, accesible y responde health checks correctamente.
2. Un microservicio al iniciar se registra automáticamente con su nombre y dirección.
3. Un microservicio puede consultar la ubicación de otro servicio por nombre y obtener su dirección actual.
4. Si un servicio se reinicia o escala en una dirección diferente, el registro se actualiza automáticamente sin intervención manual.
5. Si un servicio se cae, el Service Discovery lo detecta y lo marca como no disponible.

---

#### TS-14.3 — Configuración del Servicio de Configuración Centralizada

**Story:** "Como sistema, necesito un servicio de configuración centralizada, para que todos los microservicios obtengan sus configuraciones desde un único punto en lugar de tenerlas repetidas individualmente."

**Criterios de aceptación:**

1. El Config Service está desplegado, accesible y responde health checks correctamente.
2. Las configuraciones de todos los microservicios están almacenadas en un solo lugar (credenciales de base de datos, API keys, feature flags, etc.).
3. Cada microservicio consulta y obtiene sus configuraciones al arrancar correctamente.
4. Un cambio de configuración se realiza una sola vez en el Config Service y los servicios afectados lo reciben sin necesidad de redespliegue (actualización en caliente).
5. Se soportan configuraciones diferenciadas por ambiente: desarrollo, staging y producción.

---

### EP-15 — Almacenamiento

---

#### TS-15.1 — Configuración del Cache Service

**Story:** "Como sistema, necesito una capa de caché compartida, para que las consultas frecuentes se sirvan rápidamente sin golpear la base de datos en cada petición."

**Criterios de aceptación:**

1. El Cache Service está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede almacenar y recuperar datos desde la caché correctamente.
3. Los datos cacheados tienen un tiempo de expiración configurable (TTL) para evitar servir información desactualizada.
4. Ante un cache miss (dato no encontrado en caché), la consulta se redirige a la base de datos, y el resultado se almacena en caché para futuras consultas.
5. Los tipos de datos cacheables se definirán cuando se desarrolle cada servicio en su fase correspondiente.

---

#### TS-15.2 — Configuración de la Base de Datos Principal

**Story:** "Como sistema, necesito almacenamiento persistente de datos, para que la información de usuarios, predicciones, metadata de modelos y logs se conserve de forma confiable y estructurada."

**Criterios de aceptación:**

1. Los servidores de base de datos (SQL y NoSQL) están desplegados, accesibles y responden health checks correctamente.
2. Dentro de los servidores, cada microservicio tiene su propio esquema o base de datos lógica independiente, siguiendo el patrón Database per Service.
3. Los datos transaccionales (usuarios, predicciones, metadata de modelos) se almacenan en base de datos relacional (SQL).
4. Los datos no estructurados (logs, eventos) se almacenan en base de datos NoSQL.
5. Cada microservicio tiene su propia base de datos lógica creada dentro del servidor correspondiente, vacía y sin tablas ni colecciones. Las estructuras de tablas y colecciones se definirán cuando se desarrolle cada servicio en su fase correspondiente.
6. Se cuenta con una estrategia de backups configurada para evitar pérdida de datos.

---

#### TS-15.3 — Configuración del Object Storage

**Story:** "Como sistema, necesito un almacén de objetos para archivos pesados y binarios, para que los datasets, modelos entrenados y backups se almacenen de forma independiente a la base de datos relacional."

**Criterios de aceptación:**

1. El Object Storage está desplegado, accesible y responde health checks correctamente.
2. Un servicio puede subir y descargar archivos correctamente (datasets, modelos serializados).
3. Los archivos se organizan en una estructura lógica definida (por ejemplo, separando datasets, modelos entrenados, backups y logs históricos).
4. Se soportan archivos de gran tamaño (cientos de MB o GB) sin fallos ni timeouts.
5. Los backups de la base de datos se almacenan aquí según la estrategia definida en TS-15.2.

---

### EP-16 — Operaciones

---

#### TS-16.1 — Configuración del Container Orchestrator

**Story:** "Como sistema, necesito un orquestador de contenedores, para que todos los microservicios se desplieguen, escalen y se recuperen de fallos de forma automatizada."

**Criterios de aceptación:**

1. El orquestador de contenedores está desplegado y operativo.
2. Los microservicios se despliegan como contenedores gestionados por el orquestador.
3. Si un contenedor se cae, el orquestador lo levanta automáticamente (self-healing).
4. Un servicio puede escalar horizontalmente (más instancias) cuando la carga aumenta y reducir instancias cuando la carga baja.
5. Los despliegues se realizan sin downtime (rolling updates o blue-green deployment).
6. La red interna entre servicios está configurada para que los contenedores se comuniquen entre sí.
7. Los secrets y configuraciones sensibles se gestionan de forma segura dentro del orquestador.

---

#### TS-16.2 — Configuración del CI/CD Pipeline

**Story:** "Como equipo de desarrollo, necesitamos un pipeline de integración y despliegue continuo, para que el código pase automáticamente por pruebas, construcción y despliegue sin intervención manual."

**Criterios de aceptación:**

1. El pipeline se activa automáticamente cuando se sube un cambio al repositorio de código.
2. Se ejecutan pruebas automatizadas (unitarias e integración) y el pipeline se detiene si alguna falla.
3. Si las pruebas pasan, se construye automáticamente la imagen del contenedor del servicio modificado.
4. La imagen construida se despliega automáticamente en el ambiente de staging para validación.
5. Tras aprobación manual, se despliega en el ambiente de producción a través del Container Orchestrator (TS-16.1).

---

### EP-17 — Fundación Frontend

---

#### TS-17.1 — Inicialización de la Mobile App (Flutter)

**Story:** "Como equipo de desarrollo, necesitamos el proyecto de la Mobile App creado y configurado con su estructura base, herramientas de calidad de código y entorno de pruebas, para que las historias de usuario de Fase 2 tengan dónde implementar sus pantallas."

**Criterios de aceptación:**

1. El proyecto Flutter está creado en la ruta `frontend/mobile-app/` del monorepo con la estructura de carpetas estándar de Flutter.
2. El linter `dart analyze` está configurado con las reglas recomendadas por Flutter (`flutter_lints`) y se ejecuta sin errores ni warnings sobre el proyecto base.
3. El formatter `dart format` está configurado y el código base cumple las reglas de formato.
4. El framework de testing (`flutter_test`) está configurado y se puede ejecutar al menos un test de ejemplo exitosamente.
5. La app se compila y ejecuta mostrando una pantalla base placeholder sin errores.
6. La estructura de carpetas sigue una organización por feature/módulo que soporte el crecimiento del proyecto: separación de pantallas, widgets, servicios, modelos y utilidades.

---

#### TS-17.2 — Design System de MultIAZ

**Story:** "Como equipo de desarrollo, necesitamos un sistema de diseño unificado que defina la identidad visual de la plataforma e implemente los componentes base reutilizables, para que todas las pantallas de ambos clientes mantengan consistencia visual y no se rehaga trabajo de estilos en cada historia."

**Criterios de aceptación:**

1. La paleta de colores de MultIAZ está definida: colores primario, secundario, de acento, de fondo, de superficie, de texto, de éxito, de error y de advertencia, con sus variantes para modo claro.
2. La tipografía está definida: familia tipográfica, tamaños para headings (h1-h6), body, caption y button, con sus pesos correspondientes.
3. El spacing system está definido: escala de espaciado consistente (por ejemplo, 4px, 8px, 12px, 16px, 24px, 32px, 48px) aplicable a márgenes, paddings y gaps.
4. Los componentes base reutilizables están implementados en Flutter: botón primario, botón secundario, campo de texto (input), card, app bar personalizada y layout de pantalla base.
5. Cada componente base acepta las variantes necesarias (por ejemplo, botón habilitado/deshabilitado/loading, input con/sin error).
6. Los tokens de diseño (colores, tipografía, spacing) están centralizados en archivos de tema de Flutter (`ThemeData`) y no hardcodeados en los componentes.
7. Las decisiones de diseño están documentadas en `docs/guides/DESIGN_SYSTEM_MULTIAZ.md` como referencia para la implementación futura en React.

---

#### TS-17.3 — Conexión con el Backend desde la Mobile App

**Story:** "Como sistema, necesita la Mobile App un módulo de comunicación HTTP configurado para conectarse con el API Gateway, para que todas las pantallas de Fase 2 puedan enviar y recibir datos del backend sin implementar la conexión desde cero en cada historia."

**Criterios de aceptación:**

1. Existe un servicio HTTP centralizado en la Mobile App que dirige todas las peticiones al API Gateway como punto de entrada único.
2. El servicio HTTP agrega automáticamente el token JWT en el header `Authorization` de cada petición autenticada.
3. Si una petición recibe un error 401 (token expirado), el servicio intenta renovar el token usando el refresh token antes de reintentar la petición original.
4. Si el refresh token también ha expirado o es inválido, el usuario es redirigido automáticamente a la pantalla de login.
5. Los errores de red (timeout, sin conexión, errores 5xx) se capturan de forma centralizada y se presentan al usuario con mensajes claros, sin exponer detalles técnicos.
6. La URL base del API Gateway se obtiene desde la configuración de la app, no está hardcodeada en el código.

---

#### TS-17.4 — Inicialización del Admin Web App (React)

**Story:** "Como equipo de desarrollo, necesitamos el proyecto del Admin Web App creado y configurado con su estructura base, herramientas de calidad de código, entorno de pruebas y el design system implementado, para que las historias de Fase 3 tengan dónde implementar sus pantallas de administración."

**Criterios de aceptación:**

1. El proyecto React con TypeScript está creado en la ruta `frontend/admin-web-app/` del monorepo con la estructura de carpetas estándar.
2. El linter ESLint está configurado con reglas recomendadas para React + TypeScript y se ejecuta sin errores ni warnings sobre el proyecto base.
3. El formatter Prettier está configurado y el código base cumple las reglas de formato.
4. El framework de testing (Jest + React Testing Library) está configurado y se puede ejecutar al menos un test de ejemplo exitosamente.
5. La app se compila y ejecuta mostrando una pantalla base placeholder sin errores.
6. La estructura de carpetas sigue una organización por feature/módulo que soporte el crecimiento del proyecto: separación de páginas, componentes, servicios, modelos y utilidades.
7. Los tokens de diseño definidos en TS-17.2 están implementados como CSS variables / tema del proyecto, siguiendo la documentación de `docs/guides/DESIGN_SYSTEM_MULTIAZ.md`.
8. Los componentes base reutilizables están implementados en React: botón primario, botón secundario, campo de texto (input), card, sidebar de navegación y layout de página base.

---

#### TS-17.5 — Conexión con el Backend desde el Admin Web App

**Story:** "Como sistema, necesita el Admin Web App un módulo de comunicación HTTP configurado para conectarse con el API Gateway, para que todas las pantallas de Fase 3 puedan enviar y recibir datos del backend sin implementar la conexión desde cero en cada historia."

**Criterios de aceptación:**

1. Existe un servicio HTTP centralizado en el Admin Web App que dirige todas las peticiones al API Gateway como punto de entrada único.
2. El servicio HTTP agrega automáticamente el token JWT en el header `Authorization` de cada petición autenticada.
3. Si una petición recibe un error 401 (token expirado), el servicio intenta renovar el token usando el refresh token antes de reintentar la petición original.
4. Si el refresh token también ha expirado o es inválido, el usuario es redirigido automáticamente a la pantalla de login.
5. Los errores de red (timeout, sin conexión, errores 5xx) se capturan de forma centralizada y se presentan al usuario con mensajes claros, sin exponer detalles técnicos.
6. La URL base del API Gateway se obtiene desde variables de entorno del proyecto, no está hardcodeada en el código.

---

### EP-18 — Exposición y Enrutamiento de Servicios

---

#### TS-18.1 — Configuración del API Gateway

**Story:** "Como sistema, necesito un punto de entrada centralizado para todas las peticiones externas, para que los clientes nunca accedan directamente a los microservicios internos y todas las peticiones pasen por un único componente de enrutamiento y seguridad."

**Criterios de aceptación:**

1. El API Gateway está desplegado, accesible y responde health checks correctamente.
2. Las peticiones entrantes son enrutadas al microservicio correspondiente según la ruta solicitada, utilizando el Service Discovery (Eureka) para resolver la ubicación del servicio.
3. Las rutas públicas (registro, login, recuperación de contraseña) son accesibles sin token. Las rutas protegidas rechazan peticiones sin token válido con HTTP 401.
4. El API Gateway valida el JWT antes de enrutar la petición a cualquier servicio protegido. Si el token es inválido o expirado, la petición es rechazada con HTTP 401 sin llegar al microservicio.
5. La configuración de CORS está centralizada en el API Gateway, permitiendo peticiones desde los clientes autorizados (Flutter mobile y React admin web).

> **Nota:** Esta épica pertenece conceptualmente a Fase 1 — Fundación. Su implementación se difirió al Sprint 3 porque su prerequisito real no era temporal sino la existencia de al menos un microservicio real que enrutar.

---

## 3. Fase 2 — Experiencia del Usuario

**Objetivo:** Permitir que el usuario final pueda usar la plataforma en sus funcionalidades esenciales.

---

### EP-01 — Autenticación de Usuarios

---

#### HU-01.1 — Registro de Usuario

**Story:** "Como usuario, quiero crear una cuenta en la plataforma, para poder acceder a los servicios de predicción."

**Criterios de aceptación:**

1. El usuario puede registrarse proporcionando nombre, email y contraseña.
2. El sistema valida que el email no esté ya registrado.
3. La contraseña cumple requisitos mínimos de seguridad (longitud mínima, complejidad).
4. Al completar el registro, el usuario recibe un token de acceso y queda autenticado automáticamente.
5. Los datos del usuario se almacenan de forma segura (contraseña encriptada, nunca en texto plano).

---

#### HU-01.2 — Inicio de Sesión

**Story:** "Como usuario, quiero iniciar sesión con mis credenciales, para acceder a mi cuenta y utilizar la plataforma."

**Criterios de aceptación:**

1. El usuario puede iniciar sesión con email y contraseña.
2. Si las credenciales son correctas, el sistema genera y devuelve un token de acceso (JWT) y un refresh token.
3. Si las credenciales son incorrectas, el sistema responde con un mensaje de error claro sin revelar cuál campo es el incorrecto.
4. El token de acceso tiene un tiempo de expiración definido.

---

#### HU-01.3 — Refresh Token

**Story:** "Como usuario, quiero que mi sesión se mantenga activa de forma segura, para no tener que iniciar sesión cada vez que el token expire."

**Criterios de aceptación:**

1. Cuando el token de acceso expira, el sistema puede generar uno nuevo usando el refresh token sin pedir credenciales nuevamente.
2. El refresh token tiene un tiempo de expiración mayor al del token de acceso.
3. Si el refresh token también ha expirado, el usuario debe iniciar sesión nuevamente.
4. Un refresh token solo puede usarse una vez (al usarlo se genera uno nuevo).

---

#### HU-01.4 — Recuperación de Contraseña

**Story:** "Como usuario, quiero recuperar mi contraseña si la olvido, para poder volver a acceder a mi cuenta."

**Criterios de aceptación:**

1. El usuario puede solicitar la recuperación ingresando su email registrado.
2. El sistema envía un enlace o código de recuperación al email del usuario.
3. El enlace o código tiene un tiempo de expiración limitado por seguridad.
4. El usuario puede establecer una nueva contraseña que cumpla los requisitos de seguridad.
5. Tras cambiar la contraseña, las sesiones anteriores se invalidan.

---

### EP-02 — Realización de Predicciones

---

#### HU-02.1 — Catálogo de Modelos de Predicción

**Story:** "Como usuario, quiero ver la lista de modelos de predicción disponibles con su nombre, descripción y tipo, para elegir cuál utilizar."

**Criterios de aceptación:**

1. El usuario puede consultar el catálogo de todos los modelos de IA activos en la plataforma.
2. Cada modelo muestra su nombre, descripción y tipo de predicción que realiza.
3. Los modelos desactivados por el administrador no aparecen en el catálogo.
4. El catálogo se actualiza automáticamente cuando se registran o desactivan modelos en el Model Registry.

---

#### HU-02.2 — Solicitud de Predicción en Tiempo Real

**Story:** "Como usuario, quiero seleccionar un modelo, ingresar los datos requeridos y recibir una predicción al instante, para tomar decisiones basadas en datos."

**Criterios de aceptación:**

1. Al seleccionar un modelo, el sistema presenta el formulario con los campos de entrada requeridos según el esquema de inputs del modelo.
2. El sistema valida que los datos ingresados cumplan el formato esperado antes de enviar la solicitud.
3. La predicción se devuelve al usuario en tiempo real con el resultado claro y comprensible.
4. Cada predicción realizada se almacena automáticamente en el Prediction Storage Service.
5. Si el modelo de IA no está disponible, el sistema responde con un mensaje de error claro sin romper la experiencia.

---

#### HU-02.3 — Detalle de la Predicción

**Story:** "Como usuario, quiero ver los detalles expandidos de una predicción realizada, para entender mejor el resultado y las estadísticas que lo respaldan."

**Criterios de aceptación:**

1. Después de recibir una predicción, el usuario puede seleccionar la opción "ver detalles".
2. El detalle muestra estadísticas adicionales que respaldan el resultado (datos históricos relevantes, nivel de confianza, factores considerados).
3. La información se presenta de forma clara y comprensible para un usuario no técnico.

---

### EP-03 — Historial de Predicciones

---

#### HU-03.1 — Consulta de Historial de Predicciones

**Story:** "Como usuario, quiero consultar todas las predicciones que he realizado previamente, para poder revisarlas en cualquier momento."

**Criterios de aceptación:**

1. El usuario puede ver una lista de todas sus predicciones realizadas, ordenadas de la más reciente a la más antigua.
2. Cada predicción muestra: modelo utilizado, datos ingresados, resultado obtenido y fecha/hora de la consulta.
3. El usuario puede acceder al detalle completo de cualquier predicción del historial.

---

#### HU-03.2 — Filtros y Búsqueda en el Historial

**Story:** "Como usuario, quiero filtrar y buscar en mi historial de predicciones, para encontrar rápidamente una predicción específica."

**Criterios de aceptación:**

1. El usuario puede filtrar sus predicciones por modelo de IA utilizado.
2. El usuario puede filtrar por rango de fechas.
3. Los filtros se pueden combinar entre sí.
4. Si no hay resultados que coincidan con los filtros, el sistema muestra un mensaje claro indicándolo.

---

### EP-04 — Gestión de Perfil de Usuario

---

#### HU-04.1 — Consulta de Perfil

**Story:** "Como usuario, quiero ver la información de mi perfil, para conocer mis datos registrados y mi plan actual en la plataforma."

**Criterios de aceptación:**

1. El usuario puede visualizar sus datos personales (nombre, email).
2. El usuario puede ver su tipo de plan actual (gratuito o de pago).
3. Si es plan gratuito, se muestra el número de predicciones realizadas vs. el límite mensual (50).

---

#### HU-04.2 — Edición de Perfil

**Story:** "Como usuario, quiero editar mis datos personales y preferencias, para mantener mi información actualizada."

**Criterios de aceptación:**

1. El usuario puede modificar su nombre y otros datos personales.
2. El usuario puede cambiar su contraseña proporcionando la contraseña actual como verificación.
3. Los cambios se guardan y reflejan inmediatamente en el perfil.
4. El email no se puede modificar ya que es el identificador único de la cuenta.

---

### EP-05 — Predicciones Automáticas (Batch)

---

#### HU-05.1 — Consulta de Predicciones Batch

**Story:** "Como usuario empresa, quiero consultar las predicciones generadas automáticamente por el sistema, para tomar decisiones basadas en datos actualizados sin tener que solicitar cada predicción manualmente."

**Criterios de aceptación:**

1. El usuario puede ver la lista de predicciones batch disponibles, organizadas por modelo y fecha de generación.
2. Cada resultado muestra: modelo utilizado, resultado de la predicción, fecha y hora de ejecución.
3. El usuario puede acceder al detalle completo de cada predicción batch.
4. Los resultados se sirven desde caché cuando están disponibles para garantizar rapidez de consulta.

---

#### HU-05.2 — Monitoreo Continuo de Predicciones

**Story:** "Como usuario empresa, quiero visualizar las predicciones batch de forma continua y actualizada, para monitorear tendencias y cambios en tiempo real."

**Criterios de aceptación:**

1. El usuario puede ver un panel con las predicciones batch más recientes actualizándose según la frecuencia configurada para cada modelo.
2. Se visualizan tendencias (incrementos y decrementos) entre predicciones consecutivas del mismo modelo.
3. Los datos se actualizan automáticamente sin que el usuario tenga que refrescar manualmente.

---

## 4. Fase 3 — Administración de la Plataforma

**Objetivo:** Dotar al administrador de las herramientas para gestionar y operar la plataforma de forma autónoma.

> **Nota:** Las historias de esta fase se presentan con nombre y story únicamente. Los criterios de aceptación se detallarán cuando se acerquen al sprint correspondiente (refinamiento progresivo).

---

### EP-08 — Gestión de Modelos de IA

---

#### TS-08.1 — Model Registry Service

**Story:** "Como sistema, necesito un registro centralizado de modelos de IA con su metadata, para que el administrador pueda gestionar el catálogo de modelos disponibles y el Prediction Orchestrator pueda resolver el destino correcto de cada predicción."

**Estimación:** 5 SP | **Sprint:** 4

**Criterios de aceptación:**

1. El servicio levanta correctamente y responde `UP` en `GET /actuator/health`.
2. El servicio se registra automáticamente en Eureka al arrancar.
3. Existe un `@Document` con la metadata del modelo, su `MongoRepository` y service con lógica de negocio.
4. Endpoints disponibles: `POST /models`, `GET /models?status=ACTIVE`, `GET /models/{id}`.
5. El servicio está containerizado en `docker-compose.yml` y levanta con el stack completo.
6. Un test verifica que `GET /models/{id}` retorna el documento correcto desde MongoDB.

---

#### HU-08.1 — Registro de Nuevos Modelos

**Story:** "Como administrador, quiero registrar nuevos modelos de IA con su metadata completa, para que queden disponibles automáticamente en la plataforma."

---

#### HU-08.2 — Activación y Desactivación de Modelos

**Story:** "Como administrador, quiero activar o desactivar modelos de IA sin eliminarlos, para controlar qué modelos están disponibles para los usuarios."

---

#### HU-08.3 — Consulta de Modelos y Metadata

**Story:** "Como administrador, quiero consultar el detalle y metadata de cada modelo registrado, para conocer su estado, versión, tipo de predicción y configuración."

---

#### HU-08.4 — Historial de Versiones de Modelos

**Story:** "Como administrador, quiero ver el historial de versiones de cada modelo, para tener trazabilidad de los cambios realizados."

---

### EP-09 — Gestión de Datasets

---

#### HU-09.1 — Carga de Datasets

**Story:** "Como administrador, quiero subir nuevos datasets a la plataforma, para que estén disponibles para el entrenamiento de los modelos."

---

#### HU-09.2 — Versionado de Datasets

**Story:** "Como administrador, quiero que los datasets tengan versionado, para no perder versiones anteriores y poder comparar entre ellas."

---

#### HU-09.3 — Validación de Datasets

**Story:** "Como administrador, quiero que el sistema valide el formato y calidad de los datos al subir un dataset, para evitar entrenar modelos con datos incorrectos."

---

#### HU-09.4 — Asociación de Datasets a Modelos

**Story:** "Como administrador, quiero asociar cada dataset con su modelo correspondiente, para mantener organizada la relación entre datos y modelos."

---

### EP-10 — Entrenamiento de Modelos de IA

---

#### HU-10.1 — Lanzar Reentrenamiento

**Story:** "Como administrador, quiero lanzar el reentrenamiento de un modelo con un dataset específico, para mejorar su precisión con datos actualizados."

---

#### HU-10.2 — Monitoreo de Progreso de Entrenamiento

**Story:** "Como administrador, quiero ver el progreso del entrenamiento en tiempo real, para saber en qué estado se encuentra el proceso."

---

#### HU-10.3 — Comparación de Versiones de Modelo

**Story:** "Como administrador, quiero comparar las métricas entre versiones de un modelo, para decidir si la nueva versión supera a la anterior."

---

#### HU-10.4 — Promoción y Rollback de Modelos

**Story:** "Como administrador, quiero promover un modelo nuevo a producción o hacer rollback a una versión anterior, para garantizar que siempre esté en producción la mejor versión."

---

### EP-11 — Logs y Monitoreo

---

#### HU-11.1 — Consulta Centralizada de Logs

**Story:** "Como administrador, quiero consultar los logs de todos los microservicios desde un solo punto, para diagnosticar problemas sin entrar servicio por servicio."

---

#### HU-11.2 — Monitoreo de Salud del Sistema

**Story:** "Como administrador, quiero ver el estado de salud de cada servicio y cada IA en tiempo real, para detectar problemas rápidamente."

---

#### HU-11.3 — Alertas Automáticas

**Story:** "Como administrador, quiero recibir alertas automáticas cuando un servicio se caiga, los tiempos de respuesta superen un umbral o la tasa de error aumente, para actuar de forma inmediata."

---

#### HU-11.4 — Dashboard de Rendimiento

**Story:** "Como administrador, quiero un dashboard con métricas de rendimiento en tiempo real, para tener visibilidad general del estado del sistema."

---

### EP-12 — Gestión de Usuarios

---

#### HU-12.1 — Consulta de Usuarios Registrados

**Story:** "Como administrador, quiero ver la lista de usuarios registrados y su actividad, para tener visibilidad de quién usa la plataforma."

---

#### HU-12.2 — Gestión de Roles

**Story:** "Como administrador, quiero asignar y modificar roles de usuarios, para controlar los niveles de acceso a la plataforma."

---

#### HU-12.3 — Auditoría de Sesiones

**Story:** "Como administrador, quiero ver quién se conectó, cuándo y desde dónde, para mantener la seguridad y trazabilidad del sistema."

---

#### HU-12.4 — Suspensión y Eliminación de Cuentas

**Story:** "Como administrador, quiero suspender o eliminar cuentas de usuario, para gestionar usuarios problemáticos o inactivos."

---

### EP-13 — Análisis de Predicciones Globales

---

#### HU-13.1 — Consulta Global de Predicciones

**Story:** "Como administrador, quiero consultar todas las predicciones del sistema con filtros por modelo, usuario, fecha y tipo, para analizar el uso general de la plataforma."

---

#### HU-13.2 — Estadísticas y Tendencias de Uso

**Story:** "Como administrador, quiero ver estadísticas de uso como total de predicciones por período, modelo más utilizado y tendencias, para tomar decisiones sobre la evolución de la plataforma."

---

## 5. Fase 4 — Mejoras Avanzadas

**Objetivo:** Funcionalidades de valor agregado que mejoran la experiencia pero no son esenciales para la operación básica.

> **Nota:** Las historias de esta fase se presentan con nombre y story únicamente. Los criterios de aceptación se detallarán cuando se acerquen al sprint correspondiente (refinamiento progresivo).

---

### EP-06 — Notificaciones

---

#### HU-06.1 — Notificaciones Push de Predicciones Batch

**Story:** "Como usuario empresa, quiero recibir notificaciones push cuando hay nuevas predicciones batch disponibles, para consultarlas de inmediato sin tener que revisar manualmente."

---

#### HU-06.2 — Notificaciones de Nuevos Modelos

**Story:** "Como usuario, quiero recibir notificaciones cuando se agregan nuevos modelos de predicción a la plataforma, para conocer las nuevas opciones disponibles."

---

#### HU-06.3 — Notificaciones de Alertas al Administrador

**Story:** "Como administrador, quiero recibir notificaciones cuando una IA se caiga, un entrenamiento finalice o haya alertas de rendimiento, para actuar sin tener que estar monitoreando constantemente."

---

#### HU-06.4 — Canales de Notificación

**Story:** "Como sistema, necesito soportar múltiples canales de envío de notificaciones (push móvil, email e in-app), para que cada tipo de usuario reciba las alertas por el medio adecuado."

---

### EP-07 — Recomendaciones Automatizadas

---

#### HU-07.1 — Detección de Tendencias

**Story:** "Como usuario empresa, quiero que el sistema detecte automáticamente tendencias significativas en las predicciones batch, para estar informado de cambios relevantes sin tener que analizarlos manualmente."

---

#### HU-07.2 — Recomendaciones Proactivas

**Story:** "Como usuario empresa, quiero recibir recomendaciones automáticas basadas en las tendencias detectadas, para tomar decisiones estratégicas de forma anticipada."

---

## 6. Resumen de Progreso

| Fase | Épicas | Technical Stories / Historias | Estado |
|------|--------|------------------------------|--------|
| Fase 1 — Fundación | EP-14, EP-15, EP-16, EP-17, EP-18 | 15 Technical Stories (13 completadas + 2 pendientes) | 🔄 En progreso |
| Fase 2 — Experiencia del Usuario | EP-01, EP-02, EP-03, EP-04, EP-05 | 11 Historias de Usuario | 🟡 En progreso |
| Fase 3 — Administración | EP-08, EP-09, EP-10, EP-11, EP-12, EP-13 | 1 TS + 22 Historias de Usuario | 🟡 Definido |
| Fase 4 — Mejoras Avanzadas | EP-06, EP-07 | 6 Historias de Usuario (sin criterios) | 🟡 Definido |

---

*MultIAZ — Product Backlog v1.2 | Abril 2026*