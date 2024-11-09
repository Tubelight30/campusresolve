//ignore_for_file: prefer_const_constructors
import 'package:campusresolve/controller/complaint_controller.dart';
import 'package:campusresolve/controller/location_controller.dart';
import 'package:campusresolve/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ComplaintFormScreen extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final ComplaintController complaintController =
      Get.put(ComplaintController());
  // final TextEditingController titleController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  // final RxList<File> selectedImages = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  ComplaintFormScreen({super.key});

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      complaintController.selectedImages.add(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Problem'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: complaintController.titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter problem title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: complaintController.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the problem in detail',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            Obx(() => locationController.currentPosition.value != null
                ? Text(
                    'Location: ${locationController.currentPosition.value?.latitude}, '
                    '${locationController.currentPosition.value?.longitude}',
                    style: TextStyle(color: Colors.green),
                  )
                : Text(
                    'Waiting for location...',
                    style: TextStyle(color: Colors.red),
                  )),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text('Take Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Obx(() => complaintController.selectedImages.isEmpty
                ? Text('No images selected')
                : SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: complaintController.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              Image.file(
                                complaintController.selectedImages[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => complaintController
                                      .selectedImages
                                      .removeAt(index),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // This will be handled by ComplaintController
                if (locationController.currentPosition.value == null) {
                  Get.snackbar(
                    'Location Required',
                    'Please wait for location data',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                if (complaintController.titleController.text.isEmpty ||
                    complaintController.descriptionController.text.isEmpty) {
                  Get.snackbar(
                    'Incomplete Form',
                    'Please fill all required fields',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                // TODO: Call complaint controller submit method
                await complaintController.createComplaint();
                Get.offAll(DashBoardScreen());
              },
              child: Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}