import 'package:ODMGear/common/app_colors.dart';
import 'package:ODMGear/common/app_styles.dart';
import 'package:ODMGear/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StaggeredGoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double staggerAmount;

  const StaggeredGoogleSignInButton({
    Key? key,
    this.onPressed,
    this.staggerAmount = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.spMin,
      child: Stack(
        children: [
          // Background layer (staggered effect)
          Positioned(
            top: staggerAmount,
            left: staggerAmount,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.spMin),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
          ),

          // Main button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.chatBoxColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.spMin,
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              minimumSize: Size(
                double.infinity,
                50.spMin,
              ),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  height: 24.spMin,
                  width: 24.spMin,
                  'google'.asAssetSvg(),
                ),
                SizedBox(width: 12.spMin),
                Text(
                  'Sign in with Google',
                  style: tsS16W500.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
