import 'dart:convert';

import 'package:base_project/features/map_screen/model/route_model.dart';
import 'package:base_project/utils/extensions.dart';
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

        final  data = json.decode(response.data.toString());
     final apiResponse  = RoutesModel.fromJson(data);
        print('Response data: $data');
        if (data['routes'].isEmpty) {
          print('No routes found');
          return;
        }
        final coords = data['routes'][0]['geometry']['coordinates'];

        routePoints = coords.map<LatLng>((point) {
          final double lon = point[0];
          final double lat = point[1];
          return LatLng(lat, lon);
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
