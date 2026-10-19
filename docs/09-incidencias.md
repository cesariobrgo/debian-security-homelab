# 09 · Incidencias y lecciones aprendidas

Registro basado en las pruebas relatadas en octubre de 2026. **No es una transcripción literal** de toda la consola.

| Incidencia | Señales | Resolución / estado | Aprendizaje |
| --- | --- | --- | --- |
| `openssh-server` sin candidato | `apt update` no traía catálogos | Repositorios Debian 13 configurados y línea de seguridad corregida | No desactivar GPG ni cambiar sources sin inspeccionar |
| Error 404 y fichero APT mal formado | Ruta de `trixie-security` incorrecta | Sustituida por ruta oficial de Debian Security | La ruta del repo es distinta a la principal |
| Ethernet sin IP | Solo loopback, sin DNS ni ruta | Cable físicamente desconectado | Comprobar capa 1 antes de modificar DHCP |
| AdGuard «Failed to fetch» en asistente | Panel web con fallos mientras el daemon estaba activo | Se consiguió entrar de nuevo y finalizar instalación | Validar servicio, API y puerto antes de reinstalar |
| `example.comdig` devuelve NXDOMAIN | Nombre mal tecleado en consultas repetidas | `example.com` devolvió `NOERROR` | Separar error de comando de avería del DNS |
| `grep: status: No existe el fichero` | Comandos pegados accidentalmente | Ejecución separada | Copiar comandos uno por uno y revisar el shell |
| Tailscale `up` reclama flags | `--accept-dns=false` ya configurado | Se usó `tailscale up --accept-dns=false` | Conservar preferencias existentes; `set` para cambios puntuales |
| DNS remoto no llegaba al Dell | AdGuard solo escuchaba en LAN | Se amplió a `*:53` y aparecieron consultas Pixel | Bind de servicios y rutas VPN son capas distintas |
| Spotify falla tras activar Exit Node | App dejó de funcionar en Pixel | **No resuelto / causa no demostrada** | Comparar rutas y DNS con y sin Exit Node |

## Registro de cambios

- **2026-10-11 a 2026-10-13:** inventario, Debian, optimización de energía, red, DNS y VPN Tailscale.
- **2026-10-13:** DNS remoto desde Pixel confirmado, prueba Exit Node con incidencia Spotify.
- **2026-10-19:** primera versión de documentación anonimizada y organización de pendientes.

No afirmar resolución de la incidencia Exit Node hasta repetir pruebas con conexión móvil y registro de resultados.