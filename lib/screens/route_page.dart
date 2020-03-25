import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:gpx/gpx.dart';
import '../widgets/drawer.dart';
import '../services/select_date.dart';
import '../constants/globals.dart' as globals;
import '../services/account.dart';


class RoutePage extends StatefulWidget {
  static const String id = 'Route Page';
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  List<String> tokoList = ['登校', '下校',];

  String accountName = 'test';
  String examDate = '2020/01/01';
  String tokoName = '登校';
  int _counter = 0;
  Position position; // Geolocator　現在地
  List<Marker> markersData = []; // start,goalマーカー
  List<LatLng> points = []; //経路　
  var bounds = new LatLngBounds(); // 経路範囲
  MapController mapController;
  final FitBoundsOptions options =
      const FitBoundsOptions(padding: EdgeInsets.all(12.0));
  static const double minZoom = 11.0;
  static const double maxZoom = 18.0;
  static List<String> mapHttp = [
//    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    'https://j.tile.openstreetmap.jp/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg',
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getLocation(context);
    _getRoute();
  }

  Future<void> _getLocation(context) async {
    Position _currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // ここで精度を「high」に指定している
    setState(() {
      position = _currentPosition;
    });
  }

  Future<void> _getRoute() async {
    var res = await http.get(
      globals.kTargetUrl +
          'api/route?userid=' +
          kAccountList[globals.kAccountNo].userID +
//          'ctest19' +
          '&date=' +
          globals.kTargetDate +
//          '20181217'
              '&type=' +
          globals.kTokoFlag.toString(),
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );
    // 経路設定
    setState(() {
      if( res.statusCode == 200 ) {
        setState(() {
          points.clear();
          var xmlGpx = GpxReader().fromString(res.body);
          xmlGpx.trks.forEach((oneTrks) {
            oneTrks.trksegs.forEach((oneTrksegs) {
              oneTrksegs.trkpts.forEach((val) {
                points.add(LatLng(val.lat, val.lon));
              });
            });
          });
          // start,goal マーカーセット
          markersData.clear();
          Marker tmp1 = Marker(
            point: points.first,
            builder: (ctx) =>
                Container(child: Image.asset('images/start2.png')),
            width: 40.0,
            height: 40.0,
          );
          markersData.add(tmp1);
          Marker tmp2 = Marker(
            point: points.last,
            builder: (ctx) =>
                Container(child: Image.asset('images/goal.png')),
            width: 40.0,
            height: 40.0,
          );
          markersData.add(tmp2);
          // 経路範囲
          points.forEach((val) {
            bounds.extend(val);
          });

          mapController.fitBounds(
            bounds,
            options: FitBoundsOptions(
              padding: EdgeInsets.all(40.0),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.kRoutePageTitle),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                  selectDate(context,_getRoute);
//                _getRoute();
              }),
          PopupMenuButton<String> (
            icon: Icon(Icons.directions_walk),
            initialValue: tokoList.first,
            onSelected: (String choice) {
              globals.kTokoFlag = (choice == '登校')? 1:2;
              setState(() {
                tokoName = choice;
              });
              _getRoute();
            },
            itemBuilder: (BuildContext context) {
              return tokoList.map( (String choice) {
                return PopupMenuItem(
                  child:Text(choice),
                  value:choice,
                );
              }).toList();
          }),
        ],
      ),
      drawer: buildDrawer(context, RoutePage.id),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.child_care,
                size: 24.0,
                color: Colors.black,
              ),
              Text(
                kAccountList[globals.kAccountNo].note,
                style: TextStyle(fontSize: 24.0, color: Colors.black),
              ),
              Text(
                globals.kTargetDate,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              Text(
                tokoName,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              )
            ],
          ),
          Flexible(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(35.000081, 137.004055),
                zoom: 17.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: mapHttp[_counter % 4],
                  subdomains: ['a', 'b', 'c']),

                PolylineLayerOptions(
                  polylines: [
                    Polyline(points: points, strokeWidth: 5.0, color: Colors.red),
                    ],
                ),
                MarkerLayerOptions(
                  markers: markersData,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 150.0, left: 30.0),
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _zoomIn,
                  tooltip: 'Zoom in map',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Icon(
//                    Icons.zoom_in,
                    FontAwesomeIcons.plus,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _zoomOut,
                  tooltip: 'Zoom out map',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Icon(
                    FontAwesomeIcons.minus,
//                    Icons.zoom_out,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 150.0, right: 0.0),
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'changeLayer',
                  backgroundColor: Colors.white,
                  onPressed: _changeMap,
                  tooltip: 'Change map layer',
                  child: Icon(
                    Icons.layers,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'myLocation',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _myLocation,
                  tooltip: 'my location',
                  child: Icon(
                    Icons.my_location,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _zoomIn() {
    double zoom = mapController.zoom + 1.0;

    if (zoom > maxZoom) {
      zoom = maxZoom;
    }
    setState(() {
      mapController.move(mapController.center, zoom);
    });
  }

  void _zoomOut() {
    double zoom = mapController.zoom - 1.0;

    if (zoom < minZoom) {
      zoom = minZoom;
    }
    setState(() {
      mapController.move(mapController.center, zoom);
    });
  }

  void _myLocation() {
    mapController.center.latitude = position.latitude;
    mapController.center.longitude = position.longitude;
    setState(() {
      mapController.move(mapController.center, mapController.zoom);
    });
  }

  void _changeMap() {
    setState(() {
      _counter++;
    });
  }
}
