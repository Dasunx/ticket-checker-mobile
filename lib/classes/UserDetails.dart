import 'dart:convert';

import 'Fine.dart';
import 'Journey.dart';
import 'Payment.dart';

class UserDetails {
  double balance;
  List<Payment> paymentHistory;
  bool ongoing;
  Journey onGoingJourney;
  List<Journey> travelHistory;
  double fineBalance;
  List<Fine> fineHistory;
  String name;
  String nic;
  String userId;

  UserDetails(
      this.balance,
      this.paymentHistory,
      this.ongoing,
      this.onGoingJourney,
      this.travelHistory,
      this.fineBalance,
      this.fineHistory,
      this.name,
      this.nic,
      this.userId);
}

Future<UserDetails> userDetailsFromJson(var json) async {
  UserDetails userDetails;
  List<Payment> paymentHistory;
  Journey onGoingJourney;
  List<Journey> travelHistory;
  List<Fine> fineHistory;
  double balance = double.parse(json['balance'].toString());
  bool ongoing = json['ongoing'];
  String nic = json['nic'];
  String name = json['name'];
  double fineBalance = double.parse(json['fineBalance'].toString());
  if (ongoing) {
    print(json['journey']);
    onGoingJourney = new Journey.fromJson(json['journey']);
  } else {
    onGoingJourney = null;
  }
  String userId = json['_id'];
  paymentHistory = paymentListFromJson(json["paymentHistory"]);
  travelHistory = journeyListFromJson(json['journeyHistory']);
  fineHistory = fineListFromJson(json['fineHistory']);
  userDetails = new UserDetails(
      balance,
      paymentHistory,
      ongoing,
      onGoingJourney,
      travelHistory,
      fineBalance,
      fineHistory,
      name,
      nic,
      userId);

  return userDetails;
}

List<Payment> paymentListFromJson(var json) {
  // This method is for save data as payment list.
  List<Payment> paymentList = new List<Payment>();
  json.forEach((ele) {
    Payment p = new Payment.fromJson(ele);
    paymentList.add(p);
  });
  return paymentList;
}

List<Journey> journeyListFromJson(var json) {
  List<Journey> journeyList = new List<Journey>();
  json.forEach((ele) {
    Journey j = new Journey.fromJsonFull(ele);
    journeyList.add(j);
  });
  return journeyList;
}

List<Fine> fineListFromJson(var json) {
  List<Fine> fineList = new List<Fine>();
  json.forEach((ele) {
    if (ele['paid'] == true) {
      Fine f = new Fine.fromJson(ele);
      fineList.add(f);
    } else {
      Fine f = new Fine.unPaidFinefromJson(ele);
      fineList.add(f);
    }
  });
  return fineList;
}

List<Fine> managerFineListFromJson(var json) {
  List<Fine> fineList = new List<Fine>();
  json.forEach((ele) {
    if (ele['paid'] == true) {
      Fine f = new Fine.userPaidfromJson(ele);
      fineList.add(f);
    } else {
      Fine f = new Fine.userUnPaidFinefromJson(ele);
      fineList.add(f);
    }
  });
  return fineList;
}
