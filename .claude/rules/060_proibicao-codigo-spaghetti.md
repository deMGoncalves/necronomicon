# Proibição de Código Spaghetti

**ID**: AP-03-060
**Severidade**: 🔴 Crítica
**Categoria**: Estrutural

---

## O que é

Spaghetti Code ocorre quando o fluxo de controle do código é complexo e entrelaçado como um prato de espaguete. Múltiplos branches, loops profundamente aninhados, `goto`s (ou equivalentes) e lógica de controle entrelaçada. É difícil seguir o fluxo de execução do início ao fim.

## Por que importa

- Impossível entender: desenvolvedores não conseguem rastrear o fluxo lógico
- Bugs ocultos: fluxo de controle complexo esconde casos extremos e condições não testadas
- Difícil testar: cobertura de branches se torna pesadelo; existem centenas de caminhos
- Difícil manter: mudanças quebram caminhos não-óbvios; efeitos colaterais desconhecidos
- Difícil refatorar: qualquer mudança pode quebrar fluxo entrelaçado
- Custo de onboarding muito alto: novos desenvolvedores levam meses para entender efetivamente o código

## Critérios Objetivos

- [ ] Mais de 3 níveis de indentação aninhada (if dentro de if dentro de if)
- [ ] Branches que saltam arbitrariamente para partes diferentes do código (equivalentes a goto)
- [ ] Funções com mutação inesperada de estado externo (variáveis globais, estado mutável compartilhado)
- [ ] Fluxo de controle que depende de variáveis mutadas em múltiplos locais distantes
- [ ] Múltiplos pontos de entrada/saída na mesma função (returns antecipados em todo lugar, loops com break/continue misturados)
- [ ] Complexidade ciclomática > 15 na mesma função

## Exceções Permitidas

- Máquinas de estado implementadas com switch/case bem documentado
- Código orientado a eventos com dispatcher único e múltiplos handlers (padrão mais limpo que goto)
- Parsers de protocolo ou código de rede necessariamente complexo por especificação externa
- Código legado onde refatoração imediata traria risco inaceitável

## Como Detectar

### Manual
- Ler código: se você visualiza fluxo como grafo com arestas cruzando por todo lado, é spaghetti
- Buscar variáveis mutadas em múltiplos locais sem localidade clara
- Identificar funções onde há múltiplos `if/else` encadeados com branches aninhados
- Verificar por returns antecipados, breaks, continues misturados em loops e módulos

### Automático
- Análise de complexidade ciclomática: complexidade > 15 indica risco
- Visualização de código: gerar grafos de chamada e detectar fluxo de controle entrelaçado
- Análise estática: detectar uso de variável global, problemas de mutabilidade
- Linters: max-depth, max-params, no-eqeqeq (para comparações levando a spaghetti)

## Relacionada com

- [001 - Nível Único de Indentação](001_nivel-unico-indentacao.md): reforça
- [055 - Limite Máximo de Linhas por Método](055_limite-maximo-linhas-metodo.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [066 - Proibição da Pirâmide do Destino](066_proibicao-piramide-do-destino.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça
- [009 - Diga, Não Pergunte](009_diga-nao-pergunte.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
