# Static Website Roadmap: Portfolio & E-Commerce Store

## Project Overview

This roadmap outlines the complete setup and configuration of a modern JAMstack website ecosystem for **Daniel Tarazona's** personal brand, combining a portfolio/photo gallery site with a headless e-commerce store.

### Target Domains

| Domain | Purpose | Technology |
|--------|---------|------------|
| `danieltarazona.com` | Main portfolio site with photo gallery, about page, and contact form | Astro (Static Site Generator) |
| `store.danieltarazona.com` | E-commerce store (limited to 100 products) | Astro Storefront + Medusa 2.0 Backend |

### High-Level Goals

1. **Performance First**: Achieve 90+ Lighthouse scores across all pages with static-first architecture
2. **Cost Efficiency**: Maximize free tier usage (Cloudflare, Supabase) while maintaining production quality
3. **Developer Experience**: Streamlined local development with hot reload and type safety
4. **Scalability**: Architecture that supports future multi-site expansion (Adam Robotics, Adam Automotive, Adam Defense)
5. **Self-Hosted Control**: Full ownership of e-commerce data via Medusa 2.0 on self-hosted infrastructure
6. **Security**: Zero exposed ports via Cloudflare Tunnel, encrypted data at rest and in transit

### Architecture Summary

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              CLOUDFLARE EDGE                                    │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  DNS + CDN + SSL/TLS + DDoS Protection + Web Application Firewall       │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│           │                                           │                         │
│           ▼                                           ▼                         │
│  ┌─────────────────────┐                   ┌─────────────────────┐             │
│  │ danieltarazona.com  │                   │ store.danieltarazona│             │
│  │   (Astro Static)    │                   │   (Astro + Medusa)  │             │
│  └─────────────────────┘                   └─────────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────────┘
                    │                                           │
                    ▼                                           ▼
         ┌─────────────────────┐                   ┌─────────────────────┐
         │  Cloudflare Pages   │                   │  Cloudflare Tunnel  │
         │  (Static Hosting)   │                   │  (Secure Ingress)   │
         └─────────────────────┘                   └─────────────────────┘
                                                              │
                                                              ▼
                                              ┌───────────────────────────────┐
                                              │         VPS (Coolify)         │
                                              │  ┌─────────────────────────┐  │
                                              │  │     Medusa 2.0 API      │  │
                                              │  │  (Headless Commerce)    │  │
                                              │  └───────────┬─────────────┘  │
                                              │              │                │
                                              │              ▼                │
                                              │  ┌─────────────────────────┐  │
                                              │  │   PostgreSQL Database   │  │
                                              │  │   (Supabase / Local)    │  │
                                              │  └─────────────────────────┘  │
                                              └───────────────────────────────┘
```

### Service Connection Flow

The following diagram illustrates how data flows between services in the architecture:

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           SERVICE CONNECTION ARCHITECTURE                                │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────┐
                              │   End Users     │
                              │   (Browsers)    │
                              └────────┬────────┘
                                       │ HTTPS Requests
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              CLOUDFLARE CDN LAYER                                        │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │  • Global Edge Network (300+ PoPs)                                                 │  │
│  │  • SSL/TLS Termination                                                             │  │
│  │  • DDoS Protection & WAF                                                           │  │
│  │  • Asset Caching & Optimization                                                    │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
│                    │                                           │                         │
│          Static Assets                              Dynamic API Requests                 │
│                    ▼                                           ▼                         │
│     ┌──────────────────────────┐                ┌──────────────────────────┐            │
│     │    Cloudflare Pages      │                │    Cloudflare Tunnel     │            │
│     │  (Edge Static Hosting)   │                │   (Zero Trust Ingress)   │            │
│     └──────────────────────────┘                └────────────┬─────────────┘            │
└─────────────────────────────────────────────────────────────┼───────────────────────────┘
                    ▲                                          │
                    │                                          │ Secure Tunnel
      ┌─────────────┴─────────────┐                           │ (No Open Ports)
      │                           │                            ▼
┌─────┴─────┐             ┌───────┴───────┐     ┌─────────────────────────────────────────┐
│  ASTRO    │             │    ASTRO      │     │              VPS (COOLIFY)              │
│ PORTFOLIO │             │  STOREFRONT   │     │  ┌─────────────────────────────────┐    │
│   SITE    │             │               │     │  │         MEDUSA 2.0 API          │    │
├───────────┤             ├───────────────┤     │  │  ┌───────────────────────────┐  │    │
│ • Gallery │             │ • Product     │────▶│  │  │   REST API Endpoints      │  │    │
│ • About   │             │   Catalog     │     │  │  │   /store/* (storefront)   │  │    │
│ • Contact │             │ • Cart        │     │  │  │   /admin/* (dashboard)    │  │    │
│ • Blog    │             │ • Checkout    │     │  │  └───────────────────────────┘  │    │
└───────────┘             └───────────────┘     │  │              │                  │    │
      │                                         │  │              │ Database Queries │    │
      │ Contact Form                            │  │              ▼                  │    │
      │ Submissions                             │  │  ┌───────────────────────────┐  │    │
      │                                         │  │  │    Medusa ORM Layer       │  │    │
      ▼                                         │  │  │    (MikroORM/TypeORM)     │  │    │
┌─────────────────────────────────────┐         │  │  └───────────────────────────┘  │    │
│         SUPABASE (MANAGED)          │         │  └─────────────────────────────────┘    │
│  ┌───────────────────────────────┐  │         │                 │                       │
│  │   PostgreSQL Database         │  │         │                 │ Connection String     │
│  │   • contact_submissions       │  │         │                 │ (DATABASE_URL)        │
│  │   • newsletter_signups        │  │         │                 ▼                       │
│  │   • analytics_events          │  │         │  ┌─────────────────────────────────┐    │
│  └───────────────────────────────┘  │         │  │   PostgreSQL (Local/Supabase)  │    │
│  ┌───────────────────────────────┐  │         │  │   • products                   │    │
│  │   Supabase Edge Functions     │  │         │  │   • orders                     │    │
│  │   • Form validation           │  │         │  │   • customers                  │    │
│  │   • Email notifications       │  │         │  │   • inventory                  │    │
│  └───────────────────────────────┘  │         │  │   • payments                   │    │
└─────────────────────────────────────┘         │  └─────────────────────────────────┘    │
                                                └─────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW SUMMARY                                           │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                          │
│  PORTFOLIO SITE FLOW:                                                                   │
│  User ──▶ Cloudflare CDN ──▶ Cloudflare Pages ──▶ Static HTML/CSS/JS                   │
│                                       │                                                  │
│                                       └──▶ Contact Form ──▶ Supabase PostgreSQL         │
│                                                                                          │
│  E-COMMERCE STORE FLOW:                                                                 │
│  User ──▶ Cloudflare CDN ──▶ Astro Storefront ──▶ Medusa API ──▶ PostgreSQL            │
│                    │                                    │                                │
│                    └──▶ Cached Assets                   └──▶ Orders, Products, Cart     │
│                                                                                          │
│  ADMIN DASHBOARD FLOW:                                                                  │
│  Admin ──▶ Cloudflare Tunnel ──▶ Medusa Admin UI ──▶ Medusa API ──▶ PostgreSQL         │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              CONNECTION PROTOCOLS                                        │
├──────────────────┬──────────────────────────────────────────────────────────────────────┤
│ Connection       │ Protocol / Port                                                      │
├──────────────────┼──────────────────────────────────────────────────────────────────────┤
│ User → CDN       │ HTTPS (443) with TLS 1.3                                             │
│ CDN → Pages      │ Internal Cloudflare routing                                          │
│ CDN → Tunnel     │ Cloudflare Tunnel (outbound only, no open ports)                    │
│ Tunnel → Medusa  │ HTTP (9000) internal to VPS                                          │
│ Medusa → DB      │ PostgreSQL (5432) via connection pooling                             │
│ Astro → Supabase │ HTTPS REST API + WebSocket for Realtime                             │
└──────────────────┴──────────────────────────────────────────────────────────────────────┘
```

### Key Features

- **Portfolio Site** (`danieltarazona.com`)
  - [ ] Responsive photo gallery with optimized images
  - [ ] About/Bio page with professional information
  - [ ] Contact form with PostgreSQL persistence
  - [ ] SEO-optimized pages with meta tags
  - [ ] RSS feed for updates

- **E-Commerce Store** (`store.danieltarazona.com`)
  - [ ] Product catalog (max 100 products)
  - [ ] Shopping cart functionality
  - [ ] Secure checkout flow
  - [ ] Order management
  - [ ] Inventory tracking

### Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Page Load Time | < 2 seconds | Lighthouse Performance |
| Lighthouse Score | > 90 | All categories |
| Uptime | 99.9% | Cloudflare Analytics |
| Monthly Cost | < $10 | VPS + Domain only |
| Time to Deploy | < 5 minutes | GitHub Actions |

---

## Technology Stack

This project leverages a modern JAMstack architecture with carefully selected services optimized for performance, cost efficiency, and developer experience.

### Services Overview

| Service | Purpose | Category | Free Tier | CLI Tool | Installation |
|---------|---------|----------|-----------|----------|--------------|
| **Astro** | Static site generator for portfolio and store frontend | Frontend | ✅ Yes (Open Source) | `astro` | `npm create astro@latest` |
| **Cloudflare** | DNS, CDN, SSL/TLS, Workers, Pages, Tunnel | Infrastructure | ✅ Yes (Generous) | `wrangler` | `npm install -g wrangler` |
| **Medusa 2.0** | Headless e-commerce backend with admin dashboard | E-Commerce | ✅ Self-hosted (Open Source) | `medusa` | `npm install -g @medusajs/medusa-cli` |
| **Coolify** | Self-hosting platform for deployment orchestration | Deployment | ✅ Self-hosted (Open Source) | `coolify` | Docker-based installation |
| **Supabase** | PostgreSQL database with auth and realtime | Database/BaaS | ✅ Yes (500MB, 50K MAU) | `supabase` | `npm install -g supabase` |
| **Nhost** | Backend-as-a-Service (alternative to Supabase) | Database/BaaS | ✅ Yes (Limited) | `nhost` | `npm install -g nhost` |
| **Deno** | Modern JavaScript/TypeScript runtime for serverless | Runtime | ✅ Yes (Open Source) | `deno` | `curl -fsSL https://deno.land/install.sh \| sh` |

### Service Details

#### Astro (Frontend Framework)
- **Version**: 4.x (latest stable)
- **Key Features**: Islands architecture, zero JS by default, MDX support, image optimization
- **Use Case**: Static HTML generation for portfolio and store storefront
- **Documentation**: https://docs.astro.build

```bash
# Create new Astro project
npm create astro@latest -- --template minimal

# Start development server
npm run dev

# Build for production
npm run build
```

#### Cloudflare (Infrastructure Layer)
- **Products Used**: DNS, CDN, Pages, Workers, Tunnel, WAF
- **Free Tier Limits**:
  - Pages: Unlimited sites, 500 builds/month
  - Workers: 100K requests/day
  - Tunnel: Unlimited tunnels
- **Documentation**: https://developers.cloudflare.com

```bash
# Install Wrangler CLI
npm install -g wrangler

# Authenticate with Cloudflare
wrangler login

# Deploy to Cloudflare Pages
wrangler pages deploy ./dist
```

#### Medusa 2.0 (Headless Commerce)
- **Version**: 2.x (latest stable)
- **Key Features**: Modular architecture, TypeScript, PostgreSQL, admin dashboard
- **Use Case**: Product management, orders, inventory for store.danieltarazona.com
- **Scope Limit**: 100 products maximum
- **Documentation**: https://docs.medusajs.com

```bash
# Install Medusa CLI
npm install -g @medusajs/medusa-cli

# Create new Medusa project
medusa new my-store

# Start development server
cd my-store && medusa develop
```

#### Coolify (Self-Hosting Platform)
- **Version**: 4.x (latest stable)
- **Key Features**: Docker-based, Git integration, SSL automation, resource monitoring
- **Use Case**: Deploy and manage Medusa backend on VPS
- **Requirements**: 2GB RAM minimum, Docker
- **Documentation**: https://coolify.io/docs

```bash
# Install Coolify on VPS (requires root)
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

# Access dashboard at https://your-server-ip:8000
```

#### Supabase (Database & BaaS)
- **Version**: Latest (managed service)
- **Key Features**: PostgreSQL, Row Level Security, Auth, Realtime, Edge Functions
- **Use Case**: Contact form persistence, user data storage
- **Free Tier**: 500MB database, 1GB file storage, 50K monthly active users
- **Documentation**: https://supabase.com/docs

```bash
# Install Supabase CLI
npm install -g supabase

# Login to Supabase
supabase login

# Initialize local development
supabase init

# Start local Supabase stack
supabase start
```

#### Nhost (Alternative BaaS)
- **Version**: Latest (managed service)
- **Key Features**: PostgreSQL + Hasura GraphQL, Auth, Storage, Functions
- **Use Case**: Alternative to Supabase with GraphQL-first approach
- **Free Tier**: 1GB database, 1GB storage, limited compute
- **Documentation**: https://docs.nhost.io

```bash
# Install Nhost CLI
npm install -g nhost

# Login to Nhost
nhost login

# Initialize project
nhost init

# Start local development
nhost up
```

#### Deno (JavaScript Runtime)
- **Version**: 2.x (latest stable)
- **Key Features**: Secure by default, TypeScript native, Web API compatible, Deno Deploy
- **Use Case**: Serverless functions, scripts, edge computing
- **Documentation**: https://docs.deno.com

```bash
# Install Deno
curl -fsSL https://deno.land/install.sh | sh

# Run a script
deno run --allow-net server.ts

# Deploy to Deno Deploy
deployctl deploy --project=my-project main.ts
```

### Required Development Tools

| Tool | Minimum Version | Purpose | Check Command |
|------|-----------------|---------|---------------|
| Node.js | v18.0.0+ | JavaScript runtime for build tools | `node --version` |
| npm | v9.0.0+ | Package manager | `npm --version` |
| Git | v2.30.0+ | Version control | `git --version` |
| Docker | v24.0.0+ | Container runtime for Coolify/Medusa | `docker --version` |
| Deno | v2.0.0+ | Alternative runtime for serverless | `deno --version` |

### Quick Setup Script

```bash
#!/bin/bash
# install-dev-tools.sh - Install all required CLI tools

# Node.js (via nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18

# Cloudflare Wrangler
npm install -g wrangler

# Medusa CLI
npm install -g @medusajs/medusa-cli

# Supabase CLI
npm install -g supabase

# Nhost CLI
npm install -g nhost

# Deno
curl -fsSL https://deno.land/install.sh | sh

# Verify installations
echo "Verifying installations..."
node --version
wrangler --version
medusa --version
supabase --version
nhost --version
deno --version
```

---

## Phase 1: Infrastructure & DNS Setup

This phase covers selecting and provisioning the VPS hosting, configuring DNS, and setting up secure tunnels for self-hosted services.

### VPS Hosting Options

Running Coolify + Medusa 2.0 requires a VPS with adequate resources. Below is a comparison of paid (Hetzner Cloud) and free alternatives.

#### Minimum Requirements for Coolify + Medusa

| Resource | Minimum | Recommended | Notes |
|----------|---------|-------------|-------|
| **RAM** | 2 GB | 4 GB | Coolify uses ~1GB, Medusa + PostgreSQL need ~1GB+ |
| **CPU** | 2 vCPU | 4 vCPU | Build processes are CPU-intensive |
| **Storage** | 40 GB SSD | 80 GB SSD | Docker images, database, logs grow over time |
| **Bandwidth** | 1 TB/month | 5 TB/month | Product images and API traffic |
| **OS** | Ubuntu 22.04+ | Ubuntu 24.04 LTS | Debian-based preferred for Docker |

