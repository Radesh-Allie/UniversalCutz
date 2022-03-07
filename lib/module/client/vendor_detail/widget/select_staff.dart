import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectStaffView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vendorId;
    if (AppSession.isVendorOwner) {
      vendorId = AppSession.currentUser.uid;
    } else {
      BookController bookController = Get.find();
      vendorId = bookController.selectedVendor["id"];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Your ${config.staffString}",
        ),
      ),
      body: Column(
        children: [
          if (config.setDuration)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Info"),
                    subtitle: Text(
                      "If the driver is not available, it means that the driver has been booked for that hour or the driver is still working at that hour.",
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 6.0,
          ),
          Expanded(
            child: FireStream(
              stream: FirebaseFirestore.instance
                  .collection(collection.vendorCollection)
                  .doc(vendorId)
                  .collection("staffs")
                  .snapshots(
                    includeMetadataChanges: true,
                  ),
              onSnapshot: (querySnapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (context, index) {
                    var item = querySnapshot.docs[index].data();
                    var docId = querySnapshot.docs[index].id;
                    item["id"] = docId;
                    item["staff_products"] = item["staff_products"] ?? [];
                    bool productAvailableForThisStaff = true;

                    if (config.linkProductToStaff) {
                      productAvailableForThisStaff = item["staff_products"]
                          .contains(Input.get("product_item")["id"]);
                    }

                    return Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            item['photo'] ??
                                "https://i.ibb.co/59BxMdr/image-not-available.png",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              return CustomImageBuilder.getImageLoadingBuilder(
                                  context, child, loadingProgress);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['staff_name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Expanded(
                                    child: Text(
                                      item['description'],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  if (!productAvailableForThisStaff)
                                    Text(
                                      "*This staff does not provide for this service",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  if (productAvailableForThisStaff)
                                    FirestoreSelect(
                                      staffId: item["id"],
                                      onPressed: () {
                                        BookController bookController =
                                            Get.find();
                                        bookController.selectedVendor["staff"] =
                                            item;
                                        Get.back();
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
