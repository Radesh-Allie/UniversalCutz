import 'package:barber_app/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class ExLocationPicker extends StatefulWidget {
  final String id;
  final String label;
  final double latitude;
  final double longitude;

  ExLocationPicker({
    @required this.id,
    @required this.label,
    this.latitude,
    this.longitude,
  });

  @override
  _ExLocationPickerState createState() => _ExLocationPickerState();
}

class _ExLocationPickerState extends State<ExLocationPicker> {
  @override
  void initState() {
    super.initState();
    if (widget.latitude == null && widget.longitude == null) {
      Input.set("${widget.id}_latitude", null);
      Input.set("${widget.id}_longitude", null);
    } else {
      Input.set("${widget.id}_latitude", widget.latitude);
      Input.set("${widget.id}_longitude", widget.longitude);
    }
  }

  bool isLocationPicked() {
    if (Input.get("${widget.id}_latitude") != null &&
        Input.get("${widget.id}_longitude") != null) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6.0, bottom: 4.0),
      padding: EdgeInsets.all(10.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 4.0,
            ),
            child: Text(
              (widget.label != null ? widget.label : "Select Location") +
                  (kIsWeb ? " - Not Supported in Web" : ""),
              style: TextStyle(),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          if (!isLocationPicked())
            ExButton(
              label: "Select Location",
              color: theme.disabled,
              icon: Icons.add_location,
              onPressed: () async {
                if (kIsWeb) return;

                var getPermission =
                    await AppPermission.getLocationPermission(context);

                if (getPermission) {
                  // await EssSecurity.checkMockLocationWithoutMessage(context);
                  await Get.to(
                    ExLocationPickerMapView(
                      id: widget.id,
                    ),
                  );
                  setState(() {});
                }
              },
            ),
          if (isLocationPicked())
            ExButton(
              label: "You've picked your location",
              color: theme.primary,
              icon: Icons.add_location,
              onPressed: () async {
                if (kIsWeb) return;

                await Get.to(
                  ExLocationPickerMapView(
                    id: widget.id,
                    latitude: Input.get("${widget.id}_latitude"),
                    longitude: Input.get("${widget.id}_longitude"),
                  ),
                );
                setState(() {});
              },
            ),
        ],
      ),
    );
  }
}
