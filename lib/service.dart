import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'flutter blue.dart';
import 'main.dart';

class BluetoothProvider with ChangeNotifier {
  late BluetoothConnection _connection;

  BluetoothConnection get connection => _connection;

  bool _isBluetoothConnected = false;

  bool get isBluetoothConnected => _isBluetoothConnected;


  void connectBluetooth(String address) async {
    // connect to Bluetooth device
     await BluetoothConnection.toAddress(address)
        .then((_connection) {
      print('Connected to the device of adress : ' + address);
      _isBluetoothConnected = true;
      //Provider.of<BluetoothProvider>(context, listen: false).setstateble(true);
    }).catchError((error) {
      print(error);
    });
    print('connected');
    notifyListeners();
  }
  void setstateble(bool value) {
    _isBluetoothConnected = value;
    notifyListeners();
  }

  void navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }
}



