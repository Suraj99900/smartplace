import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartplace/SharedPreferencesHelper.dart';
import 'package:smartplace/controller/configController.dart';
import 'package:smartplace/route/route.dart';
import 'package:smartplace/screen/BlogFiled.dart';

class BlogUploadController extends GetxController {
  RxList<BlogFieldModel> blogField = <BlogFieldModel>[].obs;
  final TextEditingController jsonController = TextEditingController();
  late Rx<File> file;
  RxList<Map<String, dynamic>> aFetchData = <Map<String, dynamic>>[].obs;
  RxBool isFormValid = false.obs;
  RxBool isImageValid = false.obs;
  RxBool isSubmitInProgress = false.obs;
  RxBool isDownloadInProgress = false.obs;
  RxBool isDeleteInProgress = false.obs;
  RxString sProfileUrl = "".obs;

  RxList<Map<String, dynamic>> aFetchImageData = <Map<String, dynamic>>[].obs;

  setPreLoaded() async {
    sProfileUrl.value =
        await SharedPreferencesHelper.getProfileURL("uProfileUrl") ?? "";
  }

  void setDownloadInProgress(bool value) {
    isDownloadInProgress.value = value;
  }

  void setDeleteInProgress(bool value) {
    isDeleteInProgress.value = value;
  }

  void setSubmitInProgress(bool value) {
    isSubmitInProgress.value = value;
  }

  void addSkillField() {
    blogField.add(BlogFieldModel(mainImage: ""));
  }

  void updateFormValidity() {
    isFormValid.value = jsonController.text.isNotEmpty;
  }

  void checkImageValidity() {
    isImageValid.value = blogField.any(_isProjectFieldModelValid);
  }

  bool _isProjectFieldModelValid(BlogFieldModel model) {
    return model.mainImage != '';
  }

  void removeSkillField(int index) {
    if (index >= 0 && index < blogField.length) {
      blogField.removeAt(index);
    }
  }

  @override
  void dispose() {
    for (var field in blogField) {
      field.mainImage.dispose();
    }
    super.dispose();
  }

  Future<void> uploadImageAndSubmit(
      String fileName, File pickedImageFile) async {
    final Reference storageReference = FirebaseStorage.instance.ref().child(
        'blog_images/${DateTime.now().millisecondsSinceEpoch}_${fileName}.jpg');

    final UploadTask uploadTask = storageReference.putFile(pickedImageFile);

    await uploadTask.whenComplete(() async {
      final String downloadURL = await storageReference.getDownloadURL();
      aFetchImageData.add({'fileName': fileName, 'imageUrl': downloadURL});
      aFetchData.add({'fileName': fileName, 'blogUrl': downloadURL});
    });
  }

  Future<void> submitImage() async {
    aFetchImageData.clear();
    aFetchData.clear();
    for (var field in blogField) {
      if (field.mainImage != null) {
        String fileName = field.mainImage.path.split('/').last;
        await uploadImageAndSubmit(fileName, field.mainImage);
      }
    }
    Get.snackbar(
      "Success",
      "Images Uploaded",
      colorText: Colors.black,
      backgroundColor: Colors.blue,
      barBlur: 0.5,
    );
  }

  Future<void> submitBlog() async {
    final uid = await SharedPreferencesHelper.getId("uId") ?? "";

    await FirebaseFirestore.instance.collection('blog').doc().set(
        {"uid": uid, 'blog': jsonController.text, "blogimage": aFetchData});

    Get.snackbar(
      "Success",
      "Blog Uploaded",
      colorText: Colors.black,
      backgroundColor: Colors.blue,
      barBlur: 0.5,
    );
    // Clear the fields and controller
    blogField.clear();
    jsonController.clear();
    aFetchData.clear();
    aFetchImageData.clear();

    ConfigController().setDashBoard(false);
    Get.toNamed(AppRoutes.zoom);
  }
}
