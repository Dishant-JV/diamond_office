import 'package:diamond_office/Diamond/Constant/const.dart';
import 'package:diamond_office/Diamond/LogIN/owner_emp_signup.dart';
import 'package:diamond_office/Diamond/emp_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogIN1 extends StatelessWidget {
  const LogIN1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade400,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  UtilsConst.pushMethod(
                      context,
                      OwnerEmpSignUp(
                        LogInName: "Owner",
                      ));
                },
                child: _button("Owner")),
            SizedBox(
              height: 18,
            ),
            InkWell(
                onTap: () {
                  UtilsConst.pushMethod(
                      context,
                      OwnerEmpSignUp(
                        LogInName: "Employee",
                      ));
                },
                child: _button("Employee"))
          ],
        ),
      ),
    );
  }

  Widget _button(String text) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple.shade200,
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 22),
      ),
    );
  }
}
