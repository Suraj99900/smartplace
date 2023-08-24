import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartplace/controller/configController.dart';
import 'dart:io';

import '../SharedPreferencesHelper.dart';
import '../route/route.dart';

class ZoomMenuController extends GetxController {
  final RxDouble sWidth = Get.width.obs;
  final RxString sUserName = "".obs;
  final RxString sId = "".obs;
  final RxString sProfileUrl = "".obs;
  RxBool isLoading = false.obs; // For showing loading indicator

  @override
  void onInit() {
    super.onInit();
    loadStoredPreference();
  }

  Future<void> loadStoredPreference() async {
    ImageCache().clear();

    var id = await SharedPreferencesHelper.getId("uId");

    // Fetch additional user data from Firestore
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(id).get();
      if (userDataSnapshot.exists) {
        // User data exists in Firestore
        Map<String, dynamic> userData = userDataSnapshot.data()!;
        // Save user data using SharedPreferencesHelper
        SharedPreferencesHelper.saveId("uId", userData['uid']);
        SharedPreferencesHelper.saveUserName("uUserName", userData['username']);
        SharedPreferencesHelper.saveEmail("uEmail", userData['email']);
        if (userData['profileImageUrl'] != null) {
          SharedPreferencesHelper.saveProfileURL(
              "uProfileUrl", userData['profileImageUrl']);
        }
      }
    } catch (e) {
      print(e);
    }
    var userName = await SharedPreferencesHelper.getUserName("uUserName");
    var profileUrl = await SharedPreferencesHelper.getProfileURL("uProfileUrl");
    sUserName.value = userName ?? "demo";
    sId.value = id ?? "";
    sProfileUrl.value =
        profileUrl ?? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";
  }

  Future<void> uploadProfileImage() async {
    var uId = await SharedPreferencesHelper.getId("uId");
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      isLoading.value = true;
      final pickedImageFile = File(pickedImage.path);
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final UploadTask uploadTask = storageReference.putFile(pickedImageFile);

      await uploadTask.whenComplete(() {
        Get.snackbar(
          "Success",
          "Profile image uploaded",
          colorText: Colors.black,
          backgroundColor: Colors.blue,
          barBlur: 0.5,
        );
        isLoading.value = false;
      });

      final String downloadURL = await storageReference.getDownloadURL();
      // Now you can use the downloadURL for the user's profile image.
      // Update user's profile image URL in Firestore
      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'profileImageUrl': downloadURL,
      });
      SharedPreferencesHelper.saveProfileURL("uProfileUrl", downloadURL);
      loadStoredPreference();
    } else {
      Get.snackbar(
        "Error",
        "No image selected",
        colorText: Colors.black,
        backgroundColor: Colors.red,
        barBlur: 0.5,
      );
    }
  }
}

class ZoomMenu extends StatefulWidget {
  const ZoomMenu({Key? key}) : super(key: key);

  @override
  _ZoomMenuState createState() => _ZoomMenuState();
}

class _ZoomMenuState extends State<ZoomMenu> {
  final ZoomMenuController controller = Get.put(ZoomMenuController());
  final ConfigController configController = Get.put(ConfigController());
  @override
  void initState() {
    super.initState();
    controller.loadStoredPreference(); // Call the method in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80.0),
              Center(
                child: Column(
                  children: [
                    controller.isLoading != true
                        ? GestureDetector(
                            onTap: () async {
                              await controller.uploadProfileImage();
                            },
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                controller.sProfileUrl.isNotEmpty
                                    ? controller.sProfileUrl.value
                                    : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                              ),
                            ),
                          )
                        : CircularProgressIndicator(),
                    const SizedBox(height: 20.0),
                    Obx(() => Text(
                          controller.sUserName.value,
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              fontSize: controller.sWidth.value * 0.05,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              buildMenuItem("Home", Icons.home, AppRoutes.zoom),
              buildMenuItem("Search", Icons.search, AppRoutes.zoom),
              buildMenuItem("Blog", Icons.article, AppRoutes.zoom),
              buildMenuItem("About", Icons.person, AppRoutes.zoom),
              buildDashboardMenuItem(),
              const SizedBox(height: 50.0),
              buildLoginRegisterButtons(),
            ],
          );
        }),
      ),
    );
  }

  Widget buildMenuItem(String label, IconData icon, routeName) {
    return TextButton.icon(
      onPressed: () {
        // Handle navigation and logic based on the label
        if (label == "Home") {
          configController.setDashBoard(false);
        }
        Get.offNamed(routeName);
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: GoogleFonts.arsenal(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: controller.sWidth.value * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildDashboardMenuItem() {
    return Obx(() {
      return controller.sId.value != ''
          ? TextButton.icon(
              onPressed: () {
                configController.setDashBoard(true);
                Get.toNamed(AppRoutes.zoom);
              },
              icon: const Icon(Icons.dashboard_customize_rounded,
                  color: Colors.black),
              label: Text(
                "DashBoard",
                style: GoogleFonts.arsenal(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: controller.sWidth.value * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : const SizedBox(); // Use SizedBox to show nothing if the condition is not met
    });
  }

  Widget buildLoginRegisterButtons() {
    return Obx(() {
      return controller.sId == ''
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("Login In", AppRoutes.login),
                buildButton("Register", AppRoutes.signup),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildButton("Log Out", AppRoutes.initial, Colors.red),
              ],
            );
    });
  }

  Widget buildButton(String label, String route, [Color? color]) {
    return TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>((states) {
          return BorderSide(
            style: BorderStyle.solid,
            color: color ?? Colors.black,
          );
        }),
      ),
      onPressed: () async {
        if (route == AppRoutes.initial) {
          await SharedPreferencesHelper.clearSharedPreferences();
          Get.snackbar(
            "Success",
            "Log out Sccessfully",
            colorText: Colors.black,
            backgroundColor: Colors.blue,
            barBlur: 0.5,
          );
          Get.offNamed(route);
        }
        Get.toNamed(route);
      },
      child: Text(
        label,
        style: GoogleFonts.arsenal(
          textStyle: TextStyle(
            color: color ?? Colors.black,
            fontSize: controller.sWidth.value * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
