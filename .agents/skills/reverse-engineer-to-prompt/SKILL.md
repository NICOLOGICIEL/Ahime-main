---
name: reverse-engineer-to-prompt
description: Analyse en profondeur un projet de code (dossier uploadé, dépôt, ou fichiers collés) comme le ferait un architecte logiciel senior, puis génère un prompt de réplication complet et autonome permettant à une IA de recréer un projet similaire à partir de zéro. Utilise ce skill dès que l'utilisateur demande de "rétro-ingénierier", "analyser l'architecture de", "documenter la stack de", "extraire les patterns de" un projet existant, ou de générer un prompt/cahier des charges pour recréer, cloner ou s'inspirer d'un projet — même s'il ne précise pas explicitement vouloir un "prompt" en sortie (ex. "explique-moi comment ce projet est construit pour que je puisse en refaire un similaire").
---

# Rétro-ingénierie de projet → prompt de réplication

## Objectif

Prendre un projet de code existant et produire deux livrables complémentaires :
1. Un **rapport d'analyse structuré** — la radiographie du projet : architecture, stack, philosophie de conception, conventions, éléments réutilisables.
2. Un **prompt de réplication** — un document autonome, directement utilisable par une IA (dans une nouvelle conversation, sans accès au projet original) pour recréer un projet du même esprit.

La valeur du skill n'est pas de résumer le code ligne par ligne, mais d'en extraire les **décisions et patterns durables** — ce qui resterait vrai même si tous les fichiers changeaient de nom : pourquoi le projet est structuré ainsi, quels principes il applique, ce qui serait pénible à redécouvrir en partant de zéro.

## Étape 0 : localiser le projet à analyser

Avant toute chose, assure-toi d'avoir un accès réel au code — pas seulement à sa description :
- Fichiers déjà uploadés (`/mnt/user-data/uploads/`) → les lire directement.
- Dépôt Git accessible en local ou via une URL → cloner ou parcourir.
- Si rien de concret n'est fourni, demande le chemin du dossier, une archive, ou l'URL du dépôt avant de te lancer dans une analyse générique — un rapport basé sur des suppositions est pire qu'inutile ici, il produirait un prompt de réplication trompeur.

## Étape 1 : analyse approfondie du projet

