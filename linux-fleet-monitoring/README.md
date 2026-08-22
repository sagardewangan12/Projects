# Linux Fleet Monitoring with Prometheus and Grafana

Beginner-friendly monitoring project for a fleet of 10 Linux servers using **Prometheus**, **Node Exporter**, **Grafana**, **systemd services**, and **SMTP email alerting**. It does not use Docker, Kubernetes, Terraform, Ansible, cloud services, or custom application code.

## What This Monitors

- CPU usage
- Memory usage
- Disk usage
- System availability, meaning up or down
- Network traffic
- Load average
- Uptime

## Architecture

```text
+-------------------+       scrape :9100        +------------------------+
| linux-node-01     | <------------------------ |                        |
| Node Exporter     |                           |                        |
+-------------------+                           |                        |
        ...                                     | Prometheus Server      |
+-------------------+       scrape :9100        | localhost:9090         |
| linux-node-10     | <------------------------ |                        |
| Node Exporter     |                           +-----------+------------+
+-------------------+                                       |
                                                            | Prometheus data source
                                                            v
                                                +-----------+------------+
                                                | Grafana localhost:3000 |
                                                | Dashboard + Alerting   |
                                                +-----------+------------+
                                                            |
                                                            | SMTP email
                                                            v
                                                sdewangan12032@gmail.com
```

Node Exporter runs on every Linux server and exposes machine metrics on port `9100`. Prometheus runs on the monitoring server and pulls those metrics. Grafana reads metrics from Prometheus, displays the **Linux Fleet Overview** dashboard, and sends email alerts when CPU usage is too high.

## Repository Structure

```text
linux-fleet-monitoring/
├── README.md
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   ├── grafana.ini.example
│   ├── provisioning/
│   │   ├── datasources/
│   │   ├── dashboards/
│   │   └── alerting/
│   └── dashboards/
└── screenshots/
```

## Example Fleet

The included Prometheus configuration monitors these example hosts:

| Hostname | IP address | Node Exporter target |
|---|---:|---|
| linux-node-01 | 192.168.10.11 | 192.168.10.11:9100 |
| linux-node-02 | 192.168.10.12 | 192.168.10.12:9100 |
| linux-node-03 | 192.168.10.13 | 192.168.10.13:9100 |
| linux-node-04 | 192.168.10.14 | 192.168.10.14:9100 |
| linux-node-05 | 192.168.10.15 | 192.168.10.15:9100 |
| linux-node-06 | 192.168.10.16 | 192.168.10.16:9100 |
| linux-node-07 | 192.168.10.17 | 192.168.10.17:9100 |
| linux-node-08 | 192.168.10.18 | 192.168.10.18:9100 |
| linux-node-09 | 192.168.10.19 | 192.168.10.19:9100 |
| linux-node-10 | 192.168.10.20 | 192.168.10.20:9100 |

Replace these IP addresses with your real server IP addresses.

## Install Node Exporter on Each Linux Server

Run these commands on all 10 Linux hosts. The package name is available in Ubuntu/Debian repositories.

```bash
sudo apt update
sudo apt install -y prometheus-node-exporter
sudo systemctl enable --now prometheus-node-exporter
sudo systemctl status prometheus-node-exporter
```

Confirm Node Exporter is listening:

```bash
curl http://localhost:9100/metrics | head
```

If you use UFW, allow Prometheus to reach port `9100`:

```bash
sudo ufw allow from PROMETHEUS_SERVER_IP to any port 9100 proto tcp
```

## Install Prometheus on the Monitoring Server

Run these commands on the monitoring server.

```bash
sudo apt update
sudo apt install -y prometheus
sudo cp prometheus/prometheus.yml /etc/prometheus/prometheus.yml
sudo prometheus --config.file=/etc/prometheus/prometheus.yml --web.listen-address=127.0.0.1:9091 --storage.tsdb.path=/tmp/prometheus-check --web.enable-lifecycle &
sleep 3
curl http://127.0.0.1:9091/-/ready
sudo pkill -f 'prometheus --config.file=/etc/prometheus/prometheus.yml --web.listen-address=127.0.0.1:9091' || true
sudo systemctl restart prometheus
sudo systemctl enable prometheus
```

Open Prometheus in a browser:

```text
http://PROMETHEUS_SERVER_IP:9090
```

Go to **Status > Targets** and confirm each `linux-fleet` target is `UP`.

## Add More Servers Later

1. Install Node Exporter on the new Linux server.
2. Open `/etc/prometheus/prometheus.yml` on the Prometheus server.
3. Copy the commented example block at the bottom of `prometheus/prometheus.yml`.
4. Change the IP address and `hostname` label.
5. Restart Prometheus:

```bash
sudo systemctl restart prometheus
```

