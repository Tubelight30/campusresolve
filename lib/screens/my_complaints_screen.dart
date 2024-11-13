// my_complaints_screen.dart

import 'package:campusresolve/controller/complaint_controller.dart';
import 'package:campusresolve/controller/userprofile_controller.dart';
import 'package:campusresolve/models/complaint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyComplaintsScreen extends StatelessWidget {
  final ComplaintController complaintController =
      Get.find<ComplaintController>(tag: 'complaint');
  final UserProfileController userProfileController =
      Get.find<UserProfileController>();

  MyComplaintsScreen({super.key});

  void _markAsSolved(String complaintId) {
    complaintController.updateComplaintStatus(complaintId, 'resolved');
  }

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user's ID
    final String userId = userProfileController.loggedInUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('My Complaints'),
        // backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (complaintController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Filter complaints made by the current user
        final List<Complaint> myComplaints = complaintController.complaints
            .where((complaint) => complaint.userId == userId)
            .toList();

        if (myComplaints.isEmpty) {
          return Center(child: Text('You have not submitted any complaints.'));
        }

        return ListView.builder(
          itemCount: myComplaints.length,
          itemBuilder: (context, index) {
            final complaint = myComplaints[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      complaint.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(complaint.description),
                        SizedBox(height: 4),
                        Text('Status: ${complaint.status}'),
                        SizedBox(height: 4),
                        Text('Created At: ${_formatDate(complaint.createdAt)}'),
                      ],
                    ),
                  ),
                  if (complaint.status != 'resolved')
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => _markAsSolved(complaint.id),
                        child: Text('Mark as Solved'),
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.black,
                            ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
