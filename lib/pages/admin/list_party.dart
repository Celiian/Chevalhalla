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

                  );
                },
              )
                  : Text("Il n'y pas de Soirée de prévue ")),
        ));
  }
}