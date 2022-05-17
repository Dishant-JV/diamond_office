import 'package:flutter/cupertino.dart';

class LotModel {
  // List<int>? diamond;
  // List<double>? price;
  // List<double>? weight;
  int? diamond;
  double? price;
  double? weight;

  LotModel({this.diamond,this.price,this.weight});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diamond'] = diamond;
    data['price'] = price;
    data['weight'] = weight;
    return data;
  }
}
