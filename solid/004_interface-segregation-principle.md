# Aplicação do Interface Segregation Principle (ISP)

**ID**: STRUCTURAL-013
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

Exige que os clientes não sejam forçados a depender de interfaces que não utilizam. Múltiplas interfaces específicas para cada cliente são preferíveis a uma única interface geral.

## Por que importa

Violações do ISP causam classes anêmicas (com métodos vazios ou que lançam exceções) e aumentam o acoplamento desnecessário, pois os clientes são forçados a depender de código que nunca será executado.

## Critérios Objetivos

- [ ] Interfaces devem ter no máximo **5** métodos públicos.
- [ ] Classes que implementam interfaces não devem deixar métodos vazios nem lançar exceções de "não suportado".
- [ ] Se uma interface é utilizada por mais de **3** clientes diferentes, deve ser revisada para segregação.

## Exceções Permitidas

- **Interfaces de Baixo Nível**: Interfaces de *Framework* de terceiros que exigem um alto número de métodos (ex.: `HttpRequestHandler`).

## Como Detectar

### Manual

Buscar interfaces com 8 ou mais métodos, ou classes que implementam interfaces deixando métodos sem funcionalidade.

### Automático

SonarQube: Alta complexidade de acoplamento devido a métodos não utilizados.

## Relacionado a

- [010 - Single Responsibility Principle](../solid/001_single-responsibility-principle.md): reforça
- [011 - Open/Closed Principle](../solid/002_open-closed-principle.md): complementa
- [012 - Liskov Substitution Principle](../solid/003_liskov-substitution-principle.md): reforça
- [017 - Common Reuse Principle](003_common-reuse-principle.md): complementa
- [037 - Prohibition of Flag Arguments](../clean-code/proibicao-argumentos-sinalizadores.md): reforça

---

**Criado em**: 2025-10-04
**Versão**: 1.0
