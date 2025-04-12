import 'dart:async';

import 'package:ODMGear/providers/base_provider.dart';
import 'package:flutter/material.dart';

mixin MixinProgressProvider on BaseProvider {
  Completer<bool>? _completer;

  Completer<bool>? get progressCompleter => _completer;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();

    try {
      if (value) {
        _completer ??= Completer();
        if (_completer!.isCompleted) {
          _completer = Completer();
        }
      } else {
        if (_completer == null) return;

        if (!_completer!.isCompleted) {
          _completer?.complete(true);
        }
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  void showLoading() => isLoading = true;

  void hideLoading() => isLoading = false;

  Future<T> callWithInProgress<T>({required Future<T> methodToCall}) async {
    try {
      showLoading();
      return await methodToCall;
    } catch (err) {
      rethrow;
    } finally {
      hideLoading();
    }
  }

  Future<void> callSmallDelay({int delayInMillis = 1500}) async {
    try {
      showLoading();
      // ignore: inference_failure_on_instance_creation
      await Future.delayed(Duration(milliseconds: delayInMillis));
    } finally {
      hideLoading();
    }
  }
}
