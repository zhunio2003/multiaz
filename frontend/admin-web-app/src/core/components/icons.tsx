/*
 * ============================================================
 *  ÍCONOS (SVG en línea)
 * ============================================================
 *  Dibujamos los íconos a mano en vez de instalar una librería:
 *  son pocos y así no sumamos dependencias. Menos dependencias
 *  = menos riesgo de un ataque a la cadena de suministro (ADR-006).
 *
 *  Todos usan stroke="currentColor": toman el color del texto que
 *  los rodea. Si el padre tiene color: verde, el ícono es verde.
 * ============================================================
 */

/*
 * ComponentProps<'svg'> = "todas las props que acepta un <svg> normal".
 * Así quien use <MailIcon className="x" /> puede pasar cualquier
 * atributo de SVG y TypeScript lo valida.
 */
import type { ComponentProps } from 'react';

type IconProps = ComponentProps<'svg'>;

/*
 * Props comunes a todos los íconos. "...props" (spread) copia aquí
 * lo que el usuario pase, y puede sobrescribir estos valores.
 * aria-hidden: son decorativos; el texto de al lado da el significado.
 */
function baseProps(props: IconProps): IconProps {
  return {
    width: 18,
    height: 18,
    viewBox: '0 0 24 24',
    fill: 'none',
    stroke: 'currentColor',
    strokeWidth: 1.8,
    strokeLinecap: 'round',
    strokeLinejoin: 'round',
    'aria-hidden': true,
    ...props,
  };
}

export function MailIcon(props: IconProps) {
  return (
    <svg {...baseProps(props)}>
      <rect x="3" y="5" width="18" height="14" rx="2" />
      <path d="m3 7 9 6 9-6" />
    </svg>
  );
}

export function LockIcon(props: IconProps) {
  return (
    <svg {...baseProps(props)}>
      <rect x="4" y="10" width="16" height="11" rx="2" />
      <path d="M8 10V7a4 4 0 0 1 8 0v3" />
    </svg>
  );
}

export function AlertIcon(props: IconProps) {
  return (
    <svg {...baseProps(props)}>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 8v5" />
      <path d="M12 16.5v.01" />
    </svg>
  );
}

export function CheckIcon(props: IconProps) {
  return (
    <svg {...baseProps(props)}>
      <path d="m5 12 5 5 9-10" />
    </svg>
  );
}
