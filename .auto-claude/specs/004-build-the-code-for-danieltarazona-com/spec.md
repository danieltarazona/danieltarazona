# Specification: Deploy Website and Configure Cloudflare DNS

## Overview

This task involves deploying the danieltarazona.com portfolio website to Cloudflare Pages and configuring DNS routing through Cloudflare DNS. The domain is registered at Namecheap and requires nameserver updates to point to Cloudflare. The deployment infrastructure is already configured via GitHub Actions, requiring only credential verification and DNS zone setup to complete the publication process.

## Workflow Type

**Type**: feature

**Rationale**: This is a new infrastructure deployment task that establishes the production hosting and DNS configuration for the website. While no application code changes are required, it represents a new feature in the project's infrastructure - making the website publicly accessible at its production domain.

## Task Scope

### Services Involved
- **main** (primary) - Astro-based static site deployed to Cloudflare Pages
- **Cloudflare Pages** (hosting) - Static site hosting platform
- **Cloudflare DNS** (infrastructure) - DNS management and routing
- **Namecheap** (infrastructure) - Domain registrar requiring nameserver updates

### This Task Will:
- [x] Verify and configure GitHub repository secrets for Cloudflare deployment
- [x] Deploy the Astro static site to Cloudflare Pages via existing GitHub Actions workflow
- [x] Create and configure Cloudflare DNS zone for danieltarazona.com
- [x] Configure DNS records (A/CNAME) to point to Cloudflare Pages deployment
- [x] Update Namecheap nameservers to Cloudflare's nameservers
- [x] Enable Cloudflare SSL/TLS (Full mode recommended)
- [x] Verify DNS propagation and site accessibility at https://danieltarazona.com

### Out of Scope:
- Code modifications to the Astro application
- Custom domain email setup (MX records)
- Advanced Cloudflare features (Workers, Page Rules, Analytics)
- Automated DNS configuration via Terraform/IaC
- Subdomain configurations beyond www redirect

## Service Context

### main

**Tech Stack:**
- Language: TypeScript
- Framework: Astro v4.16.18
- Styling: Tailwind CSS v3.4.16
- Build Tool: Vite (built into Astro)
- Key directories: `src/` (source code), `dist/` (build output)

**Entry Point:** `src/pages/index.astro` (root page)

**How to Run:**
```bash
# Development
npm run dev

# Production build
npm run build

# Preview production build locally
npm run preview
```

**Port:** 4321 (development)

**Build Output:** Static files in `dist/` directory

**Site Configuration:**
- Site URL: https://danieltarazona.com (defined in astro.config.mjs)
- Output mode: static
- Sitemap enabled via @astrojs/sitemap integration

## Files to Modify

| File | Service | What to Change |
|------|---------|---------------|
| N/A | N/A | No code files require modification - this is an infrastructure-only task |

**Note**: If GitHub secrets are not configured, they must be added via GitHub repository Settings → Secrets and variables → Actions.

## Files to Reference

These files show the existing deployment configuration:

| File | Pattern to Reference |
|------|---------------------|
| `.github/workflows/deploy.yml` | Cloudflare Pages deployment workflow - shows required secrets and deployment command |
| `astro.config.mjs` | Site configuration - defines production URL and build settings |
| `.env.example` | Environment variables - shows PUBLIC_SITE_URL and social links configuration |
| `package.json` | Build scripts - shows available npm commands and Node.js version requirements |

## Patterns to Follow

### GitHub Actions Deployment Workflow

From `.github/workflows/deploy.yml`:

```yaml
- name: Deploy to Cloudflare Pages
  uses: cloudflare/wrangler-action@v3
  with:
    apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    command: pages deploy dist --project-name=danieltarazona-com
```

**Key Points:**
- Project name is `danieltarazona-com` in Cloudflare Pages
- Deployment uses Wrangler CLI via GitHub Action
- Requires two secrets: CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID
- Deploys the `dist/` directory after `npm run build` completes

### Astro Site Configuration

From `astro.config.mjs`:

