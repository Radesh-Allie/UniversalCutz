import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class ExCheckbox extends StatefulWidget {
  final String id;
  final String label;
  final List items;
  final Function(bool, String, int) onChanged;
  final TextInputType keyboardType;
  final bool wrapped;
  final List selectedValues;

  ExCheckbox({
    this.id,
    this.label,
    this.onChanged,
    this.keyboardType,
    this.items = const [],
    this.wrapped = true,
    this.selectedValues = const [],
  });

  @override
  _ExCheckboxState createState() => _ExCheckboxState();
}

class _ExCheckboxState extends State<ExCheckbox> {
  List selectedCheckboxValues = [];

  @override
  void initState() {
    super.initState();
    selectedCheckboxValues = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
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
                // bool selected = selectedValue == item["value"];
                bool selected = selectedCheckboxValues.contains(item["id"]);

                return InkWell(
                  onTap: () {
                    var selectedValue = item["id"];
                    // setState(() {});
                    // if (widget.onChanged != null)
                    //   widget.onChanged(selectedValue, index);
                    // Input.set(widget.id, selectedValue);
                    bool isChecked =
                        selectedCheckboxValues.contains(item["id"]);
                    if (isChecked) {
                      selectedCheckboxValues.remove(item["id"]);
                    } else {
                      selectedCheckboxValues.add(item["id"]);
                    }
                    if (widget.onChanged != null)
                      widget.onChanged(
                          isChecked ? false : true, selectedValue, index);
                    setState(() {});
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
                      color: selected ? theme.primary : Colors.grey[700],
                    ),
                    child: Center(
                        child: Text(
                      "${item["label"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        color: selected ? Colors.white : theme.textColor,
                      ),
                    )),
                  ),
                );
              })),
        ],
      ),
    );
  }
}
