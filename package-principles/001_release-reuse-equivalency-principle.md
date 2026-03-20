# Release Reuse Equivalency Principle (REP)

**ID**: STRUCTURAL-015
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

O módulo/pacote destinado à reutilização deve ter o mesmo escopo de release que seu consumidor. A granularidade de reutilização é a granularidade de release.

## Por que importa

Violações do REP levam a pacotes difíceis de versionar e consumir, forçando os clientes a aceitar módulos que não utilizam, ou a aguardar releases desnecessários para obter uma correção.

## Critérios Objetivos

- [ ] O pacote reutilizável deve ser minimamente coeso (SRP aplicado no nível de pacote).
- [ ] Todos os itens do pacote reutilizável devem ser lançados sob a mesma versão (sem *sub-versioning*).
- [ ] A pasta/pacote deve ter um único propósito de reutilização (ex.: *Logging*, *Validation*, *DomainPrimitives*).

## Exceções Permitidas

- **Monorepos com Workspaces**: Ambientes onde o gerenciamento de dependências é estritamente controlado para que a versão esteja sempre sincronizada.

## Como Detectar

### Manual

Verificar se o pacote contém classes que não são utilizadas em conjunto pelos clientes.

### Automático

Análise de dependências: `dependency-analysis` para identificar classes não utilizadas.

## Relacionado a

- [016 - Common Closure Principle](../package-principles/002_common-closure-principle.md): complementa
- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reforça
- [014 - Dependency Inversion Principle](005_dependency-inversion-principle.md): reforça
- [017 - Common Reuse Principle](../package-principles/003_common-reuse-principle.md): complementa
- [040 - Single Codebase](../twelve-factor/001_single-codebase.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
