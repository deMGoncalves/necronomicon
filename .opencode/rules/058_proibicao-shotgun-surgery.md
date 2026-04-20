# Proibição de Shotgun Surgery (Cirurgia Espalhada)

**ID**: AP-15-058
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Shotgun Surgery (Cirurgia Espalhada) ocorre quando uma única mudança exige alterar múltiplas classes ou módulos diferentes. Oposto complementar do Divergent Change: aqui, cada novo requisito exige realizar mudanças em múltiplas localizações do código (como disparar um shotgun, atingindo vários pontos). Indica baixa coesão e alto acoplamento.

## Por que importa

- Mudanças onerosas: cada novo requisito ou correção exige tocar em N lugares
- Alta probabilidade de regressão: é fácil esquecer um dos N locais que precisam mudar
- Dificuldade de testes: testar mudança spread exige criar mocks para múltiplos módulos
- Indicação de código replicado: lógica que deveria estar centralizada está duplicada
- Frágil: quando mudar um requisito, quebra algo nos outros N módulos afetados anteriormente

## Critérios Objetivos

- [ ] Mudança de comportamento exige alterar 3+ classes/módulos
- [ ] Mesma lógica de cálculo ou validação existe em múltiplas localizações
- [ ] Adicionar novo campo/feature exige modificar N arquivos em diferentes camadas
- [ ] Bug fix precisa ser aplicado em múltiplos arquivos com mesmo padrão de correção
- [ ] Code review mostra commits modificando arquivos completamente diferentes sem relação clara

## Exceções Permitidas

- Arquiteturas explícitas onde layers são intencionalmente separadas (controller, service, repository)
- Plugins/modular systems onde opinions são extensíveis por design
- Código legado onde refatoração imediata traria risco inaceitável
- Microservices boundaries por design onde múltiplos services lidam com mesmo domain concern

## Como Detectar

### Manual
- Analisar histórico de commits: commits de features que toucham always N arquivos diferentes
- Procurar por comportamentos duplicated: mesma lógica em controllers, services, repositories
- Verificar adição de novo feature: exigiria mudar configuration, schema, multiple handlers, tests em multiple files?
- Code review: desenvolvedores dizem "preciso mudar em X, Y, Z e W" para uma única feature

### Automático
- Análise de commits: detectar commits que sempre tocam múltiplos arquivos diferentes for same feature
- Code similarity analysis: detectar código duplicado ou muito similar em múltiplas localizações
- Análise de coesão: baixa coesão entre módulos indica shotgun surgery

## Relacionada com

- [021 - Proibição de Duplicação de Lógica](021_proibicao-duplicacao-logica.md): reforça
- [054 - Proibição de Mudança Divergente](054_proibicao-mudanca-divergente.md): complementa
- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa
- [016 - Princípio de Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [017 - Princípio de Reuso Comum](017_principio-reuso-comum.md): reforça
- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0