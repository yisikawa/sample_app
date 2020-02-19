import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/accounts.dart';
import 'screens/group.dart';
import 'screens/calendar.dart';
import 'screens/rating.dart';
import 'screens/school_route.dart';
import 'screens/marker.dart';
import 'screens/location.dart';

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
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          Accounts.route: (context) => Accounts(),
          Group.route: (context) => Group(),
          Calendar.route: (context) => Calendar(),
          Rating.route: (context) => Rating(),
          SchoolRoute.route: (context) => SchoolRoute(),
          Marker.route: (context) => Marker(),
          Location.route: (context) => Location(),
        });
  }
}
