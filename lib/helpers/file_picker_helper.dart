// // ignore_for_file: use_build_context_synchronously

// import 'dart:io' as io;

// import 'package:ODMGear/common/app_colors.dart';
// import 'package:ODMGear/helpers/_base_helper.dart';
// import 'package:ODMGear/helpers/file_helper.dart';
// import 'package:ODMGear/utils/multi_media_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

// class FilePickerHelper extends BaseHelper {
//   static Future<List<io.File>?> pickDocuments(BuildContext context) async {
//     final buildContext = context;
//     await AppFileHelper.hasPermission();

//     // ignore: inference_failure_on_instance_creation
//     await Future.delayed(const Duration(milliseconds: 350));
//     final files = await showMultiMediaPicker(
//       context: buildContext,
//       onTapGallery: () async {
//         try {
//           final result = await FilePicker.platform.pickFiles(
//             type: FileType.custom,
//             allowMultiple: true,
//             allowedExtensions: [
//               'jpg',
//               'jpeg',
//               'JPEG',
//               'pdf',
//               'doc',
//               'png',
//               'JPG',
//               'PDF',
//               'DOC',
//               'PNG',
//             ],
//           );
//           final files = result?.files
//               .map<io.File>((e) => io.File.fromUri(Uri.parse(e.path!)))
//               .toList();
//           Navigator.of(context).pop(files);
//         } on PlatformException catch (ex) {
//           debugPrint(ex.toString());
//           throw Exception(
//             // "Please accept the permission"

//             'Please accept the permission',
//           );
//         } catch (ex) {
//           debugPrint(ex.toString());
//           rethrow;
//         }
//       },
//       onTapCamera: () async {
//         try {
//           final imagePicker = ImagePicker();
//           final camXFile = await imagePicker.pickImage(
//             source: ImageSource.camera,
//             imageQuality: 40,
//           );
//           final camImage = io.File(camXFile?.path ?? '');
//           final file =
//               await ImageCrop.cropImageFile(camImage.path).then((value) {
//             if (value.isNotEmpty) {
//               final file = io.File(value);
//               return file;
//             }
//           });
//           if (file == null) return;

//           Navigator.of(context).pop([file]);
//         } catch (ex) {
//           debugPrint(ex.toString());
//           rethrow;
//         }
//       },
//     );
//     return files;
//   }

//   static Future<List<io.File>?> pickImage({
//     required BuildContext context,
//     bool enableVideo = false,
//   }) async {
//     // try {
//     //   await AppFileHelper.hasPermission();
//     // } on Exception catch (e) {
//     //   debugPrint(e.toString());
//     // }
//     final files = await showMultiMediaPicker(
//       context: context,
//       enableVideo: enableVideo,
//       onTapGallery: () async {
//         try {
//           await AppFileHelper.hasPermission();
//           final result = await FilePicker.platform.pickFiles(
//             type: FileType.image,
//           );

//           final files = result?.files
//               .map<io.File>((e) => io.File.fromUri(Uri.parse(e.path!)))
//               .toList();

//           final file =
//               await ImageCrop.cropImageFile(files!.first.path).then((value) {
//             if (value.isNotEmpty) {
//               final file = io.File(value);
//               return file;
//             }
//           });
//           if (file == null) return;
//           Navigator.of(context).pop([file]);
//         } catch (ex) {
//           debugPrint(ex.toString());

//           rethrow;
//         }
//       },
//       onTapCamera: () async {
//         try {
//           final imagePicker = ImagePicker();
//           final camXFile = await imagePicker.pickImage(
//             source: ImageSource.camera,
//             imageQuality: 40,
//           );
//           final camImage = io.File(camXFile?.path ?? '');
//           final file =
//               await ImageCrop.cropImageFile(camImage.path).then((value) {
//             if (value.isNotEmpty) {
//               final file = io.File(value);
//               return file;
//             }
//           });
//           if (file == null) return;

//           Navigator.of(context).pop([file]);
//         } catch (ex) {
//           debugPrint(ex.toString());
//           rethrow;
//         }
//       },
//       onTapVideo: () async {
//         try {
//           final imagePicker = ImagePicker();
//           final camXFile = await imagePicker.pickVideo(
//             source: ImageSource.camera,
//             maxDuration: const Duration(seconds: 15),
//           );
//           final camVideo = io.File(camXFile?.path ?? '');
//           Navigator.of(context).pop([camVideo]);
//         } on Exception catch (e) {
//           debugPrint(e.toString());
//         }
//       },
//     );
//     return files;
//   }
// }

// class ImageCrop {
//   static Future<String> cropImageFile(String path) async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: path,
//       maxWidth: 1024,
//       maxHeight: 1024,
  
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Cropper',
//           toolbarColor: AppColors.primaryButtonColor,
//           toolbarWidgetColor: AppColors.colorWhite,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//       ],
//     );
//     return croppedFile?.path ?? '';
//   }
// }
