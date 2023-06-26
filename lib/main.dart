import 'dart:typed_data';

import 'package:dconfig/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'flutter blue.dart';
import 'getxtest.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:fancontroller/dbhelper.dart';
import 'package:provider/provider.dart';
import 'State/getdata.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CounterController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: MyApp(),
    ),
  );
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BluetoothConnection connection;

  TextEditingController _sendController = TextEditingController();
  String _status = "Disconnected";

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    // Connect to the ESP32
    connection = await BluetoothConnection.toAddress("ESP32_BT_ADDRESS");
    setState(() {
      _status = "Connected";
    });

    // Listen for incoming data

  }


  void sendData() {
    // Send data to the ESP32
    connection.output.add(_sendController.text as Uint8List);
    _sendController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Test"),
      ),
      body: Column(
        children: <Widget>[
          Text("Status: $_status"),
          TextField(
            controller: _sendController,
            decoration: InputDecoration(labelText: "Send data"),
          ),
          ElevatedButton(
            child: Text("Send"),
            onPressed: sendData,
          ),
        ],
      ),
    );
  }
}





class  MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context)=>getData()),
        // ListenableProvider(create: (context)=>setData_()),
        ChangeNotifierProvider(create: (_) => BluetoothProvider()),
      ],
      child: GetMaterialApp(

        initialRoute: '/',
        routes: {
      //    '/': (context) => BluetoothSetupPage(),
          '/': (context) => BluetoothSetupPage(),
      //  '/': (context) => getxtest(),
      //     '/setupPage': (context) => SetupPage(),
      //     '/selectMode': (context) => ModesPage(),
      //     '/manualmode': (context) => ManualModeScreen(),
      //     '/automaticmode': (context) => AutomaticScreen(),
      //     '/nodustmode': (context) => noDustMode(),
      //     '/home': (context) => SomePage(),
      //     '/monitor': (context) => MonitorScreen(),

        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: BluetoothApp(),
      ),
    );
  }
}

class MyApp1 extends StatefulWidget {
  @override
  _MyApp1State createState() => _MyApp1State();
}

class _MyApp1State extends State<MyApp1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
            height: 900,
            //color: Colors.white,
            child: Image.asset("assets/bkd.png",
              fit: BoxFit.fitHeight,
            )

        ),
      ),
    );
  }
}

