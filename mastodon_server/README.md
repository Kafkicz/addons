# Mastodon Server Home Assistant Add-on

Tento projekt implementuje plnohodnotnou instanci Mastodon (Fediverse) jako doplněk pro Home Assistant.

## Architektura
- **Mastodon Core**: Ruby on Rails backend a Node.js streaming server.
- **Nginx**: Reverzní proxy pro směrování provozu a SSL terminaci.
- **PostgreSQL & Redis**: Databázové a kešovací vrstvy (předpokládá se externí nebo sdílený kontejner).

## Instalace
1. Přidejte URL tohoto repozitář do Home Assistant Add-on Store.
2. Nainstalujte "Mastodon Server".
3. V záložce 'Configuration' nastavte svou doménu.
4. Spusťte add-on.
