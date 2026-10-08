# MULTIAZ APP

## Prerrequisitos

- Flutter instalado y un dispositivo disponible para ejecutarlo.
- El backend corriendo, accesible en el puerto 8080 del gateway. [¿Cómo levantar el Docker?](../../README.md#instalación-y-ejecución)

## Formas de arrancar el sistema

### Listar los dispositivos
Antes de ejecutar la aplicación se debe averiguar qué dispositivos podemos utilizar.
Para ello utilizamos el siguiente comando:

```bash
flutter devices
```

> Esto devuelve una tabla de los dispositivos con sus IDs correspondientes.

### 1. Arrancar mediante un emulador Android

```bash
flutter run -d <ID-Dispositivo>
```

> [!NOTE]
> En el emulador no es necesario especificar el valor de la variable `API_GATEWAY_URL`
> debido a que el código define `10.0.2.2` como valor por defecto.

### 2. Arrancar mediante un dispositivo físico

```bash
flutter run -d <ID-Dispositivo> --dart-define=API_GATEWAY_URL="http://<IP-de-tu-LAN>:8080"
```

> [!IMPORTANT]
> El valor de `--dart-define` se fija **una sola vez**: cuando escribes y ejecutas el
> comando `flutter run`. Ni `r` ni `R` lo vuelven a leer. Para cambiar el valor detén la app (mediante la tecla `q`) y vuelve a ejecutar el comando.
