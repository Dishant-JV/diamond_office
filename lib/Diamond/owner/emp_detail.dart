import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamond_office/Diamond/Constant/const.dart';
import 'package:diamond_office/Diamond/owner/calculate_salary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeDetail extends StatefulWidget {
  final String? uid;

  const EmployeeDetail({Key? key, this.uid}) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  Map data = {};
  List finalDisplayFinalList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getParticularEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: 10,
                top: MediaQuery.of(context).padding.top + 20,
                right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    ElevatedButton(onPressed: (){
                      UtilsConst.pushMethod(context, CalculateSalary(uid: widget.uid,));
                    }, child: Text("Calculate salary"))
                  ],
                ),
                SizedBox(
                  height: 20,
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
                        finalDisplayFinalList.clear();
                        snapshot.data?.docs.map((DocumentSnapshot document) {
                          Map a = document.data() as Map<String, dynamic>;
                          finalDisplayFinalList.add(a);
                        }).toList();
                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: finalDisplayFinalList.length,
                            itemBuilder: (context, index) {
                              List lotList =
                                  finalDisplayFinalList[index]['calculation'];
                              return Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 15),
                                  color: index % 2 == 0
                                      ? Colors.grey.shade300
                                      : null,
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        finalDisplayFinalList[index]['dateTime'],
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("Total Lot : "),
                                          Text(
                                            finalDisplayFinalList[index]
                                                    ['totalLot']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("Total Diamond : "),
                                          Text(
                                            finalDisplayFinalList[index]
                                                    ['totalDiamond']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("Total Weight : "),
                                          Text(
                                            finalDisplayFinalList[index]
                                                    ['totalWeight']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text("Total Earning : "),
                                          Text(
                                            finalDisplayFinalList[index]
                                                    ['totalEarning']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: lotList.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${index + 1}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text("diamond : "),
                                                          Text(lotList[index]
                                                                  ['diamond']
                                                              .toString())
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("price : "),
                                                          Text(
                                                            lotList[index]
                                                                    ['price']
                                                                .toString(),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text("weight : "),
                                                          Text(lotList[index]
                                                                  ['weight']
                                                              .toString())
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          })
                                    ],
                                  ));
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
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

// void getParticularEmployeeData() async {
//   print(widget.uid);
//   CollectionReference collectionReference = fireStore
//       .collection('Employee')
//       .doc(widget.uid)
//       .collection('30-04-2022');
//   QuerySnapshot querySnapshot = await collectionReference.get();
//   querySnapshot.docs.map((e) {
//     data = e.data() as Map<String, dynamic>;
//     setState(() {
//       finalList.add(data);
//     });
//   }).toList();
//   List mm=finalList[0]['calculation'];
//   print(mm);
//   print(mm[0]['diamond']);
// }
}
