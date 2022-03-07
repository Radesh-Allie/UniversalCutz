import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookDetailView extends StatelessWidget {
  final controller = Get.put(BookDetailController());

  @override
  Widget build(BuildContext context) {
    controller.view = this;

    return GetBuilder<BookDetailController>(
      builder: (_) {
        var product = Input.get("product_item");
        var total = 0.0;
        var bookingDate = (Input.get("booking_date") as DateTime);
        var bookingTime = Input.get("time") ?? "08:00";

        var bookingDateString = DateFormat("yyyy-MM-dd").format(bookingDate);
        bookingDate = DateTime.parse("$bookingDateString $bookingTime");

        var endDate = (Input.get("booking_date") as DateTime);

        if (config.setDuration) {
          var duration = Input.get("duration");
          endDate = bookingDate.add(Duration(hours: int.parse(duration)));

          total = double.parse("${Input.get("duration")}") *
              double.parse("${product["price"]}");
        }

        Input.set("start_date", bookingDate);
        Input.set("end_date", endDate);

        return Scaffold(
          appBar: AppBar(
            title: Text("Confirm Your Order"),
          ),
          bottomNavigationBar: Container(
            height: 80.0,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (controller.selectedCreditCard == null) {
                  showSnackbar(message: "Please, select any payment method");
                  return;
                }

                BookController bookController = Get.find();
                bookController.onBook();
              },
              child: Text("Pay"),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SelectedVendor(
                        changeAble: false,
                      ),
                    ),
                    Expanded(
                      child: SelectedStaff(
                        changeAble: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SelectedProduct(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectedDate(),
                      ),
                      Expanded(
                        child: SelectedTime(),
                      ),
                      Divider(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                if (config.multipleProducts) ...[
                  Divider(),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "${product["qty"]} Day(s) x ${AppSession.currency}${product["price"]}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Total: ${AppSession.currency}$total",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                Divider(),
                if (config.setDuration) ...[
                  Card(
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Duration:",
                          ),
                          Text("${Input.get("duration")} Hours"),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            "Start At:",
                          ),
                          Text(
                            "${DateFormat("d MMM y kk:mm").format(bookingDate)}",
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            "End At:",
                          ),
                          Text(
                            "${DateFormat("d MMM y kk:mm").format(endDate)}",
                          ),
                          Divider(),
                          Text(
                            "Price/Hour:",
                          ),
                          Text("\$${product["price"]}/Hour(s)"),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "\$${total}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(
                  height: 10.0,
                ),
                if (controller.selectedCreditCard != null)
                  Card(
                    child: ListTile(
                      title: Text(
                        controller.selectedCreditCard["account_title"],
                      ),
                      subtitle: Text(
                        controller.selectedCreditCard["account_number"]
                            .toString()
                            .toCreditCardFormat(),
                      ),
                      trailing: ElevatedButton(
                        child: Text("Change"),
                        onPressed: () async {
                          await Get.to(SelectCreditCardView(
                            id: "credit_card",
                          ));

                          if (Input.get("credit_card_item") != null)
                            controller.setPaymentMethodTo(
                                Input.get("credit_card_item"));
                        },
                      ),
                    ),
                  ),
                if (config.setDuration) ...[],
                if (controller.selectedCreditCard == null)
                  ExButton(
                    width: Get.width,
                    label: "Select Credit Card",
                    onPressed: () async {
                      await Get.to(SelectCreditCardView(
                        id: "credit_card",
                      ));
                      print(Input.get("credit_card"));

                      controller
                          .setPaymentMethodTo(Input.get("credit_card_item"));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
