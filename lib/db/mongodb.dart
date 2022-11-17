// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';
import '../constant.dart';

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
      int duration, DateTime date, hour) {
    collectionCours?.insertOne({
      "date": date,
      "field": field,
      "duration": duration,
      "name": className,
      "user_id": userId,
      "hour": hour,
      "discipline": discipline
    });
  }

  createCompetition(userId, name, date, adress, image) {
    collectionCompetition?.insertOne({
      "name": name,
      "date": date,
      "adress": adress,
      "image": image,
      "creator": userId
    });
  }


  createParty(userId, type, name, hour, description, date, image){
    collectionSoirees?.insertOne({
      "creator": userId,
      "type": type,
      "name": name,
      "hour": hour,
      "description": description,
      "date": date,
      "image": image
    });

  }
}
