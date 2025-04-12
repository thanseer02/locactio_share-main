// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutesModel _$RoutesModelFromJson(Map<String, dynamic> json) => RoutesModel(
      code: json['code'] as String,
      routes: (json['routes'] as List<dynamic>)
          .map((e) => Route.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => Waypoints.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutesModelToJson(RoutesModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'routes': instance.routes.map((e) => e.toJson()).toList(),
      'waypoints': instance.waypoints.map((e) => e.toJson()).toList(),
    };

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      legs: (json['legs'] as List<dynamic>)
          .map((e) => Legs.fromJson(e as Map<String, dynamic>))
          .toList(),
      weightName: json['weight_name'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'geometry': instance.geometry.toJson(),
      'legs': instance.legs.map((e) => e.toJson()).toList(),
      'weight_name': instance.weightName,
      'weight': instance.weight,
      'duration': instance.duration,
      'distance': instance.distance,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

Legs _$LegsFromJson(Map<String, dynamic> json) => Legs(
      steps: json['steps'] as List<dynamic>?,
      summary: json['summary'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LegsToJson(Legs instance) => <String, dynamic>{
      'steps': instance.steps,
      'summary': instance.summary,
      'weight': instance.weight,
      'duration': instance.duration,
      'distance': instance.distance,
    };

Waypoints _$WaypointsFromJson(Map<String, dynamic> json) => Waypoints(
      hint: json['hint'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      name: json['name'] as String?,
      location: (json['location'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$WaypointsToJson(Waypoints instance) => <String, dynamic>{
      'hint': instance.hint,
      'distance': instance.distance,
      'name': instance.name,
      'location': instance.location,
    };
