import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/user.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, required this.title});

  final String title;

  static const tag = "profil_page";

  @override
  State<StatefulWidget> createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Home page navigator
      } else if (_currentIndex == 1) {
        //Planning page navigator
      } else if (_currentIndex == 2) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form page"),
      ),
      body: Center(
          child: Column(children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Card(
              elevation: 5,
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16),
                    child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(User.profilePicture, scale: 80)),
                  ),
                  Column(
                    children: [
                      Text(User.name),
                      Text(User.mail),
                      Text(User.level),
                      Text(
                          'Date de naissance: ${DateFormat('dd/MM/yyyy').format(User.birthdate)}'),
                    ],
                  ),
                ],
              ),
            ))
      ])),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
