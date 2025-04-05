// ignore_for_file: avoid_dynamic_calls

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hail_driver/configs/app_configs.dart';
import 'package:hail_driver/data/model/_base_model.dart';
import 'package:hail_driver/helpers/_base_helper.dart';
import 'package:hail_driver/services/_mixins_api.dart';
import 'package:hail_driver/services/api_exceptions.dart';

class GoogleMapService extends BaseHelper with WebAPIMixin {
  factory GoogleMapService() => _instance;
  GoogleMapService._initialise()
      : _dio = Dio(
          BaseOptions(
            // connectTimeout: 5000, receiveTimeout: 3000,
            headers: {
              // "accept": "application/json",
              // 'X-Requested-With': 'com.oneic.om',
              // 'Sec-Fetch-Site': 'cross-site',
              // 'Sec-Fetch-Mode': 'cors',
              // 'Sec-Fetch-Dest': 'empty',
              // 'User-Agent': FkUserAgent.userAgent ?? "",
            },
          ),
        ) {
    // if (AppConfig.isDebugMode) {
    //   _dio.interceptors.add(
    //     LogInterceptor(
    //       responseHeader: false,
    //       responseBody: true,
    //       requestBody: true,
    //       requestHeader: true,
    //     ),
    //   );
    // }
  }
  static final GoogleMapService _instance = GoogleMapService._initialise();

  final Dio _dio;

  String get _googleCloudKey => AppConfig.googleCloudKey;

  Future<List<GoogleRouteModel>?> getRouteBetween({
    required AppCordinatesModel origin,
    required AppCordinatesModel destination,
    List<AppCordinatesModel>? waypoints,
    String? departureTime,
  }) {
    String? paramWayPopints;
    if (waypoints?.isNotEmpty ?? false) {
      final wayPointsStr = <String>[];

      for (var i = 0; i < waypoints!.length; i++) {
        final e = waypoints[i];
        var point = '';
        point = '${e.latitude},${e.longitude}';

        wayPointsStr.add(point);
      }

      paramWayPopints = wayPointsStr.join('|');
    }

    return _dio.get(
      '${AppConfig.baseURL}/directions/json',
      queryParameters: <String, dynamic>{
        'origin': '${origin.latitude!},${origin.longitude!}',
        'destination': '${destination.latitude!},${destination.longitude!}',
        'mode': 'TravelMode',
        if (departureTime != null) 'departure_time': departureTime,
        if (paramWayPopints?.isNotEmpty ?? false) 'waypoints': paramWayPopints,
        'key': _googleCloudKey,
      },
    ).then((res) {
      if (res.data is! Map) {
        throw APIException(
          enumProperty: EnumAPIExceptions.invalidResultType,
          message: 'Invalid result type from Google Location Service',
        );
      }

      final mapData = res.data as Map;

      if (!mapData.containsKey('routes') && (mapData['routes'] is! List)) {
        throw APIException(
          enumProperty: EnumAPIExceptions.invalidResultType,
          message: 'Invalid result type from Google Location Service',
        );
      }

      final routes = mapData['routes'] as List;
      final returnList = <GoogleRouteModel>[];

      for (final route in routes) {
        int? durationInSec;
        String? durationText;
        String? distanceText;
        int? distanceValue;
        try {
          final legs = route['legs'] as List?;
          if (legs?.isNotEmpty ?? false) {
            final firstItem = legs?.first as Map?;
            if (firstItem?.containsKey('duration_in_traffic') ?? false) {
              durationInSec =
                  firstItem?['duration_in_traffic']['value'] as int?;
              durationText =
                  firstItem?['duration_in_traffic']['text'] as String?;
            } else if (firstItem?.containsKey('duration') ?? false) {
              durationInSec = firstItem?['duration']['value'] as int?;
              durationText = firstItem?['duration']['text'] as String?;
              distanceText = firstItem?['distance']['text'] as String;
              distanceValue = firstItem?['distance']['value'] as int;
            }
          }
        } catch (ex) {
          debugPrint(ex.toString());
        }

        returnList.add(
          GoogleRouteModel(
            durationInSec: durationInSec,
            durationText: durationText,
            distanceText: distanceText,
            distanceValue: distanceValue,
            polylines: decodeEncodedPolyline(
              route['overview_polyline']['points'].toString(),
            ),
            bounds: CameraBoundModel(
              northEastCordinate: AppCordinatesModel(
                latitude: route['bounds']['northeast']['lat'] as double,
                longitude: route['bounds']['northeast']['lng'] as double,
              ),
              southWestCordinate: AppCordinatesModel(
                latitude: route['bounds']['southwest']['lat'] as double,
                longitude: route['bounds']['southwest']['lng'] as double,
              ),
            ),
          ),
        );
      }
      return returnList;
    }).catchError(
      (ex) {
        super.onDioError(ex as DioException, 'getRouteBetween');
      },
      test: (ex) => ex is DioException,
    );
  }
}

List<AppCordinatesModel> decodeEncodedPolyline(String encoded) {
  final poly = <AppCordinatesModel>[];
  var index = 0;
  final len = encoded.length;
  var lat = 0;
  var lng = 0;

  while (index < len) {
    int b;
    var shift = 0;
    var result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    final p = AppCordinatesModel(
      latitude: lat / 1E5,
      longitude: lng / 1E5,
    );
    poly.add(p);
  }
  return poly;
}

class GoogleRouteModel extends BaseModel {
  GoogleRouteModel({
    this.bounds,
    this.polylines,
    this.durationInSec,
    this.durationText,
    this.distanceText,
    this.distanceValue,
  });
  CameraBoundModel? bounds;
  List<AppCordinatesModel>? polylines;
  int? durationInSec;
  String? durationText;
  String? distanceText;
  int? distanceValue;
}

class CameraBoundModel extends BaseModel {
  CameraBoundModel({this.northEastCordinate, this.southWestCordinate});
  AppCordinatesModel? northEastCordinate;
  AppCordinatesModel? southWestCordinate;
}

class AppCordinatesModel extends BaseModel {
  AppCordinatesModel({
    required this.latitude,
    required this.longitude,
    this.bearing,
  });
  double? latitude;
  double? longitude;
  double? bearing;
}
