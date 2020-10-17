import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_checker_app/classes/DarkThemeProvider.dart';
import 'package:ticket_checker_app/classes/SharedPref.dart';
import 'package:ticket_checker_app/classes/User.dart';

import 'package:ticket_checker_app/screens/auth/login_screen.dart';
import 'package:ticket_checker_app/screens/home_screen.dart';

class CustomDrawer extends StatefulWidget {
  final String id;
  final User user;

  const CustomDrawer({
    Key key,
    this.id,
    this.user,
  }) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  SharedPref sharedPref = SharedPref();
  User user;

  loadUser() async {
    var userJson = await sharedPref.read("user");
    if (userJson == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } else {
      setState(() {
        user = User.userFromJson(jsonDecode(userJson));
      });
    }
  }

  @override
  void initState() {
    setState(() {
      user = widget.user;
    });

    //loadUser();
    super.initState();
  }

  void makeRoutes(BuildContext context, String changeId) {
    Navigator.pop(context);
    if (widget.id != changeId) {
      if (widget.id == HomeScreen.id) {
        Navigator.pushNamed(context, changeId);
      } else {
        Navigator.popAndPushNamed(context, changeId);
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor:
              themeChange.darkTheme ? Color(0xff0E1D36) : Colors.white),
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 12,
              child: ListView(
                //remove all padding from listview
                padding: const EdgeInsets.all(0.0),
                children: [
                  UserAccountsDrawerHeader(
                    margin: EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    accountName: Text(
                      user != null ? user.name : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: Text(
                      user != null ? user.email : '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        user != null ? user.name[0] : 'D',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment
                            .bottomRight, // 10% of the width, so there are ten blinds.

                        tileMode: TileMode.clamp,
                        stops: [0.5, 1.0],
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.

                          Color(0xff0039a6),

                          Color(0xff00008B),
                        ], // red to yellow
                        // repeats the gradient over the canvas
                      ),
                      // image: DecorationImage(
                      //   image: NetworkImage(
                      //       'https://image.freepik.com/free-vector/abstract-wallpaper-concept_23-2148479714.jpg'),
                      //   fit: BoxFit.fitWidth,
                      // ),
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(
                  themeChange.darkTheme
                      ? Icons.brightness_high
                      : Icons.brightness_3,
                  size: 30.0,
                ),
                title: Row(
                  children: [
                    Text("Dark Theme"),
                    Spacer(),
                    CupertinoSwitch(
                      value: themeChange.darkTheme,
                      onChanged: (value) {
                        themeChange.darkTheme = value;
                      },
                    ),
                  ],
                ),
                onTap: () {
                  themeChange.darkTheme = !themeChange.darkTheme;
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  size: 30.0,
                ),
                title: Text("Sign Out"),
                onTap: () async {
                  await sharedPref.remove("user");
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.id,
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  final String title;

  const DrawerListTile({Key key, this.icon, this.onPress, this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.red,
        size: 36.0,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      onTap: onPress,
    );
  }
}
