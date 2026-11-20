/*
 * ============================================================
 *  LOGIN PAGE — la "escena"
 * ============================================================
 *  La página es una pared de ladrillos con un foco arriba.
 *  Secuencia de la animación (todo en CSS, ver el .module.css):
 *    1. La pared empieza a oscuras.
 *    2. El foco se ENCIENDE POCO A POCO, como si alguien
 *       subiera un regulador de luz (~2.6 s). Da misterio.
 *    3. Con la luz ya casi completa, el card "sale" de la pared:
 *       estaba invisible y aparece lentamente (~1.6 s).
 *
 *  Esta página solo ARMA la escena. La lógica del formulario
 *  está en LoginForm.
 * ============================================================
 */

import { Navigate, useLocation, useNavigate } from "react-router";
import { useAuth } from "../authContext";
import type { SessionUser } from "../services/authService";
import styles from './LoginPage.module.css';
import { LoginForm } from "../components/LoginForm";

/*
 * Forma del "state" que nos deja RequireAuth al redirigir aquí.
 * Puede no existir (si entraste directo a /login), por eso el "?".
 */

interface LocationState {
    from?: string;
}

export function LoginPage() {

    const { user, signIn } = useAuth();

    // useNavigate: devuelve una función para navegar desde código (no con un link)
    const navigate = useNavigate();
    const location = useLocation();

    // "as": le decimos a TypeScript qué forma tiene (el router lo guarda como unknown)
    const from = (location.state as LocationState | null)?.from ?? '/';

    // Si ya hay sesión, no tiene sentido ver el login: directo al panel
    if (user) {
        return <Navigate to={from} replace/>
    }

    function handleLogin(loggedUser: SessionUser) {
        signIn(loggedUser);

        navigate(from, {replace: true});
    } 

    return (
        <div className={styles.scene}>
          {/*
            Capas decorativas. aria-hidden="true": los lectores de pantalla
            las ignoran, no aportan información.
            El ORDEN importa: en HTML, lo que va después se pinta encima.
          */}
          <div className={styles.darkness} aria-hidden="true" />
          <div className={styles.glow} aria-hidden="true" />
          <div className={styles.beam} aria-hidden="true" />
    
          {/* El foco: soporte a la pared, carcasa metálica y difusor que se ilumina */}
          <div className={styles.lamp} aria-hidden="true">
            <div className={styles.lampMount} />
            <div className={styles.lampBody} />
            <div className={styles.lampDiffuser} />
          </div>
    
          {/* <main> = contenido principal de la página. Aquí vive el card. */}
          <main className={styles.card}>
            {/* El formulario solo avisa "entró este usuario"; la página decide qué hacer */}
            <LoginForm onSuccess={handleLogin} />
          </main>
        </div>
      );    

}