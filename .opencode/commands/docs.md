---
description: "Sincroniza docs/ (arc42, c4, adr, bdd) com o código implementado. Funciona sem Spec Flow — útil para código legado e Quick fixes acumulados."
agent: architect
---

## Propósito

Roda a Fase 4 (Docs Sync) de forma independente, sem precisar do workflow completo.
Útil para código legado, Quick fixes acumulados ou após uma Task concluída.

Arquivos alterados recentemente:
!`git diff --name-only HEAD~1 2>/dev/null | head -20 || echo "(sem commits recentes)"`

## Instruções

1. **Determine o escopo**:
   - Se `$ARGUMENTS` foi fornecido → usar esse caminho (ex: `src/user_auth/`)
   - Se não → usar a lista acima como guia dos arquivos alterados

2. **Leia o código-alvo** em `src/` para entender a implementação atual

3. **Leia a documentação existente** em `docs/`:
   - `docs/arc42/` — arquitetura atual documentada
   - `docs/c4/` — diagramas de contexto, container, componente
   - `docs/adr/` — decisões arquiteturais anteriores
   - `docs/bdd/` — features Gherkin existentes

4. **Compare código vs docs** e identifique gaps:
   - Novos contextos ou containers não documentados
   - Comportamentos sem feature Gherkin
   - Decisões técnicas sem ADR registrado

5. **Atualize** o que for necessário:
   - `docs/arc42/` — building blocks, runtime views, concepts
   - `docs/c4/` — diagramas afetados
   - `docs/bdd/` — features Gherkin se comportamento mudou
   - `docs/adr/ADR-NNN.md` — criar se houver decisão arquitetural relevante

6. **Exiba o resumo**:
   ```
   ✅ Docs sincronizados:
   - arc42/05_building_block_view.md — descrição
   - adr/ADR-019.md — decisão documentada
   ```

**Importante:** Se `docs/` não existir, criar os diretórios antes de sincronizar.
