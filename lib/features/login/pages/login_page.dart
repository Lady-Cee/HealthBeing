import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_being_tips/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../global/toast_error.dart';
import '../../../global/toast_success.dart';
import '../../forgotpassword/pages/forgot_pwd_page.dart';
import '../../home/pages/home_page.dart';
import '../../signup/pages/signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _loadPreferences();
  }

  // load user preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }
  // Save user preferences
  // Future<void> _saveUserPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('rememberMe', _rememberMe);
  //   if (_rememberMe) {
  //     prefs.setString('email', _emailController.text);
  //     prefs.setString('password', _passwordController.text);
  //   } else {
  //     prefs.remove('email');
  //     prefs.remove('password');
  //   }
  // }
   //show error/success messages
  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message)));
  // }

//log in method
  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    //validate email and password
    if (email.isEmpty || password.isEmpty) {
      showToast(message: 'Fill in both details');
      return;
    }
      // Call the login method from AuthProvider
  try {
      final rememberMe = _rememberMe;
      final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
      await authProvider.signIn(email, password, rememberMe);
      // Save preferences (This method should exist in your provider)
     // await authProvider.savePreferences(_rememberMe, email, password);
      toastSuccess(message: "Login Successful");

      //Navigate to the home page after successful log in
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } catch (e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'user-not-found') {
        showToast(message:"No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToast(message: "Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        showToast(message: "The email address is not valid.");
      } else {
        showToast(message: "Invalid password or unregistered email");
      }
    } else {
      showToast(message: "An unexpected error occurred: ${e.toString()}");

    }
  }
  }

  @override
  Widget build(BuildContext context) {
    //final authProvider = Provider.of<MyAuthProvider>(context);
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.95,
                        //height: MediaQuery.of(context).size.height * 0.75,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          border: Border.all(
                              width: 2.0, color: Colors.green.shade100),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8, top: 24),
                          child: Column(
                            children: [
                              Image.asset("assets/images/healthLogo.png",
                                  width: MediaQuery
                                      .sizeOf(context)
                                      .width * 0.2),
                              SizedBox(height: MediaQuery
                                  .sizeOf(context)
                                  .height * 0.02),
                              Text("Welcome", style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900),),
                              Text("Enter your email and password to continue",
                                style: TextStyle(fontSize: 14),),
                              SizedBox(height: MediaQuery
                                  .sizeOf(context)
                                  .height * 0.03),
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
                                  .height * 0.03),
                              TextField(
                                controller: _passwordController,
                               // keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  hintText: "Enter your password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscured ? Icons.visibility_off : Icons
                                          .visibility,),
                                    onPressed: () {
                                      setState(() {
                                        _isObscured = !_isObscured;
                                      });
                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  //color: Colors.yellow, // Text color
                                  fontSize: 16, // Text size
                                ),
                                obscureText: _isObscured,
                                cursorColor: Colors.blue,
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _rememberMe,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      }
                                  ),
                                  Text("Remember Me",
                                    style: TextStyle(fontSize: 16,),),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacement(
                                            context,
                                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                        );
                                      },
                                      child: Text("Forgot Password?",
                                        style: TextStyle(fontSize: 16,
                                            color: Colors.green.shade800),))
                                ],
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.04),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade400,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text("Log In", style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                ),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account?",
                                      style: TextStyle(fontSize: 16,)),
                                  SizedBox(width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.04),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUpPage()),
                                        );
                                      },
                                      child: Text("Sign Up", style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green.shade800),),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}




