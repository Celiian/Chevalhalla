import 'package:chevalhalla/pages/admin/list_class.dart';
import 'package:chevalhalla/pages/admin/list_party.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:flutter/material.dart';

import '../../classes/user.dart';
import '../planning.dart';
import 'list_horse.dart';
import 'list_user.dart';

class IndexAdmin extends StatefulWidget {
  static const tag = "index_admin_page";

  const IndexAdmin({super.key});

  @override
  _IndexAdminState createState() => _IndexAdminState();
}

class _IndexAdminState extends State<IndexAdmin> {
  int _currentIndex = 2;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.of(context)
            .pushNamed(HomePage.tag)
            .then((_) => setState(() {}));
      } else if (_currentIndex == 1) {
        Navigator.of(context)
            .pushNamed(Planning.tag)
            .then((_) => setState(() {}));
      } else if (_currentIndex == 2) {
        //page profil utilisateur
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin"),
        ),
        body: Center(
            child: Column(
          children: [
            ListTile(
              title: const Text('Liste des utilisateurs',
                style: TextStyle(fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Trebuchet MS',
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListUsers()),
                );
              },
            ),
            ListTile(
              title: const Text('Liste des chevaux',
                style: TextStyle(fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Trebuchet MS',
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListHorses()),
                );
              },
            ),
            ListTile(
              title: const Text('Liste des cours',
                style: TextStyle(fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Trebuchet MS',
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListClass()),
                );
              },
            ),
            ListTile(

              title: const Text('Liste des Soirée Chevalhalla',
                  style: TextStyle(fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Trebuchet MS',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListParty()),
                );
              },
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.black,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          // new
          items: [
            if (User.status == 'admin') ...[
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Accueil",
                  backgroundColor: Colors.orange,
                  tooltip: "Accueil"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: "Planning",
                  backgroundColor: Colors.orange,
                  tooltip: "Planning"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "admin",
                  backgroundColor: Colors.orange,
                  tooltip: "admin"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profil",
                  backgroundColor: Colors.orange,
                  tooltip: "Profil")
            ] else ...[
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Accueil",
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: "Planning"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profil")
            ]
          ],
        ));
  }
}
