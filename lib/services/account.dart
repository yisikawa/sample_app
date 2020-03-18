import 'dart:convert';

import '../constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';

List<Account> accountList = [];

class Account {
  Account({this.userID, this.btxID, this.sensorID, this.note});
  String userID;
  String btxID;
  String sensorID;
  String note;
}

class AccountData {
  Future<void> getAccountData() async {
    http.Response response = await http.get(
      globals.kTargetUrl + 'api/auth',
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data != null) {
        accountList.clear();
        data.forEach((val) {
          Account tmp = Account(
            userID: val['user_id'].toString(),
            btxID: val['btx_id'].toString(),
            sensorID: val['sensor_id'].toString(),
            note: val['note'].toString(),
          );
          accountList.add(tmp);
        });
      }
    } else {
      print('can not login! status code = $response.statusCode');
    }
  }
}
