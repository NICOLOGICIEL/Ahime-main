# Ahime

Application Flutter - Plateforme de services (Transport, Hôtellerie, Artisanat).

## Structure du projet

```
lib/
├── main.dart
├── config/
│   ├── my_config.dart      # Constantes, appels API (X-API-Key), helpers UI, WebView (myPub)
│   ├── secret.dart          # Clé API (non versionné, voir .gitignore)
│   ├── getx/                # Controllers GetX
│   └── utils/                # Widgets/utilitaires partagés
└── pages/
    ├── page_accueil.dart
    ├── page_mainscreen.dart
    ├── artisan/
    ├── hotel/
    └── transport/

slideshow/
├── index.html               # Slideshow plein écran de la page d'accueil
├── slider.js                # Moteur de slides partagé (slide, fade, cube, coverflow, flip, cards, creative)
├── Slash.jpeg                # Asset image du slideshow d'accueil
├── pubartisan/               # Annonce publicitaire de la page Artisan
├── pubhotel/                 # Annonce publicitaire de la page Hôtel
└── pubtransport/              # Annonce publicitaire de la page Transport
```

## Slideshow

Le slideshow (page d'accueil et annonces publicitaires artisan/hôtel/transport) repose sur
`slideshow/slider.js`, un moteur maison sans dépendance externe (fonctionne hors-ligne dans
la WebView), qui gère plusieurs effets :

| Effet | Description |
|-------|-------------|
| `slide` | Défilement horizontal |
| `fade` | Fondu enchaîné |
| `cube` | Rotation 3D en cube |
| `coverflow` | Carrousel avec profondeur |
| `flip` | Retournement 3D |
| `cards` | Empilement de cartes |
| `creative` | Animation créative avec clip-path |

L'effet par défaut peut être défini via l'URL : `?effect=cube`

Chaque page (`page_accueil.dart`, `page_artisan.dart`, `page_hotel.dart`, `page_transport.dart`)
affiche son slideshow via `myPub(myUrl: 'slideshow/.../index.html')`, défini dans
`lib/config/my_config.dart`.

## Configuration

Créer `lib/config/secret.dart` (non versionné) avec la clé API :

```dart
const String kXApiKey = 'votre-cle-api';
```

## Lancement

```bash
# Récupérer les dépendances
flutter pub get

# Chrome
flutter run -d chrome

# Android
flutter run
```

## Déploiement

L'application est prête pour le déploiement sur :
- Web (Chrome, Edge, Firefox, Safari)
- Android (APK / Play Store)
- iOS

## Ressources

- [Flutter documentation](https://docs.flutter.dev/)
