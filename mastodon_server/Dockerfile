# 1. Definice základního obrazu z ekosystému Home Assistant
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# 2. Instalace systémových závislostí
# Instalujeme balíčky pro Mastodon (Ruby, Node), Nginx a pomocné utility
RUN apk add --no-cache \
    nginx \
    nodejs \
    yarn \
    ruby \
    ruby-bundle \
    ruby-dev \
    postgresql-client \
    redis \
    imagemagick \
    ffmpeg \
    libpq-dev \
    libxml2-dev \
    libxslt-dev \
    pkgconfig \
    build-base \
    git \
    tzdata

# 3. Nastavení pracovního prostředí
ENV RAILS_ENV="production"
ENV NODE_ENV="production"
WORKDIR /opt/mastodon

# 4. Instalace Mastodon jádra
# V reálném buildu by zde proběhl clone specifické verze z GitHubu
RUN git clone --depth 1 https://github.com/mastodon/mastodon.git . \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install -j$(getconf _NPROCESSORS_ONLN) \
    && yarn install --pure-lockfile

# 5. Příprava souborového systému pro Home Assistant
# Kopírování konfiguračních souborů (nginx.conf, run.sh) z lokální složky rootfs do kontejneru
COPY rootfs /

# 6. Nastavení oprávnění a Ingressu
# Zajišťujeme, aby spouštěcí skript byl spustitelný
RUN chmod a+x /run.sh \
    && mkdir -p /run/nginx \
    && chown -R nginx:nginx /var/lib/nginx

# 7. Expozice portů
# Porty pro webový provoz a federaci, které spravuje Nginx
EXPOSE 80 443

# 8. Startovací příkaz
# Spouští inicializační skript, který nastaví parametry z HA konfigurace
CMD [ "/run.sh" ]
