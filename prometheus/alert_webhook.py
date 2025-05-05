import os

# Create a simple Flask app for receiving and logging Alertmanager webhooks
webhook_script = '''\
# Filename: /home/blair/scr/prometheus/alert_webhook.py

from flask import Flask, request
import json
import datetime

app = Flask(__name__)
logfile = "/var/log/alertmanager_webhook.log"

@app.route("/", methods=["POST"])
def receive_alert():
    alert_data = request.get_json()
    timestamp = datetime.datetime.now().isoformat()
    with open(logfile, "a") as f:
        f.write(f"{timestamp} ALERT RECEIVED:\\n{json.dumps(alert_data, indent=2)}\\n\\n")
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
'''

# Save the script
script_path = "/mnt/data/alert_webhook.py"
with open(script_path, "w") as f:
    f.write(webhook_script)

script_path

