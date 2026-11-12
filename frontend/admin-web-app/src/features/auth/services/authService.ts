/*
 * ============================================================
 *  SERVICIO DE AUTENTICACIÓN (por ahora SIMULADO)
 * ============================================================
 *  Un "servicio" es un archivo que habla con el backend.
 *  Los componentes NUNCA hacen peticiones HTTP directamente:
 *  le piden al servicio "loguéame" y no saben cómo se hace.
 *
 *  Ventaja: hoy esto es falso (un setTimeout). Cuando conectemos
 *  el API Gateway con axios (paso futuro, TS-17.5) cambiamos
 *  SOLO este archivo, y el LoginForm sigue igual.
 *
 *  Credenciales de prueba:
 *    email:      admin@multiaz.dev
 *    contraseña: Admin123!
 * ============================================================
 */

import { DEV_OPEN_LOGIN } from "../../../core/devFlags";

// ---------- Tipos ----------
// "export" permite importarlos desde otros archivos.

/** Lo que el formulario le manda al servicio */
export interface LoginCredentials {
    email: string;
    password: string;
}

/** El usuario que inició sesión */
export interface SessionUser {
    name: string;
    email: string;
    role: 'ADMIN';
}

/** Lo que el backend devolverá (forma que esperamos del Auth Service) */
export interface LoginResponse {
    accessToken: string;
    refreshToken: string;
    user: SessionUser;
}

/*
 * Error propio para fallos de login.
 * Así el formulario puede distinguir "credenciales malas" (mostrar
 * mensaje al usuario) de un error inesperado (bug, sin red...).
 */
export class AuthError extends Error {
    constructor(message: string) {
        super(message);
        this.name = 'AuthError';
    }
}

// ---------- Simulación ----------
const DEMO_EMAIL = "admin@multiaz.dev";
const DEMO_PASSWORD = "Admin123!";

/** Espera "ms" milisegundos. Imita la demora de la red. */
function wait(ms: number): Promise<void> {

    return new Promise((resolve) => setTimeout(resolve, ms));
}
  
  /*
   * "async" = la función devuelve una Promise (un valor que llega "después").
   * Quien la llame usará "await login(...)" para esperar el resultado.
   */
export async function login(credentials: LoginCredentials): Promise<LoginResponse> {

    await wait(1200);
  
    // En modo desarrollo "abierto" cualquier dato (incluso vacío) es válido
    const isValid =
      DEV_OPEN_LOGIN || (credentials.email === DEMO_EMAIL && credentials.password === DEMO_PASSWORD);
  
    if (!isValid) {
      /*
       * SEGURIDAD: el mensaje NO dice si falló el email o la contraseña.
       * Si dijera "ese email no existe", un atacante podría averiguar
       * qué emails de administradores son reales.
       */
      throw new AuthError('Email o contraseña incorrectos.');
    }
  
    return {
      accessToken: 'demo-access-token',
      refreshToken: 'demo-refresh-token',
      user: { name: 'Admin MultIAZ', email: credentials.email || DEMO_EMAIL, role: 'ADMIN' },
    };

}
