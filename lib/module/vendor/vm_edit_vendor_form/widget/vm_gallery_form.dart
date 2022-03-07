import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VmGalleryForm extends StatelessWidget {
  final VmEditVendorFormController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: ExButton(
              width: Get.width,
              label: "Add Photo to Gallery",
              height: 40,
              color: theme.disabled,
              onPressed: () {
                Get.to(VmAddGalleryPhotoFormView());
              },
            ),
          ),
          Expanded(
            child: FireStream(
              stream: FirebaseFirestore.instance
                  .collection(collection.vendorCollection)
                  .doc(AppSession.currentUser.uid)
                  .collection("galleries")
                  .snapshots(
                    includeMetadataChanges: true,
                  ),
              onSnapshot: (querySnapshot){
                

              

                

                return Container(
                  child: Wrap(
                    children: List.generate(
                      querySnapshot.docs.length,
                      (index) {
                        var item = querySnapshot.docs[index].data();
                        var docId = querySnapshot.docs[index].id;
                        item["id"] = docId;

                        return Container(
                          child: Stack(
                            children: [
                              Image.network(
                                item['image'] ?? DataSession.noPhotoUrl,
                                height: 100,
                                width: Get.width / 4,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  return CustomImageBuilder
                                      .getImageLoadingBuilder(
                                          context, child, loadingProgress);
                                },
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: InkWell(
                                  onTap: () async {
                                    showLoading();
                                    await FirebaseFirestore.instance
                                        .collection(collection.vendorCollection)
                                        .doc(AppSession.currentUser.uid)
                                        .collection("galleries")
                                        .doc(docId)
                                        .delete();
                                    hideLoading();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
