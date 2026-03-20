# Metodologia CDD (Cognitive-Driven Development)

## Visão Geral

CDD (Cognitive-Driven Development) é uma metodologia de desenvolvimento e revisão de código focada na **carga cognitiva** que o código impõe aos desenvolvedores que precisam lê-lo, entendê-lo e modificá-lo.

## Princípios Fundamentais

### 1. Complexidade Cognitiva > Complexidade Ciclomática

Enquanto a Complexidade Ciclomática (CC) mede o número de caminhos de execução, a **Complexidade Cognitiva** mede o esforço mental necessário para compreender o código.

**Exemplo:**

```javascript
// CC = 4, mas baixa complexidade cognitiva
function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  if (!user.name) return false;
  return true;
}

// CC = 4, mas ALTA complexidade cognitiva
function processData(data) {
  if (data) {
    if (data.items) {
      for (let item of data.items) {
        if (item.active) {
          // processamento aninhado
        }
      }
    }
  }
}
```

### 2. ICP (Intrinsic Complexity Points)

ICP é uma métrica composta que considera:

- **Complexidade Ciclomática** (caminhos de execução)
- **Profundidade de Aninhamento** (níveis de indentação)
- **Número de Responsabilidades** (violação do SRP)
- **Acoplamento** (dependências)

Consulte `icp-calculation.md` para detalhes de cálculo.

### 3. A Regra "Ler é Mais Importante que Escrever"

O código é lido **10 vezes mais** do que é escrito. O CDD prioriza:

- **Legibilidade** > Concisão
- **Clareza** > Esperteza
- **Explícito** > Implícito

## Camadas de Análise CDD

### Camada 1: Análise de ICP

Quantifica a complexidade cognitiva do código por meio do ICP.

**Meta:** ICP ≤ 5 para a maioria dos métodos

### Camada 2: Validação de Rules

Verifica a conformidade com regras arquiteturais e de design:

- **Estruturais**: Layout, organização, nomenclatura
- **Comportamentais**: Princípios SOLID, padrões de design
- **Criacionais**: Encapsulamento, imutabilidade
- **Infraestrutura**: 12 Factor App, implantação

### Camada 3: Identificação de Padrões

Identifica oportunidades de aplicar padrões conhecidos:

- **Padrões GoF**: Soluções para problemas comuns de design
- **Padrões PoEAA**: Padrões arquiteturais empresariais

## Aplicação em Code Review

### Passo 1: Varredura Rápida (2-5 minutos)

- Identificar arquivos com ICP > 5
- Identificar violações óbvias de rules (nomes, estrutura)
- Identificar anti-padrões conhecidos

### Passo 2: Análise Profunda (10-20 minutos)

- Calcular ICP detalhado para arquivos críticos
- Verificar conformidade com as rules relevantes
- Identificar oportunidades de refatoração

### Passo 3: Calibração Contextual (5 minutos)

- Considerar o tipo de PR (fix, feature, refactor)
- Considerar o contexto de negócio (urgência, dívida técnica)
- Calibrar severidade com base no impacto real

## Métricas de Sucesso

### Para o Código

- **ICP médio** do projeto ≤ 4
- **0% dos métodos** com ICP > 10
- **≥ 80% de conformidade** com rules críticas

### Para o Time

- **Redução de bugs** em código com ICP baixo
- **Aumento de velocidade** em modificações
- **Redução de dívida técnica** ao longo do tempo

## Anti-Padrões a Evitar

### 1. Perfeccionismo Paralisante

❌ Bloquear PRs por violações menores de rules não críticas
✅ Focar em violações que impactam manutenibilidade e bugs

### 2. Rigidez de Rules

❌ Aplicar rules rigidamente sem considerar o contexto
✅ Calibrar severidade com base no tipo de PR e urgência

### 3. Análise Superficial

❌ Revisar apenas estilo de código e formatação
✅ Analisar complexidade cognitiva e design

### 4. Falta de Pragmatismo

❌ Exigir código perfeito que nunca é entregue
✅ Aceitar o "bom o suficiente" que entrega valor

## Referências

- **Rules** (51 regras arquiteturais):
  - `references/object-calisthenics/` - 9 regras de Object Calisthenics
  - `references/solid/` - 5 princípios SOLID
  - `references/package-principles/` - 6 princípios de Pacotes
  - `references/clean-code/` - 19 regras de Clean Code
  - `references/twelve-factor/` - 12 regras do Twelve-Factor App

- **Padrões** (66 padrões de design):
  - `references/gof/` - 23 padrões GoF (criacionais, estruturais, comportamentais)
  - `references/poeaa/` - 43 padrões PoEAA (domain-logic, data-source, object-relational, web-presentation, offline-concurrency, session-state, base)

- **Cálculo de ICP**: `references/icp-calculation.md`

## Versão

Metodologia CDD v1.0 - Março 2026
