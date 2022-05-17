import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'owner_home.dart';

class OwnerLogIN extends StatefulWidget {
  const OwnerLogIN({Key? key}) : super(key: key);

  @override
  _OwnerLogINState createState() => _OwnerLogINState();
}

class _OwnerLogINState extends State<OwnerLogIN> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  submitData(String name, String email, String number, String password) async {
    try {
      _btnController.start();
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      firestore.collection('Owner').doc(_auth.currentUser?.uid).set({
        'name': name,
        'number': number,
        'email': email.trim(),
        'uid': authResult.user?.uid
      }).then((value) {
        _btnController.success();
        setBusinessId();
      }).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerHome()));
      });
    } catch (e) {
      _btnController.error();
      _btnController.reset();
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            "OWNER",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
          ),
          SizedBox(
            height: 30,
          ),
          textField("Name", nameController, TextInputType.name),
          textField("Number", numberController, TextInputType.number),
          textField("Email", emailController, TextInputType.emailAddress),
          textField("Password", passwordController, TextInputType.text),
          RoundedLoadingButton(
              width: 350,
              borderRadius: 5,
              controller: _btnController,
              onPressed: () {
                submitData(nameController.text, emailController.text,
                    numberController.text, passwordController.text);
              },
              child: Text("SignUp"))
        ],
      ),
    );
  }

  Widget textField(
      String hint, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        keyboardType: inputType,
        controller: controller,
        decoration:
            InputDecoration(helperText: hint, border: OutlineInputBorder()),
      ),
    );
  }

   setBusinessId() async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setString("businessId", _auth.currentUser!.uid);
   }
}
