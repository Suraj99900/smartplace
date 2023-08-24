import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:smartplace/controller/configController.dart';
import 'package:smartplace/screen/dashBoard.dart';
import 'package:smartplace/screen/homeScreen.dart';
import 'package:smartplace/screen/menu.dart';

class ZoomScreen extends StatefulWidget {
  const ZoomScreen({super.key});

  @override
  State<ZoomScreen> createState() => _ZoomScreenState();
}

class _ZoomScreenState extends State<ZoomScreen> {
  ConfigController configController = Get.put(ConfigController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ZoomDrawer(
        menuScreen: ZoomMenu(),
        mainScreen: configController.isDashBoard.value
            ? DashBoardScreen()
            : HomeScreen(),
        angle: 0.0,
        menuBackgroundColor: Colors.white,
        mainScreenScale: 0.2,
        shadowLayer1Color: Colors.black,
        shadowLayer2Color: Colors.black,
        duration: Duration(microseconds: 600),
      );
    });
  }
}
