import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

class Marker extends StatelessWidget {
  static const String id = 'Marker Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('マーカー')),
      drawer: buildDrawer(context, id),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child:
                Text('This is a map that is showing (35.000081, 137.004055).'),
          ),
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(35.000081, 137.004055),
                zoom: 17.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
