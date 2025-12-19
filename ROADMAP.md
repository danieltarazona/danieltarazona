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

### Categorized Feature List

The following comprehensive feature list categorizes all planned features by priority level and type. Use this as a tracking checklist throughout the project.

#### Priority Level Definitions

| Priority | Label | Description | SLA |
|----------|-------|-------------|-----|
| **P0** | Critical | Must-have features for MVP launch. Project cannot go live without these. | Must complete |
| **P1** | Important | High-value features that significantly enhance the product. Should be included if time permits. | Should complete |
| **P2** | Nice-to-Have | Optional enhancements that add polish. Can be deferred to post-launch. | Could complete |

---

#### 🎯 P0: Required Features (MVP)

These features are **critical** for the initial launch. The project cannot be considered complete without them.

##### Portfolio Site (`danieltarazona.com`) - P0

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P0-01 | **Photo Gallery** | Responsive image gallery with lazy loading, lightbox view, and optimized WebP/AVIF images | [ ] | Astro, Cloudflare Images |
| P0-02 | **About Page** | Professional bio page with headshot, skills, experience timeline, and social links | [ ] | Astro |
| P0-03 | **Contact Form** | Functional contact form with validation, spam protection, and PostgreSQL persistence | [ ] | Supabase, Edge Functions |
| P0-04 | **Form Notifications** | Email notifications on form submission (to admin) and confirmation (to user) | [ ] | Supabase Edge Functions, SMTP |
| P0-05 | **Responsive Design** | Mobile-first responsive layout working on all screen sizes (320px to 4K) | [ ] | CSS/Tailwind |
| P0-06 | **SEO Optimization** | Meta tags, Open Graph, Twitter Cards, JSON-LD structured data, canonical URLs | [ ] | Astro SEO |
| P0-07 | **Core Pages** | Home, About, Gallery, Contact pages with consistent navigation | [ ] | Astro |
| P0-08 | **SSL/HTTPS** | Full SSL encryption via Cloudflare with HTTP/2 and HSTS | [ ] | Cloudflare |
| P0-09 | **Performance Baseline** | Lighthouse score ≥90 on all Core Web Vitals (LCP, FID, CLS) | [ ] | Build optimization |
| P0-10 | **Deployment Pipeline** | Automated deployment to Cloudflare Pages on git push | [ ] | GitHub Actions |

##### E-Commerce Store (`store.danieltarazona.com`) - P0

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P0-11 | **Product Catalog** | Display up to 100 products with images, descriptions, pricing, and variants | [ ] | Medusa 2.0, Astro |
| P0-12 | **Product Detail Pages** | Individual product pages with gallery, descriptions, variant selection | [ ] | Medusa 2.0, Astro |
| P0-13 | **Shopping Cart** | Persistent cart with add/remove items, quantity updates, and total calculation | [ ] | Medusa 2.0 Store API |
| P0-14 | **Checkout Flow** | Multi-step checkout with shipping address, shipping method, and payment | [ ] | Medusa 2.0 |
| P0-15 | **Payment Processing** | Secure payment integration (Stripe/PayPal) with PCI compliance | [ ] | Medusa Payment Providers |
| P0-16 | **Order Confirmation** | Order confirmation page and email notification | [ ] | Medusa 2.0 |
| P0-17 | **Inventory Management** | Real-time inventory tracking to prevent overselling | [ ] | Medusa 2.0 Admin |
| P0-18 | **Admin Dashboard** | Medusa admin panel for product, order, and inventory management | [ ] | Medusa 2.0 Admin |
| P0-19 | **Secure Backend** | Cloudflare Tunnel for Medusa API without exposing ports | [ ] | Cloudflare Tunnel |
| P0-20 | **Database Backups** | Automated PostgreSQL backups with retention policy | [ ] | Coolify, pg_dump |

---

#### 🔶 P1: Important Features (Post-MVP High Priority)

These features are **important** for a complete product experience. Implement after MVP launch or if time permits.

##### Portfolio Site (`danieltarazona.com`) - P1

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P1-01 | **Blog/Articles** | Markdown-based blog with categories, tags, and RSS feed | [ ] | Astro Content Collections |
| P1-02 | **Project Showcase** | Portfolio of projects with case studies, tech stack, and live demos | [ ] | Astro |
| P1-03 | **Resume/CV Page** | Downloadable PDF resume with online version | [ ] | Astro |
| P1-04 | **Dark Mode** | System-preference-aware dark/light theme toggle | [ ] | CSS/JavaScript |
| P1-05 | **Search Functionality** | Client-side search across gallery and blog content | [ ] | Pagefind/Fuse.js |
| P1-06 | **Image Categories** | Filter gallery by categories/albums/tags | [ ] | Astro |
| P1-07 | **Animation & Transitions** | Subtle page transitions and micro-interactions | [ ] | View Transitions API |
| P1-08 | **404 Custom Page** | Branded 404 error page with navigation back to site | [ ] | Astro |
| P1-09 | **Sitemap Generation** | Automatic XML sitemap generation for SEO | [ ] | @astrojs/sitemap |
| P1-10 | **robots.txt** | SEO-optimized robots.txt with sitemap reference | [ ] | Astro |

##### E-Commerce Store (`store.danieltarazona.com`) - P1

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P1-11 | **Product Search** | Full-text search across products with filters | [ ] | Medusa 2.0, MeiliSearch |
| P1-12 | **Product Reviews** | Customer reviews and ratings system | [ ] | Medusa Plugin/Custom |
| P1-13 | **Wishlist** | Save products for later functionality | [ ] | Medusa 2.0 |
| P1-14 | **Customer Accounts** | User registration, login, order history, saved addresses | [ ] | Medusa 2.0 Auth |
| P1-15 | **Order Tracking** | Order status updates and shipment tracking | [ ] | Medusa 2.0 |
| P1-16 | **Email Templates** | Branded transactional emails (order, shipping, etc.) | [ ] | Medusa 2.0, SendGrid |
| P1-17 | **Discount Codes** | Promotional codes and percentage/fixed discounts | [ ] | Medusa 2.0 |
| P1-18 | **Multiple Currencies** | Support for multiple currencies (USD, EUR, etc.) | [ ] | Medusa 2.0 |
| P1-19 | **Tax Calculation** | Automatic tax calculation by region | [ ] | Medusa 2.0 |
| P1-20 | **Shipping Zones** | Multiple shipping options and zone-based pricing | [ ] | Medusa 2.0 |

---

#### 🟢 P2: Nice-to-Have Features (Future Enhancements)

These features are **optional** enhancements that can be implemented post-launch for added value.

##### Portfolio Site (`danieltarazona.com`) - P2

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P2-01 | **Newsletter Signup** | Email subscription form with double opt-in and Supabase storage | [ ] | Supabase, Mailchimp/ConvertKit |
| P2-02 | **Analytics Dashboard** | Privacy-friendly analytics (Plausible/Umami) integration | [ ] | Self-hosted or SaaS |
| P2-03 | **Comments System** | Blog comments with moderation (Giscus/Utterances) | [ ] | GitHub Discussions |
| P2-04 | **Social Sharing** | Share buttons for social media platforms | [ ] | JavaScript |
| P2-05 | **Reading Progress** | Reading progress indicator for blog posts | [ ] | JavaScript |
| P2-06 | **Table of Contents** | Auto-generated TOC for long-form content | [ ] | Astro/rehype |
| P2-07 | **Print Styles** | Optimized print stylesheet for articles | [ ] | CSS |
| P2-08 | **Internationalization** | Multi-language support (i18n) | [ ] | Astro i18n |
| P2-09 | **PWA Support** | Progressive Web App with offline support | [ ] | Service Worker |
| P2-10 | **Accessibility Audit** | WCAG 2.1 AA compliance verification | [ ] | Manual + Automated |

##### E-Commerce Store (`store.danieltarazona.com`) - P2

| # | Feature | Description | Status | Dependencies |
|---|---------|-------------|--------|--------------|
| P2-11 | **Product Recommendations** | "You might also like" product suggestions | [ ] | Custom Algorithm |
| P2-12 | **Recently Viewed** | Display recently viewed products | [ ] | Local Storage |
| P2-13 | **Gift Cards** | Digital gift card purchasing and redemption | [ ] | Medusa 2.0 |
| P2-14 | **Abandoned Cart Emails** | Automated emails for abandoned shopping carts | [ ] | Medusa 2.0, Email Service |
| P2-15 | **Product Bundles** | Bundle products together for discounts | [ ] | Custom Medusa Module |
| P2-16 | **Stock Notifications** | Email alerts when out-of-stock items return | [ ] | Medusa 2.0, Email Service |
| P2-17 | **Order Notes** | Allow customers to add notes to orders | [ ] | Medusa 2.0 |
| P2-18 | **Invoice Generation** | PDF invoice generation for orders | [ ] | Medusa 2.0, PDF Library |
| P2-19 | **Advanced Analytics** | Sales reports, conversion tracking, revenue metrics | [ ] | Medusa 2.0 Admin |
| P2-20 | **A/B Testing** | Product page and checkout flow A/B testing | [ ] | Cloudflare Workers |

---

#### Infrastructure & DevOps Features

| Priority | # | Feature | Description | Status |
|----------|---|---------|-------------|--------|
| P0 | I-01 | **Cloudflare DNS** | DNS management with proxy enabled | [ ] |
| P0 | I-02 | **Cloudflare Pages** | Static site hosting for Astro sites | [ ] |
| P0 | I-03 | **Cloudflare Tunnel** | Secure tunnel for Medusa backend | [ ] |
| P0 | I-04 | **SSL/TLS Certificates** | Automatic SSL certificate management | [ ] |
| P0 | I-05 | **PostgreSQL Database** | Supabase for portfolio, local for Medusa | [ ] |
| P1 | I-06 | **GitHub Actions CI/CD** | Automated testing and deployment | [ ] |
| P1 | I-07 | **Coolify Orchestration** | Container management for VPS | [ ] |
| P1 | I-08 | **Monitoring & Alerts** | Uptime monitoring and incident alerts | [ ] |
| P2 | I-09 | **Staging Environment** | Preview deployments for testing | [ ] |
| P2 | I-10 | **Log Aggregation** | Centralized logging for debugging | [ ] |

---

#### Feature Progress Summary

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              FEATURE IMPLEMENTATION PROGRESS                             │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                          │
│  PRIORITY BREAKDOWN                          CATEGORY BREAKDOWN                          │
│  ──────────────────                          ──────────────────                          │
│                                                                                          │
│  P0 (Required):     20 features              Portfolio Site:    30 features             │
│  P1 (Important):    20 features              E-Commerce Store:  30 features             │
│  P2 (Nice-to-Have): 20 features              Infrastructure:    10 features             │
│  Infrastructure:    10 features                                                          │
│  ─────────────────────────────               ─────────────────────────────               │
│  TOTAL:             70 features              TOTAL:             70 features             │
│                                                                                          │
│  MVP SCOPE: 20 P0 features + 10 Infrastructure = 30 features minimum                    │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Implementation Order Recommendation

For efficient development, implement features in this order:

1. **Sprint 1 (MVP Core)**: Infrastructure (I-01 to I-05), then P0-01 to P0-10 (Portfolio)
2. **Sprint 2 (MVP Store)**: P0-11 to P0-20 (E-Commerce essentials)
3. **Sprint 3 (Enhancement)**: P1-01 to P1-10 (Portfolio improvements)
4. **Sprint 4 (Store Polish)**: P1-11 to P1-20 (E-Commerce enhancements)
5. **Sprint 5+ (Post-Launch)**: P2 features based on user feedback and analytics

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

## Phase 3: Frontend Development

This phase covers the setup and configuration of Astro as the static site generator for both the main portfolio site (`danieltarazona.com`) and the e-commerce storefront (`store.danieltarazona.com`). Astro provides an excellent foundation for building fast, content-focused websites with optional interactivity.

### Why Astro for This Project

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        ASTRO FRONTEND ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                  │
│  ┌───────────────────────────────────────────────────────────────────────────┐  │
│  │                         ASTRO BUILD SYSTEM                                 │  │
│  │                                                                            │  │
│  │   ┌─────────────────────┐              ┌─────────────────────────────┐    │  │
│  │   │    .astro files     │              │     TypeScript/TSX          │    │  │
│  │   │   (Astro Components)│              │    (React/Vue/Svelte)       │    │  │
│  │   └──────────┬──────────┘              └──────────────┬──────────────┘    │  │
│  │              │                                        │                    │  │
│  │              └───────────────────┬────────────────────┘                    │  │
│  │                                  │                                         │  │
│  │                                  ▼                                         │  │
│  │   ┌───────────────────────────────────────────────────────────────────┐   │  │
│  │   │                      Vite Build Pipeline                          │   │  │
│  │   │  • Static HTML generation (SSG)                                   │   │  │
│  │   │  • Optional Server-Side Rendering (SSR)                           │   │  │
│  │   │  • Partial Hydration (Islands Architecture)                       │   │  │
│  │   │  • Asset optimization (images, CSS, JS)                           │   │  │
│  │   └──────────────────────────────┬────────────────────────────────────┘   │  │
│  │                                  │                                         │  │
│  │                                  ▼                                         │  │
│  │   ┌───────────────────────────────────────────────────────────────────┐   │  │
│  │   │                       dist/ (Output)                               │   │  │
│  │   │  ├── index.html                                                   │   │  │
│  │   │  ├── about/index.html                                             │   │  │
│  │   │  ├── gallery/index.html                                           │   │  │
│  │   │  ├── contact/index.html                                           │   │  │
│  │   │  ├── _astro/                                                      │   │  │
│  │   │  │   ├── client.abc123.js                                         │   │  │
│  │   │  │   └── styles.def456.css                                        │   │  │
│  │   │  └── assets/                                                      │   │  │
│  │   │      └── images/ (optimized)                                      │   │  │
│  │   └───────────────────────────────────────────────────────────────────┘   │  │
│  │                                                                            │  │
│  └───────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  OUTPUT DESTINATIONS:                                                            │
│  ┌─────────────────────────────┐  ┌─────────────────────────────────────────┐   │
│  │   danieltarazona.com        │  │   store.danieltarazona.com              │   │
│  │   → Cloudflare Pages        │  │   → Cloudflare Pages + Medusa API       │   │
│  │   (Pure Static)             │  │   (Static + Client-side API calls)      │   │
│  └─────────────────────────────┘  └─────────────────────────────────────────┘   │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

#### Why Astro is Perfect for This Project

| Feature | Benefit | For This Project |
|---------|---------|------------------|
| **Zero JS by default** | Fastest possible page loads | Excellent for photo gallery performance |
| **Island Architecture** | Add interactivity only where needed | Cart, forms interactive; gallery static |
| **Content Collections** | Type-safe content management | Photo metadata, blog posts, projects |
| **Image Optimization** | Built-in image processing | Critical for photography portfolio |
| **TypeScript Native** | Full type safety | Consistent with Medusa backend |
| **Framework Agnostic** | Use React/Vue/Svelte/Solid | Flexibility for interactive components |
| **SSG + SSR** | Static + dynamic options | Static portfolio, dynamic cart |
| **Cloudflare Integration** | First-class adapter | Easy deployment to CF Pages |

### Astro CLI Installation & Project Setup

#### Prerequisites

Before setting up Astro, ensure you have the required tools installed:

```bash
# Check Node.js version (v18+ required)
node --version
# Should be v18.14.1 or higher

# Check npm version
npm --version
# Should be v6.14.0 or higher

# Optional: Install pnpm for faster installs
npm install -g pnpm

# Optional: Install bun for even faster development
# curl -fsSL https://bun.sh/install | bash
```

#### Task 4.1: Install Astro CLI

- [ ] **Task 4.1.1**: Create new Astro project for portfolio site
  ```bash
  # Create project with npm
  npm create astro@latest danieltarazona-portfolio

  # Interactive prompts:
  # ┌  Welcome to Astro!
  # │
  # ◆  How would you like to start your new project?
  # │  ○ Include sample files (recommended)
  # │  ○ Use blog template
  # │  ● Empty                              ← Select this for clean start
  # │
  # ◆  Do you plan to write TypeScript?
  # │  ● Yes                                ← Select this
  # │  ○ No
  # │
  # ◆  How strict should TypeScript be?
  # │  ○ Relaxed
  # │  ● Strict                             ← Select this
  # │  ○ Strictest
  # │
  # ◆  Install dependencies?
  # │  ● Yes
  # │  ○ No
  # │
  # ◆  Initialize a new git repository?
  # │  ● Yes
  # │  ○ No

  # Alternative: Non-interactive creation
  npm create astro@latest danieltarazona-portfolio -- \
    --template minimal \
    --typescript strict \
    --install \
    --git

  # Using pnpm (faster)
  pnpm create astro@latest danieltarazona-portfolio -- \
    --template minimal \
    --typescript strict
  ```

- [ ] **Task 4.1.2**: Verify Astro installation
  ```bash
  # Navigate to project
  cd danieltarazona-portfolio

  # Check Astro version
  npx astro --version
  # astro/4.x.x

  # Start development server
  npm run dev
  # Local: http://localhost:4321/

  # Build for production
  npm run build

  # Preview production build
  npm run preview
  ```

### Project Structure for Portfolio/Photo Gallery

The portfolio site follows Astro's recommended structure with additions for photo gallery functionality:

```
danieltarazona-portfolio/
├── astro.config.mjs           # Astro configuration
├── tsconfig.json              # TypeScript configuration
├── package.json               # Dependencies and scripts
├── .env                       # Environment variables (git-ignored)
├── .env.example               # Environment template
│
├── public/                    # Static assets (copied as-is)
│   ├── favicon.svg
│   ├── robots.txt
│   └── og-image.png          # Social sharing image
│
├── src/
│   ├── components/           # Reusable UI components
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   ├── Navigation.astro
│   │   ├── PhotoCard.astro
│   │   ├── GalleryGrid.astro
│   │   ├── ContactForm.tsx   # Interactive (React/Preact)
│   │   ├── LightboxModal.tsx # Interactive (React/Preact)
│   │   └── SocialLinks.astro
│   │
│   ├── layouts/              # Page layouts
│   │   ├── BaseLayout.astro  # HTML head, body wrapper
│   │   ├── PageLayout.astro  # Standard page with header/footer
│   │   └── GalleryLayout.astro # Photo gallery specific
│   │
│   ├── pages/                # File-based routing
│   │   ├── index.astro       # Homepage
│   │   ├── about.astro       # About/Bio page
│   │   ├── contact.astro     # Contact form page
│   │   ├── gallery/
│   │   │   ├── index.astro   # Gallery overview
│   │   │   └── [slug].astro  # Dynamic photo album pages
│   │   └── 404.astro         # Custom 404 page
│   │
│   ├── content/              # Content collections (type-safe)
│   │   ├── config.ts         # Collection schemas
│   │   ├── photos/           # Photo collection
│   │   │   ├── album-1/
│   │   │   │   ├── index.md  # Album metadata
│   │   │   │   └── photos.json
│   │   │   └── album-2/
│   │   │       └── ...
│   │   └── blog/             # Blog posts (optional)
│   │       ├── post-1.md
│   │       └── post-2.md
│   │
│   ├── styles/               # Global styles
│   │   ├── global.css        # CSS custom properties, resets
│   │   └── components.css    # Component-specific styles
│   │
│   ├── lib/                  # Utilities and helpers
│   │   ├── supabase.ts       # Supabase client
│   │   ├── image-utils.ts    # Image optimization helpers
│   │   └── seo.ts            # SEO utilities
│   │
│   ├── types/                # TypeScript types
│   │   ├── photo.ts
│   │   └── content.ts
│   │
│   └── env.d.ts              # Environment type declarations
│
└── integrations/             # Custom Astro integrations (optional)
    └── photo-processor/
```

- [ ] **Task 4.1.3**: Create project structure directories
  ```bash
  cd danieltarazona-portfolio

  # Create all directories
  mkdir -p src/{components,layouts,pages/gallery,content/{photos,blog},styles,lib,types}
  mkdir -p public
  mkdir -p integrations

  # Create placeholder files
  touch src/env.d.ts
  touch src/content/config.ts
  touch src/styles/global.css
  touch .env.example
  ```

### TypeScript Configuration

- [ ] **Task 4.1.4**: Configure TypeScript for Astro
  ```bash
  # tsconfig.json is auto-generated, but we'll customize it
  ```

  **tsconfig.json:**
  ```json
  {
    "extends": "astro/tsconfigs/strict",
    "compilerOptions": {
      "baseUrl": ".",
      "paths": {
        "@/*": ["src/*"],
        "@components/*": ["src/components/*"],
        "@layouts/*": ["src/layouts/*"],
        "@lib/*": ["src/lib/*"],
        "@content/*": ["src/content/*"],
        "@types/*": ["src/types/*"]
      },
      "types": ["astro/client"],
      "strictNullChecks": true,
      "noUncheckedIndexedAccess": true
    },
    "include": ["src"],
    "exclude": ["node_modules", "dist"]
  }
  ```

  **src/env.d.ts:**
  ```typescript
  /// <reference types="astro/client" />

  interface ImportMetaEnv {
    readonly SUPABASE_URL: string;
    readonly SUPABASE_ANON_KEY: string;
    readonly PUBLIC_SITE_URL: string;
    readonly PUBLIC_CONTACT_EMAIL: string;
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }
  ```

### Astro Configuration

- [ ] **Task 4.1.5**: Configure Astro for portfolio site
  ```bash
  # astro.config.mjs
  ```

  **astro.config.mjs:**
  ```javascript
  import { defineConfig } from 'astro/config';

  // Integrations (install as needed)
  // import react from '@astrojs/react';
  // import tailwind from '@astrojs/tailwind';
  // import sitemap from '@astrojs/sitemap';
  // import cloudflare from '@astrojs/cloudflare';

  export default defineConfig({
    // Site URL for canonical URLs and sitemap
    site: 'https://danieltarazona.com',

    // Output mode: 'static' (default) or 'server' for SSR
    output: 'static',

    // Build configuration
    build: {
      // Inline stylesheets smaller than this limit
      inlineStylesheets: 'auto',
      // Split CSS by page for better caching
      // assets: '_astro'
    },

    // Development server
    server: {
      port: 4321,
      host: true, // Expose to network
    },

    // Vite configuration
    vite: {
      build: {
        // Generate source maps for debugging
        sourcemap: true,
      },
      css: {
        devSourcemap: true,
      },
    },

    // Image optimization
    image: {
      // Sharp service for image processing
      service: {
        entrypoint: 'astro/assets/services/sharp',
      },
      // Remote image domains allowed
      domains: ['images.unsplash.com'],
      // Lazy load images by default
      // experimentalLayout: 'responsive',
    },

    // Prefetch configuration
    prefetch: {
      prefetchAll: false,
      defaultStrategy: 'hover',
    },

    // Markdown configuration
    markdown: {
      shikiConfig: {
        theme: 'github-dark',
        wrap: true,
      },
    },

    // Integrations (uncomment as needed)
    integrations: [
      // react(),           // For interactive components
      // tailwind(),        // For Tailwind CSS
      // sitemap(),         // Generate sitemap.xml
    ],

    // Adapter for deployment (uncomment for SSR)
    // adapter: cloudflare(),
  });
  ```

### Installing Essential Integrations

- [ ] **Task 4.1.6**: Install Astro integrations
  ```bash
  # Image optimization (included by default in Astro 3+)
  # No installation needed - use built-in astro:assets

  # React for interactive components (contact form, lightbox)
  npx astro add react
  # or: npm install @astrojs/react react react-dom

  # Tailwind CSS for styling (optional but recommended)
  npx astro add tailwind
  # or: npm install @astrojs/tailwind tailwindcss

  # Sitemap generation
  npx astro add sitemap
  # or: npm install @astrojs/sitemap

  # Cloudflare Pages adapter (for SSR, if needed)
  npx astro add cloudflare
  # or: npm install @astrojs/cloudflare

  # MDX support for rich content (optional)
  npx astro add mdx
  # or: npm install @astrojs/mdx
  ```

  **Updated astro.config.mjs with integrations:**
  ```javascript
  import { defineConfig } from 'astro/config';
  import react from '@astrojs/react';
  import tailwind from '@astrojs/tailwind';
  import sitemap from '@astrojs/sitemap';

  export default defineConfig({
    site: 'https://danieltarazona.com',
    output: 'static',
    integrations: [
      react(),
      tailwind({
        applyBaseStyles: false, // Use custom base styles
      }),
      sitemap({
        filter: (page) => !page.includes('/admin/'),
        changefreq: 'weekly',
        priority: 0.7,
      }),
    ],
    image: {
      service: {
        entrypoint: 'astro/assets/services/sharp',
      },
    },
  });
  ```

### Content Collections Configuration

For type-safe content management, configure Astro Content Collections:

- [ ] **Task 4.1.7**: Configure content collections
  ```bash
  # Create content configuration
  touch src/content/config.ts
  ```

  **src/content/config.ts:**
  ```typescript
  import { defineCollection, z } from 'astro:content';

  // Photo album collection
  const photosCollection = defineCollection({
    type: 'content',
    schema: ({ image }) => z.object({
      title: z.string(),
      description: z.string().optional(),
      date: z.date(),
      coverImage: image(),
      tags: z.array(z.string()).default([]),
      featured: z.boolean().default(false),
      location: z.string().optional(),
      camera: z.string().optional(),
      published: z.boolean().default(true),
    }),
  });

  // Blog posts collection
  const blogCollection = defineCollection({
    type: 'content',
    schema: z.object({
      title: z.string(),
      description: z.string(),
      date: z.date(),
      author: z.string().default('Daniel Tarazona'),
      tags: z.array(z.string()).default([]),
      draft: z.boolean().default(false),
      image: z.string().optional(),
    }),
  });

  // Projects collection
  const projectsCollection = defineCollection({
    type: 'content',
    schema: ({ image }) => z.object({
      title: z.string(),
      description: z.string(),
      technologies: z.array(z.string()),
      image: image().optional(),
      liveUrl: z.string().url().optional(),
      githubUrl: z.string().url().optional(),
      featured: z.boolean().default(false),
      order: z.number().default(0),
    }),
  });

  export const collections = {
    photos: photosCollection,
    blog: blogCollection,
    projects: projectsCollection,
  };
  ```

### Package.json Configuration

- [ ] **Task 4.1.8**: Configure package.json scripts
  ```json
  {
    "name": "danieltarazona-portfolio",
    "type": "module",
    "version": "1.0.0",
    "private": true,
    "scripts": {
      "dev": "astro dev",
      "start": "astro dev",
      "build": "astro check && astro build",
      "preview": "astro preview",
      "check": "astro check",
      "format": "prettier --write .",
      "lint": "eslint src --ext .ts,.tsx,.astro",
      "typecheck": "tsc --noEmit"
    },
    "dependencies": {
      "astro": "^4.16.0",
      "@astrojs/react": "^3.6.0",
      "@astrojs/sitemap": "^3.2.0",
      "@astrojs/tailwind": "^5.1.0",
      "@supabase/supabase-js": "^2.45.0",
      "react": "^18.3.0",
      "react-dom": "^18.3.0",
      "tailwindcss": "^3.4.0"
    },
    "devDependencies": {
      "@types/react": "^18.3.0",
      "@types/react-dom": "^18.3.0",
      "typescript": "^5.6.0",
      "prettier": "^3.3.0",
      "prettier-plugin-astro": "^0.14.0",
      "eslint": "^9.0.0",
      "eslint-plugin-astro": "^1.2.0",
      "@typescript-eslint/parser": "^8.0.0"
    },
    "engines": {
      "node": ">=18.14.1"
    }
  }
  ```

### Base Layout Template

- [ ] **Task 4.1.9**: Create base layout for all pages
  ```astro
  ---
  // src/layouts/BaseLayout.astro
  interface Props {
    title: string;
    description?: string;
    image?: string;
    canonicalUrl?: string;
  }

  const {
    title,
    description = 'Photography portfolio and personal website of Daniel Tarazona',
    image = '/og-image.png',
    canonicalUrl = Astro.url.href,
  } = Astro.props;

  const siteTitle = 'Daniel Tarazona';
  const fullTitle = title === siteTitle ? title : `${title} | ${siteTitle}`;
  ---

  <!doctype html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="generator" content={Astro.generator} />

      <!-- Primary Meta Tags -->
      <title>{fullTitle}</title>
      <meta name="title" content={fullTitle} />
      <meta name="description" content={description} />

      <!-- Canonical URL -->
      <link rel="canonical" href={canonicalUrl} />

      <!-- Open Graph / Facebook -->
      <meta property="og:type" content="website" />
      <meta property="og:url" content={canonicalUrl} />
      <meta property="og:title" content={fullTitle} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={new URL(image, Astro.site)} />

      <!-- Twitter -->
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:url" content={canonicalUrl} />
      <meta name="twitter:title" content={fullTitle} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={new URL(image, Astro.site)} />

      <!-- Favicon -->
      <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
      <link rel="apple-touch-icon" href="/apple-touch-icon.png" />

      <!-- Fonts (preconnect for performance) -->
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

      <!-- Global Styles -->
      <style is:global>
        @import '../styles/global.css';
      </style>
    </head>
    <body>
      <slot />
    </body>
  </html>
  ```

### Environment Variables Template

- [ ] **Task 4.1.10**: Create environment variables template
  ```bash
  # .env.example

  # Site Configuration
  PUBLIC_SITE_URL=https://danieltarazona.com
  PUBLIC_CONTACT_EMAIL=contact@danieltarazona.com

  # Supabase (for contact form)
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_ANON_KEY=your-anon-key

  # Analytics (optional)
  PUBLIC_ANALYTICS_ID=

  # Social Links
  PUBLIC_TWITTER_HANDLE=@danieltarazona
  PUBLIC_GITHUB_URL=https://github.com/danieltarazona
  PUBLIC_LINKEDIN_URL=https://linkedin.com/in/danieltarazona
  ```

### Development Workflow Commands

```bash
# Daily development workflow
cd danieltarazona-portfolio

# Start development server with hot reload
npm run dev
# → Local: http://localhost:4321/

# Type checking
npm run check

# Build for production
npm run build

# Preview production build locally
npm run preview

# Format code with Prettier
npm run format

# Run linting
npm run lint
```

### Phase 3 Task Summary: Portfolio Site Setup

| Task ID | Task | Status |
|---------|------|--------|
| 4.1.1 | Create new Astro project for portfolio site | [ ] |
| 4.1.2 | Verify Astro installation and scripts | [ ] |
| 4.1.3 | Create project structure directories | [ ] |
| 4.1.4 | Configure TypeScript for Astro | [ ] |
| 4.1.5 | Configure Astro for portfolio site | [ ] |
| 4.1.6 | Install Astro integrations (React, Tailwind, Sitemap) | [ ] |
| 4.1.7 | Configure content collections | [ ] |
| 4.1.8 | Configure package.json scripts | [ ] |
| 4.1.9 | Create base layout for all pages | [ ] |
| 4.1.10 | Create environment variables template | [ ] |

### Astro Storefront Integration with Medusa

This section covers connecting the Astro storefront (`store.danieltarazona.com`) to the Medusa 2.0 backend. The storefront will be a separate Astro project that fetches product data from the Medusa API and provides cart functionality and checkout flow.

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                    ASTRO STOREFRONT + MEDUSA 2.0 ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐│
│  │                         ASTRO STOREFRONT (store.danieltarazona.com)                 ││
│  │                                                                                      ││
│  │   ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐                 ││
│  │   │  Product Listing │  │   Product Detail │  │     Cart Page    │                 ││
│  │   │     (SSG/ISR)    │  │      (SSG/ISR)   │  │   (Client-side)  │                 ││
│  │   └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘                 ││
│  │            │                     │                     │                            ││
│  │            │         ┌───────────┴───────────┐        │                            ││
│  │            │         │    Checkout Flow      │        │                            ││
│  │            │         │   (Client-side SPA)   │        │                            ││
│  │            │         └───────────┬───────────┘        │                            ││
│  │            └─────────────────────┼────────────────────┘                            ││
│  │                                  │                                                  ││
│  │                                  ▼                                                  ││
│  │   ┌───────────────────────────────────────────────────────────────────────────┐    ││
│  │   │                      Medusa JS SDK (@medusajs/js-sdk)                      │    ││
│  │   │  • Product queries  • Cart management  • Checkout API  • Customer auth    │    ││
│  │   └──────────────────────────────────────┬────────────────────────────────────┘    ││
│  │                                          │                                          ││
│  └──────────────────────────────────────────┼──────────────────────────────────────────┘│
│                                             │                                           │
│                                             │ HTTPS API Calls                           │
│                                             │ (via Cloudflare Tunnel)                   │
│                                             ▼                                           │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐│
│  │                              MEDUSA 2.0 BACKEND (VPS)                               ││
│  │                                                                                      ││
│  │   ┌────────────────────────────────────────────────────────────────────────────┐   ││
│  │   │                        Store API (/store/*)                                 │   ││
│  │   │  GET  /store/products           - List products                            │   ││
│  │   │  GET  /store/products/:id       - Get product details                      │   ││
│  │   │  GET  /store/collections        - List collections                         │   ││
│  │   │  POST /store/carts              - Create cart                              │   ││
│  │   │  POST /store/carts/:id/line-items - Add to cart                            │   ││
│  │   │  POST /store/carts/:id/complete  - Complete checkout                       │   ││
│  │   │  POST /store/customers          - Register customer                        │   ││
│  │   │  POST /store/auth               - Customer login                           │   ││
│  │   └────────────────────────────────────────────────────────────────────────────┘   ││
│  │                                          │                                          ││
│  │                                          ▼                                          ││
│  │   ┌────────────────────────────────────────────────────────────────────────────┐   ││
│  │   │                        PostgreSQL Database                                  │   ││
│  │   │  products, variants, carts, orders, customers, inventory, payments         │   ││
│  │   └────────────────────────────────────────────────────────────────────────────┘   ││
│  │                                                                                      ││
│  └─────────────────────────────────────────────────────────────────────────────────────┘│
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Data Flow for E-Commerce Operations

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           E-COMMERCE DATA FLOW DIAGRAM                                   │
└─────────────────────────────────────────────────────────────────────────────────────────┘

PRODUCT BROWSING (Static Generation at Build Time):
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                          │
│  Build Time:                                                                             │
│  ┌──────────┐    GET /store/products    ┌─────────────┐    Query     ┌───────────────┐ │
│  │  Astro   │ ─────────────────────────▶│  Medusa API │ ──────────▶ │  PostgreSQL    │ │
│  │  Build   │ ◀───────────────────────── │             │ ◀────────── │  (products)    │ │
│  └──────────┘    JSON product list       └─────────────┘   Results   └───────────────┘ │
│       │                                                                                  │
│       ▼                                                                                  │
│  ┌──────────────────────────┐                                                           │
│  │  Static HTML Pages       │                                                           │
│  │  ├── /products/index.html│                                                           │
│  │  ├── /products/[slug].html │                                                         │
│  │  └── /collections/[slug].html │                                                      │
│  └──────────────────────────┘                                                           │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘

CART OPERATIONS (Client-side at Runtime):
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                          │
│  1. Create Cart (on first add-to-cart):                                                  │
│  ┌──────────┐    POST /store/carts     ┌─────────────┐  INSERT INTO  ┌───────────────┐ │
│  │  Browser │ ────────────────────────▶│  Medusa API │ ────────────▶│  PostgreSQL   │  │
│  │  (React) │ ◀─────────────────────── │             │ ◀──────────── │  (carts)      │  │
│  └──────────┘   { cart_id: "cart_..." } └─────────────┘   cart_id    └───────────────┘ │
│       │                                                                                  │
│       │ Store cart_id in localStorage                                                   │
│       ▼                                                                                  │
│  ┌──────────────────────────┐                                                           │
│  │  localStorage.cartId =   │                                                           │
│  │  "cart_01H..."           │                                                           │
│  └──────────────────────────┘                                                           │
│                                                                                          │
│  2. Add Item to Cart:                                                                   │
│  ┌──────────┐  POST /store/carts/:id/line-items  ┌─────────────┐    ┌───────────────┐  │
│  │  Browser │ ────────────────────────────────▶ │  Medusa API │ ──▶│  PostgreSQL   │  │
│  │  (React) │ ◀──────────────────────────────── │             │ ◀── │  (cart_items) │  │
│  └──────────┘   { cart: {..., items: [...]} }   └─────────────┘     └───────────────┘  │
│                                                                                          │
│  3. Update Cart (quantity change, remove item):                                         │
│  ┌──────────┐  POST /store/carts/:id/line-items/:item_id  ┌─────────────┐              │
│  │  Browser │ ──────────────────────────────────────────▶│  Medusa API │              │
│  │  (React) │ ◀────────────────────────────────────────── │             │              │
│  └──────────┘   { cart: {...} }                          └─────────────┘              │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘

CHECKOUT FLOW (Client-side Multi-step Process):
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                          │
│  Step 1: Add Shipping Address                                                           │
│  POST /store/carts/:id ──▶ { shipping_address: {...} }                                  │
│                                                                                          │
│  Step 2: Select Shipping Option                                                         │
│  GET /store/shipping-options/:cart_id ──▶ [{ id, name, amount }...]                     │
│  POST /store/carts/:id ──▶ { shipping_method: option_id }                               │
│                                                                                          │
│  Step 3: Initialize Payment Session                                                     │
│  POST /store/carts/:id/payment-sessions ──▶ { provider: "stripe" }                      │
│                                                                                          │
│  Step 4: Complete Checkout                                                              │
│  POST /store/carts/:id/complete ──▶ { order_id: "order_..." }                           │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Task 4.2: Create Astro Storefront Project

- [ ] **Task 4.2.1**: Create separate Astro project for store storefront
  ```bash
  # Create storefront project (separate from portfolio)
  npm create astro@latest danieltarazona-store -- \
    --template minimal \
    --typescript strict \
    --install \
    --git

  # Navigate to project
  cd danieltarazona-store

  # Project will serve store.danieltarazona.com
  ```

- [ ] **Task 4.2.2**: Configure storefront project structure
  ```
  danieltarazona-store/
  ├── astro.config.mjs           # Astro configuration for store
  ├── tsconfig.json              # TypeScript configuration
  ├── package.json               # Dependencies including Medusa SDK
  ├── .env                       # Environment variables (git-ignored)
  ├── .env.example               # Environment template
  │
  ├── public/
  │   ├── favicon.svg
  │   └── robots.txt
  │
  ├── src/
  │   ├── components/
  │   │   ├── common/            # Shared components
  │   │   │   ├── Header.astro
  │   │   │   ├── Footer.astro
  │   │   │   └── Navigation.astro
  │   │   │
  │   │   ├── products/          # Product components
  │   │   │   ├── ProductCard.astro
  │   │   │   ├── ProductGrid.astro
  │   │   │   ├── ProductGallery.tsx    # Interactive image gallery
  │   │   │   ├── ProductInfo.astro
  │   │   │   ├── VariantSelector.tsx   # Interactive variant picker
  │   │   │   └── AddToCartButton.tsx   # Interactive add to cart
  │   │   │
  │   │   ├── cart/              # Cart components (all interactive)
  │   │   │   ├── CartProvider.tsx      # Cart context provider
  │   │   │   ├── CartIcon.tsx          # Header cart icon with count
  │   │   │   ├── CartDrawer.tsx        # Slide-out cart drawer
  │   │   │   ├── CartItem.tsx          # Individual cart line item
  │   │   │   └── CartSummary.tsx       # Cart totals display
  │   │   │
  │   │   ├── checkout/          # Checkout components (all interactive)
  │   │   │   ├── CheckoutFlow.tsx      # Main checkout orchestrator
  │   │   │   ├── ShippingForm.tsx      # Shipping address form
  │   │   │   ├── ShippingOptions.tsx   # Shipping method selector
  │   │   │   ├── PaymentForm.tsx       # Payment details (Stripe Elements)
  │   │   │   ├── OrderSummary.tsx      # Order review
  │   │   │   └── OrderConfirmation.tsx # Success page content
  │   │   │
  │   │   └── collections/       # Collection components
  │   │       ├── CollectionCard.astro
  │   │       └── CollectionGrid.astro
  │   │
  │   ├── layouts/
  │   │   ├── BaseLayout.astro   # HTML wrapper
  │   │   ├── StoreLayout.astro  # Store pages with cart provider
  │   │   └── CheckoutLayout.astro # Minimal checkout layout
  │   │
  │   ├── pages/
  │   │   ├── index.astro        # Store homepage
  │   │   ├── products/
  │   │   │   ├── index.astro    # All products listing
  │   │   │   └── [handle].astro # Product detail page (SSG)
  │   │   ├── collections/
  │   │   │   ├── index.astro    # All collections
  │   │   │   └── [handle].astro # Collection page (SSG)
  │   │   ├── cart.astro         # Full cart page
  │   │   ├── checkout/
  │   │   │   ├── index.astro    # Checkout start
  │   │   │   └── success.astro  # Order confirmation
  │   │   └── account/           # Customer account pages
  │   │       ├── login.astro
  │   │       ├── register.astro
  │   │       └── orders.astro
  │   │
  │   ├── lib/
  │   │   ├── medusa/
  │   │   │   ├── client.ts      # Medusa SDK client instance
  │   │   │   ├── products.ts    # Product API helpers
  │   │   │   ├── cart.ts        # Cart API helpers
  │   │   │   ├── checkout.ts    # Checkout API helpers
  │   │   │   └── customer.ts    # Customer auth helpers
  │   │   │
  │   │   ├── utils/
  │   │   │   ├── price.ts       # Price formatting utilities
  │   │   │   ├── image.ts       # Image URL helpers
  │   │   │   └── storage.ts     # localStorage helpers
  │   │   │
  │   │   └── hooks/             # React hooks for storefront
  │   │       ├── useCart.ts     # Cart state hook
  │   │       ├── useProduct.ts  # Product data hook
  │   │       └── useCheckout.ts # Checkout state hook
  │   │
  │   ├── types/
  │   │   ├── medusa.ts          # Medusa type definitions
  │   │   └── store.ts           # Store-specific types
  │   │
  │   ├── styles/
  │   │   ├── global.css
  │   │   └── store.css
  │   │
  │   └── env.d.ts
  │
  └── tailwind.config.mjs
  ```

- [ ] **Task 4.2.3**: Install Medusa SDK and dependencies
  ```bash
  cd danieltarazona-store

  # Install Medusa JS SDK (v2.0)
  npm install @medusajs/js-sdk

  # Install React for interactive components
  npx astro add react

  # Install Tailwind CSS for styling
  npx astro add tailwind

  # Install additional dependencies
  npm install @stripe/stripe-js @stripe/react-stripe-js  # Stripe payments
  npm install zustand                                     # State management
  npm install react-hook-form @hookform/resolvers zod    # Form handling
  npm install clsx tailwind-merge                        # Utility classes

  # Dev dependencies
  npm install -D @types/react @types/react-dom
  ```

#### Task 4.2.4: Configure Medusa SDK Client

- [ ] **Task 4.2.4**: Set up Medusa SDK client

  **src/lib/medusa/client.ts:**
  ```typescript
  import Medusa from '@medusajs/js-sdk';

  // Initialize Medusa client
  export const medusa = new Medusa({
    baseUrl: import.meta.env.PUBLIC_MEDUSA_BACKEND_URL || 'http://localhost:9000',
    maxRetries: 3,
    publishableKey: import.meta.env.PUBLIC_MEDUSA_PUBLISHABLE_KEY,
  });

  // Type-safe region configuration
  export const DEFAULT_REGION = 'us';

  // Export typed store API methods
  export const storeApi = {
    // Products
    listProducts: async (params?: { limit?: number; offset?: number; collection_id?: string[] }) => {
      return medusa.store.product.list(params);
    },

    getProduct: async (handle: string) => {
      const { products } = await medusa.store.product.list({ handle });
      return products?.[0];
    },

    // Collections
    listCollections: async () => {
      return medusa.store.collection.list();
    },

    getCollection: async (handle: string) => {
      const { collections } = await medusa.store.collection.list({ handle });
      return collections?.[0];
    },
  };

  // Export cart API methods
  export const cartApi = {
    create: async (regionId?: string) => {
      return medusa.store.cart.create({ region_id: regionId });
    },

    retrieve: async (cartId: string) => {
      return medusa.store.cart.retrieve(cartId);
    },

    addLineItem: async (cartId: string, variantId: string, quantity: number = 1) => {
      return medusa.store.cart.createLineItem(cartId, {
        variant_id: variantId,
        quantity,
      });
    },

    updateLineItem: async (cartId: string, lineItemId: string, quantity: number) => {
      return medusa.store.cart.updateLineItem(cartId, lineItemId, { quantity });
    },

    removeLineItem: async (cartId: string, lineItemId: string) => {
      return medusa.store.cart.deleteLineItem(cartId, lineItemId);
    },

    updateCart: async (cartId: string, data: {
      email?: string;
      shipping_address?: {
        first_name: string;
        last_name: string;
        address_1: string;
        address_2?: string;
        city: string;
        province?: string;
        postal_code: string;
        country_code: string;
        phone?: string;
      };
      billing_address?: object;
    }) => {
      return medusa.store.cart.update(cartId, data);
    },
  };

  // Export checkout API methods
  export const checkoutApi = {
    getShippingOptions: async (cartId: string) => {
      return medusa.store.fulfillment.listCartOptions({ cart_id: cartId });
    },

    addShippingMethod: async (cartId: string, optionId: string) => {
      return medusa.store.cart.addShippingMethod(cartId, { option_id: optionId });
    },

    createPaymentSessions: async (cartId: string) => {
      return medusa.store.payment.initiatePaymentSession(
        { cart_id: cartId },
        { provider_id: 'stripe' }
      );
    },

    completeCart: async (cartId: string) => {
      return medusa.store.cart.complete(cartId);
    },
  };
  ```

#### Task 4.2.5: Product Listing Pages

- [ ] **Task 4.2.5**: Create product listing page

  **src/pages/products/index.astro:**
  ```astro
  ---
  import StoreLayout from '@/layouts/StoreLayout.astro';
  import ProductGrid from '@/components/products/ProductGrid.astro';
  import { storeApi } from '@/lib/medusa/client';

  // Fetch all products at build time (SSG)
  const { products } = await storeApi.listProducts({ limit: 100 });

  // Filter published products only
  const publishedProducts = products?.filter(p => p.status === 'published') ?? [];

  // SEO metadata
  const title = 'All Products';
  const description = 'Browse our complete collection of products.';
  ---

  <StoreLayout title={title} description={description}>
    <main class="container mx-auto px-4 py-8">
      <header class="mb-8">
        <h1 class="text-3xl font-bold mb-2">{title}</h1>
        <p class="text-gray-600">{publishedProducts.length} products available</p>
      </header>

      {publishedProducts.length > 0 ? (
        <ProductGrid products={publishedProducts} />
      ) : (
        <p class="text-center text-gray-500 py-12">
          No products available at the moment.
        </p>
      )}
    </main>
  </StoreLayout>
  ```

  **src/components/products/ProductGrid.astro:**
  ```astro
  ---
  import ProductCard from './ProductCard.astro';
  import type { Product } from '@/types/medusa';

  interface Props {
    products: Product[];
    columns?: 2 | 3 | 4;
  }

  const { products, columns = 4 } = Astro.props;

  const gridCols = {
    2: 'grid-cols-1 sm:grid-cols-2',
    3: 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3',
    4: 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4',
  };
  ---

  <div class={`grid ${gridCols[columns]} gap-6`}>
    {products.map((product) => (
      <ProductCard product={product} />
    ))}
  </div>
  ```

  **src/components/products/ProductCard.astro:**
  ```astro
  ---
  import { formatPrice } from '@/lib/utils/price';
  import type { Product } from '@/types/medusa';

  interface Props {
    product: Product;
  }

  const { product } = Astro.props;

  // Get primary image
  const thumbnail = product.thumbnail || product.images?.[0]?.url;

  // Get price range
  const prices = product.variants?.flatMap(v => v.prices || []) ?? [];
  const minPrice = prices.length > 0
    ? Math.min(...prices.map(p => p.amount))
    : null;

  // Build product URL
  const productUrl = `/products/${product.handle}`;
  ---

  <article class="group relative">
    <a href={productUrl} class="block">
      <!-- Product Image -->
      <div class="aspect-square overflow-hidden rounded-lg bg-gray-100">
        {thumbnail ? (
          <img
            src={thumbnail}
            alt={product.title}
            class="h-full w-full object-cover object-center transition-transform duration-300 group-hover:scale-105"
            loading="lazy"
            decoding="async"
          />
        ) : (
          <div class="flex h-full items-center justify-center">
            <span class="text-gray-400">No image</span>
          </div>
        )}
      </div>

      <!-- Product Info -->
      <div class="mt-4">
        <h3 class="text-sm font-medium text-gray-900 group-hover:text-blue-600 transition-colors">
          {product.title}
        </h3>

        {product.subtitle && (
          <p class="mt-1 text-sm text-gray-500">{product.subtitle}</p>
        )}

        {minPrice !== null && (
          <p class="mt-2 text-sm font-semibold text-gray-900">
            {formatPrice(minPrice)}
          </p>
        )}
      </div>
    </a>
  </article>
  ```

#### Task 4.2.6: Product Detail Page

- [ ] **Task 4.2.6**: Create product detail page with variant selection

  **src/pages/products/[handle].astro:**
  ```astro
  ---
  import StoreLayout from '@/layouts/StoreLayout.astro';
  import ProductGallery from '@/components/products/ProductGallery';
  import ProductInfo from '@/components/products/ProductInfo.astro';
  import VariantSelector from '@/components/products/VariantSelector';
  import AddToCartButton from '@/components/products/AddToCartButton';
  import { storeApi } from '@/lib/medusa/client';
  import type { Product } from '@/types/medusa';

  // Generate static paths for all products
  export async function getStaticPaths() {
    const { products } = await storeApi.listProducts({ limit: 100 });

    return products
      ?.filter(p => p.status === 'published')
      .map((product) => ({
        params: { handle: product.handle },
        props: { product },
      })) ?? [];
  }

  interface Props {
    product: Product;
  }

  const { product } = Astro.props;

  // Prepare images for gallery
  const images = product.images?.map(img => ({
    url: img.url,
    alt: product.title,
  })) ?? [];

  // SEO metadata
  const title = product.title;
  const description = product.description || `Shop ${product.title} at Daniel Tarazona Store`;
  const ogImage = product.thumbnail || images[0]?.url;
  ---

  <StoreLayout title={title} description={description} image={ogImage}>
    <main class="container mx-auto px-4 py-8">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12">
        <!-- Product Gallery (Interactive) -->
        <div class="lg:sticky lg:top-4 lg:self-start">
          <ProductGallery images={images} client:load />
        </div>

        <!-- Product Information -->
        <div class="flex flex-col gap-6">
          <ProductInfo product={product} />

          <!-- Variant Selection (Interactive) -->
          {product.variants && product.variants.length > 1 && (
            <VariantSelector
              variants={product.variants}
              options={product.options}
              client:load
            />
          )}

          <!-- Add to Cart Button (Interactive) -->
          <AddToCartButton
            productId={product.id}
            variants={product.variants}
            client:load
          />

          <!-- Product Description -->
          {product.description && (
            <div class="prose prose-sm max-w-none">
              <h2 class="text-lg font-semibold mb-2">Description</h2>
              <p>{product.description}</p>
            </div>
          )}
        </div>
      </div>
    </main>
  </StoreLayout>
  ```

  **src/components/products/AddToCartButton.tsx:**
  ```tsx
  import { useState } from 'react';
  import { useCart } from '@/lib/hooks/useCart';
  import type { ProductVariant } from '@/types/medusa';

  interface Props {
    productId: string;
    variants: ProductVariant[];
  }

  export default function AddToCartButton({ productId, variants }: Props) {
    const { addItem, isLoading } = useCart();
    const [selectedVariantId, setSelectedVariantId] = useState<string>(
      variants[0]?.id || ''
    );
    const [quantity, setQuantity] = useState(1);
    const [error, setError] = useState<string | null>(null);
    const [success, setSuccess] = useState(false);

    const selectedVariant = variants.find(v => v.id === selectedVariantId);
    const inStock = selectedVariant?.inventory_quantity
      ? selectedVariant.inventory_quantity > 0
      : true;

    const handleAddToCart = async () => {
      if (!selectedVariantId || !inStock) return;

      setError(null);
      setSuccess(false);

      try {
        await addItem(selectedVariantId, quantity);
        setSuccess(true);
        setTimeout(() => setSuccess(false), 2000);
      } catch (err) {
        setError('Failed to add item to cart. Please try again.');
      }
    };

    return (
      <div className="space-y-4">
        {/* Quantity Selector */}
        <div className="flex items-center gap-4">
          <label className="text-sm font-medium">Quantity:</label>
          <div className="flex items-center border rounded">
            <button
              type="button"
              onClick={() => setQuantity(q => Math.max(1, q - 1))}
              className="px-3 py-2 hover:bg-gray-100"
              aria-label="Decrease quantity"
            >
              −
            </button>
            <span className="px-4 py-2 border-x">{quantity}</span>
            <button
              type="button"
              onClick={() => setQuantity(q => q + 1)}
              className="px-3 py-2 hover:bg-gray-100"
              aria-label="Increase quantity"
            >
              +
            </button>
          </div>
        </div>

        {/* Add to Cart Button */}
        <button
          type="button"
          onClick={handleAddToCart}
          disabled={isLoading || !inStock}
          className={`
            w-full py-3 px-6 rounded-lg font-semibold text-white
            transition-colors duration-200
            ${inStock
              ? 'bg-blue-600 hover:bg-blue-700'
              : 'bg-gray-400 cursor-not-allowed'}
            ${isLoading ? 'opacity-50 cursor-wait' : ''}
            ${success ? 'bg-green-600' : ''}
          `}
        >
          {isLoading ? 'Adding...' : success ? 'Added to Cart!' : inStock ? 'Add to Cart' : 'Out of Stock'}
        </button>

        {/* Error Message */}
        {error && (
          <p className="text-red-600 text-sm">{error}</p>
        )}
      </div>
    );
  }
  ```

#### Task 4.2.7: Cart Functionality

- [ ] **Task 4.2.7**: Implement cart state management and components

  **src/lib/hooks/useCart.ts:**
  ```typescript
  import { create } from 'zustand';
  import { persist } from 'zustand/middleware';
  import { cartApi } from '@/lib/medusa/client';
  import type { Cart, LineItem } from '@/types/medusa';

  interface CartState {
    cart: Cart | null;
    isLoading: boolean;
    error: string | null;

    // Actions
    initializeCart: () => Promise<void>;
    addItem: (variantId: string, quantity?: number) => Promise<void>;
    updateItem: (lineItemId: string, quantity: number) => Promise<void>;
    removeItem: (lineItemId: string) => Promise<void>;
    clearCart: () => void;

    // Computed
    itemCount: number;
    subtotal: number;
  }

  const CART_ID_KEY = 'medusa_cart_id';

  export const useCart = create<CartState>()(
    persist(
      (set, get) => ({
        cart: null,
        isLoading: false,
        error: null,
        itemCount: 0,
        subtotal: 0,

        initializeCart: async () => {
          const storedCartId = localStorage.getItem(CART_ID_KEY);

          if (storedCartId) {
            try {
              set({ isLoading: true });
              const { cart } = await cartApi.retrieve(storedCartId);

              // Check if cart is still valid (not completed)
              if (cart && !cart.completed_at) {
                set({
                  cart,
                  isLoading: false,
                  itemCount: cart.items?.reduce((sum, item) => sum + item.quantity, 0) || 0,
                  subtotal: cart.subtotal || 0,
                });
                return;
              }
            } catch (error) {
              // Cart not found or expired, create new one
              localStorage.removeItem(CART_ID_KEY);
            }
          }

          // Create new cart
          try {
            const { cart } = await cartApi.create();
            localStorage.setItem(CART_ID_KEY, cart.id);
            set({ cart, isLoading: false, itemCount: 0, subtotal: 0 });
          } catch (error) {
            set({ error: 'Failed to create cart', isLoading: false });
          }
        },

        addItem: async (variantId: string, quantity = 1) => {
          const { cart } = get();

          if (!cart) {
            await get().initializeCart();
          }

          const currentCart = get().cart;
          if (!currentCart) return;

          set({ isLoading: true, error: null });

          try {
            const { cart: updatedCart } = await cartApi.addLineItem(
              currentCart.id,
              variantId,
              quantity
            );

            set({
              cart: updatedCart,
              isLoading: false,
              itemCount: updatedCart.items?.reduce((sum, item) => sum + item.quantity, 0) || 0,
              subtotal: updatedCart.subtotal || 0,
            });
          } catch (error) {
            set({ error: 'Failed to add item', isLoading: false });
            throw error;
          }
        },

        updateItem: async (lineItemId: string, quantity: number) => {
          const { cart } = get();
          if (!cart) return;

          set({ isLoading: true, error: null });

          try {
            if (quantity <= 0) {
              await get().removeItem(lineItemId);
              return;
            }

            const { cart: updatedCart } = await cartApi.updateLineItem(
              cart.id,
              lineItemId,
              quantity
            );

            set({
              cart: updatedCart,
              isLoading: false,
              itemCount: updatedCart.items?.reduce((sum, item) => sum + item.quantity, 0) || 0,
              subtotal: updatedCart.subtotal || 0,
            });
          } catch (error) {
            set({ error: 'Failed to update item', isLoading: false });
            throw error;
          }
        },

        removeItem: async (lineItemId: string) => {
          const { cart } = get();
          if (!cart) return;

          set({ isLoading: true, error: null });

          try {
            const { cart: updatedCart } = await cartApi.removeLineItem(
              cart.id,
              lineItemId
            );

            set({
              cart: updatedCart,
              isLoading: false,
              itemCount: updatedCart.items?.reduce((sum, item) => sum + item.quantity, 0) || 0,
              subtotal: updatedCart.subtotal || 0,
            });
          } catch (error) {
            set({ error: 'Failed to remove item', isLoading: false });
            throw error;
          }
        },

        clearCart: () => {
          localStorage.removeItem(CART_ID_KEY);
          set({ cart: null, itemCount: 0, subtotal: 0 });
        },
      }),
      {
        name: 'cart-storage',
        partialize: (state) => ({
          // Only persist cart ID, not full cart object
          cartId: state.cart?.id
        }),
      }
    )
  );
  ```

  **src/components/cart/CartDrawer.tsx:**
  ```tsx
  import { useCart } from '@/lib/hooks/useCart';
  import CartItem from './CartItem';
  import { formatPrice } from '@/lib/utils/price';

  interface Props {
    isOpen: boolean;
    onClose: () => void;
  }

  export default function CartDrawer({ isOpen, onClose }: Props) {
    const { cart, itemCount, subtotal, isLoading } = useCart();

    if (!isOpen) return null;

    return (
      <>
        {/* Backdrop */}
        <div
          className="fixed inset-0 bg-black/50 z-40"
          onClick={onClose}
        />

        {/* Drawer */}
        <div className="fixed right-0 top-0 h-full w-full max-w-md bg-white z-50 shadow-xl">
          <div className="flex flex-col h-full">
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b">
              <h2 className="text-lg font-semibold">
                Shopping Cart ({itemCount} {itemCount === 1 ? 'item' : 'items'})
              </h2>
              <button
                onClick={onClose}
                className="p-2 hover:bg-gray-100 rounded"
                aria-label="Close cart"
              >
                ✕
              </button>
            </div>

            {/* Cart Items */}
            <div className="flex-1 overflow-y-auto p-4">
              {!cart || cart.items?.length === 0 ? (
                <div className="text-center py-12">
                  <p className="text-gray-500">Your cart is empty</p>
                  <a
                    href="/products"
                    className="mt-4 inline-block text-blue-600 hover:underline"
                  >
                    Continue Shopping
                  </a>
                </div>
              ) : (
                <ul className="space-y-4">
                  {cart.items?.map((item) => (
                    <CartItem key={item.id} item={item} />
                  ))}
                </ul>
              )}
            </div>

            {/* Footer with Totals */}
            {cart && cart.items && cart.items.length > 0 && (
              <div className="border-t p-4 space-y-4">
                <div className="flex justify-between text-lg font-semibold">
                  <span>Subtotal</span>
                  <span>{formatPrice(subtotal)}</span>
                </div>
                <p className="text-sm text-gray-500">
                  Shipping and taxes calculated at checkout
                </p>
                <a
                  href="/checkout"
                  className="block w-full py-3 px-6 bg-blue-600 text-white text-center rounded-lg font-semibold hover:bg-blue-700 transition-colors"
                >
                  Proceed to Checkout
                </a>
              </div>
            )}
          </div>
        </div>
      </>
    );
  }
  ```

  **src/components/cart/CartItem.tsx:**
  ```tsx
  import { useCart } from '@/lib/hooks/useCart';
  import { formatPrice } from '@/lib/utils/price';
  import type { LineItem } from '@/types/medusa';

  interface Props {
    item: LineItem;
  }

  export default function CartItem({ item }: Props) {
    const { updateItem, removeItem, isLoading } = useCart();

    const handleQuantityChange = (newQuantity: number) => {
      if (newQuantity < 1) {
        removeItem(item.id);
      } else {
        updateItem(item.id, newQuantity);
      }
    };

    return (
      <li className="flex gap-4">
        {/* Product Image */}
        <div className="w-20 h-20 flex-shrink-0 rounded-lg overflow-hidden bg-gray-100">
          {item.thumbnail ? (
            <img
              src={item.thumbnail}
              alt={item.title}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-gray-400">
              No image
            </div>
          )}
        </div>

        {/* Item Details */}
        <div className="flex-1 min-w-0">
          <h3 className="font-medium truncate">{item.title}</h3>
          {item.variant?.title && item.variant.title !== 'Default' && (
            <p className="text-sm text-gray-500">{item.variant.title}</p>
          )}

          {/* Quantity Controls */}
          <div className="flex items-center gap-2 mt-2">
            <button
              onClick={() => handleQuantityChange(item.quantity - 1)}
              disabled={isLoading}
              className="w-8 h-8 rounded border hover:bg-gray-100 disabled:opacity-50"
              aria-label="Decrease quantity"
            >
              −
            </button>
            <span className="w-8 text-center">{item.quantity}</span>
            <button
              onClick={() => handleQuantityChange(item.quantity + 1)}
              disabled={isLoading}
              className="w-8 h-8 rounded border hover:bg-gray-100 disabled:opacity-50"
              aria-label="Increase quantity"
            >
              +
            </button>
          </div>
        </div>

        {/* Price & Remove */}
        <div className="flex flex-col items-end gap-2">
          <span className="font-semibold">
            {formatPrice(item.unit_price * item.quantity)}
          </span>
          <button
            onClick={() => removeItem(item.id)}
            disabled={isLoading}
            className="text-sm text-red-600 hover:underline disabled:opacity-50"
          >
            Remove
          </button>
        </div>
      </li>
    );
  }
  ```

#### Task 4.2.8: Checkout Flow

- [ ] **Task 4.2.8**: Implement multi-step checkout flow

  **src/pages/checkout/index.astro:**
  ```astro
  ---
  import CheckoutLayout from '@/layouts/CheckoutLayout.astro';
  import CheckoutFlow from '@/components/checkout/CheckoutFlow';

  const title = 'Checkout';
  ---

  <CheckoutLayout title={title}>
    <main class="container mx-auto px-4 py-8">
      <CheckoutFlow client:load />
    </main>
  </CheckoutLayout>
  ```

  **src/components/checkout/CheckoutFlow.tsx:**
  ```tsx
  import { useState, useEffect } from 'react';
  import { useCart } from '@/lib/hooks/useCart';
  import ShippingForm from './ShippingForm';
  import ShippingOptions from './ShippingOptions';
  import PaymentForm from './PaymentForm';
  import OrderSummary from './OrderSummary';
  import { checkoutApi } from '@/lib/medusa/client';

  type CheckoutStep = 'shipping' | 'shipping_method' | 'payment' | 'review';

  export default function CheckoutFlow() {
    const { cart, isLoading: cartLoading } = useCart();
    const [currentStep, setCurrentStep] = useState<CheckoutStep>('shipping');
    const [shippingOptions, setShippingOptions] = useState([]);
    const [isProcessing, setIsProcessing] = useState(false);
    const [error, setError] = useState<string | null>(null);

    // Redirect if cart is empty
    useEffect(() => {
      if (!cartLoading && (!cart || !cart.items?.length)) {
        window.location.href = '/cart';
      }
    }, [cart, cartLoading]);

    // Fetch shipping options after address is set
    useEffect(() => {
      if (currentStep === 'shipping_method' && cart?.id) {
        fetchShippingOptions();
      }
    }, [currentStep, cart?.id]);

    const fetchShippingOptions = async () => {
      if (!cart?.id) return;
      try {
        const { shipping_options } = await checkoutApi.getShippingOptions(cart.id);
        setShippingOptions(shipping_options || []);
      } catch (err) {
        setError('Failed to load shipping options');
      }
    };

    const handleShippingComplete = () => {
      setCurrentStep('shipping_method');
    };

    const handleShippingMethodComplete = () => {
      setCurrentStep('payment');
    };

    const handlePaymentComplete = async () => {
      setCurrentStep('review');
    };

    const handlePlaceOrder = async () => {
      if (!cart?.id) return;

      setIsProcessing(true);
      setError(null);

      try {
        const { order } = await checkoutApi.completeCart(cart.id);

        // Clear cart and redirect to success page
        window.location.href = `/checkout/success?order_id=${order.id}`;
      } catch (err) {
        setError('Failed to place order. Please try again.');
        setIsProcessing(false);
      }
    };

    const steps = [
      { id: 'shipping', label: 'Shipping', number: 1 },
      { id: 'shipping_method', label: 'Delivery', number: 2 },
      { id: 'payment', label: 'Payment', number: 3 },
      { id: 'review', label: 'Review', number: 4 },
    ];

    if (cartLoading) {
      return <div className="text-center py-12">Loading...</div>;
    }

    return (
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Checkout Steps */}
        <div className="lg:col-span-2">
          {/* Progress Steps */}
          <nav className="mb-8">
            <ol className="flex items-center justify-between">
              {steps.map((step, index) => (
                <li
                  key={step.id}
                  className={`flex items-center ${
                    index < steps.length - 1 ? 'flex-1' : ''
                  }`}
                >
                  <div className={`
                    flex items-center justify-center w-8 h-8 rounded-full
                    ${currentStep === step.id
                      ? 'bg-blue-600 text-white'
                      : steps.findIndex(s => s.id === currentStep) > index
                        ? 'bg-green-600 text-white'
                        : 'bg-gray-200 text-gray-600'
                    }
                  `}>
                    {step.number}
                  </div>
                  <span className="ml-2 text-sm font-medium hidden sm:inline">
                    {step.label}
                  </span>
                  {index < steps.length - 1 && (
                    <div className="flex-1 mx-4 h-0.5 bg-gray-200" />
                  )}
                </li>
              ))}
            </ol>
          </nav>

          {/* Error Display */}
          {error && (
            <div className="mb-4 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700">
              {error}
            </div>
          )}

          {/* Step Content */}
          {currentStep === 'shipping' && (
            <ShippingForm
              cart={cart}
              onComplete={handleShippingComplete}
            />
          )}

          {currentStep === 'shipping_method' && (
            <ShippingOptions
              cart={cart}
              options={shippingOptions}
              onComplete={handleShippingMethodComplete}
              onBack={() => setCurrentStep('shipping')}
            />
          )}

          {currentStep === 'payment' && (
            <PaymentForm
              cart={cart}
              onComplete={handlePaymentComplete}
              onBack={() => setCurrentStep('shipping_method')}
            />
          )}

          {currentStep === 'review' && (
            <div className="space-y-6">
              <h2 className="text-xl font-semibold">Review Your Order</h2>

              {/* Order Summary */}
              <div className="border rounded-lg p-4">
                <h3 className="font-medium mb-2">Shipping Address</h3>
                <p className="text-sm text-gray-600">
                  {cart?.shipping_address?.first_name} {cart?.shipping_address?.last_name}<br />
                  {cart?.shipping_address?.address_1}<br />
                  {cart?.shipping_address?.city}, {cart?.shipping_address?.province} {cart?.shipping_address?.postal_code}<br />
                  {cart?.shipping_address?.country_code?.toUpperCase()}
                </p>
              </div>

              <div className="flex gap-4">
                <button
                  onClick={() => setCurrentStep('payment')}
                  className="px-6 py-3 border rounded-lg hover:bg-gray-50"
                >
                  Back
                </button>
                <button
                  onClick={handlePlaceOrder}
                  disabled={isProcessing}
                  className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 disabled:opacity-50"
                >
                  {isProcessing ? 'Processing...' : 'Place Order'}
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Order Summary Sidebar */}
        <div className="lg:col-span-1">
          <OrderSummary cart={cart} />
        </div>
      </div>
    );
  }
  ```

  **src/components/checkout/ShippingForm.tsx:**
  ```tsx
  import { useForm } from 'react-hook-form';
  import { zodResolver } from '@hookform/resolvers/zod';
  import { z } from 'zod';
  import { cartApi } from '@/lib/medusa/client';
  import type { Cart } from '@/types/medusa';

  const shippingSchema = z.object({
    email: z.string().email('Invalid email address'),
    first_name: z.string().min(1, 'First name is required'),
    last_name: z.string().min(1, 'Last name is required'),
    address_1: z.string().min(1, 'Address is required'),
    address_2: z.string().optional(),
    city: z.string().min(1, 'City is required'),
    province: z.string().optional(),
    postal_code: z.string().min(1, 'Postal code is required'),
    country_code: z.string().min(2, 'Country is required'),
    phone: z.string().optional(),
  });

  type ShippingFormData = z.infer<typeof shippingSchema>;

  interface Props {
    cart: Cart | null;
    onComplete: () => void;
  }

  export default function ShippingForm({ cart, onComplete }: Props) {
    const {
      register,
      handleSubmit,
      formState: { errors, isSubmitting },
    } = useForm<ShippingFormData>({
      resolver: zodResolver(shippingSchema),
      defaultValues: {
        email: cart?.email || '',
        first_name: cart?.shipping_address?.first_name || '',
        last_name: cart?.shipping_address?.last_name || '',
        address_1: cart?.shipping_address?.address_1 || '',
        address_2: cart?.shipping_address?.address_2 || '',
        city: cart?.shipping_address?.city || '',
        province: cart?.shipping_address?.province || '',
        postal_code: cart?.shipping_address?.postal_code || '',
        country_code: cart?.shipping_address?.country_code || 'us',
        phone: cart?.shipping_address?.phone || '',
      },
    });

    const onSubmit = async (data: ShippingFormData) => {
      if (!cart?.id) return;

      try {
        await cartApi.updateCart(cart.id, {
          email: data.email,
          shipping_address: {
            first_name: data.first_name,
            last_name: data.last_name,
            address_1: data.address_1,
            address_2: data.address_2,
            city: data.city,
            province: data.province,
            postal_code: data.postal_code,
            country_code: data.country_code,
            phone: data.phone,
          },
        });

        onComplete();
      } catch (error) {
        console.error('Failed to update shipping address:', error);
      }
    };

    return (
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        <h2 className="text-xl font-semibold">Shipping Information</h2>

        {/* Email */}
        <div>
          <label className="block text-sm font-medium mb-1">Email</label>
          <input
            type="email"
            {...register('email')}
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
          {errors.email && (
            <p className="mt-1 text-sm text-red-600">{errors.email.message}</p>
          )}
        </div>

        {/* Name Row */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">First Name</label>
            <input
              type="text"
              {...register('first_name')}
              className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
            />
            {errors.first_name && (
              <p className="mt-1 text-sm text-red-600">{errors.first_name.message}</p>
            )}
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Last Name</label>
            <input
              type="text"
              {...register('last_name')}
              className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
            />
            {errors.last_name && (
              <p className="mt-1 text-sm text-red-600">{errors.last_name.message}</p>
            )}
          </div>
        </div>

        {/* Address */}
        <div>
          <label className="block text-sm font-medium mb-1">Address</label>
          <input
            type="text"
            {...register('address_1')}
            placeholder="Street address"
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
          />
          {errors.address_1 && (
            <p className="mt-1 text-sm text-red-600">{errors.address_1.message}</p>
          )}
        </div>

        <div>
          <input
            type="text"
            {...register('address_2')}
            placeholder="Apartment, suite, etc. (optional)"
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* City, State, Zip Row */}
        <div className="grid grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">City</label>
            <input
              type="text"
              {...register('city')}
              className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
            />
            {errors.city && (
              <p className="mt-1 text-sm text-red-600">{errors.city.message}</p>
            )}
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">State/Province</label>
            <input
              type="text"
              {...register('province')}
              className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">Postal Code</label>
            <input
              type="text"
              {...register('postal_code')}
              className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
            />
            {errors.postal_code && (
              <p className="mt-1 text-sm text-red-600">{errors.postal_code.message}</p>
            )}
          </div>
        </div>

        {/* Country */}
        <div>
          <label className="block text-sm font-medium mb-1">Country</label>
          <select
            {...register('country_code')}
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option value="us">United States</option>
            <option value="ca">Canada</option>
            <option value="mx">Mexico</option>
            <option value="gb">United Kingdom</option>
            <option value="de">Germany</option>
            <option value="fr">France</option>
          </select>
        </div>

        {/* Phone (Optional) */}
        <div>
          <label className="block text-sm font-medium mb-1">Phone (optional)</label>
          <input
            type="tel"
            {...register('phone')}
            className="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <button
          type="submit"
          disabled={isSubmitting}
          className="w-full py-3 px-6 bg-blue-600 text-white rounded-lg font-semibold hover:bg-blue-700 disabled:opacity-50"
        >
          {isSubmitting ? 'Saving...' : 'Continue to Shipping Method'}
        </button>
      </form>
    );
  }
  ```

#### Task 4.2.9: Price Formatting Utilities

- [ ] **Task 4.2.9**: Create price formatting utilities

  **src/lib/utils/price.ts:**
  ```typescript
  /**
   * Format price from smallest unit (cents) to display format
   * @param amount - Price in smallest currency unit (e.g., cents)
   * @param currencyCode - ISO 4217 currency code (default: USD)
   * @param locale - BCP 47 language tag (default: en-US)
   */
  export function formatPrice(
    amount: number,
    currencyCode: string = 'USD',
    locale: string = 'en-US'
  ): string {
    // Medusa stores prices in smallest unit (cents for USD)
    const divisor = getCurrencyDivisor(currencyCode);
    const formattedAmount = amount / divisor;

    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currencyCode,
    }).format(formattedAmount);
  }

  /**
   * Get the divisor for converting from smallest unit to main unit
   */
  function getCurrencyDivisor(currencyCode: string): number {
    // Most currencies use 100 (2 decimal places)
    // Some currencies have different decimal places
    const zeroDecimalCurrencies = ['BIF', 'CLP', 'DJF', 'GNF', 'JPY', 'KMF', 'KRW', 'MGA', 'PYG', 'RWF', 'UGX', 'VND', 'VUV', 'XAF', 'XOF', 'XPF'];
    const threeDecimalCurrencies = ['BHD', 'IQD', 'JOD', 'KWD', 'LYD', 'OMR', 'TND'];

    if (zeroDecimalCurrencies.includes(currencyCode.toUpperCase())) {
      return 1;
    }
    if (threeDecimalCurrencies.includes(currencyCode.toUpperCase())) {
      return 1000;
    }
    return 100;
  }

  /**
   * Calculate percentage discount
   */
  export function calculateDiscount(
    originalPrice: number,
    discountedPrice: number
  ): number {
    if (originalPrice <= 0) return 0;
    return Math.round(((originalPrice - discountedPrice) / originalPrice) * 100);
  }

  /**
   * Format price range (e.g., "$10.00 - $20.00")
   */
  export function formatPriceRange(
    minPrice: number,
    maxPrice: number,
    currencyCode: string = 'USD'
  ): string {
    if (minPrice === maxPrice) {
      return formatPrice(minPrice, currencyCode);
    }
    return `${formatPrice(minPrice, currencyCode)} - ${formatPrice(maxPrice, currencyCode)}`;
  }
  ```

#### Task 4.2.10: Environment Variables for Storefront

- [ ] **Task 4.2.10**: Create storefront environment template

  **.env.example (storefront):**
  ```bash
  # ===========================================
  # ASTRO STOREFRONT ENVIRONMENT VARIABLES
  # ===========================================

  # Medusa Backend Configuration
  # ------------------------------------------
  # URL of your Medusa backend API
  PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000

  # Publishable API key from Medusa admin
  # Generate in Admin > Settings > API Keys
  PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_your_publishable_key

  # Site Configuration
  # ------------------------------------------
  PUBLIC_SITE_URL=https://store.danieltarazona.com
  PUBLIC_SITE_NAME="Daniel Tarazona Store"

  # Stripe Payment (Client-side)
  # ------------------------------------------
  # Stripe publishable key (safe to expose)
  PUBLIC_STRIPE_KEY=pk_test_your_stripe_publishable_key

  # Analytics (Optional)
  # ------------------------------------------
  PUBLIC_GA_TRACKING_ID=
  PUBLIC_PLAUSIBLE_DOMAIN=

  # Feature Flags
  # ------------------------------------------
  PUBLIC_ENABLE_REVIEWS=false
  PUBLIC_ENABLE_WISHLIST=false
  PUBLIC_ENABLE_CUSTOMER_ACCOUNTS=true

  # Image Configuration
  # ------------------------------------------
  # CDN URL for product images (if using external CDN)
  PUBLIC_IMAGE_CDN_URL=
  ```

### Storefront Astro Configuration

- [ ] **Task 4.2.11**: Configure Astro for storefront deployment

  **astro.config.mjs (storefront):**
  ```javascript
  import { defineConfig } from 'astro/config';
  import react from '@astrojs/react';
  import tailwind from '@astrojs/tailwind';
  import sitemap from '@astrojs/sitemap';

  export default defineConfig({
    // Store subdomain
    site: 'https://store.danieltarazona.com',

    // Static output with client-side hydration
    output: 'static',

    // Build configuration
    build: {
      inlineStylesheets: 'auto',
    },

    // Development server
    server: {
      port: 4322, // Different port from portfolio (4321)
      host: true,
    },

    // Integrations
    integrations: [
      react({
        // Enable React 18 features
        experimentalReactChildren: true,
      }),
      tailwind({
        applyBaseStyles: false,
      }),
      sitemap({
        filter: (page) =>
          !page.includes('/checkout/') &&
          !page.includes('/account/'),
      }),
    ],

    // Image optimization
    image: {
      service: {
        entrypoint: 'astro/assets/services/sharp',
      },
      domains: ['localhost', 'medusa-server.example.com'],
    },

    // Prefetch for faster navigation
    prefetch: {
      prefetchAll: false,
      defaultStrategy: 'viewport',
    },

    // Vite configuration
    vite: {
      optimizeDeps: {
        include: ['@medusajs/js-sdk', 'zustand'],
      },
    },
  });
  ```

### Phase 3 Task Summary: Storefront Integration

| Task ID | Task | Status |
|---------|------|--------|
| 4.2.1 | Create Astro storefront project | [ ] |
| 4.2.2 | Configure storefront project structure | [ ] |
| 4.2.3 | Install Medusa SDK and dependencies | [ ] |
| 4.2.4 | Set up Medusa SDK client | [ ] |
| 4.2.5 | Create product listing page | [ ] |
| 4.2.6 | Create product detail page with variant selection | [ ] |
| 4.2.7 | Implement cart state management and components | [ ] |
| 4.2.8 | Implement multi-step checkout flow | [ ] |
| 4.2.9 | Create price formatting utilities | [ ] |
| 4.2.10 | Create storefront environment template | [ ] |
| 4.2.11 | Configure Astro for storefront deployment | [ ] |

### API Integration Quick Reference

| Operation | Method | Endpoint | Description |
|-----------|--------|----------|-------------|
| List Products | GET | `/store/products` | Get all published products |
| Get Product | GET | `/store/products?handle={handle}` | Get product by handle |
| List Collections | GET | `/store/collections` | Get all collections |
| Create Cart | POST | `/store/carts` | Create new cart session |
| Get Cart | GET | `/store/carts/{id}` | Retrieve cart details |
| Add Line Item | POST | `/store/carts/{id}/line-items` | Add product to cart |
| Update Line Item | POST | `/store/carts/{id}/line-items/{item_id}` | Update quantity |
| Remove Line Item | DELETE | `/store/carts/{id}/line-items/{item_id}` | Remove from cart |
| Update Cart | POST | `/store/carts/{id}` | Set email, addresses |
| Get Shipping Options | GET | `/store/shipping-options?cart_id={id}` | Available shipping methods |
| Add Shipping Method | POST | `/store/carts/{id}/shipping-methods` | Select shipping |
| Create Payment Session | POST | `/store/carts/{id}/payment-sessions` | Initialize payment |
| Complete Cart | POST | `/store/carts/{id}/complete` | Finalize order |

---

### Task 4.3: Contact Form Implementation

This section covers the complete implementation of the contact form feature for the portfolio site (`danieltarazona.com`). The contact form allows visitors to send messages that are persisted to Supabase PostgreSQL and trigger email notifications.

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                        CONTACT FORM ARCHITECTURE                                          │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐│
│  │                         PORTFOLIO SITE (danieltarazona.com)                          ││
│  │                                                                                       ││
│  │   ┌──────────────────────────────────────────────────────────────────────────────┐  ││
│  │   │                    ContactForm.tsx (React Island)                             │  ││
│  │   │                                                                               │  ││
│  │   │   ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐  │  ││
│  │   │   │   Form Fields   │  │   Validation    │  │    Submission State         │  │  ││
│  │   │   │   ─────────────  │  │   ────────────  │  │   ─────────────────────────  │  │  ││
│  │   │   │   • name        │  │   • required    │  │   • idle                    │  │  ││
│  │   │   │   • email       │  │   • email fmt   │  │   • submitting              │  │  ││
│  │   │   │   • subject     │  │   • min length  │  │   • success                 │  │  ││
│  │   │   │   • message     │  │   • max length  │  │   • error                   │  │  ││
│  │   │   │   • honeypot    │  │   • honeypot    │  │                             │  │  ││
│  │   │   └─────────────────┘  └─────────────────┘  └─────────────────────────────┘  │  ││
│  │   │                              │                                                │  ││
│  │   └──────────────────────────────┼────────────────────────────────────────────────┘  ││
│  │                                  │                                                    ││
│  │                                  ▼                                                    ││
│  │   ┌──────────────────────────────────────────────────────────────────────────────┐  ││
│  │   │                      contact.ts (API Client)                                  │  ││
│  │   │                                                                               │  ││
│  │   │   submitContactForm(data) ──┬── Option A: Direct Supabase Insert             │  ││
│  │   │                             └── Option B: Edge Function/Worker API            │  ││
│  │   └──────────────────────────────────────────────────────────────────────────────┘  ││
│  │                                  │                                                    ││
│  └──────────────────────────────────┼────────────────────────────────────────────────────┘│
│                                     │                                                     │
│                                     │ HTTPS                                               │
│                                     ▼                                                     │
│  ┌─────────────────────────────────────────────────────────────────────────────────────┐│
│  │                    BACKEND OPTIONS (Choose One)                                      ││
│  │                                                                                       ││
│  │   ┌─────────────────────────┐     ┌─────────────────────────────────────────────┐   ││
│  │   │  Option A: Supabase     │     │  Option B: Cloudflare Workers/Deno Deploy   │   ││
│  │   │  ───────────────────────│     │  ──────────────────────────────────────────  │   ││
│  │   │  • Direct client insert │     │  • Server-side validation                   │   ││
│  │   │  • RLS policies         │     │  • Rate limiting                            │   ││
│  │   │  • Edge Functions for   │     │  • Spam protection                          │   ││
│  │   │    email notifications  │     │  • Email via Resend/SendGrid                │   ││
│  │   │  • Simple setup         │     │  • More control over processing             │   ││
│  │   │  • Good for low traffic │     │  • Better for production scale              │   ││
│  │   └───────────┬─────────────┘     └───────────────────┬─────────────────────────┘   ││
│  │               │                                        │                              ││
│  │               └────────────────────┬───────────────────┘                              ││
│  │                                    │                                                   ││
│  │                                    ▼                                                   ││
│  │   ┌──────────────────────────────────────────────────────────────────────────────┐   ││
│  │   │                    Supabase PostgreSQL                                        │   ││
│  │   │                                                                               │   ││
│  │   │   contact_submissions table:                                                  │   ││
│  │   │   ┌─────────────────────────────────────────────────────────────────────┐    │   ││
│  │   │   │ id | name | email | subject | message | ip_address | created_at | ... │    │   ││
│  │   │   └─────────────────────────────────────────────────────────────────────┘    │   ││
│  │   │                                                                               │   ││
│  │   └──────────────────────────────────────────────────────────────────────────────┘   ││
│  │                                    │                                                   ││
│  │                                    ▼                                                   ││
│  │   ┌──────────────────────────────────────────────────────────────────────────────┐   ││
│  │   │                    Email Notification Service                                 │   ││
│  │   │                                                                               │   ││
│  │   │   Options: Resend │ SendGrid │ AWS SES │ Postmark                            │   ││
│  │   │   → Sends email to contact@danieltarazona.com on new submission              │   ││
│  │   └──────────────────────────────────────────────────────────────────────────────┘   ││
│  │                                                                                       ││
│  └─────────────────────────────────────────────────────────────────────────────────────┘│
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Task 4.3.1: Contact Form React Component

- [ ] **Task 4.3.1**: Create interactive contact form component with React

  The contact form uses React for interactivity (client-side validation, submission state) while the rest of the contact page remains static Astro.

  **src/components/ContactForm.tsx:**
  ```tsx
  import { useState, type FormEvent, type ChangeEvent } from 'react';

  // Form field state type
  interface FormData {
    name: string;
    email: string;
    subject: string;
    message: string;
    honeypot: string; // Spam protection - hidden field
  }

  // Validation error state type
  interface FormErrors {
    name?: string;
    email?: string;
    subject?: string;
    message?: string;
  }

  // Submission state type
  type SubmissionState = 'idle' | 'submitting' | 'success' | 'error';

  // API response type
  interface SubmissionResult {
    success: boolean;
    message?: string;
    error?: string;
  }

  // Props for customization
  interface ContactFormProps {
    /** API endpoint URL for form submission */
    apiEndpoint?: string;
    /** Success message to display after submission */
    successMessage?: string;
    /** Error message to display on submission failure */
    errorMessage?: string;
    /** Recipient email for display purposes */
    recipientEmail?: string;
  }

  const initialFormData: FormData = {
    name: '',
    email: '',
    subject: '',
    message: '',
    honeypot: '',
  };

  export default function ContactForm({
    apiEndpoint = '/api/contact',
    successMessage = 'Thank you for your message! I\'ll get back to you soon.',
    errorMessage = 'Something went wrong. Please try again or email me directly.',
    recipientEmail = 'contact@danieltarazona.com',
  }: ContactFormProps) {
    // Form state
    const [formData, setFormData] = useState<FormData>(initialFormData);
    const [errors, setErrors] = useState<FormErrors>({});
    const [submissionState, setSubmissionState] = useState<SubmissionState>('idle');
    const [serverMessage, setServerMessage] = useState<string>('');

    // Validation rules
    const validateField = (name: keyof FormData, value: string): string | undefined => {
      switch (name) {
        case 'name':
          if (!value.trim()) return 'Name is required';
          if (value.trim().length < 2) return 'Name must be at least 2 characters';
          if (value.trim().length > 100) return 'Name must be less than 100 characters';
          return undefined;

        case 'email':
          if (!value.trim()) return 'Email is required';
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRegex.test(value.trim())) return 'Please enter a valid email address';
          return undefined;

        case 'subject':
          if (value.trim().length > 200) return 'Subject must be less than 200 characters';
          return undefined;

        case 'message':
          if (!value.trim()) return 'Message is required';
          if (value.trim().length < 10) return 'Message must be at least 10 characters';
          if (value.trim().length > 5000) return 'Message must be less than 5000 characters';
          return undefined;

        default:
          return undefined;
      }
    };

    // Validate entire form
    const validateForm = (): boolean => {
      const newErrors: FormErrors = {};
      let isValid = true;

      (['name', 'email', 'subject', 'message'] as const).forEach((field) => {
        const error = validateField(field, formData[field]);
        if (error) {
          newErrors[field] = error;
          isValid = false;
        }
      });

      setErrors(newErrors);
      return isValid;
    };

    // Handle input changes with live validation
    const handleChange = (
      e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
    ) => {
      const { name, value } = e.target;
      setFormData((prev) => ({ ...prev, [name]: value }));

      // Clear error when user starts typing
      if (errors[name as keyof FormErrors]) {
        setErrors((prev) => ({ ...prev, [name]: undefined }));
      }
    };

    // Handle blur for field validation
    const handleBlur = (
      e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
    ) => {
      const { name, value } = e.target;
      const error = validateField(name as keyof FormData, value);
      if (error) {
        setErrors((prev) => ({ ...prev, [name]: error }));
      }
    };

    // Submit form
    const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
      e.preventDefault();

      // Check honeypot (spam bot protection)
      if (formData.honeypot) {
        // Silently "succeed" to fool bots
        setSubmissionState('success');
        return;
      }

      // Validate form
      if (!validateForm()) {
        return;
      }

      setSubmissionState('submitting');
      setServerMessage('');

      try {
        const response = await fetch(apiEndpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            name: formData.name.trim(),
            email: formData.email.trim(),
            subject: formData.subject.trim() || undefined,
            message: formData.message.trim(),
          }),
        });

        const result: SubmissionResult = await response.json();

        if (response.ok && result.success) {
          setSubmissionState('success');
          setFormData(initialFormData);
        } else {
          setSubmissionState('error');
          setServerMessage(result.error || errorMessage);
        }
      } catch (error) {
        setSubmissionState('error');
        setServerMessage(errorMessage);
      }
    };

    // Reset form to try again
    const handleReset = () => {
      setSubmissionState('idle');
      setServerMessage('');
      setErrors({});
    };

    // Success state
    if (submissionState === 'success') {
      return (
        <div className="contact-form-success" role="alert">
          <div className="success-icon">✓</div>
          <h3>Message Sent!</h3>
          <p>{successMessage}</p>
          <button
            type="button"
            onClick={handleReset}
            className="btn btn-secondary"
          >
            Send Another Message
          </button>
        </div>
      );
    }

    return (
      <form
        onSubmit={handleSubmit}
        className="contact-form"
        noValidate
        aria-label="Contact form"
      >
        {/* Error banner */}
        {submissionState === 'error' && serverMessage && (
          <div className="form-error-banner" role="alert">
            <p>{serverMessage}</p>
            <p>
              You can also email me directly at{' '}
              <a href={`mailto:${recipientEmail}`}>{recipientEmail}</a>
            </p>
          </div>
        )}

        {/* Honeypot field - hidden from users, visible to bots */}
        <div className="honeypot" aria-hidden="true">
          <label htmlFor="honeypot">Leave this field empty</label>
          <input
            type="text"
            id="honeypot"
            name="honeypot"
            value={formData.honeypot}
            onChange={handleChange}
            tabIndex={-1}
            autoComplete="off"
          />
        </div>

        {/* Name field */}
        <div className="form-group">
          <label htmlFor="name">
            Name <span className="required">*</span>
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            onBlur={handleBlur}
            required
            autoComplete="name"
            maxLength={100}
            disabled={submissionState === 'submitting'}
            aria-invalid={errors.name ? 'true' : 'false'}
            aria-describedby={errors.name ? 'name-error' : undefined}
            className={errors.name ? 'input-error' : ''}
          />
          {errors.name && (
            <span id="name-error" className="field-error" role="alert">
              {errors.name}
            </span>
          )}
        </div>

        {/* Email field */}
        <div className="form-group">
          <label htmlFor="email">
            Email <span className="required">*</span>
          </label>
          <input
            type="email"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            onBlur={handleBlur}
            required
            autoComplete="email"
            disabled={submissionState === 'submitting'}
            aria-invalid={errors.email ? 'true' : 'false'}
            aria-describedby={errors.email ? 'email-error' : undefined}
            className={errors.email ? 'input-error' : ''}
          />
          {errors.email && (
            <span id="email-error" className="field-error" role="alert">
              {errors.email}
            </span>
          )}
        </div>

        {/* Subject field (optional) */}
        <div className="form-group">
          <label htmlFor="subject">Subject</label>
          <input
            type="text"
            id="subject"
            name="subject"
            value={formData.subject}
            onChange={handleChange}
            onBlur={handleBlur}
            maxLength={200}
            disabled={submissionState === 'submitting'}
            aria-invalid={errors.subject ? 'true' : 'false'}
            aria-describedby={errors.subject ? 'subject-error' : undefined}
            className={errors.subject ? 'input-error' : ''}
          />
          {errors.subject && (
            <span id="subject-error" className="field-error" role="alert">
              {errors.subject}
            </span>
          )}
        </div>

        {/* Message field */}
        <div className="form-group">
          <label htmlFor="message">
            Message <span className="required">*</span>
          </label>
          <textarea
            id="message"
            name="message"
            value={formData.message}
            onChange={handleChange}
            onBlur={handleBlur}
            required
            rows={6}
            maxLength={5000}
            disabled={submissionState === 'submitting'}
            aria-invalid={errors.message ? 'true' : 'false'}
            aria-describedby={errors.message ? 'message-error' : undefined}
            className={errors.message ? 'input-error' : ''}
          />
          {errors.message && (
            <span id="message-error" className="field-error" role="alert">
              {errors.message}
            </span>
          )}
          <span className="character-count">
            {formData.message.length}/5000 characters
          </span>
        </div>

        {/* Submit button */}
        <button
          type="submit"
          className="btn btn-primary"
          disabled={submissionState === 'submitting'}
        >
          {submissionState === 'submitting' ? (
            <>
              <span className="spinner" aria-hidden="true"></span>
              Sending...
            </>
          ) : (
            'Send Message'
          )}
        </button>
      </form>
    );
  }
  ```

#### Task 4.3.2: Contact Form Styles

- [ ] **Task 4.3.2**: Create CSS styles for the contact form

  **src/styles/contact-form.css:**
  ```css
  /* Contact Form Styles */

  .contact-form {
    max-width: 600px;
    margin: 0 auto;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  .form-group label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: var(--color-text);
  }

  .form-group .required {
    color: var(--color-error, #dc2626);
  }

  .form-group input,
  .form-group textarea {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1px solid var(--color-border, #e5e7eb);
    border-radius: 0.5rem;
    font-size: 1rem;
    font-family: inherit;
    background-color: var(--color-bg-input, #fff);
    color: var(--color-text);
    transition: border-color 0.2s, box-shadow 0.2s;
  }

  .form-group input:focus,
  .form-group textarea:focus {
    outline: none;
    border-color: var(--color-primary, #3b82f6);
    box-shadow: 0 0 0 3px var(--color-primary-alpha, rgba(59, 130, 246, 0.1));
  }

  .form-group input.input-error,
  .form-group textarea.input-error {
    border-color: var(--color-error, #dc2626);
  }

  .form-group input.input-error:focus,
  .form-group textarea.input-error:focus {
    box-shadow: 0 0 0 3px var(--color-error-alpha, rgba(220, 38, 38, 0.1));
  }

  .form-group input:disabled,
  .form-group textarea:disabled {
    background-color: var(--color-bg-disabled, #f3f4f6);
    cursor: not-allowed;
  }

  .field-error {
    display: block;
    margin-top: 0.5rem;
    color: var(--color-error, #dc2626);
    font-size: 0.875rem;
  }

  .character-count {
    display: block;
    margin-top: 0.25rem;
    color: var(--color-text-muted, #6b7280);
    font-size: 0.75rem;
    text-align: right;
  }

  /* Honeypot field - hide from visual users */
  .honeypot {
    position: absolute;
    left: -9999px;
    opacity: 0;
    height: 0;
    overflow: hidden;
  }

  /* Buttons */
  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 0.5rem;
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.1s;
  }

  .btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .btn-primary {
    background-color: var(--color-primary, #3b82f6);
    color: white;
  }

  .btn-primary:hover:not(:disabled) {
    background-color: var(--color-primary-dark, #2563eb);
  }

  .btn-primary:active:not(:disabled) {
    transform: scale(0.98);
  }

  .btn-secondary {
    background-color: var(--color-bg-secondary, #f3f4f6);
    color: var(--color-text);
  }

  .btn-secondary:hover:not(:disabled) {
    background-color: var(--color-bg-secondary-dark, #e5e7eb);
  }

  /* Loading spinner */
  .spinner {
    width: 1rem;
    height: 1rem;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }

  /* Error banner */
  .form-error-banner {
    padding: 1rem;
    margin-bottom: 1.5rem;
    background-color: var(--color-error-bg, #fef2f2);
    border: 1px solid var(--color-error-border, #fecaca);
    border-radius: 0.5rem;
    color: var(--color-error-text, #991b1b);
  }

  .form-error-banner p {
    margin: 0;
  }

  .form-error-banner p + p {
    margin-top: 0.5rem;
  }

  .form-error-banner a {
    color: var(--color-error-text, #991b1b);
    text-decoration: underline;
  }

  /* Success state */
  .contact-form-success {
    text-align: center;
    padding: 2rem;
  }

  .success-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 4rem;
    height: 4rem;
    margin-bottom: 1rem;
    background-color: var(--color-success-bg, #dcfce7);
    color: var(--color-success, #16a34a);
    border-radius: 50%;
    font-size: 2rem;
  }

  .contact-form-success h3 {
    margin: 0 0 0.5rem;
    color: var(--color-text);
  }

  .contact-form-success p {
    margin: 0 0 1.5rem;
    color: var(--color-text-muted);
  }

  /* Dark mode support */
  @media (prefers-color-scheme: dark) {
    .form-group input,
    .form-group textarea {
      background-color: var(--color-bg-input-dark, #1f2937);
      border-color: var(--color-border-dark, #374151);
    }
  }

  /* Responsive adjustments */
  @media (max-width: 640px) {
    .contact-form {
      padding: 0 1rem;
    }

    .btn {
      width: 100%;
    }
  }
  ```

#### Task 4.3.3: Contact Page Integration

- [ ] **Task 4.3.3**: Create the contact page with the form component

  **src/pages/contact.astro:**
  ```astro
  ---
  import PageLayout from '@layouts/PageLayout.astro';
  import ContactForm from '@components/ContactForm';

  // Contact page metadata
  const title = 'Contact';
  const description = 'Get in touch with Daniel Tarazona. Send a message for project inquiries, collaborations, or just to say hello.';

  // Contact form configuration
  const contactEmail = import.meta.env.PUBLIC_CONTACT_EMAIL || 'contact@danieltarazona.com';
  const apiEndpoint = import.meta.env.PUBLIC_CONTACT_API || '/api/contact';
  ---

  <PageLayout title={title} description={description}>
    <main class="contact-page">
      <div class="container">
        <header class="page-header">
          <h1>Get in Touch</h1>
          <p class="lead">
            Have a question, project idea, or just want to say hello?
            I'd love to hear from you. Fill out the form below and I'll get back to you as soon as possible.
          </p>
        </header>

        <div class="contact-content">
          <section class="contact-form-section">
            <ContactForm
              client:load
              apiEndpoint={apiEndpoint}
              recipientEmail={contactEmail}
              successMessage="Thank you for reaching out! I typically respond within 24-48 hours."
              errorMessage="Oops! Something went wrong. Please try again or email me directly."
            />
          </section>

          <aside class="contact-info">
            <h2>Other Ways to Connect</h2>

            <div class="contact-method">
              <h3>Email</h3>
              <a href={`mailto:${contactEmail}`}>{contactEmail}</a>
            </div>

            <div class="contact-method">
              <h3>Social Media</h3>
              <ul class="social-links">
                <li>
                  <a href="https://github.com/danieltarazona" target="_blank" rel="noopener noreferrer">
                    GitHub
                  </a>
                </li>
                <li>
                  <a href="https://linkedin.com/in/danieltarazona" target="_blank" rel="noopener noreferrer">
                    LinkedIn
                  </a>
                </li>
                <li>
                  <a href="https://twitter.com/danieltarazona" target="_blank" rel="noopener noreferrer">
                    Twitter
                  </a>
                </li>
              </ul>
            </div>

            <div class="contact-method">
              <h3>Response Time</h3>
              <p>I typically respond to messages within 24-48 hours during weekdays.</p>
            </div>
          </aside>
        </div>
      </div>
    </main>
  </PageLayout>

  <style>
    /* Import contact form styles */
    @import '../styles/contact-form.css';

    .contact-page {
      padding: 4rem 0;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 1.5rem;
    }

    .page-header {
      text-align: center;
      margin-bottom: 3rem;
    }

    .page-header h1 {
      font-size: 2.5rem;
      margin-bottom: 1rem;
    }

    .lead {
      font-size: 1.125rem;
      color: var(--color-text-muted);
      max-width: 600px;
      margin: 0 auto;
    }

    .contact-content {
      display: grid;
      grid-template-columns: 1fr 300px;
      gap: 4rem;
      align-items: start;
    }

    .contact-info {
      position: sticky;
      top: 2rem;
    }

    .contact-info h2 {
      font-size: 1.25rem;
      margin-bottom: 1.5rem;
      padding-bottom: 0.5rem;
      border-bottom: 1px solid var(--color-border);
    }

    .contact-method {
      margin-bottom: 1.5rem;
    }

    .contact-method h3 {
      font-size: 0.875rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--color-text-muted);
      margin-bottom: 0.5rem;
    }

    .contact-method a {
      color: var(--color-primary);
      text-decoration: none;
    }

    .contact-method a:hover {
      text-decoration: underline;
    }

    .social-links {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .social-links li {
      margin-bottom: 0.5rem;
    }

    @media (max-width: 768px) {
      .contact-content {
        grid-template-columns: 1fr;
        gap: 2rem;
      }

      .contact-info {
        position: static;
        order: 2;
      }

      .contact-form-section {
        order: 1;
      }
    }
  </style>
  ```

#### Task 4.3.4: Validation Utilities

- [ ] **Task 4.3.4**: Create shared validation utilities

  **src/lib/validation.ts:**
  ```typescript
  /**
   * Contact form validation utilities
   * Shared between client-side and server-side validation
   */

  // Validation result type
  export interface ValidationResult {
    isValid: boolean;
    errors: Record<string, string>;
  }

  // Contact form data type
  export interface ContactFormData {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  // Email regex pattern (RFC 5322 simplified)
  const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  // Field length limits
  export const FIELD_LIMITS = {
    name: { min: 2, max: 100 },
    email: { max: 254 },
    subject: { max: 200 },
    message: { min: 10, max: 5000 },
  } as const;

  /**
   * Validate a single field
   */
  export function validateField(
    field: keyof ContactFormData,
    value: string
  ): string | null {
    const trimmedValue = value.trim();

    switch (field) {
      case 'name':
        if (!trimmedValue) return 'Name is required';
        if (trimmedValue.length < FIELD_LIMITS.name.min)
          return `Name must be at least ${FIELD_LIMITS.name.min} characters`;
        if (trimmedValue.length > FIELD_LIMITS.name.max)
          return `Name must be less than ${FIELD_LIMITS.name.max} characters`;
        return null;

      case 'email':
        if (!trimmedValue) return 'Email is required';
        if (!EMAIL_REGEX.test(trimmedValue))
          return 'Please enter a valid email address';
        if (trimmedValue.length > FIELD_LIMITS.email.max)
          return `Email must be less than ${FIELD_LIMITS.email.max} characters`;
        return null;

      case 'subject':
        if (trimmedValue.length > FIELD_LIMITS.subject.max)
          return `Subject must be less than ${FIELD_LIMITS.subject.max} characters`;
        return null;

      case 'message':
        if (!trimmedValue) return 'Message is required';
        if (trimmedValue.length < FIELD_LIMITS.message.min)
          return `Message must be at least ${FIELD_LIMITS.message.min} characters`;
        if (trimmedValue.length > FIELD_LIMITS.message.max)
          return `Message must be less than ${FIELD_LIMITS.message.max} characters`;
        return null;

      default:
        return null;
    }
  }

  /**
   * Validate entire contact form data
   */
  export function validateContactForm(data: ContactFormData): ValidationResult {
    const errors: Record<string, string> = {};

    const nameError = validateField('name', data.name);
    if (nameError) errors.name = nameError;

    const emailError = validateField('email', data.email);
    if (emailError) errors.email = emailError;

    if (data.subject) {
      const subjectError = validateField('subject', data.subject);
      if (subjectError) errors.subject = subjectError;
    }

    const messageError = validateField('message', data.message);
    if (messageError) errors.message = messageError;

    return {
      isValid: Object.keys(errors).length === 0,
      errors,
    };
  }

  /**
   * Sanitize input by trimming and removing dangerous characters
   */
  export function sanitizeInput(value: string): string {
    return value
      .trim()
      .replace(/[<>]/g, '') // Remove angle brackets
      .slice(0, 10000); // Hard limit
  }

  /**
   * Sanitize contact form data
   */
  export function sanitizeContactForm(data: ContactFormData): ContactFormData {
    return {
      name: sanitizeInput(data.name),
      email: sanitizeInput(data.email).toLowerCase(),
      subject: data.subject ? sanitizeInput(data.subject) : undefined,
      message: sanitizeInput(data.message),
    };
  }
  ```

#### Task 4.3.5: Supabase Table Schema

- [ ] **Task 4.3.5**: Ensure contact_submissions table is properly configured

  The table schema was defined in Phase 2 (Task 3.8). This task ensures the schema is complete and optimized:

  **supabase/migrations/YYYYMMDD_contact_form_enhancements.sql:**
  ```sql
  -- Contact Form Table Enhancements
  -- Run after the initial contact_submissions table creation

  -- Add spam score column for future ML-based spam detection
  ALTER TABLE contact_submissions
    ADD COLUMN IF NOT EXISTS spam_score DECIMAL(3,2) DEFAULT 0.00,
    ADD COLUMN IF NOT EXISTS is_spam BOOLEAN DEFAULT FALSE;

  -- Add notification tracking
  ALTER TABLE contact_submissions
    ADD COLUMN IF NOT EXISTS notification_sent_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS notification_failed BOOLEAN DEFAULT FALSE;

  -- Add source tracking
  ALTER TABLE contact_submissions
    ADD COLUMN IF NOT EXISTS source VARCHAR(50) DEFAULT 'website';

  -- Create indexes for common queries
  CREATE INDEX IF NOT EXISTS idx_contact_email ON contact_submissions(email);
  CREATE INDEX IF NOT EXISTS idx_contact_spam ON contact_submissions(is_spam)
    WHERE is_spam = FALSE;
  CREATE INDEX IF NOT EXISTS idx_contact_notifications ON contact_submissions(notification_sent_at)
    WHERE notification_sent_at IS NULL AND notification_failed = FALSE;

  -- Update RLS policies for enhanced security
  DROP POLICY IF EXISTS "Allow anonymous contact submission" ON contact_submissions;

  CREATE POLICY "Allow anonymous contact submission v2" ON contact_submissions
    FOR INSERT TO anon
    WITH CHECK (
      -- Only allow inserts, not updates
      true
      -- Rate limiting should be handled at the edge (Workers/Functions)
    );

  -- Function to check for duplicate submissions (spam prevention)
  CREATE OR REPLACE FUNCTION check_duplicate_submission(
    p_email VARCHAR,
    p_message_hash VARCHAR,
    p_window_minutes INT DEFAULT 5
  ) RETURNS BOOLEAN AS $$
  BEGIN
    RETURN EXISTS (
      SELECT 1 FROM contact_submissions
      WHERE email = p_email
        AND md5(message) = p_message_hash
        AND created_at > NOW() - (p_window_minutes || ' minutes')::interval
    );
  END;
  $$ LANGUAGE plpgsql SECURITY DEFINER;

  -- Grant execute permission
  GRANT EXECUTE ON FUNCTION check_duplicate_submission TO anon;

  -- Comment updates
  COMMENT ON COLUMN contact_submissions.spam_score IS 'Spam probability score from 0.00 to 1.00';
  COMMENT ON COLUMN contact_submissions.is_spam IS 'Whether the submission was marked as spam';
  COMMENT ON COLUMN contact_submissions.notification_sent_at IS 'When email notification was successfully sent';
  COMMENT ON COLUMN contact_submissions.source IS 'Source of submission (website, api, etc)';
  ```

#### Task 4.3.6: API Endpoint (Cloudflare Workers)

- [ ] **Task 4.3.6**: Create Cloudflare Worker for contact form API

  **functions/api/contact.ts (Cloudflare Pages Function):**
  ```typescript
  /**
   * Contact Form API Endpoint
   * Cloudflare Pages Function / Cloudflare Worker
   *
   * Handles contact form submissions with:
   * - Server-side validation
   * - Rate limiting
   * - Spam detection
   * - Database persistence
   * - Email notifications
   */

  import { createClient, SupabaseClient } from '@supabase/supabase-js';

  interface Env {
    SUPABASE_URL: string;
    SUPABASE_SERVICE_ROLE_KEY: string;
    RESEND_API_KEY?: string;
    NOTIFICATION_EMAIL: string;
    RATE_LIMIT_KV?: KVNamespace;
  }

  interface ContactPayload {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  interface RateLimitResult {
    allowed: boolean;
    remaining: number;
    resetAt: number;
  }

  // CORS headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  // Rate limiting configuration
  const RATE_LIMIT = {
    maxRequests: 5,
    windowMs: 60 * 60 * 1000, // 1 hour
  };

  // Validation
  function validatePayload(payload: unknown): ContactPayload | null {
    if (!payload || typeof payload !== 'object') return null;

    const data = payload as Record<string, unknown>;

    if (
      typeof data.name !== 'string' ||
      typeof data.email !== 'string' ||
      typeof data.message !== 'string'
    ) {
      return null;
    }

    const name = data.name.trim();
    const email = data.email.trim().toLowerCase();
    const subject = typeof data.subject === 'string' ? data.subject.trim() : undefined;
    const message = data.message.trim();

    // Length validation
    if (name.length < 2 || name.length > 100) return null;
    if (email.length > 254) return null;
    if (subject && subject.length > 200) return null;
    if (message.length < 10 || message.length > 5000) return null;

    // Email format validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) return null;

    return { name, email, subject, message };
  }

  // Rate limiting using KV
  async function checkRateLimit(
    kv: KVNamespace | undefined,
    ip: string
  ): Promise<RateLimitResult> {
    if (!kv) {
      // If KV not available, allow request (fallback)
      return { allowed: true, remaining: RATE_LIMIT.maxRequests, resetAt: 0 };
    }

    const key = `ratelimit:contact:${ip}`;
    const now = Date.now();
    const windowStart = now - RATE_LIMIT.windowMs;

    // Get current count
    const stored = await kv.get<{ count: number; timestamps: number[] }>(key, 'json');

    if (!stored) {
      // First request
      await kv.put(
        key,
        JSON.stringify({ count: 1, timestamps: [now] }),
        { expirationTtl: Math.ceil(RATE_LIMIT.windowMs / 1000) }
      );
      return {
        allowed: true,
        remaining: RATE_LIMIT.maxRequests - 1,
        resetAt: now + RATE_LIMIT.windowMs,
      };
    }

    // Filter out old timestamps
    const validTimestamps = stored.timestamps.filter((t) => t > windowStart);

    if (validTimestamps.length >= RATE_LIMIT.maxRequests) {
      const oldestTimestamp = Math.min(...validTimestamps);
      return {
        allowed: false,
        remaining: 0,
        resetAt: oldestTimestamp + RATE_LIMIT.windowMs,
      };
    }

    // Add new timestamp
    validTimestamps.push(now);
    await kv.put(
      key,
      JSON.stringify({ count: validTimestamps.length, timestamps: validTimestamps }),
      { expirationTtl: Math.ceil(RATE_LIMIT.windowMs / 1000) }
    );

    return {
      allowed: true,
      remaining: RATE_LIMIT.maxRequests - validTimestamps.length,
      resetAt: Math.min(...validTimestamps) + RATE_LIMIT.windowMs,
    };
  }

  // Simple spam detection
  function calculateSpamScore(payload: ContactPayload): number {
    let score = 0;

    // Check for common spam patterns
    const spamPatterns = [
      /\b(viagra|cialis|casino|lottery|winner|prize)\b/i,
      /\b(click here|buy now|limited time|act now)\b/i,
      /https?:\/\/[^\s]+/g, // Multiple URLs
    ];

    const fullText = `${payload.name} ${payload.subject || ''} ${payload.message}`;

    for (const pattern of spamPatterns) {
      const matches = fullText.match(pattern);
      if (matches) {
        score += 0.2 * matches.length;
      }
    }

    // Check for all caps
    if (payload.message === payload.message.toUpperCase() && payload.message.length > 20) {
      score += 0.3;
    }

    // Check for excessive special characters
    const specialCharRatio = (payload.message.match(/[!@#$%^&*()]/g) || []).length / payload.message.length;
    if (specialCharRatio > 0.1) {
      score += 0.2;
    }

    return Math.min(score, 1);
  }

  // Send email notification
  async function sendNotification(
    payload: ContactPayload,
    env: Env
  ): Promise<boolean> {
    if (!env.RESEND_API_KEY) {
      return false;
    }

    try {
      const response = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${env.RESEND_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: 'Contact Form <noreply@danieltarazona.com>',
          to: env.NOTIFICATION_EMAIL,
          subject: `New Contact: ${payload.subject || 'No Subject'}`,
          html: `
            <h2>New Contact Form Submission</h2>
            <p><strong>From:</strong> ${payload.name} (${payload.email})</p>
            <p><strong>Subject:</strong> ${payload.subject || 'No Subject'}</p>
            <h3>Message:</h3>
            <p>${payload.message.replace(/\n/g, '<br>')}</p>
          `,
          reply_to: payload.email,
        }),
      });

      return response.ok;
    } catch (error) {
      return false;
    }
  }

  // Main handler
  export const onRequest: PagesFunction<Env> = async (context) => {
    const { request, env } = context;

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // Only allow POST
    if (request.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    try {
      // Get client IP for rate limiting
      const clientIP = request.headers.get('CF-Connecting-IP') || 'unknown';

      // Check rate limit
      const rateLimitResult = await checkRateLimit(env.RATE_LIMIT_KV, clientIP);

      if (!rateLimitResult.allowed) {
        return new Response(
          JSON.stringify({
            error: 'Too many requests. Please try again later.',
            retryAfter: Math.ceil((rateLimitResult.resetAt - Date.now()) / 1000),
          }),
          {
            status: 429,
            headers: {
              ...corsHeaders,
              'Content-Type': 'application/json',
              'Retry-After': String(Math.ceil((rateLimitResult.resetAt - Date.now()) / 1000)),
              'X-RateLimit-Remaining': '0',
            },
          }
        );
      }

      // Parse and validate payload
      let rawPayload: unknown;
      try {
        rawPayload = await request.json();
      } catch {
        return new Response(
          JSON.stringify({ error: 'Invalid JSON' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      const payload = validatePayload(rawPayload);
      if (!payload) {
        return new Response(
          JSON.stringify({ error: 'Invalid form data. Please check your input.' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Calculate spam score
      const spamScore = calculateSpamScore(payload);
      const isSpam = spamScore >= 0.7;

      // Create Supabase client
      const supabase = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY);

      // Insert into database
      const { error: dbError } = await supabase
        .from('contact_submissions')
        .insert({
          name: payload.name,
          email: payload.email,
          subject: payload.subject,
          message: payload.message,
          ip_address: clientIP,
          user_agent: request.headers.get('User-Agent'),
          referrer: request.headers.get('Referer'),
          spam_score: spamScore,
          is_spam: isSpam,
          source: 'website',
        });

      if (dbError) {
        throw new Error(`Database error: ${dbError.message}`);
      }

      // Send email notification (only for non-spam)
      let notificationSent = false;
      if (!isSpam) {
        notificationSent = await sendNotification(payload, env);
      }

      return new Response(
        JSON.stringify({
          success: true,
          message: 'Your message has been sent successfully.',
        }),
        {
          status: 200,
          headers: {
            ...corsHeaders,
            'Content-Type': 'application/json',
            'X-RateLimit-Remaining': String(rateLimitResult.remaining),
          },
        }
      );
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Unknown error';

      return new Response(
        JSON.stringify({ error: 'An error occurred. Please try again later.' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
  };
  ```

#### Task 4.3.7: API Endpoint (Deno Deploy Alternative)

- [ ] **Task 4.3.7**: Create Deno Deploy function as alternative API endpoint

  **api/contact.ts (Deno Deploy):**
  ```typescript
  /**
   * Contact Form API - Deno Deploy
   * Alternative to Cloudflare Workers
   */

  import { serve } from 'https://deno.land/std@0.208.0/http/server.ts';
  import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

  interface ContactPayload {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  // Rate limiting with Deno KV
  const kv = await Deno.openKv();
  const RATE_LIMIT = { maxRequests: 5, windowMs: 3600000 }; // 5 per hour

  async function checkRateLimit(ip: string): Promise<boolean> {
    const key = ['ratelimit', 'contact', ip];
    const entry = await kv.get<{ count: number; resetAt: number }>(key);
    const now = Date.now();

    if (!entry.value || now > entry.value.resetAt) {
      await kv.set(key, { count: 1, resetAt: now + RATE_LIMIT.windowMs }, {
        expireIn: RATE_LIMIT.windowMs,
      });
      return true;
    }

    if (entry.value.count >= RATE_LIMIT.maxRequests) {
      return false;
    }

    await kv.set(key, { count: entry.value.count + 1, resetAt: entry.value.resetAt }, {
      expireIn: entry.value.resetAt - now,
    });
    return true;
  }

  function validatePayload(data: unknown): ContactPayload | null {
    if (!data || typeof data !== 'object') return null;

    const payload = data as Record<string, unknown>;

    if (
      typeof payload.name !== 'string' ||
      typeof payload.email !== 'string' ||
      typeof payload.message !== 'string'
    ) {
      return null;
    }

    const name = payload.name.trim();
    const email = payload.email.trim().toLowerCase();
    const subject = typeof payload.subject === 'string' ? payload.subject.trim() : undefined;
    const message = payload.message.trim();

    // Validation
    if (name.length < 2 || name.length > 100) return null;
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return null;
    if (subject && subject.length > 200) return null;
    if (message.length < 10 || message.length > 5000) return null;

    return { name, email, subject, message };
  }

  async function sendNotification(payload: ContactPayload): Promise<boolean> {
    const resendKey = Deno.env.get('RESEND_API_KEY');
    const notificationEmail = Deno.env.get('NOTIFICATION_EMAIL');

    if (!resendKey || !notificationEmail) return false;

    try {
      const res = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${resendKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: 'Contact Form <noreply@danieltarazona.com>',
          to: notificationEmail,
          subject: `New Contact: ${payload.subject || 'No Subject'}`,
          html: `
            <h2>New Contact Form Submission</h2>
            <p><strong>From:</strong> ${payload.name} (${payload.email})</p>
            <p><strong>Subject:</strong> ${payload.subject || 'No Subject'}</p>
            <h3>Message:</h3>
            <p>${payload.message.replace(/\n/g, '<br>')}</p>
          `,
          reply_to: payload.email,
        }),
      });
      return res.ok;
    } catch {
      return false;
    }
  }

  serve(async (req: Request) => {
    // CORS preflight
    if (req.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    if (req.method !== 'POST') {
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    try {
      // Rate limiting
      const clientIP = req.headers.get('x-forwarded-for')?.split(',')[0] || 'unknown';

      if (!(await checkRateLimit(clientIP))) {
        return new Response(
          JSON.stringify({ error: 'Too many requests. Please try again later.' }),
          { status: 429, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Parse payload
      const rawPayload = await req.json();
      const payload = validatePayload(rawPayload);

      if (!payload) {
        return new Response(
          JSON.stringify({ error: 'Invalid form data' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
      }

      // Supabase insert
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL')!,
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
      );

      const { error } = await supabase.from('contact_submissions').insert({
        name: payload.name,
        email: payload.email,
        subject: payload.subject,
        message: payload.message,
        ip_address: clientIP,
        user_agent: req.headers.get('User-Agent'),
        source: 'website-deno',
      });

      if (error) throw error;

      // Send notification
      await sendNotification(payload);

      return new Response(
        JSON.stringify({ success: true, message: 'Message sent successfully' }),
        { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    } catch (error) {
      return new Response(
        JSON.stringify({ error: 'An error occurred' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }
  });
  ```

  **Deploy to Deno Deploy:**
  ```bash
  # Install Deno
  curl -fsSL https://deno.land/install.sh | sh

  # Install deployctl
  deno install -A --no-check -r -f https://deno.land/x/deploy/deployctl.ts

  # Deploy
  deployctl deploy --project=danieltarazona-contact api/contact.ts

  # Set environment variables in Deno Deploy dashboard:
  # - SUPABASE_URL
  # - SUPABASE_SERVICE_ROLE_KEY
  # - RESEND_API_KEY
  # - NOTIFICATION_EMAIL
  ```

#### Task 4.3.8: Email Notification Service

- [ ] **Task 4.3.8**: Configure email notification service

  **Email Provider Options:**

  | Provider | Free Tier | Best For |
  |----------|-----------|----------|
  | **Resend** | 3,000/month | Modern API, great DX |
  | **SendGrid** | 100/day | Enterprise features |
  | **AWS SES** | 62,000/month (EC2) | High volume, AWS users |
  | **Postmark** | 100/month | Transactional focus |

  **Resend Setup (Recommended):**
  ```bash
  # 1. Sign up at https://resend.com
  # 2. Verify your domain (danieltarazona.com)
  # 3. Get API key
  # 4. Set environment variable

  # Environment variables needed:
  RESEND_API_KEY=re_xxxxxxxxxxxxx
  NOTIFICATION_EMAIL=contact@danieltarazona.com
  ```

  **Email Template (`src/lib/email-templates.ts`):**
  ```typescript
  /**
   * Email notification templates
   */

  interface ContactSubmission {
    name: string;
    email: string;
    subject?: string;
    message: string;
    createdAt: Date;
  }

  export function contactNotificationHtml(submission: ContactSubmission): string {
    return `
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <style>
          body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: #f8f9fa; padding: 20px; border-radius: 8px 8px 0 0; }
          .content { background: #fff; padding: 20px; border: 1px solid #e9ecef; border-top: none; }
          .footer { background: #f8f9fa; padding: 15px 20px; border-radius: 0 0 8px 8px; font-size: 12px; color: #6c757d; }
          .field { margin-bottom: 15px; }
          .label { font-weight: 600; color: #495057; }
          .message-box { background: #f8f9fa; padding: 15px; border-radius: 4px; white-space: pre-wrap; }
          .btn { display: inline-block; padding: 10px 20px; background: #007bff; color: #fff; text-decoration: none; border-radius: 4px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h2 style="margin: 0;">📬 New Contact Form Submission</h2>
          </div>
          <div class="content">
            <div class="field">
              <span class="label">From:</span><br>
              ${escapeHtml(submission.name)} &lt;${escapeHtml(submission.email)}&gt;
            </div>
            <div class="field">
              <span class="label">Subject:</span><br>
              ${escapeHtml(submission.subject || 'No Subject')}
            </div>
            <div class="field">
              <span class="label">Message:</span>
              <div class="message-box">${escapeHtml(submission.message)}</div>
            </div>
            <div class="field">
              <span class="label">Received:</span><br>
              ${submission.createdAt.toLocaleString('en-US', {
                dateStyle: 'full',
                timeStyle: 'short'
              })}
            </div>
            <p style="margin-top: 20px;">
              <a href="mailto:${escapeHtml(submission.email)}?subject=Re: ${encodeURIComponent(submission.subject || 'Your message')}" class="btn">
                Reply to ${escapeHtml(submission.name)}
              </a>
            </p>
          </div>
          <div class="footer">
            This email was sent from the contact form at danieltarazona.com
          </div>
        </div>
      </body>
      </html>
    `;
  }

  export function contactNotificationText(submission: ContactSubmission): string {
    return `
  New Contact Form Submission
  ===========================

  From: ${submission.name} <${submission.email}>
  Subject: ${submission.subject || 'No Subject'}
  Received: ${submission.createdAt.toLocaleString()}

  Message:
  ---------
  ${submission.message}

  ---
  Reply to this email to respond to ${submission.name}
    `.trim();
  }

  function escapeHtml(text: string): string {
    return text
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
  ```

#### Task 4.3.9: Testing the Contact Form

- [ ] **Task 4.3.9**: Create tests and verify contact form functionality

  **Test checklist:**
  ```markdown
  ## Contact Form Testing Checklist

  ### Client-side Validation
  - [ ] Empty name shows error
  - [ ] Name < 2 characters shows error
  - [ ] Empty email shows error
  - [ ] Invalid email format shows error
  - [ ] Empty message shows error
  - [ ] Message < 10 characters shows error
  - [ ] Subject > 200 characters shows error
  - [ ] Message > 5000 characters shows error
  - [ ] Character counter updates in real-time
  - [ ] Errors clear when user starts typing

  ### Form Submission
  - [ ] Valid form submits successfully
  - [ ] Loading state shows during submission
  - [ ] Success message displays after submission
  - [ ] Form resets after successful submission
  - [ ] "Send Another Message" button works
  - [ ] Error message shows on API failure
  - [ ] Direct email link shown on error

  ### Accessibility
  - [ ] Form can be navigated with keyboard
  - [ ] Error messages are announced by screen readers
  - [ ] Required fields are marked with aria-required
  - [ ] Invalid fields have aria-invalid="true"
  - [ ] Labels are properly associated with inputs

  ### Spam Protection
  - [ ] Honeypot field is hidden from visual users
  - [ ] Honeypot field is in tab order (tabindex=-1)
  - [ ] Bot submissions with honeypot are silently "accepted"
  - [ ] Rate limiting blocks excessive submissions

  ### Backend/API
  - [ ] Valid submissions are stored in database
  - [ ] IP address is recorded
  - [ ] User agent is recorded
  - [ ] Spam score is calculated
  - [ ] Email notification is sent
  - [ ] Rate limiting returns 429 status
  - [ ] Invalid JSON returns 400 status
  - [ ] Validation errors return 400 status

  ### Email Notifications
  - [ ] Email is received for valid submissions
  - [ ] Email contains correct sender info
  - [ ] Reply-to is set to submitter's email
  - [ ] HTML email renders correctly
  - [ ] Plain text fallback works
  ```

  **Manual test commands:**
  ```bash
  # Test API endpoint locally
  curl -X POST http://localhost:4321/api/contact \
    -H "Content-Type: application/json" \
    -d '{
      "name": "Test User",
      "email": "test@example.com",
      "subject": "Test Subject",
      "message": "This is a test message with enough characters."
    }'

  # Test validation (should fail - message too short)
  curl -X POST http://localhost:4321/api/contact \
    -H "Content-Type: application/json" \
    -d '{
      "name": "Test",
      "email": "test@example.com",
      "message": "Too short"
    }'

  # Test rate limiting (run multiple times)
  for i in {1..10}; do
    curl -X POST http://localhost:4321/api/contact \
      -H "Content-Type: application/json" \
      -d '{"name":"Test","email":"test@example.com","message":"Rate limit test message here"}'
    echo ""
  done

  # Check database
  supabase db query "SELECT id, name, email, created_at, spam_score FROM contact_submissions ORDER BY created_at DESC LIMIT 5;"
  ```

### Phase 3 Task Summary: Contact Form Implementation

| Task ID | Task | Status |
|---------|------|--------|
| 4.3.1 | Create ContactForm React component | [ ] |
| 4.3.2 | Create CSS styles for contact form | [ ] |
| 4.3.3 | Create contact page with form integration | [ ] |
| 4.3.4 | Create shared validation utilities | [ ] |
| 4.3.5 | Configure contact_submissions table enhancements | [ ] |
| 4.3.6 | Create Cloudflare Workers API endpoint | [ ] |
| 4.3.7 | Create Deno Deploy API endpoint (alternative) | [ ] |
| 4.3.8 | Configure email notification service | [ ] |
| 4.3.9 | Test contact form end-to-end | [ ] |

---

## Phase 4: Serverless Functions

This phase covers the setup and deployment of serverless functions using Deno runtime and Deno Deploy for edge computing. Serverless functions handle dynamic operations like form submissions, API proxies, and scheduled tasks without managing infrastructure.

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                           SERVERLESS ARCHITECTURE                                        │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────┐
                              │   Client Apps   │
                              │  (Astro Sites)  │
                              └────────┬────────┘
                                       │ HTTPS Requests
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              EDGE NETWORK                                                │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │                         Cloudflare / Deno Deploy                                   │  │
│  │  • 300+ Edge Locations (Cloudflare) / 35+ Regions (Deno Deploy)                   │  │
│  │  • Sub-millisecond cold starts                                                     │  │
│  │  • Automatic SSL/TLS                                                               │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
│                    │                                           │                         │
│          Deno Deploy                                 Cloudflare Workers                  │
│                    ▼                                           ▼                         │
│     ┌──────────────────────────┐                ┌──────────────────────────┐            │
│     │    Deno Functions        │                │    Workers Functions     │            │
│     │  • TypeScript Native     │                │  • JavaScript/TypeScript │            │
│     │  • Web Standard APIs     │                │  • V8 Isolates           │            │
│     │  • Deno KV Storage       │                │  • KV, D1, R2 Bindings   │            │
│     └──────────────────────────┘                └──────────────────────────┘            │
└─────────────────────────────────────────────────────────────────────────────────────────┘
                    │                                           │
                    └───────────────┬───────────────────────────┘
                                    │
                                    ▼
                    ┌───────────────────────────────┐
                    │      Backend Services         │
                    │  • Supabase PostgreSQL        │
                    │  • Medusa API                 │
                    │  • Email Services (Resend)    │
                    │  • External APIs              │
                    └───────────────────────────────┘
```

### Why Serverless Functions?

| Use Case | Benefit | Example |
|----------|---------|---------|
| **Contact Form Processing** | No server to manage, scales automatically | `/api/contact` endpoint |
| **API Proxies** | Hide API keys, add CORS headers | Proxying Medusa API |
| **Image Processing** | On-demand transformations | Thumbnail generation |
| **Scheduled Tasks** | Run cron jobs without servers | Daily analytics sync |
| **Authentication** | Token validation at the edge | JWT verification |
| **Rate Limiting** | Protect backend from abuse | Request throttling |

### Deno vs Cloudflare Workers Comparison

| Feature | Deno Deploy | Cloudflare Workers |
|---------|-------------|-------------------|
| **Runtime** | Deno (V8 + Rust) | V8 Isolates |
| **Language** | TypeScript native | TypeScript (transpiled) |
| **Cold Start** | ~10-50ms | ~0-5ms |
| **Max Execution** | 50ms (free), 5min (paid) | 50ms (free), 30s (paid) |
| **Storage** | Deno KV (built-in) | KV, D1, R2, Durable Objects |
| **Free Tier** | 100K req/day, 1GB bandwidth | 100K req/day |
| **Web APIs** | Full compatibility | Most APIs |
| **Deploy Method** | Git integration or CLI | Wrangler CLI |
| **Best For** | TypeScript projects, simpler setup | Complex workflows, Cloudflare ecosystem |

**Recommendation**: Use **Deno Deploy** for simpler serverless functions (contact form, proxies) due to native TypeScript support and simpler deployment. Use **Cloudflare Workers** when you need deeper integration with Cloudflare services (KV, D1, R2).

---

### Task 5.1: Deno Runtime Setup and Deployment

This section covers installing Deno, setting up a project structure for serverless functions, configuring Deno Deploy, and implementing common serverless patterns.

#### Task 5.1.1: Deno Installation

- [ ] **Task 5.1.1**: Install Deno runtime on development machine

  **Installation Methods:**

  ```bash
  # macOS / Linux (Recommended)
  curl -fsSL https://deno.land/install.sh | sh

  # macOS via Homebrew
  brew install deno

  # Windows via PowerShell
  irm https://deno.land/install.ps1 | iex

  # Windows via Chocolatey
  choco install deno

  # Windows via Scoop
  scoop install deno

  # Using Cargo (Rust)
  cargo install deno --locked
  ```

  **Post-Installation Setup:**

  ```bash
  # Add Deno to PATH (if using curl installer)
  # Add to ~/.bashrc, ~/.zshrc, or ~/.profile
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"

  # Verify installation
  deno --version
  # deno 2.x.x (release, x86_64-apple-darwin)
  # v8 12.x.x
  # typescript 5.x.x

  # Check available commands
  deno help
  ```

  **IDE Setup (VS Code):**

  ```bash
  # Install Deno extension
  code --install-extension denoland.vscode-deno

  # Enable Deno for workspace (create .vscode/settings.json)
  {
    "deno.enable": true,
    "deno.lint": true,
    "deno.unstable": ["kv"],
    "editor.defaultFormatter": "denoland.vscode-deno",
    "[typescript]": {
      "editor.defaultFormatter": "denoland.vscode-deno"
    },
    "[typescriptreact]": {
      "editor.defaultFormatter": "denoland.vscode-deno"
    }
  }
  ```

  **Deno CLI Reference:**

  | Command | Purpose | Example |
  |---------|---------|---------|
  | `deno run` | Execute a script | `deno run --allow-net server.ts` |
  | `deno task` | Run defined tasks | `deno task dev` |
  | `deno test` | Run tests | `deno test --allow-read` |
  | `deno fmt` | Format code | `deno fmt src/` |
  | `deno lint` | Lint code | `deno lint src/` |
  | `deno check` | Type check | `deno check main.ts` |
  | `deno compile` | Create executable | `deno compile --output app main.ts` |
  | `deno bench` | Run benchmarks | `deno bench bench.ts` |
  | `deno info` | Show dependencies | `deno info main.ts` |
  | `deno upgrade` | Update Deno | `deno upgrade` |

#### Task 5.1.2: Project Structure for Serverless Functions

- [ ] **Task 5.1.2**: Create organized project structure for Deno serverless functions

  **Recommended Project Structure:**

  ```
  deno-functions/
  ├── deno.json              # Deno configuration
  ├── deno.lock              # Dependency lock file
  ├── import_map.json        # Import aliases (optional)
  ├── .env                   # Environment variables (local only)
  ├── .env.example           # Environment template
  ├── .gitignore
  ├── README.md
  │
  ├── src/
  │   ├── main.ts            # Entry point / router
  │   │
  │   ├── routes/            # API route handlers
  │   │   ├── contact.ts     # POST /api/contact
  │   │   ├── health.ts      # GET /health
  │   │   └── proxy/
  │   │       └── medusa.ts  # Medusa API proxy
  │   │
  │   ├── middleware/        # Request/response middleware
  │   │   ├── cors.ts        # CORS headers
  │   │   ├── ratelimit.ts   # Rate limiting
  │   │   ├── auth.ts        # Authentication
  │   │   └── logger.ts      # Request logging
  │   │
  │   ├── services/          # External service integrations
  │   │   ├── supabase.ts    # Supabase client
  │   │   ├── resend.ts      # Email service
  │   │   └── medusa.ts      # Medusa API client
  │   │
  │   ├── utils/             # Utility functions
  │   │   ├── validation.ts  # Input validation
  │   │   ├── response.ts    # Response helpers
  │   │   └── env.ts         # Environment helpers
  │   │
  │   └── types/             # TypeScript types
  │       ├── api.ts         # API request/response types
  │       └── models.ts      # Data models
  │
  └── tests/                 # Test files
      ├── routes/
      │   └── contact_test.ts
      └── utils/
          └── validation_test.ts
  ```

  **Create Project:**

  ```bash
  # Create directory structure
  mkdir -p deno-functions/src/{routes/proxy,middleware,services,utils,types}
  mkdir -p deno-functions/tests/{routes,utils}

  # Initialize with basic files
  cd deno-functions
  touch deno.json import_map.json .env.example README.md
  touch src/main.ts
  ```

  **deno.json (Configuration):**

  ```json
  {
    "name": "danieltarazona-functions",
    "version": "1.0.0",
    "exports": "./src/main.ts",

    "tasks": {
      "dev": "deno run --watch --allow-net --allow-env --allow-read src/main.ts",
      "start": "deno run --allow-net --allow-env --allow-read src/main.ts",
      "test": "deno test --allow-net --allow-env --allow-read",
      "test:coverage": "deno test --allow-net --allow-env --allow-read --coverage=coverage",
      "lint": "deno lint",
      "fmt": "deno fmt",
      "check": "deno check src/main.ts",
      "deploy": "deployctl deploy --project=danieltarazona-api src/main.ts"
    },

    "imports": {
      "@/": "./src/",
      "@std/": "https://deno.land/std@0.220.0/",
      "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2.39.0",
      "hono": "https://deno.land/x/hono@v4.0.0/mod.ts",
      "hono/": "https://deno.land/x/hono@v4.0.0/",
      "zod": "https://deno.land/x/zod@v3.22.4/mod.ts"
    },

    "compilerOptions": {
      "strict": true,
      "lib": ["deno.window", "deno.unstable"]
    },

    "lint": {
      "include": ["src/", "tests/"],
      "rules": {
        "tags": ["recommended"],
        "include": ["ban-untagged-todo", "no-unused-vars"],
        "exclude": ["no-explicit-any"]
      }
    },

    "fmt": {
      "useTabs": false,
      "lineWidth": 100,
      "indentWidth": 2,
      "singleQuote": true,
      "proseWrap": "preserve"
    },

    "test": {
      "include": ["tests/"]
    },

    "unstable": ["kv"]
  }
  ```

  **.env.example:**

  ```bash
  # Supabase Configuration
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_ANON_KEY=your-anon-key
  SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

  # Email Service (Resend)
  RESEND_API_KEY=re_xxxxxxxxxxxxx
  NOTIFICATION_EMAIL=admin@danieltarazona.com
  FROM_EMAIL=noreply@danieltarazona.com

  # Medusa Configuration
  MEDUSA_BACKEND_URL=https://api.store.danieltarazona.com
  MEDUSA_PUBLISHABLE_KEY=pk_xxxxxxxxxxxxx

  # Rate Limiting
  RATE_LIMIT_MAX=10
  RATE_LIMIT_WINDOW_MS=60000

  # Environment
  DENO_ENV=development
  ALLOWED_ORIGINS=http://localhost:4321,https://danieltarazona.com
  ```

#### Task 5.1.3: Main Entry Point and Router

- [ ] **Task 5.1.3**: Create main entry point with routing using Hono framework

  **src/main.ts:**

  ```typescript
  /**
   * Main entry point for Deno serverless functions
   * Uses Hono framework for routing and middleware
   */
  import { Hono } from 'hono';
  import { cors } from 'hono/cors';
  import { logger } from 'hono/logger';
  import { secureHeaders } from 'hono/secure-headers';
  import { timing } from 'hono/timing';

  // Route handlers
  import { contactRouter } from '@/routes/contact.ts';
  import { healthRouter } from '@/routes/health.ts';
  import { medusaProxyRouter } from '@/routes/proxy/medusa.ts';

  // Middleware
  import { rateLimiter } from '@/middleware/ratelimit.ts';

  // Types
  type Bindings = {
    SUPABASE_URL: string;
    SUPABASE_SERVICE_ROLE_KEY: string;
    RESEND_API_KEY: string;
    NOTIFICATION_EMAIL: string;
    ALLOWED_ORIGINS: string;
  };

  // Initialize app
  const app = new Hono<{ Bindings: Bindings }>();

  // Global middleware
  app.use('*', timing());
  app.use('*', logger());
  app.use('*', secureHeaders());

  // CORS configuration
  app.use('*', cors({
    origin: (origin, c) => {
      const allowedOrigins = (Deno.env.get('ALLOWED_ORIGINS') || '').split(',');
      if (allowedOrigins.includes(origin) || !origin) {
        return origin;
      }
      return allowedOrigins[0]; // Return first allowed origin as fallback
    },
    allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    exposeHeaders: ['X-Request-Id', 'X-Response-Time'],
    maxAge: 86400,
    credentials: true,
  }));

  // Rate limiting (applied to specific routes)
  app.use('/api/*', rateLimiter({
    max: parseInt(Deno.env.get('RATE_LIMIT_MAX') || '100'),
    windowMs: parseInt(Deno.env.get('RATE_LIMIT_WINDOW_MS') || '60000'),
  }));

  // Health check (no rate limiting)
  app.route('/health', healthRouter);

  // API routes
  app.route('/api/contact', contactRouter);
  app.route('/api/store', medusaProxyRouter);

  // Root route
  app.get('/', (c) => {
    return c.json({
      name: 'Daniel Tarazona API',
      version: '1.0.0',
      endpoints: {
        health: '/health',
        contact: '/api/contact',
        store: '/api/store/*',
      },
      documentation: 'https://docs.danieltarazona.com/api',
    });
  });

  // 404 handler
  app.notFound((c) => {
    return c.json({
      error: 'Not Found',
      message: `Route ${c.req.method} ${c.req.path} not found`,
      status: 404,
    }, 404);
  });

  // Error handler
  app.onError((err, c) => {
    console.error(`[ERROR] ${err.message}`, err.stack);

    return c.json({
      error: 'Internal Server Error',
      message: Deno.env.get('DENO_ENV') === 'development'
        ? err.message
        : 'An unexpected error occurred',
      status: 500,
    }, 500);
  });

  // Start server (local development) or export for Deno Deploy
  const port = parseInt(Deno.env.get('PORT') || '8000');

  if (Deno.env.get('DENO_ENV') !== 'production') {
    console.log(`🦕 Server starting on http://localhost:${port}`);
  }

  Deno.serve({ port }, app.fetch);
  ```

  **src/routes/health.ts:**

  ```typescript
  /**
   * Health check endpoint for monitoring
   */
  import { Hono } from 'hono';

  export const healthRouter = new Hono();

  healthRouter.get('/', async (c) => {
    const checks = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: performance.now(),
      checks: {} as Record<string, { status: string; latency?: number }>,
    };

    // Check Deno KV availability
    try {
      const start = performance.now();
      const kv = await Deno.openKv();
      await kv.get(['health', 'check']);
      checks.checks.kv = {
        status: 'connected',
        latency: Math.round(performance.now() - start),
      };
    } catch {
      checks.checks.kv = { status: 'unavailable' };
    }

    // Check Supabase connectivity (optional)
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    if (supabaseUrl) {
      try {
        const start = performance.now();
        const response = await fetch(`${supabaseUrl}/rest/v1/`, {
          method: 'HEAD',
          headers: {
            'apikey': Deno.env.get('SUPABASE_ANON_KEY') || '',
          },
        });
        checks.checks.supabase = {
          status: response.ok ? 'connected' : 'error',
          latency: Math.round(performance.now() - start),
        };
      } catch {
        checks.checks.supabase = { status: 'unreachable' };
      }
    }

    const allHealthy = Object.values(checks.checks).every(
      (check) => check.status !== 'unavailable' && check.status !== 'error'
    );

    return c.json(checks, allHealthy ? 200 : 503);
  });

  // Readiness probe (for Kubernetes/orchestration)
  healthRouter.get('/ready', (c) => {
    return c.json({ ready: true }, 200);
  });

  // Liveness probe
  healthRouter.get('/live', (c) => {
    return c.json({ alive: true }, 200);
  });
  ```

#### Task 5.1.4: Rate Limiting Middleware

- [ ] **Task 5.1.4**: Implement rate limiting using Deno KV

  **src/middleware/ratelimit.ts:**

  ```typescript
  /**
   * Rate limiting middleware using Deno KV
   */
  import { Context, Next } from 'hono';

  interface RateLimitOptions {
    max: number;           // Maximum requests per window
    windowMs: number;      // Time window in milliseconds
    keyPrefix?: string;    // Key prefix for different endpoints
    keyGenerator?: (c: Context) => string;  // Custom key generation
    skip?: (c: Context) => boolean;         // Skip rate limiting
    handler?: (c: Context) => Response;     // Custom rate limit response
  }

  interface RateLimitEntry {
    count: number;
    resetAt: number;
  }

  export function rateLimiter(options: RateLimitOptions) {
    const {
      max = 100,
      windowMs = 60000,
      keyPrefix = 'ratelimit',
      keyGenerator = defaultKeyGenerator,
      skip,
      handler = defaultHandler,
    } = options;

    return async (c: Context, next: Next) => {
      // Check if should skip rate limiting
      if (skip && skip(c)) {
        return next();
      }

      const key = keyGenerator(c);
      const now = Date.now();

      try {
        const kv = await Deno.openKv();
        const kvKey = [keyPrefix, key];

        // Get current rate limit entry
        const result = await kv.get<RateLimitEntry>(kvKey);
        let entry = result.value;

        if (!entry || entry.resetAt < now) {
          // Create new window
          entry = {
            count: 1,
            resetAt: now + windowMs,
          };
        } else {
          // Increment count
          entry.count += 1;
        }

        // Check if rate limited
        if (entry.count > max) {
          const retryAfter = Math.ceil((entry.resetAt - now) / 1000);

          c.header('X-RateLimit-Limit', max.toString());
          c.header('X-RateLimit-Remaining', '0');
          c.header('X-RateLimit-Reset', entry.resetAt.toString());
          c.header('Retry-After', retryAfter.toString());

          return handler(c);
        }

        // Update entry with atomic operation
        await kv.atomic()
          .set(kvKey, entry, { expireIn: windowMs })
          .commit();

        // Set rate limit headers
        c.header('X-RateLimit-Limit', max.toString());
        c.header('X-RateLimit-Remaining', (max - entry.count).toString());
        c.header('X-RateLimit-Reset', entry.resetAt.toString());

        return next();
      } catch (error) {
        // On KV error, allow request but log warning
        console.warn('[RateLimit] KV error, allowing request:', error);
        return next();
      }
    };
  }

  function defaultKeyGenerator(c: Context): string {
    // Use IP address as default key
    const forwarded = c.req.header('x-forwarded-for');
    const ip = forwarded?.split(',')[0]?.trim() ||
               c.req.header('cf-connecting-ip') ||
               'unknown';
    return `${c.req.method}:${c.req.path}:${ip}`;
  }

  function defaultHandler(c: Context): Response {
    return c.json({
      error: 'Too Many Requests',
      message: 'Rate limit exceeded. Please try again later.',
      status: 429,
    }, 429);
  }

  // Stricter rate limiter for sensitive endpoints (like contact form)
  export const strictRateLimiter = rateLimiter({
    max: 5,
    windowMs: 60000, // 5 requests per minute
    keyPrefix: 'strict_ratelimit',
  });

  // Lenient rate limiter for read operations
  export const lenientRateLimiter = rateLimiter({
    max: 1000,
    windowMs: 60000, // 1000 requests per minute
    keyPrefix: 'lenient_ratelimit',
  });
  ```

#### Task 5.1.5: Contact Form Handler

- [ ] **Task 5.1.5**: Create contact form API endpoint

  **src/routes/contact.ts:**

  ```typescript
  /**
   * Contact form API handler
   */
  import { Hono } from 'hono';
  import { z } from 'zod';
  import { createClient } from '@supabase/supabase-js';
  import { strictRateLimiter } from '@/middleware/ratelimit.ts';

  export const contactRouter = new Hono();

  // Validation schema
  const ContactSchema = z.object({
    name: z.string()
      .min(2, 'Name must be at least 2 characters')
      .max(100, 'Name must be less than 100 characters'),
    email: z.string()
      .email('Invalid email address')
      .max(255, 'Email must be less than 255 characters'),
    subject: z.string()
      .max(200, 'Subject must be less than 200 characters')
      .optional(),
    message: z.string()
      .min(10, 'Message must be at least 10 characters')
      .max(5000, 'Message must be less than 5000 characters'),
    honeypot: z.string()
      .max(0, 'Bot detected')
      .optional(),
  });

  type ContactInput = z.infer<typeof ContactSchema>;

  // Apply strict rate limiting to contact endpoint
  contactRouter.use('*', strictRateLimiter);

  contactRouter.post('/', async (c) => {
    const requestId = crypto.randomUUID();
    c.header('X-Request-Id', requestId);

    try {
      // Parse and validate request body
      const body = await c.req.json();
      const validationResult = ContactSchema.safeParse(body);

      if (!validationResult.success) {
        return c.json({
          success: false,
          error: 'Validation failed',
          details: validationResult.error.flatten().fieldErrors,
          requestId,
        }, 400);
      }

      const data = validationResult.data;

      // Check honeypot (spam protection)
      if (data.honeypot && data.honeypot.length > 0) {
        // Silently "accept" but don't process
        console.log(`[SPAM] Honeypot triggered for request ${requestId}`);
        return c.json({
          success: true,
          message: 'Thank you for your message!',
          requestId,
        }, 200);
      }

      // Get request metadata
      const ip = c.req.header('cf-connecting-ip') ||
                 c.req.header('x-forwarded-for')?.split(',')[0]?.trim() ||
                 'unknown';
      const userAgent = c.req.header('user-agent') || 'unknown';

      // Calculate spam score
      const spamScore = calculateSpamScore(data, ip, userAgent);

      // Initialize Supabase client
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL')!,
        Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
      );

      // Insert into database
      const { data: submission, error: dbError } = await supabase
        .from('contact_submissions')
        .insert({
          name: data.name,
          email: data.email,
          subject: data.subject || null,
          message: data.message,
          ip_address: ip,
          user_agent: userAgent,
          spam_score: spamScore,
          status: spamScore > 0.7 ? 'spam' : 'pending',
        })
        .select('id, created_at')
        .single();

      if (dbError) {
        console.error(`[ERROR] Database insert failed: ${dbError.message}`, dbError);
        throw new Error('Failed to save submission');
      }

      // Send email notification (non-blocking)
      sendEmailNotification(data, submission.id).catch((err) => {
        console.error(`[ERROR] Email notification failed: ${err.message}`);
      });

      return c.json({
        success: true,
        message: 'Thank you for your message! We\'ll get back to you soon.',
        requestId,
        submissionId: submission.id,
      }, 201);

    } catch (error) {
      console.error(`[ERROR] Contact form error:`, error);

      return c.json({
        success: false,
        error: 'Failed to process your message',
        message: 'Please try again or email us directly at hello@danieltarazona.com',
        requestId,
      }, 500);
    }
  });

  // Health check for contact endpoint
  contactRouter.get('/', (c) => {
    return c.json({
      endpoint: '/api/contact',
      method: 'POST',
      status: 'operational',
      rateLimit: '5 requests per minute',
    });
  });

  /**
   * Calculate spam score based on various factors
   */
  function calculateSpamScore(
    data: ContactInput,
    ip: string,
    userAgent: string
  ): number {
    let score = 0;

    // Check for common spam patterns in message
    const spamPatterns = [
      /\b(viagra|cialis|casino|lottery|winner|prize|free money)\b/i,
      /\b(click here|buy now|act now|limited time)\b/i,
      /https?:\/\/[^\s]+/g, // URLs in message
      /\b\d{10,}\b/, // Long number sequences
    ];

    for (const pattern of spamPatterns) {
      if (pattern.test(data.message)) {
        score += 0.2;
      }
    }

    // Check for suspicious email domains
    const suspiciousDomains = ['tempmail', 'guerrilla', '10minute', 'throwaway'];
    const emailDomain = data.email.split('@')[1]?.toLowerCase() || '';
    if (suspiciousDomains.some(d => emailDomain.includes(d))) {
      score += 0.3;
    }

    // Check for very short or generic messages
    if (data.message.length < 20) {
      score += 0.1;
    }

    // Check user agent
    if (!userAgent || userAgent === 'unknown' || userAgent.length < 10) {
      score += 0.2;
    }

    // Cap score at 1.0
    return Math.min(score, 1.0);
  }

  /**
   * Send email notification for new contact submission
   */
  async function sendEmailNotification(
    data: ContactInput,
    submissionId: string
  ): Promise<void> {
    const resendKey = Deno.env.get('RESEND_API_KEY');
    const notificationEmail = Deno.env.get('NOTIFICATION_EMAIL');

    if (!resendKey || !notificationEmail) {
      console.warn('[WARN] Email notification not configured');
      return;
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${resendKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: Deno.env.get('FROM_EMAIL') || 'noreply@danieltarazona.com',
        to: notificationEmail,
        reply_to: data.email,
        subject: `New Contact: ${data.subject || 'Message from ' + data.name}`,
        html: `
          <h2>New Contact Form Submission</h2>
          <p><strong>From:</strong> ${escapeHtml(data.name)} &lt;${escapeHtml(data.email)}&gt;</p>
          <p><strong>Subject:</strong> ${escapeHtml(data.subject || 'No subject')}</p>
          <p><strong>Submission ID:</strong> ${submissionId}</p>
          <hr>
          <h3>Message:</h3>
          <p style="white-space: pre-wrap;">${escapeHtml(data.message)}</p>
        `,
        text: `
New Contact Form Submission
From: ${data.name} <${data.email}>
Subject: ${data.subject || 'No subject'}
Submission ID: ${submissionId}

Message:
${data.message}
        `.trim(),
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Resend API error: ${error}`);
    }
  }

  function escapeHtml(text: string): string {
    return text
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }
  ```

#### Task 5.1.6: Deno Deploy Configuration

- [ ] **Task 5.1.6**: Configure and deploy to Deno Deploy

  **Deno Deploy Setup:**

  ```bash
  # Install deployctl CLI
  deno install -Arf jsr:@deno/deployctl

  # Or use npx (alternative)
  # npx deployctl deploy

  # Verify installation
  deployctl --version
  ```

  **Deployment Methods:**

  **Method 1: GitHub Integration (Recommended)**

  1. Go to [dash.deno.com](https://dash.deno.com)
  2. Click "New Project"
  3. Select "Deploy from GitHub"
  4. Choose your repository
  5. Configure:
     - **Entry point**: `src/main.ts`
     - **Build step**: (none needed for Deno)
     - **Install step**: (none needed)
  6. Set environment variables in project settings
  7. Deploy!

  **Method 2: CLI Deployment**

  ```bash
  # Login to Deno Deploy
  deployctl login

  # Deploy project (creates new project if not exists)
  deployctl deploy \
    --project=danieltarazona-api \
    --prod \
    src/main.ts

  # Deploy with environment variables
  deployctl deploy \
    --project=danieltarazona-api \
    --prod \
    --env=SUPABASE_URL=https://xxx.supabase.co \
    --env=SUPABASE_SERVICE_ROLE_KEY=xxx \
    src/main.ts
  ```

  **Method 3: GitHub Actions**

  ```yaml
  # .github/workflows/deploy-deno.yml
  name: Deploy to Deno Deploy

  on:
    push:
      branches: [main]
      paths:
        - 'deno-functions/**'
    workflow_dispatch:

  jobs:
    deploy:
      runs-on: ubuntu-latest

      permissions:
        id-token: write  # Required for OIDC
        contents: read

      steps:
        - name: Checkout
          uses: actions/checkout@v4

        - name: Setup Deno
          uses: denoland/setup-deno@v1
          with:
            deno-version: v2.x

        - name: Run tests
          working-directory: deno-functions
          run: deno task test

        - name: Type check
          working-directory: deno-functions
          run: deno task check

        - name: Deploy to Deno Deploy
          uses: denoland/deployctl@v1
          with:
            project: danieltarazona-api
            entrypoint: deno-functions/src/main.ts
            root: deno-functions
  ```

  **Environment Variables in Deno Deploy:**

  Set via Dashboard (Settings → Environment Variables):

  ```
  SUPABASE_URL=https://your-project.supabase.co
  SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIs...
  SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIs...
  RESEND_API_KEY=re_xxxxxxxxxxxxx
  NOTIFICATION_EMAIL=admin@danieltarazona.com
  FROM_EMAIL=noreply@danieltarazona.com
  MEDUSA_BACKEND_URL=https://api.store.danieltarazona.com
  MEDUSA_PUBLISHABLE_KEY=pk_xxxxxxxxxxxxx
  RATE_LIMIT_MAX=100
  RATE_LIMIT_WINDOW_MS=60000
  DENO_ENV=production
  ALLOWED_ORIGINS=https://danieltarazona.com,https://store.danieltarazona.com
  ```

  **Custom Domain Setup:**

  ```bash
  # Via Dashboard: Settings → Domains → Add Domain
  # Add: api.danieltarazona.com

  # DNS Configuration (Cloudflare):
  # Type: CNAME
  # Name: api
  # Target: danieltarazona-api.deno.dev
  # Proxy: ON (orange cloud)
  ```

#### Task 5.1.7: Common Serverless Patterns

- [ ] **Task 5.1.7**: Implement common serverless function patterns

  **Pattern 1: API Proxy (Hide API Keys)**

  **src/routes/proxy/medusa.ts:**

  ```typescript
  /**
   * Medusa API Proxy - Hides backend URL and adds CORS
   */
  import { Hono } from 'hono';

  export const medusaProxyRouter = new Hono();

  const MEDUSA_URL = Deno.env.get('MEDUSA_BACKEND_URL') || 'http://localhost:9000';

  // Proxy all store API requests
  medusaProxyRouter.all('/*', async (c) => {
    const path = c.req.path.replace('/api/store', '/store');
    const url = `${MEDUSA_URL}${path}`;

    const headers = new Headers();
    headers.set('Content-Type', 'application/json');

    // Forward publishable key if present
    const pubKey = c.req.header('x-publishable-api-key');
    if (pubKey) {
      headers.set('x-publishable-api-key', pubKey);
    }

    try {
      const response = await fetch(url, {
        method: c.req.method,
        headers,
        body: c.req.method !== 'GET' ? await c.req.text() : undefined,
      });

      const data = await response.json();
      return c.json(data, response.status);
    } catch (error) {
      console.error('[Proxy Error]', error);
      return c.json({ error: 'Proxy error' }, 502);
    }
  });
  ```

  **Pattern 2: Scheduled Tasks (Cron)**

  ```typescript
  /**
   * Scheduled task handler for Deno Deploy
   * Configure in deno.json or deploy dashboard
   */

  // Handler for scheduled invocations
  Deno.cron('daily-analytics-sync', '0 0 * * *', async () => {
    console.log('[CRON] Starting daily analytics sync');

    try {
      // Fetch analytics from various sources
      const [pageviews, orders] = await Promise.all([
        fetchPageviews(),
        fetchOrders(),
      ]);

      // Store aggregated data
      const kv = await Deno.openKv();
      const date = new Date().toISOString().split('T')[0];

      await kv.set(['analytics', date], {
        pageviews,
        orders: orders.length,
        revenue: orders.reduce((sum, o) => sum + o.total, 0),
        syncedAt: new Date().toISOString(),
      });

      console.log(`[CRON] Analytics synced for ${date}`);
    } catch (error) {
      console.error('[CRON] Analytics sync failed:', error);
    }
  });

  async function fetchPageviews(): Promise<number> {
    // Implement Cloudflare Analytics API call
    return 0;
  }

  async function fetchOrders(): Promise<{ total: number }[]> {
    // Implement Medusa orders API call
    return [];
  }
  ```

  **Pattern 3: Webhook Handler**

  ```typescript
  /**
   * Webhook handler for external service events
   */
  import { Hono } from 'hono';
  import { createHmac } from 'node:crypto';

  export const webhookRouter = new Hono();

  // Medusa webhook handler
  webhookRouter.post('/medusa', async (c) => {
    const signature = c.req.header('x-medusa-signature');
    const body = await c.req.text();

    // Verify webhook signature
    const secret = Deno.env.get('MEDUSA_WEBHOOK_SECRET');
    if (secret && signature) {
      const expectedSig = createHmac('sha256', secret)
        .update(body)
        .digest('hex');

      if (signature !== expectedSig) {
        return c.json({ error: 'Invalid signature' }, 401);
      }
    }

    const event = JSON.parse(body);

    switch (event.type) {
      case 'order.placed':
        await handleOrderPlaced(event.data);
        break;
      case 'order.shipped':
        await handleOrderShipped(event.data);
        break;
      case 'product.updated':
        await invalidateProductCache(event.data);
        break;
      default:
        console.log(`[Webhook] Unhandled event: ${event.type}`);
    }

    return c.json({ received: true });
  });

  async function handleOrderPlaced(order: unknown): Promise<void> {
    console.log('[Webhook] Order placed:', order);
    // Send order confirmation email, update analytics, etc.
  }

  async function handleOrderShipped(order: unknown): Promise<void> {
    console.log('[Webhook] Order shipped:', order);
    // Send shipping notification email
  }

  async function invalidateProductCache(product: unknown): Promise<void> {
    console.log('[Webhook] Product updated:', product);
    // Invalidate CDN cache, trigger rebuild, etc.
  }
  ```

  **Pattern 4: Image Processing (On-Demand)**

  ```typescript
  /**
   * On-demand image resizing/optimization
   */
  import { Hono } from 'hono';

  export const imageRouter = new Hono();

  imageRouter.get('/:width/:height/*', async (c) => {
    const width = parseInt(c.req.param('width'));
    const height = parseInt(c.req.param('height'));
    const imagePath = c.req.path.split('/').slice(4).join('/');

    // Validate dimensions
    if (width > 2000 || height > 2000 || width < 1 || height < 1) {
      return c.json({ error: 'Invalid dimensions' }, 400);
    }

    const sourceUrl = `${Deno.env.get('STORAGE_URL')}/${imagePath}`;

    try {
      // Use Cloudflare Image Resizing or similar service
      const resizedUrl = `https://images.danieltarazona.com/cdn-cgi/image/width=${width},height=${height},fit=cover,format=auto/${sourceUrl}`;

      return c.redirect(resizedUrl, 302);
    } catch (error) {
      console.error('[Image] Resize failed:', error);
      return c.json({ error: 'Image processing failed' }, 500);
    }
  });
  ```

#### Task 5.1.8: Testing Deno Functions

- [ ] **Task 5.1.8**: Create tests for serverless functions

  **tests/routes/contact_test.ts:**

  ```typescript
  /**
   * Contact API endpoint tests
   */
  import { assertEquals, assertExists } from '@std/assert';
  import { describe, it, beforeAll, afterAll } from '@std/testing/bdd';

  const BASE_URL = 'http://localhost:8000';

  describe('Contact API', () => {
    describe('POST /api/contact', () => {
      it('should accept valid contact submission', async () => {
        const response = await fetch(`${BASE_URL}/api/contact`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: 'Test User',
            email: 'test@example.com',
            subject: 'Test Subject',
            message: 'This is a test message with enough characters.',
          }),
        });

        assertEquals(response.status, 201);

        const data = await response.json();
        assertEquals(data.success, true);
        assertExists(data.requestId);
        assertExists(data.submissionId);
      });

      it('should reject invalid email', async () => {
        const response = await fetch(`${BASE_URL}/api/contact`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: 'Test User',
            email: 'not-an-email',
            message: 'This is a test message with enough characters.',
          }),
        });

        assertEquals(response.status, 400);

        const data = await response.json();
        assertEquals(data.success, false);
        assertExists(data.details.email);
      });

      it('should reject short message', async () => {
        const response = await fetch(`${BASE_URL}/api/contact`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: 'Test User',
            email: 'test@example.com',
            message: 'Too short',
          }),
        });

        assertEquals(response.status, 400);

        const data = await response.json();
        assertEquals(data.success, false);
        assertExists(data.details.message);
      });

      it('should silently accept honeypot submissions', async () => {
        const response = await fetch(`${BASE_URL}/api/contact`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: 'Bot User',
            email: 'bot@spam.com',
            message: 'This is a spam message with enough characters.',
            honeypot: 'I am a bot',
          }),
        });

        assertEquals(response.status, 200);

        const data = await response.json();
        assertEquals(data.success, true);
      });
    });

    describe('GET /api/contact', () => {
      it('should return endpoint info', async () => {
        const response = await fetch(`${BASE_URL}/api/contact`);

        assertEquals(response.status, 200);

        const data = await response.json();
        assertEquals(data.endpoint, '/api/contact');
        assertEquals(data.method, 'POST');
      });
    });
  });

  describe('Health API', () => {
    it('should return health status', async () => {
      const response = await fetch(`${BASE_URL}/health`);

      assertEquals(response.status, 200);

      const data = await response.json();
      assertEquals(data.status, 'healthy');
      assertExists(data.timestamp);
      assertExists(data.checks);
    });

    it('should return readiness status', async () => {
      const response = await fetch(`${BASE_URL}/health/ready`);

      assertEquals(response.status, 200);

      const data = await response.json();
      assertEquals(data.ready, true);
    });
  });
  ```

  **Run tests:**

  ```bash
  # Start server in one terminal
  deno task dev

  # Run tests in another terminal
  deno task test

  # Run with coverage
  deno task test:coverage

  # View coverage report
  deno coverage coverage/
  ```

### Phase 4 Task Summary: Deno Serverless Functions

| Task ID | Task | Status |
|---------|------|--------|
| 5.1.1 | Install Deno runtime | [ ] |
| 5.1.2 | Create project structure for serverless functions | [ ] |
| 5.1.3 | Create main entry point with Hono router | [ ] |
| 5.1.4 | Implement rate limiting middleware with Deno KV | [ ] |
| 5.1.5 | Create contact form API endpoint | [ ] |
| 5.1.6 | Configure Deno Deploy for production | [ ] |
| 5.1.7 | Implement common serverless patterns | [ ] |
| 5.1.8 | Create tests for serverless functions | [ ] |

### Deno Resources & Documentation

| Resource | URL |
|----------|-----|
| Deno Manual | https://docs.deno.com/runtime/manual |
| Deno Deploy Docs | https://docs.deno.com/deploy/manual |
| Hono Framework | https://hono.dev |
| Deno Standard Library | https://deno.land/std |
| Deno KV | https://docs.deno.com/deploy/kv/manual |
| deployctl CLI | https://docs.deno.com/deploy/manual/deployctl |

---

### Task 5.2: Cloudflare Workers Configuration

This section covers setting up Cloudflare Workers for serverless functions at the edge, including Wrangler CLI setup, project configuration, routing, and integration with the main Astro sites.

#### Why Cloudflare Workers?

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                        CLOUDFLARE WORKERS ARCHITECTURE                                    │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────┐
                              │   Incoming      │
                              │   Request       │
                              └────────┬────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              CLOUDFLARE EDGE (300+ PoPs)                                 │
│                                                                                          │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │                            V8 ISOLATES (Sub-ms Cold Start)                         │  │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐                    │  │
│  │  │ Worker: API     │  │ Worker: Form    │  │ Worker: Proxy   │                    │  │
│  │  │ /api/*          │  │ /contact        │  │ /medusa/*       │                    │  │
│  │  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘                    │  │
│  │           │                    │                    │                             │  │
│  └───────────┼────────────────────┼────────────────────┼─────────────────────────────┘  │
│              │                    │                    │                                 │
│  ┌───────────▼────────────────────▼────────────────────▼─────────────────────────────┐  │
│  │                           BINDINGS                                                 │  │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐       │  │
│  │  │    KV     │  │    D1     │  │    R2     │  │  Durable  │  │   Queues  │       │  │
│  │  │  Storage  │  │  Database │  │  Storage  │  │  Objects  │  │           │       │  │
│  │  └───────────┘  └───────────┘  └───────────┘  └───────────┘  └───────────┘       │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
                              │                    │
                              ▼                    ▼
                    ┌──────────────────┐  ┌──────────────────┐
                    │  Supabase        │  │  Medusa API      │
                    │  PostgreSQL      │  │  (VPS)           │
                    └──────────────────┘  └──────────────────┘
```

#### Cloudflare Workers Features

| Feature | Description | Use Case |
|---------|-------------|----------|
| **KV Storage** | Global key-value store | Session data, cache, config |
| **D1 Database** | SQLite at the edge | Simple relational data |
| **R2 Storage** | S3-compatible object store | Images, files, backups |
| **Durable Objects** | Stateful serverless | Real-time collaboration, WebSockets |
| **Queues** | Message queues | Background jobs, batch processing |
| **Workers AI** | AI inference at the edge | Text generation, embeddings |
| **Email Routing** | Email handling | Contact form email |

#### Task 5.2.1: Wrangler CLI Installation

- [ ] **Task 5.2.1**: Install and configure Wrangler CLI

  **Installation Methods:**

  ```bash
  # Global installation (Recommended)
  npm install -g wrangler

  # Or with pnpm
  pnpm add -g wrangler

  # Or with yarn
  yarn global add wrangler

  # Verify installation
  wrangler --version
  # ⛅️ wrangler 3.x.x
  ```

  **Authentication:**

  ```bash
  # Login to Cloudflare (opens browser)
  wrangler login

  # Verify authentication
  wrangler whoami
  # 👋 You are logged in with an OAuth Token, associated with the email: your@email.com

  # Alternative: API Token authentication
  # Create token at: https://dash.cloudflare.com/profile/api-tokens
  # Required permissions: Workers Scripts:Edit, Account Settings:Read
  export CLOUDFLARE_API_TOKEN="your-api-token"
  ```

  **Wrangler CLI Reference:**

  | Command | Purpose | Example |
  |---------|---------|---------|
  | `wrangler init` | Create new Worker project | `wrangler init my-worker` |
  | `wrangler dev` | Local development server | `wrangler dev` |
  | `wrangler deploy` | Deploy to production | `wrangler deploy` |
  | `wrangler tail` | Live logs from production | `wrangler tail` |
  | `wrangler secret` | Manage secrets | `wrangler secret put API_KEY` |
  | `wrangler kv` | KV namespace management | `wrangler kv:namespace create MY_KV` |
  | `wrangler d1` | D1 database management | `wrangler d1 create my-db` |
  | `wrangler r2` | R2 bucket management | `wrangler r2 bucket create my-bucket` |
  | `wrangler pages` | Pages project management | `wrangler pages deploy ./dist` |
  | `wrangler types` | Generate TypeScript types | `wrangler types` |

#### Task 5.2.2: Worker Project Setup

- [ ] **Task 5.2.2**: Create and configure Cloudflare Workers project structure

  **Initialize Project:**

  ```bash
  # Create new Workers project
  mkdir cloudflare-workers && cd cloudflare-workers

  # Initialize with Wrangler (interactive)
  wrangler init . --from-dash # Use existing worker from dashboard
  # OR
  wrangler init . # Start fresh

  # Select options:
  # - TypeScript: Yes
  # - Git: Yes
  # - Deploy: No (we'll configure first)
  ```

  **Recommended Project Structure:**

  ```
  cloudflare-workers/
  ├── wrangler.toml               # Wrangler configuration
  ├── package.json
  ├── tsconfig.json
  ├── .dev.vars                   # Local development secrets
  ├── .gitignore
  │
  ├── src/
  │   ├── index.ts                # Main entry point
  │   │
  │   ├── routes/                 # Route handlers
  │   │   ├── api.ts              # API routes
  │   │   ├── contact.ts          # Contact form handler
  │   │   ├── health.ts           # Health check
  │   │   └── proxy.ts            # Medusa API proxy
  │   │
  │   ├── middleware/             # Middleware functions
  │   │   ├── cors.ts             # CORS handling
  │   │   ├── rateLimit.ts        # Rate limiting
  │   │   └── auth.ts             # Authentication
  │   │
  │   ├── services/               # External integrations
  │   │   ├── supabase.ts         # Supabase client
  │   │   └── email.ts            # Email sending
  │   │
  │   ├── lib/                    # Shared utilities
  │   │   ├── response.ts         # Response helpers
  │   │   └── validation.ts       # Input validation
  │   │
  │   └── types/                  # TypeScript definitions
  │       └── env.d.ts            # Environment types
  │
  └── test/                       # Test files
      └── handler.test.ts
  ```

  **wrangler.toml Configuration:**

  ```toml
  # wrangler.toml - Main configuration file
  name = "danieltarazona-api"
  main = "src/index.ts"
  compatibility_date = "2024-01-01"
  compatibility_flags = ["nodejs_compat"]

  # Account Configuration
  account_id = "your-account-id"  # Found in Cloudflare dashboard

  # Worker Settings
  workers_dev = true              # Enable workers.dev subdomain
  minify = true                   # Minify production bundle
  node_compat = true              # Enable Node.js compatibility

  # Custom Routes (production)
  routes = [
    { pattern = "api.danieltarazona.com/*", zone_name = "danieltarazona.com" },
    { pattern = "danieltarazona.com/api/*", zone_name = "danieltarazona.com" }
  ]

  # Environment Variables (non-secret)
  [vars]
  ENVIRONMENT = "production"
  ALLOWED_ORIGINS = "https://danieltarazona.com,https://store.danieltarazona.com"
  MEDUSA_BACKEND_URL = "https://api.danieltarazona.com/medusa"

  # KV Namespace Bindings
  [[kv_namespaces]]
  binding = "RATE_LIMIT_KV"
  id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  preview_id = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

  [[kv_namespaces]]
  binding = "CACHE_KV"
  id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  preview_id = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

  # D1 Database Binding (optional)
  [[d1_databases]]
  binding = "DB"
  database_name = "danieltarazona-db"
  database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

  # R2 Bucket Binding (optional)
  [[r2_buckets]]
  binding = "ASSETS_BUCKET"
  bucket_name = "danieltarazona-assets"

  # Development Environment
  [env.development]
  name = "danieltarazona-api-dev"
  vars = { ENVIRONMENT = "development" }

  # Staging Environment
  [env.staging]
  name = "danieltarazona-api-staging"
  routes = [
    { pattern = "api-staging.danieltarazona.com/*", zone_name = "danieltarazona.com" }
  ]
  vars = { ENVIRONMENT = "staging" }
  ```

  **TypeScript Configuration (tsconfig.json):**

  ```json
  {
    "compilerOptions": {
      "target": "ES2022",
      "module": "ESNext",
      "moduleResolution": "bundler",
      "lib": ["ES2022"],
      "types": ["@cloudflare/workers-types"],
      "strict": true,
      "skipLibCheck": true,
      "noEmit": true,
      "isolatedModules": true,
      "resolveJsonModule": true,
      "allowSyntheticDefaultImports": true,
      "esModuleInterop": true,
      "forceConsistentCasingInFileNames": true
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules", "test"]
  }
  ```

  **package.json:**

  ```json
  {
    "name": "danieltarazona-workers",
    "version": "1.0.0",
    "private": true,
    "scripts": {
      "dev": "wrangler dev",
      "deploy": "wrangler deploy",
      "deploy:staging": "wrangler deploy --env staging",
      "deploy:production": "wrangler deploy --env production",
      "tail": "wrangler tail",
      "types": "wrangler types",
      "test": "vitest",
      "test:coverage": "vitest --coverage",
      "lint": "eslint src/",
      "format": "prettier --write src/"
    },
    "devDependencies": {
      "@cloudflare/workers-types": "^4.20240512.0",
      "typescript": "^5.4.5",
      "wrangler": "^3.57.0",
      "vitest": "^1.6.0",
      "@types/node": "^20.12.12",
      "eslint": "^9.3.0",
      "prettier": "^3.2.5"
    },
    "dependencies": {
      "hono": "^4.3.7",
      "zod": "^3.23.8"
    }
  }
  ```

#### Task 5.2.3: Main Worker Entry Point with Hono

- [ ] **Task 5.2.3**: Create main Worker entry point with Hono router framework

  **src/types/env.d.ts (Environment Bindings):**

  ```typescript
  // src/types/env.d.ts
  export interface Env {
    // Environment Variables
    ENVIRONMENT: string;
    ALLOWED_ORIGINS: string;
    MEDUSA_BACKEND_URL: string;

    // Secrets (set via wrangler secret put)
    SUPABASE_URL: string;
    SUPABASE_ANON_KEY: string;
    RESEND_API_KEY: string;

    // KV Namespaces
    RATE_LIMIT_KV: KVNamespace;
    CACHE_KV: KVNamespace;

    // D1 Database (optional)
    DB?: D1Database;

    // R2 Bucket (optional)
    ASSETS_BUCKET?: R2Bucket;
  }

  export type Variables = {
    requestId: string;
    clientIp: string;
    startTime: number;
  };
  ```

  **src/index.ts (Main Entry Point):**

  ```typescript
  // src/index.ts
  import { Hono } from 'hono';
  import { cors } from 'hono/cors';
  import { logger } from 'hono/logger';
  import { secureHeaders } from 'hono/secure-headers';
  import { timing } from 'hono/timing';
  import type { Env, Variables } from './types/env';
  import { contactRoutes } from './routes/contact';
  import { healthRoutes } from './routes/health';
  import { proxyRoutes } from './routes/proxy';
  import { apiRoutes } from './routes/api';
  import { rateLimitMiddleware } from './middleware/rateLimit';

  // Create Hono app with typed bindings
  const app = new Hono<{ Bindings: Env; Variables: Variables }>();

  // Global Middleware
  app.use('*', timing());
  app.use('*', logger());
  app.use('*', secureHeaders());

  // CORS Configuration
  app.use('*', cors({
    origin: (origin, c) => {
      const allowedOrigins = c.env.ALLOWED_ORIGINS.split(',');
      if (allowedOrigins.includes(origin) || c.env.ENVIRONMENT === 'development') {
        return origin;
      }
      return null;
    },
    allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    credentials: true,
    maxAge: 86400,
  }));

  // Request Context Middleware
  app.use('*', async (c, next) => {
    c.set('requestId', crypto.randomUUID());
    c.set('clientIp', c.req.header('CF-Connecting-IP') || 'unknown');
    c.set('startTime', Date.now());
    await next();
  });

  // Rate Limiting (applies to API routes)
  app.use('/api/*', rateLimitMiddleware);
  app.use('/contact', rateLimitMiddleware);

  // Mount Routes
  app.route('/health', healthRoutes);
  app.route('/api', apiRoutes);
  app.route('/contact', contactRoutes);
  app.route('/medusa', proxyRoutes);

  // Root endpoint
  app.get('/', (c) => {
    return c.json({
      name: 'Daniel Tarazona API',
      version: '1.0.0',
      environment: c.env.ENVIRONMENT,
      documentation: 'https://danieltarazona.com/api/docs',
    });
  });

  // 404 Handler
  app.notFound((c) => {
    return c.json(
      {
        error: 'Not Found',
        message: `Route ${c.req.method} ${c.req.path} not found`,
        requestId: c.get('requestId'),
      },
      404
    );
  });

  // Error Handler
  app.onError((err, c) => {
    console.error(`[${c.get('requestId')}] Error:`, err);

    const status = err instanceof HTTPException ? err.status : 500;
    const message = c.env.ENVIRONMENT === 'production'
      ? 'Internal Server Error'
      : err.message;

    return c.json(
      {
        error: 'Internal Server Error',
        message,
        requestId: c.get('requestId'),
      },
      status
    );
  });

  export default app;
  ```

#### Task 5.2.4: Route Configuration and Handlers

- [ ] **Task 5.2.4**: Create route handlers for API endpoints

  **src/routes/health.ts:**

  ```typescript
  // src/routes/health.ts
  import { Hono } from 'hono';
  import type { Env, Variables } from '../types/env';

  export const healthRoutes = new Hono<{ Bindings: Env; Variables: Variables }>();

  // Basic health check
  healthRoutes.get('/', (c) => {
    return c.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      environment: c.env.ENVIRONMENT,
      requestId: c.get('requestId'),
    });
  });

  // Readiness check (verifies dependencies)
  healthRoutes.get('/ready', async (c) => {
    const checks: Record<string, boolean> = {};

    // Check KV availability
    try {
      await c.env.RATE_LIMIT_KV.get('health-check');
      checks.kv = true;
    } catch {
      checks.kv = false;
    }

    // Check D1 availability (if configured)
    if (c.env.DB) {
      try {
        await c.env.DB.prepare('SELECT 1').first();
        checks.d1 = true;
      } catch {
        checks.d1 = false;
      }
    }

    const allHealthy = Object.values(checks).every(Boolean);

    return c.json(
      {
        ready: allHealthy,
        checks,
        timestamp: new Date().toISOString(),
      },
      allHealthy ? 200 : 503
    );
  });

  // Liveness check
  healthRoutes.get('/live', (c) => {
    return c.json({ alive: true });
  });
  ```

  **src/routes/contact.ts:**

  ```typescript
  // src/routes/contact.ts
  import { Hono } from 'hono';
  import { z } from 'zod';
  import { zValidator } from '@hono/zod-validator';
  import type { Env, Variables } from '../types/env';

  export const contactRoutes = new Hono<{ Bindings: Env; Variables: Variables }>();

  // Contact form schema
  const contactSchema = z.object({
    name: z.string().min(2).max(100),
    email: z.string().email(),
    subject: z.string().min(5).max(200),
    message: z.string().min(10).max(5000),
    honeypot: z.string().max(0).optional(), // Spam protection
  });

  contactRoutes.post('/', zValidator('json', contactSchema), async (c) => {
    const data = c.req.valid('json');

    // Honeypot check (spam bots fill hidden fields)
    if (data.honeypot) {
      return c.json({ success: true, message: 'Thank you!' }); // Fake success for bots
    }

    try {
      // Store in Supabase
      const response = await fetch(`${c.env.SUPABASE_URL}/rest/v1/contact_submissions`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': c.env.SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${c.env.SUPABASE_ANON_KEY}`,
          'Prefer': 'return=minimal',
        },
        body: JSON.stringify({
          name: data.name,
          email: data.email,
          subject: data.subject,
          message: data.message,
          source: 'contact_form',
          ip_address: c.get('clientIp'),
          user_agent: c.req.header('User-Agent'),
        }),
      });

      if (!response.ok) {
        throw new Error(`Supabase error: ${response.status}`);
      }

      // Send email notification via Resend
      await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${c.env.RESEND_API_KEY}`,
        },
        body: JSON.stringify({
          from: 'Contact Form <noreply@danieltarazona.com>',
          to: ['daniel@danieltarazona.com'],
          subject: `New Contact: ${data.subject}`,
          html: `
            <h2>New Contact Form Submission</h2>
            <p><strong>From:</strong> ${data.name} (${data.email})</p>
            <p><strong>Subject:</strong> ${data.subject}</p>
            <hr>
            <p>${data.message.replace(/\n/g, '<br>')}</p>
          `,
        }),
      });

      return c.json({
        success: true,
        message: 'Thank you for your message! We\'ll get back to you soon.',
        requestId: c.get('requestId'),
      });
    } catch (error) {
      console.error(`[${c.get('requestId')}] Contact form error:`, error);
      return c.json(
        {
          success: false,
          message: 'Failed to send message. Please try again later.',
          requestId: c.get('requestId'),
        },
        500
      );
    }
  });
  ```

  **src/routes/proxy.ts (Medusa API Proxy):**

  ```typescript
  // src/routes/proxy.ts
  import { Hono } from 'hono';
  import type { Env, Variables } from '../types/env';

  export const proxyRoutes = new Hono<{ Bindings: Env; Variables: Variables }>();

  // Proxy all requests to Medusa backend
  proxyRoutes.all('/*', async (c) => {
    const path = c.req.path.replace('/medusa', '');
    const targetUrl = `${c.env.MEDUSA_BACKEND_URL}${path}`;

    // Create headers for upstream request
    const headers = new Headers(c.req.raw.headers);
    headers.delete('host');
    headers.set('X-Forwarded-For', c.get('clientIp'));
    headers.set('X-Forwarded-Proto', 'https');
    headers.set('X-Request-ID', c.get('requestId'));

    try {
      // Check cache for GET requests
      if (c.req.method === 'GET') {
        const cacheKey = `medusa:${path}:${c.req.url}`;
        const cached = await c.env.CACHE_KV.get(cacheKey, 'text');
        if (cached) {
          return new Response(cached, {
            headers: {
              'Content-Type': 'application/json',
              'X-Cache': 'HIT',
            },
          });
        }
      }

      // Forward request to Medusa
      const response = await fetch(targetUrl, {
        method: c.req.method,
        headers,
        body: c.req.method !== 'GET' && c.req.method !== 'HEAD'
          ? await c.req.text()
          : undefined,
      });

      // Clone response for potential caching
      const responseText = await response.text();

      // Cache successful GET responses for 5 minutes
      if (c.req.method === 'GET' && response.ok) {
        const cacheKey = `medusa:${path}:${c.req.url}`;
        await c.env.CACHE_KV.put(cacheKey, responseText, {
          expirationTtl: 300,
        });
      }

      return new Response(responseText, {
        status: response.status,
        headers: {
          'Content-Type': response.headers.get('Content-Type') || 'application/json',
          'X-Cache': 'MISS',
          'X-Proxy-Request-ID': c.get('requestId'),
        },
      });
    } catch (error) {
      console.error(`[${c.get('requestId')}] Proxy error:`, error);
      return c.json(
        {
          error: 'Proxy Error',
          message: 'Failed to connect to backend service',
          requestId: c.get('requestId'),
        },
        502
      );
    }
  });
  ```

#### Task 5.2.5: Rate Limiting with KV Storage

- [ ] **Task 5.2.5**: Implement rate limiting middleware using Cloudflare KV

  **src/middleware/rateLimit.ts:**

  ```typescript
  // src/middleware/rateLimit.ts
  import { MiddlewareHandler } from 'hono';
  import type { Env, Variables } from '../types/env';

  interface RateLimitConfig {
    windowMs: number;      // Time window in milliseconds
    maxRequests: number;   // Max requests per window
    keyPrefix: string;     // KV key prefix
  }

  const defaultConfig: RateLimitConfig = {
    windowMs: 60 * 1000,   // 1 minute
    maxRequests: 30,       // 30 requests per minute
    keyPrefix: 'ratelimit',
  };

  export const rateLimitMiddleware: MiddlewareHandler<{
    Bindings: Env;
    Variables: Variables;
  }> = async (c, next) => {
    const config = defaultConfig;
    const clientIp = c.get('clientIp');
    const path = c.req.path;

    // Create unique key for this client + path combo
    const key = `${config.keyPrefix}:${clientIp}:${path}`;
    const now = Date.now();
    const windowStart = now - config.windowMs;

    try {
      // Get current request count
      const data = await c.env.RATE_LIMIT_KV.get(key, 'json') as {
        count: number;
        resetAt: number;
      } | null;

      if (!data || data.resetAt < now) {
        // Start new window
        await c.env.RATE_LIMIT_KV.put(key, JSON.stringify({
          count: 1,
          resetAt: now + config.windowMs,
        }), {
          expirationTtl: Math.ceil(config.windowMs / 1000),
        });
      } else if (data.count >= config.maxRequests) {
        // Rate limit exceeded
        const retryAfter = Math.ceil((data.resetAt - now) / 1000);
        return c.json(
          {
            error: 'Too Many Requests',
            message: 'Rate limit exceeded. Please try again later.',
            retryAfter,
            requestId: c.get('requestId'),
          },
          429,
          {
            'Retry-After': retryAfter.toString(),
            'X-RateLimit-Limit': config.maxRequests.toString(),
            'X-RateLimit-Remaining': '0',
            'X-RateLimit-Reset': data.resetAt.toString(),
          }
        );
      } else {
        // Increment counter
        await c.env.RATE_LIMIT_KV.put(key, JSON.stringify({
          count: data.count + 1,
          resetAt: data.resetAt,
        }), {
          expirationTtl: Math.ceil((data.resetAt - now) / 1000),
        });
      }

      // Add rate limit headers
      const remaining = data
        ? Math.max(0, config.maxRequests - data.count - 1)
        : config.maxRequests - 1;

      c.header('X-RateLimit-Limit', config.maxRequests.toString());
      c.header('X-RateLimit-Remaining', remaining.toString());
      c.header('X-RateLimit-Reset', (data?.resetAt || now + config.windowMs).toString());

      await next();
    } catch (error) {
      console.error(`[${c.get('requestId')}] Rate limit error:`, error);
      // On error, allow request through but log
      await next();
    }
  };

  // Stricter rate limit for sensitive endpoints
  export const strictRateLimitMiddleware: MiddlewareHandler<{
    Bindings: Env;
    Variables: Variables;
  }> = async (c, next) => {
    const strictConfig: RateLimitConfig = {
      windowMs: 60 * 60 * 1000,  // 1 hour
      maxRequests: 10,            // 10 per hour
      keyPrefix: 'ratelimit:strict',
    };

    // Apply strict rate limiting (same logic, different config)
    // ... implementation similar to above
    await next();
  };
  ```

#### Task 5.2.6: KV Namespace Creation and Configuration

- [ ] **Task 5.2.6**: Create and configure KV namespaces for Workers

  ```bash
  # Create KV namespaces

  # Rate limiting storage
  wrangler kv:namespace create "RATE_LIMIT_KV"
  # Output: 🌀 Created namespace with id = "xxxxx"

  # Create preview namespace for development
  wrangler kv:namespace create "RATE_LIMIT_KV" --preview
  # Output: 🌀 Created namespace with id = "yyyyy"

  # Cache storage
  wrangler kv:namespace create "CACHE_KV"
  wrangler kv:namespace create "CACHE_KV" --preview

  # List all namespaces
  wrangler kv:namespace list

  # Update wrangler.toml with the namespace IDs
  # [[kv_namespaces]]
  # binding = "RATE_LIMIT_KV"
  # id = "xxxxx"
  # preview_id = "yyyyy"

  # KV Operations (for debugging/maintenance)
  wrangler kv:key list --namespace-id=xxxxx
  wrangler kv:key get --namespace-id=xxxxx "some-key"
  wrangler kv:key put --namespace-id=xxxxx "some-key" "some-value"
  wrangler kv:key delete --namespace-id=xxxxx "some-key"

  # Bulk operations
  wrangler kv:bulk put --namespace-id=xxxxx ./data.json
  wrangler kv:bulk delete --namespace-id=xxxxx ./keys.json
  ```

#### Task 5.2.7: Secrets Management

- [ ] **Task 5.2.7**: Configure secrets for Workers

  ```bash
  # Add secrets (values will be prompted securely)
  wrangler secret put SUPABASE_URL
  # Enter value: https://xxxxx.supabase.co

  wrangler secret put SUPABASE_ANON_KEY
  # Enter value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

  wrangler secret put RESEND_API_KEY
  # Enter value: re_xxxxx

  # List secrets (values are hidden)
  wrangler secret list
  # Output:
  # [
  #   { "name": "SUPABASE_URL", "type": "secret_text" },
  #   { "name": "SUPABASE_ANON_KEY", "type": "secret_text" },
  #   { "name": "RESEND_API_KEY", "type": "secret_text" }
  # ]

  # Delete a secret
  wrangler secret delete SECRET_NAME

  # For staging environment
  wrangler secret put SUPABASE_URL --env staging
  ```

  **Local Development Secrets (.dev.vars):**

  ```bash
  # .dev.vars (gitignored, local development only)
  SUPABASE_URL=https://xxxxx.supabase.co
  SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  RESEND_API_KEY=re_xxxxx
  ```

#### Task 5.2.8: Local Development Server

- [ ] **Task 5.2.8**: Configure local development environment

  ```bash
  # Start local development server
  wrangler dev

  # Output:
  # ⛅️ wrangler 3.x.x
  # ──────────────────────────────────────────────────
  # ⎔ Starting local server...
  # [mf:inf] Ready on http://localhost:8787

  # Development with specific environment
  wrangler dev --env staging

  # Development with live backend (uses real KV, etc.)
  wrangler dev --remote

  # Development on specific port
  wrangler dev --port 3000

  # Development with inspector
  wrangler dev --inspect

  # Test endpoints
  curl http://localhost:8787/health
  curl http://localhost:8787/api/v1/status
  curl -X POST http://localhost:8787/contact \
    -H "Content-Type: application/json" \
    -d '{"name":"Test","email":"test@example.com","subject":"Test","message":"Hello World"}'
  ```

#### Task 5.2.9: Deployment and Routing

- [ ] **Task 5.2.9**: Deploy Workers and configure routes

  ```bash
  # Deploy to production
  wrangler deploy

  # Output:
  # ⛅️ wrangler 3.x.x
  # ──────────────────────────────────────────────────
  # Your worker has access to the following bindings:
  # - KV Namespaces:
  #   - RATE_LIMIT_KV
  #   - CACHE_KV
  # - Vars:
  #   - ENVIRONMENT: "production"
  # Uploaded danieltarazona-api (1.23 sec)
  # Published danieltarazona-api (3.45 sec)
  #   https://danieltarazona-api.yoursubdomain.workers.dev
  #   api.danieltarazona.com/*
  #   danieltarazona.com/api/*

  # Deploy to staging
  wrangler deploy --env staging

  # Deploy specific version (dry run)
  wrangler deploy --dry-run

  # View deployment versions
  wrangler deployments list

  # Rollback to previous version
  wrangler rollback
  ```

  **DNS Configuration for Custom Routes:**

  ```bash
  # Add Worker routes via Cloudflare API (or dashboard)
  # These map requests to your Worker

  # Route: api.danieltarazona.com/* → Worker
  curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/workers/routes" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "pattern": "api.danieltarazona.com/*",
      "script": "danieltarazona-api"
    }'

  # Route: danieltarazona.com/api/* → Worker
  curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/workers/routes" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{
      "pattern": "danieltarazona.com/api/*",
      "script": "danieltarazona-api"
    }'
  ```

#### Task 5.2.10: Monitoring and Logging

- [ ] **Task 5.2.10**: Set up monitoring and logging for Workers

  ```bash
  # Real-time logs (tail)
  wrangler tail

  # Filter by status
  wrangler tail --status error

  # Filter by IP
  wrangler tail --ip 192.168.1.1

  # Filter by search term
  wrangler tail --search "contact"

  # JSON output for processing
  wrangler tail --format json

  # Tail with sampling (for high-traffic workers)
  wrangler tail --sampling-rate 0.1  # 10% of requests
  ```

  **Analytics (via Cloudflare Dashboard):**

  | Metric | Description | Location |
  |--------|-------------|----------|
  | Requests | Total requests per period | Workers → Overview |
  | CPU Time | Execution time metrics | Workers → Analytics |
  | Errors | Error rate and types | Workers → Analytics |
  | Subrequests | Outbound fetch() calls | Workers → Analytics |
  | KV Operations | Read/write operations | KV → Analytics |

  **Custom Logging to External Service:**

  ```typescript
  // src/lib/logger.ts
  export async function logToExternal(
    env: Env,
    level: 'info' | 'warn' | 'error',
    message: string,
    meta?: Record<string, unknown>
  ) {
    // Example: Log to Logflare, Datadog, or custom endpoint
    await fetch('https://your-logging-service.com/logs', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        level,
        message,
        timestamp: new Date().toISOString(),
        environment: env.ENVIRONMENT,
        ...meta,
      }),
    });
  }
  ```

#### Task 5.2.11: Integration with Astro Sites

- [ ] **Task 5.2.11**: Integrate Workers API with main Astro sites

  **Astro Site Configuration:**

  ```typescript
  // src/lib/api.ts (in Astro project)
  const API_BASE = import.meta.env.PUBLIC_API_URL || 'https://api.danieltarazona.com';

  export async function submitContactForm(data: ContactFormData) {
    const response = await fetch(`${API_BASE}/contact`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Failed to submit form');
    }

    return response.json();
  }

  export async function fetchProducts() {
    const response = await fetch(`${API_BASE}/medusa/store/products`);
    if (!response.ok) {
      throw new Error('Failed to fetch products');
    }
    return response.json();
  }
  ```

  **Environment Variables for Astro:**

  ```bash
  # .env (Astro project)
  PUBLIC_API_URL=https://api.danieltarazona.com

  # Development
  PUBLIC_API_URL=http://localhost:8787
  ```

### Phase 4 Task Summary: Cloudflare Workers

| Task ID | Task | Status |
|---------|------|--------|
| 5.2.1 | Install and configure Wrangler CLI | [ ] |
| 5.2.2 | Create Workers project structure | [ ] |
| 5.2.3 | Create main entry point with Hono router | [ ] |
| 5.2.4 | Create route handlers for API endpoints | [ ] |
| 5.2.5 | Implement rate limiting with KV storage | [ ] |
| 5.2.6 | Create and configure KV namespaces | [ ] |
| 5.2.7 | Configure secrets for Workers | [ ] |
| 5.2.8 | Set up local development environment | [ ] |
| 5.2.9 | Deploy Workers and configure routes | [ ] |
| 5.2.10 | Set up monitoring and logging | [ ] |
| 5.2.11 | Integrate Workers API with Astro sites | [ ] |

### Cloudflare Workers Resources & Documentation

| Resource | URL |
|----------|-----|
| Workers Documentation | https://developers.cloudflare.com/workers/ |
| Wrangler CLI | https://developers.cloudflare.com/workers/wrangler/ |
| Workers Examples | https://developers.cloudflare.com/workers/examples/ |
| Hono Framework | https://hono.dev |
| Workers KV | https://developers.cloudflare.com/kv/ |
| D1 Database | https://developers.cloudflare.com/d1/ |
| R2 Storage | https://developers.cloudflare.com/r2/ |
| Workers AI | https://developers.cloudflare.com/workers-ai/ |

---

## Phase 5: Deployment & Orchestration

This phase covers the setup and configuration of Coolify as a self-hosted deployment platform for managing Medusa 2.0 backend services on your VPS. Coolify provides a user-friendly interface for container orchestration, environment management, and automated deployments.

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                         COOLIFY DEPLOYMENT ARCHITECTURE                                  │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────┐
                              │   GitHub Repo   │
                              │  (Source Code)  │
                              └────────┬────────┘
                                       │ Webhook / Push
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              VPS (Hetzner / Oracle Cloud)                                │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │                              COOLIFY PLATFORM                                      │  │
│  │  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐               │  │
│  │  │   Dashboard     │    │   Build Engine  │    │   Traefik       │               │  │
│  │  │   (Port 8000)   │    │   (Nixpacks)    │    │   (Reverse Proxy)│              │  │
│  │  └─────────────────┘    └─────────────────┘    └─────────────────┘               │  │
│  │           │                      │                      │                         │  │
│  │           └──────────────────────┼──────────────────────┘                         │  │
│  │                                  │                                                 │  │
│  │                    ┌─────────────┴─────────────┐                                  │  │
│  │                    │      Docker Engine         │                                  │  │
│  │                    └─────────────┬─────────────┘                                  │  │
│  │                                  │                                                 │  │
│  │     ┌────────────────────────────┼────────────────────────────┐                   │  │
│  │     │                            │                            │                   │  │
│  │     ▼                            ▼                            ▼                   │  │
│  │  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐               │  │
│  │  │  Medusa 2.0     │    │   PostgreSQL    │    │     Redis       │               │  │
│  │  │  (Backend API)  │    │   (Database)    │    │   (Cache/Queue) │               │  │
│  │  │  Port: 9000     │    │   Port: 5432    │    │   Port: 6379    │               │  │
│  │  └─────────────────┘    └─────────────────┘    └─────────────────┘               │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
│                                       │                                                  │
│                                       │ Cloudflare Tunnel (cloudflared)                 │
│                                       ▼                                                  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
                        ┌──────────────────────────────┐
                        │    Cloudflare Edge Network   │
                        │  (CDN + SSL + DDoS + WAF)    │
                        └──────────────────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              ▼                        ▼                        ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ store.daniel... │      │ admin.daniel... │      │ api.daniel...   │
    │ (Storefront)    │      │ (Medusa Admin)  │      │ (REST API)      │
    └─────────────────┘      └─────────────────┘      └─────────────────┘
```

### Why Coolify?

| Feature | Description | Benefit |
|---------|-------------|---------|
| **Self-Hosted** | Run on your own VPS | Full data ownership, no vendor lock-in |
| **Docker Native** | Built on Docker/Docker Compose | Industry-standard containerization |
| **Git Integration** | Connect to GitHub/GitLab/Bitbucket | Automated deployments on push |
| **Zero-Config SSL** | Automatic Let's Encrypt certificates | Secure by default |
| **Multi-Service** | Deploy multiple services per project | Microservices support |
| **Database Management** | One-click PostgreSQL, MySQL, Redis | Easy database provisioning |
| **Environment Variables** | Secure secrets management | No env files in repos |
| **Logs & Monitoring** | Real-time logs and metrics | Debugging and observability |
| **Backup Integration** | Scheduled database backups | Data protection |
| **Cost-Effective** | Open source, pay only for VPS | ~$5-20/month total |

### Task 6.1: Coolify Installation and Configuration

#### Task 6.1.1: VPS Prerequisites

- [ ] **Task 6.1.1**: Prepare VPS for Coolify installation

  **Minimum Requirements:**

  | Resource | Minimum | Recommended | Notes |
  |----------|---------|-------------|-------|
  | RAM | 2 GB | 4 GB | For Coolify + Medusa + PostgreSQL |
  | CPU | 1 vCPU | 2 vCPU | More for build processes |
  | Storage | 30 GB | 60 GB | SSD recommended |
  | OS | Ubuntu 22.04+ | Ubuntu 24.04 LTS | Debian 12 also supported |
  | Network | IPv4 required | IPv4 + IPv6 | Cloudflare handles DNS |

  **Initial VPS Setup (Run as Root):**

  ```bash
  # Update system packages
  apt update && apt upgrade -y

  # Install essential tools
  apt install -y curl wget git htop nano ufw

  # Configure firewall (minimal ports - Cloudflare Tunnel handles ingress)
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp  # SSH (consider changing default port)
  ufw allow 8000/tcp  # Coolify Dashboard (temporary, can be tunneled)
  ufw enable

  # Create non-root user for operations
  adduser deploy
  usermod -aG sudo deploy
  usermod -aG docker deploy  # After Docker installation

  # Configure SSH key authentication (copy your public key)
  mkdir -p /home/deploy/.ssh
  # Add your public key to /home/deploy/.ssh/authorized_keys
  chmod 700 /home/deploy/.ssh
  chmod 600 /home/deploy/.ssh/authorized_keys
  chown -R deploy:deploy /home/deploy/.ssh

  # Disable password authentication (security hardening)
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  systemctl restart sshd
  ```

  **Swap Configuration (Recommended for 2GB VPS):**

  ```bash
  # Create 2GB swap file
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile

  # Make swap permanent
  echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

  # Optimize swap settings
  echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
  sysctl -p
  ```

#### Task 6.1.2: Docker Installation

- [ ] **Task 6.1.2**: Install Docker Engine and Docker Compose

  **Automated Docker Installation (Recommended):**

  ```bash
  # Install Docker using official script
  curl -fsSL https://get.docker.com | sh

  # Add current user to docker group
  sudo usermod -aG docker $USER

  # Apply group changes (or log out and back in)
  newgrp docker

  # Verify installation
  docker --version
  docker compose version

  # Enable Docker to start on boot
  sudo systemctl enable docker
  sudo systemctl start docker

  # Test Docker installation
  docker run hello-world
  ```

  **Docker Configuration (Optional but Recommended):**

  ```bash
  # Create Docker daemon configuration
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json <<EOF
  {
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "10m",
      "max-file": "3"
    },
    "storage-driver": "overlay2",
    "default-address-pools": [
      {
        "base": "172.17.0.0/16",
        "size": 24
      }
    ]
  }
  EOF

  # Restart Docker to apply changes
  sudo systemctl restart docker
  ```

#### Task 6.1.3: Coolify Installation

- [ ] **Task 6.1.3**: Install Coolify self-hosted platform

  **One-Line Installation (Recommended):**

  ```bash
  # Run Coolify installer as root
  curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
  ```

  **What the Installer Does:**
  1. Checks system requirements (Docker, etc.)
  2. Creates Coolify directories (`/data/coolify`)
  3. Downloads and starts Coolify containers
  4. Sets up internal SQLite database
  5. Configures Traefik reverse proxy
  6. Generates initial admin credentials

  **Manual Installation (Alternative):**

  ```bash
  # Create Coolify directories
  mkdir -p /data/coolify/{source,ssh,applications,databases,backups,services,proxy,webhooks-during-maintenance}
  mkdir -p /data/coolify/ssh/{keys,mux}
  mkdir -p /data/coolify/proxy/dynamic

  # Clone Coolify repository
  git clone https://github.com/coollabsio/coolify.git /data/coolify/source

  # Copy environment file
  cp /data/coolify/source/.env.example /data/coolify/source/.env

  # Generate application key
  cd /data/coolify/source
  docker compose up -d
  ```

  **Post-Installation Verification:**

  ```bash
  # Check Coolify containers are running
  docker ps --filter "name=coolify"

  # Expected containers:
  # - coolify (Main application)
  # - coolify-proxy (Traefik)
  # - coolify-realtime (WebSocket for real-time updates)
  # - coolify-db (SQLite via Soketi)

  # View Coolify logs
  docker logs coolify -f --tail 100

  # Check Coolify version
  docker exec coolify php artisan about
  ```

#### Task 6.1.4: Initial Coolify Configuration

- [ ] **Task 6.1.4**: Complete Coolify initial setup via web interface

  **Access Coolify Dashboard:**

  ```
  URL: http://<your-vps-ip>:8000

  # Or if using Cloudflare Tunnel:
  URL: https://coolify.danieltarazona.com
  ```

  **Initial Setup Steps:**

  1. **Create Admin Account**
     - Email: `admin@danieltarazona.com`
     - Password: Use a strong, unique password
     - Store credentials securely in password manager

  2. **Add Server**
     - Go to: Servers → Add Server
     - Type: `Localhost` (for single VPS setup)
     - Connection: Docker socket
     - Coolify will validate the connection

  3. **Configure Default Settings**
     - Settings → General
       - Instance Name: `danieltarazona-production`
       - Public Domain: `coolify.danieltarazona.com`
       - Timezone: `America/Lima` (or your timezone)

  4. **Setup Wildcard Domain (Optional)**
     - Settings → Domains
     - Add wildcard: `*.danieltarazona.com`
     - Required for automatic subdomain routing

#### Task 6.1.5: Git Source Configuration

- [ ] **Task 6.1.5**: Connect GitHub repository to Coolify

  **Method 1: GitHub App (Recommended)**

  1. Go to: Sources → Add Source → GitHub App
  2. Click "Register GitHub App"
  3. Name: `coolify-danieltarazona`
  4. Select repositories to access
  5. Complete OAuth authorization

  **Method 2: Deploy Keys**

  ```bash
  # Generate SSH key pair for Coolify
  ssh-keygen -t ed25519 -C "coolify@danieltarazona.com" -f ~/.ssh/coolify_deploy

  # Copy public key
  cat ~/.ssh/coolify_deploy.pub
  ```

  1. Add public key as Deploy Key in GitHub repository settings
  2. In Coolify: Sources → Add Source → Deploy Key
  3. Paste private key content

  **Method 3: Personal Access Token**

  1. GitHub → Settings → Developer settings → Personal access tokens
  2. Generate token with `repo` scope
  3. In Coolify: Sources → Add Source → GitHub → Token

#### Task 6.1.6: Create Medusa 2.0 Application

- [ ] **Task 6.1.6**: Deploy Medusa 2.0 backend via Coolify

  **Project Structure in GitHub:**

  ```
  medusa-backend/
  ├── src/
  │   ├── api/
  │   ├── modules/
  │   ├── workflows/
  │   └── subscribers/
  ├── medusa-config.ts
  ├── package.json
  ├── Dockerfile
  └── docker-compose.yml
  ```

  **Dockerfile for Medusa 2.0:**

  ```dockerfile
  # Multi-stage build for production
  FROM node:20-alpine AS builder

  WORKDIR /app

  # Install dependencies
  COPY package*.json ./
  RUN npm ci

  # Copy source and build
  COPY . .
  RUN npm run build

  # Production stage
  FROM node:20-alpine AS production

  WORKDIR /app

  # Install production dependencies only
  COPY package*.json ./
  RUN npm ci --only=production

  # Copy built application
  COPY --from=builder /app/dist ./dist
  COPY --from=builder /app/medusa-config.ts ./
  COPY --from=builder /app/public ./public

  # Create non-root user
  RUN addgroup -g 1001 -S medusa && \
      adduser -S medusa -u 1001 -G medusa

  USER medusa

  # Expose Medusa port
  EXPOSE 9000

  # Health check
  HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9000/health || exit 1

  # Start Medusa
  CMD ["npm", "run", "start"]
  ```

  **Coolify Application Setup:**

  1. Go to: Projects → Add Project → `danieltarazona-store`
  2. Add Application → Docker-based
  3. Source: Select GitHub repository
  4. Branch: `main`
  5. Build Pack: `Dockerfile`
  6. Port: `9000`

#### Task 6.1.7: Database Configuration in Coolify

- [ ] **Task 6.1.7**: Create and configure PostgreSQL database

  **Option 1: Coolify Managed PostgreSQL**

  1. Go to: Projects → danieltarazona-store → Add Database
  2. Select: PostgreSQL
  3. Version: 15 or 16
  4. Configuration:
     - Database Name: `medusa`
     - Username: `medusa_user`
     - Password: Auto-generated or custom
     - Port: `5432` (internal)

  **Database Environment Variables (Auto-populated):**

  ```env
  # These are automatically set when linking database
  POSTGRES_HOST=<container-name>
  POSTGRES_PORT=5432
  POSTGRES_DB=medusa
  POSTGRES_USER=medusa_user
  POSTGRES_PASSWORD=<generated-password>

  # Constructed DATABASE_URL
  DATABASE_URL=postgres://medusa_user:<password>@<container-name>:5432/medusa
  ```

  **Option 2: External Supabase PostgreSQL**

  1. Skip database creation in Coolify
  2. Add environment variable manually:

  ```env
  DATABASE_URL=postgres://postgres.<ref>:<password>@aws-0-us-west-1.pooler.supabase.com:6543/postgres?pgbouncer=true
  ```

  **Database Link in Coolify:**

  1. Go to: Applications → Medusa 2.0 → Storages
  2. Link: Select PostgreSQL database
  3. Alias: `DATABASE` (creates DATABASE_URL automatically)

#### Task 6.1.8: Redis Cache Configuration

- [ ] **Task 6.1.8**: Configure Redis for Medusa caching and queues

  **Create Redis Instance:**

  1. Go to: Projects → danieltarazona-store → Add Database
  2. Select: Redis
  3. Version: 7.x
  4. Port: `6379` (internal)

  **Environment Variable:**

  ```env
  REDIS_URL=redis://<redis-container>:6379
  ```

  **Link to Application:**

  1. Applications → Medusa 2.0 → Storages
  2. Link Redis with alias: `REDIS`

#### Task 6.1.9: Environment Variables Management

- [ ] **Task 6.1.9**: Configure all required environment variables for Medusa

  **Coolify Environment Variables (Applications → Medusa → Environment Variables):**

  ```env
  # ─────────────────────────────────────────────────────────────
  # MEDUSA CORE CONFIGURATION
  # ─────────────────────────────────────────────────────────────
  NODE_ENV=production
  MEDUSA_BACKEND_URL=https://api.danieltarazona.com
  STORE_CORS=https://store.danieltarazona.com,https://danieltarazona.com
  ADMIN_CORS=https://admin.danieltarazona.com

  # ─────────────────────────────────────────────────────────────
  # DATABASE (Auto-linked from Coolify database)
  # ─────────────────────────────────────────────────────────────
  # DATABASE_URL is automatically set when database is linked

  # ─────────────────────────────────────────────────────────────
  # REDIS (Auto-linked from Coolify Redis)
  # ─────────────────────────────────────────────────────────────
  # REDIS_URL is automatically set when Redis is linked

  # ─────────────────────────────────────────────────────────────
  # AUTHENTICATION & SECURITY
  # ─────────────────────────────────────────────────────────────
  JWT_SECRET=<generate-with: openssl rand -hex 64>
  COOKIE_SECRET=<generate-with: openssl rand -hex 64>

  # ─────────────────────────────────────────────────────────────
  # PAYMENT PROVIDERS (Production)
  # ─────────────────────────────────────────────────────────────
  STRIPE_API_KEY=sk_live_xxxxx
  STRIPE_WEBHOOK_SECRET=whsec_xxxxx

  # ─────────────────────────────────────────────────────────────
  # EMAIL CONFIGURATION
  # ─────────────────────────────────────────────────────────────
  SMTP_HOST=smtp.resend.com
  SMTP_PORT=465
  SMTP_USER=resend
  SMTP_PASSWORD=re_xxxxx
  SMTP_FROM=store@danieltarazona.com

  # ─────────────────────────────────────────────────────────────
  # FILE STORAGE (S3-compatible)
  # ─────────────────────────────────────────────────────────────
  S3_URL=https://<account-id>.r2.cloudflarestorage.com
  S3_BUCKET=medusa-files
  S3_REGION=auto
  S3_ACCESS_KEY_ID=xxxxx
  S3_SECRET_ACCESS_KEY=xxxxx

  # ─────────────────────────────────────────────────────────────
  # LOGGING & MONITORING
  # ─────────────────────────────────────────────────────────────
  LOG_LEVEL=info
  ```

  **Secrets vs Environment Variables:**

  | Type | Use For | Example |
  |------|---------|---------|
  | Environment | Non-sensitive config | `NODE_ENV`, `LOG_LEVEL` |
  | Secret | Sensitive data | `JWT_SECRET`, `STRIPE_API_KEY` |
  | Build Argument | Build-time values | `NODE_VERSION` |

  **Generating Secure Secrets:**

  ```bash
  # Generate JWT secret
  openssl rand -hex 64

  # Generate Cookie secret
  openssl rand -hex 64

  # Generate random password
  openssl rand -base64 32
  ```

#### Task 6.1.10: Deployment Configuration

- [ ] **Task 6.1.10**: Configure automatic deployment settings

  **Deployment Settings (Applications → Medusa → General):**

  | Setting | Value | Description |
  |---------|-------|-------------|
  | Auto Deploy | Enabled | Deploy on push to main branch |
  | Branch | `main` | Production branch |
  | Build Pack | Dockerfile | Use custom Dockerfile |
  | Health Check Path | `/health` | Verify deployment success |
  | Health Check Interval | `30s` | Check frequency |
  | Container Replicas | `1` | Single instance (scale as needed) |

  **Webhook Configuration:**

  Coolify automatically creates a webhook URL for GitHub:

  ```
  https://coolify.danieltarazona.com/webhooks/github/<webhook-id>
  ```

  This triggers automatic deployments when:
  - Push to monitored branch
  - Pull request merged
  - Manual trigger from Coolify dashboard

  **Pre-deployment Commands:**

  ```bash
  # Run before deployment
  npm run build
  npm run db:migrate
  ```

  **Post-deployment Commands:**

  ```bash
  # Run after successful deployment
  npm run db:seed  # Only for initial setup
  ```

#### Task 6.1.11: Cloudflare Tunnel Integration

- [ ] **Task 6.1.11**: Configure Cloudflare Tunnel for Coolify services

  **Install cloudflared on VPS:**

  ```bash
  # Download and install cloudflared
  curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    -o /usr/local/bin/cloudflared
  chmod +x /usr/local/bin/cloudflared

  # Authenticate with Cloudflare
  cloudflared tunnel login
  ```

  **Create Tunnel:**

  ```bash
  # Create named tunnel
  cloudflared tunnel create danieltarazona-vps

  # This creates a credentials file at:
  # ~/.cloudflared/<tunnel-uuid>.json
  ```

  **Tunnel Configuration (`~/.cloudflared/config.yml`):**

  ```yaml
  tunnel: danieltarazona-vps
  credentials-file: /root/.cloudflared/<tunnel-uuid>.json

  ingress:
    # Medusa Store API
    - hostname: api.danieltarazona.com
      service: http://localhost:9000
      originRequest:
        noTLSVerify: true

    # Medusa Admin Dashboard
    - hostname: admin.danieltarazona.com
      service: http://localhost:9000
      path: /admin
      originRequest:
        noTLSVerify: true

    # Coolify Dashboard (Optional - restrict access)
    - hostname: coolify.danieltarazona.com
      service: http://localhost:8000
      originRequest:
        noTLSVerify: true

    # Catch-all
    - service: http_status:404
  ```

  **Run Tunnel as Service:**

  ```bash
  # Install as systemd service
  cloudflared service install

  # Enable and start
  systemctl enable cloudflared
  systemctl start cloudflared

  # Check status
  systemctl status cloudflared
  ```

  **DNS Configuration (Automatic via API):**

  ```bash
  # Route DNS to tunnel
  cloudflared tunnel route dns danieltarazona-vps api.danieltarazona.com
  cloudflared tunnel route dns danieltarazona-vps admin.danieltarazona.com
  cloudflared tunnel route dns danieltarazona-vps coolify.danieltarazona.com
  ```

#### Task 6.1.12: Backup Configuration

- [ ] **Task 6.1.12**: Configure automated database backups

  **Coolify Built-in Backups:**

  1. Go to: Databases → PostgreSQL → Backups
  2. Enable: Scheduled Backups
  3. Schedule: `0 3 * * *` (3 AM daily)
  4. Retention: 7 days

  **Backup Storage Options:**

  | Storage | Configuration | Notes |
  |---------|--------------|-------|
  | Local | `/data/coolify/backups` | Default, limited by disk |
  | S3 | Add S3 credentials | Recommended for production |
  | R2 | Cloudflare R2 bucket | Cost-effective S3-compatible |

  **S3/R2 Backup Configuration:**

  ```env
  # Add to Coolify settings
  S3_BACKUP_BUCKET=danieltarazona-backups
  S3_BACKUP_ENDPOINT=https://<account-id>.r2.cloudflarestorage.com
  S3_BACKUP_ACCESS_KEY=xxxxx
  S3_BACKUP_SECRET_KEY=xxxxx
  ```

  **Manual Backup Script:**

  ```bash
  #!/bin/bash
  # /data/coolify/scripts/backup.sh

  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  BACKUP_DIR="/data/coolify/backups"
  DATABASE_CONTAINER="coolify-<db-uuid>"

  # Create backup
  docker exec $DATABASE_CONTAINER pg_dump -U medusa_user medusa > \
    "$BACKUP_DIR/medusa_$TIMESTAMP.sql"

  # Compress
  gzip "$BACKUP_DIR/medusa_$TIMESTAMP.sql"

  # Upload to R2 (using rclone or aws cli)
  aws s3 cp "$BACKUP_DIR/medusa_$TIMESTAMP.sql.gz" \
    s3://danieltarazona-backups/medusa/ \
    --endpoint-url https://<account-id>.r2.cloudflarestorage.com

  # Clean old local backups (keep 7 days)
  find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete

  echo "Backup completed: medusa_$TIMESTAMP.sql.gz"
  ```

  **Schedule with Cron:**

  ```bash
  # Add to crontab
  crontab -e

  # Daily at 3 AM
  0 3 * * * /data/coolify/scripts/backup.sh >> /var/log/backup.log 2>&1
  ```

#### Task 6.1.13: Monitoring and Logging

- [ ] **Task 6.1.13**: Set up monitoring and log aggregation

  **Coolify Built-in Monitoring:**

  1. Dashboard → Server → Metrics
     - CPU usage
     - Memory usage
     - Disk usage
     - Network traffic

  2. Applications → Logs
     - Real-time log streaming
     - Download log files
     - Filter by timeframe

  **Container Health Monitoring:**

  ```bash
  # Check all container health
  docker ps --format "table {{.Names}}\t{{.Status}}"

  # View specific container logs
  docker logs coolify-<uuid> -f --tail 100

  # Check resource usage
  docker stats --no-stream
  ```

  **External Monitoring (Optional):**

  | Service | Purpose | Free Tier |
  |---------|---------|-----------|
  | Uptime Robot | HTTP monitoring | 50 monitors |
  | Betterstack | Logs + Uptime | Limited |
  | Grafana Cloud | Metrics visualization | 10K series |

  **Uptime Robot Configuration:**

  ```
  Monitor Type: HTTP(s)
  URL: https://api.danieltarazona.com/health
  Interval: 5 minutes
  Alert Contacts: email, Discord webhook
  ```

#### Task 6.1.14: Scaling Configuration

- [ ] **Task 6.1.14**: Configure horizontal scaling options

  **Single VPS Scaling (Vertical):**

  1. Upgrade VPS plan in Hetzner/Oracle
  2. Increase container resources in Coolify:
     - Applications → Medusa → Resources
     - Memory Limit: 512MB → 1024MB
     - CPU Limit: 0.5 → 1.0

  **Multi-Container Scaling (Horizontal):**

  ```yaml
  # docker-compose.yml with load balancing
  version: '3.8'

  services:
    medusa:
      image: medusa-backend:latest
      deploy:
        replicas: 2
        resources:
          limits:
            memory: 512M
            cpus: '0.5'
      healthcheck:
        test: ["CMD", "wget", "-q", "--spider", "http://localhost:9000/health"]
        interval: 30s
        timeout: 10s
        retries: 3
  ```

  **Coolify Scaling Settings:**

  | Setting | Value | Notes |
  |---------|-------|-------|
  | Replicas | 1-5 | Based on traffic |
  | Auto-scaling | Not built-in | Use external orchestration |
  | Zero-downtime | Enabled | Rolling updates |

### Task 6.2: GitHub Actions Workflow Setup

This section covers the setup and configuration of GitHub Actions for automated CI/CD pipelines, following the existing repository patterns (e.g., `snake.yml`) and integrating with Coolify and Cloudflare Pages for automated deployments.

#### GitHub Actions Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                         GITHUB ACTIONS CI/CD ARCHITECTURE                                │
└─────────────────────────────────────────────────────────────────────────────────────────┘

                              ┌─────────────────┐
                              │   Developer     │
                              │   (Push/PR)     │
                              └────────┬────────┘
                                       │ git push / Pull Request
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                              GITHUB REPOSITORY                                           │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │  .github/workflows/                                                                │  │
│  │  ├── portfolio-deploy.yml    (Portfolio site → Cloudflare Pages)                  │  │
│  │  ├── store-deploy.yml        (Store frontend → Cloudflare Pages)                  │  │
│  │  ├── medusa-deploy.yml       (Medusa backend → Coolify webhook)                   │  │
│  │  ├── lint-test.yml           (Code quality checks)                                │  │
│  │  └── snake.yml               (Existing: GitHub contribution animation)            │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────────────────────┘
                                       │
                    ┌──────────────────┼──────────────────┐
                    │                  │                  │
                    ▼                  ▼                  ▼
         ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
         │  Lint & Test    │ │ Build Static    │ │  Webhook        │
         │  (Quality Gate) │ │ (Astro Build)   │ │  (Coolify)      │
         └────────┬────────┘ └────────┬────────┘ └────────┬────────┘
                  │                   │                   │
                  ▼                   ▼                   ▼
         ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
         │   Pass/Fail     │ │ Cloudflare      │ │  Coolify        │
         │   Status        │ │ Pages Deploy    │ │  Auto-Deploy    │
         └─────────────────┘ └─────────────────┘ └─────────────────┘
                                     │                   │
                                     ▼                   ▼
                          ┌───────────────────────────────────────┐
                          │         PRODUCTION ENVIRONMENT        │
                          │  ┌─────────────┐  ┌─────────────────┐ │
                          │  │ danieltara- │  │ store.daniel-   │ │
                          │  │ zona.com    │  │ tarazona.com    │ │
                          │  │ (Portfolio) │  │ (E-commerce)    │ │
                          │  └─────────────┘  └─────────────────┘ │
                          └───────────────────────────────────────┘
```

#### Workflow Pattern Reference

The existing `snake.yml` workflow demonstrates the repository's conventions for GitHub Actions:

```yaml
# .github/workflows/snake.yml - Reference Pattern
name: Generate Snake Animation

on:
  schedule:
    - cron: "0 */12 * * *" # Runs every 12 hours
  workflow_dispatch:
  push:
    branches:
      - main
      - master

jobs:
  generate:
    permissions:
      contents: write
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - name: Generate Snake Game
        uses: Platane/snk/svg-only@v3
        with:
          github_user_name: ${{ github.repository_owner }}
          outputs: |
            dist/github-contribution-grid-snake.svg
            dist/github-contribution-grid-snake-dark.svg?palette=github-dark

      - name: Push Snake to Output Branch
        uses: crazy-max/ghaction-github-pages@v4
        with:
          target_branch: output
          build_dir: dist
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Key Patterns to Follow:**
- Use semantic workflow names
- Define appropriate triggers (`push`, `schedule`, `workflow_dispatch`)
- Set explicit permissions for security
- Use `ubuntu-latest` as the runner
- Set reasonable timeouts
- Leverage existing GitHub Actions from marketplace
- Use environment variables and secrets properly

#### Task 6.2.1: Repository Secrets Configuration

- [ ] **Task 6.2.1**: Configure GitHub repository secrets for deployments

  **Required Secrets:**

  | Secret Name | Purpose | Where to Get |
  |-------------|---------|--------------|
  | `CLOUDFLARE_API_TOKEN` | Cloudflare Pages deployment | Cloudflare Dashboard → API Tokens |
  | `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account identifier | Cloudflare Dashboard → Overview |
  | `COOLIFY_WEBHOOK_URL` | Trigger Coolify deployments | Coolify → Application → Webhooks |
  | `COOLIFY_WEBHOOK_SECRET` | Authenticate webhook requests | Coolify → Application → Webhooks |
  | `SUPABASE_URL` | Supabase project URL | Supabase Dashboard → Settings → API |
  | `SUPABASE_ANON_KEY` | Supabase anonymous key | Supabase Dashboard → Settings → API |

  **Adding Secrets via GitHub CLI:**

  ```bash
  # Install GitHub CLI if not present
  brew install gh  # macOS
  # or
  sudo apt install gh  # Ubuntu

  # Authenticate with GitHub
  gh auth login

  # Add secrets to repository
  gh secret set CLOUDFLARE_API_TOKEN --body "your-cloudflare-api-token"
  gh secret set CLOUDFLARE_ACCOUNT_ID --body "your-cloudflare-account-id"
  gh secret set COOLIFY_WEBHOOK_URL --body "https://coolify.yourdomain.com/webhook/abc123"
  gh secret set COOLIFY_WEBHOOK_SECRET --body "your-webhook-secret"
  gh secret set SUPABASE_URL --body "https://your-project.supabase.co"
  gh secret set SUPABASE_ANON_KEY --body "your-anon-key"

  # Verify secrets are set
  gh secret list
  ```

  **Adding Secrets via GitHub Web UI:**

  1. Navigate to repository → Settings → Secrets and variables → Actions
  2. Click "New repository secret"
  3. Add each secret with its name and value
  4. Repeat for all required secrets

  **Creating Cloudflare API Token:**

  ```bash
  # Required permissions for Cloudflare Pages deployment
  # Account: Cloudflare Pages - Edit
  # Zone: DNS - Edit (if managing DNS)
  # Zone: Zone - Read

  # Via Cloudflare Dashboard:
  # 1. Go to My Profile → API Tokens
  # 2. Create Token → Custom Token
  # 3. Add permissions:
  #    - Account: Cloudflare Pages - Edit
  #    - Account: Account Settings - Read
  #    - Zone: Zone - Read (for your domain)
  # 4. Continue to summary → Create Token
  # 5. Copy and save the token immediately
  ```

#### Task 6.2.2: Portfolio Site Deployment Workflow

- [ ] **Task 6.2.2**: Create GitHub Actions workflow for portfolio site deployment to Cloudflare Pages

  **Create `.github/workflows/portfolio-deploy.yml`:**

  ```yaml
  name: Deploy Portfolio Site

  on:
    push:
      branches:
        - main
      paths:
        - 'portfolio/**'
        - '.github/workflows/portfolio-deploy.yml'
    pull_request:
      branches:
        - main
      paths:
        - 'portfolio/**'
    workflow_dispatch:
      inputs:
        environment:
          description: 'Deployment environment'
          required: true
          default: 'production'
          type: choice
          options:
            - production
            - preview

  env:
    NODE_VERSION: '20'
    PNPM_VERSION: '8'

  jobs:
    lint-and-test:
      name: Lint & Test
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'
            cache-dependency-path: 'portfolio/pnpm-lock.yaml'

        - name: Install dependencies
          working-directory: portfolio
          run: pnpm install --frozen-lockfile

        - name: Run linter
          working-directory: portfolio
          run: pnpm lint

        - name: Run type check
          working-directory: portfolio
          run: pnpm typecheck

        - name: Run tests
          working-directory: portfolio
          run: pnpm test --passWithNoTests

    build:
      name: Build Portfolio
      needs: lint-and-test
      runs-on: ubuntu-latest
      timeout-minutes: 15

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'
            cache-dependency-path: 'portfolio/pnpm-lock.yaml'

        - name: Install dependencies
          working-directory: portfolio
          run: pnpm install --frozen-lockfile

        - name: Build Astro site
          working-directory: portfolio
          run: pnpm build
          env:
            SITE_URL: https://danieltarazona.com
            PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
            PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}

        - name: Upload build artifacts
          uses: actions/upload-artifact@v4
          with:
            name: portfolio-dist
            path: portfolio/dist
            retention-days: 1

    deploy-preview:
      name: Deploy Preview
      needs: build
      runs-on: ubuntu-latest
      timeout-minutes: 10
      if: github.event_name == 'pull_request'

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Download build artifacts
          uses: actions/download-artifact@v4
          with:
            name: portfolio-dist
            path: portfolio/dist

        - name: Deploy to Cloudflare Pages (Preview)
          uses: cloudflare/pages-action@v1
          with:
            apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
            accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
            projectName: danieltarazona-portfolio
            directory: portfolio/dist
            gitHubToken: ${{ secrets.GITHUB_TOKEN }}

    deploy-production:
      name: Deploy Production
      needs: build
      runs-on: ubuntu-latest
      timeout-minutes: 10
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      environment:
        name: production
        url: https://danieltarazona.com

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Download build artifacts
          uses: actions/download-artifact@v4
          with:
            name: portfolio-dist
            path: portfolio/dist

        - name: Deploy to Cloudflare Pages (Production)
          uses: cloudflare/pages-action@v1
          with:
            apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
            accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
            projectName: danieltarazona-portfolio
            directory: portfolio/dist
            branch: main
            gitHubToken: ${{ secrets.GITHUB_TOKEN }}

        - name: Purge Cloudflare Cache
          run: |
            curl -X POST "https://api.cloudflare.com/client/v4/zones/${{ secrets.CLOUDFLARE_ZONE_ID }}/purge_cache" \
              -H "Authorization: Bearer ${{ secrets.CLOUDFLARE_API_TOKEN }}" \
              -H "Content-Type: application/json" \
              --data '{"purge_everything":true}'
  ```

#### Task 6.2.3: Store Frontend Deployment Workflow

- [ ] **Task 6.2.3**: Create GitHub Actions workflow for store frontend deployment to Cloudflare Pages

  **Create `.github/workflows/store-deploy.yml`:**

  ```yaml
  name: Deploy Store Frontend

  on:
    push:
      branches:
        - main
      paths:
        - 'store/**'
        - '.github/workflows/store-deploy.yml'
    pull_request:
      branches:
        - main
      paths:
        - 'store/**'
    workflow_dispatch:

  env:
    NODE_VERSION: '20'
    PNPM_VERSION: '8'

  jobs:
    lint-and-test:
      name: Lint & Test
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'
            cache-dependency-path: 'store/pnpm-lock.yaml'

        - name: Install dependencies
          working-directory: store
          run: pnpm install --frozen-lockfile

        - name: Run linter
          working-directory: store
          run: pnpm lint

        - name: Run type check
          working-directory: store
          run: pnpm typecheck

    build:
      name: Build Store
      needs: lint-and-test
      runs-on: ubuntu-latest
      timeout-minutes: 15

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'
            cache-dependency-path: 'store/pnpm-lock.yaml'

        - name: Install dependencies
          working-directory: store
          run: pnpm install --frozen-lockfile

        - name: Build Astro Storefront
          working-directory: store
          run: pnpm build
          env:
            SITE_URL: https://store.danieltarazona.com
            PUBLIC_MEDUSA_BACKEND_URL: https://api.danieltarazona.com
            PUBLIC_MEDUSA_PUBLISHABLE_KEY: ${{ secrets.MEDUSA_PUBLISHABLE_KEY }}

        - name: Upload build artifacts
          uses: actions/upload-artifact@v4
          with:
            name: store-dist
            path: store/dist
            retention-days: 1

    deploy-preview:
      name: Deploy Preview
      needs: build
      runs-on: ubuntu-latest
      timeout-minutes: 10
      if: github.event_name == 'pull_request'

      steps:
        - name: Download build artifacts
          uses: actions/download-artifact@v4
          with:
            name: store-dist
            path: store/dist

        - name: Deploy to Cloudflare Pages (Preview)
          uses: cloudflare/pages-action@v1
          with:
            apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
            accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
            projectName: danieltarazona-store
            directory: store/dist
            gitHubToken: ${{ secrets.GITHUB_TOKEN }}

    deploy-production:
      name: Deploy Production
      needs: build
      runs-on: ubuntu-latest
      timeout-minutes: 10
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      environment:
        name: store-production
        url: https://store.danieltarazona.com

      steps:
        - name: Download build artifacts
          uses: actions/download-artifact@v4
          with:
            name: store-dist
            path: store/dist

        - name: Deploy to Cloudflare Pages (Production)
          uses: cloudflare/pages-action@v1
          with:
            apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
            accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
            projectName: danieltarazona-store
            directory: store/dist
            branch: main
            gitHubToken: ${{ secrets.GITHUB_TOKEN }}
  ```

#### Task 6.2.4: Medusa Backend Deployment Workflow

- [ ] **Task 6.2.4**: Create GitHub Actions workflow for Medusa backend deployment to Coolify

  **Create `.github/workflows/medusa-deploy.yml`:**

  ```yaml
  name: Deploy Medusa Backend

  on:
    push:
      branches:
        - main
      paths:
        - 'medusa/**'
        - '.github/workflows/medusa-deploy.yml'
    workflow_dispatch:
      inputs:
        skip_tests:
          description: 'Skip tests before deployment'
          required: false
          default: 'false'
          type: boolean

  env:
    NODE_VERSION: '20'
    PNPM_VERSION: '8'

  jobs:
    test:
      name: Test Medusa Backend
      runs-on: ubuntu-latest
      timeout-minutes: 15
      if: ${{ github.event.inputs.skip_tests != 'true' }}

      services:
        postgres:
          image: postgres:15
          env:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: postgres
            POSTGRES_DB: medusa_test
          ports:
            - 5432:5432
          options: >-
            --health-cmd pg_isready
            --health-interval 10s
            --health-timeout 5s
            --health-retries 5

        redis:
          image: redis:7
          ports:
            - 6379:6379
          options: >-
            --health-cmd "redis-cli ping"
            --health-interval 10s
            --health-timeout 5s
            --health-retries 5

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'
            cache-dependency-path: 'medusa/pnpm-lock.yaml'

        - name: Install dependencies
          working-directory: medusa
          run: pnpm install --frozen-lockfile

        - name: Run database migrations
          working-directory: medusa
          run: pnpm medusa db:migrate
          env:
            DATABASE_URL: postgres://postgres:postgres@localhost:5432/medusa_test
            REDIS_URL: redis://localhost:6379

        - name: Run tests
          working-directory: medusa
          run: pnpm test
          env:
            DATABASE_URL: postgres://postgres:postgres@localhost:5432/medusa_test
            REDIS_URL: redis://localhost:6379
            JWT_SECRET: test-jwt-secret
            COOKIE_SECRET: test-cookie-secret

    deploy:
      name: Trigger Coolify Deployment
      needs: [test]
      runs-on: ubuntu-latest
      timeout-minutes: 5
      if: always() && (needs.test.result == 'success' || needs.test.result == 'skipped')
      environment:
        name: medusa-production
        url: https://api.danieltarazona.com

      steps:
        - name: Trigger Coolify Webhook
          run: |
            response=$(curl -s -w "\n%{http_code}" -X POST \
              "${{ secrets.COOLIFY_WEBHOOK_URL }}" \
              -H "Content-Type: application/json" \
              -H "X-Webhook-Secret: ${{ secrets.COOLIFY_WEBHOOK_SECRET }}" \
              -d '{
                "ref": "${{ github.ref }}",
                "sha": "${{ github.sha }}",
                "repository": "${{ github.repository }}",
                "pusher": "${{ github.actor }}"
              }')

            http_code=$(echo "$response" | tail -n 1)
            body=$(echo "$response" | head -n -1)

            echo "Response: $body"
            echo "HTTP Status: $http_code"

            if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
              echo "::error::Coolify webhook failed with status $http_code"
              exit 1
            fi

        - name: Wait for Deployment
          run: |
            echo "Waiting for Coolify deployment to complete..."
            sleep 30  # Give Coolify time to start the deployment

        - name: Health Check
          run: |
            max_attempts=10
            attempt=1

            while [ $attempt -le $max_attempts ]; do
              echo "Health check attempt $attempt of $max_attempts..."

              response=$(curl -s -o /dev/null -w "%{http_code}" \
                "https://api.danieltarazona.com/health" || echo "000")

              if [ "$response" = "200" ]; then
                echo "✅ Health check passed!"
                exit 0
              fi

              echo "Health check returned $response, waiting..."
              sleep 15
              attempt=$((attempt + 1))
            done

            echo "::warning::Health check did not pass within expected time"
            # Don't fail the job, just warn
  ```

#### Task 6.2.5: Unified CI/CD Workflow

- [ ] **Task 6.2.5**: Create a unified lint and test workflow for all projects

  **Create `.github/workflows/ci.yml`:**

  ```yaml
  name: CI Pipeline

  on:
    push:
      branches:
        - main
        - develop
    pull_request:
      branches:
        - main
        - develop

  env:
    NODE_VERSION: '20'
    PNPM_VERSION: '8'

  jobs:
    detect-changes:
      name: Detect Changes
      runs-on: ubuntu-latest
      outputs:
        portfolio: ${{ steps.filter.outputs.portfolio }}
        store: ${{ steps.filter.outputs.store }}
        medusa: ${{ steps.filter.outputs.medusa }}
        shared: ${{ steps.filter.outputs.shared }}

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Detect file changes
          uses: dorny/paths-filter@v2
          id: filter
          with:
            filters: |
              portfolio:
                - 'portfolio/**'
              store:
                - 'store/**'
              medusa:
                - 'medusa/**'
              shared:
                - 'packages/**'
                - 'package.json'
                - 'pnpm-lock.yaml'
                - 'pnpm-workspace.yaml'

    lint-portfolio:
      name: Lint Portfolio
      needs: detect-changes
      if: needs.detect-changes.outputs.portfolio == 'true' || needs.detect-changes.outputs.shared == 'true'
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'

        - name: Install dependencies
          run: pnpm install --frozen-lockfile

        - name: Lint portfolio
          working-directory: portfolio
          run: pnpm lint

        - name: Type check portfolio
          working-directory: portfolio
          run: pnpm typecheck

    lint-store:
      name: Lint Store
      needs: detect-changes
      if: needs.detect-changes.outputs.store == 'true' || needs.detect-changes.outputs.shared == 'true'
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'

        - name: Install dependencies
          run: pnpm install --frozen-lockfile

        - name: Lint store
          working-directory: store
          run: pnpm lint

        - name: Type check store
          working-directory: store
          run: pnpm typecheck

    lint-medusa:
      name: Lint Medusa
      needs: detect-changes
      if: needs.detect-changes.outputs.medusa == 'true' || needs.detect-changes.outputs.shared == 'true'
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'

        - name: Install dependencies
          run: pnpm install --frozen-lockfile

        - name: Lint medusa
          working-directory: medusa
          run: pnpm lint

        - name: Type check medusa
          working-directory: medusa
          run: pnpm typecheck

    build-check:
      name: Build Check
      needs: [detect-changes, lint-portfolio, lint-store, lint-medusa]
      if: always()
      runs-on: ubuntu-latest
      timeout-minutes: 20

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: ${{ env.PNPM_VERSION }}

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ env.NODE_VERSION }}
            cache: 'pnpm'

        - name: Install dependencies
          run: pnpm install --frozen-lockfile

        - name: Build portfolio
          if: needs.detect-changes.outputs.portfolio == 'true' || needs.detect-changes.outputs.shared == 'true'
          working-directory: portfolio
          run: pnpm build

        - name: Build store
          if: needs.detect-changes.outputs.store == 'true' || needs.detect-changes.outputs.shared == 'true'
          working-directory: store
          run: pnpm build

        - name: Build medusa
          if: needs.detect-changes.outputs.medusa == 'true' || needs.detect-changes.outputs.shared == 'true'
          working-directory: medusa
          run: pnpm build
  ```

#### Task 6.2.6: Cloudflare Pages Project Setup

- [ ] **Task 6.2.6**: Configure Cloudflare Pages projects via Wrangler CLI

  **Install and Configure Wrangler:**

  ```bash
  # Install Wrangler CLI globally
  npm install -g wrangler

  # Authenticate with Cloudflare
  wrangler login

  # Verify authentication
  wrangler whoami
  ```

  **Create Cloudflare Pages Project for Portfolio:**

  ```bash
  # Navigate to portfolio directory
  cd portfolio

  # Create Cloudflare Pages project
  wrangler pages project create danieltarazona-portfolio \
    --production-branch main

  # Deploy manually (first time)
  pnpm build
  wrangler pages deploy dist --project-name danieltarazona-portfolio
  ```

  **Create Cloudflare Pages Project for Store:**

  ```bash
  # Navigate to store directory
  cd store

  # Create Cloudflare Pages project
  wrangler pages project create danieltarazona-store \
    --production-branch main

  # Deploy manually (first time)
  pnpm build
  wrangler pages deploy dist --project-name danieltarazona-store
  ```

  **Configure Custom Domains:**

  ```bash
  # Add custom domain for portfolio
  wrangler pages project add-domain danieltarazona-portfolio danieltarazona.com

  # Add custom domain for store
  wrangler pages project add-domain danieltarazona-store store.danieltarazona.com

  # Verify DNS settings (Cloudflare will auto-configure if domain is on Cloudflare)
  ```

  **Environment Variables in Cloudflare Pages:**

  ```bash
  # Set production environment variables for portfolio
  wrangler pages secret put PUBLIC_SUPABASE_URL --project-name danieltarazona-portfolio
  wrangler pages secret put PUBLIC_SUPABASE_ANON_KEY --project-name danieltarazona-portfolio

  # Set production environment variables for store
  wrangler pages secret put PUBLIC_MEDUSA_BACKEND_URL --project-name danieltarazona-store
  wrangler pages secret put PUBLIC_MEDUSA_PUBLISHABLE_KEY --project-name danieltarazona-store
  ```

  **Pages Configuration File (`wrangler.toml` for each project):**

  ```toml
  # portfolio/wrangler.toml
  name = "danieltarazona-portfolio"
  compatibility_date = "2024-01-01"

  [site]
  bucket = "./dist"

  [env.production]
  vars = { ENVIRONMENT = "production" }

  [env.preview]
  vars = { ENVIRONMENT = "preview" }
  ```

  ```toml
  # store/wrangler.toml
  name = "danieltarazona-store"
  compatibility_date = "2024-01-01"

  [site]
  bucket = "./dist"

  [env.production]
  vars = { ENVIRONMENT = "production" }

  [env.preview]
  vars = { ENVIRONMENT = "preview" }
  ```

#### Task 6.2.7: Coolify Webhook Configuration

- [ ] **Task 6.2.7**: Configure Coolify webhooks for automated deployments

  **Enable Webhooks in Coolify:**

  1. Navigate to Coolify Dashboard → Applications → Medusa
  2. Go to "Webhooks" tab
  3. Enable "Deploy Webhook"
  4. Copy the webhook URL (format: `https://coolify.yourdomain.com/webhook/<uuid>`)
  5. Generate a webhook secret for authentication

  **Webhook Configuration Details:**

  | Setting | Value | Notes |
  |---------|-------|-------|
  | Webhook URL | `https://coolify.domain.com/webhook/<uuid>` | Unique per application |
  | Secret | Random string (32+ chars) | Store in GitHub Secrets |
  | Trigger | On webhook call | Manual or CI/CD triggered |

  **Alternative: Git-Based Deployments in Coolify:**

  If you prefer Coolify to poll GitHub directly (without webhooks):

  1. Coolify Dashboard → Applications → Medusa → General
  2. Set "Git Repository" to your GitHub repo
  3. Enable "Auto Deploy on Push"
  4. Coolify will automatically deploy when it detects changes

  **Coolify Deploy Key Setup (for Private Repos):**

  ```bash
  # Generate SSH key pair on Coolify server
  ssh-keygen -t ed25519 -C "coolify-deploy" -f ~/.ssh/coolify_deploy -N ""

  # Copy public key
  cat ~/.ssh/coolify_deploy.pub

  # Add as Deploy Key in GitHub:
  # Repository → Settings → Deploy keys → Add deploy key
  # Paste the public key, enable "Allow write access" if needed
  ```

#### Task 6.2.8: Deployment Notifications

- [ ] **Task 6.2.8**: Configure deployment notifications (optional)

  **Create `.github/workflows/notify.yml`:**

  ```yaml
  name: Deployment Notifications

  on:
    workflow_run:
      workflows:
        - "Deploy Portfolio Site"
        - "Deploy Store Frontend"
        - "Deploy Medusa Backend"
      types:
        - completed

  jobs:
    notify:
      name: Send Notification
      runs-on: ubuntu-latest
      timeout-minutes: 5

      steps:
        - name: Determine status
          id: status
          run: |
            if [ "${{ github.event.workflow_run.conclusion }}" = "success" ]; then
              echo "emoji=✅" >> $GITHUB_OUTPUT
              echo "status=succeeded" >> $GITHUB_OUTPUT
            else
              echo "emoji=❌" >> $GITHUB_OUTPUT
              echo "status=failed" >> $GITHUB_OUTPUT
            fi

        - name: Send Discord notification
          if: ${{ secrets.DISCORD_WEBHOOK_URL != '' }}
          run: |
            curl -H "Content-Type: application/json" \
              -d '{
                "content": null,
                "embeds": [{
                  "title": "${{ steps.status.outputs.emoji }} Deployment ${{ steps.status.outputs.status }}",
                  "description": "**Workflow:** ${{ github.event.workflow_run.name }}\n**Branch:** ${{ github.event.workflow_run.head_branch }}\n**Commit:** `${{ github.event.workflow_run.head_sha }}`",
                  "color": ${{ github.event.workflow_run.conclusion == 'success' && '3066993' || '15158332' }},
                  "timestamp": "${{ github.event.workflow_run.updated_at }}"
                }]
              }' \
              ${{ secrets.DISCORD_WEBHOOK_URL }}

        - name: Send Slack notification
          if: ${{ secrets.SLACK_WEBHOOK_URL != '' }}
          run: |
            curl -X POST -H "Content-Type: application/json" \
              -d '{
                "text": "${{ steps.status.outputs.emoji }} Deployment ${{ steps.status.outputs.status }}",
                "blocks": [
                  {
                    "type": "section",
                    "text": {
                      "type": "mrkdwn",
                      "text": "*${{ github.event.workflow_run.name }}* ${{ steps.status.outputs.status }}\n*Branch:* ${{ github.event.workflow_run.head_branch }}\n*Commit:* `${{ github.event.workflow_run.head_sha }}`"
                    }
                  }
                ]
              }' \
              ${{ secrets.SLACK_WEBHOOK_URL }}
  ```

#### Task 6.2.9: Scheduled Maintenance Workflows

- [ ] **Task 6.2.9**: Create scheduled maintenance workflows

  **Create `.github/workflows/maintenance.yml`:**

  ```yaml
  name: Scheduled Maintenance

  on:
    schedule:
      # Run daily at 3:00 AM UTC
      - cron: '0 3 * * *'
    workflow_dispatch:

  jobs:
    dependency-check:
      name: Check Dependencies
      runs-on: ubuntu-latest
      timeout-minutes: 10

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup pnpm
          uses: pnpm/action-setup@v2
          with:
            version: '8'

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: '20'
            cache: 'pnpm'

        - name: Install dependencies
          run: pnpm install --frozen-lockfile

        - name: Check for outdated packages
          run: pnpm outdated || true

        - name: Run security audit
          run: pnpm audit || true

    lighthouse-audit:
      name: Lighthouse Audit
      runs-on: ubuntu-latest
      timeout-minutes: 15

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Run Lighthouse CI
          uses: treosh/lighthouse-ci-action@v10
          with:
            urls: |
              https://danieltarazona.com
              https://store.danieltarazona.com
            uploadArtifacts: true
            temporaryPublicStorage: true

        - name: Check Lighthouse scores
          run: |
            echo "Lighthouse audit completed. Check artifacts for detailed reports."

    healthcheck:
      name: Health Check
      runs-on: ubuntu-latest
      timeout-minutes: 5

      steps:
        - name: Check Portfolio Site
          run: |
            status=$(curl -s -o /dev/null -w "%{http_code}" https://danieltarazona.com)
            if [ "$status" != "200" ]; then
              echo "::error::Portfolio site returned status $status"
              exit 1
            fi
            echo "✅ Portfolio site is healthy (HTTP $status)"

        - name: Check Store Site
          run: |
            status=$(curl -s -o /dev/null -w "%{http_code}" https://store.danieltarazona.com)
            if [ "$status" != "200" ]; then
              echo "::error::Store site returned status $status"
              exit 1
            fi
            echo "✅ Store site is healthy (HTTP $status)"

        - name: Check Medusa API
          run: |
            status=$(curl -s -o /dev/null -w "%{http_code}" https://api.danieltarazona.com/health)
            if [ "$status" != "200" ]; then
              echo "::warning::Medusa API returned status $status"
            else
              echo "✅ Medusa API is healthy (HTTP $status)"
            fi
  ```

#### Task 6.2.10: Workflow Best Practices

- [ ] **Task 6.2.10**: Implement GitHub Actions best practices

  **Security Best Practices:**

  | Practice | Implementation |
  |----------|----------------|
  | Least privilege | Use minimal permissions in `permissions:` block |
  | Pin action versions | Use SHA hashes instead of tags (e.g., `actions/checkout@a1b2c3d...`) |
  | Secrets management | Never log secrets, use `${{ secrets.* }}` |
  | Environment protection | Use GitHub Environments for production deployments |
  | Branch protection | Require PR reviews before merging to main |

  **Performance Best Practices:**

  | Practice | Implementation |
  |----------|----------------|
  | Caching | Use `actions/cache` or built-in caching (e.g., `actions/setup-node` cache) |
  | Parallelization | Run independent jobs concurrently |
  | Path filtering | Only run workflows when relevant files change |
  | Artifact passing | Use `actions/upload-artifact` and `download-artifact` between jobs |
  | Timeout limits | Set reasonable `timeout-minutes` on all jobs |

  **Workflow Structure Template:**

  ```yaml
  name: Descriptive Workflow Name

  on:
    # Define specific triggers
    push:
      branches: [main]
      paths: ['relevant/**']
    pull_request:
      branches: [main]
    workflow_dispatch:  # Allow manual triggers

  # Limit permissions to minimum required
  permissions:
    contents: read
    # Add other permissions as needed

  # Define reusable environment variables
  env:
    NODE_VERSION: '20'

  jobs:
    job-name:
      name: Human-Readable Job Name
      runs-on: ubuntu-latest
      timeout-minutes: 15  # Always set a timeout

      steps:
        - name: Descriptive step name
          uses: action/name@v1
          with:
            parameter: value
  ```

  **Reusable Workflows (`.github/workflows/reusable-build.yml`):**

  ```yaml
  name: Reusable Build Workflow

  on:
    workflow_call:
      inputs:
        project:
          required: true
          type: string
        node-version:
          required: false
          type: string
          default: '20'
      secrets:
        npm-token:
          required: false

  jobs:
    build:
      name: Build ${{ inputs.project }}
      runs-on: ubuntu-latest
      timeout-minutes: 15

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Setup Node.js
          uses: actions/setup-node@v4
          with:
            node-version: ${{ inputs.node-version }}

        - name: Install and build
          working-directory: ${{ inputs.project }}
          run: |
            npm ci
            npm run build
  ```

  **Using Reusable Workflows:**

  ```yaml
  name: Build All Projects

  on:
    push:
      branches: [main]

  jobs:
    build-portfolio:
      uses: ./.github/workflows/reusable-build.yml
      with:
        project: portfolio

    build-store:
      uses: ./.github/workflows/reusable-build.yml
      with:
        project: store
  ```

### Task 6.3: Direct Cloudflare Pages Deployment (Alternative to Coolify for Frontend)

This section covers deploying Astro static sites directly to Cloudflare Pages without using Coolify. This is the **recommended approach for frontend static sites** as it leverages Cloudflare's global edge network for optimal performance, eliminates VPS costs for static hosting, and provides built-in CI/CD with Git integration.

> **When to Use This Approach:**
> - Portfolio site (`danieltarazona.com`) - Always recommended
> - Store frontend (`store.danieltarazona.com`) - Recommended (client-side API calls to Medusa)
> - Any pure static or client-side rendered Astro site
>
> **When to Use Coolify Instead:**
> - Medusa 2.0 backend API (requires Node.js runtime)
> - Server-side rendered (SSR) Astro with dynamic data
> - Applications requiring persistent database connections

#### Cloudflare Pages vs Coolify Comparison

```
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT OPTIONS COMPARISON                                         │
├─────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                          │
│  OPTION A: Cloudflare Pages (Recommended for Static Sites)                              │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │  PROS:                              │  CONS:                                       │  │
│  │  ✅ Free tier (unlimited requests)  │  ⚠️  Limited to static/client-side          │  │
│  │  ✅ Global CDN (300+ PoPs)          │  ⚠️  500 builds/month (free tier)           │  │
│  │  ✅ Automatic Git deployments       │  ⚠️  No server-side runtime (use Workers)   │  │
│  │  ✅ Preview deployments per branch  │                                              │  │
│  │  ✅ Zero server maintenance         │                                              │  │
│  │  ✅ Built-in SSL/TLS                │                                              │  │
│  │  ✅ Instant cache invalidation      │                                              │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                          │
│  OPTION B: Coolify (Required for Backend Services)                                      │
│  ┌───────────────────────────────────────────────────────────────────────────────────┐  │
│  │  PROS:                              │  CONS:                                       │  │
│  │  ✅ Full server-side capabilities   │  ⚠️  Requires VPS (~$5-10/month)            │  │
│  │  ✅ Docker container support        │  ⚠️  Server maintenance required            │  │
│  │  ✅ Database hosting                │  ⚠️  Single point of failure (no CDN)       │  │
│  │  ✅ Background jobs                 │  ⚠️  Manual SSL configuration               │  │
│  │  ✅ Persistent storage              │  ⚠️  Cold starts possible                   │  │
│  └───────────────────────────────────────────────────────────────────────────────────┘  │
│                                                                                          │
│  RECOMMENDED ARCHITECTURE:                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────────────┐    │
│  │                                                                                  │    │
│  │  danieltarazona.com     ──────▶  Cloudflare Pages  (Static portfolio)           │    │
│  │                                                                                  │    │
│  │  store.danieltarazona.com ────▶  Cloudflare Pages  (Static storefront)          │    │
│  │         │                                                                        │    │
│  │         │ API calls (client-side)                                               │    │
│  │         ▼                                                                        │    │
│  │  api.danieltarazona.com  ─────▶  Coolify/VPS       (Medusa 2.0 backend)         │    │
│  │                                                                                  │    │
│  └─────────────────────────────────────────────────────────────────────────────────┘    │
│                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

#### Task 6.3.1: Cloudflare Pages Project Creation

- [ ] **Task 6.3.1**: Create Cloudflare Pages projects via Dashboard

  **Method 1: Cloudflare Dashboard (Recommended for Initial Setup)**

  1. Log in to [Cloudflare Dashboard](https://dash.cloudflare.com)
  2. Navigate to **Workers & Pages** → **Pages**
  3. Click **Create a project** → **Connect to Git**
  4. Authorize Cloudflare to access your GitHub account
  5. Select your repository (e.g., `DanielTarazona/portfolio`)

  **Project Configuration:**

  | Setting | Portfolio Site | Store Frontend |
  |---------|----------------|----------------|
  | Project name | `danieltarazona-portfolio` | `danieltarazona-store` |
  | Production branch | `main` | `main` |
  | Build command | `npm run build` | `npm run build` |
  | Build output directory | `dist` | `dist` |
  | Root directory | `/portfolio` (if monorepo) | `/store` (if monorepo) |
  | Node.js version | `20` | `20` |

  **Build Settings for Astro:**

  ```
  Framework preset: Astro
  Build command: npm run build
  Build output directory: dist
  ```

  **Environment Variables (Set in Pages Dashboard):**

  | Variable | Portfolio Site | Store Frontend |
  |----------|----------------|----------------|
  | `NODE_VERSION` | `20` | `20` |
  | `PUBLIC_SITE_URL` | `https://danieltarazona.com` | `https://store.danieltarazona.com` |
  | `PUBLIC_SUPABASE_URL` | `https://xxx.supabase.co` | - |
  | `PUBLIC_SUPABASE_ANON_KEY` | `eyJhbG...` | - |
  | `PUBLIC_MEDUSA_BACKEND_URL` | - | `https://api.danieltarazona.com` |
  | `PUBLIC_MEDUSA_PUBLISHABLE_KEY` | - | `pk_xxx...` |

#### Task 6.3.2: Wrangler CLI Deployment Setup

- [ ] **Task 6.3.2**: Configure Wrangler CLI for Cloudflare Pages deployments

  **Install and Authenticate Wrangler:**

  ```bash
  # Install Wrangler globally
  npm install -g wrangler

  # Authenticate with Cloudflare
  wrangler login

  # Verify authentication
  wrangler whoami
  ```

  **Create Pages Project via CLI:**

  ```bash
  # Create portfolio site project
  wrangler pages project create danieltarazona-portfolio \
    --production-branch main

  # Create store frontend project
  wrangler pages project create danieltarazona-store \
    --production-branch main
  ```

  **Manual Deployment via CLI:**

  ```bash
  # Build and deploy portfolio site
  cd portfolio
  npm run build
  wrangler pages deploy dist --project-name danieltarazona-portfolio

  # Build and deploy store frontend
  cd ../store
  npm run build
  wrangler pages deploy dist --project-name danieltarazona-store
  ```

  **Preview Deployment (for branches/PRs):**

  ```bash
  # Deploy preview for feature branch
  wrangler pages deploy dist \
    --project-name danieltarazona-portfolio \
    --branch feature/new-gallery
  ```

#### Task 6.3.3: Git Integration Setup

- [ ] **Task 6.3.3**: Configure automatic Git deployments for Cloudflare Pages

  **Automatic Deployments Architecture:**

  ```
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │                         GIT-BASED DEPLOYMENT FLOW                               │
  └─────────────────────────────────────────────────────────────────────────────────┘

        GitHub Repository                     Cloudflare Pages
  ┌───────────────────────────┐         ┌───────────────────────────┐
  │                           │         │                           │
  │  main branch              │────────▶│  Production deployment    │
  │  (push/merge)             │  auto   │  (danieltarazona.com)     │
  │                           │         │                           │
  │  feature/* branches       │────────▶│  Preview deployments      │
  │  (push)                   │  auto   │  (xxx.pages.dev)          │
  │                           │         │                           │
  │  Pull Requests            │────────▶│  Preview + Comment        │
  │  (open/update)            │  auto   │  (link in PR comments)    │
  │                           │         │                           │
  └───────────────────────────┘         └───────────────────────────┘
  ```

  **Configure Git Integration:**

  1. In Cloudflare Dashboard → Pages → Your Project → Settings
  2. Navigate to **Builds & deployments**
  3. Configure the following:

  | Setting | Value | Description |
  |---------|-------|-------------|
  | Production branch | `main` | Deploys to custom domain |
  | Preview branches | `All non-production branches` | Creates preview URLs |
  | Branch deploy controls | Include: `*` | Deploy all branches |
  | Build comments | `Enabled` | Post preview URLs to PRs |

  **Branch-Specific Build Configuration:**

  Create `wrangler.toml` in your project root:

  ```toml
  # portfolio/wrangler.toml
  name = "danieltarazona-portfolio"
  compatibility_date = "2024-01-01"

  [site]
  bucket = "./dist"

  # Production environment
  [env.production]
  vars = { ENVIRONMENT = "production" }

  # Preview environment (non-production branches)
  [env.preview]
  vars = { ENVIRONMENT = "preview" }
  ```

  **Build Watch Paths (Optimize Build Triggers):**

  In Cloudflare Dashboard → Pages → Settings → Build watch paths:

  ```
  # Only trigger builds when these paths change
  portfolio/**
  package.json
  pnpm-lock.yaml
  ```

#### Task 6.3.4: Custom Domain Configuration

- [ ] **Task 6.3.4**: Configure custom domains for Cloudflare Pages sites

  **Add Custom Domain:**

  ```bash
  # Via Cloudflare Dashboard:
  # Pages → Project → Custom domains → Set up a custom domain

  # Or via API:
  curl -X POST "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}/domains" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"name": "danieltarazona.com"}'
  ```

  **Domain Configuration Table:**

  | Domain | Pages Project | DNS Record |
  |--------|---------------|------------|
  | `danieltarazona.com` | `danieltarazona-portfolio` | CNAME → `danieltarazona-portfolio.pages.dev` |
  | `www.danieltarazona.com` | `danieltarazona-portfolio` | CNAME → `danieltarazona-portfolio.pages.dev` |
  | `store.danieltarazona.com` | `danieltarazona-store` | CNAME → `danieltarazona-store.pages.dev` |

  **DNS Records (Auto-configured if domain is on Cloudflare):**

  ```bash
  # If domain is already on Cloudflare, DNS records are auto-configured
  # If using external DNS, add these CNAME records:

  # Portfolio site
  # Type: CNAME | Name: @ | Target: danieltarazona-portfolio.pages.dev | Proxy: Yes

  # WWW redirect
  # Type: CNAME | Name: www | Target: danieltarazona-portfolio.pages.dev | Proxy: Yes

  # Store subdomain
  # Type: CNAME | Name: store | Target: danieltarazona-store.pages.dev | Proxy: Yes
  ```

  **SSL/TLS Configuration (Automatic):**

  Cloudflare Pages automatically provisions and renews SSL certificates for custom domains. No manual configuration required.

  | Feature | Status |
  |---------|--------|
  | SSL Certificate | ✅ Auto-provisioned |
  | TLS 1.3 | ✅ Enabled by default |
  | HTTPS Redirect | ✅ Automatic |
  | HSTS | ✅ Configurable |

#### Task 6.3.5: Environment Variables Management

- [ ] **Task 6.3.5**: Configure environment variables for Cloudflare Pages

  **Set Environment Variables via Dashboard:**

  1. Cloudflare Dashboard → Pages → Project → Settings → Environment variables
  2. Add variables for Production and Preview separately

  **Set Environment Variables via Wrangler CLI:**

  ```bash
  # Set production environment variable (plaintext)
  wrangler pages secret put PUBLIC_SITE_URL \
    --project-name danieltarazona-portfolio

  # When prompted, enter: https://danieltarazona.com

  # Set production secrets (encrypted)
  wrangler pages secret put PUBLIC_SUPABASE_ANON_KEY \
    --project-name danieltarazona-portfolio

  # List all secrets
  wrangler pages secret list --project-name danieltarazona-portfolio
  ```

  **Environment Variable Categories:**

  | Category | Prefix | Example | Notes |
  |----------|--------|---------|-------|
  | Public (client-safe) | `PUBLIC_` | `PUBLIC_SITE_URL` | Bundled into client JavaScript |
  | Secret (server-only) | None | `SUPABASE_SERVICE_KEY` | Only in Cloudflare Functions |

  **Portfolio Site Environment Variables:**

  ```bash
  # Production
  PUBLIC_SITE_URL=https://danieltarazona.com
  PUBLIC_SUPABASE_URL=https://xxx.supabase.co
  PUBLIC_SUPABASE_ANON_KEY=eyJhbG...

  # Preview
  PUBLIC_SITE_URL=https://xxx.danieltarazona-portfolio.pages.dev
  PUBLIC_SUPABASE_URL=https://xxx.supabase.co
  PUBLIC_SUPABASE_ANON_KEY=eyJhbG...
  ```

  **Store Frontend Environment Variables:**

  ```bash
  # Production
  PUBLIC_SITE_URL=https://store.danieltarazona.com
  PUBLIC_MEDUSA_BACKEND_URL=https://api.danieltarazona.com
  PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_xxx...

  # Preview
  PUBLIC_SITE_URL=https://xxx.danieltarazona-store.pages.dev
  PUBLIC_MEDUSA_BACKEND_URL=https://api.danieltarazona.com  # Or staging API
  PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_xxx...
  ```

#### Task 6.3.6: Cloudflare Pages Functions (Serverless API Routes)

- [ ] **Task 6.3.6**: Set up Cloudflare Pages Functions for server-side logic

  **Pages Functions Overview:**

  Cloudflare Pages Functions allow you to add serverless API endpoints to your static site without a separate backend server. These run on Cloudflare's edge network.

  ```
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │                    PAGES FUNCTIONS ARCHITECTURE                                  │
  └─────────────────────────────────────────────────────────────────────────────────┘

  Project Structure:
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │  portfolio/                                                                      │
  │  ├── src/                    (Astro source files)                               │
  │  │   ├── pages/                                                                 │
  │  │   └── components/                                                            │
  │  ├── functions/              (Cloudflare Pages Functions)                       │
  │  │   └── api/                                                                   │
  │  │       ├── contact.ts      → /api/contact                                     │
  │  │       ├── newsletter.ts   → /api/newsletter                                  │
  │  │       └── health.ts       → /api/health                                      │
  │  ├── dist/                   (Build output)                                     │
  │  └── package.json                                                               │
  └─────────────────────────────────────────────────────────────────────────────────┘
  ```

  **Create Contact Form API Endpoint:**

  Create `portfolio/functions/api/contact.ts`:

  ```typescript
  /**
   * Contact Form API Endpoint
   * Handles contact form submissions and stores in Supabase
   *
   * Route: POST /api/contact
   */

  interface ContactFormData {
    name: string;
    email: string;
    subject?: string;
    message: string;
  }

  interface Env {
    SUPABASE_URL: string;
    SUPABASE_SERVICE_KEY: string;
  }

  export const onRequestPost: PagesFunction<Env> = async (context) => {
    const { request, env } = context;

    // CORS headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    };

    // Handle preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // Parse form data
      const formData: ContactFormData = await request.json();

      // Validate required fields
      if (!formData.name || !formData.email || !formData.message) {
        return new Response(
          JSON.stringify({ error: 'Missing required fields' }),
          {
            status: 400,
            headers: { 'Content-Type': 'application/json', ...corsHeaders },
          }
        );
      }

      // Validate email format
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(formData.email)) {
        return new Response(
          JSON.stringify({ error: 'Invalid email format' }),
          {
            status: 400,
            headers: { 'Content-Type': 'application/json', ...corsHeaders },
          }
        );
      }

      // Store in Supabase
      const supabaseResponse = await fetch(
        `${env.SUPABASE_URL}/rest/v1/contact_submissions`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': env.SUPABASE_SERVICE_KEY,
            'Authorization': `Bearer ${env.SUPABASE_SERVICE_KEY}`,
            'Prefer': 'return=minimal',
          },
          body: JSON.stringify({
            name: formData.name,
            email: formData.email,
            subject: formData.subject || 'Contact Form Submission',
            message: formData.message,
            submitted_at: new Date().toISOString(),
          }),
        }
      );

      if (!supabaseResponse.ok) {
        throw new Error('Failed to store submission');
      }

      return new Response(
        JSON.stringify({ success: true, message: 'Form submitted successfully' }),
        {
          status: 200,
          headers: { 'Content-Type': 'application/json', ...corsHeaders },
        }
      );
    } catch (error) {
      console.error('Contact form error:', error);
      return new Response(
        JSON.stringify({ error: 'Internal server error' }),
        {
          status: 500,
          headers: { 'Content-Type': 'application/json', ...corsHeaders },
        }
      );
    }
  };
  ```

  **Create Health Check Endpoint:**

  Create `portfolio/functions/api/health.ts`:

  ```typescript
  /**
   * Health Check Endpoint
   * Route: GET /api/health
   */

  export const onRequestGet: PagesFunction = async () => {
    return new Response(
      JSON.stringify({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        service: 'danieltarazona-portfolio',
      }),
      {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  };
  ```

  **Configure Functions Secrets:**

  ```bash
  # Set server-only secrets for Pages Functions
  wrangler pages secret put SUPABASE_URL --project-name danieltarazona-portfolio
  wrangler pages secret put SUPABASE_SERVICE_KEY --project-name danieltarazona-portfolio
  ```

#### Task 6.3.7: Build Configuration and Optimization

- [ ] **Task 6.3.7**: Optimize Astro build configuration for Cloudflare Pages

  **Astro Configuration for Cloudflare Pages:**

  Update `portfolio/astro.config.mjs`:

  ```javascript
  import { defineConfig } from 'astro/config';
  import cloudflare from '@astrojs/cloudflare';
  import sitemap from '@astrojs/sitemap';

  export default defineConfig({
    // Site URL for sitemap and canonical URLs
    site: 'https://danieltarazona.com',

    // Output mode: 'static' for pure static, 'server' for SSR
    output: 'static',  // Use 'static' for Cloudflare Pages static hosting

    // Use Cloudflare adapter only if using SSR features
    // adapter: cloudflare(),  // Uncomment for SSR mode

    integrations: [
      sitemap(),
    ],

    build: {
      // Inline stylesheets smaller than this limit
      inlineStylesheets: 'auto',
    },

    vite: {
      build: {
        // Optimize chunk size for edge delivery
        rollupOptions: {
          output: {
            manualChunks: {
              // Split vendor chunks for better caching
              vendor: ['astro'],
            },
          },
        },
      },
    },
  });
  ```

  **Store Frontend Configuration:**

  Update `store/astro.config.mjs`:

  ```javascript
  import { defineConfig } from 'astro/config';
  import react from '@astrojs/react';
  import tailwind from '@astrojs/tailwind';
  import sitemap from '@astrojs/sitemap';

  export default defineConfig({
    site: 'https://store.danieltarazona.com',
    output: 'static',

    integrations: [
      react(),
      tailwind(),
      sitemap(),
    ],

    vite: {
      define: {
        // Make env vars available at build time
        'import.meta.env.PUBLIC_MEDUSA_BACKEND_URL': JSON.stringify(
          process.env.PUBLIC_MEDUSA_BACKEND_URL
        ),
      },
    },
  });
  ```

  **Build Output Optimization:**

  Create `portfolio/_headers` file for custom headers:

  ```
  # Cache static assets for 1 year
  /assets/*
    Cache-Control: public, max-age=31536000, immutable

  # Cache images for 1 week
  /images/*
    Cache-Control: public, max-age=604800

  # Security headers for all pages
  /*
    X-Content-Type-Options: nosniff
    X-Frame-Options: DENY
    X-XSS-Protection: 1; mode=block
    Referrer-Policy: strict-origin-when-cross-origin
    Permissions-Policy: camera=(), microphone=(), geolocation=()
  ```

  Create `portfolio/_redirects` file for URL redirects:

  ```
  # WWW to non-WWW redirect
  https://www.danieltarazona.com/* https://danieltarazona.com/:splat 301

  # Legacy URL redirects
  /portfolio/* /gallery/:splat 301
  /blog /articles 301

  # SPA fallback (if using client-side routing)
  # /* /index.html 200
  ```

#### Task 6.3.8: Deployment Monitoring and Analytics

- [ ] **Task 6.3.8**: Set up monitoring and analytics for Cloudflare Pages deployments

  **Cloudflare Web Analytics (Free):**

  1. Cloudflare Dashboard → Analytics → Web Analytics
  2. Click **Add a site** → Select your Pages project
  3. Copy the tracking snippet to your Astro layout

  ```html
  <!-- Add to portfolio/src/layouts/BaseLayout.astro -->
  <script
    defer
    src="https://static.cloudflareinsights.com/beacon.min.js"
    data-cf-beacon='{"token": "YOUR_SITE_TOKEN"}'
  ></script>
  ```

  **Deployment Notifications:**

  Configure deployment notifications in Cloudflare Dashboard:

  1. Pages → Project → Settings → Notifications
  2. Add notification channels:

  | Channel | Trigger | Configuration |
  |---------|---------|---------------|
  | Email | Deploy success/failure | team@danieltarazona.com |
  | Webhook | Deploy success/failure | Discord/Slack webhook URL |

  **Monitor Build Logs:**

  ```bash
  # View recent deployments
  wrangler pages deployment list --project-name danieltarazona-portfolio

  # View specific deployment logs
  wrangler pages deployment tail --project-name danieltarazona-portfolio
  ```

  **Real-time Logs for Pages Functions:**

  ```bash
  # Stream logs from Pages Functions
  wrangler pages deployment tail \
    --project-name danieltarazona-portfolio \
    --format pretty
  ```

#### Task 6.3.9: Preview Deployments and Branch Protection

- [ ] **Task 6.3.9**: Configure preview deployments and branch protection rules

  **Preview Deployment URLs:**

  Cloudflare Pages automatically creates preview deployments for each branch:

  | Branch | Preview URL |
  |--------|-------------|
  | `feature/gallery` | `feature-gallery.danieltarazona-portfolio.pages.dev` |
  | `fix/contact-form` | `fix-contact-form.danieltarazona-portfolio.pages.dev` |
  | PR #123 | `pr-123.danieltarazona-portfolio.pages.dev` |

  **Branch Protection Configuration:**

  1. Cloudflare Dashboard → Pages → Settings → Builds & deployments
  2. Configure branch controls:

  | Setting | Value |
  |---------|-------|
  | Production branch | `main` |
  | Preview branch exclusions | `dependabot/*`, `renovate/*` |
  | Skip deployments pattern | `[skip ci]`, `[skip deploy]` |

  **Access Control for Previews:**

  Enable Cloudflare Access for preview deployments (optional):

  1. Zero Trust Dashboard → Access → Applications → Add an application
  2. Select **Self-hosted** → Configure for `*.danieltarazona-portfolio.pages.dev`
  3. Add policy: Allow only team members

  ```
  # Access Policy Example
  Application: Preview Deployments
  Domain: *.danieltarazona-portfolio.pages.dev
  Policy: Allow
  - Email ending in: @danieltarazona.com
  - GitHub organization: DanielTarazona
  ```

#### Task 6.3.10: Rollback and Deployment Management

- [ ] **Task 6.3.10**: Set up deployment rollback procedures

  **View Deployment History:**

  ```bash
  # List all deployments
  wrangler pages deployment list \
    --project-name danieltarazona-portfolio

  # Output example:
  # Deployment ID          | Branch | Status  | Created
  # abc123-def456-...      | main   | Success | 2024-01-15 10:30
  # xyz789-uvw012-...      | main   | Success | 2024-01-14 15:45
  ```

  **Rollback to Previous Deployment:**

  Via Cloudflare Dashboard:
  1. Pages → Project → Deployments
  2. Find the deployment to restore
  3. Click **...** → **Rollback to this deploy**

  Via API:

  ```bash
  # Rollback to specific deployment
  curl -X POST \
    "https://api.cloudflare.com/client/v4/accounts/{account_id}/pages/projects/{project_name}/deployments/{deployment_id}/rollback" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN"
  ```

  **Deployment Retention:**

  | Deployment Type | Retention Period |
  |-----------------|------------------|
  | Production | 30 days (configurable) |
  | Preview | 7 days (auto-cleanup) |
  | Aliased | Indefinite |

### Task 6.3: Cloudflare Pages Deployment - Task Summary

| Task ID | Description | Status |
|---------|-------------|--------|
| 6.3.1 | Create Cloudflare Pages projects via Dashboard | [ ] |
| 6.3.2 | Configure Wrangler CLI for deployments | [ ] |
| 6.3.3 | Configure automatic Git deployments | [ ] |
| 6.3.4 | Configure custom domains | [ ] |
| 6.3.5 | Set up environment variables | [ ] |
| 6.3.6 | Set up Cloudflare Pages Functions | [ ] |
| 6.3.7 | Optimize Astro build configuration | [ ] |
| 6.3.8 | Set up monitoring and analytics | [ ] |
| 6.3.9 | Configure preview deployments and branch protection | [ ] |
| 6.3.10 | Set up deployment rollback procedures | [ ] |

### Cloudflare Pages Resources & Documentation

| Resource | URL |
|----------|-----|
| Cloudflare Pages Documentation | https://developers.cloudflare.com/pages |
| Pages Functions | https://developers.cloudflare.com/pages/platform/functions |
| Astro + Cloudflare Guide | https://docs.astro.build/en/guides/deploy/cloudflare/ |
| Wrangler CLI Reference | https://developers.cloudflare.com/workers/wrangler/commands |
| Custom Domains | https://developers.cloudflare.com/pages/platform/custom-domains |
| Build Configuration | https://developers.cloudflare.com/pages/platform/build-configuration |
| Preview Deployments | https://developers.cloudflare.com/pages/platform/preview-deployments |
| Pages Limits | https://developers.cloudflare.com/pages/platform/limits |

### Phase 5: Deployment & Orchestration - Task Summary

| Task ID | Description | Status |
|---------|-------------|--------|
| 6.1.1 | Prepare VPS prerequisites | [ ] |
| 6.1.2 | Install Docker Engine | [ ] |
| 6.1.3 | Install Coolify platform | [ ] |
| 6.1.4 | Complete initial Coolify setup | [ ] |
| 6.1.5 | Connect GitHub repository | [ ] |
| 6.1.6 | Deploy Medusa 2.0 application | [ ] |
| 6.1.7 | Configure PostgreSQL database | [ ] |
| 6.1.8 | Configure Redis cache | [ ] |
| 6.1.9 | Set up environment variables | [ ] |
| 6.1.10 | Configure deployment settings | [ ] |
| 6.1.11 | Integrate Cloudflare Tunnel | [ ] |
| 6.1.12 | Set up automated backups | [ ] |
| 6.1.13 | Configure monitoring and logging | [ ] |
| 6.1.14 | Set up scaling options | [ ] |
| 6.2.1 | Configure GitHub repository secrets | [ ] |
| 6.2.2 | Create portfolio site deployment workflow | [ ] |
| 6.2.3 | Create store frontend deployment workflow | [ ] |
| 6.2.4 | Create Medusa backend deployment workflow | [ ] |
| 6.2.5 | Create unified CI/CD workflow | [ ] |
| 6.2.6 | Configure Cloudflare Pages projects | [ ] |
| 6.2.7 | Configure Coolify webhooks | [ ] |
| 6.2.8 | Configure deployment notifications | [ ] |
| 6.2.9 | Create scheduled maintenance workflows | [ ] |
| 6.2.10 | Implement GitHub Actions best practices | [ ] |
| 6.3.1 | Create Cloudflare Pages projects via Dashboard | [ ] |
| 6.3.2 | Configure Wrangler CLI for deployments | [ ] |
| 6.3.3 | Configure automatic Git deployments | [ ] |
| 6.3.4 | Configure custom domains | [ ] |
| 6.3.5 | Set up environment variables | [ ] |
| 6.3.6 | Set up Cloudflare Pages Functions | [ ] |
| 6.3.7 | Optimize Astro build configuration | [ ] |
| 6.3.8 | Set up monitoring and analytics | [ ] |
| 6.3.9 | Configure preview deployments and branch protection | [ ] |
| 6.3.10 | Set up deployment rollback procedures | [ ] |

### Coolify Resources & Documentation

| Resource | URL |
|----------|-----|
| Coolify Documentation | https://coolify.io/docs |
| Coolify GitHub | https://github.com/coollabsio/coolify |
| Coolify Discord | https://discord.gg/coolify |
| Docker Documentation | https://docs.docker.com/ |
| Traefik Documentation | https://doc.traefik.io/traefik/ |
| Cloudflare Tunnel | https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/ |

### GitHub Actions Resources & Documentation

| Resource | URL |
|----------|-----|
| GitHub Actions Documentation | https://docs.github.com/en/actions |
| GitHub Actions Marketplace | https://github.com/marketplace?type=actions |
| Workflow Syntax Reference | https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions |
| Cloudflare Pages Action | https://github.com/cloudflare/pages-action |
| Reusable Workflows | https://docs.github.com/en/actions/using-workflows/reusing-workflows |
| GitHub Environments | https://docs.github.com/en/actions/deployment/targeting-different-environments |
| Security Hardening | https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions |
| Secrets Management | https://docs.github.com/en/actions/security-guides/encrypted-secrets |
| GitHub CLI | https://cli.github.com/ |
| Wrangler CLI | https://developers.cloudflare.com/workers/wrangler/ |

---

## Appendix A: Comprehensive Environment Variables Reference

This appendix provides a consolidated reference of all environment variables used across the project stack. Each service has its own `.env` file with variables specific to its functionality.

### Service Overview

| Service | Environment File | Purpose |
|---------|------------------|---------|
| **Astro Portfolio** | `portfolio/.env` | Portfolio site configuration |
| **Astro Storefront** | `store/.env` | E-commerce storefront configuration |
| **Medusa Backend** | `medusa-backend/.env` | Headless commerce API configuration |
| **Deno Functions** | `deno-functions/.env` | Serverless functions configuration |
| **Cloudflare Workers** | `workers/wrangler.toml` | Edge workers configuration |
| **GitHub Actions** | Repository Secrets | CI/CD pipeline secrets |
| **Coolify** | Application Settings | Deployment environment |

---

### Astro Portfolio Site (`portfolio/.env`)

Environment variables for the main portfolio and photo gallery site at `danieltarazona.com`.

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `PUBLIC_SITE_URL` | Yes | Public URL of the portfolio site | `https://danieltarazona.com` |
| `PUBLIC_CONTACT_EMAIL` | Yes | Contact email displayed on site | `contact@danieltarazona.com` |
| `SUPABASE_URL` | Yes | Supabase project URL for contact form | `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Yes | Supabase anonymous key (public) | `eyJhbGciOi...` |
| `SUPABASE_SERVICE_ROLE_KEY` | No | Supabase service role key (server-only) | `eyJhbGciOi...` |
| `PUBLIC_ANALYTICS_ID` | No | Google Analytics or Plausible ID | `G-XXXXXXXXXX` |
| `PUBLIC_TWITTER_HANDLE` | No | Twitter/X handle for social meta | `@danieltarazona` |
| `PUBLIC_GITHUB_URL` | No | GitHub profile URL | `https://github.com/danieltarazona` |
| `PUBLIC_LINKEDIN_URL` | No | LinkedIn profile URL | `https://linkedin.com/in/danieltarazona` |

**Example `.env` file:**

```bash
# ===========================================
# ASTRO PORTFOLIO ENVIRONMENT VARIABLES
# ===========================================

# Site Configuration
PUBLIC_SITE_URL=https://danieltarazona.com
PUBLIC_CONTACT_EMAIL=contact@danieltarazona.com

# Supabase Configuration (Contact Form)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
# Server-only (NEVER expose in client code)
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Analytics (Optional)
PUBLIC_ANALYTICS_ID=G-XXXXXXXXXX

# Social Links (Optional)
PUBLIC_TWITTER_HANDLE=@danieltarazona
PUBLIC_GITHUB_URL=https://github.com/danieltarazona
PUBLIC_LINKEDIN_URL=https://linkedin.com/in/danieltarazona
```

---

### Astro Storefront (`store/.env`)

Environment variables for the e-commerce storefront at `store.danieltarazona.com`.

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `PUBLIC_SITE_URL` | Yes | Public URL of the store | `https://store.danieltarazona.com` |
| `PUBLIC_SITE_NAME` | Yes | Store display name | `Daniel Tarazona Store` |
| `PUBLIC_MEDUSA_BACKEND_URL` | Yes | Medusa API endpoint URL | `https://api.danieltarazona.com` |
| `PUBLIC_MEDUSA_PUBLISHABLE_KEY` | Yes | Medusa publishable API key | `pk_xxxxxxxxxxxxx` |
| `PUBLIC_STRIPE_KEY` | No | Stripe publishable key (client-side) | `pk_live_xxxxxxxxx` |
| `PUBLIC_GA_TRACKING_ID` | No | Google Analytics tracking ID | `G-XXXXXXXXXX` |
| `PUBLIC_PLAUSIBLE_DOMAIN` | No | Plausible Analytics domain | `store.danieltarazona.com` |
| `PUBLIC_ENABLE_REVIEWS` | No | Enable product reviews feature | `true` or `false` |
| `PUBLIC_ENABLE_WISHLIST` | No | Enable wishlist feature | `true` or `false` |
| `PUBLIC_ENABLE_CUSTOMER_ACCOUNTS` | No | Enable customer accounts | `true` or `false` |
| `PUBLIC_IMAGE_CDN_URL` | No | Custom image CDN URL | `https://images.danieltarazona.com` |

**Example `.env` file:**

```bash
# ===========================================
# ASTRO STOREFRONT ENVIRONMENT VARIABLES
# ===========================================

# Site Configuration
PUBLIC_SITE_URL=https://store.danieltarazona.com
PUBLIC_SITE_NAME="Daniel Tarazona Store"

# Medusa Backend Configuration
PUBLIC_MEDUSA_BACKEND_URL=https://api.danieltarazona.com
PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_xxxxxxxxxxxxx

# Stripe Configuration (Client-Side)
PUBLIC_STRIPE_KEY=pk_live_xxxxxxxxx

# Analytics (Optional)
PUBLIC_GA_TRACKING_ID=G-XXXXXXXXXX
PUBLIC_PLAUSIBLE_DOMAIN=store.danieltarazona.com

# Feature Flags
PUBLIC_ENABLE_REVIEWS=false
PUBLIC_ENABLE_WISHLIST=false
PUBLIC_ENABLE_CUSTOMER_ACCOUNTS=true

# CDN Configuration (Optional)
PUBLIC_IMAGE_CDN_URL=https://images.danieltarazona.com
```

---

### Medusa 2.0 Backend (`medusa-backend/.env`)

Environment variables for the Medusa 2.0 headless commerce backend.

#### Core Configuration

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `NODE_ENV` | Yes | Node.js environment | `development` or `production` |
| `PORT` | No | Server port (default: 9000) | `9000` |
| `MEDUSA_BACKEND_URL` | Yes | Public backend URL | `https://api.danieltarazona.com` |
| `MEDUSA_WORKER_MODE` | No | Worker mode configuration | `shared`, `server`, or `worker` |

#### Database Configuration

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string | `postgresql://user:pass@host:5432/db` |
| `DB_NAME` | No | Database name (if not in URL) | `danieltarazona_store` |
| `REDIS_URL` | Yes | Redis connection URL | `redis://localhost:6379` |

#### Security & Authentication

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `JWT_SECRET` | Yes | JWT signing secret (64+ chars) | `openssl rand -hex 64` |
| `COOKIE_SECRET` | Yes | Cookie signing secret (64+ chars) | `openssl rand -hex 64` |

#### CORS Configuration

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `STORE_CORS` | Yes | Allowed origins for store API | `https://store.danieltarazona.com` |
| `ADMIN_CORS` | Yes | Allowed origins for admin API | `https://admin.danieltarazona.com` |
| `AUTH_CORS` | Yes | Allowed origins for auth endpoints | `https://store.danieltarazona.com,https://admin.danieltarazona.com` |

#### Admin Dashboard

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `ADMIN_PATH` | No | Admin dashboard URL path | `/app` |
| `DISABLE_MEDUSA_ADMIN` | No | Disable built-in admin | `true` or `false` |

#### Payment Providers

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `STRIPE_API_KEY` | No | Stripe secret API key | `sk_live_xxxxxxxxx` |
| `STRIPE_WEBHOOK_SECRET` | No | Stripe webhook signing secret | `whsec_xxxxxxxxx` |

#### Email Configuration

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `SMTP_HOST` | No | SMTP server hostname | `smtp.resend.com` |
| `SMTP_PORT` | No | SMTP server port | `465` |
| `SMTP_USER` | No | SMTP username | `resend` |
| `SMTP_PASSWORD` | No | SMTP password/API key | `re_xxxxxxxxxxxxx` |
| `SMTP_FROM` | No | Default "from" email address | `store@danieltarazona.com` |

#### File Storage (S3-Compatible)

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `S3_URL` | No | S3-compatible endpoint URL | `https://xxxx.r2.cloudflarestorage.com` |
| `S3_BUCKET` | No | S3 bucket name | `medusa-files` |
| `S3_REGION` | No | S3 region | `auto` (for R2) |
| `S3_ACCESS_KEY_ID` | No | S3 access key | `xxxxxxxxxxxxx` |
| `S3_SECRET_ACCESS_KEY` | No | S3 secret key | `xxxxxxxxxxxxx` |

#### Logging & Monitoring

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `LOG_LEVEL` | No | Logging verbosity | `info`, `debug`, `warn`, `error` |

**Example `.env` file:**

```bash
# ============================================
# MEDUSA 2.0 ENVIRONMENT CONFIGURATION
# ============================================

# Core Configuration
NODE_ENV=development
PORT=9000
MEDUSA_BACKEND_URL=http://localhost:9000
MEDUSA_WORKER_MODE=shared

# Database Configuration
DATABASE_URL=postgresql://medusa:medusa_password@localhost:5432/danieltarazona_store
DB_NAME=danieltarazona_store
REDIS_URL=redis://localhost:6379

# Security (Generate with: openssl rand -hex 64)
JWT_SECRET=your_64_character_jwt_secret_here
COOKIE_SECRET=your_64_character_cookie_secret_here

# CORS Configuration
STORE_CORS=http://localhost:4321,https://store.danieltarazona.com
ADMIN_CORS=http://localhost:9000,https://admin.danieltarazona.com
AUTH_CORS=http://localhost:4321,http://localhost:9000,https://store.danieltarazona.com,https://admin.danieltarazona.com

# Admin Dashboard
ADMIN_PATH=/app
DISABLE_MEDUSA_ADMIN=false

# Payment Providers (Production)
STRIPE_API_KEY=sk_live_xxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxx

# Email Configuration
SMTP_HOST=smtp.resend.com
SMTP_PORT=465
SMTP_USER=resend
SMTP_PASSWORD=re_xxxxxxxxxxxxx
SMTP_FROM=store@danieltarazona.com

# File Storage (Cloudflare R2)
S3_URL=https://xxxx.r2.cloudflarestorage.com
S3_BUCKET=medusa-files
S3_REGION=auto
S3_ACCESS_KEY_ID=xxxxxxxxxxxxx
S3_SECRET_ACCESS_KEY=xxxxxxxxxxxxx

# Logging
LOG_LEVEL=info
```

---

### Deno Functions (`deno-functions/.env`)

Environment variables for Deno serverless functions.

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `DENO_ENV` | No | Deno environment | `development` or `production` |
| `PORT` | No | Server port (default: 8000) | `8000` |
| `SUPABASE_URL` | Yes | Supabase project URL | `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Yes | Supabase anonymous key | `eyJhbGciOi...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Yes | Supabase service role key | `eyJhbGciOi...` |
| `RESEND_API_KEY` | No | Resend email API key | `re_xxxxxxxxxxxxx` |
| `NOTIFICATION_EMAIL` | No | Email for notifications | `admin@danieltarazona.com` |
| `FROM_EMAIL` | No | Default "from" email | `noreply@danieltarazona.com` |
| `MEDUSA_BACKEND_URL` | No | Medusa API URL (for proxy) | `https://api.danieltarazona.com` |
| `MEDUSA_PUBLISHABLE_KEY` | No | Medusa publishable key | `pk_xxxxxxxxxxxxx` |
| `RATE_LIMIT_MAX` | No | Max requests per window | `100` |
| `RATE_LIMIT_WINDOW_MS` | No | Rate limit window (ms) | `60000` |
| `ALLOWED_ORIGINS` | Yes | Allowed CORS origins | `https://danieltarazona.com` |

**Example `.env` file:**

```bash
# ===========================================
# DENO FUNCTIONS ENVIRONMENT VARIABLES
# ===========================================

# Environment
DENO_ENV=development
PORT=8000

# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Email Notifications (Optional)
RESEND_API_KEY=re_xxxxxxxxxxxxx
NOTIFICATION_EMAIL=admin@danieltarazona.com
FROM_EMAIL=noreply@danieltarazona.com

# Medusa Integration (Optional)
MEDUSA_BACKEND_URL=https://api.danieltarazona.com
MEDUSA_PUBLISHABLE_KEY=pk_xxxxxxxxxxxxx

# Rate Limiting
RATE_LIMIT_MAX=10
RATE_LIMIT_WINDOW_MS=60000

# CORS
ALLOWED_ORIGINS=http://localhost:4321,https://danieltarazona.com
```

---

### Cloudflare Workers (`workers/wrangler.toml`)

Cloudflare Workers configuration in `wrangler.toml` format.

#### Environment Variables (Non-Secret)

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `ENVIRONMENT` | Yes | Deployment environment | `development`, `staging`, `production` |
| `ALLOWED_ORIGINS` | Yes | Allowed CORS origins (comma-separated) | `https://danieltarazona.com,https://store.danieltarazona.com` |
| `MEDUSA_BACKEND_URL` | No | Medusa API URL for proxying | `https://api.danieltarazona.com` |

#### Secrets (Set via Wrangler CLI)

| Secret | Required | Description | Set Command |
|--------|----------|-------------|-------------|
| `SUPABASE_URL` | Yes | Supabase project URL | `wrangler secret put SUPABASE_URL` |
| `SUPABASE_ANON_KEY` | Yes | Supabase anonymous key | `wrangler secret put SUPABASE_ANON_KEY` |
| `RESEND_API_KEY` | No | Resend email API key | `wrangler secret put RESEND_API_KEY` |

#### KV Namespace Bindings

| Binding | Purpose | Description |
|---------|---------|-------------|
| `RATE_LIMIT_KV` | Rate limiting | Stores request counts per IP |
| `CACHE_KV` | Response caching | Caches API responses |

#### D1 Database Bindings (Optional)

| Binding | Purpose | Description |
|---------|---------|-------------|
| `DB` | Analytics/Logs | Cloudflare D1 SQLite database |

#### R2 Bucket Bindings (Optional)

| Binding | Purpose | Description |
|---------|---------|-------------|
| `ASSETS_BUCKET` | Static assets | Cloudflare R2 object storage |

**Example `wrangler.toml`:**

```toml
# ===========================================
# CLOUDFLARE WORKERS CONFIGURATION
# ===========================================

name = "danieltarazona-api"
main = "src/index.ts"
compatibility_date = "2024-01-01"
node_compat = true

# Routes
routes = [
  { pattern = "api.danieltarazona.com/*", zone_name = "danieltarazona.com" }
]

# Environment Variables (Non-Secret)
[vars]
ENVIRONMENT = "production"
ALLOWED_ORIGINS = "https://danieltarazona.com,https://store.danieltarazona.com"
MEDUSA_BACKEND_URL = "https://api.danieltarazona.com/medusa"

# KV Namespace Bindings
[[kv_namespaces]]
binding = "RATE_LIMIT_KV"
id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
preview_id = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

[[kv_namespaces]]
binding = "CACHE_KV"
id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
preview_id = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

# D1 Database Binding (Optional)
[[d1_databases]]
binding = "DB"
database_name = "danieltarazona-db"
database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# R2 Bucket Binding (Optional)
[[r2_buckets]]
binding = "ASSETS_BUCKET"
bucket_name = "danieltarazona-assets"

# Development Environment
[env.development]
name = "danieltarazona-api-dev"
vars = { ENVIRONMENT = "development" }

# Staging Environment
[env.staging]
name = "danieltarazona-api-staging"
vars = { ENVIRONMENT = "staging" }
```

**Setting Secrets via Wrangler CLI:**

```bash
# Set secrets (will prompt for value)
wrangler secret put SUPABASE_URL
wrangler secret put SUPABASE_ANON_KEY
wrangler secret put RESEND_API_KEY

# Set secret with value directly
echo "your-secret-value" | wrangler secret put SECRET_NAME

# List all secrets
wrangler secret list
```

---

### Nhost Configuration (`nhost/.env`)

Environment variables for Nhost (alternative to Supabase).

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `NHOST_SUBDOMAIN` | Yes | Nhost project subdomain | `your-project-subdomain` |
| `NHOST_REGION` | Yes | Nhost deployment region | `eu-central-1` |
| `NHOST_ADMIN_SECRET` | Yes | Hasura admin secret | `your-admin-secret` |
| `PUBLIC_NHOST_SUBDOMAIN` | Yes | Client-side subdomain | `your-project-subdomain` |
| `PUBLIC_NHOST_REGION` | Yes | Client-side region | `eu-central-1` |
| `NHOST_HASURA_URL` | No | Hasura GraphQL endpoint | `http://localhost:1337` |
| `NHOST_GRAPHQL_URL` | No | GraphQL endpoint | `http://localhost:1337/v1/graphql` |
| `NHOST_AUTH_URL` | No | Auth service endpoint | `http://localhost:1337/v1/auth` |
| `NHOST_STORAGE_URL` | No | Storage service endpoint | `http://localhost:1337/v1/storage` |
| `NHOST_FUNCTIONS_URL` | No | Functions endpoint | `http://localhost:1337/v1/functions` |

**Example `.env` file:**

```bash
# ===========================================
# NHOST ENVIRONMENT VARIABLES
# ===========================================

# Cloud Configuration
NHOST_SUBDOMAIN=your-project-subdomain
NHOST_REGION=eu-central-1
NHOST_ADMIN_SECRET=your-admin-secret

# Client-Side (Public)
PUBLIC_NHOST_SUBDOMAIN=your-project-subdomain
PUBLIC_NHOST_REGION=eu-central-1

# Local Development URLs
NHOST_HASURA_URL=http://localhost:1337
NHOST_GRAPHQL_URL=http://localhost:1337/v1/graphql
NHOST_AUTH_URL=http://localhost:1337/v1/auth
NHOST_STORAGE_URL=http://localhost:1337/v1/storage
NHOST_FUNCTIONS_URL=http://localhost:1337/v1/functions
```

---

### Supabase Configuration

Environment variables for Supabase PostgreSQL and services.

| Variable | Required | Description | Example Value |
|----------|----------|-------------|---------------|
| `SUPABASE_URL` | Yes | Supabase project URL | `https://xxxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Yes | Anonymous/public key | `eyJhbGciOi...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Yes | Service role key (server-only) | `eyJhbGciOi...` |
| `DATABASE_URL` | Yes | Direct PostgreSQL connection | `postgresql://postgres:pass@db.xxxx.supabase.co:5432/postgres` |
| `DATABASE_POOLER_URL` | No | Pooled connection (recommended) | `postgresql://postgres.xxxx:pass@aws-0-region.pooler.supabase.co:6543/postgres` |

**Example `.env` file:**

```bash
# ===========================================
# SUPABASE ENVIRONMENT VARIABLES
# ===========================================

# Project Configuration
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
# NEVER expose service role key in client-side code
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Database Direct Connection
DATABASE_URL=postgresql://postgres:<password>@db.<project-ref>.supabase.co:5432/postgres

# Database Pooled Connection (Recommended for serverless)
DATABASE_POOLER_URL=postgresql://postgres.<project-ref>:<password>@aws-0-<region>.pooler.supabase.co:6543/postgres
```

---

### GitHub Actions Secrets

Repository secrets for GitHub Actions CI/CD workflows.

| Secret Name | Required | Purpose | Where to Get |
|-------------|----------|---------|--------------|
| `CLOUDFLARE_API_TOKEN` | Yes | Cloudflare Pages deployment | Cloudflare Dashboard → API Tokens |
| `CLOUDFLARE_ACCOUNT_ID` | Yes | Cloudflare account identifier | Cloudflare Dashboard → Overview |
| `CLOUDFLARE_ZONE_ID` | No | Zone ID for cache purging | Cloudflare Dashboard → Zone Overview |
| `COOLIFY_WEBHOOK_URL` | Yes | Trigger Coolify deployments | Coolify → Application → Webhooks |
| `COOLIFY_WEBHOOK_SECRET` | Yes | Authenticate webhook requests | Coolify → Application → Webhooks |
| `SUPABASE_URL` | Yes | Supabase project URL | Supabase Dashboard → Settings → API |
| `SUPABASE_ANON_KEY` | Yes | Supabase anonymous key | Supabase Dashboard → Settings → API |
| `MEDUSA_PUBLISHABLE_KEY` | No | Medusa publishable API key | Medusa Admin Dashboard |
| `DISCORD_WEBHOOK_URL` | No | Discord notifications | Discord Server Settings → Integrations |
| `SLACK_WEBHOOK_URL` | No | Slack notifications | Slack App → Incoming Webhooks |

**Adding Secrets via GitHub CLI:**

```bash
# Authenticate with GitHub
gh auth login

# Add Cloudflare secrets
gh secret set CLOUDFLARE_API_TOKEN --body "your-cloudflare-api-token"
gh secret set CLOUDFLARE_ACCOUNT_ID --body "your-cloudflare-account-id"
gh secret set CLOUDFLARE_ZONE_ID --body "your-cloudflare-zone-id"

# Add Coolify secrets
gh secret set COOLIFY_WEBHOOK_URL --body "https://coolify.yourdomain.com/webhook/abc123"
gh secret set COOLIFY_WEBHOOK_SECRET --body "your-webhook-secret"

# Add Supabase secrets
gh secret set SUPABASE_URL --body "https://your-project.supabase.co"
gh secret set SUPABASE_ANON_KEY --body "your-anon-key"

# Add Medusa secret
gh secret set MEDUSA_PUBLISHABLE_KEY --body "pk_xxxxxxxxxxxxx"

# Add notification webhooks (optional)
gh secret set DISCORD_WEBHOOK_URL --body "https://discord.com/api/webhooks/..."
gh secret set SLACK_WEBHOOK_URL --body "https://hooks.slack.com/services/..."

# Verify secrets
gh secret list
```

---

### Coolify Application Environment Variables

Environment variables configured in Coolify dashboard for Medusa deployment.

| Category | Variable | Description |
|----------|----------|-------------|
| **Core** | `NODE_ENV` | `production` |
| **Core** | `MEDUSA_BACKEND_URL` | Public API URL |
| **Core** | `STORE_CORS` | Allowed storefront origins |
| **Core** | `ADMIN_CORS` | Allowed admin origins |
| **Database** | `DATABASE_URL` | Auto-linked from Coolify database |
| **Cache** | `REDIS_URL` | Auto-linked from Coolify Redis |
| **Security** | `JWT_SECRET` | Generated with `openssl rand -hex 64` |
| **Security** | `COOKIE_SECRET` | Generated with `openssl rand -hex 64` |
| **Payment** | `STRIPE_API_KEY` | Stripe secret key |
| **Payment** | `STRIPE_WEBHOOK_SECRET` | Stripe webhook secret |
| **Email** | `SMTP_HOST` | SMTP server (e.g., `smtp.resend.com`) |
| **Email** | `SMTP_PORT` | SMTP port (e.g., `465`) |
| **Email** | `SMTP_USER` | SMTP username |
| **Email** | `SMTP_PASSWORD` | SMTP password/API key |
| **Email** | `SMTP_FROM` | Default from address |
| **Storage** | `S3_URL` | S3-compatible endpoint |
| **Storage** | `S3_BUCKET` | Bucket name |
| **Storage** | `S3_REGION` | Bucket region |
| **Storage** | `S3_ACCESS_KEY_ID` | Access key |
| **Storage** | `S3_SECRET_ACCESS_KEY` | Secret key |
| **Logging** | `LOG_LEVEL` | `info`, `debug`, `warn`, `error` |
| **Backup** | `S3_BACKUP_BUCKET` | Backup bucket name |
| **Backup** | `S3_BACKUP_ENDPOINT` | Backup S3 endpoint |
| **Backup** | `S3_BACKUP_ACCESS_KEY` | Backup access key |
| **Backup** | `S3_BACKUP_SECRET_KEY` | Backup secret key |

---

### Cloudflare Pages Environment Variables

Environment variables set in Cloudflare Pages dashboard.

#### Portfolio Site (Production)

| Variable | Value |
|----------|-------|
| `PUBLIC_SITE_URL` | `https://danieltarazona.com` |
| `PUBLIC_SUPABASE_URL` | `https://xxx.supabase.co` |
| `PUBLIC_SUPABASE_ANON_KEY` | `eyJhbG...` |

#### Portfolio Site (Preview)

| Variable | Value |
|----------|-------|
| `PUBLIC_SITE_URL` | `https://xxx.danieltarazona-portfolio.pages.dev` |
| `PUBLIC_SUPABASE_URL` | `https://xxx.supabase.co` |
| `PUBLIC_SUPABASE_ANON_KEY` | `eyJhbG...` |

#### Store Frontend (Production)

| Variable | Value |
|----------|-------|
| `PUBLIC_SITE_URL` | `https://store.danieltarazona.com` |
| `PUBLIC_MEDUSA_BACKEND_URL` | `https://api.danieltarazona.com` |
| `PUBLIC_MEDUSA_PUBLISHABLE_KEY` | `pk_xxx...` |

#### Store Frontend (Preview)

| Variable | Value |
|----------|-------|
| `PUBLIC_SITE_URL` | `https://xxx.danieltarazona-store.pages.dev` |
| `PUBLIC_MEDUSA_BACKEND_URL` | `https://api.danieltarazona.com` |
| `PUBLIC_MEDUSA_PUBLISHABLE_KEY` | `pk_xxx...` |

---

### Security Best Practices

#### Environment Variable Categories

| Category | Prefix | Exposure | Examples |
|----------|--------|----------|----------|
| **Public** | `PUBLIC_` | Client-side safe | `PUBLIC_SITE_URL`, `PUBLIC_STRIPE_KEY` |
| **Private** | None | Server-side only | `DATABASE_URL`, `STRIPE_API_KEY` |
| **Service Role** | `*_SERVICE_ROLE_*` | Never expose | `SUPABASE_SERVICE_ROLE_KEY` |

#### Generation Commands

```bash
# Generate secure secrets
openssl rand -hex 32    # 32-byte hex string (64 chars)
openssl rand -hex 64    # 64-byte hex string (128 chars)
openssl rand -base64 32 # Base64 encoded 32 bytes
openssl rand -base64 48 # Base64 encoded 48 bytes

# Generate UUID
uuidgen | tr '[:upper:]' '[:lower:]'

# Generate JWT secret for Medusa
echo "JWT_SECRET=$(openssl rand -hex 64)"
echo "COOKIE_SECRET=$(openssl rand -hex 64)"
```

#### File Permissions

```bash
# Secure .env files (owner read/write only)
chmod 600 .env
chmod 600 .env.local
chmod 600 .env.production

# Verify permissions
ls -la .env*
```

#### .gitignore Configuration

Ensure all `.env` files are excluded from version control:

```gitignore
# Environment files
.env
.env.local
.env.development
.env.production
.env*.local

# Exception: example files can be committed
!.env.example
```

#### API Key Security

Proper API key management is critical for protecting your services and preventing unauthorized access.

**API Key Types and Security Levels:**

| Key Type | Security Level | Client Exposure | Use Case |
|----------|---------------|-----------------|----------|
| **Publishable Keys** | Low | Safe | Client-side API calls (Stripe `pk_*`, Medusa `pk_*`) |
| **Secret/Private Keys** | Critical | Never expose | Server-side only (Stripe `sk_*`, database credentials) |
| **Service Role Keys** | Critical | Never expose | Admin operations (Supabase service role) |
| **API Tokens** | High | Never expose | CI/CD, automation (Cloudflare, GitHub tokens) |
| **Webhook Secrets** | High | Never expose | Webhook signature verification |

**API Key Protection Strategies:**

```typescript
// ❌ NEVER: Hard-coded API keys
const stripe = new Stripe('sk_live_abc123');

// ✅ CORRECT: Environment variables
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// ❌ NEVER: API keys in frontend code
// This exposes your key in the browser
const response = await fetch('/api/data', {
  headers: { 'Authorization': 'Bearer sk_secret_key' }
});

// ✅ CORRECT: Use publishable keys or proxy through backend
const response = await fetch('/api/data', {
  headers: { 'Authorization': 'Bearer pk_publishable_key' }
});
```

**Key Rotation Schedule:**

| Key Type | Rotation Frequency | Action on Compromise |
|----------|-------------------|---------------------|
| Database credentials | Every 90 days | Immediate rotation |
| API tokens (CI/CD) | Every 60 days | Immediate revocation |
| JWT secrets | Every 180 days | Rolling update strategy |
| Webhook secrets | Every 90 days | Update all integrations |
| Service role keys | Every 90 days | Immediate rotation |

**Key Rotation Checklist:**

```bash
# 1. Generate new keys
NEW_JWT_SECRET=$(openssl rand -hex 64)
NEW_COOKIE_SECRET=$(openssl rand -hex 64)

# 2. Update secrets in all environments
# For Coolify
coolify env:set JWT_SECRET=$NEW_JWT_SECRET
coolify env:set COOKIE_SECRET=$NEW_COOKIE_SECRET

# For Cloudflare Workers
wrangler secret put JWT_SECRET
wrangler secret put COOKIE_SECRET

# For GitHub Actions - update via web UI or CLI
gh secret set JWT_SECRET --body "$NEW_JWT_SECRET"

# 3. Deploy changes
# 4. Verify functionality
# 5. Revoke old keys
# 6. Update documentation/runbooks
```

#### Secrets Management Strategies

Different deployment scenarios require different secrets management approaches. Choose the strategy that matches your infrastructure complexity.

**Strategy 1: Environment Variables (Simple Deployments)**

Best for: Single-service deployments, small teams, development environments.

```bash
# Local development: .env file
DATABASE_URL=postgresql://user:pass@localhost:5432/db
JWT_SECRET=dev_secret_not_for_production

# Production: Set via platform UI or CLI
# Coolify
coolify env:set DATABASE_URL="postgresql://user:pass@host:5432/db"

# Cloudflare Workers
wrangler secret put DATABASE_URL

# Cloudflare Pages
# Set in Cloudflare Dashboard > Pages > Settings > Environment variables
```

**Strategy 2: Secrets Manager (Production Systems)**

Best for: Multi-service architectures, compliance requirements, team collaboration.

```typescript
// Using Doppler (recommended for this stack)
// Install: npm install @doppler/node-sdk

import { DopplerClient } from '@doppler/node-sdk';

const doppler = new DopplerClient({
  token: process.env.DOPPLER_TOKEN,
  project: 'danieltarazona',
  config: process.env.NODE_ENV === 'production' ? 'prd' : 'dev'
});

const secrets = await doppler.secrets.list();
const dbUrl = secrets['DATABASE_URL'];
```

**Strategy 3: HashiCorp Vault (Enterprise/Self-Hosted)**

Best for: Self-hosted infrastructure, complex compliance, dynamic secrets.

```bash
# Initialize Vault (one-time setup)
vault operator init -key-shares=5 -key-threshold=3

# Store secrets
vault kv put secret/danieltarazona/medusa \
  DATABASE_URL="postgresql://..." \
  JWT_SECRET="..." \
  COOKIE_SECRET="..."

# Retrieve secrets in application
vault kv get -field=DATABASE_URL secret/danieltarazona/medusa
```

**Secrets Management Comparison:**

| Feature | Env Variables | Doppler | Vault | 1Password |
|---------|---------------|---------|-------|-----------|
| **Complexity** | Low | Medium | High | Low |
| **Cost** | Free | Free tier | Self-hosted | $4/user/mo |
| **Audit Logging** | No | Yes | Yes | Yes |
| **Access Control** | Basic | RBAC | Advanced | RBAC |
| **Secret Rotation** | Manual | Automated | Dynamic | Manual |
| **CI/CD Integration** | Basic | Native | Native | Native |
| **Team Collaboration** | Limited | Excellent | Excellent | Excellent |
| **Recommended For** | Solo dev | Small teams | Enterprise | Small teams |

**Secrets Hierarchy for This Project:**

```
danieltarazona/
├── development/
│   ├── portfolio/      # Astro portfolio dev secrets
│   ├── storefront/     # Astro storefront dev secrets
│   ├── medusa/         # Medusa backend dev secrets
│   └── functions/      # Deno/Workers dev secrets
├── staging/
│   ├── portfolio/
│   ├── storefront/
│   ├── medusa/
│   └── functions/
└── production/
    ├── portfolio/
    ├── storefront/
    ├── medusa/
    └── functions/
```

#### Security Headers Configuration

Security headers protect your application from common web vulnerabilities. Configure them at both the CDN (Cloudflare) and application level.

**Essential Security Headers:**

| Header | Purpose | Recommended Value |
|--------|---------|------------------|
| `Strict-Transport-Security` | Force HTTPS | `max-age=31536000; includeSubDomains; preload` |
| `Content-Security-Policy` | Prevent XSS/injection | See detailed config below |
| `X-Content-Type-Options` | Prevent MIME sniffing | `nosniff` |
| `X-Frame-Options` | Prevent clickjacking | `DENY` or `SAMEORIGIN` |
| `X-XSS-Protection` | Legacy XSS protection | `1; mode=block` |
| `Referrer-Policy` | Control referrer info | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | Control browser features | See detailed config below |
| `Cross-Origin-Opener-Policy` | Isolate browsing context | `same-origin` |
| `Cross-Origin-Embedder-Policy` | Control cross-origin embeds | `require-corp` |
| `Cross-Origin-Resource-Policy` | Protect resources | `same-origin` |

**Cloudflare Security Headers Configuration:**

```bash
# Configure security headers via Cloudflare API
# Add to Transform Rules in Cloudflare Dashboard or via API

# Create a Transform Rule for response headers
curl -X POST "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/rulesets" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "Security Headers",
    "kind": "zone",
    "phase": "http_response_headers_transform",
    "rules": [
      {
        "action": "rewrite",
        "action_parameters": {
          "headers": {
            "Strict-Transport-Security": {
              "operation": "set",
              "value": "max-age=31536000; includeSubDomains; preload"
            },
            "X-Content-Type-Options": {
              "operation": "set",
              "value": "nosniff"
            },
            "X-Frame-Options": {
              "operation": "set",
              "value": "DENY"
            },
            "Referrer-Policy": {
              "operation": "set",
              "value": "strict-origin-when-cross-origin"
            },
            "Permissions-Policy": {
              "operation": "set",
              "value": "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
            }
          }
        },
        "expression": "true",
        "enabled": true
      }
    ]
  }'
```

**Cloudflare Pages `_headers` File:**

Create `portfolio/_headers` and `storefront/_headers`:

```
# Security headers for all pages
/*
  Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  X-XSS-Protection: 1; mode=block
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Embedder-Policy: require-corp
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' https://static.cloudflareinsights.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https://api.danieltarazona.com https://*.supabase.co; frame-ancestors 'none'; base-uri 'self'; form-action 'self'

# Cache static assets
/assets/*
  Cache-Control: public, max-age=31536000, immutable

# No cache for HTML pages
/*.html
  Cache-Control: public, max-age=0, must-revalidate
```

**Content Security Policy Breakdown:**

```
Content-Security-Policy:
  default-src 'self';                              # Default to same origin
  script-src 'self' 'unsafe-inline'                # Scripts from self + inline
    https://static.cloudflareinsights.com;         # Cloudflare analytics
  style-src 'self' 'unsafe-inline';                # Styles from self + inline
  img-src 'self' data: https:;                     # Images from self, data URIs, HTTPS
  font-src 'self' data:;                           # Fonts from self, data URIs
  connect-src 'self'                               # API connections
    https://api.danieltarazona.com                 # Medusa API
    https://*.supabase.co;                         # Supabase services
  frame-ancestors 'none';                          # Prevent framing (clickjacking)
  base-uri 'self';                                 # Restrict base element
  form-action 'self';                              # Restrict form submissions
```

**CSP for E-Commerce Store (with Stripe):**

```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'unsafe-inline' https://js.stripe.com https://static.cloudflareinsights.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https: blob:;
  font-src 'self' data:;
  connect-src 'self' https://api.danieltarazona.com https://*.supabase.co https://api.stripe.com;
  frame-src https://js.stripe.com https://hooks.stripe.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self' https://checkout.stripe.com;
```

**Astro Middleware for Security Headers:**

```typescript
// src/middleware.ts
import { defineMiddleware } from 'astro/middleware';

export const onRequest = defineMiddleware(async (context, next) => {
  const response = await next();

  // Security headers (for non-Cloudflare deployments)
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-XSS-Protection', '1; mode=block');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  response.headers.set('Permissions-Policy',
    'accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()');

  // CSP header
  response.headers.set('Content-Security-Policy',
    "default-src 'self'; script-src 'self' 'unsafe-inline' https://static.cloudflareinsights.com; " +
    "style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; " +
    "connect-src 'self' https://api.danieltarazona.com https://*.supabase.co; " +
    "frame-ancestors 'none'; base-uri 'self'; form-action 'self'");

  return response;
});
```

#### Authentication Considerations

Proper authentication architecture protects your APIs and administrative interfaces.

**Authentication Architecture Overview:**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         AUTHENTICATION ARCHITECTURE                              │
└─────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   PUBLIC SITE    │     │   STOREFRONT     │     │   ADMIN PANEL    │
│ danieltarazona   │     │ store.daniel...  │     │ admin.daniel...  │
│   No auth req.   │     │ Customer auth    │     │ Admin auth req.  │
└────────┬─────────┘     └────────┬─────────┘     └────────┬─────────┘
         │                        │                        │
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         CLOUDFLARE ACCESS (Zero Trust)                           │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  • IP Allowlisting                                                       │   │
│  │  • Email OTP / SSO (Google, GitHub)                                      │   │
│  │  • Device Posture Checks                                                 │   │
│  │  • Session Duration Controls                                             │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Static Files   │     │   Medusa API     │     │   Medusa Admin   │
│   No auth check  │     │ Customer JWT     │     │ Admin JWT/RBAC   │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

**Medusa 2.0 Authentication Configuration:**

```typescript
// medusa-config.ts - Authentication setup
import { defineConfig, Modules } from '@medusajs/framework/utils';

export default defineConfig({
  projectConfig: {
    // ... other config
  },
  modules: {
    // Customer authentication (storefront)
    [Modules.AUTH]: {
      resolve: '@medusajs/auth',
      options: {
        providers: [
          // Email/password auth
          {
            resolve: '@medusajs/auth-emailpass',
            id: 'emailpass',
            options: {
              hashConfig: {
                // bcrypt configuration
                rounds: 10
              }
            }
          },
          // Social login (optional)
          {
            resolve: '@medusajs/auth-google',
            id: 'google',
            options: {
              clientId: process.env.GOOGLE_CLIENT_ID,
              clientSecret: process.env.GOOGLE_CLIENT_SECRET,
              callbackUrl: `${process.env.MEDUSA_BACKEND_URL}/auth/google/callback`
            }
          }
        ]
      }
    }
  },
  // Admin CORS - restrict to admin domain
  admin: {
    cors: process.env.ADMIN_CORS || 'https://admin.danieltarazona.com'
  },
  // Store CORS - allow storefront
  store: {
    cors: process.env.STORE_CORS || 'https://store.danieltarazona.com'
  }
});
```

**JWT Token Security Best Practices:**

```typescript
// JWT configuration best practices
const jwtConfig = {
  // Token expiration times
  accessTokenExpiry: '15m',      // Short-lived access tokens
  refreshTokenExpiry: '7d',      // Longer refresh tokens

  // Required claims
  requiredClaims: ['sub', 'iat', 'exp', 'aud'],

  // Audience validation
  audience: [
    'https://api.danieltarazona.com',
    'https://store.danieltarazona.com'
  ],

  // Issuer validation
  issuer: 'https://api.danieltarazona.com',

  // Algorithm (RS256 for production, HS256 for simpler setups)
  algorithm: 'HS256'
};

// Token validation middleware
async function validateToken(token: string): Promise<TokenPayload | null> {
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET, {
      algorithms: [jwtConfig.algorithm],
      audience: jwtConfig.audience,
      issuer: jwtConfig.issuer
    });

    return payload as TokenPayload;
  } catch (error) {
    // Log for security monitoring (don't expose details)
    console.error('Token validation failed:', error.name);
    return null;
  }
}
```

**Cloudflare Access for Admin Protection:**

```bash
# Configure Cloudflare Access for admin.danieltarazona.com

# 1. Create an Access Application
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "Daniel Tarazona Admin",
    "domain": "admin.danieltarazona.com",
    "type": "self_hosted",
    "session_duration": "24h",
    "auto_redirect_to_identity": false,
    "allowed_idps": ["google"],
    "cors_headers": {
      "allow_all_headers": true,
      "allow_all_origins": false,
      "allowed_origins": ["https://admin.danieltarazona.com"]
    }
  }'

# 2. Create an Access Policy (allow specific emails)
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$CF_ACCOUNT_ID/access/apps/{app_id}/policies" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{
    "name": "Admin Access Policy",
    "decision": "allow",
    "include": [
      {
        "email": {
          "email": "daniel@danieltarazona.com"
        }
      }
    ],
    "require": [
      {
        "login_method": {
          "id": "google"
        }
      }
    ]
  }'
```

**Supabase Row Level Security (RLS) for Contact Form:**

```sql
-- Enable RLS on tables
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_signups ENABLE ROW LEVEL SECURITY;

-- Policy: Allow public insert (for form submissions)
CREATE POLICY "Allow public insert" ON contact_submissions
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Policy: Only authenticated admins can read
CREATE POLICY "Admin read only" ON contact_submissions
  FOR SELECT
  TO authenticated
  USING (
    auth.jwt() ->> 'email' IN (
      SELECT email FROM admin_users WHERE is_active = true
    )
  );

-- Policy: Prevent updates and deletes from non-admins
CREATE POLICY "Admin update only" ON contact_submissions
  FOR UPDATE
  TO authenticated
  USING (
    auth.jwt() ->> 'email' IN (
      SELECT email FROM admin_users WHERE is_active = true
    )
  );

-- Rate limiting function
CREATE OR REPLACE FUNCTION check_submission_rate_limit(client_ip TEXT)
RETURNS BOOLEAN AS $$
DECLARE
  recent_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO recent_count
  FROM contact_submissions
  WHERE ip_address = client_ip
    AND created_at > NOW() - INTERVAL '1 hour';

  -- Allow max 5 submissions per hour per IP
  RETURN recent_count < 5;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

**API Authentication Patterns:**

| Endpoint Type | Auth Method | Rate Limit | CORS |
|--------------|-------------|------------|------|
| Public store API | Publishable key | 1000/min | `store.danieltarazona.com` |
| Customer API | JWT (customer) | 100/min | `store.danieltarazona.com` |
| Admin API | JWT (admin) | 500/min | `admin.danieltarazona.com` |
| Webhook endpoints | HMAC signature | No limit | N/A |
| Contact form | None (RLS + rate limit) | 5/hour/IP | `danieltarazona.com` |

**Session Security Checklist:**

- [ ] Use `httpOnly` cookies for session tokens
- [ ] Set `secure` flag on cookies (HTTPS only)
- [ ] Implement `sameSite=strict` or `sameSite=lax`
- [ ] Set appropriate session expiration times
- [ ] Implement session invalidation on logout
- [ ] Store only session ID in cookies, not user data
- [ ] Implement CSRF protection for state-changing operations
- [ ] Log authentication events for security monitoring

**Cookie Configuration Example:**

```typescript
// Secure cookie configuration for sessions
const cookieConfig = {
  httpOnly: true,          // Prevent JavaScript access
  secure: true,            // HTTPS only
  sameSite: 'strict',      // Prevent CSRF
  maxAge: 60 * 60 * 24 * 7, // 7 days
  path: '/',
  domain: '.danieltarazona.com'  // Allow subdomains
};

// Setting session cookie
response.headers.set(
  'Set-Cookie',
  `session=${sessionId}; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=${7 * 24 * 60 * 60}; Domain=.danieltarazona.com`
);
```

#### Security Monitoring and Incident Response

Implement security monitoring to detect and respond to threats.

**Logging Configuration:**

```typescript
// Security event logging
interface SecurityEvent {
  timestamp: string;
  eventType: 'auth_success' | 'auth_failure' | 'rate_limit' | 'suspicious_activity';
  userId?: string;
  ipAddress: string;
  userAgent: string;
  resource: string;
  details: Record<string, unknown>;
}

async function logSecurityEvent(event: SecurityEvent): Promise<void> {
  // Log to Supabase for analysis
  await supabase.from('security_logs').insert({
    event_type: event.eventType,
    user_id: event.userId,
    ip_address: event.ipAddress,
    user_agent: event.userAgent,
    resource: event.resource,
    details: event.details,
    created_at: event.timestamp
  });

  // Alert on suspicious activity
  if (event.eventType === 'suspicious_activity') {
    await sendSecurityAlert(event);
  }
}
```

**Security Monitoring Checklist:**

- [ ] Log all authentication attempts (success/failure)
- [ ] Monitor rate limit violations
- [ ] Track unusual access patterns
- [ ] Set up alerts for failed login attempts (>5 in 10 min)
- [ ] Monitor for credential stuffing attacks
- [ ] Review logs regularly (weekly minimum)
- [ ] Implement automated anomaly detection

---

### Quick Reference: All Variables by Service

| Service | Total Variables | Required | Optional |
|---------|-----------------|----------|----------|
| Astro Portfolio | 10 | 4 | 6 |
| Astro Storefront | 11 | 4 | 7 |
| Medusa Backend | 25 | 9 | 16 |
| Deno Functions | 13 | 4 | 9 |
| Cloudflare Workers | 8 | 2 | 6 |
| Nhost | 10 | 5 | 5 |
| Supabase | 5 | 4 | 1 |
| GitHub Actions | 10 | 6 | 4 |
| Coolify | 20 | 10 | 10 |
| Cloudflare Pages | 6 | 3 | 3 |

**Total Unique Variables: ~80+**

---

*This environment variables reference is part of the ROADMAP.md documentation. Keep this section updated as new services or configuration options are added to the project.*

---

*This roadmap serves as a reusable template for future multi-domain projects with consistent theming and shared infrastructure patterns.*
