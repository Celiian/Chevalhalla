import 'dart:ui';

import 'package:flutter/material.dart';

class User {
  late var name= "";
  var birthdate= "";
  var level= "";
  var mail= "";
  var profilePicture= "";
  final themeColor= "blue";
  var status= "";
  var linkFFE= "";
 var password= "";
  
  
  decodeJson(json){
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