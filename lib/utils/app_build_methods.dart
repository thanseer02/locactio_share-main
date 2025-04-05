// ignore_for_file: use_if_null_to_convert_nulls_to_bools

import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:base_project/common/app_colors.dart';
import 'package:base_project/utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildCachedNetworkImage(
  String? url, {
  double? height,
  BoxFit fit = BoxFit.cover,
  BoxFit? placeholderFit,
  double? width,
  EdgeInsets placeholderPadding = EdgeInsets.zero,
  bool isProfile = false,
}) {
  placeholderFit ??= fit;
  if (url?.isEmpty ?? true) {
    return _ThisErrorWidget(
      height: height,
      width: width,
      isProfile: isProfile,
    );
  }

  return CachedNetworkImage(
    imageUrl: url ?? '',
    height: height,
    width: width,
    fit: fit,
    placeholder: (context, url) => Padding(
      padding: placeholderPadding,
      // child: SvgPicture.asset(
      //   'place_holder'.asAssetSvg(),
      //   fit: placeholderFit!,
      // ),
      child: const SizedBox(),
    ),
    errorWidget: (
      context,
      url,
      error,
    ) =>
        Padding(
      padding: placeholderPadding,
      child: _ThisErrorWidget(
        height: height,
        width: width,
        isProfile: isProfile,
      ),
    ),
  );
}

class _ThisErrorWidget extends StatelessWidget {
  const _ThisErrorWidget({
    required this.height,
    required this.width,
    required this.isProfile,
  });
  final double? height;
  final double? width;
  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    return isProfile
        ? Image.asset(
            'default_profile.png'.asAssetImg(),
            height: height?.spMin,
            width: width?.spMin,
            fit: BoxFit.cover,
          )
        : SvgPicture.asset(
            'profile'.asAssetSvg(),
            height: 30.spMin,
            width: 30.spMin,
            fit: BoxFit.cover,
          );
  }
}

double rssiTosignalStrength([double rssi = 0.0]) {
  const minRssi = -100; // Reference RSSI value for minimum signal strength
  const maxRssi = 0; // Reference RSSI value for maximum signal strength
  const minSignalStrength = 0; // Minimum signal strength value
  const maxSignalStrength = 1; // Maximum signal strength value

  final signalStrength = ((rssi - minRssi) *
          (maxSignalStrength - minSignalStrength) /
          (maxRssi - minRssi)) +
      minSignalStrength;

  return signalStrength; // Output: 0.78
}

void showToast(
  String msg, {
  ToastGravity? gravity,
  Color? backgroundColor,
  Color? textColor,
  double? fontSize,
}) {

  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}

String changeDateFormat({
  required String? dateString,
  String? dateFormate,
  String? currentFormat,
}) {
  if (dateString?.isEmpty ?? false) {
    return '';
  } else {
    final newdDate = DateFormat(currentFormat ?? 'dd-MM-yy')
        .parse(dateString ?? DateTime.now().toString());
    final date = DateFormat(dateFormate ?? 'dd-MMM-yyyy').format(newdDate);
    return date;
  }
}
// String changeDateFormat({
//   required String dateString,
//   String? dateFormate,
//   String? currentFormat,
// }) {
//   final newdDate = dateConvert(currentFormat ?? 'dd-MM-yy', dateString);
//   final date = DateFormat(dateFormate ?? 'dd-MMM-yyyy').format(newdDate);
//   return date;
// }
// DateTime dateConvert(String currentFormat, String date) {
//   var changedDate = DateTime.now();
//   try {
//     changedDate = DateFormat(currentFormat).parse(date);
//   } catch (e) {
//     if (kDebugMode) {
//       print(e);
//     }
//   }
//   return changedDate;
// }

Future<bool?> showAppToast({required String msg}) async {
  if (msg.startsWith('Exception:')) {
    msg = msg.replaceFirst('Exception:', '');
  }

  msg.trim();

  if (msg.startsWith('This widget has been')) {
    return true;
  }

  if (msg.startsWith('Null check operator')) {
    return true;
  }

  return Fluttertoast.showToast(
    msg: msg,
    textColor: AppColors.colorWhite,
    backgroundColor: AppColors.colorBlack.withOpacity(.9),
    //gravity: ToastGravity.TOP
  );
}

