// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/LoginController.dart';
import '../route/route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var dWidth = Get.width;
    var dHeight = Get.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "assets/images/register.png",
              width: dWidth * 1,
              height: dHeight * 1,
              fit: BoxFit.fill,
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: dWidth * 0.1),
                    Text(
                      "Student",
                      style: GoogleFonts.arsenal(
                        textStyle: TextStyle(
                          fontSize: dWidth * 0.15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: dWidth * 0.15),
                    Text(
                      "   Login",
                      style: GoogleFonts.arsenal(
                        textStyle: TextStyle(
                          fontSize: dWidth * 0.15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: Container(
                    width: dWidth >= 850 ? dWidth * 0.6 : dWidth * 0.9,
                    // height: dHeight * 0.6,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(70, 0, 0, 0),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: Offset(10, 10),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _loginController.loginFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an email';
                                }
                                // You can add more email validation logic here
                                return null;
                              },
                              onSaved: (value) {
                                _loginController.email.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                              ),
                              obscureText: true, // Hide the password
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a password';
                                }
                                // You can add more password validation logic here
                                return null;
                              },
                              onSaved: (value) {
                                _loginController.password.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Obx(() {
                              return _loginController.isLogin == true
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton.icon(
                                      onPressed: () async {
                                        _loginController
                                            .setLoginProgressBar(true);
                                        await _loginController.userLogin();
                                        _loginController
                                            .setLoginProgressBar(false);
                                      },
                                      icon: const Icon(
                                          Icons.app_registration_rounded),
                                      label: const Text(
                                        "Log in",
                                        style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    );
                            }),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Get.offNamed(AppRoutes.signup);
                                  },
                                  icon: const Icon(
                                      Icons.app_registration_rounded),
                                  label: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Manrope",
                                        fontSize: dWidth >= 550 ? 16 : 12),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.password_rounded),
                                  label: Text(
                                    "Forget password",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Manrope",
                                        fontSize: dWidth >= 550 ? 16 : 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
