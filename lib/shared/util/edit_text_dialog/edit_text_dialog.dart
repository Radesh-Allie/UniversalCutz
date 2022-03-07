import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class EditTextDialog extends StatelessWidget {
  final String id;
  final String label;
  final String value;

  EditTextDialog({
    @required this.id,
    @required this.label,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$label"),
      ),
      body: Container(
        padding: theme.normalPadding,
        child: Column(
          children: [
            ExMemoField(
              id: "$id",
              label: "$label",
              value: "$value",
            ),
          ],
        ),
      ),
    );
  }
}
