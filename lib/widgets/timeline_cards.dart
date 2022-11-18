// ignore_for_file: prefer_typing_uninitialized_variables, camel_case_types, non_constant_identifier_names, prefer_interpolation_to_compose_strings, must_be_immutable, prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:flutter/material.dart';

class timeline_card extends StatelessWidget {
  late final event;
  late Widget card = _emptyCard();

  timeline_card(new_event, {super.key}) {
    event = new_event;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              if (event["event_type"] == "class")
                _classCard(event)
              else if (event["event_type"] == "competition")
                _competitionCard(event)
              else if (event["event_type"] == "party")
                _partyCard(event)
              else if (event["mail"] != null)
                _userCard(event)
            ])));
  }
}

class _userCard extends StatelessWidget {
  late final event;
  var date;

  _userCard(new_event, {super.key}) {
    event = new_event;

    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Image.network(
            event["profil_picture"],
            height: 80,
            width: 120,
          ),
        ]),
        Column(
          children: [
            Text(event["name"] + " nous as rejoint le :"),
            Text(" $date"),
          ],
        )
      ],
    );
    ;
  }
}

class _emptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text("");
  }
}

class _classCard extends StatelessWidget {
  late final event;
  String date = "";
  String hour = "";

  _classCard(new_event, {super.key}) {
    event = new_event;

    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
    hour = event["hour"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Image.network(
            "https://blog.action-sejours.com/wp-content/uploads/2018/10/conseils-equitation.jpg",
            height: 80,
            width: 120,
          ),
        ]),
        Column(
          children: [
            Text("  Le $date à $hour"),
            Text(event["name"]),
            Text("Durée : ${event["duration"]} min"),
            Container(
                child: (event["date"].compareTo(DateTime.now()) < 0)
                    ? const Text("Status : Terminé")
                    : Text("Status : " + event["status"]))
          ],
        )
      ],
    );
  }
}

class _partyCard extends StatelessWidget {
  late final event;
  String date = "";
  String hour = "";

  _partyCard(new_event, {super.key}) {
    event = new_event;
    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
    hour = event["hour"].toString().split(" ")[1].split(".")[0];
    hour = hour.split(":")[0] + ":" + hour.split(":")[1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(children: [
            Image.network(
              event["image"],
              height: 80,
              width: 120,
            ),
          ]),
          Column(
            children: [
              Text(" Le $date à $hour"),
              Text(event["name"]),
              Container(
                  child: (event["date"].compareTo(DateTime.now()) < 0)
                      ? const Text("Status : Terminé")
                      : Text("Status : " + event["status"]))
            ],
          )
        ],
      ),
    );
  }
}

class _competitionCard extends StatelessWidget {
  late final event;
  String date = "";

  _competitionCard(new_event, {super.key}) {
    event = new_event;
    date = event["date"].toString().split(" ")[0];
    date =
        "${date.split("-")[2]} / ${date.split("-")[1]} / ${date.split("-")[0]}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(children: [
          Image.network(
            event["image"],
            height: 80,
            width: 120,
          ),
        ]),
        Column(
          children: [
            Text(" Le $date"),
            Text(event["name"]),
            Text(" Adresse : " + event["adress"]),
            Container(
                child: (event["date"].compareTo(DateTime.now()) < 0)
                    ? const Text("Status : Terminé")
                    : null),
          ],
        )
      ],
    );
  }
}
