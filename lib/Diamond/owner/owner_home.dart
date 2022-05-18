import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:diamond_office/Diamond/LogIN/login_1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'emp_detail.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({Key? key}) : super(key: key);

  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? businessId;
  List finaEmplList = [];
  bool isLoad = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your business id",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LogIN1()),
                        (route) => false);
                  });
                },
                child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            FirebaseAuth.instance.currentUser!.uid,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            "Your employees",
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w500, color: Colors.blue),
          )),
          SizedBox(
            height: 20,
          ),
          isLoad == true
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Employee')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data?.size != 0) {
                     getBusinessId().then((value) {
                       finaEmplList.clear();
                       snapshot.data?.docs.map((DocumentSnapshot document) {
                         Map a = document.data() as Map<String, dynamic>;
                         if(a['businessId'].toString() == value){
                           finaEmplList.add(a);
                         }
                       }).toList();
                     });

                      return ListView.builder(
                          itemCount: finaEmplList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EmployeeDetail(
                                              uid: finaEmplList[index]['uid'],
                                            )));
                              },
                              child: Container(
                                  color: index % 2 == 0
                                      ? Colors.grey.shade300
                                      : null,
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    finaEmplList[index]['name'],
                                    style: TextStyle(fontSize: 22),
                                  )),
                            );
                          });
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
        ],
      ),
    ));
  }

  Future getBusinessId() async {
    // setState(() {
    //   isLoad = true;
    // });
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // businessId = preferences.getString("businessId");
    return FirebaseAuth.instance.currentUser!.uid;
  }

// void getEmployeeData(String businessGetId) async {
//   finalList.clear();
//   print(businessGetId);
//   CollectionReference collectionReference = fireStore.collection("Employee");
//   QuerySnapshot querySnapshot = await collectionReference.get();
//   querySnapshot.docs.map((e) {
//     print(e.data());
//     Map data = e.data() as Map<String, dynamic>;
//     if (data['businessId'] == businessGetId) {
//       finalList.add(data);
//     }
//   }).toList();
//   setState(() {
//     isLoad = false;
//   });
// }

// Future<Null> _selectDate(BuildContext context) async {
//   var myFormat = DateFormat('d-MM-yyyy');
//   DateTime selectedDate = DateTime.now();
//   final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       initialDatePickerMode: DatePickerMode.day,
//       firstDate: DateTime(2015),
//       lastDate: DateTime(2101));
//   if (picked != null)
//     setState(() {
//       selectedDate = picked;
//       print(myFormat.format(picked));
//     });
// }
}
