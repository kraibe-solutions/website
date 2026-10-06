# CLAUDE.md — Kraibe Website

Actualizado: 2026-08-10

## Qué es este proyecto

Sitio web corporativo de Kraibe — kraibe.cl
HTML/CSS/JS estático servido por nginx en VPS Hostinger.

**Empresa:** Inversiones Kraibe SpA — RUT 78.249.497-K
**Unidad operativa:** SE Kraibe SpA — RUT 78.254.946-4

---

## Stack técnico

| Capa | Tecnología |
|------|-----------|
| Tipo | HTML/CSS/JS estático — sin framework, sin build step |
| Deploy | GitHub Actions → SSH → `git pull` en VPS Hostinger (187.77.248.142) |
| Servidor | nginx en VPS |
| HTTPS | Let's Encrypt (Certbot) |
| Dominio | kraibe.cl |

---

## Estructura

```
kraibe-website/
├── assets/              # Imágenes, logos (vacío por ahora)
├── docs/                # Documentación de proyecto y migración
├── .github/workflows/   # Deploy automático a VPS
├── articulo-cultura-seguridad.html   # Artículo SEO publicado
└── CLAUDE.md
```

---

## Deploy

Push a `main` → GitHub Actions ejecuta `git pull origin main` en el VPS via SSH.

Secrets requeridos en GitHub:
- `VPS_HOST`
- `VPS_USER`
- `VPS_SSH_KEY`

---

## Paleta de marca

| Color | Hex | Uso |
|-------|-----|-----|
| Azul oscuro | #0D364A | Primario, headers |
| Turquesa | #33AEB3 | Acentos, CTAs |
| Verde lima | #CFEE9E | Highlights |
| Blanco hueso | #FFFBFA | Fondo |

**Tipografía:** Títulos Trebuchet MS — Cuerpo Calibri

---

## Lo que NO hacer

1. No agregar frameworks pesados (React, Vue) — es sitio estático intencional.
2. No commitear imágenes sin optimizar (max 200KB por imagen).
3. No romper compatibilidad mobile — responsive es obligatorio.
4. No modificar nginx config en VPS sin documentar.
5. No inventar clientes ni métricas — solo los 3 casos verificados (Rozto, Footline, Vía del Río Villuco).

---

## Contacto

- **Product Owner:** Gabriel Kraemer — gkraemer@kraibe.cl
