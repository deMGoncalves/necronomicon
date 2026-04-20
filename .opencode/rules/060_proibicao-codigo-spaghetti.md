# Proibição de Código Spaghetti (Spaghetti Code)

**ID**: AP-03-060
**Severidade**: 🔴 Crítica
**Categoria**: Estrutural

---

## O que é

Spaghetti Code (Código Spaghetti) ocorre quando o control flow do código é complexo e entrelaçado como um prato de spaghetti. Múltiplos branches, loops aninhados profundamente, `goto`s (ou equivalentes), e lógica de controle entrelaçada. É difícil seguir o fluxo de execução de ponta a ponta.

## Por que importa

- Impossível de entender: desenvolvedores não conseguem trackear o fluxo lógico
- Bugs ocultos: control flow complexo esconde edge cases e conditions não testadas
- Difícil de testar: cobertura de branches becomes nightmare; há centenas de caminhos
- Difícil de manter: mudanças break caminhos não óbvios; side effects desconhecidos
- Difícil de refatorar: qualquer alteração pode quebrar fluxo entrelaçado
- Altíssimo custo de onboarding: novos desenvolvedores demoram meses para_effectivamente entender o código

## Critérios Objetivos

- [ ] Mais de 3 níveis de indentação aninhada (if dentro de if dentro de if)
- [ ] Branches que saltam arbitrariamente para diferentes partes do código (goto equivalents)
- [ ] Funções com mutação de estado externas inesperadas (global variables, shared mutable state)
- [ ] Control flow que depende de variáveis mutadas em múltiplos locais distantes
- [ ] Múltiplos entry/exit points na mesma função (early returns everywhere, loops com break/continue misturados)
- [ ] Cyclomatic complexity > 15 em mesma função

## Exceções Permitidas

- State machines implementadas com switch/case bem documentados
- Event driven code single dispatcher com múltiples handlers (pattern mais limpo goto)
- Protocol parsers ou network code necessariamente complexo por especificação externa
- Código legado where refactoring imediata traria risco inaceitável

## Como Detectar

### Manual
- Ler código: se visualizar fluxo como graph com edges cruzando everywhere, é spaghetti
- Procurar por variáveis mutadas em múltiplos locais sem localidade clara
- Identificar funções onde há múltiplos `if/else` encadeados com nested branches
- Verificar há early returns, breaks, continues misturados em loops emódulos

### Automático
- Cyclomatic complexity analysis: complexity > 15 indica risco
- Code visualization: generate call graphs e detect control flow entrelaçado
- Static analysis: detect global variable usage, mutability issues
- Linters: max-depth, max-params, no-eqeqeq (for comparisons leading to spaghetti)

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [055 - Limite Máximo de Linhas por Método](055_limite-maximo-linhas-metodo.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [066 - Proibição de Pirâmide do Destino](066_proibicao-piramide-do-destino.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça
- [009 - Diga Não, Pergunte](009_diga-nao-pergunte.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0