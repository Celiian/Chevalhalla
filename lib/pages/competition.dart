// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, no_logic_in_create_state, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/timeline_cards.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';

class CompetitionPage extends StatefulWidget {
  static const tag = "competition_page";
  final event;

  const CompetitionPage({super.key, required this.event});

  @override
  State<CompetitionPage> createState() => _CompetitionPageState(event);
}

class _CompetitionPageState extends State<CompetitionPage> {
  int _currentIndex = 0;
  var user = User();
  late var event;
  var date = "";
  final levelController = TextEditingController();

  var participation;
  List participations = [];

  _CompetitionPageState(new_event) {
    event = new_event;
  }

  @override
  void initState() {
    super.initState();
    getParticipation();

    levelController.text = "";

    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
  }

  getParticipation() async {
    participation = await MongoDatabase()
        .checkParticipation(User.id, event["_id"], event["event_type"]);
    participations = await MongoDatabase().getParticipations(event["_id"]);
    setState(() {});
  }

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
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
        //Profile page navigator
      }
    });
  }

  openModal(checkParticipation) {
    setState(() {});
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Center(
            child: (!checkParticipation)
                // Vérifie si l'utilisateur participe déja à l'evenement ou non
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('A quel niveau voulez vous participer ?'),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: 'Niveau',
                            hintText: 'Choisissez un niveau',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'amateur',
                              child: Text('Amateur'),
                            ),
                            DropdownMenuItem(
                              value: 'Club1',
                              child: Text('Club 1'),
                            ),
                            DropdownMenuItem(
                              value: 'Club2',
                              child: Text('Club 2'),
                            ),
                            DropdownMenuItem(
                              value: 'Club3',
                              child: Text('Club 3'),
                            ),
                            DropdownMenuItem(
                              value: 'Club4',
                              child: Text('Club 4'),
                            ),
                          ],
                          onChanged: (value) {
                            levelController.text = value!;
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Choisissez un niveau';
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              child: const Text('Annuler'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                                onPressed: () => {
                                      MongoDatabase()
                                          .createParticipationCompetition(
                                              User.id,
                                              User.name,
                                              event["_id"],
                                              event["event_type"],
                                              "",
                                              levelController.text),
                                      Navigator.pop(context),
                                      setState(() {
                                        participation = true;
                                      })
                                    },
                                child: const Text(
                                  "Valider",
                                ))
                          ])
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Vous participez déjà à cet evenement'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side:
                                              BorderSide(color: Colors.red)))),
                              child: const Text('Annuler participation'),
                              onPressed: () => {
                                MongoDatabase()
                                    .cancelParticipation(User.id, event["_id"]),
                                setState(() {
                                  participation = false;
                                }),
                                Navigator.pop(context)
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Retour'),
                              onPressed: () => {Navigator.pop(context)},
                            ),
                          ]),
                    ],
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion"), actions: <Widget>[
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
          Image.network(
            event["image"],
            width: 430,
          ),
          Text(
            event["name"],
            style: const TextStyle(height: 2, fontSize: 30),
          ),
          Text(
            " Le $date",
            style: const TextStyle(height: 1, fontSize: 15),
          ),
          Text(
            event["adress"],
            style: const TextStyle(height: 4),
          ),
          Container(
              child: (event["date"].compareTo(DateTime.now()) < 0)
                  ? const Text(
                      "Status : Terminé",
                      style: TextStyle(height: 2, fontSize: 15),
                    )
                  : null),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () => {Navigator.pop(context)},
                  child: Text("Retour".toUpperCase(),
                      style: const TextStyle(fontSize: 14))),
              ElevatedButton(
                  onPressed: () => {openModal(participation)},
                  child: Text("Participer".toUpperCase(),
                      style: const TextStyle(fontSize: 14)))
            ],
          ),
          const Text(
            "Participants :",
            style: TextStyle(height: 3, fontSize: 23),
          ),
          Container(
            height: 150,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: participations.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                      participations[index]["user_name"] +
                          " -> " +
                          participations[index]["level"],
                      style: const TextStyle(fontSize: 20)),
                );
              },
            ),
          ),
        ],
      )),
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
