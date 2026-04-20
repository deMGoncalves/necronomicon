---
name: package-principles
description: "6 princípios de design de pacotes (Robert C. Martin). Use quando @architect organizar módulos/pacotes, ou @reviewer verificar conformidade com rules 015-020 em imports e dependências."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Package Principles (Robert C. Martin)

## O que é

Os **6 Princípios de Pacotes** (Package Principles) de Robert C. Martin são métricas e diretrizes para organizar classes em pacotes/módulos coesos e com dependências saudáveis. Dividem-se em dois grupos complementares:

### Grupo 1: Coesão de Pacotes (Principles of Package Cohesion)
Respondem: **"O que colocar dentro de um pacote?"**

- **REP** (Release Reuse Equivalency): Granularidade de reuso = granularidade de release
- **CCP** (Common Closure): Classes que mudam juntas devem estar juntas
- **CRP** (Common Reuse): Classes reutilizadas juntas devem estar juntas

### Grupo 2: Acoplamento de Pacotes (Principles of Package Coupling)
Respondem: **"Como organizar dependências entre pacotes?"**

- **ADP** (Acyclic Dependencies): Grafo de dependências deve ser acíclico (DAG)
- **SDP** (Stable Dependencies): Dependa de pacotes estáveis
- **SAP** (Stable Abstractions): Pacotes estáveis devem ser abstratos

## Quando Usar

| Cenário | Princípio(s) relevante(s) |
|---------|--------------------------|
| Criar novo módulo/pacote | REP, CCP, CRP (Coesão) |
| Organizar estrutura de pastas | CCP, CRP |
| Decidir onde colocar uma classe | CCP (muda junto com quais outras?) |
| Versionar biblioteca compartilhada | REP |
| Detectar import circular | ADP |
| Avaliar estabilidade de módulo | SDP, SAP |
| Refatorar para reduzir acoplamento | ADP, SDP |
| Definir interface pública de módulo | SAP, CRP |

## Os 6 Princípios

| Princípio | Grupo | Rule deMGoncalves | Pergunta-chave | Arquivo de Referência |
|-----------|-------|-------------------|----------------|----------------------|
| **REP** - Release Reuse Equivalency | Coesão | [015](../../rules/015_principio-equivalencia-lancamento-reuso.md) | Reuso e release têm mesma granularidade? | [rep.md](references/rep.md) |
| **CCP** - Common Closure | Coesão | [016](../../rules/016_principio-fechamento-comum.md) | Classes que mudam juntas estão juntas? | [ccp.md](references/ccp.md) |
| **CRP** - Common Reuse | Coesão | [017](../../rules/017_principio-reuso-comum.md) | Se usa uma classe, usa todas do pacote? | [crp.md](references/crp.md) |
| **ADP** - Acyclic Dependencies | Acoplamento | [018](../../rules/018_principio-dependencias-aciclicas.md) | Grafo de dependências é DAG? | [adp.md](references/adp.md) |
| **SDP** - Stable Dependencies | Acoplamento | [019](../../rules/019_principio-dependencias-estaveis.md) | Instabilidade I < 0.5 para módulos críticos? | [sdp.md](references/sdp.md) |
| **SAP** - Stable Abstractions | Acoplamento | [020](../../rules/020_principio-abstracoes-estaveis.md) | Abstração A alta se Instabilidade I baixa? | [sap.md](references/sap.md) |

## Tensão Arquitetural: Triângulo de Coesão

Os três princípios de coesão criam uma **tensão arquitetural**:

```
          REP
         /   \
        /     \
       /       \
      /         \
     /           \
    CCP --------- CRP
```

- **REP ↔ CCP**: CCP favorece coesão por mudança (classes grandes). REP favorece reuso granular (pacotes pequenos).
- **CCP ↔ CRP**: CCP quer tudo junto que muda junto. CRP quer separar o que não é reutilizado junto.
- **REP ↔ CRP**: REP quer releases coesos. CRP quer pacotes reutilizáveis isoladamente.

**Balanceamento**: Arquiteto deve encontrar equilíbrio conforme fase do projeto (early stage = CCP; mature = REP + CRP).

