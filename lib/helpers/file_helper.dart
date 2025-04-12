// // ignore_for_file: inference_failure_on_instance_creation

// import 'dart:io';

// import 'package:CyberTrace/helpers/_base_helper.dart';
// import 'package:CyberTrace/utils/app_build_methods.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AppFileHelper extends BaseHelper {

//   static List<Permission> permissions = [];

//   static late Directory directories;

//   static Future<void> hasPermission() async {
//     if (Platform.isAndroid) {
//       final device = await DeviceInformation.platformVersion;
//       if (int.parse(device.replaceAll('Android', '')) > 12) {
//         permissions = [Permission.photos];
//       } else {
//         permissions = [Permission.storage];
//       }
//     } else {
//       permissions = [Permission.storage];
//     }

//     for (final permission in permissions) {
//       // if (Platform.isIOS) {
//       //   if (permission == Permission.manageExternalStorage) continue;
//       // sp// }
//       if (await permission.isGranted) continue;
//       final res = await permission.request();

//       if (res.isRestricted) continue;
//       if (!res.isGranted) showToast('Please accept the permission');
//       if (!res.isGranted) throw Exception('Please accept the permission');
//       await Future.delayed(const Duration(milliseconds: 350));
//     }
//   }

//   static Future<String?> _localPath() async {
//     await hasPermission();
//     if (Platform.isAndroid) {
//       final device = await DeviceInformation.platformVersion;

//       if (int.parse(device.replaceAll('Android', '')) > 12) {
//         directories = await getTemporaryDirectory();
//       } else {
//         directories = (await getExternalStorageDirectory())!;
//       }
//       final path = directories.path;
//       final direcoty = Directory.fromUri(Uri.parse(path));
//       if (!direcoty.existsSync()) {
//         direcoty.createSync();
//       }

//       return path;
    
//     }

//     if (Platform.isIOS) {
//       Directory? directory;

//       directory = await getApplicationDocumentsDirectory();
//       return directory.path;
//     }

//     return '';
//   }

//   static Future<String?> getlocalPath() async {
//     await hasPermission();
//     if (Platform.isAndroid) {
//       final device = await DeviceInformation.platformVersion;

//       if (int.parse(device.replaceAll('Android', '')) > 12) {
//         directories = await getTemporaryDirectory();
//       } else {
//         directories = (await getExternalStorageDirectory())!;
//       }
//       final path = directories.path;
//       final direcoty = Directory.fromUri(Uri.parse(path));
//       if (!direcoty.existsSync()) {
//         direcoty.createSync();
//       }

//       return path;
    
//     }

//     if (Platform.isIOS) {
//       Directory? directory;

//       directory = await getApplicationDocumentsDirectory();
//       return directory.path;
//     }

//     return '';
//   }

//   static Future<String?> getTempDirectory() => hasPermission()
//       .then((_) => getTemporaryDirectory().then((dir) => dir.path));

//   static Future<void> downloadAndOpenFile(
//     String url,
//     String filename, {
//     String? directoryPath,
//   }) async {
//     showToast('Downloading file...');
//     directoryPath ??= await _localPath();

//     if (!(directoryPath?.isNotEmpty ?? false)) {
//       throw Exception('The directory path is null or empty');
//     }

//     String? filePath;
//     try {
//       filePath = await downloadFile(url, filename, directoryPath!);
//     } catch (e) {
//       debugPrint('${e}iii');
//       showToast('Unable to download the file');
//     }
//     // url_launcher.launchUrl(Uri.file(filePath),
//     //     mode: url_launcher.LaunchMode.externalNonBrowserApplication);
//     try {
//       if (filePath?.isNotEmpty ?? false) {
//         await OpenFile.open(filePath);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       showToast('Unable to open the file');
//     }
//   }

//   static void openDownloadedFile(String? filePath) {
//     try {
//       if (filePath?.isNotEmpty ?? false) {
//         OpenFile.open(filePath);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       showToast('Unable to open the file');
//     }
//   }

//   static Future<String> downloadFile(
//     String url,
//     String fileName,
//     String dir,
//   ) async {
//     // HttpClient httpClient = new HttpClient();
//     // File file;
//     final filePath = '$dir/$fileName'.replaceAll('//', '/');

//     try {
//       await Dio().download(url, filePath);
     
//     } catch (ex) {
//       debugPrint(ex.toString());
//       rethrow;
//     }

//     return filePath;
//   }

 
// }