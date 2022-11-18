import 'package:chevalhalla/pages/admin/list_class.dart';
import 'package:chevalhalla/pages/admin/list_party.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/profil.dart';
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
            .pushNamed(PlanningPage.tag)
            .then((_) => setState(() {}));
      } else if (_currentIndex == 3) {
        //page profil utilisateur
        Navigator.of(context)
            .pushNamed(ProfilPage.tag)
            .then((_) => setState(() {}));
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
                  color: Colors.blue,
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
                  color: Colors.blue,
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
                  color: Colors.blue,
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
                    color: Colors.blue,
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
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.black,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          // new
          items: [
            if (User.status == 'admin') ...[
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Accueil",
                  backgroundColor: Colors.blue,
                  tooltip: "Accueil"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: "Planning",
                  backgroundColor: Colors.blue,
                  tooltip: "Planning"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "admin",
                  backgroundColor: Colors.blue,
                  tooltip: "admin"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profil",
                  backgroundColor: Colors.blue,
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
