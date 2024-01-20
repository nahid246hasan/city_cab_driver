import 'dart:async';

import 'package:city_cab_driver/configMaps.dart';
import 'package:city_cab_driver/main.dart';
import 'package:city_cab_driver/models/ride_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../resources/assistant/assistant_methods.dart';
import '../../resources/components/progress_dialogue.dart';

import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as GeoLocation;

class NewRideScreen extends StatefulWidget {
  final RideDetails rideDetails;

  const NewRideScreen({super.key, required this.rideDetails});

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  GoogleMapController? newRideGoogleMapController;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  Set<Marker> markersSet = Set<Marker>();
  Set<Polyline> polylineSet = Set<Polyline>();
  Set<Circle> circleSet = Set<Circle>();
  List<LatLng> polylineCoOrdinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions = const LocationSettings(
      accuracy: GeoLocation.LocationAccuracy.bestForNavigation);
  late BitmapDescriptor animatingMarkerIcon;
  late Position myPosition;

  @override
  void initState() {
    super.initState();

    acceptRideRequest();
  }

  void createIconMarker() {
    print("hi");
    if (animatingMarkerIcon == null) {
      print("hello");
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/car_android.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLocationUpdates() {
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon,
        infoWindow: InfoWindow(title: "Current Location"),
      );
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController
            ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      markersSet.removeWhere((element) => element.mapsId.value=="animation");
      markersSet.add(animatingMarker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circleSet,
            polylines: polylineSet,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                mapPaddingFromBottom = 265;
              });
              var currentLatLng =
                  LatLng(currentPosition!.latitude, currentPosition!.longitude);
              var pickUpLatLng = widget.rideDetails.pickup;

              await getPlaceDirection(currentLatLng, pickUpLatLng);
            getRideLocationUpdates();
              },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]),
              height: 260,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
                child: Column(
                  children: [
                    const Text(
                      "10 mins",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                          fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nahid Hasan",
                          style:
                              TextStyle(fontSize: 24, fontFamily: "Brand-Bold"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone_android),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/desticon.png",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Container(
                          child: const Text(
                            "Street, paris,france",
                            style: TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Your onPressed logic goes here
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            children: [
                              Text(
                                "Arrived",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection(
      LatLng pickUpLatLng, LatLng dropOfLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgreessDialogue(msg: "Please wait..."),
    );

    var details = await AssistantMethods.obtainDirectionsDetails(
        pickUpLatLng, dropOfLatLng);

    Get.back();

    if (kDebugMode) {
      print("this is encoded point:: ");
      print(details?.encodedPoints);
    }

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointsResults =
        polylinePoints.decodePolyline("${details?.encodedPoints}");

    polylineCoOrdinates.clear();

    if (decodePolylinePointsResults.isNotEmpty) {
      decodePolylinePointsResults.forEach((PointLatLng pointLatLng) {
        polylineCoOrdinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoOrdinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOfLatLng.latitude &&
        pickUpLatLng.longitude > dropOfLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOfLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOfLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOfLatLng.longitude),
          northeast: LatLng(dropOfLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOfLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOfLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOfLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOfLatLng);
    }

    newRideGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickupLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      position: pickUpLatLng,
      markerId: const MarkerId("pickUpId"),
    );

    Marker dropOffLocationMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: dropOfLatLng,
      markerId: const MarkerId("dropOffId"),
    );
    setState(() {
      markersSet.add(pickupLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });

    Circle pickupLocationCircle = Circle(
      fillColor: Colors.yellow,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.yellowAccent,
      circleId: const CircleId("pickUpId"),
    );

    Circle dropOffLocationCircle = Circle(
      fillColor: Colors.red,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
      circleId: const CircleId("dropOffId"),
    );

    setState(() {
      circleSet.add(pickupLocationCircle);
      circleSet.add(dropOffLocationCircle);
    });
  }

  void acceptRideRequest() {
    String rideRequestId = widget.rideDetails.ride_request_id;

    newRequestRef.child(rideRequestId).child("status").set("accepted");
    newRequestRef
        .child(rideRequestId)
        .child("driver_name")
        .set(driversInformation?.name);
    newRequestRef
        .child(rideRequestId)
        .child("driver_phone")
        .set(driversInformation?.phone);
    newRequestRef
        .child(rideRequestId)
        .child("driver_id")
        .set(driversInformation?.id);
    newRequestRef.child(rideRequestId).child("car_details").set(
        '${driversInformation?.car_color} - ${driversInformation?.car_model} - ${driversInformation?.car_number}');

    Map locMap = {
      "latitude": currentPosition?.latitude.toString(),
      "longitude": currentPosition?.longitude.toString(),
    };
    newRequestRef.child(rideRequestId).child("driver_location").set(locMap);
  }
}
