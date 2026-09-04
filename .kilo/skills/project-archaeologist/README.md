# Project Archaeologist

A skill that deeply analyzes an existing project (from its description, source code, or overview) to extract its essence, then generates an **autonomous reproduction prompt** that can be used to build a similar project from scratch.

## Purpose

When migrating, rewriting, or templating a project, it's crucial to understand not just *what* the project contains, but *why* it was built that way. This skill performs a structured archaeological dig of a codebase — extracting architectural patterns, technical stack, design philosophy, and recurring conventions — and synthesizes them into a ready-to-use prompt for reproducing the project's DNA in a new context.

## When to Use

Common trigger phrases:

- "analyse ce projet et génère un prompt de reproduction"
- "je veux recréer un projet similaire à celui-ci"
- "génère un prompt autonome pour construire un projet comme celui-ci"
- "analyse l'architecture de ce projet et donne-moi le plan pour le recréer"
- "cré un prompt de reproduction à partir de ce code"

## How It Works

### Phase 1: Source Analysis

The skill explores the provided project using file reading, grep, and glob tools. It collects observations across four dimensions:

1. **Architecture & Structure** — folder layout, architectural pattern (MVC, clean architecture, microservices, etc.), responsibility separation, modularity and coupling.
2. **Technical Stack** — languages, frameworks, databases, state management, build/test/lint tools, CI/CD pipeline.
3. **Design Philosophy** — guiding principles (SOLID, KISS, DRY, YAGNI), programming paradigm, UI/UX/accessibility/security/i18n choices, naming conventions.
4. **Recurring Patterns & Conventions** — feature addition workflow, error handling & logging strategy, test structure, idiomatic habits.

### Phase 2: Livrable 1 — Structured Analysis

A comprehensive report covering all four axes, with concrete code references (`path:file:line`), identified patterns, and anomaly notes.

### Phase 3: Livrable 2 — Autonomous Reproduction Prompt

A copy-paste-ready prompt containing:

1. **Project Definition** — type, stack, architecture, and conventions extracted from the analysis.
2. **Context Variables** — bracketed placeholders (`[NOM_DU_PROJET]`, `[DOMAINE_METIER]`, `[PUBLIC_CIBLE]`, `[VOLUMÉTRIE_ATTENDUE]`) for adaptability.
3. **Non-Functional Constraints** — strict requirements for performance, security, scalability, accessibility, and observability.
4. **Step-by-Step Execution Plan** — from project initialization and linting/test setup through key module implementation, integration, testing, and deployment.

## Output

After running, you get two deliverables:

**Livrable 1 — Analysis Report:**
```markdown
# Analyse Structurée du Projet Source

## 1. Architecture et Structure
... (folder layout, patterns, modularity analysis)

## 2. Stack Technique
... (languages, frameworks, tools, CI/CD)

## 3. Philosophie de Conception
... (principles, paradigms, conventions)

## 4. Patterns Récurrents et Conventions Implicites
... (feature workflow, testing, error handling)
```

**Livrable 2 — Autonomous Reproduction Prompt:**
```markdown
Tu es un ingénieur logiciel expert. Crée un projet conforme aux spécifications suivantes.

[DOMAINE_METIER]...
[NOM_DU_PROJET]...
[PUBLIC_CIBLE]...

## Définition du Projet
...

## Variables de Contexte
- [NOM_DU_PROJET]: ...
- [DOMAINE_METIER]: ...

## Contraintes Non-Fonctionnelles
...

## Plan d'Exécution
1. Initialisation du projet
2. Configuration des outils
...
```

## Best Practices

### Before Starting
- Ensure the project source is fully accessible
- Note any incomplete or inaccessible areas

### During Analysis
- Cross-reference multiple files to identify patterns
- Distinguish between conventions and coincidences
- Document everything with concrete file references

### After Generation
- Verify all file references are valid
- Confirm the reproduction prompt contains all necessary context variables
- Ensure non-functional constraints match the source project

## Anti-Patterns

| Avoid | Why | Instead |
|-------|-----|---------|
| Copying code verbatim | Doesn't transmit the philosophy | Extract underlying principles |
| Omitting context variables | Prompt is not reusable | Include clearly named `[VARIABLE]` placeholders |
| Ignoring error handling | Incomplete prompt | Document the error strategy used |
| Neglecting NFR constraints | Poor reproduction quality | Include performance, security, scalability, a11y |

## License

MIT
