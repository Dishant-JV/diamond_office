import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diamond_office/Diamond/lot_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RefreshEmpList extends GetxController {
  RxList finalList = [].obs;
  RxList lstLot=[].obs;
  RxBool isLoad = false.obs;
}
