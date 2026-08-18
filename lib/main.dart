import 'package:flutter/material.dart';
import 'package:ahime/pages/page_accueil.dart';
import 'package:ahime/config/my_config.dart';


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
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
