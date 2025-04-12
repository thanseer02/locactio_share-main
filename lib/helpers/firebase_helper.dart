// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ODMGear/common/app_colors.dart';
import 'package:ODMGear/helpers/_base_helper.dart';
import 'package:ODMGear/helpers/sp_helper.dart';

import 'package:ODMGear/utils/app_build_methods.dart';
import 'package:ODMGear/utils/sp_keys.dart';
import 'package:ODMGear/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseMessagingHelper extends BaseHelper {
  factory FirebaseMessagingHelper() => _con;

  FirebaseMessagingHelper._instance();
  static final FirebaseMessagingHelper _con =
      FirebaseMessagingHelper._instance();

  /// The types of notifications that will be ignored to show when app is in
  /// foreground or background
  static const List<String> _ignoreNotificationTypes = <String>[];
  final _instance = FirebaseMessaging.instance;

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  /// Call this method to initialise the firebase and local notificaiton plugins
  Future<void> setUpFirebase() async {
    await _firebaseCloudMessagingListeners();
    await requestAndSetup();
    if (!await Permission.notification.isGranted) {
      _configureLocalNotifications();
    }
  }

  Future<void> deleteToken() => FirebaseMessaging.instance.deleteToken();

  Future<String?> getToken() => FirebaseMessaging.instance.getToken();

  /// This method will subcribe to [topic]
  Future<void> subscribeToTopic(String topic) {
    debugPrint('############ [FirebaseHelper] [subscribeToTopic] $topic');
    return FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  /// [onReceiveNotification] will navigate to screens based on title and body
  static void onReceiveNotification(
    RemoteMessage event, {
    bool? canNavigate = true,
  }) {
    debugPrint('######### [onReceiveNotification]: ${event.data}');
    try {
      final data = event.data;
      final key = data['key']?.toString();

      /// [details] is used when a future trip notification
      ///  is received and its ready for arrival
      var details = '';
      if (data.containsKey('details') && data['details'] != null) {
        details = data['details']?.toString() ?? '';
      }
      if (details == 'future_trip' && canNavigate!) {
        // onNavigate(isFutureNotification: true);
      } else if (key == 'ride_request') {
        // if (canNavigate!) onNavigate(isFutureNotification: false);
      } else if (key == 'ride_rejected' && canNavigate!) {
        /// When a ride rejected then ride type will be considerd for navigation
        /// '1' is instant trip
        /// '2' is future trip
        final type = data['ride_type']?.toString();
        if (type == '1') {
          // onNavigateRideCancel();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    _playsoundOnBackgroundNotification(message);
  }

  static void _playsoundOnBackgroundNotification(RemoteMessage message) {
    final data = message.data;
    final dynamicTitle = data['key'];
    var titleToShow = '';
    if (dynamicTitle != null) titleToShow = dynamicTitle.toString();
    if (titleToShow == 'ride_request') {}
  }

  // Future<void> _unSubscribeToTopic(String topic) {
  //   print("############ [FirebaseHelper] [unSubscribeToTopic] $topic");
  //   return FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  // }

  Future<NotificationSettings> requestPermission() =>
      _instance.requestPermission();

  /// The method to setup the push notification in device.
  ///
  /// For the ios this will show the request dialog and setup the notifications
  Future<bool> requestAndSetup() async {
    var isGranted = false;
    var permission = await Permission.notification.status;
    switch (permission) {
      case PermissionStatus.denied:
        permission = await Permission.notification.request();
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        try {
          var res = true;
          if (Platform.isIOS) {
            await showModalBottomSheet<void>(
              // context: appNavigatorkey.currentContext!,
              context: AppUtils.navKey.currentContext!,
              builder: (context) => const SizedBox(),
            ).then((value) => res = value as bool? ?? false);
          }
          if (res == true) {
            await openAppSettings();
          }
        } catch (ex) {
          debugPrint(ex.toString());
        }
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        break;
      case PermissionStatus.provisional:
        break;
    }
    isGranted = await Permission.notification.isGranted;
    if (isGranted) {
      await requestPermission();
      _configureLocalNotifications();
    }
    return isGranted;
  }

  /// This method intiate the redirection from the notification.
  Future<void> _firebaseCloudMessagingListeners() async {
    FirebaseMessaging.instance.onTokenRefresh.listen(_onTokenRefresh);
    unawaited(subscribeToTopic('general-notification-driver'));
    if ((await SpHelper.getString(keyDeviceToken)).toString().isEmpty) {
      await FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) _onTokenRefresh(token);
        debugPrint('Push Messaging token=>: $token');
      });
    }
    if (Platform.isAndroid) {
      //it will handle terminated case
      await FirebaseMessaging.instance.getInitialMessage().then((event) {
        if (event?.data != null) {
          debugPrint('######### [getInitialMessage]: ${event?.data}');
          //used to handle notification in terminated case of application
          handleNotificationClick(event: event);

          if (event?.data.isEmpty ?? true) return;

          // String? type;

          // if (event!.data.containsKey("type")) {
          //   type = event.data["type"]?.toString();
          // }
          if (event!.data.containsKey('type')) {}

          debugPrint(
            '''########## [_firebaseCloudMessagingListeners] [getInitialMessage] [listen] ${event.data}''',
          );

          // if (type != null) {
          //_handleNavigation(event.data, type);

          // }
        }
      });
    }

    FirebaseMessaging.onMessage.listen((event) {
      try {
        onReceiveNotification(event);
      } catch (e) {
        debugPrint('##Error:$e');
      }

      debugPrint(event.data.toString());
      // RefreshOnNotificationProvider().remoteMessage = event;

      String? imgUrl;
      if (Platform.isAndroid) {
        imgUrl = event.notification?.android?.imageUrl;
      } else if (Platform.isIOS) {
        imgUrl = event.notification?.apple?.imageUrl;
      }
      String? type;
      var isShowNotification = true;

      if (event.data.containsKey('type')) {
        type = event.data['type']?.toString();
        isShowNotification = !_ignoreNotificationTypes.contains(type);

        if (isShowNotification) {
          // isShowNotification = canShowNotificationForType(event.data);
        }
      }
      final title = event.notification?.title;
      final body = event.notification?.body ?? '';

      if (title != null) {
        showNotificationWithDefaultSound(
          title,
          body,
          imgUrl: imgUrl,
          type: type,
          data: event.data,
          androidChannelId: event.notification?.android?.channelId,
        );
      }
      //   if (isShowNotification) {

      //   }

      // if (type != null) {
      // _handleNavigation(event.data, type);
      // }
      // } catch (ex) {
      //   debugPrint(ex.toString());
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      //to handle background notification
      debugPrint('######### [onMessageOpenedApp]: ${event.data}');
      handleNotificationClick(event: event);

      //NotificationStreamProvider.addNotification(event);

      // String? type;

      // if (event.data.containsKey("type")) {
      //   type = event.data["type"]?.toString();
      // }

      if (event.data.containsKey('type')) {}
      debugPrint(
        '''########## [_firebaseCloudMessagingListeners] [onMessageOpenedApp] [listen] ${event.data}''',
      );
      // if (type != null) {
      // _handleNavigation(event.data, type);

      // }
    });
  }

  ///[clearNotification] clear the notification on app drawer
  void clearNotification() {
    flutterLocalNotificationsPlugin?.cancel(0);
  }

  ///[]
  Future<void> showNotificationWithDefaultSound(
    String title,
    String message, {
    String? imgUrl,
    String? type,
    String? androidChannelId,
    Map<String, dynamic>? data,
  }) async {
    // bool hasPermission = await Permission.notification.isGranted;
    // if (!hasPermission) return;

    StyleInformation? styleInformation;

    if (data?['image'] != null && data?['image'].isNotEmpty as bool) {
      debugPrint(data?['image'].toString());
      final bigPicturePath =
          await _downloadAndSaveFile(data?['image']! as String, 'bigPicture');
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        contentTitle: title,
        htmlFormatContentTitle: true,
        // largeIcon: FilePathAndroidBitmap(bigPicturePath),
        summaryText: message,
        htmlFormatSummaryText: true,
      );
    } else {
      styleInformation = BigTextStyleInformation(
        message,
        contentTitle: title,
      );
    }

    const channelName = 'ODMGear';

    androidChannelId ??= 'ODMGear';

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidChannelId,
      channelName,
      importance: Importance.max,
      priority: Priority.max,
      colorized: true,
      color: AppColors.primaryColor,
      enableLights: true,
      styleInformation: styleInformation,
    );
    // var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    const iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(threadIdentifier: 'ODMGear');
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    if (flutterLocalNotificationsPlugin != null) {
      try {
        await flutterLocalNotificationsPlugin!.show(
          0,
          title,
          message,
          platformChannelSpecifics,
          payload: jsonEncode({
            'title': title,
            'message': message,
            'type': type,
            'data': data,
          }),
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  /// This method helps to download and save the notification image, so that it
  /// can be shown as big picture notification in
  /// [FlutterLocalNotificationsPlugin]
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    // final value = await Dio().download(url, filePath);
    return filePath;
  }

  void _configureLocalNotifications() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_stat_noti');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(
      initializationSettings,
      // onSelectNotification: onSelectNotification
      //to handle forground notification click
      onDidReceiveNotificationResponse: (details) async {
        debugPrint(details.payload);
        await handleNotificationClick(details: details);
      },
    );
  }

  void _onTokenRefresh(String token) {
    debugPrint('############# [_onTokenRefresh] FirebaseToken: $token');

    SpHelper.saveString(keyDeviceToken, token);

    // if (userData != null) {
    //   debugPrint("############# [_onTokenRefresh] userId: ${userData!.id}");
    //   userData!.fcmToken = token;
    //   UserRepoImp().updateFirestoreDoc(model: userData!);
    // }
  }

  ///[handleNotificationClick] on tap notification function

  static Future<void> handleNotificationClick({
    NotificationResponse? details,
    RemoteMessage? event,
  }) async {
    final isHome = true;
    //  await homeCompleter.future;
    if (isHome) {
      dynamic data;

      if (details != null) {
        final payload = jsonDecode(details.payload!);
        data = payload['data'];
      }
      if (event != null) {
        data = event.data;
        debugPrint(data.toString());
      }

      if (data != null) {
        final key = data['key']?.toString();
        final type = data['type']?.toString();
        final message = data['details']?.toString();
        printWarning('message1: $message');
        if (message == 'future_trip') {
          printWarning('future_trip');
          // await onNavigate(isFutureNotification: true);
        } else if (key == 'ride_request') {
          // await onNavigate(isFutureNotification: false);
        } else if (key == 'Ride Rejected') {
          final type = data['ride_type']?.toString();
          if (type == '1') {
            // await onNavigateRideCancel();
          }
        } else if (type == 'chat') {
          // await onNavigateChat(data as Map<String, dynamic>);
        } else {
          // await AppUtils.navKey.currentState?.pushNamed(
          //   NotificationScreen.routeName,
          // );
        }
      }
    }
  }
}
