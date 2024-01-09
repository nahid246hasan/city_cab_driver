import 'package:city_cab_driver/configMaps.dart';
import 'package:city_cab_driver/provider/app_data.dart';
import 'package:city_cab_driver/resources/routes/routes.dart';
import 'package:city_cab_driver/screens/login_screen/login_screen.dart';
import 'package:city_cab_driver/screens/main_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  currentFirebaseUser=FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.ref().child("users");
DatabaseReference driversRef =
FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference rideRequestRef =
FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRide");



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'City Cab Driver App',
        theme: ThemeData(
          fontFamily: "Signatra",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser==null?LoginScreen():const MainScreen(),
        getPages: AppRoutes.appRoutes(),
      ),
    );
  }
}
