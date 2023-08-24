import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartplace/Table/userTable.dart';
import 'package:smartplace/screen/menu.dart';
import 'package:smartplace/screen/uploadButton.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  var sWidth = Get.width;
  var sHeight = Get.height;
  RxInt _selectedIndex = 0.obs;
  final UserTableController _userTableController =
      Get.put(UserTableController());
  @override
  Widget build(BuildContext context) {
    _userTableController.fetchUserData();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(
          25,
          255,
          255,
          255,
        ), // Set background color to white
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SmartPlace",
              style: GoogleFonts.barriecito(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: sWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GestureDetector(
                onTap: () {
                  ZoomMenuController().loadStoredPreference();
                  ZoomDrawer.of(context)?.toggle();
                },
                child: Icon(
                  Icons.person_4_rounded,
                  color: Colors.white,
                  size: sWidth * 0.08,
                ),
              ),
            ),
          ],
        ),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false, // Hide the back button
      ),
      body: Obx(() {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Add a light shadow
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              NavigationRail(
                onDestinationSelected: (int index) {
                  _selectedIndex.value = index;
                },
                selectedIndex: _selectedIndex.value,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.person_2_rounded, size: sWidth * 0.08),
                      label: Text('Admin')),
                  NavigationRailDestination(
                      icon: Icon(Icons.notes_rounded, size: sWidth * 0.08),
                      label: Text('Blog')),
                  NavigationRailDestination(
                      icon:
                          Icon(Icons.file_upload_rounded, size: sWidth * 0.08),
                      label: Text('Upload')),
                  NavigationRailDestination(
                      icon: Icon(Icons.settings), label: Text('Settings')),
                ],

                labelType: NavigationRailLabelType.all,
                selectedLabelTextStyle: GoogleFonts.arsenal(
                  textStyle: TextStyle(
                      fontSize: sWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),

                unselectedLabelTextStyle: const TextStyle(),
                // Called when one tab is selected
              ),
              Expanded(child: _screens[_selectedIndex.value])
            ],
          ),
        );
      }),
    );
  }

  final List<Widget> _screens = [
    // Content for Feed tab
    Container(
      alignment: Alignment.center,
      child: UserTable(),
    ),
    // Content for Favorites tab
    Container(
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Settings tab
    Container(
      alignment: Alignment.center,
      child: UploadButton(),
    ),
    Container(
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];
}
