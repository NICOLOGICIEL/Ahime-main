import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahime/pages/page_accueil.dart';
import 'package:ahime/config/my_config.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Dart's HTTP stack (used by Dio/http) ignores Android's network_security_config,
// so on networks behind a TLS-inspecting proxy (e.g. Zscaler) requests fail even
// though the OS trusts the proxy's CA. Debug-only: accept the proxy's certs so
// local/emulator testing works; release builds keep strict validation.
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
      title: 'Ahime',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myColorBlue),
        useMaterial3: true,
      ),
      home: PageAccueil(),
    );
  }
}
