# Home Assistant Add-on: Mastodon Server

## Installation

Use the following steps to install this add-on.

1. Add this repository to your Home Assistant instance:
  [![Open this add-on in your Home Assistant instance.][addon-badge]][addon]
   `https://github.com/Kafkicz/addons`
2. Find the "Mastodon Server" add-on in the Add-on Store.
3. Click the "Install" button to install the add-on.

## How to use

After installation, you need to configure the add-on with your domain and other settings.

1. Go to the "Configuration" tab.
2. Set the `domain` to your public domain name (e.g., `mastodon.example.com`).
3. Set the `mastodon_instance_name` to your preferred instance name.
4. If you have SSL certificates in the `/ssl` folder, ensure the `ssl_certificate_path` is correct.
5. Start the add-on.

### External Access

Mastodon requires a public domain and valid SSL certificates to function correctly in the Fediverse. Ensure your router/firewall forwards ports 80 and 443 to your Home Assistant instance if you are not using a proxy like Nginx Proxy Manager.

## Configuration

Add-on configuration:

| Configuration | Description |
| --- | --- |
| `domain` | Your public domain name for the Mastodon instance. |
| `mastodon_instance_name` | The name of your Mastodon instance. |
| `ssl_certificate_path` | Path to your SSL certificates (default: `/ssl`). |
| `db_host` | Hostname for the PostgreSQL database. |
| `db_user` | Username for the database. |
| `db_pass` | Password for the database. |
| `db_name` | Name of the database. |

## Support

Got questions?

- [GitHub Issues](https://github.com/Kafkicz/addons/issues)
- [Home Assistant Community Forum](https://community.home-assistant.io)
- [Mastodon Documentation](https://docs.joinmastodon.org/)

[issue]: https://github.com/Kafkicz/addons/issues
