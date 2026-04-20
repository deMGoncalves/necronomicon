# Princípio do Reuso Comum (CRP)

**ID**: ESTRUTURAL-017
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

As classes em um pacote devem ser reutilizadas em conjunto. Se você usa uma, você deve usar todas.

## Por que importa

O CRP ajuda a refinar a granularidade do pacote, garantindo que os clientes não sejam forçados a depender de classes que não usam, o que evita recompilações/redeploy desnecessários e reduz o acoplamento indesejado.

## Critérios Objetivos

- [ ] O pacote deve ser dividido se houver classes que não são utilizadas por pelo menos **50%** dos clientes que importam o pacote.
- [ ] Se uma classe é usada isoladamente, ela deve ser movida para um pacote de utilidade ou para fora do pacote coeso.
- [ ] Não deve haver mais de **3** classes públicas dentro de um pacote que não são referenciadas externamente.

## Exceções Permitidas

- **Métodos Privados de Suporte**: Classes auxiliares internas que são estritamente usadas para suportar as classes públicas do pacote.

## Como Detectar

### Manual

Verificar o diretório de `imports` de um cliente e ver quantas classes do pacote importado ele usa ativamente.

### Automático

Análise de dependências: Ferramentas que mapeiam a porcentagem de classes consumidas dentro de um pacote.

## Relacionada com

- [015 - Princípio de Equivalência de Lançamento e Reuso](015_principio-equivalencia-lancamento-reuso.md): complementa
- [013 - Princípio de Segregação de Interface](013_principio-segregacao-interfaces.md): reforça
- [016 - Princípio do Fechamento Comum](016_principio-fechamento-comum.md): complementa
- [056 - Proibição de Código Zombie (Lava Flow)](056_proibicao-codigo-zombie-lava-flow.md): reforça
- [067 - Proibição de Dependência Barco Âncora](067_proibicao-dependencia-barco-ancora.md): reforça

---

**Criada em**: 2025-10-04
**Versão**: 1.0
