import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => (Navigator.of(context).pop()),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(
                255, 0, 0, 0), // Set the background color here

            title: const Text('Profile',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          ),
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    child: const Row(),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
