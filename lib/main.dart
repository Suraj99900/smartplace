import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:smartplace/firebase_options.dart';
import 'package:smartplace/route/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartPlace',
      initialRoute:
          AppRoutes.initial, // Set the initial route to the home route
      getPages: AppRoutes
          .routes, // Use the AppRoutes.routes list to define the routes
    );
  }
}
