# Proibição de Agrupamentos de Dados Repetidos (Data Clumps)

**ID**: AP-20-053
**Severidade**: 🟡 Média
**Categoria**: Estrutural

---

## O que é

Data Clumps ocorrem quando grupos de dados sempre aparecem juntos como parâmetros de função, atributos de classe ou variáveis locais, mas não possuem seu próprio objeto ou estrutura representando aquele conceito coeso. São primitivos que sempre viajam juntos mas nunca se casaram.

## Por que importa

- Inflação de parâmetros: funções recebem muitos valores individuais em vez de um objeto
- Validação duplicada: mesma lógica de validação repetida em múltiplos locais
- Mudança custosa: alterar o conceito requer modificar N assinaturas de função
- Baixa coesão conceitual: o domínio é modelado como primitivos espalhados
- Dificuldade de extensão: adicionar novo campo requer alterar todas as funções que usam o grupo

## Critérios Objetivos

- [ ] 3 ou mais parâmetros aparecendo juntos em mais de 2 funções diferentes
- [ ] Grupo de atributos que são sempre lidos/escritos juntos em uma classe
- [ ] Remover um elemento de dados do grupo torna os outros sem significado ou incompletos
- [ ] Mesmo conjunto de tipos/formato aparece repetidamente em assinaturas de métodos
- [ ] Validação de campos é idêntica em diferentes locais do código

## Exceções Permitidas

- Grupos temporários em eventos únicos ou scripts de migração
- Integrações com APIs externas que não permitem objetos customizados
- Código legado onde refatoração traria alto risco sem ganho claro

## Como Detectar

### Manual
- Procurar assinaturas de função com parâmetros repetidos com exatamente o mesmo nome/tipo
- Identificar funções que sempre recebem `(rua, cidade, cep, pais)`, `(startX, startY, endX, endY)`, `(dia, mes, ano)`
- Buscar padrões de coerência: se um campo muda, os outros sempre mudam juntos

### Automático
- Análise estática: detectar assinaturas com grupos de parâmetros idênticos
- Análise de código: identificar parâmetros co-ocorrentes em funções
- Ferramentas de refatoração: sugestões de "Introduce Parameter Object"

## Relacionada com

- [003 - Encapsulamento de Primitivos](003_encapsulamento-primitivos.md): reforça
- [033 - Limite Máximo de Parâmetros por Função](033_limite-parametros-funcao.md): complementa
- [034 - Nomes de Classes e Métodos Consistentes](034_nomes-classes-metodos-consistentes.md): complementa
- [037 - Proibição de Argumentos Sinalizadores](037_proibicao-argumentos-sinalizadores.md): reforça

---

**Criada em**: 2026-03-28
**Versão**: 1.0
