import 'package:flutter/material.dart';
import '../constants/globals.dart' as globals;
import '../screens/accounts_page.dart';
import '../screens/rating_page.dart';
import '../screens/route_page.dart';
import '../screens/marker_page.dart';
import '../screens/location_page.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                globals.kAppTitle,
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.child_care,
                size: 100,
                color: Colors.white,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text(globals.kAccountPageTitle),
          selected: currentRoute == AccountsPage.id,
          onTap: () {
            Navigator.pushReplacementNamed(context, AccountsPage.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.grade),
          title: Text(globals.kRatingPageTitle),
          selected: currentRoute == RatingPage.id,
          onTap: () {
            Navigator.pushReplacementNamed(context, RatingPage.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.directions_walk),
          title: Text(globals.kRoutePageTitle),
          selected: currentRoute == RoutePage.id,
          onTap: () {
            Navigator.pushReplacementNamed(context, RoutePage.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(globals.kMakerPageTitle),
          selected: currentRoute == MarkerPage.id,
          onTap: () {
            Navigator.pushReplacementNamed(context, MarkerPage.id);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_searching),
          title: Text(globals.kLocationPageTitle),
          selected: currentRoute == Location.id,
          onTap: () {
            Navigator.pushReplacementNamed(context, Location.id);
          },
        ),
      ],
    ),
  );
}

//Widget buildAction(String title, IconData iconData, Function onPressed) {
//  return ListTile(
//    onTap: onPressed,
//    title: Text(
//      title,
//      style: TextStyle(color: Colors.black),
//    ),
//    leading: Icon(
//      iconData,
//      color: Colors.black,
//    ),
//  );
//}
