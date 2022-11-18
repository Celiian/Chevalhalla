// ignore_for_file: equal_keys_in_map

import 'package:chevalhalla/pages/competition.dart';
import 'package:chevalhalla/pages/horse_dp.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/pages/profil.dart';
import 'package:flutter/material.dart';
import 'db/mongodb.dart';
import 'pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chevalhalla/pages/register.dart';
import 'pages/login.dart';
import 'pages/party.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

Future<void> main() async {
  initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      //thème clair
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      //thème sombre
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      //thème par défaut
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Chevalhalla',
        theme: theme,
        darkTheme: darkTheme,
        home: const LoginPage(title: 'Connexion'),
        routes: {
          RegisterPage.tag: (context) => const RegisterPage(),
          HomePage.tag: (context) => const HomePage(),
          Planning.tag: (context) => const Planning(),
          PartyPage.tag: (context) => const PartyPage(event: null),
          CompetitionPage.tag: (context) => const CompetitionPage(event: null),
          ProfilPage.tag: (context) => const ProfilPage(),
          HorseDpPage.tag: (context) => const HorseDpPage(),
        },
      ),
    );
  }
}
