# 07 · Runbook de operación y recuperación

## Verificación diaria o tras reiniciar

```bash
hostnamectl
ip -br -4 addr
ip route
systemctl is-active AdGuardHome tailscaled
tailscale status
ss -lntup | grep ':53'
dig @127.0.0.1 example.com A +time=2 +tries=1
sensors
```

Si `dig` no está instalado: `apt install dnsutils`, tras verificar que APT está bien configurado y la red funciona.

## Caso 1: Internet falla en clientes domésticos

1. Comprobar si hay acceso por IP (separa Internet de DNS).
2. Revisar Ethernet física, `ip -br link`, `ip -4 route`, la reserva DHCP del ZTE.
3. Comprobar `systemctl is-active AdGuardHome` y `dig @<DELL_LAN_IP> example.com`.
4. Probar el DNS secundario del router, recordando que el sistema cliente elige el resolutor.
5. Consultar logs: `journalctl -u AdGuardHome -n 100 --no-pager`.

**No modificar NextDNS, ZTE y AdGuard a la vez**: aislar una variable por prueba.

## Caso 2: el móvil no resuelve con Tailscale

1. Desactivar Exit Node en el Pixel si estuviera seleccionado.
2. Verificar que el Dell aparece online en `tailscale status`.
3. Confirmar puerto DNS en `*:53` o IP Tailscale del Dell.
4. Verificar nameserver global y Use Tailscale DNS.
5. Desactivar temporalmente DNS Tailscale en el Pixel para recuperar navegación mientras se diagnostica.

## Caso 3: AdGuard no abre en el navegador

```bash
systemctl status AdGuardHome --no-pager
ss -lntp
journalctl -u AdGuardHome -n 80 --no-pager
```

La interfaz web inicial del asistente utilizó el puerto 3000; al terminar, se configuró en 8080. El DNS puede estar activo aunque el panel no sea accesible por Tailscale.

## Caso 4: seguridad tras instalar paquetes

- Actualizar Debian con frecuencia razonable y revisar changelogs que afecten servicios críticos.
- Antes de cambios grandes, respaldar configuraciones fuera del repositorio.
- Mantener acceso físico o consola local al Dell en cambios de red/firewall.
- Evitar dejar secretos en el historial de shell o capturas de pantalla.

## Backups mínimos sugeridos

- Archivo de configuración real de AdGuard Home, almacenado **en destino privado cifrado**.
- Export/registro de políticas de filtro y lista de dispositivos.
- Ajustes Tailscale relevantes (nunca claves privadas ni authkeys).
- Ficheros de configuración Linux modificados a mano (APT, sysctl, servicios).

Una copia en el propio SSD **no protege** frente a fallo de disco; el disco viejo no sustituye un backup externo.

## Restauración DNS ante emergencia

Si el Dell está inaccesible y la resolución LAN falla, modificar temporalmente DHCP del ZTE o la configuración DNS de un cliente para utilizar un resolvedor disponible; luego restaurar la arquitectura tras diagnosticar. En Tailscale móvil, retirar el DNS global o desactivar Use Tailscale DNS temporalmente cuando haga falta.