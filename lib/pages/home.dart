// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/planning.dart';
import 'package:chevalhalla/widgets/timeline_cards.dart';
import 'package:flutter/material.dart';

import '../classes/user.dart';

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
      if (_currentIndex == 0) {
        //Home page navigator
      } else if (_currentIndex == 1) {
        Navigator.of(context)
            .pushNamed(Planning.tag)
            .then((_) => setState(() {}));
      } else if (_currentIndex == 2) {
        //Profile page navigator
      }
    });
  }

  getCards() {
    setState(() {
      while (cardList.isNotEmpty) {
        cardList.removeLast();
      }

      for (var event in events) {
        cardList.add(timeline_card(event));
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
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                height: 200,
                child: cardList[index],
              );
            }),
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
