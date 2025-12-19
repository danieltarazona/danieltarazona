# Specification: Create Static Website Roadmap with Portfolio & Store

## Overview

This task involves creating a comprehensive **ROADMAP.md** document that outlines the complete setup and configuration of a static website (`danieltarazona.com`) with an integrated portfolio (photo gallery) and e-commerce store (`store.danieltarazona.com`) limited to 100 products. The solution leverages a modern JAMstack architecture using Astro for the frontend, Medusa 2.0 for headless commerce, Cloudflare for DNS/CDN/Workers, Coolify for self-hosting orchestration, Supabase/Nhost for PostgreSQL database, and Deno for serverless functions. The roadmap will serve as a reusable template for creating similar multi-site projects (e.g., Adam Robotics, Adam Automotive, Adam Defense) with consistent theming.

## Workflow Type

**Type**: feature

**Rationale**: This is a greenfield feature task that creates a new comprehensive documentation artifact (ROADMAP.md) from scratch. It doesn't modify existing code but establishes the foundational planning document for a complete website infrastructure project.

## Task Scope

### Services Involved
- **Documentation** (primary) - Creating ROADMAP.md as the main deliverable
- **Astro** (frontend) - Static site generator for portfolio and main site
- **Medusa 2.0** (e-commerce) - Headless commerce backend for store subdomain
- **Cloudflare** (infrastructure) - DNS, CDN, Workers, Tunnel, CLI tools
- **Coolify** (orchestration) - Self-hosting platform for deployment
- **Supabase** (database) - PostgreSQL for contact form and data storage
- **Nhost** (alternative backend) - Alternative BaaS option
- **Deno** (runtime) - Serverless functions and scripts

### This Task Will:
- [ ] Create ROADMAP.md with structured phases for project setup
- [ ] Document configuration scripts for each service (Astro, Cloudflare, Medusa, Coolify, Supabase, Deno, Nhost)
- [ ] Include CLI commands and orchestration tools for each service
- [ ] Define required features including contact form with PostgreSQL persistence
- [ ] Provide VPS options (Hetzner paid vs free alternatives)
- [ ] Compare Vendure vs Medusa for multi-site templating scenarios
- [ ] Create reusable template structure for future multi-domain projects

### Out of Scope:
- Actual implementation of the website code
- Live deployment to production servers
- Purchase or configuration of actual domain names
- Setting up billing accounts for cloud services
- Writing the actual Astro components or Medusa customizations

## Service Context

### Documentation Project

**Tech Stack:**
- Language: Markdown
- Format: GitHub-flavored Markdown with task lists
- Key directories: Project root (`/`)

**Entry Point:** `ROADMAP.md`

**How to Run:**
```bash
# View the roadmap
cat ROADMAP.md

# Or open in editor
code ROADMAP.md
```

**Port:** N/A (documentation only)

### Technology Stack Overview

| Service | Purpose | Free Tier | CLI Tool |
|---------|---------|-----------|----------|
| Astro | Static site generator | Yes | `npm create astro@latest` |
| Cloudflare | DNS/CDN/Workers | Yes | `wrangler` |
| Medusa 2.0 | Headless commerce | Self-hosted | `medusa` |
| Coolify | Self-hosting platform | Self-hosted | `coolify` |
| Supabase | PostgreSQL database | Yes (500MB) | `supabase` |
| Nhost | Backend-as-a-Service | Yes (limited) | `nhost` |
| Deno | JavaScript runtime | Yes | `deno` |

## Files to Modify

| File | Service | What to Change |
|------|---------|---------------|
| `ROADMAP.md` | Documentation | Create new file with complete project roadmap |

## Files to Reference

These files show patterns to follow:

| File | Pattern to Copy |
|------|----------------|
| `.github/workflows/snake.yml` | GitHub Actions workflow structure for CI/CD patterns |

## Patterns to Follow

### Markdown Task List Pattern

Use GitHub-flavored markdown task lists for trackable progress:

```markdown
## Phase 1: Infrastructure Setup

- [ ] Task 1: Configure DNS
  - [ ] Subtask 1.1: Add A record
  - [ ] Subtask 1.2: Add CNAME for subdomain
- [ ] Task 2: Setup Cloudflare Tunnel
```

**Key Points:**
- Use nested task lists for subtasks
- Group related tasks into phases
- Include estimated time where helpful

### Script Block Pattern

Document CLI commands in fenced code blocks with language identifiers:

```bash
# Install Astro
npm create astro@latest -- --template minimal

# Install Cloudflare Wrangler
npm install -g wrangler

# Login to Cloudflare
wrangler login
```

**Key Points:**
- Include comments explaining each command
- Group related commands together
- Specify prerequisites before commands

## Requirements

### Functional Requirements

1. **Project Roadmap Structure**
   - Description: Create a phased approach to building the complete website
   - Acceptance: ROADMAP.md contains clearly defined phases with ordered tasks

2. **Service Configuration Scripts**
   - Description: Include executable scripts/commands for each service in the stack
   - Acceptance: Each service (Astro, Cloudflare, Medusa, Coolify, Supabase, Deno, Nhost) has documented setup commands

3. **CLI Tool Documentation**
   - Description: Document available CLI tools and orchestrators for each service
   - Acceptance: Each service lists its CLI tool with installation and basic usage

4. **Contact Form with PostgreSQL**
   - Description: Document the required contact form feature that persists to PostgreSQL
   - Acceptance: Roadmap includes tasks for form implementation and database integration

5. **VPS Deployment Options**
   - Description: Provide options for both paid (Hetzner) and free VPS alternatives
   - Acceptance: Roadmap includes deployment sections for both options with trade-offs