Future<void> onTapPhone({required String? mobileNumber}) async {
  if (mobileNumber != null && mobileNumber != '') {
    final telphoneUrl = Uri(scheme: 'tel', path: mobileNumber);
    try {
      await canLaunchUrl(telphoneUrl)
          ? await launchUrl(telphoneUrl)
          : throw Exception('error while launch call');
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    unawaited(showAppToast(msg: 'Phone number is not availble'));
  }
}

// void onTapLocation() async {
//   const location =
//       "//www.google.com/maps/place/Tire+24X7+Inc.+MOBILE+TIRE+SERVICE/@39.6386828,-75.8440945,12z/data=!4m22!1m16!4m15!1m6!1m2!1s0x89c7a95276a287a5:0xe5ca387eadf92423!2sTire+24X7+Inc.+MOBILE+TIRE+SERVICE,+Welsh+Hill+Road,+Newark,+DE,+USA!2m2!1d-75.7740539!2d39.6385716!1m6!1m2!1s0x89c7a95276a287a5:0xe5ca387eadf92423!2sTire+24X7+Inc.+MOBILE+TIRE+SERVICE,+402+Welsh+Hill+Rd,+Newark,+DE+19702,+United+States!2m2!1d-75.7740539!2d39.6385716!3e2!3m4!1s0x89c7a95276a287a5:0xe5ca387eadf92423!8m2!3d39.6385716!4d-75.7740539";
//   //const location = "//www.google.com/";
//   Uri locationUrl = Uri(scheme: 'https', path: location);
//   try {
//     await canLaunchUrl(locationUrl)
//         ? await launchUrl(locationUrl)
//         : throw 'error while launc call';
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }

Future<void> openLink({required String link}) async {
  final url = Uri.parse(link);
  try {
    if (Platform.isAndroid) {
      await canLaunchUrl(url)
          ? await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            )
          : 'Error while launching Uri'.log('Error:');
    } else if (Platform.isIOS) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> onTapMail({required String? email}) async {
  if (email != null && email != '') {
    final emailUrl = Uri(
      scheme: 'mailto',
      path: email,
      query:
          '''subject=${Uri.encodeComponent("Subject")}&body=${Uri.encodeComponent('')}''',
    );
    try {
      await canLaunchUrl(emailUrl)
          ? await launchUrl(emailUrl)
          : throw Exception('error while launch email');
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    unawaited(showAppToast(msg: 'Email address is not availble'));
  }
}

Future<void> openWhatsapp({
  required String text,
  required String? number,
}) async {
  final whatsapp = number; //+92xx enter like this

  if (number != null && number != '') {
    final whatsappURlAndroid = 'whatsapp://send?phone=$whatsapp&text=$text';
    final whatsappURLIos = 'https://wa.me/$whatsapp?text=${Uri.tryParse(text)}';
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(
          Uri.parse(
            whatsappURLIos,
          ),
        );
      } else {
        unawaited(showAppToast(msg: 'Whatsapp not installed'));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        unawaited(showAppToast(msg: 'Whatsapp not installed'));
      }
    }
  } else {
    unawaited(showAppToast(msg: 'WhatsApp number not availble'));
  }
}

void printWarning(String text) {
  print('\x1B[32m$text\x1B[0m');
}

void printRed(String text) {
  print('\x1B[31m$text\x1B[0m');
}

double convertoDouble(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return 0;
}

Future<void> showCustomBottomWidget(
  BuildContext context, {
  required Widget widget,
  bool isPop = false,
  bool isTopBarEnabled = true,
  bool isDismissible = false,
}) {
  return showModalBottomSheet<void>(
    isDismissible: isDismissible,
    isScrollControlled: true,
    elevation: 0,
    useRootNavigator: true,
    enableDrag: false,
    useSafeArea: true,
    backgroundColor: isPop ? Colors.transparent : Colors.white,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.spMin),
        topRight: Radius.circular(12.spMin),
        bottomLeft:
            isPop ? Radius.circular(12.spMin) : Radius.circular(0.spMin),
        bottomRight:
            isPop ? Radius.circular(12.spMin) : Radius.circular(0.spMin),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return IntrinsicHeight(
        child: Container(
          margin: isPop ? EdgeInsets.all(15.spMin) : EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.spMin),
              topRight: Radius.circular(12.spMin),
              bottomLeft:
                  isPop ? Radius.circular(12.spMin) : Radius.circular(0.spMin),
              bottomRight:
                  isPop ? Radius.circular(12.spMin) : Radius.circular(0.spMin),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: isTopBarEnabled
                    ? AppColors.disabledButtonColor
                    : AppColors.colorWhite,
                margin: EdgeInsets.all(6.spMin),
                height: isTopBarEnabled ? 4.spMin : 0,
                width: 63.spMin,
              ),
              Expanded(
                child: widget,
              ),
            ],
          ),
        ),
      );
    },
  );
}


