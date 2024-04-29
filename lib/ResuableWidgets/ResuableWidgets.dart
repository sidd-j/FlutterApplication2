import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

TextField CustomTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, Color ColorPlate,
    {String? errorText, TextInputType inputType = TextInputType.text}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color.fromARGB(255, 255, 251, 251),
      ),
      labelText: text,
      labelStyle: TextStyle(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: ColorPlate,
      errorText: errorText,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: inputType,
  );
}

Container SigninButton(BuildContext context, bool islogin, Function onTap,
    String text, Color ColorField, Color TextColor) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(0, 0, 0, 0);
            }
            return ColorField;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(text,
          style: TextStyle(
              color: TextColor, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}

Widget PhoneNumberField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
  Color ColorPlate,
  void Function(Country?) onCountryChanged,
) {
  return IntlPhoneField(
    controller: controller,
    obscureText: isPasswordType,
    cursorColor: Colors.white,
    disableLengthCheck: true,
    initialCountryCode: 'IN',
    onCountryChanged: onCountryChanged,
    dropdownTextStyle: const TextStyle(color: Colors.white),
    dropdownIcon: const Icon(
      Icons.arrow_drop_down,
      color: Colors.white,
    ),
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: const Color.fromARGB(255, 255, 251, 251),
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: ColorPlate,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: TextInputType.number,
  );
}
