import 'package:firebase_database/firebase_database.dart';

class Drivers{
  String? name;
  String? phone;
  String? email;
  String? id;
  String? car_color;
  String? car_model;
  String? car_number;

  Drivers(this.name, this.phone, this.email, this.id, this.car_color,
      this.car_model, this.car_number);

  Drivers.fromSnapshot(DataSnapshot dataSnapshot){
    Map<dynamic, dynamic> data = dataSnapshot.value as Map;
    id=dataSnapshot.key!;
    phone=data["phone"];
    phone=data["email"];
    phone=data["name"];
    phone=data["car_details"]["car_color"];
    phone=data["car_details"]["car_model"];
    phone=data["car_details"]["car_number"];


  }
}