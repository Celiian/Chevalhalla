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
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  var user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Form page"),
        ),
        body: Center(
            child: Column(children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: mailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Mail',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre mot de passe ',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                TextButton(
                  child: const Text("Je n'ai pas de compte"),
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterPage.tag);
                  },
                ),
              ],
            ),
          ),
        ])));
  }
}
