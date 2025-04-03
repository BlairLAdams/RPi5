#!/bin/bash
# installLokiPromtail.sh - Installs Grafana Loki and Promtail on Raspberry Pi

set -e

echo "[INFO] Installing unzip and curl if missing..."
sudo apt-get update -y
sudo apt-get install -y unzip curl

echo "[INFO] Preparing install directory..."
sudo mkdir -p /opt/loki
cd /opt/loki

echo "[INFO] Downloading latest Loki and Promtail..."
sudo curl -Lo loki-linux-arm64.zip https://github.com/grafana/loki/releases/latest/download/loki-linux-arm64.zip
sudo curl -Lo promtail-linux-arm64.zip https://github.com/grafana/loki/releases/latest/download/promtail-linux-arm64.zip

echo "[INFO] Extracting and installing binaries..."
sudo unzip -o loki-linux-arm64.zip
sudo unzip -o promtail-linux-arm64.zip
sudo mv -f loki-linux-arm64 loki
sudo mv -f promtail-linux-arm64 promtail
sudo chmod +x loki promtail
sudo mv -f loki promtail /usr/local/bin/

echo "[INFO] Creating required data directories..."
sudo mkdir -p /opt/loki/{index,boltdb-cache,chunks,wal,compactor}
sudo chown -R root:root /opt/loki

echo "[INFO] Writing Loki config..."
sudo tee /etc/loki-config.yaml > /dev/null <<EOF
auth_enabled: false

server:
  http_listen_port: 3100
  log_level: info

common:
  path_prefix: /opt/loki

ingester:
  wal:
    enabled: true
    dir: /opt/loki/wal
  chunk_idle_period: 5m
  max_chunk_age: 1h
  chunk_target_size: 1048576
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1

schema_config:
  configs:
    - from: 2022-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /opt/loki/index
    cache_location: /opt/loki/boltdb-cache
  filesystem:
    directory: /opt/loki/chunks

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h
  allow_structured_metadata: false

compactor:
  working_directory: /opt/loki/compactor
EOF

echo "[INFO] Writing Promtail config..."
sudo tee /etc/promtail-config.yaml > /dev/null <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /opt/loki/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*.log
EOF

echo "[INFO] Creating systemd unit for Loki..."
sudo tee /etc/systemd/system/loki.service > /dev/null <<EOF
[Unit]
Description=Grafana Loki
After=network.target

[Service]
ExecStart=/usr/local/bin/loki -config.file=/etc/loki-config.yaml
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Creating systemd unit for Promtail..."
sudo tee /etc/systemd/system/promtail.service > /dev/null <<EOF
[Unit]
Description=Grafana Promtail
After=network.target

[Service]
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail-config.yaml
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "[INFO] Reloading systemd and starting services..."
sudo systemctl daemon-reload
sudo systemctl enable --now loki
sudo systemctl enable --now promtail

echo "[SUCCESS] Loki and Promtail installed and running."
