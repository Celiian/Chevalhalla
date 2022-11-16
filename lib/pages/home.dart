import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/mongodb.dart';
//import 'package:chevalhalla/pages/register.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  var user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Connection"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Connectez-vous',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.alphabetic,
                    fontStyle: FontStyle.italic,
                    fontFamilyFallback: ['Times New Roman'],
                    decoration: TextDecoration.underline,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 30.0),
                        child: TextFormField(
                          controller: mailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Entrez votre mot de passe ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              user.decodeJson( await MongoDatabase().getUser(mailController.text, passwordController.text));
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Register(title: 'Inscription')),
                          );*/
                        },
                        child: const Text('Pas encore inscrit ?'),
                      ),
                    ],
                  ),
                ),
          ]),
        ));
  }
}
