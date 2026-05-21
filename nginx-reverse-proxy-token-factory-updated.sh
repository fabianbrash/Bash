#!/bin/bash
# =============================================================================
# Nginx Reverse Proxy Setup — fbdemoes.net / Rafay Token Factory
# =============================================================================
# Usage: sudo bash setup-nginx-proxy.sh
# =============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; exit 1; }
section() { echo -e "\n${BOLD}━━━  $*  ━━━${NC}"; }

# ── Root check ────────────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
  error "Please run as root: sudo bash $0"
fi

# =============================================================================
# STEP 0 — Collect model info interactively
# =============================================================================
section "Model Configuration"

echo ""
read -rp "  Model subdomain  (e.g. nemotron-model)  : " MODEL_SUBDOMAIN
read -rp "  Backend IP                               : " BACKEND_IP
read -rp "  Backend Port     (e.g. 32314)            : " BACKEND_PORT

# Derived values
DOMAIN="fbdemoes.net"
FULL_HOSTNAME="${MODEL_SUBDOMAIN}.${DOMAIN}"
CONF_NAME="${MODEL_SUBDOMAIN}-proxy"
CONF_PATH="/etc/nginx/sites-available/${CONF_NAME}"
LINK_PATH="/etc/nginx/sites-enabled/${CONF_NAME}"

# SSL cert paths (assumed to already be on the VM)
SSL_CERT="/etc/ssl/certs/star-fbdemoes.pem"
SSL_KEY="/etc/ssl/private/star-fbdemoes-privkey1.pem"

echo ""
info "Will configure:"
echo "    Hostname   : ${FULL_HOSTNAME}"
echo "    Backend    : https://${BACKEND_IP}:${BACKEND_PORT}"
echo "    Nginx conf : ${CONF_PATH}"
echo "    SSL cert   : ${SSL_CERT}"
echo "    SSL key    : ${SSL_KEY}"
echo ""
read -rp "  Looks good? Continue? [Y/n]: " CONFIRM
CONFIRM=${CONFIRM:-Y}
[[ "$CONFIRM" =~ ^[Yy]$ ]] || { info "Aborted."; exit 0; }

# =============================================================================
# STEP 1 — Install nginx
# =============================================================================
section "Installing Nginx"

if command -v nginx &>/dev/null; then
  success "Nginx already installed ($(nginx -v 2>&1 | tr -d '\n'))"
else
  info "Running apt update..."
  apt-get update -qq
  info "Installing nginx..."
  apt-get install -y nginx
  success "Nginx installed"
fi

# =============================================================================
# STEP 2 — Verify SSL certs exist
# =============================================================================
section "Verifying SSL Certificates"

CERT_OK=true
if [[ ! -f "$SSL_CERT" ]]; then
  warn "Certificate not found: ${SSL_CERT}"
  CERT_OK=false
fi
if [[ ! -f "$SSL_KEY" ]]; then
  warn "Private key not found: ${SSL_KEY}"
  CERT_OK=false
fi

if [[ "$CERT_OK" == false ]]; then
  echo ""
  warn "One or more cert files are missing."
  warn "Place them at the paths above, then re-run this script."
  warn "Continuing anyway — nginx config test will fail if certs are absent."
  echo ""
fi

# =============================================================================
# STEP 3 — Write nginx config
# =============================================================================
section "Writing Nginx Config → ${CONF_PATH}"

cat > "${CONF_PATH}" <<EOF
# =============================================================================
# Nginx Reverse Proxy — ${FULL_HOSTNAME}
# Backend : https://${BACKEND_IP}:${BACKEND_PORT}
# Generated: $(date)
# =============================================================================

