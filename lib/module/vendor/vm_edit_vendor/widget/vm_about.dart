import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VmAboutView extends StatelessWidget {
  final dynamic item;
  VmAboutView({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //ABOUT
            Text(
              'Why Choose Us',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              '${item["about_us"]}',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
