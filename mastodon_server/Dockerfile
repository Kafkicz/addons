# 1. Definice základního obrazu z ekosystému Home Assistant
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# Build arguments
ARG MASTODON_VERSION="v4.2.9"

# 2. Instalace systémových závislostí
# Instalujeme balíčky pro Mastodon (Ruby, Node), Nginx a pomocné utility
RUN apk add --no-cache \
    nginx \
    nodejs \
    yarn \
    ruby \
    ruby-bundler \
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
# Používáme verzi definovanou v argumentu
RUN git clone --depth 1 --branch ${MASTODON_VERSION} https://github.com/mastodon/mastodon.git . \
    && bundle config set --local deployment 'true' \
    && bundle config set --local without 'development test' \
    && bundle install -j$(getconf _NPROCESSORS_ONLN) \
    && yarn install --pure-lockfile

# 5. Příprava souborového systému pro Home Assistant
COPY rootfs /

# 6. Nastavení oprávnění a Ingressu
RUN chmod a+x /run.sh \
    && mkdir -p /run/nginx \
    && chown -R nginx:nginx /var/lib/nginx

# 7. Expozice portů
EXPOSE 80 443

# 8. Startovací příkaz
CMD [ "/run.sh" ]
