import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_app/constants/globals.dart' as globals;
import 'package:sample_app/screens/accounts_page.dart';
import '../services/account.dart';

class LoginPage extends StatefulWidget {
  static const id = 'login_page';
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AccountData accountData = AccountData();
  final TextEditingController _useridFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  String _userid = "";
  String _password = "";

  _LoginPageState() {
    _useridFilter.addListener(_useridListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _useridListen() {
    if (_useridFilter.text.isEmpty) {
      _userid = "";
    } else {
      _userid = _useridFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  Future<void> _loginPressed() async {
    final res = await http.post(globals.kTargetUrl + 'api/login',
        body: {'userid': _userid, 'password': _password});
    globals.kAuthToken = res.headers['authorization'];
//    print(globals.kAuthToken);

    if (globals.kAuthToken != null) {
      await accountData.getAccountData();
      globals.kAccountNo = 0;
      setState(() {
        Navigator.of(context).pushNamed(AccountsPage.id);
      });
    } else {
      print('can not login!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログインしてください"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _useridFilter,
              decoration: InputDecoration(
                  labelText: 'ユーザーID',
                  icon: Icon(
                    Icons.account_circle,
                    size: 40.0,
                  )),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: _passwordFilter,
              decoration: InputDecoration(
                  labelText: 'パスワード',
//                  hintText: 'enter password',
                  icon: Icon(
                    Icons.security,
                    size: 40.0,
                  )),
              obscureText: true,
            ),
            SizedBox(
              height: 24.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: Text(
                'ログイン',
              ),
              onPressed: _loginPressed,
            ),
          ],
        ),
      ),
    );
  }
}
