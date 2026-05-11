# Vývojářská dokumentace (DEVELOPMENT.md)

## Struktura projektu
- `Dockerfile`: Definice sestavení (Alpine Linux, Ruby, Node.js).
- `nginx.conf`: Konfigurace reverzní proxy.
- `rootfs/run.sh`: Iniciační skript pro propojení HA konfigurace s aplikací.

## Sestavení (Build Skill)
Pro lokální testování použijte:
```bash
ha addons build mastodon_server
```
