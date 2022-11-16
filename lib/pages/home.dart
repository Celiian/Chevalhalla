// ignore_for_file: avoid_print

import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/mongodb.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const tag = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Form page"),
        ),
        body: Center(
            child: Column(
          children: [
            TextButton(
              onPressed: () {
              },
              child: const Text("Home Page"),
            )
          ],
        )));
  }
}
