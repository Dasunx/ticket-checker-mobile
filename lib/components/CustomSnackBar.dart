import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker_app/classes/DarkThemeProvider.dart';

SnackBar customSnackBar(BuildContext context, String message) {
  return SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(message, style: TextStyle(color: Colors.black, fontSize: 16)),
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
    behavior: SnackBarBehavior.floating,
  );
}