server {
    listen 443 ssl;
    server_name *.${DOMAIN};

    # SSL Certs (wildcard — covers all *.${DOMAIN})
    ssl_certificate     ${SSL_CERT};
    ssl_certificate_key ${SSL_KEY};

    # Large header buffers — handles big Rafay JWTs
    large_client_header_buffers 4 128k;

    location / {
        proxy_pass https://${BACKEND_IP}:${BACKEND_PORT};

        # Backend TLS identity
        proxy_ssl_server_name on;
        proxy_ssl_name        ${FULL_HOSTNAME};
        proxy_set_header Host ${FULL_HOSTNAME};
        proxy_ssl_verify      off;

        # Response buffer sizing
        # Tune proxy_buffers up for larger/reasoning models
        proxy_buffer_size        128k;
        proxy_buffers            4 256k;
        proxy_busy_buffers_size  256k;

        # Do NOT buffer the full request before forwarding.
        # Critical for large-context models (32k+ tokens).
        proxy_request_buffering off;

        # Stream responses to the client immediately.
        # Prevents nginx holding back tokens during slow TTFT phases
        # (e.g. reasoning/thinking models like Nemotron).
        proxy_buffering off;
        proxy_cache     off;
        aio             off;

        # HTTP/1.1 keepalive to backend
        proxy_http_version 1.1;
        proxy_set_header Connection "";

        # Pass all upstream headers through
        proxy_pass_request_headers on;
        proxy_set_header X-Real-IP \$remote_addr;

        # Generous timeouts — covers slow TTFT and long generation runs
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
    }
}

# Redirect plain HTTP → HTTPS
server {
    listen 80;
    server_name *.${DOMAIN};
    return 301 https://\$host\$request_uri;
}
EOF

success "Config written"

# =============================================================================
# STEP 4 — /etc/hosts entry for backend resolution
# =============================================================================
section "Updating /etc/hosts"

HOSTS_ENTRY="${BACKEND_IP}  ${FULL_HOSTNAME}"
HOSTS_MARKER="# nginx-proxy: ${FULL_HOSTNAME}"

if grep -qF "${FULL_HOSTNAME}" /etc/hosts; then
  warn "Entry for ${FULL_HOSTNAME} already exists in /etc/hosts — skipping"
  grep "${FULL_HOSTNAME}" /etc/hosts
else
  {
    echo ""
    echo "${HOSTS_MARKER}"
    echo "${HOSTS_ENTRY}"
  } >> /etc/hosts
  success "Added: ${HOSTS_ENTRY}"
fi

# =============================================================================
# STEP 5 — Enable site, disable default
# =============================================================================
section "Enabling Site"

# Remove the default site if it's still enabled
DEFAULT_ENABLED="/etc/nginx/sites-enabled/default"
if [[ -f "$DEFAULT_ENABLED" ]]; then
  rm "$DEFAULT_ENABLED"
  info "Removed default site symlink"
fi

# Create symlink for our config
ln -sf "${CONF_PATH}" "${LINK_PATH}"
success "Symlink created: ${LINK_PATH}"

# =============================================================================
# STEP 6 — Test & restart nginx
# =============================================================================
section "Testing & Restarting Nginx"

if nginx -t 2>&1; then
  success "Nginx config valid"
  systemctl enable nginx --quiet
  systemctl restart nginx
  success "Nginx restarted"
else
  echo ""
  error "Nginx config test FAILED. Check the errors above. Nginx was NOT restarted."
fi

# =============================================================================
# STEP 7 — Summary
# =============================================================================
section "Setup Complete"

echo ""
echo -e "  ${GREEN}✔${NC}  Nginx installed and running"
echo -e "  ${GREEN}✔${NC}  Proxy config : ${CONF_PATH}"
echo -e "  ${GREEN}✔${NC}  /etc/hosts   : ${HOSTS_ENTRY}"
echo ""
echo -e "  ${YELLOW}NOTE:${NC} /etc/cloud/cloud.cfg may overwrite /etc/hosts on reboot."
echo "        To make the hosts entry permanent, also add it to:"
echo "        /etc/cloud/templates/hosts.debian.tmpl"
echo ""
echo -e "  ${YELLOW}NOTE:${NC} To add another model later, just re-run this script."
echo "        Each model gets its own config file in sites-available."
echo ""
echo -e "  ${CYAN}Test your proxy:${NC}"
echo "    curl -k https://${FULL_HOSTNAME}/v1/models"
echo ""
