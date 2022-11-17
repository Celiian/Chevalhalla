import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  var user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Connexion"), actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.lightbulb_sharp,
            ),
            tooltip: 'Changer de thème',
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
          ),
        ]),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: mailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      icon: Icon(Icons.mail),
                      labelText: 'Adresse mail',
                      hintText: 'Entrez votre adresse mail',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez une adresse mail valide';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      icon: Icon(Icons.lock),
                      labelText: 'Mots de passe',
                      hintText: 'Entrez votre mots de passe',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez un mots de passe valide';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50, left: 16.0, right: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          user.decodeJson(await MongoDatabase().getUser(
                              mailController.text, passwordController.text));
                          Navigator.of(context)
                              .pushNamed(
                                HomePage.tag,
                              )
                              .then((_) => setState(() {}));
                        }
                      },
                      child: const Text('Se connecter'),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    child: const Text("Je n'ai pas de compte"),
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPage.tag);
                    },
                  ),
                ),
              ],
            ),
          ),
        ])));
  }
}
