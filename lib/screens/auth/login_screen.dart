import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ticket_checker_app/classes/SharedPref.dart';
import 'package:ticket_checker_app/classes/User.dart';
import 'package:ticket_checker_app/components/CustomSnackBar.dart';
import 'package:ticket_checker_app/components/ModalProgressHud.dart';
import 'package:ticket_checker_app/functions/validators.dart';

import '../home_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SharedPref sharedPref = SharedPref();
  String email;
  String password;
  bool isLoading = false;
  bool _emailValidator = false;
  String emailError;
  bool _passWordValidator = false;
  String passwordError;

  login(email, password, BuildContext context) async {
    SharedPref sharedPref = SharedPref();
    String url = 'https://urbanticket.herokuapp.com/api/auth/login';
    try {
      if (!checkPass(password)) {
        setState(() {
          passwordError = 'minimum password length is 8';
          _passWordValidator = true;
          isLoading = false;
        });
      }
      if (!validateEmail(email)) {
        return "Please enter valid email";
      }
      final http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              <String, String>{"email": email, 'password': password}));

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
          setState(() {
            _passWordValidator = false;
            _emailValidator = false;
            isLoading = false;
          });
        } else {
          setState(() {
            emailError = "You are not a manager";
            _emailValidator = true;
            isLoading = false;
          });
          Scaffold.of(context)
              .showSnackBar(customSnackBar(context, "You are not a manager"));
        }
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context).showSnackBar(
          customSnackBar(context, "Failed to sign in, check your credentials"));
    }
  }

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
    double keyboardH = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Builder(
          builder: (BuildContext context) {
            return ModalProgressHUD(
              inAsyncCall: isLoading,
              child: Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      const Color(0xFF3366FF),
                      const Color(0xFF00CCFF),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment.center,
                      height: keyboardH > 0
                          ? 0
                          : (MediaQuery.of(context).size.height / 5) * 3,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.fastOutSlowIn,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Image(
                                image: AssetImage("images/Address-bro.png"),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(keyboardH > 0 ? 0 : 40),
                            topLeft: Radius.circular(keyboardH > 0 ? 0 : 40),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: keyboardH > 0 ? 80 : 40, left: 30, right: 30),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child: Theme(
                                  data: ThemeData(),
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        _emailValidator = false;
                                      });
                                    },
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        errorText:
                                            _emailValidator ? emailError : null,
                                        prefixIcon: Icon(Icons.person),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1)),
                                        border: OutlineInputBorder(),
                                        labelText: "Email",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Theme(
                                  data: ThemeData(),
                                  child: TextField(
                                    obscureText: true,
                                    onTap: () {
                                      setState(() {
                                        _passWordValidator = false;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        errorText: _passWordValidator
                                            ? passwordError
                                            : null,
                                        prefixIcon: Icon(Icons.remove_red_eye),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1)),
                                        labelText: "Password",
                                        // errorText:
                                        // emailValidation ? "Add Valid Email" : null,
                                        errorBorder: OutlineInputBorder()
                                            .copyWith(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                color: Color(0XFFFF7A2A),
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await login(email, password, context);
                                },
                              ),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 34, vertical: 8),
                                color: Colors.blue,
                                child: Text(
                                  "create Local account",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                color: Colors.blue,
                                child: Text(
                                  "create Foreigner account",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
