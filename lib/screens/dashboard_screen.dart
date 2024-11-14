//ignore_for_file: prefer_const_constructors
import 'package:campusresolve/controller/complaint_controller.dart';
import 'package:campusresolve/controller/location_controller.dart';
import 'package:campusresolve/models/complaint.dart';
import 'package:campusresolve/screens/complaint_details_screen.dart';
import 'package:campusresolve/screens/complaint_form_screen.dart';
import 'package:campusresolve/screens/map_screen.dart';
import 'package:campusresolve/screens/my_complaints_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/controller/logout_controller.dart';
import 'package:campusresolve/controller/userprofile_controller.dart';
import 'package:campusresolve/screens/onboard_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  UserProfileController userProfileController =
      Get.put(UserProfileController());

  ComplaintController complaintController =
      Get.put(ComplaintController(), tag: 'complaint');

  LogoutController logoutController = Get.put(LogoutController());

  final locationController = Get.put(LocationController(), tag: 'location');
  final RxString selectedFilter = 'All'.obs;
  final List<String> filterOptions = [
    'All',
    'Pending',
    'In Progress',
    'Resolved'
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Complaints'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filterOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedFilter.value,
                onChanged: (value) {
                  selectedFilter.value = value!;
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Color(0xff6F6FC8),
          //   ),
          //   onPressed: () async {
          //     final ans = await logoutController.logout();
          //     if (ans) {
          //       Get.snackbar(
          //         'Logout Successful',
          //         'You have successfully logged out',
          //         backgroundColor: Colors.black,
          //         colorText: Colors.white,
          //         snackPosition: SnackPosition.BOTTOM,
          //       );
          //       Get.off(OnBoardScreen());
          //     }
          //   },
          //   child: Icon(
          //     Icons.logout,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(ComplaintFormScreen()),
        // backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Campus Resolve',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('My Complaints'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Get.to(() => MyComplaintsScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.maps_home_work_outlined),
              title: Text('Map View'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Get.to(() => MapScreen());
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Need Help?'),
              onTap: () {
                launchUrl(
                  Uri.parse("https://v-buddy.streamlit.app/"),
                  mode: LaunchMode.inAppBrowserView,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                final ans = await logoutController.logout();
                if (ans) {
                  Get.snackbar(
                    'Logout Successful',
                    'You have successfully logged out',
                    backgroundColor: Colors.black,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Get.off(OnBoardScreen());
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => complaintController.fetchComplaints(),
        child: Obx(
          () {
            if (complaintController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (complaintController.complaints.isEmpty) {
              return Center(child: Text('No complaints yet!'));
            }
            List<Complaint> filteredComplaints = complaintController.complaints;
            if (selectedFilter.value != 'All') {
              filteredComplaints = filteredComplaints.where((complaint) {
                return complaint.status.toLowerCase() ==
                    selectedFilter.value.toLowerCase();
              }).toList();
            }

            if (filteredComplaints.isEmpty) {
              return Center(child: Text('No complaints found.'));
            }
            return ListView.builder(
              itemCount: filteredComplaints.length,
              itemBuilder: (context, index) {
                final complaint = filteredComplaints[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            Text(
                              'Roll No: ${complaint.rollNo}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 16),
                                Text(
                                  ' ${complaint.latitude.toStringAsFixed(6)}, ${complaint.longitude.toStringAsFixed(6)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            if (complaint.building != null &&
                                complaint.building!.isNotEmpty)
                              Text('Building: ${complaint.building}'),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(complaint.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    complaint.status.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                Text(
                                  _formatDate(complaint.createdAt),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: complaint.photos.isNotEmpty
                            ? Icon(Icons.photo_library)
                            : null,
                        onTap: () {
                          Get.to(() =>
                              ComplaintDetailsScreen(complaint: complaint));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
