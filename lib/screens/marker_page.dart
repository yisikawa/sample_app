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
      GeoJsonPoint tmp = element.geometry;
      print('maker = $element');
      print(tmp.geoPoint.toLatLng());
//      LatLng point = tmp.geoPoint.toLatLng();
      Marker tmpdata = Marker(
        point: tmp.geoPoint.toLatLng(),
        builder: (ctx) {
          if (element.properties['type'] == 'red') {
            return Container(child: Image.asset('images/pin-red.png'));
          } else if (element.properties['type'] == 'orange') {
            return Container(child: Image.asset('images/pin-orange.png'));
          } else {
            return Container(child: Image.asset('images/pin-blue.png'));
          }
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
      appBar: AppBar(title: Text('マーカー')),
      drawer: buildDrawer(context, MarkerPage.id),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(35.000081, 137.004055),
                zoom: 17.0,
              ),
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
