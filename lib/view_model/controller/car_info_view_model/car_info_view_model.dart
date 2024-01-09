import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../configMaps.dart';
import '../../../main.dart';
import '../../../resources/routes/routes_name.dart';
import '../../../utils/utils.dart';

class CarInfoViewModel extends GetxController {
  final carModelController = TextEditingController().obs;
  final carNumberController = TextEditingController().obs;
  final carColorController = TextEditingController().obs;

  void saveDriverCarInfo(BuildContext context) {
    if (carModelController.value.text.isEmpty) {
      Utils.toastMessage("Please write the car model.");
    }
    if (carNumberController.value.text.isEmpty) {
      Utils.toastMessage("Please write the car number.");
    }
    if (carColorController.value.text.isEmpty) {
      Utils.toastMessage("Please write the car color.");
    } else {
      String? userId = currentFirebaseUser?.uid;

      Map carInfoMap = {
        "car_color": carColorController.value.text,
        "car_number": carNumberController.value.text,
        "car_model": carModelController.value.text,
      };
      driversRef.child(userId!).child("car_details").set(carInfoMap);

      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.mainScreen, (route) => false);
    }
  }
}
