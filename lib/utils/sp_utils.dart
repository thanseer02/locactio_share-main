import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hail_driver/utils/extensions.dart';
import 'package:hail_driver/utils/sp_keys.dart';
import 'package:hail_driver/utils/utils.dart';

/// [SPUtils] - Secure Storage Utility class.
class SPUtils {
  static FlutterSecureStorage? _ss;

  static FlutterSecureStorage _secureInstance() {
    _ss ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    return _ss!;
  }

  /// Save a [String] value to Shared Preference.
  /// [key] - A string to identify the saved value.
  /// [value] - The value to be saved.
  static Future<bool> saveString(String key, String value) async {
    try {
      await _secureInstance().write(key: key, value: value);
      return true;
    } catch (e) {
      dlog(e.toString());
    }
    return false;
  }

  /// Returns the saved string value.
  /// [key] name given to save.
  static Future<String?> getString(String key) async {
    try {
      final value = _secureInstance().read(key: key);
      return value;
    } catch (e) {
      dlog(e.toString());
    }
    return null;
  }

  /// Save a [bool] value to Shared Preference.
  /// [key] - A string to identify the saved value.
  /// [value] - The value to be saved.
  static Future<bool> saveBoolean(String key, {required bool value}) async {
    try {
      await _secureInstance().write(key: key, value: value.toString());
      return true;
    } catch (e) {
      dlog(e.toString());
    }
    return false;
  }

  /// Returns the saved string value.
  /// [key] name given to save.
  static Future<bool?> getBoolean(String key) async {
    try {
      final savedValue = await _secureInstance().read(key: key);
      if (savedValue == null) {
        return null;
      }
      return bool.parse(savedValue);
    } catch (e) {
      dlog(e.toString());
    }
    return null;
  }

  /// Clear all secure storage value
  static Future<void> clearLogoutValues() async {
    try {
      await _secureInstance().delete(key: keyToken);
    } catch (e) {
      e.log('clearLogoutValues');
    }
  }
}
