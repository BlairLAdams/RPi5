#!/usr/bin/env python3
# ✅ Filename: alertLogger.py
# 📦 Purpose: Minimal Alertmanager webhook receiver that logs alerts locally
# 📍 Location: ~/scr/prometheus/alertLogger.py

import os
import sys
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

# ─────────────────────────────────────────────────────────────────────────────
# 📁 SETUP: Log file destination
# ─────────────────────────────────────────────────────────────────────────────
LOG_DIR = "/var/log/alertmanager"
LOG_FILE = os.path.join(LOG_DIR, "alerts.log")

# Ensure log directory exists
os.makedirs(LOG_DIR, exist_ok=True)

class AlertHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_len = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_len)
        alert = json.loads(body.decode('utf-8'))

        with open(LOG_FILE, "a") as f:
            f.write(json.dumps(alert, indent=2))
            f.write("\n" + "="*60 + "\n")

        self.send_response(200)
        self.end_headers()

# ─────────────────────────────────────────────────────────────────────────────
# 🚀 START SERVER
# ─────────────────────────────────────────────────────────────────────────────
def run(server_class=HTTPServer, handler_class=AlertHandler, port=5001):
    try:
        server_address = ('', port)
        httpd = server_class(server_address, handler_class)
        print(f"🟢 Listening for alerts on port {port}...")
        httpd.serve_forever()
    except PermissionError:
        print("❌ Permission denied. Try running with sudo.")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    run()
