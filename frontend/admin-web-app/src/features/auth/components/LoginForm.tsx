/*
 * ============================================================
 *  LOGIN FORM — el formulario y toda su lógica
 * ============================================================
 *    - useState:  memoria del componente (lo escrito, si carga...)
 *    - useRef:    "agarrar" un elemento del DOM (para darle foco)
 *    - useId:     ids únicos para conectar <label> con <input>
 *    - Inputs CONTROLADOS: React es dueño del valor del input
 *    - Estado DERIVADO: valores que se calculan, no se guardan
 * ============================================================
 */

import { useId, useRef, useState } from 'react';
import type { SubmitEvent } from 'react'; // "import type": solo es un tipo, no existe en el JS final

import { AlertIcon, LockIcon, MailIcon } from '../../../core/components/icons';
import { DEV_OPEN_LOGIN } from '../../../core/devFlags';
import { Logo } from '../../../core/components/Logo';
import { AuthError, login } from '../services/authService';
import type { SessionUser } from '../services/authService';
import { validateEmail, validatePassword } from '../validation';
import styles from './LoginForm.module.css';

/*
 * Los estados posibles del envío. Con un tipo unión es IMPOSIBLE
 * quedar en un estado raro como "cargando y exitoso a la vez",
 * cosa que sí pasa si usas dos booleanos (isLoading, isSuccess).
 */
type SubmitStatus = 'idle' | 'submitting';

interface LoginFormProps {
  /*
   * "Callback": una función que nos pasa el PADRE para avisarle algo.
   * El formulario no decide a dónde ir después del login: solo avisa
   * "entró este usuario" y el padre (App) cambia de pantalla.
   */
  onSuccess: (user: SessionUser) => void;
}

