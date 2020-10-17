import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_checker_app/classes/SharedPref.dart';
import 'package:ticket_checker_app/classes/User.dart';
import 'package:ticket_checker_app/components/CustomSnackBar.dart';
import 'package:ticket_checker_app/functions/validators.dart';
import 'package:ticket_checker_app/screens/home_screen.dart';
import 'package:http/http.dart' as http;

login(email, password, BuildContext context) async {
  SharedPref sharedPref = SharedPref();
  String url = 'https://urbanticket.herokuapp.com/api/auth/login';
  try {
    if (!checkPass(password)) {}
    if (!validateEmail(email)) {
      return "Please enter valid email";
    }
    final http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body:
            jsonEncode(<String, String>{"email": email, 'password': password}));

    print(jsonDecode(response.body)['user']['role']);
    if (response.statusCode == 200) {
      print(response.body);
      if (jsonDecode(response.body)['user']['role'] == 'Manager') {
        User user = User.managerFromJson(jsonDecode(response.body)['user']);
        sharedPref.save("user", response.body);
        print(user);
        Scaffold.of(context)
            .showSnackBar(customSnackBar(context, "Sign in as ${user.name}"));
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (Route<dynamic> route) => false,
            arguments: user);
      } else {
        Scaffold.of(context)
            .showSnackBar(customSnackBar(context, "You are not a manager"));
      }
    }
  } catch (error) {
    print(error);

    Scaffold.of(context).showSnackBar(
        customSnackBar(context, "Failed to sign in, check your credentials"));
  }
}
