import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/drawer.dart';
import '../services/account.dart';

class AccountsPage extends StatefulWidget {
  static const String id = 'Account Page';
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<String> _ddList = [];
  AccountData accountData = AccountData();
  List<Account> accountList = [];
  int currentAccout = 0;
  String accountName = null;

  @override
  void initState() {
    super.initState();
    _ddList.clear();
    initAccountList();
    print(_ddList.length);
    ;
    setState(() {});
  }

  void makeList(dynamic accData) {
    if (accData != null) {
      accData.forEach((val) {
        _ddList.add(val['user_id']);
//        Map tmp1 = value;
//        Account tmp2 = Account(
//          userID: tmp1['user_id'].toString(),
//          btxID: tmp1['btx_id'].toString(),
//          sensorID: tmp1['sensor_id'].toString(),
//          note: tmp1['note'].toString(),
//        );
//        accountList.add(tmp2);
      });
    }
  }

  void initAccountList() async {
    dynamic data = await accountData.getAccountData();
    makeList(data);
    _ddList.forEach((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アカウント')),
      drawer: buildDrawer(context, AccountsPage.id),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Icon(Icons.child_care, size: 240, color: Colors.amber),
            ),
            Flexible(
                child: Text('account Name',
//                    '${accountList[currentAccout].userID} ${accountList[currentAccout].note}',
                    style: TextStyle(fontSize: 40, color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
