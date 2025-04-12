import 'package:ODMGear/common/app_colors.dart';
import 'package:ODMGear/features/map_screen/view_model.dart/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  static const routeName = '/MapScreen';

  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          final provider = context.read<MapViewModel>();
          await provider.requestLocationPermission();
        },
        onTap: () async {
          final provider = context.read<MapViewModel>();
          await provider.getRouteBetweenPoints();
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(),
          child: Icon(
            Icons.location_searching,
            size: 40,
            color: AppColors.primaryColor,
           
          ),
        ),
      ),
      body: Consumer<MapViewModel>(
        builder: (context, value, child) {
          return FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(value.latitude, value.longitude),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),

              // Polyline route from your location to destination
              if (value.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: value.routePoints,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),

              // Markers
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(value.latitude, value.longitude),
                    width: 80,
                    height: 80,
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 40),
                  ),
                  Marker(
                    point: const LatLng(10.9765, 76.2269),
                    width: 80,
                    height: 80,
                    child:
                        const Icon(Icons.flag, color: Colors.green, size: 40),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
