// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/controller/signup_controller.dart';
import 'package:campusresolve/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  SignUpController signUpController = Get.put(SignUpController());
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: kToolbarHeight,
            ),
            Center(
              child: Text(
                "CampusResolve",
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  // color: Color(0xff403B36),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: signUpController.emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: signUpController.rollNoController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Roll No",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: signUpController.passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Obx(
              () => GestureDetector(
                onTap: signUpController.isLoading.value
                    ? null // Disable onTap when loading
                    : () async {
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
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: signUpController.isLoading.value
                        ? Color(0xffD9614C)
                            .withOpacity(0.7) // Dim the color when loading
                            .withOpacity(0.7) // Dim the color when loading
                        : Color(0xffD9614C),
                  ),
                  child: Center(
                    child: signUpController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create Account",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            // signUpController.isLoading
            //     ? CircularProgressIndicator()
            //     : ElevatedButton(
            //         onPressed: () async {
            //           final ans = await signUpController.signup();
            //           if (ans) {
            //             Get.snackbar(
            //               'Registration Successful',
            //               'You have successfully registered',
            //               backgroundColor: Colors.black,
            //               colorText: Colors.white,
            //               snackPosition: SnackPosition.BOTTOM,
            //             );
            //             Get.to(LoginScreen());
            //           }
            //         },
            //         child: Text("Register"),
            //       ),
          ],
        ),
      ),
    );
  }
}
