import 'package:flutter/material.dart';
import 'package:sample_app/screens/login_page.dart';

import 'screens/accounts_page.dart';
import 'screens/group.dart';
import 'screens/calendar.dart';
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
        title: 'GEKO APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginPage.id,
        routes: <String, WidgetBuilder>{
          LoginPage.id: (context) => LoginPage(),
          AccountsPage.id: (context) => AccountsPage(),
          Group.id: (context) => Group(),
          Calendar.id: (context) => Calendar(),
          Rating.id: (context) => Rating(),
          RoutePage.id: (context) => RoutePage(),
          Marker.id: (context) => Marker(),
          Location.id: (context) => Location(),
        });
  }
}
