import 'dart:developer';

import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';

class BookController extends GetxController {
  bool loading = true;
  BookView view;
  Map selectedVendor;

  @override
  void onInit() async {
    super.onInit();
    await selectVendorOnMode();
    loading = false;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void reloadVendor() async {
    loading = true;
    update();

    await selectVendorOnMode();

    loading = false;
    update();
  }

  void selectVendorOnMode() async {
    if (AdminSettingApi?.appSetting["multi_vendor"] == false) {
      var adminUid = await AdminApi.getAdminUid();
      var snapshot = await FirebaseFirestore.instance
          .collection(collection.vendorCollection)
          .doc(adminUid)
          .get();
      selectedVendor = snapshot.data();
      selectedVendor["id"] = adminUid;
      selectedVendor["products"] = await VendorApi.getProducts(adminUid);

      print("ADMIN VENDOR: $selectedVendor");
      print("ADMIN VENDOR PRODUCTS: ${selectedVendor["products"]}");
    }
  }

  List<Map<String, dynamic>> getTimeItems() {
    List<Map<String, dynamic>> items = [];

    var today = DateTime.now();
    DateTime startTime = DateTime(
      today.year,
      today.month,
      today.day,
      8,
      0,
    );

    DateTime endTime = DateTime(
      today.year,
      today.month,
      today.day,
      21,
      0,
    );

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      var label = DateFormat("kk:mm").format(startTime);

      items.add({
        "label": label,
        "value": label,
      });

      startTime = startTime.add(Duration(hours: 1));
    }
    return items;
  }

  String get getVendorPhoto {
    var vendorPhoto;
    if (selectedVendor != null && selectedVendor["staff"] != null) {
      vendorPhoto = selectedVendor["staff"]["photo"] ?? null;
    }
    return vendorPhoto;
  }

  bool get isStaffNotSelected {
    if (selectedVendor["staff"] != null) return false;
    return true;
  }

  bool get isProductNotSelected {
    if (Input.get("product") == null) return true;
    return false;
  }

  getSelectedStaff() {
    return selectedVendor["staff"];
  }

  removeSelectedStaff() {
    selectedVendor["staff"] = null;
    update();
  }

  onBook() async {
    var product = Input.get("product");
    var productDetail = Input.get("product_item");
    var bookingDate = Input.get("booking_date");
    var time = Input.get("time");
    var duration = Input.get("duration") ?? 0;
    var startDate = Input.get("start_date");
    var endDate = Input.get("end_date");

    print("product: $product");
    print("productDetail: $productDetail");
    print("booking_date: $bookingDate");
    print("time: $time");

    if (bookingDate == null) {
      showAlert(
        message: "Booking date is required",
        alertType: AlertType.warning,
      );
      return;
    }

    DateTime bDate = bookingDate;
    var arr = time.split(":");
    bookingDate = DateTime(
      bDate.year,
      bDate.month,
      bDate.day,
      int.parse(arr[0]),
      int.parse(arr[1]),
    );

    showLoading();
    var paymentCard = Input.get("credit_card_item");

    var total = int.parse("${productDetail["qty"]}") *
        double.parse("${productDetail["price"]}");
    if (config.setDuration) {
      productDetail["qty"] = duration;
      total = int.parse(duration) * double.parse(productDetail["price"]);
    }

    var isSuccess = await BookingApi.newBooking({
      "product": product,
      "booking_date": bookingDate,
      "booking_time": time,
      "duration": duration,
      "start_date": startDate,
      "end_date": endDate,
      "created_at": DateTime.now(),
      "expired_at": bookingDate.add(Duration(minutes: 15)),
      "products": [
        productDetail,
      ],
      "total": total,
      "payment_method": {
        "account_type": paymentCard["account_type"],
        "account_title": paymentCard["account_title"],
        "account_number": paymentCard["account_number"].replaceAll(" ", ""),
        "cvc": paymentCard["cvc"],
        "expiration_month": paymentCard["expiration_month"],
        "expiration_year": paymentCard["expiration_year"],
        "memo": "-",
      },
      "vendor": selectedVendor,
      "vendor_name": selectedVendor["vendor_name"],
      "status": "Pending",
      "payment_status": "Pending",
      //-----------
      "user_id": AppSession.currentUser.uid,
      "user_name": AppSession.currentUser.displayName,
      "vendor_id": selectedVendor["id"],
      "staff": selectedVendor["staff"],
    });

    if (isSuccess) {
      var stripeResponse;
      try {
        stripeResponse = await PaymentApi.callNoWebhookPayEndpointMethodId(
          items: [
            {
              "id": productDetail["id"],
              "product_name": productDetail["title"],
              "qty": productDetail["qty"],
              "price": productDetail["price"],
              "total": total,
            }
          ],
          accountNumber: paymentCard["account_number"],
          cvc: paymentCard["cvc"],
          expirationMonth: paymentCard["expiration_month"],
          expirationYear: paymentCard["expiration_year"],
        );
      } on Exception catch (_) {
        //---------------

        print("ERROR: $_");
        print("----------------------");

        await BookingApi.updateBooking(BookingApi.newBookingID, {
          "status": "Failed",
          "payment_status": "Failed",
        });

        hideLoading();

        await showAlert(
          alertType: AlertType.warning,
          message: "Failed to pay this order.",
        );

        await Get.backUntil("$MainNavigationView");
        return;
      }

      log("Stripe Response: $stripeResponse");

      await BookingApi.updateBooking(BookingApi.newBookingID, {
        "status": "Pending",
        "payment_status": "Success",
        "stripe_response": stripeResponse,
      });

      hideLoading();

      await showAlert(
        alertType: AlertType.success,
        message: "Your booking is successful",
      );

      await Get.backUntil("$MainNavigationView");
      return;
    } else {
      hideLoading();

      await showAlert(
        alertType: AlertType.warning,
        message:
            "There is already a booking at this hour.\nChoose another time.",
      );
    }
  }

  DateTime getFirstDate() {
    DateTime now = DateTime.now().add(Duration(days: 1));

    return DateTime(
      now.year,
      now.month,
      now.day,
      0,
      0,
    );
  }
}
