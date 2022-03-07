import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VmAddGalleryPhotoFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Photo to Gallery"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExButton(
              label: "Save",
              onPressed: () async {
                String image = Input.get("image");
                if (image.isEmpty) {
                  showSnackbar(
                    message: "Photo is required",
                    backgroundColor: theme.danger,
                  );
                  return;
                }

                showLoading();
                await VendorApi.addGalleryPhoto(
                  image: Input.get("image"),
                );
                hideLoading();

                Get.back();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExImgBbImagePicker(
              id: "image",
              label: "Photo",
            ),
          ],
        ),
      ),
    );
  }
}
