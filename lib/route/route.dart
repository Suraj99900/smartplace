import 'package:get/get.dart';
import 'package:smartplace/screen/LoginScreen.dart';
import 'package:smartplace/screen/SplashScreen.dart';
import 'package:smartplace/screen/blogUpload.dart';
import 'package:smartplace/screen/dashBoard.dart';
import 'package:smartplace/screen/homeScreen.dart';
import 'package:smartplace/screen/registerUser.dart';
import 'package:smartplace/screen/zoomScreen.dart';

class AppRoutes {
  static const initial = '/';
  static const home = '/home';
  static const zoom = '/zoom';
  static const login = '/login';
  static const signup = '/signup';
  static const dashBoard = '/dashBoard';
  static const uploadBlog = '/uploadBlog';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(name: zoom, page: () => const ZoomScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: dashBoard, page: () => const DashBoardScreen()),
    GetPage(name: uploadBlog, page: () => BlogUploadScreen()),
  ];
}
