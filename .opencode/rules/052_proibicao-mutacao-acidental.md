# Proibição de Mutação Acidental

**ID**: AP-07-052
**Severidade**: 🟠 Alta
**Categoria**: Comportamental

---

## O que é

Mutação acidental ocorre quando objetos ou estruturas de dados são modificados inadvertidamente, frequentemente por passagem por referência ou efeitos colaterais não documentados. O estado original é alterado sem intenção explícita do desenvolvedor, causando bugs difíceis de rastrear.

## Por que importa

- Bugs imprevisíveis: estado mutado silenciosamente falha testes e produz comportamento incorreto
- Rastreamento difícil: o local onde a mutação ocorre pode estar distante de onde o erro é detectado
- Comportamento não idempotente: mesmo código pode ter resultados diferentes dependendo do estado anterior
- Baixa confiança no código: desenvolvedores hesitam em reutilizar funções devido a efeitos colaterais ocultos

## Critérios Objetivos

- [ ] Funções modificam parâmetros recebidos sem documentação explícita
- [ ] Objetos são retornados de funções após modificação de propriedades
- [ ] Arrays são modificados via `push()`, `splice()`, `pop()` sem criar cópia
- [ ] Estruturas de dados compartilhadas são mutadas de múltiplas localizações
- [ ] Variáveis locais têm seu valor reatribuído sem motivo claro
- [ ] Alterações em循对象 propagam para outros componentes não relacionados

## Exceções Permitidas

- Métodos explicitamente identificados como mutators (ex: `save()`, `update()`)
- Objetos temporários construídos e usados exclusivamente dentro mesmo escopo
- Implementações de mutadores obrigatórios em interfaces/framework que não suportam imutabilidade
- Código legado com mutação documentada e testes que garantem comportamento esperado

## Como Detectar

### Manual
- Buscar por `push()`, `pop()`, `splice()`, `unshift()` em arrays transitórios
- Identificar funções que retornam o mesmo objeto recebido como parâmetro
- Procurar reatribuições de parâmetros
- Verificar objetos compartilhados entre múltiplos módulos

### Automático
- Linters (ESLint): `no-param-reassign`, `no-const-assign`
- Type strictness: usar `Readonly<T>`, `as const`, `readonly`
- Libraries: Immer, Immutable.js para detectar mutações
- Test de snapshot: capturar estado antes/depois para detectar mudanças inesperadas

## Relacionada com

- [029 - Imutabilidade de Objetos (Freeze)](029_imutabilidade-objetos-freeze.md): reforça
- [036 - Restrição de Funções com Efeitos Colaterais](036_restricao-funcoes-efeitos-colaterais.md): reforça
- [009 - Diga Não, Pergunte](009_diga-nao-pergunte.md): complementa
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): complementa
- [039 - Regra do Escoteiro (Refatoração Contínua)](039_regra-escoteiro-refatoracao-continua.md): reforça
- [070 - Proibição de Estado Mutável Compartilhado](070_proibicao-estado-mutavel-compartilhado.md): complementa

---

**Criada em**: 2026-03-28
**Versão**: 1.0