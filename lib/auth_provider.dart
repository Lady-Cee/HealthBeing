import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/toast_error.dart';

class MyAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;


//signin method

  Future<void> signIn(String email, String password, bool rememberMe) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();

      // Save user preferences after successful sign-in
      await _savePreferences(rememberMe, email, password);
    } catch (e) {
      // Handle different error codes here if needed
      throw e; // Rethrow the exception to handle it in the UI

    }
  }

// signup method
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      print(e);
      // handle error
    }
  }

  // Future<void> resetPassword(String email) async {
  //   try {
  //     await _auth.sendPasswordResetEmail(email: email);
  //     showToast(message: "Password reset email sent. Please check your inbox.");
  //   } catch (e) {
  //     // Handle different types of errors
  //     if (e is FirebaseAuthException) {
  //       if (e.code == 'invalid-email') {
  //         showToast(message: "Invalid email address." );
  //       } else if (e.code == 'user-not-found') {
  //         showToast(message: "No user found for that email.");
  //       }
  //     } else {
  //       showToast(message: "Something went wrong. Please try again.");
  //     }
  //   }
  // }



    //signout
    Future<void> signOut() async {
      await _auth.signOut();
      _user = null;
      notifyListeners();

      // Clear preferences on sign out
      await _clearPreferences();
    }

    // Save user preferences
    Future<void> _savePreferences(bool rememberMe, String email,
        String password) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', rememberMe);
      if (rememberMe) {
        prefs.setString('email', email);
        prefs.setString('password', password);
      } else {
        prefs.remove('email');
        prefs.remove('password');
      }
    }

    // Clear user preferences
    Future<void> _clearPreferences() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('rememberMe');
      prefs.remove('email');
      prefs.remove('password');
    }
  }
