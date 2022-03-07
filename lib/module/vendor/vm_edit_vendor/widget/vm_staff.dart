import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VmStaffView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FireStream(
      stream: FirebaseFirestore.instance
          .collection(collection.vendorCollection)
          .doc(AppSession.currentUser.uid)
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

            print(item);
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
                          Text(
                            item['description'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                            ),
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
    );
  }
}
