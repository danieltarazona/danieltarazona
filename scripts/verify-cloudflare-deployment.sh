#!/bin/bash
# Verification script for Cloudflare Pages deployment
# Run this after merging the PR and the GitHub Actions workflow completes

set -e

PAGES_URL="https://danieltarazona-com.pages.dev"
MAX_RETRIES=10
RETRY_DELAY=30

echo "=== Cloudflare Pages Deployment Verification ==="
echo ""
echo "Target URL: $PAGES_URL"
echo ""

# Function to check HTTP status
check_url() {
    local url=$1
    local status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 "$url" 2>/dev/null)
    echo "$status"
}

# Wait for DNS propagation and site availability
echo "[1/5] Waiting for Cloudflare Pages site to become available..."
for i in $(seq 1 $MAX_RETRIES); do
    status=$(check_url "$PAGES_URL")
    if [ "$status" = "200" ]; then
        echo "✓ Site is accessible (HTTP $status)"
        break
    elif [ "$status" = "000" ]; then
        echo "  Attempt $i/$MAX_RETRIES: DNS not resolving yet, retrying in ${RETRY_DELAY}s..."
    else
        echo "  Attempt $i/$MAX_RETRIES: HTTP $status, retrying in ${RETRY_DELAY}s..."
    fi

    if [ $i -eq $MAX_RETRIES ]; then
        echo "✗ FAILED: Site not accessible after $MAX_RETRIES attempts"
        echo "  Please check:"
        echo "  1. GitHub Actions workflow completed successfully"
        echo "  2. Cloudflare Pages project 'danieltarazona-com' exists"
        exit 1
    fi
    sleep $RETRY_DELAY
done

# Check homepage
echo ""
echo "[2/5] Verifying homepage loads correctly..."
homepage_status=$(check_url "$PAGES_URL")
if [ "$homepage_status" = "200" ]; then
    echo "✓ Homepage returns HTTP 200"
else
    echo "✗ FAILED: Homepage returned HTTP $homepage_status"
    exit 1
fi

# Check sitemap
echo ""
echo "[3/5] Verifying sitemap is accessible..."
sitemap_status=$(check_url "${PAGES_URL}/sitemap-index.xml")
if [ "$sitemap_status" = "200" ]; then
    echo "✓ Sitemap returns HTTP 200"

    # Verify sitemap content
    sitemap_content=$(curl -s "${PAGES_URL}/sitemap-index.xml")
    if echo "$sitemap_content" | grep -q "danieltarazona.com"; then
        echo "✓ Sitemap contains correct production URL"
    else
        echo "⚠ Warning: Sitemap may not contain expected production URL"
    fi
else
    echo "✗ FAILED: Sitemap returned HTTP $sitemap_status"
    exit 1
fi

# Check assets
echo ""
echo "[4/5] Verifying static assets load..."
# Extract first CSS file from homepage and check it
css_path=$(curl -s "$PAGES_URL" | grep -oE 'href="[^"]*\.css"' | head -1 | sed 's/href="//;s/"//')
if [ -n "$css_path" ]; then
    if [[ "$css_path" == /* ]]; then
        css_url="${PAGES_URL}${css_path}"
    else
        css_url="${PAGES_URL}/${css_path}"
    fi
    css_status=$(check_url "$css_url")
    if [ "$css_status" = "200" ]; then
        echo "✓ CSS assets load correctly"
    else
        echo "⚠ Warning: CSS returned HTTP $css_status"
    fi
else
    echo "⚠ Could not locate CSS file to verify"
fi

# Check for common error indicators
echo ""
echo "[5/5] Checking for errors..."
page_content=$(curl -s "$PAGES_URL")
if echo "$page_content" | grep -qi "error\|exception\|500\|404"; then
    echo "⚠ Warning: Page may contain error messages"
else
    echo "✓ No obvious errors detected"
fi

echo ""
echo "=== Verification Complete ==="
echo ""
echo "Summary:"
echo "  Site URL:    $PAGES_URL"
echo "  Status:      ✓ PASSED"
echo ""
echo "Manual verification checklist:"
echo "  [ ] Open $PAGES_URL in browser"
echo "  [ ] Verify homepage displays correctly"
echo "  [ ] Open DevTools and check for console errors"
echo "  [ ] Verify all images and assets load"
echo ""
