import 'package:flutter/cupertino.dart';

import '../models/address.dart';

class AppData extends ChangeNotifier{
  Address pickUpLocation=Address("", "", "", 0.0, 0.0);
  Address dropOffLocation=Address("", "", "", 0.0, 0.0);

  void updatePickupLocationAddress(Address pickupAddress){
    pickUpLocation=pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress){
    dropOffLocation=dropOffAddress;
    notifyListeners();
  }
}