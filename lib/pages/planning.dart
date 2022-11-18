// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/db/mongodb.dart';
import 'package:chevalhalla/pages/home.dart';
import 'package:chevalhalla/pages/profil.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/modal_event.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chevalhalla/widgets/modal_event.dart';
import 'admin/Index_Admin.dart';

class PlanningPage extends StatefulWidget {
  static const tag = "planning_page";

  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  late ValueNotifier<List<String>> _selectedEvents;
  Map<DateTime, List<String>> events = {};

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late var cours;

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    getData();
  }

  getData() async {
    // Récupère les données des events et "rafraichit" la page pour les afficher dans le calendirer
    events = await MongoDatabase().getPlanning(User.id);

    setState(() {
      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<String> _getEventsForDay(DateTime day) {
    // Récupere les evenement d'un jour
    return events[day] ?? [];
  }

  getCours() async {}

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  void onTabTapped(int index) {
    // Gère les "tap" sur la bottom nav pour rediriger entre les différentes pages
    setState(() {
      _currentIndex = index;
      if(User.status == 'Cavalier'){

        if (_currentIndex == 0) {
          //Page d'accueil
          Navigator.of(context)
              .pushNamed(HomePage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 1) {
          Navigator.of(context)
              .pushNamed(PlanningPage.tag)
              .then((_) => setState(() {}));      }
        else if (_currentIndex == 2) {
          //page profil utilisateur
        }
      }
      else {
        if (_currentIndex == 0) {
          //Page d'accueil
          Navigator.of(context)
              .pushNamed(HomePage.tag)
              .then((_) => setState(() {}));
        } else if (_currentIndex == 1) {
        }
        else if (_currentIndex == 2) {
          //page profil utilisateur
          Navigator.of(context)
              .pushNamed(IndexAdmin.tag)
              .then((_) => setState(() {}));
        }
        else if (_currentIndex == 3) {
          //page profil utilisateur
          Navigator.of(context)
              .pushNamed(ProfilPage.tag)
              .then((_) => setState(() {}));
        }
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chelavkyries"), actions: <Widget>[
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
          child: Column(
        children: [
          TableCalendar<String>(
            locale: 'fr_Fr',
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 10, 16),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: true,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print(value[index]),
                        title: Text(value[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ModalEvent().modalChoice(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex, // new
        items:  [
          if (User.status == 'admin')...
          [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",backgroundColor: Colors.blue,tooltip: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning",backgroundColor: Colors.blue,tooltip: "Planning"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "admin",backgroundColor: Colors.blue,tooltip: "admin"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil",backgroundColor: Colors.blue,tooltip: "Profil")]
          else ...
          [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil",),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Planning"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil")]
        ],
      ),
    );
  }
}
