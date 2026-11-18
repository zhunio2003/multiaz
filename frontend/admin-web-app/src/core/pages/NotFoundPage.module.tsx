/*
 * ============================================================
 *  NOT FOUND (404) y ERROR DE RUTA
 * ============================================================
 *  - NotFoundPage: la URL no coincide con ninguna ruta (ej: /hola).
 *  - RouteErrorPage: algo EXPLOTÓ al dibujar una página (un bug).
 *    El router la muestra en vez de dejar la pantalla en blanco.
 *
 *  Comparten diseño, así que usan el mismo componente base.
 * ============================================================
 */
import { isRouteErrorResponse, Link, useRouteError } from "react-router";
import { Logo } from "../components/Logo";

 

interface StatusScreenProps {
  code: string;
  title: string;
  message: string;
}

function StatusScreen({code, title, message}: StatusScreenProps) {

  return (
    <main className="{styles.screen}">
      <Logo size={40}/>
      <p className="{styles.code}">{code}</p>
      <h1 className="{styles.title}">{title}</h1>
      <p className="{styles.message}">{message}</p>
      <Link to="/" className="{styles.button}">
        IR AL INICIO
      </Link>
    </main>
  );
}

export function NotFoundPage() {
  return (
    <StatusScreen
      code="404"
      title="This page does not exist"
      message="Check the address or return to the top of the panel."
    />  
  );

}

export function RouteErrorPage() {

  // useRouteError: el error que ocurrió (solo funciona en un errorElement)
  const error = useRouteError();

  // ¿Es una respuesta HTTP del router (ej: 404) o un error de codigo?
  if (isRouteErrorResponse(error) && error.status === 404) {
    return <NotFoundPage />;
  }

  /*
   * En desarrollo mostramos el mensaje técnico para depurar.
   * En producción NO (no se exponen detalles internos al usuario).
   */
  const detail = import.meta.env.DEV && error instanceof Error ? error.message : undefined;
  
  
  return (
    <StatusScreen
      code="Error"
      title="Something went wrong"
      message={detail ?? 'An unexpected problem occurred. Please try reloading the page.'}
    />

  ); 

}
