// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/material.dart';
import 'constant.dart';

class MongoDatabase {
  static DbCollection? collectionUtilisateurs;
  static DbCollection? collectionChevaux;
  static DbCollection? collectionConcours;
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
    collectionConcours = db.collection(COLLECTION_CONCOURS);
    collectionCours = db.collection(COLLECTION_COURS);
    collectionDemiPensionnaires = db.collection(COLLECTION_DP);
    collectionParticipations = db.collection(COLLECTION_PARTICIPATIONS);
    collectionSoirees = db.collection(COLLECTION_SOIREES);

    if (await collectionUtilisateurs?.find().toList() != null){
      print("connected");
    }
  }



  getUser(mail, password) async {
    var user = await collectionUtilisateurs?.findOne(where.eq("mail", mail).eq("password", password));
    print(user);
    return user;
  }

}