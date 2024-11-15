// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/controller/signup_controller.dart';
import 'package:campusresolve/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  SignUpController signUpController = Get.put(SignUpController());
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: signUpController.emailController,
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),
          TextField(
            controller: signUpController.rollNoController,
            decoration: InputDecoration(
              hintText: "Roll No",
            ),
          ),
          TextField(
            controller: signUpController.passwordController,
            decoration: InputDecoration(
              hintText: "Password",
            ),
            obscureText: true,
          ),
          signUpController.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    final ans = await signUpController.signup();
                    if (ans) {
                      Get.snackbar(
                        'Registration Successful',
                        'You have successfully registered',
                        backgroundColor: Colors.black,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.to(LoginScreen());
                    }
                  },
                  child: Text("Register"),
                ),
        ],
      ),
    );
  }
}
