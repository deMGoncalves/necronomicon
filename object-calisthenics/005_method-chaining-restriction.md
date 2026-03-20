# Restrição de Encadeamento de Métodos

**ID**: STRUCTURAL-005
**Severity**: 🟡 Medium
**Category**: Structural

---

## O que é

Limita o encadeamento de chamadas de métodos e acesso encadeado a propriedades (*train wrecks*), permitindo no máximo uma chamada de método ou acesso a propriedade por linha.

## Por que importa

Encadeamento excessivo (por exemplo, `a.b().c().d()`) viola a Lei de Demeter (Princípio do Mínimo Conhecimento), aumentando o acoplamento do cliente a detalhes internos da estrutura do objeto. A restrição melhora a legibilidade ao forçar quebras de linha ou o uso de variáveis temporárias.

## Critérios Objetivos

- [ ] Cada instrução deve conter no máximo uma chamada de método ou um acesso a propriedade (por exemplo, `a.b()`).
- [ ] Múltiplas chamadas na mesma linha (por exemplo, `object.getA().getB()`) são proibidas.
- [ ] Múltiplas chamadas devem ser divididas em linhas separadas ou delegadas a um novo método.

## Exceções Permitidas

- **Interfaces Fluentes/Builders**: Padrões de design (*Builder* ou *Chaining*) que retornam `this` para configurar um objeto (por exemplo, `new Query().where().limit()`).
- **Constantes Estáticas**: Acesso a constantes estáticas de classes utilitárias.

## Como Detectar

### Manual

Buscar por dois ou mais pontos consecutivos (`.`) (excluindo ponto flutuante) em uma única linha de instrução.

### Automático

ESLint: `no-chaining` (com plugins customizados).

## Relacionado a

- [009 - Tell, Don't Ask](../object-calisthenics/009_tell-dont-ask.md): reforça
- [006 - Prohibition of Abbreviated Names](../object-calisthenics/006_prohibition-abbreviated-names.md): complementa
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reforça
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
