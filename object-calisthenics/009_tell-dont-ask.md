# Aplicação do Princípio "Tell, Don't Ask" (Lei de Demeter)

**ID**: BEHAVIORAL-009
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## O que é

Exige que um método chame métodos ou acesse propriedades apenas de seus "vizinhos imediatos": o próprio objeto, objetos passados como argumentos, objetos que ele cria ou objetos que são propriedades internas diretas.

## Por que importa

Violações da Lei de Demeter resultam em acoplamento alto e transitivo (*train wrecks*), tornando o código frágil a mudanças internas em objetos distantes na cadeia de dependências e obscurecendo a responsabilidade de cada objeto.

## Critérios Objetivos

- [ ] Um método deve evitar chamar métodos de um objeto retornado por outro método (por exemplo, `a.getB().getC().f()`).
- [ ] Chamadas de métodos devem ser restritas a objetos que o método conhece diretamente.
- [ ] O objeto cliente deve *dizer* ao objeto dependente o que fazer, em vez de *perguntar* pelo estado interno para tomar uma decisão.

## Exceções Permitidas

- **Padrões de Interface Fluente (Chaining)**: Desde que o método retorne `this` (ou a mesma interface), como em Builders.
- **Acesso a DTOs/Value Objects**: Acesso a dados de objetos que são puramente contêineres de dados.

## Como Detectar

### Manual

Buscar por encadeamento de chamadas (*dot-chaining*) com três ou mais chamadas consecutivas, indicando conhecimento de objetos aninhados.

### Automático

ESLint: `no-chaining` com alta profundidade e `no-access-target` (com plugins customizados).

## Relacionado a

- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reforça
- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): reforça
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): reforça
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): reforça
- [004 - First Class Collections](../object-calisthenics/004_first-class-collections.md): complementa
- [018 - Acyclic Dependencies Principle](004_acyclic-dependencies-principle.md): reforça
- [036 - Side Effect Function Restriction](../clean-code/restricao-funcoes-efeitos-colaterais.md): reforça
- [038 - Query Inversion Principle](../clean-code/conformidade-principio-inversao-consulta.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
