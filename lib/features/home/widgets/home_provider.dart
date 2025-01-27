import 'dart:io';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  // User's selected profile image
  File? _userImage;
  File? get userImage => _userImage;

  // Selected health condition
  String? _selectedHealthCondition;
  String? get selectedHealthCondition => _selectedHealthCondition;

  // User's name, if needed to be managed here
  String _userName = '';
  String get userName => _userName;

  // Method to update user image
  void setUserImage(File image) {
    _userImage = image;
    notifyListeners();
  }

  // Method to update user name
  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // Method to set selected health condition
  void setHealthCondition(String condition) {
    _selectedHealthCondition = condition;
    notifyListeners();
  }

  // Optional: method to reset user profile data
  void clearData() {
    _userImage = null;
    _userName = '';
    _selectedHealthCondition = null;
    notifyListeners();
  }
}



// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// class HomeProvider with ChangeNotifier {
//   // String _userName = "";
//   // String get userName => _userName;
//
//   File? _userImage;
//   File? get userImage => _userImage;
//
//   String? _selectedHealthCondition;
//   String? get selectedHealthCondition => _selectedHealthCondition;
//
//   void setUserImage(File image) {
//     _userImage = image;
//     notifyListeners();
//   }
//
//   void setHealthCondition(String condition) {
//     _selectedHealthCondition = condition;
//     notifyListeners();
//   }
// }
