import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../global/toast_error.dart';
import '../../../global/toast_success.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reset password method
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim(); // Get the email input

    if (email.isNotEmpty) {
      try {
        // Send password reset email using Firebase Auth
        await _auth.sendPasswordResetEmail(email: email);
        toastSuccess(message: "Password reset email sent. Please check your inbox.");
      } catch (e) {
        // Handle FirebaseAuth exceptions and other errors
        if (e is FirebaseAuthException) {
          if (e.code == 'invalid-email') {
            showToast(message: "Invalid email address.");
          } else if (e.code == 'user-not-found') {
            showToast(message: "No user found for that email.");
          }
        } else {
          showToast(message: "Something went wrong. Please try again.");
        }
      }
    } else {
      showToast(message: "Please enter your email");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
      return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/health3.png"),
                    fit: BoxFit.cover,
                  )
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.95,
                    //height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      border: Border.all(
                          width: 2.0, color: Colors.green.shade100),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8, top: 24, ),
                      child: Column(
                        children: [
                          Image.asset(
                              "assets/images/healthLogo.png", width: MediaQuery
                              .sizeOf(context)
                              .width * 0.2),
                          SizedBox(height: MediaQuery
                              .sizeOf(context)
                              .height * 0.02),
                          Text("Forgot Password?", style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w900),),
                          SizedBox(height: MediaQuery
                              .sizeOf(context)
                              .height * 0.03),
                          Text("No worries 😊", style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),),
                          SizedBox(height: MediaQuery
                              .sizeOf(context)
                              .height * 0.02),
                          Text(
                            "Enter the email associated with your account and we will send you a link to reset your password",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,),
                          SizedBox(height: MediaQuery
                              .sizeOf(context)
                              .height * 0.05),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.black54),
                              hintText: "Enter your email address",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              prefixIcon: Icon(Icons.mail_outline),
                            ),
                            style: TextStyle(
                              //color: Colors.yellow, // Text color
                              fontSize: 16, // Text size
                            ),
                            cursorColor: Colors.blue,
                          ),
                          SizedBox(height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade400,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Check your Mail", style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),

                        ],
                      ),

                    ),
                  ),
                ),
              ),
            ),
          )
      );
    }
        )
    );
  }

  }