#### Hetzner Cloud (Recommended Paid Option)

Hetzner offers excellent price-to-performance ratio with European and US datacenters.

| Plan | vCPU | RAM | Storage | Bandwidth | Monthly Cost | Best For |
|------|------|-----|---------|-----------|--------------|----------|
| **CX22** | 2 | 4 GB | 40 GB | 20 TB | **€4.35** (~$4.75) | Minimum viable setup |
| **CX32** | 4 | 8 GB | 80 GB | 20 TB | **€8.25** (~$9.00) | Production recommended |
| **CX42** | 8 | 16 GB | 160 GB | 20 TB | **€15.55** (~$17.00) | Multi-site hosting |

**Hetzner Advantages:**
- ✅ Excellent price-to-performance (best value in market)
- ✅ 20 TB bandwidth included (more than enough)
- ✅ ISO 27001 certified datacenters
- ✅ Hourly billing (pay only for what you use)
- ✅ Native IPv6 support
- ✅ Snapshots and backups available

**Setup Commands:**
```bash
# Install Hetzner CLI (hcloud)
brew install hcloud  # macOS
# Or download from https://github.com/hetznercloud/cli

# Create SSH key
hcloud ssh-key create --name my-key --public-key-from-file ~/.ssh/id_rsa.pub

# Create server
hcloud server create \
  --name medusa-server \
  --type cx32 \
  --image ubuntu-24.04 \
  --ssh-key my-key \
  --location nbg1  # Nuremberg datacenter

# List available locations
hcloud location list
# nbg1 (Nuremberg), fsn1 (Falkenstein), hel1 (Helsinki), ash (Ashburn, VA)
```

#### Free VPS Alternatives

For development/testing or budget-constrained production, these free tier options can work:

##### Oracle Cloud Free Tier (Best Free Option)

Oracle Cloud offers the most generous always-free tier for VPS hosting.

| Resource | Free Allocation | Notes |
|----------|-----------------|-------|
| **ARM VM** | 4 OCPU, 24 GB RAM | Ampere A1 (up to 4 instances sharing resources) |
| **AMD VM** | 1/8 OCPU, 1 GB RAM | 2 instances (too small for Coolify) |
| **Storage** | 200 GB block storage | Combined across instances |
| **Bandwidth** | 10 TB/month | Outbound data transfer |

**Recommended Setup:**
```
┌─────────────────────────────────────┐
│      Oracle ARM Instance            │
│  2 OCPU / 12 GB RAM / 100 GB        │
│  ┌─────────────────────────────────┐│
│  │ Coolify + Medusa + PostgreSQL  ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

**Pros:**
- ✅ Generous ARM instances (24 GB RAM total!)
- ✅ Always free (no credit card charge after trial)
- ✅ 200 GB free block storage
- ✅ Good network performance

**Cons:**
- ⚠️ ARM architecture requires compatible Docker images
- ⚠️ Instance creation can be difficult (capacity issues)
- ⚠️ Limited datacenter availability
- ⚠️ Account may be terminated for inactivity

**Setup Commands:**
```bash
# Install OCI CLI
brew install oci-cli  # macOS
# Or: pip install oci-cli

# Configure OCI CLI
oci setup config

# Create ARM instance (requires tenancy, compartment, subnet IDs)
oci compute instance launch \
  --availability-domain "AD-1" \
  --compartment-id $COMPARTMENT_ID \
  --shape "VM.Standard.A1.Flex" \
  --shape-config '{"ocpus": 2, "memoryInGBs": 12}' \
  --image-id $UBUNTU_ARM_IMAGE_ID \
  --subnet-id $SUBNET_ID \
  --ssh-authorized-keys-file ~/.ssh/id_rsa.pub
```

##### Google Cloud Free Tier

Google Cloud offers a limited but reliable free tier for e2-micro instances.

| Resource | Free Allocation | Notes |
|----------|-----------------|-------|
| **VM** | e2-micro (0.25 vCPU, 1 GB RAM) | 1 instance in us-west1, us-central1, or us-east1 |
| **Storage** | 30 GB HDD | Standard persistent disk |
| **Bandwidth** | 1 GB/month to most regions | Network egress |

**Verdict:** ❌ **Not recommended** - e2-micro is too small for Coolify + Medusa

**Potential Use:** Could host only a lightweight PostgreSQL database while Medusa runs elsewhere.

```bash
# Create free tier instance (reference only - too small for this project)
gcloud compute instances create medusa-db \
  --machine-type=e2-micro \
  --zone=us-central1-a \
  --image-project=ubuntu-os-cloud \
  --image-family=ubuntu-2404-lts-amd64 \
  --boot-disk-size=30GB
```

##### Azure Free Tier

Azure offers limited free compute for 12 months, then pay-as-you-go.

| Resource | Free Allocation | Duration |
|----------|-----------------|----------|
| **VM** | B1s (1 vCPU, 1 GB RAM) | 750 hours/month for 12 months |
| **Storage** | 64 GB x 2 managed disks | 12 months |
| **Bandwidth** | 15 GB outbound | Monthly |

**Verdict:** ⚠️ **Temporary only** - B1s is marginal for Coolify, and free tier expires after 12 months

```bash
# Install Azure CLI
brew install azure-cli

# Login
az login

# Create resource group
az group create --name medusa-rg --location eastus

# Create VM (free tier B1s)
az vm create \
  --resource-group medusa-rg \
  --name medusa-vm \
  --image Ubuntu2404 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys
```

##### AWS Free Tier

AWS offers t2.micro/t3.micro for 12 months.

| Resource | Free Allocation | Duration |
|----------|-----------------|----------|
| **EC2** | t2.micro (1 vCPU, 1 GB RAM) | 750 hours/month for 12 months |
| **EBS** | 30 GB SSD | 12 months |
| **Bandwidth** | 100 GB outbound | Monthly |

**Verdict:** ❌ **Not recommended** - t2.micro is too small, and free tier expires

#### Hosting Comparison Summary

| Provider | Plan | vCPU | RAM | Storage | Monthly Cost | Coolify + Medusa? |
|----------|------|------|-----|---------|--------------|-------------------|
| **Hetzner** | CX22 | 2 | 4 GB | 40 GB | **€4.35** | ✅ Yes (minimum) |
| **Hetzner** | CX32 | 4 | 8 GB | 80 GB | **€8.25** | ✅ Yes (recommended) |
| **Oracle** | ARM A1.Flex | 2+ | 12+ GB | 100 GB | **Free** | ✅ Yes (ARM images) |
| **Google** | e2-micro | 0.25 | 1 GB | 30 GB | Free | ❌ Too small |
| **Azure** | B1s | 1 | 1 GB | 64 GB | Free (12mo) | ⚠️ Marginal |
| **AWS** | t2.micro | 1 | 1 GB | 30 GB | Free (12mo) | ❌ Too small |

#### Recommended Approach

```
┌─────────────────────────────────────────────────────────────────────┐
│                    RECOMMENDED VPS STRATEGY                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  DEVELOPMENT / TESTING:                                             │
│  └─ Oracle Cloud ARM Free Tier                                      │
│     • 2 OCPU / 12 GB RAM instance                                   │
│     • Use ARM-compatible Docker images                              │
│     • Total cost: $0/month                                          │
│                                                                     │
│  PRODUCTION (Budget):                                               │
│  └─ Hetzner CX22 (€4.35/month)                                     │
│     • 2 vCPU / 4 GB RAM / 40 GB SSD                                │
│     • Reliable x86 architecture                                     │
│     • 20 TB bandwidth included                                      │
│                                                                     │
│  PRODUCTION (Recommended):                                          │
│  └─ Hetzner CX32 (€8.25/month)                                     │
│     • 4 vCPU / 8 GB RAM / 80 GB SSD                                │
│     • Room for growth and multiple services                         │
│     • Comfortable headroom for builds                               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### VPS Setup Tasks

- [ ] **Task 2.1**: Select VPS provider based on budget and requirements
  - [ ] For free: Create Oracle Cloud account and provision ARM instance
  - [ ] For paid: Create Hetzner account and provision CX22 or CX32 server
- [ ] **Task 2.2**: Configure SSH access and security
  - [ ] Add SSH key to server
  - [ ] Disable password authentication
  - [ ] Configure firewall (ufw or iptables)
- [ ] **Task 2.3**: Update system and install Docker
  ```bash
  # Update system
  sudo apt update && sudo apt upgrade -y

  # Install Docker
  curl -fsSL https://get.docker.com | sh

  # Add user to docker group
  sudo usermod -aG docker $USER

  # Install Docker Compose
  sudo apt install docker-compose-plugin -y

  # Verify installation
  docker --version
  docker compose version
  ```
- [ ] **Task 2.4**: Install Coolify
  ```bash
  # One-line Coolify installation
  curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

  # Access Coolify dashboard at http://your-server-ip:8000
  ```

### Cloudflare DNS Configuration

Cloudflare provides DNS management, CDN caching, SSL/TLS termination, and DDoS protection. This section covers setting up DNS records for both the apex domain and store subdomain.

#### Wrangler CLI Installation

```bash
# Install Wrangler CLI globally
npm install -g wrangler

# Verify installation
wrangler --version

# Authenticate with Cloudflare account
wrangler login

# Check account status
wrangler whoami
```

#### Adding Domain to Cloudflare

- [ ] **Task 2.5**: Add domain to Cloudflare
  1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com)
  2. Click "Add a Site"
  3. Enter `danieltarazona.com`
  4. Select Free plan (or Pro for advanced features)
  5. Cloudflare will scan existing DNS records
  6. Update nameservers at your domain registrar:
     ```
     # Example Cloudflare nameservers (yours will differ)
     ns1.cloudflare.com
     ns2.cloudflare.com
     ```
  7. Wait for DNS propagation (up to 24 hours, usually faster)

```bash
# Verify nameserver propagation
dig NS danieltarazona.com +short

# Check if Cloudflare is active
curl -I https://danieltarazona.com | grep "cf-ray"
```

#### DNS Record Configuration

The following DNS records need to be configured for the architecture:

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                          DNS RECORD CONFIGURATION                               │
├────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  APEX DOMAIN (danieltarazona.com) → Cloudflare Pages                           │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │  Type: CNAME (flattened)  │  Name: @  │  Target: *.pages.dev            │  │
│  │  Proxy: ✅ Enabled        │  TTL: Auto                                   │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│  WWW SUBDOMAIN (www.danieltarazona.com) → Redirect to apex                     │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │  Type: CNAME              │  Name: www  │  Target: danieltarazona.com   │  │
│  │  Proxy: ✅ Enabled        │  TTL: Auto                                   │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
│  STORE SUBDOMAIN (store.danieltarazona.com) → Cloudflare Tunnel                │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │  Type: CNAME              │  Name: store  │  Target: <tunnel-id>.cfargotunnel.com │
│  │  Proxy: ✅ Enabled        │  TTL: Auto                                   │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
└────────────────────────────────────────────────────────────────────────────────┘
```

##### DNS Record Tasks

- [ ] **Task 2.6**: Configure DNS records for apex domain
  ```bash
  # Using Cloudflare API (alternative to dashboard)

  # Get Zone ID
  export CF_ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=danieltarazona.com" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

  # Create CNAME record for apex domain (Cloudflare Pages)
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "CNAME",
      "name": "@",
      "content": "danieltarazona-portfolio.pages.dev",
      "ttl": 1,
      "proxied": true
    }'
  ```

- [ ] **Task 2.7**: Configure DNS records for www subdomain
  ```bash
  # Create CNAME record for www redirect
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "CNAME",
      "name": "www",
      "content": "danieltarazona.com",
      "ttl": 1,
      "proxied": true
    }'
  ```

- [ ] **Task 2.8**: Configure CNAME for store subdomain
  ```bash
  # Create CNAME record pointing to Cloudflare Tunnel
  # (Tunnel ID will be created in the Tunnel setup phase)
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "CNAME",
      "name": "store",
      "content": "<tunnel-id>.cfargotunnel.com",
      "ttl": 1,
      "proxied": true
    }'
  ```

##### IPv6 Support (Optional A/AAAA Records)

For direct VPS hosting without Cloudflare Pages, use A/AAAA records:

```bash
# A record for IPv4
curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "A",
    "name": "@",
    "content": "YOUR_VPS_IPV4_ADDRESS",
    "ttl": 1,
    "proxied": true
  }'

# AAAA record for IPv6
curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "AAAA",
    "name": "@",
    "content": "YOUR_VPS_IPV6_ADDRESS",
    "ttl": 1,
    "proxied": true
  }'
```

#### Cloudflare Proxy Settings

Enabling the Cloudflare proxy (orange cloud) provides:

| Feature | Description |
|---------|-------------|
| **CDN Caching** | Static assets cached at 300+ edge locations |
| **DDoS Protection** | Layer 3/4/7 attack mitigation |
| **SSL/TLS** | Free Universal SSL certificate |
| **IP Masking** | Origin server IP hidden from public |
| **Compression** | Brotli/Gzip compression for text assets |
| **HTTP/2 & HTTP/3** | Modern protocol support |

- [ ] **Task 2.9**: Enable proxy for all DNS records
  - In Cloudflare Dashboard → DNS → Records
  - Ensure the orange cloud (Proxied) is enabled for all records
  - **Exception**: Disable proxy for records that need direct IP access (e.g., SSH)

```bash
# Verify proxy status via API
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" | jq '.result[] | {name, type, proxied}'
```

#### SSL/TLS Configuration

Cloudflare provides free SSL certificates with flexible configuration options.

##### SSL/TLS Encryption Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **Off** | No encryption | ❌ Never use |
| **Flexible** | HTTPS to Cloudflare, HTTP to origin | ⚠️ Not recommended |
| **Full** | HTTPS end-to-end (any certificate) | ✅ Good for self-signed |
| **Full (Strict)** | HTTPS end-to-end (valid certificate) | ✅ Best for production |

- [ ] **Task 2.10**: Configure SSL/TLS settings
  1. Navigate to **SSL/TLS** → **Overview** in Cloudflare Dashboard
  2. Set encryption mode to **Full (Strict)**
  3. Enable the following settings:
     - ✅ Always Use HTTPS
     - ✅ Automatic HTTPS Rewrites
     - ✅ TLS 1.3 (minimum TLS 1.2)

```bash
# Set SSL mode to Full (Strict) via API
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/ssl" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"value": "strict"}'

# Enable Always Use HTTPS
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/always_use_https" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"value": "on"}'

# Enable TLS 1.3
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/min_tls_version" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"value": "1.2"}'

# Enable Automatic HTTPS Rewrites
curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/automatic_https_rewrites" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"value": "on"}'
```

##### Origin Certificates

For Full (Strict) mode with self-hosted origin, generate a Cloudflare Origin Certificate:

- [ ] **Task 2.11**: Generate Cloudflare Origin Certificate
  1. Navigate to **SSL/TLS** → **Origin Server**
  2. Click "Create Certificate"
  3. Select: Generate private key and CSR with Cloudflare
  4. Hostnames: `danieltarazona.com`, `*.danieltarazona.com`
  5. Certificate validity: 15 years (default)
  6. Save the certificate and private key

```bash
# Install certificate on origin server (Coolify/VPS)
sudo mkdir -p /etc/ssl/cloudflare
sudo nano /etc/ssl/cloudflare/origin-cert.pem  # Paste certificate
sudo nano /etc/ssl/cloudflare/origin-key.pem   # Paste private key

