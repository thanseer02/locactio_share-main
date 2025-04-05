import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hail_driver/common/app_colors.dart';
import 'package:hail_driver/common/app_styles.dart';
import 'package:hail_driver/common/injector.dart';
import 'package:hail_driver/helpers/_base_helper.dart';
import 'package:hail_driver/helpers/sp_helper.dart';
import 'package:hail_driver/presentation/home/providers/home_provider.dart';
import 'package:hail_driver/presentation/location_error/location_error.screen.dart';
import 'package:hail_driver/utils/app_build_methods.dart';
import 'package:hail_driver/utils/extensions.dart';
import 'package:hail_driver/utils/sp_keys.dart' as spkeys;

import 'package:permission_handler/permission_handler.dart';

/// This Helper class can be used for the location type functionalities
class LocationHelper extends BaseHelper {
  // final StreamController<bool> _streamController =
  //     StreamController<bool>.broadcast();

  // Stream<bool> get streamRefresh => _streamController.stream;

  // void refreshStream() => _streamController.sink.add(true);

  // LocationHelper() {
  //   _initLocationStream();
  // }
  Position? currentLocation;
  static final StreamController<Position> _locationStreamController =
      StreamController<Position>.broadcast();

  static Stream<Position> get streamRefresh => _locationStreamController.stream;

  // void _initLocationStream() {
  //   Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(
  //       accuracy: LocationAccuracy.lowest,
  //       distanceFilter: 10,
  //     ),
  //   ).listen(_locationStreamController.add);
  // }

  void dispose() {
    _locationStreamController.close();
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      printWarning('getCurrentLocation $permission');
      if (permission == LocationPermission.always) {
        final canContinue = await Geolocator.isLocationServiceEnabled();
        if (canContinue) {
          final x = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.lowest,
          );

          locator.get<HomeProvider>().latitude =
              x.latitude.log('latitude in helper');
          locator.get<HomeProvider>().longitude =
              x.longitude.log('longitude in helper');
          await saveLongitudeLogitude(x.longitude, x.latitude);

          currentLocation = x;

          _locationStreamController.sink.add(x);
        }
      }
    } on LocationServiceDisabledException catch (_) {
      rethrow;
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  // Future<void> getCurrentLocation({void Function()? onSuccess}) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return;
  //   }

  //   // Check for location permissions
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return;
  //   }

  //   // If permissions are granted, get the position
  //   final position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.lowest,
  //   );
  //   locator.get<HomeProvider>().latitude =
  //       position.latitude.log('latitude in helper');
  //   locator.get<HomeProvider>().longitude =
  //       position.longitude.log('longitude in helper');
  //   currentLocation = position;
  //   if (onSuccess != null) {
  //     onSuccess();
  //   }
  //   // setState(() {
  //   //   _currentPosition = position;
  //   //   _currentAddress =
  //   //       'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  //   // });
  // }

  /// Launch the app settings screen
  Future<void> openAppSettings() async {
    await AppSettings.openAppSettings();
  }

  /// [checkPermissionAndNavigate] will check location permission
  /// [onPermission] will triggerd when permission is granted
  /// otherwise it will navigate to [LocationErrorScreen]
  Future<void> checkPermissionAndNavigate(
    BuildContext context, {
    required VoidCallback onPermission,
  }) async {
    final initialSts = await getForegroundPermissionSts();

    if (initialSts != PermissionStatus.granted) {
      /// If permission is denied then it will request for foreground location
      ///  permission
      // await Permission.location.request();

      if (await getForegroundPermissionSts() != PermissionStatus.granted) {
        /// If permission is denied even after requesting for permission
        /// it will navigate to permission error screen
        if (context.mounted) {
          await _navigateToError(context, onPermission: onPermission);
        }
      } else {
        /// If foreground permission is granted then it will request background
        /// location permission
        // await Permission.locationAlways.request();

        if (await getAlwaysPermissionSts() != PermissionStatus.granted) {
          /// If permission is denied even after requesting for permission
          /// it will navigate to permission error screen
          if (context.mounted) {
            await _navigateToError(context, onPermission: onPermission);
          }
        } else {
          onPermission();
        }
      }
    } else if (initialSts == PermissionStatus.permanentlyDenied) {
      /// If permission is permanentlyDenied
      /// it will navigate to permission error screen
      if (context.mounted) {
        if (context.mounted) {
          await _navigateToError(context, onPermission: onPermission);
        }
      }
    } else {
      onPermission();
    }
  }

  Future<void> _navigateToError(
    BuildContext context, {
    required VoidCallback onPermission,
  }) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      LocationErrorScreen.routeName,
      (route) => false,
    ).then((value) async {
      final permSts = await getAlwaysPermissionSts();
      if (permSts.isGranted) onPermission();
    });
  }

  Future<PermissionStatus> getAlwaysPermissionSts() async {
    return Permission.locationAlways.status;
  }

  Future<PermissionStatus> getForegroundPermissionSts() async {
    return Permission.location.status;
  }

  static Future<LocationPermission?> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<bool> saveLongitudeLogitude(
    double? longitude,
    double? latitude,
  ) async {
    final sp = await SpHelper.getSP();
    longitude.log('Longitude saved');
    await sp.setDouble(spkeys.keyLongitude, longitude ?? 0);

    return sp.setDouble(spkeys.keyLongitude, longitude ?? 0);
  }
}

class OpenSettingWaringWidget extends StatelessWidget {
  const OpenSettingWaringWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.colorWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.06),
            offset: const Offset(0, -5),
            blurRadius: 9,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.spMin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 34.spMin),
          Text(
            'Open Settings',
            style: tsS18W500.copyWith(color: AppColors.colorBlack),
          ),
          SizedBox(height: 14.spMin),
          Text(
            '''You need to enable the permission from the settings. Do you want to open the settings now ?''',
            style: tsS15W500.copyWith(color: AppColors.colorBlack),
          ),
          SizedBox(height: 28.spMin),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.colorBlack,
                    side: const BorderSide(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.spMin),
                    ),
                    textStyle: tsS18W500,
                    padding: EdgeInsets.symmetric(
                      vertical: 16.spMin,
                      horizontal: 38.spMin,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
              ),
              SizedBox(width: 20.spMin),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.spMin),
                    elevation: 0,
                  ),
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.spMin),
        ],
      ),
    );
  }
}
