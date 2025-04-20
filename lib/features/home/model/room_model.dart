import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'room_model.g.dart';

@JsonSerializable(explicitToJson: true) // Enable nested serialization
class Room {
  final String id;
  final String name;
  final String createdBy;
  final int maxParticipants;

  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime createdAt;

  Room({
    required this.id,
    required this.name,
    required this.createdBy,
    this.maxParticipants = 4,
    required this.createdAt,
  });

  // JSON Serialization
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  // Firestore Conversion
  factory Room.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return Room(
      id: snapshot.id,
      name: data['name'] ?? '',
      createdBy: data['createdBy'] ?? '',
      maxParticipants: data['maxParticipants'] ?? 4,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'createdBy': createdBy,
      'maxParticipants': maxParticipants,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Timestamp conversion helpers
  static DateTime _fromJsonTimestamp(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _toJsonTimestamp(DateTime date) => Timestamp.fromDate(date);
}
