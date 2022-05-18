import 'package:diamond_office/Diamond/Constant/textfield_constant.dart';
import 'package:diamond_office/Diamond/owner/owner_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../employee/emp_home.dart';
import 'owner_emp_signup.dart';

class OwnerEmpLogIN extends StatefulWidget {
  final String? logInName;

  const OwnerEmpLogIN({Key? key, this.logInName}) : super(key: key);

  @override
  _OwnerEmpLogINState createState() => _OwnerEmpLogINState();
}

class _OwnerEmpLogINState extends State<OwnerEmpLogIN> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  logInController controller = Get.put(logInController());
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.logInName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top +
                    MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 25, letterSpacing: 2),
              ),
              SizedBox(
                height: 30,
              ),
              TextFieldConst.textFields(
                  "Email", emailController, TextInputType.emailAddress),
              SizedBox(
                height: 10,
              ),
              TextFieldConst.textFields(
                  "Password", passController, TextInputType.visiblePassword),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => InkWell(
                    onTap: () {
                      print(firebaseAuth.currentUser?.uid);
                      controller.isLogINLoding.value = true;
                      signIn();
                    },
                    child: controller.isLogINLoding.value == false
                        ? TextFieldConst.submitButton()
                        : CircularProgressIndicator()),
              ),
              Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom+10))
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passController.text.trim());
      print(userCredential.user?.uid);
      controller.isLogINLoding.value = false;
      widget.logInName == "Employee"
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => EmpHome()),
              (route) => false)
          : Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => OwnerHome()),
              (route) => false);
    } on FirebaseAuthException catch (e) {
      controller.isLogINLoding.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', "No User Found for this email , Please SignUp",
            backgroundColor: Colors.black, colorText: Colors.white);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', "Password is wrong",
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    }
  }
}
