# oh my claude — Dependency Graph

Mapa de dependências entre rules, skills e agents.

---

## Camadas de Rules

```mermaid
graph TD
  subgraph OC["Object Calisthenics (001–009)"]
    r001["001 Indentação"]
    r002["002 No ELSE"]
    r003["003 Primitivos"]
    r004["004 Collections"]
    r005["005 1 chamada/linha"]
    r006["006 Sem abreviações"]
    r007["007 Max linhas"]
    r008["008 No get/set"]
    r009["009 Tell Don't Ask"]
  end

  subgraph SOLID["SOLID (010–014)"]
    r010["010 SRP"]
    r011["011 OCP"]
    r012["012 LSP"]
    r013["013 ISP"]
    r014["014 DIP"]
  end

  subgraph PP["Package Principles (015–020)"]
    r015["015 REP"]
    r016["016 CCP"]
    r017["017 CRP"]
    r018["018 ADP"]
    r019["019 SDP"]
    r020["020 SAP"]
  end

  subgraph CC["Clean Code (021–039)"]
    r022["022 KISS"]
    r021["021 DRY"]
    r024["024 No Magic"]
    r032["032 Coverage"]
    r033["033 Max Params"]
    r036["036 Side Effects"]
    r038["038 CQS"]
    r039["039 Boy Scout"]
  end

  subgraph TF["Twelve-Factor (040–051)"]
    r040["040 Codebase"]
    r041["041 Dependencies"]
    r042["042 Config"]
    r045["045 Stateless"]
    r050["050 Logs"]
  end

  subgraph AP["Anti-Patterns (052–070)"]
    r055["055 Long Method"]
    r060["060 Spaghetti"]
    r066["066 Pyramid"]
    r069["069 Premature Opt"]
    r070["070 Shared State"]
  end

  OC --> SOLID
  SOLID --> PP
  PP --> CC
  CC --> TF
  OC --> AP
  SOLID --> AP
  CC --> AP
```

---

## Skills → Rules

```mermaid
graph LR
  s_oc["skill: object-calisthenics"] --> r001 & r002 & r003 & r004 & r005 & r006 & r007 & r008 & r009
  s_solid["skill: solid"] --> r010 & r011 & r012 & r013 & r014
  s_pp["skill: package-principles"] --> r015 & r016 & r017 & r018 & r019 & r020
  s_cc["skill: clean-code"] --> r021 & r022 & r024 & r032 & r033 & r036 & r038 & r039
  s_tf["skill: twelve-factor"] --> r040 & r041 & r042 & r045 & r050
  s_ap["skill: anti-patterns"] --> r052 & r053 & r054 & r055 & r056 & r057 & r058 & r059 & r060 & r061 & r062 & r063 & r064 & r065 & r066 & r067 & r068 & r069 & r070
  s_cdd["skill: cdd"] --> r001 & r010 & r014 & r018 & r022 & r066
  s_comp["skill: complexity"] --> r001 & r022
  s_bigo["skill: big-o"] --> r001 & r007 & r022
```

---

## Skills → Skills

```mermaid
graph LR
  s_oc["object-calisthenics"] <--> s_solid["solid"]
  s_solid <--> s_pp["package-principles"]
  s_solid --> s_cc["clean-code"]
  s_oc --> s_cc
  s_cc --> s_ap["anti-patterns"]
  s_gof["gof"] <--> s_poeaa["poeaa"]
  s_gof --> s_solid
  s_poeaa --> s_solid
  s_cdd["cdd"] <--> s_comp["complexity"]
  s_cdd --> s_sq["software-quality"]
  s_sq <--> s_ct["codetags"]
  s_ap --> s_ct
  s_arc42["arc42"] --> s_adr["adr"]
  s_arc42 --> s_c4["c4model"]
  s_arc42 --> s_bdd["bdd"]
```

---

## Agents → Skills → Rules

```mermaid
graph TD
  leader["@leader"] --> s_cdd["skill: cdd"]

  architect["@architect"] --> s_gof["gof"] & s_poeaa["poeaa"] & s_solid["solid"] & s_pp["package-principles"]
  architect --> s_arc42["arc42"] & s_c4["c4model"] & s_adr["adr"] & s_bdd["bdd"]
  architect --> s_sq["software-quality"]

  developer["@developer"] --> s_oc["object-calisthenics"] & s_solid & s_pp
  developer --> s_cc["clean-code"] & s_tf["twelve-factor"] & s_ap["anti-patterns"]
  developer --> s_col["colocation"] & s_rev["revelation"]

  tester["@tester"] --> s_comp["complexity"] & s_sq & s_cc & s_col

  reviewer["@reviewer"] --> s_cdd & s_ap & s_sq & s_ct["codetags"]

  s_oc --> r001_009["Rules 001–009"]
  s_solid --> r010_014["Rules 010–014"]
  s_pp --> r015_020["Rules 015–020"]
  s_cc --> r021_039["Rules 021–039"]
  s_tf --> r040_051["Rules 040–051"]
  s_ap --> r052_070["Rules 052–070"]
```

---

## Legenda

| Símbolo | Significado |
|---------|-------------|
| `→` | usa / referencia |
| `↔` | bidirecional |
| `skill: X` | arquivo em `.claude/skills/X/SKILL.md` |
| `Rule NNN` | arquivo em `.claude/rules/NNN_*.md` |

---

**Atualizado em:** 2026-04-01
