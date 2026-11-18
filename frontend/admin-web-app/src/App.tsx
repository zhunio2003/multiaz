/**
  * APP — el componente raíz.
  * Por ahora está vacío: las pantallas (y las rutas) llegan en los
  * próximos commits.
  * ============================================================
  *  APP — el componente raíz: aquí se definen las RUTAS
  * ============================================================
  *  Con react-router, la URL decide qué pantalla se ve:
  *
  *    /login            → LoginPage (pública)
  *    cualquier otra    → 404
  *
  *  El panel (/) y sus módulos se agregan en los próximos commits.
  *  La sesión NO vive aquí: está en AuthProvider (ver main.tsx).
  * ============================================================
*/

import { createBrowserRouter, RouterProvider } from "react-router";
import { NotFoundPage, RouteErrorPage } from "./core/pages/NotFoundPage.module";

const router  = createBrowserRouter([
  {
    path: '/login',
    element: <LoginPage />,
    errorElement: <RouteErrorPage />
  },
  {
    // "*" = cualquier URL que no coincidió con nada de arriba
    path: '*',
    element: <NotFoundPage />
  },
]);

export default function App() {
  return <RouterProvider router={router} />;
}