import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class Calendar extends StatelessWidget {
  static const String id = 'Calendar Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('カレンダー')),
      drawer: buildDrawer(context, id),
      body: Center(
        child: Column(
          children: [
            Flexible(
                child: Text('対象の日付を選択してください',
                    style: TextStyle(fontSize: 20, color: Colors.red[50])))
          ],
        ),
      ),
    );
  }
}
