import 'dart:async';
import 'dart:convert';

import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExLocationPickerMapView extends StatefulWidget {
  final String id;

  final double latitude;
  final double longitude;

  ExLocationPickerMapView({
    @required this.id,
    this.latitude,
    this.longitude,
  });

  @override
  _ExLocationPickerMapViewState createState() =>
      _ExLocationPickerMapViewState();
}

class _ExLocationPickerMapViewState extends State<ExLocationPickerMapView> {
  @override
  Widget build(BuildContext context) {
    return LocationPickerMap(
      id: widget.id,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
  }
}

class LocationPickerMap extends StatefulWidget {
  final String id;
  final double latitude;
  final double longitude;
  final double zoom;
  final bool enableMyLocationFeature;

  LocationPickerMap({
    @required this.id,
    this.latitude,
    this.longitude,
    this.zoom = 16,
    this.enableMyLocationFeature = true,
  });

  @override
  LocationPickerMapState createState() => LocationPickerMapState();
}

class LocationPickerMapState extends State<LocationPickerMap> {
  bool loading = true;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  Completer<GoogleMapController> mapController = Completer();

  initData() async {
    if (widget.latitude != null && widget.longitude != null) {
      currentLatitude = widget.latitude;
      currentLongitude = widget.longitude;
    } else {
      print("################");
      print("GetCurrentLocation...###");
      print("################");
      await getCurrentLocation();
      print("################");
      print("GetCurrentLocation [DONE]");
      print("################");

      setState(() {
        loading = false;
      });
    }

    if (this.mounted)
      setState(() {
        loading = false;
      });
  }

  getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentLatitude = currentLocation.latitude;
    currentLongitude = currentLocation.longitude;
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    initData();
  }

  double currentLatitude;
  double currentLongitude;

  bool updatePosition = false;
  getCameraPosition() {
    if (updatePosition) {
      return CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: widget.zoom,
      );
    }

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

  List nominatimSearchResults = [];
  bool nominatimSearchLoading = false;
  void nominatimSearch(search) async {
    if (search.toString().length == 0) return;

    setState(() {
      nominatimSearchLoading = true;
    });

    try {
      nominatimSearchResults.clear();
      var apiResponse = await https.get(
        url:
            "https://nominatim.openstreetmap.org/search/$search?format=json&limit=10",
      );

      nominatimSearchResults.addAll(jsonDecode(apiResponse.body));
      setState(() {});
    } catch (_) {
      print("Nominatim API ERROR");
    }

    setState(() {
      nominatimSearchLoading = false;
    });
  }

  LatLng middlePoint;
  bool typing = true;
  int tryCode = 0;
  TextEditingController searchController;
  GlobalKey googleMapContainerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     color: Colors.black26,
          //     height: 100.0,
          //   ),
          // ),
          Positioned(
            left: -1000,
            top: -1000,
            child: Container(
              width: 0.0,
              height: 0.0,
              child: MapViewer(),
            ),
          ),
          if (loading)
            Align(
              alignment: Alignment.center,
              child: Container(
                width: Get.width / 2,
                height: 50.0,
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/gif/loading.gif",
                        width: 60.0,
                        height: 60.0,
                      ),
                      Container(
                        child: Text("Updating Location..."),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!loading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width,
                      height: 54.0,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextField(
                              enabled: loading ? false : true,
                              controller: searchController,
                              decoration: InputDecoration.collapsed(
                                hintText: "Search",
                              ),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[900],
                              ),
                              onChanged: (text) {
                                tryCode += 1;
                                var currentTryCode = tryCode;

                                Future.delayed(
                                  Duration(milliseconds: 700),
                                  () {
                                    if (tryCode == currentTryCode) {
                                      nominatimSearch(text);
                                    } else {
                                      return;
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          InkWell(
                            onTap: () {
                              searchController.text = "";
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      key: googleMapContainerKey,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: GoogleMap(
                              myLocationEnabled: widget.enableMyLocationFeature,
                              myLocationButtonEnabled:
                                  widget.enableMyLocationFeature,
                              initialCameraPosition: getCameraPosition(),
                              markers: Set<Marker>.of(markers.values),
                              onMapCreated: (GoogleMapController controller) {
                                mapController.complete(controller);
                              },
                              onCameraMove: (cameraPosition) async {
                                currentLatitude =
                                    cameraPosition.target.latitude;
                                currentLongitude =
                                    cameraPosition.target.longitude;
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: Image.network(
                                "https://icons.iconarchive.com/icons/icons-land/vista-map-markers/96/Map-Marker-Marker-Outside-Azure-icon.png",
                                height: 50.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(6.0),
                      width: MediaQuery.of(context).size.width,
                      height: 60.0,
                      child: ExButton(
                        label: "Select Location",
                        color: theme.primary,
                        enabled: loading ? false : true,
                        onPressed: () async {
                          if (currentLatitude == null &&
                              currentLongitude == null) {}

                          Input.set("${widget.id}_latitude", currentLatitude);
                          Input.set("${widget.id}_longitude", currentLongitude);

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (nominatimSearchLoading || nominatimSearchResults.length > 0)
            Positioned(
              left: 0,
              right: 0,
              top: 50,
              bottom: 0,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: SafeArea(
                      child: Column(
                        children: [
                          if (nominatimSearchLoading)
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Text(
                                "Searching...",
                                style: TextStyle(
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                          if (nominatimSearchResults.length > 0)
                            Container(
                              color: Colors.white,
                              height: 500.0,
                              child: Wrap(
                                  children: List.generate(
                                      nominatimSearchResults.length, (index) {
                                var item = nominatimSearchResults[index];
                                var displayName = item["display_name"];
                                var lat = item["lat"];
                                var lng = item["lon"];

                                return InkWell(
                                  onTap: () async {
                                    updatePosition = true;
                                    currentLatitude = double.tryParse(lat);
                                    currentLongitude = double.tryParse(lng);

                                    print("set Latitude to $lat");
                                    print("set Longitude to $lng");

                                    nominatimSearchResults = [];

                                    searchController.text =
                                        item["display_name"];

                                    GoogleMapController c =
                                        await mapController.future;
                                    c.moveCamera(CameraUpdate.newLatLng(LatLng(
                                        currentLatitude, currentLongitude)));

                                    setState(() {
                                      nominatimSearchResults = [];
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
