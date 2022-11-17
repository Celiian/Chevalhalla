import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:flutter/material.dart';

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
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Home page navigator
      } else if (_currentIndex == 1) {
        Navigator.of(context)
            .pushNamed(Planning.tag)
            .then((_) => setState(() {}));      }
      else if (_currentIndex == 2) {
        //Profile page navigator
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
          [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",backgroundColor: Colors.orange,tooltip: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning",backgroundColor: Colors.orange,tooltip: "Planning"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "admin",backgroundColor: Colors.orange,tooltip: "admin"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil",backgroundColor: Colors.orange,tooltip: "Profil")]
          else ...
          [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")]
        ],
    )
    );
  }
}
