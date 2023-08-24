import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartplace/controller/blogUploadController.dart';
import 'package:smartplace/modal/CopyTextModal.dart';
import 'package:smartplace/screen/BlogFiled.dart';

class BlogUploadScreen extends StatefulWidget {
  const BlogUploadScreen({super.key});

  @override
  State<BlogUploadScreen> createState() => _BlogUploadScreenState();
}

class _BlogUploadScreenState extends State<BlogUploadScreen> {
  final BlogUploadController _controller = Get.put(BlogUploadController());

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.1;
    final mainTitleFontSize = screenHeight * 0.035;
    final titleFontSize = screenHeight * 0.02;
    final subtitleFontSize = screenHeight * 0.018;
    final textFieldFontSize = screenHeight * 0.020;
    // Fetch and set personal information

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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upload Blog".toUpperCase(),
                          style: GoogleFonts.arsenal(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: iconSize,
                            backgroundImage: Image.network(
                              _controller.sProfileUrl.value != ''
                                  ? _controller.sProfileUrl.value
                                  : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
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
                      key: _formKey,
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
                          child: Obx(
                            () => _controller.isSubmitInProgress.value != true
                                ? Column(
                                    children: [
                                      for (int index = 0;
                                          index < _controller.blogField.length;
                                          index++)
                                        BlogField(
                                          model: _controller.blogField[index],
                                          onRemove: () => _controller
                                              .removeSkillField(index),
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              _controller.checkImageValidity();
                                              if (_controller
                                                  .isImageValid.value) {
                                                _controller
                                                    .setSubmitInProgress(true);
                                                await _controller.submitImage();
                                                _controller
                                                    .setSubmitInProgress(false);
                                              } else {
                                                Get.snackbar(
                                                  'Form Error',
                                                  'Please add images...',
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                              print(
                                                  _controller.aFetchImageData);
                                            },
                                            label: const Text('Upload Image'),
                                            icon: const Icon(
                                                Icons.upload_file_rounded),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              _controller.addSkillField();
                                            },
                                            label: const Text('Add Image'),
                                            icon: const Icon(Icons.add_circle),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          minLines: 10,
                                          maxLines: 1000,
                                          controller:
                                              _controller.jsonController,
                                          decoration: const InputDecoration(
                                              labelText: 'Json File Containe'),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              _controller.updateFormValidity();
                                              if (_controller
                                                  .isFormValid.value) {
                                                _controller
                                                    .setSubmitInProgress(true);
                                                await _controller.submitBlog();
                                                _controller
                                                    .setSubmitInProgress(false);
                                              } else {
                                                Get.snackbar(
                                                  'Form Error',
                                                  'Please fill in all fields before submitting.',
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            }, // Disable button if form not valid
                                            icon: const Icon(
                                                Icons.upload_outlined),
                                            label: Text("submit".toUpperCase()),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          if (_controller
                                              .aFetchImageData.isNotEmpty)
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                Get.bottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  CopyTextModal(
                                                      textToCopy: _controller
                                                          .aFetchImageData
                                                          // ignore: invalid_use_of_protected_member
                                                          .value),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.upload_outlined),
                                              label: Text(
                                                  "Image Url".toUpperCase()),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  )
                                : const CircularProgressIndicator(),
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
}
