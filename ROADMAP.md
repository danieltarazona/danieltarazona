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

*This roadmap serves as a reusable template for future multi-domain projects with consistent theming and shared infrastructure patterns.*
