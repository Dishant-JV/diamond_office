import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldConst {
  static Padding textFields(
      String hint, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) {
          if (value!.isEmpty) {
            return " please fill";
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
          fillColor: Colors.green,
        ),
      ),
    );
  }

  static Widget submitButton() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(8),
      height: 50,
      width: double.infinity,
      child: Text(
        "Submit",
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}
