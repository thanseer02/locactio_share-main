import 'dart:math';

import 'package:base_project/common/app_colors.dart';
import 'package:base_project/common/app_styles.dart';
import 'package:base_project/providers/mixin_progress_provider.dart';
import 'package:base_project/widgets/custom_loader.dart';
import 'package:base_project/widgets/list_scroll_more_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:base_project/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Extension on [Future]
extension FutureExtension<T> on Future<T> {
  /// Extension function to show/hide the loading progress.
  /// Returns a [Future].
  /// [I] - Provider that extends the [MixinProgressProvider].
  Future<T> setProgress<I extends MixinProgressProvider>(
    I provider, {
    bool stopLoading = true,
  }) async {
    try {
      provider.showLoading();
      await this;
    } finally {
      if (stopLoading) {
        provider.hideLoading();
      }
    }
    return this;
  }

  /// Extension function to show/hide the loading progress with percentage.
  ///
  /// Returns a [Future].
  /// [totalFuture] is the number of total [Future]s
  ///
  /// [currentFuture] is the number of current [Future].
  ///
  /// participating in the stream.
  ///
  /// [I] - Provider that extends the [MixinProgressProvider].
  Future<T> showProgressStream<I extends MixinProgressProvider>(
    I provider,
    int currentFuture,
    int totalFuture, {
    String? message,
  }) async {
    try {
      final percent = ((currentFuture / totalFuture) * 100).round();
      provider
        ..streamProgressStatus = percent
        ..streamProgressMessage = message ?? 'loading'
        ..showStreamingProgress();

      await this;
    } catch (e) {
      provider
        ..streamProgressStatus = null
        ..streamProgressMessage = null
        ..hideStreamingProgress();
    } finally {
      if (currentFuture == totalFuture) {
        provider
          ..streamProgressStatus = null
          ..streamProgressMessage = null
          ..hideStreamingProgress();
      }
    }
    return this;
  }

