# Rapport du Projet Ahime

---

## 1. Informations Générales

| Élément | Détail | |---|---| | __Nom__ | `ahime` | | __Version__ | 1.0.0+1 | | __Description__ | Projet Ahime — Application mobile Flutter multi-services | | __SDK Dart__ | `>=3.4.3 <4.0.0` | | __Plateformes cibles__ | Android, iOS, Web, Windows, Linux, macOS | | __Dépôt Git__ | [](https://github.com/NICOLOGICIEL/Ahime-main.git)<https://github.com/NICOLOGICIEL/Ahime-main.git> | | __Copyright__ | © 2023 Gek Expertise | | __API Backend__ | `https://ahime-ci.com/casa2babyAPI` |

---

## 2. Structure du Projet

```javascript
lib/
├── main.dart                          # Point d'entrée de l'app
├── config/
│   ├── my_config.dart                 # Config centrale (couleurs, API, utilitaires, widgets)
│   ├── getx/
│   │   ├── updateimg.dart             # Contrôleur GetX pour images
│   │   ├── updaterusulttext.dart      # Contrôleur GetX pour résultats/recherche
│   │   └── updatescreen.dart          # Contrôleur GetX pour mise à jour écran
│   └── utils/
│       ├── dropdownlist.dart          # Widget dropdown réutilisable
│       ├── my_navbar.dart             # Barre de navigation réutilisable
│       ├── my_titlerusult.dart        # Titre de résultats
│       ├── my_titlesub.dart           # Sous-titre
│       ├── resizable.dart             # Configuration responsive (SizeConfig)
│       └── slide_img.dart             # Widget slider d'images
├── pages/
│   ├── page_accueil.dart              # Page d'accueil principale
│   ├── hotel/
│   │   ├── page_hotel.dart            # Liste des hôtels/résidences
│   │   ├── page_hoteldetail.dart      # Détail d'un hôtel
│   │   ├── page_hotelimgdetail.dart   # Galerie images hôtel
│   │   ├── page_hotelimgfull.dart     # Image plein écran
│   │   ├── page_hotelrecherche.dart   # Recherche filtrée hôtels
│   │   ├── page_hotelresult.dart      # Résultats recherche hôtels
│   │   ├── page_h.dart               # Page auxiliaire hôtel
│   │   └── my_form.dart              # Formulaire hôtel
│   ├── artisan/
│   │   ├── page_artisan.dart          # Liste des catégories d'artisans
│   │   ├── page_artisanresult.dart    # Résultats recherche artisans
│   │   ├── page_artisantrecherche.dart # Recherche filtrée artisans
│   │   ├── page_artisancommentaire.dart # Commentaires artisans
│   │   └── page_artisanimgdetail.dart # Galerie images artisan
│   └── transport/
│       ├── page_transport.dart        # Recherche transport (ligne/compagnie)
│       ├── page_tranportresult.dart   # Résultats recherche transport
│       └── page_transporthoraire.dart # Horaires de départ
```

---

## 3. Architecture & Patterns

| Aspect | Choix technique | |---|---| | __State Management__ | __GetX__ (`get: ^4.6.6`) — contrôleurs réactifs (`Obx`, `Get.put`) | | __HTTP Client__ | Double client : __Dio__ (`^5.7.0`) + __http__ (`^1.2.2`) | | __Navigation__ | Navigation classique Flutter (`Navigator.push/pop`) avec helpers `pushPage`/`popPage` | | __Responsive__ | `responsive_sizer` (`^3.3.1`) via `SizeConfig` (pourcentages écran) | | __Backend__ | API REST sur `ahime-ci.com/casa2babyAPI` — requêtes SQL construites côté client | | __Splash Screen__ | `flutter_native_splash` (`^2.4.3`) — fond vert `#02893c` | | __WebView__ | `flutter_inappwebview` (mobile natif) + `webview_flutter` (web) |

---

## 4. Modules Fonctionnels

### 🏨 Module Hôtel (8 fichiers)

- Liste hôtels et résidences meublées
- Recherche par mot-clé, localisation, commodités (Wi-Fi, piscine, spa, bar, climatisation, ventilateur)
- Filtrage par étoiles, prix, type (hôtel vs résidence)
- Détail avec galerie d'images
- Résultats paginés (`LIMIT` SQL)

### 🔨 Module Artisan (5 fichiers)

- 7 catégories : Environnement, Automobile, Technologie, Bâtiment, Sécurité, Transport, Autres
- Recherche par métier, catégorie, ville, commune, quartier, note étoiles
- Système de commentaires
- Scroll d'avertissement (texte défilant sur la confiance)

### 🚌 Module Transport (3 fichiers)

- Recherche par ligne (ville de départ → ville d'arrivée)
- Recherche par compagnie
- Affichage des horaires et escales
- Onglets Ligne / Compagnie via `TabBar`

---

## 5. Dépendances (22 packages)

| Package | Version | Rôle | |---|---|---| | `flutter` | SDK | Framework | | `cupertino_icons` | ^1.0.6 | Icônes iOS | | `google_fonts` | ^6.2.1 | Polices Google | | `responsive_sizer` | ^3.3.1 | Responsive design | | `text_scroll` | ^0.2.0 | Texte défilant | | `animated_custom_dropdown` | ^3.1.1 | Dropdown animé | | `flutter_rating` | ^2.0.2 | Étoiles de notation | | `scrollable_text_indicator` | ^0.0.2 | Indicateur texte | | `readmore` | ^3.0.0 | Texte "lire la suite" | | `http` | ^1.2.2 | Client HTTP | | `dio` | ^5.7.0 | Client HTTP avancé | | `get` | ^4.6.6 | State management | | `url_launcher` | ^6.3.1 | Lancement d'URLs/appels/SMS | | `flutter_spinkit` | ^5.2.1 | Indicateurs de chargement | | `platform_detector` | ^0.2.0 | Détection de plateforme | | `flutter_inappwebview` | ^6.1.5 | WebView in-app | | `webview_flutter` | ^4.10.0 | WebView Flutter | | `flutter_masked_text2` | ^0.9.1 | Texte masqué (téléphone) | | `geolocator` | ^13.0.2 | Géolocalisation GPS | | `latlong2` | ^0.9.1 | Coordonnées GPS | | `motion_toast` | ^2.11.0 | Toasts animés | | `timeline_tile_plus` | ^0.0.3 | Timeline UI | | `flutter_native_splash` | ^2.4.3 | Splash screen natif | | `double_back_to_close_app` | ^2.1.0 | Double retour pour quitter |

---

## 6. Design & Identité Visuelle

| Élément | Valeur | |---|---| | __Couleur principale__ | Bleu `#023a6b` | | __Couleur secondaire__ | Bleu clair `#0050a0` | | __Couleur accent__ | Vert `#02893c` | | __Couleur fond__ | Blanc cassé `#F6F7F9` | | __Couleur alerte__ | Rouge `#cb182b` | | __Fonts personnalisées__ | `Noteworthy-Lt`, `palr45w` | | __Assets images__ | __76 fichiers__ dans `assets/image/` | | __Style UI__ | Cards arrondies, boutons `StadiumBorder`, navigation bleu/vert |

---

## 7. API & Backend

- __Base URL__ : `https://ahime-ci.com/casa2babyAPI`
- __Endpoints__ : `/api/action` (requêtes), `/api` (initialisation)
- __Méthode__ : Les requêtes SQL sont __construites côté client__ et envoyées via POST au serveur (pattern `data_action` + `Requete`)
- __Fonctions API__ : `getData`, `postData`, `getdata`, `postdata`, `sendReq`
- __⚠️ Alerte sécurité__ : Les requêtes SQL sont construites par concaténation de chaînes — vulnérabilité potentielle aux __injections SQL__

---

## 8. Points d'Attention & Recommandations

| # | Problème | Sévérité | |---|---|---| | 1 | __Injection SQL__ — Les requêtes sont construites côté client par concaténation | 🔴 Critique | | 2 | __Double client HTTP__ — `http` et `dio` coexistent inutilement | 🟡 Moyen | | 3 | __Fichier `my_config.dart`__ trop volumineux (~500+ lignes) — contient config, utilitaires, widgets, API, modèles | 🟡 Moyen | | 4 | __Pas de tests__ — Seul `test/widget_test.dart` existe (test par défaut Flutter) | 🟡 Moyen | | 5 | __Pas d'architecture claire__ — Pas de séparation service/repository/model | 🟡 Moyen | | 6 | __Variables globales__ — `myHeight`, `myWidth`, `dataP` en dehors des classes dans `page_hotel.dart` | 🟠 Faible | | 7 | __Pas de gestion d'erreurs UI__ — Les exceptions API sont lancées mais rarement catchées dans l'UI | 🟠 Faible | | 8 | __`google_fonts`__ déclaré mais non utilisé visiblement | 🟠 Faible |

---

## 9. Statistiques

| Métrique | Valeur | |---|---| | __Fichiers Dart__ | ~22 | | __Pages/Écrans__ | ~15 | | __Assets images__ | 76 | | __Fonts personnalisées__ | 2 | | __Dépendances__ | 22 | | __Plateformes__ | 6 (Android, iOS, Web, Windows, Linux, macOS) |

---

__Résumé__ : Ahime est une application Flutter multi-services (hôtels, artisans, transport) destinée au marché de Côte d'Ivoire, avec un backend API PHP/MySQL. L'architecture fonctionne mais gagnerait à être restructurée (séparation des couches, suppression des requêtes SQL côté client, et ajout de tests).
