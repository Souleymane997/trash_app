// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_app/shared/colors.dart';


void showMapPopup(BuildContext context, double lat, double lng) {
  final mapController = MapController();
  double zoom = 15.0;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (context, setState) => SizedBox(
          width: 500,
          height: 500,
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(lat, lng),
                  zoom: zoom,
                  maxZoom: 18,
                  minZoom: 3,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lng),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),

              // Boutons + / -
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      backgroundColor: vert(),
                      heroTag: "zoomIn",
                      onPressed: () {
                        setState(() {
                          zoom += 1;
                          mapController.move(mapController.center, zoom);
                        });
                      },
                      child: Icon(Icons.add, color: blanc()),
                    ),
                    SizedBox(height: 8),
                    FloatingActionButton.small(
                      backgroundColor: vert(),
                      heroTag: "zoomOut",
                      onPressed: () {
                        setState(() {
                          zoom -= 1;
                          mapController.move(mapController.center, zoom);
                        });
                      },
                      child: Icon(Icons.remove, color: blanc(),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Fermer"),
        )
      ],
    ),
  );
}
