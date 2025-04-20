import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{
  String? _profileImge;
  
  String? get profileImge => _profileImge;
  set profileImge(String? value) {
      _profileImge = value;
      notifyListeners();
  }
  
}