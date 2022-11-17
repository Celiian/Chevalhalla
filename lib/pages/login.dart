import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/register.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
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
              //toggleThemeMode(); sert à changer de thème
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
                  child: TextField(
                    controller: passwordController,
                    //obscureText sert à cacher le mot de passe
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      icon: const Icon(Icons.lock),
                      labelText: 'Mot de passe',
                      hintText: 'Entrez votre mot de passe',
                      //InkWell permet de rendre le bouton cliquable
                      suffix: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(Icons.visibility),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 50, left: 16.0, right: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        //si le formulaire est valide on envoie les données à la base de données
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

  _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
      //si _isHidden est vrai, alors on affiche le mot de passe
    });
  }
}
