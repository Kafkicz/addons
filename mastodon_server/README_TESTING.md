# Lokální testování Mastodon Add-onu

Tento add-on byl opraven, aby se předešlo chybám při kompilaci Ruby gemů (`posix-spawn`, `cbor`) v prostředí Alpine Linux.

## Co bylo opraveno:
1. **Dockerfile**: Přenastaven na stabilní repozitáře **Alpine 3.20**. Ruby 3.4 (výchozí v Alpine 3.23) není kompatibilní s verzí Mastodonu 4.2.9.
2. **Závislosti**: Opraven název balíčku `postgresql-dev` (původně chybně `libpq-dev`), což umožnilo úspěšnou kompilaci PostgreSQL rozšíření pro Ruby.

## Jak to vyzkoušet lokálně (na localhostu):
Pokud máte nainstalovaný Docker Desktop, můžete spustit Mastodon lokálně pro ověření:

1. **Generování SSL certifikátů**:
   Nginx v kontejneru vyžaduje SSL. Spusťte tento příkaz (pokud máte openssl):
   ```bash
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout test_ssl/privkey.pem -out test_ssl/fullchain.pem -subj "/CN=localhost"
   ```

2. **Spuštění stacku**:
   V adresáři `mastodon_server` spusťte:
   ```bash
   docker-compose -f docker-compose.test.yaml up --build
   ```

3. **Přístup**:
   Mastodon bude dostupný na `https://localhost`. (Budete muset potvrdit bezpečnostní výjimku pro self-signed certifikát).

## Poznámky k Home Assistantu:
Pokud chcete add-on nasadit přímo v Home Assistantu:
1. Ujistěte se, že soubory jsou v `/addons/mastodon_server`.
2. V HA přejděte do **Nastavení > Doplňky > Obchod s doplňky**.
3. Klikněte na tři tečky vpravo nahoře > **Aktualizovat**.
4. Mastodon by se měl objevit v sekci „Local add-ons“.
5. Klikněte na **Instalovat**. Build by nyní měl proběhnout úspěšně.
