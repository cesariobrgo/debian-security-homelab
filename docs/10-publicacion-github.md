# 10 · Publicación y mantenimiento seguro de GitHub

## Estado actual

El repositorio `cesariobrgo/debian-security-homelab` se creó como **público**. Por eso los documentos publicados son plantillas anonimizadas y no deben incluir capturas de administración ni registros originales.

## Alternativa: crear un repositorio privado vacío

1. En GitHub, **New repository**.
2. Nombre: `debian-security-homelab`.
3. Visibilidad: **Private**.
4. Evitar inicializarlo con README si vas a subir el contenido mediante `git push` a una rama vacía.
5. Descomprimir el ZIP recibido y revisar el contenido antes de publicar.

Luego, en el directorio descomprimido:

```bash
git init
git add .
git commit -m "docs: documentar homelab Debian y DNS/VPN"
git branch -M main
git remote add origin git@github.com:<GITHUB_USER>/debian-security-homelab.git
git push -u origin main
```

Para usar SSH con GitHub se requiere haber configurado una clave de GitHub propia; alternativa: GitHub Desktop o HTTPS con credenciales modernas. **No incluir tokens en scripts o comandos compartidos.**

Si se utiliza una integración de ChatGPT con acceso de escritura a ese repositorio, los documentos también pueden subirse directamente después de que exista y sea visible para la integración.

## Revisión previa para publicación pública

- No incluir IP pública, IP Tailscale concreta o nombres internos identificables.
- No incluir URL de autenticación Tailscale, claves, secretos, hashes de contraseñas, cookies ni archivos de configuración completos.
- No incluir logs brutos: pueden revelar hábitos de navegación y dominios de trabajo.
- Revisar `git log` y el historial: el historial publicado también contiene versiones antiguas.
- Mantener `.gitignore`, pero recordar que `.gitignore` no protege archivos ya rastreados.

## Cómo mantener la documentación

Tras cada cambio real, actualizar `README.md` (estado), documento técnico pertinente y la tabla de incidencias; separar siempre **confirmado**, **inferido** y **pendiente**.