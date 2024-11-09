import 'package:appwrite/appwrite.dart';
import 'package:campusresolve/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/constants/secrets.dart';
import 'package:campusresolve/controller/appwrite_service.dart';

class LoginController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  // User? loggedInUser;

  Future<bool> login() async {
    isLoading = true;
    update();

    try {
      final database = appwriteService.database;
      final response = await database.listDocuments(
        collectionId: Secrets.usercollectionId,
        databaseId: Secrets.databaseId,
        queries: [
          Query.equal('rollNo', rollNoController.text),
        ],
      );

      if (response.documents.isEmpty) {
        throw Exception('User not found');
      }

      final user = response.documents.first;
      print(user.data['email']);

      await appwriteService.account.createEmailPasswordSession(
        email: user.data['email'],
        password: passwordController.text,
      );

      return true;
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
}
// // import 'package:appwrite/models.dart';
// import 'package:campusresolve/controller/appwrite_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:securenotes/controller/appwrite_service.dart';
// // import 'package:securenotes/models/user.dart';
// // import 'package:securenotes/utils/encryption_utils.dart';

// class LoginController extends GetxController {
//   final AppwriteService appwriteService = Get.find<AppwriteService>();
//   final regController = TextEditingController();
//   final passwordController = TextEditingController();
//   // late String? _encryptionKey;
//   // final isLogin = false.obs;
//   final isLoading = false.obs;
//   // User? loggedInUser;

//   @override
//   void onInit() {
//     super.onInit();
//     // _initEncryptionKey();
//   }

//   // Future<void> _initEncryptionKey() async {
//   //   _encryptionKey = await EncryptionUtils.getEncryptionKey();
//   // }

//   Future<bool> login() async {
//     isLoading.value = true;
//     update();
//     try {
//       print("this da email");
//       print(regController.text);
//       await appwriteService.account.createEmailPasswordSession(
//         email: regController.text,
//         password: passwordController.text,
//       );
//       print("this da user");
//       // final user = await appwriteService.account.get();
//       // await fetchUserDetails(user.$id);
//       return true;
//     } catch (e) {
//       // Show error SnackBar
//       Get.snackbar(
//         'Login Failed',
//         e.toString(),
//         backgroundColor: Colors.black,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//       update();
//     }
//   }
// }
