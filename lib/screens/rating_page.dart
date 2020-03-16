import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class Rating extends StatelessWidget {
  static const String id = 'Rating Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('評 価')),
      drawer: buildDrawer(context, id),
      body: Center(
        child: Column(
          children: [
            Flexible(
                child: Icon(
              Icons.child_care,
              size: 90,
              color: Colors.amber,
            )
//                  Image.asset('images/geko_tamago.png', width: 90, height: 90),
                ),
            Flexible(
                child: Text('評 価',
                    style: TextStyle(fontSize: 20, color: Colors.blue)))
          ],
        ),
      ),
    );
  }
}
