/*
 * ============================================================
 *  CONTEXTO DE AUTENTICACIÓN
 * ============================================================
 *  PROBLEMA: con el router, el usuario logueado lo necesitan
 *  muchos componentes en distintos niveles (el guardia de rutas,
 *  el login, el encabezado, el botón de cerrar sesión...).
 *  Pasarlo por props de padre a hijo a nieto ("prop drilling")
 *  se vuelve inmanejable.
 *
 *  SOLUCIÓN: CONTEXT. Es como una "antena": el AuthProvider
 *  transmite el usuario y cualquier componente de adentro lo
 *  recibe con useAuth(), sin importar qué tan profundo esté.
 *
 *  Este archivo es .ts (no .tsx) porque no tiene JSX: solo el
 *  contexto, sus tipos y el hook. El componente AuthProvider
 *  vive en AuthProvider.tsx (React Fast Refresh funciona mejor
 *  si un archivo .tsx solo exporta componentes).
 * ============================================================
 */

import { createContext, useContext } from "react";
import type { SessionUser } from "./services/authService";

/** Lo que el contexto ofrece a quien lo use */
export interface AuthContextValue {

    user: SessionUser | null;

    /** Guarda el usuario después de un login correcto */
    signIn: (user: SessionUser) => void;

    /** Cierra la sesión */
    signOut: () => void;

    
}

/*
* createContext(valorPorDefecto). Usamos null como "no hay Provider":
* si alguien usa useAuth() fuera del AuthProvider, avisamos con un error claro.
*/
export const AuthContext = createContext<AuthContextValue | null>(null);

/** Hook para leer la sesión desde cualquier componente */
export function useAuth(): AuthContextValue {
    const value = useContext(AuthContext);

    // Este error solo lo verías si olvidas envolver la app con <AuthProvider>
    if (!value) {
        throw new Error('useAuth() debe usarse dentro de <AuthProvider>');
    }

    return value;
}
