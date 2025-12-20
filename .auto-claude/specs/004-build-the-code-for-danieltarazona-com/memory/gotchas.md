# Gotchas & Pitfalls

Things to watch out for in this codebase.

## [2025-12-20 16:36]
Cloudflare Pages preview URL (*.pages.dev) doesn't exist until first deployment. The project is created on first wrangler pages deploy command. Cannot verify subtask-1-3 until PR is merged to main and GitHub Actions workflow completes.

_Context: Infrastructure deployment task - Cloudflare Pages project 'danieltarazona-com' doesn't exist yet because deploy workflow only triggers on push to main/master branch. Subtasks 1-1 and 1-2 set up the workflow but it hasn't been triggered._

## [2025-12-20 16:40]
Subtask-1-3 verification requires external user action (PR merge) before it can be completed. Local verification (npm build, sitemap check) can be done, but remote verification (*.pages.dev URL) is impossible until the deployment workflow runs. This subtask has a hard dependency on user completing the PR merge process documented in build-progress.txt.

_Context: Retry #2 of subtask-1-3 - Cloudflare Pages deployment verification. The *.pages.dev subdomain doesn't exist until the first deployment, which requires the deploy.yml workflow to be on main branch and triggered. All local verification passed but remote verification is blocked by external user action._
