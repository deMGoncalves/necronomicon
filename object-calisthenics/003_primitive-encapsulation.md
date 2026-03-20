# Encapsulamento de Primitivos de Domínio (Value Objects)

**ID**: CREATIONAL-003
**Severity**: 🔴 Critical
**Category**: Creational

---

## O que é

Exige que tipos primitivos (como `number`, `boolean`) e a classe `String` que representam conceitos de domínio (por exemplo, *Email*, *CPF*, *Currency*) sejam encapsulados em seus próprios *Value Objects* imutáveis.

## Por que importa

Garante que validação, formatação e regras de negócio intrínsecas aos dados sejam definidas e verificadas uma única vez no construtor, evitando inconsistências e bugs graves decorrentes da passagem de dados inválidos entre métodos.

## Critérios Objetivos

- [ ] Parâmetros de entrada e valores de retorno de métodos públicos não devem ser do tipo primitivo/String se representarem um conceito específico de domínio.
- [ ] Todos os *Value Objects* devem ser imutáveis.
- [ ] A lógica de validação de formato e regras de negócio do valor deve estar contida e ser executada no construtor do *Value Object*.

## Exceções Permitidas

- **Primitivos Genéricos**: Tipos primitivos usados para contagem (`i`, `index`), booleanos de controle (`isValid`) ou números sem significado de domínio (por exemplo, delta de tempo).

## Como Detectar

### Manual

Identificar String ou Number sendo passados como argumento em múltiplos métodos, representando, por exemplo, um *ID* ou *Path*.

## Automático

TypeScript: Detectar uso excessivo de `string` ou `number` para campos tipados que deveriam ser classes dedicadas.

## Relacionado a

- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reforça
- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reforça
- [024 - Prohibition of Magic Constants](../clean-code/proibicao-constantes-magicas.md): reforça
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): reforça
- [033 - Parameter Limit per Function](../clean-code/limite-parametros-funcao.md): reforça
- [029 - Object Immutability](../clean-code/imutabilidade-objetos-freeze.md): reforça
- [012 - Liskov Substitution Principle](003_liskov-substitution-principle.md): complementa
- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): complementa
- [035 - Prohibition of Misleading Names](../clean-code/proibicao-nomes-enganosos.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
