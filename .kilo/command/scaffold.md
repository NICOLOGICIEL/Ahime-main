---
description: Crée des dossiers et fichiers à partir d'une structure donnée
---

Génère la structure de dossiers et fichiers décrite dans les arguments `$ARGUMENTS`.

Si aucun argument n'est fourni, demande à l'utilisateur de décrire la structure souhaitée.

Pour chaque chemin identifié, applique ces règles :

- Chemin terminant par `/` → c'est un dossier, crée-le s'il n'existe pas.
- Chemin sans `/` final → c'est un fichier, crée les dossiers parents puis le fichier.
- Si un fichier existe déjà, ne l'écrase pas et signale-le.

Pour les fichiers Dart, génère un contenu minimal valide selon le nom :
- Nom contenant `_screen` → Widget Scaffold basique nommé d'après le fichier.
- Nom contenant `_service` → classe service vide nommée d'après le fichier.
- Nom contenant `_model` ou dans un dossier `models/` → classe modèle vide.
- Nom contenant `_widget` ou dans `widgets/` ou `components/` → StatelessWidget vide.
- Autres fichiers `.dart` → fichier Dart minimal avec un commentaire descriptif.

Pour les fichiers non-Dart, génère un contenu approprié au type ou laisse vide.

Une fois terminé, affiche la liste complète des fichiers et dossiers créés avec leurs chemins relatifs depuis la racine du projet.
