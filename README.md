# Ahime

Application Flutter - Plateforme de services (Transport, Hôtelleris, Artisanat, Immobilier).

## Structure du projet

```
lib/
├── main.dart
└── pages/
    ├── page_accueil.dart
    ├── slideshow/page_slideshow.dart
    └── transport/page_transport.dart

slideshow/
├── index.html      # Slideshow plein écran avec effets SwiperJS
├── slider.js       # Moteur de slides (slide, fade, cube, coverflow, flip, cards, creative)
└── Slash.jpeg      # Asset image
```

## Slideshow

Le slideshow intègre les principaux effets SwiperJS :

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

## Lancement

```bash
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
- [SwiperJS](https://swiperjs.com/)
