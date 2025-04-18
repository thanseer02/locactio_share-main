import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<List<io.File>?> showMultiMediaPicker({
  required BuildContext context,
  required GestureTapCallback onTapGallery,
  required GestureTapCallback onTapCamera,
  GestureTapCallback? onTapVideo,
  bool enableVideo = false,

  // required Function(XFile? image) callAPI,
}) async {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    elevation: 10,
    builder: (BuildContext bc) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 15.spMin,
                left: 25.spMin,
              ),
              child: const Text(
                // 'Upload Image',
                'Upload Image',
             
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
              ),
              title: const Text(
                //'Gallery',
                'Gallery',
                style: TextStyle(
                ),
              ),
              onTap: onTapGallery,
              // onTap: () {
              //   // _imgFromGallery(callAPI: callAPI);
              //   // Navigator.pop(context);
              // },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_camera,
              ),
              title: const Text(
                //'Camera',
                'Camera',
                style: TextStyle(
                ),
              ),
              onTap: onTapCamera,
              // onTap: () {
              //   // _imgFromCamera(callAPI: callAPI);
              //   // Navigator.pop(context);
              // },
            ),
          ],
        ),
      );
    },
  );
}