Explore le projet méthodiquement (arborescence d'abord, puis fichiers clés — `package.json`/`requirements.txt`/`composer.json`, fichiers de config, points d'entrée, un échantillon représentatif de chaque couche) et documente ce que tu observes selon ces cinq axes. Ne te contente pas de lister des technologies : pour chaque point, cherche la *raison* derrière le choix quand elle est déductible du code (un fichier `docker-compose.yml` avec un service Redis à côté d'une queue suggère un choix de cache/jobs asynchrones, pas juste "utilise Redis").

### 1. Structure du projet
- Architecture générale (monolithe, microservices, serverless, monorepo…) et ce qui le révèle concrètement dans le code.
- Arborescence des dossiers et conventions de nommage — assez précis pour qu'on puisse la reconstituer sans la revoir.
- Séparation des responsabilités : comment le code est découpé (couches, modules, domaines) et selon quel critère.
- Points d'entrée : fichiers principaux, routes, controllers.
- Configuration : fichiers de config, variables d'environnement (lister les noms de variables sans jamais recopier de valeurs sensibles trouvées dans un `.env`).

### 2. Stack technologique
- Langages, avec versions exactes trouvées dans les fichiers de manifeste (`package.json`, `pyproject.toml`, `go.mod`…), pas des suppositions.
- Frameworks (frontend, backend, testing).
- Base de données : type, ORM/ODM, stratégie de migrations.
- Outils de build (bundlers, task runners).
- Dépendances clés et leur rôle réel dans le projet — pas la description marketing de la librairie.
- Infrastructure : Docker, CI/CD, indices d'hébergement.

### 3. Philosophie de conception
- Patterns architecturaux identifiables (MVC, MVVM, Clean Architecture, DDD…) — avec un exemple concret de fichier qui l'illustre.
- Design patterns repérés (Factory, Singleton, Observer…) et où ils apparaissent.
- Principes appliqués (SOLID, DRY, KISS, YAGNI) — juge sur des indices réels (interfaces, injection de dépendances, duplication ou absence de duplication), pas par principe.
- Gestion des erreurs : stratégie, logging, monitoring.
- Sécurité : authentification, autorisation, validation des entrées.
- Performance : caching, optimisations, lazy loading.
- Tests : stratégie, ce qui est couvert, types de tests présents.

### 4. Conventions et bonnes pratiques
- Style de code : formatting, linting, conventions de nommage (fichiers de config `.eslintrc`, `.prettierrc`, `pyproject.toml [tool.ruff]`…).
- Documentation : JSDoc/TSDoc, présence et qualité du README, densité des commentaires.
- Git workflow : ce que l'historique ou les fichiers `.github/` révèlent (branches, conventions de commit, templates de PR).
- Conventions d'API : REST/GraphQL, nommage des routes/endpoints.

### 5. Éléments réutilisables
- Composants génériques (UI components, utils, helpers) qui auraient de la valeur dans un autre projet.
- Services abstraits ou réutilisables dans d'autres contextes.
- Patterns de configuration récurrents.

Livre ce rapport structuré (les 5 sections ci-dessus, en Markdown, avec des exemples de chemins de fichiers à l'appui de chaque affirmation importante) avant de passer à l'étape 2 — c'est la matière première du prompt de réplication, et l'utilisateur doit pouvoir la corriger si elle contient une erreur d'interprétation avant qu'elle ne se propage dans le prompt final.

## Étape 2 : génération du prompt de réplication

À partir du rapport de l'étape 1, rédige un prompt complet, autonome et directement utilisable — quelqu'un doit pouvoir le coller dans une conversation vierge avec une IA et obtenir un projet du même esprit, sans avoir besoin de rouvrir le projet original. Structure-le ainsi :

```markdown
# Contexte et objectif
Description du projet à construire : à quoi il sert, pour qui, à quel niveau de maturité
(prototype, MVP, production-ready).

# Stack technique imposée
Langages et versions exactes, frameworks, base de données + ORM, outils de build,
dépendances clés avec leur rôle. Assez précis pour qu'un `npm install`/`pip install`
reproduise un environnement équivalent.

# Architecture et structure de dossiers
Le pattern architectural à suivre, et une arborescence de dossiers cible commentée
(à quoi sert chaque dossier, quoi y mettre).

# Conventions de code
Style, nommage, formatting/linting à appliquer ; conventions d'API ; format de
documentation attendu (JSDoc, docstrings…).

# Principes et patterns de conception à respecter
Design patterns à utiliser et où ; principes (SOLID, DRY…) à appliquer explicitement ;
stratégie de gestion d'erreurs et de logging ; approche sécurité (auth, validation) ;
approche performance (caching, lazy loading) si pertinent.

# Fonctionnalités clés à implémenter
Liste priorisée des fonctionnalités observées dans le projet original, décrites en
termes de comportement (pas de code), dans un ordre de construction logique.

# Composants et services réutilisables à prévoir
Les éléments génériques identifiés à l'étape 1, à recréer comme briques indépendantes
dès le départ plutôt qu'en dur dans les fonctionnalités.

# Exigences non fonctionnelles
Tests (stratégie et couverture visée), CI/CD, containerisation si le projet original
en avait, exigences de performance ou de sécurité spécifiques observées.

# Livrables attendus
Ce que l'IA qui recevra ce prompt doit produire concrètement (code source organisé
selon l'arborescence ci-dessus, README, tests, config Docker…) et les critères qui
permettent de juger que la réplication est réussie.
```

Adapte les sections à ce qui a réellement été trouvé — ne remplis jamais une section par du générique quand l'étape 1 n'a rien révélé sur ce point ; il vaut mieux l'omettre ou noter "non déterminé" que d'halluciner une convention. Le prompt final doit se suffire à lui-même : quelqu'un qui ne connaît pas le projet original doit pouvoir le lire et comprendre exactement quoi construire.

## Format de sortie

Sauf demande contraire, livre les deux documents en Markdown, directement dans la conversation si le rapport est raisonnablement court, ou comme fichiers `.md` (voir skill `docx`/`md` si l'utilisateur veut un fichier téléchargeable) quand le projet est volumineux et que le rapport dépasse ce qui est confortable à lire en ligne. Nomme-les clairement, par exemple `analyse-<nom-projet>.md` et `prompt-replication-<nom-projet>.md`.

## Points de vigilance

- **Ne pas halluciner de versions ou de dépendances.** Toujours sourcer les versions dans les fichiers de manifeste réels du projet, jamais depuis la mémoire générale de frameworks similaires.
- **Distinguer ce qui est observé de ce qui est déduit.** Un pattern clairement présent dans le code ("le projet utilise un Repository pattern, voir `src/repositories/UserRepository.ts`") se formule différemment d'une supposition ("l'absence de tests suggère un stade précoce du projet").
- **Le prompt de réplication n'est pas un résumé du rapport d'analyse.** Le rapport décrit *ce qui existe* ; le prompt décrit *ce qu'il faut construire*, à l'impératif, dans un ordre actionnable — c'est une reformulation orientée vers l'avenir, pas une simple compression.
- **Ne jamais recopier de secrets.** Noms de variables d'environnement oui, valeurs de clés API, mots de passe ou tokens trouvés dans des fichiers de config jamais — ni dans le rapport, ni dans le prompt.
- **Un projet volumineux ne s'analyse pas fichier par fichier.** Échantillonne intelligemment : un exemple représentatif par couche/module suffit généralement à établir un pattern ; vérifie-le sur 2-3 autres fichiers similaires plutôt que de tout lire.
