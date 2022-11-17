import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/user.dart';

class RegisterPage extends StatefulWidget {
  static const tag = 'register_page';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isHidden = true;
  var user = User();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _birthday = TextEditingController();
  final _mail = TextEditingController();
  final _level = TextEditingController();
  final _linkFFE = TextEditingController();
  final _profilePicture = TextEditingController();
  final _status = TextEditingController();
  final _password = TextEditingController();

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
      body:
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _profilePicture,
                decoration: const InputDecoration(
                  hintText: 'https://image.png',
                  label: Text("Lien Photo de profils"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),

              ),
            ), Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  label: Text("Nom"),
                  hintText: 'Nom Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 20.0, right: 20.0),
                child: TextFormField(
                  controller: _birthday,
                  decoration: const InputDecoration(
                    labelText: "Enter Date",
                    hintText: "06-12-2000",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                  ),
                  //readOnly sert à rendre le champ non modifiable en ecrit
                  readOnly: true,

                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                    );

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(
                          pickedDate);

                      setState(() {
                        _birthday.text = formattedDate;
                      });
                    }
                  },
                )
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _mail,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  hintText: 'exemple@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, left: 20.0, right: 20.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    label: Text("Votre Niveau"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _level.text = newValue!;
                    });
                  },
                  items: <String>['Amateur', 'Club1', 'Club2', 'Club3', 'Club4']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _linkFFE,
                decoration: const InputDecoration(
                  label: Text("Lien FFE"),
                  hintText: 'https://www.ffe.com/#users',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, left: 20.0, right: 20.0),
              child: TextField(
                controller: _password,
                //obscureText sert à cacher le mot de passe
                obscureText: _isHidden,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: 'Password',
                  labelText: 'Password',
                  //Affiche un bouton pour cacher ou afficher le mot de passe
                  suffix: InkWell(
                    onTap: _togglePasswordView,
                    child: Icon(
                      _isHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    user.createUser(
                        _name.text,
                        _birthday.text,
                        _level.text,
                        _mail.text,
                        _profilePicture.text,
                        "cavalier",
                        _linkFFE.text,
                        _password.text);
                    Navigator.of(context)
                        .pushNamed(
                      HomePage.tag,
                    )
                        .then((_) => setState(() {}));
                  }
                },
                child: const Text('Inscription'),
              ),
            ),
            TextButton(
              child: const Text("J'ai déjà un compte"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Fonction pour cacher le mot de passe
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}