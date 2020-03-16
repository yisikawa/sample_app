import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home Page';
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  Position position; // Geolocator

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
    mapController = new MapController();
    _getLocation(context);
  }

  Future<void> _getLocation(context) async {
    Position _currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // ここで精度を「high」に指定している
    setState(() {
      position = _currentPosition;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ホーム')),
      drawer: buildDrawer(context, HomePage.id),
      body: Column(
        children: [
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
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              heroTag: "zoomIn",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _zoomIn,
              tooltip: 'Zoom in map',
              child: Icon(Icons.zoom_in, size: 20, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              heroTag: "zoomOut",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _zoomOut,
              tooltip: 'Zoom out map',
              child: Icon(Icons.zoom_out, size: 20, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              heroTag: "myLocation",
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _myLocation,
              tooltip: 'my location',
              child: Icon(Icons.my_location, size: 20, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              heroTag: "changeLayer",
              backgroundColor: Colors.white,
              onPressed: _changeMap,
              tooltip: 'change map layer',
              child: Icon(Icons.layers, size: 40, color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
