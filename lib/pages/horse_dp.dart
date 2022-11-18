// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/profil.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/modal_horse.dart';
import 'package:flutter/material.dart';

class HorseDpPage extends StatefulWidget {
  static const tag = "horse_page";

  const HorseDpPage({super.key});

  @override
  State<HorseDpPage> createState() => _HorseDpPageState();
}

class _HorseDpPageState extends State<HorseDpPage> {
  int _currentIndex = 2;
  List allHorses = [];
  List dpHorses = [];

  getAllHorses() async {
    allHorses = await MongoDatabase().getAllHorses();

    for (var horse in allHorses) {
      if (horse["owner"] == User.id) {
        allHorses.remove(horse);
      }
    }

    dpHorses = await MongoDatabase().getDpId(User.id);

    print(allHorses.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllHorses();
  }

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        //Home page navigator
      } else if (_currentIndex == 1) {
        Navigator.of(context)
            .pushNamed(PlanningPage.tag)
            .then((_) => setState(() {}));
      } else if (_currentIndex == 2) {
        Navigator.of(context)
            .pushNamed(
              ProfilPage.tag,
            )
            .then((_) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
            height: 400,
            child: Column(
              children: [
                if (allHorses.isNotEmpty)
                  const Text(
                    "Voici les Chevalkyries disponible pour une demi-pension",
                    style: TextStyle(fontSize: 20),
                  ),
                if (allHorses.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: allHorses.length,
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
                            onTap: () => {
                              ModalHorse()
                                  .ChooseHorse(context, allHorses[index], dpHorses)
                            },
                            title: Text(
                                "${"Nom : " + allHorses[index]["name"]} | breed : " +
                                    allHorses[index]["breed"]),
                          ),
                        );
                      },
                    ),
                  ),
                if (allHorses.isEmpty)
                  const Text(
                    "Il n'y a aucun Chevalkyrie disponible pour une demi-pension",
                    style: TextStyle(fontSize: 17),
                  )
              ],
            )),
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
            label: 'Profil',
          )
        ],
      ),
    );
  }
}
