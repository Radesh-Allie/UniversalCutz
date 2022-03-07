import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class SelectedTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectedTime = Input.get("time");

    return Container(
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Text(
            "$selectedTime",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
