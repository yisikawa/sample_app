import 'package:flutter/material.dart';

const kStarTextStyle = TextStyle(fontSize: 30, color: Colors.amber);
const kDateTextStyle = TextStyle(fontSize: 30, color: Colors.blue);

class RatingDay extends StatelessWidget {
  RatingDay({
    @required this.dayDate,
    @required this.dayStar,
  });

  final String dayDate;
  final String dayStar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(dayDate, style: kDateTextStyle),
        SizedBox(
          width: 10,
        ),
        Text(dayStar, style: kStarTextStyle),
      ],
    );
  }
}
