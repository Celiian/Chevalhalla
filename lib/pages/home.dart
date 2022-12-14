// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/profil.dart';
import 'package:chevalhalla/pages/party.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/timeline_cards.dart';
import 'package:flutter/material.dart';
import 'competition.dart';

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
  var user = User();
  List events = [];
  List<timeline_card> cardList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    events = await MongoDatabase().getTimeline();
    getCards();
  }

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
    setState(() {
      _currentIndex = index;
      if(User.status == 'Cavalier'){
        if (_currentIndex == 0) {
          //Page d'accueil
        } else if (_currentIndex == 1) {
          //page planning
          Navigator.of(context)
              .pushNamed(PlanningPage.tag)
              .then((_) => setState(() {}));      }
        else if (_currentIndex == 2) {
          //page profil utilisateur
          Navigator.of(context)
              .pushNamed(ProfilPage.tag)
              .then((_) => setState(() {}));
        }
      }
      else {
        if (_currentIndex == 0) {
          //Home page navigator

        } else if (_currentIndex == 1) {
          Navigator.of(context)
              .pushNamed(PlanningPage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 2) {
          Navigator.of(context)
              .pushNamed(IndexAdmin.tag)
              .then((_) => setState(() {}));
        }
        else if (_currentIndex == 3) {
          //Profile page navigator
          Navigator.of(context)
              .pushNamed(ProfilPage.tag)
              .then((_) => setState(() {}));
        }
      }
    }
    );
  }


  getCards() {
    setState(() {
      while (cardList.isNotEmpty) {
        cardList.removeLast();
      }

      for (var event in events) {
        cardList.add(timeline_card(event["info"]));
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
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    if (events[index]["info"]["event_type"] == "party") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PartyPage(event: events[index]["info"])));
                    } else if (events[index]["info"]["event_type"] ==
                        "competition") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CompetitionPage(
                                      event: events[index]["info"])));
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    height: 200,
                    child: cardList[index],
                  ));
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // new
        items: [
          if (User.status == 'admin')...
          [
            const BottomNavigationBarItem(icon: Icon(Icons.home),
                label: "Accueil",
                backgroundColor: Colors.blue,
                tooltip: "Accueil"),
            const BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
                label: "Planning",
                backgroundColor: Colors.blue,
                tooltip: "Planning"),
            const BottomNavigationBarItem(icon: Icon(Icons.settings),
                label: "admin",
                backgroundColor: Colors.blue,
                tooltip: "admin"),
            const BottomNavigationBarItem(icon: Icon(Icons.person),
                label: "Profil",
                backgroundColor: Colors.blue,
                tooltip: "Profil")
          ]
          else
            ...
            [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: "Accueil",),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today), label: "Planning"),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profil")
            ]
        ],
      )
  );
}}
