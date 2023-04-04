import 'package:flutter/cupertino.dart';

class Model with ChangeNotifier {
  int _costtotal = 0;

  int get costtotal => _costtotal;

  set costtotal(int costtotal) {
    _costtotal = costtotal;
    //notifyListeners();
  }

  int _num1 = 0;

  int get num1 => _num1;

  set num1(int num1) {
    _num1 = num1;
    notifyListeners();
  }

  int _num2 = 0;

  int get num2 => _num2;

  set num2(int num2) {
    _num2 = num2;
    notifyListeners();
  }

  String _indexOrder = '';

  String get indexOrder => _indexOrder;

  set indexOrder(String indexOrder) {
    _indexOrder = indexOrder;
    notifyListeners();
  }
}
