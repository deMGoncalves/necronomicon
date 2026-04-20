# Proibição do Martelo de Ouro

**ID**: AP-06-068
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Golden Hammer ocorre quando um desenvolvedor ou time aplica a mesma ferramenta, padrão ou tecnologia para todos os problemas, independentemente da adequação. Como o ditado "para um homem com um martelo, tudo parece um prego", isso define o viés de usar a mesma solução universal (o martelo de ouro) em todos os contextos.

## Por que importa

- Soluções subótimas: usar ferramenta errada para problema específico, criando over-engineering ou under-engineering
- Dificuldade de evolução: quando problema muda, ainda usando mesmo "martelo de ouro" mesmo que inadequado
- Falta de inovação mental: time para de aprender novas ferramentas; se apega ao conteúdo conhecido
- Débito técnico acumula: soluções universais são frequentemente complexas quando aplicadas onde simples ajudaria
- Frustra time técnico: desenvolvedores experientes veem ferramentas erradas sendo usadas

## Critérios Objetivos

- [ ] Mesma ferramenta/padrão aplicado em 3+ contextos significativamente diferentes
- [ ] Rejeição de alternativas com "sempre usamos X" sem justificativa
- [ ] Uso de padrão de microserviço em sistemas onde monolito único seria suficiente
- [ ] Uso de banco de dados NoSQL em sistemas fortemente relacionais ou vice-versa
- [ ] Framework/biblioteca event-bus em sistemas com operação síncrona simples

## Exceções Permitidas

- Padrões padrão impostos por compliance/regulação (ex: frameworks de segurança)
- Stack tecnológico company-wide onde variância traria maior custo de manutenibilidade
- Bibliotecas/frameworks conhecidos e battle-tested onde investir em risco de nova tecnologia é alto

## Como Detectar

### Manual
- Code review: questionar "esta é a melhor ferramenta para este problema?" para cada escolha tecnológica
- Buscar padrões repetidos em domínios diferentes: mesmo ORM usado para KV store, search engine, DB relacional
- Identificar arquiteturas onde cada feature mesmo pequena usa mesmo padrão complexo (event bus para tudo, microservice para tudo)

### Automático
- Análise de arquitetura: detectar padrões aplicados em múltiplos domínios quando características de domínio diferem
- Complexidade de código: detectar overhead de framework onde solução simples existiria

## Relacionada com

- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): reforça
- [064 - Proibição de Overengineering](064_proibicao-overengineering.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
