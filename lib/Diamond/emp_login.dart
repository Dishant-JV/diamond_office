import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../main.dart';
import 'employee/emp_home.dart';

class EmpLogin extends StatefulWidget {
  const EmpLogin({Key? key}) : super(key: key);

  @override
  _EmpLoginState createState() => _EmpLoginState();
}

class _EmpLoginState extends State<EmpLogin> {
   Future<bool> getData(String id) async {
    var collection = FirebaseFirestore.instance.collection('Owner');
    var docSnapshot = await collection.doc('$id').get();
    if (docSnapshot.exists) {
      return true;
    }else{
      return false;
    }
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController businessIdController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  submitData(String name, String email, String number, String password,String id) async {
    try {
      _btnController.start();
     getData(id).then((isValid) async{
       if(isValid==true){
         UserCredential authResult = await _auth.createUserWithEmailAndPassword(
             email: email.trim(), password: password);
         firestore.collection('Employee').doc(_auth.currentUser?.uid).set({
           'name': name,
           'number': number,
           'email': email.trim(),
           'uid': authResult.user?.uid,
           'businessId': id
         }).then((value) {
           _btnController.success();
         }).then((value) {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const EmpHome()));
         });
       }else{
         print("please enter valid businessId");
         _btnController.reset();
          Get.snackbar('Error','Enter Valid BusinessId',backgroundColor: Colors.black,colorText: Colors.white);
       }
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
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Text(
              "Employee",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            textField("Name", nameController, TextInputType.name),
            textField("Number", numberController, TextInputType.number),
            textField("Email", emailController, TextInputType.emailAddress),
            textField("Password", passwordController, TextInputType.text),
            textField("Enter business Id", businessIdController, TextInputType.text),
            RoundedLoadingButton(
                width: 350,
                borderRadius: 5,
                controller: _btnController,
                onPressed: () {
                  submitData(nameController.text, emailController.text,
                      numberController.text, passwordController.text,businessIdController.text);
                },
                child: Text("SignUp"))
          ],
        ),
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
}
