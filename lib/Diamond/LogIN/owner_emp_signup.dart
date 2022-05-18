import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamond_office/Diamond/Constant/const.dart';
import 'package:diamond_office/Diamond/Constant/textfield_constant.dart';
import 'package:diamond_office/Diamond/LogIN/owner_emp_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../employee/emp_home.dart';
import '../owner/owner_home.dart';

class OwnerEmpSignUp extends StatefulWidget {
  final String? LogInName;

  const OwnerEmpSignUp({Key? key, this.LogInName}) : super(key: key);

  @override
  _OwnerEmpSignUpState createState() => _OwnerEmpSignUpState();
}

class _OwnerEmpSignUpState extends State<OwnerEmpSignUp> {
  final keys = GlobalKey<FormState>();
  logInController controller = Get.put(logInController());

  Future<bool> getData(String id) async {
    var collection = FirebaseFirestore.instance.collection('Owner');
    var docSnapshot = await collection.doc('$id').get();
    if (docSnapshot.exists) {
      return true;
    } else {
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

  submitEmpData(String name, String email, String number, String password,
      String id) async {
    getData(id).then((isValid) async {
      if (isValid == true) {
        try {
          UserCredential authResult =
              await _auth.createUserWithEmailAndPassword(
                  email: email.trim(), password: password);
          firestore.collection('Employee').doc(_auth.currentUser?.uid).set({
            'name': name,
            'number': number,
            'email': email.trim(),
            'uid': authResult.user?.uid,
            'businessId': id
          }).then((value) {
            controller.isLoding.value = false;
            UtilsConst.pushMethod(
                context,
                OwnerEmpLogIN(
                  logInName: widget.LogInName,
                ));
          });
        } on FirebaseAuthException catch (e) {
          controller.isLoding.value = false;
          if (e.code == "email-already-in-use") {
            print("email error");
            Get.snackbar(
                'Error', 'this email is already used by another account',
                backgroundColor: Colors.black, colorText: Colors.white);
          } else {
            Get.snackbar('Error', e.toString(),
                backgroundColor: Colors.black, colorText: Colors.white);
          }
        }
      } else {
        print("please enter valid businessId");
        controller.isLoding.value = false;
        Get.snackbar('Error', 'Enter Valid BusinessId',
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    });
  }

  submitOwnerData(
      String name, String email, String number, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      firestore.collection('Owner').doc(_auth.currentUser?.uid).set({
        'name': name,
        'number': number,
        'email': email.trim(),
        'uid': authResult.user?.uid
      }).then((value) {
        setBusinessId();
      }).then((value) {
        controller.isLoding.value = false;
        UtilsConst.pushMethod(
            context,
            OwnerEmpLogIN(
              logInName: widget.LogInName,
            ));
      });
    } on FirebaseAuthException catch (e) {
      controller.isLoding.value = false;
      if (e.code == "email-already-in-use") {
        print("email error");
        Get.snackbar('Error', 'this email is already used by another account',
            backgroundColor: Colors.black, colorText: Colors.white);
      } else {
        Get.snackbar('Error', e.toString(),
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.LogInName);
    print(_auth.currentUser?.uid);
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
              widget.LogInName == "Employee" ? "Employee" : "Owner",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              key: keys,
              child: Column(
                children: [
                  TextFieldConst.textFields(
                      "Name", nameController, TextInputType.name),
                  TextFieldConst.textFields(
                      "Number", numberController, TextInputType.number),
                  TextFieldConst.textFields(
                      "Email", emailController, TextInputType.emailAddress),
                  TextFieldConst.textFields(
                      "Password", passwordController, TextInputType.text),

                  // textField("Name", nameController, TextInputType.name),
                  // textField("Number", numberController, TextInputType.number),
                  // textField(
                  //     "Email", emailController, TextInputType.emailAddress),
                  // textField("Password", passwordController, TextInputType.text),
                  widget.LogInName == "Employee"
                      ? TextFieldConst.textFields("Enter business Id",
                          businessIdController, TextInputType.text)
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => InkWell(
                        onTap: () {
                          controller.isLoding.value = true;
                          if (keys.currentState!.validate()) {
                            widget.LogInName == "Employee"
                                ? submitEmpData(
                                    nameController.text,
                                    emailController.text,
                                    numberController.text,
                                    passwordController.text,
                                    businessIdController.text)
                                : submitOwnerData(
                                    nameController.text,
                                    emailController.text,
                                    numberController.text,
                                    passwordController.text,
                                  );
                          } else {
                            controller.isLoding.value = false;
                          }
                        },
                        child: controller.isLoding.value == false
                            ? TextFieldConst.submitButton()
                            : CircularProgressIndicator(),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        UtilsConst.pushMethod(context, OwnerEmpLogIN(logInName: widget.LogInName,));
                      },
                      child: Text(
                        "click here to Login",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                  Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom+10))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  setBusinessId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("businessId", _auth.currentUser!.uid);
  }
}

class logInController extends GetxController {
  RxBool isLoding = false.obs;
  RxBool isLogINLoding = false.obs;
}
