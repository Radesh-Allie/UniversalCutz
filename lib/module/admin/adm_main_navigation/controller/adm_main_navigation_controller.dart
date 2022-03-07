

import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdmMainNavigationController extends GetxController {
  AdmMainNavigationView view;
  String adminUid;
  List vendorListUids = [];

  @override
  void onInit() async {
    super.onInit();

    var adminSnapshot = await FirebaseFirestore.instance
        .collection(collection.adminCollection)
        .get();
    adminUid = adminSnapshot.docs[0].data()["uid"];

    var vendorListSnapshot = await FirebaseFirestore.instance
        .collection(collection.vendorCollection)
        .get();
    vendorListSnapshot.docs.forEach((doc) {
      vendorListUids.add(doc.id);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
