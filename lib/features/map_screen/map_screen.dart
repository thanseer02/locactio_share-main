import 'dart:math';

import 'package:ODMGear/features/login_screen/home_provider.dart';
import 'package:ODMGear/features/map_screen/view_model.dart/map_view_model.dart';
import 'package:ODMGear/utils/app_build_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // For Clipboard

class MapScreen extends StatelessWidget {
  final String roomId;

  static const routeName = '/MapScreen';

  const MapScreen({
    super.key,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen $roomId'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: roomId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Room ID copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share.share('Join my room with ID: $roomId');
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'location_permission',
            onPressed: () async {
              final provider = context.read<MapViewModel>();
              if (await provider.requestLocationPermission() == true) {
                provider.getCurrentLocation(roomId);
              }
              
            },
            backgroundColor: Colors.teal, // Changed color
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'get_route',
            onPressed: () async {
              final provider = context.read<MapViewModel>();
              await provider.getRouteBetweenPoints();
            },
            backgroundColor: Colors.teal, // Changed color
            child: const Icon(Icons.directions, color: Colors.white),
          ),
        ],
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
              if (value.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: value.routePoints,
                      color: Colors.orange, // Changed color
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(value.latitude, value.longitude),
                      width: 35.spMin,
                      height: 35.spMin,
                      child: ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(50.spMin),
                        child: buildCachedNetworkImage(
                            context.read<HomeProvider>().profileImge),
                      )
                  
                  ),
                  Marker(
                    point: const LatLng(10.9765, 76.2269),
                    width: 80.spMin,
                    height: 80.spMin,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.green, // Changed color
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
