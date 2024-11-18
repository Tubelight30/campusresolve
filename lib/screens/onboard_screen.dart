import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/screens/login_screen.dart';
import 'package:campusresolve/screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              ),
            ),
          ),
          Spacer(),
          Image.asset(
            "assets/intor.png",
            height: MediaQuery.of(context).size.height * 0.26,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                "Welcome to CampusResolve, your one stop solution for all campus related issues.",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(RegisterScreen());
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffD9614C),
              ),
              child: Center(
                child: Text(
                  "GET STARTED",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.to(LoginScreen());
            },
            child: Center(
              child: Text(
                "Already have an account?",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffD9614C),
                ),
              ),
            ),
          ),
          SizedBox(
            height: kBottomNavigationBarHeight,
          ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.to(LoginScreen());
          //     },
          //     child: Text("Login"),
          //   ),
          // ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Get.to(RegisterScreen());
          //     },
          //     child: Text("Signup"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
