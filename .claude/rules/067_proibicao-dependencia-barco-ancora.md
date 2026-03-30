# Proibição de Dependência Barco-Âncora (Boat Anchor)

**ID**: AP-01-067
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Boat Anchor (Barco-Âncora) ocorre quando uma dependência, biblioteca ou componente é importado na base de código, instalado em `package.json` ou `requirements.txt`, mas nunca é usado ou apenas usado superficialmente. Como uma âncora de barco que interfere o movimento, essas dependências inutilizadas adicionam complexidade e custo de manutenção sem trazer valor. Variante de Lava Flow para dependências.

## Por que importa

- Bloat de dependências: mais arquivos, mais downloads, mais tempo de build/CI/CD
- Vulnerabilidades de segurança: dependências não usadas não são monitoradas mas podem ter CVEs
- Dificulta onboarding: desenvolvedores se perguntam "para que serve X?" e gastam tempo pesquisando
- Confusão sobre tecnologias: aparece sendo usado mas não está; falsa impressão de capabilities
- Licenças complexas: dependências não usadas podem introduzir licenças lawyerism sem reason

## Critérios Objetivos

- [ ] Dependência listada em `package.json`, `requirements.txt`, `Pipfile`, `go.mod`, mas nunca importada
- [ ] Biblioteca importada mas nunca chamada (`import X` sem `X.method()` usage)
- [ ] Dependência morta (unmaintained) mantida "por precaução" sem timeline de uso futuro
- [ ] Framework/library instalado mas apenas 1-2 features usadas quando alternative simples exists

## Exceções Permitidas

- DevDependencies used em build-tooling apenas (linters, formatters não reference em code prod)
- Optional dependencies where usage é runtime desconhecido até execution (plugins)
- Dependência de futuro com roadmap bem definido (ex: feature requerendo X em Q3) se documentado em comments/tickets

## Como Detectar

### Manual
- Comparar `package.json`/`requirements.txt` com `grep -r "^import\|^from"` ou `grep -r "^require\|^use"` — diff é boat anchors
- Procurar por libraries onde docs/wiki mention "we use X" mas grep code base mostra zero usage
- Verificar testes: se library não appear em tests只用 em production code não importado, é boat anchor

### Automático
- Tools: npm-check, depcheck, pipreqs, go mod tidy
- CI/CD: scripts que detectam unused dependencies e fail build
- Dependency analysis tools: detect imports vs usage across entire codebase

## Relacionada com

- [056 - Proibição de Código Zombie (Lava Flow)](056_proibicao-codigo-zombie-lava-flow.md): complementa
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): reforça
- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça
- [043 - Configurações Via Ambiente](043_configuracoes-via-ambiente.md): complementa
- [022 - Priorização de Simplicidade e Clareza](022_priorizacao-simplicidade-clareza.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0