#!/bin/bash
cd "$(dirname "$0")"

clear
echo ""
echo "════════════════════════════════════════════════════"
echo "  Laufplan App — lokaler Server (mit No-Cache)"
echo "════════════════════════════════════════════════════"
echo ""

# IP-Adresse herausfinden (WLAN bevorzugt, sonst Ethernet)
IP=$(ipconfig getifaddr en0 2>/dev/null)
if [ -z "$IP" ]; then IP=$(ipconfig getifaddr en1 2>/dev/null); fi
if [ -z "$IP" ]; then IP="<keine WLAN-IP gefunden>"; fi

echo "  Auf dem iPhone in Safari öffnen:"
echo ""
echo "    http://${IP}:8080/laufplan_app.html"
echo ""
echo "  Dann unten: Teilen → Zum Home-Bildschirm"
echo ""
echo "  → Server liefert mit no-cache Headers — Updates kommen sofort durch"
echo "  Beenden: Strg+C oder dieses Fenster schließen"
echo "════════════════════════════════════════════════════"
echo ""

python3 -c "
from http.server import HTTPServer, SimpleHTTPRequestHandler

class NoCacheHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        # Komplett kein Caching — jede Anfrage holt frische Datei
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        # Service Worker Update-Header: Browser darf SW jederzeit updaten
        if self.path.endswith('sw.js'):
            self.send_header('Service-Worker-Allowed', '/')
        super().end_headers()

HTTPServer(('', 8080), NoCacheHandler).serve_forever()
"
