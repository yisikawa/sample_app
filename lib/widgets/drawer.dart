import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/accounts.dart';
import '../screens/group.dart';
import '../screens/calendar.dart';
import '../screens/rating.dart';
import '../screens/school_route.dart';
import '../screens/marker.dart';
import '../screens/location.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: <Widget>[
              Text('登下校　見守りアプリ'),
              Icon(
                Icons.child_care,
                size: 100,
                color: Colors.amber,
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('ホーム'),
          selected: currentRoute == HomePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('アカウント'),
          selected: currentRoute == Accounts.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Accounts.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: Text('グループ'),
          selected: currentRoute == Group.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Group.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text('カレンダー'),
          selected: currentRoute == Calendar.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Calendar.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.grade),
          title: Text('評　価'),
          selected: currentRoute == Rating.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Rating.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text('通学経路'),
          selected: currentRoute == SchoolRoute.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SchoolRoute.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('マーカー'),
          selected: currentRoute == Marker.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Marker.route);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_searching),
          title: Text('現在地'),
          selected: currentRoute == Location.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Location.route);
          },
        ),
      ],
    ),
  );
}

Widget buildAction(String title, IconData iconData, Function onPressed) {
  return ListTile(
    onTap: onPressed,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    leading: Icon(
      iconData,
      color: Colors.black,
    ),
  );
}
