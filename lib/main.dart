import 'package:campusresolve/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/appwrite_service.dart';
import 'controller/setup_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appwriteService = Get.put(AppwriteService());
  final startup = Get.put(SetupController());
  await startup.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final setup = Get.find<SetupController>();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(LocationController());
      }),
      home: Obx(() => setup.route.value),
    );
  }
}
