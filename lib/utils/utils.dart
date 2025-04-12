import 'dart:developer' as dev;
import 'package:CyberTrace/common/app_colors.dart';
import 'package:CyberTrace/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


/// [AppUtils] - Utility methods
class AppUtils {
  /// navigator [GlobalKey] used for navigation without [BuildContext] .
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static BuildContext? _context;
  static BuildContext get initialContext => _context!;

  /// Getter & Setter method for [BuildContext].
  // ignore: avoid_setters_without_getters
  static set initContext(BuildContext? context) {
    _context = context;
  }

  /// Function to open a dropdown bottom sheet with a fixed width of 300
  /// [context] The BuildContext of the current widget.
  /// [widget] The widget to be displayed in the bottom sheet.
  /// Returns a [Future] that completes to the value returned by the bottomsheet
  static Future<dynamic> openDropdownBottomSheet(
    BuildContext context,
    Widget widget, {
    double? width,
  }) {
    return showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: width ?? 390.sp,
      ),
      builder: (context) => widget,
    );
  }

  /// This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  /// [context] The BuildContext of the current widget.
  /// [content] The String to be displayed as message.
  /// [title] The String to be displayed in the header.
  static Future<E?> showAlertDialog<E>(
    BuildContext context, {
    String? title,
    String? content,
    String? successButtonText,
    String? cancelButtonText,
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
    bool dismissable = true,
  }) {
    return showCupertinoModalPopup<E>(
      context: context,
      barrierDismissible: dismissable,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: <CupertinoDialogAction>[
          if (cancelButtonText != null)
            CupertinoDialogAction(
              /// This parameter indicates this action is the default,
              /// and turns the action's text to bold text.
              // isDefaultAction: false,
              onPressed: onCancel,
              child: Text(
                cancelButtonText,
                style: TextStyle(
                  color: AppColors.primaryButtonColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          if (successButtonText != null)
            CupertinoDialogAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as deletion, and turns
              /// the action's text color to red.
              isDefaultAction: true,
              onPressed: onSuccess,
              child: Text(
                successButtonText,
                style: TextStyle(
                  color: AppColors.primaryButtonColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Function to show a snackbar alert in the bottom.
  /// [context] The BuildContext of the current widget.
  /// [content] The String to be displayed as message.
  static void showSnackBar(
    BuildContext context, {
    required String content,
    MessageType messageType = MessageType.success,
  }) {
    final snackBar = SnackBar(
      elevation: 10000,
      backgroundColor: messageType.color,
      content: Row(
        children: [
          messageType.icon,
          SizedBox(
            width: 10.w,
          ),
          Text(
            content,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.colorWhite,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Multiple types of messages for showSnackBar function
enum MessageType {
  /// indicates success message
  success,

  /// indicates failure message
  failure;

  /// returns [Color] according to the type.
  Color get color {
    switch (this) {
      case MessageType.success:
        return AppColors.successMessageColor;
      case MessageType.failure:
        return AppColors.failureMessageColor;
    }
  }

  /// returns [SvgPicture] according to the type.
  SvgPicture get icon {
    switch (this) {
      case MessageType.success:
        return SvgPicture.asset('success_round'.asAssetSvg());
      case MessageType.failure:
        return SvgPicture.asset('failure_round'.asAssetSvg());
    }
  }
}

/// Log a message in debug mode.
/// [message] : The message to be logged.
/// [key] : An optional key to identify
/// the log entry (default is 'hail_DRIVER').
void dlog(String message, {String key = 'hail_DRIVER'}) {
  if (kDebugMode) {
    dev.log('[$key] $message', name: 'hail_DRIVER');
  }
}

/// helps to show [SnackBar] and [AlertDialog] without providing context.
class Alert {
  static BuildContext? _context;

  /// Getter & Setter method for [BuildContext].
  // ignore: avoid_setters_without_getters
  static set initContext(BuildContext? context) {
    _context = context;
  }

  /// function to show snackbar with [message].
  static void showSnackBar({
    required String message,
    BuildContext? buildContext,
    MessageType type = MessageType.success,
  }) =>
      AppUtils.showSnackBar(
        buildContext ?? _context!,
        content: message,
        messageType: type,
      );

  /// This shows a [`CupertinoModalPopup`]() which hosts a CupertinoAlertDialog.
  /// [message] The String to be displayed as message.
  /// [title] The String to be displayed in the header.
  /// [onSuccess] is a callback function when click of `success button`
  ///  of type
  ///  ``void Function()?``
  static void showAlertDialog({
    required String message,
    String? title,
    String? cancelButtonText,
    String? successButtonText,
    void Function()? onSuccess,
  }) =>
      AppUtils.showAlertDialog<void>(
        _context!,
        content: message,
        title: title,
        onSuccess: onSuccess,
        cancelButtonText: cancelButtonText,
        successButtonText: successButtonText,
      );

  static String socketURL({
    required String sessionToken,
    required String rideId,
    required String lat,
    required String lng,
  }) =>

      // LIVE
      // "ws://customer-api.shahn.ae:3006/ws?api=$sessionToken&user-type=2&ride-id=$rideId";

      // DEV
      // 'ws://143.244.132.75:3006/ws?api=$sessionToken&user-type=2&ride-id=$rideId';

      'ws://143.244.132.75:3007/ws?api=$sessionToken&user-type=1&ride-id=$rideId&lat=$lat&lng=$lng';

  // UAT
  // "ws://86.96.200.140:3006/ws?api=$sessionToken&user-type=2&ride-id=$rideId";
}