6. **Multi-Site Template Comparison**
   - Description: Compare Vendure vs Medusa for multi-domain/multi-brand scenarios
   - Acceptance: Includes comparison table with recommendation for template reusability

7. **Feature Checklist**
   - Description: Comprehensive list of site features (required and optional)
   - Acceptance: Features are categorized with priority levels

### Edge Cases

1. **Free Tier Limits** - Document when free tiers might be exceeded (Supabase 500MB, Cloudflare limits)
2. **Self-Hosting Requirements** - Minimum VPS specs for Coolify + Medusa
3. **Domain Configuration** - Handle both apex domain and subdomain routing
4. **Database Migrations** - Strategy for Medusa schema + custom tables

## Implementation Notes

### DO
- Follow the phased approach pattern for roadmap structure
- Reuse existing GitHub Actions patterns from `.github/workflows/` for CI/CD sections
- Include version numbers for all dependencies
- Provide both Docker and non-Docker installation options
- Document environment variables clearly

### DON'T
- Create overly complex dependency chains between phases
- Assume the reader has prior experience with all services
- Skip security considerations (API keys, secrets management)
- Forget to mention backup strategies for database

## Development Environment

### No Development Server Required

This is a documentation task. The output is a Markdown file.

### Required Tools for Referenced Services

```bash
# Node.js (for Astro, Medusa)
node --version  # v18+ required

# Deno
deno --version

# Docker (for Coolify, Medusa)
docker --version

# Cloudflare CLI
wrangler --version

# Supabase CLI
supabase --version
```

### Service URLs (Once Deployed)
- Main Site: https://danieltarazona.com
- Store: https://store.danieltarazona.com
- Supabase Dashboard: https://app.supabase.com
- Coolify Dashboard: https://<your-coolify-instance>

### Required Environment Variables

Document these in ROADMAP.md:
- `CLOUDFLARE_API_TOKEN`: Cloudflare API authentication
- `SUPABASE_URL`: Supabase project URL
- `SUPABASE_ANON_KEY`: Supabase anonymous key
- `MEDUSA_BACKEND_URL`: Medusa API endpoint
- `DATABASE_URL`: PostgreSQL connection string

## Success Criteria

The task is complete when:

1. [x] ROADMAP.md exists in project root
2. [ ] Contains minimum 5 implementation phases
3. [ ] Each service has documented setup scripts
4. [ ] CLI tools are listed for all services
5. [ ] Contact form feature is documented with PostgreSQL integration
6. [ ] VPS options include Hetzner and free alternatives
7. [ ] Vendure vs Medusa comparison is included
8. [ ] Feature checklist with priorities is present
9. [ ] No console errors (N/A - documentation only)
10. [ ] Document validates as proper Markdown

## QA Acceptance Criteria

**CRITICAL**: These criteria must be verified by the QA Agent before sign-off.

### Unit Tests

| Test | File | What to Verify |
|------|------|----------------|
| Markdown Lint | `ROADMAP.md` | Document passes markdown linting (no syntax errors) |
| Link Validation | `ROADMAP.md` | All external links are valid (if any) |

### Integration Tests

| Test | Services | What to Verify |
|------|----------|----------------|
| Script Execution | All services | Sample scripts are syntactically valid bash/shell |
| Command Accuracy | CLI tools | Documented CLI commands match current tool versions |

### End-to-End Tests

| Flow | Steps | Expected Outcome |
|------|-------|------------------|
| Roadmap Completeness | 1. Read ROADMAP.md 2. Check all phases 3. Verify features list | All required sections present |
| Script Validity | 1. Review each script block 2. Validate syntax | No syntax errors in code blocks |

### Document Verification

| Check | Command | Expected |
|-------|---------|----------|
| File exists | `ls -la ROADMAP.md` | File is present |
| Minimum length | `wc -l ROADMAP.md` | At least 200 lines |
| Phase count | `grep -c "^## Phase" ROADMAP.md` | At least 5 phases |
| Task count | `grep -c "^\- \[ \]" ROADMAP.md` | At least 30 tasks |

### Content Verification

| Section | Grep Pattern | What to Verify |
|---------|--------------|----------------|
| Astro setup | `grep -i "astro" ROADMAP.md` | Astro configuration documented |
| Cloudflare setup | `grep -i "cloudflare\|wrangler" ROADMAP.md` | Cloudflare tools documented |
| Medusa setup | `grep -i "medusa" ROADMAP.md` | Medusa 2.0 configuration documented |
| Coolify setup | `grep -i "coolify" ROADMAP.md` | Coolify deployment documented |
| Supabase setup | `grep -i "supabase" ROADMAP.md` | Supabase configuration documented |
| Deno setup | `grep -i "deno" ROADMAP.md` | Deno runtime documented |
| Contact form | `grep -i "contact.*form\|form.*contact" ROADMAP.md` | Contact form feature included |
| VPS options | `grep -i "hetzner\|vps" ROADMAP.md` | VPS options documented |
| Vendure comparison | `grep -i "vendure" ROADMAP.md` | Vendure vs Medusa comparison present |

### QA Sign-off Requirements
- [ ] ROADMAP.md exists and is valid Markdown
- [ ] All 5+ phases are present and properly structured
- [ ] Every service in the stack has setup documentation
- [ ] CLI tools documented for each service
- [ ] Contact form + PostgreSQL integration documented
- [ ] VPS options (paid and free) are included
- [ ] Vendure vs Medusa comparison is thorough
- [ ] Feature checklist is comprehensive
- [ ] Code blocks have proper syntax highlighting
- [ ] Document is readable and well-organized
