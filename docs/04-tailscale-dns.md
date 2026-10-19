# 04 · Tailscale: VPN y DNS remoto

## Motivación

La WAN del ZTE usa CG-NAT. Tailscale permite conectar los dispositivos sin port forwarding ni contratar una IPv4 pública individual.

## Estado confirmado

- `tailscaled` instalado y operativo en Debian.
- Dell y Pixel 9a conectados a una misma tailnet.
- En el servidor se usó `--accept-dns=false` para no reemplazar su DNS local.
- El panel de administración DNS de Tailscale anunció la IP Tailscale del Dell como nameserver global, con Override DNS servers habilitado durante la configuración.
- La opción **Use Tailscale DNS** del Pixel se activó.
- El registro de AdGuard mostró numerosas consultas desde la IP Tailscale del Pixel; por tanto, el DNS remoto funcionó al menos durante las pruebas.

## Configuración de referencia (valores anónimos)

En Dell:

```bash
tailscale status
tailscale ip -4
tailscale debug prefs
```

Comando de arranque utilizado durante el montaje:

```bash
tailscale up --accept-dns=false
```

**Nota:** `tailscale up` puede exigir repetir opciones no predeterminadas. Para cambiar una sola preferencia en un nodo ya configurado, normalmente se prefiere `tailscale set ...`.

En `https://login.tailscale.com/admin/dns`:

```text
Global nameserver: <DELL_TAILSCALE_IP>
Override DNS servers: enabled (si se desea en toda la tailnet)
```

En el Pixel: conectado a Tailscale, **Use Tailscale DNS** activo. Para utilizar exclusivamente el DNS casero, **no es necesario** seleccionar un Exit Node.

## Bind y control de acceso DNS

Tras la configuración inicial, AdGuard escuchaba solo en LAN y no atendía por Tailscale. Se amplió a todas las interfaces IPv4; quedó confirmado:

```text
udp *:53  AdGuardHome
tcp *:53  AdGuardHome
```

Se propuso una allowlist que incluyera la LAN, rango Tailscale y loopback; **no está verificado aquí si se guardó exactamente así**. Antes de endurecer el firewall, revisar `AdGuardHome.yaml`, clientes permitidos y reglas de Tailscale. Escuchar en `0.0.0.0` **no equivale** a abrir DNS en Internet; no crear reglas de port-forward para el puerto 53.

## Limitaciones

- Los ajustes globales de DNS de una tailnet pueden afectar a **todos** sus miembros que acepten DNS Tailscale; revisar equipos de trabajo antes de integrarlos.
- Si el Dell cae y es el único DNS global de Tailscale, el Pixel puede perder resolución hasta desactivar Use Tailscale DNS, desconectar Tailscale o configurar un respaldo apto.
- Un DNS secundario anunciado por DHCP del ZTE **no protege automáticamente** a los móviles que usan el DNS global de Tailscale.
- Restringir acceso al panel 8080 y a SSH a clientes autorizados, no confundir DNS externo con interfaz web pública.

## Prueba de cliente sin Exit Node

1. Wi-Fi apagado en Pixel; datos móviles activados.
2. Tailscale conectado, **Exit Node = None**, **Use Tailscale DNS = On**.
3. Navegar y abrir AdGuard desde otra sesión de administración.
4. Confirmar consultas originadas por `<PIXEL_TAILSCALE_IP>`.
5. Desconectar Tailscale y verificar que el móvil sigue navegando normalmente.