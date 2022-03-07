import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectedDate = DateFormat("d MMM y").format(Input.get("booking_date"));

    return Container(
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Text(
            "$selectedDate",
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
