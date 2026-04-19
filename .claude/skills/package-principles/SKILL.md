---
name: package-principles
description: "6 princípios de design de pacotes (Robert C. Martin). Use quando @architect organiza módulos/pacotes ou verifica conformidade com rules 015-020 em imports e dependências."
model: haiku
allowed-tools: Read
metadata:
  author: deMGoncalves
  version: "1.0.0"
---

# Package Principles (Robert C. Martin)

---

## Manifest

| Campo | Valor |
|-------|-------|
| **Applicability** | Ao criar novo módulo/pacote; ao organizar estrutura de pastas; ao detectar imports circulares; ao avaliar estabilidade de módulo; ao versionar biblioteca compartilhada |
| **Prerequisites** | Princípios SOLID (especialmente SRP e DIP — rules 010, 014); conceito de grafo direcionado acíclico (DAG) |
| **Constraints** | Triângulo de tensão REP/CCP/CRP: equilibrar conforme fase do projeto (inicial = CCP; maduro = REP + CRP); não calcular métricas de abstração em pacotes de dados puros (DTOs/Value Objects) |
| **Scope** | Os 6 princípios de pacote (REP, CCP, CRP, ADP, SDP, SAP) mapeados para rules 015–020, incluindo métricas de Instabilidade (I), Abstração (A) e Distância (D) |

---

## O que é

Os **6 Princípios de Pacote** de Robert C. Martin são métricas e diretrizes para organizar classes em pacotes/módulos coesos com dependências saudáveis. Divididos em dois grupos complementares:

### Grupo 1: Coesão de Pacotes (Principles of Package Cohesion)
Responde: **"O que colocar dentro de um pacote?"**

- **REP** (Release Reuse Equivalency): Granularidade de reuso = granularidade de release
- **CCP** (Common Closure): Classes que mudam juntas devem estar juntas
- **CRP** (Common Reuse): Classes reutilizadas juntas devem estar juntas

### Grupo 2: Acoplamento de Pacotes (Principles of Package Coupling)
Responde: **"Como organizar dependências entre pacotes?"**

- **ADP** (Acyclic Dependencies): Grafo de dependência deve ser acíclico (DAG)
- **SDP** (Stable Dependencies): Depender de pacotes estáveis
- **SAP** (Stable Abstractions): Pacotes estáveis devem ser abstratos

## Quando Usar

| Cenário | Princípio(s) Relevante(s) |
|---------|---------------------------|
| Criar novo módulo/pacote | REP, CCP, CRP (Coesão) |
| Organizar estrutura de pastas | CCP, CRP |
| Decidir onde colocar uma classe | CCP (muda com quais outras?) |
| Versionar biblioteca compartilhada | REP |
| Detectar import circular | ADP |
| Avaliar estabilidade de módulo | SDP, SAP |
| Refatorar para reduzir acoplamento | ADP, SDP |
| Definir interface pública de módulo | SAP, CRP |

## Os 6 Princípios

| Princípio | Grupo | Rule deMGoncalves | Pergunta-Chave | Arquivo de Referência |
|-----------|-------|-------------------|----------------|----------------------|
| **REP** - Release Reuse Equivalency | Coesão | [015](../../rules/015_principio-equivalencia-lancamento-reuso.md) | Reuso e release têm mesma granularidade? | [rep.md](references/rep.md) |
| **CCP** - Common Closure | Coesão | [016](../../rules/016_principio-fechamento-comum.md) | Classes que mudam juntas estão juntas? | [ccp.md](references/ccp.md) |
| **CRP** - Common Reuse | Coesão | [017](../../rules/017_principio-reuso-comum.md) | Se usa uma classe, usa todas no pacote? | [crp.md](references/crp.md) |
| **ADP** - Acyclic Dependencies | Acoplamento | [018](../../rules/018_principio-dependencias-aciclicas.md) | Grafo de dependência é DAG? | [adp.md](references/adp.md) |
| **SDP** - Stable Dependencies | Acoplamento | [019](../../rules/019_principio-dependencias-estaveis.md) | Instabilidade I < 0.5 para módulos críticos? | [sdp.md](references/sdp.md) |
| **SAP** - Stable Abstractions | Acoplamento | [020](../../rules/020_principio-abstracoes-estaveis.md) | Abstração A alta se Instabilidade I baixa? | [sap.md](references/sap.md) |

