/*
 * PUNTO DE ENTRADA de la app (lo carga index.html).
 * Su único trabajo: montar <App /> dentro del <div id="root">.
*/
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'

// Estilos globales: tokens + reset. Se importan UNA vez aquí y aplican a todo.
import './core/theme/global.css'
import App from './App.tsx'
import { AuthProvider } from './features/auth/AuthProvider.tsx';

/*
 * document.getElementById('root') puede devolver null (si el div no
 * existiera). El "!" le dice a TypeScript: "confía, sí existe".
 *
 * StrictMode: solo en desarrollo, ejecuta ciertas cosas DOS veces
 * a propósito para detectar bugs. En producción no hace nada.
*/
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <AuthProvider>
      <App />
    </AuthProvider>
  </StrictMode>,

);
