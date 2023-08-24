import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxBool isBlogLoad = false.obs;
  RxList userPosts = [].obs;

  Future<void> fetchBlog() async {
    try {
      isBlogLoad.value = true;

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('blog').get();

      List profileUrlFutures = querySnapshot.docs
          .map((doc) => fetchProfileUrl(doc.data()['uid'].toString()))
          .toList();

      List<Map<String, dynamic>> postsWithProfileUrl = [];
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        String profileUrl = await profileUrlFutures[i];
        postsWithProfileUrl.add({
          "id": querySnapshot.docs[i].id,
          "data": querySnapshot.docs[i].data(),
          "profileUrl": profileUrl,
        });
      }

      userPosts.assignAll(postsWithProfileUrl);
      isBlogLoad.value = false;
    } catch (e) {
      isBlogLoad.value = false;
      Get.snackbar(
        "Error",
        "Failed to fetch blog: $e",
        colorText: Colors.black,
        backgroundColor: Colors.red,
        barBlur: 0.5,
      );
    }
  }

  Future<String> fetchProfileUrl(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(id).get();

      if (userDataSnapshot.exists) {
        Map<String, dynamic> userData = userDataSnapshot.data()!;
        return userData['profileImageUrl'];
      }

      return 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
    } catch (e) {
      isBlogLoad.value = false;
      Get.snackbar(
        "Error",
        "Failed to fetch blog: $e",
        colorText: Colors.black,
        backgroundColor: Colors.red,
        barBlur: 0.5,
      );
      return 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
    }
  }
}
