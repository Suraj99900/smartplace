import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:smartplace/controller/blogController.dart';
import 'package:smartplace/controller/homeScreenController.dart';
import 'package:smartplace/screen/blogScreen.dart';
import 'package:smartplace/screen/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController homeController = Get.put(HomeScreenController());
  var sWidth = Get.width;
  bool isDrawerOpen = false;
  final double drawerWidth = 200.0; // Width of the drawer when open

  @override
  Widget build(BuildContext context) {
    homeController.fetchBlog();
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
      body: Row(
        children: [
          Expanded(
            flex: isDrawerOpen ? 3 : 4,
            child: Container(
              color: Colors.white70, // Set background color to white
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      LoopAnimationBuilder(
                        duration: const Duration(seconds: 3),
                        tween: IntTween(
                            begin: 0, end: "Welcome to SmartPlace".length),
                        builder: (context, animatedValue, child) {
                          String text = "Welcome to SmartPlace"
                              .substring(0, animatedValue);
                          return Text(
                            text,
                            style: GoogleFonts.arsenal(
                              textStyle: TextStyle(
                                  fontSize: sWidth * 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Explore a collection of thought-provoking articles, insightful reviews, and captivating stories that ignite your curiosity.",
                        style: GoogleFonts.arsenal(
                          textStyle: TextStyle(
                              fontSize: sWidth * 0.04, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.3), // Add a light shadow
                              spreadRadius: 2,
                              blurRadius: 20,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "assets/images/college_1.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeController.userPosts.value.length,
                          itemBuilder: (context, index) {
                            return buildUserPostContainer(
                                homeController.userPosts.value[index]);
                          },
                        );
                      }),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserPostContainer(post) {
    var aPostData = jsonDecode(post['data']['blog']);
    //Fetch profile url by id
    return GestureDetector(
      onTap: () async {
        Get.to(BlogScreen(
          id: post['id'],
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post['profileUrl']),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aPostData['author_name'],
                      style: GoogleFonts.arsenal(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Uploaded on ${aPostData['date']}",
                      style: GoogleFonts.arsenal(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      "Topic: ${aPostData['topic']}",
                      style: GoogleFonts.arsenal(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              child: Image.network(
                aPostData["blog_data"]['1_img'],
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              aPostData["blog_data"]['main_heading'],
              style: GoogleFonts.arsenal(
                textStyle: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              aPostData["blog_data"]['sub_data'][0]['container']
                      .substring(0, 250) +
                  "...",
              textAlign: TextAlign.justify,
              style: GoogleFonts.arsenal(
                textStyle: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
