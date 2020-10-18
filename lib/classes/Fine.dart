import 'User.dart';

class Fine {
  double amount;
  double paidAmount;
  bool paid;
  DateTime date;
  DateTime paidDate;
  User user;

  Fine.unPaidFinefromJson(Map<String, dynamic> json)
      : amount = double.parse(json['amount'].toString()),
        paid = json['paid'],
        paidAmount = double.parse(json['paidAmount'].toString()),
        date = DateTime.parse(json['time']),
        user = User.managerFromJson(json['managerId']);

  Fine.fromJson(Map<String, dynamic> json)
      : amount = double.parse(json['amount'].toString()),
        paidAmount = double.parse(json['paidAmount'].toString()),
        paid = json['paid'],
        paidDate = DateTime.parse(json['paidTime']),
        date = DateTime.parse(json['time']),
        user = User.managerFromJson(json['managerId']);

  Fine.userUnPaidFinefromJson(Map<String, dynamic> json)
      : amount = double.parse(json['amount'].toString()),
        paid = json['paid'],
        paidAmount = double.parse(json['paidAmount'].toString()),
        date = DateTime.parse(json['time']),
        user = User.managerFromJson(json['passengerId']);

  Fine.userPaidfromJson(Map<String, dynamic> json)
      : amount = double.parse(json['amount'].toString()),
        paidAmount = double.parse(json['paidAmount'].toString()),
        paid = json['paid'],
        paidDate = DateTime.parse(json['paidTime']),
        date = DateTime.parse(json['time']),
        user = User.managerFromJson(json['passengerId']);
}
