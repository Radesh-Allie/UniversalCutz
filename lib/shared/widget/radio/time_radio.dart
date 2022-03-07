import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExTimeRadio extends StatefulWidget {
  final String id;
  final String label;
  final String value;
  final List<Map<String, dynamic>> items;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool wrapped;

  ExTimeRadio({
    this.id,
    this.label,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.items = const [],
    this.wrapped = false,
  });

  @override
  _ExTimeRadioState createState() => _ExTimeRadioState();
}

class _ExTimeRadioState extends State<ExTimeRadio> {
  String selectedValue;
  bool loading = true;

  List bookingTimeList = [];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    if (widget.value == null) {
      selectedValue =
          widget.value == null ? widget.items[0]["value"] : widget.value;
      Input.set(widget.id, selectedValue);
    } else {
      Input.set(widget.id, widget.value);
    }

    loadData();
  }

  loadData() async {
    var bookingDate = DateTime.parse(Input.get("booking_date").toString());

    BookController bookController = Get.find();
    var snapshot = await FirebaseFirestore.instance
        .collection(collection.bookingCollection)
        .where("vendor_id", isEqualTo: bookController.selectedVendor["id"])
        .where("booking_date", isGreaterThanOrEqualTo: bookingDate)
        .where(
          "booking_date",
          isLessThan: bookingDate.add(
            Duration(days: 1),
          ),
        )
        .get();

    var bookingList = snapshot.toList();

    bookingList = bookingList
        .where((i) => i["status"] == "Pending" || i["status"] == "Approved")
        .toList();

    bookingTimeList.clear();
    for (var i = 0; i < bookingList.length; i++) {
      var b = bookingList[i];
      bookingTimeList.add(b["booking_time"]);
      print("bookingListAdd: ${b["booking_time"]}");
    }

    print("Booking: ${bookingList.length}");

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Container();
    if (widget.wrapped) {
      return Container(
        padding: EdgeInsets.all(10.0),
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text("${widget.label}"),
            ),
            Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 8.0,
                spacing: 8.0,
                children: List.generate(widget.items.length, (index) {
                  var item = widget.items[index];
                  bool selected = selectedValue == item["value"];

                  bool booked = bookingTimeList.contains(item["value"]);

                  print(bookingTimeList);

                  getColor() {
                    if (booked) return theme.disabled;
                    if (selected) return theme.primary;
                    return theme.secondary;
                  }

                  return InkWell(
                    onTap: () {
                      if (booked) return;
                      selectedValue = item["value"];
                      setState(() {});
                      if (widget.onChanged != null)
                        widget.onChanged(selectedValue);
                      Input.set(widget.id, selectedValue);
                    },
                    child: Container(
                      width: (Get.width / 4) - 12,
                      // width: 100.0,
                      padding: EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                      ),
                      margin: EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      // height: theme.mediumHeight,
                      decoration: BoxDecoration(
                        borderRadius: theme.largeRadius,
                        color: getColor(),
                      ),
                      child: Center(
                          child: Text(
                        "${item["value"]}",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : theme.textColor,
                          decoration: booked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      )),
                    ),
                  );
                })),
          ],
        ),
      );
    }

    return Container(
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 4.0,
                right: 4.0,
                top: 4.0,
                bottom: 4.0,
              ),
              child: Text("${widget.label}"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var item = widget.items[index];
                  bool selected = selectedValue == item["value"];

                  return InkWell(
                    onTap: () {
                      selectedValue = item["value"].toString();
                      setState(() {});
                      if (widget.onChanged != null)
                        widget.onChanged(selectedValue);
                      Input.set(widget.id, selectedValue);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                      height: theme.mediumHeight,
                      decoration: BoxDecoration(
                        borderRadius: theme.largeRadius,
                        color: selected ? theme.primary : theme.disabled,
                      ),
                      child: Center(
                          child: Text(
                        "${item["value"]}",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : theme.textColor,
                        ),
                      )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
