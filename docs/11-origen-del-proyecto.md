# 11 · Cómo empezó este homelab: Xiaomi Mesh, DNS y hardware reutilizado

> Reconstrucción a partir de la conversación de diseño previa al montaje del Dell. No es un registro de paquetes, una auditoría forense ni una prueba de exfiltración.

## El problema original

El punto de partida no fue montar servidores por afición, sino comprender y limitar conexiones externas del **Xiaomi Mesh System AC1200 RD13** sin perder su utilidad como punto de acceso. Se habían observado comunicaciones periódicas del firmware hacia infraestructura de Xiaomi y destinos alojados en servicios cloud. **La existencia de esas conexiones no permite concluir que Xiaomi espiara el contenido del tráfico de los ordenadores.**

Se recurrió primero a **NextDNS**, con reglas para algunos dominios Xiaomi. Hubo indicios de bloqueos correctos mientras se utilizaba la configuración DNS anterior. Quedó por demostrar si todos los dispositivos —y, en especial, el propio Xiaomi— respetaban el servidor configurado.

## El cambio que desencadenó el proyecto

Para simplificar la LAN, el Xiaomi se puso en **modo repetidor/punto de acceso por cable**; el **router DIGI ZTE** pasó a ser el encargado de DHCP y routing, evitando doble NAT. Esto tuvo una consecuencia: los ajustes DNS que antes se aplicaban a través del Xiaomi ya no determinaban necesariamente qué resolutor recibían los clientes.

La conversación identificó el siguiente cambio:

- Antes: clientes → Xiaomi (ajustes DNS NextDNS) → router DIGI.
- Después: clientes → Xiaomi en puente → router DIGI (DHCP y DNS).

Los filtros de NextDNS **no se borraron**: las listas persistían en la cuenta. Lo que había que recuperar era la *ruta efectiva de las consultas* hacia ese perfil.

La recomendación inicial fue comprobar si el ZTE permitía anunciar resolutores mediante DHCP y verificar con `test.nextdns.io` que los clientes recibían las políticas esperadas.

## Lo que aprendimos sobre DNS

1. **DNS no es un firewall:** bloquear un dominio no impide que un dispositivo contacte directamente con una IP. Tampoco impide que use DNS cifrado independiente o resolutores no controlados.
2. **Bloquear localmente ahorra consultas externas:** una lista atendida en AdGuard/Pi-hole puede cortar consultas antes de enviarlas a NextDNS, aunque el comportamiento exacto de caché y reintentos depende del cliente.
3. **El Xiaomi en modo puente no es el router perimetral:** imponer restricciones de salida basadas en IP exige que el tráfico atraviese un firewall controlado, o un diseño de segmentación y políticas adecuado.
4. **La privacidad depende de quién resuelve:** NextDNS ve las consultas que recibe; AdGuard permite tener un registro local y cifrar las consultas al upstream mediante DoH. No significa que todas las conexiones salientes pasen por AdGuard.

## Por qué elegimos reutilizar un PC antiguo

Se consideraron Pi-hole, AdGuard Home, Raspberry Pi, mini-PC y un equipo antiguo. Los criterios eran **coste de entrada bajo, electricidad, disponibilidad 24/7 y aprendizaje real de redes y seguridad**.

Se descartó comprar hardware inmediatamente. El compromiso fue:

- Reutilizar primero el PC antiguo.
- Separar DNS crítico de la minería de Monero (que pondría CPU bajo carga).
- No convertir sin planificación un host con una sola NIC en firewall físico de toda la casa.
- Medir consumo con un vatímetro antes de afirmar ahorros; una fuente de 500 W no consume continuamente 500 W.

Para el DNS se eligió **AdGuard Home**, especialmente por su integración de DNS-over-HTTPS y administración local. NextDNS se mantendría como upstream y filtro complementario. Más adelante estudiaríamos **OpenWrt/OPNsense** para restringir tráfico IP, pero solo si una topología apropiada lo permite.

## De la idea al despliegue real

La conversación anterior cerró con una separación deliberada:

- Proyecto de **auditoría del Xiaomi**: verificar qué bloqueos persisten, revisar servicios cloud y decidir si hace falta aislamiento adicional.
- Proyecto **Home Lab**: identificar hardware, instalar Debian/AdGuard, optimizar consumo, servir DNS local y explorar firewall.

En el segundo proyecto acabamos reutilizando un **Dell Latitude E4310 con Debian 13**, 8 GB RAM y SSD. Se configuró la red Ethernet, AdGuard Home con NextDNS y acceso remoto DNS mediante **Tailscale**, incluso con CG-NAT. Los detalles técnicos, evidencias y estados constan en los capítulos [01](01-hardware-consumo.md), [03](03-adguard-nextdns.md) y [04](04-tailscale-dns.md).

## Qué sigue abierto del objetivo original

- Comprobar específicamente qué DNS utiliza **el firmware del Xiaomi**, no solo los clientes de la LAN.
- Auditar con una nueva captura corta de tráfico si siguen existiendo conexiones cloud directas a IP y si son necesarias para la funcionalidad Mesh.
- Revisar y deshabilitar, cuando sea seguro, servicios cloud, WPS y administración remota innecesaria.
- Diseñar restricciones IP de salida solo después de determinar la ruta del tráfico y evitar romper el punto de acceso.
- Distinguir conexiones observadas, funcionalidad técnica y **evidencia de una eventual transferencia de datos sensibles**: no equivalen.

## Lección principal

Lo que empezó como un problema de telemetría y DNS terminó siendo un laboratorio de **troubleshooting de capas de red**, de reutilización de hardware y de análisis de arquitectura. La motivación original sigue vigente: tener control técnico sobre el tráfico de la red doméstica sin perder disponibilidad ni gastar por inercia.

---
*Documento redactado el 19 de octubre de 2026 a partir de la conversación facilitada. Las fechas de cada paso anterior no se han reconstruido con precisión si el registro no las documenta.*