# Set proper permissions
sudo chmod 600 /etc/ssl/cloudflare/origin-key.pem
sudo chmod 644 /etc/ssl/cloudflare/origin-cert.pem
```

##### Edge Certificates

- [ ] **Task 2.12**: Verify Edge Certificate status
  1. Navigate to **SSL/TLS** → **Edge Certificates**
  2. Ensure "Universal SSL" status is "Active"
  3. Verify certificate covers: `danieltarazona.com`, `*.danieltarazona.com`

```bash
# Check certificate status via API
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/ssl/certificate_packs" \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" | jq '.result[0].status'
```

#### Additional Security Settings

- [ ] **Task 2.13**: Configure security headers and settings
  ```bash
  # Enable HSTS (HTTP Strict Transport Security)
  curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/security_header" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "value": {
        "strict_transport_security": {
          "enabled": true,
          "max_age": 31536000,
          "include_subdomains": true,
          "preload": true
        }
      }
    }'

  # Set Security Level to Medium
  curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/security_level" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"value": "medium"}'

  # Enable Browser Integrity Check
  curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/settings/browser_check" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"value": "on"}'
  ```

#### DNS Configuration Summary

| Record | Type | Name | Target | Proxied | Purpose |
|--------|------|------|--------|---------|---------|
| Apex | CNAME | @ | `*.pages.dev` | ✅ Yes | Main portfolio site |
| WWW | CNAME | www | `danieltarazona.com` | ✅ Yes | Redirect to apex |
| Store | CNAME | store | `<tunnel-id>.cfargotunnel.com` | ✅ Yes | E-commerce store |
| API | CNAME | api | `<tunnel-id>.cfargotunnel.com` | ✅ Yes | Medusa API (optional) |
| Admin | CNAME | admin | `<tunnel-id>.cfargotunnel.com` | ✅ Yes | Medusa Admin (optional) |

### Cloudflare Tunnel Setup

Cloudflare Tunnel (formerly Argo Tunnel) provides secure, outbound-only connections from your VPS to Cloudflare's edge network. This eliminates the need to open inbound ports, providing a zero-trust security model for exposing Medusa and Coolify services.

#### Why Cloudflare Tunnel?

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    TRADITIONAL VS CLOUDFLARE TUNNEL                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  TRADITIONAL (Open Ports):                                                       │
│  ┌─────────────┐    Inbound:443    ┌─────────────┐                              │
│  │   Internet  │ ───────────────▶  │     VPS     │                              │
│  │  (Attackers)│    Exposed Port   │  (Exposed)  │                              │
│  └─────────────┘                   └─────────────┘                              │
│  ⚠️ Risks: DDoS, Port Scanning, Direct Attacks                                  │
│                                                                                  │
│  CLOUDFLARE TUNNEL (No Open Ports):                                             │
│  ┌─────────────┐    Outbound Only  ┌─────────────┐                              │
│  │  Cloudflare │ ◀───────────────  │     VPS     │                              │
│  │    Edge     │    Secure Tunnel  │ (Protected) │                              │
│  └─────────────┘                   └─────────────┘                              │
│  ✅ Benefits: Hidden IP, DDoS Protection, Zero Trust                            │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

| Feature | Open Ports | Cloudflare Tunnel |
|---------|------------|-------------------|
| **Origin IP** | Exposed | Hidden |
| **Firewall Ports** | 80, 443, 9000 open | All inbound closed |
| **DDoS Protection** | Limited | Full Cloudflare protection |
| **SSL/TLS** | Self-managed | Automatic via Cloudflare |
| **Authentication** | Application-level | Zero Trust Access (optional) |
| **Setup Complexity** | Low | Medium |
| **Cost** | Free | Free (unlimited tunnels) |

#### Installing Cloudflared

Cloudflared is the daemon that creates and manages Cloudflare Tunnels. Install it on your VPS:

- [ ] **Task 2.14**: Install cloudflared on VPS
  ```bash
  # Debian/Ubuntu - Add Cloudflare GPG key and repository
  sudo mkdir -p --mode=0755 /usr/share/keyrings
  curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

  echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list

  # Install cloudflared
  sudo apt update && sudo apt install cloudflared -y

  # Verify installation
  cloudflared --version
  # cloudflared version 2024.x.x (built 2024-xx-xx)
  ```

  Alternative installation methods:
  ```bash
  # Direct download (any Linux)
  curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
  chmod +x cloudflared
  sudo mv cloudflared /usr/local/bin/

  # ARM64 (Oracle Cloud ARM instance)
  curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -o cloudflared
  chmod +x cloudflared
  sudo mv cloudflared /usr/local/bin/

  # Docker (useful for Coolify deployments)
  docker pull cloudflare/cloudflared:latest
  ```

#### Authenticating with Cloudflare

- [ ] **Task 2.15**: Authenticate cloudflared with your Cloudflare account
  ```bash
  # Authenticate with Cloudflare (opens browser for OAuth)
  cloudflared tunnel login

  # This creates a certificate at ~/.cloudflared/cert.pem
  # The certificate authorizes tunnel creation for your account

  # Verify authentication
  ls -la ~/.cloudflared/
  # Should show: cert.pem
  ```

#### Creating a Tunnel

- [ ] **Task 2.16**: Create a named tunnel for the project
  ```bash
  # Create a new tunnel with a descriptive name
  cloudflared tunnel create danieltarazona-tunnel

  # Output will show:
  # Created tunnel danieltarazona-tunnel with id <TUNNEL_ID>
  # Credentials written to ~/.cloudflared/<TUNNEL_ID>.json

  # Save the Tunnel ID for DNS configuration
  export TUNNEL_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # List all tunnels
  cloudflared tunnel list

  # Get tunnel info
  cloudflared tunnel info danieltarazona-tunnel
  ```

#### Tunnel Configuration File

Create a configuration file that defines how traffic should be routed to your local services:

- [ ] **Task 2.17**: Create tunnel configuration file
  ```bash
  # Create cloudflared config directory
  sudo mkdir -p /etc/cloudflared

  # Create configuration file
  sudo nano /etc/cloudflared/config.yml
  ```

  **Configuration file content (`/etc/cloudflared/config.yml`):**
  ```yaml
  # Cloudflare Tunnel Configuration for danieltarazona.com
  # This file defines how incoming requests are routed to local services

  tunnel: <TUNNEL_ID>
  credentials-file: /root/.cloudflared/<TUNNEL_ID>.json

  # Ingress rules define how requests are routed
  # Rules are evaluated in order - first match wins
  ingress:
    # Medusa Storefront API (store.danieltarazona.com)
    - hostname: store.danieltarazona.com
      service: http://localhost:9000
      originRequest:
        noTLSVerify: true
        connectTimeout: 30s

    # Medusa Admin Dashboard (admin.danieltarazona.com) - Optional
    - hostname: admin.danieltarazona.com
      service: http://localhost:9000
      originRequest:
        noTLSVerify: true

    # Medusa API endpoint (api.danieltarazona.com) - Optional
    - hostname: api.danieltarazona.com
      service: http://localhost:9000
      originRequest:
        noTLSVerify: true
        httpHostHeader: "api.danieltarazona.com"

    # Coolify Dashboard (coolify.danieltarazona.com) - Optional
    - hostname: coolify.danieltarazona.com
      service: http://localhost:8000
      originRequest:
        noTLSVerify: true

    # Catch-all rule (required) - Returns 404 for unmatched requests
    - service: http_status:404
  ```

  **Ingress Configuration Options:**

  | Option | Description | Example |
  |--------|-------------|---------|
  | `hostname` | The public hostname for this route | `store.danieltarazona.com` |
  | `service` | Local service URL to forward to | `http://localhost:9000` |
  | `noTLSVerify` | Skip TLS verification for local service | `true` (for self-signed certs) |
  | `connectTimeout` | Timeout for establishing connection | `30s` |
  | `httpHostHeader` | Override Host header sent to origin | `api.danieltarazona.com` |

#### DNS Route Configuration

After creating the tunnel, configure DNS records to point to it:

- [ ] **Task 2.18**: Configure DNS routes for the tunnel
  ```bash
  # Route store subdomain through the tunnel
  cloudflared tunnel route dns danieltarazona-tunnel store.danieltarazona.com

  # Route admin subdomain through the tunnel (optional)
  cloudflared tunnel route dns danieltarazona-tunnel admin.danieltarazona.com

  # Route API subdomain through the tunnel (optional)
  cloudflared tunnel route dns danieltarazona-tunnel api.danieltarazona.com

  # Route Coolify dashboard (optional, for remote management)
  cloudflared tunnel route dns danieltarazona-tunnel coolify.danieltarazona.com

  # Verify DNS records were created
  cloudflared tunnel route list

  # Alternative: Create CNAME manually via Cloudflare API
  curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "CNAME",
      "name": "store",
      "content": "'$TUNNEL_ID'.cfargotunnel.com",
      "ttl": 1,
      "proxied": true
    }'
  ```

#### Running the Tunnel

- [ ] **Task 2.19**: Test tunnel connectivity
  ```bash
  # Run tunnel in foreground (for testing)
  cloudflared tunnel run danieltarazona-tunnel

  # Test from another terminal or browser
  curl -I https://store.danieltarazona.com
  # Should return HTTP 200 or Medusa response

  # Run with debug logging
  cloudflared tunnel --loglevel debug run danieltarazona-tunnel
  ```

#### Installing as a System Service

For production, run cloudflared as a systemd service:

- [ ] **Task 2.20**: Configure cloudflared as a systemd service
  ```bash
  # Install the service (copies config to /etc/cloudflared/)
  sudo cloudflared service install

  # Or manually create the service file
  sudo nano /etc/systemd/system/cloudflared.service
  ```

  **Systemd service file (`/etc/systemd/system/cloudflared.service`):**
  ```ini
  [Unit]
  Description=Cloudflare Tunnel for danieltarazona.com
  After=network-online.target
  Wants=network-online.target

  [Service]
  Type=simple
  User=root
  ExecStart=/usr/local/bin/cloudflared tunnel --config /etc/cloudflared/config.yml run
  Restart=always
  RestartSec=5
  TimeoutStartSec=0

  # Logging
  StandardOutput=journal
  StandardError=journal
  SyslogIdentifier=cloudflared

  # Security hardening
  NoNewPrivileges=yes
  ProtectSystem=full
  ProtectHome=read-only

  [Install]
  WantedBy=multi-user.target
  ```

  ```bash
  # Enable and start the service
  sudo systemctl daemon-reload
  sudo systemctl enable cloudflared
  sudo systemctl start cloudflared

  # Check status
  sudo systemctl status cloudflared

  # View logs
  sudo journalctl -u cloudflared -f
  ```

#### Cloudflare Zero Trust Access (Optional)

For additional security on admin endpoints, configure Cloudflare Access:

- [ ] **Task 2.21**: Configure Zero Trust Access policies (optional)
  ```bash
  # Access policies are configured via Cloudflare Dashboard or API
  # Dashboard: Zero Trust → Access → Applications → Add an Application

  # Example: Protect admin.danieltarazona.com
  # 1. Create an Access Application for admin.danieltarazona.com
  # 2. Add authentication method (email OTP, Google, GitHub, etc.)
  # 3. Create access policy (e.g., only allow specific emails)

  # CLI approach using Cloudflare API
  curl -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/access/apps" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "name": "Medusa Admin",
      "domain": "admin.danieltarazona.com",
      "type": "self_hosted",
      "session_duration": "24h",
      "auto_redirect_to_identity": true
    }'
  ```

#### Tunnel Health Monitoring

- [ ] **Task 2.22**: Set up tunnel monitoring and alerts
  ```bash
  # Check tunnel health via API
  curl -s "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/cfd_tunnel/$TUNNEL_ID" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" | jq '.result.status'

  # Monitor tunnel connections
  cloudflared tunnel info danieltarazona-tunnel

  # View active connections
  cloudflared tunnel list --show-recently-disconnected
  ```

  **Health Check Script (`/usr/local/bin/check-tunnel.sh`):**
  ```bash
  #!/bin/bash
  # Tunnel health check script

  TUNNEL_NAME="danieltarazona-tunnel"
  HEALTH_URL="https://store.danieltarazona.com/health"

  # Check if cloudflared is running
  if ! systemctl is-active --quiet cloudflared; then
    echo "ALERT: cloudflared service is not running"
    systemctl restart cloudflared
    exit 1
  fi

  # Check if endpoints are accessible
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_URL)
  if [ "$HTTP_STATUS" != "200" ]; then
    echo "ALERT: Tunnel endpoint returned HTTP $HTTP_STATUS"
    exit 1
  fi

  echo "OK: Tunnel is healthy"
  exit 0
  ```

#### Tunnel Architecture Summary

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CLOUDFLARE TUNNEL ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  INTERNET                                                                        │
│      │                                                                           │
│      │  HTTPS (443)                                                              │
│      ▼                                                                           │
│  ┌───────────────────────────────────────────────────────────────────────────┐  │
│  │                        CLOUDFLARE EDGE                                     │  │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐│  │
│  │  │ DDoS Protection │  │   WAF Rules     │  │   Zero Trust Access        ││  │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘│  │
│  │                              │                                             │  │
│  │                              ▼                                             │  │
│  │  ┌─────────────────────────────────────────────────────────────────────┐  │  │
│  │  │              Cloudflare Tunnel Routing                              │  │  │
│  │  │  store.danieltarazona.com  ───▶  danieltarazona-tunnel             │  │  │
│  │  │  admin.danieltarazona.com  ───▶  danieltarazona-tunnel             │  │  │
│  │  │  api.danieltarazona.com    ───▶  danieltarazona-tunnel             │  │  │
│  │  └─────────────────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────────────────┘  │
│                              │                                                   │
│                              │  Secure Tunnel (Outbound from VPS)               │
│                              │  QUIC/HTTP2 multiplexed connection               │
│                              ▼                                                   │
│  ┌───────────────────────────────────────────────────────────────────────────┐  │
│  │                             VPS (COOLIFY)                                  │  │
│  │                                                                            │  │
│  │   ┌─────────────────────────────────────────────────────────────────┐     │  │
│  │   │                      cloudflared daemon                          │     │  │
│  │   │   Config: /etc/cloudflared/config.yml                           │     │  │
│  │   │   Creds:  /root/.cloudflared/<tunnel-id>.json                   │     │  │
│  │   └───────────────────────────┬─────────────────────────────────────┘     │  │
│  │                               │                                            │  │
│  │          ┌────────────────────┼────────────────────┐                      │  │
│  │          │                    │                    │                      │  │
│  │          ▼                    ▼                    ▼                      │  │
│  │   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                │  │
│  │   │ Medusa API  │     │ Medusa Admin│     │  Coolify    │                │  │
│  │   │ :9000       │     │ :9000/admin │     │  :8000      │                │  │
│  │   └─────────────┘     └─────────────┘     └─────────────┘                │  │
│  │          │                    │                                           │  │
│  │          └────────────────────┘                                           │  │
│  │                    │                                                      │  │
│  │                    ▼                                                      │  │
│  │            ┌─────────────┐                                               │  │
│  │            │ PostgreSQL  │                                               │  │
│  │            │ :5432       │                                               │  │
│  │            └─────────────┘                                               │  │
│  │                                                                          │  │
│  │   FIREWALL: All inbound ports CLOSED (except SSH 22 for management)     │  │
│  └───────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Tunnel Tasks Summary

| Task | Description | Status |
|------|-------------|--------|
| 2.14 | Install cloudflared on VPS | [ ] |
| 2.15 | Authenticate with Cloudflare account | [ ] |
| 2.16 | Create named tunnel | [ ] |
| 2.17 | Create tunnel configuration file | [ ] |
| 2.18 | Configure DNS routes for tunnel | [ ] |
| 2.19 | Test tunnel connectivity | [ ] |
| 2.20 | Install as systemd service | [ ] |
| 2.21 | Configure Zero Trust Access (optional) | [ ] |
| 2.22 | Set up tunnel monitoring | [ ] |

