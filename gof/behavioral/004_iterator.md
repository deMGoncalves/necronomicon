# Iterator

**Classificação**: Padrão Comportamental

---

## Intenção e Objetivo

Fornecer uma maneira de acessar sequencialmente os elementos de um objeto agregado sem expor sua representação subjacente. Desacopla algoritmos de contêineres, permitindo percorrer coleções sem conhecer sua estrutura interna.

## Também Conhecido Como

- Cursor

## Motivação

Um objeto agregado como uma lista deve fornecer uma forma de acessar seus elementos sem expor sua estrutura interna. Além disso, você pode querer percorrer a lista de diferentes maneiras. Mas você não quer sobrecarregar a interface de List com diferentes operações de percurso. Você também pode precisar de mais de um percurso pendente sobre a mesma lista.

O padrão Iterator permite fazer tudo isso. A ideia central é retirar a responsabilidade de acesso e percurso do objeto lista e colocá-la em um objeto iterador. A classe Iterator define uma interface para acessar elementos. Uma instância de Iterator mantém o controle do elemento atual e quais foram percorridos.

## Aplicabilidade

Use o padrão Iterator quando:

- Acessar o conteúdo de um objeto agregado sem expor sua representação interna
- Suportar múltiplos percursos de objetos agregados
- Fornecer uma interface uniforme para percorrer diferentes estruturas agregadas (iteração polimórfica)
- Desacoplar algoritmos de estruturas de dados
- Implementar avaliação preguiçosa de coleções

## Estrutura

```
Client
└── Usa: Iterator, Aggregate

Aggregate (Interface)
└── createIterator(): Iterator

ConcreteAggregate implements Aggregate
├── Mantém: elementos internos
└── createIterator() → return new ConcreteIterator(this)

Iterator (Interface)
├── hasNext(): boolean
├── next(): Element
└── remove() (opcional)

ConcreteIterator implements Iterator
├── Compõe: ConcreteAggregate
├── Mantém: posição atual
├── hasNext() → verifica se há próximo
└── next() → retorna o próximo e avança
```

## Participantes

- [**Iterator**](004_iterator.md): Define a interface para acessar e percorrer elementos
- **ConcreteIterator**: Implementa a interface Iterator; mantém o controle da posição atual no percurso do agregado
- **Aggregate**: Define a interface para criar um objeto Iterator
- **ConcreteAggregate**: Implementa a interface de criação de Iterator para retornar uma instância do ConcreteIterator adequado

## Colaborações

- ConcreteIterator mantém o controle do objeto atual no agregado e pode calcular o próximo item no percurso

## Consequências

### Vantagens

- **Suporta variações no percurso**: Agregados complexos podem ser percorridos de muitas formas; pode-se definir novos iteradores sem alterar o agregado
- **Simplifica a interface do Aggregate**: Não é necessário ter operações de percurso no Aggregate
- **Mais de um percurso pode estar pendente**: Cada iterador mantém seu próprio estado de percurso

### Desvantagens

- **Sobrecarga**: Para coleções simples pode ser uma sobrecarga desnecessária
- **Acesso direto**: Pode ser mais lento do que acesso direto por índice

## Implementação

### Considerações

1. **Quem controla a iteração**: Iterador externo (o cliente controla) vs iterador interno (o iterador controla)

2. **Quem define o algoritmo de percurso**: Iterator ou Aggregate; tê-lo no iterador permite diferentes algoritmos; tê-lo no agregado evita duplicação

3. **Robustez do iterador**: Modificações no agregado durante a iteração podem ser perigosas; solução: copiar o agregado ou registrar o iterador no agregado

4. **Operações adicionais no Iterator**: Pode ter previous(), currentItem(), skipTo(), etc.

5. **Usando iteradores em linguagens tipadas**: Usar generics/templates

6. **Iteradores nulos**: Ter um iterador de objeto nulo para coleções vazias

7. **Acesso privilegiado**: O iterador pode precisar de acesso privilegiado à estrutura interna do agregado

### Técnicas

- **Iterador Interno**: O iterador controla a iteração (forEach)
- **Iterador Externo**: O cliente controla a iteração (hasNext/next)
- **Iterador Fail-fast**: Lança exceção se o agregado for modificado durante a iteração
- **Generator/Yield**: Iteradores preguiçosos usando corotinas

## Usos Conhecidos

- **Java Collections**: Interface `Iterator`, enhanced for-loop
- **JavaScript**: Protocolo de iteração (`Symbol.iterator`), loops for-of
- **Python**: Protocolo `__iter__` e `__next__`, generators
- **C++ STL**: Iteradores para todos os contêineres
- **Cursores de Banco de Dados**: Iterar sobre conjuntos de resultados
- **Leitores de Arquivo**: Ler arquivos linha por linha

## Padrões Relacionados

- [**Composite**](008_composite.md): Iteradores frequentemente aplicados a estruturas recursivas
- [**Factory Method**](../creational/003_factory-method.md): Aggregate usa Factory Method para instanciar iteradores adequados
- [**Memento**](006_memento.md): Pode ser usado com Iterator para capturar o estado da iteração
- [**Visitor**](011_visitor.md): Visitor pode usar Iterator para percorrer a estrutura
- [**Strategy**](009_strategy.md): Iterator pode ser visto como Strategy para acessar coleções

### Relação com Rules

- [010 - Single Responsibility Principle](../../solid/001_single-responsibility-principle.md): separar iteração da coleção
- [004 - First-Class Collections](../../object-calisthenics/004_colecoes-primeira-classe.md): iterador encapsula o acesso
- [036 - Function Side Effects Restriction](../../clean-code/restricao-funcoes-efeitos-colaterais.md): iteração sem efeitos colaterais

---

**Criado em**: 2025-01-11
**Versão**: 1.0