```javascript
export default defineConfig({
  site: 'https://danieltarazona.com',
  output: 'static',
  integrations: [tailwind(), sitemap()],
  build: { assets: 'assets' }
});
```

**Key Points:**
- Static site generation (no server-side rendering)
- Production URL is danieltarazona.com (apex domain)
- Sitemap automatically generated at /sitemap.xml
- Build outputs to dist/ with assets subdirectory

## Requirements

### Functional Requirements

1. **GitHub Secrets Configuration**
   - Description: Ensure CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are configured in GitHub repository secrets
   - Acceptance: Workflow can authenticate with Cloudflare API without errors

2. **Cloudflare Pages Deployment**
   - Description: Deploy the Astro static site to Cloudflare Pages project `danieltarazona-com`
   - Acceptance: Site is accessible via Cloudflare Pages preview URL (e.g., danieltarazona-com.pages.dev)

3. **Cloudflare DNS Zone Setup**
   - Description: Create DNS zone for danieltarazona.com in Cloudflare dashboard
   - Acceptance: Cloudflare provides nameserver addresses (e.g., ada.ns.cloudflare.com, phil.ns.cloudflare.com)

4. **DNS Record Configuration**
   - Description: Configure A/AAAA/CNAME records to point to Cloudflare Pages deployment
   - Acceptance: DNS records resolve to Cloudflare Pages IP addresses with proxying enabled (orange cloud)

5. **Namecheap Nameserver Update**
   - Description: Update domain nameservers at Namecheap to Cloudflare's nameservers
   - Acceptance: Namecheap control panel shows Cloudflare nameservers as active

6. **SSL/TLS Configuration**
   - Description: Enable Cloudflare SSL/TLS in Full or Full (Strict) mode
   - Acceptance: Site loads with valid HTTPS certificate at https://danieltarazona.com

7. **WWW Subdomain Handling**
   - Description: Configure www.danieltarazona.com to redirect to apex domain
   - Acceptance: https://www.danieltarazona.com redirects to https://danieltarazona.com

### Edge Cases

1. **DNS Propagation Delay** - Nameserver changes can take 24-48 hours to propagate globally. Use DNS checkers (whatsmydns.net) to verify propagation status.

2. **GitHub Secrets Missing** - If secrets are not configured, deployment will fail with authentication error. Verify secrets exist before triggering workflow.

3. **Cloudflare Project Name Mismatch** - If Cloudflare Pages project doesn't exist or has different name, deployment will fail. Ensure project name matches `danieltarazona-com`.

4. **SSL Certificate Provisioning Delay** - Cloudflare may take 1-5 minutes to provision SSL certificates for new domains. Wait for "Active Certificate" status.

5. **WWW Subdomain SSL** - If www subdomain is configured, ensure it also has SSL enabled (automatic with proxied DNS records).

## Implementation Notes

### DO
- Verify GitHub repository secrets exist before triggering deployment workflow
- Use Cloudflare's DNS proxy (orange cloud) for all web traffic records to enable CDN and SSL
- Configure SSL/TLS to "Full" mode in Cloudflare dashboard for best security
- Enable "Always Use HTTPS" redirect in Cloudflare SSL/TLS settings
- Create both apex and www DNS records for maximum compatibility
- Document the assigned Cloudflare nameservers for future reference
- Test DNS propagation with multiple DNS checkers before considering complete
- Verify sitemap accessibility at https://danieltarazona.com/sitemap.xml after deployment

### DON'T
- Modify the existing deploy.yml workflow - it's correctly configured
- Use "Flexible" SSL mode - it creates an insecure connection between Cloudflare and origin
- Delete the Cloudflare Pages project and recreate - use the existing danieltarazona-com project
- Point DNS records directly to GitHub Pages or other platforms - use Cloudflare Pages
- Configure custom nameservers at Namecheap - use Cloudflare's provided nameservers
- Enable "Development Mode" in Cloudflare after launch - it bypasses caching
- Create duplicate DNS records - this causes resolution conflicts

## Development Environment

### Start Services

```bash
# Install dependencies
npm ci

# Start development server
npm run dev

# Build for production (outputs to dist/)
npm run build

# Preview production build locally
npm run preview
```

