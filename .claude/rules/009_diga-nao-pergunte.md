# Aplicação do Princípio do "Diga, Não Pergunte" (Law of Demeter)

**ID**: COMPORTAMENTAL-009
**Severidade**: 🔴 Crítica
**Categoria**: Comportamental

---

## O que é

Exige que um método chame métodos ou acesse propriedades apenas de seus "vizinhos imediatos": o próprio objeto, objetos passados como argumento, objetos que ele cria ou objetos que são propriedades internas diretas.

*(Previne o anti-pattern Message Chains / Train Wreck: ao dizer ao objeto o que fazer em vez de navegar sua estrutura interna via getters encadeados.)*

## Por que importa

Violações do Princípio de Demeter resultam em acoplamento alto e transitivo (*train wrecks*), tornando o código frágil a mudanças internas em objetos distantes na cadeia de dependência, e obscurecendo a responsabilidade de cada objeto.

## Critérios Objetivos

- [ ] Um método deve evitar chamar métodos de um objeto retornado por outro método (ex: `a.getB().getC().f()`).
- [ ] A chamada de métodos deve ser restrita aos objetos que o método tem conhecimento direto.
- [ ] O objeto cliente deve *dizer* ao objeto dependente o que fazer, em vez de *perguntar* pelo estado interno para tomar uma decisão.

## Exceções Permitidas

- **Padrões de Interface Fluida (Chaining)**: Desde que o método retorne `this` (ou a mesma interface), como em Builders.
- **Acesso a DTOs/Value Objects**: Acesso a dados de objetos que são puramente recipientes de dados.

## Como Detectar

### Manual

Busca por encadeamento de chamadas (*dot-chaining*) com três ou mais chamadas consecutivas, indicando conhecimento de objetos aninhados.

### Automático

ESLint: `no-chaining` com alta profundidade e `no-access-target` (com plugins customizados).

## Relacionada com

- [008 - Proibição de Getters/Setters](008_proibicao-getters-setters.md): reforça
- [005 - Restrição de Encadeamento de Chamadas](005_maximo-uma-chamada-por-linha.md): reforça
- [012 - Princípio de Substituição de Liskov](012_principio-substituicao-liskov.md): reforça
- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [004 - Coleções de Primeira Classe](004_colecoes-primeira-classe.md): complementa
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [038 - Princípio de Inversão de Consulta](038_conformidade-principio-inversao-consulta.md): reforça
- [057 - Proibição de Feature Envy](057_proibicao-feature-envy.md): complementa

---

**Criada em**: 2025-10-04
**Versão**: 1.0
