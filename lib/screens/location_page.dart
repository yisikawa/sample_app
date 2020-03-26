import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geojson/geojson.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/account.dart';
import '../constants/globals.dart' as globals;
import '../services/location_marker.dart';

import '../widgets/drawer.dart';

class LocationPage extends StatefulWidget {
  static const String id = 'Location Page';
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int _mapCounter = 0;
  Position _mapPosition; // Geolocator　現在地
  MapController mapController;
  List<Marker> posMarkersData = []; // 現在地マーカー
  List<Marker> mapMarkersData = []; // userマーカー

  Future<void> _getLocation() async {
    Position _currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // ここで精度を「high」に指定している
    _mapPosition = _currentPosition;
  }

  Future<void> _getUserLocation() async {
    http.Response res = await http.get(
      globals.kTargetUrl +
          'api/location?userid=' +
//          'cuser19',
          kAccountList[globals.kAccountNo].userID,
      headers: {HttpHeaders.authorizationHeader: globals.kAuthToken},
    );

    if (res.statusCode == 200) {
      mapMarkersData.clear();
      var features = await featuresFromGeoJson(res.body);
      var element = features.collection.first;
      GeoJsonPoint tmp = element.geometry;
      Marker tmpdata = UserLocMarker(tmp.geoPoint.toLatLng());
      setState(() {
        mapMarkersData.add(tmpdata);
        mapController.move(tmp.geoPoint.toLatLng(), mapController.zoom);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getLocation();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(globals.kLocationPageTitle)),
      drawer: buildDrawer(context, LocationPage.id),
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
                    urlTemplate: globals.kMapHttp[_mapCounter % 4],
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: mapMarkersData,
                ),
                MarkerLayerOptions(
                  markers: posMarkersData,
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

    if (zoom > globals.kMaxZoom) {
      zoom = globals.kMaxZoom;
    }
    setState(() {
      mapController.move(mapController.center, zoom);
    });
  }

  void _zoomOut() {
    double zoom = mapController.zoom - 1.0;

    if (zoom < globals.kMinZoom) {
      zoom = globals.kMinZoom;
    }
    setState(() {
      mapController.move(mapController.center, zoom);
    });
  }

  void _myLocation() {
    _getLocation();
    posMarkersData.clear();
    setState(() {
      Marker tmpdata =
          MyLocMarker(LatLng(_mapPosition.latitude, _mapPosition.longitude));
      posMarkersData.add(tmpdata);
      mapController.center.latitude = _mapPosition.latitude;
      mapController.center.longitude = _mapPosition.longitude;
      mapController.move(mapController.center, mapController.zoom);
    });
  }

  void _changeMap() {
    setState(() {
      _mapCounter++;
    });
  }
}
