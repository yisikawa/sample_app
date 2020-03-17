import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/drawer.dart';
import '../constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';
import '../services/account.dart';
import '../widgets/rating_day.dart';

class Rating extends StatefulWidget {
  static const String id = 'Rating Page';
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
//  String accountName = accountList[globals.kAccountNo].note;
  String accountName = 'test';
  List<int> ratingNum = [
    5,
    1,
    2,
    3,
    4,
    5,
  ];
  List<String> ratingDate = [
    '20200101',
    '20200101',
    '20200102',
    '20200103',
    '20200104',
    '20200105',
  ];
  List<String> countStar = [
    '★☆☆☆☆',
    '★★☆☆☆',
    '★★★☆☆',
    '★★★★☆',
    '★★★★★',
  ];

  Future<void> _getRating() async {
    http.Response response = await http.get(
      globals.kTargetUrl +
          'api/rating?userid=' +
          accountList[globals.kAccountNo].userID +
//          'geko40c' +
          '&date=' +
//          '20200217',
          globals.kTargetDate,
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      int cnt = 0;
      data.forEach((val) {
        setState(() {
          ratingNum[cnt] = val['rating'].toInt();
          ratingDate[cnt] = val['ratingDate'];
        });
        cnt++;
      });
    } else {
      print('error status $response.statusCode');
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: globals.kSelectedDate,
      firstDate: DateTime(2018, 11),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != globals.kSelectedDate) {
      setState(() {
        globals.kSelectedDate = picked;
        //ここで選択された値を変数なり、コントローラーに代入する
        globals.kTargetDate =
            DateFormat('yyyyMMdd').format(globals.kSelectedDate);
//        print('select date = ' + globals.targetDate);
      });
      _getRating();
    }
  }

  @override
  void initState() {
    super.initState();
    accountName = accountList[globals.kAccountNo].note;
    _getRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('評 価'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context)),
        ],
      ),
      drawer: buildDrawer(context, Rating.id),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.child_care,
                  size: 90,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Container(
                  child: Text(accountName,
                      style: TextStyle(fontSize: 30, color: Colors.blue))),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(countStar[ratingNum[0] ~/ 5 - 1],
                  style: TextStyle(fontSize: 60, color: Colors.amber)),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('今週の評価', style: TextStyle(fontSize: 40, color: Colors.blue)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RatingDay(
              dayDate: ratingDate[1], dayStar: countStar[ratingNum[1] - 1]),
          RatingDay(
              dayDate: ratingDate[2], dayStar: countStar[ratingNum[2] - 1]),
          RatingDay(
              dayDate: ratingDate[3], dayStar: countStar[ratingNum[3] - 1]),
          RatingDay(
              dayDate: ratingDate[4], dayStar: countStar[ratingNum[4] - 1]),
          RatingDay(
              dayDate: ratingDate[5], dayStar: countStar[ratingNum[5] - 1]),
        ],
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        alignment: Alignment.center,
//            padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
      ),
    );
  }
}
