# Singleton

**Categoria:** Criacional
**Intenção:** Garantir que uma classe tenha apenas uma instância e fornecer ponto de acesso global a ela.

---

## Quando Usar

- Gerenciamento de conexão a banco de dados
- Configuração global da aplicação
- Logger centralizado
- Cache compartilhado em memória

## Quando NÃO Usar

- Como substituto de injeção de dependência — viola DIP (rule 014) e dificulta testes
- Para objetos que precisam de múltiplas instâncias com estados distintos
- Em sistemas com concorrência onde a instância única pode ser gargalo

## Estrutura Mínima (TypeScript)

```typescript
class DatabaseConnection {
  private static instance: DatabaseConnection

  // Construtor privado impede instanciação direta
  private constructor(private readonly url: string) {}

  static getInstance(url: string): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection(url)
    }
    return DatabaseConnection.instance
  }

  query(sql: string): Promise<unknown[]> {
    // executa query
    return Promise.resolve([])
  }
}
```

## Exemplo de Uso Real

```typescript
const db = DatabaseConnection.getInstance(process.env.DATABASE_URL)
```

## Relacionada com

- [flyweight.md](flyweight.md): complementa — ambos controlam instâncias; Flyweight para muitas, Singleton para uma
- [factory-method.md](factory-method.md): complementa — Factory Method pode retornar a instância Singleton
- [rule 014 - Princípio de Inversão de Dependência](../../../rules/014_principio-inversao-dependencia.md): reforça — não usar Singleton como substituto de DI
- [rule 070 - Proibição de Estado Mutável Compartilhado](../../../rules/070_proibicao-estado-mutavel-compartilhado.md): reforça — instância única com estado mutável é risco

---

**GoF Categoria:** Creational
**Fonte:** Design Patterns — Gamma, Helm, Johnson, Vlissides (1994)
