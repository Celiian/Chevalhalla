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
                    subtitle: Text(HorseList[index]['race']),
                  );
                },
              )
                  : Text("Il n'y pas de chevaux ")),
        ));
  }
}