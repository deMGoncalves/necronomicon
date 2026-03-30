---
name: c4model
description: Template C4 Model com 4 níveis de abstração para visualização arquitetural (Context, Container, Component, Code). Use quando @architect precisa criar ou atualizar docs/c4/ para comunicar arquitetura a diferentes audiências.
model: haiku
allowed-tools: Read, Write, Edit
user-invocable: true
location: managed
metadata:
  version: "1.0.0"
  category: documentation
---

# C4 Model

4 níveis de abstração progressiva para comunicar arquitetura a diferentes audiências.

---

## Quando Usar

- **Fase 4 (Docs):** @architect cria/atualiza docs/c4/ após implementação
- **Level 1-2:** para stakeholders (negócio, gestão)
- **Level 3-4:** para desenvolvedores (implementação)

## Os 4 Níveis

| Level | Arquivo | Audiência | Pergunta-chave |
|-------|---------|-----------|----------------|
| 1 — System Context | 01_system_context.md | Todos | O que o sistema faz e com quem se conecta? |
| 2 — Container | 02_container.md | Técnico | Qual tecnologia compõe cada parte? |
| 3 — Component | 03_component.md | Dev | Como este serviço é organizado internamente? |
| 4 — Code | 04_code.md | Dev | Como este componente é implementado? |

## Templates

Consulte os templates em references/:
- [references/01_system-context.md](references/01_system-context.md) → template Level 1
- [references/02_container.md](references/02_container.md) → template Level 2
- [references/03_component.md](references/03_component.md) → template Level 3
- [references/04_code.md](references/04_code.md) → template Level 4

## Convenções

- Nomenclatura consistente entre níveis (mesmo nome de sistema/container/componente)
- Level 1-2: linguagem simples, sem jargão técnico
- Level 3-4: tipos, interfaces, padrões específicos
- Idioma: português brasileiro
- Relacionada com: arc42 §5 (Building Block View)

## Fundamentação

- c4model.com: criado por Simon Brown
- Complementa arc42 com visualizações por nível de abstração
