# Escalabilidade via Modelo de Processos (Concorrência)

**ID**: INFRASTRUCTURE-047
**Severidade**: 🟠 Alto
**Categoria**: Infraestrutura

---

## O que é

A aplicação deve escalar horizontalmente por meio da execução de **múltiplos processos independentes**, não por meio de threads internas ou um único processo monolítico. Diferentes tipos de trabalho (web, worker, scheduler) devem ser separados em tipos de processo distintos.

## Por que importa

O modelo de processos permite escalabilidade elástica — adicionar mais processos web para lidar com tráfego, ou mais workers para processar filas. Cada tipo de processo pode ser escalado independentemente de acordo com a demanda, otimizando recursos.

## Critérios Objetivos

- [ ] A aplicação deve suportar a execução de **múltiplas instâncias** do mesmo processo sem conflito.
- [ ] Cargas de trabalho diferentes (HTTP, background jobs, tarefas agendadas) devem ser separadas em processos distintos.
- [ ] O processo não deve *daemonizar* ou escrever arquivos PID — o gerenciamento de processos é responsabilidade do ambiente de execução.

## Exceções Permitidas

- **Workers Internos**: Uso de worker threads para operações CPU-bound dentro de uma requisição, desde que o estado não seja compartilhado entre requisições.

## Como Detectar

### Manual

Verificar se a aplicação pode executar N instâncias simultâneas com um load balancer na frente, sem conflitos.

### Automático

Testes de carga: Escalar horizontalmente e verificar se o throughput aumenta linearmente.

## Relacionado a

- [045 - Processos Stateless](../twelve-factor/006_processos-stateless.md): complementa
- [046 - Port Binding](../twelve-factor/007_port-binding.md): complementa
- [048 - Descartabilidade de Processos](../twelve-factor/009_descartabilidade-processos.md): reforça
- [010 - Princípio da Responsabilidade Única](001_single-responsibility-principle.md): reforça

---

**Criado em**: 2025-01-10
**Versão**: 1.0
