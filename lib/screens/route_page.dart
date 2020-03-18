import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sample_app/constants/globals.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoutePage extends StatefulWidget {
  static const String id = 'Route Page';
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kRoutePageTitle)),
      drawer: buildDrawer(context, RoutePage.id),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '2020/01/01',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                '登校',
                style: TextStyle(
                  fontSize: 24.0,
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
