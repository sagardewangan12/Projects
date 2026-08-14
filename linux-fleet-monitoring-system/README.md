# Linux Fleet Monitoring System

A beginner-friendly SRE / DevOps portfolio project that monitors four Linux client servers from one central monitoring server using Prometheus, Node Exporter, and Grafana.

The goal is to learn practical Linux monitoring without Kubernetes, cloud services, Terraform, Jenkins, Ansible, or complex microservices.

## Project Structure

```text
linux-fleet-monitoring-system/
├── README.md
├── configs/
│   ├── prometheus.yml
│   └── systemd/
│       ├── node_exporter.service
│       └── prometheus.service
├── docs/
│   └── interview-questions.md
├── logs/
│   └── .gitkeep
├── screenshots/
│   └── .gitkeep
└── scripts/
    └── health_check.sh
```

## Architecture

```text
                 +-----------------------------+
                 |     Monitoring Server       |
                 |-----------------------------|
                 | Prometheus :9090            |
                 | Grafana    :3000            |
                 +-------------+---------------+
                               |
             Prometheus scrapes Node Exporter metrics
                               |
      +------------+-----------+-----------+------------+
      |            |                       |            |
+-----v----+  +----v-----+           +-----v----+  +----v-----+
|Client 01 |  |Client 02 |           |Client 03 |  |Client 04 |
|Node Exp. |  |Node Exp. |           |Node Exp. |  |Node Exp. |
|:9100     |  |:9100     |           |:9100     |  |:9100     |
+----------+  +----------+           +----------+  +----------+
```

## Features

- Central monitoring server for four Linux machines.
- Node Exporter metrics collection for Linux hosts.
- Prometheus scrape configuration using static targets.
- Grafana dashboard guidance for CPU, memory, disk, network, load, and uptime.
- Simple Bash health check automation with logs and warnings.
- Beginner-focused documentation suitable for interviews and resume discussion.

## Technologies Used

- Linux
- Bash
- systemd
- Prometheus
- Node Exporter
- Grafana
- PromQL

## Metrics Monitored

- CPU usage
- Memory usage
- Disk usage
- Network traffic
- System load
- Server uptime

## Setup Guide

> Replace example IP addresses with your own lab server IPs.

### 1. Install Node Exporter on Each Client Server

Run these steps on all four client servers.

```bash
sudo useradd --no-create-home --shell /usr/sbin/nologin node_exporter
cd /tmp
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
tar xvf node_exporter-1.8.2.linux-amd64.tar.gz
sudo cp node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```

Create the systemd service:

```bash
sudo cp configs/systemd/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable --now node_exporter
sudo systemctl status node_exporter
```

Confirm metrics are available:

```bash
curl http://localhost:9100/metrics
```

### 2. Install Prometheus on the Monitoring Server

```bash
sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
sudo mkdir -p /etc/prometheus /var/lib/prometheus
cd /tmp
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
tar xvf prometheus-2.53.1.linux-amd64.tar.gz
sudo cp prometheus-2.53.1.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.53.1.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.53.1.linux-amd64/consoles /etc/prometheus/
sudo cp -r prometheus-2.53.1.linux-amd64/console_libraries /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
```

### 3. Configure Prometheus

Copy this repository's Prometheus config:

```bash
sudo cp configs/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

Edit `/etc/prometheus/prometheus.yml` and replace these example targets with real client IP addresses:

```yaml
- "192.168.1.101:9100"
- "192.168.1.102:9100"
- "192.168.1.103:9100"
- "192.168.1.104:9100"
```

Install and start the Prometheus systemd service:

```bash
sudo cp configs/systemd/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable --now prometheus
sudo systemctl status prometheus
```

Open Prometheus in a browser:

```text
http://MONITORING_SERVER_IP:9090
```

Check targets:

```text
http://MONITORING_SERVER_IP:9090/targets
```

All four client targets should show `UP`.

### 4. Install Grafana on the Monitoring Server

On Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo systemctl enable --now grafana-server
sudo systemctl status grafana-server
```

