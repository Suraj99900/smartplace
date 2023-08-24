import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class BlogFieldModel {
  var mainImage;

  BlogFieldModel({
    this.mainImage = '',
  });
}

class BlogField extends StatefulWidget {
  final BlogFieldModel model;
  final VoidCallback onRemove;

  BlogField({Key? key, required this.model, required this.onRemove})
      : super(key: key);

  @override
  _BlogFieldState createState() => _BlogFieldState();
}

class _BlogFieldState extends State<BlogField> {
  final sWidth = Get.width;
  final sHeight = Get.height;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    widget.model.mainImage = File(pickedFile.path);
                  });
                }
              },
              child: Container(
                width: sWidth * 0.4,
                child: widget.model.mainImage != ''
                    ? Column(
                        children: [
                          Image.file(
                            widget.model.mainImage,
                            fit: BoxFit.fill,
                            width: sWidth * 0.4,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Image Selected",
                            style: GoogleFonts.arsenal(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    : Image.asset(
                        "assets/images/upload.png",
                        fit: BoxFit.fill,
                        width: sWidth * 0.4,
                      ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.remove),
                  label: const Text('Remove'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
