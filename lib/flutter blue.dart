import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'State/getdata.dart';
import 'service.dart';

class BluetoothSetupPage extends StatefulWidget {
  @override
  _BluetoothSetupPageState createState() => _BluetoothSetupPageState();
}

class _BluetoothSetupPageState extends State<BluetoothSetupPage> {

  BluetoothProvider bluetoothProvider = BluetoothProvider();
  FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  BluetoothDevice? arduinoDevice;
  StreamSubscription<BluetoothDevice>? deviceConnection;

  late BluetoothConnection connection;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  TextEditingController _sendController = TextEditingController();
  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  var _allRows = [];
  Color _colorrgreen = Colors.black38;
  Color bulbColor = Colors.white10;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    getPairedDevices();
    new Future.delayed(new Duration(seconds: 3));
    //_getDeviceItems();
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    super.dispose();
  }
  void _disconnect() async {
    await flutterBluetoothSerial
        .removeDeviceBondWithAddress(arduinoDevice!.address);
    print('Device disconnected');
    await new Future.delayed(new Duration(seconds: 2));
  }

  Future<void> _requestLocationPermission() async {
    // if (status.isGranted) {
      print("permision granted");
      setState(() {});
    // } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Container(
          child: AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please grant location permission to use this feature.'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  Navigator.of(context).pop();

                },
              ),
            ],
          ),
        ),
      );
    // }
  }

  void _sendOnMessageToBluetooth(Uint8List data) async {
    connection.output.add(data);
    print('Device Turned On');
    // setState(() {
    // _deviceState = 1; // device on
    // });
  }

  void connectToArduino() async {
    try {
      connection = await BluetoothConnection.toAddress(_device!.address);
      print('Connected to the device of address: ' + _device!.address);
      Get.put(connection);
      Get.back();
      Provider.of<BluetoothProvider>(context, listen: false).setstateble(true);
      Get.find<BluetoothController>().setConnected(true);
      setState(() {
        _connected = true;
        _isButtonUnavailable = false;
      });
    } catch (error) {
      print('Cannot connect, exception occurred');
      print(error);
    }
  }


  Future<void> getDataFunc() async {
    // Future<List<dynamic>> allRows =  Provider.of<getData>(context, listen: false).getdata;
    // _allRows = await  allRows;
    setState(() {});
    // print(_allRows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<BluetoothProvider>(
          builder: (context, isBluetoothConnected, _) {
            if (isBluetoothConnected.isBluetoothConnected) {
              return Container(child: Center(child: Text("Connected"),),);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.teal),
                  const SizedBox(height: 12),
                  IconButton(
                      onPressed: () {  },
                      icon: Icon(Icons.bluetooth_audio, size: 45, color: Colors.teal)),

                  FutureBuilder<List<DropdownMenuItem<BluetoothDevice>>>(
                    future: getPairedDeviceItems(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return DropdownButton<BluetoothDevice>(
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                          items: snapshot.data!,
                          onChanged: (value) => setState(() => _device = value),
                          value: _devicesList.isNotEmpty ? _device : null,
                        );
                      } else {
                        return DropdownButton<BluetoothDevice>(
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                          items: [DropdownMenuItem(child: Text("Loading..."))],
                          onChanged: null,
                        );
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: connectToArduino,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        child: Text("Connect"),
                      ),
                      // Spacer(flex: 5),
                      // ElevatedButton(
                      //   onPressed: connectToArduino,
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.teal),
                      //   child: Text("Disconnect"),
                      // ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  /// Returns a list of dropdown menu items representing Bluetooth devices.

  Future<List<DropdownMenuItem<BluetoothDevice>>> getPairedDeviceItems() async {
    final List<BluetoothDevice> devices = await flutterBluetoothSerial.getBondedDevices();

    final List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('No device available',
            style: TextStyle(color: Colors.blue)),
      ));
    } else {
      devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? 'Unknown', style: TextStyle(color: Colors.teal)),
          value: device,
        ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    final List<DropdownMenuItem<BluetoothDevice>> items = [];

    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('No device available', style: TextStyle(color: Colors.blue)),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? 'Unknown', style: TextStyle(color: Colors.teal)),
          value: device,
        ));
      });
    }

    return items;
  }


  /// Retrieves the list of paired Bluetooth devices and stores it in [_devicesList].
  Future<void> getPairedDevices() async {
    try {
      final List<BluetoothDevice> devices = await flutterBluetoothSerial.getBondedDevices();

      debugPrint('Paired devices: ${devices}');

      setState(() {
        _devicesList = devices;
      });
    } on PlatformException catch (e) {
      debugPrint('Error getting paired devices: ${e.message}');
    }
  }
}

class BluetoothController extends GetxController {
  var isConnected = false.obs;

  void setConnected(bool status) {
    isConnected.value = status;
  }
}

// class FanDataList extends StatefulWidget {
//   @override
//   _FanDataListState createState() => _FanDataListState();
// }
//
// class _FanDataListState extends State<FanDataList> {
//   DatabaseHelper db = DatabaseHelper();
//   List<FanData> fanDataList;
//
//   @override
//   void initState() {
//     super.initState();
//     getFanData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fan Data List'),
//       ),
//       body: fanDataList == null
//           ? Center(child: Text('No Data Found'))
//           : ListView.builder(
//         itemCount: fanDataList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             leading: Icon(Icons.fast_forward),
//             title: Text(fanDataList[index].fanName),
//             subtitle: Text('ID: ${fanDataList[index].fanID}'),
//             trailing: Text(fanDataList[index].orientation),
//           );
//         },
//       ),
//     );
//   }
//
//   void getFanData() async {
//     List<Map<String, dynamic>> fanDataMap = await db.getFanDataMapList();
//     fanDataList = <FanData>[];
//     for (int i = 0; i < fanDataMap.length; i++) {
//       fanDataList.add(FanData.fromMapObject(fanDataMap[i]));
//     }
//     setState(() {});
//   }
// }
