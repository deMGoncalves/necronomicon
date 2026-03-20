# Identity Field

**Classificação**: Padrão Object-Relational Estrutural

---

## Intenção e Objetivo

Salvar o ID do objeto no banco de dados como um campo no objeto para manter a identidade entre memória e banco de dados. Usa a chave primária do banco de dados como identidade do objeto.

## Também Conhecido Como

- ID Field
- Primary Key Field
- Object ID

## Motivação

Para persistir um objeto em um banco de dados relacional e recuperá-lo depois, você precisa de uma forma de identificar qual linha corresponde a qual objeto. O Identity Field resolve isso armazenando a chave primária da linha como uma propriedade do objeto. Quando o objeto é salvo, o ID é gerado ou atualizado. Quando o objeto é carregado, o ID vem junto, permitindo futuras atualizações.

Decisões-chave incluem: usar chaves numéricas auto-incrementadas, GUIDs ou chaves compostas; se o ID é imutável ou pode mudar; se é gerado pelo banco de dados ou pela aplicação. Cada escolha afeta performance, portabilidade e complexidade. O Identity Field torna o ID uma parte explícita do modelo de objetos.

## Aplicabilidade

Use Identity Field quando:

- Objetos precisam ser persistidos em banco de dados relacional
- A identidade única dos objetos precisa ser mantida entre sessões
- O Identity Map é usado para cache
- Relacionamentos precisam ser mapeados via chaves estrangeiras
- Atualizações e exclusões precisam identificar uma linha específica
- Qualquer padrão de persistência (Active Record, Data Mapper) é utilizado

## Estrutura

```
Domain Object
└── id: Identity Field

Opções de Implementação:
1. Chave Simples
   └── id: number (auto-increment)

2. Chave GUID
   └── id: string (UUID/GUID)

3. Chave Composta
   └── id: { orderId: number, itemId: number }

4. Chave Significativa
   └── id: string (email, username)

Tabela do Banco de Dados
└── coluna PRIMARY KEY
```

## Participantes

- **Domain Object**: Objeto contendo o Identity Field
- [**Identity Field**](004_identity-field.md): Propriedade que armazena a chave primária
- **Key Generator**: Gera novos IDs (banco de dados ou aplicação)
- [**Data Mapper**](../data-source/004_data-mapper.md): Usa o ID para correlacionar objetos com linhas

## Colaborações

- Quando um novo objeto é criado, o ID é nulo ou tem valor temporário
- Quando o objeto é inserido, o ID é gerado (pelo banco de dados ou pela aplicação)
- O ID gerado é armazenado no Identity Field do objeto
- Quando o objeto é carregado, o ID vem do banco de dados com os dados
- Para atualização, o Data Mapper usa o ID para identificar a linha
- Para exclusão, o ID identifica qual linha remover
- O Identity Map usa o ID como chave para o cache

## Consequências

### Vantagens

- **Identidade simples**: Forma direta de identificar objetos
- **Performance**: Chaves numéricas são rápidas para índices
- **Unicidade**: Garante identidade única no banco de dados
- **Relacionamentos**: Facilita o mapeamento de chaves estrangeiras
- **Portabilidade**: Conceito universal em bancos de dados relacionais
- **Cache**: Permite uso eficiente do Identity Map

### Desvantagens

- **Expõe detalhes de persistência**: ID é detalhe técnico no domínio
- **Geração de ID**: Coordenar a geração entre app e banco de dados
- **Chaves compostas**: Complexidade adicional
- **Mudança de ID**: Difícil se o ID precisar mudar
- **GUIDs**: Ocupam mais espaço que inteiros
- **Chaves significativas**: Podem mudar, violando a identidade

## Implementação

### Considerações

1. **Tipo da chave**: Auto-increment numérico, GUID ou chave natural
2. **Geração**: Gerado pelo banco de dados vs. gerado pela aplicação
3. **Imutabilidade**: ID deve ser imutável após a criação
4. **Visibilidade**: ID parte da interface pública ou interna
5. **Chaves compostas**: Como tratar chaves compostas
6. **Sequence vs. Identity**: Sequences do PostgreSQL vs. AUTO_INCREMENT do MySQL

### Técnicas

- **Auto-increment**: Deixar o banco de dados gerar IDs sequenciais
- **GUID/UUID**: Gerar GUIDs na aplicação
- **Algoritmo Hi/Lo**: Gerar IDs em lotes para performance
- **Sequence Object**: Usar sequences do banco de dados
- **Chave Natural**: Usar atributo de negócio como ID (evitar)
- **Chave Composta**: Usar objeto composto como ID

## Usos Conhecidos

- **Hibernate @Id**: Anotação Id no JPA/Hibernate
- **Entity Framework Key**: Chave primária no EF
- **ActiveRecord id**: Campo id padrão no Rails
- **Sequelize primaryKey**: Chave primária no Sequelize
- **TypeORM @PrimaryColumn**: Decorator de chave primária
- **SQLAlchemy primary_key**: Coluna com primary_key=True

## Padrões Relacionados

- [**Identity Map**](002_identity-map.md): Usa o Identity Field como chave
- [**Foreign Key Mapping**](005_foreign-key-mapping.md): Usa o Identity Field para relacionamentos
- [**Data Mapper**](../data-source/004_data-mapper.md): Usa o Identity Field para mapear objetos
- [**Unit of Work**](001_unit-of-work.md): Usa o ID para rastrear objetos
- [**Active Record**](../data-source/003_active-record.md): Armazena o ID internamente

### Relação com Rules

- [003 - Encapsulamento de Primitivos](../../object-calisthenics/003_encapsulamento-primitivos.md): ID pode ser Value Object
- [029 - Imutabilidade de Objetos](../../clean-code/imutabilidade-objetos-freeze.md): ID deve ser imutável

---

**Criado em**: 2025-01-11
**Versão**: 1.0
