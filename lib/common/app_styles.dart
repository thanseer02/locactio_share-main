import 'package:base_project/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Inter Regular font style
const interRegular = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
);

/// Inter Medium font style
const interMedium = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
);

/// Inter semi bold font style
const interSemiBold = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w600,
);

/// Inter bold font style
const interBold = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
);

/// Inter extra bold font style
const interExtraBold = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w900,
);

///Button styles
///
/// [tsS16W600] returns [TextStyle] with font size ```16.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsPrimaryButton => interSemiBold.copyWith(
      fontSize: 16.sp,
      color: AppColors.colorWhite,
    );

/// [tsS16W600] returns [TextStyle] with font size ```16.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsDisbledButton => interSemiBold.copyWith(
      fontSize: 16.sp,
      color: AppColors.disabledButtonTextColor,
    );
TextStyle get tsBorderedButton => interSemiBold.copyWith(
      fontSize: 16.sp,
      color: AppColors.colorBlack,
    );

/// [ts34CPrimaryOrange] returns [TextStyle] with font size ```34.sp``` and
/// color ```primaryColor```
TextStyle get ts34CPrimaryOrange => interBold.copyWith(
      fontSize: 34.sp,
      color: AppColors.primaryColor,
    );

/// [ts34CPrimaryOrange] returns [TextStyle] with font size ```34.sp``` and
/// color ```colorBlack```
TextStyle get ts34CBlack => interBold.copyWith(
      fontSize: 34.sp,
      color: AppColors.colorBlack,
    );
TextStyle get tsS12W400 => interRegular.copyWith(
      fontSize: 12.sp,
    );

TextStyle get tsS14W400 => interRegular.copyWith(
      fontSize: 14.sp,
    );
TextStyle get tsS14W400CGrey => interRegular.copyWith(
      fontSize: 14.sp,
      color: AppColors.colorBlack,
    );
TextStyle get tsS16W500 => interMedium.copyWith(
      fontSize: 16.sp,
    );

TextStyle get tsS16W500CBlack =>
    interMedium.copyWith(fontSize: 16.sp, color: AppColors.colorBlack);

TextStyle get ts36W600CBlack => interSemiBold.copyWith(
      fontSize: 36.sp,
      color: AppColors.colorBlack,
    );

/// [tsS24W700CBlack] returns [TextStyle] with font size ```24.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS24W700CBlack => interBold.copyWith(
      fontSize: 24.sp,
      color: AppColors.colorBlack,
    );
TextStyle get tsS14W500CBlack => interMedium.copyWith(
      fontSize: 14.sp,
      color: AppColors.colorBlack,
    );

TextStyle get tsS28W500 => interMedium.copyWith(
      fontSize: 28.sp,
      color: AppColors.colorBlack,
    );

/// [tsSecondaryButton] returns [TextStyle] with font size ```10.sp``` and
/// color ```colorWhite```
TextStyle get tsSecondaryButton => interMedium.copyWith(
      fontSize: 10.sp,
      color: AppColors.colorWhite,
    );

///TS [TextStyle]
///
///w400
/// [tsS16W400] returns [TextStyle] with font size ```16.sp```
TextStyle get tsS16W400 => interRegular.copyWith(
      fontSize: 16.sp,
    );

/// [tsS16W400CBlack] returns [TextStyle] with font size ```16.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS16W400CBlack => interRegular.copyWith(
      fontSize: 16.sp,
      color: AppColors.colorBlack,
    );

/// [tsS12W500] returns [TextStyle] with font size ```12.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS12W500 => interMedium.copyWith(
      fontSize: 12.sp,
    );

/// [tsS14W500] returns [TextStyle] with font size ```14.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS14W500 => interMedium.copyWith(
      fontSize: 14.sp,
    );

/// [tsS13W500] returns [TextStyle] with font size ```13.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS13W500 => interMedium.copyWith(
      fontSize: 13.sp,
    );

/// [tsS13W400] returns [TextStyle] with font size ```13.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS13W400 => interRegular.copyWith(
      fontSize: 13.sp,
    );

/// [tsS18W500] returns [TextStyle] with font size ```18.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS18W500 => interMedium.copyWith(
      fontSize: 18.sp,
    );

/// [tsS15W500] returns [TextStyle] with font size ```15.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS15W500 => interMedium.copyWith(
      fontSize: 15.sp,
    );

///w600
/// [tsS14W600] returns [TextStyle] with font size ```14.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS14W600 => interSemiBold.copyWith(
      fontSize: 14.sp,
    );

/// [tsS16W600] returns [TextStyle] with font size ```16.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS16W600 => interSemiBold.copyWith(
      fontSize: 16.sp,
    );

/// [tsS20W600] returns [TextStyle] with font size ```20.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS20W600 => interSemiBold.copyWith(
      fontSize: 20.sp,
    );

/// [tsS24W600] returns [TextStyle] with font size ```24.sp``` and
/// color ```colorDarkGrey```
TextStyle get tsS24W600 => interSemiBold.copyWith(
      fontSize: 24.sp,
    );

///w700
/// [tsS10W700] returns [TextStyle] with font size ```10.sp```
TextStyle get tsS10W700 => interBold.copyWith(
      fontSize: 10.sp,
    );

/// [tsS10W500] returns [TextStyle] with font size ```10.sp```
TextStyle get tsS10W500 => interMedium.copyWith(
      fontSize: 10.sp,
    );

/// [tsS24W700] returns [TextStyle] with font size ```24.sp```
TextStyle get tsS24W700 => interBold.copyWith(
      fontSize: 24.sp,
    );

/// [tsS20W700] returns [TextStyle] with font size ```20.sp```
TextStyle get tsS20W700 => interBold.copyWith(
      fontSize: 20.sp,
    );

/// [tsS16W700] returns [TextStyle] with font size ```16.sp```
TextStyle get tsS16W700 => interBold.copyWith(
      fontSize: 16.sp,
    );

/// [tsS30W600] returns [TextStyle] with font size ```30.sp```
TextStyle get tsS30W600 => interSemiBold.copyWith(
      fontSize: 30.sp,
    );

/// [tsS40W700] returns [TextStyle] with font size ```40.sp```
TextStyle get tsS40W700 => interBold.copyWith(
      fontSize: 40.sp,
    );

/// [tsS10W400] returns [TextStyle] with font size ```10.sp```
TextStyle get tsS10W400 => interRegular.copyWith(
      fontSize: 10.sp,
    );

/// [tsS14W700] returns [TextStyle] with font size ```14.sp```
TextStyle get tsS14W700 => interBold.copyWith(
      fontSize: 14.sp,
    );
