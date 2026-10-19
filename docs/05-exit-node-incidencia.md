# 05 · Exit Node de Tailscale: incidente pendiente

## Estado real

**No está demostrado que el Exit Node funcione correctamente.** Se intentó anunciar el Dell como nodo de salida y aprobarlo en la consola de Tailscale. Durante las pruebas, Spotify dejó de funcionar en el Pixel; también hubo un mensaje de error DNS y dificultades para encontrar la opción de desconectar el Exit Node en Android.

Una comprobación de IP pública mostró la IP de salida doméstica, pero sin confirmar inequívocamente si se observó en el móvil por datos móviles y con Exit Node seleccionado. **No atribuir el fallo a Spotify, DNS ni routing sin pruebas comparativas.**

## Qué se intentó

- Habilitar reenvío IPv4/IPv6 en Debian con `sysctl`.
- Ejecutar `tailscale up --accept-dns=false --advertise-exit-node`.
- Aprobar `Use as exit node` en la consola de administración (estado final no documentado de forma concluyente).
- Se sugirió retirar el anuncio desde Debian con `tailscale set --advertise-exit-node=false`; **no se recibió confirmación de ejecución**.

## Cómo diagnosticar sin romper AdGuard

### A. Dejar un baseline funcional

Pixel con datos móviles, Tailscale encendido, **Exit Node desactivado** y **Use Tailscale DNS activo**. Confirmar que navega y que las consultas aparecen en AdGuard. Esto valida VPN + DNS, independientemente de Exit Node.

### B. Revisar el Dell (solo lectura)

```bash
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
tailscale status
tailscale debug prefs
ip -4 route
systemctl is-active tailscaled AdGuardHome
```

### C. Repetir prueba controlada con Pixel

1. Datos móviles, Wi-Fi desconectado.
2. Comparar IP pública con Exit Node desactivado y activado, manteniendo igual la configuración DNS.
3. Probar navegación HTTPS general **y** Spotify en ambos estados.
4. Si solo falla con Exit Node, revisar forwarding, política firewall/NAT, rutas, IPv6 y MTU.
5. Si falla con Tailscale DNS sin Exit Node, revisar nameserver global, bind del 53, DNS privado de Android y allowed clients.

### D. Retirada rápida del anuncio (si se desea)

En el Dell:

```bash
tailscale set --advertise-exit-node=false
```

La opción de Exit Node se selecciona **en el cliente**, no en el Dell. Retirar el anuncio evita que nuevos clientes lo utilicen como salida; después revisar en el Pixel que realmente no lo tiene seleccionado. **No ejecutar `tailscale down` como primer remedio**, porque cortaría también el DNS remoto.

## Riesgos y límites

- Si el Dell se apaga mientras se usa como Exit Node, el cliente puede perder la salida a Internet hasta deseleccionarlo.
- El cifrado de Tailscale no equivale a anonimato. Los sitios ven la IP pública de salida de DIGI; algunos servicios detectan ubicación con otras señales.
- La propia red doméstica/operador sigue transportando tráfico al exterior.
- El rendimiento depende de CPU, red y en ciertos casos de relés.

## Criterio para marcar como resuelto

- Comparativa reproducible (datos móviles) donde `Exit Node=None` use IP del operador móvil y `Exit Node=Dell` use IP de DIGI.
- DNS continúa funcionando con y sin Exit Node.
- Spotify y navegación general funcionan en ambos estados.
- Configuración persistente comprobada tras reiniciar el Dell y reconectar Pixel.