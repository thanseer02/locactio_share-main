import 'package:ODMGear/helpers/sp_helper.dart';
import 'package:ODMGear/utils/sp_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> createUserProfile({
    required String name,
    required String email,
    String? imageUrl,
  }) async {
    try {
      CollectionReference usersCollection =
          await _firestore.collection('users');
      usersCollection.add({
        'name': name,
        'email': email,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      SpHelper.saveString(
          keyUserId, DateTime.now().millisecondsSinceEpoch.toString());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }
}
