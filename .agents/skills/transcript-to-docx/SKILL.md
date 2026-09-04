---
name: transcript-to-docx
description: Transforme un long transcript technique (conversation, échange Q&A, export de chat, historique de recherche, fil de discussion) en un document Word (.docx) complet, structuré et présentable, qui reprend l'INTÉGRALITÉ du contenu plutôt qu'un résumé. Utilise ce skill dès que l'utilisateur colle/upload un long échange (souvent un copier-coller de conversation avec IA, un export de chat, une FAQ, un fil de support) et demande de le mettre "dans un document", "en PDF/Word", de le rendre "présentable", "propre", "lisible", ou de "tout regrouper" — même s'il ne précise pas explicitement le format de sortie. Déclenche aussi sur "reprends tout", "je veux plus d'information", "comme dans le fichier de base", ou toute demande de fidélité/exhaustivité par rapport à un contenu source déjà fourni.
---

# Transcript technique → document Word complet

## Objectif

Produire un document Word qui est une **mise en forme fidèle et exhaustive** d'un contenu source (transcript, conversation, export), pas un résumé exécutif. Le lecteur doit pouvoir retrouver dans le document tout ce qui était dans la source — explications, code, fichiers de config, schémas, tableaux — simplement mieux organisé et mis en forme.

C'est la différence essentielle avec une synthèse classique : ici, la valeur ajoutée est la **structure et la présentation**, pas la compression de l'information.

## Quand ce skill s'applique

- L'utilisateur colle ou upload un long échange technique (souvent un copier-coller de recherche/chat IA, un ticket de support, une FAQ, un historique de discussion Slack/email).
- Il demande de le transformer en fichier présentable, sans forcément nommer le format (« fais-moi un document bien présentable », « mets tout ça dans un PDF », « regroupe cette conversation »).
- Il redemande plus de détail après un premier essai trop condensé (« je veux plus d'information », « comme dans le fichier de base », « ne résume pas », « garde tout »).

Ne s'applique **pas** quand l'utilisateur demande explicitement un résumé, une synthèse courte, ou un rapport exécutif — dans ce cas, produire un résumé classique, pas ce skill.

## Étapes

### 1. Lire et cartographier le contenu source

Avant d'écrire une ligne de docx, lis l'intégralité du transcript et repère :
- Les **thèmes/questions successifs** — chacun devient typiquement une section numérotée.
- Les **blocs de code, commandes, fichiers de configuration** (YAML, .env, nginx.conf, JSON…) — à préserver dans leur intégralité, jamais tronqués ni résumés en pseudo-code.
- Les **schémas ASCII / diagrammes de flux** — à conserver tels quels dans des blocs monospace.
- Les **tableaux ou comparatifs** — à convertir en vrais tableaux Word, pas en texte aligné avec des espaces.
- Les **passages redondants mais non identiques** (ex. la même configuration déclinée pour plusieurs technologies) — les garder toutes : elles diffèrent dans le détail et perdre l'une d'elles est une perte d'information, pas une simplification légitime.

Construis un plan de sections à partir de cette lecture — en général un sommaire calqué sur l'enchaînement des questions/réponses de la source, plus une section de synthèse finale si le contenu s'y prête.

### 2. Vérifier le skill docx

Avant de générer le fichier, charge `/mnt/skills/public/docx/SKILL.md` (gotchas docx-js : tables avec `columnWidths` + `width` par cellule, `ShadingType.CLEAR` jamais `SOLID`, listes via `numbering`, pas de `\n` littéral, etc.). Ce skill est un prérequis, pas une alternative.

### 3. Construire le document

Structure standard à suivre :
- **Page de titre** : titre principal, sous-titre, mention "Note technique de synthèse" ou équivalent, saut de page.
- **Sommaire** : liste des sections numérotées.
- **Sections numérotées (1, 2, 3…)**, chacune avec des sous-sections (1.1, 1.2…) reprenant fidèlement les explications de la source — en prose complète, pas juste des puces télégraphiques, sauf quand la source elle-même est une liste.
- **Blocs de code** : dans des tableaux à une cellule avec fond gris clair et police monospace (voir gabarit ci-dessous), avec une légende en italique juste avant (`Installation :`, `Configuration .env :`, `Route GET avec stratégie de cache :`…).
- **Tableaux comparatifs** : vrais tableaux Word avec en-tête coloré.
- **Encadrés "À retenir"** : pour les 2-3 points clés vraiment cruciaux, pas plus — un encadré par section maximum, sinon ça perd son effet.
- **Saut de page avant chaque section majeure** (`new Paragraph({ children: [new PageBreak()] })`), pas avant les sous-sections.

Utilise une charte simple et cohérente : une seule couleur d'accent pour les titres/en-têtes de tableau, du gris neutre pour le texte secondaire, une police sans-serif pour le corps (Calibri) et une police monospace pour le code (Consolas).

Un gabarit JS complet (helpers `h1`, `h2`, `h3`, `p`, `bullet`, `codeBlock`, `codeLabel`, `calloutTip`, `comparisonTable`) est disponible dans `references/docx-template.js` — pars de ce fichier plutôt que de tout réécrire from scratch.

### 4. Vérifier avant de livrer

Comme demandé par le skill docx : convertis en PDF (`soffice.py --convert-to pdf`) puis rends quelques pages en image (`pdftoppm`) pour repérer un débordement de code, une mise en page cassée, ou un tableau mal dimensionné. Corrige avant de livrer.

### 5. Livrer

Copie le fichier dans `/mnt/user-data/outputs/` et appelle `present_files`. Pas de long message d'accompagnement après — un résumé bref de ce que couvre le document suffit.

## Points de vigilance (retours d'expérience)

- **Ne pas condenser par réflexe.** Le premier réflexe naturel est de résumer un long transcript. Ici c'est un anti-pattern : si l'utilisateur voulait un résumé, il l'aurait demandé. Reproduire fidèlement est le service rendu.
- **Ne jamais tronquer un extrait de code** avec des commentaires du type `// ...` ou `# reste du code` si la source donnait le code complet — recopie-le entièrement.
- **Garder les variantes techniques séparées** (ex. la même route déclinée en Node.js, PHP, Python) plutôt que de les fusionner en un seul exemple "générique" : c'est souvent tout l'intérêt du document pour l'utilisateur.
- **Un tableau comparatif ne remplace pas les explications qui l'accompagnaient** dans la source — garde les deux.
- Si l'utilisateur redemande "plus de détail" après un premier essai, ne réponds pas par un simple ajout en fin de document : reprends chaque section et développe-la au niveau de détail de la source, comme un enrichissement en profondeur.
