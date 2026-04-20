# Proibição da Pirâmide do Destino

**ID**: AP-23-066
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Pirâmide do Destino (ou Arrow Anti-Pattern) ocorre quando há aninhamento excessivo de condicionais (`if`/`else`) e loops que cria uma estrutura visual de pirâmide ou seta. Cada nível de aninhamento adiciona complexidade cognitiva e aumenta o Índice de Complexidade Ciclomática. O caminho feliz está enterrado profundamente dentro em vez de no nível zero. Versão síncrona de Callback Hell.

## Por que importa

- Leitura não-linear: desenvolvedores não conseguem seguir fluxo de cima para baixo; precisam rastrear aninhamento
- Bugs em casos extremos: caminhos aninhados raramente testados; bugs frequentemente encontrados em níveis profundos
- Dificuldade de adicionar condições: cada nova validação aumenta aninhamento; refatoração requer reindentação
- Inflação de complexidade: validações simples se transformam em estruturas complexas com ifs aninhados
- Alta Complexidade Ciclomática: cada nível dobra o número de caminhos de execução possíveis

## Critérios Objetivos

- [ ] Código com 4+ níveis de aninhamento de if/else/loops
- [ ] `if` dentro de `if` dentro de `for` dentro de `if` — padrão de pirâmide visual
- [ ] Complexidade Ciclomática > 10 na mesma função
- [ ] Caminho feliz está no nível de aninhamento 3+ em vez de nível zero
- [ ] Múltiplos statements `else` sem early return/guard clauses

## Exceções Permitidas

- Código legado onde refatoração imediata traria alto risco sem ganho claro
- Código de parser ou máquinas de estado necessariamente complexos por especificação externa
- Event handlers onde múltiplas validações são obrigatórias e não podem ser extraídas

## Como Detectar

### Manual
- Varredura visual: procurar código com formato de seta com aninhamento
- Buscar código onde adicionar nova validação requer reindentar tudo abaixo
- Identificar funções onde nunca fazem early return; todos os caminhos aninhados em else

### Automático
- Linters: detectar profundidade de aninhamento > 3, complexidade ciclomática > 10
- Code formatters: auto-format que visualiza pirâmides via indentação excessiva
- Análise estática: métricas de Complexidade Ciclomática, análise de profundidade de aninhamento

## Relacionada com

- [002 - Proibição da Cláusula Else](002_proibicao-clausula-else.md): reforça
- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [060 - Proibição de Código Spaghetti](060_proibicao-codigo-spaghetti.md): complementa
- [063 - Proibição do Inferno de Callbacks](063_proibicao-inferno-callbacks.md): complementa
- [027 - Qualidade de Tratamento de Erros de Domínio](027_qualidade-tratamento-erros-dominio.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
