import 'package:chevalhalla/pages/planning.dart';
import 'package:flutter/material.dart';
import 'mongodb.dart';
import 'pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        Planning.tag: (context) => const Planning()
      },
      home: const MyHomePage(title: 'Chevalhalla'),
    );
  }
}