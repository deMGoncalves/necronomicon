# Common Reuse Principle (CRP)

**ID**: STRUCTURAL-017
**Severity**: 🟡 Medium
**Category**: Structural

---

## O que é

Classes em um pacote devem ser reutilizadas em conjunto. Se você usa uma, deve usar todas.

## Por que importa

O CRP ajuda a refinar a granularidade dos pacotes, garantindo que os clientes não sejam forçados a depender de classes que não utilizam, o que evita recompilações/redeploys desnecessários e reduz o acoplamento indesejado.

## Critérios Objetivos

- [ ] O pacote deve ser dividido se houver classes não utilizadas por pelo menos **50%** dos clientes que o importam.
- [ ] Se uma classe é utilizada de forma isolada, deve ser movida para um pacote utilitário ou removida do pacote coeso.
- [ ] Não deve haver mais de **3** classes públicas dentro de um pacote que não sejam referenciadas externamente.

## Exceções Permitidas

- **Métodos de Suporte Privados**: Classes helper internas que são estritamente utilizadas para suportar as classes públicas do pacote.

## Como Detectar

### Manual

Verificar o diretório de `imports` de um cliente e observar quantas classes do pacote importado ele utiliza ativamente.

### Automático

Análise de dependências: Ferramentas que mapeiam o percentual de classes consumidas dentro de um pacote.

## Relacionado a

- [015 - Release Reuse Equivalency Principle](../package-principles/001_release-reuse-equivalency-principle.md): complementa
- [013 - Interface Segregation Principle](004_interface-segregation-principle.md): reforça
- [016 - Common Closure Principle](../package-principles/002_common-closure-principle.md): complementa

---

**Criado em**: 2025-10-04
**Versão**: 1.0
