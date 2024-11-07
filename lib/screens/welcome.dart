import 'package:flutter/material.dart';
import 'package:shoply/constants/routes.dart';
import 'package:shoply/screens/login.dart';
import 'package:shoply/screens/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: kToolbarHeight + 20,
          ),
          Image.asset(
            "assets/images/logo.png",
            // ImagesIcons.instance.welcomeimage

            scale: 0.1,
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            "Thank You For Choosing us!",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 21),
          ),
        
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Routes().push(const Login(), context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 155, 245, 201),
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
                onPressed: () {
                  Routes().push(const SignUp(), context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "Signup",
                  style: TextStyle(
                    color: Color.fromARGB(255, 123, 199, 162),
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                )),
          ),
          const SizedBox(
            height: 24.0,
          ),
          const Text(
            "Sign up using",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
