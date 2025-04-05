import 'package:json_annotation/json_annotation.dart';

part 'route_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class RoutesModel {
  RoutesModel({
    required this.code,
    required this.routes,
    required this.waypoints,
  });

  final String code;
  final List<Route> routes;
  final List<Waypoints> waypoints;

  factory RoutesModel.fromJson(Map<String, dynamic> json) =>
      _$RoutesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutesModelToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class Route {
  Route({
    required this.geometry,
    required this.legs,
    required this.weightName,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  final Geometry geometry;
  final List<Legs> legs;

  @JsonKey(name: 'weight_name')
  final String? weightName;
  final double? weight;
  final double? duration;
  final int? distance;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  final String type;
  final List<List<double>>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class Legs {
  Legs({
    required this.steps,
    required this.summary,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  final List<dynamic>? steps;
  final String? summary;
  final double? weight;
  final double? duration;
  final int? distance;

  factory Legs.fromJson(Map<String, dynamic> json) => _$LegsFromJson(json);

  Map<String, dynamic> toJson() => _$LegsToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class Waypoints {
  Waypoints({
    required this.hint,
    required this.distance,
    required this.name,
    required this.location,
  });

  final String? hint;
  final double? distance;
  final String? name;
  final List<double>? location;

  factory Waypoints.fromJson(Map<String, dynamic> json) =>
      _$WaypointsFromJson(json);

  Map<String, dynamic> toJson() => _$WaypointsToJson(this);
}
