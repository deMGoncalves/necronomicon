# Proibição de Estado Mutável Compartilhado (Shared Mutable State)

**ID**: AP-08-070
**Severidade**: 🟠 Alta
**Categoria**: Comportamental

---

## O que é

Shared Mutable State ocorre quando múltiplos módulos, funções ou contextos de execução leem e modificam o mesmo objeto sem coordenação. Qualquer parte do sistema pode alterar o estado a qualquer momento, tornando o comportamento imprevisível. Distinto da Mutação Acidental (052): aqui o compartilhamento é estrutural, não acidental.

## Por que importa

- Bugs fantasmas: a origem da mutação está em módulo diferente do ponto de falha
- Testes frágeis: resultado depende do estado global deixado por testes anteriores
- Rastreabilidade zero: impossível saber quem alterou o estado sem breakpoints
- Concorrência impossível: qualquer paralelismo introduz race conditions

## Critérios Objetivos

- [ ] Objeto de domínio passado por referência e modificado em dois ou mais módulos distintos
- [ ] Variável de módulo ou global alterada por múltiplas funções sem coordenação explícita
- [ ] Testes que falham dependendo da ordem de execução (sinal de estado compartilhado)
- [ ] Array ou objeto usado como "buffer de comunicação" entre partes do sistema sem cópia
- [ ] Ausência de `Object.freeze()` em objetos passados para múltiplos consumidores

## Exceções Permitidas

- **Stores Explícitos**: Gerenciadores de estado (Redux, Zustand, MobX) onde o padrão de mutação é centralizado, rastreado e intencional.
- **Objetos de Configuração Read-Only**: Configurações congeladas com `Object.freeze()` passadas como constantes de leitura.

## Como Detectar

### Manual

Rastrear o ciclo de vida de um objeto: se ele é passado para múltiplas funções e cada uma pode modificá-lo, é Shared Mutable State.

### Automático

ESLint: `no-param-reassign`, TypeScript: `Readonly<T>`, `as const`. Testes: rodar em ordem aleatória detecta dependência de estado global.

## Relacionada com

- [029 - Imutabilidade de Objetos](029_imutabilidade-objetos-freeze.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [045 - Processos Stateless](045_processos-stateless.md): complementa
- [052 - Proibição de Mutação Acidental](052_proibicao-mutacao-acidental.md): complementa
- [069 - Proibição de Otimização Prematura](069_proibicao-otimizacao-prematura.md): complementa

---

**Criada em**: 2026-03-29
**Versão**: 1.0
