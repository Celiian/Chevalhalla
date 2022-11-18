import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db/mongodb.dart';

class ListHorses extends StatefulWidget {
  static const tag = "list_horses_page";

  const ListHorses({super.key});

  @override
  _ListHorsesState createState() => _ListHorsesState();

}

class _ListHorsesState extends State<ListHorses> {
  List HorseList = [];

  @override
  void initState() {
    super.initState();
    getHorses();

  }

  getHorses() async {
    HorseList = await MongoDatabase().getHorses();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Liste des Chevaux"),
        ),
        body: Center(
          child: Container(
              child: (HorseList != null)
                  ? ListView.builder(
                    itemCount: HorseList.length,
                    itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(HorseList[index]['name']),
                    onTap: () {
                      _showDialog(HorseList[index], context);
                    },
                  );
                },
              )
                  : Text("Il n'y pas de chevaux ")),
        ));
  }
}

 void _showDialog (chevaux, context) {
  var chevauxBirtday = chevaux["birthdate"].toString().split(" ")[0];
  chevauxBirtday = "${chevauxBirtday.split("-")[2]}/${chevauxBirtday.split("-")[1]}/${chevauxBirtday.split("-")[0]}";

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Nom : " + chevaux["name"],
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center),
          actions: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.network(
                    chevaux["image"], alignment: Alignment.center, width: 300, height: 300),
              ),

              Text("Genre : " + chevaux["gender"],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,),),
              Text("Race : " + chevaux["breed"],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text("Date de naissance :$chevauxBirtday",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Spécialité : " + chevaux["speciality"],
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right
                ),
              ),
            ],
          )
        ],
        );
      });
}