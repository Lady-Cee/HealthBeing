import 'package:flutter/material.dart';
import 'package:health_being_tips/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../global/toast_error.dart';
import '../../../global/toast_success.dart';
import '../../login/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  //Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  //signup method
  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    //show error/success messages
    // void _showMessage(String message) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    // }
    //validate if fields are empty
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showToast(message: "Please fill in all details");
      return;
    }
    // validate email
    if (!_isValidEmail(email)) {
      showToast(message: "Please enter a valid email address");
      return;
    }
    //check if passwords match
    if (password != confirmPassword) {
      showToast(message: "Passwords do not match");
      return;
    }
    // Check if password meets the minimum requirements (e.g., length)
    if (password.length < 8) {
      showToast(message: "Password must be at least 8 characters long");
      return;
    }
    // Call the signUp method from AuthProvider
    try {
      final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
      await authProvider.signUp(email, password);
      toastSuccess(message: "Sign up successful");
      // Navigate to login page after successful sign-up
      Navigator.pushReplacement(
          context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      showToast(message: "Sign up failed: $e");
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
                        // height: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .height * 0.85,
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
                              Text("Sign Up", style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900),),
                              Text("Create an account to continue",
                                style: TextStyle(fontSize: 14),),
                              SizedBox(height: MediaQuery
                                  .sizeOf(context)
                                  .height * 0.03),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Full Name",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  hintText: "Enter your full name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14),
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
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.03),
                              TextField(
                                keyboardType: TextInputType.phone,
                               // controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  hintText: "Enter your phone number",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  prefixIcon: Icon(Icons.phone),
                                  // errorText: _isValidEmail(_emailController.text) ? null : "Invalid email format",
                                ),
                                style: TextStyle(
                                  //color: Colors.yellow, // Text color
                                  fontSize: 16, // Text size
                                ),
                                cursorColor: Colors.blue,
                                // onChanged: (value){
                                //   setState(() {});
                                // }
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
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
                                 // errorText: _isValidEmail(_emailController.text) ? null : "Invalid email format",
                                ),
                                style: TextStyle(
                                  //color: Colors.yellow, // Text color
                                  fontSize: 16, // Text size
                                ),
                                cursorColor: Colors.blue,
                                // onChanged: (value){
                                //   setState(() {});
                                // }
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.03),
                              TextField(
                                controller: _passwordController,
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
                                      _isPasswordObscured ? Icons.visibility_off : Icons
                                          .visibility,),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured = !_isPasswordObscured;
                                      });
                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  //color: Colors.yellow, // Text color
                                  fontSize: 16, // Text size
                                ),
                                obscureText: _isPasswordObscured,
                                cursorColor: Colors.blue,
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.02),
                              TextField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  labelStyle: TextStyle(color: Colors.black54),
                                  hintText: "Confirm your password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordObscured ? Icons.visibility_off : Icons
                                          .visibility,),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                      });
                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  //color: Colors.yellow, // Text color
                                  fontSize: 16, // Text size
                                ),
                                obscureText: _isConfirmPasswordObscured,
                                cursorColor: Colors.blue,
                              ),
                              //SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.04),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade400,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text("Sign Up", style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                ),
                              ),
                              SizedBox(height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.03),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 32.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Already have an account?",
                                        style: TextStyle(fontSize: 16,)),
                                    SizedBox(width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.04),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const LoginPage()),
                                        );
                                      },
                                      child: Text("Log in", style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green.shade800),),
                                    ),
                                  ],
                                ),
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






