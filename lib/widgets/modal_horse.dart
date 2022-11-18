// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chevalhalla/db/mongodb.dart';
import '../classes/user.dart';

class ModalHorse {
  var user = User();

  void CreateHorse(BuildContext context) {
    final nameController = TextEditingController();
    final BreedController = TextEditingController();
    final DisciplineController = TextEditingController();
    final dateController = TextEditingController();
    final imageController = TextEditingController();
    final GenderController = TextEditingController();
    final ColorController = TextEditingController();

    final format = DateFormat("HH:mm");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Création d'un chevalkyrie"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez le nom du cheval',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Photo du Cheval',
                      hintText: 'Entrez le lien de la photo',
                    ),
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez la date de naissance du cheval',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.utc(1980),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  TextFormField(
                    controller: BreedController,
                    decoration: const InputDecoration(
                      hintText: 'Race du cheval',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: DisciplineController,
                    decoration: const InputDecoration(
                      hintText: 'Spécialité du cheval',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ColorController,
                    decoration: const InputDecoration(
                      hintText: 'Couleur du pelage',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                        hintText: 'Choisissez un genre',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text('Mâle'),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Femelle'),
                        ),
                        DropdownMenuItem(
                          value: 'Other',
                          child: Text('Autre'),
                        ),
                      ],
                      onChanged: (value) {
                        GenderController.text = value!;
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  MongoDatabase().createHorse(
                      nameController.text,
                      imageController.text,
                      dateController.text,
                      BreedController.text,
                      DisciplineController.text,
                      ColorController.text,
                      GenderController.text,
                      User.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }

  ChooseHorse(BuildContext context, horse, dpHorses) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Ajout d'un chevalkyrie"),
            content: Column(
              children: [
                Image.network(
                  horse["image"],
                  height: 100,
                ),
                Column(
                  children: [
                    Text("Non :" + horse["name"]),
                    Text("Race :" + horse["breed"]),
                    Text("Couleur :" + horse["coatColor"]),
                    Text("Discipline favorite :" + horse["speciality"]),
                    Text("Genre :" + horse["gender"]),
                    Text("Propriétaire :" + horse["owner_name"]),
                  ],
                ),
                if (!dpHorses.contains(horse["_id"]))
                  Row(children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        MongoDatabase().addDp(User.id, horse["_id"]);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ajouter'),
                    ),
                  ]),
                if (dpHorses.contains(horse["_id"]))
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                if (dpHorses.contains(horse["_id"]))
                  const Text("Vous avez déjà ce cheval en demi-pension")
              ],
            ),
          );
        });
  }
}
