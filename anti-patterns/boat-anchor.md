---
titulo: Boat Anchor (Âncora de Barco)
aliases:
  - Boat Anchor
  - Âncora de Barco
tipo: anti-pattern
id: AP-06
severidade: 🟡 Médio
origem: antipatterns-book
tags: [anti-pattern, estrutural, manutencao, complexidade]
criado: 2026-03-20
relacionados:
  - "[[lava-flow]]"
  - "[[speculative-generality]]"
  - "[[proibicao-funcionalidade-especulativa]]"
---

# Boat Anchor (Âncora de Barco)

*Boat Anchor*

---

## Definição

Componente de software (biblioteca, módulo, classe, sistema inteiro) mantido na codebase porque "pode ser útil no futuro", mas que atualmente não tem propósito ativo. Como uma âncora num barco: peso sem utilidade.

## Sintomas

- Módulos importados mas nunca utilizados
- Dependências no `package.json` sem nenhuma referência no código
- Infraestrutura provisionada que ninguém usa (filas, bancos, serviços)
- Código de "integração futura" escrito antes de a integração existir
- Comentários como `// será usado quando implementarmos X`

## Causas Raiz

- Antecipação otimista: desenvolver para um futuro que não chega
- Custo percebido de remoção: "deixa, qualquer hora usamos"
- "Já que estou aqui": adicionar algo enquanto se trabalha em outra coisa
- Falta de revisão periódica de dependências e código não utilizado

## Consequências

- Bundle size maior: usuário carrega código que nunca executa
- Tempo de build e startup aumentado sem benefício
- Confusão para novos desenvolvedores: "por que existe isso?"
- Superfície de ataque de segurança aumentada: dependências sem uso têm vulnerabilidades

## Solução / Refatoração

Remover imediatamente qualquer componente sem uso atual. O YAGNI é claro: não construa o que não é necessário agora. Auditar dependências regularmente com `npm ls`, `depcheck` ou equivalentes.

## Exemplo — Problemático

```javascript
// ❌ Dependência instalada "para quando precisarmos"
// package.json tem: "pdfkit", "sharp", "node-cron"
// Nenhuma delas tem uma única linha de uso no código

// ❌ Módulo criado "para a próxima sprint"
export class ReportExporter {
  exportToExcel() { /* TODO: implementar */ }
  exportToPowerPoint() { /* TODO: implementar */ }
}
```

## Exemplo — Refatorado

```javascript
// ✅ Apenas o que é usado existe
// package.json: apenas dependências com referências reais no código
// Módulo criado quando a feature for necessária, com testes desde o início
```

## Rules que Previnem

- [[proibicao-funcionalidade-especulativa]] — YAGNI: não construa o que não é necessário agora

## Relacionados

- [[lava-flow]] — Boat Anchor vira lava flow com o tempo
- [[speculative-generality]] — mesma raiz: construir para futuros hipotéticos
