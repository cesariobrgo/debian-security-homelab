#!/usr/bin/env bash
# Diagnóstico local de solo lectura; no modifica la configuración
set -u
heading() { printf '\n=== %s ===\n' "$1"; }
heading "Fecha y host"
date -Is
hostname
heading "IPv4 y rutas"
ip -br -4 addr || true
ip -4 route || true
heading "Servicios"
for service in AdGuardHome tailscaled ssh; do
  printf '%-14s ' "$service"
  systemctl is-active "$service" 2>/dev/null || true
done
heading "Puertos DNS"
ss -lntup 2>/dev/null | grep -E ':53([[:space:]]|$)' || echo 'No se encontró puerto 53 escuchando'
heading "DNS local"
if command -v dig >/dev/null 2>&1; then
  dig @127.0.0.1 example.com A +time=2 +tries=1 +noall +answer || true
else
  echo 'Falta dig (dnsutils)'
fi
heading "Tailscale"
if command -v tailscale >/dev/null 2>&1; then tailscale status || true; fi
heading "Energía"
if command -v rfkill >/dev/null 2>&1; then rfkill list || true; fi
if command -v sensors >/dev/null 2>&1; then sensors || true; fi
systemctl is-enabled sleep.target suspend.target hibernate.target 2>/dev/null || true
printf '\nFinalizado sin cambios de configuración.\n'
