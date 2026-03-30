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

# Logs como Fluxo de Eventos (Logs)

**ID**: INFRAESTRUTURA-050
**Severidade**: 🔴 Crítica
**Categoria**: Infraestrutura

---

## O que é

A aplicação deve tratar logs como um **fluxo contínuo de eventos** ordenados por tempo, escritos em `stdout`. A aplicação nunca deve se preocupar com roteamento, armazenamento, ou rotação de logs — isso é responsabilidade do ambiente de execução.

## Por que importa

Logs em arquivos locais são perdidos quando containers são destruídos, difíceis de agregar em sistemas distribuídos, e criam dependência de filesystem. Stdout permite que o ambiente de execução capture, agregue, e roteie logs para qualquer destino.

## Critérios Objetivos

- [ ] Todos os logs devem ser escritos em **stdout** (ou stderr para erros), nunca em arquivos locais.
- [ ] É proibido o uso de bibliotecas de logging que escrevem diretamente em arquivos ou fazem rotação de logs.
- [ ] Logs devem ser estruturados (JSON) para facilitar parsing e análise automatizada.

## Exceções Permitidas

- **Ambiente de Desenvolvimento Local**: Formatação colorida e legível para console em dev, desde que stdout seja mantido.
- **Logs de Debug Temporários**: `console.log` para debugging local, removidos antes do commit.

## Como Detectar

### Manual

Verificar configuração de bibliotecas de logging para identificar escritas em arquivo ou configuração de rotação.

### Automático

Análise de código: Busca por configurações de `FileAppender`, `RotatingFileHandler`, ou caminhos de arquivo em logging.

## Relacionada com

- [027 - Qualidade no Tratamento de Erros](027_qualidade-tratamento-erros-dominio.md): complementa
- [045 - Processos Stateless](045_processos-stateless.md): reforça
- [048 - Descartabilidade de Processos](048_descartabilidade-processos.md): complementa
- [026 - Qualidade de Comentários](026_qualidade-comentarios-porque.md): complementa

---

**Criada em**: 2025-01-10
**Versão**: 1.0
