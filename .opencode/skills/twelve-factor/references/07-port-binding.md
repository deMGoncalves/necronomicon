# Factor 07 — Port Binding

**Rule deMGoncalves:** [046 - Port Binding](../../../rules/046_port-binding.md)
**Pergunta:** Aplicação auto-contida com HTTP server embutido (não depende de servidor externo)?

## O que é

A aplicação deve ser **completamente autocontida** e expor seus serviços através de *port binding*. Não deve depender de um servidor web externo (Apache, Nginx) injetado em runtime para ser executável — o servidor HTTP deve estar embutido na aplicação.

**Port binding = app portável + arquitetura de microserviços natural.**

## Critério de Conformidade

- [ ] Aplicação inicia seu próprio servidor HTTP/HTTPS e faz bind em porta especificada por variável de ambiente
- [ ] Zero dependência de configuração de servidor web externo (VirtualHost, .htaccess) para funcionar
- [ ] Porta de execução configurável via `PORT` ou equivalente (não hardcoded)

## ❌ Violação

```typescript
// Porta hardcoded ❌
const app = express();
app.listen(3000);  // não configurável

// Dependência de servidor externo ❌
// Apache + mod_proxy configurado em /etc/apache2/sites-enabled/
# VirtualHost necessário para app funcionar
<VirtualHost *:80>
  ProxyPass / http://localhost:3000/
</VirtualHost>
```

## ✅ Correto

```typescript
// Porta configurável via env var ✅
const app = express();
const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// Servidor HTTP embutido na aplicação
import { serve } from '@hono/node-server';
import { Hono } from 'hono';

const app = new Hono();
serve({ fetch: app.fetch, port: Number(process.env.PORT) });
```

## Codetag quando violado

```typescript
// FIXME: Porta hardcoded — use process.env.PORT
const PORT = 8080;
```
