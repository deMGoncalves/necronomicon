# Proibição de Nomes Abreviados e Acrônimos Ambíguos

**ID**: STRUCTURAL-006
**Severity**: 🟡 Medium
**Category**: Structural

---

## O que é

Exige que nomes de variáveis, métodos, classes e parâmetros sejam completos, autoexplicativos e não utilizem abreviações ou acrônimos que não sejam amplamente reconhecidos no domínio do problema.

## Por que importa

A clareza do código depende diretamente da clareza dos nomes. Abreviações reduzem a legibilidade, tornam o código menos pesquisável e obrigam os desenvolvedores a decodificar o significado, aumentando o custo cognitivo.

## Critérios Objetivos

- [ ] Nomes de classes, métodos e variáveis devem ter pelo menos 3 caracteres (exceto exceções).
- [ ] Acrônimos (por exemplo, `Mngr` para `Manager`, `Calc` para `Calculate`) são proibidos, exceto exceções.
- [ ] Nomes devem representar o significado sem necessidade de consultar documentação.

## Exceções Permitidas

- **Convenções de Loop**: Variáveis de iteração únicas e de curta duração (por exemplo, `i`, `j`).
- **Acrônimos Ubíquos**: Acrônimos comuns no setor (por exemplo, `ID`, `URL`, `API`, `HTTP`).

## Como Detectar

### Manual

Buscar por nomes de variáveis incompreensíveis para um novo leitor sem contexto.

### Automático

ESLint: `naming-convention` com limites mínimos de caracteres.

## Relacionado a

- [005 - Method Chaining Restriction](../object-calisthenics/005_method-chaining-restriction.md): complementa
- [003 - Primitive Encapsulation](../object-calisthenics/003_primitive-encapsulation.md): reforça
- [024 - Prohibition of Magic Constants](../clean-code/proibicao-constantes-magicas.md): complementa
- [026 - Comment Quality](../clean-code/qualidade-comentarios-porque.md): reforça
- [034 - Consistent Class and Method Names](../clean-code/nomes-classes-metodos-consistentes.md): reforça
- [035 - Prohibition of Misleading Names](../clean-code/proibicao-nomes-enganosos.md): complementa
- [022 - Prioritization of Simplicity and Clarity](../clean-code/priorizacao-simplicidade-clareza.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
