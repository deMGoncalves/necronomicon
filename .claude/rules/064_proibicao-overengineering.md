# Proibição de Overengineering

**ID**: AP-09-064
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Overengineering ocorre quando um desenvolvedor cria arquitetura ou código excessivamente complexos para requisitos simples. Padrões, abstrações, camadas e frameworks introduzidos "para o futuro" que complicam código sem trazer valor real. Abstração prematura em nome de "escalabilidade" ou "flexibilidade".

*(Engloba o anti-pattern Speculative Generality quando complexidade especulativa é introduzida em nível de arquitetura.)*

## Por que importa

- Sobrecarga cognitiva: desenvolvedores gastam tempo entendendo arquitetura em vez de domínio
- Tempo de desenvolvimento: construir features complexas leva mais tempo que soluções simples
- Dificuldade de manutenção: mudanças na arquitetura quebram muitas partes do código em cascata
- Desbalanceamento Concreto vs Abstração: sem problemas reais para abstrair, abstrações se tornam inventadas
- Honestamente, requisitos funcionais simples (API REST, CRUD) raramente justificam microserviços, arquitetura orientada a eventos, containers DI complexos

## Critérios Objetivos

- [ ] Introduzir padrão sem problema claro sendo resolvido (ex: padrão Strategy sem variação de algoritmos)
- [ ] Criar interfaces/classes para "escalabilidade futura" sem requisitos de negócio documentados
- [ ] Múltiplas camadas de abstração quando camada única seria suficiente (ex: service chamando service chamando service)
- [ ] Uso de framework (DI, ORM, event bus) para operações CRUD triviais
- [ ] Excesso de generalidade: código genérico parametrizado em vez de código específico de domínio

## Exceções Permitidas

- Código de framework por natureza geral que precisa suportar múltiplos casos de uso
- Bibliotecas onde flexibilidade é preocupação primária (frameworks UI, ORMs)
- Decisões arquiteturais explícitas documentando por que complexidade é justificada
- Código em crescimento extremo (startups com MVP rapidamente escalado) onde investimento em arquitetura se paga

## Como Detectar

### Manual
- Code review: perguntar "que problema concreto isso resolve?" para cada abstração/framework introduzido
- Buscar funcionalidades "para o futuro" sem timeline ou requisitos definidos
- Identificar código onde adicionar campo simples requer mapear config, interfaces, DTOs, services, repositories
- Verificar arquitetura: múltiplas camadas onde uma única camada isolada seria suficiente

### Automático
- Análise de complexidade: detectar abstrações com baixa frequência de uso
- Métricas de código: detectar funções/classes alta complexidade mas apenas 1-2 usos
- Análise de arquitetura: detectar sistemas orientados a microserviço onde padrões de comunicação são simples

## Relacionada com

- [023 - Proibição de Funcionalidade Especulativa](023_proibicao-funcionalidade-especulativa.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): complementa
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): reforça
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
