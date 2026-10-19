# 08 · Hoja de ruta propuesta

Priorizar utilidad tangible y estabilidad frente a instalar servicios por instalar.

| Prioridad | Proyecto | Estado | Criterio de finalización |
| --- | --- | --- | --- |
| P0 | DNS AdGuard + NextDNS | Operativo | Filtrado LAN y remoto comprobado |
| P0 | Seguridad básica de accesos | Pendiente parcial | SSH endurecido, reglas de entrada revisadas |
| P0 | Continuidad DNS si Dell cae | Pendiente de prueba | Probar DHCP secundario e impacto Tailscale |
| P1 | Resolver incidencia Exit Node/Spotify | Pendiente | Enrutamiento y Spotify sin errores |
| P1 | Auditar IPv6 y DNS de clientes | Pendiente | Identificar RDNSS/DHCPv6 sin interrumpir VPN corporativa |
| P1 | Backups de configuración | Pendiente | Copia cifrada externa y prueba de restauración |
| P2 | Tailscale Subnet Router | Posible | Acceso controlado a subred LAN, ACLs y aislamiento |
| P2 | nftables local | Diseñado | Política mínima segura y plan de rollback probado |
| P2 | Virtualizar OpenWrt | Por evaluar | CPU VT-x/KVM verificada, red aislada sin afectar casa |
| P3 | Unbound recursivo | Opcional | Laboratorio DNS/DNSSEC, sin degradar disponibilidad |
| P3 | Syncthing | Opcional | Sincronización limitada y backups adecuados |
| P3 | Python/automatizaciones | Opcional | Tareas útiles, baja carga permanente |
| P4 | Nodo Monero Stagenet | Experimental | Recursos aislados, espacio y temperatura controlados |
| P4 | Minería Monero 24/7 | No recomendada | Eficiencia eléctrica poco probable en CPU antigua |

### Virtualización

Intel i5 M560 es antiguo. Comprobar `grep -m1 -o vmx /proc/cpuinfo`, VT-x habilitado y `/dev/kvm` antes de optar por KVM/QEMU. La viabilidad de cargas concretas depende del firmware y CPU reales, y del uso de RAM en producción.

### Decisiones descartadas por ahora

- Uptime Kuma en el mismo Dell como única alerta: no puede notificar si el propio Dell está apagado.
- Healthchecks.io: técnicamente útil, pero se decidió posponer por escaso valor percibido frente al esfuerzo.
- Proxmox: innecesario para pocos servicios ligeros; puede reconsiderarse si el laboratorio crece.
- Firewall físico de toda la casa con una NIC: requiere rediseño (segunda interfaz física o VLAN + switch adecuado) y plan de continuidad.