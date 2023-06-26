import 'package:flutter/material.dart';

class saveData extends ChangeNotifier{
  String butttonName = "Button";
  String butttonId = "1";
  bool butttonState = true;


  void setData(String _buttonName,String _buttonId,bool _buttonState,){
    butttonName =_buttonName;
    butttonId = _buttonId;
    butttonState = _buttonState;
    notifyListeners();
  }

}