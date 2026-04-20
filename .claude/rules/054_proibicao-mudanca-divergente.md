# Proibição de Mudança Divergente

**ID**: AP-16-054
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Mudança Divergente (Divergent Change) ocorre quando uma única classe é modificada por múltiplas razões diferentes e não relacionadas. Cada novo tipo de mudança requer editar a mesma classe por uma razão completamente diferente da anterior. Oposto complementar de Shotgun Surgery: aqui, uma classe muda por N razões.

## Por que importa

- Violação do Princípio de Responsabilidade Única (SRP): classe com múltiplas responsabilidades
- Alto risco de regressão: alterar uma preocupação (ex: banco de dados) pode quebrar acidentalmente outra (ex: regra de negócio)
- Manutenção difícil: desenvolvedores não sabem quais partes da classe são seguras de editar
- Testes complexos: é difícil testar cada responsabilidade isoladamente quando estão misturadas
- Histórico de commits confuso: commits de features totalmente diferentes sempre tocam o mesmo arquivo

## Critérios Objetivos

- [ ] Classe possui seções separadas por comentários (`// lógica do banco`, `// regras de negócio`, `// formatação ui`)
- [ ] Histórico de commits mostra commits de features diferentes sempre modificando o mesmo arquivo
- [ ] Testes unitários precisam mockar múltiplas responsabilidades para testar uma única funcionalidade
- [ ] Múltiplas razões-para-mudar documentadas ou discutidas em code reviews
- [ ] Classe cresce continuamente porque cada nova feature adiciona +1 método para responsabilidade diferente

## Exceções Permitidas

- Classes pequenas (< 100 linhas) com responsabilidades estreitamente relacionadas
- DTOs (Data Transfer Objects) ou Value Objects que por definição agrupam dados
- Adapters que precisam implementar múltiplas interfaces do mesmo paradigma
- Código legado onde refatoração imediata traria risco inaceitável

## Como Detectar

### Manual
- Ler comentários que delimitam seções claramente distintas na mesma classe
- Analisar histórico de commits: identificar commits de features diferentes editando o mesmo arquivo
- Verificar testes: se testar uma responsabilidade requer preparar/mockar outras, pode ser mudança divergente
- Buscar classes que respondem a múltiplos tipos de requisitos (banco de dados, ui, domínio, infraestrutura)

### Automático
- Análise de commits: detectar arquivos com commits de múltiplas categorias/labels
- Análise de acoplamento: detectar classes mudando por múltiplas razões-para-mudar
- Métricas de coesão: baixa coesão funcional indica múltiplas responsabilidades

## Relacionada com

- [010 - Princípio da Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [058 - Proibição de Shotgun Surgery](058_proibicao-shotgun-surgery.md): complementa
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [025 - Proibição do Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): complementa
- [004 - Coleções de Primeira Classe](004_colecoes-primeira-classe.md): reforça
- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0
