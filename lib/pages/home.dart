import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';
import 'admin/Index_Admin.dart';

class HomePage extends StatefulWidget {
  static const tag = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List _children = [];

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
    setState(() {
      _currentIndex = index;

      if (User.status == "Cavalier") {
        if (_currentIndex == 0) {
          //Home page navigator
        } else if (_currentIndex == 1) {
          Navigator.of(context)
              .pushNamed(Planning.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 2) {
          //Profile page navigator
        }
      }
      else {
        if (_currentIndex == 0) {
          //Home page navigator
        } else if (_currentIndex == 1) {
          Navigator.of(context)
              .pushNamed(Planning.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 2) {
          Navigator.of(context)
              .pushNamed(IndexAdmin.tag)
              .then((_) => setState(() {}));
        }
        else if (_currentIndex == 2) {
          //Profile page navigator
        }
      }
    });
  }

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
            onPressed: () {},
            child: const Text("Home Page"),
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex, // new
        items:  [
          if (User.status == 'admin')...
          [const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",backgroundColor: Colors.orange,tooltip: "Accueil"),
            const BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning",backgroundColor: Colors.orange,tooltip: "Planning"),
            const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "admin",backgroundColor: Colors.orange,tooltip: "admin"),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil",backgroundColor: Colors.orange,tooltip: "Profil")]
          else ...
          [const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",),
            const BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning"),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")]
        ],
    )
    );
  }
}
