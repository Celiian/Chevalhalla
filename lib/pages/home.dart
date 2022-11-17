// ignore_for_file: avoid_print

import 'package:chevalhalla/classes/user.dart';
import 'package:chevalhalla/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:chevalhalla/pages/register.dart';


class HomePage extends StatefulWidget {
  static const tag = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Home page navigator
      } else if (_currentIndex == 1) {
        //Planning page navigator
      }
      else if (_currentIndex == 2) {
        //Profile page navigator
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form page"),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Register.tag);
              },
              child: const Text('Inscription'),
            ),
          ],
        ),

          child: Column(
        children: [
          TextButton(
            onPressed: () {},
            child: const Text("Home Page"),
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex, // new
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],

      ),
    );
  }
}