### Service URLs
- Development: http://localhost:4321
- Production (after deployment): https://danieltarazona.com
- Cloudflare Pages Preview: https://danieltarazona-com.pages.dev

### Required Environment Variables

**For GitHub Actions (Repository Secrets):**
- `CLOUDFLARE_API_TOKEN`: Cloudflare API token with Pages edit permissions
- `CLOUDFLARE_ACCOUNT_ID`: Cloudflare account ID (found in dashboard)

**For Local Development (.env file - optional):**
- `PUBLIC_SITE_URL`: https://danieltarazona.com
- `PUBLIC_GITHUB_USERNAME`: danieltarazona
- `PUBLIC_LINKEDIN_URL`: https://www.linkedin.com/in/danieltarazona

## Success Criteria

The task is complete when:

1. [x] GitHub Actions workflow successfully deploys to Cloudflare Pages without errors
2. [x] Cloudflare DNS zone is created and active for danieltarazona.com
3. [x] DNS records (A/AAAA/CNAME) are configured to point to Cloudflare Pages
4. [x] Namecheap nameservers updated to Cloudflare's nameservers (e.g., ada.ns.cloudflare.com)
5. [x] Site accessible at https://danieltarazona.com with valid SSL certificate
6. [x] www.danieltarazona.com redirects to apex domain (https://danieltarazona.com)
7. [x] DNS propagation verified using external DNS checkers (whatsmydns.net)
8. [x] Sitemap accessible at https://danieltarazona.com/sitemap.xml
9. [x] No console errors in browser when accessing the site
10. [x] All site assets (images, CSS, JS) load correctly over HTTPS

## QA Acceptance Criteria

**CRITICAL**: These criteria must be verified by the QA Agent before sign-off.

### GitHub Actions Workflow Verification
| Test | File | What to Verify |
|------|------|----------------|
| Workflow runs successfully | `.github/workflows/deploy.yml` | GitHub Actions shows green checkmark for latest deployment |
| Secrets are configured | GitHub Secrets UI | CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID exist in repository secrets |
| Build completes | Workflow logs | `npm run build` step completes without errors |
| Deployment succeeds | Workflow logs | Wrangler successfully deploys to Cloudflare Pages |

### Cloudflare Pages Verification
| Test | Resource | What to Verify |
|------|----------|----------------|
| Project exists | Cloudflare Dashboard | Project `danieltarazona-com` exists in Cloudflare Pages |
| Latest deployment | Pages dashboard | Most recent deployment shows as "Active" with production badge |
| Preview URL works | https://danieltarazona-com.pages.dev | Preview domain loads the site correctly |
| Build settings | Pages settings | Build command: `npm run build`, Output directory: `dist` |

### DNS Configuration Verification
| Test | Tool/Method | What to Verify |
|------|-------------|----------------|
| Nameservers updated | Namecheap dashboard | Custom DNS shows Cloudflare nameservers (e.g., ada.ns.cloudflare.com) |
| Nameserver propagation | `dig danieltarazona.com NS` | Returns Cloudflare nameservers globally |
| A/AAAA records | Cloudflare DNS dashboard | Apex domain has A/AAAA records pointing to Cloudflare Pages |
| CNAME for www | Cloudflare DNS dashboard | www subdomain CNAME points to danieltarazona.com or Pages URL |
| DNS proxy enabled | Cloudflare dashboard | Orange cloud icon active for web traffic records |
| DNS resolution | `dig danieltarazona.com A` | Resolves to Cloudflare IP addresses |

### SSL/TLS Verification
| Test | Location | What to Verify |
|------|----------|----------------|
| SSL mode | Cloudflare SSL/TLS settings | Set to "Full" or "Full (Strict)" |
| Certificate status | Cloudflare SSL/TLS → Edge Certificates | Shows "Active Certificate" |
| HTTPS redirect | Cloudflare SSL/TLS settings | "Always Use HTTPS" is enabled |
| Certificate validity | Browser (https://danieltarazona.com) | Valid certificate issued by Cloudflare |
| No mixed content | Browser console | No insecure resource warnings |

### Browser Verification
| Page/Component | URL | Checks |
|----------------|-----|--------|
| Homepage | `https://danieltarazona.com` | Loads without errors, all content visible |
| WWW redirect | `https://www.danieltarazona.com` | Redirects to apex domain (https://danieltarazona.com) |
| Sitemap | `https://danieltarazona.com/sitemap.xml` | Valid XML sitemap loads |
| Assets loading | Browser DevTools Network | All CSS, JS, images load over HTTPS with 200 status |
| Mobile viewport | Responsive design testing | Site renders correctly on mobile devices |
| Social links | Homepage links | GitHub and LinkedIn links work correctly |

### DNS Propagation Verification
| Check | Tool | Expected |
|-------|------|----------|
| Global propagation | https://whatsmydns.net | Nameservers resolve to Cloudflare globally (minimum 80% propagation) |
| DNS lookup | https://dnschecker.org | A records resolve to Cloudflare IPs globally |
| TTL check | `dig danieltarazona.com` | TTL values appropriate (e.g., 300-3600 seconds) |

### Performance & Security Verification
| Check | Tool/Method | Expected |
|-------|-------------|----------|
| SSL Labs grade | https://www.ssllabs.com/ssltest/ | Minimum A rating |
| Page load speed | Browser DevTools | First Contentful Paint < 2 seconds |
| CDN caching | Response headers | `cf-cache-status: HIT` for static assets |
| Security headers | Response headers | Basic security headers present (X-Content-Type-Options, etc.) |

### QA Sign-off Requirements
- [x] GitHub Actions workflow deploys successfully on push to main/master
- [x] Cloudflare Pages project shows active deployment
- [x] Namecheap nameservers successfully updated to Cloudflare
- [x] DNS records correctly configured with proxying enabled
- [x] DNS propagation verified at 80%+ globally
- [x] SSL/TLS configured in Full mode with valid certificate
- [x] Site accessible at https://danieltarazona.com
- [x] WWW redirect working correctly
- [x] All browser verification tests pass
- [x] No console errors or broken assets
- [x] No regressions in existing site functionality
- [x] Site follows Astro build patterns (static output, sitemap generation)
- [x] No security vulnerabilities introduced (SSL Labs grade A minimum)
- [x] Performance acceptable (page load < 2 seconds)

## Post-Deployment Tasks

After successful deployment and DNS configuration:

1. **Update Environment Variables**: Create `.env` file based on `.env.example` for local development
2. **Monitor DNS Propagation**: Check DNS propagation status over 24-48 hours
3. **Configure Cloudflare Caching**: Review and adjust cache settings if needed
4. **Set up Analytics** (optional): Configure Cloudflare Web Analytics or Google Analytics
5. **Enable Security Features** (optional): Consider enabling Cloudflare WAF, Bot Fight Mode
6. **Backup Nameservers**: Document Cloudflare nameservers in project documentation
7. **GitHub Branch Protection**: Consider enabling branch protection rules for main/master
8. **Domain Auto-Renewal**: Verify domain auto-renewal is enabled at Namecheap

## Troubleshooting Guide

### Issue: GitHub Actions deployment fails with authentication error
**Solution**: Verify CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID are correctly set in GitHub Secrets

### Issue: DNS not resolving after nameserver update
**Solution**: Wait 24-48 hours for full propagation. Check propagation status with whatsmydns.net

### Issue: SSL certificate not provisioning
**Solution**: Wait 5-10 minutes. Ensure DNS is proxied (orange cloud). Verify domain is active in Cloudflare

### Issue: Site loads on pages.dev but not custom domain
**Solution**: Verify DNS records exist and are proxied. Check that custom domain is added to Cloudflare Pages project

### Issue: Mixed content warnings in browser
**Solution**: Enable "Always Use HTTPS" in Cloudflare SSL/TLS settings. Verify all assets use relative URLs

### Issue: WWW subdomain not redirecting
**Solution**: Create CNAME record for www pointing to apex or Pages URL. Enable proxy (orange cloud)
