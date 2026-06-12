# Migración del stack de Claude Code a la cuenta de empresa (Claude Team)

> Guía para migrar de una cuenta personal de Claude a la cuenta de **Claude for Teams**
> de la empresa **sin perder el stack actual** (MCPs, connectors, configuración del entorno).
>
> Esta guía vive en el repo a propósito: así sobrevive al cambio de cuenta y queda
> accesible desde la cuenta nueva.

---

## Concepto clave: el stack vive en DOS capas

| Capa | Qué incluye | ¿Se migra sola? |
|------|-------------|-----------------|
| **A. En el repo (git)** | `.mcp.json` (Playwright + GitHub MCP), `.claude/settings.json`, `.claude/hooks/session-start.sh`, `CLAUDE.md` | ✅ **Sí, automático.** Viaja con el repo. La cuenta nueva solo necesita acceso al repo. |
| **B. Atada a la cuenta / entorno** | Los **connectors** OAuth, el **nivel de red**, variables de entorno y setup scripts del *environment* | ❌ **No.** Hay que **recrearlo** a mano en la cuenta de empresa. |

La Capa A ya está resuelta (commiteada). Lo que hay que rehacer es la **Capa B**.

---

## Lo que YA está salvado en el repo (Capa A)

| Archivo | Función |
|---------|---------|
| `.mcp.json` → server `playwright` | Playwright MCP headless apuntando al Chromium preinstalado vía symlink estable. Caps: `testing,devtools`. |
| `.mcp.json` → server `github` | Servidor MCP remoto de GitHub (`https://api.githubcopilot.com/mcp/`, HTTP). Autenticación **OAuth por usuario** — sin token en el repo. |
| `.claude/hooks/session-start.sh` | Resuelve dinámicamente el build de Chromium en `/opt/pw-browsers` y crea el symlink que usa `.mcp.json`. Sin descargas. |
| `.claude/settings.json` | Registra el hook `SessionStart`. |

> En cuanto la cuenta de empresa tenga acceso a `kraibe-solutions/website`,
> estos servidores cargan solos en cada sesión cloud (solo hay que **aprobarlos**
> la primera vez — ver paso 5).

---

## Checklist de migración a Claude Team

### 1. Plan y asiento (seat)
- La empresa necesita plan **Claude for Teams** y que el admin asigne un **seat con Claude Code**.
- Claude Code en la web requiere cuenta Claude.ai con seat (no basta una API key de Console).
- Seats: https://support.claude.com/en/articles/11845131

### 2. Conectar GitHub (para que el repo sea alcanzable)
- En la cuenta de empresa: autorizar la **GitHub App de Claude** (onboarding web) o correr `/web-setup` desde la terminal.
- El acceso al repo depende de que esa cuenta de GitHub vea `kraibe-solutions/website`.

### 3. Recrear el *environment* de Claude Code en la web
No está en el repo; se rearma en la UI (ícono de nube → editar environment):
- **Network access → `Full`** (necesario para navegar competencia/proveedores y llenar formularios externos, y para el OAuth del MCP de GitHub). Es por-environment, no se hereda.
- **Variables de entorno** y **setup script**, si los tenías.
- ⚠️ No hay bóveda de secretos: cualquier secreto va como env var, visible para quien edite el environment.

### 4. Re-habilitar y RE-AUTORIZAR los connectors (OAuth, por cuenta)
Cada connector se reconecta por OAuth bajo la cuenta nueva. Inventario de lo que había activo:

| Connector | Connector |
|-----------|-----------|
| GitHub | Google Drive |
| Supabase | Gmail |
| Vercel | Google Calendar |
| Slack | Microsoft (Outlook/SharePoint) |
| Canva | Cloudflare *(requería auth)* |
| DocuSign | Clarify *(requería auth)* |

> En **Team**, el **admin puede configurar connectors a nivel organización** desde
> el admin console (`claude.ai/admin-settings`), así todos los seats los reciben
> sin reconectarlos uno por uno.

### 5. Aprobar los MCP de proyecto
- La primera sesión cloud mostrará `playwright` y `github` (del `.mcp.json`) como **"Pending approval"** → se aprueban una vez.
- El de `github` además pedirá **OAuth** la primera vez que se use.

---

## Sobre el MCP de GitHub (server `github` en `.mcp.json`)

- Es el **servidor MCP remoto oficial** de GitHub: `https://api.githubcopilot.com/mcp/` (transporte HTTP).
- **Autenticación OAuth por usuario** → no hay tokens en el repo; cada persona se autentica como sí misma.
- **Portable**: viaja con el repo, también funciona desde la terminal (no solo en la web).
- **Requisitos**: nivel de red **Full** (o tener `api.githubcopilot.com` en el allowlist) + aprobar el server la primera vez.
- **Nota sobre la web**: Claude Code en la web ya trae una integración de GitHub nativa (proxy con credencial scoped). Este server del `.mcp.json` se suma para que la integración sea **portable y explícita**; es especialmente útil fuera de la web (terminal / cuenta de empresa). Si en una sesión web te resulta redundante, puedes desactivar uno de los dos.

---

## ⚠️ Gotchas propios de Team (administración)

1. **Si el admin despliega `managed-mcp.json`** (control exclusivo de MCP), eso
   **suprime los connectors de claude.ai y puede bloquear los servers del repo**
   (`playwright`, `github`). Soluciones:
   - Añadir `"allowAllClaudeAiMcps": true` en managed settings para no perder los connectors.
   - Incluir los servers del repo en el allowlist:
     - `github` por `serverUrl`: `{ "serverUrl": "https://api.githubcopilot.com/*" }`
     - `playwright` por `serverCommand` (match **exacto**, argumento por argumento).
2. **Si usan `allowManagedMcpServersOnly: true`**, el `.mcp.json` del repo no carga
   salvo que esté en el allowlist gestionado. Coordinar con quien administre.
3. Si **no** activan políticas de MCP gestionado (lo común en un Team chico), no hay
   nada que hacer: el `.mcp.json` del repo carga y el usuario solo aprueba.

Referencia: https://code.claude.com/docs/en/managed-mcp

---

## Resumen en una línea

**Playwright + GitHub MCP + hook ya están salvados** (en el repo). Lo que se migra a mano es:
*seat → conectar GitHub → environment (red Full + vars) → reconectar connectors (o vía admin) → aprobar los MCP*.
Siguiendo esta lista, nada del stack se pierde.
