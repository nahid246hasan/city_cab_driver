import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'models/all_users.dart';

String mapKey="AIzaSyBxvP_Bz59gcf6mO7l4I-5b5FZsLxX7Vjc";
String autoCompleteUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json";
User? firebaseUser;
Users? usersCurrentInfo;

User? currentFirebaseUser;

StreamSubscription<Position>? hometabPageStreamSubscription;