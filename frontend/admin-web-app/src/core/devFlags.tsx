/*
 * ============================================================
 *  BANDERAS DE DESARROLLO
 * ============================================================
 *  Atajos que SOLO existen mientras programas (pnpm dev).
 *
 *  DEV_OPEN_LOGIN → el login se muestra normal (con su animación),
 *  pero "Entrar" funciona con los campos VACÍOS (o con cualquier dato).
 *  Así recorres: login → dashboard → cerrar sesión → login...
 *  sin escribir credenciales cada vez.
 *
 *  Las DOS condiciones deben cumplirse:
 *    1. import.meta.env.DEV → true SOLO con "pnpm dev". En "pnpm build"
 *       vale false y Vite BORRA el código que depende de esto:
 *       el atajo nunca llega a producción.
 *    2. VITE_DEV_OPEN_LOGIN === 'true' → en el archivo .env.development.
 *       Ponla en false para probar el login de verdad (validaciones, errores).
 *  Las variables de entorno siempre llegan como TEXTO ('true'), no booleano.
 * ============================================================
 */

export const DEV_OPEN_LOGIN = import.meta.env.DEV && import.meta.env.VITE_DEV_OPEN_LOGIN === 'true';
