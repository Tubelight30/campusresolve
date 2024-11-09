//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/controller/login_controller.dart';
import 'package:campusresolve/screens/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: loginController.rollNoController,
            decoration: InputDecoration(
              hintText: "Roll No",
            ),
          ),
          TextField(
            controller: loginController.passwordController,
            decoration: InputDecoration(
              hintText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final ans = await loginController.login();
              if (ans) {
                Get.snackbar(
                  'Login Successful',
                  'You have successfully logged in',
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                Get.offAll(DashBoardScreen());
              }
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