---

## Phase 2: Database & Backend Services

This phase covers PostgreSQL database setup with Supabase as the primary managed database solution, including schema design, migrations, and connection configuration for both the portfolio site and e-commerce store.

### Supabase PostgreSQL Setup

Supabase provides a managed PostgreSQL database with additional features like Row Level Security, Authentication, Realtime subscriptions, and Edge Functions. For this project, Supabase will be used for:

1. **Portfolio Site**: Contact form submissions, newsletter signups, analytics events
2. **E-Commerce Store**: Optional backup/analytics database (Medusa uses its own PostgreSQL)

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         SUPABASE ARCHITECTURE                                    │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                          SUPABASE CLOUD                                  │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│  │  │   PostgreSQL    │  │   PostgREST     │  │     GoTrue Auth         │  │   │
│  │  │   Database      │  │   REST API      │  │   (Authentication)      │  │   │
│  │  │   (500MB Free)  │  │   (Auto-gen)    │  │   (50K MAU Free)        │  │   │
│  │  └────────┬────────┘  └────────┬────────┘  └─────────────────────────┘  │   │
│  │           │                    │                                         │   │
│  │           └─────────┬──────────┘                                         │   │
│  │                     │                                                    │   │
│  │  ┌─────────────────┴─────────────────┐  ┌─────────────────────────────┐ │   │
│  │  │         Supabase API              │  │       Edge Functions        │ │   │
│  │  │  https://<project>.supabase.co    │  │   (Deno-based serverless)   │ │   │
│  │  └───────────────────────────────────┘  └─────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                              │                                                   │
│                              │ HTTPS/WebSocket                                   │
│                              ▼                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         CLIENT APPLICATIONS                              │   │
│  │  ┌─────────────────────┐              ┌─────────────────────┐           │   │
│  │  │   Astro Portfolio   │              │   Astro Storefront  │           │   │
│  │  │   - Contact Form    │              │   - Analytics       │           │   │
│  │  │   - Newsletter      │              │   - User Prefs      │           │   │
│  │  └─────────────────────┘              └─────────────────────┘           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Supabase Free Tier Limits

Understanding the free tier limits is crucial for cost-effective deployment:

| Resource | Free Tier Limit | Notes |
|----------|-----------------|-------|
| **Database Size** | 500 MB | PostgreSQL storage limit |
| **Monthly Active Users** | 50,000 MAU | For Supabase Auth |
| **Edge Function Invocations** | 500,000/month | Serverless function calls |
| **Realtime Messages** | 2 million/month | WebSocket messages |
| **Storage** | 1 GB | File storage (S3-compatible) |
| **Bandwidth** | 2 GB/month | Database egress |
| **Projects** | 2 active | Can pause/resume others |
| **Daily Backups** | 7 days retention | Point-in-time recovery |

**Monitoring Usage:**
```bash
# Check database size via SQL
SELECT pg_size_pretty(pg_database_size('postgres')) as db_size;

# Check table sizes
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;
```

#### Supabase CLI Installation

- [ ] **Task 3.1**: Install Supabase CLI
  ```bash
  # Install via npm (recommended)
  npm install -g supabase

  # Verify installation
  supabase --version
  # supabase version 1.x.x

  # Alternative: Install via Homebrew (macOS)
  brew install supabase/tap/supabase

  # Alternative: Install via Scoop (Windows)
  scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
  scoop install supabase

  # Alternative: Direct download
  # Visit: https://github.com/supabase/cli/releases
  ```

- [ ] **Task 3.2**: Authenticate with Supabase
  ```bash
  # Login to Supabase (opens browser for OAuth)
  supabase login

  # Verify authentication
  supabase projects list

  # Check logged-in account
  supabase orgs list
  ```

#### Supabase Project Creation

