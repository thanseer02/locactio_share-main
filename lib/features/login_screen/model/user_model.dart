import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String id;
  String name;
  String email;
  String image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  // JSON Serialization
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Firestore-specific methods
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'image': image,
    };
  }

  // For documents with converter
  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      name: snapshot['name'],
      email: snapshot['email'],
      image: snapshot['image'],
    );
  }
}
