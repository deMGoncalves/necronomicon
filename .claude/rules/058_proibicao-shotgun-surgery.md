# Proibição de Shotgun Surgery

**ID**: AP-15-058
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Shotgun Surgery ocorre quando uma única mudança requer alterar múltiplas classes ou módulos diferentes. Oposto complementar de Mudança Divergente: aqui, cada novo requisito exige fazer mudanças em múltiplos locais do código (como disparar uma espingarda, acertando vários pontos). Indica baixa coesão e alto acoplamento.

## Por que importa

- Mudanças custosas: cada novo requisito ou correção requer tocar em N lugares
- Alta probabilidade de regressão: é fácil esquecer um dos N locais que precisam mudar
- Dificuldade de teste: testar mudanças espalhadas requer criar mocks para múltiplos módulos
- Indicação de código replicado: lógica que deveria estar centralizada está duplicada
- Frágil: ao mudar um requisito, quebra algo nos outros N módulos anteriormente afetados

## Critérios Objetivos

- [ ] Mudança de comportamento requer alterar 3+ classes/módulos
- [ ] Mesma lógica de cálculo ou validação existe em múltiplos locais
- [ ] Adicionar novo campo/feature requer modificar N arquivos em camadas diferentes
- [ ] Correção de bug precisa ser aplicada em múltiplos arquivos com mesmo padrão de correção
- [ ] Code review mostra commits modificando arquivos completamente diferentes sem relação clara

## Exceções Permitidas

- Arquiteturas explícitas onde camadas são intencionalmente separadas (controller, service, repository)
- Sistemas de plugins/modulares onde opiniões são extensíveis por design
- Código legado onde refatoração imediata traria risco inaceitável
- Fronteiras de microserviços por design onde múltiplos serviços tratam mesma preocupação de domínio

## Como Detectar

### Manual
- Analisar histórico de commits: commits de features que sempre tocam N arquivos diferentes
- Buscar comportamentos duplicados: mesma lógica em controllers, services, repositories
- Verificar adição de nova feature: requereria alterar configuração, schema, múltiplos handlers, testes em múltiplos arquivos?
- Code review: desenvolvedores dizem "preciso mudar X, Y, Z e W" para uma única feature

### Automático
- Análise de commits: detectar commits que sempre tocam múltiplos arquivos diferentes para mesma feature
- Análise de similaridade de código: detectar código duplicado ou muito similar em múltiplos locais
- Análise de coesão: baixa coesão entre módulos indica shotgun surgery

## Relacionada com

- [021 - Proibição da Duplicação de Lógica](021_proibicao-duplicacao-logica.md): reforça
- [054 - Proibição de Mudança Divergente](054_proibicao-mudanca-divergente.md): complementa
- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): reforça
- [017 - Princípio do Reuso Comum](017_principio-reuso-comum.md): reforça
- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
