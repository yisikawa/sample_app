import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geojson/geojson.dart';
import 'dart:io';
import '../widgets/drawer.dart';
import '../constants/globals.dart' as globals;

class MarkerPage extends StatefulWidget {
  static const String id = 'Marker Page';
  @override
  _MarkerPageState createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter = 0;
  Position position; // Geolocator　現在地
  List<Marker> markersData = []; // start,goalマーカー
  MapController mapController;
  static const double minZoom = 11.0;
  static const double maxZoom = 18.0;
  static List<String> mapHttp = [
//    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    'https://j.tile.openstreetmap.jp/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png',
    'https://cyberjapandata.gsi.go.jp/xyz/ort/{z}/{x}/{y}.jpg',
  ];
  Future<void> _getLocation(context) async {
    Position _currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // ここで精度を「high」に指定している
    setState(() {
      position = _currentPosition;
    });
  }

  Future<void> _getMarker() async {
    var res = await http.get(
      globals.kTargetUrl + 'api/marker',
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );
    markersData.clear();

    var features = await featuresFromGeoJson(res.body);
    features.collection.forEach((element) {
      String iconName = 'images/pin-${element.properties['type']}.png';
      GeoJsonPoint tmp = element.geometry;
//      LatLng point = tmp.geoPoint.toLatLng();
      Marker tmpdata = Marker(
        point: tmp.geoPoint.toLatLng(),
        builder: (ctx) {
          return Container(
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(element.properties['comment']),
                ));
              },
              child: Image.asset(iconName),
            ),
          );
        },
        width: 40.0,
        height: 40.0,
      );
      markersData.add(tmpdata);
    });
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getLocation(context);
    _getMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('マーカー')),
      drawer: buildDrawer(context, MarkerPage.id),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                  center: LatLng(35.000081, 137.004055),
                  zoom: 17.0,
                  onLongPress: _handleTap),
              layers: [
                TileLayerOptions(
                    urlTemplate: mapHttp[_counter % 4],
                    subdomains: ['a', 'b', 'c']),
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

  void _handleTap(LatLng latlng) async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '危険',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  Text(
                    '注意',
                    style: TextStyle(fontSize: 20, color: Colors.yellow),
                  ),
                  Text(
                    '安全',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
//                  TextField(
//                    enabled: true,
//                    maxLength: 10,
//                    maxLines: 1,
//                    decoration: InputDecoration(
//                        icon: Icon(Icons.add_location), hintText: 'message'),
//                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.of(context).pop(1),
                    child: Text(
                      '登録',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.of(context).pop(2),
                    child: Text(
                      'ｷｬﾝｾﾙ',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
//              Row(
//                children: <Widget>[
//                  TextField(
//                    enabled: true,
//                    maxLength: 60,
//                    maxLines: 3,
//                    decoration: InputDecoration(
//                        icon: Icon(Icons.add_location), hintText: 'ﾒｯｾｰｼﾞ入力'),
//                  )
//                ],
//              ),
            ],
          );
        });
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

//showModalBottomSheet(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
//backgroundColor: Colors.black,
//context: context,
//isScrollControlled: true,
//builder: (context) => Padding(
//padding: const EdgeInsets.symmetric(horizontal:18 ),
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//mainAxisSize: MainAxisSize.min,
//children: <Widget>[
//Padding(
//padding: const EdgeInsets.symmetric(horizontal: 12.0),
//child: Text('Enter your address',
//style: TextStyles.textBody2),
//),
//SizedBox(
//height: 8.0,
//),
//Padding(
//padding: EdgeInsets.only(
//bottom: MediaQuery.of(context).viewInsets.bottom),
//child: TextField(
//decoration: InputDecoration(
//hintText: 'adddrss'
//),
//autofocus: true,
//controller: _newMediaLinkAddressController,
//),
//),
//
//SizedBox(height: 10),
//],
//),
//));
//https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
