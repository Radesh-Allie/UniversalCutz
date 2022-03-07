import 'dart:async';

import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpcomingOrderController extends GetxController {
  List orderList = [];
  Timer timer;

  @override
  void onInit() async {
    super.onInit();
    loadData();

    timer = Timer.periodic(Duration(seconds: 60), (t) {
      loadData();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }

  void loadData() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    var snapshot = await FirebaseFirestore.instance
        .collection(collection.bookingCollection)
        .where("user_id", isEqualTo: AppSession.currentUser.uid)
        .where("status", isEqualTo: "Approved")
        .where("booking_date",
            isLessThanOrEqualTo: DateTime.now().add(Duration(hours: 2)))
        .where("booking_date", isGreaterThan: DateTime.now())
        .orderBy("booking_date")
        .get();
    orderList = snapshot.toList();
    update();

    print("Reload Data..");
  }
}

class UpcomingOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpcomingOrderController>(
      init: UpcomingOrderController(),
      builder: (controller) {
        if (controller.orderList.isEmpty) return Container();
        return Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            bottom: 10.0,
          ),
          child: Card(
            color: theme.primary.withOpacity(0.8),
            child: Container(
              width: Get.width,
              padding: EdgeInsets.only(
                top: 12.0,
                bottom: 12.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text("REMINDER: You have an upcoming book"),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  ExButton(
                    height: 36.0,
                    label: "View",
                    onPressed: () => Get.to(
                      OrderDetailView(orderList: controller.orderList),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
