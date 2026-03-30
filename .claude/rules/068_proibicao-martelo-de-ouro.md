# Proibição de Martelo de Ouro (Golden Hammer)

**ID**: AP-06-068
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Golden Hammer (Martelo de Ouro) ocorre quando desenvolvedor ou equipe aplica a mesma ferramenta, padrão ou tecnologia para todos os problemas, independente de se adequado. Como a frase "para homem com martelo, tudo parece prego", isso define vies de usar mesma solução universal (o martelo de ouro) em todos os contextos.

## Por que importa

- Soluções subótimas: usando ferramenta errada para problema específico, criando over-engineering ou under-engineering
- Dificuldade de evolução: quando problema muda, still using mesmo "martelo de ouro" mesmo se inadequado
- Falta de inovação mental: equipe para de aprender novas ferramentas; se apega a conteúdo conhecido
- Debt técnico acumula: soluções universais são frequentemente complexas when aplicadas onde simples helps
- Frustra equipe técnica: desenvolvedores experientes veem wrong tools being used

## Critérios Objetivos

- [ ] Mesma ferramenta/pattern aplicado em 3+ contextos significantemente diferentes
- [ ] Rejeição de alternatives com "usamos X always" sem justificativa
- [ ] Uso de microservice pattern em sistemas onde single monolith seria suficiente
- [ ] Uso de NoSQL database em sistemas fortemente relacional ou vice versa
- [ ] Framework/library de event-bus em sistemas com operação síncrona simples

## Exceções Permitidas

- Standard enforced patterns por compliance/regulamentação (ex: security frameworks)
- Company-wide technology stack where variance traria maintainability cost maior
- Libraries/frameworks conhecidos e battle-tested onde investing em new technology risk é alto

## Como Detectar

### Manual
- Code review: questionar "é essa a melhor ferramenta para este problema?" para cada technology choice
- Procurar por patterns repetidos em domains diferentes: same ORM used para KV store, search engine, relational DB
- Identificar arquiteturas onde every feature mesmo small uses same complex pattern (event bus para tudo, microservice para tudo)

### Automático
- Architecture analysis: detectar patterns aplicados across multiple domains when domain characteristics diferem
- Code complexity: detectar overhead de framework where simple solution existiria

## Relacionada com

- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): reforça
- [064 - Proibição de Overengineering](064_proibicao-overengineering.md): reforça
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [016 - Princípio de Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0