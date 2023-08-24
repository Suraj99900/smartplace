import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogController extends GetxController {
  final aBlogData = <Map<String, dynamic>>[].obs;

  Future<void> fetchBlogById(String id) async {
    try {
      final blogSnapshot =
          await FirebaseFirestore.instance.collection('blog').doc(id).get();

      if (blogSnapshot.exists) {
        // The document with the given ID exists in the 'blog' collection
        aBlogData.assignAll([blogSnapshot.data()!]);
      } else {
        Get.snackbar(
          "Error",
          "Blog not found",
          colorText: Colors.black,
          backgroundColor: Colors.red,
          barBlur: 0.5,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Error: ${e.toString()}",
        colorText: Colors.black,
        backgroundColor: Colors.red,
        barBlur: 0.5,
      );
    }
  }
}
