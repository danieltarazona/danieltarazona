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

*This roadmap serves as a reusable template for future multi-domain projects with consistent theming and shared infrastructure patterns.*
