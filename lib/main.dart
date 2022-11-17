import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/register.dart';
import 'package:flutter/material.dart';
import 'db/mongodb.dart';
import 'pages/login.dart';
import 'pages/register.dart';

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
      routes: {
        HomePage.tag: (context) => const HomePage(),
        RegisterPage.tag: (context) => const RegisterPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const LoginPage(title: 'Chevalhalla'),
    );
  }
}
