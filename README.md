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
