/*
 * ============================================================
 *  AUTH PROVIDER — el que "transmite" la sesión
 * ============================================================
 *  Envuelve toda la app (en main.tsx). Guarda el usuario en
 *  useState y lo comparte a través del AuthContext.
 * ============================================================
 */
import { useMemo, useState, type ReactNode } from "react";
import type { SessionUser } from "./services/authService";
import { AuthContext, type AuthContextValue } from "./authContext";

export function AuthProvider({ children }: { children: ReactNode }) {

    // null = nadie ha iniciado sesión (la app siempre arranca en el login)
    const [user, setUser] = useState<SessionUser | null>(null);

    /*
   * useMemo: el objeto "value" se crea de nuevo SOLO si cambia user.
   * Sin esto, cada render crearía un objeto nuevo y TODOS los
   * componentes que usan useAuth() se volverían a dibujar sin motivo.
   *
   * NOTA: por ahora la sesión vive solo en memoria (si recargas la
   * página, se pierde y vuelves al login). Cuando conectemos el backend (TS-17.5)
   * guardaremos los tokens y la recuperaremos al recargar.
   */
    const value = useMemo<AuthContextValue>(
        () => ({
            user,
            signIn: setUser,
            signOut: () => setUser(null),
        }),
        [user],
    );

    // Todo lo que esté dentro de <AuthContext value={...}> puede usar useAuth()
    return <AuthContext value={value}>{children}</AuthContext>;
}