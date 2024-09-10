import 'package:flutter/material.dart';

import '../../login/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              height: MediaQuery.of(context).size.height * 0.85,
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
                    Text("Sign Up", style: TextStyle(fontStyle: FontStyle.italic,fontSize: 32, fontWeight: FontWeight.w900),),
                    Text("Create an account to continue", style: TextStyle(fontSize: 14),),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: Colors.black54),
                        hintText: "Enter your full name",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: Icon(Icons.person),
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
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black54),
                        hintText: "Enter your email address",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: Icon(Icons.person),
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
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: TextStyle(color: Colors.black54),
                        hintText: "Confirm your password",
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
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade400,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(fontSize: 16,)),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text("Log in", style: TextStyle(fontSize: 16,color: Colors.green.shade800),),
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
    );
  }
}

