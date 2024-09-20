

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastSuccess({required String message}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green.shade400,
      textColor: Colors.white,
      fontSize: 16.0
  );
}