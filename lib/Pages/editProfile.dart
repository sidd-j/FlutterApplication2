import 'package:flutter/material.dart';
import 'package:flutterapiapp/ResuableWidgets/ResuableWidgets.dart';

class EditProfile extends StatelessWidget {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _genderTextController = TextEditingController();

  final Color fieldColor = Color.fromARGB(86, 255, 255, 255);

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _ageTextController.text = picked
          .toString()
          .split(" ")[0]; // Update the text field with the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Set the background color here
        iconTheme: const IconThemeData(
            color: Colors
                .white), // Change the color of the back arrow button to white

        title: const Text('Edit Profile',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Color.fromARGB(149, 6, 6, 6),
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blueAccent,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 200,
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 220,
                    ),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(style: BorderStyle.solid),
                    ),
                    child: CustomTextField(
                      "Enter Full Name",
                      Icons.person_outline,
                      false,
                      _nameTextController,
                      fieldColor, // Change to your desired field color
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                      margin: const EdgeInsets.only(
                        top: 280,
                      ),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(style: BorderStyle.solid),
                      ),
                      child: CustomTextField(
                        "Enter Birthdate",
                        Icons.calendar_month,
                        false, // Change to true if age is a password
                        _ageTextController, // Use a different controller for age
                        fieldColor,
                        onPress: () {
                          _showDatePicker(context);
                        },
                      )),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 340,
                    ),
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(style: BorderStyle.solid),
                    ),
                    child: CustomTextField(
                        "Enter Gender",
                        Icons.person_outline,
                        false, // Change to true if gender is a password
                        _genderTextController, // Use a different controller for gender
                        fieldColor // Change to your desired field color
                        ),
                  ),
                ),
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 400,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      ),
                      child: const Text(
                        'Save changes to profile',
                        style: TextStyle(
                            color: Color.fromARGB(255, 235, 232, 232)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
