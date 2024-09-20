import 'dart:io';

import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  String _userName = "Cynthia";
  String get userName => _userName;

  File? _userImage;
  File? get userImage => _userImage;

  String? _selectedHealthCondition;
  String? get selectedHealthCondition => _selectedHealthCondition;

  void setUserImage(File image) {
    _userImage = image;
    notifyListeners();
  }

  void setHealthCondition(String condition) {
    _selectedHealthCondition = condition;
    notifyListeners();
  }
}
