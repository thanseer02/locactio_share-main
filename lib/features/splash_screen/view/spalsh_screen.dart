import 'package:base_project/common/app_styles.dart';
import 'package:base_project/features/map_screen/map_screen.dart';
import 'package:base_project/features/map_screen/view_model.dart/map_view_model.dart';
import 'package:base_project/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    LocationHelper().getCurrentLocation(context: context);
    Future.delayed(const Duration(seconds: 1), () {
      LocationHelper().getCurrentLocation(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Welcome to Location Share',
              style: tsS20W600.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed(MapScreen.routeName);
            },
            // onPressed: () => _onClick(),
            child: const Text('Go to Map'),
          ),
          ElevatedButton(
            onPressed: () async {
              requestLocationPermission().then((v) {
                if (v == true) {
                  Navigator.of(context)
                      .pushReplacementNamed(MapScreen.routeName);
                }
              }); // requestLocationPermission();
              // LocationHelper().getCurrentLocation(context: context);
            },
            // onPressed: () => _onClick(),
            child: const Text('Get Location'),
          ),
        ],
      ),
    );
  }


  Future<void> checkLocation() async {
    await LocationHelper().checkPermissionAndNavigate(
      context,
      onPermission: () {
        LocationHelper().getCurrentLocation(context: context);
      },
    );
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
    final provider = context.read<MapViewModel>();
    provider
      ..latitude = _locationData.latitude ?? 0.0
      ..longitude = _locationData.longitude ?? 0.0;

    return true;
  }

}
