# 01 · Hardware, energía y temperatura

## Inventario confirmado

| Elemento | Valor |
| --- | --- |
| Equipo | Dell Latitude E4310 (portátil empresarial antiguo) |
| CPU | Intel Core i5 M560, 2 núcleos / 4 hilos, 2,67 GHz nominal |
| RAM | 8 GB instalados (aprox. 7,7 GiB utilizables) |
| Almacenamiento | SSD Kingston A400 de 480 GB |
| Sistema operativo | Debian 13 «Trixie», minimal |
| NIC cableada | `eno1` |
| Alimentación | Adaptador externo; batería original retirada |

## Cambios realizados / comprobados

- Perfil de frecuencia CPU: `schedutil` con controlador `acpi-cpufreq`. No se cambió a `performance`.
- PowerTOP mostró uso de CPU muy bajo en reposo (~0,4 % en una captura) y actividad de reposo elevada. No son datos de vatios.
- Wi-Fi, Bluetooth y WWAN bloqueados mediante `rfkill`; los bloqueos seguían activos tras reiniciar.
- Apagado visual de consola mediante `setterm`: se observó pantalla sin resplandor y el apagado persistió tras reinicio.
- Objetivos de suspensión / hibernación systemd marcados `masked` tras reiniciar. El portátil se mantuvo con la tapa abierta para ventilación.
- Batería retirada al resolverse el atasco mecánico de la pestaña. El sistema pudo seguir funcionando conectado al cargador.

## Temperaturas observadas

Sensores mostraron aprox. 38–49 °C en reposo, dependiendo del sensor y de la prueba. La lectura de ventilador a 0 RPM podría ser real o un problema de lectura; **no se verificó físicamente**.

## Consumo eléctrico: estimación, no medición

No se utilizó vatímetro de enchufe. El objetivo propuesto de **10–20 W** en reposo es solo una estimación. PowerTOP no certifica el consumo total desde la pared.

Ejemplo para **0,20 €/kWh** y uso continuo:

| Consumo medio | kWh / año | Coste / año |
| --- | ---: | ---: |
| 10 W | 87,6 | 17,52 € |
| 15 W | 131,4 | 26,28 € |
| 20 W | 175,2 | 35,04 € |
| 30 W | 262,8 | 52,56 € |

El consumo aumenta con carga, periféricos y batería cargándose. El SSD y Debian minimal ayudan a reducir carga, pero no garantizan una cifra concreta.

## Comprobaciones no destructivas

```bash
cat /proc/cpuinfo | grep -m1 'model name'
free -h
lsblk -o NAME,SIZE,ROTA,MODEL,TYPE
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
rfkill list
sensors
systemctl is-enabled sleep.target suspend.target hibernate.target
```

## Pendientes

- Medir vatios reales en enchufe, especialmente con pantalla apagada y en reposo.
- Confirmar retención o eliminación segura de la batería vieja; una batería deteriorada debe ir a recogida adecuada.
- Verificar temperatura bajo carga moderada y ventilación física antes de tareas intensivas.
- No ejecutar `powertop --auto-tune` indiscriminadamente: puede afectar USB, Ethernet y almacenamiento.