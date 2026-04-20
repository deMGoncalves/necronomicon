---
description: "Sincroniza docs/ (arc42, c4, adr, bdd) com código implementado. Funciona sem Spec Flow — útil para código legado e Quick fixes acumulados."
argument-hint: "[src/caminho (opcional)]"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(git diff *), Bash(git log *)
---

## Propósito

Executa Fase 4 (Sync de Docs) independentemente, sem necessidade de fluxo completo.
Útil para código legado, Quick fixes acumulados ou após Task completo.

Arquivos alterados recentemente:
!`git diff --name-only HEAD~1 2>/dev/null | head -20 || echo "(sem commits recentes)"`

## Instruções

1. **Determinar escopo**:
   - Se `$ARGUMENTS` fornecido → usar aquele caminho (ex: `src/user_auth/`)
   - Se não → usar lista acima como guia para arquivos alterados

2. **Ler código alvo** em `src/` para entender implementação atual

3. **Ler documentação existente** em `docs/`:
   - `docs/arc42/` — arquitetura atualmente documentada
   - `docs/c4/` — diagramas de contexto, container, componente
   - `docs/adr/` — decisões arquiteturais anteriores
   - `docs/bdd/` — features Gherkin existentes

4. **Comparar código vs docs** e identificar lacunas:
   - Novos contextos ou containers não documentados
   - Comportamentos sem feature Gherkin
   - Decisões técnicas sem ADR registrado

5. **Atualizar** o que for necessário:
   - `docs/arc42/` — blocos de construção, visões de runtime, conceitos
   - `docs/c4/` — diagramas afetados
   - `docs/bdd/` — features Gherkin se comportamento mudou
   - `docs/adr/ADR-NNN.md` — criar se houver decisão arquitetural relevante

6. **Exibir resumo**:
   ```
   ✅ Docs sincronizados:
   - arc42/05_building_block_view.md — descrição
   - adr/ADR-019.md — decisão documentada
   ```

**Importante:** Se `docs/` não existir, criar diretórios antes de sincronizar.