Open Grafana:

```text
http://MONITORING_SERVER_IP:3000
```

Default login is usually `admin / admin`. Change the password when prompted.

### 5. Connect Grafana to Prometheus

1. Open Grafana.
2. Go to **Connections** → **Data sources**.
3. Select **Prometheus**.
4. Set URL to `http://localhost:9090` if Grafana and Prometheus run on the same server.
5. Click **Save & test**.

### 6. Import or Create Dashboards

Beginner option: import a community Node Exporter dashboard such as dashboard ID `1860` from Grafana dashboards.

Manual learning option: create your own dashboard using the panel guide below.

## Grafana Dashboard Guide

Recommended layout:

| Row | Panel | PromQL Query |
| --- | --- | --- |
| 1 | Server status | `up{job="linux-client-servers"}` |
| 1 | Uptime | `time() - node_boot_time_seconds{job="linux-client-servers"}` |
| 2 | CPU usage | `100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle",job="linux-client-servers"}[5m])) * 100)` |
| 2 | System load | `node_load1{job="linux-client-servers"}` |
| 3 | Memory usage | `(1 - (node_memory_MemAvailable_bytes{job="linux-client-servers"} / node_memory_MemTotal_bytes{job="linux-client-servers"})) * 100` |
| 3 | Disk usage | `(1 - (node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs",job="linux-client-servers"} / node_filesystem_size_bytes{mountpoint="/",fstype!="rootfs",job="linux-client-servers"})) * 100` |
| 4 | Network receive | `rate(node_network_receive_bytes_total{device!="lo",job="linux-client-servers"}[5m])` |
| 4 | Network transmit | `rate(node_network_transmit_bytes_total{device!="lo",job="linux-client-servers"}[5m])` |

Panel tips:

- Use **Time series** panels for CPU, memory, disk, network, and load.
- Use **Stat** panels for uptime and current server status.
- Set CPU, memory, and disk units to **Percent (0-100)**.
- Set network units to **bytes/sec**.
- Use thresholds such as green under 70%, yellow from 70-85%, and red above 85%.

## Beginner Automation: Health Check Script

Run the script locally on any Linux server:

```bash
chmod +x scripts/health_check.sh
./scripts/health_check.sh
```

The script checks CPU, memory, and disk usage, prints warnings when thresholds are exceeded, and writes output to `logs/health_check.log`.

## Screenshots

Add screenshots after you build the lab:

- `screenshots/prometheus-targets.png` - Prometheus targets showing four clients as `UP`.
- `screenshots/grafana-dashboard.png` - Grafana Linux fleet dashboard.
- `screenshots/health-check-output.png` - Bash script output.

## Resume Content

### 2-Line Description

Built a Linux Fleet Monitoring System to monitor four Linux servers from a central Prometheus and Grafana monitoring server. Implemented Node Exporter metrics collection and a Bash health check script for basic operational visibility.

### Resume Bullet Points

- Designed a beginner-friendly monitoring lab with one Prometheus/Grafana server scraping metrics from four Linux client servers.
- Configured Node Exporter and Prometheus static targets to collect CPU, memory, disk, network, load, and uptime metrics.
- Built Grafana dashboard guidance using PromQL queries to visualize Linux fleet health and troubleshoot resource usage.
- Developed a Bash health check script that logs CPU, memory, and disk usage and prints threshold-based warnings.

### Technologies Used

Linux, Bash, systemd, Prometheus, Node Exporter, Grafana, PromQL

## Future Enhancements

- Add email alerts using Prometheus Alertmanager.
- Add Slack alerts for critical server issues.
- Add a simple auto-healing script to restart a failed service.
- Add Docker Compose deployment for Prometheus and Grafana.
- Add backup and restore steps for Grafana dashboards.
- Add a troubleshooting runbook for common alerts.
