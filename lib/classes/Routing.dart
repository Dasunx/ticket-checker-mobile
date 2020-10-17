import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_checker_app/screens/auth/login_screen.dart';
import 'package:ticket_checker_app/screens/welcome_screen.dart';

class Routing {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case WelcomeScreen.id:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case LoginScreen.id:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'no routes for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
