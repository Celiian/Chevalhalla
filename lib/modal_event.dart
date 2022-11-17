import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class ModalEvent {
  void modalChoice(BuildContext context, _dateController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 100.0),
                  child: Text('Que voullez-vous crée ?',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                ),
                ListTile(
                    title: const Text(
                      'Un Cours',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () => {
                          Navigator.pop(context),
                          CreateCours(context, _dateController)
                        }),
                ListTile(
                  title: const Text('Un Concour', textAlign: TextAlign.center),
                  onTap: () =>
                      {Navigator.pop(context), CreateCompetition(context)},
                ),
                ListTile(
                  title: const Text('Une Soirée', textAlign: TextAlign.center),
                  onTap: () => {
                    Navigator.pop(context),
                    CreateSoiree(context, _dateController),
                  },
                ),
              ],
            ),
          );
        });
  }

  void CreateSoiree(BuildContext context, _dateController) {
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
                      onChanged: (value) {}),
                  TextFormField(
                    //controller: ,
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
                    controller: _dateController,
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
                            DateFormat('dd-MM-yyyy').format(date);
                        _dateController.text = formattedDate;
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
                      return DateTimeField.convert(time);
                    },
                  ),
                  TextFormField(
                    //controller: ,
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
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }

  void CreateCours(BuildContext context, _dateController) {
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
                      onChanged: (value) {}),
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
                      onChanged: (value) {}),
                  TextFormField(
                    //controller: ,
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
                          value: 60,
                          child: Text('1h'),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text('30min'),
                        ),
                      ],
                      onChanged: (value) {}),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date du cours',
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
                            DateFormat('dd-MM-yyyy').format(date);
                        _dateController.text = formattedDate;
                      }
                    },
                  ),
                  DateTimeField(
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
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }

  void CreateCompetition(BuildContext context) {
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
                    //controller: ,
                    decoration: const InputDecoration(
                      labelText: 'Photo de la compétition',
                      hintText: 'Entrez le lien de la photo',
                    ),
                  ),
                  TextFormField(
                    //controller: ,
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
                    //controller: ,
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
                    //controller: ,
                    decoration: const InputDecoration(
                      hintText: 'Entrez du concours',
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
                        DateFormat('dd-MM-yyyy').format(date);
                        //_dateController.text = formattedDate;
                      }
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child:
                      Text('Afficher les participants')),
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
                  Navigator.of(context).pop();
                },
                child: const Text('Créer'),
              ),
            ],
          );
        });
  }
}
