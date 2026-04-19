---
name: alphabetical
description: Convenção para organização de propriedades em objetos/JSON — ao criar ou modificar objetos JavaScript/JSON/TypeScript — ao ordenar propriedades, imports, exports ou qualquer lista de atributos
model: haiku
allowed-tools: Read, Write, Edit
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Alphabetical

Convenção para organização de propriedades em objetos e JSON.

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Criação ou modificação de objetos JS/TS, arquivos JSON, interfaces TypeScript, exports de módulo e objetos de configuração |
| **Prerequisites** | Nenhum pré-requisito específico além do contexto do objeto sendo criado |
| **Constraints** | Não aplicar quando a ordem tem significado semântico (coordenadas, sequências lógicas, construtores) ou em APIs externas com contrato definido |
| **Scope** | Ordenação de propriedades em literais de objeto, chaves JSON, exports nomeados, CSS-in-JS e propriedades de classe |

---

## Quando Usar

Use ao criar ou modificar objetos para ordenar propriedades alfabeticamente.

## Princípio

| Princípio | Descrição |
|-----------|-----------|
| Previsibilidade | Ordem alfabética reduz custo cognitivo de localizar itens |

## Regras

| Regra | Descrição |
|-------|-----------|
| Ordem alfabética | Propriedades devem estar em ordem alfabética (A-Z) |
| Recursivo | Objetos aninhados também seguem ordem alfabética |
| Sensível a maiúsculas | Letras minúsculas após maiúsculas (`A` antes de `a`) |

## Aplicação

| Contexto | Descrição |
|----------|-----------|
| Literais de objeto | Propriedades de objetos inline |
| Arquivos JSON | Chaves em arquivos de configuração |
| Exports de módulo | Named exports em index |
| Configurações | Objetos de configuração |
| CSS-in-JS | Propriedades CSS em template literals ou objetos |
| Interfaces TypeScript | Propriedades de types e interfaces |
| Propriedades de classe | Campos privados ou públicos e properties |
| Objetos de estilo | Propriedades de estilo em objetos JavaScript |

## Exceções

Não aplicar ordem alfabética quando:

| Situação | Justificativa |
|----------|---------------|
| Ordem lógica crítica | Sequência tem significado semântico (ex: coordenadas x, y, z) |
| Agrupamento semântico | Propriedades relacionadas devem ficar juntas |
| Arrays ordenados | Ordem tem significado funcional |
| Construtores | Parâmetros seguem ordem de importância |
| APIs externas | Estrutura definida por contrato externo |

## Exemplos

```typescript
// ❌ Ruim — propriedades em ordem aleatória
const config = {
  timeout: 3000,
  apiUrl: 'https://api.example.com',
  debug: false,
  maxRetries: 3,
}

// ✅ Bom — propriedades em ordem alfabética
const config = {
  apiUrl: 'https://api.example.com',
  debug: false,
  maxRetries: 3,
  timeout: 3000,
}
```

## Proibições

| O que evitar | Motivo |
|--------------|--------|
| Ordenar propriedades com dependência lógica | Quando ordem tem significado semântico, mantê-la (coordenadas, sequências) |
| Forçar ordem alfabética em APIs externas | Respeitar contrato de APIs de terceiros |
| Quebrar agrupamentos coesos | Propriedades fortemente relacionadas devem ficar juntas (rule 016) |

## Justificativa

- [022 - Priorização da Simplicidade e Clareza](../../rules/022_priorizacao-simplicidade-clareza.md): ordem alfabética é previsível e reduz custo cognitivo ao buscar propriedades, eliminando necessidade de entender lógica de ordenação
- [006 - Proibição de Nomes Abreviados](../../rules/006_proibicao-nomes-abreviados.md): nomes completos descritivos são mais fáceis de localizar quando ordenados alfabeticamente
- [016 - Princípio do Fechamento Comum](../../rules/016_principio-fechamento-comum.md): propriedades que mudam juntas devem ficar agrupadas, mas dentro do grupo aplicar ordem alfabética
