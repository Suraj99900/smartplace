import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartplace/controller/blogController.dart';
import 'package:smartplace/controller/homeScreenController.dart';

class BlogScreen extends StatefulWidget {
  final String id;

  const BlogScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  BlogController blogController = Get.put(BlogController());
  HomeScreenController homeController = Get.put(HomeScreenController());
  Map<String, dynamic> aPost = {};
  String profileUrl = "";

  Future<void> callBlogFetch() async {
    await blogController.fetchBlogById(widget.id);
    var aData = await blogController.aBlogData.value;
    aPost = jsonDecode(aData[0]["blog"]) as Map<String, dynamic>;
    String id = aData[0]['uid'];
    profileUrl = await homeController.fetchProfileUrl(id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.1;

    return FutureBuilder(
      future: callBlogFetch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: screenWidth * 0.2,
              height: Get.height * 0.1,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"), // Handle error
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                'SmartPlace',
                style: GoogleFonts.barriecito(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              scrolledUnderElevation: 0,
            ),
            body: Scaffold(
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 30),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        aPost['topic'],
                                        style: GoogleFonts.arsenal(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.0,
                                      ),
                                      Text(
                                        aPost['date'],
                                        style: GoogleFonts.arsenal(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    aPost['blog_data']['main_heading']
                                        .toUpperCase(),
                                    style: GoogleFonts.arsenal(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: iconSize,
                                  backgroundImage: Image.network(
                                    profileUrl,
                                    fit: BoxFit.fill,
                                  ).image,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(200)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(174, 137, 200, 248),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 5),
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.2),
                                      spreadRadius: 2,
                                      blurRadius: 10)
                                ],
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: // Form Section
                                  Container(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      aPost['blog_data']['main_heading'],
                                      style: GoogleFonts.arsenal(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      child: Image.network(
                                        aPost["blog_data"]['1_img'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Loop through sub_data and create widgets
                                    for (var subSection in aPost["blog_data"]
                                        ["sub_data"])
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (subSection["img"].isNotEmpty)
                                            Container(
                                              child: Image.network(
                                                subSection["img"],
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          if (subSection["sub_heading"]
                                              .isNotEmpty)
                                            Text(
                                              subSection["sub_heading"],
                                              style: GoogleFonts.arsenal(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: screenWidth * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          if (subSection["container"]
                                              .isNotEmpty)
                                            Text(
                                              subSection["container"],
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.arsenal(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: screenWidth * 0.03,
                                                ),
                                              ),
                                            ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
