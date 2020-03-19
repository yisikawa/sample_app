import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../services/account.dart';
import '../constants/globals.dart' as globals;

const kFontSize = 30.0;
class AccountsPage extends StatefulWidget {
  static const String id = 'Account Page';
  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<Account> accounts = [];
  String selectedCurrency = '';

  String accountName = '';
  String beaconName = '';
  String sensorName = '';
  String noteName = '';

  @override
  void initState() {
    super.initState();
    if (accountList.length > 0 && globals.kAccountNo < accountList.length) {
      updateAccount(globals.kAccountNo);
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
    globals.kAccountNo = accountList.indexOf(it);
    updateAccount(globals.kAccountNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.kAccountPageTitle),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Icon(Icons.child_care, size: 120, color: Colors.amber),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('アカウント：$accountName',
                  style: TextStyle(fontSize: kFontSize, color: Colors.blue))),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('ビーコン　：$beaconName',
                  style: TextStyle(fontSize: kFontSize, color: Colors.blue))),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('センサー　：$sensorName',
                  style: TextStyle(fontSize: kFontSize, color: Colors.blue))),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text('ノート　　：$noteName',
                  style: TextStyle(fontSize: kFontSize, color: Colors.blue))),
        ],
      ),
//      bottomNavigationBar: Container(
//        height: 40.0,
//        alignment: Alignment.center,
////            padding: EdgeInsets.only(bottom: 30.0),
//        color: Colors.lightBlue,
//      ),
    );
  }
}
