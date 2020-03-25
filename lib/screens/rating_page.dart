import 'dart:convert';

import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../constants/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';
import '../services/account.dart';
import '../widgets/rating_day.dart';
import '../services/select_date.dart';

class RatingPage extends StatefulWidget {
  static const String id = 'Rating Page';
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
//  String accountName = accountList[globals.kAccountNo].note;
  String accountName = '';
  List<int> ratingNum = [
    0,
    0,
    0,
    0,
    0,
    0,
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
    '☆☆☆☆☆',
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
          kAccountList[globals.kAccountNo].userID +
//          'geko40c' +
          '&date=' +
//          '20200217',
          globals.kTargetDate,
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );

    if (response.statusCode == 200) {
      setState(() {
        var data = jsonDecode(response.body);

        int cnt = 0;
        data.forEach((val) {
          ratingNum[cnt] = val['rating'].toInt();
          ratingDate[cnt] = val['ratingDate'];

          cnt++;
        });
      });
    } else {
      print('error status $response.statusCode');
    }
  }

  @override
  void initState() {
    super.initState();
    accountName = kAccountList[globals.kAccountNo].note;
    _getRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.kRatingPageTitle),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                selectDate(context);
                _getRating();
              }),
        ],
      ),
      drawer: buildDrawer(context, RatingPage.id),
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
              Text(countStar[ratingNum[0] ~/ 5],
                  style: TextStyle(fontSize: 40, color: Colors.amber)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('今週の評価', style: TextStyle(fontSize: 30, color: Colors.blue)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () => _handleTapRating(1),
              child: RatingDay(
                  dayDate: ratingDate[1], dayStar: countStar[ratingNum[1]])),
          FlatButton(
              onPressed: () => _handleTapRating(2),
              child: RatingDay(
                  dayDate: ratingDate[2], dayStar: countStar[ratingNum[2]])),
          FlatButton(
              onPressed: () => _handleTapRating(3),
              child: RatingDay(
                  dayDate: ratingDate[3], dayStar: countStar[ratingNum[3]])),
          FlatButton(
              onPressed: () => _handleTapRating(4),
              child: RatingDay(
                  dayDate: ratingDate[4], dayStar: countStar[ratingNum[4]])),
          FlatButton(
              onPressed: () => _handleTapRating(5),
              child: RatingDay(
                  dayDate: ratingDate[5], dayStar: countStar[ratingNum[5]])),
        ],
      ),
    );
  }

  void _handleTapRating(int targetNo) async {
    String tempStar;
    int starNum = ratingNum[targetNo];
    tempStar = countStar[ratingNum[targetNo]];
    var result = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  ratingDate[targetNo],
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40,
                  ),
                ),
                Text(
                  tempStar,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 60,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.orange,
                    inactiveTrackColor: Colors.grey,
                    thumbColor: Colors.orange,
                    overlayColor: Colors.yellow,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                  ),
                  child: Slider(
//                  label: '評価 $dayNum',
                    min: 0,
                    max: 5,
                    value: starNum.toDouble(),
//                    activeColor: Colors.orange,
//                    inactiveColor: Colors.blueAccent,
                    divisions: 5,
                    onChanged: (double e) {
                      setState(() {
                        starNum = e.round();
                        ratingNum[targetNo] = starNum;
                        tempStar = countStar[starNum];
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        '評価',
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(1);
                      },
                    ),
                    RaisedButton(
                        child: Text(
                          'ｷｬﾝｾﾙ',
                          style: TextStyle(color: Colors.blue, fontSize: 30),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(2);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
    if (result == 1) {
      var vals = [
        {
          'cuserId': kAccountList[globals.kAccountNo].userID,
          'ratingDate': ratingDate[targetNo],
          'rating': ratingNum[targetNo],
          'shortCutCnt': null,
          'detourCnt': null,
          'wrongWayCnt': null,
          'elapsedTime': null,
          'markerCnt': 0,
          'updflg': 1,
        },
      ];
      String jsonText = json.encode(vals);
      var res = await http.put(
        globals.kTargetUrl + 'api/rating',
        headers: {
          HttpHeaders.authorizationHeader: globals.kAuthToken,
          'content-type': 'application/json',
        },
        body: jsonText,
      );
      if (res.statusCode == 200) {
        _getRating();
      } else {
        print('rating can not saved!');
      }
    } else {
      print('rating can not saved!');
    }
  }
}