- [ ] **Task 3.3**: Create a new Supabase project

  **Via Dashboard (Recommended for first time):**
  1. Navigate to [app.supabase.com](https://app.supabase.com)
  2. Click "New Project"
  3. Configure project settings:
     - **Organization**: Select or create organization
     - **Project name**: `danieltarazona-portfolio`
     - **Database password**: Generate strong password (save securely!)
     - **Region**: Choose closest to target audience
       - `us-east-1` (N. Virginia) - US East
       - `us-west-1` (N. California) - US West
       - `eu-west-1` (Ireland) - Europe
       - `ap-southeast-1` (Singapore) - Asia
     - **Pricing Plan**: Free tier
  4. Wait for project provisioning (~2 minutes)

  **Via CLI:**
  ```bash
  # Create project via CLI (requires existing organization)
  supabase projects create danieltarazona-portfolio \
    --org-id <your-org-id> \
    --db-password "<secure-password>" \
    --region us-east-1

  # Get organization ID
  supabase orgs list

  # List projects to confirm creation
  supabase projects list
  ```

#### Project Configuration & Connection

- [ ] **Task 3.4**: Retrieve project credentials and API keys
  ```bash
  # Get project API settings
  supabase projects api-keys --project-ref <project-ref>

  # The output will include:
  # - anon (public) key: Safe to use in browser
  # - service_role key: Admin access, NEVER expose in client-side code
  ```

  **Environment Variables Setup:**
  ```bash
  # Create .env file for local development
  cat > .env << 'EOF'
  # Supabase Configuration
  SUPABASE_URL=https://<project-ref>.supabase.co
  SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

  # Database Connection (for direct access)
  DATABASE_URL=postgresql://postgres:<password>@db.<project-ref>.supabase.co:5432/postgres

  # Connection Pooling (recommended for production)
  DATABASE_POOLER_URL=postgresql://postgres.<project-ref>:<password>@aws-0-<region>.pooler.supabase.co:6543/postgres
  EOF

  # Secure the file
  chmod 600 .env
  ```

  **Connection String Formats:**

  | Type | Port | Use Case | Connection String |
  |------|------|----------|-------------------|
  | **Direct** | 5432 | Migrations, admin | `postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres` |
  | **Session Pooler** | 5432 | Long-lived connections | `postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.co:5432/postgres` |
  | **Transaction Pooler** | 6543 | Serverless, Lambda | `postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.co:6543/postgres` |

- [ ] **Task 3.5**: Test database connection
  ```bash
  # Install PostgreSQL client (if not installed)
  sudo apt install postgresql-client -y  # Debian/Ubuntu
  brew install libpq                      # macOS

  # Test direct connection
  psql "postgresql://postgres:<password>@db.<project-ref>.supabase.co:5432/postgres" -c "SELECT version();"

  # Test pooled connection
  psql "postgresql://postgres.<project-ref>:<password>@aws-0-us-east-1.pooler.supabase.co:6543/postgres" -c "SELECT 1;"
  ```

#### Local Development Setup

- [ ] **Task 3.6**: Initialize Supabase for local development
  ```bash
  # Navigate to your project directory
  cd danieltarazona-portfolio

  # Initialize Supabase (creates supabase/ directory)
  supabase init

  # This creates:
  # supabase/
  # ├── config.toml       # Local Supabase configuration
  # ├── seed.sql          # Seed data for development
  # └── migrations/       # Database migration files
  ```

  **Local Configuration (`supabase/config.toml`):**
  ```toml
  # supabase/config.toml
  [api]
  enabled = true
  port = 54321
  schemas = ["public", "graphql_public"]
  extra_search_path = ["public", "extensions"]
  max_rows = 1000

  [db]
  port = 54322
  shadow_port = 54320
  major_version = 15

  [studio]
  enabled = true
  port = 54323
  api_url = "http://localhost"

  [auth]
  enabled = true
  site_url = "http://localhost:3000"
  additional_redirect_urls = ["https://localhost:3000"]
  jwt_expiry = 3600
  enable_signup = true

  [auth.email]
  enable_signup = true
  double_confirm_changes = true
  enable_confirmations = false
  ```

- [ ] **Task 3.7**: Start local Supabase stack
  ```bash
  # Start local Supabase (requires Docker)
  supabase start

  # Output will show local URLs:
  # API URL: http://localhost:54321
  # GraphQL URL: http://localhost:54321/graphql/v1
  # Studio URL: http://localhost:54323
  # DB URL: postgresql://postgres:postgres@localhost:54322/postgres
  # Anon key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  # Service role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

  # Stop local Supabase
  supabase stop

  # Stop and reset database (removes all data)
  supabase stop --no-backup
  ```

#### Database Schema Design

- [ ] **Task 3.8**: Create database schema for portfolio site
  ```bash
  # Create initial migration
  supabase migration new create_portfolio_tables
  ```

  **Migration file (`supabase/migrations/YYYYMMDD_create_portfolio_tables.sql`):**
  ```sql
  -- Contact Form Submissions Table
  CREATE TABLE IF NOT EXISTS contact_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    subject VARCHAR(500),
    message TEXT NOT NULL,
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    replied_at TIMESTAMPTZ,
    archived BOOLEAN DEFAULT FALSE
  );

  -- Create index for querying unread submissions
  CREATE INDEX idx_contact_unread ON contact_submissions(created_at DESC)
    WHERE read_at IS NULL AND archived = FALSE;

  -- Newsletter Signups Table
  CREATE TABLE IF NOT EXISTS newsletter_signups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    source VARCHAR(100),
    confirmed BOOLEAN DEFAULT FALSE,
    confirmation_token UUID DEFAULT gen_random_uuid(),
    confirmed_at TIMESTAMPTZ,
    unsubscribed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Create index for email lookup
  CREATE INDEX idx_newsletter_email ON newsletter_signups(email);

  -- Analytics Events Table (lightweight, for custom tracking)
  CREATE TABLE IF NOT EXISTS analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL,
    page_path VARCHAR(500),
    referrer TEXT,
    user_agent TEXT,
    ip_hash VARCHAR(64),  -- Hashed IP for privacy
    session_id VARCHAR(100),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Create indexes for analytics queries
  CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
  CREATE INDEX idx_analytics_created_at ON analytics_events(created_at DESC);
  CREATE INDEX idx_analytics_page_path ON analytics_events(page_path);

  -- Partition analytics table by month for performance (optional for large scale)
  -- CREATE TABLE analytics_events_y2024m01 PARTITION OF analytics_events
  --   FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

  -- Row Level Security Policies
  ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;
  ALTER TABLE newsletter_signups ENABLE ROW LEVEL SECURITY;
  ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

  -- Policy: Allow anonymous inserts (for public forms)
  CREATE POLICY "Allow anonymous contact submission" ON contact_submissions
    FOR INSERT TO anon
    WITH CHECK (true);

  CREATE POLICY "Allow anonymous newsletter signup" ON newsletter_signups
    FOR INSERT TO anon
    WITH CHECK (true);

  CREATE POLICY "Allow anonymous analytics events" ON analytics_events
    FOR INSERT TO anon
    WITH CHECK (true);

  -- Policy: Only service_role can read/update (for admin access)
  CREATE POLICY "Service role full access to contacts" ON contact_submissions
    FOR ALL TO service_role
    USING (true);

  CREATE POLICY "Service role full access to newsletter" ON newsletter_signups
    FOR ALL TO service_role
    USING (true);

  CREATE POLICY "Service role full access to analytics" ON analytics_events
    FOR ALL TO service_role
    USING (true);

  -- Function to hash IP addresses for privacy
  CREATE OR REPLACE FUNCTION hash_ip(ip INET)
  RETURNS VARCHAR(64) AS $$
  BEGIN
    RETURN encode(sha256(ip::text::bytea), 'hex');
  END;
  $$ LANGUAGE plpgsql IMMUTABLE;

  -- Comments for documentation
  COMMENT ON TABLE contact_submissions IS 'Stores contact form submissions from the portfolio site';
  COMMENT ON TABLE newsletter_signups IS 'Stores newsletter subscription emails';
  COMMENT ON TABLE analytics_events IS 'Lightweight analytics events for custom tracking';
  ```

#### Schema Migrations

- [ ] **Task 3.9**: Apply migrations to local and remote databases
  ```bash
  # Apply migrations to local database
  supabase migration up

  # Check migration status
  supabase migration list

  # Generate TypeScript types from schema (for type safety)
  supabase gen types typescript --local > src/types/supabase.ts

  # Link to remote project (required for pushing migrations)
  supabase link --project-ref <project-ref>

  # Push migrations to remote database
  supabase db push

  # Pull remote changes (if schema was modified via dashboard)
  supabase db pull

  # Diff local vs remote schema
  supabase db diff
  ```

- [ ] **Task 3.10**: Create seed data for development
  ```bash
  # Edit seed file
  nano supabase/seed.sql
  ```

  **Seed file (`supabase/seed.sql`):**
  ```sql
  -- Seed data for local development

  -- Sample contact submissions
  INSERT INTO contact_submissions (name, email, subject, message, created_at)
  VALUES
    ('John Doe', 'john@example.com', 'Project Inquiry', 'I''d like to discuss a potential project collaboration.', NOW() - INTERVAL '2 days'),
    ('Jane Smith', 'jane@example.com', 'Photography Question', 'What camera gear do you use for your portfolio shots?', NOW() - INTERVAL '1 day'),
    ('Bob Wilson', 'bob@example.com', 'Speaking Request', 'Would you be available for a conference talk?', NOW());

  -- Sample newsletter signups
  INSERT INTO newsletter_signups (email, name, source, confirmed)
  VALUES
    ('subscriber1@example.com', 'Alice', 'homepage', true),
    ('subscriber2@example.com', 'Bob', 'blog', true),
    ('subscriber3@example.com', NULL, 'footer', false);

  -- Sample analytics events
  INSERT INTO analytics_events (event_type, page_path, metadata)
  VALUES
    ('page_view', '/', '{"source": "direct"}'),
    ('page_view', '/gallery', '{"source": "homepage"}'),
    ('page_view', '/about', '{"source": "navigation"}'),
    ('button_click', '/contact', '{"button": "submit"}');
  ```

  ```bash
  # Apply seed data (resets and seeds local database)
  supabase db reset

  # This runs:
  # 1. supabase migration up (applies all migrations)
  # 2. supabase/seed.sql (inserts seed data)
  ```

#### Supabase Client Configuration

- [ ] **Task 3.11**: Install and configure Supabase JavaScript client
  ```bash
  # Install Supabase client for Astro
  npm install @supabase/supabase-js
  ```

  **Client configuration (`src/lib/supabase.ts`):**
  ```typescript
  import { createClient } from '@supabase/supabase-js';
  import type { Database } from '../types/supabase';

  // Environment variables
  const supabaseUrl = import.meta.env.SUPABASE_URL || import.meta.env.PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = import.meta.env.SUPABASE_ANON_KEY || import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

  if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Missing Supabase environment variables');
  }

  // Public client (safe for browser)
  export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey, {
    auth: {
      persistSession: false, // Disable for static sites
      autoRefreshToken: false,
    },
  });

  // Server-side client with service role (NEVER expose to client)
  export const supabaseAdmin = createClient<Database>(
    supabaseUrl,
    import.meta.env.SUPABASE_SERVICE_ROLE_KEY,
    {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    }
  );
  ```

  **Example: Contact form submission:**
  ```typescript
  // src/lib/contact.ts
  import { supabase } from './supabase';

  interface ContactFormData {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  export async function submitContactForm(data: ContactFormData) {
    const { error } = await supabase
      .from('contact_submissions')
      .insert({
        name: data.name,
        email: data.email,
        subject: data.subject,
        message: data.message,
      });

    if (error) {
      console.error('Error submitting contact form:', error);
      throw new Error('Failed to submit contact form');
    }

    return { success: true };
  }
  ```

#### Edge Functions for Form Processing

- [ ] **Task 3.12**: Create Edge Function for form validation and email notifications
  ```bash
  # Create new Edge Function
  supabase functions new contact-form-handler
  ```

  **Edge Function (`supabase/functions/contact-form-handler/index.ts`):**
  ```typescript
  import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
  import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  };

  interface ContactPayload {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  serve(async (req) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders });
    }

    try {
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL') ?? '',
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
      );

      const payload: ContactPayload = await req.json();

      // Validate required fields
      if (!payload.name || !payload.email || !payload.message) {
        return new Response(
          JSON.stringify({ error: 'Missing required fields' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Basic email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(payload.email)) {
        return new Response(
          JSON.stringify({ error: 'Invalid email format' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Insert into database
      const { error: dbError } = await supabase
        .from('contact_submissions')
        .insert({
          name: payload.name,
          email: payload.email,
          subject: payload.subject,
          message: payload.message,
          ip_address: req.headers.get('cf-connecting-ip'),
          user_agent: req.headers.get('user-agent'),
          referrer: req.headers.get('referer'),
        });

      if (dbError) throw dbError;

      // TODO: Send email notification (integrate with Resend, SendGrid, etc.)
      // await sendEmailNotification(payload);

      return new Response(
        JSON.stringify({ success: true, message: 'Form submitted successfully' }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    } catch (error) {
      console.error('Error:', error);
      return new Response(
        JSON.stringify({ error: 'Internal server error' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
  });
  ```

  ```bash
  # Deploy Edge Function
  supabase functions deploy contact-form-handler

  # Test locally
  supabase functions serve contact-form-handler

  # Invoke function
  curl -X POST http://localhost:54321/functions/v1/contact-form-handler \
    -H "Authorization: Bearer <anon-key>" \
    -H "Content-Type: application/json" \
    -d '{"name":"Test","email":"test@example.com","message":"Hello"}'
  ```

#### Database Backup Strategy

- [ ] **Task 3.13**: Configure and document backup procedures
  ```bash
  # Supabase provides automatic daily backups for 7 days (free tier)
  # For additional backup strategies:

  # Export database schema
  supabase db dump --schema-only > backup/schema_$(date +%Y%m%d).sql

  # Export full database (data + schema)
  pg_dump "$DATABASE_URL" > backup/full_$(date +%Y%m%d).sql

  # Export specific tables
  pg_dump "$DATABASE_URL" -t contact_submissions -t newsletter_signups > backup/forms_$(date +%Y%m%d).sql
  ```

  **Automated backup script (`scripts/backup-supabase.sh`):**
  ```bash
  #!/bin/bash
  # Supabase database backup script

  set -e

  BACKUP_DIR="./backups"
  DATE=$(date +%Y%m%d_%H%M%S)

  # Create backup directory
  mkdir -p "$BACKUP_DIR"

  # Export schema
  echo "Exporting schema..."
  pg_dump "$DATABASE_URL" --schema-only > "$BACKUP_DIR/schema_$DATE.sql"

  # Export data
  echo "Exporting data..."
  pg_dump "$DATABASE_URL" --data-only > "$BACKUP_DIR/data_$DATE.sql"

  # Compress backups
  gzip "$BACKUP_DIR/schema_$DATE.sql"
  gzip "$BACKUP_DIR/data_$DATE.sql"

  # Remove backups older than 30 days
  find "$BACKUP_DIR" -name "*.sql.gz" -mtime +30 -delete

  echo "Backup completed: $BACKUP_DIR/*_$DATE.sql.gz"
  ```

#### Supabase Tasks Summary

| Task | Description | Status |
|------|-------------|--------|
| 3.1 | Install Supabase CLI | [ ] |
| 3.2 | Authenticate with Supabase | [ ] |
| 3.3 | Create Supabase project | [ ] |
| 3.4 | Retrieve credentials and API keys | [ ] |
| 3.5 | Test database connection | [ ] |
| 3.6 | Initialize local development | [ ] |
| 3.7 | Start local Supabase stack | [ ] |
| 3.8 | Create database schema | [ ] |
| 3.9 | Apply migrations | [ ] |
| 3.10 | Create seed data | [ ] |
| 3.11 | Configure Supabase client | [ ] |
| 3.12 | Create Edge Functions | [ ] |
| 3.13 | Configure backup strategy | [ ] |

### Nhost Alternative BaaS Option

Nhost is an open-source alternative to Supabase that provides a complete backend-as-a-service platform with PostgreSQL, Hasura GraphQL, authentication, storage, and serverless functions. This section documents Nhost as an alternative for projects that prefer a GraphQL-first approach.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           NHOST ARCHITECTURE                                     │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                            NHOST CLOUD                                   │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│  │  │   PostgreSQL    │  │     Hasura      │  │     Auth Service        │  │   │
│  │  │   Database      │  │   GraphQL API   │  │   (JWT-based Auth)      │  │   │
│  │  │   (1GB Free)    │  │   (Auto-gen)    │  │   (Social + Email)      │  │   │
│  │  └────────┬────────┘  └────────┬────────┘  └─────────────────────────┘  │   │
│  │           │                    │                                         │   │
│  │           └─────────┬──────────┘                                         │   │
│  │                     │                                                    │   │
│  │  ┌─────────────────┴─────────────────┐  ┌─────────────────────────────┐ │   │
│  │  │         GraphQL Endpoint          │  │     Serverless Functions    │ │   │
│  │  │  https://<subdomain>.nhost.run    │  │   (Node.js/TypeScript)      │ │   │
│  │  └───────────────────────────────────┘  └─────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                              │                                                   │
│                              │ GraphQL/REST                                      │
│                              ▼                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         CLIENT APPLICATIONS                              │   │
│  │  ┌─────────────────────┐              ┌─────────────────────┐           │   │
│  │  │   Astro Portfolio   │              │   Astro Storefront  │           │   │
│  │  │   - Contact Form    │              │   - Analytics       │           │   │
│  │  │   - Newsletter      │              │   - User Prefs      │           │   │
│  │  └─────────────────────┘              └─────────────────────┘           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Why Consider Nhost?

| Feature | Benefit |
|---------|---------|
| **GraphQL-First** | Hasura auto-generates GraphQL API from PostgreSQL schema |
| **Open Source** | Fully open-source stack, can self-host entire platform |
| **Local Development** | Complete local development environment with Docker |
| **Hasura Console** | Visual database management and API explorer |
| **Built-in Auth** | JWT-based authentication with social providers |
| **Storage** | S3-compatible storage with image transformations |

#### Nhost Free Tier Limits

| Resource | Free Tier Limit | Notes |
|----------|-----------------|-------|
| **Database Size** | 1 GB | PostgreSQL storage limit |
| **Compute** | Shared CPU | Limited serverless compute |
| **Storage** | 1 GB | File storage |
| **Bandwidth** | 5 GB/month | Data transfer |
| **Functions** | 128 MB memory | Serverless function limits |
| **Projects** | 1 project | Free tier limitation |

#### Nhost CLI Installation

- [ ] **Task 3.14**: Install Nhost CLI
  ```bash
  # Install via npm (recommended)
  npm install -g nhost

  # Verify installation
  nhost --version
  # nhost version x.x.x

  # Alternative: Install via Homebrew (macOS)
  brew install nhost/tap/cli

  # Alternative: Install via curl
  curl -L https://raw.githubusercontent.com/nhost/cli/main/get.sh | bash

  # Alternative: Download binary directly
  # Visit: https://github.com/nhost/cli/releases
  ```

- [ ] **Task 3.15**: Authenticate with Nhost
  ```bash
  # Login to Nhost (opens browser for OAuth)
  nhost login

  # Verify authentication
  nhost whoami

  # List available projects
  nhost list
  ```

#### Nhost Project Creation

- [ ] **Task 3.16**: Create a new Nhost project

  **Via Dashboard (Recommended for first time):**
  1. Navigate to [app.nhost.io](https://app.nhost.io)
  2. Click "New Project"
  3. Configure project settings:
     - **Project name**: `danieltarazona-portfolio`
     - **Region**: Choose closest to target audience
       - `eu-central-1` (Frankfurt) - Europe
       - `us-east-1` (N. Virginia) - US East
       - `ap-south-1` (Mumbai) - Asia
     - **Plan**: Free tier
  4. Wait for project provisioning (~3-5 minutes)

  **Via CLI:**
  ```bash
  # Initialize Nhost project in current directory
  nhost init

  # This creates the following structure:
  # nhost/
  # ├── config.yaml       # Nhost configuration
  # ├── metadata/         # Hasura metadata
  # ├── migrations/       # Database migrations
  # └── seeds/            # Seed data

  # Link to existing cloud project
  nhost link

  # Select project from list and link
  ```

#### Local Development Setup

- [ ] **Task 3.17**: Initialize and run local Nhost development environment
  ```bash
  # Initialize Nhost in project directory
  cd danieltarazona-portfolio
  nhost init

  # Start local Nhost stack (requires Docker)
  nhost up

  # Output will show local URLs:
  # ┌─────────────────────────────────────────────────────────────────────┐
  # │ Nhost development environment started.                              │
  # ├─────────────────────────────────────────────────────────────────────┤
  # │ GraphQL:    http://localhost:1337/v1/graphql                       │
  # │ Auth:       http://localhost:1337/v1/auth                          │
  # │ Storage:    http://localhost:1337/v1/storage                       │
  # │ Functions:  http://localhost:1337/v1/functions                     │
  # │ Dashboard:  http://localhost:1337                                  │
  # │ Postgres:   postgres://postgres:postgres@localhost:5432/postgres   │
  # │ Hasura:     http://localhost:8080 (console)                        │
  # └─────────────────────────────────────────────────────────────────────┘

  # Stop local development
  nhost down

  # Stop and remove all data
  nhost down --volumes
  ```

  **Local Configuration (`nhost/config.yaml`):**
  ```yaml
  # nhost/config.yaml
  [global]
  [[global.environment]]
  name = "HASURA_GRAPHQL_ADMIN_SECRET"
  value = "nhost-admin-secret"

  [hasura]
  version = "v2.36.0-ce"
  adminSecret = "nhost-admin-secret"
  webhookSecret = "nhost-webhook-secret"

  [hasura.settings]
  enableConsole = true
  enableRemoteSchemaPermissions = false
  devMode = true

  [auth]
  version = "0.24.1"

  [auth.method.emailPassword]
  emailVerificationRequired = false
  hibpEnabled = false

  [auth.method.anonymous]
  enabled = false

  [postgres]
  version = "14.6-20230705-2"

  [storage]
  version = "0.6.0"
  ```

#### Database Schema with Hasura Migrations

- [ ] **Task 3.18**: Create database schema using Hasura migrations
  ```bash
  # Create a new migration
  nhost hasura migrate create create_portfolio_tables --database-name default

  # This creates:
  # nhost/migrations/default/<timestamp>_create_portfolio_tables/up.sql
  # nhost/migrations/default/<timestamp>_create_portfolio_tables/down.sql
  ```

  **Migration file (`nhost/migrations/default/<timestamp>_create_portfolio_tables/up.sql`):**
  ```sql
  -- Contact Form Submissions Table
  CREATE TABLE IF NOT EXISTS public.contact_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    subject VARCHAR(500),
    message TEXT NOT NULL,
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    replied_at TIMESTAMPTZ,
    archived BOOLEAN DEFAULT FALSE
  );

  -- Newsletter Signups Table
  CREATE TABLE IF NOT EXISTS public.newsletter_signups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    source VARCHAR(100),
    confirmed BOOLEAN DEFAULT FALSE,
    confirmation_token UUID DEFAULT gen_random_uuid(),
    confirmed_at TIMESTAMPTZ,
    unsubscribed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Analytics Events Table
  CREATE TABLE IF NOT EXISTS public.analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL,
    page_path VARCHAR(500),
    referrer TEXT,
    user_agent TEXT,
    ip_hash VARCHAR(64),
    session_id VARCHAR(100),
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Create indexes
  CREATE INDEX idx_contact_created ON public.contact_submissions(created_at DESC);
  CREATE INDEX idx_newsletter_email ON public.newsletter_signups(email);
  CREATE INDEX idx_analytics_event ON public.analytics_events(event_type, created_at DESC);
  ```

  **Rollback migration (`nhost/migrations/default/<timestamp>_create_portfolio_tables/down.sql`):**
  ```sql
  DROP TABLE IF EXISTS public.analytics_events;
  DROP TABLE IF EXISTS public.newsletter_signups;
  DROP TABLE IF EXISTS public.contact_submissions;
  ```

  ```bash
  # Apply migrations locally
  nhost hasura migrate apply --database-name default

  # Check migration status
  nhost hasura migrate status --database-name default

  # Push migrations to production
  nhost hasura migrate apply --database-name default --endpoint https://<subdomain>.hasura.nhost.run --admin-secret <admin-secret>
  ```

#### Hasura Permissions & Metadata

- [ ] **Task 3.19**: Configure Hasura permissions for public access
  ```bash
  # Export current metadata (if using Hasura Console)
  nhost hasura metadata export

  # Apply metadata from files
  nhost hasura metadata apply
  ```

  **Table permissions (`nhost/metadata/databases/default/tables/public_contact_submissions.yaml`):**
  ```yaml
  table:
    name: contact_submissions
    schema: public
  insert_permissions:
    - role: public
      permission:
        check: {}
        columns:
          - name
          - email
          - subject
          - message
  select_permissions:
    - role: admin
      permission:
        columns: "*"
        filter: {}
  ```

#### Nhost Client Configuration

- [ ] **Task 3.20**: Install and configure Nhost JavaScript client
  ```bash
  # Install Nhost client packages
  npm install @nhost/nhost-js
  # Or for React:
  npm install @nhost/react
  ```

  **Client configuration (`src/lib/nhost.ts`):**
  ```typescript
  import { NhostClient } from '@nhost/nhost-js';

  // Environment variables
  const nhostSubdomain = import.meta.env.NHOST_SUBDOMAIN || import.meta.env.PUBLIC_NHOST_SUBDOMAIN;
  const nhostRegion = import.meta.env.NHOST_REGION || import.meta.env.PUBLIC_NHOST_REGION;

  if (!nhostSubdomain || !nhostRegion) {
    throw new Error('Missing Nhost environment variables');
  }

  // Create Nhost client
  export const nhost = new NhostClient({
    subdomain: nhostSubdomain,
    region: nhostRegion,
  });

  // For local development
  export const nhostLocal = new NhostClient({
    subdomain: 'local',
    region: '',
    backendUrl: 'http://localhost:1337',
  });
  ```

  **Example: GraphQL query for contact form submission:**
  ```typescript
  // src/lib/contact-nhost.ts
  import { nhost } from './nhost';

  interface ContactFormData {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  const INSERT_CONTACT_MUTATION = `
    mutation InsertContact($object: contact_submissions_insert_input!) {
      insert_contact_submissions_one(object: $object) {
        id
        created_at
      }
    }
  `;

  export async function submitContactForm(data: ContactFormData) {
    const { data: result, error } = await nhost.graphql.request(
      INSERT_CONTACT_MUTATION,
      {
        object: {
          name: data.name,
          email: data.email,
          subject: data.subject,
          message: data.message,
        },
      }
    );

    if (error) {
      console.error('Error submitting contact form:', error);
      throw new Error('Failed to submit contact form');
    }

    return { success: true, id: result.insert_contact_submissions_one.id };
  }
  ```

#### Nhost Serverless Functions

- [ ] **Task 3.21**: Create serverless function for form processing
  ```bash
  # Create functions directory
  mkdir -p nhost/functions

  # Create a new function
  touch nhost/functions/contact-handler.ts
  ```

  **Function file (`nhost/functions/contact-handler.ts`):**
  ```typescript
  import { Request, Response } from 'express';

  interface ContactPayload {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  export default async (req: Request, res: Response) => {
    // Only allow POST requests
    if (req.method !== 'POST') {
      return res.status(405).json({ error: 'Method not allowed' });
    }

    try {
      const payload: ContactPayload = req.body;

      // Validate required fields
      if (!payload.name || !payload.email || !payload.message) {
        return res.status(400).json({ error: 'Missing required fields' });
      }

      // Basic email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(payload.email)) {
        return res.status(400).json({ error: 'Invalid email format' });
      }

      // Insert via GraphQL (using admin secret for server-side)
      const HASURA_ENDPOINT = process.env.NHOST_HASURA_URL + '/v1/graphql';
      const HASURA_ADMIN_SECRET = process.env.NHOST_ADMIN_SECRET;

      const response = await fetch(HASURA_ENDPOINT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-hasura-admin-secret': HASURA_ADMIN_SECRET || '',
        },
        body: JSON.stringify({
          query: `
            mutation InsertContact($object: contact_submissions_insert_input!) {
              insert_contact_submissions_one(object: $object) {
                id
              }
            }
          `,
          variables: {
            object: {
              name: payload.name,
              email: payload.email,
              subject: payload.subject,
              message: payload.message,
              ip_address: req.headers['x-forwarded-for'] || req.ip,
              user_agent: req.headers['user-agent'],
              referrer: req.headers['referer'],
            },
          },
        }),
      });

      const result = await response.json();

      if (result.errors) {
        throw new Error(result.errors[0].message);
      }

      // TODO: Send email notification

      return res.status(200).json({
        success: true,
        message: 'Form submitted successfully',
        id: result.data.insert_contact_submissions_one.id,
      });
    } catch (error) {
      console.error('Error:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  };
  ```

  ```bash
  # Deploy functions to Nhost
  nhost deploy

  # Test function locally
  curl -X POST http://localhost:1337/v1/functions/contact-handler \
    -H "Content-Type: application/json" \
    -d '{"name":"Test","email":"test@example.com","message":"Hello"}'
  ```

#### Environment Variables for Nhost

```bash
# .env file for Nhost configuration
# Nhost Cloud Configuration
NHOST_SUBDOMAIN=your-project-subdomain
NHOST_REGION=eu-central-1
NHOST_ADMIN_SECRET=your-admin-secret

# Public keys (safe for client-side)
PUBLIC_NHOST_SUBDOMAIN=your-project-subdomain
PUBLIC_NHOST_REGION=eu-central-1

# Local Development
NHOST_HASURA_URL=http://localhost:1337
NHOST_GRAPHQL_URL=http://localhost:1337/v1/graphql
NHOST_AUTH_URL=http://localhost:1337/v1/auth
NHOST_STORAGE_URL=http://localhost:1337/v1/storage
NHOST_FUNCTIONS_URL=http://localhost:1337/v1/functions
```

### Supabase vs Nhost Comparison

This comparison helps determine which BaaS platform is better suited for the danieltarazona.com portfolio and store project.

#### Feature Comparison

| Feature | Supabase | Nhost | Winner |
|---------|----------|-------|--------|
| **Database** | PostgreSQL | PostgreSQL | Tie |
| **API Style** | REST + PostgREST | GraphQL (Hasura) | Depends on preference |
| **Free Tier Storage** | 500 MB | 1 GB | Nhost |
| **Free Tier Bandwidth** | 2 GB/month | 5 GB/month | Nhost |
| **Authentication** | GoTrue (JWT) | Hasura Auth (JWT) | Tie |
| **File Storage** | S3-compatible | S3-compatible | Tie |
| **Edge Functions** | Deno-based | Node.js/TypeScript | Supabase |
| **Realtime** | Built-in WebSocket | Hasura Subscriptions | Tie |
| **Local Development** | Full Docker stack | Full Docker stack | Tie |
| **Open Source** | Yes (Apache 2.0) | Yes (MIT) | Tie |
| **Self-Hosting** | Complex setup | Docker Compose ready | Nhost |
| **Community Size** | Larger | Smaller | Supabase |
| **Documentation** | Excellent | Good | Supabase |
| **CLI Maturity** | Mature | Good | Supabase |

#### API Style Comparison

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           API STYLE COMPARISON                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  SUPABASE (REST + PostgREST):                                                   │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │  // Simple and familiar REST-style queries                                  │ │
│  │  const { data, error } = await supabase                                    │ │
│  │    .from('contact_submissions')                                            │ │
│  │    .select('*')                                                            │ │
│  │    .order('created_at', { ascending: false })                              │ │
│  │    .limit(10);                                                             │ │
│  │                                                                             │ │
│  │  // Easy inserts                                                           │ │
│  │  const { error } = await supabase                                          │ │
│  │    .from('contact_submissions')                                            │ │
│  │    .insert({ name, email, message });                                      │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
│  NHOST (GraphQL via Hasura):                                                    │
│  ┌────────────────────────────────────────────────────────────────────────────┐ │
│  │  // Powerful GraphQL with type safety                                       │ │
│  │  const { data, error } = await nhost.graphql.request(`                     │ │
│  │    query GetContacts {                                                     │ │
│  │      contact_submissions(                                                  │ │
│  │        order_by: { created_at: desc },                                     │ │
│  │        limit: 10                                                           │ │
│  │      ) {                                                                   │ │
│  │        id name email message created_at                                    │ │
│  │      }                                                                     │ │
│  │    }                                                                       │ │
│  │  `);                                                                       │ │
│  │                                                                             │ │
│  │  // Mutations with variables                                               │ │
│  │  const { data, error } = await nhost.graphql.request(                      │ │
│  │    INSERT_CONTACT_MUTATION,                                                │ │
│  │    { object: { name, email, message } }                                    │ │
│  │  );                                                                        │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Use Case Recommendations

| Use Case | Recommended Platform | Reason |
|----------|---------------------|--------|
| **Simple CRUD operations** | Supabase | REST API is more familiar, less boilerplate |
| **Complex nested queries** | Nhost | GraphQL excels at fetching related data |
| **Real-time updates** | Tie | Both support WebSocket subscriptions |
| **Form submissions** | Supabase | Simpler RLS policies, easier setup |
| **Admin dashboards** | Nhost | Hasura Console is excellent for data exploration |
| **Serverless functions** | Supabase | Deno-based functions with better edge deployment |
| **Self-hosting** | Nhost | More mature self-hosting documentation |
| **Team collaboration** | Supabase | Better dashboard UI and team features |

#### Recommendation for This Project

For the **danieltarazona.com portfolio and store** project, **Supabase is recommended** as the primary choice:

**Reasons:**
1. **Simpler Learning Curve**: REST API is more familiar for developers without GraphQL experience
2. **Better Documentation**: More comprehensive guides and examples
3. **Edge Functions**: Deno-based functions integrate well with Cloudflare Workers
4. **Contact Form Use Case**: Simple INSERT operations don't require GraphQL complexity
5. **Larger Community**: More Stack Overflow answers and community resources
6. **Free Tier**: 500MB is sufficient for portfolio + contact forms

**When to Choose Nhost Instead:**
- If you have existing GraphQL experience
- If you need the Hasura Console for complex data exploration
- If you plan to self-host the entire stack
- If you need more complex relational queries

#### Nhost Tasks Summary

| Task | Description | Status |
|------|-------------|--------|
| 3.14 | Install Nhost CLI | [ ] |
| 3.15 | Authenticate with Nhost | [ ] |
| 3.16 | Create Nhost project | [ ] |
| 3.17 | Initialize local development | [ ] |
| 3.18 | Create database schema | [ ] |
| 3.19 | Configure Hasura permissions | [ ] |
| 3.20 | Configure Nhost client | [ ] |
| 3.21 | Create serverless functions | [ ] |

### Medusa 2.0 E-Commerce Backend

Medusa 2.0 is a modular, open-source headless commerce platform built with TypeScript and Node.js. It provides a complete backend for e-commerce including product management, order processing, inventory tracking, and a built-in admin dashboard. For this project, Medusa 2.0 powers the `store.danieltarazona.com` storefront with a limit of 100 products.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         MEDUSA 2.0 ARCHITECTURE                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                          MEDUSA 2.0 BACKEND                              │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│  │  │   PostgreSQL    │  │   REST API      │  │     Admin Dashboard     │  │   │
│  │  │   Database      │  │   Endpoints     │  │   (Built-in React UI)   │  │   │
│  │  │   (Products,    │  │   /store/*      │  │   /app (default path)   │  │   │
│  │  │    Orders)      │  │   /admin/*      │  │                         │  │   │
│  │  └────────┬────────┘  └────────┬────────┘  └─────────────────────────┘  │   │
│  │           │                    │                                         │   │
│  │           └─────────┬──────────┘                                         │   │
│  │                     │                                                    │   │
│  │  ┌─────────────────┴─────────────────┐  ┌─────────────────────────────┐ │   │
│  │  │         Core Modules              │  │     Medusa Workflows        │ │   │
│  │  │  • Product Module                 │  │   (Business Logic SDK)      │ │   │
│  │  │  • Order Module                   │  │   • Checkout flow           │ │   │
│  │  │  • Cart Module                    │  │   • Inventory updates       │ │   │
│  │  │  • Customer Module                │  │   • Order processing        │ │   │
│  │  │  • Inventory Module               │  └─────────────────────────────┘ │   │
│  │  │  • Payment Module                 │                                   │   │
│  │  └───────────────────────────────────┘                                   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                              │                                                   │
│                              │ HTTP/REST API                                     │
│                              ▼                                                   │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         CLIENT APPLICATIONS                              │   │
│  │  ┌─────────────────────┐              ┌─────────────────────┐           │   │
│  │  │   Astro Storefront  │              │   Next.js Starter   │           │   │
│  │  │   (Custom Build)    │              │   (Official)        │           │   │
│  │  │   - Product pages   │              │   - Ready to use    │           │   │
│  │  │   - Cart/Checkout   │              │   - Server actions  │           │   │
│  │  └─────────────────────┘              └─────────────────────┘           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Why Medusa 2.0 for This Project?

| Feature | Benefit |
|---------|---------|
| **Open Source** | Full control, no vendor lock-in, MIT licensed |
| **Self-Hosted** | Data ownership, deploy on own VPS (Coolify) |
| **100 Products** | Perfect for small catalog, no scaling concerns |
| **TypeScript** | Type-safe development, excellent IDE support |
| **Modular Architecture** | Use only needed modules, extend with custom logic |
| **Built-in Admin** | No need for separate admin panel |
| **REST API** | Easy integration with Astro storefront |

#### Product Limits & Scope

For the `store.danieltarazona.com` project, we're working within these constraints:

| Resource | Limit | Rationale |
|----------|-------|-----------|
| **Products** | 100 max | Small catalog, curated selection |
| **Variants per Product** | 20 max | Reasonable for size/color combos |
| **Product Images** | 10 per product | High-quality photography focus |
| **Categories** | 20 max | Simple navigation structure |
| **Collections** | 10 max | Featured/seasonal groupings |

**Storage Estimation:**
```
Products:         100 × ~5KB average  =   500 KB
Product Images:   100 × 10 × 500KB    =   500 MB (stored in S3/Cloudflare R2)
Orders (yearly):  ~500 × 2KB          =     1 MB
Customers:        ~200 × 1KB          =   200 KB
───────────────────────────────────────────────
Database Total:                       ~   10 MB (PostgreSQL)
File Storage:                         ~  500 MB (external storage)
```

#### Medusa CLI Installation

- [ ] **Task 3.22**: Install Medusa CLI globally
  ```bash
  # Install Medusa CLI via npm (recommended)
  npm install -g @medusajs/medusa-cli

  # Verify installation
  medusa --version
  # @medusajs/medusa-cli/x.x.x

  # Alternative: Use npx without global install
  npx @medusajs/medusa-cli --version

  # View available commands
  medusa --help
  ```

  **Available CLI Commands:**
  | Command | Description |
  |---------|-------------|
  | `medusa new` | Create a new Medusa project |
  | `medusa develop` | Start development server with hot reload |
  | `medusa build` | Build for production |
  | `medusa start` | Start production server |
  | `medusa db:setup` | Create database and run migrations |
  | `medusa db:migrate` | Run pending migrations |
  | `medusa user` | Create admin user |

#### Project Scaffolding

- [ ] **Task 3.23**: Create new Medusa 2.0 project
  ```bash
  # Create new project using create-medusa-app (recommended)
  npx create-medusa-app@latest danieltarazona-store

  # Interactive prompts will ask:
  # 1. Project name: danieltarazona-store
  # 2. Install Next.js storefront? (optional)
  # 3. PostgreSQL database name

  # Alternative: Create with specific version
  npx create-medusa-app@latest danieltarazona-store --version 2.3.0

  # Alternative: Create plugin project
  npx create-medusa-app@latest my-medusa-plugin --plugin
  ```

  **Project Structure Created:**
  ```
  danieltarazona-store/
  ├── .medusa/                # Build output directory
  ├── src/
  │   ├── admin/              # Admin dashboard customizations
  │   │   ├── widgets/        # Custom dashboard widgets
  │   │   └── routes/         # Custom admin pages
  │   ├── api/                # Custom API routes
  │   │   ├── store/          # Storefront API extensions
  │   │   └── admin/          # Admin API extensions
  │   ├── jobs/               # Background job handlers
  │   ├── links/              # Module links (relations)
  │   ├── modules/            # Custom modules
  │   ├── subscribers/        # Event subscribers
  │   └── workflows/          # Custom business workflows
  ├── integration-tests/      # Integration test files
  ├── medusa-config.ts        # Main configuration file
  ├── package.json
  ├── tsconfig.json
  └── .env                    # Environment variables
  ```

- [ ] **Task 3.24**: Navigate and verify project structure
  ```bash
  # Enter project directory
  cd danieltarazona-store

  # Install dependencies (if not done automatically)
  npm install

  # Build the project
  npm run build

  # Verify structure
  ls -la src/
  ```

#### Database Configuration

- [ ] **Task 3.25**: Configure PostgreSQL database for Medusa

  **Option A: Local PostgreSQL (Development)**
  ```bash
  # Install PostgreSQL (macOS)
  brew install postgresql@15
  brew services start postgresql@15

  # Install PostgreSQL (Ubuntu/Debian)
  sudo apt update
  sudo apt install postgresql postgresql-contrib
  sudo systemctl start postgresql

  # Create database
  createdb danieltarazona_store

  # Or via psql
  psql -U postgres -c "CREATE DATABASE danieltarazona_store;"
  ```

  **Option B: Docker PostgreSQL (Recommended for Consistency)**
  ```bash
  # Create docker-compose.yml for local database
  cat > docker-compose.yml << 'EOF'
  version: '3.8'
  services:
    postgres:
      image: postgres:15-alpine
      container_name: medusa-postgres
      environment:
        POSTGRES_USER: medusa
        POSTGRES_PASSWORD: medusa_password
        POSTGRES_DB: danieltarazona_store
      ports:
        - "5432:5432"
      volumes:
        - medusa_postgres_data:/var/lib/postgresql/data
      healthcheck:
        test: ["CMD-SHELL", "pg_isready -U medusa -d danieltarazona_store"]
        interval: 5s
        timeout: 5s
        retries: 5

    redis:
      image: redis:7-alpine
      container_name: medusa-redis
      ports:
        - "6379:6379"
      volumes:
        - medusa_redis_data:/data

  volumes:
    medusa_postgres_data:
    medusa_redis_data:
  EOF

  # Start containers
  docker-compose up -d

  # Verify containers are running
  docker-compose ps
  ```

  **Option C: Supabase PostgreSQL (Production)**
  ```bash
  # Use existing Supabase project for Medusa
  # Connection string from Supabase dashboard:
  # postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

  # Or create dedicated database in Supabase
  # Settings > Database > New Database
  ```

#### Environment Variables

- [ ] **Task 3.26**: Configure environment variables for Medusa

  **Create `.env` file:**
  ```bash
  cat > .env << 'EOF'
  # ============================================
  # MEDUSA 2.0 ENVIRONMENT CONFIGURATION
  # ============================================

  # Database Configuration
  # ----------------------
  # Local Docker PostgreSQL
  DATABASE_URL=postgresql://medusa:medusa_password@localhost:5432/danieltarazona_store

  # Or Supabase PostgreSQL (Production)
  # DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

  # Database name (optional if included in DATABASE_URL)
  DB_NAME=danieltarazona_store

  # Redis Configuration (for events, caching, sessions)
  # ---------------------------------------------------
  REDIS_URL=redis://localhost:6379

  # Security Secrets (GENERATE SECURE VALUES FOR PRODUCTION!)
  # ---------------------------------------------------------
  # Generate with: openssl rand -hex 32
  COOKIE_SECRET=supersecret_change_in_production_abc123
  JWT_SECRET=supersecret_change_in_production_xyz789

  # CORS Configuration
  # ------------------
  # Storefront URL (Astro site)
  STORE_CORS=http://localhost:4321,https://store.danieltarazona.com

  # Admin dashboard URL
  ADMIN_CORS=http://localhost:9000,https://admin.danieltarazona.com

  # Auth endpoints (comma-separated storefront and admin URLs)
  AUTH_CORS=http://localhost:4321,http://localhost:9000,https://store.danieltarazona.com,https://admin.danieltarazona.com

  # Server Configuration
  # --------------------
  PORT=9000
  MEDUSA_BACKEND_URL=http://localhost:9000

  # Admin Dashboard
  # ---------------
  DISABLE_MEDUSA_ADMIN=false
  ADMIN_PATH=/app

  # Worker Mode (server | worker | shared)
  # --------------------------------------
  # server: API + Admin only
  # worker: Background jobs only
  # shared: Both API and worker (default for development)
  MEDUSA_WORKER_MODE=shared

  # Environment
  # -----------
  NODE_ENV=development
  EOF

  # Secure the file
  chmod 600 .env
  ```

  **Environment Variables Reference:**

  | Variable | Required | Description | Example |
  |----------|----------|-------------|---------|
  | `DATABASE_URL` | ✅ | PostgreSQL connection string | `postgresql://user:pass@host:5432/db` |
  | `REDIS_URL` | ⚠️ | Redis connection (required for events) | `redis://localhost:6379` |
  | `COOKIE_SECRET` | ✅ | Session cookie encryption key | 32+ char random string |
  | `JWT_SECRET` | ✅ | JWT token signing key | 32+ char random string |
  | `STORE_CORS` | ✅ | Allowed storefront origins | `https://store.example.com` |
  | `ADMIN_CORS` | ✅ | Allowed admin origins | `https://admin.example.com` |
  | `AUTH_CORS` | ✅ | Allowed auth origins | Comma-separated URLs |
  | `PORT` | ❌ | Server port (default: 9000) | `9000` |
  | `MEDUSA_WORKER_MODE` | ❌ | Worker configuration | `server`, `worker`, `shared` |
  | `DISABLE_MEDUSA_ADMIN` | ❌ | Disable admin dashboard | `true` or `false` |

  **Generate Secure Secrets:**
  ```bash
  # Generate COOKIE_SECRET
  echo "COOKIE_SECRET=$(openssl rand -hex 32)"

  # Generate JWT_SECRET
  echo "JWT_SECRET=$(openssl rand -hex 32)"
  ```

#### Medusa Configuration File

- [ ] **Task 3.27**: Configure `medusa-config.ts`
  ```typescript
  // medusa-config.ts
  import { defineConfig } from "@medusajs/medusa";
  import { loadEnv } from "@medusajs/utils";

  // Load environment variables
  loadEnv(process.env.NODE_ENV || "development", process.cwd());

  export default defineConfig({
    // Project configuration
    projectConfig: {
      // Database connection
      databaseUrl: process.env.DATABASE_URL,
      databaseName: process.env.DB_NAME || "danieltarazona_store",

      // Redis for events and caching
      redisUrl: process.env.REDIS_URL,

      // Server settings
      http: {
        storeCors: process.env.STORE_CORS || "http://localhost:4321",
        adminCors: process.env.ADMIN_CORS || "http://localhost:9000",
        authCors: process.env.AUTH_CORS || "http://localhost:4321,http://localhost:9000",
        jwtSecret: process.env.JWT_SECRET || "supersecret",
        cookieSecret: process.env.COOKIE_SECRET || "supersecret",
      },

      // Worker mode
      workerMode: process.env.MEDUSA_WORKER_MODE as "server" | "worker" | "shared" || "shared",
    },

    // Admin dashboard configuration
    admin: {
      // Dashboard path (default: /app)
      path: process.env.ADMIN_PATH || "/app",

      // Disable admin (for separate deployment)
      disable: process.env.DISABLE_MEDUSA_ADMIN === "true",

      // Backend URL for admin API calls
      backendUrl: process.env.MEDUSA_BACKEND_URL || "http://localhost:9000",
    },

    // Modules configuration
    modules: [
      // Core modules are included by default:
      // - Product, Order, Cart, Customer, Inventory, Payment, etc.

      // Add custom modules here:
      // {
      //   resolve: "./src/modules/custom-module",
      //   options: { /* module options */ },
      // },
    ],
  });
  ```

#### Database Setup & Migrations

- [ ] **Task 3.28**: Initialize database and run migrations
  ```bash
  # Setup database (creates DB if not exists + runs migrations)
  npx medusa db:setup

  # Or run migrations only (if database exists)
  npx medusa db:migrate

  # Check migration status
  npx medusa db:migrate --status

  # Generate new migration (after schema changes)
  npx medusa db:generate my_migration_name

  # Rollback last migration
  npx medusa db:rollback
  ```

  **Database Schema Overview:**
  ```
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │                         MEDUSA DATABASE SCHEMA                                   │
  ├─────────────────────────────────────────────────────────────────────────────────┤
  │                                                                                  │
  │  CORE TABLES (auto-created by Medusa):                                          │
  │  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐           │
  │  │     product       │  │   product_variant │  │  product_option   │           │
  │  │  - id             │  │  - id             │  │  - id             │           │
  │  │  - title          │  │  - product_id     │  │  - product_id     │           │
  │  │  - handle         │  │  - title          │  │  - title          │           │
  │  │  - description    │  │  - sku            │  │  - values[]       │           │
  │  │  - status         │  │  - prices[]       │  └───────────────────┘           │
  │  │  - metadata       │  │  - inventory_qty  │                                   │
  │  └───────────────────┘  └───────────────────┘                                   │
  │                                                                                  │
  │  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐           │
  │  │      order        │  │    line_item      │  │     customer      │           │
  │  │  - id             │  │  - id             │  │  - id             │           │
  │  │  - customer_id    │  │  - order_id       │  │  - email          │           │
  │  │  - status         │  │  - variant_id     │  │  - first_name     │           │
  │  │  - total          │  │  - quantity       │  │  - last_name      │           │
  │  │  - currency_code  │  │  - unit_price     │  │  - metadata       │           │
  │  └───────────────────┘  └───────────────────┘  └───────────────────┘           │
  │                                                                                  │
  │  ┌───────────────────┐  ┌───────────────────┐  ┌───────────────────┐           │
  │  │       cart        │  │   payment         │  │   fulfillment     │           │
  │  │  - id             │  │  - id             │  │  - id             │           │
  │  │  - customer_id    │  │  - order_id       │  │  - order_id       │           │
  │  │  - items[]        │  │  - provider_id    │  │  - provider_id    │           │
  │  │  - region_id      │  │  - amount         │  │  - status         │           │
  │  └───────────────────┘  └───────────────────┘  └───────────────────┘           │
  │                                                                                  │
  └─────────────────────────────────────────────────────────────────────────────────┘
  ```

- [ ] **Task 3.29**: Create admin user
  ```bash
  # Create admin user for dashboard access
  npx medusa user -e admin@danieltarazona.com -p SecurePassword123!

  # Or with interactive prompt
  npx medusa user

  # Output:
  # User admin@danieltarazona.com created successfully
  ```

#### Starting Development Server

- [ ] **Task 3.30**: Start Medusa development server
  ```bash
  # Start development server (with hot reload)
  npx medusa develop

  # Output:
  # ┌─────────────────────────────────────────────────────┐
  # │  Medusa server is running!                          │
  # ├─────────────────────────────────────────────────────┤
  # │  Admin:     http://localhost:9000/app               │
  # │  Store API: http://localhost:9000/store             │
  # │  Admin API: http://localhost:9000/admin             │
  # │  Health:    http://localhost:9000/health            │
  # └─────────────────────────────────────────────────────┘

  # Alternative: Start with specific port
  PORT=8000 npx medusa develop

  # Build for production
  npx medusa build

  # Start production server
  npx medusa start

  # Build admin dashboard only (for separate deployment)
  npx medusa build --admin-only
  ```

  **Verify Server is Running:**
  ```bash
  # Health check
  curl http://localhost:9000/health
  # Response: {"status":"ok"}

  # Store API - List products
  curl http://localhost:9000/store/products

  # Admin API requires authentication
  curl http://localhost:9000/admin/products \
    -H "Authorization: Bearer <jwt-token>"
  ```

#### Medusa JS SDK for Storefront

- [ ] **Task 3.31**: Configure Medusa JS SDK for Astro storefront
  ```bash
  # Install Medusa SDK in storefront project
  cd ../danieltarazona-storefront  # Astro project
  npm install @medusajs/js-sdk@latest @medusajs/types@latest
  ```

  **SDK Configuration (`src/lib/medusa.ts`):**
  ```typescript
  import Medusa from "@medusajs/js-sdk";

  // Environment variables
  const MEDUSA_BACKEND_URL = import.meta.env.PUBLIC_MEDUSA_URL || "http://localhost:9000";

  // Create SDK instance for storefront
  export const medusa = new Medusa({
    baseUrl: MEDUSA_BACKEND_URL,
    debug: import.meta.env.DEV,
    auth: {
      type: "session",
    },
  });

  // Type-safe API helpers
  export async function getProducts(limit = 12, offset = 0) {
    const { products, count } = await medusa.store.product.list({
      limit,
      offset,
    });
    return { products, count };
  }

  export async function getProductByHandle(handle: string) {
    const { products } = await medusa.store.product.list({
      handle,
    });
    return products[0] || null;
  }

  export async function getCategories() {
    const { product_categories } = await medusa.store.category.list();
    return product_categories;
  }

  export async function createCart(regionId: string) {
    const { cart } = await medusa.store.cart.create({
      region_id: regionId,
    });
    return cart;
  }

  export async function addToCart(cartId: string, variantId: string, quantity = 1) {
    const { cart } = await medusa.store.cart.createLineItem(cartId, {
      variant_id: variantId,
      quantity,
    });
    return cart;
  }
  ```

  **Environment Variables for Storefront:**
  ```bash
  # .env in Astro storefront project
  PUBLIC_MEDUSA_URL=http://localhost:9000
  # Production:
  # PUBLIC_MEDUSA_URL=https://api.danieltarazona.com
  ```

#### Production Deployment Checklist

- [ ] **Task 3.32**: Prepare Medusa for production deployment

  **Security Checklist:**
  ```bash
  # 1. Generate production secrets
  COOKIE_SECRET=$(openssl rand -hex 32)
  JWT_SECRET=$(openssl rand -hex 32)

  # 2. Update CORS settings for production domains only
  STORE_CORS=https://store.danieltarazona.com
  ADMIN_CORS=https://admin.danieltarazona.com
  AUTH_CORS=https://store.danieltarazona.com,https://admin.danieltarazona.com

  # 3. Use production database (Supabase or managed PostgreSQL)
  DATABASE_URL=postgresql://user:password@host:5432/database?sslmode=require

  # 4. Enable SSL/TLS for all connections
  # 5. Set NODE_ENV=production
  NODE_ENV=production
  ```

  **Docker Production Setup:**
  ```dockerfile
  # Dockerfile for Medusa production
  FROM node:20-alpine AS builder

  WORKDIR /app

  # Copy package files
  COPY package*.json ./

  # Install dependencies
  RUN npm ci --only=production

  # Copy source code
  COPY . .

  # Build the application
  RUN npm run build

  # Production stage
  FROM node:20-alpine AS runner

  WORKDIR /app

  # Copy built application
  COPY --from=builder /app/.medusa ./.medusa
  COPY --from=builder /app/node_modules ./node_modules
  COPY --from=builder /app/package.json ./package.json
  COPY --from=builder /app/medusa-config.ts ./medusa-config.ts

  # Set environment
  ENV NODE_ENV=production
  ENV PORT=9000

  EXPOSE 9000

  # Health check
  HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9000/health || exit 1

  # Start server
  CMD ["npm", "run", "start"]
  ```

  **docker-compose.production.yml:**
  ```yaml
  version: '3.8'
  services:
    medusa:
      build:
        context: .
        dockerfile: Dockerfile
      container_name: medusa-backend
      environment:
        - NODE_ENV=production
        - DATABASE_URL=${DATABASE_URL}
        - REDIS_URL=${REDIS_URL}
        - COOKIE_SECRET=${COOKIE_SECRET}
        - JWT_SECRET=${JWT_SECRET}
        - STORE_CORS=${STORE_CORS}
        - ADMIN_CORS=${ADMIN_CORS}
        - AUTH_CORS=${AUTH_CORS}
      ports:
        - "9000:9000"
      depends_on:
        - redis
      restart: unless-stopped

    redis:
      image: redis:7-alpine
      container_name: medusa-redis
      volumes:
        - redis_data:/data
      restart: unless-stopped

  volumes:
    redis_data:
  ```

#### Medusa Tasks Summary

| Task | Description | Status |
|------|-------------|--------|
| 3.22 | Install Medusa CLI | [ ] |
| 3.23 | Create new Medusa project | [ ] |
| 3.24 | Verify project structure | [ ] |
| 3.25 | Configure PostgreSQL database | [ ] |
| 3.26 | Set up environment variables | [ ] |
| 3.27 | Configure medusa-config.ts | [ ] |
| 3.28 | Run database migrations | [ ] |
| 3.29 | Create admin user | [ ] |
| 3.30 | Start development server | [ ] |
| 3.31 | Configure Medusa JS SDK | [ ] |
| 3.32 | Prepare production deployment | [ ] |

#### Medusa API Quick Reference

**Store API Endpoints (Public):**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/store/products` | GET | List products |
| `/store/products/:id` | GET | Get product by ID |
| `/store/collections` | GET | List collections |
| `/store/categories` | GET | List categories |
| `/store/carts` | POST | Create cart |
| `/store/carts/:id` | GET | Get cart |
| `/store/carts/:id/line-items` | POST | Add item to cart |
| `/store/carts/:id/complete` | POST | Complete checkout |

