import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserChatListItem extends StatelessWidget {
  final String userId;
  final String vendorId;
  final int unreadMessageCount;

  UserChatListItem({
    @required this.userId,
    @required this.vendorId,
    @required this.unreadMessageCount,
  });

  @override
  Widget build(BuildContext context) {
    if (!AppSession.isVendorOwner) {
      return FireStreamDocument(
        stream: FirebaseFirestore.instance
            .collection(collection.vendorCollection)
            .doc(vendorId)
            .snapshots(
              includeMetadataChanges: true,
            ),
        onSnapshot: (querySnapshot) {
          var d = querySnapshot.data();
          if(d==null) return Container();

          return InkWell(
            onTap: () {
              Get.to(
                ChatDetailView(
                  orderItem: {
                    "user_id": userId,
                    "vendor_id": vendorId,
                    "user_name": AppSession.currentUser.displayName,
                    "vendor_name": d["vendor_name"],
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: theme.smallRadius,
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(d["photo_url"] == null
                              ? "https://i.ibb.co/F7J1gZj/no-image.jpg"
                              : d["photo_url"]),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(child: Text("${d["vendor_name"]}")),
                        SizedBox(
                          width: 10.0,
                        ),
                        CircleAvatar(
                          radius: 14.0,
                          backgroundColor: unreadMessageCount > 0
                              ? theme.primary
                              : Colors.transparent,
                          child: Text(
                              "${unreadMessageCount > 0 ? unreadMessageCount : ""}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return FireStreamDocument(
        stream: FirebaseFirestore.instance
            .collection(collection.userDataCollection)
            .doc(userId)
            .snapshots(
              includeMetadataChanges: true,
            ),
        onSnapshot: (querySnapshot) {
          var d = querySnapshot.data()["profile"];

          return InkWell(
            onTap: () {
              Get.to(
                ChatDetailView(
                  orderItem: {
                    "user_id": userId,
                    "vendor_id": vendorId,
                    "user_name": d["display_name"],
                    "vendor_name": AppSession.myVendor["vendor_name"],
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: theme.smallRadius,
              ),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(d["photo_url"]),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(child: Text("${d["display_name"]}")),
                        SizedBox(
                          width: 10.0,
                        ),
                        CircleAvatar(
                          radius: 14.0,
                          backgroundColor: unreadMessageCount > 0
                              ? theme.primary
                              : Colors.transparent,
                          child: Text(
                              "${unreadMessageCount > 0 ? unreadMessageCount : ""}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
