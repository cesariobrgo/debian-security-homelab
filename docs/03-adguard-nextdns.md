# 03 · AdGuard Home, NextDNS y DHCP

## Estado observado

- Servicio `AdGuardHome` activo.
- DNS TCP/UDP puerto **53** escuchando en todas las interfaces (`*:53`) tras ampliar el bind para Tailscale.
- Interfaz de administración web configurada durante el asistente en el puerto **8080**; verificar la dirección efectiva de escucha antes de exponerla.
- Consultas reales registradas desde LAN y desde el Pixel mediante Tailscale.
- El router ZTE conserva DHCP, y se reservó la IP del Dell.

## Ajustes lógicos

| Ajuste | Valor / criterio |
| --- | --- |
| Interfaz DNS | En LAN inicialmente; más tarde `0.0.0.0` para poder servir DNS a Tailscale |
| Puerto DNS | `53/udp` y `53/tcp` |
| Web admin | `8080/tcp` previsto, solo desde redes autorizadas |
| Upstream | `https://dns.nextdns.io/<NEXTDNS_PROFILE_ID>` |
| Fallback upstream | Vacío para no saltar las políticas por error |
| Bootstrap | Se propusieron DNS públicos para resolver el nombre de NextDNS; verificar configuración efectiva |
| DNS inverso LAN | Se evaluó el ZTE, pero la respuesta PTR no quedó confirmada |
| DHCP de AdGuard | **No habilitado**; DHCP permanece en ZTE |
| Logs | Retención corta configurada; revisar si son 24 h o 7 d en la instalación actual |

No guardar el fichero de producción `AdGuardHome.yaml` en GitHub: puede contener identificadores, hashes y otros detalles sensibles. Los ejemplos del repositorio son deliberadamente parciales y anonimizados.

## Filtros instalados (confirmados)

1. [AdGuard DNS Filter](https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt), lista base.
2. [HaGeZi TIF Mini](https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.mini.txt), inteligencia de amenazas.

Se optó por **Mini**, no por la versión completa. No hay constancia de activar una lista «No Google»; **no se recomienda** en el Pixel principal porque podría romper servicios esenciales de Android.

## DHCP LAN y respaldo DNS

Se propuso en ZTE:

```text
DNS principal: <DELL_LAN_IP>
DNS secundario: <NEXTDNS_LINKED_IPV4>
DHCP: activado
```

El DNS secundario se configura en **DHCP del router**, no en el campo «Fallback DNS servers» de AdGuard (que solo cubre una caída del upstream con AdGuard aún encendido).

Advertencias:

- Muchos clientes **no respetan prioridad estricta** entre DNS primario y secundario.
- Para usar el perfil NextDNS por IPv4 tradicional se requiere vinculación correcta de la IP pública de salida; cambia con el operador.
- El DNS tradicional dirigido directamente a NextDNS suele ir **sin cifrar**, mientras que AdGuard → NextDNS usa HTTPS.
- IPv6 y DNS de VPN corporativas pueden permitir consultas fuera de AdGuard.
- Si el Dell se apaga, los dispositivos pueden recurrir al secundario, pero **no se garantizó el tiempo ni el éxito de failover en todos los clientes**.

## Comprobar resolución y bloqueos

En Debian:

```bash
systemctl is-active AdGuardHome
ss -lntup | grep ':53'
dig @127.0.0.1 example.com A +time=2 +tries=1
```

En Windows, en una red donde la VPN corporativa no interfiera:

```powershell
nslookup example.com <DELL_LAN_IP>
Get-DnsClientServerAddress -InterfaceAlias 'Wi-Fi'
```

No confundir el error `NXDOMAIN` de `example.comdig` —dominio tecleado accidentalmente— con un fallo del DNS. Se verificó `example.com` con respuesta `NOERROR` desde el Dell.

## Telemetría Pixel: prudencia

En registros se observaron bloqueos de dominios de publicidad y métricas como `region1.google-analytics.com`, `pagead2.googlesyndication.com` y algunos `beacons*.gvt2.com`. Un dominio consultado **no prueba por sí solo** qué aplicación originó la petición ni qué datos pretendía enviar.

Se prefirió reducir telemetría mediante opciones de privacidad Android y mantener funciones de Play Services, navegación segura y actualizaciones, en vez de aplicar bloqueos indiscriminados a `googleapis.com` o `gstatic.com`.