#!/bin/bash
# SessionStart hook — prepara Chromium para el MCP de Playwright.
#
# El entorno de Claude Code en la web trae navegadores Playwright preinstalados
# en /opt/pw-browsers, pero el número de build (ej. chromium-1194) cambia cuando
# se actualiza la imagen base. Para no hardcodear esa ruta en .mcp.json, este
# hook resuelve el binario dinámicamente y crea un symlink en una ruta estable
# (~/.cache/playwright-mcp/chrome) a la que apunta .mcp.json.
#
# Ventaja: no descarga nada (cdn.playwright.dev está fuera de la allowlist en el
# nivel de red "Trusted"), así que funciona con cualquier nivel de red.
set -euo pipefail

DEST="$HOME/.cache/playwright-mcp"
mkdir -p "$DEST/output"

# Build más reciente de Chromium preinstalado (orden por versión).
CHROME="$(ls -d /opt/pw-browsers/chromium-*/chrome-linux/chrome 2>/dev/null | sort -V | tail -n1 || true)"

if [ -n "${CHROME:-}" ] && [ -x "$CHROME" ]; then
  ln -sf "$CHROME" "$DEST/chrome"
  echo "[playwright-mcp] Chromium listo: $CHROME -> $DEST/chrome"
else
  echo "[playwright-mcp] AVISO: no hay Chromium preinstalado en /opt/pw-browsers." >&2
  echo "[playwright-mcp] Con red 'Full' puedes instalarlo con: npx playwright install chromium" >&2
fi
