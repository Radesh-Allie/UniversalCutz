// @Dont use this class, doesnt work on web version
// import 'dart:io' as io;
// import 'dart:io';
// import 'package:path/path.dart' as path;

// import 'package:barber_app/core.dart';
// import 'package:file_picker_cross/file_picker_cross.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firestorage;
// import 'package:uuid/uuid.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';

// FilePickerCross pickedFileInImagePicker;
// FilePickerResult filePickerResult;

// class ExFirestoreImagePicker extends StatefulWidget {
//   final String id;
//   final String label;
//   final String value;

//   ExImgBbImagePicker({
//     this.id,
//     this.label,
//     this.value,
//   });

//   @override
//   _ExFirestoreImagePickerState createState() => _ExFirestoreImagePickerState();
// }

// class _ExFirestoreImagePickerState extends State<ExFirestoreImagePicker> {
//   String imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     pickedFileInImagePicker = null;
//     imageUrl = widget.value;
//     Input.set(widget.id, imageUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         if (io.Platform.isAndroid) {
//           filePickerResult = await FilePicker.platform.pickFiles(
//             allowMultiple: false,
//           );
//           if (filePickerResult == null) return;
//           if (filePickerResult.files.isEmpty) return;

//           showLoading();
//           var file = filePickerResult.files[0];
//           var filename = Uuid().v1() + "_" + path.basename(file.name);
//           //Compress Image
//           Directory tempDir = await getTemporaryDirectory();
//           String tempPath = tempDir.path;
//           String targetpath = "$tempPath/$filename";
//           File targetFile = File(targetpath);

//           await FlutterImageCompress.compressAndGetFile(
//             file.path,
//             targetpath,
//             quality: 50,
//           );

//           print(filename);

//           firestorage.UploadTask uploadTask;
//           firestorage.Reference ref = firestorage.FirebaseStorage.instance
//               .ref()
//               .child('uploads')
//               .child('/$filename');

//           final metadata = firestorage.SettableMetadata(
//               contentType: 'image/jpeg',
//               customMetadata: {'picked-file-path': targetFile.path});

//           if (kIsWeb) {
//             uploadTask = ref.putData(targetFile.readAsBytesSync(), metadata);
//           } else {
//             uploadTask = ref.putFile(io.File(targetFile.path), metadata);
//           }

//           uploadTask.whenComplete(() async {
//             var firebaseUrl = await ref.getDownloadURL();

//             var cleanUrl = firebaseUrl.split("&token")[0];
//             imageUrl = cleanUrl;
//             print("Clean Url: $cleanUrl");
//             Input.set(widget.id, imageUrl);
//             setState(() {});
//             hideLoading();
//           });
//         }
//       },
//       child: Container(
//         width: Get.width,
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 4.0,
//                 right: 4.0,
//                 top: 4.0,
//                 bottom: 4.0,
//               ),
//               child: Text(widget.label),
//             ),
//             SizedBox(
//               height: 4.0,
//             ),
//             if (imageUrl != null)
//               Container(
//                 height: 120.0,
//                 width: 160.0,
//                 child: Image.network(
//                   imageUrl,
//                   height: 100,
//                   width: Get.width / 3,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     return CustomImageBuilder.getImageLoadingBuilder(
//                         context, child, loadingProgress);
//                   },
//                 ),
//               ),
//             if (imageUrl == null)
//               Container(
//                 height: 120.0,
//                 width: 160.0,
//                 child: Center(
//                   child: Icon(
//                     Icons.photo,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
