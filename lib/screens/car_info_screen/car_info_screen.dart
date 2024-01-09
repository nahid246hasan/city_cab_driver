import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../view_model/controller/car_info_view_model/car_info_view_model.dart';

class CarInfoScreen extends StatelessWidget {
  CarInfoScreen({super.key});

  CarInfoViewModel carInfoViewModel = CarInfoViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 22,
              ),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 390,
                height: 250,
                alignment: Alignment.center,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22, 22, 22, 32),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Enter Car Details",
                      style: TextStyle(fontSize: 24, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: carInfoViewModel.carModelController.value,
                      decoration: const InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: carInfoViewModel.carNumberController.value,
                      decoration: const InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: carInfoViewModel.carColorController.value,
                      decoration: const InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 42),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: ElevatedButton(
                        onPressed: () {
                          carInfoViewModel.saveDriverCarInfo(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
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
          ),
        ),
      ),
    );
  }
}
