# terraform-aws-webapp-cicd-demo

Fully automated web app deployment with Terraform, Docker Hub, AWS EC2, and GitHub Actions CI/CD.

```
git push main ─► GitHub Actions ─► docker build ─► Docker Hub (sajedul5/webapp-demo)
                                                        │
                                   ssh + deploy.sh ◄────┘
                                        │
                              EC2 (us-east-1, default VPC)
                              pull new image → stop/rm old container → run new on :8080
```

## Layout

| Path | What |
|------|------|
| `terraform/` | EC2 (Ubuntu 22.04) in the default VPC, security group for ports 22 and 8080, Docker installed via user data |
| `webapp/` | Single-page app (animated DevOps logo, success + chill emojis), nginx, `Dockerfile` |
| `scripts/deploy.sh` | Runs on EC2: pulls the new image, stops and removes the old container, starts the new one, health-checks it |
| `.github/workflows/cicd.yml` | On push to `main`: build → push to Docker Hub → SSH to EC2 → run `deploy.sh` |

## 1. Provision EC2 with Terraform

Prerequisites: AWS CLI profile `devops`, and an existing EC2 key pair named `devops-demo` in `us-east-1` (you hold `devops-demo.pem`).

```bash
cd terraform
terraform init
terraform apply
```

Outputs include `public_ip`, `app_url` and `ssh_command`. User data takes 1–2 minutes to install Docker. To check:

```bash
ssh -i devops-demo.pem ubuntu@<public_ip> "docker --version"
```

## 2. Add GitHub repository secrets

Settings → Secrets and variables → Actions → New repository secret:

| Secret | Value |
|--------|-------|
| `DOCKERHUB_USERNAME` | `sajedul5` |
| `DOCKERHUB_TOKEN` | Docker Hub access token (Account Settings → Personal access tokens, Read & Write) |
| `EC2_HOST` | `terraform output -raw public_ip` |
| `EC2_USER` | `ubuntu` |
| `EC2_SSH_KEY` | Full contents of `devops-demo.pem` |

With the GitHub CLI:

```bash
gh secret set DOCKERHUB_USERNAME -b sajedul5
gh secret set DOCKERHUB_TOKEN          # paste token
gh secret set EC2_HOST -b "$(terraform -chdir=terraform output -raw public_ip)"
gh secret set EC2_USER -b ubuntu
gh secret set EC2_SSH_KEY < ~/Downloads/devops-demo.pem
```

## 3. Deploy

Change anything in `webapp/` and push to `main`. The workflow builds `sajedul5/webapp-demo:latest` and `:<short-sha>`, pushes both, then deploys on EC2. Open `http://<public_ip>:8080`.

You can also run it by hand from the Actions tab (`workflow_dispatch`).

## Run locally

```bash
docker build -t webapp-demo ./webapp
docker run --rm -p 8080:80 webapp-demo
# http://localhost:8080
```

## Tear down

```bash
cd terraform && terraform destroy
```
