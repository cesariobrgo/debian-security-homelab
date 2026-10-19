# 02 · Debian: configuración base y recuperación

## Instalación

Debian 13 minimal ya estaba presente cuando se inició la puesta a punto; **no se reinstaló** para este proyecto. Se trabajó localmente como `root` durante la preparación. No dar por confirmado un acceso SSH endurecido.

## Incidencia inicial: APT sin repositorios

`apt update` no ofrecía índices útiles y `openssh-server` no tenía candidato. Se añadieron repositorios correctos de Debian 13 y seguridad. Una línea `trixie-security` quedó inicialmente mal formada y fue corregida.

**Referencia de sintaxis** (no pegar a ciegas si ya existen fuentes):

```text
deb http://deb.debian.org/debian trixie main non-free-firmware
deb http://deb.debian.org/debian trixie-updates main non-free-firmware
deb http://security.debian.org/debian-security trixie-security main non-free-firmware
```

En una instalación nueva, consultar **primero** los ficheros de `/etc/apt/sources.list` y `/etc/apt/sources.list.d/`, incluidos los `.sources` en formato Deb822. Evitar fuentes duplicadas. No desactivar nunca la validación de firmas para solucionar errores APT.

## Energía: decisiones aplicadas

Se bloquearon mecanismos de suspensión gestionados por systemd:

```bash
systemctl is-enabled sleep.target suspend.target hibernate.target
```

La operación original utilizada fue:

```bash
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
```

Para **revertir** deliberadamente:

```bash
systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target
```

No cerrar la tapa hasta verificar ventilación y política de `logind` si se cambia el uso físico del equipo.

## Red

La interfaz Ethernet detectada es `eno1`; el enrutador asigna dirección por DHCP y se creó una reserva de IP en el ZTE.

```bash
ip -br link
ip -br -4 addr
ip route
ping -c 2 <ROUTER_LAN_IP>
```

En una incidencia se perdió IPv4 por estar **desconectado físicamente el cable**, no por un fallo de DHCP o AdGuard.

## Paquetes de diagnóstico utilizados

- `openssh-server`: instalación intentada tras arreglar APT; estado actual de autenticación/SSH no verificado de forma concluyente.
- `rfkill`: bloqueo de radios no utilizadas.
- `powertop`: auditoría de actividad y ajustes de ahorro (sin aplicar `--auto-tune`).
- `lm-sensors`: temperaturas.
- `dnsutils`: `dig` para pruebas DNS.

Antes de abrir el servidor al exterior, configurar un usuario sin privilegios, acceso SSH con claves, actualizaciones y reglas de acceso revisadas. **No abrir el puerto SSH en el router WAN.**