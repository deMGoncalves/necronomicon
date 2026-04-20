# Proibição de Mudança Divergente (Divergent Change)

**ID**: AP-16-054
**Severidade**: 🟠 Alta
**Categoria**: Estrutural

---

## O que é

Divergent Change ocorre quando uma única classe é modificada por múltiplas razões diferentes e não relacionadas. Cada novo tipo de mudança exige editar a mesma classe por um motivo completamente diferente do anterior. Oposto complementar do Shotgun Surgery: aqui, uma classe muda por N razões.

## Por que importa

- Violação do Princípio de Responsabilidade Única (SRP): classe com múltiplas responsabilidades
- Alto risco de regressão: mudar uma concern (ex: banco de dados) pode quebrar acidentalmente outra (ex: regra de negócio)
- Difícil manutenção: desenvolvedores não sabem quais partes da classe são seguras para editar
- Testes complexos: é difícil testar isoladamente cada responsabilidade quando estão misturadas
- Histórico de commits confuso: commits de features totalmente diferentes sempre tocam o mesmo arquivo

## Critérios Objetivos

- [ ] Classe possui seções separadas por comentários (`// database logic`, `// business rules`, `// ui formatting`)
- [ ] Histórico de commits mostra commits de features diferentes sempre modificando mesmo arquivo
- [ ] Testes de unidade precisam mockar múltiplas responsabilidades para testar uma única funcionalidade
- [ ] Múltiplos reasons-to-change documentados ou discutidos em code reviews
- [ ] Classe cresce continuamente porque cada nova feature adiciona +1 método responsabilidade diferente

## Exceções Permitidas

- Classes pequenas (< 100 linhas) com responsabilidades intimamente relacionadas
- DTOs (Data Transfer Objects) ou Value Objects por definição agrupam dados
- Adapters que precisam implementar múltiplas interfaces de um mesmo paradigma
- Código legado onde refatoração imediata traria risco inaceitável

## Como Detectar

### Manual
- Ler comentários que delimitam seções claramente distintas na mesma classe
- Analisar histórico de commits: identificar commits de features diferentes editando mesmo arquivo
- Verificar testes: se testar uma responsabilidade exige preparar/mockar outras, pode ser divergent change
- Procurar por classes responsivas a múltiplos tipos de requisitos (banco, ui, domínio, infraestrutura)

### Automático
- Análise de commits: detectar arquivos com commits de múltiplas categorias/labels
- Análise de acoplamento: detectar classes mudando por múltiplos reasons-to-change
- Métricas de coesão: baixa coesão funcional indica múltiplas responsabilidades

## Relacionada com

- [010 - Princípio de Responsabilidade Única](010_principio-responsabilidade-unica.md): reforça
- [058 - Proibição de Shotgun Surgery](058_proibicao-shotgun-surgery.md): complementa
- [007 - Limite Máximo de Linhas por Classe](007_limite-maximo-linhas-classe.md): reforça
- [025 - Proibição de Anti-Pattern The Blob](025_proibicao-anti-pattern-the-blob.md): complementa
- [004 - Coleções de Primeira Classe](004_colecoes-primeira-classe.md): reforça
- [014 - Princípio de Inversão de Dependência](014_principio-inversao-dependencia.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0