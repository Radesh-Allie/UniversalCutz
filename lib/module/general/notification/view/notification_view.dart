import 'package:barber_app/core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class NotificationView extends StatelessWidget {
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    controller.view = this;

    return GetBuilder<NotificationController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Notification"),
            actions: [
              if (kDebugMode)
                InkWell(
                  onDoubleTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ExButton(
                      label: "Test Notification",
                      onPressed: () {
                        NotificationApi.createNotificationFor(
                          targetUserId: AppSession.userId,
                          title: "Test",
                          message: "Test MEssage Success",
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FireStream(
              stream: userCollection
                  .collection("notification")
                  .orderBy("created_at", descending: true)
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

                    return Container(
                      decoration: BoxDecoration(
                        color: theme.backgroundColor.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: ListTile(
                        title: Text(
                          "${item["title"]}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "${item["body"]}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
