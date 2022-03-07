import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetailView extends StatelessWidget {
  final Map orderItem;
  ChatDetailView({
    this.orderItem,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatDetailController>(
      init: ChatDetailController(
        orderItem: orderItem,
      ),
      builder: (controller) {
        controller.displayedDateList.clear();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.disabled,
            title: Row(
              children: [
                if (!controller.loading)
                  CircleAvatar(
                    backgroundImage: NetworkImage(AppSession.isVendorOwner
                        ? controller.Vendor["photo_url"]
                        : controller.Vendor["photo_url"]),
                  ),
                SizedBox(
                  width: 10.0,
                ),
                if (!controller.loading)
                  Text(
                      "${AppSession.isVendorOwner ? orderItem["user_name"] : orderItem["vendor_name"]}"),
              ],
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      var item = controller.items[index];

                      bool isMe =
                          item["sender"] == AppSession.currentUser.uid;

                      DateTime createdDate = DateTime.parse(item["created_at"]);
                      // var message = "${item["message"]}";

                      var dateString =
                          DateFormat("d MMM y").format(createdDate);
                      var todayDateString =
                          DateFormat("d MMM y").format(DateTime.now());
                      var yesterdayDateString = DateFormat("d MMM y")
                          .format(DateTime.now().subtract(Duration(days: 1)));

                      bool displayGroup = false;

                      if (controller.displayedDateList.indexOf(dateString) ==
                          -1) {
                        displayGroup = true;
                        controller.displayedDateList.add(dateString);
                      }

                      if (dateString == todayDateString) {
                        dateString = "Today";
                      }

                      if (dateString == yesterdayDateString) {
                        dateString = "Yesterday";
                      }
                      controller.updateReadStatus(item);

                      return Column(
                        children: [
                          if (displayGroup)
                            Card(
                              child: Container(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "$dateString",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: Get.width - (Get.width / 4),
                                    minWidth: 74,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Color(0xffDCF8C8)
                                        : theme.secondary,
                                    borderRadius: theme.mediumRadius,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: Get.width / 2.2,
                                        ),
                                        padding: EdgeInsets.only(
                                          bottom: 14.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                "${item["message"]}",
                                                style: TextStyle(
                                                  color: Colors.grey[900],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          child: Wrap(
                                            children: [
                                              Text(
                                                "${DateFormat("jm").format(DateTime.parse(item["created_at"]))}",
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 9.0,
                                                ),
                                              ),
                                              if (isMe)
                                                SizedBox(
                                                  width: 2.0,
                                                ),
                                              if (isMe)
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Icon(
                                                        Icons.check,
                                                        color: item["unread"] ==
                                                                false
                                                            ? Colors.blue
                                                            : Colors.grey[600],
                                                        size: 10.0,
                                                      ),
                                                      if (item["unread"] ==
                                                          false)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 2.0),
                                                          child: Icon(
                                                            Icons.check,
                                                            color:
                                                                item["unread"] ==
                                                                        false
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors.grey[
                                                                        600],
                                                            size: 10.0,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  color: theme.disabled,
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ExChatField(
                          id: "message",
                          hintText: "Message",
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                        onTap: () => controller.sendMessage(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.send,
                          ),
                        ),
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
