import 'package:CyberTrace/features/map_screen/model/route_model.dart';
import 'package:CyberTrace/utils/extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  double _latitude = 10.9765;

  double get latitude => _latitude;
  set latitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  double _longitude = 76.2269;

  double get longitude => _longitude;
  set longitude(double value) {
    _longitude = value;
    notifyListeners();
  }

  Future<bool?> requestLocationPermission() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return true;
      }
    }

    _locationData = await location.getLocation();
    print('Location: ${_locationData.latitude}, ${_locationData.longitude}');
    latitude = _locationData.latitude ?? 0.0;
    longitude = _locationData.longitude ?? 0.0;

    return true;
  }

  List<LatLng> _routePoints = [];

  List<LatLng> get routePoints => _routePoints;
  set routePoints(List<LatLng> value) {
    _routePoints = value;
    notifyListeners();
  }

Future<void> getRouteBetweenPoints() async {
    final Dio dio = Dio();
    final start = '$longitude,$latitude'; // Note: lng,lat
    final end = '76.2269,10.9765';

    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$start;$end?overview=full&geometries=geojson',
    );

    try {
      final response = await dio.get(url.toString());
      if (response.statusCode == 200) {
        log('Response data: ${response.data}');

        // Parse the response data into your model
        final apiResponse = RoutesModel.fromJson(response.data);

        if (apiResponse.routes.isEmpty) {
          log('No routes found');
          return;
        }

        // Get the first route (you might want to handle multiple routes differently)
        final route = apiResponse.routes.first;

        // Extract coordinates from the geometry
        // Note: Coordinates are in [longitude, latitude] order
        final coordinates = route.geometry.coordinates;

        if (coordinates == null || coordinates.isEmpty) {
          log('No coordinates found in route geometry');
          return;
        }

        // Convert to LatLng objects (flutter_map uses LatLng(latitude, longitude))
        routePoints = coordinates.map((coord) {
          return LatLng(coord[1], coord[0]); // Note the order: lat, lng
        }).toList();

        notifyListeners();
      } else {
        print('Failed to get route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }
}
