// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db/mongodb.dart';

class ListUsers extends StatefulWidget {
  static const tag = "list_users_page";

  const ListUsers({super.key});

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List userList = [];

  @override
  void initState() {
    super.initState();
    //la fonction getUsers() est appelée dans le initState() pour récupérer la liste des utilisateurs

    getUsers();
  }

  getUsers() async {
    //la fonction getUsers() sert à récupérer la liste des utilisateurs
    userList = await MongoDatabase().getUsers();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Liste des Utilisateurs"),
        ),
        body: Center(
          child: Container(
              child: (userList != null)
                  ? ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(userList[index]['name']),
                    subtitle: Text(userList[index]['mail']),
                    onTap: () {
                      _showDialog(userList[index], context);
                    },
                  );
                },
              )
                  : const Text("Il n'y a pas de Soirée de prévue ")),
        ));
  }
  void _showDialog(user, context) {
    //userCreate est une variable qui contient la date de création de l'utilisateur
    var userCreate = user["creation_date"].toString().split(" ")[0];
    userCreate = "${userCreate.split("-")[2]} / ${userCreate.split("-")[1]} / ${userCreate.split("-")[0]}";
    //userBirthday est une variable qui contient la date de naissance de l'utilisateur
    var userBirthday = user["birthdate"].toString().split(" ")[0];
    userBirthday = "${userBirthday.split("-")[2]} / ${userBirthday.split("-")[1]} / ${userBirthday.split("-")[0]}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Utilisateur : " + user["name"]), actions: <Widget>[
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                    user["profil_picture"], width: 100),
              ),

              Text("Email : " + user["mail"],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text("Niveau : " + user["level"],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text("Date de naissance : $userBirthday",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Text("Date de Création : $userCreate",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
        );
      },
    );
  }
}