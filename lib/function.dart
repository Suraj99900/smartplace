import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartplace/SharedPreferencesHelper.dart';

Future<void> uploadProfileImage() async {
  var uId = await SharedPreferencesHelper.getId("uId");
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
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
    });

    final String downloadURL = await storageReference.getDownloadURL();
    // Now you can use the downloadURL for the user's profile image.
    // Update user's profile image URL in Firestore
    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'profileImageUrl': downloadURL,
    });
    SharedPreferencesHelper.saveProfileURL("uProfileUrl", downloadURL);
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
