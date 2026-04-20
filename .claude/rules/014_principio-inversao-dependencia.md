# Aplicação do Princípio de Inversão de Dependência (DIP)

**ID**: COMPORTAMENTAL-014
**Severidade**: 🔴 Crítica
**Categoria**: Comportamental

---

## O que é

Módulos de alto nível não devem depender de módulos de baixo nível. Ambos devem depender de abstrações (interfaces).

## Por que importa

O DIP é crucial para desacoplar a política de negócio da implementação. A violação cria acoplamento rígido, dificultando testes (unidade e integração) e impedindo que o módulo de alto nível seja reutilizado em um novo contexto.

## Critérios Objetivos

- [ ] A criação de novas instâncias de classes concretas (*new Class()*) é proibida dentro de classes de alto nível (ex: *Services* e *Controllers*).
- [ ] Módulos de alto nível devem referenciar apenas interfaces ou classes abstratas (o que será injetado).
- [ ] O número de *imports* para classes concretas em construtores deve ser zero (apenas injeção de abstrações).

## Exceções Permitidas

- **Entidades e Value Objects**: Classes de dados puras que podem ser instanciadas livremente.
- **Root Composer**: O módulo de inicialização do sistema onde a injeção de dependência é configurada.

## Como Detectar

### Manual

Busca por `new NomeConcreto()` dentro do código de *Services* ou *Business Logic*.

### Automático

ESLint: `no-new-without-abstraction` (com regras customizadas).

## Relacionada com

- [011 - Princípio Aberto/Fechado](011_principio-aberto-fechado.md): reforça
- [015 - Princípio de Equivalência de Lançamento e Reuso](015_principio-equivalencia-lancamento-reuso.md): reforça
- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): complementa
- [018 - Princípio de Dependências Acíclicas](018_principio-dependencias-aciclicas.md): reforça
- [019 - Princípio de Dependências Estáveis](019_principio-dependencias-estaveis.md): reforça
- [020 - Princípio de Abstrações Estáveis](020_principio-abstracoes-estaveis.md): reforça
- [032 - Cobertura Mínima de Teste](032_cobertura-teste-minima-qualidade.md): complementa
- [041 - Declaração Explícita de Dependências](041_declaracao-explicita-dependencias.md): complementa
- [043 - Serviços de Apoio como Recursos](043_servicos-apoio-recursos.md): complementa

---

**Criada em**: 2025-10-04
**Atualizada em**: 2025-10-04
**Versão**: 1.1
