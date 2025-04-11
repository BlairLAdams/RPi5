# alert_log_server.py
from flask import Flask, request
import logging
import os

LOG_PATH = "/var/log/prometheus_alerts.log"
os.makedirs(os.path.dirname(LOG_PATH), exist_ok=True)

app = Flask(__name__)
logging.basicConfig(filename=LOG_PATH, level=logging.INFO)

@app.route("/", methods=["POST"])
def alert_log():
    alert = request.get_json(force=True)
    app.logger.info(f"ALERT RECEIVED:\n{alert}")
    return '', 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
