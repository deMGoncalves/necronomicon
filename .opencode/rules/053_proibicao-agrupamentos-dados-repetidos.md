# Proibição de Agrupamentos de Dados Repetidos (Data Clumps)

**ID**: AP-20-053
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Data Clumps (Aglomerados de Dados) ocorre quando grupos de dados sempre aparecem juntos como parâmetros de funções, atributos de classes ou variáveis locais, mas não têm um objeto ou estrutura própria que represente esse conceito coeso. São primitivos que sempre viajam juntos mas nunca se casaram.

## Por que importa

- Inflação de parâmetros: funções recebem muitos valores individuais ao invés de um objeto
- Validação duplicada: mesma lógica de validação repetida em múltiplas localizações
- Mudança onerosa: alterar conceito exige modificar N assinaturas de função
- Baixa coesão conceitual: o domínio fica modelado como primitivos dispersos
- Dificuldade de extensão: adicionar campo novo exige mudar todas as funções que usam o grupo

## Critérios Objetivos

- [ ] 3 ou mais parâmetros appearing juntos em mais de 2 funções diferentes
- [ ] Grupo de atributos que sempre são lidos/escritos juntos em uma classe
- [ ] Remover um dos dados do grupo torna os outros sem sentido ou incompletos
- [ ] Mesmo conjunto de tipos/formato aparece repetidamente em assinaturas de método
- [ ] Validação dos campos é idêntica em diferentes localizações do código

## Exceções Permitidas

- Grupos temporários em eventos únicos ou scripts de migração
- Integrações com APIs externas que não permitem objetos customizados
- Código legado onde refatoração traria risco alto sem ganho claro

## Como Detectar

### Manual
- Buscar assinaturas de função com parâmetros repetidos exatamente mesmo nome/tipo
- Identificar funções que sempre recebem `(street, city, zipCode, country)`, `(startX, startY, endX, endY)`, `(day, month, year)`
- Procurar por padrões de coerência: se mudar um campo, sempre mudam os outros juntos

### Automático
- Análise estática: detectar assinaturas com grupos de parâmetros idênticos
- Análise de código: identificar parâmetros co-ocorrentes em funções
- Ferramentas de refatoração: suggestions para "Introduce Parameter Object"

## Relacionada com

- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [033 - Limite de Parâmetros por Função](033_limite-parametros-funcao.md): complementa
- [034 - Nomes de Classes e Métodos Consistentes](034_nomes-classes-metodos-consistentes.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0