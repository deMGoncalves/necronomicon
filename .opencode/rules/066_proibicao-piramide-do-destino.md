# Proibição de Pirâmide do Destino (Pyramid of Doom)

**ID**: AP-23-066
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Pyramid of Doom (Pirâmide da Perdição ou Arrow Anti-Pattern) ocorre quando há aninhamento excessivo de condicionais (`if`/`else`) e loops que cria estrutura visual em forma de pirâmide ou seta. Cada nível de aninhamento adiciona complexidade cognitiva e aumenta o Índice de Complexidade Ciclomática. O caminho feliz fica enterrado deep inside dois nível zero. Versão síncrona do Callback Hell.

## Por que importa

- Leitura não linear: desenvolvedores não conseguem seguir fluxo de cima-para-baixo; precisam trackear aninhamento
- Bugs em edge cases: caminhos nested raramente testados; bugs são frequentemente encontrados em níveis profundos
- Dificuldade de adicionar condições: cada nova validação aumenta aninhamento; refatoração requer reindentação
- Ingolfia of Complexidade: simples validações se transformam em estruturas complexas com nested ifs
- Alta Cyclomatic Complexity: cada nível dobr o número de possíveis caminhos de execução

## Critérios Objetivos

- [ ] Código com 4+ níveis de aninhamento de if/else/loops
- [ ] `if` dentro de `if` dentro de `for` dentro de `if` — pattern visual pyramid
- [ ] Cyclomatic Complexity > 10 na mesma função
- [ ] Caminho feliz (happy path) está em nível de aninhamento 3+ ao invés de nível zero
- [ ] Múltiplos `else` statements sem early return/guard clauses

## Exceções Permitidas

- Código legado onde refatoração imediata traria risco alto sem ganho claro
- Parser code ou state machines necessariamente complexos por specification externa
- Event handlers onde multiple validations são obrigatórias e não podem ser extraídas

## Como Detectar

### Manual
- Visual scan: procurar por código com formato de seta ──》 com aninhamento
- Procurar por código onde adicionar nova validação exige reindentar tudo abaixo
- Identificar funções onde nunca fazer early return; todos os caminhos.addItem nested else

### Automático
- Linters: detect nesting depth > 3, cyclomatic complexity > 10
- Code formatters: auto-format que visualiza pyramids via indentação excessiva
- Static analysis: Cyclomatic Complexity metrics, nesting depth analysis

## Relacionada com

- [002 - Proibição de Cláusula Else](002_proibicao-clausula-else.md): reforça
- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [060 - Proibição de Código Spaghetti](060_proibicao-codigo-spaghetti.md): complementa
- [063 - Proibição de Inferno de Callbacks](063_proibicao-inferno-callbacks.md): complementa
- [027 - Qualidade de Tratamento de Erros de Domínio](027_qualidade-tratamento-erros-dominio.md): reforça
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0