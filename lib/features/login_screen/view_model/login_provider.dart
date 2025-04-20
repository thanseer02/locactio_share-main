import 'package:ODMGear/features/login_screen/repo/login_repo.dart';
import 'package:ODMGear/helpers/sp_helper.dart';
import 'package:ODMGear/utils/sp_keys.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addToFirebase({required GoogleSignInAccount user,
  required VoidCallback onSuccess,
  }) async {
    final auth = await user.authentication;
    SpHelper.saveString(keyToken, auth.accessToken ?? '');
    SpHelper.saveString(keyUserName, user.displayName ?? '');
    SpHelper.saveString(keyUserImage, user.photoUrl ?? '');

    try {
      UserRepository().createUserProfile(
        name: user.displayName ?? '',
        email: user.email,
      ).then((value) {
        onSuccess();
      });
    } catch (e) {
    } finally {}
  }
}
