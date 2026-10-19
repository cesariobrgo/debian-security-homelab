# Seguridad y divulgación de datos

Este repositorio es documentación de una red doméstica, **no** una distribución con parámetros seguros universales.

- No abrir DNS (53), panel AdGuard (8080) ni SSH (22) hacia Internet mediante port forwarding.
- Las conexiones por Tailscale requieren controles de identidad y permisos de la tailnet además de las ACL del servicio.
- No divulgar enlaces de inicio de sesión, autenticaciones, claves ni identificadores de proveedores DNS.
- Antes de publicar cualquier archivo de producción, eliminar secretos y validar el historial de Git.
- No aplicar recetas restrictivas de firewall sin rollback local y sin identificar los puertos/reenvíos reales.
- En caso de pérdida de DNS, restaurar primero conectividad y resolver el incidente sin cambios simultáneos en múltiples capas.