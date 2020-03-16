import 'dart:convert';

import 'package:flutter/material.dart';
import '../constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';

class Account {
  Account({this.userID, this.btxID, this.sensorID, this.note});
  final String userID;
  final String btxID;
  final String sensorID;
  final String note;
}

class AccountData {
  Future<dynamic> getAccountData() async {
    final res = await http.get(
      globals.targetUrl + 'api/auth',
      headers: {HttpHeaders.authorizationHeader: globals.authToken},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print('can not login! status code = $res.statusCode');
    }
  }
}
