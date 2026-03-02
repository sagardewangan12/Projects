# Linux User Management (Docker + Bash)

Simple containerized project that demonstrates basic Linux user management commands inside an Ubuntu Docker container.

## Features
- Add user (checks for duplicate)
- Delete user
- Add user to group (creates group if missing)
- List all users

## Files
- `user_mgmt.sh` — main interactive bash script
- `Dockerfile` — builds the Ubuntu image with required tools
- `README.md` — this file

## How to build & run (local)
1. Build the Docker image:
   ```bash
   docker build -t user-mgmt .
