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
  }


  getHorses() async {
    var horses = await MongoDatabase().getHorses(User.id);
    horsesOwned = horses["owned"];
    horseDp = horses["dp"];
    setState(() {});
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.of(context)
            .pushNamed(
              HomePage.tag,
            )
            .then((_) => setState(() {}));
      } else if (_currentIndex == 1) {
        Navigator.of(context)
            .pushNamed(
              Planning.tag,
            )
            .then((_) => setState(() {}));
      } else if (_currentIndex == 2) {}
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
                                onPressed: () {},
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