## Seleção Rápida por Sintoma

### "Commit pequeno afeta 10+ arquivos em pacotes diferentes"
→ **Violação de CCP** — classes que mudam juntas devem estar juntas

### "Atualizar biblioteca exige aceitar 50 classes não usadas"
→ **Violação de CRP** — pacote tem classes não reutilizadas em conjunto

### "Import circular entre módulos quebra build"
→ **Violação de ADP** — quebrar ciclo via DIP (extrair interface)

### "Módulo de domínio depende de módulo de infra volátil"
→ **Violação de SDP** — dependências devem apontar para estabilidade

### "Módulo estável mas 100% concreto (zero interfaces)"
→ **Violação de SAP** — pacotes estáveis devem ser abstratos

### "Não sei onde colocar nova classe"
→ **Aplicar CCP** — colocar com classes que mudarão pelo mesmo motivo

## Proibições

Esta skill detecta e previne:

- **❌ Dependências circulares** (viola ADP)
- **❌ Pacotes com classes heterogêneas** (viola CCP, CRP)
- **❌ Módulo estável dependendo de instável** (viola SDP)
- **❌ Módulo estável 100% concreto** (viola SAP)
- **❌ Releases com granularidade diferente de reuso** (viola REP)
- **❌ Commit tocando múltiplos pacotes não relacionados** (viola CCP)

## Métricas Objetivas

### Instabilidade (I)
```
I = Dependências de Saída / Total de Dependências
I ∈ [0, 1]

I = 0 → Máxima estabilidade (ninguém depende dele, ele depende de muitos)
I = 1 → Máxima instabilidade (muitos dependem dele, ele não depende de ninguém)
```

### Abstração (A)
```
A = Total de Abstrações / Total de Classes
A ∈ [0, 1]

A = 0 → 100% concreto
A = 1 → 100% abstrato
```

### Distância da Main Sequence (D)
```
D = |A + I - 1|
D ∈ [0, 1]

D ≈ 0 → Na Main Sequence (ideal)
D ≈ 1 → Zona de Dor ou Zona de Inutilidade
```

**Zonas**:
- **Zone of Pain** (A=0, I=0): Pacote concreto e estável — difícil de mudar
- **Zone of Uselessness** (A=1, I=1): Pacote abstrato e instável — não tem valor
- **Main Sequence** (A + I = 1): Equilíbrio ideal

## Fundamentação

**Rules deMGoncalves 015–020** implementam os 6 princípios:

- **Severidade crítica (🔴)**: ADP (018), SAP (020) — quebram arquitetura
- **Severidade alta (🟠)**: REP (015), CCP (016), SDP (019) — exigem justificativa
- **Severidade média (🟡)**: CRP (017) — melhoria esperada

**Skills relacionadas:**
- [`solid`](../solid/SKILL.md) — depende: REP/CCP/CRP dependem de SRP e OCP
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — complementa: OC complementa no nível de classe

## Exemplos de Uso

### @architect: Organizar novo módulo
```typescript
// Aplicar CCP: agrupar classes que mudam juntas
src/
├── user/                  // Entidade de domínio
│   ├── User.ts
│   ├── UserService.ts
│   ├── UserRepository.ts
│   └── UserFactory.ts
└── billing/               // Outro contexto
    ├── Invoice.ts
    ├── Payment.ts
    └── BillingService.ts
```

### @reviewer: Detectar violação de ADP (ciclo)
```typescript
// FIXME: Ciclo detectado — Order → Payment → Order
// Order.ts
import { Payment } from './Payment';

// Payment.ts
import { Order } from './Order';  // violação

// Solução: extrair interface
interface PaymentProcessor {
  process(amount: number): Promise<void>;
}
```

### @reviewer: Calcular métricas SDP/SAP
```bash
# Módulo domain/
# Fan-in: 15 (15 módulos dependem dele)
# Fan-out: 3 (ele depende de 3 módulos)

I = 3 / (15 + 3) = 0.167  # Estável ✅
A = 8 / 12 = 0.667        # 67% abstrato ✅
D = |0.667 + 0.167 - 1| = 0.166  # Na Main Sequence ✅
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
