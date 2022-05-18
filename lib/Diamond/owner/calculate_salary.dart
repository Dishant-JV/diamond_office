

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:diamond_office/Diamond/getx_class/refresh_emplist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class CalculateSalary extends StatefulWidget {
  final String? uid;

  const CalculateSalary({Key? key, this.uid}) : super(key: key);

  @override
  State<CalculateSalary> createState() => _CalculateSalaryState();
}

class _CalculateSalaryState extends State<CalculateSalary> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.uid);
    // getParticularEmployeeData();
  }

  String toDate = "";
  String fromDate = "";
  List finalDisplayFinalList = [];

  double? salary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        String dd = await pickedDate();
                        setState(() {
                          fromDate = dd;
                        });
                      },
                      child: Text("From")),
                  ElevatedButton(
                      onPressed: () async {
                        String dd = await pickedDate();
                        setState(() {
                          toDate = dd;
                        });
                      },
                      child: Text("To")),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(fromDate), Text(toDate)],
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(onPressed: () {}, child: Text("Calculate")),
              SizedBox(
                height: 50,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Employee')
                      .doc(widget.uid)
                      .collection('EmpData')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.size != 0) {
                      salary=0.0;
                      finalDisplayFinalList.clear();
                      snapshot.data?.docs.map((DocumentSnapshot document) {
                        Map a = document.data() as Map<String, dynamic>;
                        finalDisplayFinalList.add(a);
                      }).toList();
                      print(finalDisplayFinalList.length);
                      for (int i = 0; i < finalDisplayFinalList.length; i++) {
                        print(finalDisplayFinalList[i]['totalEarning'].toString());
                        salary = (salary?? 0) + (finalDisplayFinalList[i]['totalEarning']);
                      }
                      print(salary);


                      return Text(salary.toString());
                    }
                    return Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "No Data",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.grey.shade400),
                          ),
                        ));
                  })

              // Row(
              //   children: [
              //     Text("Your Salary is :  "),
              //     Text(salary ??"",style: TextStyle(fontWeight: FontWeight.w500),);
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> pickedDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    return DateFormat('d-MM-yyyy').format(picked!);
  }
}
