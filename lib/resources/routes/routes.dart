
import 'package:city_cab_driver/resources/routes/routes_name.dart';
import 'package:city_cab_driver/screens/new_ride_screen/new_ride_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../screens/car_info_screen/car_info_screen.dart';
import '../../screens/login_screen/login_screen.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../screens/registration_screen/registration_screen.dart';
import '../../screens/search_screen/search_screen.dart';

class AppRoutes{
  static appRoutes()=>[
    GetPage(
      name: RoutesName.registrationScreen,
      page: () => RegistrationScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: RoutesName.mainScreen,
      page: () => const MainScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.leftToRight,
    ),

    GetPage(
      name: RoutesName.loginScreen,
      page: () => LoginScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.leftToRight,
    ),

    GetPage(
      name: RoutesName.searchScreen,
      page: () => const SearchScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.leftToRight,
    ),

    GetPage(
      name: RoutesName.carInfoScreen,
      page: () => CarInfoScreen(),
      transitionDuration: const Duration(milliseconds: 250),
      transition: Transition.leftToRight,
    ),

    // GetPage(
    //   name: RoutesName.newRideScreen,
    //   page: () => NewRideScreen(rideDetails: null,),
    //   transitionDuration: const Duration(milliseconds: 250),
    //   transition: Transition.leftToRight,
    // ),
  ];
}