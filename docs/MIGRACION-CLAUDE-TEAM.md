# Migración — Kraibe Website → Claude Team

> Guía completa para migrar el proyecto kraibe-website a una cuenta Claude for Teams
> sin perder stack, connectors ni contexto de proyecto.
>
> **Última consolidación:** 2026-08-10
> **Mantenedor:** Gabriel Kraemer · gkraemer@kraibe.cl
> **Convención:** `[CONFIRMAR]` = dato ambiguo que Gabriel debe validar.

---

## 1. Qué viaja con el repo (automático)

| Archivo | Función |
|---------|---------|
| `.github/workflows/deploy-vps.yml` | Deploy automático via SSH al VPS Hostinger |
| `CLAUDE.md` | Contexto del proyecto para agentes |

> En cuanto la cuenta de empresa tenga acceso al repo, estos archivos cargan solos.

---

## 2. Qué se recrea a mano (por cuenta)

### 2.1 Plan y seat

- Plan **Claude for Teams** con seat que incluya Claude Code.
- Seats: https://support.claude.com/en/articles/11845131

### 2.2 Conectar GitHub

- Autorizar la **GitHub App de Claude** (onboarding web) o correr `/web-setup`.
- La cuenta de GitHub debe ver `kraibe-solutions/website`.

### 2.3 Environment de Claude Code en la web

Configurar en la UI (ícono de nube → editar environment):
- **Network access → `Full`** (necesario para OAuth del MCP de GitHub y navegación externa).
- Variables de entorno y setup script según necesidad.
- No hay bóveda de secretos: cualquier secreto va como env var.

### 2.4 Re-autorizar connectors (OAuth por cuenta)

| Connector | Connector |
|-----------|-----------|
| GitHub | Google Drive |
| Supabase | Gmail |
| Vercel | Google Calendar |
| Slack | Microsoft (Outlook/SharePoint) |
| Canva | Cloudflare |
| DocuSign | Clarify |

> En **Team**, el admin puede configurar connectors a nivel organización desde
> `claude.ai/admin-settings`, así todos los seats los reciben sin reconectarlos uno por uno.

---

## 3. Gotchas de Team (administración)

1. **`managed-mcp.json`** — si el admin lo despliega con control exclusivo, puede bloquear servers del repo. Solución: `"allowAllClaudeAiMcps": true` en managed settings.
2. **`allowManagedMcpServersOnly: true`** — el `.mcp.json` del repo no carga salvo que esté en el allowlist gestionado.
3. Si **no** activan políticas de MCP gestionado (lo común en un Team chico), no hay nada que hacer.

Referencia: https://code.claude.com/docs/en/managed-mcp

---

## 4. Contexto de proyecto (base de conocimiento)

### 4.1 Empresa

**Inversiones Kraibe SpA** — RUT 78.249.497-K — Concepción, Chile.
- **SE Kraibe** (RUT 78.254.946-4) — Seguridad electrónica + SOC 24/7.
- **Kraibe Solutions** — Software B2B (Kraibe OS, Kraibe Residentes, Kraibe Audit).

### 4.2 Clientes reales verificados (únicos para uso público)

| Cliente | Servicio | Resultado |
|---------|----------|-----------|
| Rozto | ERP/software + seguridad con IA | Visibilidad total de costo por producto |
| Footline | Dashboard EERR multi-centro kinesiología | Reemplazó flujos en Excel |
| Condominio Vía del Río Villuco | Conserjería remota + monitoreo | Reducción significativa de costo |

### 4.3 Reglas de negocio inamovibles

- Kraibe = holding con 2 unidades. kraibe.cl representa al holding completo.
- Instagram @sekraibe = SOLO SE Kraibe.
- Toda decisión de marca pasa por aprobación de Gabriel Kraemer.
- Propuestas siempre mencionan Ley 21.659 e incluyen números (99.9% disponibilidad, <60s respuesta).
- Casos de cliente reales son el diferenciador — no inventar métricas ni clientes.

### 4.4 Paleta de marca (NO negociable)

| Color | HEX | Uso |
|-------|-----|-----|
| Azul oscuro / Navy | #0D364A | Primario, headers |
| Turquesa / Teal | #33AEB3 | Acentos, CTAs |
| Verde lima / Lime | #CFEE9E | Highlights (máx 1 por sección) |
| Blanco hueso | #FFFBFA | Fondo |

**Tipografía:** Títulos Trebuchet MS — Cuerpo Calibri.

### 4.5 Tone of voice

Directo, profesional, sin relleno. Habla de números.
- ✅ "Monitoreo 24/7 + control de acceso. 99.9% disponibilidad, <60s respuesta."
- ❌ "Soluciones integrales de seguridad electrónica."

Palabras prohibidas: "soluciones integrales", "transformación digital", "ecosistema", "sinergia", "disruptivo".

### 4.6 Contacto

| Campo | Valor |
|-------|-------|
| Contacto principal | Gabriel Kraemer · gkraemer@kraibe.cl · +56 9 5171 5595 |
| Dominio / correo | kraibe.cl (Microsoft 365) |
| Dirección | `[CONFIRMAR]` — hay versiones conflictivas en docs anteriores |

### 4.7 Backlog del sitio web

1. Agregar más páginas de contenido/artículos SEO.
2. Reemplazar mockups por screenshots reales de Kraibe OS y App Residentes.
3. Formulario de contacto/cotización.
4. Páginas legales: `/privacidad`, `/terminos`.
5. Cookie banner.

### 4.8 Deuda técnica

- n8n en `localhost` — falta endpoint de producción.
- Secretos pendientes de rotar: password Supabase y `ABACUSAI_API_KEY`.

---

## 5. Información pendiente de confirmar

1. **Dirección de la empresa** — 3 versiones en docs anteriores. `[CONFIRMAR]` cuál es la vigente.
2. **URL de producción de n8n** y estado real del pipeline SOC.
3. **Decisión final de correo transaccional:** Azure AD OAuth vs. Resend vs. SMTP.
4. **Screenshots reales** de Kraibe OS y App Residentes.

---

## Resumen en una línea

**Deploy workflow ya está salvado** (en el repo). Lo que se migra a mano es:
*seat → conectar GitHub → environment (red Full + vars) → reconectar connectors (o vía admin)*.
