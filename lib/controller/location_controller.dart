import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLocationServiceEnabled = false.obs;
  final RxBool isFetchingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  Future<bool> checkLocationServices() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      // Open location settings
      await Geolocator.openLocationSettings();

      // Recheck if location services are enabled
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        // User did not enable location services
        return false;
      }
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      Get.snackbar(
        'Permissions Required',
        'Location permissions are permanently denied, please enable them in app settings.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // All good, start getting location updates
    await _startLocationUpdates();

    return true;
  }

  Future<void> _initializeLocation() async {
    await checkLocationServices();
    // try {
    //   // Check if location services are enabled
    //   isLocationServiceEnabled.value =
    //       await Geolocator.isLocationServiceEnabled();

    //   if (!isLocationServiceEnabled.value) {
    //     Get.snackbar(
    //       'Location Services Disabled',
    //       'Please enable location services',
    //       backgroundColor: Colors.red,
    //       colorText: Colors.white,
    //       snackPosition: SnackPosition.BOTTOM,
    //     );
    //     return;
    //   }

    //   // Check location permissions
    //   LocationPermission permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //     if (permission == LocationPermission.denied) {
    //       Get.snackbar(
    //         'Location Permission Denied',
    //         'Location permissions are denied',
    //         backgroundColor: Colors.red,
    //         colorText: Colors.white,
    //         snackPosition: SnackPosition.BOTTOM,
    //       );
    //       return;
    //     }
    //   }

    //   // Start listening to location updates
    //   Geolocator.getPositionStream(
    //     locationSettings: const LocationSettings(
    //       accuracy: LocationAccuracy.high,
    //       distanceFilter: 10, // Update every 10 meters
    //     ),
    //   ).listen((Position position) {
    //     currentPosition.value = position;
    //   }, onError: (e) {
    //     Get.snackbar(
    //       'Location Error',
    //       e.toString(),
    //       backgroundColor: Colors.red,
    //       colorText: Colors.white,
    //       snackPosition: SnackPosition.BOTTOM,
    //     );
    //   });
    // } catch (e) {
    //   Get.snackbar(
    //     'Location Error',
    //     e.toString(),
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
  }

  Future<void> _startLocationUpdates() async {
    try {
      isFetchingLocation.value = true;
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).listen((Position position) {
        currentPosition.value = position;
        isFetchingLocation.value = false;
      }, onError: (e) {
        isFetchingLocation.value = false;
        Get.snackbar(
          'Location Error',
          e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      isFetchingLocation.value = false;
      Get.snackbar(
        'Location Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Future<Position?> getCurrentLocation() async {
  //   if (currentPosition.value != null) {
  //     return currentPosition.value;
  //   } else {
  //     try {
  //       isFetchingLocation.value = true; // Start fetching
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );
  //       currentPosition.value = position;
  //       isFetchingLocation.value = false; // Done fetching
  //       return position;
  //     } catch (e) {
  //       isFetchingLocation.value = false; // Error occurred
  //       return null;
  //     }
  //   }
  // }
  static Future<Position?> getCurrentLocation() async {
    // Check location permission
    final permissionStatus = await Permission.location.request();
    if (!permissionStatus.isGranted) {
      return null;
    }

    // Check if location service is enabled
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }
}
