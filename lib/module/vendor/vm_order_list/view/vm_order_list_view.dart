import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:intl/intl.dart';

class VmOrderListView extends StatelessWidget {
  final controller = Get.put(VmOrderListController());

  @override
  Widget build(BuildContext context) {
    controller.view = this;

    return GetBuilder<VmOrderListController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Order List"),
            actions: [
              InkWell(
                onTap: () {
                  Get.to(ChatView());
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    right: 8.0,
                  ),
                  child: VmChatCount(),
                ),
              ),
              InkWell(
                onTap: () => Get.to(VmOrderCalendarView()),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: theme.normalPadding,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => controller.updateFilter(0),
                        child: Card(
                          color: controller.selectedFilterIndex == 0
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Pending"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.updateFilter(1),
                        child: Card(
                          color: controller.selectedFilterIndex == 1
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Approved"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.updateFilter(2),
                        child: Card(
                          color: controller.selectedFilterIndex == 2
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Rejected"),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.updateFilter(3),
                        child: Card(
                          color: controller.selectedFilterIndex == 3
                              ? theme.primary
                              : Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Failed"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FireStream(
                    stream: FirebaseFirestore.instance
                        .collection(collection.bookingCollection)
                        .where("vendor_id",
                            isEqualTo: AppSession.currentUser.uid)
                        .where("status", isEqualTo: controller.filterStatus)
                        .orderBy("booking_date")
                        .snapshots(
                          includeMetadataChanges: true,
                        ),
                    onSnapshot: (querySnapshot) {
                      return ListView.builder(
                        itemCount: querySnapshot.size,
                        itemBuilder: (context, index) {
                          var item = querySnapshot.docs[index].data();
                          item["id"] = querySnapshot.docs[index].id;
                          return Container(
                            child: Column(
                              children: [
                                Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${item["user_name"]}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            ExButton(
                                              label: "Rate",
                                              height: 26.0,
                                              fontSize: 10.0,
                                              onPressed: () {
                                                Get.to(
                                                  RateView(
                                                    item: item,
                                                    orderId: item["id"],
                                                    rateClient: true,
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(ChatDetailView(
                                                  orderItem: item,
                                                ));
                                              },
                                              child: Icon(
                                                Icons.chat,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: theme.primary,
                                        ),
                                        ListItem(
                                          label: "Date",
                                          value:
                                              "${friendlydate(item["booking_date"])}",
                                        ),
                                        ListItem(
                                          label: "Time",
                                          value:
                                              "${DateFormat("kk:mm").format(item["booking_date"].toDate())}",
                                        ),
                                        ListItem(
                                          label: "${config.vendorString}",
                                          value: "${item["vendor_name"]}",
                                        ),
                                        ListItem(
                                          label: "${config.staffString}",
                                          value:
                                              "${item["staff"] == null ? "-" : item["staff"]["staff_name"]}",
                                        ),
                                        if (config.setDuration) ...[
                                          Divider(),
                                          ListItem(
                                            label: "Duration",
                                            value:
                                                "${item["duration"] ?? 0}Hour(s)",
                                            valueStyle: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (item["products"] != null) ...[
                                            ListItem(
                                              label: "Price",
                                              value:
                                                  "\$${item["products"][0]["price"]} /Hour(s)",
                                              valueStyle: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ListItem(
                                              label: "Total",
                                              value: "\$${item["total"] ?? 0}",
                                              valueStyle: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(),
                                          ],
                                        ],
                                        Divider(),
                                        ListItem(
                                          label: "Status",
                                          value: "${item["status"]}",
                                          valueStyle: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ListItem(
                                          label: "Payment Status",
                                          value:
                                              "${item["payment_status"] ?? "-"}",
                                          valueStyle: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(),
                                        ListItem(
                                          label: "Created At",
                                          value:
                                              "${friendlydate(item["created_at"].toDate())}",
                                          valueStyle: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        ListItem(
                                          label: "Expired At",
                                          value:
                                              "${friendlydate(item["expired_at"].toDate())}",
                                          valueStyle: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        Divider(
                                          color: theme.primary,
                                        ),
                                        Divider(
                                          color: theme.primary,
                                        ),
                                        if (controller.selectedFilterIndex == 0)
                                          Container(
                                            child: Row(
                                              children: [
                                                ExButton(
                                                  label: "",
                                                  icon: FlutterIcons
                                                      .file_invoice_faw5s,
                                                  iconSize: 16.0,
                                                  height: 36.0,
                                                  onPressed: () => Get.to(
                                                    OrderInvoiceDetailView(
                                                      item: item,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                ExButton(
                                                  label: "",
                                                  icon: Icons.phone,
                                                  iconSize: 16.0,
                                                  height: 36.0,
                                                  onPressed: () =>
                                                      controller.doCall(item),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  child: ExButton(
                                                    label: "Approve",
                                                    height: 40.0,
                                                    fontSize: 10.0,
                                                    onPressed: () => controller
                                                        .doApprove(item),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Expanded(
                                                  child: ExButton(
                                                    label: "Reject",
                                                    height: 40.0,
                                                    fontSize: 10.0,
                                                    onPressed: () => controller
                                                        .doReject(item),
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
                          );
                        },
                      );
                    },
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
