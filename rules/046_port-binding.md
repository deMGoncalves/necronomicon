---
paths:
  - "**/*.yml"
  - "**/*.yaml"
  - "**/*.json"
  - "**/Dockerfile*"
  - "**/docker-compose*"
  - "**/.env*"
  - "**/package.json"
  - "**/tsconfig.json"
---

# Service Exposition via Port Binding

**ID**: INFRAESTRUTURA-046
**Severity**: 🟠 High
**Category**: Infrastructure

---

## What It Is

The application must be **completely self-contained** and expose its services through *port binding*. It must not depend on an external web server (Apache, Nginx) injected at runtime to be executable — the HTTP server must be embedded in the application.

## Why It Matters

Port binding ensures the application is portable and can be run in any environment without external server configuration. The application becomes a service that can be consumed by other applications via URL, creating a natural microservices architecture.

## Objective Criteria

- [ ] The application must start its own HTTP/HTTPS server and *bind* to a port specified by environment variable.
- [ ] Depending on external web server configuration (VirtualHost, .htaccess) to function correctly is prohibited.
- [ ] The execution port must be configurable via `PORT` or equivalent variable, not hardcoded.

## Allowed Exceptions

- **Reverse Proxy**: Use of Nginx/HAProxy in front of the application for TLS termination, load balancing, or routing — provided the application works without it.
- **Frontend SPA Applications**: Static applications served by CDN or static file server.

## How to Detect

### Manual

Check if the application can be started and accessed with just `npm start` or `bun run start`, without additional server configuration.

### Automatic

CI/CD: Tests that start the application in clean container and verify it responds on configured port.

## Related To

- [042 - Configuration via Environment](042_configuracoes-via-ambiente.md): reinforces
- [043 - Backing Services as Attached Resources](043_servicos-apoio-recursos.md): complements
- [047 - Concurrency via Process Model](047_concorrencia-via-processos.md): complements
- [048 - Process Disposability](048_descartabilidade-processos.md): complements

---

**Created on**: 2025-01-10
**Version**: 1.0
