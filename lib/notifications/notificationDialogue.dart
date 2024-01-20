import 'package:city_cab_driver/main.dart';
import 'package:city_cab_driver/models/ride_details.dart';
import 'package:city_cab_driver/resources/assistant/assistant_methods.dart';
import 'package:city_cab_driver/resources/routes/routes_name.dart';
import 'package:city_cab_driver/screens/new_ride_screen/new_ride_screen.dart';
import 'package:city_cab_driver/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationDialogue extends StatelessWidget {
  final RideDetails rideDetails;

  const NotificationDialogue({required this.rideDetails, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "assets/images/taxi.png",
              width: 120,
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              "New Ride Request",
              style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.pickup_address,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails.dropoff_address,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 2.0,color: Colors.black,thickness: 2,),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      backgroundColor: Colors.white,
                      primary: Colors.red,
                      padding: EdgeInsets.all(8.0),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                  const SizedBox(width: 25),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green),
                      ),
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {
                      checkAvailableOfRide(context);
                      // Your onPressed logic goes here
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  void checkAvailableOfRide(BuildContext context){
    rideRequestRef.once().then((DatabaseEvent event) {
      Get.back();
      DataSnapshot? dataSnapshot = event.snapshot;
      String theRideId="";
      if(dataSnapshot.value!=null){
        theRideId=dataSnapshot.value.toString();
      }
      else {
        Utils.toastMessage("Ride not exists");
      }
      if(theRideId==rideDetails.ride_request_id){
        rideRequestRef.set("accept");
        AssistantMethods.diableHomeTabLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NewRideScreen(rideDetails: rideDetails)));
      }
      else if(theRideId=="cancelled"){
        Utils.toastMessage("Ride has been cancelled");
      }
      else if(theRideId=="timeout"){
        Utils.toastMessage("Ride has been time out");
      }
      else {
        Utils.toastMessage("Ride not exists");
      }
    });
  }
}
