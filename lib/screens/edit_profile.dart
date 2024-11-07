import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoply/models/user_model.dart';
import 'package:shoply/provider/app_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    // Responsive dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        children: [
          Center(
            child: image == null
                ? GestureDetector(
                    onTap: null,
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 70,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: null,
                    child: CircleAvatar(
                      backgroundImage: FileImage(image!),
                      radius: 70,
                    ),
                  ),
          ),
          const SizedBox(height: 20.0),

          // User Name Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: appProvider.getUserInformation.name,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),

          // Update Button
          SizedBox(
            height: 60,
            width: screenWidth * 0.8, // 80% of screen width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                elevation: 2,
              ),
              onPressed: () async {
                UserModel userModel = appProvider.getUserInformation
                    .copyWith(name: textEditingController.text);
                appProvider.updateUserInfor(context, userModel, image);
              },
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Additional Padding for visual spacing
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
