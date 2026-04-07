# Factor 07 — Port Binding

**deMGoncalves Rule:** [046 - Port Binding](../../../rules/046_port-binding.md)
**Question:** Self-contained app with embedded HTTP server (doesn't depend on external server)?

## What It Is

The application must be **completely self-contained** and expose its services through *port binding*. It should not depend on an external web server (Apache, Nginx) injected at runtime to be executable — the HTTP server must be embedded in the application.

**Port binding = portable app + natural microservices architecture.**

## Compliance Criteria

- [ ] Application starts its own HTTP/HTTPS server and binds to port specified by environment variable
- [ ] Zero dependency on external web server configuration (VirtualHost, .htaccess) to function
- [ ] Execution port configurable via `PORT` or equivalent (not hardcoded)

## ❌ Violation

```typescript
// Hardcoded port ❌
const app = express();
app.listen(3000);  // not configurable

// External server dependency ❌
// Apache + mod_proxy configured in /etc/apache2/sites-enabled/
# VirtualHost needed for app to work
<VirtualHost *:80>
  ProxyPass / http://localhost:3000/
</VirtualHost>
```

## ✅ Good

```typescript
// Configurable port via env var ✅
const app = express();
const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// Embedded HTTP server in application
import { serve } from '@hono/node-server';
import { Hono } from 'hono';

const app = new Hono();
serve({ fetch: app.fetch, port: Number(process.env.PORT) });
```

## Codetag when violated

```typescript
// FIXME: Hardcoded port — use process.env.PORT
const PORT = 8080;
```
