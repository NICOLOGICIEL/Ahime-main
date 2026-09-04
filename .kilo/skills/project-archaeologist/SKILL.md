---
name: project-archaeologist
description: >-
  Analyse un projet existant (description, code source ou aperçu) pour en extraire
  l'essence, puis génère un prompt autonome permettant de concevoir un projet similaire.
  Produit un rapport d'analyse structuré et un prompt de reproduction détaillé avec
  variables de contexte, contraintes non-fonctionnelles et plan d'exécution.
metadata:
  category: development
  source:
    repository: 'https://github.com/Kilo-Org/kilocode'
    path: skills/project-archaeologist
    license_path: LICENSE
    commit: local
---

# Project Archaeologist

Analyse en profondeur un projet existant pour en extraire l'essence, puis génère un **prompt de reproduction autonome** permettant de construire un projet similaire à partir de zéro.

---

## Triggers

Use this skill when the user:
- "analyse ce projet et génère un prompt de reproduction"
- "je veux recréer un projet similaire à celui-ci"
- "génère un prompt autonome pour construire un projet comme celui-ci"
- "analyse l'architecture de ce projet et donne-moi le plan pour le recréer"
- "extrayez la philosophie de conception de ce projet"
- "crée un prompt de reproduction à partir de ce code"
- "je veux un prompt pour scaffold un projet identique"
- "analyse ce codebase et génère un prompt pour le recréer"

---

## Contexte

Le skill agit sur un projet source fourni sous forme de **description textuelle**, **code source**, ou **aperçu** (structure de dossiers, fichiers clés, architecture). Il prodigue une analyse systématique puis délivre un prompt prêt à l'emploi pour une autre session IA.

---

## Processus

### Phase 1 — Analyse du projet source

Explore le projet fourni en utilisant les outils disponibles (lecture de fichiers, grep, glob). Si le projet n'est pas entierement fourni, identifie ce qui manque et signale-le.

Collecte les éléments suivants :

1. **Architecture et Structure**
   - Arborescence des dossiers et fichiers
   - Pattern architectural (MVC, microservices, monolithe, event-driven, clean architecture, etc.)
   - Découpage des responsabilités
   - Niveau de modularité et couplage entre composants

2. **Stack Technique**
   - Langages de programmation et versions
   - Frameworks principaux et bibliothèques notable
   - Systèmes de base de données, gestion d'état, cache
   - Outils de build, test, linting, formatage
   - Infrastructure de déploiement et pipeline CI/CD

3. **Philosophie de Conception**
   - Principes directeurs (SOLID, KISS, DRY, YAGNI)
   - Paradigme de programmation dominant
   - Choix UI/UX, accessibilité, performance, sécurité, i18n
   - Conventions de nommage et de style

4. **Patterns Récurrents et Conventions Implicites**
   - Processus d'ajout d'une nouvelle fonctionnalité
   - Stratégie de gestion des erreurs et logging
   - Structure et typologie des tests
   - Idiome et habitudes spécifiques

---

### Phase 2 — Livrable 1 : Analyse structurée

Génère un rapport détaillé couvrant les quatre axes ci-dessus. Pour chaque axe, fournis :

- **Observations concrètes** extraites du code (avec références `chemin:fichier:ligne`)
- **Patterns identifiés** et leur justification
- **Écarts ou anomalies** notables (points de vigilance)

---

### Phase 3 — Livrable 2 : Prompt de reproduction autonome

Génère un prompt prêt à copier-coller, contenant impérativement :

1. **Définition du Projet** — description claire du type de projet, stack imposée, architecture et conventions extraites du Livrable 1.
2. **Variables de Contexte** — variables entre crochets (`[NOM_DU_PROJET]`, `[DOMAINE_METIER]`, `[PUBLIC_CIBLE]`, `[VOLUMÉTRIE_ATTENDUE]`, etc.) pour adapter le prompt.
3. **Contraintes Non-Fonctionnelles** — exigences strictes en performance, sécurité, scalabilité, accessibilité, observabilité.
4. **Plan d'Exécution Étape par Étape** — instructions détaillées du scaffolding (initialisation, configuration linters/tests) jusqu'à l'implémentation des modules clés, l'intégration, les tests et le déploiement.

---

### Phase 4 — Synthèse

Présente les deux livrables de manière claire, exhaustive et directement exploitable. Vérifie :

- [ ] Toutes les références de fichiers pointent vers des éléments existants
- [ ] Le prompt de reproduction contient toutes les variables de contexte nécessaires
- [ ] Les contraintes non-fonctionnelles reflètent fidèlement le projet source
- [ ] Le plan d'exécution est cohérent et ordonnancé

---

## Quick Reference

| Phase | Action | Output |
|-------|--------|--------|
| 1 | Explore le projet source | Observations brutes collectées |
| 2 | Analyse structurelle | Livrable 1 — Rapport d'analyse |
| 3 | Génère le prompt | Livrable 2 — Prompt de reproduction |
| 4 | Synthèse et vérif | Deux livrables finaux prêts à l'emploi |

---

## Anti-Patterns

| Avoid | Why | Instead |
|-------|-----|---------|
| Copier le code tel quel | Ne transmet pas la philosophie | Extraire les principes sous-jacents |
| Omettre les variables contextuelles | Prompt peu réutilisable | Inclure `[VARIABLE]` clairement nommées |
| Ignorer la gestion d'erreurs | Prompt incomplet | Documenter le pattern utilisé |
| Négliger les contraintes NFR | Reproduction médiocre | Inclure perf, sécurité, scalabilité, a11y |
