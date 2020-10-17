import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_checker_app/classes/SharedPref.dart';
import 'package:ticket_checker_app/classes/User.dart';
import 'package:ticket_checker_app/screens/auth/login_screen.dart';
import 'package:ticket_checker_app/screens/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  SharedPref sharedPref = SharedPref();
  loadSharedPrefs() async {
    try {
      User user = User.userFromJson(jsonDecode(await sharedPref.read("user")));
      print(user.name);
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (Route<dynamic> route) => false,
            arguments: user);
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome screen'),
      ),
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Text('Login'),
          ),
        ),
      ),
    );
  }
}
