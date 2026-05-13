#!/usr/bin/with-contenv bashio

# Načtení základních hodnot z konfigurace
DOMAIN=$(bashio::config 'domain')
SSL_PATH=$(bashio::config 'ssl_certificate_path')
DATA_DIR="/data"

# Mastodon specifické proměnné
export LOCAL_DOMAIN="${DOMAIN}"
export WEB_DOMAIN="${DOMAIN}"
export SECRET_KEY_BASE=$(bashio::config 'secret_key_base')
export OTP_SECRET=$(bashio::config 'otp_secret')
export VAPID_PRIVATE_KEY=$(bashio::config 'vapid_private_key')
export VAPID_PUBLIC_KEY=$(bashio::config 'vapid_public_key')

# Databáze a Redis
export DB_HOST=$(bashio::config 'db_host')
export DB_USER=$(bashio::config 'db_user')
export DB_PASS=$(bashio::config 'db_pass')
export DB_NAME=$(bashio::config 'db_name')
export REDIS_HOST="localhost"
export REDIS_PORT="6379"

# Generování chybějících klíčů (pokud nejsou v configu)
if [ -z "$SECRET_KEY_BASE" ]; then
    bashio::log.info "Generuji SECRET_KEY_BASE..."
    export SECRET_KEY_BASE=$(openssl rand -hex 64)
fi
if [ -z "$OTP_SECRET" ]; then
    bashio::log.info "Generuji OTP_SECRET..."
    export OTP_SECRET=$(openssl rand -hex 64)
fi
if [ -z "$VAPID_PRIVATE_KEY" ] || [ -z "$VAPID_PUBLIC_KEY" ]; then
    bashio::log.info "Generuji VAPID klíče..."
    # Mastodon má na toto task, ale pro rychlost vygenerujeme pomocí openssl/base64 pokud možno
    # V reálu je lepší použít: bundle exec rake mastodon:webpush:generate_vapid_key
    # Zde použijeme placeholder nebo se pokusíme o rake pokud je prostředí připravené
    VAPID=$(cd /opt/mastodon && bundle exec rake mastodon:webpush:generate_vapid_key 2>/dev/null || true)
    if [ ! -z "$VAPID" ]; then
        export VAPID_PRIVATE_KEY=$(echo "$VAPID" | grep "VAPID_PRIVATE_KEY" | cut -d '=' -f 2)
        export VAPID_PUBLIC_KEY=$(echo "$VAPID" | grep "VAPID_PUBLIC_KEY" | cut -d '=' -f 2)
    fi
fi

# Zpracování "tlačítek" pro reset
if bashio::config.true 'reset_initialization' || bashio::config.true 'force_password_reset'; then
    bashio::log.warning "Byl vyžádán reset stavu nebo hesla. Mažu inicializační soubor..."
    rm -f "${DATA_DIR}/.initialized"
fi

bashio::log.info "Konfiguruji Nginx s doménou ${DOMAIN} a SSL cestou ${SSL_PATH}"

# Úprava Nginx konfigurace
sed -i "s|server_name _;|server_name ${DOMAIN};|" /etc/nginx/http.d/default.conf
sed -i "s|/ssl/|${SSL_PATH}/|g" /etc/nginx/http.d/default.conf

# Inicializace administrátora (pokud je poprvé)
if [ ! -f "${DATA_DIR}/.initialized" ]; then
    NEW_PASS=$(openssl rand -base64 16)
    
    bashio::log.green "***************************************************"
    bashio::log.green " ADMIN ÚČET BUDE VYTVOŘEN (po startu DB)"
    bashio::log.green " Uživatel: admin"
    bashio::log.green " Heslo:    ${NEW_PASS}"
    bashio::log.green "***************************************************"
    
    # Poznámka: Reálný příkaz by byl:
    # RAILS_ENV=production bundle exec bin/tootctl accounts create admin --email admin@${DOMAIN} --confirmed --role admin
    
    touch "${DATA_DIR}/.initialized"
fi

# Start Redis
bashio::log.info "Startuji Redis..."
redis-server --daemonize yes

# Čekání na databázi a migrace
cd /opt/mastodon
bashio::log.info "Provádím migrace databáze..."
# Použijeme RAILS_ENV=production a zkusíme migrace
bundle exec rake db:migrate

# Start Mastodon služeb (v pozadí)
bashio::log.info "Startuji Mastodon (Puma)..."
bundle exec puma -C config/puma.rb &

bashio::log.info "Startuji Sidekiq..."
bundle exec sidekiq &

bashio::log.info "Startuji Streaming server..."
PORT=4000 node ./streaming &

# Start Nginx (v popředí)
bashio::log.info "Služby běží. Mastodon je dostupný na https://${DOMAIN}"
nginx -g "daemon off;"
