import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeDetail extends StatefulWidget {
  final String? uid;

  const EmployeeDetail({Key? key, this.uid}) : super(key: key);

  @override
  _EmployeeDetailState createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Map? data;
  List finalList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParticularEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(
              left: 10, top: MediaQuery.of(context).padding.top + 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: finalList.length,
                  itemBuilder: (context, index) {
                    List lotList = finalList[index]['calculation'];
                    return Container(
                        color: index % 2 == 0 ? Colors.grey.shade300 : null,
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
                              padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: lotList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${index+1}",style: TextStyle(fontWeight: FontWeight.w500),),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text("diamond : "),
                                                Text(lotList[index]['diamond'].toString())
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("price : "),
                                                Text(lotList[index]['price'].toString(),)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("weight : "),
                                                Text(lotList[index]['weight'].toString())
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
                  })
            ],
          ),
        ),
      ),
    );
  }

  void getParticularEmployeeData() async {
    print(widget.uid);
    CollectionReference collectionReference = fireStore
        .collection('Employee')
        .doc(widget.uid)
        .collection('30-04-2022');
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.map((e) {
      data = e.data() as Map<String, dynamic>;
      setState(() {
        finalList.add(data);
      });
    }).toList();
    List mm=finalList[0]['calculation'];
    print(mm);
    print(mm[0]['diamond']);
  }
}
