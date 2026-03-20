# Association Table Mapping

**Classificação**: Padrão Object-Relational Estrutural

---

## Intenção e Objetivo

Salvar associação muitos-para-muitos como uma tabela de ligação com chaves estrangeiras para ambas as tabelas. Usa tabela intermediária para representar o relacionamento bidirecional entre objetos.

## Também Conhecido Como

- Join Table Mapping
- Link Table Mapping
- Many-to-Many Mapping
- Junction Table

## Motivação

Relacionamentos muitos-para-muitos são comuns em objetos: Student possui muitos Courses, Course possui muitos Students. Bancos de dados relacionais não suportam muitos-para-muitos diretamente — eles requerem uma tabela intermediária. O Association Table Mapping gerencia essa tabela de ligação de forma transparente.

A tabela de associação contém apenas chaves estrangeiras apontando para as duas entidades relacionadas. Por exemplo, student_courses tem student_id e course_id. Ao adicionar um Course a um Student, o Mapper insere uma linha na tabela de ligação. Ao remover, exclui a linha. Ao carregar um Student, o Mapper faz join nas tabelas via tabela de ligação para recuperar os Courses.

A tabela de ligação pode ser simples (apenas FKs) ou rica (com atributos adicionais como data de matrícula, nota). Uma tabela de ligação rica eventualmente se torna sua própria entidade.

## Aplicabilidade

Use Association Table Mapping quando:

- Objetos possuem relacionamentos muitos-para-muitos
- Banco de dados relacional normalizado é utilizado
- O relacionamento não possui atributos significativos próprios
- Ambos os lados do relacionamento são entidades independentes
- Coleções bidirecionais precisam ser navegadas
- O padrão ORM requer mapeamento explícito

## Estrutura

```
Domain Objects (em memória)
Student
├── id: 1
└── courses: [Course{id:101}, Course{id:102}]

Course
├── id: 101
└── students: [Student{id:1}, Student{id:2}]

Banco de Dados (persistido)
tabela students
└── id: 1, name: "Alice"

tabela courses
├── id: 101, name: "Matemática"
└── id: 102, name: "Física"

student_courses (tabela de ligação)
├── student_id: 1, course_id: 101
├── student_id: 1, course_id: 102
└── student_id: 2, course_id: 101
```

## Participantes

- **Entity A**: Primeira entidade no relacionamento (Student)
- **Entity B**: Segunda entidade no relacionamento (Course)
- **Association Table**: Tabela contendo apenas chaves estrangeiras
- **Link Row**: Linha na tabela de associação
- [**Data Mapper**](../data-source/004_data-mapper.md): Gerencia inserção/exclusão/consulta dos vínculos

## Colaborações

**Ao Adicionar Relacionamento:**
- Client adiciona Course à coleção Student.courses
- No commit, Mapper detecta mudança na coleção
- Mapper insere linha em student_courses com ambos os IDs
- Relacionamento agora existe no banco de dados

**Ao Carregar:**
- Mapper carrega Student do banco de dados
- Mapper consulta student_courses WHERE student_id = 1
- Mapper obtém os course_ids relacionados
- Mapper carrega os Courses correspondentes
- Mapper preenche Student.courses com os objetos Course

**Ao Remover:**
- Client remove Course da coleção Student.courses
- No commit, Mapper detecta a remoção
- Mapper exclui a linha correspondente de student_courses
- Relacionamento desfeito sem afetar as entidades

## Consequências

### Vantagens

- **Normalização**: Segue design relacional normalizado
- **Independência**: Entidades existem de forma independente
- **Bidirecionalidade**: Relacionamento navegável de ambos os lados
- **Flexibilidade**: Fácil adicionar/remover associações
- **Integridade**: Chaves estrangeiras mantêm a integridade referencial
- **Padrão difundido**: Amplamente utilizado e compreendido

### Desvantagens

- **Complexidade de join**: Queries requerem joins adicionais
- **Performance**: Mais tabelas para consultar
- **Tabela extra**: Tabela adicional para gerenciar
- **Vínculos mais ricos**: Se o vínculo precisar de atributos, torna-se entidade
- **Cascade deletes**: Requer configuração cuidadosa
- **Operações em massa**: Operações em massa são complexas

## Implementação

### Considerações

1. **Nomenclatura da tabela**: Convenção para o nome da tabela de ligação
2. **Chave composta**: Chave primária composta ou ID próprio?
3. **Bidirecionalidade**: Manter ambos os lados sincronizados
4. **Lazy/Eager**: Estratégia de carregamento da coleção
5. **Cascade**: O que acontece quando a entidade é excluída
6. **Atributos do vínculo**: Se o vínculo tiver atributos, considerar entidade

### Técnicas

- **PK Composta**: Usar (entity_a_id, entity_b_id) como chave primária
- **Unique Constraint**: Prevenir vínculos duplicados
- **Cascade Delete**: Excluir vínculos quando a entidade é removida
- **Coleção Lazy**: Não carregar a coleção até ser acessada
- **Join Fetch**: Usar join para carregar a coleção eficientemente
- **Lado Inverso**: Designar um lado como "dono" do relacionamento

## Usos Conhecidos

- **Hibernate @ManyToMany**: Com @JoinTable para a tabela de ligação
- **Entity Framework Many-to-Many**: Navigation properties
- **ActiveRecord has_and_belongs_to_many**: HABTM com join table
- **Sequelize belongsToMany**: Com a opção through
- **TypeORM @ManyToMany**: Com @JoinTable
- **Doctrine ManyToMany**: Com anotação JoinTable

## Padrões Relacionados

- [**Foreign Key Mapping**](005_foreign-key-mapping.md): A tabela de ligação possui duas chaves estrangeiras
- [**Identity Field**](004_identity-field.md): IDs usados na tabela de ligação
- [**Data Mapper**](../data-source/004_data-mapper.md): Implementa o mapeamento
- [**Dependent Mapping**](007_dependent-mapping.md): Alternativa para objetos dependentes
- [**Lazy Load**](003_lazy-load.md): Carrega coleções sob demanda

### Relação com Rules

- [004 - Coleções de Primeira Classe](../../object-calisthenics/004_colecoes-primeira-classe.md): coleções bem encapsuladas

---

**Criado em**: 2025-01-11
**Versão**: 1.0
