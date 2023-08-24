import 'package:get/get.dart';

class ConfigController extends GetxController {
  RxBool isDashBoard = false.obs;

  setDashBoard(bool value) {
    isDashBoard.value = value;
  }
}
