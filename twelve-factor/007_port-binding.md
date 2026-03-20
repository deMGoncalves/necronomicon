# Exposição de Serviços via Port Binding

**ID**: INFRASTRUCTURE-046
**Severidade**: 🟠 Alto
**Categoria**: Infraestrutura

---

## O que é

A aplicação deve ser **completamente autocontida** e expor seus serviços por meio de *port binding*. Não deve depender de um servidor web externo (Apache, Nginx) injetado em tempo de execução para ser executável — o servidor HTTP deve estar embutido na aplicação.

## Por que importa

O port binding garante que a aplicação seja portável e possa ser executada em qualquer ambiente sem configuração de servidor externo. A aplicação se torna um serviço que pode ser consumido por outras aplicações via URL, criando uma arquitetura natural de microsserviços.

## Critérios Objetivos

- [ ] A aplicação deve iniciar seu próprio servidor HTTP/HTTPS e fazer *bind* em uma porta especificada por variável de ambiente.
- [ ] É proibido depender de configuração de servidor web externo (VirtualHost, .htaccess) para funcionar corretamente.
- [ ] A porta de execução deve ser configurável via variável `PORT` ou equivalente, não hardcoded.

## Exceções Permitidas

- **Reverse Proxy**: Uso de Nginx/HAProxy na frente da aplicação para terminação TLS, balanceamento de carga ou roteamento — desde que a aplicação funcione sem ele.
- **Aplicações Frontend SPA**: Aplicações estáticas servidas por CDN ou servidor de arquivos estáticos.

## Como Detectar

### Manual

Verificar se a aplicação pode ser iniciada e acessada apenas com `npm start` ou `bun run start`, sem configuração adicional de servidor.

### Automático

CI/CD: Testes que iniciam a aplicação em um container limpo e verificam se ela responde na porta configurada.

## Relacionado a

- [042 - Configurações via Ambiente](../twelve-factor/003_configuracoes-via-ambiente.md): reforça
- [043 - Serviços de Apoio como Recursos](../twelve-factor/004_servicos-apoio-recursos.md): complementa
- [047 - Concorrência via Modelo de Processos](../twelve-factor/008_concorrencia-via-processos.md): complementa
- [048 - Descartabilidade de Processos](../twelve-factor/009_descartabilidade-processos.md): complementa

---

**Criado em**: 2025-01-10
**Versão**: 1.0
