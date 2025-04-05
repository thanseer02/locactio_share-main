// import 'dart:async';

// import 'package:base_project/providers/base_provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class RefreshOnNotificationProvider extends BaseProvider {
//   factory RefreshOnNotificationProvider() => _instance;
//   RefreshOnNotificationProvider._initialise() : super();
//   static final RefreshOnNotificationProvider _instance =
//       RefreshOnNotificationProvider._initialise();

//   final StreamController<bool> _streamController =
//       StreamController<bool>.broadcast();

//   Stream<bool> get streamRefresh => _streamController.stream;
//   // ignore: avoid_positional_boolean_parameters
//   void refreshStream(bool val) => _streamController.sink.add(val);
//   RemoteMessage? message;
//   RemoteMessage? get remoteMessage => message;
//   set remoteMessage(RemoteMessage? value) {
//     message = value;
//     notifyListeners();
//   }
// }
