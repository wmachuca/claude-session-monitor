#!/bin/bash
# Compila e instala la app en /Applications (uso permanente).
set -e
cd "$(dirname "$0")"

./build.sh

echo "📦 Instalando en /Applications…"
pkill -f ClaudeSessionMonitor 2>/dev/null || true
sleep 0.4
rm -rf /Applications/ClaudeSessionMonitor.app
ditto ClaudeSessionMonitor.app /Applications/ClaudeSessionMonitor.app   # preserva la firma
open /Applications/ClaudeSessionMonitor.app

echo "✅ Instalada en /Applications y lanzada"
echo "   Si tenías «Iniciar al arrancar» activado, reactívalo en Preferencias para que apunte a /Applications."
