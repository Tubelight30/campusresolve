import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLocationServiceEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      isLocationServiceEnabled.value =
          await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled.value) {
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Location permissions are denied',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      // Start listening to location updates
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).listen((Position position) {
        currentPosition.value = position;
      }, onError: (e) {
        Get.snackbar(
          'Location Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      Get.snackbar(
        'Location Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Position? getCurrentLocation() {
    return currentPosition.value;
  }
}