export function LoginForm({ onSuccess }: LoginFormProps) {
  // ---------- 1. Estado ----------
  // useState devuelve [valorActual, funciónParaCambiarlo].
  // Cada vez que llamas a la función, React vuelve a dibujar el componente.
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [status, setStatus] = useState<SubmitStatus>('idle');
  // El <...> le dice a TypeScript el tipo: un texto o null (sin error)
  const [serverError, setServerError] = useState<string | null>(null);
  /*
   * ¿El usuario ya intentó enviar? Solo mostramos errores DESPUÉS
   * del primer intento. Gritarle "email inválido" mientras aún
   * está escribiendo es molesto.
   */
  const [hasTriedSubmit, setHasTriedSubmit] = useState(false);

  // ---------- 2. Refs ----------
  // Para mover el foco al primer campo con error al enviar.
  const emailRef = useRef<HTMLInputElement>(null);
  const passwordRef = useRef<HTMLInputElement>(null);

  // ---------- 3. Ids únicos ----------
  // useId genera algo como ":r1:". Lo usamos para enlazar label ↔ input
  // y input ↔ mensaje de error, sin riesgo de ids repetidos.
  const id = useId();
  const emailId = `${id}-email`;
  const passwordId = `${id}-password`;

  // ---------- 4. Estado derivado ----------
  /*
   * NO guardamos los errores en useState: se CALCULAN a partir de
   * email y password en cada render. Si los guardáramos, tendríamos
   * que acordarnos de actualizarlos siempre: fuente segura de bugs.
   */
  const showErrors = hasTriedSubmit && !DEV_OPEN_LOGIN;
  const emailError = showErrors ? validateEmail(email) : undefined;
  const passwordError = showErrors ? validatePassword(password) : undefined;
  const isSubmitting = status === 'submitting';

  // ---------- 5. Envío ----------
  async function handleSubmit(event: SubmitEvent<HTMLFormElement>) {
    // Sin esto, el navegador recarga la página al enviar.
    event.preventDefault();

    setHasTriedSubmit(true);
    setServerError(null);

    // Validamos con los valores actuales (no con emailError, que
    // pertenece al render ANTERIOR).
    // En modo desarrollo "abierto" saltamos la validación: se entra con todo vacío.
    if (!DEV_OPEN_LOGIN && validateEmail(email)) {
      emailRef.current?.focus(); // "?." = si es null, no hagas nada (no explota)
      return;
    }
    if (!DEV_OPEN_LOGIN && validatePassword(password)) {
      passwordRef.current?.focus();
      return;
    }

    setStatus('submitting');

    // try/catch: "intenta esto; si lanza un error, atrápalo aquí"
    try {
      const response = await login({ email: email.trim(), password });
      // Avisamos al padre. (Cuando conectemos el backend, aquí también
      // guardaremos los tokens: TS-17.5)
      onSuccess(response.user);
    } catch (error) {
      setStatus('idle');
      // "instanceof" pregunta: ¿este error es un AuthError?
      if (error instanceof AuthError) {
        setServerError(error.message);
      } else {
        // Nunca mostramos el error técnico al usuario (TS-17.5, criterio 5)
        setServerError('No pudimos conectar con el servidor. Inténtalo de nuevo.');
      }
    }
  }

  // ---------- 6. Formulario ----------
  return (
    /*
     * noValidate: apaga los globos de error nativos del navegador
     * (feos y distintos en cada navegador). Validamos nosotros.
     */
    <form className={styles.form} onSubmit={handleSubmit} noValidate>
      {/*
        ---------- Marca ----------
        El logo de MultIAZ ES el toque de IA: una línea de datos con
        nodos (como una red neuronal) y una curva de predicción.
        En el CSS lo animamos para que se "dibuje" al aparecer.
      */}
      <header className={styles.brand}>
        <Logo size={76} withWordmark={false} />
        <h1 className={styles.title}>Login</h1>
        <p className={styles.subtitle}>Panel de control de los agentes de predicción</p>
      </header>

      {/* Error del servidor. role="alert": el lector de pantalla lo lee apenas aparece. */}
      {serverError && (
        <div className={styles.alert} role="alert">
          <AlertIcon />
          <span>{serverError}</span>
        </div>
      )}

      {/* ---------- Campo: email ---------- */}
      <div className={styles.field}>
        {/*
          El diseño no muestra un texto encima del input, pero el <label>
          SIGUE siendo necesario para los lectores de pantalla.
          La clase "srOnly" lo oculta a la vista sin quitarlo del HTML.
        */}
        <label htmlFor={emailId} className={styles.srOnly}>
          Email
        </label>
        <div className={styles.inputWrap} data-invalid={Boolean(emailError)}>
          <input
            ref={emailRef}
            id={emailId}
            className={styles.input}
            type="email" // en el celular abre el teclado con "@"
            autoComplete="username" // el gestor de contraseñas sabe qué rellenar
            placeholder="Email"
            /*
              INPUT CONTROLADO: value viene del estado, y cada tecla
              llama a onChange, que actualiza el estado. React manda.
            */
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            disabled={isSubmitting}
            // Accesibilidad: avisa que el campo es inválido y dónde está el porqué
            aria-invalid={Boolean(emailError)}
            aria-describedby={emailError ? `${emailId}-error` : undefined}
          />
          <MailIcon width={20} height={20} className={styles.inputIcon} />
        </div>
        {/* {condición && <algo />} = "si la condición es true, dibuja <algo />" */}
        {emailError && (
          <p id={`${emailId}-error`} className={styles.fieldError}>
            {emailError}
          </p>
        )}
      </div>

      {/* ---------- Campo: contraseña ---------- */}
      <div className={styles.field}>
        <label htmlFor={passwordId} className={styles.srOnly}>
          Contraseña
        </label>
        <div className={styles.inputWrap} data-invalid={Boolean(passwordError)}>
          <input
            ref={passwordRef}
            id={passwordId}
            className={styles.input}
            type="password"
            autoComplete="current-password"
            placeholder="Contraseña"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
            disabled={isSubmitting}
            aria-invalid={Boolean(passwordError)}
            aria-describedby={passwordError ? `${passwordId}-error` : undefined}
          />
          <LockIcon width={20} height={20} className={styles.inputIcon} />
        </div>
        {passwordError && (
          <p id={`${passwordId}-error`} className={styles.fieldError}>
            {passwordError}
          </p>
        )}
      </div>

      {/*
        ---------- Olvidé mi contraseña ----------
        NO hay "Recordarme": en un panel de administrador la sesión
        nunca debe quedar abierta en el navegador. Si alguien usa
        la misma computadora, entraría directo como admin.
      */}
      <div className={styles.row}>
        {/* href="#" de momento: la pantalla de recuperación es un paso futuro */}
        <a href="#" className={styles.link}>
          ¿Olvidaste tu contraseña?
        </a>
      </div>

      {/* ---------- Botón ---------- */}
      <button type="submit" className={styles.submit} disabled={isSubmitting}>
        {/* Operador ternario: condición ? siTrue : siFalse */}
        {isSubmitting ? <span className={styles.spinner} aria-label="Verificando" /> : 'Entrar'}
      </button>

      {/*
        Pie del card: el nombre de la marca con la "I" de IA resaltada.
        En modo desarrollo, el mismo espacio muestra el aviso del atajo
        (así no agrega altura y no vuelve a aparecer el scroll).
      */}
      {DEV_OPEN_LOGIN ? (
        <p className={`${styles.footer} ${styles.devHint}`}>Modo desarrollo · entra sin datos</p>
      ) : (
        <p className={styles.footer}>
          MULT<span className={styles.footerHighlight}>I</span>AZ · predicción con IA
        </p>
      )}
    </form>
  );
}
