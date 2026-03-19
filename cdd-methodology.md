# CDD Methodology (Cognitive-Driven Development)

## Overview

CDD (Cognitive-Driven Development) is a development and code review methodology focused on the **cognitive load** that code imposes on developers who need to read, understand, and modify it.

## Fundamental Principles

### 1. Cognitive Complexity > Cyclomatic Complexity

While Cyclomatic Complexity (CC) measures the number of execution paths, **Cognitive Complexity** measures the mental effort required to understand the code.

**Example:**

```javascript
// CC = 4, but low cognitive complexity
function validateUser(user) {
  if (!user) return false;
  if (!user.email) return false;
  if (!user.name) return false;
  return true;
}

// CC = 4, but HIGH cognitive complexity
function processData(data) {
  if (data) {
    if (data.items) {
      for (let item of data.items) {
        if (item.active) {
          // nested processing
        }
      }
    }
  }
}
```

### 2. ICP (Intrinsic Complexity Points)

ICP is a composite metric that considers:

- **Cyclomatic Complexity** (execution paths)
- **Nesting Depth** (indentation levels)
- **Number of Responsibilities** (SRP violation)
- **Coupling** (dependencies)

See `icp-calculation.md` for calculation details.

### 3. The "Reading is More Important than Writing" Rule

Code is read **10x more times** than it is written. CDD prioritizes:

- **Readability** > Conciseness
- **Clarity** > Cleverness
- **Explicit** > Implicit

## CDD Analysis Layers

### Layer 1: ICP Analysis

Quantifies the code's cognitive complexity through ICP.

**Goal:** ICP ≤ 5 for most methods

### Layer 2: Rules Validation

Verifies compliance with architectural and design rules:

- **Structural**: Layout, organization, naming
- **Behavioral**: SOLID principles, design patterns
- **Creational**: Encapsulation, immutability
- **Infrastructure**: 12 Factor App, deployment

### Layer 3: Pattern Identification

Identifies opportunities to apply known patterns:

- **GoF Patterns**: Solutions to common design problems
- **PoEAA Patterns**: Enterprise architectural patterns

## Application in Code Review

### Step 1: Quick Scan (2-5 minutes)

- Identify files with ICP > 5
- Identify obvious rule violations (names, structure)
- Identify known anti-patterns

### Step 2: Deep Analysis (10-20 minutes)

- Calculate detailed ICP for critical files
- Verify compliance with relevant rules
- Identify refactoring opportunities

### Step 3: Contextual Calibration (5 minutes)

- Consider PR type (fix, feature, refactor)
- Consider business context (urgency, technical debt)
- Calibrate severity based on real impact

## Success Metrics

### For the Code

- **Average ICP** of the project ≤ 4
- **0% of methods** with ICP > 10
- **≥ 80% compliance** with critical rules

### For the Team

- **Bug reduction** in code with low ICP
- **Increased velocity** in modifications
- **Technical debt reduction** over time

## Anti-Patterns to Avoid

### 1. Paralyzing Perfectionism

❌ Block PRs for minor violations of non-critical rules
✅ Focus on violations that impact maintainability and bugs

### 2. Rule Rigidity

❌ Apply rules rigidly without considering context
✅ Calibrate severity based on PR type and urgency

### 3. Superficial Analysis

❌ Review only code style and formatting
✅ Analyze cognitive complexity and design

### 4. Lack of Pragmatism

❌ Demand perfect code that is never delivered
✅ Accept "good enough" that delivers value

## References

- **Rules** (51 architectural rules):
  - `references/object-calisthenics/` - 9 Object Calisthenics rules
  - `references/solid/` - 5 SOLID principles
  - `references/package-principles/` - 6 Package principles
  - `references/clean-code/` - 19 Clean Code rules
  - `references/twelve-factor/` - 12 Twelve-Factor App rules

- **Patterns** (66 design patterns):
  - `references/gof/` - 23 GoF patterns (creational, structural, behavioral)
  - `references/poeaa/` - 43 PoEAA patterns (domain-logic, data-source, object-relational, web-presentation, offline-concurrency, session-state, base)

- **ICP Calculation**: `references/icp-calculation.md`

## Version

CDD Methodology v1.0 - March 2026
