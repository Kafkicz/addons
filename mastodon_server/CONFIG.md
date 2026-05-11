# Konfigurační příručka (CONFIG.md)

| Klíč | Popis | Výchozí hodnota |
|------|-------|----------------|
| `domain` | Veřejná doména vaší instance (nutné pro federaci) | `example.local` |
| `mastodon_instance_name` | Název vaší sítě viditelný pro ostatní | `Moje HA Instance` |

### Síťové nastavení
Add-on vyžaduje otevřené porty 80 a 443 pro komunikaci s ostatními servery ve Fediverse. Nginx automaticky využívá certifikáty ze složky `/ssl/`.
