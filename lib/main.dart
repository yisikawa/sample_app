import 'package:flutter/material.dart';
import 'package:sample_app/screens/login_page.dart';
import 'constants/globals.dart' as globals;
import 'screens/accounts_page.dart';
import 'screens/rating_page.dart';
import 'screens/route_page.dart';
import 'screens/marker_page.dart';
import 'screens/location_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: globals.kAppTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginPage.id,
        routes: <String, WidgetBuilder>{
          LoginPage.id: (context) => LoginPage(),
          AccountsPage.id: (context) => AccountsPage(),
          Rating.id: (context) => Rating(),
          RoutePage.id: (context) => RoutePage(),
          MarkerPage.id: (context) => MarkerPage(),
          Location.id: (context) => Location(),
        });
  }
}
