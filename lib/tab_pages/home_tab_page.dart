import 'dart:async';

import 'package:city_cab_driver/main.dart';
import 'package:city_cab_driver/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../configMaps.dart';
import '../resources/assistant/assistant_methods.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  String driverStatusText="Offline Now - Go Online";
  Color driverStatusColor=Colors.black;
  bool isDriverAvailable=false;

  GoogleMapController? googleMapController;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  Position? currentPosition;

  void locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      currentPosition = position;
    });

    print(currentFirebaseUser?.uid);
    print(currentPosition?.latitude);
    print(currentPosition?.longitude);
    print("//////////////////////////");

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 14,
    );
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    // var assistantMethods = Get.put(AssistantMethods());
    // var address =
    // await assistantMethods.searchCoordinateAddress(position, context);
    // if (kDebugMode) {
    //   print("This is your Address :: $address");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: 50),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,

          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            _controllerGoogleMap.complete(controller);
            googleMapController = controller;

            locatePosition();
          },
        ),

        //online offline driver container
        // Container(
        //   height: 140,
        //   width: double.infinity,
        //   color: Colors.black54,
        // ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: ElevatedButton(
                  onPressed: () {

                    if(isDriverAvailable!=true){
                      makeDriverOnlineNow();
                      getLocationLiveUpdates();
                      setState(() {
                        driverStatusColor=Colors.green;
                        driverStatusText="Online Now";
                        isDriverAvailable=true;
                      });
                      Utils.toastMessage("You are Online.");
                    }
                    else{
                      makeDriverOffline();

                      setState(() {
                        driverStatusColor=Colors.black;
                        driverStatusText="Offline Now - Go Online";
                        isDriverAvailable=false;
                      });
                      Utils.toastMessage("You are Offline.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: driverStatusColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$driverStatusText",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.phone_android,
                          color: Colors.white,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      currentPosition = position;
    });
    //await locatePosition();
    if(currentPosition!=null){
      Geofire.initialize("availableDrivers");
      print(currentPosition?.latitude);
      print("//////////////////////////////////////////");
      Geofire.setLocation("${currentFirebaseUser?.uid}", currentPosition!.latitude, currentPosition!.longitude);

      rideRequestRef.onValue.listen((event) {

      });
    }
    else{
      print("ajfhagsdgh");
    }
  }
  void  getLocationLiveUpdates(){
    hometabPageStreamSubscription=Geolocator.getPositionStream().listen((Position position) {
      currentPosition=position;
      if(isDriverAvailable){
        Geofire.setLocation(currentFirebaseUser!.uid, position.latitude, position.longitude);
      }
      LatLng latLng=LatLng(position.latitude, position.longitude);
      googleMapController?.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
  void makeDriverOffline(){
    Geofire.removeLocation(currentFirebaseUser!.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
  }
}
