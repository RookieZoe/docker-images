# TokenHub Docker Image

[![status](https://img.shields.io/github/actions/workflow/status/RookieZoe/docker-images/tokenhub.yml?label=tokenhub&logo=github&logoColor=959da5)](https://github.com/RookieZoe/docker-images/actions/workflows/tokenhub.yml)
[![rookiezoe/tokenhub:latest](https://img.shields.io/docker/v/rookiezoe/tokenhub?color=086dd7&label=rookiezoe%2Ftokenhub%3Alatest&logo=docker&logoColor=fff)](https://hub.docker.com/r/rookiezoe/tokenhub/tags?page=1&ordering=last_updated)

Self-built docker image for [TokenHub](https://github.com/astaxie/TokenHub) (private enterprise AI gateway).

Builds the upstream [backend/Dockerfile](https://github.com/astaxie/TokenHub/blob/main/backend/Dockerfile)
from the `main` branch — a single image containing the Go backend and the
Next.js admin console. Supports `linux/amd64` and `linux/arm64`.

The GitHub Actions workflow runs daily and on manual dispatch: it detects the
latest upstream release (falling back to the latest Git tag), compares it with
the newest tag already pushed to Docker Hub, and rebuilds only when a newer
version is available. Tags: `latest` + upstream version (e.g. `0.5.0`).

> The upstream project also publishes images to `ghcr.io/astaxie/tokenhub-backend`,
> but only when its maintainers publish a Release. This self-built image gives a
> build cadence we control.

## Usage

```bash
docker run -d --name tokenhub \
  -p 8080:8080 -p 3000:3000 \
  -v tokenhub-data:/app/data \
  -v tokenhub-releases:/opt/tokenhub \
  -e TOKENHUB_ADMIN_TOKEN=change-me \
  -e TOKENHUB_BOOTSTRAP_ADMIN_PASSWORD=change-me \
  -e TOKENHUB_SECRET_KEY=change-me \
  rookiezoe/tokenhub:latest
```

- Admin console: http://localhost:3000
- API / OpenAI-compatible endpoints: http://localhost:8080

For a full PostgreSQL + application Compose deployment, see the
`d_tokenhub` directory (`compose.yml` + `.env.example`).

## Key Environment Variables

| Variable | Default | Description |
| --- | --- | --- |
| `TOKENHUB_ADMIN_TOKEN` | `change-me-tokenhub-admin-token` | Admin API token (must change) |
| `TOKENHUB_BOOTSTRAP_ADMIN_PASSWORD` | `change-me-tokenhub-admin-password` | Initial admin password (must change) |
| `TOKENHUB_SECRET_KEY` | `change-me-tokenhub-secret-key` | Session/secret key (must change) |
| `TOKENHUB_DB_HOST` | unset (SQLite) | PostgreSQL host; when set the DSN is built from `TOKENHUB_DB_*` fields |
| `TOKENHUB_DB_PORT` | `5432` | PostgreSQL port |
| `TOKENHUB_DB_USER` / `TOKENHUB_DB_PASSWORD` / `TOKENHUB_DB_NAME` | — | PostgreSQL credentials / database |
| `TOKENHUB_PUBLIC_BASE_URL` | `http://localhost:8080` | Public base URL of the gateway |
| `TOKENHUB_API_BASE_URL` | `http://localhost:8080` | API base URL used by the admin console |

Full variable reference: `deploy/.env.example` in the upstream TokenHub repository.
