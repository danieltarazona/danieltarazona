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

---

*This roadmap serves as a reusable template for future multi-domain projects with consistent theming and shared infrastructure patterns.*
