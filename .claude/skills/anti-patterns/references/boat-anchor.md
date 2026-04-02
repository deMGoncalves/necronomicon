# Boat Anchor (Âncora de Barco)

**Severidade:** 🟡 Médio
**Rule associada:** Rule 067

## O que é

Componente de software (biblioteca, módulo, classe, sistema inteiro) ou dependência mantida na codebase porque "pode ser útil no futuro", mas que atualmente não tem propósito ativo. Como uma âncora num barco: peso sem utilidade.

## Sintomas

- Dependência listada em `package.json`, `requirements.txt` mas nunca importada
- Biblioteca importada mas nunca chamada (`import X` sem `X.method()` usage)
- Módulos importados mas nunca utilizados
- Dependências no `package.json` sem nenhuma referência no código
- Infraestrutura provisionada que ninguém usa (filas, bancos, serviços)
- Código de "integração futura" escrito antes de a integração existir
- Comentários como `// será usado quando implementarmos X`

## ❌ Exemplo (violação)

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

## ✅ Refatoração

```javascript
// ✅ Apenas o que é usado existe (YAGNI)
// package.json: apenas dependências com referências reais no código
// Módulo criado quando a feature for necessária, com testes desde o início

// Use: npm-check, depcheck, pipreqs, go mod tidy para detectar
```

## Codetag sugerida

```typescript
// FIXME: Boat Anchor — pdfkit/sharp/node-cron instalados mas nunca referenciados
// TODO: npm uninstall; criar módulo quando necessidade for real
```
