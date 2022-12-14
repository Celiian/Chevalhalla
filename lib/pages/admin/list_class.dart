// ignore_for_file: library_private_types_in_public_api, unnecessary_import, unnecessary_null_comparison, avoid_print, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chevalhalla/db/mongodb.dart';

class ListClass extends StatefulWidget {
  static const tag = "list_class_page";

  const ListClass({super.key});

  @override
  _ListClassState createState() => _ListClassState();
}

class _ListClassState extends State<ListClass> {
  List ClassesList = [];

  @override
  void initState() {
    super.initState();
    getClasses();
  }

  getClasses() async {
    ClassesList = await MongoDatabase().getClasses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Liste des Cours"),
        ),
        body: Center(
          child: Container(
              child: (ClassesList != null)
                  ? ListView.builder(
                      itemCount: ClassesList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(ClassesList[index]['name']),
                          subtitle: Text(ClassesList[index]['hour']),
                          onTap: () {
                            _showDialog(ClassesList[index], context);
                          },
                        );
                      },
                    )
                  : const Text("Il n'y a pas de Soirée de prévue ")),
        ));
  }

  void _showDialog(event, context) {
    var date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String duration = event['duration'].toString();
        return AlertDialog(
          content: Text(
            event["name"],
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Utilisateur : " + event["user_name"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Text("Terrain : " + event["field"],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text("Discipline : " + event["discipline"],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text("Date : $date",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text("Durée : $duration minutes",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text("Heure : " + event["hour"],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text("Status : " + event["status"],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 30.0),
                  child: Row(
                    children: [
                      if (event["status"] == "En attente" || event["status"] == "Refusé")
                          Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: TextButton(
                            child: const Text("Valider",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              MongoDatabase().acceptClass(event["_id"]);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      if (event["status"] == "Accepté")
                        Padding(
                          padding: const EdgeInsets.only(left: 90.0),
                          child: TextButton(
                            child: const Text("Refuser",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              MongoDatabase().refuseClass(event["_id"]);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
