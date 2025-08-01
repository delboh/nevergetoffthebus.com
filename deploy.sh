#!/bin/bash
# deploy.sh - Simple Hugo deployment script for static text-only blog

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="/var/www/nevergetoffthebus"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

log "📁 Deploying from: $REPO_DIR"
cd "$REPO_DIR"

log "🧹 Cleaning $BUILD_DIR..."
sudo rm -rf "$BUILD_DIR"/*
sudo mkdir -p "$BUILD_DIR"

log "🏗️  Building site with Hugo..."
sudo hugo --minify --destination "$BUILD_DIR"

log "🔐 Setting permissions..."
sudo chown -R www-data:www-data "$BUILD_DIR"
sudo chmod -R 755 "$BUILD_DIR"

log "✅ Deployment complete: $BUILD_DIR"
