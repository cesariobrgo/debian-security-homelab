# 06 · Seguridad y firewall (diseño, no implantación)

## Modelo de amenazas

- Aplicaciones o dispositivos IoT dentro de la misma LAN.
- Escucha y abuso de servicios del Dell si se publican indebidamente.
- Fallos de configuración DNS que provoquen pérdida de conectividad o saltos de filtrado.
- Secuestro de credenciales, claves privadas o archivos de configuración publicados en GitHub.
- Riesgo de disponibilidad por depender de un portátil antiguo sin batería.

## Situación actual

- El ZTE gestiona NAT y actúa como router de borde.
- El Dell presta DNS, acceso Tailscale y servicios locales.
- **No hay evidencia de un ruleset nftables restrictivo implantado.**
- AdGuard llegó a escuchar en todas las interfaces (`*:53`) para permitir DNS de Tailscale.
- SSH no se ha validado como acceso con claves endurecido; se pospuso su revisión.

## Política propuesta (todavía por implementar)

| Servicio | Destinos autorizados | Puerto |
| --- | --- | --- |
| DNS AdGuard | LAN doméstica y dispositivos autorizados Tailscale | 53 TCP/UDP |
| Admin AdGuard | Admin local por LAN y, si procede, clientes Tailscale concretos | 8080 TCP |
| SSH | Solo administración autenticada desde red privada | 22 TCP (si habilitado) |
| Tráfico establecido | Permitir retorno de conexiones válidas | `ct state established,related` |
| Loopback / ICMPv6 | Permitir los mecanismos necesarios de funcionamiento | Según familia y caso |
| Entrada no solicitada | Denegar tras validar las excepciones | Resto |

Para un posible Exit Node hay que considerar `forward` y NAT que Tailscale configura. Una política `drop` indiscriminada en `forward` puede romper la VPN aunque el DNS funcione. IPv6 exige cuidar especialmente ICMPv6/Neighbor Discovery.

## Procedimiento seguro antes de aplicar nftables

1. Auditar `ss -lntup`, `nft list ruleset`, `iptables-save` y servicios activos.
2. Exportar la configuración previa a un lugar seguro (fuera del repositorio público).
3. Diseñar reglas en fichero, comprobar sintaxis con `nft -c -f <archivo>`.
4. Preparar rollback automático por consola local **antes** de aplicar políticas restrictivas.
5. Probar DNS LAN, DNS Tailscale, panel AdGuard y VPN sin cerrar la consola.
6. Solo entonces hacer persistente el ruleset.

**No se incluye un script de firewall listo para ejecutar a ciegas** porque aún falta una auditoría de la topología real, IPv6 y del estado del Exit Node.

## Servicios futuros

Unbound recursivo, OpenWrt virtual, Syncthing y automatizaciones solo deben abrir los puertos estrictamente necesarios y aislarse de DNS esencial. No montar un laboratorio ofensivo en la LAN doméstica sin segmentación.