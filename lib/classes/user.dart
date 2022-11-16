import 'dart:ui';

import 'package:flutter/material.dart';

class User {
  static var name = "";
  static var birthdate = "";
  static var level = "";
  static var mail = "";
  static var profilePicture = "";
  static var themeColor = "blue";
  static var status = "";
  static var linkFFE = "";
  static var password = "";

  decodeJson(json) {
    name = json?["name"];
    mail = json?["mail"];
    password = json?["password"];
    //level = json["level"];
    //birthdate = json["birthdate"];
    //profilePicture = json["profilePicture"];
    //status = json["status"];
    //linkFFE = json["linkFFE"];
  }
}
