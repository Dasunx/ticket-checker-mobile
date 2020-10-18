import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_checker_app/classes/DarkThemeProvider.dart';
import 'package:ticket_checker_app/classes/Fine.dart';
import 'package:ticket_checker_app/classes/SharedPref.dart';
import 'package:ticket_checker_app/classes/User.dart';
import 'package:ticket_checker_app/classes/UserDetails.dart';
import 'package:ticket_checker_app/components/DottedLine.dart';
import 'package:ticket_checker_app/components/ModalProgressHud.dart';

class FineHistory extends StatefulWidget {
  static const String id = 'fine_history';
  final User manager;

  const FineHistory({Key key, this.manager}) : super(key: key);
  @override
  _FineHistoryState createState() => _FineHistoryState();
}

class _FineHistoryState extends State<FineHistory> {
  List<Fine> items;
  String url = "https://urbanticket.herokuapp.com/api/fine/";
  List<Fine> paidItems;
  List<Fine> currentItems;
  bool isLoading = false;
  Future<List<Fine>> loadFines() async {
    SharedPref sharedPref = SharedPref();
    User user = User.userFromJson(jsonDecode(await sharedPref.read("user")));
    final http.Response response =
        await http.get(url + widget.manager.userId, headers: <String, String>{
      'Content-Type': 'application/json',
    });
    List<Fine> fines;
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['journeyHistory']);
      fines = await managerFineListFromJson(jsonDecode(response.body));
      print(fines[0].amount);
    }
    setState(() {
      isLoading = false;
    });
    paidItems = fines
        .where((element) => element.paid == true)
        .toList()
        .reversed
        .toList();
    currentItems = fines
        .where((element) => element.paid == false)
        .toList()
        .reversed
        .toList();
    return fines;
  }

  Future<void> _getData() async {
    setState(() {
      isLoading = true;
    });
    List<Fine> tempItems = await loadFines();
    setState(() {
      items = tempItems;
      paidItems = items
          .where((element) => element.paid == true)
          .toList()
          .reversed
          .toList();
      currentItems = items
          .where((element) => element.paid == false)
          .toList()
          .reversed
          .toList();
    });
  }

  @override
  void initState() {
    _getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Fines'),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Current'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Paid'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: _getData,
              child: !isLoading
                  ? currentItems.length > 0
                      ? ListView.builder(
                          itemCount: currentItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 265,
                              child: Card(
                                color: themeChange.darkTheme
                                    ? Color(0XFF1E453E)
                                    : Color(0xffCBDCF8),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DottedLine(
                                          dashColor: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Fine Amount:",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            'LKR ${currentItems[index].amount + currentItems[index].paidAmount}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DottedLine(
                                          dashColor: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Paid amount :",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Spacer(),
                                          Text(
                                            'LKR ${currentItems[index].paidAmount}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Balance amount :",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Spacer(),
                                          Text(
                                            'LKR ${currentItems[index].amount}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Text(
                                        'Received',
                                        textAlign: TextAlign.left,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Date : ${DateFormat.yMMMd().format(currentItems[index].date.toLocal())} "),
                                          Spacer(),
                                          Text(
                                              "TO : ${currentItems[index].user.name}")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Contact email : ${currentItems[index].user.email} "),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Chip(
                                            backgroundColor:
                                                currentItems[index].paidAmount >
                                                        0
                                                    ? Colors.black
                                                    : Colors.redAccent,
                                            label: Text(
                                              currentItems[index].paidAmount > 0
                                                  ? 'LKR ${currentItems[index].amount} to pay'
                                                  : 'not paid yet',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Spacer(),
                                          Chip(
                                            backgroundColor:
                                                currentItems[index].paidAmount >
                                                        0
                                                    ? Colors.blue
                                                    : Colors.redAccent,
                                            label: Text(
                                              currentItems[index].paidAmount > 0
                                                  ? 'partialy completed'
                                                  : 'not paid yet',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            avatar: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                currentItems[index].paidAmount >
                                                        0
                                                    ? Icons.done
                                                    : Icons.close,
                                                color: currentItems[index]
                                                            .paidAmount >
                                                        0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/no-data.png'))),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 1,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'No current fines',
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        )
                  : CircularProgressIndicator(),
            ),
            RefreshIndicator(
              onRefresh: _getData,
              child: !isLoading
                  ? paidItems.length > 0
                      ? ListView.builder(
                          itemCount: paidItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 265,
                              child: Card(
                                color: themeChange.darkTheme
                                    ? Color(0XFF1E453E)
                                    : Color(0xffCBDCF8),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DottedLine(
                                          dashColor: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Fine Amount:",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            'LKR ${paidItems[index].paidAmount}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DottedLine(
                                          dashColor: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Full payment done",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Passenger :",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${paidItems[index].user.name}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      Text(
                                        'Fine details',
                                        textAlign: TextAlign.left,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "From : ${DateFormat.yMMMd().format(paidItems[index].date.toLocal())} "),
                                          Spacer(),
                                          Text(
                                              "Paid :${DateFormat.yMMMd().format(paidItems[index].paidDate.toLocal())}")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Contact email : ${paidItems[index].user.email} "),
                                          Spacer(),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Chip(
                                            backgroundColor: Colors.blue,
                                            label: Text(
                                              'Paid',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            avatar: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 1.5,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/no-data.png'))),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 1,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'No paid fines',
                                  style: TextStyle(fontSize: 20),
                                ))
                          ],
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
