import 'dart:convert';
import 'dart:io';

import 'package:chevalhalla/pages/form.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../classes/user.dart';
import '../mongodb.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, required this.title});

  final String title;

  static const tag = "profil_page";

  @override
  State<StatefulWidget> createState() => _ProfilState();
}

class _ProfilState extends State<ProfilPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.of(context).pushNamed(HomePage.tag,).then((_) => setState(() {}));
      } else if (_currentIndex == 1) {
        //Planning page navigator
      } else if (_currentIndex == 2) {}
    });
  }

  var horse = Horse();

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var ownerController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form page"),
      ),
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
                                  Navigator.of(context).popUntil((route) => route.isFirst);
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
                              onPressed: () {},
                            ),
                            TextButton(
                              child: const Text("Choisir un chevalkyrie"),
                              onPressed: () {},
                            ),
                          ]),
                      SizedBox(
                        height: 200,
                        child: FutureBuilder(
                            future: MongoDatabase().getHorses(User.mail),
                            builder: (buildContext, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                throw const Center(
                                  child: Text("Waiting..."),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                  child: Text("Waiting..."),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(

                                          children: <Widget>[
                                        Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40),
                                            child:
                                            CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    snapshot.data[index]
                                                        ['profilePicture'],
                                                    scale: 30))),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Nom : ${snapshot.data[index]['name']}'),
                                                Text(
                                                    'Race : ${snapshot.data[index]['race']}'),
                                                Text(
                                                    'Sexe : ${snapshot.data[index]['gender']}'),
                                                Text(
                                                    'Spécialité : ${snapshot.data[index]['speciality']}'),
                                              ],
                                            ),
                                          ]));
                                    });
                              }
                            }),
                      )
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
