import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

Marker MyLocMarker(LatLng position) {
  return Marker(
    point: position,
    builder: (ctx) => Container(
      child: Icon(
        Icons.my_location,
        size: 40,
        color: Colors.blue,
      ),
    ),
  );
}

Marker UserLocMarker(LatLng position) {
  return Marker(
    point: position,
    builder: (ctx) => Container(
      child: Icon(
        Icons.my_location,
        size: 40,
        color: Colors.red,
      ),
    ),
  );
}
