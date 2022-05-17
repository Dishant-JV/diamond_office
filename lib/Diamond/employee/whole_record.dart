import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WholeEmpRecord extends StatefulWidget {
  const WholeEmpRecord({Key? key}) : super(key: key);

  @override
  _WholeEmpRecordState createState() => _WholeEmpRecordState();
}

class _WholeEmpRecordState extends State<WholeEmpRecord> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Map? data;
  List finalList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmpOwnWholeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top+10,),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("All Data : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.blue),),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: finalList.length,
              itemBuilder: (context, index) {
                List lotList = finalList[index]['calculation'];
                return Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finalList[index]['dateTime'],
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Total Lot : "),
                            Text(
                              finalList[index]['totalLot'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
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
                              finalList[index]['totalDiamond'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
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
                              finalList[index]['totalWeight'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
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
                              finalList[index]['totalEarning'].toString(),
                              style: TextStyle(fontWeight: FontWeight.w500),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}",
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text("diamond : "),
                                            Text(lotList[index]['diamond']
                                                .toString())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("price : "),
                                            Text(
                                              lotList[index]['price'].toString(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("weight : "),
                                            Text(
                                                lotList[index]['weight'].toString())
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
              }),
        ],
      ),
    );
  }

  void getEmpOwnWholeData() async {
    CollectionReference collectionReference = fireStore
        .collection('Employee')
        .doc(firebaseAuth.currentUser?.uid)
        .collection('EmpData');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.map((e) {
      data = e.data() as Map<String, dynamic>;
      setState(() {
        finalList.add(data);
      });
    }).toList();
  }
}
