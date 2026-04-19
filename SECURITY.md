# Política de Segurança

## Versões suportadas

| Versão  | Suportada  |
|---------|------------|
| 1.x     | ✅ Sim     |
| < 1.0   | ❌ Não     |

## Reportando uma vulnerabilidade

**Não abra uma issue pública para reportar vulnerabilidades de segurança.**

Se você encontrou um problema de segurança no `oh my claude`, por favor:

1. **Envie um e-mail** para: [security@deMGoncalves.dev](mailto:security@deMGoncalves.dev)
2. **Ou utilize** os [GitHub Security Advisories](https://github.com/melisource/fury_oh-my-claude/security/advisories/new) (privado)

### O que incluir no relatório

- Descrição do problema
- Passos para reprodução
- Impacto potencial
- Sugestão de correção (se houver)

### Processo

1. Você receberá uma confirmação em até **48 horas**
2. O problema será investigado e classificado
3. Uma correção será desenvolvida e testada
4. A vulnerabilidade será divulgada após a publicação do patch

## Escopo

Este projeto é um **workflow para Claude Code CLI** composto por:

- **Shell hooks** (`lint.sh`, `loop.sh`, `prompt.sh`) — execução de comandos local
- **MCPs configurados** (`.mcp.json`) — conexões com serviços externos
- **Agents e skills** — prompts injetados no contexto do Claude

### Áreas de atenção

- Injeção de comandos nos hooks
- Exposição de tokens/segredos no `.mcp.json` ou nos agents
- Execução arbitrária via hooks `PreToolUse`/`PostToolUse`

**Lembre-se:** Nunca faça commit de tokens reais (Figma, GitHub) no `.mcp.json`. Utilize variáveis de ambiente.
