# Prompt pour générer un projet Flutter similaire à Ahime

## Objectif
Créer une application Flutter complète avec une architecture modulaire pour un service de réservation multi-domaines (hôtels, transport, artisans) similaire à l'application Ahime.

## Structure de base du projet
Créez le répertoire racine du projet avec la structure suivante :
```
projet_nom/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── assets/
│   ├── image/           # Toutes les images PNG/JPG
│   └── fonts/           # Polices personnalisées
├── lib/
│   ├── main.dart        # Point d'entrée
│   ├── pages/           # Tous les écrans
│   │   ├── page_mainscreen.dart
│   │   ├── page_accueil.dart
│   │   ├── artisan/
│   │   ├── hotel/
│   │   └── transport/
│   └── config/          # Configuration et utilitaires
│       ├── my_config.dart
│       ├── utils/
│       └── getx/
└── pubspec.yaml        # Dépendances
```

## Configuration Flutter (pubspec.yaml)

```yaml
name: [nom_projet]
description: "Projet similaire à Ahime."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.4.3 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  google_fonts: ^6.2.1
  responsive_sizer: ^3.3.1
  text_scroll: ^0.2.0
  animated_custom_dropdown: ^3.1.1
  flutter_rating: ^2.0.2
  scrollable_text_indicator: ^0.0.2
  readmore: ^3.0.0
  http: ^1.2.2
  dio: ^5.7.0
  get: ^4.6.6
  url_launcher: ^6.3.1
  flutter_spinkit: ^5.2.1
  platform_detector: ^0.2.0
  flutter_inappwebview: ^6.1.5
  webview_flutter: ^4.10.0
  flutter_masked_text2: ^0.9.1
  geolocator: ^13.0.2
  latlong2: ^0.9.1
  motion_toast: ^2.11.0
  timeline_tile_plus: ^0.0.3
  flutter_native_splash: ^2.4.3
  double_back_to_close_app: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  flutter_launcher_icons: ^0.14.3

flutter_icons:
  android: "ic_launcher"
  ios: true
  image_path: "assets/image/[votre_logo].png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/image/[icône_adaptative].png"
  remove_alpha_ios: true
  min_sdk_android: 21

flutter_native_splash:
  color: "#FFFFFF"
  color_dark: "#0E1116"
  image: "assets/image/[logo_transparent].png"
  image_dark: "assets/image/[logo_transparent].png"
  android_12:
    color: "#FFFFFF"
    color_dark: "#0E1116"
    image: "assets/image/[icône_12].png"
    image_dark: "assets/image/[icône_12].png"
  android: true
  ios: true
  web: false
  fullscreen: true
```

## Configuration principale (lib/main.dart)

```dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:[nom_projet]/pages/page_mainscreen.dart';
import 'package:[nom_projet]/config/my_config.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  if (kDebugMode) {
    HttpOverrides.global = DebugHttpOverrides();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '[Nom Projet]',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myColorBlue),
        useMaterial3: true,
      ),
      home: const PageMainscreen(),
    );
  }
}
```

## Configuration (lib/config/my_config.dart)

```dart
// ignore_for_file: non_constant_identifier_names

import 'package:[nom_projet]/config/utils/resizable.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:platform_detector/platform_detector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

// Couleurs
const Color myColorBlue = Color(0xFF023a6b);
const Color myColorBlue2 = Color(0xFF0050a0);
const Color myColorGreen = Color(0xFF02893c);
const Color myColorWhite = Color(0xFFF6F7F9);
const Color myColorRed = Color(0xFFcb182b);
const Color myColorBlueLight = Color(0xFFeaf1f9);
const Color myColorBgGrey = Color(0xFFf1f1f2);
var myColorGreyBorber = Colors.grey.withValues(alpha: 0.5);
const Color myColorGreenLight = Color(0xFFe9fdfe);
const Color myColorGreenn = Color(0xFF35d852);

// Configuration API
const String APIServeur = "https://www.votre-site.com";
const String apiBaseURL = "www.votre-site.com";
var endpoint = '/api/action';
var endpointINI = '/api';
final apiurl = '$APIServeur$endpoint';
final apiurlINI = '$APIServeur$endpointINI';

// Chemins des actifs
const imageUri = 'assets/image';
const fontsUri = 'assets/fonts';

// Navigation
Future pushPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future popPage(BuildContext context) {
  return Navigator.pop(context);
}
```

## Utilitaires de configuration (lib/config/utils/resizable.dart)

```dart
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;
  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth!/100;
    blockSizeVertical = screenHeight!/100;
    _safeAreaHorizontal = _mediaQueryData!.padding.left +
        _mediaQueryData!.padding.right;
    _safeAreaVertical = _mediaQueryData!.padding.top +
        _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!)/100;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!)/100;
  }
}
```

