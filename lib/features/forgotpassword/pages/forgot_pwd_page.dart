import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => HomePage()),
                                  // );
                                },
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
