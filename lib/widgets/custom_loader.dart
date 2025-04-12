import 'dart:math' as math;
import 'dart:ui';
import 'package:ODMGear/common/app_colors.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


///[CustomLoader]
class CustomLoader extends StatefulWidget {
  ///loader used for when the api call occur
  const CustomLoader({
    super.key,
    this.height = 45,
    this.width = 45,
    this.child,
    this.message,
    this.canEnableBlur = true,
  });

  ///[height]
  final double height;

  ///[width]

  final double width;

  ///[child]
  final Widget? child;

  ///[message]
  final String? message;

  ///
  final bool? canEnableBlur;
  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.canEnableBlur! ? 0 : 0,
          sigmaY: widget.canEnableBlur! ? 0 : 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Transform.rotate(
                    angle: angle,
                    child: Container(
                      height: widget.height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('orange loader.png'.asAssetImg()),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: widget.child != null
                          ? Transform.rotate(
                              angle: -angle,
                              child: Center(child: widget.child),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 15.0.sp,
                bottom: 10.0.sp,
                left: 10.0.sp,
                right: 10.0.sp,
              ),
              child: Text(
                widget.message ?? 'loading',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get angle {
    return _controller.status == AnimationStatus.forward
        ? (math.pi * 2) * _controller.value
        : -(math.pi * 2) * _controller.value;
  }
}