## Contrôleurs GetX (lib/config/getx/updatescreen.dart)

```dart
import 'package:get/get.dart';

class ChkController extends GetxController {
  var txtresult = ''.obs;
  var notNote = 0.0.obs;

  @override
  void onClose() {
    txtresult.value = '0 résultat trouvé';
  }

  void tTotal(nbrTot) {
    if (nbrTot <= 1) {
      txtresult.value = '$nbrTot résultat trouvé';
    } else {
      txtresult.value = '$nbrTot résultats trouvés';
    }
  }

  void changeNote(rate) {
    notNote.value = rate;
  }
}

class EscaleController extends GetxController {
  var dataEscale = [].obs;

  @override
  void onClose() {
    dataEscale.value = [];
  }

  void tEscale(data) {
    dataEscale.value = data;
  }
}
```

## Page principale (lib/pages/page_mainscreen.dart)

```dart
import 'package:flutter/material.dart';
import 'package:[nom_projet]/pages/artisan/page_artisan.dart';
import 'package:[nom_projet]/pages/hotel/page_hotel.dart';
import 'package:[nom_projet]/pages/transport/page_transport.dart';
import 'package:[nom_projet]/config/utils/resizable.dart';
import 'package:[nom_projet]/config/my_config.dart';

const Color myColorOrange = Color(0xFFF08A24);

class PageMainscreen extends StatefulWidget {
  const PageMainscreen({super.key});

  @override
  State<PageMainscreen> createState() => _PageMainscreenState();
}

class _PageMainscreenState extends State<PageMainscreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildLogo(),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildServiceCard(
                        title: 'HÔTELS',
                        subtitle: 'Réservez votre hôtel',
                        icon: Icons.bed_rounded,
                        color: myColorBlue2,
                        onTap: () => pushPage(context, PageHotel()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: _buildServiceCard(
                        title: 'TRANSPORT',
                        subtitle: 'Trouvez votre trajet',
                        icon: Icons.directions_bus_filled_rounded,
                        color: myColorGreen,
                        onTap: () => pushPage(context, const PageTransport()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: _buildServiceCard(
                        title: 'ARTISANS',
                        subtitle: 'Trouvez un professionnel',
                        icon: Icons.handyman_rounded,
                        color: myColorOrange,
                        onTap: () => pushPage(context, const PageArtisan()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myWidth * 4),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        '$imageUri/header.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      alignment: Alignment.center,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              color: _selectedIndex == 0 ? myColorBlue2 : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 0),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 1 ? Icons.hotel : Icons.hotel_outlined,
              color: _selectedIndex == 1 ? myColorBlue2 : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 2 ? Icons.directions_bus : Icons.directions_bus_outlined,
              color: _selectedIndex == 2 ? myColorBlue2 : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 2),
          ),
          IconButton(
            icon: Icon(
              _selectedIndex == 3 ? Icons.handyman : Icons.handyman_outlined,
              color: _selectedIndex == 3 ? myColorBlue2 : Colors.grey,
            ),
            onPressed: () => setState(() => _selectedIndex = 3),
          ),
        ],
      ),
    );
  }
}
```

## Structure des modules

Pour chaque module (artisan, hotel, transport), créez :
- `page_[module].dart` - Page principale
- `page_[module]result.dart` - Page de résultats
- `page_[module]detail.dart` - Page de détail
- `page_[module]imgdetail.dart` - Page de détail d'image
- `my_form.dart` - Formulaire personnalisé si nécessaire

## Ressources

Ajoutez les ressources suivantes dans `assets/` :
- `image/` : Toutes les images PNG/JPG (logo, icônes, fonds, etc.)
- `fonts/` : Polices personnalisées (Noteworthy-Lt.ttf, palr45w.ttf)

## Configuration Android/iOS

Assurez-vous d'avoir les fichiers de configuration appropriés :
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- `macos/Runner/Info.plist`

## Scripts de construction

Ajoutez les scripts de construction nécessaires :
- `linux/main.cc`
- `macos/Runner/MainFlutterWindow.swift`
- `windows/runner/CMakeLists.txt`

## Tests

Ajoutez les tests de base :
- `test/widget_test.dart`
- `test/robot/` pour les tests robotisés

## Configuration d'environnement

Assurez-vous d'avoir :
- `.gitignore` avec les entrées Flutter standard
- `analysis_options.yaml` pour les linters
- `pubspec.lock` généré après `flutter pub get`

## Étapes de construction

1. `flutter pub get` - Installer les dépendances
2. `flutter analyze` - Analyser le code
3. `flutter test` - Exécuter les tests
4. `flutter build apk` - Construire l'APK Android
5. `flutter build ios` - Construire l'IPA iOS

Ce prompt générera un projet Flutter complet et fonctionnel similaire à Ahime avec la même architecture modulaire, configuration, et flux de navigation.
