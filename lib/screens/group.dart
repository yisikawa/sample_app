import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class Group extends StatelessWidget {
  static const String id = 'Group Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('グループ')),
      drawer: buildDrawer(context, id),
      body: Center(
        child: Column(
          children: [
            Flexible(
                child: Text('グループ名',
                    style: TextStyle(fontSize: 40, color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
