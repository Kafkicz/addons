# Release documentation for developers

## Mastodon Server Update Procedure

When updating the Mastodon version in the add-on follow these steps:

1. Update the `MASTODON_VERSION` argument in `build.yaml`.
2. Check if new system dependencies are required in `Dockerfile`.
3. If the database schema or configuration format has changed, set the `homeassistant` key in `config.yaml` to the minimum version of Home Assistant Core required if applicable.
4. Update the add-on version in `config.yaml`.
5. Update the changelog in `CHANGELOG.md`. Include a markdown link to the Mastodon release on GitHub.
