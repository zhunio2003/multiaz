/*
 * ============================================================
 *  LOGO (versión DEMO)
 * ============================================================
 *  Dibujado a mano en SVG imitando el logo de docs/brand/.
 *  Cuando tengas tu logo final, solo cambias ESTE archivo
 *  y se actualiza en toda la app. Por eso es un componente.
 *
 *  Para usar una imagen (.png / .svg) en vez de este dibujo:
 *    1. Copia tu archivo a  src/assets/logo.svg
 *    2. Arriba:  import logoUrl from '../../assets/logo.svg';
 *    3. Cambia el <svg> por:  <img src={logoUrl} alt="" width={size} />
 * ============================================================
 */

import styles from './Logo.module.css';

/*
 * "Props" = los parámetros que recibe un componente.
 * Con TypeScript describimos su forma en una interface.
 * El "?" significa OPCIONAL: quien use <Logo /> puede no pasarlo.
 */
interface LogoProps {
  /** Ancho del ícono en píxeles */
  size?: number;
  /** Si es true, muestra el texto "MULTIAZ" al lado del ícono */
  withWordmark?: boolean;
}

/*
 * Destructuring con valores por defecto:
 * si no pasan size, vale 40; si no pasan withWordmark, vale true.
 */
export function Logo({ size = 40, withWordmark = true }: LogoProps) {
  return (
    <span className={styles.logo}>
      {/*
        viewBox="0 0 64 48" = el "lienzo" interno del dibujo mide 64x48.
        width/height lo escalan al tamaño real sin perder calidad
        (es vectorial, nunca se pixela).

        aria-hidden: el dibujo es decorativo. El nombre de la marca
        ya lo lee el lector de pantalla en el texto de al lado.
      */}
      <svg
        className={styles.mark}
        width={size}
        height={(size * 48) / 64}
        viewBox="0 0 64 48"
        aria-hidden="true"
      >
        {/* stroke = color de la línea. "currentColor" = usa el "color" del CSS */}
        <g
          fill="none"
          stroke="currentColor"
          strokeWidth="3"
          strokeLinecap="round"
          strokeLinejoin="round"
        >
          {/*
            pathLength={1}: "trata el largo de esta línea como 1".
            No cambia cómo se ve, pero permite animar el trazo desde
            CSS sin saber cuánto mide de verdad (lo usa el login).
          */}
          {/* Línea recta con quiebres: los "datos" */}
          <polyline points="6,40 21,14 37,36 58,6" pathLength={1} />
          {/* Curva suave: la "predicción" que ajusta los datos */}
          <path d="M6 40 Q20 22 29 28 T58 6" pathLength={1} />
        </g>
        {/* Nodos: rellenos en los extremos, huecos en el medio (como el logo original) */}
        <circle cx="6" cy="40" r="5" fill="currentColor" />
        <circle cx="21" cy="14" r="3.5" className={styles.hollow} />
        <circle cx="37" cy="36" r="3.5" className={styles.hollow} />
        <circle cx="58" cy="6" r="5.5" fill="currentColor" />
      </svg>

      {/*
        En JSX, {condición && <algo />} significa:
        "si la condición es true, dibuja <algo />; si no, nada".
      */}
      {withWordmark && (
        <span className={styles.wordmark}>
          MULT<span className={styles.highlight}>I</span>AZ
        </span>
      )}
    </span>
  );
}
