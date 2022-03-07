import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:barber_app/core.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';


FilePickerCross pickedFileInImagePicker;
FilePickerResult filePickerResult;

class ExImgBbImagePicker extends StatefulWidget {
  final String id;
  final String label;
  final String value;

  ExImgBbImagePicker({
    this.id,
    this.label,
    this.value,
  });

  @override
  _ExImgBbImagePickerState createState() => _ExImgBbImagePickerState();
}

class _ExImgBbImagePickerState extends State<ExImgBbImagePicker> {
  String imageUrl;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    pickedFileInImagePicker = null;
    imageUrl = widget.value;
    Input.set(widget.id, imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    log("imageUrl: $imageUrl");

    return InkWell(
      onTap: () async {
        if (loading) return;
        if (kIsWeb) {
          FilePickerCross myFile = await FilePickerCross.importFromStorage(
            type: FileTypeCross.custom,
            fileExtension: 'jpg, png',
          );

          loading = true;
          setState(() {});

          final form = FormData({
            'image': MultipartFile(
              myFile.toUint8List(),
              filename: myFile.fileName,
            ),
          });

          var res = await GetConnect().post(
            'https://api.imgbb.com/1/upload?expiration=600&key=b55ef3fd02b80ab180f284e479acd7c4',
            form,
          );

          var data = res.body["data"];
          var url = data["url"];
          print(url);

          imageUrl = url;
          Input.set(widget.id, imageUrl);
          setState(() {});

          loading = false;
          setState(() {});
        } else {
          filePickerResult = await FilePicker.platform.pickFiles(
            allowMultiple: false,
          );
          if (filePickerResult == null) return;
          if (filePickerResult.files.isEmpty) return;

          loading = true;
          setState(() {});

          var file = filePickerResult.files[0];
          var filename = Uuid().v1() + "_" + path.basename(file.name);
          //Compress Image
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          String targetpath = "$tempPath/$filename";
          File targetFile = File(targetpath);

          await FlutterImageCompress.compressAndGetFile(
            file.path,
            targetpath,
            quality: 50,
          );

          final form = FormData({
            'image': MultipartFile(
              targetFile.readAsBytesSync(),
              filename: "upload.jpg",
            ),
          });

          var res = await GetConnect().post(
            'https://api.imgbb.com/1/upload?expiration=600&key=b55ef3fd02b80ab180f284e479acd7c4',
            form,
          );

          var data = res.body["data"];
          var url = data["url"];
          print(url);

          imageUrl = url;
          Input.set(widget.id, imageUrl);
          setState(() {});

          loading = false;
          setState(() {});
        }
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text(widget.label),
            ),
            SizedBox(
              height: 4.0,
            ),
            if (loading) ...[
              Container(
                height: 120.0,
                width: 160.0,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
            if (!loading) ...[
              if (imageUrl != null)
                Container(
                  height: 120.0,
                  width: 160.0,
                  child: Image.network(
                    imageUrl,
                    height: 100,
                    width: Get.width / 3,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      return CustomImageBuilder.getImageLoadingBuilder(
                          context, child, loadingProgress);
                    },
                  ),
                ),
              if (imageUrl == null)
                Container(
                  height: 120.0,
                  width: 160.0,
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
