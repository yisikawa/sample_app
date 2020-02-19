import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class Rating extends StatelessWidget {
  static const String route = '/rating';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('評価')),
      drawer: buildDrawer(context, route),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child:
                  Image.asset('images/geko_tamago.png', width: 90, height: 90),
            ),
            Flexible(
                child: Text('評　価',
                    style: TextStyle(fontSize: 20, color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
