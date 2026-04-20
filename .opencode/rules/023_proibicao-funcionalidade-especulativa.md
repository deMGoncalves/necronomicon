# Proibição de Funcionalidade Especulativa (Princípio YAGNI)

**ID**: COMPORTAMENTAL-023
**Severidade**: 🟡 Média
**Categoria**: Comportamental

---

## O que é

Exige que o código seja implementado apenas quando uma funcionalidade é **necessária** (e não *talvez necessária* no futuro), evitando a inclusão de código ou abstrações desnecessárias.

*(Previne o anti-pattern Speculative Generality: hooks, parâmetros, classes abstratas e configurações criados para casos de uso hipotéticos sem uso atual.)*

## Por que importa

A funcionalidade especulativa aumenta a complexidade e o código morto, desperdiçando tempo de desenvolvimento. Aumenta a superfície de ataque e reduz a agilidade na resposta a mudanças reais.

## Critérios Objetivos

- [ ] Classes ou métodos *vazios* que visam ser *placeholders* para funcionalidades futuras são proibidos.
- [ ] É proibida a adição de parâmetros ou opções de configuração que não são usados imediatamente pelo menos por **um** cliente.
- [ ] O código não deve conter mais de **5%** de linhas marcadas como desabilitadas ou com comentários indicando "TODO: futura implementação".

## Exceções Permitidas

- **Requisitos de Interface**: Métodos de interface exigidos por um contrato externo (ex: `Disposable` ou `Closable`) que são trivialmente implementados.

## Como Detectar

### Manual

Busca por métodos vazios, parâmetros não utilizados, ou código que nunca é chamado (código morto).

### Automático

SonarQube/ESLint: `no-unused-vars`, `no-empty-function`.

## Relacionada com

- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [022 - Priorização da Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): complementa
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): complementa

---

**Criada em**: 2025-10-08
**Versão**: 1.0
