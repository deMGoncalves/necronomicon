# Proibição de Otimização Prematura

**ID**: AP-10-069
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Otimização Prematura ocorre quando o desenvolvedor otimiza código baseado em suspeita de lentidão, sem medir o problema real. Código legível e correto é sacrificado por ganho de performance hipotético. Donald Knuth: *"A otimização prematura é a raiz de todo mal."*

## Por que importa

- Complexidade acidental: código mais difícil de ler sem ganho mensurável
- Tempo desperdiçado: otimizações em código que não é gargalo não entregam valor
- Bugs introduzidos: código otimizado é mais frágil e difícil de corrigir
- Manutenção cara: otimizações prematuras são difíceis de desfazer depois

## Critérios Objetivos

- [ ] Otimização implementada sem medição prévia (profiling, benchmark, métricas de produção)
- [ ] Algoritmo complexo onde O(n²) seria imperceptível no volume real de dados
- [ ] Cache manual em camadas que já possuem caching nativo (ORM, banco de dados, HTTP)
- [ ] Micro-otimizações de linguagem (`for` vs `map`, `++i` vs `i++`) em código não-crítico
- [ ] Comentário justificando ilegibilidade com "é mais rápido" sem evidência

## Exceções Permitidas

- **Hotspots Comprovados**: Otimizações em código cuja lentidão foi identificada por profiling com dados reais de produção.
- **Algoritmos Canônicos**: Uso de algoritmos conhecidos (quicksort, busca binária) onde a escolha é padrão da indústria, não especulativa.

## Como Detectar

### Manual

Perguntar: "há uma medição provando que isso é um gargalo?" — se a resposta é não, é otimização prematura.

### Automático

Code review: identificar caches manuais, estruturas de dados incomuns ou micro-otimizações sem comentário de profiling referenciado.

## Relacionada com

- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [023 - Proibição de Funcionalidade Especulativa](023_proibicao-funcionalidade-especulativa.md): complementa
- [062 - Proibição de Código Inteligente](062_proibicao-codigo-inteligente-clever-code.md): reforça
- [064 - Proibição de Overengineering](064_proibicao-overengineering.md): complementa
- [070 - Proibição de Estado Mutável Compartilhado](070_proibicao-estado-mutavel-compartilhado.md): complementa

---

**Criada em**: 2026-03-29
**Versão**: 1.0
