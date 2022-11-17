import 'package:chevalhalla/pages/planning.dart';
import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/register.dart';
import 'package:flutter/material.dart';
import 'db/mongodb.dart';
import 'pages/login.dart';
import 'pages/register.dart';

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
    return MaterialApp(
      title: 'Home',
      routes: {
        HomePage.tag: (context) => const HomePage(),
        Planning.tag: (context) => const Planning(),
        RegisterPage.tag: (context) => const RegisterPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(title: 'Chevalhalla'),
    );
  }
}
