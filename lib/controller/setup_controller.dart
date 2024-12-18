import 'package:campusresolve/controller/appwrite_service.dart';
import 'package:campusresolve/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:securenotes/models/user.dart';
import 'package:campusresolve/screens/dashboard_screen.dart';
import 'package:campusresolve/screens/onboard_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SetupController extends GetxController {
  final AppwriteService appwriteService = Get.put(AppwriteService());

  RxBool isLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  RxString token = "".obs;
  late SharedPreferences _prefs;
  // User? loggedInUser;
  var route = Rx<Widget>(OnBoardScreen());

  // final Client client = Client();
  // late final Account account;

  @override
  void onInit() {
    // setup();
    super.onInit();
    // initAppwrite();
  }

  // void initAppwrite() {
  //   client
  //       .setEndpoint(Secrets.endpoint) // Your API Endpoint
  //       .setProject(Secrets.projId) // Your project ID
  //       .setSelfSigned(status: true); // Your project ID

  //   account = Account(client);
  // }

  setup() async {
    try {
      isLoading.value = true;
      final user = await appwriteService.account.get();
      print(user.email);
      Get.put(LocationController(), permanent: true);
      // loggedInUser = User.fromMap(user.toMap());
      route.value = DashBoardScreen();
      // print("User logged in: ${loggedInUser?.name}");
    } catch (e) {
      route.value = const OnBoardScreen();
      print("User not logged in $e");
    } finally {
      isLoading.value = false;
    }
    // final user = await appwriteService.account.get();

    // await SharedPreferences.getInstance().then((value) {
    //   _prefs = value;
    //   isLoggedIn.value = _prefs.getBool('isLoggedIn') ?? false;
    //   token.value = _prefs.getString('token') ?? "";
    // });
    // route = user != null ? DashBoardScreen() : const OnBoardScreen();
  }
}
