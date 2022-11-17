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
    /// Crée un ustilisateur dans la base de donnée
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
    /// Récupère un utilisateur en utilisant son mot de passe et son mail (utilisé pour la connexion)
    var user = await collectionUtilisateurs
        ?.findOne(where.eq("mail", mail).eq("password", password));
    return user;
  }

  createClass(userId, String discipline, String field, String className,
      int duration, DateTime date, hour) async {
    /// Crée un cours dans la base de donnée
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

    var cours = await collectionCours?.findOne(
        where.eq("creator", userId).eq("date", date).eq("hour", hour));
    // Ajoute l'utilisateur en tant que participant
    collectionParticipations?.insertOne(
        {"user": userId, "event": cours?["_id"], "type": "class"});
  }

  createCompetition(userId, name, date, adress, image) async {
    /// Crée une competition dans la base de donnée
    collectionCompetition?.insertOne({
      "name": name,
      "date": date,
      "adress": adress,
      "image": image,
      "creator": userId
    });
    var competition = await collectionCompetition?.findOne(
        where.eq("creator", userId).eq("date", date).eq("adress", adress));
    // Ajoute l'utilisateur en tant que participant
    collectionParticipations?.insertOne(
        {"user": userId, "event": competition?["_id"], "type": "competition"});
  }

  createParty(userId, type, name, hour, description, date, image) async {
    /// Crée une soirée dans la base de donnée
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
    // Ajoute l'utilisateur en tant que participant
    collectionParticipations
        ?.insertOne({"user": userId, "event": soiree?["_id"], "type": "party"});
  }

  getPlanning(userId) async {
    /// Cette fonction permet d'envoyer au planning un dictionnaire associant une
    /// journée  (DateTime) à une liste d'évenement (String) pour les afficher
    /// dans le calendrier.
    var participations =
        await collectionParticipations?.find(where.eq("user", userId)).toList();
    // Récupère toutes les participation à un évènement de l'utilisateur
    List<Map> events = [];

    for (var participation in participations!) {
      /// Cette boucle va, pour chaque type d'évenement (class, party, competition),
      /// aller récupérer les informations de l'évenement dans leur table de la bdd
      /// puis les ranger dans un dictionnaire :
      /// ( "date" : date de l'event, "info": informations de l'evenement)
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
    // Trie les evenements par date croissante (permet de les regrouper par jour pour la suite)

    List dateList = [];
    for (var event in events) {
      dateList.add(event["date"]);
    }
    // Crée une liste avec chaque date existantes d'un évenement (avec doublons)

    Map<DateTime, List<String>> map = {};
    int i = 0;
    while (dateList.isNotEmpty) {
      /// Utilise la liste de date pour remplir le dictionnaire avec en clé une date
      /// et en valeur la liste des évenements.
      List<String> list = [];
      var date = events[i]["date"];
      while (dateList.contains(date) && events[i]["date"] == date) {
        // Cette partie permet de regrouper les evenement ayant la même date dans la même liste
        // la boucle continue d'ajouter des evenements dans la liste temporaire
        // tant qu'il reste cette date dans la liste de date
        list.add(events[i]["info"]);
        dateList.remove(events[i]["date"]);
        i++;
      }

      //Formatage pour adapter les dates au calendrier
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      String dateStr = dateFormat.format(date);
      dateStr = "$dateStr 00:00:00.000Z";
      map.addAll({DateTime.parse(dateStr): list});
    }
    return map;
  }

  getTimeline() async {
    /// Récupère tous les évenements existants triés par date
    var participations =
        await collectionParticipations?.find().toList();

    List events = [];

    for (var participation in participations!) {
      late var event;
      Map planningInfo;
      if (participation["type"] == "class") {
        event = await collectionCours
            ?.findOne(where.eq("_id", participation["event"]));

        planningInfo = {"date": event["date"], "info": event};
      } else if (participation["type"] == "party") {
        event = await collectionSoirees
            ?.findOne(where.eq("_id", participation["event"]));

        planningInfo = {"date": event["date"], "info": event};
      } else {
        event = await collectionCompetition
            ?.findOne(where.eq("_id", participation["event"]));
        planningInfo = {"date": event["date"], "info": event};
      }
      events.add(planningInfo);
    }
    events.sort((a, b) => a["date"].compareTo(b["date"]));

    return events;
  }
}
