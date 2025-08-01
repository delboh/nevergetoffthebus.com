#!/bin/bash
# deploy.sh - Safe Hugo deploy script for use in a Git post-merge or post-pull hook
#
# This script:
#  - Ensures it's running from the project root
#  - Runs `npm ci` to install exact versions of Tailwind, PostCSS, etc.
#  - Uses `sudo` to clear and rebuild the production site in /var/www/html
#  - Provides timestamped log output for traceability
#
# Requirements:
#  - Hugo (extended version) must be installed and in PATH
#  - Node.js + npm installed
#  - Sufficient sudo permissions to write to /var/www/html
#  - Script should live at the root of your Hugo project (next to package.json, config.toml, etc.)

set -euo pipefail  # Stop on any error, unset variable, or pipe failure

# Absolute path to the repo root (where this script lives)
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Destination directory served by your web server (adjust if needed)
BUILD_DIR="/var/www/nevergetoffthebus"

# Logging function: prints timestamped status messages
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Step 1: Confirm we're in the project directory
log "📁 Deploying from project root: $REPO_DIR"
cd "$REPO_DIR"

# Step 2: Reinstall exact versions of Node dependencies using npm ci
# This ensures consistent Tailwind/PostCSS behavior between local and server
log "📦 Running 'npm ci' to install exact dependencies..."
npm ci

# Step 3: Clear the deploy target directory (requires sudo)
# This ensures stale content (e.g. deleted posts or styles) doesn't linger in production
log "🧼 Cleaning existing content in $BUILD_DIR (requires sudo)..."
sudo rm -rf "$BUILD_DIR"/*
sudo mkdir -p "$BUILD_DIR"

# Step 4: Run Hugo to rebuild the site, minified, into /var/www/html
# This uses the local Hugo Pipes setup with Tailwind + PostCSS
log "🏗️ Building site with Hugo into $BUILD_DIR (with minification)..."
sudo hugo --minify --destination "$BUILD_DIR"

# Step 5: Ensure correct permissions for web server (optional but recommended)
log "🔐 Setting ownership and permissions for $BUILD_DIR..."
sudo chown -R www-data:www-data "$BUILD_DIR"
sudo chmod -R 755 "$BUILD_DIR"

# Done!
log "✅ Deployment complete. Your Hugo site is live at $BUILD_DIR"
