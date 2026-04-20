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

# Descartabilidade de Processos (Disposability)

**ID**: INFRAESTRUTURA-048
**Severidade**: 🔴 Crítica
**Categoria**: Infraestrutura

---

## O que é

Os processos da aplicação devem ser **descartáveis** — podem ser iniciados ou parados a qualquer momento. Isso requer startup rápido, shutdown graceful, e robustez contra terminação súbita (SIGTERM/SIGKILL).

## Por que importa

Descartabilidade permite deploys rápidos, escalabilidade elástica, e recuperação rápida de falhas. Processos que demoram para iniciar ou não tratam shutdown corretamente causam downtime, perda de dados, e degradação de serviço.

## Critérios Objetivos

- [ ] O tempo de **startup** do processo deve ser inferior a **10 segundos** para estar pronto para receber requisições.
- [ ] O processo deve tratar **SIGTERM** e finalizar requisições em andamento graciosamente antes de encerrar.
- [ ] Jobs de background devem ser **idempotentes** e usar padrões de retry, pois podem ser interrompidos a qualquer momento.

## Exceções Permitidas

- **Processos de Warm-up**: Processos que precisam carregar modelos ML ou caches grandes podem ter startup mais lento, desde que health checks reflitam o estado real.

## Como Detectar

### Manual

Medir tempo de startup e enviar SIGTERM durante processamento para verificar se finaliza graciosamente.

### Automático

Kubernetes: Configurar `terminationGracePeriodSeconds` e `readinessProbe` para validar comportamento.

## Relacionada com

- [045 - Processos Stateless](045_processos-stateless.md): reforça
- [046 - Port Binding](046_port-binding.md): complementa
- [047 - Concorrência via Processos](047_concorrencia-via-processos.md): reforça
- [028 - Tratamento de Exceção Assíncrona](028_tratamento-excecao-assincrona.md): reforça

---

**Criada em**: 2025-01-10
**Versão**: 1.0
