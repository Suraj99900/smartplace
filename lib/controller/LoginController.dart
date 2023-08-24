// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../SharedPreferencesHelper.dart'; // Import your SharedPreferencesHelper if needed
import '../route/route.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final email = ''.obs;
  final password = ''.obs;
  RxBool isLogin = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  setLoginProgressBar(bool res) {
    isLogin.value = res;
  }

  Future<void> userLogin() async {
    if (loginFormKey.currentState!.validate()) {
      loginFormKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );
        User? user = userCredential.user;

        if (user != null) {
          // Fetch additional user data from Firestore
          DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .get();
          if (userDataSnapshot.exists) {
            // User data exists in Firestore
            Map<String, dynamic> userData = userDataSnapshot.data()!;
            // Save user data using SharedPreferencesHelper
            SharedPreferencesHelper.saveId("uId", userData['uid']);
            SharedPreferencesHelper.saveUserName(
                "uUserName", userData['username']);
            SharedPreferencesHelper.saveEmail("uEmail", userData['email']);
            // print(userData['profileImageUrl']);
            if (userData['profileImageUrl'] != null) {
              SharedPreferencesHelper.saveProfileURL(
                  "uProfileUrl", userData['profileImageUrl']);
            }
            // You can now use userData for further actions or display
            Get.snackbar(
              "Success",
              "User login successful",
              colorText: Colors.black,
              backgroundColor: Colors.blue,
              barBlur: 0.5,
            );
            Get.offNamed(AppRoutes.zoom);
            update();
          } else {
            Get.snackbar(
              "Error",
              "User data not found",
              colorText: Colors.black,
              backgroundColor: Colors.red,
              barBlur: 0.5,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "User login failed",
            colorText: Colors.black,
            backgroundColor: Colors.red,
            barBlur: 0.5,
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Email not found
          Get.snackbar(
            "Error",
            "No user found with this email",
            colorText: Colors.black,
            backgroundColor: Colors.red,
            barBlur: 0.5,
          );
        } else if (e.code == 'wrong-password') {
          // Wrong password
          Get.snackbar(
            "Error",
            "Incorrect password",
            colorText: Colors.black,
            backgroundColor: Colors.red,
            barBlur: 0.5,
          );
        } else {
          // Other authentication exceptions
          Get.snackbar(
            "Error",
            "Authentication failed: ${e.message}",
            colorText: Colors.black,
            backgroundColor: Colors.red,
            barBlur: 0.5,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Authentication failed",
          colorText: Colors.black,
          backgroundColor: Colors.red,
          barBlur: 0.5,
        );
      }
    }
  }
}
