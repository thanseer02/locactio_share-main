import 'dart:async';
import 'package:CyberTrace/common/app_colors.dart';
import 'package:CyberTrace/common/app_styles.dart';
import 'package:CyberTrace/features/map_screen/view_model.dart/map_view_model.dart';
import 'package:CyberTrace/helpers/_base_helper.dart';
import 'package:CyberTrace/utils/app_build_methods.dart';
import 'package:CyberTrace/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';


import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/// This Helper class can be used for the location type functionalities
class LocationHelper extends BaseHelper {

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

  Future<void> getCurrentLocation({required BuildContext context}) async {
    try {
      final permission = await Geolocator.checkPermission();
      log('getCurrentLocation $permission');
      if (permission == LocationPermission.always) {
        final canContinue = await Geolocator.isLocationServiceEnabled();
        if (canContinue) {
          final x = await Geolocator.getCurrentPosition(

          );
          final provider = context.read<MapViewModel>();
          provider
            ..latitude = x.latitude.log('latitude in helper')
            ..longitude = x.longitude.log('longitude in helper');

       
          // await saveLongitudeLogitude(x.longitude, x.latitude);

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
    showToast('Location permission is required to use this feature.');
    // await Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   LocationErrorScreen.routeName,
    //   (route) => false,
    // ).then((value) async {
    //   final permSts = await getAlwaysPermissionSts();
    //   if (permSts.isGranted) onPermission();
    // });
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

  // Future<bool> saveLongitudeLogitude(
  //   double? longitude,
  //   double? latitude,
  // ) async {
  //   final sp = await SpHelper.getSP();
  //   longitude.log('Longitude saved');
  //   await sp.setDouble(spkeys.keyLongitude, longitude ?? 0);

  //   return sp.setDouble(spkeys.keyLongitude, longitude ?? 0);
  // }
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
            color: AppColors.colorBlack,
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
