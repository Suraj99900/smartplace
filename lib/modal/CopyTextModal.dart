import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CopyTextModal extends StatelessWidget {
  final List<Map<String, dynamic>> textToCopy;

  CopyTextModal({Key? key, required this.textToCopy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back(); // Close the modal using GetX
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              for (var item in textToCopy)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(174, 137, 200, 248),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FileName: ${item['fileName']}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Image URL: ${item['imageUrl']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: item['imageUrl']));
                          Get.snackbar(
                            "Copied",
                            "Image URL copied",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                          );
                        },
                        child: const Text('Copy URL'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