// import 'package:flutter/material.dart';
//
// import '../../login/pages/login_page.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   bool _isObscured = true;
//   bool _rememberMe = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: constraints.maxHeight,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage("assets/images/health3.png"),
//                       fit: BoxFit.cover,
//                     )
//                 ),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Container(
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width * 0.95,
//                       // height: MediaQuery
//                       //     .of(context)
//                       //     .size
//                       //     .height * 0.85,
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade100,
//                         border: Border.all(
//                             width: 2.0, color: Colors.green.shade100),
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             right: 8.0, left: 8, top: 24),
//                         child: Column(
//                           children: [
//                             Image.asset("assets/images/healthLogo.png",
//                                 width: MediaQuery
//                                     .sizeOf(context)
//                                     .width * 0.2),
//                             SizedBox(height: MediaQuery
//                                 .sizeOf(context)
//                                 .height * 0.02),
//                             Text("Sign Up", style: TextStyle(
//                                 fontStyle: FontStyle.italic,
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.w900),),
//                             Text("Create an account to continue",
//                               style: TextStyle(fontSize: 14),),
//                             SizedBox(height: MediaQuery
//                                 .sizeOf(context)
//                                 .height * 0.03),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: "Full Name",
//                                 labelStyle: TextStyle(color: Colors.black54),
//                                 hintText: "Enter your full name",
//                                 hintStyle: TextStyle(
//                                     color: Colors.grey, fontSize: 14),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 prefixIcon: Icon(Icons.person),
//                               ),
//                               style: TextStyle(
//                                 //color: Colors.yellow, // Text color
//                                 fontSize: 16, // Text size
//                               ),
//                               cursorColor: Colors.blue,
//                             ),
//                             SizedBox(height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 0.03),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: "Email",
//                                 labelStyle: TextStyle(color: Colors.black54),
//                                 hintText: "Enter your email address",
//                                 hintStyle: TextStyle(
//                                     color: Colors.grey, fontSize: 14),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 prefixIcon: Icon(Icons.person),
//                               ),
//                               style: TextStyle(
//                                 //color: Colors.yellow, // Text color
//                                 fontSize: 16, // Text size
//                               ),
//                               cursorColor: Colors.blue,
//                             ),
//                             SizedBox(height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 0.03),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: "Password",
//                                 labelStyle: TextStyle(color: Colors.black54),
//                                 hintText: "Enter your password",
//                                 hintStyle: TextStyle(
//                                     color: Colors.grey, fontSize: 14),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0)
//                                 ),
//                                 prefixIcon: Icon(Icons.lock),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _isObscured ? Icons.visibility_off : Icons
//                                         .visibility,),
//                                   onPressed: () {
//                                     setState(() {
//                                       _isObscured = !_isObscured;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               style: TextStyle(
//                                 //color: Colors.yellow, // Text color
//                                 fontSize: 16, // Text size
//                               ),
//                               obscureText: _isObscured,
//                               cursorColor: Colors.blue,
//                             ),
//                             SizedBox(height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 0.02),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: "Confirm Password",
//                                 labelStyle: TextStyle(color: Colors.black54),
//                                 hintText: "Confirm your password",
//                                 hintStyle: TextStyle(
//                                     color: Colors.grey, fontSize: 14),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12.0)
//                                 ),
//                                 prefixIcon: Icon(Icons.lock),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _isObscured ? Icons.visibility_off : Icons
//                                         .visibility,),
//                                   onPressed: () {
//                                     setState(() {
//                                       _isObscured = !_isObscured;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               style: TextStyle(
//                                 //color: Colors.yellow, // Text color
//                                 fontSize: 16, // Text size
//                               ),
//                               obscureText: _isObscured,
//                               cursorColor: Colors.blue,
//                             ),
//                             //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//
//                             SizedBox(height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 0.04),
//                             Container(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginPage()),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green.shade400,
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 child: Text("Sign Up", style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold),),
//                               ),
//                             ),
//                             SizedBox(height: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .height * 0.03),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 32.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text("Already have an account?",
//                                       style: TextStyle(fontSize: 16,)),
//                                   SizedBox(width: MediaQuery
//                                       .of(context)
//                                       .size
//                                       .width * 0.04),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => LoginPage()),
//                                       );
//                                     },
//                                     child: Text("Log in", style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.green.shade800),),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//         ),
//       );
//   }
// }
//
