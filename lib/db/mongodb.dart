// ignore_for_file: avoid_print, await_only_futures

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
    var x = await collectionUtilisateurs?.find().toList();
    if (x != null) {
      print("connected");
    }
  }

  createUser(String name, DateTime birthdate, String level, String mail,
      String profilePicture, String status, String ffe, String password) {
    /// Crée un ustilisateur dans la base de donnée
    var date = DateTime.now();

    collectionUtilisateurs?.insertOne({
      "name": name,
      "birthdate": birthdate,
      "level": level,
      "mail": mail,
      "profil_picture": profilePicture,
      "status": status,
      "ffe": ffe,
      "password": password,
      "creation_date": date
    });
  }

  getUser(mail, password) async {
    /// Récupère un utilisateur en utilisant son mot de passe et son mail (utilisé pour la connexion)
    var user = await collectionUtilisateurs
        ?.findOne(where.eq("mail", mail).eq("password", password));
    return user;
  }

  createClass(userId, userName, String discipline, String field,
      String className, int duration, DateTime date, hour) async {
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
    collectionParticipations?.insertOne({
      "user": userId,
      "event": cours?["_id"],
      "type": "class",
      "commentary": "",
      "user_name": userName
    });
  }

  createCompetition(userId, userName, name, date, adress, image) async {
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
    collectionParticipations?.insertOne({
      "user": userId,
      "event": competition?["_id"],
      "type": "competition",
      "commentary": "",
      "user_name": userName
    });
  }

  createParty(
      userId, userName, type, name, hour, description, date, image) async {
    /// Crée une soirée dans la base de donnée
    collectionSoirees?.insertOne({
      "creator": userId,
      "type": type,
      "name": name,
      "hour": hour,
      "description": description,
      "date": date,
      "image": image,
      "status": "En attente",
      "user_name": userName
    });

    var soiree = await collectionSoirees?.findOne(
        where.eq("creator", userId).eq("date", date).eq("hour", hour));
    // Ajoute l'utilisateur en tant que participant
    collectionParticipations?.insertOne({
      "user": userId,
      "event": soiree?["_id"],
      "type": "party",
      "commentary": "",
      "user_name": userName
    });
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
      Map planningInfo = {};
      if (participation["type"] == "class") {
        print(participation["event"]);
        print(await collectionCours
            ?.findOne(where.eq("_id", participation["event"])));
        event = await collectionCours
            ?.findOne(where.eq("_id", participation["event"]));
        var name = event["name"];
        var status = event["status"];
        var hour = event["hour"].toString().split(" ")[1].split(".")[0];
        hour = "${hour.split(":")[0]}:${hour.split(":")[1]}";
        planningInfo = {
          "date": event["date"],
          "info": "$status | $name | $hour "
        };
      } else if (participation["type"] == "party") {
        event = await collectionSoirees
            ?.findOne(where.eq("_id", participation["event"]));
        var name = event["name"];
        var status = event["status"];
        var hour = event["hour"].toString().split(" ")[1].split(".")[0];
        hour = "${hour.split(":")[0]}:${hour.split(":")[1]}";
        planningInfo = {
          "date": event["date"],
          "info": "$status | $name | $hour "
        };
      } else if (participation["type"] == "competition") {
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
    /// Ainsi que les utilisateurs crée
    List events = [];

    Map planningInfo = {};

    List listClass = (await collectionCours?.find().toList())!;
    for (var event in listClass) {
      if (event["date"].compareTo(DateTime.now()) >= 0) {
        planningInfo = {"date": event["date"], "info": event};
        events.add(planningInfo);
      }
    }
    List listCompetition = (await collectionCompetition?.find().toList())!;
    for (var event in listCompetition) {
      if (event["date"].compareTo(DateTime.now()) >= 0) {
        planningInfo = {"date": event["date"], "info": event};
        events.add(planningInfo);
      }
    }
    List listParty = (await collectionSoirees?.find().toList())!;
    for (var event in listParty) {
      if (event["date"].compareTo(DateTime.now()) >= 0) {
        planningInfo = {"date": event["date"], "info": event};
        events.add(planningInfo);
      }
    }
    List listUsers = (await collectionUtilisateurs?.find().toList())!;
    for (var user in listUsers) {
      if (user["creation_date"].compareTo(DateTime.now()) >= 0 ||
          user["creation_date"]
                  .compareTo(DateTime.now().add(const Duration(days: 1))) >=
              0) {
        user["date"] = user["creation_date"];
        planningInfo = {"date": user["date"], "info": user};
        events.add(planningInfo);
      }
    }

    events.sort((a, b) => a["date"].compareTo(b["date"]));
    return events;
  }

  checkParticipation(userId, eventId, type) async {
    var x = await collectionParticipations?.findOne(
        where.eq("user", userId).eq("event", eventId).eq("type", type));

    if (x?["user"] == null) {
      return false;
    } else {
      return true;
    }
  }

  getParticipations(eventId) async {
    var x = await collectionParticipations
        ?.find(where.eq("event", eventId))
        .toList();
    return x;
  }

  createParticipation(userId, userName, eventId, type, commentary) {
    collectionParticipations?.insertOne({
      "user": userId,
      "event": eventId,
      "type": type,
      "commentary": commentary,
      "user_name": userName
    });
  }

  createParticipationCompetition(
      userId, userName, eventId, type, commentary, level) {
    collectionParticipations?.insertOne({
      "user": userId,
      "event": eventId,
      "type": type,
      "commentary": commentary,
      "user_name": userName,
      "level": level
    });
  }

  cancelParticipation(userId, eventId) {
    collectionParticipations?.deleteOne({"user": userId, "event": eventId});
  }

  getAllHorses() async {
    var horses = await collectionChevaux?.find().toList();
    return horses;
  }


  getDpId(userId) async {
    var dp = await collectionDemiPensionnaires?.find(where.eq("user", userId)).toList();
    List horses = [];
    for (var singleDp in dp!){
      var horse = (await collectionChevaux?.findOne(where.eq("_id", singleDp["horse"])));
      horses.add(horse?["_id"]);
    }
    return horses;
  }

  getHorses(owner) async {
    var horses =
        await collectionChevaux?.find(where.eq("owner", owner)).toList();
    return horses;
  }

  createHorse(name, image, birthdate, breed, discipline, color, genre, owner) {
    collectionChevaux?.insertOne({
      "name": name,
      "image": image,
      "birthdate": birthdate,
      "breed": breed,
      "speciality": discipline,
      "coatColor": color,
      "gender": genre,
      "owner": owner
    });
  }

  addDp(userId, horseId) {
    collectionDemiPensionnaires?.insertOne({"user": userId, "horse": horseId});
  }
}
