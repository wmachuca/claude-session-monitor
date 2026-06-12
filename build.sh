#!/bin/bash
# Compila Claude Session Monitor como una app nativa de barra de menús.
set -e
cd "$(dirname "$0")"

APP="ClaudeSessionMonitor.app"
BIN="$APP/Contents/MacOS/ClaudeSessionMonitor"
ID="com.wmachuca.claude-session-monitor"

# Identidad de firma ESTABLE (certificado autofirmado en un llavero dedicado).
# Necesaria para que los permisos de Accesibilidad/Automatización persistan entre builds:
# con firma ad-hoc el CDHash cambia en cada compilación y macOS revoca el permiso.
CERT="ClaudeSessionMonitor-Dev"
KC="$HOME/Library/Keychains/cs-signing.keychain-db"
KCPASS="csmonitor"

ensure_cert() {
  if [ -f "$KC" ] && security find-identity -p codesigning "$KC" 2>/dev/null | grep -q "$CERT"; then return; fi
  echo "🔑 Creando identidad de firma estable '$CERT'…"
  security delete-keychain "$KC" 2>/dev/null || true
  security create-keychain -p "$KCPASS" "$KC"
  security set-keychain-settings "$KC"                 # sin auto-lock por timeout
  security unlock-keychain -p "$KCPASS" "$KC"
  local TMP; TMP=$(mktemp -d)
  cat > "$TMP/c.conf" <<EOF
[req]
distinguished_name=dn
x509_extensions=v3
prompt=no
[dn]
CN=$CERT
[v3]
keyUsage=critical,digitalSignature
extendedKeyUsage=critical,codeSigning
basicConstraints=critical,CA:false
EOF
  /usr/bin/openssl req -x509 -newkey rsa:2048 -nodes -keyout "$TMP/k.pem" -out "$TMP/c.pem" -days 3650 -config "$TMP/c.conf" 2>/dev/null
  /usr/bin/openssl pkcs12 -export -inkey "$TMP/k.pem" -in "$TMP/c.pem" -out "$TMP/c.p12" -passout pass:tmp 2>/dev/null
  security import "$TMP/c.p12" -k "$KC" -P "tmp" -A -T /usr/bin/codesign >/dev/null 2>&1
  security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KCPASS" "$KC" >/dev/null 2>&1
  rm -rf "$TMP"
}

echo "🔨 Compilando..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc -O Sources/main.swift -o "$BIN" \
    -framework AppKit -framework Foundation

# ícono de la app
[ -f Resources/AppIcon.icns ] && cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key><string>Claude Session Monitor</string>
    <key>CFBundleIdentifier</key><string>$ID</string>
    <key>CFBundleVersion</key><string>1.0</string>
    <key>CFBundleShortVersionString</key><string>1.0</string>
    <key>CFBundleExecutable</key><string>ClaudeSessionMonitor</string>
    <key>CFBundleIconFile</key><string>AppIcon</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>LSUIElement</key><true/>
    <key>LSMinimumSystemVersion</key><string>13.0</string>
</dict>
</plist>
PLIST

# Firmar con la identidad estable (cae a ad-hoc solo si algo falla)
ensure_cert
security unlock-keychain -p "$KCPASS" "$KC" 2>/dev/null || true
if security find-identity -p codesigning "$KC" 2>/dev/null | grep -q "$CERT"; then
    codesign --force --deep --sign "$CERT" --keychain "$KC" --identifier "$ID" "$APP"
    echo "🔏 Firmado con identidad estable ($CERT)"
else
    codesign --force --deep --sign - "$APP" 2>/dev/null || true
    echo "⚠️  Firmado ad-hoc (no se pudo crear la identidad estable)"
fi

echo "✅ Listo: $(pwd)/$APP"
