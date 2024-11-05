// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoply/Firebase/firebase_auth.dart';
import 'package:shoply/constants/constants.dart';
import 'package:shoply/constants/routes.dart';
import 'package:shoply/screens/custom_bottom_bar.dart';
import 'package:shoply/screens/signup.dart';
import 'package:shoply/widget/custom_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromARGB(255, 253, 253, 253), const Color.fromARGB(255, 255, 255, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight),
                Image.asset("assets/images/logo.png"),
                const SizedBox(height: 20),
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 20),
                // Email TextField
                CustomTextField(
                  textEditingController: email,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color.fromARGB(255, 155, 245, 201),
                  ),
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                // Password TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    controller: password,
                    obscureText: isShowPassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: CupertinoButton(
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                        child: Icon(
                          isShowPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 155, 245, 201),
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color.fromARGB(255, 155, 245, 201),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 155, 245, 201),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValidated =
                          loginValidation(email.text, password.text);
                      if (isValidated) {
                        bool isLogined = await FirebaseAuthHelper.instance
                            .login(email.text, password.text, context);
                        if (isLogined) {
                          Routes().pushAndRemoveUntil(
                              const CustomBottomBar(), context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 155, 245, 201),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Sign Up Button
                TextButton(
                  onPressed: () {
                    Routes().push(const SignUp(), context);
                  },
                  child: const Text(
                    "Create an account",
                    style: TextStyle(
                      color: Color.fromARGB(255, 155, 245, 201),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
