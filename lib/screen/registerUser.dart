import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartplace/controller/SignUpController.dart';

import '../route/route.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final SignUpController _signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    var dWidth = MediaQuery.of(context).size.width;
    var dHeight = MediaQuery.of(context).size.height;

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
                      "Create",
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
                    SizedBox(width: dWidth * 0.13),
                    Text(
                      "   Account",
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
                  height: 30.0,
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
                      padding: const EdgeInsets.all(50.0),
                      child: Form(
                        key: _signUpController.signUpFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _signUpController.username.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
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
                                _signUpController.email.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                hintText: 'Enter your phone number',
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                // You can add more phone number validation logic here
                                return null;
                              },
                              onSaved: (value) {
                                _signUpController.phone.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
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
                                _signUpController.password.value = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton.icon(
                              onPressed: _signUpController.signUp,
                              icon: const Icon(Icons.app_registration_rounded),
                              label: Text(
                                "Sign Up",
                                style: GoogleFonts.arsenal(
                                  textStyle: TextStyle(
                                    fontSize: dWidth * 0.05,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Get.offNamed(AppRoutes.login);
                                  },
                                  icon: const Icon(Icons.login),
                                  label: Text(
                                    "Login",
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