**Admin API Endpoints (Authenticated):**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/admin/products` | GET/POST | Manage products |
| `/admin/orders` | GET | List orders |
| `/admin/customers` | GET | List customers |
| `/admin/inventory-items` | GET | Manage inventory |

---

## Vendure vs Medusa 2.0: Multi-Brand/Multi-Domain Comparison

This comparison evaluates both headless e-commerce platforms for future multi-brand expansion scenarios including **Adam Robotics**, **Adam Automotive**, and **Adam Defense** as separate storefronts with distinct branding but potentially shared infrastructure.

### Platform Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    MULTI-BRAND E-COMMERCE SCENARIO                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│   ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐             │
│   │  Adam Robotics   │  │  Adam Automotive │  │   Adam Defense   │             │
│   │   (robotics.     │  │   (automotive.   │  │   (defense.      │             │
│   │  adamtech.com)   │  │  adamtech.com)   │  │  adamtech.com)   │             │
│   │                  │  │                  │  │                  │             │
│   │  • Industrial    │  │  • Auto parts    │  │  • Security gear │             │
│   │    robots        │  │  • Accessories   │  │  • Tactical      │             │
│   │  • Components    │  │  • Tools         │  │    equipment     │             │
│   └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘             │
│            │                     │                     │                         │
│            └─────────────────────┼─────────────────────┘                         │
│                                  │                                               │
│                                  ▼                                               │
│   ┌─────────────────────────────────────────────────────────────────────────┐   │
│   │                    SHARED E-COMMERCE BACKEND                             │   │
│   │                                                                          │   │
│   │     Option A: VENDURE             │      Option B: MEDUSA 2.0           │   │
│   │   ┌─────────────────────────┐     │    ┌─────────────────────────┐      │   │
│   │   │  Built-in Multi-Channel │     │    │  Multi-tenant via       │      │   │
│   │   │  Single instance,       │     │    │  Sales Channels or      │      │   │
│   │   │  multiple storefronts   │     │    │  separate instances     │      │   │
│   │   └─────────────────────────┘     │    └─────────────────────────┘      │   │
│   │                                                                          │   │
│   └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Feature Comparison Table

| Feature | Vendure | Medusa 2.0 | Winner |
|---------|---------|------------|--------|
| **Multi-Channel/Multi-Store** | ✅ Built-in Channels (native) | ⚠️ Sales Channels (basic) | **Vendure** |
| **Multi-Tenant Architecture** | ✅ Single instance, multiple channels | ⚠️ Separate instances recommended | **Vendure** |
| **GraphQL API** | ✅ Native (primary API) | ⚠️ Not available (REST only) | **Vendure** |
| **REST API** | ⚠️ Available via plugin | ✅ Native (primary API) | **Medusa** |
| **TypeScript Support** | ✅ Full TypeScript | ✅ Full TypeScript | Tie |
| **Open Source License** | MIT | MIT | Tie |
| **Admin Dashboard** | ✅ Angular-based (included) | ✅ React-based (included) | Tie |
| **Plugin Ecosystem** | ⚠️ Growing (smaller) | ✅ Larger ecosystem | **Medusa** |
| **Documentation Quality** | ✅ Excellent | ✅ Excellent | Tie |
| **Community Size** | ⚠️ Smaller | ✅ Larger | **Medusa** |
| **Self-Hosting Complexity** | ⚠️ Moderate | ✅ Easier | **Medusa** |
| **Database Support** | PostgreSQL, MySQL, SQLite | PostgreSQL only | **Vendure** |
| **Product Variants** | ✅ Unlimited, flexible | ✅ Good support | Tie |
| **Per-Channel Pricing** | ✅ Native support | ⚠️ Requires customization | **Vendure** |
| **Per-Channel Inventory** | ✅ Native support | ⚠️ Via sales channels | **Vendure** |
| **Shared Product Catalog** | ✅ Products belong to channels | ⚠️ Complex setup | **Vendure** |
| **Independent Branding** | ✅ Per-channel customization | ⚠️ Separate frontends | **Vendure** |
| **Development Speed** | ⚠️ Steeper learning curve | ✅ Faster to start | **Medusa** |
| **Scalability** | ✅ Enterprise-grade | ✅ Good for SMB | Tie |
| **Payment Integrations** | ✅ Stripe, PayPal, etc. | ✅ Stripe, PayPal, etc. | Tie |
| **Hosting Requirements** | 2GB+ RAM | 2GB+ RAM | Tie |

### Multi-Brand Architecture Comparison

#### Vendure Multi-Channel Approach

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                      VENDURE MULTI-CHANNEL ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│                         SINGLE VENDURE INSTANCE                                  │
│  ┌───────────────────────────────────────────────────────────────────────────┐  │
│  │                                                                            │  │
│  │   ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────────────┐ │  │
│  │   │ Channel:        │ │ Channel:        │ │ Channel:                    │ │  │
│  │   │ Adam Robotics   │ │ Adam Automotive │ │ Adam Defense                │ │  │
│  │   ├─────────────────┤ ├─────────────────┤ ├─────────────────────────────┤ │  │
│  │   │ • Own pricing   │ │ • Own pricing   │ │ • Own pricing               │ │  │
│  │   │ • Own inventory │ │ • Own inventory │ │ • Own inventory             │ │  │
│  │   │ • Own shipping  │ │ • Own shipping  │ │ • Own shipping              │ │  │
│  │   │ • Own currency  │ │ • Own currency  │ │ • Own currency              │ │  │
│  │   │ • Own tax rules │ │ • Own tax rules │ │ • Own tax rules             │ │  │
│  │   └────────┬────────┘ └────────┬────────┘ └──────────────┬──────────────┘ │  │
│  │            │                   │                         │                │  │
│  │            └───────────────────┼─────────────────────────┘                │  │
│  │                                │                                          │  │
│  │                                ▼                                          │  │
│  │   ┌────────────────────────────────────────────────────────────────────┐  │  │
│  │   │              SHARED RESOURCES                                      │  │  │
│  │   │  • Single PostgreSQL database                                      │  │  │
│  │   │  • Shared product catalog (assigned to channels)                   │  │  │
│  │   │  • Unified admin dashboard                                         │  │  │
│  │   │  • Single GraphQL API endpoint                                     │  │  │
│  │   │  • Consolidated reporting                                          │  │  │
│  │   └────────────────────────────────────────────────────────────────────┘  │  │
│  │                                                                            │  │
│  └───────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  PROS:                              │ CONS:                                     │
│  ✅ Single deployment               │ ❌ Steeper learning curve                 │
│  ✅ Unified inventory management    │ ❌ GraphQL requires more setup            │
│  ✅ Easy cross-channel analytics    │ ❌ Smaller plugin ecosystem               │
│  ✅ Shared customer accounts        │ ❌ Angular admin may be unfamiliar        │
│  ✅ Lower infrastructure cost       │ ❌ Single point of failure                │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Medusa 2.0 Multi-Instance Approach

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                     MEDUSA 2.0 MULTI-INSTANCE ARCHITECTURE                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ┌─────────────────────┐ ┌─────────────────────┐ ┌─────────────────────────┐    │
│  │  MEDUSA INSTANCE 1  │ │  MEDUSA INSTANCE 2  │ │  MEDUSA INSTANCE 3      │    │
│  │   Adam Robotics     │ │   Adam Automotive   │ │   Adam Defense          │    │
│  ├─────────────────────┤ ├─────────────────────┤ ├─────────────────────────┤    │
│  │ • PostgreSQL DB 1   │ │ • PostgreSQL DB 2   │ │ • PostgreSQL DB 3       │    │
│  │ • Products: 100     │ │ • Products: 100     │ │ • Products: 100         │    │
│  │ • Own admin panel   │ │ • Own admin panel   │ │ • Own admin panel       │    │
│  │ • REST API :9000    │ │ • REST API :9001    │ │ • REST API :9002        │    │
│  │ • Full isolation    │ │ • Full isolation    │ │ • Full isolation        │    │
│  └──────────┬──────────┘ └──────────┬──────────┘ └────────────┬────────────┘    │
│             │                       │                         │                  │
│             │                       │                         │                  │
│             ▼                       ▼                         ▼                  │
│  ┌─────────────────────┐ ┌─────────────────────┐ ┌─────────────────────────┐    │
│  │  Astro Storefront   │ │  Astro Storefront   │ │  Astro Storefront       │    │
│  │  robotics.adam.com  │ │  automotive.adam.com│ │  defense.adam.com       │    │
│  └─────────────────────┘ └─────────────────────┘ └─────────────────────────┘    │
│                                                                                  │
│  PROS:                              │ CONS:                                     │
│  ✅ Complete isolation              │ ❌ 3x infrastructure cost                 │
│  ✅ Independent scaling             │ ❌ No shared inventory                    │
│  ✅ Easier per-brand customization  │ ❌ Separate admin dashboards             │
│  ✅ Familiar REST API               │ ❌ Complex cross-brand reporting         │
│  ✅ Faster initial development      │ ❌ No shared customer accounts           │
│  ✅ No single point of failure      │ ❌ Higher maintenance overhead           │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Multi-Brand Scenario Analysis

| Scenario | Vendure | Medusa 2.0 | Recommendation |
|----------|---------|------------|----------------|
| **3 brands, shared inventory** | ✅ Native channels | ❌ Not supported | Vendure |
| **3 brands, separate inventory** | ✅ Channel isolation | ✅ Separate instances | Tie |
| **Unified customer accounts** | ✅ Built-in | ❌ Requires custom auth | Vendure |
| **Independent brand evolution** | ⚠️ Constrained by shared code | ✅ Full independence | Medusa |
| **Single admin dashboard** | ✅ Multi-channel admin | ❌ Separate admins | Vendure |
| **Cross-brand analytics** | ✅ Unified reporting | ⚠️ Custom aggregation needed | Vendure |
| **Budget-conscious (1 VPS)** | ✅ Single instance | ❌ 3 instances needed | Vendure |
| **Team familiar with REST** | ⚠️ GraphQL primary | ✅ REST native | Medusa |
| **Rapid initial deployment** | ⚠️ Longer setup | ✅ Faster start | Medusa |
| **Long-term maintainability** | ✅ Centralized | ⚠️ Distributed complexity | Vendure |

### Infrastructure Cost Comparison

| Resource | Vendure (Single Instance) | Medusa (3 Instances) |
|----------|---------------------------|----------------------|
| **VPS Requirements** | 1× 4GB RAM VPS | 3× 2GB RAM VPS or 1× 8GB |
| **Database** | 1× PostgreSQL | 3× PostgreSQL |
| **Monthly Cost (Hetzner)** | ~€8/month (CX21) | ~€15-24/month |
| **Admin Dashboards** | 1 unified | 3 separate |
| **Deployment Complexity** | Single Docker stack | 3 Docker stacks |
| **Backup Strategy** | 1 database backup | 3 database backups |
| **SSL Certificates** | 1 wildcard or 3 certs | 3 certificates |

### Code Example: Vendure Multi-Channel Configuration

```typescript
// vendure-config.ts
import { VendureConfig } from '@vendure/core';

