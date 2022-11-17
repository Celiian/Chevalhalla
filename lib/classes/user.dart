import 'dart:ffi';

import 'package:chevalhalla/db/mongodb.dart';
import 'package:intl/intl.dart';

// Classe User qui représente un utilisateur
class User {
  static var name = "";
  static var birthdate = DateTime.utc(2000, 12, 31);
  static var level = "";
  static var mail = "";
  static String profilePicture = "";
  static var themeColor = "blue";
  static var status = "";
  static var ffe = "";
  static var password = "";

  // Constructeur de la classe User
  createUser(newName, newBirthdate, newLevel, newMail, newProfilePicture, newStatus, newFfe, newPassword){
    name = newName;
    birthdate = DateTime.parse(newBirthdate);
    level = newLevel;
    mail = newMail;
    profilePicture = newProfilePicture;
    status = newStatus;
    ffe = newFfe;
    password = newPassword;

    MongoDatabase().createUser(name, birthdate, level, mail, profilePicture, status, ffe, password);
  }

  // Fonction qui permet de récupérer les informations d'un utilisateur
  decodeJson(json) {
    name = json?["name"];
    mail = json?["mail"];
    password = json?["password"];
    level = json["level"];
    birthdate = json["birthdate"];
    profilePicture = json["profil_picture"];
    status = json["status"];
    ffe = json["ffe"];
  }

  // Fonction qui permet de convertir un utilisateur en String
  @override
  String toString() {
    return 'User{$name, $mail, $birthdate}';
  }
}
