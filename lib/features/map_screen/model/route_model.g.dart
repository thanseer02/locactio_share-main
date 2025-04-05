// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutesModel _$RoutesModelFromJson(Map<String, dynamic> json) => RoutesModel(
      routes: (json['routes'] as List<dynamic>?)
          ?.map((e) => Route.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypoints: json['waypoints'] as List<dynamic>?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$RoutesModelToJson(RoutesModel instance) =>
    <String, dynamic>{
      'routes': instance.routes?.map((e) => e.toJson()).toList(),
      'waypoints': instance.waypoints,
      'code': instance.code,
    };

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      legs: json['legs'] as List<dynamic>?,
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'geometry': instance.geometry,
      'legs': instance.legs,
      'distance': instance.distance,
      'duration': instance.duration,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'coordinates': instance.coordinates,
      'type': instance.type,
    };
