import 'package:chevalhalla/pages/home.dart';
import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'pages/home.dart';
import 'pages/register.dart';
import 'pages/form.dart';


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
      routes: {Register.tag: (context) => const Register()},
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const FormPage(title: 'Chevalhalla'),
    );
  }
}