import 'package:flutter/material.dart';

import 'dart:async';
import '../widgets/drawer.dart';
import '../services/account.dart';

class AccountsPage extends StatefulWidget {
  static const String id = 'Account Page';
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Account> accounts = [];
  String selectedCurrency = '';

  int currentAccount = 0;
  String accountName = '';
  String beaconName = '';
  String sensorName = '';
  String noteName = '';

  @override
  void initState() {
    super.initState();
    if (accountList.length > 0) {
      updateAccount(0);
    }
  }

  void updateAccount(int currentNo) {
    setState(() {
      accountName = accountList[currentNo].userID;
      beaconName = accountList[currentNo].btxID;
      sensorName = accountList[currentNo].sensorID;
      noteName = accountList[currentNo].note;
    });
  }

  void _select(String choice) {
    Account it = accountList.firstWhere((val) => val.userID == choice);
    // Causes the app to rebuild with the new _selectedChoice.
    updateAccount(accountList.indexOf(it));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント'),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.account_box),
            initialValue: accountList.first.userID,
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return accountList.map((Account choice) {
                return PopupMenuItem(
                  value: choice.userID,
                  child: Text(choice.note),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: buildDrawer(context, AccountsPage.id),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Icon(Icons.child_care, size: 240, color: Colors.amber),
          ),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('アカウント：$accountName',
                  style: TextStyle(fontSize: 30, color: Colors.blue))),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('ビーコン　：$beaconName',
                  style: TextStyle(fontSize: 30, color: Colors.blue))),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('センサー　：$sensorName',
                  style: TextStyle(fontSize: 30, color: Colors.blue))),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('ノート　　：$noteName',
                  style: TextStyle(fontSize: 30, color: Colors.blue))),
          Container(
            height: 40.0,
            alignment: Alignment.center,
//            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}
