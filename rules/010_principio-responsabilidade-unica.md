# Application of the Single Responsibility Principle (SRP)

**ID**: COMPORTAMENTAL-010
**Severity**: 🔴 Critical
**Category**: Behavioral

---

## What It Is

Requires that a class or module have only one reason to change, which implies it should have a single responsibility.

## Why It Matters

SRP violation causes **low cohesion** and **high coupling**, making classes fragile and difficult to test. It increases maintenance cost, as a change in one business area can break another.

## Objective Criteria

- [ ] A class should not contain business logic and persistence logic together (e.g., *Service* and *Repository* together).
- [ ] The number of public methods of a class should not exceed **7**.
- [ ] The **Lack of Cohesion in Methods (LCOM)** should be less than 0.75.

## Permitted Exceptions

- **Utility/Helper Classes**: Static classes that group pure stateless functions for generic data manipulation (e.g., date formatters).

## How to Detect

### Manual

Ask: "If there is a change in requirement X and in requirement Y, does this class need to be changed in both situations?" (SRP violated if the answer is yes).

### Automatic

SonarQube: High `Cognitive Complexity` and high `LCOM (Lack of Cohesion in Methods)`.

## Related To

- [007 - Maximum Lines per Class Limit](007_limite-maximo-linhas-classe.md): reinforces
- [004 - First Class Collections](004_colecoes-primeira-classe.md): reinforces
- [011 - Open/Closed Principle](011_principio-aberto-fechado.md): complements
- [025 - Prohibition of The Blob Anti-Pattern](025_proibicao-anti-pattern-the-blob.md): complements
- [021 - Prohibition of Logic Duplication](021_proibicao-duplicacao-logica.md): reinforces
- [022 - Prioritization of Simplicity and Clarity](022_priorizacao-simplicidade-clareza.md): reinforces
- [015 - Release Reuse Equivalency Principle](015_principio-equivalencia-lancamento-reuso.md): reinforces
- [016 - Common Closure Principle](016_principio-fechamento-comum.md): reinforces
- [032 - Minimum Test Coverage](032_cobertura-teste-minima-qualidade.md): reinforces
- [033 - Parameter Limit per Function](033_limite-parametros-funcao.md): reinforces
- [034 - Consistent Class and Method Names](034_nomes-classes-metodos-consistentes.md): reinforces
- [037 - Prohibition of Flag Arguments](037_proibicao-argumentos-sinalizadores.md): reinforces
- [038 - Command-Query Separation Principle](038_conformidade-principio-inversao-consulta.md): reinforces
- [001 - Single Level of Indentation](001_nivel-unico-indentacao.md): complements
- [047 - Concurrency via Processes](047_concorrencia-via-processos.md): complements
- [054 - Prohibition of Divergent Change](054_proibicao-mudanca-divergente.md): reinforces
- [058 - Prohibition of Shotgun Surgery](058_proibicao-shotgun-surgery.md): reinforces

---

**Created on**: 2025-10-04
**Version**: 1.0
