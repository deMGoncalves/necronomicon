# Common Closure Principle (CCP)

**ID**: STRUCTURAL-016
**Severity**: 🟠 High
**Category**: Structural

---

## O que é

Classes que mudam juntas pelo mesmo motivo devem ser empacotadas juntas.

## Por que importa

O CCP reforça o SRP no nível de pacote, garantindo que as modificações de software sejam localizadas. Reduz a necessidade de alterar muitos pacotes em uma única mudança de requisito, facilitando o deploy e a manutenção.

## Critérios Objetivos

- [ ] O pacote deve ser revisado se uma mudança de requisito causar modificações em mais de **3** arquivos de classe/módulo não relacionados.
- [ ] Classes relacionadas a uma única entidade de domínio (ex.: `Order`, `OrderService`, `OrderFactory`) devem estar no mesmo pacote.
- [ ] Classes que mudam juntas devem estar no mesmo diretório para facilitar a coesão.

## Exceções Permitidas

- **Classes de Infraestrutura Compartilhada**: Classes utilizadas em muitos pacotes e que residem em um pacote utilitário de baixo nível.

## Como Detectar

### Manual

Analisar o histórico de commits: verificar se um único *feature request* afetou classes espalhadas por vários pacotes.

### Automático

Análise de métricas de código: ferramentas que rastreiam arquivos alterados por funcionalidade.

## Relacionado a

- [010 - Single Responsibility Principle](001_single-responsibility-principle.md): reforça
- [015 - Release Reuse Equivalency Principle](../package-principles/001_release-reuse-equivalency-principle.md): complementa
- [007 - Maximum Lines per Class Limit](../object-calisthenics/007_maximum-lines-per-class.md): reforça
- [017 - Common Reuse Principle](../package-principles/003_common-reuse-principle.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
