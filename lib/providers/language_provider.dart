// // ignore_for_file: avoid_setters_without_getters

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:hail_driver/utils/sp_keys.dart';
// import 'package:hail_driver/utils/sp_utils.dart';

// /// A provider class for app localization.
// class LanguageProvider extends ChangeNotifier {
//   /// Build context
//   static BuildContext? context;

//   /// Setter method for [BuildContext].
//   static set initContext(BuildContext? ctx) {
//     context = ctx;
//   }

//   /// Getter method for [AppLocalizations] object.
//   static AppLocalizations? get appLocalizations {
//     if (context == null) {
//       throw Exception(
//         '''Context is not initialised. '''
//         '''Please call LanguageProvider.initContext(context) in builder '''
//         '''method or within context.''',
//       );
//     }
//     return AppLocalizations.of(context!);
//   }

//   Locale _locale = const Locale('en', 'US');

//   /// Getter & Setter for current active [Locale].
//   Locale get locale => _locale;
//   set setLocale(Locale value) {
//     _locale = value;
//     _saveLanguagePreference(value.languageCode);
//     notifyListeners();
//   }

//   /// Save the selected language to Shared Pref.
//   Future<bool?> _saveLanguagePreference(String code) async {
//     return SPUtils.saveString(keyLanguageCode, code);
//   }
// }
