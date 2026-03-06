# AWS Nginx Docker Demo (Intern Level)

A very simple project to run an **Nginx web page in Docker** and host it on **AWS EC2**.

## Project structure

- `index.html` → static webpage served by Nginx
- `Dockerfile` → builds a custom Nginx image with your page
- `docker-compose.yml` → runs the container on port `8080`
- `deploy-ec2.sh` → helper script to deploy on Amazon Linux EC2

## Run locally

### Option 1: Docker Compose (recommended)

```bash
docker compose up -d --build
```

Open: `http://localhost:8080`

### Option 2: Docker only

```bash
docker build -t aws-nginx-demo .
docker run -d --name aws-nginx-demo -p 8080:80 aws-nginx-demo
```

Open: `http://localhost:8080`

## Deploy on AWS EC2 (simple way)

1. Launch an EC2 instance (Amazon Linux).
2. In Security Group, allow inbound TCP **8080** from your IP (or 0.0.0.0/0 for demo).
3. SSH into EC2.
4. Clone this repository:

   ```bash
   git clone <YOUR_REPO_URL> ~/aws-nginx-intern-project
   cd ~/aws-nginx-intern-project
   ```

5. Run deployment script:

   ```bash
   chmod +x deploy-ec2.sh
   ./deploy-ec2.sh
   ```

6. Visit:

   `http://<EC2_PUBLIC_IP>:8080`

## Useful commands

```bash
docker compose ps
docker compose logs -f
docker compose down
```

## Next improvements

- Add custom domain + HTTPS (ACM + Load Balancer)
- Push image to ECR
- Deploy with ECS Fargate instead of EC2


# My Linux Projects

# Linux System Monitoring Script (Bash)

## Overview

This project is a simple and practical Linux system monitoring tool built using Bash scripting. The purpose of this script is to continuously check important system metrics like CPU usage, memory consumption, disk space, system load, running services, and active processes.

Instead of manually checking system health, this script automates the monitoring process and logs useful information. It also alerts when system resources cross defined thresholds, helping detect potential issues early.

This project reflects real-world DevOps and Site Reliability Engineering (SRE) practices, where monitoring and automation are essential for maintaining reliable and stable systems.

---

## Features

This script helps monitor the overall health of a Linux system by:

- Checking CPU usage in real time  
- Monitoring memory utilization  
- Tracking disk space usage across mounted drives  
- Observing system load average  
- Verifying status of important services like SSH and Cron  
- Showing the top 5 processes consuming CPU and memory  
- Creating log files for system health tracking  
- Alerting when resource usage exceeds safe limits  
- Supporting automation through cron scheduling  

---

## Technologies Used

This project uses basic and powerful Linux tools:

- Bash scripting  
- Linux system utilities such as `top`, `ps`, `df`, `awk`, and `systemctl`  
- Cron for automating monitoring tasks  

---

## Project Structure


