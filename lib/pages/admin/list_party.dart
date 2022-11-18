import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db/mongodb.dart';

class ListParty extends StatefulWidget {
  static const tag = "list_party_page";

  const ListParty({super.key});

  @override
  _ListPartyState createState() => _ListPartyState();
}

class _ListPartyState extends State<ListParty> {
  List PartyList = [];

  @override
  void initState() {
    super.initState();
    getParty();

  }

  getParty() async {
    PartyList = await MongoDatabase().getParties();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Liste des Soirées"),
        ),
        body: Center(
          child: Container(
              child: (PartyList != null)
                  ? ListView.builder(
                itemCount: PartyList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(PartyList[index]['name']),
                    subtitle: Text(PartyList[index]['description']),
                    onTap: () {
                      _showDialog(PartyList[index], context);
                    },
                  );
                },
              )
                  : Text("Il n'y pas de Soirée de prévue ")),
        ));
  }
}

  _showDialog(soirees, context) {
    var date = soirees["date"].toString().split(" ")[0];
    date = "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
    showDialog(context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        content: Image.network(
            soirees["image"], width: 100), actions: <Widget>[
        Column(
          children: [
            Text("Type : " + soirees["type"],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text("Date : " + date,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text("Heure : " + soirees["hour"],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text("Description : " + soirees["description"],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text("Crée par : " + soirees["user_name"],
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 30.0),
              child: Row(
                children: [
                  TextButton(
                      child: const Text("Refuser",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextButton(
                      child: const Text("Valider",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onPressed: () {
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
    });

}