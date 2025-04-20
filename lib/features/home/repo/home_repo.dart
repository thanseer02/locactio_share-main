import 'package:ODMGear/features/home/model/room_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new room
  Future<Room> createRoom({
    required String name,
    required String userId,
    int maxParticipants = 4,
  }) async {
    final roomRef = await _firestore.collection('rooms').add({
      'name': name,
      'createdBy': userId,
      'maxParticipants': maxParticipants,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Add creator as first member
    await addRoomMember(roomId: roomRef.id, userId: userId);

    return Room(
      id: roomRef.id,
      name: name,
      createdBy: userId,
      maxParticipants: maxParticipants,
      createdAt: DateTime.now(),
    );
  }

  // Add user to room
  Future<void> addRoomMember({
    required String roomId,
    required String userId,
  }) async {
    await _firestore.collection('room_members').add({
      'roomId': roomId,
      'userId': userId,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get rooms where user is a member
  Stream<List<Room>> getUserRooms(String userId) {
    return _firestore
        .collection('room_members')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final roomIds =
          snapshot.docs.map((doc) => doc['roomId'] as String).toList();

      if (roomIds.isEmpty) return [];

      final rooms = await _firestore
          .collection('rooms')
          .where(FieldPath.documentId, whereIn: roomIds)
          .get();

      return rooms.docs.map((doc) => Room.fromFirestore(doc)).toList();
    });
  }

  // Get all members in a room
  Stream<List<String>> getRoomMembers(String roomId) {
    return _firestore
        .collection('room_members')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc['userId'] as String).toList());
  }
}
