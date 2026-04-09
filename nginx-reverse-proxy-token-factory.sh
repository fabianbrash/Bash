#!/bin/bash

# Define variables
CONF_PATH="/etc/nginx/sites-available/qwen_proxy"
LINK_PATH="/etc/nginx/sites-enabled/qwen_proxy"
DEFAULT_ENABLED="/etc/nginx/sites-enabled/default"
BASHRC="$HOME/.bashrc"

echo "🚀 Starting Nginx Proxy Setup..."

# 1. Create the configuration file
echo "📝 Creating qwen_proxy configuration..."
sudo tee $CONF_PATH > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name *.genai-apps.fbclouddemo.us;

    # SSL Certs
    ssl_certificate /etc/ssl/certs/gen-ai-fullchain1.pem;
    ssl_certificate_key /etc/ssl/private/gen-ai-privkey1.pem;

    # Header Buffers (Inside server, but outside location)
    large_client_header_buffers 4 128k;

    location / {
        proxy_pass https://192.9.139.71:31444;

        # Identity & SSL
        proxy_ssl_server_name on;
        proxy_ssl_name models-qwen.genai-apps.fbclouddemo.us;
        proxy_set_header Host models-qwen.genai-apps.fbclouddemo.us;
        proxy_ssl_verify off;

        # Local buffers for large JWTs
        proxy_buffer_size 128k;
        proxy_buffers 4 256k;
        proxy_busy_buffers_size 256k;

        # Proxy Logic
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_buffering off;
        proxy_pass_request_headers on;
        
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_read_timeout 600s;
    }
}
EOF

# 2. Enable the site and remove the default
echo "🧹 Cleaning up default configurations..."
[ -f "$DEFAULT_ENABLED" ] && sudo rm "$DEFAULT_ENABLED"
sudo ln -sf $CONF_PATH $LINK_PATH

# 3. Test and Restart
echo "⚙️ Testing Nginx configuration..."
if sudo nginx -t; then
    echo "✅ Config valid. Restarting Nginx..."
    sudo systemctl restart nginx
else
    echo "❌ Nginx config test failed! Please check your SSL certificate paths."
    exit 1
fi

# 4. Persistence for SSL Bypass
echo "🔗 Adding SSL bypass to .bashrc..."
LINE_TO_ADD="export NODE_TLS_REJECT_UNAUTHORIZED=0"
if ! grep -Fxq "$LINE_TO_ADD" "$BASHRC"; then
    echo "$LINE_TO_ADD" >> "$BASHRC"
    echo "✅ Added to .bashrc"
else
    echo "ℹ️  Bypass already exists in .bashrc"
fi

# Apply to current session
source "$BASHRC"

# 5. Final Reminders
echo "----------------------------------------------------------------"
echo "✅ SETUP COMPLETE"
echo "----------------------------------------------------------------"
echo "⚠️  REMINDER: On the CLIENT (OpenClaw) machine, edit /etc/hosts:"
echo "   Add: <NGINX_VM_IP> models-qwen.genai-apps.fbclouddemo.us"
echo ""
echo "💡 The SSL bypass is now permanent. Restart your terminal or run:"
echo "   source ~/.bashrc"
echo "----------------------------------------------------------------"
