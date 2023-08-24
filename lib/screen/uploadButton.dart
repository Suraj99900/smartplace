import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartplace/route/route.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({super.key});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  var dWidth = Get.width;
  var dHeight = Get.height;
  var buttonWidth = 200.0;
  var buttonHeight = 60.0;
  var buttonTextStyle = GoogleFonts.arsenal(
      textStyle: TextStyle(
    fontSize: Get.width * 0.03,
    fontWeight: FontWeight.bold,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: dWidth >= 850 ? dWidth * 0.3 : dWidth * 0.9,
        height: dHeight * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_file_rounded),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Upload Data",
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: dWidth * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: dHeight * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.note_add_rounded),
                  label: Text(
                    "Upload Notes",
                    style: buttonTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue, // Adjust color as needed
                    minimumSize: Size(buttonWidth, buttonHeight),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.code_off_rounded),
                  label: Text(
                    "Upload Project",
                    style: buttonTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen, // Adjust color as needed
                    minimumSize: Size(buttonWidth, buttonHeight),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.uploadBlog);
                  },
                  icon: Icon(Icons.article_rounded),
                  label: Text(
                    "Upload Blog",
                    style: buttonTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Adjust color as needed
                    minimumSize: Size(buttonWidth, buttonHeight),
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
