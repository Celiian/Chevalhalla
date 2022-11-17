import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';


class ModalEvent{

  void modalChoice(BuildContext context, _dateController) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 100.0),
                  child: Text('Que voullez-vous crée ?', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                ),
                ListTile(
                    title: const Text('Un Cours', textAlign: TextAlign.center,),
                    onTap: () => {
                      Navigator.pop(context),
                      //_modalCours(context),
                    }),
                ListTile(
                  title: const Text('Un Concour', textAlign: TextAlign.center),
                  onTap: () => {
                    Navigator.pop(context),
                    //_modalConcour(context),
                  },
                ),
                ListTile(
                  title: const Text('Une Soirée', textAlign: TextAlign.center),
                  onTap: () =>
                  {
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
                      hintText: 'Entrez la date de la soirée',),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2100)
                      );
                      if (date != null) {
                        final String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                        _dateController.text = formattedDate;
                      }
                    },
                  ),
                  DateTimeField(
                    format: format,
                    decoration:
                    const InputDecoration(
                      label: Text('Entrez la date de la soirée',),
                    ),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.convert(time);
                    },
                  ),
                  TextFormField(
                    //controller: ,
                    decoration: const InputDecoration(
                      hintText: 'Entrez le lieu de la soirée',),
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
                      hintText: 'Entrez le nombre de places',),
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
}