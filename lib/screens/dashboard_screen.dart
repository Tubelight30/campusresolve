//ignore_for_file: prefer_const_constructors
import 'package:campusresolve/controller/complaint_controller.dart';
import 'package:campusresolve/controller/location_controller.dart';
import 'package:campusresolve/screens/complaint_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campusresolve/controller/logout_controller.dart';
import 'package:campusresolve/controller/userprofile_controller.dart';
import 'package:campusresolve/screens/onboard_screen.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({super.key});
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  ComplaintController complaintController = Get.put(ComplaintController());

  LogoutController logoutController = Get.put(LogoutController());
  final locationController = Get.find<LocationController>();
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff6F6FC8),
            ),
            onPressed: () async {
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
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(ComplaintFormScreen()),
        // backgroundColor: Colors.black,
        child: Icon(Icons.add),
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
            return ListView.builder(
              itemCount: complaintController.complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaintController.complaints[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
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
                              ' ${complaint.latitude.toStringAsFixed(3)}, ${complaint.longitude.toStringAsFixed(3)}',
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: complaint.photos.isNotEmpty
                        ? Icon(Icons.photo_library)
                        : null,
                    onTap: () {
                      // TODO: Implement complaint details view
                      // Get.to(() => ComplaintDetailsScreen(complaint: complaint));
                    },
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

// class DashBoardScreen extends StatelessWidget {
//   DashBoardScreen({super.key});
//   UserProfileController userProfileController =
//       Get.put(UserProfileController());
//   // NoteController noteController = Get.put(NoteController());
//   LogoutController logoutController = Get.put(LogoutController());
//   Map<int, String> month = {
//     1: "Jan",
//     2: "Feb",
//     3: "Mar",
//     4: "Apr",
//     5: "May",
//     6: "Jun",
//     7: "Jul",
//     8: "Aug",
//     9: "Sep",
//     10: "Oct",
//     11: "Nov",
//     12: "Dec"
//   };
//   void _showCreateNoteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Create New Note'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: noteController.titleController,
//                 decoration: InputDecoration(hintText: 'Title'),
//               ),
//               TextField(
//                 controller: noteController.contentController,
//                 decoration: InputDecoration(hintText: 'Content'),
//                 maxLines: 3,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 noteController.createNote();
//                 Navigator.of(context).pop();
//               },
//               child: Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _refresh() async {
//     await noteController.fetchNotes();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey[900],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         title: Obx(
//           () {
//             if (userProfileController.isLoading.value) {
//               return Text('Loading...');
//             }
//             return Text(
//               "Welcome, " + userProfileController.loggedInUser!.name,
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             );
//           },
//         ),
//         actions: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xff6F6FC8),
//             ),
//             onPressed: () async {
//               final ans = await logoutController.logout();
//               if (ans) {
//                 Get.snackbar(
//                   'Logout Successful',
//                   'You have successfully logged out',
//                   backgroundColor: Colors.black,
//                   colorText: Colors.white,
//                   snackPosition: SnackPosition.BOTTOM,
//                 );
//                 Get.off(OnBoardScreen());
//               }
//             },
//             child: Icon(
//               Icons.logout,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: SizedBox(
//         width: 80,
//         height: 80,
//         child: FloatingActionButton(
//           shape: const CircleBorder(),
//           backgroundColor: const Color(0xff6F6FC8),
//           onPressed: () {
//             _showCreateNoteDialog(context);
//           },
//           child: const Icon(
//             Icons.note_add_outlined,
//             size: 32,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: Obx(
//           () {
//             if (noteController.isLoading.value) {
//               // return const Center(
//               //   child: CircularProgressIndicator(),
//               // );
//             }
//             return ListView.builder(
//               itemCount: noteController.notes.length,
//               itemBuilder: (context, index) {
//                 Note note = noteController.notes[index];
//                 return Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.white,
//                     border: Border.all(
//                       color: Colors.white,
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       note.title,
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     trailing: Text(
//                       "${month[note.updatedAt.month]} ${note.updatedAt.day.toString()} ${note.updatedAt.hour.toString()}:${note.updatedAt.minute.toString()}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     subtitle: Text(
//                       note.content
//                           .split('\n')
//                           .first, // Only show the first line
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     onTap: () {
//                       Get.to(() => EditNoteScreen(note: note));
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
