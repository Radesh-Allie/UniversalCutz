import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VmAddStaffFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ${config.staffString}"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExButton(
              label: "Save",
              onPressed: () async {
                String staffName = Input.get("staff_name");
                String photo = Input.get("photo");
                String description = Input.get("description");
                List staffProducts = Input.get("product");

                if (staffName.isEmpty) {
                  showSnackbar(
                    message: "Vendor name is required",
                    backgroundColor: theme.danger,
                  );
                  return;
                }

                showLoading();
                await VendorApi.addVendor(
                  staffName: staffName,
                  photo: photo,
                  description: description,
                  staffProducts: staffProducts,
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
              id: "photo",
              label: "Photo",
            ),
            ExTextField(
              id: "staff_name",
              label: "Vendor Name",
            ),
            if (config.linkProductToStaff)
              ExStreamCheckbox(
                id: "product",
                label: "${config.productString}",
                valueField: "id",
                displayField: "title",
                stream: FirebaseFirestore.instance
                    .collection(collection.vendorCollection)
                    .doc(AppSession.currentUser.uid)
                    .collection("products")
                    .snapshots(),
              ),
            ExMemoField(
              id: "description",
              label: "Description",
            ),
          ],
        ),
      ),
    );
  }
}
