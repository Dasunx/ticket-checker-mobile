import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker_app/screens/welcome_screen.dart';

import 'classes/DarkThemeProvider.dart';
import 'classes/Routing.dart';
import 'classes/Styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Widgets',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            onGenerateRoute: Routing.generateRoute,
            initialRoute: WelcomeScreen.id,
          );
        },
      ),
    );
  }
}
