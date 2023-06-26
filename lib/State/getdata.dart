// import 'dart:core';
// import 'dart:core';
//
// import 'package:flutter/material.dart';
//
// import '../dbhelper.dart';
//
// class getData extends ChangeNotifier{
//
//   var DatakaMap = [];
//   final dbHelper = DatabaseHelper.instance;
//
//   Future<List> get getdata async {
//     DatakaMap= await dbHelper.queryAllRows();
//     // print('query all rows:');
//     //DatakaMap.forEach(print);
//     return DatakaMap;
//   }
//
// }
//
// class setData_ extends ChangeNotifier {
//   String fanName = "";
//   int fanID = 0;
//   int fanCount = 0;
//   double diaMeter = 0.0;
//   int rpM = 0;
//   double maxFlow = 0.0;
//   String orientation = "";
//
//   var allRows = [];
//   final dbHelper = DatabaseHelper.instance;
//
//
//   void updateData(int _id1,int state1) async {
//
//     print(_id1);
//
//     print(state1.toString());
//
//     Map<String, dynamic> row = {
//       DatabaseHelper.columnId   : _id1,
//       //DatabaseHelper.columnState  : state1
//     };
//     final rowsAffected = await dbHelper.update(row);
//     print('updated $rowsAffected row(s)');
//     notifyListeners();
//   }
//
//   void insertData(int fanid, String _fanName,int _fancount, double diameter,int RPM,double maxflow, String orienTation) async {
//     fanID = fanid;
//     fanName = _fanName;
//     fanCount = _fancount;
//     diaMeter = diameter;
//     rpM = RPM;
//     maxFlow = maxflow;
//     orientation = orienTation;
//
//     Map<String, dynamic> row = {
//       DatabaseHelper.columnId : fanID,
//       DatabaseHelper.columnName : fanName,
//       DatabaseHelper.columnfanNum : fanCount,
//       DatabaseHelper.columnDiameter : diaMeter,
//       DatabaseHelper.columnRPM : rpM,
//       DatabaseHelper.columnMaxFlow : maxFlow,
//       DatabaseHelper.columnOrientation : orientation
//     };
//     final id = await dbHelper.insert(row);
//     print('inserted row id: $id');
//     notifyListeners();
//   }
//
// }