## Install Grafana on Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y apt-transport-https software-properties-common wget gpg
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable --now grafana-server
```

Open Grafana:

```text
http://PROMETHEUS_SERVER_IP:3000
```

Default first login is usually `admin` / `admin`. Change the password immediately.

## Provision Grafana Data Source, Dashboard, and Alerts

Copy provisioning files:

```bash
sudo cp grafana/provisioning/datasources/prometheus.yml /etc/grafana/provisioning/datasources/prometheus.yml
sudo cp grafana/provisioning/dashboards/linux-fleet-overview.yml /etc/grafana/provisioning/dashboards/linux-fleet-overview.yml
sudo mkdir -p /var/lib/grafana/dashboards
sudo cp grafana/dashboards/linux-fleet-overview.json /var/lib/grafana/dashboards/linux-fleet-overview.json
sudo cp grafana/provisioning/alerting/*.yml /etc/grafana/provisioning/alerting/
sudo chown -R grafana:grafana /var/lib/grafana/dashboards
sudo systemctl restart grafana-server
```

The dashboard is named **Linux Fleet Overview** and includes:

1. Fleet Health Summary
2. Online vs Offline Servers
3. CPU Usage by Host
4. Memory Usage by Host
5. Disk Usage by Host
6. Network Traffic by Host
7. Load Average by Host
8. Top 5 Highest CPU Hosts
9. Top 5 Highest Memory Hosts

An extra uptime panel is included because uptime is part of the monitoring requirements.

## Manual Dashboard Import Option

If you do not want provisioning, import the JSON manually:

1. Open Grafana.
2. Go to **Dashboards > New > Import**.
3. Upload `grafana/dashboards/linux-fleet-overview.json`.
4. Select the Prometheus data source.
5. Click **Import**.

## Configure SMTP Email Alerting

Use `grafana/grafana.ini.example` as a safe template. Edit `/etc/grafana/grafana.ini` and configure SMTP with real values outside Git:

```ini
[smtp]
enabled = true
host = SMTP_HOST:SMTP_PORT
user = SMTP_USER
password = SMTP_PASSWORD
from_address = grafana-alerts@example.com
from_name = Linux Fleet Monitoring
```

Restart Grafana after changing SMTP settings:

```bash
sudo systemctl restart grafana-server
```

The provisioned contact point sends alerts to:

```text
sdewangan12032@gmail.com
```

## Alert Rule

Grafana Unified Alerting is configured with this rule:

- Alert Name: **Linux Host CPU Usage Above 80%**
- Threshold: CPU usage greater than `80%`
- Evaluation Period: `5 minutes`
- Severity: `critical`
- Notification: email contact point

## Test Alerts

Use one test host and temporarily generate CPU load for more than 5 minutes:

```bash
sudo apt install -y stress-ng
stress-ng --cpu 2 --timeout 360s
```

Then open Grafana:

1. Go to **Alerting > Alert rules**.
2. Open **Linux Host CPU Usage Above 80%**.
3. Confirm the rule changes to `Firing` after the evaluation period.
4. Check the recipient inbox and spam folder.

Stop the load test if needed:

```bash
pkill stress-ng || true
```

## Useful PromQL Queries

```promql
up{job="linux-fleet"}
100 * (1 - avg by (hostname) (rate(node_cpu_seconds_total{job="linux-fleet",mode="idle"}[5m])))
100 * (1 - (node_memory_MemAvailable_bytes{job="linux-fleet"} / node_memory_MemTotal_bytes{job="linux-fleet"}))
node_load1{job="linux-fleet"}
node_time_seconds{job="linux-fleet"} - node_boot_time_seconds{job="linux-fleet"}
```

## Troubleshooting

### Prometheus target is down

Check Node Exporter on the target server:

```bash
sudo systemctl status prometheus-node-exporter
curl http://TARGET_SERVER_IP:9100/metrics | head
```

Check firewall rules:

```bash
sudo ufw status
```

### Grafana dashboard has no data

Confirm the Prometheus data source URL is reachable from Grafana server:

```bash
curl http://localhost:9090/-/ready
```

Confirm Prometheus has targets:

```bash
curl http://localhost:9090/api/v1/targets | head
```

### Email alerts are not delivered

Check Grafana logs:

```bash
sudo journalctl -u grafana-server -n 100 --no-pager
```

Verify SMTP host, port, username, password, sender address, TLS settings, and spam folder. Keep credentials outside Git.

### CPU alert does not fire

The CPU alert requires CPU usage above 80% for 5 continuous minutes. Confirm the PromQL query returns values above 80 and that the alert rule is enabled.

## Security Notes

- Do not expose Node Exporter directly to the internet.
- Restrict port `9100` to the Prometheus server.
- Do not commit real SMTP credentials.
- Change the default Grafana admin password immediately.