## Tensão Arquitetural: Triângulo de Coesão

Os três princípios de coesão criam **tensão arquitetural**:

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
- **REP ↔ CRP**: REP quer releases coesas. CRP quer pacotes independentemente reutilizáveis.

**Equilíbrio**: Arquiteto deve encontrar equilíbrio conforme fase do projeto (estágio inicial = CCP; maduro = REP + CRP).

## Seleção Rápida por Sintoma

### "Commit pequeno afeta 10+ arquivos em pacotes diferentes"
→ **Violação CCP** — classes que mudam juntas devem estar juntas

### "Atualizar biblioteca exige aceitar 50 classes não usadas"
→ **Violação CRP** — pacote tem classes não reutilizadas juntas

### "Import circular entre módulos quebra build"
→ **Violação ADP** — quebrar ciclo via DIP (extrair interface)

### "Módulo de domínio depende de módulo infra volátil"
→ **Violação SDP** — dependências devem apontar para estabilidade

### "Módulo estável mas 100% concreto (zero interfaces)"
→ **Violação SAP** — pacotes estáveis devem ser abstratos

### "Não sei onde colocar nova classe"
→ **Aplicar CCP** — colocar com classes que mudarão pela mesma razão

## Proibições

Esta skill detecta e previne:

- **❌ Dependências circulares** (viola ADP)
- **❌ Pacotes com classes heterogêneas** (viola CCP, CRP)
- **❌ Módulo estável dependendo de instável** (viola SDP)
- **❌ Módulo estável 100% concreto** (viola SAP)
- **❌ Releases com granularidade diferente do reuso** (viola REP)
- **❌ Commit tocando múltiplos pacotes não relacionados** (viola CCP)

## Métricas Objetivas

### Instabilidade (I)
```
I = Dependências de Saída / Total de Dependências
I ∈ [0, 1]

I = 0 → Estabilidade máxima (ninguém depende dele, ele depende de muitos)
I = 1 → Instabilidade máxima (muitos dependem dele, ele não depende de ninguém)
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
D ≈ 1 → Zona da Dor ou Zona da Inutilidade
```

**Zonas**:
- **Zona da Dor** (A=0, I=0): Pacote concreto e estável — difícil mudar
- **Zona da Inutilidade** (A=1, I=1): Pacote abstrato e instável — sem valor
- **Main Sequence** (A + I = 1): Equilíbrio ideal

## Justificativa

**Rules deMGoncalves 015–020** implementam os 6 princípios:

- **Severidade crítica (🔴)**: ADP (018), SAP (020) — quebram arquitetura
- **Severidade alta (🟠)**: REP (015), CCP (016), SDP (019) — requerem justificativa
- **Severidade média (🟡)**: CRP (017) — melhoria esperada

**Skills relacionadas:**
- [`solid`](../solid/SKILL.md) — depende: REP/CCP/CRP dependem de SRP e OCP
- [`object-calisthenics`](../object-calisthenics/SKILL.md) — complementa: OC complementa em nível de classe

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

### @architect: Detectar violação ADP (ciclo)
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

### @architect: Calcular métricas SDP/SAP
```bash
# módulo domain/
# Fan-in: 15 (15 módulos dependem dele)
# Fan-out: 3 (ele depende de 3 módulos)

I = 3 / (15 + 3) = 0.167  # Estável ✅
A = 8 / 12 = 0.667        # 67% abstrato ✅
D = |0.667 + 0.167 - 1| = 0.166  # Na Main Sequence ✅
```

---

**Criada em**: 2026-04-01
**Versão**: 1.0.0
