# Proibição da Cláusula ELSE para Fluxo de Controle

**ID**: BEHAVIORAL-002
**Severity**: 🟠 High
**Category**: Behavioral

---

## O que é

Restringe o uso de cláusulas `else` e `else if`, promovendo a substituição por *guard clauses* (retorno antecipado) ou padrões de polimorfismo para lidar com diferentes caminhos de execução.

## Por que importa

Melhora a clareza do fluxo de controle, evita Complexidade Ciclomática desnecessária e impõe a aderência ao Princípio da Responsabilidade Única (SRP), pois cada bloco de código trata uma condição específica.

## Critérios Objetivos

- [ ] O uso explícito das palavras-chave `else` ou `else if` é proibido.
- [ ] Condicionais devem ser usados principalmente como *guard clauses* (verificação de pré-condição e retorno/lançamento de erro).
- [ ] Lógica de ramificação complexa deve ser resolvida via polimorfismo (padrões *Strategy* ou *State*).

## Exceções Permitidas

- **Estruturas de Controle de Linguagem**: Estruturas como `switch` (que geralmente se comportam como `if/else if`) podem ser usadas, desde que cada `case` retorne ou encerre a execução.

## Como Detectar

### Manual

Buscar por ` else ` ou ` else if ` no código.

### Automático

ESLint: `no-else-return` e `no-lonely-if` com configurações para impor saída antecipada.

## Relacionado a

- [001 - Single Indentation Level](../object-calisthenics/001_single-indentation-level.md): reforça
- [008 - Prohibition of Getters/Setters](../object-calisthenics/008_prohibition-getters-setters.md): reforça
- [011 - Open/Closed Principle](002_open-closed-principle.md): reforça
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): complementa
- [027 - Error Handling Quality](../clean-code/qualidade-tratamento-erros-dominio.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
