# Descartabilidade de Processos

**ID**: INFRASTRUCTURE-048
**Severidade**: 🔴 Crítico
**Categoria**: Infraestrutura

---

## O que é

Os processos da aplicação devem ser **descartáveis** — podem ser iniciados ou encerrados a qualquer momento. Isso requer inicialização rápida, desligamento gracioso e robustez contra encerramento abrupto (SIGTERM/SIGKILL).

## Por que importa

A descartabilidade permite deploys rápidos, escalabilidade elástica e recuperação ágil de falhas. Processos que demoram muito para iniciar ou não tratam o desligamento corretamente causam indisponibilidade, perda de dados e degradação do serviço.

## Critérios Objetivos

- [ ] O tempo de **inicialização** do processo deve ser inferior a **10 segundos** para estar pronto para receber requisições.
- [ ] O processo deve tratar **SIGTERM** e finalizar as requisições em andamento de forma graciosa antes de encerrar.
- [ ] Background jobs devem ser **idempotentes** e usar padrões de retry, pois podem ser interrompidos a qualquer momento.

## Exceções Permitidas

- **Processos de Warm-up**: Processos que precisam carregar modelos de ML ou grandes caches podem ter inicialização mais lenta, desde que os health checks reflitam o estado real.

## Como Detectar

### Manual

Medir o tempo de inicialização e enviar SIGTERM durante o processamento para verificar se ele finaliza graciosamente.

### Automático

Kubernetes: Configurar `terminationGracePeriodSeconds` e `readinessProbe` para validar o comportamento.

## Relacionado a

- [045 - Processos Stateless](../twelve-factor/006_processos-stateless.md): reforça
- [046 - Port Binding](../twelve-factor/007_port-binding.md): complementa
- [047 - Concorrência via Modelo de Processos](../twelve-factor/008_concorrencia-via-processos.md): reforça
- [028 - Tratamento de Exceção Assíncrona](../clean-code/tratamento-excecao-assincrona.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
