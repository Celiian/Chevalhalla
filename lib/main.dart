import 'package:chevalhalla/pages/home.dart';
import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'pages/form.dart';
import 'pages/profil.dart';

Future<void> main() async {
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
      routes:
      {HomePage.tag: (context) => const HomePage(),
        ProfilPage.tag: (context) => const ProfilPage(title: 'profil_page',),},
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const FormPage(title: 'Chevalhalla'),
    );
  }
}