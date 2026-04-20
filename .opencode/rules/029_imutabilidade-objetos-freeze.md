# Imutabilidade de Objetos de Domínio (Object.freeze)

**ID**: CRIACIONAL-029
**Severidade**: 🟠 Alta
**Categoria**: Criacional

---

## O que é

Exige que todos os objetos criados para representar Entidades ou *Value Objects* do Domínio sejam **imutáveis**, aplicando explicitamente métodos de congelamento (`Object.freeze()`) antes de serem expostos.

## Por que importa

A mutabilidade acidental introduz bugs graves e dificulta o rastreamento da origem da mudança de estado, violando o princípio do **Encapsulamento**. O congelamento garante que o objeto não mude após sua criação.

## Critérios Objetivos

- [ ] Todas as instâncias de `Value Objects` ou `Entities` de domínio devem ser congeladas antes de sair do construtor ou da camada de persistência.
- [ ] É proibido aceitar objetos do domínio como parâmetro em métodos públicos e modificá-los sem clonar ou forçar um método de intenção.
- [ ] A imutabilidade deve ser aplicada de forma *shallow* (superficial) ou *deep* (profunda), dependendo do objeto.

## Exceções Permitidas

- **DTOs Puros**: Objetos de transferência de dados usados estritamente para comunicação externa ou mapeamento de dados.

## Como Detectar

### Manual

Verificar a ausência de `Object.freeze()` em métodos *Factory* ou construtores de Entidades.

### Automático

TypeScript: Uso de `readonly` em propriedades.

## Relacionada com

- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [008 - Proibição de Getters/Setters](008_proibicao-getters-setters.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [045 - Processos Stateless](045_processos-stateless.md): complementa
- [070 - Proibição de Estado Mutável Compartilhado](070_proibicao-estado-mutavel-compartilhado.md): reforça

---

**Criada em**: 2025-10-08
**Versão**: 1.0