export const config: VendureConfig = {
  channelTokenKey: 'vendure-token',
  defaultChannelToken: 'default-channel',
  customFields: {
    Channel: [
      { name: 'brandColor', type: 'string' },
      { name: 'logo', type: 'string' },
      { name: 'contactEmail', type: 'string' },
    ],
  },
};

// Creating channels via Admin API
const roboticsChannel = {
  code: 'adam-robotics',
  token: 'robotics-token',
  defaultLanguageCode: 'en',
  currencyCode: 'USD',
  pricesIncludeTax: false,
};

const automotiveChannel = {
  code: 'adam-automotive',
  token: 'automotive-token',
  defaultLanguageCode: 'en',
  currencyCode: 'USD',
  pricesIncludeTax: false,
};

const defenseChannel = {
  code: 'adam-defense',
  token: 'defense-token',
  defaultLanguageCode: 'en',
  currencyCode: 'USD',
  pricesIncludeTax: false,
};
```

### Code Example: Medusa Sales Channels Configuration

```typescript
// medusa-config.ts (per instance)
module.exports = {
  projectConfig: {
    // Each instance has its own config
    store_name: "Adam Robotics Store", // Change per brand
    database_url: process.env.DATABASE_URL,
    redis_url: process.env.REDIS_URL,
  },
  modules: {
    // Sales channels for sub-categorization within instance
    // But NOT for multi-brand separation
  },
};

