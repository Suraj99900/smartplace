import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartplace/route/route.dart';

class SignUpController extends GetxController {
  final signUpFormKey = GlobalKey<FormState>();
  final username = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final password = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      signUpFormKey.currentState!.save();
      try {
        UserCredential aResult = await _auth.createUserWithEmailAndPassword(
            email: email.value, password: password.value);
        User? user = aResult.user;

        if (user != null) {
          String uid = user.uid;
          // Store additional user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': uid, // Store the UID in Firestore
            'username': username.value,
            'email': email.value,
            'phone': phone.value,
          });
          Get.snackbar(
            "Success",
            "User registered successfully",
            colorText: Colors.black,
            backgroundColor: Colors.blue,
            barBlur: 0.5,
          );
          Get.offNamed(AppRoutes.login);
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred.";
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        }

        Get.snackbar(
          "Error",
          errorMessage,
          colorText: Colors.black,
          backgroundColor: Colors.red,
          barBlur: 0.5,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          "An error occurred while registering the user.",
          colorText: Colors.black,
          backgroundColor: Colors.red,
          barBlur: 0.5,
        );
      }
    }
  }
}
