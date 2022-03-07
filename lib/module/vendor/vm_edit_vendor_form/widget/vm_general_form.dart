import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VmGeneralForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ExTextField(
            id: "vendor_name",
            label: "Vendor Name",
            value: AppSession.myVendor["vendor_name"],
          ),
          ExImgBbImagePicker(
            id: "photo_url",
            label: "Photo",
            value: AppSession.myVendor["photo_url"],
          ),
          ExTextField(
            id: "phone",
            label: "Phone",
            value: AppSession.myVendor["phone"],
          ),
          ExTextField(
            id: "website",
            label: "Website",
            value: AppSession.myVendor["website"],
          ),
          ExLocationPicker(
            id: "location",
            label: "Location",
            latitude: AppSession.myVendor["latitude"],
            longitude: AppSession.myVendor["longitude"],
          ),
          ExMemoField(
            id: "address",
            label: "Address",
            value: AppSession.myVendor["address"],
          ),
          ExMemoField(
            id: "about_us",
            label: "About Us",
            value: AppSession.myVendor["about_us"],
          ),
        ],
      ),
    );
  }
}