// Medusa's sales channels are for categorizing within ONE store
// e.g., "Online", "Wholesale", "Retail" - not separate brands
```

### Decision Matrix: Which Platform to Choose?

| If You Need... | Choose |
|----------------|--------|
| Multiple brands on single infrastructure | **Vendure** |
| Shared product catalog across brands | **Vendure** |
| Unified customer experience | **Vendure** |
| Single admin for all brands | **Vendure** |
| Complete brand isolation | **Medusa** |
| Faster initial development | **Medusa** |
| Team prefers REST over GraphQL | **Medusa** |
| Each brand to evolve independently | **Medusa** |
| Larger plugin ecosystem | **Medusa** |
| Lower learning curve | **Medusa** |

### Recommendation for Adam Multi-Brand Expansion

**Primary Recommendation: Vendure**

For the scenario of expanding to **Adam Robotics**, **Adam Automotive**, and **Adam Defense** as related brands under a parent organization, **Vendure** is the recommended choice for the following reasons:

1. **Native Multi-Channel Architecture**: Vendure's built-in channel system is specifically designed for multi-brand/multi-store scenarios. Each brand can have its own pricing, inventory, tax rules, and shipping configurations while sharing a single codebase and database.

2. **Cost Efficiency**: Running a single Vendure instance for 3 brands requires significantly less infrastructure than 3 separate Medusa instances. This translates to:
   - ~50% lower hosting costs
   - Single deployment pipeline
   - One backup strategy
   - Unified monitoring

3. **Unified Administration**: Store managers can switch between channels in a single admin dashboard, making it easier to:
   - Cross-list products between brands
   - View consolidated sales reports
   - Manage shared customer accounts
   - Apply consistent policies

4. **Scalability Path**: As the brands grow, Vendure's architecture can handle enterprise-scale operations without restructuring. Medusa would require migrating to a more complex multi-tenant setup.

5. **GraphQL Benefits**: While requiring initial learning, Vendure's GraphQL API enables:
   - Efficient data fetching (no over-fetching)
   - Strong typing for frontend development
   - Flexible queries for varied storefront needs

**When to Choose Medusa Instead:**

- **Current Project (danieltarazona.com)**: For the single-brand portfolio store with 100 products, Medusa 2.0 remains the better choice due to:
  - Simpler initial setup
  - REST API familiarity
  - Sufficient for single-store needs
  - Already documented in this roadmap

- **Future Multi-Brand (if isolation is critical)**: If Adam Robotics, Adam Automotive, and Adam Defense must operate as completely independent entities with:
  - Separate teams managing each store
  - No shared products or customers
  - Potentially different technology stacks per brand
  - Ability to sell individual brands independently

**Migration Path:**

If starting with Medusa for `danieltarazona.com` and later needing multi-brand:

```
Phase 1 (Now):        danieltarazona.com → Medusa 2.0 (single store)
Phase 2 (If needed):  Adam brands → Evaluate Vendure migration
                      OR
                      Adam brands → Separate Medusa instances
```

### Summary Comparison Table

| Aspect | Vendure | Medusa 2.0 | For This Project |
|--------|---------|------------|------------------|
| **Single Store (danieltarazona.com)** | Overkill | ✅ Perfect fit | **Medusa** |
| **Multi-Brand Expansion** | ✅ Best choice | ⚠️ Workable | **Vendure** |
| **Learning Investment** | Higher | Lower | Medusa now, Vendure later |
| **Long-term Flexibility** | Higher | Moderate | Depends on growth |
| **Community Support** | Growing | Established | Medusa |

**Final Verdict:**
- **For danieltarazona.com (now)**: Stick with **Medusa 2.0** as planned
- **For Adam multi-brand (future)**: Plan for **Vendure** when expansion begins

---

*This roadmap serves as a reusable template for future multi-domain projects with consistent theming and shared infrastructure patterns.*
