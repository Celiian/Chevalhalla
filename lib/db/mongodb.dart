// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:intl/intl.dart';

class MongoDatabase {
  static DbCollection? collectionUtilisateurs;
  static DbCollection? collectionChevaux;
  static DbCollection? collectionCompetition;
  static DbCollection? collectionSoirees;
  static DbCollection? collectionCours;
  static DbCollection? collectionDemiPensionnaires;
  static DbCollection? collectionParticipations;

  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    collectionUtilisateurs = db.collection(COLLECTION_UTILISATEURS);
    collectionChevaux = db.collection(COLLECTION_CHEVAUX);
    collectionCompetition = db.collection(COLLECTION_CONCOURS);
    collectionCours = db.collection(COLLECTION_COURS);
    collectionDemiPensionnaires = db.collection(COLLECTION_DP);
    collectionParticipations = db.collection(COLLECTION_PARTICIPATIONS);
    collectionSoirees = db.collection(COLLECTION_SOIREES);

    if (await collectionUtilisateurs?.find().toList() != null) {
      print("connected");
    }
  }

  createUser(String name, DateTime birthdate, String level, String mail,
      String profilePicture, String status, String ffe, String password) {
    collectionUtilisateurs?.insertOne({
      "name": name,
      "birthdate": birthdate,
      "level": level,
      "mail": mail,
      "profil_picture": profilePicture,
      "status": status,
      "ffe": ffe,
      "password": password
    });
  }

  getUser(String mail, String password) async {
    var user = await collectionUtilisateurs
        ?.findOne(where.eq("mail", mail).eq("password", password));
    return user;
  }

  createClass(userId, String discipline, String field, String className,
      int duration, DateTime date, hour) async {
    collectionCours?.insertOne({
      "date": date,
      "field": field,
      "duration": duration,
      "name": className,
      "creator": userId,
      "hour": hour,
      "discipline": discipline,
      "status": "En attente"
    });

    var competition = await collectionCours?.findOne(
        where.eq("creator", userId).eq("date", date).eq("hour", hour));

    collectionParticipations?.insertOne(
        {"user": userId, "event": competition?["_id"], "type": "class"});
  }

  createCompetition(userId, name, date, adress, image) async {
    collectionCompetition?.insertOne({
      "name": name,
      "date": date,
      "adress": adress,
      "image": image,
      "creator": userId
    });
    var competition = await collectionCompetition?.findOne(
        where.eq("creator", userId).eq("date", date).eq("adress", adress));

    collectionParticipations?.insertOne(
        {"user": userId, "event": competition?["_id"], "type": "competition"});
  }

  createParty(userId, type, name, hour, description, date, image) async {
    collectionSoirees?.insertOne({
      "creator": userId,
      "type": type,
      "name": name,
      "hour": hour,
      "description": description,
      "date": date,
      "image": image,
      "status": "En attente"
    });

    var soiree = await collectionSoirees?.findOne(
        where.eq("creator", userId).eq("date", date).eq("hour", hour));

    collectionParticipations
        ?.insertOne({"user": userId, "event": soiree?["_id"], "type": "party"});
  }

  getPlanning(userId) async {
    var participations =
        await collectionParticipations?.find(where.eq("user", userId)).toList();

    List<Map> events = [];

    for (var participation in participations!) {
      late var event;
      Map planningInfo;
      if (participation["type"] == "class") {
        event = await collectionCours
            ?.findOne(where.eq("_id", participation["event"]));
        var name = event["name"];
        var status = event["status"];
        var hour = event["hour"];
        planningInfo = {
          "date": event["date"],
          "info": "$status | $name | $hour "
        };
      } else if (participation["type"] == "party") {
        event = await collectionSoirees
            ?.findOne(where.eq("_id", participation["event"]));
        var name = event["name"];
        var status = event["status"];
        var hour = event["hour"];
        planningInfo = {
          "date": event["date"],
          "info": "$status | $name | $hour "
        };
      } else {
        event = await collectionCompetition
            ?.findOne(where.eq("_id", participation["event"]));
        var name = event["name"];
        var adress = event["adress"];
        planningInfo = {"date": event["date"], "info": "$name | $adress "};
      }
      events.add(planningInfo);
    }
    events.sort((a, b) => a["date"].compareTo(b["date"]));

    List dateList = [];
    for (var event in events) {
      dateList.add(event["date"]);
    }

    Map<DateTime, List<String>> map = {};
    int i = 0;
    while (dateList.isNotEmpty) {
      List<String> list = [];
      var date = events[i]["date"];
      while (dateList.contains(date) && events[i]["date"] == date) {
        list.add(events[i]["info"]);
        dateList.remove(events[i]["date"]);
        i++;
      }

      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      String dateStr = dateFormat.format(date);
      dateStr = "$dateStr 00:00:00.000Z";
      map.addAll({DateTime.parse(dateStr): list});

    }
    return map;
  }
  getClasses() async{
    return await collectionCours?.find().toList();
  }

  getParties() async{
    return await collectionSoirees?.find().toList();
  }

  getCompetitions() async{
    return await collectionCompetition?.find().toList();
  }

  getHorses() async{
    return await collectionChevaux?.find().toList();
  }

  getUsers() async {
    return await collectionUtilisateurs?.find().toList();
  }

  getParticipationClass(classId) async {
    return await collectionParticipations?.findOne(where.eq("event", classId));
  }

}


