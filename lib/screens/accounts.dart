import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class Accounts extends StatelessWidget {
  static const String route = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アカウント')),
      drawer: buildDrawer(context, route),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Icon(Icons.child_care, size: 240, color: Colors.amber),
//              child: Image.asset('images/geko_tamago.png',
//                  width: 240, height: 240),
            ),
            Flexible(
                child: Text('アカウント名',
                    style: TextStyle(fontSize: 40, color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
