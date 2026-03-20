# Conformidade com o Open/Closed Principle (OCP)

**ID**: BEHAVIORAL-011
**Severity**: 🟠 High
**Category**: Behavioral

---

## O que é

Módulos, classes ou funções devem ser abertos para extensão e fechados para modificação, permitindo a adição de novos comportamentos sem alterar o código existente da unidade.

## Por que importa

A violação do OCP gera código frágil. A conformidade reduz o risco de regressão e aumenta a manutenibilidade, pois novas funcionalidades são adicionadas sem a necessidade de reescrever lógica já testada.

## Critérios Objetivos

- [ ] A adição de um novo "tipo" de comportamento deve ser implementada por meio de herança ou composição, e **não** por meio de novos `if/switch` no código existente.
- [ ] Métodos com mais de **3** cláusulas `if/else if/switch case` que tratam *tipos* (ex.: `if (type === 'A')`) violam o OCP.
- [ ] Módulos de alto nível não devem ter dependência direta de mais de **2** classes concretas que implementam a mesma abstração.

## Exceções Permitidas

- **Classes de Orquestração**: Módulos que atuam como *Factory* para instanciar tipos, onde a lógica de `switch` é centralizada.

## Como Detectar

### Manual

Sempre que for necessário adicionar uma nova funcionalidade, verificar se foi necessário modificar a classe base (se sim, OCP violado).

### Automático

ESLint: Regras que detectam alto número de *switch/if-else* em um método.

## Relacionado a

- [002 - Prohibition of ELSE Clause](../object-calisthenics/002_prohibition-else-clause.md): reforça
- [012 - Liskov Substitution Principle](../solid/003_liskov-substitution-principle.md): depende
- [013 - Interface Segregation Principle](../solid/004_interface-segregation-principle.md): complementa
- [010 - Single Responsibility Principle](../solid/001_single-responsibility-principle.md): complementa
- [014 - Dependency Inversion Principle](../solid/005_dependency-inversion-principle.md): reforça
- [020 - Command-Query Separation](../clean-code/conformidade-principio-inversao-consulta.md): reforça
- [043 - Backing Services as Resources](../twelve-factor/004_backing-services-resources.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
