// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, no_logic_in_create_state, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/timeline_cards.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';

class PartyPage extends StatefulWidget {
  static const tag = "party_page";
  final event;

  const PartyPage({super.key, required this.event});

  @override
  State<PartyPage> createState() => _PartyPageState(event);
}

class _PartyPageState extends State<PartyPage> {
  int _currentIndex = 0;
  var user = User();
  late var event;
  var date = "";
  var hour = "";
  final commentaryController = TextEditingController();
  var participation;

  _PartyPageState(new_event) {
    event = new_event;
  }

  @override
  void initState() {
    super.initState();
    getParticipation();
    event = event["info"];

    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
    hour = event["hour"].toString().split(" ")[1].split(".")[0];
    hour = "${hour.split(":")[0]}:${hour.split(":")[1]}";
  }

  getParticipation() async {
    participation = await MongoDatabase()
        .checkParticipation(User.id, event["info"]["_id"], event["info"]["event_type"]);
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
    print(checkParticipation);
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
                      const Text('Voulez vous ajouter un commentaire ?'),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: TextFormField(
                          controller: commentaryController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            icon: Icon(Icons.comment),
                            labelText: 'Commentaire',
                            hintText:
                                'Entrez le commentaire que vous souhaitez ajouter',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez un commentaide';
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
                                onPressed: () => {},
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
                              child: const Text('Retour'),
                              onPressed: () => Navigator.pop(context),
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
            " Le $date à $hour",
            style: const TextStyle(height: 1, fontSize: 15),
          ),
          Text(
            event["description"],
            style: const TextStyle(height: 4),
          ),
          Container(
              child: (event["date"].compareTo(DateTime.now()) < 0)
                  ? const Text(
                      "Status : Terminé",
                      style: TextStyle(height: 2, fontSize: 15),
                    )
                  : Text(
                      "Status : " + event["status"],
                      style: const TextStyle(height: 2, fontSize: 15),
                    )),
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
                  child: Text("Particier".toUpperCase(),
                      style: const TextStyle(fontSize: 14)))
            ],
          )
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
