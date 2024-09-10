import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/health3.png"),
                fit: BoxFit.cover,
              )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  border: Border.all(width: 2.0, color:Colors.green.shade100),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8, top: 24),
                  child: Column(
                    children: [
                      Image.asset("assets/images/healthLogo.png", width: MediaQuery.sizeOf(context).width * 0.2),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                      Text("Welcome", style: TextStyle(fontStyle: FontStyle.italic,fontSize: 32, fontWeight: FontWeight.w900),),
                      Text("Enter your email and password to continue", style: TextStyle(fontSize: 14),),
                      SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.black54),
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black54),
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility,),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        children: [
                          Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? value){
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              }
                          ),
                          Text("Remember Me", style: TextStyle(fontSize: 16,),),
                          Spacer(),
                          GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                );
                              },
                              child: Text("Forgot Password?", style: TextStyle(fontSize: 16,color: Colors.green.shade800),))
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Log In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?", style: TextStyle(fontSize: 16,)),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text("Sign Up", style: TextStyle(fontSize: 16,color: Colors.green.shade800),),
                          ),
                        ],
                      )
                    ],
                  ),

                ),
              ),
            ),
          ),
        )

    );
  }
}

