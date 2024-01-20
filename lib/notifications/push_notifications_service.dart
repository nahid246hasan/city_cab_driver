import 'dart:async';

import 'package:city_cab_driver/configMaps.dart';
import 'package:city_cab_driver/main.dart';
import 'package:city_cab_driver/models/ride_details.dart';
import 'package:city_cab_driver/notifications/notificationDialogue.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationsService
{
  final FirebaseMessaging firebaseMessaging= FirebaseMessaging.instance;




  Future initialize(BuildContext context) async {

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      retrieveRideRequestInfo("${getRideRequestId(message!)}",context);
      print('getInitialMessage data: ${message?.data}');
      //_serialiseAndNavigate(message);
    });

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      retrieveRideRequestInfo("${getRideRequestId(message)}",context);
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      retrieveRideRequestInfo("${getRideRequestId(message)}",context);
      print('onMessageOpenedApp data: ${message.data}');
      //_serialiseAndNavigate(message);
    });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('Got a message whilst in the foreground!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //     getRideRequestId(message);
    //   }
    // });
  }

  Future getToken() async{
    await firebaseMessaging.requestPermission();

    String? token=await firebaseMessaging.getToken();
    print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    print(token);
    driversRef.child(currentFirebaseUser!.uid).child("token").set(token);
    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }

  String? getRideRequestId(RemoteMessage message){
    String? rideRequestId=message.data['ride_request_id'];
    print("???????????????????????????????????????????????????????????????????");
    print(rideRequestId);
    return rideRequestId;
  }


  void retrieveRideRequestInfo(String rideReqId,BuildContext context) {
    try {
      newRequestRef.child(rideReqId).once().then((DatabaseEvent event) {
        DataSnapshot? dataSnapshot = event.snapshot;

        if (dataSnapshot != null && dataSnapshot.value is Map<String, dynamic>) {
          Map<String, dynamic> rideData = dataSnapshot.value as Map<String, dynamic>;

          double pickUpLocationLat =
          double.parse(rideData['pickup']['latitude'].toString());
          double pickUpLocationLng =
          double.parse(rideData['pickup']['longitude'].toString());
          String pickUpAddress = rideData['pickup_address'].toString();

          double dropOffLocationLat =
          double.parse(rideData['dropoff']['latitude'].toString());
          double dropOffLocationLng =
          double.parse(rideData['dropoff']['longitude'].toString());
          String? dropOffAddress = rideData['dropoff_address']?.toString();

          String? paymentMethod = rideData['payment_method']?.toString();
          RideDetails rideDetails=RideDetails(pickUpAddress, dropOffAddress!, LatLng(pickUpLocationLat,pickUpLocationLng), LatLng(dropOffLocationLat,dropOffLocationLng), rideReqId, paymentMethod!, "", "");
          showDialog(context: context,
              barrierDismissible: false,
              builder: (BuildContext context)=>NotificationDialogue(rideDetails: rideDetails),);
        }
      });
    } catch (e) {
      print("Error retrieving ride request information: $e");
      // Handle the error as needed
    }
  }




}