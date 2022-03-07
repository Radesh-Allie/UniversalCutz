import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class SelectedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var productItem = Input.get("product_item");

    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                ),
                Text(
                  "${config.productString}",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  productItem["label"],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: Get.width,
                ),
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  "${AppSession.currency}${productItem["price"]}",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
