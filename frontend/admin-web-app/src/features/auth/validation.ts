/*
 * ============================================================
 *  VALIDACIONES DEL LOGIN
 * ============================================================
 *  Funciones "puras": reciben un valor y devuelven un mensaje
 *  de error, o undefined si todo está bien. No tocan React ni el DOM.
 *  Por eso son muy fáciles de probar con tests más adelante.
 *
 *  OJO: validar en el frontend es solo para la COMODIDAD del usuario.
 *  La seguridad real la pone el backend, que siempre vuelve a validar.
 * ============================================================
 */

/*
 * Expresión regular (regex) sencilla para un email:
 *   ^        inicio del texto
 *   [^\s@]+  uno o más caracteres que NO sean espacio ni @
 *   @        una arroba
 *   [^\s@]+  el dominio (ej: multiaz)
 *   \.       un punto literal
 *   [^\s@]+  la extensión (ej: dev)
 *   $        fin del texto
 * No es perfecta (ninguna lo es), pero atrapa los errores comunes.
 */
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// "string | undefined" = devuelve un texto O nada
export function validateEmail(email: string): string | undefined {

    if (email.trim() === '') return "Ingresa tu email";
    if (EMAIL_PATTERN.test(email.trim())) return "Ese email no tiene un formato válido."
    return undefined; 

}

export function validatePassword(password: string) {

    if (password === '') return "Ingresa tu contraseña.";
    return undefined;
    
} 