# CLAUDE.md — Kraibe Website
Actualizado: 2026-05-30

## ¿Qué es este proyecto?

Sitio web corporativo de Kraibe — kraibe.cl
Presenta los servicios de SE Kraibe (seguridad, conserjería remota) y Kraibe Solutions (ERP/software).

**Empresa:** Inversiones Kraibe SpA — RUT 78.249.497-K

---

## Stack técnico

| Capa | Tecnología |
|------|-----------|
| Tipo | HTML/CSS/JS estático |
| Estilos | CSS propio (carpeta css/) |
| Scripts | JS vanilla (carpeta js/) |
| Assets | Imágenes, logos (carpeta assets/) |
| Deploy | Hostinger VPS — nginx — kraibe.cl |
| HTTPS | Let's Encrypt (Certbot) |

---

## Estructura

```
kraibe-website/
├── assets/       # Imágenes, logos, iconos
├── css/          # Estilos
├── js/           # Scripts
└── index.html    # (si existe) — página principal
```

---

## Deploy

El sitio corre directamente en el VPS Hostinger (187.77.248.142) via nginx.
No tiene build step — los archivos se sirven estáticos.

```bash
# Deploy manual via SSH
scp -r . root@187.77.248.142:/var/www/kraibe.cl/

# O via git pull en el VPS
ssh root@187.77.248.142
cd /var/www/kraibe.cl
git pull origin main
```

---

## Paleta de marca Kraibe

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
4. No modificar nginx config directamente en VPS sin documentar.

---

## Contacto

- **Product Owner:** Gabriel Kraemer — gkraemer@kraibe.cl
- **Org GitHub:** github.com/kraibe-solutions/website
