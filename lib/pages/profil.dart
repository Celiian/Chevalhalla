// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/horse_dp.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/modal_horse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/user.dart';
import '../db/mongodb.dart';
import 'admin/Index_Admin.dart';

class ProfilPage extends StatefulWidget {
  static const tag = "profil_page";

  const ProfilPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage> {
  int _currentIndex = 2;
  List horsesOwned = [];
  List horseDp = [];

  @override
  void initState() {
    super.initState();
    getHorses();

    if(User.status == "admin"){
      _currentIndex = 3;
    }
  }

  getHorses() async {
    var horses = await MongoDatabase().getHorsesOwner(User.id);
    horsesOwned = horses["owned"];
    horseDp = horses["dp"];
    setState(() {});
  }

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
    setState(() {
      _currentIndex = index;
      if (User.status == 'Cavalier') {
        if (_currentIndex == 0) {
          //Page d'accueil
          Navigator.of(context)
              .pushNamed(HomePage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 1) {
          Navigator.of(context)
              .pushNamed(PlanningPage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 2) {
          //page profil utilisateur
        }
      } else {
        if (_currentIndex == 0) {
          //Page d'accueil
          Navigator.of(context)
              .pushNamed(HomePage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 1) {
          //Page planning
          Navigator.of(context)
              .pushNamed(PlanningPage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 2) {
          //page profil utilisateur
          Navigator.of(context)
              .pushNamed(IndexAdmin.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 3) {
          //page profil utilisateur
          Navigator.of(context)
              .pushNamed(ProfilPage.tag)
              .then((_) => setState(() {}));
        }
      }
    });
  }

  var horse = Horse();

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var ownerController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Chelavkyries"), actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.lightbulb_sharp,
          ),
          tooltip: 'Changer de thème',
          onPressed: () {
            AdaptiveTheme.of(context).toggleThemeMode();
          },
        ),
      ]),
      body: Center(
        child: Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                          Text(
                            User.name,
                            style: const TextStyle(fontSize: 17),
                          ),
                          Text(User.mail),
                          Text(User.level),
                          Text(
                              'Date de naissance: ${DateFormat('dd/MM/yyyy').format(User.birthdate)}'),
                          Row(
                            children: [
                              TextButton(
                                child: const Text("Editer profil"),
                                onPressed: () {
                                  _EditProfile(context);
                                },
                              ),
                              TextButton(
                                child: const Text("Déconnexion"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )),
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      const Text(
                        "Chevalkyries : ",
                        style: TextStyle(fontSize: 17),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              child: const Text("Inscrire un chevalkyrie"),
                              onPressed: () {
                                ModalHorse().CreateHorse(context);
                                setState(() {});
                              },
                            ),
                            TextButton(
                              child: const Text("Choisir un chevalkyrie"),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(
                                      HorseDpPage.tag,
                                    )
                                    .then((_) => setState(() {}));
                                setState(() {});
                              },
                            ),
                          ]),
                      if (horsesOwned.isNotEmpty)
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: horsesOwned.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                child: ListTile(
                                  onTap: () => print(horsesOwned[index]),
                                  title: Text("Nom : " +
                                      horsesOwned[index]["name"] +
                                      " | breed : " +
                                      horsesOwned[index]["breed"] +
                                      " - Vous en êtes propriétaire"),
                                ),
                              );
                            },
                          ),
                        ),
                      if (horseDp.isNotEmpty)
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: horseDp.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                ),
                                child: ListTile(
                                  onTap: () => print(horseDp[index]),
                                  title: Text("Nom : " +
                                      horseDp[index]["name"] +
                                      " | breed : " +
                                      horseDp[index]["breed"] +
                                      " - Vous êtes en demi-pension"),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // new
        items: [
          if (User.status == 'admin') ...[
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Accueil", tooltip: "Accueil"),
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
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")
          ]
        ],
      ),
    );
  }
}


void _EditProfile(BuildContext context) {
  var _nameController = TextEditingController();
  var _mailController = TextEditingController();
  var _levelController = TextEditingController();
  var _passwordController = TextEditingController();
  var _lienFfeController = TextEditingController();
  var _pictureController = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editer profil"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Nom",
                  ),
                ),
                TextField(
                  controller: _mailController,
                  decoration: const InputDecoration(
                    hintText: "mail",
                  ),
                ),
                TextField(
                  controller: _levelController,
                  decoration: const InputDecoration(
                    hintText: "Mon niveau",
                  ),
                ),
                TextField(
                  controller: _lienFfeController,
                  decoration: const InputDecoration(
                    hintText: "lien FFE",
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                  ),
                ),
                TextField(
                  controller: _pictureController,
                  decoration: const InputDecoration(
                    hintText: "Url Photo de profil",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Valider"),
              onPressed: () {
                User.name = _nameController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}