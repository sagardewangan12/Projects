# Linux Fleet Monitoring System

A beginner-friendly SRE / DevOps portfolio project that demonstrates centralized Linux monitoring using Prometheus, Grafana, Node Exporter, and Docker Compose.

The project monitors four simulated Linux nodes from a central monitoring stack and visualizes system health metrics such as CPU, memory, disk, network traffic, load, and uptime.

This project focuses on practical observability concepts while keeping the architecture simple enough for freshers to understand, build, and explain during interviews.

---

## Architecture

```text
                     +----------------------+
                     |      Prometheus      |
                     |        :9090         |
                     +----------+-----------+
                                |
                                |
         -------------------------------------------------
         |                |              |               |
         |                |              |               |
    +----v----+      +----v----+    +----v----+     +----v----+
    |  node1  |      |  node2  |    |  node3  |     |  node4  |
    | Exporter|      | Exporter|    | Exporter|     | Exporter|
    +---------+      +---------+    +---------+     +---------+

                                |
                                |
                     +----------v-----------+
                     |       Grafana        |
                     |        :3000         |
                     +----------------------+
```

---

## Project Structure

```text
linux-fleet-monitoring-system/
├── README.md
├── configs/
│   ├── prometheus.yml
│   └── systemd/
│       ├── node_exporter.service
│       └── prometheus.service
├── docker/
│   └── docker-compose.yml
├── logs/
│   └── .gitkeep
├── screenshots/
│   └── .gitkeep
├── scripts/
│   └── health_check.sh
└── .gitignore
```

---

## Features

- Centralized monitoring using Prometheus.
- Grafana dashboards for infrastructure visibility.
- Four monitored Linux nodes simulated using Docker containers.
- CPU, memory, disk, network, load, and uptime monitoring.
- Beginner-friendly Bash health check automation.
- Docker Compose deployment.
- PromQL-based dashboard visualization.
- Practical observability project suitable for DevOps, SRE, and Platform Engineering interviews.

---

## Technologies Used

- Linux
- Docker
- Docker Compose
- Prometheus
- Grafana
- Node Exporter
- Bash
- systemd
- PromQL

---

## Metrics Monitored

- CPU Usage
- Memory Usage
- Disk Usage
- Network Traffic
- System Load
- Server Uptime

---

# Docker-Based Lab Setup

This project uses Docker Compose to create a lightweight monitoring lab.

The four monitored nodes are simulated using Node Exporter containers.

## Prerequisites

Verify Docker is installed:

```bash
docker --version
docker compose version
```

Example:

```text
Docker version 28.x
Docker Compose version v2.x
```

---

## Start the Monitoring Stack

Navigate to the docker directory:

```bash
cd docker
```

Start all services:

```bash
docker compose up -d
```

Verify containers:

```bash
docker ps
```

Expected containers:

```text
prometheus
grafana
node1
node2
node3
node4
```

---

## Prometheus Configuration

Prometheus configuration is stored in:

```text
configs/prometheus.yml
```

Prometheus scrapes metrics from:

```yaml
node1:9100
node2:9100
node3:9100
node4:9100
```

Verify Prometheus is running:

```text
http://localhost:9090
```

Verify scrape targets:

```text
http://localhost:9090/targets
```

Expected:

```text
node1 = UP
node2 = UP
node3 = UP
node4 = UP
```

---

## Grafana Setup

Open Grafana:

```text
http://localhost:3000
```

Default credentials:

```text
Username: admin
Password: admin
```

Change the password when prompted.

---

## Add Prometheus Data Source

1. Open Grafana.
2. Navigate to Connections → Data Sources.
3. Select Prometheus.
4. Configure URL:

```text
http://prometheus:9090
```

5. Click Save & Test.

Expected:

```text
Data source is working
```

---

## Import Dashboard

Import Grafana Dashboard ID:

```text
1860
```

Dashboard Name:

```text
Node Exporter Full
```

This dashboard provides:

- CPU Utilization
- Memory Usage
- Disk Usage
- Filesystem Statistics
- Network Throughput
- Load Average
- Uptime

---

## Useful PromQL Queries

### Server Status

```promql
up
```

### CPU Usage

```promql
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Memory Usage

```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

### Disk Usage

```promql
(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100
```

### System Load

```promql
node_load1
```

### Network Receive

```promql
rate(node_network_receive_bytes_total{device!="lo"}[5m])
```

### Network Transmit

```promql
rate(node_network_transmit_bytes_total{device!="lo"}[5m])
```

---

# Health Check Automation

The project includes a Bash health monitoring script.

Location:

```text
scripts/health_check.sh
```

Run:

```bash
chmod +x scripts/health_check.sh
./scripts/health_check.sh
```

The script checks:

- CPU Usage
- Memory Usage
- Disk Usage

The script writes logs to:

```text
logs/health_check.log
```

---

## Example Output

```text
========================================
Health Check Time: Thu Aug 14 12:10:01
Hostname: node1
========================================

CPU Usage: 12%
Memory Usage: 45%
Disk Usage on /: 28%

Health check completed.
```

---

## Screenshots

### Prometheus Targets

![Prometheus Targets](screenshots/prometheus-targets.png)

### Grafana Dashboard

![Grafana Dashboard](screenshots/grafana-dashboard.png)

### Prometheus Query

![Prometheus Query](screenshots/prometheus-query-up.png)

### Health Check Script

![Health Check Script](screenshots/health-check-output.png)

---

# Resume Description

Built a Linux Fleet Monitoring System using Prometheus, Grafana, Node Exporter, Docker Compose, and Bash to monitor infrastructure metrics across four simulated Linux nodes.

Implemented centralized observability dashboards, PromQL-based monitoring, and automated health checks to gain hands-on experience with monitoring and operational troubleshooting.

---

## Resume Bullet Points

- Designed and deployed a centralized monitoring solution using Prometheus and Grafana for four simulated Linux nodes.
- Configured Node Exporter metrics collection and Prometheus scraping to monitor CPU, memory, disk, network, load, and uptime metrics.
- Developed Grafana dashboards and PromQL queries to visualize infrastructure health and troubleshoot performance issues.
- Created a Bash-based health check utility that logs system resource usage and generates threshold-based warnings.

---

## Future Enhancements

- Prometheus Alertmanager integration.
- Email notifications for critical alerts.
- Slack alert integration.
- Service auto-healing and automatic restarts.
- Docker volume persistence.
- Grafana dashboard backup automation.
- Monitoring additional Linux services.
- Container health monitoring dashboards.

---

## Learning Outcomes

After completing this project, you should understand:

- Linux monitoring fundamentals.
- Prometheus architecture and scraping.
- Node Exporter metrics collection.
- Grafana dashboard creation.
- PromQL basics.
- Docker Compose deployments.
- Bash scripting for operational tasks.
- Observability concepts used in SRE and DevOps environments.

---

## Author

Sagar Dewangan

DevOps | Cloud | SRE | Platform Engineering Enthusiast
