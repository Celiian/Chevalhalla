import 'package:chevalhalla/db/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../classes/user.dart';

class ModalEvent {
  var user = User();

  void modalChoice(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 100.0),
                  child: Text('Que voulez-vous créer ?',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                ),
                ListTile(
                    title: const Text(
                      'Un Cours',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () =>
                        {Navigator.pop(context), createCours(context)}),
                ListTile(
                  title: const Text('Une Compétition',
                      textAlign: TextAlign.center),
                  onTap: () =>
                      {Navigator.pop(context), createCompetition(context)},
                ),
                ListTile(
                  title: const Text('Une Soirée', textAlign: TextAlign.center),
                  onTap: () => {
                    Navigator.pop(context),
                    CreateSoiree(context),
                  },
                ),
              ],
            ),
          );
        });
  }

  void CreateSoiree(BuildContext context) {
    final typeController = TextEditingController();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final hourController = TextEditingController();
    final dateController = TextEditingController();
    final imageController = TextEditingController();

    final format = DateFormat("HH:mm");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Création d\'une soirée'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Type de soirée',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Apéro',
                          child: Text('Apéro'),
                        ),
                        DropdownMenuItem(
                          value: 'Repas',
                          child: Text('Repas'),
                        ),
                      ],
                      onChanged: (value) {
                        typeController.text = value!;
                      }),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez le nom de la soirée',
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
                      labelText: 'Photo de la soirée',
                      hintText: 'Entrez le lien de la photo',
                    ),
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez la date de la soirée',
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  DateTimeField(
                    format: format,
                    decoration: const InputDecoration(
                      label: Text(
                        'Entrez l\'heure de la soirée',
                      ),
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      hourController.text =
                          DateTimeField.convert(time).toString();
                      return DateTimeField.convert(time);
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description de la soirée',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
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
                  MongoDatabase().createParty(
                    User.id,
                    typeController.text,
                    nameController.text,
                    hourController.text,
                    descriptionController.text,
                    DateTime.parse(dateController.text),
                    imageController.text
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }

  void createCours(BuildContext context) {
    final fieldController = TextEditingController();
    final nameController = TextEditingController();
    final disciplineController = TextEditingController();
    final durationController = TextEditingController();
    final hourController = TextEditingController();
    final dateController = TextEditingController();

    final format = DateFormat("HH:mm");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Création d\'un cours'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: 'Discipline',
                        hintText: 'Choisissez une discipline',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Dressage',
                          child: Text('Dressage'),
                        ),
                        DropdownMenuItem(
                          value: 'Saut d’obstacle',
                          child: Text('Saut d’obstacle'),
                        ),
                        DropdownMenuItem(
                          value: 'Endurance',
                          child: Text('Endurance'),
                        ),
                      ],
                      onChanged: (value) {
                        disciplineController.text = value!;
                      }),
                  DropdownButtonFormField(
                      decoration: const InputDecoration(
                        hintText: 'Choisissez le terrain',
                        labelText: 'Terrain',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Carrière',
                          child: Text('Carrière'),
                        ),
                        DropdownMenuItem(
                          value: 'Manège',
                          child: Text('Manège'),
                        ),
                      ],
                      onChanged: (value) {
                        fieldController.text = value!;
                      }),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom du cours',
                      hintText: 'Entrez le nom du cours',
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
                        labelText: 'Durée du cours',
                        hintText: 'Durée du cours',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "60",
                          child: Text('1h'),
                        ),
                        DropdownMenuItem(
                          value: "30",
                          child: Text('30min'),
                        ),
                      ],
                      onChanged: (value) {
                        durationController.text = value!;
                      }),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez la date du cours',
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  DateTimeField(
                    controller: hourController,
                    format: format,
                    decoration: const InputDecoration(
                      labelText: 'Heure du cours',
                      hintText: 'Entrez l\'heure du cours',
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      disciplineController.text =
                          DateTimeField.convert(time).toString();
                      return DateTimeField.convert(time);
                    },
                  ),
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
                  MongoDatabase().createClass(
                      User.id,
                      disciplineController.text,
                      fieldController.text,
                      nameController.text,
                      int.parse(durationController.text),
                      DateTime.parse(dateController.text),
                      hourController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }

  void createCompetition(BuildContext context) {
    final imageController = TextEditingController();
    final nameController = TextEditingController();
    final adressController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Création d\'une compétition'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Photo de la compétition',
                      hintText: 'Entrez le lien de la photo',
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la compétition',
                      hintText: 'Entrez le nom de la compétition',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: adressController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse de la compétition',
                      hintText: 'Entrez l\'adresse de la compétition',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez la date de la compétition',
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        final String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Afficher les participants')),
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
                  MongoDatabase().createCompetition(
                      User.id,
                      nameController.text,
                      DateTime.parse(dateController.text),
                      adressController.text,
                      imageController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }
}
