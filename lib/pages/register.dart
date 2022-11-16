import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  static const tag = 'register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _birthday = TextEditingController();
  final _mail = TextEditingController();
  final _level = TextEditingController();
  final _linkFFE = TextEditingController();
  final _profilePicture = TextEditingController();
  final status = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire'),
      ),
      body:
          Form(
            key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
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
            ),Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
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
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _birthday,
                decoration: const InputDecoration(
                    labelText: "Enter Date",
                    hintText: "06-12-2000",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),

                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context, initialDate: DateTime.now(),
                      firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );

                  if(pickedDate != null ){
                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

                    setState(() {
                      _birthday.text = formattedDate;
                    });
                  }
                },
              )
                ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _mail,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  hintText: 'prenom@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
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
                items: <String>['Amateur','Club1','Club2','Club3','Club4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
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
             //create DropdownButton
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("Status"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    status.text = newValue!;
                  });
                },
                items: <String>['Cavalier', 'Gérant']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  label: Text("Mot de passe"),
                  hintText: '********',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('Inscription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}