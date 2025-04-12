import 'dart:async';
import 'package:ODMGear/utils/extensions.dart';
import 'package:flutter/material.dart';

/// progress status controller mixin.
mixin MixinProgressProvider on ChangeNotifier {
  Completer<bool>? _completer;

  /// returns status of the future in [Completer]
  Completer<bool>? get progressCompleter => _completer;

  /// returns status in [int] as percentage of the stream progress
  int? get streamProgressStatus => _streamProgressStatus;
  set streamProgressStatus(int? value) {
    _streamProgressStatus = value;
    notifyListeners();
  }

  /// returns Message in [String] of the stream progress.
  String? get streamProgressMessage => _streamProgressMessage;
  set streamProgressMessage(String? value) {
    _streamProgressMessage = value;
    notifyListeners();
  }

  int? _streamProgressStatus;
  String? _streamProgressMessage;

  bool _isLoading = false;

  /// returns the current status of the [Future].
  /// returns ``true`` if the [Future] is in execution.
  bool get isLoading => _isLoading;

  bool _isStreamingEnabled = false;

  /// returns the current status of the [Future]s.
  /// returns ``true`` if the [Future] is in execution.
  bool get isStreamingEnabled => _isStreamingEnabled;

  set isStreamingEnabled(bool value) {
    _isStreamingEnabled = value;
    notifyListeners();
  }

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
      ex.log();
    }
  }

  ///show loading
  ///
  /// enables the Loading .
  void showLoading() => isLoading = true;

  ///hide loading
  ///
  /// disabels the loading.
  void hideLoading() => isLoading = false;

  ///show streaming progress
  ///
  /// enables the streaming progress .
  void showStreamingProgress() => isStreamingEnabled = true;

  ///hide streaming progress
  ///
  /// disabels the streaming progress.
  void hideStreamingProgress() => isStreamingEnabled = false;

  ///generate loading on future.
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

  ///loading with delay
  Future<void> callSmallDelay({int delayInMillis = 1500}) async {
    try {
      showLoading();
      await Future<void>.delayed(Duration(milliseconds: delayInMillis));
    } finally {
      hideLoading();
    }
  }
}
