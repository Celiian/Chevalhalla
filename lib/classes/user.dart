import 'package:chevalhalla/mongodb.dart';

class User {
  late var name = "";
  var birthdate = "";
  var level = "";
  var mail = "";
  var profilePicture = "";
  var themeColor = "blue";
  var status = "";
  var linkFFE = "";
  var password = "";

  User.create(
      this.name,
      this.birthdate,
      this.level,
      this.mail,
      this.profilePicture,
      this.status,
      this.linkFFE,
      this.password)
  {
    MongoDatabase.collectionUtilisateurs?.insertOne(toJson());
  }

  decodeJson(json) {
    name = json["name"];
    birthdate = json["birthdate"];
    level = json["level"];
    mail = json["mail"];
    profilePicture = json["profilePicture"];
    status = json["status"];
    linkFFE = json["linkFFE"];
    password = json["password"];
  }

  toJson() {
    return '{ "name": name, "birthdate": birthdate, "level": level, "mail": mail, "profilePicture": profilePicture,"status": status,"linkFFE": linkFFE, "password": password}';
  }
}
