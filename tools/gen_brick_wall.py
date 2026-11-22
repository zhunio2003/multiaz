"""
Genera src/assets/brick-wall.svg — la pared de ladrillos del login.

Uso (desde la carpeta multiaz/):
    python3 tools/gen_brick_wall.py src/assets/brick-wall.svg

Para cambiar el color de los ladrillos, edita la lista `palette`.
"""
import random, sys

random.seed(7)  # misma semilla = mismo resultado siempre
W, ROW, ROWS = 360, 64, 6        # azulejo 360 x 384
BRICK_W, BRICK_H, GAP = 174, 56, 6
H = ROW * ROWS
palette = ['#2a2a2b', '#2f2e2e', '#262627', '#333233', '#2c2b2b', '#232324', '#302f30', '#373636', '#29292a', '#2d2c2c']

bricks = []
for r in range(ROWS):
    offset = (r % 2) * (W // 4)  # filas alternas desplazadas medio ladrillo
    y = r * ROW + GAP / 2
    wrap_color = random.choice(palette)
    xs = [offset - W // 2, offset, offset + W // 2]
    for i, x in enumerate(xs):
        # El primero y el último son el MISMO ladrillo partido por el borde del azulejo:
        # deben tener el mismo color para que no se note la unión al repetirse.
        color = wrap_color if i in (0, 2) else random.choice(palette)
        bricks.append((x + GAP / 2, y, color))

rects = '\n'.join(
    f'    <rect x="{x:.0f}" y="{y:.0f}" width="{BRICK_W}" height="{BRICK_H}" rx="3" fill="{c}"/>'
    for x, y, c in bricks
)
bevels = '\n'.join(
    f'    <rect x="{x:.0f}" y="{y:.0f}" width="{BRICK_W}" height="{BRICK_H}" rx="3"/>'
    for x, y, c in bricks
)

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
  <!--
    PARED DE LADRILLOS (azulejo que se repite con background-repeat).
    Es un ARCHIVO DE IMAGEN, no código de la app: puedes copiarlo tal cual.
    Ladrillo gris casi negro (combina con el dashboard). Lo que lo hace "realista" en vez de "Lego":
      1. Colores distintos en cada ladrillo.
      2. #grain: textura granulada + manchas (feTurbulence = ruido aleatorio).
      3. #rough: bordes un poco irregulares (feDisplacementMap deforma la forma).
      4. Relieve: luz arriba y sombra abajo en cada ladrillo (#bevel).
      5. Mortero (la mezcla) con su propia textura.
  -->
  <defs>
    <filter id="mortar" x="0" y="0" width="100%" height="100%">
      <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" stitchTiles="stitch"/>
      <feColorMatrix values="0 0 0 0 0.11  0 0 0 0 0.11  0 0 0 0 0.11  0 0 0 0.7 0"/>
      <feComposite in2="SourceGraphic" operator="in"/>
      <feBlend in2="SourceGraphic" mode="normal"/>
    </filter>

    <filter id="rough" x="-5%" y="-5%" width="110%" height="110%">
      <feTurbulence type="fractalNoise" baseFrequency="0.12" numOctaves="2" stitchTiles="stitch" result="warp"/>
      <feDisplacementMap in="SourceGraphic" in2="warp" scale="3" xChannelSelector="R" yChannelSelector="G"/>
    </filter>

    <filter id="grain" x="0" y="0" width="100%" height="100%">
      <!-- Granos finos -->
      <feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="3" stitchTiles="stitch" result="fine"/>
      <feColorMatrix in="fine" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 -1.1 0.62" result="fineDark"/>
      <!-- Manchas grandes (zonas más oscuras dentro del ladrillo) -->
      <feTurbulence type="fractalNoise" baseFrequency="0.035" numOctaves="2" seed="3" stitchTiles="stitch" result="blot"/>
      <feColorMatrix in="blot" values="0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 -1.2 0.55" result="blotDark"/>
      <feMerge result="dirt"><feMergeNode in="fineDark"/><feMergeNode in="blotDark"/></feMerge>
      <!-- Solo dentro de los ladrillos -->
      <feComposite in="dirt" in2="SourceAlpha" operator="in" result="dirtIn"/>
      <feMerge><feMergeNode in="SourceGraphic"/><feMergeNode in="dirtIn"/></feMerge>
    </filter>

    <linearGradient id="bevel" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#fff" stop-opacity="0.16"/>
      <stop offset="0.12" stop-color="#fff" stop-opacity="0.03"/>
      <stop offset="0.8" stop-color="#000" stop-opacity="0.05"/>
      <stop offset="1" stop-color="#000" stop-opacity="0.35"/>
    </linearGradient>
  </defs>

  <!-- Mortero -->
  <rect width="{W}" height="{H}" fill="#121212" filter="url(#mortar)"/>

  <!-- Ladrillos con textura y bordes irregulares -->
  <g filter="url(#rough)">
    <g filter="url(#grain)">
{rects}
    </g>
  </g>

  <!-- Relieve de cada ladrillo -->
  <g fill="url(#bevel)">
{bevels}
  </g>
</svg>
'''
open(sys.argv[1], 'w').write(svg)
print('ok', len(bricks), 'bricks')