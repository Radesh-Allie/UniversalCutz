import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewer extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double zoom;
  final bool enableMyLocationFeature;

  MapViewer({
    this.latitude,
    this.longitude,
    this.zoom = 16,
    this.enableMyLocationFeature = true,
  });

  @override
  MapViewerState createState() => MapViewerState();
}

class MapViewerState extends State<MapViewer> {
  bool loading = true;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  Completer<GoogleMapController> mapController = Completer();

  initData() async {
    if (widget.latitude == null && widget.longitude == null) {
      await getCurrentLocation();
    }

    addMarker();

    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLatitude = position.latitude;
    currentLongitude = position.longitude;
  }

  void addMarker() {
    if (widget.latitude == null || widget.longitude == null) return;

    final MarkerId markerId = MarkerId("MyLocation");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(widget.latitude, widget.longitude),
      infoWindow: InfoWindow(title: "Your Position", snippet: '*'),
      onTap: () {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  double currentLatitude;
  double currentLongitude;

  getCameraPosition() {
    if (widget.latitude != null && widget.longitude != null) {
      return CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: widget.zoom,
      );
    } else {
      return CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: widget.zoom,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: Colors.grey[300],
      );
    }

    try {
      var googleMap = GoogleMap(
        myLocationEnabled: widget.enableMyLocationFeature,
        myLocationButtonEnabled: widget.enableMyLocationFeature,
        initialCameraPosition: getCameraPosition(),
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          mapController.complete(controller);
        },
        // onCameraMove: null,
      );

      return Scaffold(
        body: googleMap,
      );
    } on PlatformException catch (_) {
      print("##############################");
      print("###############################");
      print("##############################");
      print("###############################");
      print("ERROR WOY");
      return Scaffold(
        body: Container(
          color: Colors.red,
        ),
      );
    }
  }
}