  /// Extension function to show the loading on top of the screen.
  /// Returns a [Future].
  /// [context] - BuildContext of the screen.
  /// [bgOpacity] - (optional) Background Opactiy value.
  Future<T> showOverlayProgress(
    BuildContext context, {
    double bgOpacity = 0.5,
  }) {
    OverlayEntry? progressOverlay;
    progressOverlay = OverlayEntry(
      builder: (context) => AbsorbPointer(
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black.withOpacity(bgOpacity),
            alignment: Alignment.center,
            child: const CustomLoader(),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(progressOverlay);
    return whenComplete(() {
      if (progressOverlay != null) {
        progressOverlay!.remove();
        progressOverlay = null;
      }
    });
  }
}

/// Extension on [String]
extension StringExtensions on String {
  /// Extension function to check if a [String] is numeric.
  /// Returns [bool], true - is numeric ; false - is not numeric
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  /// Extension function to convert the first letter of a string to capital
  String capitalize() {
    if (trim().isEmpty) return '';
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Extension function to convert the first letter of all words in the string
  /// to capital
  String capitalizeEachWord() {
    if (isEmpty) return this;

    final words = split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    });

    return capitalizedWords.join(' ');
  }

  /// Extension function to get the svg icon asset location
  String asAssetIconSvg() => 'assets/icons/$this.svg';

  /// Extension function to get the svg asset location
  String asAssetSvg() => 'assets/svgs/$this.svg';

  String asAssetMp3() => 'audio/$this.mp3';

  /// Extension function to get the lottie asset location
  String asAssetLottie() => 'assets/lotties/$this.json';

  /// Extension function to get the image asset location
  String asAssetImg() => 'assets/images/$this';

  /// Extension function to get the gig asset location
  String asAssetGif() => 'assets/gifs/$this';

  /// converts [String] to [double].
  double? toDouble() {
    try {
      if (isEmpty) {
        return null;
      }
      return double.parse(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime roundToCeil() {
    var returnTime = this;
    if (returnTime.minute % 5 != 0) {
      final roundedMinutes = 5 * (returnTime.minute / 5).ceil();
      final diff = roundedMinutes - returnTime.minute;
      if (diff != 0) {
        returnTime = returnTime.add(Duration(minutes: diff));
      }
    }
    return returnTime;
  }

  String? toFormatted({String format = 'dd/MM/yyy'}) {
    try {
      return DateFormat(format).format(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  String? toDateTimeFormatted({String format = 'dd-MM-yyyy HH:mm:ss'}) {
    try {
      return DateFormat(format).format(this);
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }

  bool isCurrentDateTimeInRange(
    DateTime scheduleStartTime,
    DateTime scheduleEndTime,
    DateTime startOffTime,
    DateTime endOffTime,
  ) {
    return scheduleStartTime.isAfter(startOffTime) &&
        // scheduleStartTime.isAtSameMomentAs(startOffTime) &&
        // scheduleEndTime.isAtSameMomentAs(endOffTime) &&
        scheduleStartTime.isBefore(endOffTime);
  }

  bool isCurrentDateInRange() {
    final currentDate = DateTime.now();
    final startDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').parse('28-04-2023 20:00:00');
    final endDate =
        DateFormat('dd-MM-yyyy HH:mm:ss').parse('28-04-2023 22:00:00');
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }

  String? toFormattedCurrent({String format = 'dd/MM/yyy'}) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final aDate = DateTime(year, month, day);
      if (aDate == today) {
        return 'Today ${DateFormat.jm().format(this)}';
      }
      return '''${DateFormat("dd-MM-yyyy").format(this)} ${DateFormat.jm().format(this)}''';
    } catch (ex) {
      debugPrint(ex.toString());
      return null;
    }
  }
}

/// Extensions on [DateTime]
extension DateExtension on DateTime {
  /// Extension function to convert the DateTime into 2023-11-23
  String toServerYMD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Extension function to convert the DateTime into 10:30 PM
  String toLocalTime() {
    return DateFormat('jm').format(this);
  }
}



/// Extension on [bool]
extension Boolean on bool {
  /// Extension function to get random boolean value.
  static bool get random {
    final r = Random();
    const falseProbability = .5;
    return r.nextDouble() > falseProbability;
  }
}

extension ListViewExtension on ListView {
  Widget withLoadMore({
    required void Function(BuildContext context) onLoadMore,
    required bool Function(BuildContext context) canLoadMore,
  }) =>
      ListScrollMoreWidget(
        onLoadMore: onLoadMore,
        canLoadMore: canLoadMore,
        child: this,
      );
}

/// Extension on [int]
extension Integer on int {
  /// Extension function to get random value.
  static int random({int from = 0, int to = 100}) =>
      from + Random().nextInt(to - from);
}

/// Extension on [Color]


const String resetColor = '\x1B[0m';
const String redColor = '\x1B[31m';
const String greenColor = '\x1B[32m';
const String yellowColor = '\x1B[33m';
const String blueColor = '\x1B[34m';
const String magentaColor = '\x1B[35m';
const String cyanColor = '\x1B[36m';

/// ### Extension on Logger.
extension Logger<E> on E {
  /// Extension function to log with an optional [key] value
  E log([String key = '']) {
    dlog(toString(), key: '--> $key');
    return this;
  }
}

extension NavigatorStateExtension on NavigatorState {
  // void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
  //   if (!isCurrentRoute(routeName)) {
  //     pushNamed(routeName, arguments: arguments);
  //   } else {
  //     pop();
  //     pushNamed(routeName, arguments: arguments);
  //   }
  // }

  bool isCurrentRoute(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}

/// Extensions for [Widget]
extension WidgetExtension on Widget {
  /// Shows the progress widget on the center of the [Widget]
  /// need to pass a Provider extended with [MixinProgressProvider]
  Widget showProgressOnCenter<P extends MixinProgressProvider?>({
    double bgOpacity = 0.0,
    bool canEnableBlur = true,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Material(
        child: Consumer<P>(
          builder: (context, provider, _) => Stack(
            children: [
              AbsorbPointer(
                absorbing: provider?.isLoading ?? false,
                child: this,
              ),
              if (provider?.isLoading ?? false)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(bgOpacity),
                      borderRadius: borderRadius,
                    ),
                    child: CustomLoader(
                      canEnableBlur: canEnableBlur,
                      width: 46.sp,
                      height: 46.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  /// Shows the progress widget on the center of the [Widget]
  /// need to pass a Provider extended with [MixinProgressProvider]
  Widget showProgressWithPercentage<P extends MixinProgressProvider?>({
    double bgOpacity = 0.6,
    BorderRadiusGeometry? borderRadius,
  }) =>
      Material(
        child: Consumer<P>(
          builder: (context, provider, _) {
            final isStreaming = provider?.isStreamingEnabled ?? false;
            final streamPercentage =
                ' ${provider?.streamProgressStatus ?? 0} %';

            return Stack(
              children: [
                AbsorbPointer(
                  absorbing: provider?.isStreamingEnabled ?? false,
                  child: this,
                ),
                if (isStreaming)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(bgOpacity),
                        borderRadius: borderRadius,
                      ),
                      child: CustomLoader(
                        height: 46.sp,
                        width: 46.sp,
                        message: provider?.streamProgressMessage,
                        child: isStreaming
                            ? Text(
                                streamPercentage,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.colorWhite,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );

  /// Shows the progress widget on the center of the [Widget]
  /// need to pass 2 Provider extended with [MixinProgressProvider]
  /// it is used to show progress when need to track
  /// [Future] in multiple(2) providers.
  Widget showProgressOnCenter2<P extends MixinProgressProvider?,
      P2 extends MixinProgressProvider?>({
    double bgOpacity = 0.6,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Material(
      child: Consumer2<P, P2>(
        builder: (context, provider, p2, _) {
          final isLoading =
              (provider?.isLoading ?? false) || (p2?.isLoading ?? false);

          return Stack(
            children: [
              AbsorbPointer(
                absorbing: isLoading,
                child: this,
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: borderRadius,
                    ),
                    child: CustomLoader(
                      width: 46.sp,
                      height: 46.sp,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Shows the progress widget on the center of the [Widget]
  /// need to pass 3 Provider extended with [MixinProgressProvider]
  /// it is used to show progress when need to track
  /// [Future] in multiple(2) providers.
  Widget showProgressOnCenter3<P extends MixinProgressProvider?,
      P2 extends MixinProgressProvider?, P3 extends MixinProgressProvider?>({
    double bgOpacity = 0.6,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Material(
      child: Consumer3<P, P2, P3>(
        builder: (context, provider, p2, p3, _) {
          final isLoading = (provider?.isLoading ?? false) ||
              (p2?.isLoading ?? false || (p3?.isLoading ?? false));

          return Stack(
            children: [
              AbsorbPointer(
                absorbing: isLoading,
                child: this,
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(bgOpacity),
                      borderRadius: borderRadius,
                    ),
                    child: CustomLoader(
                      width: 46.sp,
                      height: 46.sp,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget orShowEmptyWidget({
    // ignore: strict_raw_type
    @required List? items,
    bool isLoading = false,
    String text = 'You have no items',
    String subText = '',
    String image = 'no_items',
    double bottomPadding = 0.0,
    double topPadding = 16.0,
    double iconTopPadding = 0.0,
    TextStyle? style,
  }) {
    if (isLoading) return this;
    if (items?.isEmpty ?? true) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(image.asAssetSvg()),
            SizedBox(
              height: 16.spMin,
            ),
            Text(
              text,
              style: tsS24W700.copyWith(
                color: AppColors.primaryTextColor,
              ),
            ),
            SizedBox(
              height: 16.spMin,
            ),
            Text(
              subText,
              style: tsS16W400.copyWith(
                color: AppColors.colorBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return this;
  }
}
