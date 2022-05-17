import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamond_office/Diamond/Constant/const.dart';
import 'package:diamond_office/Diamond/employee/whole_record.dart';
import 'package:diamond_office/Diamond/getx_class/refresh_emplist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:uuid/uuid.dart';

import '../LogIN/login_1.dart';
import '../lot_model.dart';

class EmpHome extends StatefulWidget {
  const EmpHome({Key? key}) : super(key: key);

  @override
  _EmpHomeState createState() => _EmpHomeState();
}

class _EmpHomeState extends State<EmpHome> {
  RefreshEmpList refreshEmpList = Get.put(RefreshEmpList());
  Map? data;
  // List finalList = [];

  bool isUpload = false;
  int totalNumberOfLot = 1;
  int totalDiamond = 0;
  double totalWeight = 0;
  double totalEarning = 0;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  LotModel lotModel = LotModel();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  List<LotModel> lstLot = [];
  List finalLotList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstLot.add(LotModel());
    getParticularEmployeeData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _refresh() async {
    refreshEmpList.finalList.clear();
    await Future.delayed(Duration(milliseconds: 1000));
    getParticularEmployeeData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: _refresh,
      controller: _refreshController,
      child: Scaffold(
          floatingActionButton: InkWell(
            onTap: () {
              UtilsConst.pushMethod(context, WholeEmpRecord());
            },
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              height: 50,
              width: 50,
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 10,
                  right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            lstLot.add(LotModel());
                            totalNumberOfLot = lstLot.length;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              size: 30,
                            )),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogIN1()),
                                  (route) => false);
                            });
                          },
                          child: Text("Logout"))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        "Total number of lot : ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      Text(totalNumberOfLot.toString(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: globalKey,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lstLot.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      diamondUI(index),
                                      priceUI(index),
                                      weightUI(index),
                                    ],
                                  ),
                                ),
                                index == 0
                                    ? SizedBox(
                                        width: 20,
                                      )
                                    : SizedBox(
                                        width: 20,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              lstLot.removeAt(index);
                                              totalNumberOfLot = lstLot.length;
                                            });
                                          },
                                          child: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      finalLotList.clear();
                      totalDiamond = 0;
                      totalWeight = 0;
                      totalEarning = 0;
                      final form = globalKey.currentState;
                      if (globalKey.currentState?.validate() == true) {
                        form?.save();
                        lstLot.forEach((element) {
                          finalLotList.add(element.toJson());
                          totalEarning = totalEarning +
                              (element.diamond! * element.price!.toDouble());
                          totalDiamond =
                              totalDiamond + element.diamond!.toInt();
                          totalWeight =
                              totalWeight + element.weight!.toDouble();
                        });
                        print(finalLotList);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return Dialog(
                                  child: Container(
                                    height: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, top: 15, bottom: 10),
                                          child: Text(
                                            "Please Note",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Total diamond : ",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(totalDiamond.toString(),
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total weight : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(totalWeight.toString(),
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total earning : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  Text(totalEarning.toString(),
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel")),
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: isUpload == true
                                                          ? CircularProgressIndicator()
                                                          : InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  print(
                                                                      isUpload);
                                                                  isUpload =
                                                                      true;
                                                                });
                                                                saveData();
                                                                final form =
                                                                    globalKey
                                                                        .currentState;
                                                                form?.reset();
                                                                setState(() {
                                                                  lstLot
                                                                      .clear();
                                                                  totalNumberOfLot =
                                                                      1;
                                                                });
                                                                lstLot.add(
                                                                    LotModel());
                                                              },
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .blue),
                                                                height: 40,
                                                                width: 60,
                                                                child:
                                                                    Text("Ok"),
                                                              ),
                                                            )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue),
                      child: Text(
                        "submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Obx(() => ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: refreshEmpList.finalList.length,
                      itemBuilder: (context, index) {
                        List lotList =
                            refreshEmpList.finalList[index]['calculation'];
                        return Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            color: index % 2 == 0 ? Colors.grey.shade300 : null,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  refreshEmpList.finalList[index]['dateTime'],
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Total Lot : "),
                                    Text(
                                      refreshEmpList.finalList[index]
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
                                      refreshEmpList.finalList[index]
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
                                      refreshEmpList.finalList[index]
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
                                      refreshEmpList.finalList[index]
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
                                                  fontWeight: FontWeight.w500),
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
                                                    Text(lotList[index]
                                                            ['diamond']
                                                        .toString())
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("price : "),
                                                    Text(
                                                      lotList[index]['price']
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
                      }))
                ],
              ),
            ),
          )),
    );
  }

  void getParticularEmployeeData() async {
    refreshEmpList.finalList.clear();
    var myFormat = DateFormat('d-MM-yyyy');
    String datetime = myFormat.format(DateTime.now());
    DocumentReference collectionReference = fireStore
        .collection('Employee')
        .doc(firebaseAuth.currentUser?.uid)
        .collection('EmpData')
        .doc(datetime);
    DocumentSnapshot documentSnapshot = await collectionReference.get();
    data = documentSnapshot.data() as Map<String, dynamic>;
    refreshEmpList.finalList.add(data);
  }

  Widget diamondUI(int index) {
    return Container(
      height: 50,
      width: 100,
      child: FormHelper.inputFieldWidget(context, "", "diamond", (onValidate) {
        if (onValidate.toString().isEmpty) {
          return "diamond ${index + 1} can't be empty";
        }
      }, (onSaved) {
        lstLot[index].diamond = int.parse(onSaved);
      },
          hintColor: Colors.grey.shade400.withOpacity(0.7),
          borderColor: Colors.grey.shade500,
          borderFocusColor: Colors.grey.shade600,
          borderRadius: 2,
          fontSize: 15,
          isNumeric: true,
          paddingLeft: 0,
          paddingRight: 0,
          paddingTop: 0,
          paddingBottom: 0),
    );
  }

  Widget priceUI(int index) {
    return Container(
      height: 50,
      width: 100,
      child: FormHelper.inputFieldWidget(
        context,
        "",
        "price",
        (onValidate) {
          if (onValidate.toString().isEmpty) {
            return "price ${index + 1} can't be empty";
          }
        },
        (onSaved) {
          lstLot[index].price = double.parse(onSaved);
        },
        hintColor: Colors.grey.shade400.withOpacity(0.7),
        borderColor: Colors.grey.shade500,
        borderFocusColor: Colors.grey.shade600,
        borderRadius: 2,
        fontSize: 15,
        isNumeric: true,
        paddingLeft: 0,
        paddingRight: 0,
        paddingTop: 0,
        paddingBottom: 0,
      ),
    );
  }

  Widget weightUI(int index) {
    return Container(
      height: 50,
      width: 100,
      child: FormHelper.inputFieldWidget(context, "", "weight", (onValidate) {
        if (onValidate.toString().isEmpty) {
          return "weight ${index + 1} can't be empty";
        }
      }, (onSaved) {
        lstLot[index].weight = double.parse(onSaved);
      },
          hintColor: Colors.grey.shade400.withOpacity(0.7),
          borderColor: Colors.grey.shade500,
          borderFocusColor: Colors.grey.shade600,
          borderRadius: 2,
          fontSize: 15,
          isNumeric: true,
          paddingLeft: 0,
          paddingRight: 0,
          paddingTop: 0,
          paddingBottom: 0),
    );
  }

  saveData() async {
    var userId = firebaseAuth.currentUser?.uid;
    var myFormat = DateFormat('d-MM-yyyy');
    String datetime = myFormat.format(DateTime.now());

    DocumentReference documentReference = fireStore
        .collection("Employee")
        .doc(userId)
        .collection("EmpData")
        .doc(datetime);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (!documentSnapshot.exists) {
      print("save data");
      try {
        await fireStore
            .collection('Employee')
            .doc(userId)
            .collection("EmpData")
            .doc(datetime)
            .set({
          "calculation": finalLotList,
          "totalLot": totalNumberOfLot,
          "totalDiamond": totalDiamond,
          "totalWeight": totalWeight,
          "totalEarning": totalEarning,
          "calculationId": userId,
          "dateTime": datetime,
        }).whenComplete(() {
          setState(() {
            print(isUpload);
            isUpload = false;
            print("data Uploaded");
            Navigator.pop(context);
          });
        }).onError((error, stackTrace) async {
          await FirebaseFirestore.instance.clearPersistence();
          print("ERROR OCCURED");
        });
      } on FirebaseAuthException catch (e) {
        print("error occured $e");
      }
    } else {
      List preCalculation = [];
      double preTotalWeight = 0.0;
      int preTotalLot = 0;
      int preTotalDiamond = 0;
      double preTotalEarning = 0;
      print("Already Exists");
      DocumentReference documentReference = fireStore
          .collection("Employee")
          .doc(userId)
          .collection("EmpData")
          .doc(datetime);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      print(documentSnapshot.data());
      Map data = documentSnapshot.data() as Map<String, dynamic>;
      preCalculation = data['calculation'];
      preTotalWeight = data['totalWeight'];
      preTotalLot = data['totalLot'];
      preTotalDiamond = data['totalDiamond'];
      preTotalEarning = data['totalEarning'];
      preCalculation.addAll(finalLotList);
      preTotalWeight = preTotalWeight + totalWeight;
      preTotalLot = preTotalLot + totalNumberOfLot;
      preTotalDiamond = preTotalDiamond + totalDiamond;
      preTotalEarning = preTotalEarning + totalEarning;
      await fireStore
          .collection('Employee')
          .doc(userId)
          .collection("EmpData")
          .doc(datetime)
          .update({
        "calculation": preCalculation,
        "totalLot": preTotalLot,
        "totalDiamond": preTotalDiamond,
        "totalWeight": preTotalWeight,
        "totalEarning": preTotalEarning,
      }).whenComplete(() {
        setState(() {
          isUpload = false;
        });
        print("Updated");
        Navigator.pop(context);
      });
    }
  }
}
